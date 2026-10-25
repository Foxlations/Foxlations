import 'dart:convert';
import 'dart:io';

import 'package:rhttp/rhttp.dart' show DnsSettings;

import '../app_logger.dart';
import '../settings_store.dart';
import 'doh_provider.dart';

class _CacheEntry {
  final List<String> ips;
  final DateTime expiry;
  _CacheEntry(this.ips, this.expiry);
}

/// Resolves hostnames to IPs over DNS-over-HTTPS (RFC 8484 "DNS-JSON").
///
/// The endpoint is queried as `{queryUrl}?name={host}&type=A` (+ AAAA) with
/// `Accept: application/dns-json`, over a plain system-DNS [HttpClient] so it
/// never recurses into itself. Results are cached per host honoring the record
/// TTL (clamped), and ANY failure falls back to the system resolver - so
/// turning DoH on can never hard-break networking.
class DohResolver {
  DohResolver._();
  static final DohResolver instance = DohResolver._();

  static const _minTtl = Duration(seconds: 30);
  static const _maxTtl = Duration(hours: 1);
  static const _timeout = Duration(seconds: 5);

  final Map<String, _CacheEntry> _cache = {};
  HttpClient? _http;

  HttpClient get _client =>
      _http ??= (HttpClient()..connectionTimeout = _timeout);

  /// Drop cached lookups - call when the provider or toggle changes.
  void clearCache() => _cache.clear();

  // Bumped whenever the DoH toggle or provider changes. HTTP clients that cache
  // an rhttp client (built once with the DNS settings at creation time) compare
  // against this and rebuild lazily on their next request, so flipping DoH
  // off/on actually takes effect on already-created source clients instead of
  // only after an app restart.
  int _clientGeneration = 0;
  int get clientGeneration => _clientGeneration;
  void bumpClientGeneration() => _clientGeneration++;

  /// Resolve [host] to IP strings via [provider]. Never throws; returns system
  /// DNS results (or an empty list, letting the caller's stack try its own) on
  /// any DoH failure.
  Future<List<String>> resolve(String host, DohProvider provider) async {
    if (_isIp(host)) return [host];

    final now = DateTime.now();
    final cached = _cache[host];
    if (cached != null && cached.expiry.isAfter(now)) return cached.ips;

    // Try the user's provider, then non-filtering public resolvers (literal-IP,
    // so they keep working where a DoH hostname can't be resolved). A provider
    // that FILTERS a source - Quad9 / filtered AdGuard block aggregator domains
    // like natomanga.com - or a blocked resolver IP then can't break resolution.
    for (final p in _chain(provider)) {
      try {
        final result = await _queryDoh(host, p).timeout(_timeout);
        if (result.ips.isNotEmpty) {
          _cache[host] = _CacheEntry(result.ips, now.add(result.ttl));
          return result.ips;
        }
      } catch (e) {
        logger.warning('DoH lookup failed for $host (${p.label})',
            category: LogCategory.network, detail: e.toString());
      }
    }
    return _systemLookup(host);
  }

  /// Non-filtering public resolvers used as fallbacks, as literal-IP JSON
  /// endpoints spanning two networks (Cloudflare + Google) so neither filtering
  /// nor a single blocked IP can stop resolution. Google serves JSON at /resolve.
  static const _fallbacks = <DohProvider>[
    DohProvider(
        id: '_fb_cf1', label: 'Cloudflare 1.1.1.1',
        queryUrl: 'https://1.1.1.1/dns-query'),
    DohProvider(
        id: '_fb_cf2', label: 'Cloudflare 1.0.0.1',
        queryUrl: 'https://1.0.0.1/dns-query'),
    DohProvider(
        id: '_fb_g1', label: 'Google 8.8.8.8',
        queryUrl: 'https://8.8.8.8/resolve'),
  ];

  /// The user's provider first, then the fallbacks, de-duped by endpoint host.
  static List<DohProvider> _chain(DohProvider primary) {
    final chain = <DohProvider>[primary];
    final seen = <String?>{Uri.tryParse(primary.queryUrl)?.host};
    for (final f in _fallbacks) {
      if (seen.add(Uri.tryParse(f.queryUrl)?.host)) chain.add(f);
    }
    return chain;
  }

  Future<List<String>> _systemLookup(String host) async {
    try {
      final addrs = await InternetAddress.lookup(host);
      return [for (final a in addrs) a.address];
    } catch (e) {
      logger.warning('System DNS fallback failed for $host',
          category: LogCategory.network, detail: e.toString());
      return const [];
    }
  }

  Future<({List<String> ips, Duration ttl})> _queryDoh(
      String host, DohProvider provider) async {
    final ips = <String>[];
    var minTtl = _maxTtl.inSeconds;
    for (final type in const ['A', 'AAAA']) {
      final uri = Uri.parse(provider.queryUrl)
          .replace(queryParameters: {'name': host, 'type': type});
      final req = await _client.getUrl(uri);
      req.headers.set(HttpHeaders.acceptHeader, 'application/dns-json');
      final resp = await req.close();
      if (resp.statusCode != 200) {
        await resp.drain<void>();
        continue;
      }
      final body = await resp.transform(utf8.decoder).join();
      final json = jsonDecode(body);
      if (json is! Map) continue;
      final answers = json['Answer'];
      if (answers is! List) continue;
      for (final a in answers) {
        if (a is! Map) continue;
        final data = a['data']?.toString();
        if (data != null && _isIp(data)) {
          ips.add(data);
          final ttl = (a['TTL'] as num?)?.toInt();
          if (ttl != null && ttl < minTtl) minTtl = ttl;
        }
      }
    }
    final clamped =
        minTtl.clamp(_minTtl.inSeconds, _maxTtl.inSeconds);
    return (ips: ips, ttl: Duration(seconds: clamped));
  }

  static bool _isIp(String s) => InternetAddress.tryParse(s) != null;
}

/// The rhttp [DnsSettings] to apply given the current DoH settings, or null
/// when DoH is off / there's no usable provider (→ the stack's own resolver).
/// A client created with this keeps a dynamic resolver, so it reflects the live
/// setting without the client being rebuilt.
DnsSettings? dohDnsSettingsOrNull() {
  final s = SettingsStore.instance;
  if (!(s.getBool('adv_dns_over_https') ?? false)) return null;
  final provider = DohProviders.byId(
          s.getString('adv_dns_provider'), DohCustomStore.load()) ??
      DohProviders.cloudflare; // selected custom was deleted → safe default
  return DnsSettings.dynamic(
    resolver: (host) => DohResolver.instance.resolve(host, provider),
  );
}

/// The DoH config to push into the embedded-JVM / ART Kotlin extension lane.
///
/// - **Android**: honours the toggle; [url] is the provider's hostname endpoint
///   (Android's system DNS resolves the DoH host fine).
/// - **iOS**: DoH is MANDATORY (the Zero JVM's native DNS is broken), so it
///   always uses a DoH endpoint - the chosen provider's LITERAL-IP endpoint when
///   DoH is on, else the default Cloudflare IP endpoint. The JVM resolver can't
///   resolve a DoH hostname (that's what it IS), so the URL must be IP-based.
///   `enabled` is effectively ignored by the iOS resolver.
({bool enabled, String url}) jvmDohConfig() {
  final s = SettingsStore.instance;
  final on = s.getBool('adv_dns_over_https') ?? false;
  final provider = DohProviders.byId(
          s.getString('adv_dns_provider'), DohCustomStore.load()) ??
      DohProviders.cloudflare;
  if (Platform.isIOS) {
    final ipUrl = _ipEndpoint(on ? provider : DohProviders.cloudflare);
    return (enabled: true, url: ipUrl);
  }
  return (enabled: on, url: provider.queryUrl);
}

/// A literal-IP DoH endpoint for [p]: its queryUrl if the host is already an IP,
/// else its first IPv4 bootstrap + the same path. Falls back to Cloudflare's
/// 1.1.1.1 when a (custom) provider has no usable IP.
String _ipEndpoint(DohProvider p) {
  final uri = Uri.tryParse(p.queryUrl);
  if (uri != null && InternetAddress.tryParse(uri.host) != null) return p.queryUrl;
  final ipv4 = p.bootstrap.where((b) => !b.contains(':')).toList();
  if (uri != null && ipv4.isNotEmpty) {
    final path = uri.path.isEmpty ? '/dns-query' : uri.path;
    return 'https://${ipv4.first}$path';
  }
  return 'https://1.1.1.1/dns-query';
}
