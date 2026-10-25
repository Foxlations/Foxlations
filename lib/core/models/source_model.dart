/// FNV-1a (64-bit) over [seed].
///
/// Deliberately NOT `String.hashCode`: Dart makes no guarantee that it is
/// stable across runs or VM versions, and installed sources are persisted by
/// id - an id that changed between launches would orphan the user's installs.
String _stableHash(String seed) {
  var hash = 0xcbf29ce484222325;
  for (final unit in seed.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
  }
  return hash.toRadixString(16);
}

/// A manga source from our extension repository index.json.
/// Uses our own Foxlations format.
class MangaSource {
  final String id; // readable slug e.g. "mangadex-en"
  final String name;
  final String baseUrl;
  final String lang;
  final String framework; // "madara", "mangathemesia", "mangabox", "mmrcms", "nepnep", "custom"
  final String iconUrl;
  final String sourceCodeUrl;
  final String sourceCodeLanguage; // "dart" or "js"
  final String version;
  final bool isNsfw;
  final bool hasCloudflare;
  final String dateFormat;
  final String dateFormatLocale;
  final String apiUrl;
  final String appMinVerReq;
  final Map<String, dynamic> config;
  final String notes;
  final String repoUrl; // which repo this came from
  final String repoName; // friendly name of the repo
  final String itemType; // 'manga' or 'anime'

  const MangaSource({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.lang,
    required this.framework,
    required this.sourceCodeUrl,
    this.iconUrl = '',
    this.sourceCodeLanguage = 'dart',
    this.version = '0.1.0',
    this.isNsfw = false,
    this.hasCloudflare = false,
    this.dateFormat = '',
    this.dateFormatLocale = '',
    this.apiUrl = '',
    this.appMinVerReq = '0.0.1',
    this.config = const {},
    this.notes = '',
    this.repoUrl = '',
    this.repoName = '',
    this.itemType = 'manga',
  });

  /// Parse a source row from a repo index. Tolerant of two schemas:
  ///  - Foxlations: `itemType` string, `sourceCodeLanguage` string, `id` string.
  ///  - Mangayomi/keiyoushi: `itemType` int (0 manga / 1 anime / 2 novel) with an
  ///    `isManga` bool, `typeSource` (framework), `sourceCodeLanguage` int
  ///    (0 dart / 1 js), and a numeric `id`.
  /// [defaultType] is the content type inferred from the index filename (e.g.
  /// `anime_index.json` → anime), used when a row doesn't state its own type.
  factory MangaSource.fromJson(Map<String, dynamic> json, String repoUrl,
      {String repoName = '', String defaultType = 'manga'}) {
    String asStr(dynamic v, [String def = '']) =>
        v == null ? def : v.toString();
    bool asBool(dynamic v) => v is bool
        ? v
        : (v is int ? v != 0 : (v is String ? v.toLowerCase() == 'true' : false));

    // Two Kotlin-repo schemas to normalize:
    //  - Aniyomi / keiyoushi index.min.json stub: `pkg` + a bare `apk` filename.
    //  - keiyoushi FULL index.json: `packageName` + `resources.{apkUrl,jarUrl,
    //    iconUrl}` + `versionName`, with name/lang/baseUrl inside `sources[0]`.
    final pkgName = asStr(json['pkg']).isNotEmpty
        ? asStr(json['pkg'])
        : asStr(json['packageName']);
    final rawSources = json['sources'];
    final Map<String, dynamic>? firstSource =
        (rawSources is List && rawSources.isNotEmpty && rawSources.first is Map)
            ? Map<String, dynamic>.from(rawSources.first as Map)
            : null;
    final Map<String, dynamic>? resources = json['resources'] is Map
        ? Map<String, dynamic>.from(json['resources'] as Map)
        : null;
    // Prefer the top-level value; fall back to the first sub-source's.
    String field(String key, [String def = '']) {
      final v = json[key];
      if (v != null && v.toString().isNotEmpty) return v.toString();
      final fv = firstSource?[key];
      return (fv == null || fv.toString().isEmpty) ? def : fv.toString();
    }

    // Same, but tries several spellings - Mangayomi/Foxlations use `lang`/
    // `baseUrl`, while Aniyomi/keiyoushi sources use `language`/`homeUrl`. Read
    // all top-level keys first, then the first sub-source's, so an expanded
    // keiyoushi row (child `language`/`homeUrl` merged up) resolves correctly.
    String fieldMulti(List<String> keys, [String def = '']) {
      for (final k in keys) {
        final v = json[k];
        if (v != null && v.toString().isNotEmpty) return v.toString();
      }
      for (final k in keys) {
        final fv = firstSource?[k];
        if (fv != null && fv.toString().isNotEmpty) return fv.toString();
      }
      return def;
    }

    // keiyoushi tags every extension with a 3-value contentWarning enum
    // (CONTENT_WARNING_{SAFE,MIXED,NSFW}) - 100% of entries carry the field, so
    // treating any non-empty value as NSFW hid the entire catalogue behind the
    // "show NSFW" toggle. Only NSFW should hide; MIXED (e.g. MangaDex) and SAFE
    // stay visible. A free-text warning from another repo still counts if it
    // mentions NSFW/18+/adult.
    bool contentWarningIsNsfw() {
      final cw = asStr(json['contentWarning']).toUpperCase();
      return cw.contains('NSFW') || cw.contains('18+') || cw.contains('ADULT');
    }

    String parseItemType() {
      final it = json['itemType'];
      if (it is int) return it == 1 ? 'anime' : (it == 2 ? 'novel' : 'manga');
      if (it is String && it.trim().isNotEmpty) {
        final l = it.trim().toLowerCase();
        if (l == 'manga' || l == 'anime' || l == 'novel') return l;
        final n = int.tryParse(l);
        if (n != null) return n == 1 ? 'anime' : (n == 2 ? 'novel' : 'manga');
      }
      // Mangayomi flags anime rows with isManga=false (novels carry itemType=2).
      final isManga = json['isManga'];
      if (isManga is bool && !isManga) return 'anime';
      // Aniyomi/keiyoushi encode the type in the package name.
      final pkg = pkgName.toLowerCase();
      if (pkg.contains('animeextension')) return 'anime';
      if (pkg.contains('novelextension')) return 'novel';
      // Nothing on the row - fall back to the type implied by the index file.
      return defaultType;
    }

    // Tachiyomi/Aniyomi/keiyoushi rows are compiled Kotlin - they carry an `apk`
    // filename, a `resources.jarUrl`, or an `eu.kanade.tachiyomi.*` package, and
    // run in the embedded JVM (not the JS/Dart interpreters).
    bool looksKotlin() {
      final apk = asStr(json['apk']);
      final hasRes = resources != null &&
          (resources['jarUrl'] != null || resources['apkUrl'] != null);
      return apk.isNotEmpty ||
          hasRes ||
          pkgName.startsWith('eu.kanade.tachiyomi');
    }

    String parseSourceLang() {
      if (looksKotlin()) return 'kotlin';
      final scl = json['sourceCodeLanguage'];
      if (scl is int) return scl == 1 ? 'js' : 'dart';
      if (scl is String && scl.trim().isNotEmpty) {
        final l = scl.trim().toLowerCase();
        if (l == 'kotlin') return 'kotlin';
        return l == '1' ? 'js' : (l == '0' ? 'dart' : l);
      }
      return 'dart';
    }

    // Anime/keiyoushi repos serve the artifact next to the index - an Aniyomi
    // `apk` at `<repo-dir>/apk/<apk>`, keiyoushi a full `resources.jarUrl`. Stash
    // the download URL + package on config so installSource can fetch + convert.
    Map<String, dynamic> buildConfig() {
      final base = (json['config'] as Map<String, dynamic>?) ?? <String, dynamic>{};
      final cfg = Map<String, dynamic>.from(base);
      if (pkgName.isNotEmpty) cfg['pkg'] = pkgName;
      // keiyoushi index.json: full jar/apk URLs under `resources`.
      if (resources?['jarUrl'] != null) cfg['jarUrl'] = resources!['jarUrl'].toString();
      if (resources?['apkUrl'] != null) {
        cfg['apkUrl'] = resources!['apkUrl'].toString();
      } else {
        // Aniyomi index.min.json: a bare `apk` filename at `<repo-dir>/apk/<apk>`.
        final apk = asStr(json['apk']);
        if (apk.isNotEmpty) {
          if (apk.startsWith('http')) {
            cfg['apkUrl'] = apk;
          } else {
            final slash = repoUrl.lastIndexOf('/');
            final dir = slash <= 0 ? repoUrl : repoUrl.substring(0, slash);
            cfg['apkUrl'] = '$dir/apk/$apk';
          }
        }
      }
      return cfg;
    }

    // Tachiyomi/keiyoushi index entries carry NO top-level `id` - the real id
    // lives inside their `sources[]` array. Without a fallback every row parsed
    // to id '', so they all collided and installing one flipped the entire
    // catalogue to "installed". Derive a stable id from whatever identifies the
    // row instead.
    String resolveId() {
      final explicit = asStr(json['id']);
      if (explicit.isNotEmpty) return explicit;
      final seed = [
        pkgName,
        field('name'),
        field('lang'),
        field('baseUrl'),
      ].where((e) => e.isNotEmpty).join('|');
      return seed.isEmpty ? '' : _stableHash(seed);
    }

    // Where to find this source's icon.
    //
    // Mangayomi-style indexes carry `iconUrl` outright. Tachiyomi-style ones
    // (keiyoushi and its forks) carry none at all - 0 of keiyoushi's 1368
    // entries have the field - but they publish icons next to the index at
    // `<repo-root>/icon/<pkg>.png`, so derive it from the index URL. Left empty
    // when neither applies: the site's own favicon is an unreliable fallback
    // (sampled hosts returned 403 and 404 as often as an image), and the letter
    // tile the UI already draws beats a broken image.
    String resolveIconUrl() {
      final explicit = asStr(json['iconUrl']);
      if (explicit.isNotEmpty) return explicit;
      // keiyoushi index.json ships a full iconUrl under resources.
      if (resources?['iconUrl'] != null) return resources!['iconUrl'].toString();
      if (pkgName.isEmpty || repoUrl.isEmpty) return '';
      final slash = repoUrl.lastIndexOf('/');
      if (slash <= 0) return '';
      return '${repoUrl.substring(0, slash)}/icon/$pkgName.png';
    }

    // LNReader novel plugins: a flat row {id,name,site,lang,version,url(.js),
    // iconUrl} with none of the app/keiyoushi/mangayomi markers. Detect by shape
    // so they're categorised as novels and their JS url becomes the code url.
    final isLNReader = asStr(json['sourceCodeUrl']).isEmpty &&
        json['apk'] == null &&
        json['sources'] == null &&
        json['resources'] == null &&
        json['itemType'] == null &&
        json['sourceCodeLanguage'] == null &&
        json['baseUrl'] == null &&
        json['site'] != null &&
        asStr(json['url']).toLowerCase().endsWith('.js');

    // Recover the repo the source came from: an explicitly-passed value wins,
    // then the persisted json field, then derive a name from the URL (so an
    // installed source saved before repoName existed still shows its repo, not
    // the "custom" framework fallback).
    final effectiveRepoUrl =
        repoUrl.isNotEmpty ? repoUrl : asStr(json['repoUrl']);
    var effectiveRepoName =
        repoName.isNotEmpty ? repoName : asStr(json['repoName']);
    if (effectiveRepoName.isEmpty) {
      effectiveRepoName = repoNameFromUrl(effectiveRepoUrl);
    }

    return MangaSource(
      id: resolveId(),
      name: field('name', 'Unknown'),
      baseUrl: isLNReader ? asStr(json['site']) : fieldMulti(const ['baseUrl', 'homeUrl']),
      lang: normalizeLang(fieldMulti(const ['lang', 'language'], 'en')),
      framework: isLNReader ? 'LNReader' : asStr(json['framework'] ?? json['typeSource'], 'custom'),
      iconUrl: resolveIconUrl(),
      sourceCodeUrl: isLNReader ? asStr(json['url']) : asStr(json['sourceCodeUrl']),
      sourceCodeLanguage: isLNReader ? 'js' : parseSourceLang(),
      version: asStr(json['version']).isNotEmpty
          ? asStr(json['version'])
          : asStr(json['versionName'], '0.1.0'),
      isNsfw: asBool(json['isNsfw']) ||
          asBool(json['nsfw']) ||
          contentWarningIsNsfw(),
      hasCloudflare: asBool(json['hasCloudflare']),
      dateFormat: asStr(json['dateFormat']),
      dateFormatLocale: asStr(json['dateFormatLocale']),
      apiUrl: asStr(json['apiUrl']),
      appMinVerReq: asStr(json['appMinVerReq'], '0.0.1'),
      config: buildConfig(),
      notes: asStr(json['notes']),
      repoUrl: effectiveRepoUrl,
      repoName: effectiveRepoName,
      itemType: isLNReader ? 'novel' : parseItemType(),
    );
  }

  /// A friendly repo name derived from a repo URL - git hosts name the repo
  /// after its owner (keiyoushi, yuzono, …), which is what users recognise.
  /// Mirrors RepoService so a source can recover its repo name from the stored
  /// URL alone (installed sources persisted before repoName was saved otherwise
  /// fell back to the framework, i.e. "custom").
  static String repoNameFromUrl(String url) {
    if (url.isEmpty) return '';
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();
      if (host.isEmpty) return '';
      const gitHosts = {
        'raw.githubusercontent.com',
        'github.com',
        'gitlab.com',
        'codeberg.org',
      };
      if (gitHosts.contains(host) && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.first;
      }
      return host.startsWith('www.') ? host.substring(4) : host;
    } catch (_) {
      return '';
    }
  }

  /// Canonicalise a source's language to an ISO 639-1 code.
  ///
  /// Repos label languages inconsistently: Tachiyomi/keiyoushi-style indexes use
  /// ISO codes (`en`, `es`), while LNReader's `plugins.min.json` uses display
  /// names (`English`, `Español`) and even multi-name strings (`中文, 汉语, 漢語`).
  /// Left as-is, the Browse language filter shows the SAME language as two
  /// separate chips (`EN` and `ENGLISH`) and hides half the sources behind each.
  /// Collapsing everything to one code fixes the filter and the chips. Unknown
  /// values fall through lowercased so they at least group consistently.
  static String normalizeLang(String raw) {
    var s = raw.trim().toLowerCase();
    if (s.isEmpty) return 'en';
    if (s == 'all' || s == 'multi') return s;
    // LNReader multi-name strings (e.g. "中文, 汉语, 漢語"): take the first name.
    if (s.contains(',')) s = s.split(',').first.trim();
    // Already an ISO code, optionally with a region/script suffix (es-419,
    // zh-hant, pt-br): canonicalise to base[-region] and KEEP the region, so
    // distinct scripts/regions (Traditional vs Simplified Chinese) stay apart.
    final code = RegExp(r'^([a-z]{2,3})(?:[-_]([a-z0-9]{2,4}))?$').firstMatch(s);
    if (code != null) {
      final region = code.group(2);
      return region == null ? code.group(1)! : '${code.group(1)}-$region';
    }
    // Otherwise it's a native display name (English, Español, 日本語, Bahasa
    // Indonesia) - map to its base code. Display names carry no region.
    const byName = {
      'english': 'en',
      'spanish': 'es', 'español': 'es', 'espanol': 'es', 'castellano': 'es',
      'chinese': 'zh', '中文': 'zh', '汉语': 'zh', '漢語': 'zh', '简体中文': 'zh',
      '繁體中文': 'zh', '官话': 'zh',
      'arabic': 'ar', 'العربية': 'ar',
      'indonesian': 'id', 'bahasa indonesia': 'id',
      'vietnamese': 'vi', 'tiếng việt': 'vi', 'tieng viet': 'vi',
      'portuguese': 'pt', 'português': 'pt', 'portugues': 'pt',
      'french': 'fr', 'français': 'fr', 'francais': 'fr',
      'german': 'de', 'deutsch': 'de',
      'italian': 'it', 'italiano': 'it',
      'russian': 'ru', 'русский': 'ru',
      'japanese': 'ja', '日本語': 'ja',
      'korean': 'ko', '한국어': 'ko', '조선말': 'ko',
      'turkish': 'tr', 'türkçe': 'tr', 'turkce': 'tr',
      'polish': 'pl', 'polski': 'pl',
      'ukrainian': 'uk', 'українська': 'uk',
      'thai': 'th', 'ไทย': 'th',
      'persian': 'fa', 'farsi': 'fa', 'فارسی': 'fa',
      'hindi': 'hi', 'हिन्दी': 'hi',
      'dutch': 'nl', 'nederlands': 'nl',
      'filipino': 'fil', 'tagalog': 'fil',
    };
    // Unknown display name: keep it (lowercased) so it at least groups together.
    return byName[s] ?? s;
  }

  /// A friendly display name for a (normalized) language code, for filter chips
  /// and badges. Unknown codes fall back to their upper-cased form.
  static String languageName(String code) {
    final c = code.trim().toLowerCase();
    if (c == 'all') return 'All';
    if (c == 'multi') return 'Multi-language';
    const names = {
      'en': 'English', 'es': 'Spanish', 'zh': 'Chinese', 'ar': 'Arabic',
      'id': 'Indonesian', 'vi': 'Vietnamese', 'pt': 'Portuguese',
      'fr': 'French', 'de': 'German', 'it': 'Italian', 'ru': 'Russian',
      'ja': 'Japanese', 'ko': 'Korean', 'tr': 'Turkish', 'pl': 'Polish',
      'uk': 'Ukrainian', 'th': 'Thai', 'fa': 'Persian', 'hi': 'Hindi',
      'nl': 'Dutch', 'fil': 'Filipino', 'ms': 'Malay', 'bn': 'Bengali',
      'cs': 'Czech', 'ro': 'Romanian', 'hu': 'Hungarian', 'el': 'Greek',
      'he': 'Hebrew', 'sv': 'Swedish', 'da': 'Danish', 'fi': 'Finnish',
      'no': 'Norwegian', 'uz': 'Uzbek', 'ca': 'Catalan', 'sr': 'Serbian',
    };
    // Kept region/script variants (es-419, zh-hant, pt-br): "Base (Region)".
    const regions = {
      '419': 'Latin America', 'br': 'Brazil', 'mx': 'Mexico', 'ar': 'Argentina',
      'es': 'Spain', 'hant': 'Traditional', 'hans': 'Simplified',
      'hk': 'Hong Kong', 'tw': 'Taiwan', 'cn': 'China', 'pt': 'Portugal',
      'us': 'US', 'gb': 'UK', 'kr': '', 'rhk': 'Hong Kong',
    };
    final m = RegExp(r'^([a-z]{2,3})[-_]([a-z0-9]{2,4})$').firstMatch(c);
    if (m != null) {
      final b = names[m.group(1)] ?? m.group(1)!.toUpperCase();
      final r = regions[m.group(2)!] ?? m.group(2)!.toUpperCase();
      return r.isEmpty ? b : '$b ($r)';
    }
    return names[c] ?? c.toUpperCase();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'baseUrl': baseUrl,
        'lang': lang,
        'framework': framework,
        'iconUrl': iconUrl,
        'sourceCodeUrl': sourceCodeUrl,
        'sourceCodeLanguage': sourceCodeLanguage,
        'version': version,
        'isNsfw': isNsfw,
        'hasCloudflare': hasCloudflare,
        'dateFormat': dateFormat,
        'dateFormatLocale': dateFormatLocale,
        'apiUrl': apiUrl,
        'appMinVerReq': appMinVerReq,
        'config': config,
        'notes': notes,
        'itemType': itemType,
        'repoUrl': repoUrl,
        'repoName': repoName,
      };

  MangaSource copyWith({
    Map<String, dynamic>? config,
    String? itemType,
    String? sourceCodeLanguage,
    String? baseUrl,
  }) {
    return MangaSource(
      id: id,
      name: name,
      baseUrl: baseUrl ?? this.baseUrl,
      lang: lang,
      framework: framework,
      iconUrl: iconUrl,
      sourceCodeUrl: sourceCodeUrl,
      sourceCodeLanguage: sourceCodeLanguage ?? this.sourceCodeLanguage,
      version: version,
      isNsfw: isNsfw,
      hasCloudflare: hasCloudflare,
      dateFormat: dateFormat,
      dateFormatLocale: dateFormatLocale,
      apiUrl: apiUrl,
      appMinVerReq: appMinVerReq,
      config: config ?? this.config,
      notes: notes,
      repoUrl: repoUrl,
      repoName: repoName,
      itemType: itemType ?? this.itemType,
    );
  }

  bool get isKotlinBased => sourceCodeLanguage == 'kotlin';

  String get displayName => name;
  bool get hasSourceCode => sourceCodeUrl.isNotEmpty;
  bool get isJsBased => sourceCodeLanguage == 'js' || sourceCodeLanguage == 'javascript';
  bool get isDartBased => sourceCodeLanguage == 'dart';
  bool get isAnime => itemType == 'anime';
  bool get isNovel => itemType == 'novel';
}
