import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import '../services/download_service.dart';
import '../services/settings_store.dart';
import '../services/app_logger.dart';
import '../services/notification_service.dart';
import '../../eval/lib.dart';
import '../providers/source_provider.dart';

/// Tracks download state for a single chapter or anime episode.
class DownloadTask {
  final String sourceId;
  final String mangaUrl;
  final String mangaTitle;
  final String chapterUrl;
  final String chapterName;
  final bool isVault;
  final bool isAnime;
  final bool isNovel;
  int completed;
  int total;
  DownloadStatus status;

  DownloadTask({
    required this.sourceId,
    required this.mangaUrl,
    required this.mangaTitle,
    required this.chapterUrl,
    required this.chapterName,
    this.isVault = false,
    this.isAnime = false,
    this.isNovel = false,
    this.completed = 0,
    this.total = 0,
    this.status = DownloadStatus.queued,
  });

  String get key => '${sourceId}_$chapterUrl';
  double get progress => total > 0 ? completed / total : 0;
}

enum DownloadStatus { queued, downloading, completed, failed, cancelled }

/// Manages the download queue and tracks per-chapter download state.
class DownloadProvider extends ChangeNotifier {
  final DownloadService _downloadService = DownloadService();
  final List<DownloadTask> _queue = [];
  final Map<String, DownloadTask> _tasks = {};
  final Set<String> _downloadedChapters = {};
  // Manga-level download index ('{sourceId}::{mangaUrl}' for entries with at
  // least one downloaded chapter). Backs the library's "Downloaded" filter and
  // the downloaded badge; populated by [refreshDownloadedMangaIndex] and kept
  // fresh incrementally as chapters complete.
  final Set<String> _downloadedMangaKeys = {};
  bool _refreshingMangaIndex = false;
  bool _isProcessing = false;
  bool _paused = false;
  int _maxConcurrent = 2;
  int _activeCount = 0;
  // Tally for the current run of the queue. The app fires ONE "downloads
  // complete" notification when the queue fully drains, not one per chapter —
  // these count what finished since the queue was last empty, and reset after
  // the summary notification.
  int _batchCompleted = 0;
  int _batchFailed = 0;
  // Chapters/episodes finished this session (newest first, capped), backing the
  // Downloads screen's "Recently downloaded" list. Not persisted across launches.
  final List<DownloadTask> _recent = [];

  // Settings (persisted via SettingsStore). Wired keys:
  //   dl_auto              autoDownload            (consumed by
  //                                                 LibraryUpdateService — new
  //                                                 chapters auto-download)
  //   dl_wifi_only         wifiOnly                (consumed in _constraintsOk)
  //   dl_only_charging     onlyWhenCharging        (consumed in _constraintsOk)
  //   dl_while_reading     downloadWhileReading    (consumed by reader_screen)
  //   dl_delete_after_read deleteAfterRead         (consumed by reader_screen)
  //   dl_remove_bookmarked removeBookmarked        (gates auto-delete)
  //   dl_auto_delete       autoDeleteAfter         (consumed by reader_screen)
  //   dl_save_cbz          saveAsCbz               (consumed in this file)
  //   dl_save_pdf          saveAsPdf               (consumed in this file)
  //   dl_simultaneous      simultaneousDownloads   (consumed in _processQueue)
  //   dl_quality           downloadQuality         (consumed in _pickVideo)
  bool autoDownload = false;
  bool wifiOnly = true;
  bool onlyWhenCharging = false;
  bool downloadWhileReading = false;
  int downloadAheadCount = 1; // how many chapters ahead (dl_ahead_count)
  bool deleteAfterRead = false;
  bool removeBookmarked = false;
  String autoDeleteAfter = 'Disabled';
  bool saveAsCbz = false;
  bool saveAsPdf = false;
  String simultaneousDownloads = '2';
  String downloadQuality = 'Original';

  List<DownloadTask> get queue => List.unmodifiable(_queue);
  Map<String, DownloadTask> get tasks => Map.unmodifiable(_tasks);
  bool get isProcessing => _isProcessing;
  bool get isPaused => _paused;

  /// In-flight work for the Downloads queue screen: tasks currently downloading
  /// first, then the queued tasks in queue order. (Downloading tasks leave
  /// [_queue] when they start but remain in [_tasks] until they finish.)
  List<DownloadTask> get activeDownloads {
    final downloading = _tasks.values
        .where((t) => t.status == DownloadStatus.downloading)
        .toList();
    return [...downloading, ..._queue];
  }

  /// Number of tasks queued or downloading — cheap value the UI can badge.
  int get activeCount => _activeCount + _queue.length;

  /// Chapters/episodes finished this session, newest first (session-scoped).
  List<DownloadTask> get recentCompleted => List.unmodifiable(_recent);

  /// Library entries ('{sourceId}::{mangaUrl}') that have downloaded chapters.
  Set<String> get downloadedMangaKeys => Set.unmodifiable(_downloadedMangaKeys);

  /// O(1) membership without allocating a wrapper — the library grid/list calls
  /// this once per card per frame, so the `Set.unmodifiable(...)` getter above
  /// was churning a throwaway view object per card during scroll.
  bool isMangaDownloaded(String key) => _downloadedMangaKeys.contains(key);

  /// Count of entries with downloads — cheap value the library can `select` on
  /// so it rebuilds when the downloaded SET changes (a chapter finished), not on
  /// every per-image progress tick.
  int get downloadedCount => _downloadedMangaKeys.length;

  /// Rescan disk for which library entries have downloaded chapters and refresh
  /// the cached index. Overlapping runs are coalesced (a single in-flight scan).
  Future<void> refreshDownloadedMangaIndex(
      Iterable<({String sourceId, String url, String title})> entries) async {
    if (_refreshingMangaIndex) return;
    _refreshingMangaIndex = true;
    try {
      final keys = await _downloadService.downloadedMangaKeys(entries);
      _downloadedMangaKeys
        ..clear()
        ..addAll(keys);
      notifyListeners();
    } finally {
      _refreshingMangaIndex = false;
    }
  }

  /// Reconcile one title's chapter download-state against what's actually on
  /// disk, re-adding any downloaded chapters the persisted index lost — a
  /// reinstall or data wipe keeps the files but clears SharedPreferences, so
  /// the chapter checkmarks and the "Downloaded" filter would otherwise read as
  /// not-downloaded until a needless re-download. Cheap: one directory listing
  /// per section, then a set match. Call it when a title's chapters load.
  Future<void> reconcileDownloads(
    String sourceId,
    String mangaUrl,
    String mangaTitle,
    Iterable<({String url, String name})> chapters,
  ) async {
    if (mangaTitle.isEmpty) return;
    final onDisk = await _downloadService.downloadedChapterUrls(
        sourceId, mangaTitle, chapters);
    if (onDisk.isEmpty) return;
    var changed = false;
    for (final url in onDisk) {
      if (_downloadedChapters.add('${sourceId}_$url')) changed = true;
    }
    if (changed) {
      _downloadedMangaKeys.add('$sourceId::$mangaUrl');
      await _saveDownloaded();
      notifyListeners();
    }
  }

  /// Number of chapters to keep before auto-deleting older ones (e.g.
  /// "After 5 chapters" → 5). 0 means disabled.
  int get autoDeleteThreshold {
    final m = RegExp(r'(\d+)').firstMatch(autoDeleteAfter);
    return m == null ? 0 : int.tryParse(m.group(1)!) ?? 0;
  }

  /// Reference to source provider (set from outside after construction).
  SourceProvider? sourceProvider;
  // Resume a paused queue when the network/charging state becomes favourable.
  StreamSubscription? _connSub;
  StreamSubscription? _battSub;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    autoDownload = SettingsStore.instance.getBool('dl_auto') ?? false;
    wifiOnly = SettingsStore.instance.getBool('dl_wifi_only') ?? true;
    onlyWhenCharging = SettingsStore.instance.getBool('dl_only_charging') ?? false;
    downloadWhileReading = SettingsStore.instance.getBool('dl_while_reading') ?? false;
    downloadAheadCount = (SettingsStore.instance.getInt('dl_ahead_count') ?? 1).clamp(1, 10);
    deleteAfterRead = SettingsStore.instance.getBool('dl_delete_after_read') ?? false;
    removeBookmarked = SettingsStore.instance.getBool('dl_remove_bookmarked') ?? false;
    autoDeleteAfter = SettingsStore.instance.getString('dl_auto_delete') ?? 'Disabled';
    saveAsCbz = SettingsStore.instance.getBool('dl_save_cbz') ?? false;
    saveAsPdf = SettingsStore.instance.getBool('dl_save_pdf') ?? false;
    simultaneousDownloads = SettingsStore.instance.getString('dl_simultaneous') ?? '2';
    downloadQuality = SettingsStore.instance.getString('dl_quality') ?? 'Original';
    _maxConcurrent = int.tryParse(simultaneousDownloads) ?? 2;
    _downloadedChapters.addAll(prefs.getStringList('downloaded_chapters') ?? []);
    // Resume the queue when conditions improve (back on Wi-Fi / plugged in).
    _connSub ??= Connectivity().onConnectivityChanged.listen((_) {
      if (_queue.isNotEmpty) _processQueue();
    });
    _battSub ??= Battery().onBatteryStateChanged.listen((_) {
      if (_queue.isNotEmpty) _processQueue();
    });
  }

  @override
  void dispose() {
    _connSub?.cancel();
    _battSub?.cancel();
    super.dispose();
  }

  Future<void> _saveDownloaded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('downloaded_chapters', _downloadedChapters.toList());
  }

  /// How many chapters to pull ahead while reading (1–10).
  Future<void> setDownloadAheadCount(int n) async {
    downloadAheadCount = n.clamp(1, 10);
    await SettingsStore.instance.setInt('dl_ahead_count', downloadAheadCount);
    notifyListeners();
  }

  Future<void> saveSetting(String key, bool value) async {
    await SettingsStore.instance.setBool(key, value);
    switch (key) {
      case 'dl_auto':
        autoDownload = value;
        break;
      case 'dl_wifi_only':
        wifiOnly = value;
        break;
      case 'dl_only_charging':
        onlyWhenCharging = value;
        break;
      case 'dl_while_reading':
        downloadWhileReading = value;
        break;
      case 'dl_delete_after_read':
        deleteAfterRead = value;
        break;
      case 'dl_remove_bookmarked':
        removeBookmarked = value;
        break;
      case 'dl_save_cbz':
        saveAsCbz = value;
        // CBZ and PDF export are mutually exclusive.
        if (value && saveAsPdf) {
          saveAsPdf = false;
          await SettingsStore.instance.setBool('dl_save_pdf', false);
        }
        break;
      case 'dl_save_pdf':
        saveAsPdf = value;
        if (value && saveAsCbz) {
          saveAsCbz = false;
          await SettingsStore.instance.setBool('dl_save_cbz', false);
        }
        break;
    }
    notifyListeners();
  }

  /// String-valued setting persistence (simultaneous downloads, quality,
  /// auto-delete threshold).
  Future<void> saveStringSetting(String key, String value) async {
    await SettingsStore.instance.setString(key, value);
    switch (key) {
      case 'dl_simultaneous':
        simultaneousDownloads = value;
        // Apply new concurrency immediately. New tasks pick it up; in-flight
        // ones complete on their own.
        _maxConcurrent = int.tryParse(value) ?? 2;
        // Kick the queue in case the new limit is higher than current active.
        _processQueue();
        break;
      case 'dl_quality':
        downloadQuality = value;
        break;
      case 'dl_auto_delete':
        autoDeleteAfter = value;
        break;
    }
    notifyListeners();
  }

  /// Check if a chapter is downloaded.
  bool isDownloaded(String sourceId, String chapterUrl) {
    return _downloadedChapters.contains('${sourceId}_$chapterUrl');
  }

  /// Get active task for a chapter (if downloading/queued).
  DownloadTask? getTask(String sourceId, String chapterUrl) {
    return _tasks['${sourceId}_$chapterUrl'];
  }

  /// Queue a single chapter for download.
  void enqueueChapter({
    required String sourceId,
    required String mangaUrl,
    required String mangaTitle,
    required String chapterUrl,
    required String chapterName,
    bool isVault = false,
  }) {
    final key = '${sourceId}_$chapterUrl';
    if (_tasks.containsKey(key) || _downloadedChapters.contains(key)) return;

    final task = DownloadTask(
      sourceId: sourceId,
      mangaUrl: mangaUrl,
      mangaTitle: mangaTitle,
      chapterUrl: chapterUrl,
      chapterName: chapterName,
      isVault: isVault,
    );
    _tasks[key] = task;
    _queue.add(task);
    notifyListeners();
    _processQueue();
  }

  /// Queue an anime episode for download.
  void enqueueEpisode({
    required String sourceId,
    required String animeUrl,
    required String animeTitle,
    required String episodeUrl,
    required String episodeName,
  }) {
    final key = '${sourceId}_$episodeUrl';
    if (_tasks.containsKey(key) || _downloadedChapters.contains(key)) return;

    final task = DownloadTask(
      sourceId: sourceId,
      mangaUrl: animeUrl,
      mangaTitle: animeTitle,
      chapterUrl: episodeUrl,
      chapterName: episodeName,
      isAnime: true,
    );
    _tasks[key] = task;
    _queue.add(task);
    notifyListeners();
    _processQueue();
  }

  /// Queue a light-novel chapter for offline reading (saves its text, not images).
  void enqueueNovelChapter({
    required String sourceId,
    required String novelUrl,
    required String novelTitle,
    required String chapterUrl,
    required String chapterName,
    bool isVault = false,
  }) {
    final key = '${sourceId}_$chapterUrl';
    if (_tasks.containsKey(key) || _downloadedChapters.contains(key)) return;

    final task = DownloadTask(
      sourceId: sourceId,
      mangaUrl: novelUrl,
      mangaTitle: novelTitle,
      chapterUrl: chapterUrl,
      chapterName: chapterName,
      isVault: isVault,
      isNovel: true,
    );
    _tasks[key] = task;
    _queue.add(task);
    notifyListeners();
    _processQueue();
  }

  /// Queue multiple chapters.
  void enqueueChapters(List<Map<String, String>> chapters) {
    for (final ch in chapters) {
      enqueueChapter(
        sourceId: ch['sourceId']!,
        mangaUrl: ch['mangaUrl']!,
        mangaTitle: ch['mangaTitle']!,
        chapterUrl: ch['chapterUrl']!,
        chapterName: ch['chapterName']!,
      );
    }
  }

  /// Queue multiple novel chapters.
  void enqueueNovelChapters(List<Map<String, String>> chapters) {
    for (final ch in chapters) {
      enqueueNovelChapter(
        sourceId: ch['sourceId']!,
        novelUrl: ch['mangaUrl']!,
        novelTitle: ch['mangaTitle']!,
        chapterUrl: ch['chapterUrl']!,
        chapterName: ch['chapterName']!,
      );
    }
  }

  /// Cancel a download task.
  void cancelTask(String sourceId, String chapterUrl) {
    final key = '${sourceId}_$chapterUrl';
    final task = _tasks[key];
    if (task != null) {
      task.status = DownloadStatus.cancelled;
      _queue.removeWhere((t) => t.key == key);
      _tasks.remove(key);
      notifyListeners();
    }
  }

  /// Cancel all queued/active downloads.
  void cancelAll() {
    for (final task in _tasks.values) {
      task.status = DownloadStatus.cancelled;
    }
    _queue.clear();
    _tasks.clear();
    _isProcessing = false;
    _activeCount = 0;
    notifyListeners();
  }

  /// Pause the queue: in-flight downloads finish, but no new ones start until
  /// [resumeQueue]. The underlying page/video fetch has no mid-chapter pause
  /// hook, so the currently-downloading item completes rather than stopping
  /// part-way — matching how the queue already "pauses" on lost Wi-Fi.
  void pauseQueue() {
    if (_paused) return;
    _paused = true;
    notifyListeners();
  }

  /// Resume a paused queue and kick processing.
  void resumeQueue() {
    if (!_paused) return;
    _paused = false;
    notifyListeners();
    _processQueue();
  }

  /// Clear the session "recently downloaded" list.
  void clearRecent() {
    if (_recent.isEmpty) return;
    _recent.clear();
    notifyListeners();
  }

  /// Delete a downloaded chapter from disk.
  Future<void> deleteDownload(
      String sourceId, String mangaTitle, String chapterName, String chapterUrl) async {
    await _downloadService.deleteChapter(sourceId, mangaTitle, chapterName);
    _downloadedChapters.remove('${sourceId}_$chapterUrl');
    await _saveDownloaded();
    notifyListeners();
  }

  /// Process the download queue.
  /// Whether the current network/battery state satisfies "Wi-Fi only" and "only
  /// while charging". Fails CLOSED — if a state can't be read we pause rather
  /// than download against the user's wishes (mirrors the library scheduler).
  Future<bool> _constraintsOk() async {
    if (wifiOnly) {
      try {
        final conn = await Connectivity().checkConnectivity();
        final onWifi = conn.contains(ConnectivityResult.wifi) ||
            conn.contains(ConnectivityResult.ethernet);
        if (!onWifi) return false;
      } catch (_) {
        return false;
      }
    }
    if (onlyWhenCharging) {
      try {
        final state = await Battery().batteryState;
        final charging =
            state == BatteryState.charging || state == BatteryState.full;
        if (!charging) return false;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  Future<void> _processQueue() async {
    // User-paused: in-flight tasks finish, nothing new starts until resumed.
    if (_paused) return;
    if (_isProcessing && _activeCount >= _maxConcurrent) return;
    // Pause (don't drop) the queue when Wi-Fi-only / charging-only isn't met;
    // the connectivity/battery listeners resume it when conditions improve.
    if (_queue.isNotEmpty && !await _constraintsOk()) return;
    _isProcessing = true;

    while (_queue.isNotEmpty && _activeCount < _maxConcurrent) {
      final task = _queue.removeAt(0);
      if (task.status == DownloadStatus.cancelled) continue;
      _activeCount++;
      _downloadChapter(task); // fire and forget, managed by _activeCount
    }
  }

  Future<void> _downloadChapter(DownloadTask task) async {
    task.status = DownloadStatus.downloading;
    notifyListeners();

    try {
      final installed = sourceProvider?.resolveInstalled(task.sourceId);
      if (installed == null) throw Exception('Source not installed');

      if (task.isAnime) {
        await _downloadEpisode(task, installed);
      } else if (task.isNovel) {
        await _downloadNovelChapter(task, installed);
      } else {
        await _downloadMangaChapter(task, installed);
      }
    } catch (e) {
      logger.error('Download failed: ${task.mangaTitle} · ${task.chapterName}: $e',
          category: LogCategory.download);
      task.status = DownloadStatus.failed;
    }

    // Tally the finished task for the end-of-queue summary instead of firing a
    // notification per chapter. Cancelled tasks never reach completed/failed here.
    if (task.status == DownloadStatus.completed) {
      // Record in the session "recently downloaded" list (newest first, capped).
      _recent.insert(0, task);
      if (_recent.length > 30) _recent.removeRange(30, _recent.length);
      _batchCompleted++;
    } else if (task.status == DownloadStatus.failed) {
      _batchFailed++;
    }

    _activeCount--;
    _tasks.remove(task.key);
    notifyListeners();

    // Process next in queue
    if (_queue.isNotEmpty) _processQueue();
    // Queue fully drained (nothing active, nothing waiting) → ONE summary
    // notification for everything that just finished. A paused queue leaves
    // items in _queue, so this correctly doesn't fire until the user resumes
    // and the last item lands.
    if (_activeCount == 0 && _queue.isEmpty) {
      _isProcessing = false;
      if (_batchCompleted + _batchFailed > 0) {
        NotificationService.instance.downloadsFinished(
            completed: _batchCompleted, failed: _batchFailed);
        _batchCompleted = 0;
        _batchFailed = 0;
      }
    }
  }

  Future<void> _downloadMangaChapter(DownloadTask task, dynamic installed) async {
    // Fetch the page list AND the request headers in ONE service build —
    // constructing the extension service (interpreter/runtime + full source
    // execute) is one of the most expensive ops in the pipeline, so doing it
    // once per chapter instead of twice halves that cost. (Also keeps source
    // calls minimal, which matters for the iOS sequential-source rule.)
    final (pages, headers) = await withExtensionService(
      installed.source,
      installed.sourceCode,
      (service) async {
        final p = await service.getPageList(task.chapterUrl);
        Map<String, String> h = {};
        try {
          h = service.getHeaders();
        } catch (_) {}
        return (p, h);
      },
    );

    final imageUrls = pages.map((p) => p.url).toList();
    task.total = imageUrls.length;
    notifyListeners();

    // Coalesce progress notifications — pages now download in parallel, so
    // completions arrive in bursts; rebuilding every listener per image (across
    // concurrent chapters) floods the UI isolate and competes with the download
    // work. Notify at most ~4x/sec, plus once when the chapter finishes.
    var lastNotify = 0;
    final success = await _downloadService.downloadChapter(
      sourceId: task.sourceId,
      mangaTitle: task.mangaTitle,
      chapterName: task.chapterName,
      imageUrls: imageUrls,
      headers: headers,
      isVault: task.isVault,
      onProgress: (completed, total) {
        task.completed = completed;
        task.total = total;
        final now = DateTime.now().millisecondsSinceEpoch;
        if (completed >= total || now - lastNotify >= 250) {
          lastNotify = now;
          notifyListeners();
        }
      },
    );

    if (task.status == DownloadStatus.cancelled) return;

    if (success) {
      if (saveAsCbz) {
        await _downloadService.convertToCbz(
          sourceId: task.sourceId,
          mangaTitle: task.mangaTitle,
          chapterName: task.chapterName,
          isVault: task.isVault,
        );
      } else if (saveAsPdf) {
        await _downloadService.convertToPdf(
          sourceId: task.sourceId,
          mangaTitle: task.mangaTitle,
          chapterName: task.chapterName,
          isVault: task.isVault,
        );
      }
      task.status = DownloadStatus.completed;
      _downloadedChapters.add(task.key);
      // Keep the manga-level index in step without a full rescan (the next full
      // refresh reconciles deletions).
      _downloadedMangaKeys.add('${task.sourceId}::${task.mangaUrl}');
      await _saveDownloaded();
    } else {
      task.status = DownloadStatus.failed;
    }
  }

  Future<void> _downloadNovelChapter(DownloadTask task, dynamic installed) async {
    task.total = 1;
    notifyListeners();

    // Fetch the chapter's HTML through the extension host (same call the novel
    // reader makes) and persist it for offline reading.
    final html = await withExtensionService(
      installed.source,
      installed.sourceCode,
      (service) => service.getHtmlContent(task.chapterUrl),
    );

    final success = await _downloadService.downloadNovelChapter(
      sourceId: task.sourceId,
      novelTitle: task.mangaTitle,
      chapterName: task.chapterName,
      htmlContent: html,
      isVault: task.isVault,
    );

    if (task.status == DownloadStatus.cancelled) return;

    if (success) {
      task.completed = 1;
      task.status = DownloadStatus.completed;
      _downloadedChapters.add(task.key);
      _downloadedMangaKeys.add('${task.sourceId}::${task.mangaUrl}');
      await _saveDownloaded();
    } else {
      task.status = DownloadStatus.failed;
    }
  }

  Future<void> _downloadEpisode(DownloadTask task, dynamic installed) async {
    final videos = await withExtensionService(
      installed.source, installed.sourceCode,
      (service) => service.getVideoList(task.chapterUrl),
    );

    if (videos.isEmpty) {
      task.status = DownloadStatus.failed;
      return;
    }

    // Pick quality: prefer setting match, fall back to first
    final video = _pickVideo(videos);

    task.total = 1;
    notifyListeners();

    final success = await _downloadService.downloadEpisode(
      sourceId: task.sourceId,
      animeTitle: task.mangaTitle,
      episodeName: task.chapterName,
      videoUrl: video.url,
      headers: video.headers ?? {},
      onProgress: (received, total) {
        task.completed = received;
        task.total = total > 0 ? total : 1;
        notifyListeners();
      },
    );

    if (task.status == DownloadStatus.cancelled) return;

    if (success) {
      task.status = DownloadStatus.completed;
      _downloadedChapters.add(task.key);
      _downloadedMangaKeys.add('${task.sourceId}::${task.mangaUrl}');
      await _saveDownloaded();
    } else {
      task.status = DownloadStatus.failed;
    }
  }

  /// Pick the best video from a list based on the downloadQuality setting.
  dynamic _pickVideo(List<dynamic> videos) {
    if (videos.length == 1) return videos.first;
    // Try to match quality label (e.g. "1080p", "720p")
    final pref = downloadQuality.toLowerCase();
    for (final v in videos) {
      if (v.quality.toLowerCase().contains(pref)) return v;
    }
    // Default: the highest RESOLUTION variant, parsed from the quality label —
    // sources don't agree on order, so "first"/"last" was a coin flip.
    dynamic best;
    var bestRes = -1;
    for (final v in videos) {
      final m = RegExp(r'(\d{3,4})\s*p', caseSensitive: false)
          .firstMatch(v.quality.toString());
      final res = m != null ? (int.tryParse(m.group(1)!) ?? -1) : -1;
      if (res > bestRes) {
        bestRes = res;
        best = v;
      }
    }
    return best ?? videos.first;
  }

  /// Get total download size.
  Future<int> getTotalSize({bool? isVault}) => _downloadService.getTotalSize(isVault: isVault);

  /// Get local pages for a downloaded chapter.
  Future<List<String>> getLocalPages(
      String sourceId, String mangaTitle, String chapterName) {
    return _downloadService.getLocalPages(sourceId, mangaTitle, chapterName);
  }
}
