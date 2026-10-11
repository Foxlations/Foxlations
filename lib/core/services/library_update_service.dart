import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_store.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import '../models/manga_model.dart';
import '../models/source_settings.dart';
import '../providers/library_provider.dart';
import '../providers/source_provider.dart';
import '../providers/download_provider.dart';
import 'app_logger.dart';
import 'image_loader.dart';
import 'notification_service.dart';
import '../../eval/lib.dart';

/// Record of a new chapter found during update check.
class MangaUpdate {
  final String sourceId;
  final String mangaUrl;
  final String mangaTitle;
  final String coverUrl;
  final String chapterUrl;
  final String chapterName;
  final String dateFound;
  bool isRead;

  MangaUpdate({
    required this.sourceId,
    required this.mangaUrl,
    required this.mangaTitle,
    required this.coverUrl,
    required this.chapterUrl,
    required this.chapterName,
    required this.dateFound,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'sourceId': sourceId, 'mangaUrl': mangaUrl, 'mangaTitle': mangaTitle,
    'coverUrl': coverUrl, 'chapterUrl': chapterUrl, 'chapterName': chapterName,
    'dateFound': dateFound, 'isRead': isRead,
  };

  factory MangaUpdate.fromJson(Map<String, dynamic> json) => MangaUpdate(
    sourceId: json['sourceId'] ?? '', mangaUrl: json['mangaUrl'] ?? '',
    mangaTitle: json['mangaTitle'] ?? '', coverUrl: json['coverUrl'] ?? '',
    chapterUrl: json['chapterUrl'] ?? '', chapterName: json['chapterName'] ?? '',
    dateFound: json['dateFound'] ?? '', isRead: json['isRead'] ?? false,
  );
}

/// Outcome of a library-update run: the new chapters found + the per-title
/// tally, so the UI can show "X completed, X skipped, X failed" and offer to
/// retry the failed set or force-update the skipped set.
class LibraryUpdateResult {
  final List<MangaUpdate> updates;
  final List<LibraryManga> completedTitles;
  final List<LibraryManga> skippedTitles;
  final List<LibraryManga> failedTitles;
  const LibraryUpdateResult({
    this.updates = const [],
    this.completedTitles = const [],
    this.skippedTitles = const [],
    this.failedTitles = const [],
  });
  int get completed => completedTitles.length;
  int get skipped => skippedTitles.length;
  int get failed => failedTitles.length;

  /// The skipped titles worth force-updating: ongoing or hiatus only (a
  /// completed/finished/cancelled series won't get new chapters).
  List<LibraryManga> get skippedUpdatable => [
        for (final m in skippedTitles)
          if (_isUpdatableStatus(m.status)) m
      ];

  static bool _isUpdatableStatus(String status) {
    final s = status.toLowerCase();
    return s == 'ongoing' || s == 'hiatus';
  }
}

enum _Outcome { completed, skipped, failed }

/// Checks all library manga for new chapters.
class LibraryUpdateService {
  static const _updatesKey = 'manga_updates';
  static const _lastUpdateKey = 'last_library_update';

  static Future<List<MangaUpdate>> loadUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_updatesKey) ?? [];
    return raw.map((s) {
      try { return MangaUpdate.fromJson(jsonDecode(s)); }
      catch (_) { return null; }
    }).whereType<MangaUpdate>().toList();
  }

  static Future<void> saveUpdates(List<MangaUpdate> updates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_updatesKey,
        updates.map((u) => jsonEncode(u.toJson())).toList());
  }

  static Future<DateTime?> getLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_lastUpdateKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  /// Checks the library for new chapters.
  ///
  /// [only] restricts the check to a subset — used by "Category Update" so it
  /// checks just the visible category instead of every entry.
  static Future<LibraryUpdateResult> checkForUpdates({
    required LibraryProvider libraryProvider,
    required SourceProvider sourceProvider,
    void Function(int checked, int total, String? currentTitle)? onProgress,
    List<LibraryManga>? only,
    DownloadProvider? downloadProvider,
    bool notify = false,
    // "Update skipped" from the banner: force-update the given titles even
    // though the skip rules would normally skip them.
    bool ignoreSkipRules = false,
  }) async {
    final manga = only ?? libraryProvider.manga;
    final newUpdates = <MangaUpdate>[];
    final completedTitles = <LibraryManga>[];
    final skippedTitles = <LibraryManga>[];
    final failedTitles = <LibraryManga>[];
    int checked = 0;

    // Settings > Library > "Skip titles you haven't started". readChapters == 0
    // means the user has never opened a chapter, so there's nothing to catch up
    // on — checking it just spends network on titles they may never read.
    final prefs = await SharedPreferences.getInstance();
    final skipNotStarted =
        SettingsStore.instance.getBool('lib_skip_not_started') ?? false;
    // Smart-update skip rules — each avoids a source request (anti-ban/battery).
    final skipHasUnread =
        SettingsStore.instance.getBool('lib_skip_has_unread') ?? false;
    final skipCompleted =
        SettingsStore.instance.getBool('lib_skip_completed') ?? false;

    // Throttle the live "a title just got new chapters" refresh — workers run
    // concurrently and we don't want a notify per entry.
    var lastPing = DateTime.fromMillisecondsSinceEpoch(0);

    Future<void> checkOne(LibraryManga m) async {
      _Outcome outcome = _Outcome.completed;
      try {
        // Skip rules (per-source exclude + the global smart-update filters),
        // unless this is a forced "Update skipped" run.
        final skip = !ignoreSkipRules &&
            (SourceSettings.cached(m.sourceId).excludeFromUpdates ||
                // Ground-truth read count (chapter-box isRead tally), not the
                // denormalized readChapters counter, so manual or imported read
                // marks count — otherwise an imported-and-read title drifts to
                // readChapters==0 and gets wrongly skipped as "not started".
                (skipNotStarted && libraryProvider.readCountForManga(m) <= 0) ||
                (skipHasUnread && libraryProvider.unreadForManga(m) > 0) ||
                (skipCompleted && m.status.toLowerCase() == 'completed'));
        if (skip) {
          outcome = _Outcome.skipped;
        } else {
          final installed = sourceProvider.getInstalledSource(m.sourceId);
          if (installed == null) {
            outcome = _Outcome.failed;
          } else {
            final detail = await withExtensionService(
              installed.source, installed.sourceCode,
              // Lightweight: only the newest chapters are needed to detect new
              // ones (avoids re-fetching every page of a huge paginated novel).
              (service) => service.getDetail(m.url, fullChapters: false),
            );
            if (detail.chapters == null) {
              outcome = _Outcome.failed;
            } else {
              // Diff against the cached chapter URLs. First sight of a title
              // seeds the cache WITHOUT reporting its whole back catalogue.
              final cached =
                  libraryProvider.getCachedChapters(m.sourceId, m.url);
              final cachedUrls = cached.map((c) => c.chapterUrl).toSet();
              final firstSeen = cachedUrls.isEmpty;
              final now = DateTime.now().toIso8601String();
              final before = newUpdates.length;
              for (final ch in detail.chapters!) {
                if (!firstSeen &&
                    ch.url != null &&
                    !cachedUrls.contains(ch.url)) {
                  newUpdates.add(MangaUpdate(
                    sourceId: m.sourceId,
                    mangaUrl: m.url,
                    mangaTitle: m.title,
                    coverUrl: m.coverUrl,
                    chapterUrl: ch.url!,
                    chapterName: ch.name ?? 'New Chapter',
                    dateFound: now,
                  ));
                }
              }
              // Did THIS title gain chapters? (Captured before the await below,
              // since a concurrent worker may append to newUpdates after it.)
              final gained = newUpdates.length > before;
              if (detail.chapters!.isNotEmpty) {
                await libraryProvider.cacheChaptersQuiet(m.sourceId, m.url,
                    detail.chapters!.map((c) => c.toJson()).toList());
              }
              // Refresh this title's card live (throttled) — cacheChaptersQuiet
              // already wrote the box (invalidating the unread tally), so a bare
              // notify repaints the badge without a full library rebuild.
              if (gained) {
                final t = DateTime.now();
                if (t.difference(lastPing).inMilliseconds > 400) {
                  lastPing = t;
                  libraryProvider.pingListeners();
                }
              }
              outcome = _Outcome.completed;
            }
          }
        }
      } catch (e) {
        logger.error('Library update failed for ${m.title}: $e',
            category: LogCategory.library);
        outcome = _Outcome.failed;
      }
      switch (outcome) {
        case _Outcome.completed:
          completedTitles.add(m);
        case _Outcome.skipped:
          skippedTitles.add(m);
        case _Outcome.failed:
          failedTitles.add(m);
      }
      checked++;
      onProgress?.call(checked, manga.length, m.title);
      if (notify) {
        NotificationService.instance
            .updateProgress(checked, manga.length, m.title);
      }
    }

    // Check several entries at once instead of strictly one-at-a-time — a big
    // library was spending most of the time blocked on sequential network
    // round-trips. Android's ART/QuickJS engines are reentrant, so fan out
    // there. iOS stays sequential: its embedded Zero-JVM shares a process-wide
    // crash-signal save/restore that isn't concurrency-safe (concurrent source
    // calls could race it and SIGABRT), and iOS JS already serialises itself —
    // iOS still wins big from the one-reload change below, just not from fan-out.
    final concurrency = Platform.isIOS ? 1 : 5;
    var next = 0;
    Future<void> worker() async {
      while (true) {
        final i = next++;
        if (i >= manga.length) break;
        await checkOne(manga[i]);
      }
    }

    await Future.wait(
        List.generate(concurrency, (_) => worker()));

    // One reload+notify for the whole run (the per-entry notify was removed).
    await libraryProvider.reload();

    // "Auto-download new chapters" (Downloads settings). When on, queue every
    // newly found chapter for download. DownloadProvider dedups against
    // in-flight + already-downloaded, so re-runs don't double-enqueue.
    if (downloadProvider != null &&
        downloadProvider.autoDownload &&
        newUpdates.isNotEmpty) {
      for (final u in newUpdates) {
        downloadProvider.enqueueChapter(
          sourceId: u.sourceId,
          mangaUrl: u.mangaUrl,
          mangaTitle: u.mangaTitle,
          chapterUrl: u.chapterUrl,
          chapterName: u.chapterName,
        );
      }
    }

    // Save timestamp (reuses the `prefs` opened at the top of this method).
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

    // Merge with existing, keep max 500
    if (newUpdates.isNotEmpty) {
      final existing = await loadUpdates();
      final all = [...newUpdates, ...existing];
      if (all.length > 500) all.removeRange(500, all.length);
      await saveUpdates(all);
    }

    final result = LibraryUpdateResult(
      updates: newUpdates,
      completedTitles: completedTitles,
      skippedTitles: skippedTitles,
      failedTitles: failedTitles,
    );

    // Replace the live progress notification with the run summary.
    if (notify) {
      NotificationService.instance.updateComplete(
        completed: result.completed,
        skipped: result.skipped,
        failed: result.failed,
        newChapters: newUpdates.length,
      );
    }

    debugPrint('[Update] Checked ${manga.length} manga, found ${newUpdates.length} new chapters');
    return result;
  }

  /// Re-fetch cover art for every library item from its source ("Refresh library
  /// covers"). Updates the stored cover URL and evicts the cached image so the
  /// grid shows the fresh art. A user-set local cover (file://) is left alone.
  /// Sequential on iOS for the same JVM-signal reason as [checkForUpdates].
  /// Returns the number of covers that changed.
  static Future<int> refreshCovers({
    required SourceProvider sourceProvider,
    required LibraryProvider libraryProvider,
    bool Function()? shouldCancel,
    void Function(int done, int total)? onProgress,
  }) async {
    final items = List<LibraryManga>.from(libraryProvider.manga);
    final total = items.length;
    var done = 0;
    var changed = 0;
    final concurrency = Platform.isIOS ? 1 : 5;
    var next = 0;

    Future<void> work() async {
      while (true) {
        if (shouldCancel?.call() == true) return;
        final i = next++;
        if (i >= items.length) break;
        final m = items[i];
        try {
          // Don't clobber a user-set local cover.
          if (!m.coverUrl.startsWith('file://')) {
            final installed = sourceProvider.resolveInstalled(m.sourceId);
            if (installed != null) {
              final detail = await withExtensionService(
                installed.source, installed.sourceCode,
                (service) => service.getDetail(m.url, fullChapters: false),
              );
              final fresh = detail.imageUrl;
              if (fresh != null && fresh.isNotEmpty) {
                // Drop the old bytes so the grid re-downloads. If the source
                // moved the cover, persist the new URL (and clear any stale
                // bytes already cached under it).
                ImageLoader().evict(m.coverUrl);
                if (fresh != m.coverUrl) {
                  ImageLoader().evict(fresh);
                  await libraryProvider.setCoverUrlQuiet(m.sourceId, m.url, fresh);
                  changed++;
                }
              }
            }
          }
        } catch (e) {
          logger.warning('Refresh covers failed for ${m.title}: $e',
              category: LogCategory.library);
        }
        done++;
        onProgress?.call(done, total);
      }
    }

    await Future.wait(List.generate(concurrency, (_) => work()));
    await libraryProvider.reload();
    return changed;
  }

  static Future<void> clearUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_updatesKey);
  }

  // ── Automatic updates ──────────────────────────────────────────────────────
  // Foreground scheduler: the app checks on launch and on resume whether an
  // update is due. This deliberately does NOT run a true OS background task
  // (Android WorkManager / iOS BGTaskScheduler need native setup and are a
  // separate piece of work); the trade-off is that updates happen while the app
  // is open rather than while it's closed, which is enough to honour the
  // frequency / Wi-Fi / charging preferences the settings screen exposes.

  /// Interval for a "Update frequency" label, or null for "Manual" (never auto).
  static Duration? _frequencyInterval(String label) {
    switch (label) {
      case 'Every 12 hours':
        return const Duration(hours: 12);
      case 'Daily':
        return const Duration(days: 1);
      case 'Every 2 days':
        return const Duration(days: 2);
      case 'Weekly':
        return const Duration(days: 7);
      default:
        return null; // 'Manual'
    }
  }

  /// Whether an automatic library update is due right now, honouring the
  /// frequency, "Wi-Fi only" and "Only while charging" settings.
  ///
  /// Constraints fail CLOSED: if the network or battery state can't be read, or
  /// doesn't satisfy a required condition, we skip rather than risk updating on
  /// cellular / on battery against the user's wishes.
  static Future<bool> shouldAutoUpdate() async {
    final interval = _frequencyInterval(
        SettingsStore.instance.getString('lib_update_frequency') ?? 'Manual');
    if (interval == null) return false; // Manual — never auto-update.

    final last = await getLastUpdate();
    if (last != null && DateTime.now().difference(last) < interval) {
      return false; // Checked recently enough.
    }

    if (SettingsStore.instance.getBool('lib_update_wifi_only') ?? true) {
      try {
        final conn = await Connectivity().checkConnectivity();
        final onWifi = conn.contains(ConnectivityResult.wifi) ||
            conn.contains(ConnectivityResult.ethernet);
        if (!onWifi) return false;
      } catch (_) {
        return false;
      }
    }

    if (SettingsStore.instance.getBool('lib_update_charging_only') ?? false) {
      try {
        final state = await Battery().batteryState;
        final charging = state == BatteryState.charging ||
            state == BatteryState.full;
        if (!charging) return false;
      } catch (_) {
        return false;
      }
    }

    return true;
  }

  static Future<int> getUnreadCount() async {
    final updates = await loadUpdates();
    return updates.where((u) => !u.isRead).length;
  }
}
