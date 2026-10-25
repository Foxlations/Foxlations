import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../presentation/webview_screen/cf_challenge_screen.dart';
import 'app_logger.dart';
import 'app_navigator.dart';
import 'cookie_store.dart';
import 'webview_service.dart';

/// A loopback HTTP endpoint that speaks the FlareSolverr `/v1` protocol, backed
/// by Foxlations' existing [WebViewService] (flutter_inappwebview → WKWebView on
/// iOS, WebView on Android).
///
/// This is the bridge that lets the **Kotlin/JVM** extension engine clear
/// Cloudflare. Suwayomi's built-in `CloudflareInterceptor` already knows how to
/// call a FlareSolverr server (`POST /v1` → cf_clearance cookies + User-Agent →
/// inject into its cookie jar → retry); our `SourceRunner.enableCloudflareSolver`
/// turns it on when `-Dfoxlations.flareSolverrUrl` points here. So instead of
/// bundling FlareSolverr (impossible on iOS) we let the JVM drive the SAME
/// device WebView the Dart sources already use - one solver, one cookie source.
///
/// The harness proved this exact wiring with a Playwright-backed `/v1` server;
/// on-device the browser backend is just WKWebView instead of Chromium.
class CfFlareSolverrServer {
  CfFlareSolverrServer._();
  static final CfFlareSolverrServer instance = CfFlareSolverrServer._();

  /// Fixed loopback port the JVM boot options point at
  /// (`-Dfoxlations.flareSolverrUrl=http://127.0.0.1:$port`).
  static const int port = 52700;

  HttpServer? _server;

  /// Serialises start/ensure so a resume-triggered rebind can't race startup.
  Future<void>? _starting;

  /// Last time a Cloudflare toast was shown per host, to debounce burst solves.
  final Map<String, DateTime> _lastCfToast = {};

  /// The URL the JVM should be told to use, once [start] has bound the port.
  String get url => 'http://127.0.0.1:$port';

  bool get isRunning => _server != null;

  bool get _supported => Platform.isIOS || Platform.isAndroid || Platform.isMacOS;

  /// Bind the loopback server. Safe to call once at startup. A bind failure is
  /// non-fatal (CF for Kotlin sources stays unavailable), but - unlike before - 
  /// it is surfaced to More > Debug logs instead of being silently swallowed,
  /// so "ConnectException 127.0.0.1:52700" has a matching host-side entry.
  Future<void> start() async {
    if (_server != null) return;
    if (!_supported) {
      // Desktop uses the harness/Playwright or an external proxy; the in-app
      // webview solver isn't wired for those here.
      return;
    }
    // Collapse concurrent callers onto one in-flight bind.
    final pending = _starting;
    if (pending != null) return pending;
    final run = _bind();
    _starting = run;
    try {
      await run;
    } finally {
      if (identical(_starting, run)) _starting = null;
    }
  }

  Future<void> _bind() async {
    try {
      final server =
          await HttpServer.bind(InternetAddress.loopbackIPv4, port, shared: true);
      _server = server;
      unawaited(_serve(server));
      AppLogger.instance.info(
        'Cloudflare solver listening on $url',
        category: LogCategory.network,
      );
    } catch (e) {
      _server = null;
      AppLogger.instance.error(
        'Cloudflare solver failed to bind $url',
        category: LogCategory.network,
        detail:
            '$e\nKotlin/JVM sources that hit Cloudflare will fail until this '
            'binds (ConnectException 127.0.0.1:$port). Usually transient - the '
            'app retries it on resume.',
      );
    }
  }

  /// Re-bind if the loopback socket is gone. iOS tears down loopback listeners
  /// across a background→foreground cycle, which left the JVM hitting a dead
  /// port (`_server` was still non-null, so the old `start()` early-returned and
  /// never rebound). Called on app resume. Dart-only - it touches no JVM op, so
  /// it is safe inside the background-transition window that the native
  /// signal-handler restore guards against.
  Future<void> ensureRunning() async {
    if (!_supported) return;
    if (_server != null && await _isAlive()) return;
    await stop();
    await start();
  }

  /// Quick self-probe: is the listener actually accepting connections?
  Future<bool> _isAlive() async {
    try {
      final client = HttpClient()
        ..connectionTimeout = const Duration(milliseconds: 600);
      final req = await client
          .get(InternetAddress.loopbackIPv4.address, port, '/health')
          .timeout(const Duration(milliseconds: 600));
      final resp = await req.close().timeout(const Duration(milliseconds: 600));
      await resp.drain<void>();
      client.close(force: true);
      return resp.statusCode == HttpStatus.ok;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    final s = _server;
    _server = null;
    if (s != null) {
      try {
        await s.close(force: true);
      } catch (_) {}
    }
  }

  Future<void> _serve(HttpServer server) async {
    await for (final req in server) {
      // Never let one bad request tear down the listener.
      unawaited(_handle(req).catchError((_) {}));
    }
  }

  Future<void> _handle(HttpRequest req) async {
    if (req.method == 'GET' && req.uri.path == '/health') {
      req.response
        ..statusCode = HttpStatus.ok
        ..write('ok');
      await req.response.close();
      return;
    }
    if (req.method != 'POST' || !req.uri.path.startsWith('/v1')) {
      req.response.statusCode = HttpStatus.notFound;
      await req.response.close();
      return;
    }

    Map<String, dynamic> out;
    try {
      final body = await utf8.decoder.bind(req).join();
      final data = jsonDecode(body.isEmpty ? '{}' : body) as Map<String, dynamic>;
      final cmd = (data['cmd'] as String?) ?? 'request.get';
      if (cmd.startsWith('sessions.')) {
        // FlareSolverr session commands - we don't keep sessions; ack them.
        out = {'status': 'ok', 'message': '', 'session': data['session'] ?? 'fox', 'sessions': <String>[]};
      } else {
        out = await _solve((data['url'] as String?) ?? '');
      }
    } catch (e) {
      out = {'status': 'error', 'message': '$e', 'solution': null};
    }

    final json = jsonEncode(out);
    req.response
      ..headers.contentType = ContentType.json
      ..statusCode = HttpStatus.ok
      ..write(json);
    await req.response.close();
  }

  /// Solve Cloudflare for [targetUrl] via the device WebView, then package the
  /// harvested cookies + UA into a FlareSolverr `solution` the JVM understands.
  Future<Map<String, dynamic>> _solve(String targetUrl) async {
    if (targetUrl.isEmpty) {
      return {'status': 'error', 'message': 'missing url', 'solution': null};
    }
    // Let the user know a Cloudflare check is being handled. A source can fire many
    // solve requests in a row (per image/page), so debounce the toasts per host.
    final host = Uri.tryParse(targetUrl)?.host ?? '';
    final now = DateTime.now();
    final notify = host.isEmpty ||
        _lastCfToast[host] == null ||
        now.difference(_lastCfToast[host]!) > const Duration(seconds: 8);
    if (notify) {
      _lastCfToast[host] = now;
      showGlobalToast(
          'Bypassing Cloudflare${host.isEmpty ? '' : ' on $host'}…');
    }
    // Headless auto-solve first (handles the common JS "Just a moment" challenge);
    // fall back to the interactive screen for Turnstile-style checks.
    bool solved = await WebViewService().resolveCloudflare(targetUrl);
    if (!solved) {
      try {
        solved = await solveCloudflareInteractively(targetUrl);
      } catch (e) {
        AppLogger.instance.warning(
          'Cloudflare interactive solve threw'
          '${host.isEmpty ? '' : ' on $host'}',
          category: LogCategory.network,
          detail: e.toString(),
        );
      }
    }
    if (notify) {
      showGlobalToast(
          solved ? 'Cloudflare bypass successful' : 'Cloudflare bypass failed',
          status: solved);
    }

    final store = CookieStore();
    final cookieHeader = await store.getCookieHeader(targetUrl) ?? '';
    final ua = await store.getUserAgent();
    // `host` is already derived above for the toast.

    final cookies = <Map<String, dynamic>>[];
    for (final pair in cookieHeader.split(';')) {
      final p = pair.trim();
      if (p.isEmpty) continue;
      final i = p.indexOf('=');
      if (i <= 0) continue;
      cookies.add({
        'name': p.substring(0, i),
        'value': p.substring(i + 1),
        'domain': host,
        'path': '/',
      });
    }

    return {
      'status': 'ok',
      'message': solved ? 'Challenge solved!' : 'Challenge not detected!',
      'startTimestamp': 0,
      'endTimestamp': 0,
      'version': 'foxlations-webview-1.0',
      'solution': {
        'url': targetUrl,
        'status': 200,
        'headers': <String, dynamic>{},
        'response': '',
        'cookies': cookies,
        'userAgent': ua,
      },
    };
  }
}
