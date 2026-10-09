/// Safely extract origin from a URL.
/// Returns null for relative paths, malformed URLs, or URLs without a scheme.
String? safeOrigin(String? url) {
  if (url == null || url.isEmpty) return null;
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return null;
  try {
    return uri.origin;
  } catch (_) {
    return null;
  }
}

/// The path (+query+fragment) of [url] with any scheme/host dropped — mirrors
/// Tachiyomi/Mihon's `getUrlWithoutDomain`. A relative url returns its own path.
String urlWithoutDomain(String url) {
  try {
    final u = Uri.parse(url.replaceAll(' ', '%20'));
    var out = u.path;
    if (u.hasQuery && u.query.isNotEmpty) out += '?${u.query}';
    if (u.hasFragment && u.fragment.isNotEmpty) out += '#${u.fragment}';
    return out.isEmpty ? url : out;
  } catch (_) {
    return url;
  }
}

/// Re-home an item [url] onto [base]: strip any domain off [url] and append its
/// path to the source's CURRENT base URL — the way Mihon/Mangayomi build the
/// "Open in browser" URL. Robust to absolute-vs-relative storage and to a source
/// whose domain changed since the item was saved.
String rehomeUrl(String base, String url) {
  if (base.isEmpty) return url;
  final path = urlWithoutDomain(url);
  final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  final p = path.startsWith('/') ? path : '/$path';
  return '$b$p';
}

/// Join a possibly-relative item [path] onto a source [base] to form a
/// browsable URL. Absolute paths (already http/https) are returned unchanged.
/// This is the default "open in browser" URL for sources that don't know a
/// better one (manga/anime); LNReader overrides it with the plugin's resolveUrl.
String joinWebUrl(String base, String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (base.isEmpty) return path;
  try {
    return Uri.parse(base).resolve(path).toString();
  } catch (_) {
    if (path.startsWith('/')) return '$base$path';
    return base.endsWith('/') ? '$base$path' : '$base/$path';
  }
}
