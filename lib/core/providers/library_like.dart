import '../models/manga_model.dart';
import '../models/chapter_model.dart';

/// The common surface the manga-detail / reader / novel-reader / player stack
/// needs from a library-backed store, implemented by BOTH [LibraryProvider]
/// (the public `library_*` boxes) and [VaultProvider] (the encrypted vault
/// boxes). Threading a `LibraryLike` (selected by an `isVault` flag) through
/// those screens keeps vault chapter lists + read-marks + reading progress in
/// the vault instead of leaking them into the plaintext library box.
///
/// Deliberately NOT a [ChangeNotifier]: it declares only the members both
/// providers expose for reading/writing per-title state. Screens that need to
/// rebuild still `watch` the concrete provider.
abstract class LibraryLike {
  List<LibraryManga> get manga;

  bool isInLibrary(String sourceId, String url);

  List<LibraryChapter> getCachedChapters(String sourceId, String mangaUrl);

  Future<void> cacheChapters(
      String sourceId, String mangaUrl, List<Map<String, dynamic>> chapters);

  bool isChapterRead(String sourceId, String chapterUrl);

  /// [active] true = a genuine in-app read (reaching the chapter's end), which
  /// also feeds the gamified stats; false (manual / bulk / migrate) only flips
  /// the read flag.
  Future<void> markChapterRead(
      String sourceId, String mangaUrl, String chapterUrl,
      {bool active = false});

  Future<void> markChapterUnread(
      String sourceId, String mangaUrl, String chapterUrl);

  Future<void> markAllRead(String sourceId, String url);

  Future<void> markAllUnread(String sourceId, String url);

  Future<void> updateReadingProgress(
      String sourceId, String mangaUrl, String chapterUrl, int page);

  Future<void> updateNovelProgress(
      String sourceId, String mangaUrl, String chapterUrl, int offset,
      double fraction);

  Future<void> updateEpisodeProgress(
      String sourceId, String mangaUrl, String episodeUrl, int positionSeconds,
      {int totalSeconds, bool notify});

  /// Saved playback position (seconds) for an episode, or 0 if none.
  int episodeLastPosition(String sourceId, String episodeUrl);

  /// Add [seconds] of active read/watch time to an entry (Reading Insights).
  Future<void> addReadTime(String sourceId, String mangaUrl, int seconds);
}
