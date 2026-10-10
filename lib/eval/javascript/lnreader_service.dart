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

/// Runs LNReader novel plugins (compiled CommonJS JS) in the flutter_js runtime.
///
/// LNReader plugins are `tsc`-compiled modules that `require('cheerio')`,
/// `require('htmlparser2')`, `require('dayjs')` and a handful of `@libs/*`, then
/// `exports.default` a ready plugin instance implementing LNReader's Plugin API
/// (popularNovels / searchNovels / parseNovel / parseChapter). This service
/// supplies a `require()` shim + WHATWG `fetch`/`Response` (over the existing
/// HTTP bridge) + the cheerio/htmlparser2/dayjs bundle (assets/js), loads the
/// plugin, and maps its methods onto the app's [ExtensionService] interface.
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
    runtime = getJavascriptRuntime();
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
    } catch (_) {}
    _initialized = true;
  }

  /// Source is wrapped verbatim; it already ends in `exports.default = …`.
  static String _wrapSource(String code) => code;

  /// Decode the `{ok, data|error}` envelope. Some flutter_js engines (notably
  /// iOS's JavaScriptCore) return a resolved promise's value ALREADY JSON-encoded,
  /// so the envelope arrives double-encoded — decode once, and if that yields a
  /// String, decode again. Android's engine single-encodes, so the guard is a
  /// no-op there. Without this, every LNReader call throws "String is not a
  /// subtype of Map" on iOS and the whole lane is dead.
  static Map<String, dynamic> _decodeEnvelope(String s) {
    dynamic d = jsonDecode(s);
    if (d is String) d = jsonDecode(d);
    return (d as Map).cast<String, dynamic>();
  }

  /// Run an async plugin call and return its JSON. Args are JSON-encoded so a
  /// source-controlled path/query can't break out of the expression.
  Future<dynamic> _call(String method, List<dynamic> args) async {
    await _ensureInit();
    final argsJson = jsonEncode(args);
    final expr =
        '__lnrRun(function(){ return __lnrPlugin.$method.apply(__lnrPlugin, $argsJson); })';
    try {
      final jsResult = await runtime.evaluateAsync(expr);
      final promised = await runtime.handlePromise(jsResult);
      final out = _decodeEnvelope(promised.stringResult);
      if (out['ok'] == true) return out['data'];
      logger.error('LNReader $method failed: ${out['error']}',
          category: LogCategory.extension);
      return null;
    } catch (e) {
      logger.error('LNReader $method threw: $e', category: LogCategory.extension);
      return null;
    }
  }

  /// Run an arbitrary JS body inside __lnrRun (for calls whose args must be built
  /// in JS, like popularNovels' resolved filter values).
  Future<dynamic> _callExpr(String body) async {
    await _ensureInit();
    final expr = '__lnrRun(function(){ $body })';
    try {
      final jsResult = await runtime.evaluateAsync(expr);
      final promised = await runtime.handlePromise(jsResult);
      final out = _decodeEnvelope(promised.stringResult);
      if (out['ok'] == true) return out['data'];
      logger.error('LNReader call failed: ${out['error']}',
          category: LogCategory.extension);
      return null;
    } catch (e) {
      logger.error('LNReader call threw: $e', category: LogCategory.extension);
      return null;
    }
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
        );
    final chapters = <MChapter>[
      for (final c in (data['chapters'] is List
              ? data['chapters'] as List
              : const [])
          .whereType<Map>())
        toChapter(c),
    ];
    // LNReader paginates long chapter lists: parseNovel returns only page 1 plus
    // a `totalPages` count, and the rest come from parsePage(novelPath, page).
    // Walk the remaining pages so a novel like Shadow Slave (3000+ chapters at
    // ~100/page) loads its FULL list instead of only the first 100. Best-effort:
    // a page that errors (parsePage unimplemented / network) is skipped, and
    // chapters are de-duplicated by url.
    final totalPages =
        ((data['totalPages'] as num?)?.toInt() ?? 1).clamp(1, 500);
    if (totalPages > 1) {
      final seen = <String>{
        for (final ch in chapters)
          if (ch.url != null) ch.url!
      };
      // Full list = every page; a lightweight update check ([fullChapters]
      // false) only needs the LAST page — the newest chapters on an
      // ascending-paginated source like Novel Phoenix — so it's ~2 requests
      // instead of ~32.
      final pages = fullChapters
          ? [for (var p = 2; p <= totalPages; p++) p]
          : <int>[totalPages];
      for (final page in pages) {
        final pageData = await _call('parsePage', [url, '$page']);
        final list = (pageData is Map && pageData['chapters'] is List)
            ? pageData['chapters'] as List
            : const [];
        for (final c in list.whereType<Map>()) {
          final ch = toChapter(c);
          if (ch.url != null && seen.add(ch.url!)) chapters.add(ch);
        }
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
  /// call is synchronous JS — string ops, no regex, to keep escaping simple.
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

  if (typeof G.FormData === 'undefined') {
    G.FormData = function () { this._d = []; };
    G.FormData.prototype.append = function (k, v) { this._d.push([k, v]); };
    G.FormData.prototype.toString = function () {
      return this._d.map(function (p) { return encodeURIComponent(p[0]) + '=' + encodeURIComponent(p[1]); }).join('&');
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
      var sp = {}; (this.search.replace(/^\?/, '')).split('&').forEach(function (p) {
        if (!p) return; var i = p.indexOf('='); var kk = decodeURIComponent(i < 0 ? p : p.slice(0, i));
        sp[kk] = decodeURIComponent(i < 0 ? '' : p.slice(i + 1));
      });
      this.searchParams = {
        get: function (k) { return sp[k] !== undefined ? sp[k] : null; },
        has: function (k) { return sp[k] !== undefined; },
        set: function (k, v) { sp[k] = String(v); },
        toString: function () { return Object.keys(sp).map(function (k) { return encodeURIComponent(k) + '=' + encodeURIComponent(sp[k]); }).join('&'); }
      };
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
      // second arg of popularNovels is our opts marker — patch in place
      return fn.call(null);
    }).then(function (data) {
      return JSON.stringify({ ok: true, data: data });
    }).catch(function (e) {
      return JSON.stringify({ ok: false, error: String((e && e.stack) || e) });
    });
  };
})();
''';
