import 'dart:convert';
import 'dart:io';
import 'package:rhttp/rhttp.dart' as rhttp;
import 'package:flutter_js/flutter_js.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/cookie_store.dart';
import '../../core/services/doh/doh_resolver.dart';
import '../../core/services/webview_service.dart';
import '../../presentation/webview_screen/cf_challenge_screen.dart';
import '../dart/bridge/http.dart' show isBackgroundIsolate;

/// Normalised HTTP result the JS envelope is built from - decoupled from any
/// particular transport (was Dio's `Response<String>`, now rhttp).
typedef _Resp = ({int statusCode, String body, Map<String, String> headers});

/// Injects HTTP client functions into the JS runtime.
class JsHttpClient {
  final JavascriptRuntime _runtime;

  JsHttpClient(this._runtime);

  /// Test-only seam. When non-null, every bridged fetch is served by this
  /// backend instead of the real transport, and must return the same JSON
  /// envelope (`{statusCode, body, headers}`). The LNReader harness points this
  /// at a real headless browser (real UA + TLS + Cloudflare solving) to measure
  /// how many sources work once CF/TLS-fingerprint blocking is handled. Always
  /// null in the shipped app, so production behaviour is unchanged.
  static Future<String> Function(
    String method,
    String url,
    Map<String, String> headers,
    String? body,
  )? testFetchBackend;

  // rhttp (Rust/reqwest) gives a Chrome-like TLS fingerprint, so the JS lane
  // gets through the hosts that fingerprint the ClientHello and drop non-browser
  // clients at the handshake - exactly where the old Dio client died. Mirrors
  // the Dart lane's client (eval/dart/bridge/http.dart): TLS verification stays
  // ON (we attach the user's cf_clearance cookie, so an accepted forged cert
  // would hand a MITM the cleared session), DoH is applied when enabled, and the
  // client is rebuilt when the DoH toggle/provider changes.
  static rhttp.RhttpClient? _client;
  static int _clientGen = -1;

  static Future<rhttp.RhttpClient> _getClient() async {
    final gen = DohResolver.instance.clientGeneration;
    if (_client != null && _clientGen == gen) return _client!;
    final old = _client;
    _client = await rhttp.RhttpClient.create(
      settings: rhttp.ClientSettings(
        throwOnStatusCode: false,
        dnsSettings: dohDnsSettingsOrNull(),
      ),
    );
    _clientGen = gen;
    old?.dispose();
    return _client!;
  }

  static final CookieStore _cookies = CookieStore();

  // Per-host Cloudflare single-flight gate: while one request solves a host's
  // challenge, every other request to the same host awaits the SAME solve
  // instead of each launching its own interactive WebView. Mirrors the Dart
  // lane's _cfLocks (dart/bridge/http.dart).
  static final Map<String, Future<bool>> _cfLocks = {};

  /// True if the response looks like a Cloudflare challenge (needs solving).
  static bool _isChallenge(int status, String body) {
    if (status == 403 || status == 503) return true;
    if (body.isEmpty || body.length > 60000) return false;
    final b = body.toLowerCase();
    return b.contains('just a moment') ||
        b.contains('challenge-platform') ||
        b.contains('cf-browser-verification') ||
        b.contains('_cf_chl_opt') ||
        b.contains('enable javascript and cookies to continue');
  }

  /// Merge stored Cloudflare cookies + the resolved User-Agent into [headers].
  static Future<Map<String, String>> _buildHeaders(
      String url, Map<String, String> headers) async {
    final h = Map<String, String>.from(headers);
    // Honours per-source desktop mode; otherwise the stored/platform UA.
    h['User-Agent'] = await _cookies.userAgentFor(url);
    final cookie = await _cookies.getCookieHeader(url);
    if (cookie != null && cookie.isNotEmpty) {
      h['Cookie'] = h['Cookie'] != null && h['Cookie']!.isNotEmpty
          ? '${h['Cookie']}; $cookie'
          : cookie;
    }
    return h;
  }

  /// One transport request via rhttp, with a Dart-`HttpClient` fallback for the
  /// rhttp DNS-resolver failures seen on some (Windows) configurations - same
  /// fallback the Dart lane uses.
  static Future<_Resp> _send(
      String method, String url, Map<String, String> headers,
      [String? body]) async {
    final merged = await _buildHeaders(url, headers);
    try {
      final client = await _getClient();
      final r = await client.requestText(
        method: method == 'POST' ? rhttp.HttpMethod.post : rhttp.HttpMethod.get,
        url: url,
        headers: rhttp.HttpHeaders.rawMap(merged),
        body: (method == 'POST' && body != null) ? rhttp.HttpBody.text(body) : null,
      );
      return (
        statusCode: r.statusCode,
        body: r.body,
        headers: r.headerMap,
      );
    } catch (e) {
      final s = e.toString();
      if (s.contains('ConnectError') || s.contains('dns error')) {
        logger.warning('JS lane: rhttp failed, falling back to HttpClient for $url: $e',
            category: LogCategory.network);
        return _dartSend(method, url, merged, body);
      }
      rethrow;
    }
  }

  /// Fallback transport using Dart's built-in HttpClient (system DNS). No
  /// bad-cert override - this request carries the user's session cookies, so a
  /// bad cert must fail rather than be accepted.
  static Future<_Resp> _dartSend(
      String method, String url, Map<String, String> headers,
      [String? body]) async {
    final httpClient = HttpClient();
    try {
      final req = method == 'POST'
          ? await httpClient.postUrl(Uri.parse(url))
          : await httpClient.getUrl(Uri.parse(url));
      headers.forEach((k, v) => req.headers.set(k, v));
      if (method == 'POST' && body != null) req.write(body);
      final resp = await req.close();
      final b = await resp.transform(utf8.decoder).join();
      final hmap = <String, String>{};
      resp.headers.forEach((k, v) => hmap[k] = v.join(', '));
      return (statusCode: resp.statusCode, body: b, headers: hmap);
    } finally {
      httpClient.close();
    }
  }

  /// A Cloudflare-aware fetch: attaches cookies, and on a challenge, solves it
  /// (headless, else interactive WebView) and retries - persisting cookies so
  /// the challenge isn't re-shown next time.
  static Future<String> _cfAwareFetch(
      String method, String url, Map<String, String> headers,
      [String? body]) async {
    final backend = testFetchBackend;
    if (backend != null) {
      return backend(method, url, headers, body);
    }

    String encode(_Resp r) => jsonEncode({
          'statusCode': r.statusCode,
          'body': r.body,
          'headers': r.headers,
        });

    _Resp resp;
    try {
      resp = await _send(method, url, headers, body);
    } catch (e) {
      // A TLS/handshake/socket failure. Cloudflare (and some CDNs) fingerprint
      // the TLS ClientHello and drop non-browser clients at the handshake. rhttp
      // presents a Chrome-like fingerprint so this is rare now, but if it still
      // fails, retry the GET through the real browser (WebView): it presents a
      // genuine UA + browser TLS and carries any cf_clearance. (A background
      // isolate can't drive a WebView - see below.)
      if (!isBackgroundIsolate && method == 'GET') {
        try {
          final html = await WebViewService().fetchHtml(url);
          if (html != null && html.isNotEmpty) {
            return jsonEncode(
                {'statusCode': 200, 'body': html, 'headers': const {}});
          }
        } catch (e2) {
          logger.warning('JS lane: WebView TLS fallback failed for $url: $e2',
              category: LogCategory.network);
        }
      }
      logger.warning('JS lane: request failed for $url: $e',
          category: LogCategory.network);
      return jsonEncode({'statusCode': 0, 'body': '', 'error': e.toString()});
    }

    if (!_isChallenge(resp.statusCode, resp.body)) {
      return encode(resp);
    }

    // Cloudflare challenge - solve headless first, then retry.
    //
    // A background isolate can't drive a WebView: `rootNavigatorKey` is a
    // different, null instance there, so the interactive fallback always
    // returns false and the headless attempt just burns its 30s timeout before
    // failing anyway. The Dart bridge guards this the same way - bail out and
    // let the caller retry on the main isolate.
    if (isBackgroundIsolate) {
      return encode(resp);
    }

    // Per-host single-flight. A global-search / migrate fan-out hits the same
    // CF-gated host from several JS sources at once; without this each one pops
    // its own interactive WebView (N stacked solve dialogs). The first request
    // owns the solve; the rest await it and then retry with the fresh cookies.
    final host = Uri.tryParse(url)?.host ?? url;
    bool resolved;
    final inflight = _cfLocks[host];
    if (inflight != null) {
      try {
        resolved = await inflight;
      } catch (_) {
        resolved = false;
      }
    } else {
      Future<bool> solve() async {
        // Headless first; if that can't clear it (interactive Turnstile /
        // captcha), ask the user to complete it in a visible WebView.
        var ok = await WebViewService().resolveCloudflare(url);
        if (!ok) ok = await solveCloudflareInteractively(url);
        if (ok) _cookies.markResolved(url);
        return ok;
      }

      final future = solve();
      _cfLocks[host] = future;
      try {
        resolved = await future;
      } catch (_) {
        resolved = false;
      } finally {
        _cfLocks.remove(host);
      }
    }

    if (resolved) {
      try {
        final retry = await _send(method, url, headers, body);
        if (!_isChallenge(retry.statusCode, retry.body)) {
          return encode(retry);
        }
      } catch (e) {
        logger.warning('JS lane: CF retry failed for $url: $e',
            category: LogCategory.network);
      }
    }
    // GET fallback: let the WebView return the rendered HTML directly.
    if (method == 'GET') {
      final html = await WebViewService().fetchHtml(url);
      if (html != null && html.isNotEmpty) {
        return jsonEncode({'statusCode': 200, 'body': html, 'headers': {}});
      }
    }
    return encode(resp);
  }

  void init() {
    // Register the HTTP bridge channel
    _runtime.onMessage('HttpGet', (dynamic args) async {
      final url = args['url'] as String;
      final headers = (args['headers'] as Map?)?.cast<String, String>() ?? {};
      return _cfAwareFetch('GET', url, headers);
    });

    _runtime.onMessage('HttpPost', (dynamic args) async {
      final url = args['url'] as String;
      final headers = (args['headers'] as Map?)?.cast<String, String>() ?? {};
      final body = args['body'] as String?;
      return _cfAwareFetch('POST', url, headers, body);
    });

    // Inject JS Client class
    _runtime.evaluate('''
class Client {
  constructor() {}

  async get(url, headers) {
    const result = await sendMessage('HttpGet', JSON.stringify({
      url: url,
      headers: headers || {}
    }));
    return JSON.parse(result);
  }

  async post(url, headers, body) {
    const result = await sendMessage('HttpPost', JSON.stringify({
      url: url,
      headers: headers || {},
      body: body || ''
    }));
    return JSON.parse(result);
  }
}
''');
  }
}
