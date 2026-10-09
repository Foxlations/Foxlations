import 'model/filter.dart';
import 'model/m_manga.dart';
import 'model/m_pages.dart';
import 'model/m_video.dart';
import 'model/page_url.dart';
import 'model/source_preference.dart';

abstract interface class ExtensionService {
  String get sourceBaseUrl;
  bool get supportsLatest;

  void dispose();

  Map<String, String> getHeaders();

  Future<MPages> getPopular(int page);

  Future<MPages> getLatestUpdates(int page);

  Future<MPages> search(String query, int page, List<dynamic> filters);

  /// [fullChapters] false = a lightweight fetch that only needs the NEWEST
  /// chapters (used by library update checks); true = the complete list (the
  /// detail screen). Only matters for paginated sources (LNReader novels).
  Future<MManga> getDetail(String url, {bool fullChapters = true});

  Future<List<PageUrl>> getPageList(String url);

  Future<List<MVideo>> getVideoList(String url);

  /// Browsable named listings/categories (e.g. tube-site categories). Each is
  /// `{name, link}` where `link` is a listing URL. Empty if the source has none.
  Future<List<Map<String, String>>> getCategories();

  /// Fetch the listing at an arbitrary [listingUrl] (used to drill into a
  /// category). Reuses the source's own listing parser.
  Future<MPages> getListing(String listingUrl, int page);

  /// For novel sources: the chapter's HTML/text content at [url]. Empty for
  /// non-novel sources.
  Future<String> getHtmlContent(String url);

  /// The source's own browsable page URL for an item ("Open in browser"), given
  /// its stored url/path. LNReader uses the plugin's `resolveUrl`; manga/anime
  /// re-home the path onto the current base URL (Mihon-style). Resolved on
  /// demand so it's correct even for a library item shown from cache before a
  /// refresh. Returns null if it can't be determined (caller falls back).
  Future<String?> getWebUrl(String url);

  FilterList getFilterList();

  /// The source's declared preferences. Synchronous for in-process (JS/Dart)
  /// sources whose code runs here; host-backed (Kotlin) sources return a cache
  /// that [fetchSourcePreferences] fills, so prefer that for a fresh read.
  List<SourcePreference> getSourcePreferences();

  /// Fetch the source's preference schema, awaiting the host when needed. JS/Dart
  /// return [getSourcePreferences] immediately; Kotlin round-trips to the extension
  /// runtime (ConfigurableSource.setupPreferenceScreen). Returns [] if unsupported.
  Future<List<SourcePreference>> fetchSourcePreferences();

  /// Persist one preference so the source itself reads it. JS/Dart sources read
  /// from the app's own store (written by the settings UI), so this is a no-op for
  /// them; Kotlin sources read from their runtime store, so this writes there.
  Future<void> setSourcePreference(String key, dynamic value);
}
