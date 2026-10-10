import 'package:flutter/foundation.dart' hide Category;
import '../models/manga_model.dart';
import '../models/chapter_model.dart';
import '../models/category_model.dart';
import '../services/library_service.dart';
import 'incognito_provider.dart';

class LibraryProvider extends ChangeNotifier {
  final LibraryService _libraryService = LibraryService();
  List<LibraryManga> _manga = [];
  List<Category> _categories = [];
  bool _initialized = false;

  List<LibraryManga> get manga => _manga;
  List<Category> get categories => _categories;
  bool get initialized => _initialized;

  Future<void> initialize() async {
    await _libraryService.init();
    _manga = _libraryService.getAllManga();
    _categories = _libraryService.getCategories();
    _initialized = true;
    notifyListeners();
  }

  /// Re-read the library from disk (e.g. after a backup restore wrote directly
  /// to the Hive boxes) without re-initializing the service.
  Future<void> reload() async {
    _manga = _libraryService.getAllManga();
    _categories = _libraryService.getCategories();
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

  /// Set a cover to a raw (http) URL WITHOUT reloading/notifying — for the
  /// batch "Refresh library covers" run, which calls reload() once at the end.
  /// Unlike [setCover] this stores the URL as-is (no file:// local-override).
  Future<void> setCoverUrlQuiet(String sourceId, String url, String coverUrl) async {
    final m = _libraryService.getManga(sourceId, url);
    if (m == null) return;
    m.coverUrl = coverUrl;
    await _libraryService.updateManga(m);
  }

  bool isInLibrary(String sourceId, String url) {
    return _libraryService.isInLibrary(sourceId, url);
  }

  Future<void> addToLibrary(LibraryManga manga) async {
    await _libraryService.addManga(manga);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Cache the source's browsable URL on this entry (for instant cold-start
  /// "Open in WebView"). Quiet — no notify, it's a background detail.
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

  /// Bulk add — one reload + one notify for the whole batch (vs per-item).
  Future<void> addEntriesWithChaptersBulk(
      List<(LibraryManga, List<LibraryChapter>)> entries) async {
    for (final (m, ch) in entries) {
      await _libraryService.addEntryWithChapters(m, ch);
    }
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Bulk remove — one reload + one notify for the whole batch.
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

  Future<void> updateReadingProgress(
    String sourceId,
    String mangaUrl,
    String chapterUrl,
    int page,
  ) async {
    // Incognito: read privately — don't persist position (keeps it out of
    // "continue reading" and off any trackers).
    if (IncognitoProvider.active) return;
    // Persist only — this fires on every page turn, and the saved page/chapter
    // isn't shown live in the library, so reloading the whole list + notifying
    // here just rebuilt the (off-screen) library on every flip. The in-memory
    // entry is updated so a later reload reflects it; the detail screen's
    // Resume refreshes when it reopens.
    await _libraryService.updateReadingProgress(
        sourceId, mangaUrl, chapterUrl, page);
  }

  /// Persist novel reading position (scroll offset + reflow-safe fraction).
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
  int episodeLastPosition(String sourceId, String episodeUrl) =>
      _libraryService.episodeLastPosition(sourceId, episodeUrl);

  Future<void> markChapterRead(
      String sourceId, String mangaUrl, String chapterUrl) async {
    await _libraryService.markChapterRead(sourceId, mangaUrl, chapterUrl);
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

  bool isChapterRead(String sourceId, String chapterUrl) {
    return _libraryService.isChapterRead(sourceId, chapterUrl);
  }

  /// Unread-chapter count for [m]'s library badge, from actual cached read-state
  /// (see [LibraryService.unreadCount]) so it can't stick at "99+".
  int unreadForManga(LibraryManga m) =>
      _libraryService.unreadCount(m.sourceId, m.url);

  Future<void> markChapterUnread(
      String sourceId, String mangaUrl, String chapterUrl) async {
    await _libraryService.markChapterUnread(sourceId, mangaUrl, chapterUrl);
    notifyListeners();
  }

  // ── Chapter cache ─────────────────────────────────────────
  Future<void> cacheChapters(String sourceId, String mangaUrl, List<Map<String, dynamic>> chapters) async {
    final libChapters = chapters.map((c) => LibraryChapter(
      sourceId: sourceId,
      mangaUrl: mangaUrl,
      chapterUrl: c['url'] as String? ?? '',
      title: c['name'] as String? ?? '',
      dateUpload: c['dateUpload'] as String?,
    )).toList();
    await _cacheAndStampIfNew(sourceId, mangaUrl, libChapters);

    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

  /// Cache chapters WITHOUT reloading the whole library or notifying listeners.
  /// Used by the bulk library-update pass, which caches for many entries and
  /// then reloads/notifies ONCE at the end — a per-entry reload+notify is
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
            ))
        .toList();
    await _cacheAndStampIfNew(sourceId, mangaUrl, libChapters);
  }

  /// Caches [libChapters] and stamps `lastChapterFetchAt` ONLY when the list
  /// gained chapters not already cached — so the "Chapter fetch date" sort
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

  List<LibraryChapter> getCachedChapters(String sourceId, String mangaUrl) {
    return _libraryService.getCachedChapters(sourceId, mangaUrl);
  }

  Future<void> markAllRead(String sourceId, String url) async {
    await _libraryService.markAllChaptersRead(sourceId, url);
    _manga = _libraryService.getAllManga();
    notifyListeners();
  }

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
