import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_js/flutter_js.dart';

import '../../core/services/app_logger.dart';
import '../interface.dart';
import '../model/filter.dart';
import '../model/m_chapter.dart';
import '../model/m_manga.dart';
import '../model/m_pages.dart';
import '../model/m_source.dart';
import '../model/m_video.dart';
import '../model/page_url.dart';
import '../model/source_preference.dart';
import 'http.dart';
import 'js_promise_decode.dart';

/// Runs LNReader novel plugins (compiled CommonJS JS) in the flutter_js runtime.
///
/// LNReader plugins are `tsc`-compiled modules that `require('cheerio')`,
/// `require('htmlparser2')`, `require('dayjs')` and a handful of `@libs/*`, then
/// `exports.default` a ready plugin instance implementing LNReader's Plugin API
/// (popularNovels / searchNovels / parseNovel / parseChapter). This service
/// supplies a `require()` shim + WHATWG `fetch`/`Response` (over the existing
/// HTTP bridge) + the cheerio/htmlparser2/dayjs bundle (assets/js), loads the
/// plugin, and maps its methods onto the app's [ExtensionService] interface.

/// A source-side failure from an LNReader plugin call. `toString()` is the raw
/// message (e.g. "Could not reach site (403)…") so callers can match on it and
/// the catalog screen shows it verbatim.
class LnrException implements Exception {
  final String message;
  LnrException(this.message);
  @override
  String toString() => message;
}

class LnrExtensionService implements ExtensionService {
  final MSource mSource;
  final String sourceCode;
  final String baseUrl;

  late final JavascriptRuntime runtime;
  bool _initialized = false;
  static String? _libsBundle;

  LnrExtensionService({
    required this.mSource,
    required this.sourceCode,
    required this.baseUrl,
  });

  Future<void> _ensureInit() async {
    if (_initialized) return;
    // xhr:false - do NOT enable flutter_js's built-in fetch/XHR. That extension
    // talks to the network with package:http directly, bypassing our
    // Cloudflare-aware bridge (no CF solve, no cookies/UA/DoH) AND throwing
    // UNCAUGHT ClientExceptions that crash the app when a request fails. It also
    // async-loads a fetch.js polyfill that could race-overwrite our own fetch.
    // Our preamble is self-contained (fetch/Headers/Response/URL/XHR), so we
    // need none of it - every request goes through the bridge below.
    runtime = getJavascriptRuntime(xhr: false);
    // Reuse the Cloudflare-aware HTTP bridge: registers onMessage HttpGet/HttpPost.
    JsHttpClient(runtime).init();
    _libsBundle ??= await rootBundle.loadString('assets/js/lnreader_libs.js');
    runtime.evaluate(_libsBundle!); // defines __LNR_cheerio / __LNR_htmlparser2 / __LNR_dayjs
    runtime.evaluate(_preamble); // fetch/Response/require/@libs
    // Load the plugin as a CommonJS module and keep its exported instance.
    final loadRes = runtime.evaluate('''
globalThis.__lnrLoadError = null;
globalThis.__lnrPlugin = (function () {
  var module = { exports: {} };
  var exports = module.exports;
  try {
    (function (require, module, exports) {
      ${_wrapSource(sourceCode)}
    })(globalThis.__lnr_require, module, exports);
  } catch (e) {
    globalThis.__lnrLoadError = String((e && e.stack) || e);
    return null;
  }
  return module.exports && module.exports.default ? module.exports.default : null;
})();
globalThis.__lnrSite = (globalThis.__lnrPlugin && globalThis.__lnrPlugin.site) || ${jsonEncode(baseUrl)};
JSON.stringify({ loaded: !!globalThis.__lnrPlugin, error: globalThis.__lnrLoadError });
''');
    try {
      final info = jsonDecode(loadRes.stringResult) as Map<String, dynamic>;
      if (info['loaded'] != true) {
        logger.error('LNReader plugin failed to load: ${info['error']}',
            category: LogCategory.extension);
      }
    } catch (e) {
      logger.warning('LNReader plugin load status unreadable: $e',
          category: LogCategory.extension);
    }
    _initialized = true;
  }

  /// Source is wrapped verbatim; it already ends in `exports.default = …`.
  static String _wrapSource(String code) => code;

  /// Decode the `{ok, data|error}` envelope. Some flutter_js engines (notably
  /// iOS's JavaScriptCore) return a resolved promise's value ALREADY JSON-encoded,
  /// so the envelope arrives double-encoded - decode once, and if that yields a
  /// String, decode again. Android's engine single-encodes, so the guard is a
  /// no-op there. Without this, every LNReader call throws "String is not a
  /// subtype of Map" on iOS and the whole lane is dead.
  ///
  /// The double-decode rule lives in [decodeJsPromiseResult], shared with the
  /// manga lane; requesting a Map here makes a bare String (the once-encoded
  /// envelope) re-decode exactly as before.
  static Map<String, dynamic> _decodeEnvelope(String s) =>
      decodeJsPromiseResult<Map<String, dynamic>>(s);

  /// Run an async plugin call and return its JSON. Args are JSON-encoded so a
  /// source-controlled path/query can't break out of the expression.
  ///
  /// On a source error (e.g. a Cloudflare 403) this THROWS, mirroring the manga
  /// lane. Swallowing it and returning an empty list made a blocked source look
  /// merely empty ("No light novels found") with no way to solve the challenge;
  /// propagating lets the catalog screen show the real error + the "Open in
  /// WebView" solve button.
  Future<dynamic> _call(String method, List<dynamic> args) async {
    await _ensureInit();
    final argsJson = jsonEncode(args);
    final expr =
        '__lnrRun(function(){ return __lnrPlugin.$method.apply(__lnrPlugin, $argsJson); })';
    return _runEnvelope(expr, method);
  }

  /// Run an arbitrary JS body inside __lnrRun (for calls whose args must be built
  /// in JS, like popularNovels' resolved filter values).
  Future<dynamic> _callExpr(String body) async {
    await _ensureInit();
    return _runEnvelope('__lnrRun(function(){ $body })', 'call');
  }

  Future<dynamic> _runEnvelope(String expr, String label) async {
    Map<String, dynamic> out;
    try {
      final jsResult = await runtime.evaluateAsync(expr);
      final promised = await runtime.handlePromise(jsResult);
      out = _decodeEnvelope(promised.stringResult);
    } catch (e) {
      logger.error('LNReader $label threw: $e', category: LogCategory.extension);
      throw LnrException('$label failed: $e');
    }
    if (out['ok'] == true) return out['data'];
    final err = (out['error'] ?? 'unknown error').toString();
    logger.error('LNReader $label failed: $err',
        category: LogCategory.extension);
    throw LnrException(err);
  }

  String get _popularBody =>
      'var f=(__lnrPlugin.filters)||{};var o={};for(var k in f){o[k]={value:f[k]&&f[k].value,type:f[k]&&f[k].type};}';

  MManga _novelItemToManga(Map m) => MManga(
        name: m['name']?.toString(),
        link: m['path']?.toString(),
        imageUrl: m['cover']?.toString(),
      );

  MPages _mapNovelList(dynamic data, int page) {
    final list = (data is List ? data : const [])
        .whereType<Map>()
        .map(_novelItemToManga)
        .toList();
    // LNReader has no hasNextPage signal; assume more while a full-ish page comes back.
    return MPages(list: list, hasNextPage: list.isNotEmpty);
  }

  @override
  Future<MPages> getPopular(int page) async {
    final data = await _callExpr(
        '$_popularBody return __lnrPlugin.popularNovels($page, {showLatestNovels:false, filters:o});');
    return _mapNovelList(data, page);
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    final data = await _callExpr(
        '$_popularBody return __lnrPlugin.popularNovels($page, {showLatestNovels:true, filters:o});');
    return _mapNovelList(data, page);
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    final data = await _call('searchNovels', [query, page]);
    return _mapNovelList(data, page);
  }

  @override
  Future<MManga> getDetail(String url, {bool fullChapters = true}) async {
    final data = await _call('parseNovel', [url]);
    if (data is! Map) return MManga(link: url);
    int? statusInt() {
      final s = (data['status'] ?? '').toString().toLowerCase();
      if (s.contains('ongoing')) return 0;
      if (s.contains('completed') || s.contains('publishing finished')) return 1;
      if (s.contains('hiatus')) return 2;
      if (s.contains('cancel')) return 3;
      return null;
    }

    final genres = (data['genres'] ?? '')
        .toString()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    MChapter toChapter(Map c) => MChapter(
          name: c['name']?.toString(),
          url: c['path']?.toString(),
          dateUpload: c['releaseTime']?.toString(),
          scanlator: c['scanlator'] is List
              ? (c['scanlator'] as List).join(', ')
              : c['scanlator']?.toString(),
          // LNReader plugins supply a monotonic `chapterNumber` (reading-order
          // position). Keep it - the readers order next/prev by it instead of
          // guessing from the name, which fixes sources whose chapter names/urls
          // carry no usable number.
          chapterNumber: (c['chapterNumber'] as num?)?.toDouble(),
        );
    final chapters = <MChapter>[
      for (final c in (data['chapters'] is List
              ? data['chapters'] as List
              : const [])
          .whereType<Map>())
        toChapter(c),
    ];
    // parseNovel returns the first page of chapters (sometimes ALL of them,
    // depending on the plugin's mode) plus a `totalPages` hint; the rest come
    // from parsePage(novelPath, page). Two robustness guards, both from real
    // Novel Phoenix (novelfire) failures:
    //   1. parsePage THROWS on the plugin side for a 404 / rate-limit. Without a
    //      try/catch a late failure aborted getDetail and lost the WHOLE list,
    //      so a title would intermittently fail or come back short.
    //   2. `totalPages` is UNDER-reported when the site's chapter-count text has
    //      a thousands separator: novelfire computes ceil(parseInt("2,196")/100)
    //      and parseInt stops at the comma -> 2 -> totalPages 1 -> only the first
    //      100 chapters (exactly the "sometimes only 100" report, which kicks in
    //      once a novel crosses 1,000 chapters). So we do NOT treat totalPages as
    //      the end: we keep paging while pages still add NEW chapters, probing
    //      past totalPages whenever the gathered count lands exactly on a page
    //      boundary (the signature of that truncation). Single-request "all
    //      chapters" modes return a non-boundary count and are left untouched, so
    //      they aren't re-fetched needlessly.
    final totalPages =
        ((data['totalPages'] as num?)?.toInt() ?? 1).clamp(1, 1000);
    final seen = <String>{
      for (final ch in chapters)
        if (ch.url != null) ch.url!
    };
    // Fetch one more page; append its NEW (deduped) chapters; return how many.
    Future<int> appendPage(int page) async {
      final pageData = await _call('parsePage', [url, '$page']);
      final list = (pageData is Map && pageData['chapters'] is List)
          ? pageData['chapters'] as List
          : const [];
      var added = 0;
      for (final c in list.whereType<Map>()) {
        final ch = toChapter(c);
        if (ch.url != null && seen.add(ch.url!)) {
          chapters.add(ch);
          added++;
        }
      }
      return added;
    }

    if (!fullChapters) {
      // Lightweight update check: the newest chapters sit on the LAST page of an
      // ascending-paginated source, so fetch just that one.
      if (totalPages > 1) {
        try {
          await appendPage(totalPages);
        } catch (e) {
          logger.warning('LNReader parsePage $totalPages failed: $e',
              category: LogCategory.extension);
        }
      }
    } else {
      const pageSize = 100;
      const hardCap = 1000;
      var page = chapters.isEmpty ? 1 : 2;
      while (page <= hardCap &&
          (chapters.isEmpty ||
              page <= totalPages ||
              chapters.length % pageSize == 0)) {
        final int added;
        try {
          added = await appendPage(page);
        } catch (e) {
          logger.warning(
              'LNReader parsePage $page failed; keeping ${chapters.length} '
              'chapters: $e',
              category: LogCategory.extension);
          break;
        }
        if (added == 0) break;
        page++;
      }
    }
    final novelPath = (data['path'] ?? url).toString();
    return MManga(
      name: data['name']?.toString(),
      link: novelPath,
      webUrl: await _resolveWebUrl(novelPath),
      imageUrl: data['cover']?.toString(),
      description: data['summary']?.toString(),
      author: data['author']?.toString(),
      artist: data['artist']?.toString(),
      status: switch (statusInt()) {
        0 => MangaStatus.ongoing,
        1 => MangaStatus.completed,
        2 => MangaStatus.onHiatus,
        3 => MangaStatus.canceled,
        _ => MangaStatus.unknown,
      },
      genre: genres,
      chapters: chapters,
    );
  }

  /// Browsable page URL for a novel [path]. LNReader plugins expose an optional
  /// `resolveUrl(path, isNovel)` that maps an internal path to the public web
  /// page (some sites fetch details from a different path than the readable one,
  /// so `site + path` 404s); without it the convention is `site + path`. The
  /// call is synchronous JS - string ops, no regex, to keep escaping simple.
  Future<String?> _resolveWebUrl(String path) async {
    await _ensureInit();
    final expr = '''(function(){
      try {
        var p = ${jsonEncode(path)};
        var plugin = globalThis.__lnrPlugin;
        var site = String(globalThis.__lnrSite || '');
        if (plugin && typeof plugin.resolveUrl === 'function') {
          var r = plugin.resolveUrl(p, true);
          if (r) return String(r);
        }
        if (p.indexOf('http://') === 0 || p.indexOf('https://') === 0) return p;
        if (!site) return p;
        while (site.length && site.charAt(site.length - 1) === '/') site = site.slice(0, -1);
        var pp = String(p);
        while (pp.length && pp.charAt(0) === '/') pp = pp.slice(1);
        return site + '/' + pp;
      } catch (e) { return ''; }
    })()''';
    try {
      final res = runtime.evaluate(expr);
      final s = res.stringResult;
      return s.isNotEmpty ? s : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getWebUrl(String url) => _resolveWebUrl(url);

  @override
  Future<String> getHtmlContent(String url) async {
    final data = await _call('parseChapter', [url]);
    return data?.toString() ?? '';
  }

  // Novels have no image pages / videos / categories.
  @override
  Future<List<PageUrl>> getPageList(String url) async => const [];
  @override
  Future<List<MVideo>> getVideoList(String url) async => const [];
  @override
  Future<List<Map<String, String>>> getCategories() async => const [];
  @override
  Future<MPages> getListing(String listingUrl, int page) async =>
      MPages(list: const [], hasNextPage: false);
  @override
  Future<List<SourcePreference>> fetchSourcePreferences() async => const [];
  @override
  Future<void> setSourcePreference(String key, dynamic value) async {}

  @override
  String get sourceBaseUrl => baseUrl;
  @override
  bool get supportsLatest => true;
  @override
  Map<String, String> getHeaders() => const {};
  @override
  FilterList getFilterList() => const FilterList([]);
  @override
  List<SourcePreference> getSourcePreferences() => const [];

  @override
  void dispose() {
    if (!_initialized) return;
    runtime.dispose();
    _initialized = false;
  }
}

/// Injected before the plugin: globals, require() shim, @libs.
const String _preamble = r'''
(function () {
  var G = globalThis;
  if (typeof G.console === 'undefined') {
    G.console = { log: function(){}, warn: function(){}, error: function(){}, info: function(){}, debug: function(){} };
  }

  // --- WHATWG-ish fetch over the HttpGet/HttpPost bridge ---
  function Headers(obj) { this._h = {}; var o = obj || {}; for (var k in o) this._h[String(k).toLowerCase()] = o[k]; }
  Headers.prototype.get = function (n) { var v = this._h[String(n).toLowerCase()]; return v === undefined ? null : v; };
  Headers.prototype.has = function (n) { return this._h[String(n).toLowerCase()] !== undefined; };
  G.Headers = Headers;

  function Response(raw, url) {
    this.status = (raw && raw.statusCode) || 0;
    this.ok = this.status >= 200 && this.status < 300;
    this.statusText = '';
    this.url = url || (raw && raw.url) || '';
    this._body = (raw && raw.body) || '';
    this.headers = new Headers((raw && raw.headers) || {});
  }
  Response.prototype.text = function () { var b = this._body; return Promise.resolve(b); };
  Response.prototype.json = function () { var b = this._body; return Promise.resolve(JSON.parse(b)); };
  Response.prototype.arrayBuffer = function () {
    var b = this._body, n = b.length, u = new Uint8Array(n);
    for (var i = 0; i < n; i++) u[i] = b.charCodeAt(i) & 0xff;
    return Promise.resolve(u.buffer);
  };
  G.Response = Response;

  function _serializeBody(body) {
    if (body == null) return null;
    if (typeof body === 'string') return body;
    if (body && typeof body.toString === 'function') return body.toString();
    return String(body);
  }

  G.fetch = function (url, init) {
    init = init || {};
    var method = (init.method || 'GET').toUpperCase();
    var headers = {};
    if (init.headers) {
      if (init.headers instanceof Headers) headers = init.headers._h;
      else for (var k in init.headers) if (init.headers[k] != null) headers[k] = String(init.headers[k]);
    }
    var payload = JSON.stringify({ url: String(url), headers: headers, body: _serializeBody(init.body) });
    var ch = method === 'POST' ? 'HttpPost' : 'HttpGet';
    return sendMessage(ch, payload).then(function (raw) {
      return new Response(JSON.parse(raw), String(url));
    });
  };

  // Minimal XMLHttpRequest over the SAME bridge as fetch - plugins/libs that use
  // XHR (or a transport that falls back to it) go through our Cloudflare-aware
  // path too, instead of flutter_js's package:http XHR (which bypasses CF and
  // crashes uncaught on a failed request). Async only (no sync open(...,false)).
  G.XMLHttpRequest = function () {
    this.readyState = 0; this.status = 0; this.statusText = '';
    this.responseText = ''; this.response = '';
    this.onreadystatechange = null; this.onload = null;
    this.onerror = null; this.onloadend = null;
    this._method = 'GET'; this._url = ''; this._reqHeaders = {}; this._respHeaders = {};
  };
  (function (XP) {
    function fire(self, name) {
      var cb = self[name];
      if (typeof cb === 'function') { try { cb.call(self); } catch (e) {} }
    }
    XP.open = function (method, url) {
      this._method = String(method || 'GET').toUpperCase();
      this._url = String(url);
      this.readyState = 1;
      fire(this, 'onreadystatechange');
    };
    XP.setRequestHeader = function (k, v) { this._reqHeaders[String(k)] = String(v); };
    XP.abort = function () {};
    XP.getAllResponseHeaders = function () {
      var s = ''; for (var k in this._respHeaders) s += k + ': ' + this._respHeaders[k] + '\r\n'; return s;
    };
    XP.getResponseHeader = function (k) {
      k = String(k).toLowerCase();
      for (var h in this._respHeaders) if (h.toLowerCase() === k) return this._respHeaders[h];
      return null;
    };
    XP.send = function (body) {
      var self = this;
      var ch = self._method === 'POST' ? 'HttpPost' : 'HttpGet';
      var payload = JSON.stringify({
        url: self._url, headers: self._reqHeaders,
        body: (body == null ? null : (typeof body === 'string' ? body : String(body)))
      });
      sendMessage(ch, payload).then(function (raw) {
        var r = {};
        try { r = JSON.parse(raw) || {}; } catch (e) {}
        self.status = r.statusCode || 0;
        self.statusText = '';
        self.responseText = r.body || '';
        self.response = self.responseText;
        self._respHeaders = r.headers || {};
        self.readyState = 4;
        fire(self, 'onreadystatechange');
        fire(self, (self.status >= 200 && self.status < 300) ? 'onload' : 'onerror');
        fire(self, 'onloadend');
      }).catch(function () {
        self.status = 0; self.readyState = 4;
        fire(self, 'onreadystatechange');
        fire(self, 'onerror');
        fire(self, 'onloadend');
      });
    };
  })(G.XMLHttpRequest.prototype);

  if (typeof G.FormData === 'undefined') {
    G.FormData = function () { this._d = []; };
    G.FormData.prototype.append = function (k, v) { this._d.push([k, v]); };
    G.FormData.prototype.toString = function () {
      return this._d.map(function (p) { return encodeURIComponent(p[0]) + '=' + encodeURIComponent(p[1]); }).join('&');
    };
  }

  // URLSearchParams: QuickJS has no built-in. Many LNReader plugins build query
  // strings via `new URLSearchParams({...}).toString()` / .append / .set, so
  // without this they throw "URLSearchParams is not defined" and return nothing.
  if (typeof G.URLSearchParams === 'undefined') {
    G.URLSearchParams = function (init) {
      this._p = [];
      var self = this;
      function addStr(s) {
        s = String(s).replace(/^\?/, '');
        if (!s) return;
        s.split('&').forEach(function (pair) {
          if (!pair) return;
          var i = pair.indexOf('=');
          var k = i < 0 ? pair : pair.slice(0, i);
          var v = i < 0 ? '' : pair.slice(i + 1);
          self._p.push([
            decodeURIComponent(k.replace(/\+/g, ' ')),
            decodeURIComponent(v.replace(/\+/g, ' '))
          ]);
        });
      }
      if (init == null) {
        // empty
      } else if (typeof init === 'string') {
        addStr(init);
      } else if (init instanceof G.URLSearchParams) {
        this._p = init._p.map(function (e) { return [e[0], e[1]]; });
      } else if (Object.prototype.toString.call(init) === '[object Array]') {
        init.forEach(function (e) { self._p.push([String(e[0]), String(e[1])]); });
      } else if (typeof init === 'object') {
        Object.keys(init).forEach(function (k) { self._p.push([k, String(init[k])]); });
      }
    };
    var SP = G.URLSearchParams.prototype;
    SP.append = function (k, v) { this._p.push([String(k), String(v)]); };
    SP.set = function (k, v) {
      var done = false;
      this._p = this._p.filter(function (e) {
        if (e[0] === String(k)) { if (!done) { e[1] = String(v); done = true; return true; } return false; }
        return true;
      });
      if (!done) this._p.push([String(k), String(v)]);
    };
    SP.get = function (k) { for (var i = 0; i < this._p.length; i++) if (this._p[i][0] === String(k)) return this._p[i][1]; return null; };
    SP.getAll = function (k) { var r = []; for (var i = 0; i < this._p.length; i++) if (this._p[i][0] === String(k)) r.push(this._p[i][1]); return r; };
    SP.has = function (k) { for (var i = 0; i < this._p.length; i++) if (this._p[i][0] === String(k)) return true; return false; };
    SP['delete'] = function (k) { this._p = this._p.filter(function (e) { return e[0] !== String(k); }); };
    SP.forEach = function (cb, thisArg) { for (var i = 0; i < this._p.length; i++) cb.call(thisArg, this._p[i][1], this._p[i][0], this); };
    SP.keys = function () { return this._p.map(function (e) { return e[0]; }); };
    SP.values = function () { return this._p.map(function (e) { return e[1]; }); };
    SP.entries = function () { return this._p.map(function (e) { return [e[0], e[1]]; }); };
    SP.sort = function () { this._p.sort(function (a, b) { return a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0; }); };
    SP.toString = function () {
      return this._p.map(function (e) { return encodeURIComponent(e[0]) + '=' + encodeURIComponent(e[1]); }).join('&');
    };
  }

  if (typeof G.URL === 'undefined') {
    G.URL = function (url, base) {
      url = String(url);
      if (base && !/^[a-z][a-z0-9+.-]*:\/\//i.test(url)) {
        url = String(base).replace(/\/+$/, '') + '/' + url.replace(/^\/+/, '');
      }
      var m = /^([a-z][a-z0-9+.-]*:)\/\/([^\/?#]*)([^?#]*)(\?[^#]*)?(#.*)?$/i.exec(url) || [];
      this.href = url; this.protocol = m[1] || ''; this.host = m[2] || '';
      this.hostname = (m[2] || '').split(':')[0]; this.pathname = m[3] || '/';
      this.search = m[4] || ''; this.hash = m[5] || ''; this.origin = (m[1] || '') + '//' + (m[2] || '');
      this.searchParams = new G.URLSearchParams(this.search);
      this.toString = function () { return this.href; };
    };
  }

  if (typeof G.TextDecoder === 'undefined') {
    G.TextDecoder = function () {};
    G.TextDecoder.prototype.decode = function (buf) {
      var u = buf instanceof Uint8Array ? buf : new Uint8Array(buf || []);
      var s = ''; for (var i = 0; i < u.length; i++) s += String.fromCharCode(u[i]); return s;
    };
  }

  // --- @libs ---
  var DEFAULT_HEADERS = { 'Connection': 'keep-alive', 'Accept': '*/*', 'Accept-Language': '*', 'Sec-Fetch-Mode': 'cors' };
  function fetchApi(url, init) {
    init = init || {};
    var h = {}; for (var k in DEFAULT_HEADERS) h[k] = DEFAULT_HEADERS[k];
    if (init.headers) { if (init.headers instanceof Headers) { for (var x in init.headers._h) h[x] = init.headers._h[x]; } else for (var y in init.headers) if (init.headers[y] != null) h[y] = init.headers[y]; }
    return G.fetch(url, { method: init.method, headers: h, body: init.body });
  }
  function fetchText(url, init) { return fetchApi(url, init).then(function (r) { return r.text(); }).catch(function () { return ''; }); }
  function fetchFile() { return Promise.resolve(''); }
  function fetchProto() { return Promise.reject(new Error('fetchProto unsupported')); }

  var _mem = {};
  var storage = {
    get: function (key, raw) { var it = _mem[key]; if (!it) return undefined; if (it.expires && Date.now() > it.expires) { delete _mem[key]; return undefined; } return raw ? it : it.value; },
    set: function (key, value, expires) { _mem[key] = { created: new Date(), value: value, expires: (expires instanceof Date) ? expires.getTime() : expires }; },
    getAllKeys: function () { return Object.keys(_mem); },
    delete: function (key) { delete _mem[key]; },
    clearAll: function () { _mem = {}; }
  };
  var webStorage = { get: function () { return {}; }, set: function () {} };

  var NovelStatus = { Unknown: 'Unknown', Ongoing: 'Ongoing', Completed: 'Completed', Licensed: 'Licensed', PublishingFinished: 'Publishing Finished', Cancelled: 'Cancelled', OnHiatus: 'On Hiatus', STUB: 'STUB', Inactive: 'Inactive' };
  var defaultCover = 'https://github.com/LNReader/lnreader-plugins/blob/main/icons/src/coverNotAvailable.jpg?raw=true';
  var FilterTypes = { TextInput: 'Text', Picker: 'Picker', CheckboxGroup: 'Checkbox', Switch: 'Switch', ExcludableCheckboxGroup: 'XCheckbox' };
  function isUrlAbsolute(url) { if (!url) return false; url = String(url); return /^([a-z][a-z0-9+.-]*:)?\/\//i.test(url) || /^[a-z][a-z0-9+.-]*:/i.test(url); }

  var MODS = {
    'cheerio': G.__LNR_cheerio,
    'htmlparser2': G.__LNR_htmlparser2,
    'dayjs': (G.__LNR_dayjs && G.__LNR_dayjs.default) ? G.__LNR_dayjs.default : G.__LNR_dayjs,
    '@libs/fetch': { fetchApi: fetchApi, fetchText: fetchText, fetchFile: fetchFile, fetchProto: fetchProto },
    '@libs/storage': { storage: storage, localStorage: webStorage, sessionStorage: webStorage },
    '@libs/novelStatus': { NovelStatus: NovelStatus },
    '@libs/defaultCover': { defaultCover: defaultCover },
    '@libs/filterInputs': { FilterTypes: FilterTypes },
    '@libs/isAbsoluteUrl': { isUrlAbsolute: isUrlAbsolute },
    '@/types/constants': { NovelStatus: NovelStatus, defaultCover: defaultCover },
    '@libs/aes': { gcm: function () { throw new Error('aes.gcm unsupported'); } }
  };
  G.__lnr_require = function (name) {
    if (Object.prototype.hasOwnProperty.call(MODS, name)) return MODS[name];
    throw new Error('LNReader require: module not found: ' + name);
  };

  // Resolve default filter values from the plugin's own filter definitions.
  function fillFilters(opts) {
    if (opts && opts.__fillFilters) {
      var f = (G.__lnrPlugin && G.__lnrPlugin.filters) || {};
      var out = {};
      for (var k in f) out[k] = { value: f[k] && f[k].value, type: f[k] && f[k].type };
      opts.filters = out;
      delete opts.__fillFilters;
    }
    return opts;
  }

  // Wrap a plugin call: resolve opts markers, run, and report {ok,data|error}.
  G.__lnrRun = function (fn) {
    return Promise.resolve().then(function () {
      // second arg of popularNovels is our opts marker - patch in place
      return fn.call(null);
    }).then(function (data) {
      return JSON.stringify({ ok: true, data: data });
    }).catch(function (e) {
      // Extract a legible message across engines. iOS JavaScriptCore often hands
      // back a rejection whose name/message read empty while only `stack` is set
      // (anonymous "@" frames), so String(e) / the old path produced just a wall
      // of "@". Try every avenue and keep the first that yields real text.
      function clean(s) { return (s == null) ? '' : String(s).trim(); }
      var name = '';
      var msg = '';
      try { name = clean(e && e.name); } catch (ignored) {}
      try { msg = clean(e && e.message); } catch (ignored) {}
      if (!msg) { try { if (typeof e === 'string') msg = clean(e); } catch (ignored) {} }
      if (!msg) { try { var ts = clean(e && e.toString && e.toString()); if (ts && ts !== '[object Object]') msg = ts; } catch (ignored) {} }
      if (!msg && !name) { try { var js = clean(JSON.stringify(e)); if (js && js !== '{}' && js !== 'null') msg = js; } catch (ignored) {} }
      var head = (name && msg)
        ? (msg.indexOf(name) === 0 ? msg : (name + ': ' + msg))
        : (msg || name);
      if (!head) head = 'unknown error (' + (typeof e) + ')';
      // Keep the stack only when it carries something beyond bare "@" frames.
      var stack = '';
      try { stack = clean(e && e.stack); } catch (ignored) {}
      var useful = stack && /[A-Za-z0-9_$]+@|\bat [A-Za-z_$]/.test(stack) &&
        clean(stack.replace(/Promise@\[native code\]/g, '').replace(/[@\s]/g, ''));
      if (useful) head = head + '\n' + stack;
      return JSON.stringify({ ok: false, error: head });
    });
  };
})();
''';
