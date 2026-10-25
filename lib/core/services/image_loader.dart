import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:rhttp/rhttp.dart' as rhttp;
import 'app_logger.dart';
import 'cookie_store.dart';
import 'doh/doh_resolver.dart';

/// Loads images using rhttp (Rust/reqwest) with Chrome-like TLS fingerprint.
/// This is the same HTTP engine that bypasses Cloudflare.
class ImageLoader {
  static final ImageLoader _instance = ImageLoader._();
  factory ImageLoader() => _instance;
  ImageLoader._();

  rhttp.RhttpClient? _client;
  /// Insertion-ordered, so `keys.first` is the oldest entry.
  final Map<String, Uint8List> _cache = {};
  int _cacheBytes = 0;
  /// In-flight fetches keyed by URL, so two widgets requesting the same image at
  /// once (e.g. a cover in the grid + the "Continue reading" card, or a widget
  /// recycled mid-load) share ONE network request instead of each spending a
  /// concurrency slot on a duplicate GET.
  final Map<String, Future<Uint8List?>> _inFlight = {};

  /// Encoded-image cache budget. Bytes are the real constraint - entry count
  /// is kept only as a secondary guard against pathologically tiny images.
  static const int _maxCacheBytes = 64 * 1024 * 1024;
  static const int _maxCacheEntries = 200;
  final Set<String> _blockedDomains = {};

  Future<rhttp.RhttpClient> _getClient() async {
    if (_client != null) return _client!;
    // Don't verify TLS certs for image fetches. Manga image CDNs (e.g.
    // static.mfcdn.cc) routinely serve incomplete/unknown-issuer chains that a
    // browser papers over by fetching the missing intermediate, but reqwest
    // (rhttp) does not - so covers and reader pages failed with
    // InvalidCertificate(UnknownIssuer) even though the DOWNLOAD client already
    // fetches the same images with verification off. Match it so on-screen
    // display works too. (Public manga images; integrity risk is low, and
    // inconsistent behaviour between view and download is worse.)
    _client = await rhttp.RhttpClient.create(
      settings: rhttp.ClientSettings(
        throwOnStatusCode: false,
        tlsSettings: const rhttp.TlsSettings(verifyCertificates: false),
        // DNS-over-HTTPS when enabled in Advanced settings; null = system DNS.
        dnsSettings: dohDnsSettingsOrNull(),
      ),
    );
    return _client!;
  }

  /// Load image bytes from URL with headers.
  Future<Uint8List?> loadImage(String url,
      {Map<String, String>? headers}) async {
    if (url.isEmpty) return null;
    // A source can hand back a RELATIVE image URL (e.g. "cover.jpg"), which
    // failed with "relative URL without a base". Resolve it against the Referer
    // so it has a base before anything tries to fetch it.
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      final ref = headers?['Referer'];
      final base = ref != null ? Uri.tryParse(ref) : null;
      if (base != null && base.hasScheme) {
        url = base.resolve(url).toString();
      }
    }
    final cached = _cache[url];
    if (cached != null) return cached;
    // Collapse duplicate concurrent requests for the same URL to one fetch.
    final existing = _inFlight[url];
    if (existing != null) return existing;
    final future = _loadImageUncached(url, headers);
    _inFlight[url] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(url);
    }
  }

  Future<Uint8List?> _loadImageUncached(
      String url, Map<String, String>? headers) async {
    final imageDomain = Uri.tryParse(url)?.host ?? '';
    if (_blockedDomains.contains(imageDomain)) return null;

    // Build headers - include Sec-Fetch-* so Cloudflare's bot detection treats
    // this as a legitimate cross-origin image request from a browser.
    final refererForSite = headers?['Referer'];
    final isCrossOrigin = refererForSite != null &&
        Uri.tryParse(refererForSite)?.host != Uri.tryParse(url)?.host;
    final mergedHeaders = <String, String>{
      'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
      'sec-fetch-dest': 'image',
      'sec-fetch-mode': 'no-cors',
      'sec-fetch-site': isCrossOrigin ? 'cross-site' : 'same-site',
      // Client Hints are Chromium-only - Safari never sends them. On iOS the
      // stored UA is iOS Safari, so advertising Chromium *and* desktop Windows
      // from an iPhone is a strong bot signal. A 403 here is unrecoverable:
      // the domain gets added to _blockedDomains for the rest of the session.
      if (!Platform.isIOS) ...{
        'sec-ch-ua':
            '"Not A Brand";v="99","Google Chrome";v="120","Chromium";v="120"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Windows"',
      },
      ...?headers,
    };

    // Use stored UA
    final storedUA = await CookieStore().getUserAgent();
    mergedHeaders.putIfAbsent('User-Agent', () => storedUA);

    // Only send cookies that belong to the image domain.
    // Do NOT send the Referer domain's cookies here - that leaks source-site
    // session tokens (e.g. missav.ai cookies) to third-party CDNs.
    final imageCookies = await CookieStore().getCookieHeader(url);
    if (imageCookies != null) {
      final existing = mergedHeaders['Cookie'] ?? '';
      if (existing.isEmpty) {
        mergedHeaders['Cookie'] = imageCookies;
      } else if (!existing.contains(imageCookies)) {
        mergedHeaders['Cookie'] = '$existing; $imageCookies';
      }
    }

    // Fetch behind a small concurrency cap (so we don't hammer a CDN into
    // 429/503), with retry + backoff on transient/Cloudflare errors.
    await _acquireSlot();
    try {
      return await _fetchWithRetry(url, mergedHeaders, imageDomain);
    } finally {
      _releaseSlot();
    }
  }

  /// GET with up to 3 attempts. Retries transient origin/Cloudflare failures
  /// (5xx / 429 / timeouts) with exponential-ish backoff; a 403 is a managed
  /// challenge we can't beat, so it blocks the domain and gives up immediately.
  Future<Uint8List?> _fetchWithRetry(
      String url, Map<String, String> headers, String domain) async {
    const maxAttempts = 3;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final client = await _getClient();
        final response = await client
            .requestBytes(
              method: rhttp.HttpMethod.get,
              url: url,
              headers: rhttp.HttpHeaders.rawMap(headers),
            )
            .timeout(const Duration(seconds: 25));
        final code = response.statusCode;
        if (code == 200 && response.body.isNotEmpty) {
          final bytes = Uint8List.fromList(response.body);
          _addToCache(url, bytes);
          return bytes;
        }
        if (code == 200) {
          // 200 with an empty body - usually a hotlink/CF block served as a
          // blank response.
          await logger.warning('Image load: empty response (HTTP 200)',
              category: LogCategory.network, detail: url);
          return null;
        }
        if (code == 403) {
          await logger.warning(
              'Image blocked by the server (HTTP 403) - $domain',
              category: LogCategory.network,
              detail:
                  '$url\nHotlink protection or Cloudflare. This image domain is '
                  'skipped for the rest of the session; tap Retry to try it again.');
          _blockedDomains.add(domain);
          return null;
        }
        if (_isTransient(code) && attempt < maxAttempts) {
          await Future.delayed(_backoff(attempt));
          continue;
        }
        // Non-transient (404 etc.) or out of retry attempts.
        await logger.warning('Image load failed (HTTP $code)',
            category: LogCategory.network, detail: url);
        return null;
      } catch (e) {
        if (attempt < maxAttempts) {
          await Future.delayed(_backoff(attempt));
          continue;
        }
        await logger.error('Image load error after $maxAttempts attempts',
            category: LogCategory.network, detail: '$url\n$e');
      }
    }
    return null;
  }

  /// Drop a domain from the session block-list so a user-initiated Retry (or a
  /// fresh Cloudflare solve) actually re-requests it instead of short-circuiting.
  void unblockDomainFor(String url) {
    final host = Uri.tryParse(url)?.host;
    if (host != null) _blockedDomains.remove(host);
  }

  /// Drop one URL's cached bytes so it re-downloads next time it's shown. Used
  /// by "Refresh library covers" so a re-fetched cover isn't served stale from
  /// the in-memory cache. No-op if the URL isn't cached.
  void evict(String url) {
    final bytes = _cache.remove(url);
    if (bytes != null) _cacheBytes -= bytes.lengthInBytes;
  }

  static bool _isTransient(int code) =>
      code == 408 ||
      code == 425 ||
      code == 429 ||
      code == 500 ||
      code == 502 ||
      code == 503 ||
      code == 504 ||
      (code >= 520 && code <= 524); // Cloudflare origin-side errors

  static Duration _backoff(int attempt) =>
      Duration(milliseconds: 400 * attempt + 250 * attempt * attempt);

  // ── concurrency cap ──────────────────────────────────────
  // Too many parallel image GETs is itself what trips rate limits / 503s on a
  // lot of CDNs, so cap in-flight requests; the rest queue for a freed slot.
  static const int _maxConcurrent = 5;
  int _activeRequests = 0;
  final List<Completer<void>> _slotWaiters = [];

  Future<void> _acquireSlot() async {
    if (_activeRequests < _maxConcurrent) {
      _activeRequests++;
      return;
    }
    final c = Completer<void>();
    _slotWaiters.add(c);
    await c.future; // slot handed over on release - the count stays with us
  }

  void _releaseSlot() {
    if (_slotWaiters.isNotEmpty) {
      _slotWaiters.removeAt(0).complete();
    } else {
      _activeRequests--;
    }
  }

  void unblockDomains() => _blockedDomains.clear();

  void _addToCache(String url, Uint8List bytes) {
    // A single oversized page shouldn't be able to evict the whole cache.
    if (bytes.lengthInBytes > _maxCacheBytes ~/ 4) return;

    _cache[url] = bytes;
    _cacheBytes += bytes.lengthInBytes;

    // Evict oldest-first until BOTH budgets are satisfied. Capping by entry
    // count alone is what let this grow unbounded: webtoon strips are ~10x the
    // size of a normal page, so 200 of them is gigabytes of encoded data held
    // outside Flutter's ImageCache budget. Android merely OOMs; iOS jetsams the
    // process with no Dart exception, so the app just vanishes mid-chapter.
    while (_cache.isNotEmpty &&
        (_cacheBytes > _maxCacheBytes || _cache.length > _maxCacheEntries)) {
      final oldest = _cache.keys.first;
      final evicted = _cache.remove(oldest);
      _cacheBytes -= evicted?.lengthInBytes ?? 0;
    }
    if (_cache.isEmpty) _cacheBytes = 0;
  }

  void clearCache() {
    _cache.clear();
    _cacheBytes = 0;
    _blockedDomains.clear();
    _client?.dispose();
    _client = null;
  }

  /// Drop the cached HTTP client so the next request rebuilds it - used when the
  /// DNS-over-HTTPS setting changes, so it takes effect without an app restart.
  void resetHttpClient() {
    _client?.dispose();
    _client = null;
  }
}
