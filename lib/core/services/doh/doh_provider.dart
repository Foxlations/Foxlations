import 'dart:convert';

import '../settings_store.dart';

/// A DNS-over-HTTPS endpoint the app can resolve hostnames through.
///
/// [queryUrl] is an RFC 8484 "DNS-JSON" endpoint (queried as
/// `GET {queryUrl}?name={host}&type=A`). [bootstrap] are literal IPs for the
/// endpoint's OWN host, kept so a future build can reach the resolver even when
/// system DNS is blocked for it (the current resolver reaches the endpoint via
/// system DNS, which is enough for privacy + unblocking the actual sites).
///
/// Preset endpoints + bootstrap IPs are public protocol facts (the same
/// addresses every DoH client uses); the implementation around them is ours.
/// User-added providers are [isCustom] and persist via [DohCustomStore].
class DohProvider {
  final String id;
  final String label;
  final String queryUrl;
  final List<String> bootstrap;
  final bool isCustom;

  const DohProvider({
    required this.id,
    required this.label,
    required this.queryUrl,
    this.bootstrap = const [],
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {'id': id, 'name': label, 'url': queryUrl};

  factory DohProvider.fromJson(Map<String, dynamic> j) => DohProvider(
        id: (j['id'] ?? '').toString(),
        label: (j['name'] ?? 'Custom').toString(),
        queryUrl: (j['url'] ?? '').toString(),
        isCustom: true,
      );
}

/// Built-in providers + resolution of the stored selection to a provider.
class DohProviders {
  DohProviders._();

  static const cloudflare = DohProvider(
    id: 'Cloudflare',
    label: 'Cloudflare',
    queryUrl: 'https://cloudflare-dns.com/dns-query',
    bootstrap: ['1.1.1.1', '1.0.0.1', '2606:4700:4700::1111', '2606:4700:4700::1001'],
  );
  static const google = DohProvider(
    id: 'Google',
    label: 'Google',
    // Google serves the JSON (dns-json) API at /resolve — /dns-query is
    // wireformat only, which returned no records for us.
    queryUrl: 'https://dns.google/resolve',
    bootstrap: ['8.8.8.8', '8.8.4.4', '2001:4860:4860::8888', '2001:4860:4860::8844'],
  );
  static const quad9 = DohProvider(
    id: 'Quad9',
    label: 'Quad9',
    queryUrl: 'https://dns.quad9.net/dns-query',
    bootstrap: ['9.9.9.9', '149.112.112.112', '2620:fe::fe', '2620:fe::9'],
  );
  static const adguard = DohProvider(
    id: 'AdGuard',
    label: 'AdGuard',
    queryUrl: 'https://dns-unfiltered.adguard.com/dns-query',
    bootstrap: ['94.140.14.140', '94.140.14.141', '2a10:50c0::1:ff', '2a10:50c0::2:ff'],
  );

  /// Built-in providers, in picker order. These can't be deleted.
  static const presets = [cloudflare, google, quad9, adguard];

  /// Resolve a stored selected id against the presets then the custom list.
  /// Returns null if the selection no longer exists (e.g. a deleted custom).
  static DohProvider? byId(String? id, List<DohProvider> customs) {
    final v = (id ?? cloudflare.id).trim();
    for (final p in presets) {
      if (p.id == v) return p;
    }
    for (final c in customs) {
      if (c.id == v) return c;
    }
    return null;
  }

  /// True if [url] is a usable https DoH endpoint.
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    return uri != null && uri.isScheme('https') && uri.host.isNotEmpty;
  }
}

/// Persists the user's custom DoH providers (a JSON list in the durable store).
class DohCustomStore {
  DohCustomStore._();
  static const key = 'adv_dns_custom_providers';

  static List<DohProvider> load() {
    final raw = SettingsStore.instance.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return [
        for (final e in list)
          DohProvider.fromJson((e as Map).cast<String, dynamic>()),
      ].where((p) => p.id.isNotEmpty && p.queryUrl.isNotEmpty).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _save(List<DohProvider> providers) async {
    await SettingsStore.instance
        .setString(key, jsonEncode([for (final p in providers) p.toJson()]));
  }

  /// Add a custom provider and return it (with its generated id).
  static Future<DohProvider> add(String name, String url) async {
    final list = load();
    final provider = DohProvider(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      label: name.trim().isEmpty ? url.trim() : name.trim(),
      queryUrl: url.trim(),
      isCustom: true,
    );
    list.add(provider);
    await _save(list);
    return provider;
  }

  static Future<void> remove(String id) async {
    final list = load()..removeWhere((p) => p.id == id);
    await _save(list);
  }
}
