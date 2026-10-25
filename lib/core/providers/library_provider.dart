import 'package:flutter/foundation.dart' hide Category;
import '../models/manga_model.dart';
import '../models/chapter_model.dart';
import '../models/category_model.dart';
import '../services/library_service.dart';
import '../services/settings_store.dart';
import 'incognito_provider.dart';
import 'library_like.dart';

class LibraryProvider extends ChangeNotifier implements LibraryLike {
  final LibraryService _libraryService = LibraryService();
  List<LibraryManga> _manga = [];
  List<Category> _categories = [];
  bool _initialized = false;

  @override
  List<LibraryManga> get manga => _manga;
  List<Category> get categories => _categories;
  bool get initialized => _initialized;

  Future<void> initialize() async {
    await _libraryService.init();
    _manga = _libraryService.getAllManga();
    _categories = _libraryService.getCategories();
    // Reading Insights counts active time only now, so strip any estimate-seeded
    // time left by older builds (idempotent; see purgeEstimatedReadTime).
    await _libraryService.purgeEstimatedReadTime();
    _initialized = true;
    notifyListeners();
  }

  /// Re-read the library from disk (e.g. after a backup restore wrote directly
  /// to the Hive boxes) without re-initializing the service.
  Future<void> reload() async {
    _manga = _libraryService.getAllManga();
    _categories = _libraryService.getCategories();
    // Strip any estimate-seeded time a restore may have brought in (idempotent).
    await _libraryService.purgeEstimatedReadTime();
    notifyListeners();
  }

  // ── Category management ─────────────────────────────────────
  Future<void> addCategory(String name) async {
    await _libraryService.addCategory(name);
    _categories = _libraryService.getCategories();
    notifyListeners();
  }

  Future<void> removeCategory(String name) async {
    await _libraryService.removeCategory(name);
    _categories = _libraryService.getCategories();
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  Future<void> reorderCategories(List<String> orderedNames) async {
    await _libraryService.reorderCategories(orderedNames);
    _categories = _libraryService.getCategories();
    notifyListeners();
  }

  Future<void> renameCategory(String oldName, String newName) async {
    await _libraryService.renameCategory(oldName, newName);
    _categories = _libraryService.getCategories();
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  Future<void> setMangaCategories(String sourceId, String url, List<String> cats) async {
    final manga = _libraryService.getManga(sourceId, url);
    if (manga != null) {
      manga.categories = cats;
      await _libraryService.updateManga(manga);
      _manga = _libraryService.getAllManga();
      notifyListeners();
    }
  }

  /// Set a library entry's cover to a local image file (reader "Set as cover").
  /// Returns false if the manga isn't in the library.
  Future<bool> setCover(String sourceId, String url, String coverPath) async {
    final ok = await _libraryService.setCover(sourceId, url, coverPath);
    if (ok) {
      _manga = _libraryService.getAllManga();
      notifyListeners();
    }
    return ok;
  }

  /// Set a cover to a raw (http) URL WITHOUT reloading/notifying - for the
  /// batch "Refresh library covers" run, which calls reload() once at the end.
  /// Unlike [setCover] this stores the URL as-is (no file:// local-override).
  Future<void> setCoverUrlQuiet(String sourceId, String url, String coverUrl) async {
    final m = _libraryService.getManga(sourceId, url);
    if (m == null) return;
    m.coverUrl = coverUrl;
    await _libraryService.updateManga(m);
  }

  @override
  bool isInLibrary(String sourceId, String url) {
    return _libraryService.isInLibrary(sourceId, url);
  }

  Future<void> addToLibrary(LibraryManga manga) async {
    await _libraryService.addManga(manga);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Categories a brand-new library entry should be filed into, honouring the
  /// "Default category" preference (Settings → Library). Returns the configured
  /// category as a single-element list when it's set AND still exists among the
  /// current [categories]; otherwise `const []`, meaning "always ask" - the
  /// caller's existing add-flow behaviour. Synchronous: reads the already-loaded
  /// [categories] list and the sync SettingsStore getter.
  List<String> defaultCategoriesForNewEntry() {
    final name = SettingsStore.instance.getString('lib_default_category') ?? '';
    if (name.isEmpty) return const [];
    return _categories.any((c) => c.name == name) ? [name] : const [];
  }

  /// Cache the source's browsable URL on this entry (for instant cold-start
  /// "Open in WebView"). Quiet - no notify, it's a background detail.
  Future<void> setWebUrl(String sourceId, String url, String? webUrl) =>
      _libraryService.setWebUrl(sourceId, url, webUrl);

  Future<void> removeFromLibrary(String sourceId, String url) async {
    await _libraryService.removeManga(sourceId, url);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Full chapter objects (with read state) for an entry, for moving to vault.
  List<LibraryChapter> fullChapters(String sourceId, String url) =>
      _libraryService.getFullChapters(sourceId, url);

  /// Adds an entry and its chapters, preserving read progress (for vault moves).
  Future<void> addEntryWithChapters(
      LibraryManga manga, List<LibraryChapter> chapters) async {
    await _libraryService.addEntryWithChapters(manga, chapters);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Bulk add - one reload + one notify for the whole batch (vs per-item).
  Future<void> addEntriesWithChaptersBulk(
      List<(LibraryManga, List<LibraryChapter>)> entries) async {
    for (final (m, ch) in entries) {
      await _libraryService.addEntryWithChapters(m, ch);
    }
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Bulk remove - one reload + one notify for the whole batch.
  Future<void> removeMangaBulk(List<(String, String)> keys) async {
    for (final (sid, url) in keys) {
      await _libraryService.removeManga(sid, url);
    }
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  Future<void> markAllReadBulk(List<(String, String)> keys) async {
    for (final (sid, url) in keys) {
      await _libraryService.markAllChaptersRead(sid, url);
    }
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  Future<void> markAllUnreadBulk(List<(String, String)> keys) async {
    for (final (sid, url) in keys) {
      await _libraryService.markAllChaptersUnread(sid, url);
    }
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  Future<void> setMangaCategoriesBulk(
      List<(String, String, List<String>)> items) async {
    for (final (sid, url, cats) in items) {
      final m = _libraryService.getManga(sid, url);
      if (m != null) {
        m.categories = cats;
        await _libraryService.updateManga(m);
      }
    }
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Re-link entries stranded on a source name (from a restore before the source
  /// was installed) onto the now-installed source id. Returns how many healed.
  Future<int> relinkSources(Map<String, String> installedIdToName) async {
    final n = await _libraryService.relinkSources(installedIdToName);
    if (n > 0) {
      _manga = _libraryService.getAllManga();
      notifyListeners();
    }
    return n;
  }

  @override
  Future<void> updateReadingProgress(
    String sourceId,
    String mangaUrl,
    String chapterUrl,
    int page,
  ) async {
    // Incognito: read privately - don't persist position (keeps it out of
    // "continue reading" and off any trackers).
    if (IncognitoProvider.active) return;
    // Persist only - this fires on every page turn, and the saved page/chapter
    // isn't shown live in the library, so reloading the whole list + notifying
    // here just rebuilt the (off-screen) library on every flip. The in-memory
    // entry is updated so a later reload reflects it; the detail screen's
    // Resume refreshes when it reopens.
    await _libraryService.updateReadingProgress(
        sourceId, mangaUrl, chapterUrl, page);
  }

  /// Accumulate active read/watch time (Reading Insights). Quiet/persist-only - 
  /// fires on a timer while reading, so it must not rebuild the library. Not
  /// tracked while reading privately (incognito).
  @override
  Future<void> addReadTime(String sourceId, String mangaUrl, int seconds) async {
    if (IncognitoProvider.active) return;
    await _libraryService.addReadTime(sourceId, mangaUrl, seconds);
  }

  /// Persist novel reading position (scroll offset + reflow-safe fraction).
  @override
  Future<void> updateNovelProgress(
    String sourceId,
    String mangaUrl,
    String chapterUrl,
    int offset,
    double fraction,
  ) async {
    if (IncognitoProvider.active) return;
    await _libraryService.updateNovelProgress(
        sourceId, mangaUrl, chapterUrl, offset, fraction);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Persist anime playback position (seconds). Called on a ~5s throttle during
  /// playback (notify off, to avoid rebuilding the library mid-watch) and once on exit
  /// (notify on, so the detail screen's Resume button updates).
  @override
  Future<void> updateEpisodeProgress(
    String sourceId,
    String mangaUrl,
    String episodeUrl,
    int positionSeconds, {
    int totalSeconds = 0,
    bool notify = false,
  }) async {
    if (IncognitoProvider.active) return;
    await _libraryService.updateEpisodeProgress(
        sourceId, mangaUrl, episodeUrl, positionSeconds,
        totalSeconds: totalSeconds);
    if (notify) {
      _manga = _libraryService.getAllManga();
      notifyListeners();
    }
  }

  /// Saved playback position (seconds) for an episode, or 0 if none.
  @override
  int episodeLastPosition(String sourceId, String episodeUrl) =>
      _libraryService.episodeLastPosition(sourceId, episodeUrl);

  @override
  Future<void> markChapterRead(
      String sourceId, String mangaUrl, String chapterUrl,
      {bool active = false}) async {
    await _libraryService.markChapterRead(sourceId, mangaUrl, chapterUrl,
        active: active);
    notifyListeners();
  }

  /// Mark a batch of chapter URLs read with a single notify (used when a migrate
  /// replays an entry's read history onto the new source).
  Future<void> markChaptersRead(
      String sourceId, String mangaUrl, List<String> chapterUrls) async {
    if (chapterUrls.isEmpty) return;
    await _libraryService.markChaptersRead(sourceId, mangaUrl, chapterUrls);
    notifyListeners();
  }

  @override
  bool isChapterRead(String sourceId, String chapterUrl) {
    return _libraryService.isChapterRead(sourceId, chapterUrl);
  }

  /// Unread-chapter count for [m]'s library badge, from actual cached read-state
  /// (see [LibraryService.unreadCount]) so it can't stick at "99+".
  int unreadForManga(LibraryManga m) =>
      _libraryService.unreadCount(m.sourceId, m.url);

  /// Read-chapter count for [m] from ground-truth read state (see
  /// [LibraryService.readCount]) - used by the update skip rules so manual or
  /// imported read marks count even if the denormalized counter drifted.
  int readCountForManga(LibraryManga m) =>
      _libraryService.readCount(m.sourceId, m.url);

  /// Chapters ACTIVELY read in-app for [m] - the gamified stats' ground truth,
  /// unaffected by bulk "mark all" (see [LibraryService.activeReadCount]).
  int activeReadCountForManga(LibraryManga m) =>
      _libraryService.activeReadCount(m.sourceId, m.url);

  /// Monotonic counter bumped on EVERY notify. The library screen memoizes its
  /// filtered/sorted list and reads this to know when to recompute: over-bumping
  /// is safe (forces a recompute), under-bumping would show a stale list. Covers
  /// in-place changes (badge pings, mid-update chapter writes) where the [_manga]
  /// list identity is unchanged.
  int _dataVersion = 0;
  int get dataVersion => _dataVersion;

  @override
  void notifyListeners() {
    _dataVersion++;
    super.notifyListeners();
  }

  /// Notify listeners WITHOUT rebuilding the [_manga] list. Library cards read
  /// their unread/read counts straight from the service (the chapter box), so a
  /// bare notify is enough to refresh badges live mid-update - far cheaper than
  /// a full reload per entry.
  void pingListeners() => notifyListeners();

  @override
  Future<void> markChapterUnread(
      String sourceId, String mangaUrl, String chapterUrl) async {
    await _libraryService.markChapterUnread(sourceId, mangaUrl, chapterUrl);
    notifyListeners();
  }

  // ── Chapter cache ─────────────────────────────────────────
  @override
  Future<void> cacheChapters(String sourceId, String mangaUrl, List<Map<String, dynamic>> chapters) async {
    final libChapters = chapters.map((c) => LibraryChapter(
      sourceId: sourceId,
      mangaUrl: mangaUrl,
      chapterUrl: c['url'] as String? ?? '',
      title: c['name'] as String? ?? '',
      dateUpload: c['dateUpload'] as String?,
      chapterNumber: (c['chapterNumber'] as num?)?.toDouble(),
    )).toList();
    await _cacheAndStampIfNew(sourceId, mangaUrl, libChapters);

    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Cache chapters WITHOUT reloading the whole library or notifying listeners.
  /// Used by the bulk library-update pass, which caches for many entries and
  /// then reloads/notifies ONCE at the end - a per-entry reload+notify is
  /// O(N) each (so O(N²) over the run) and rebuilds the whole grid every item.
  Future<void> cacheChaptersQuiet(String sourceId, String mangaUrl,
      List<Map<String, dynamic>> chapters) async {
    final libChapters = chapters
        .map((c) => LibraryChapter(
              sourceId: sourceId,
              mangaUrl: mangaUrl,
              chapterUrl: c['url'] as String? ?? '',
              title: c['name'] as String? ?? '',
              dateUpload: c['dateUpload'] as String?,
              chapterNumber: (c['chapterNumber'] as num?)?.toDouble(),
            ))
        .toList();
    await _cacheAndStampIfNew(sourceId, mangaUrl, libChapters);
  }

  /// Caches [libChapters] and stamps `lastChapterFetchAt` ONLY when the list
  /// gained chapters not already cached - so the "Chapter fetch date" sort
  /// reflects when NEW chapters actually arrived, not merely when the app last
  /// checked for updates (an update that finds nothing must not bump the date).
  Future<void> _cacheAndStampIfNew(String sourceId, String mangaUrl,
      List<LibraryChapter> libChapters) async {
    final existingUrls = _libraryService
        .getCachedChapters(sourceId, mangaUrl)
        .map((c) => c.chapterUrl)
        .toSet();
    final hasNew = libChapters.any((c) => !existingUrls.contains(c.chapterUrl));
    await _libraryService.cacheChapters(sourceId, mangaUrl, libChapters);
    if (!hasNew) return;
    final entry = _libraryService.getManga(sourceId, mangaUrl);
    if (entry != null) {
      entry.lastChapterFetchAt = DateTime.now();
      await entry.save();
    }
  }

  @override
  List<LibraryChapter> getCachedChapters(String sourceId, String mangaUrl) {
    return _libraryService.getCachedChapters(sourceId, mangaUrl);
  }

  @override
  Future<void> markAllRead(String sourceId, String url) async {
    await _libraryService.markAllChaptersRead(sourceId, url);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  @override
  Future<void> markAllUnread(String sourceId, String url) async {
    await _libraryService.markAllChaptersUnread(sourceId, url);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  // ── Reading stats ──────────────────────────────────────────────────
  Map<DateTime, int> getReadActivityByDay({int days = 365, Set<String>? sourceIds}) =>
      _libraryService.getReadActivityByDay(days: days, sourceIds: sourceIds);

  int getCurrentReadingStreak({Set<String>? sourceIds}) =>
      _libraryService.getCurrentReadingStreak(sourceIds: sourceIds);
  int getLongestReadingStreak({Set<String>? sourceIds}) =>
      _libraryService.getLongestReadingStreak(sourceIds: sourceIds);
}
