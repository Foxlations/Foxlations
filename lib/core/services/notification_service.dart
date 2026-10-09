import 'dart:io';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../l10n/app_localizations.dart';
import 'app_logger.dart';
import 'settings_store.dart';

/// Local notifications for new chapters, library-update summaries, and download
/// completion/errors. Each event is gated on its `notif_*` toggle (Settings >
/// Notifications); content is blanked when `sec_hide_notif_content` is on.
///
/// Fires from background/service code with no BuildContext, so strings are
/// localized via [lookupAppLocalizations] against the saved app locale.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  int _idCounter = 1000;
  // Fixed id for the live library-update notification so progress updates
  // replace in place and the summary replaces the progress one.
  static const _progressId = 2;

  static const _chUpdates = 'library_updates';
  static const _chDownloads = 'downloads';

  bool get _supported =>
      Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  AppLocalizations get _t {
    try {
      final code = SettingsStore.instance.getString('app_locale');
      final locale = (code != null && code.isNotEmpty && code != 'system')
          ? Locale(code)
          : PlatformDispatcher.instance.locale;
      return lookupAppLocalizations(locale);
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  Future<void> initialize() async {
    if (_initialized || !_supported) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(const InitializationSettings(
          android: android, iOS: darwin, macOS: darwin));
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final t = _t;
      await androidImpl?.createNotificationChannel(AndroidNotificationChannel(
          _chUpdates, t.notifChannelUpdatesName,
          description: t.notifChannelUpdatesDesc,
          importance: Importance.defaultImportance));
      await androidImpl?.createNotificationChannel(AndroidNotificationChannel(
          _chDownloads, t.notifChannelDownloadsName,
          description: t.notifChannelDownloadsDesc,
          importance: Importance.low));
      _initialized = true;
    } catch (e, st) {
      logger.error('Notification init failed: $e',
          category: LogCategory.notification, detail: st.toString());
    }
  }

  /// Ask the OS for notification permission (Android 13+, iOS/macOS). Safe to
  /// call repeatedly — the OS only prompts once.
  Future<void> requestPermission() async {
    if (!_supported) return;
    try {
      if (Platform.isIOS) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      } else if (Platform.isMacOS) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      } else if (Platform.isAndroid) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
    } catch (e) {
      logger.error('Notification permission request failed: $e',
          category: LogCategory.notification);
    }
  }

  bool _on(String key, {bool def = true}) =>
      SettingsStore.instance.getBool(key) ?? def;

  Future<void> _show({
    required String channelId,
    required String channelName,
    required String channelDesc,
    required String title,
    required String body,
    String? group,
  }) async {
    if (!_supported) return;
    if (!_initialized) await initialize();
    if (!_initialized) return;
    final sound = _on('notif_sound');
    final vibration = _on('notif_vibration');
    final grouped = _on('notif_group');
    final hide = _on('sec_hide_notif_content', def: false);
    try {
      final android = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: sound,
        enableVibration: vibration,
        groupKey: grouped ? group : null,
      );
      final darwin = DarwinNotificationDetails(
        presentAlert: true,
        presentSound: sound,
        threadIdentifier: grouped ? group : null,
      );
      await _plugin.show(
        _idCounter++,
        hide ? _t.appTitle : title,
        hide ? _t.notifHiddenBody : body,
        NotificationDetails(android: android, iOS: darwin, macOS: darwin),
      );
    } catch (e, st) {
      logger.error('Notification show failed: $e',
          category: LogCategory.notification, detail: st.toString());
    }
  }

  /// Live library-update progress — a single ongoing notification updated in
  /// place (fixed id). Android shows a progress bar; iOS just refreshes the body.
  Future<void> updateProgress(int current, int total, String? title) async {
    if (!_supported || !_on('notif_new_chapters')) return;
    if (!_initialized) await initialize();
    if (!_initialized) return;
    final hide = _on('sec_hide_notif_content', def: false);
    final max = total <= 0 ? 1 : total;
    try {
      final android = AndroidNotificationDetails(
        _chUpdates, _t.notifChannelUpdatesName,
        channelDescription: _t.notifChannelUpdatesDesc,
        importance: Importance.low,
        priority: Priority.low,
        playSound: false,
        enableVibration: false,
        onlyAlertOnce: true,
        ongoing: true,
        showProgress: true,
        maxProgress: max,
        progress: current.clamp(0, max),
      );
      const darwin =
          DarwinNotificationDetails(presentAlert: false, presentSound: false);
      final body = hide
          ? _t.notifHiddenBody
          : 'Updating ${title ?? ''}  $current/$total';
      await _plugin.show(
        _progressId,
        hide ? _t.appTitle : 'Updating library',
        body,
        NotificationDetails(android: android, iOS: darwin, macOS: darwin),
      );
    } catch (_) {}
  }

  /// Replace the live progress notification with the run summary.
  Future<void> updateComplete({
    required int completed,
    required int skipped,
    required int failed,
    int newChapters = 0,
  }) async {
    if (!_supported || !_on('notif_new_chapters')) return;
    if (!_initialized) await initialize();
    if (!_initialized) return;
    final hide = _on('sec_hide_notif_content', def: false);
    try {
      await _plugin.cancel(_progressId);
      final sound = _on('notif_sound');
      final android = AndroidNotificationDetails(
        _chUpdates, _t.notifChannelUpdatesName,
        channelDescription: _t.notifChannelUpdatesDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: sound,
        enableVibration: _on('notif_vibration'),
      );
      final darwin =
          DarwinNotificationDetails(presentAlert: true, presentSound: sound);
      var body = '$completed completed, $skipped skipped, $failed failed';
      if (newChapters > 0) body = '$body  ·  +$newChapters new';
      await _plugin.show(
        _progressId,
        hide ? _t.appTitle : 'Update complete',
        hide ? _t.notifHiddenBody : body,
        NotificationDetails(android: android, iOS: darwin, macOS: darwin),
      );
    } catch (_) {}
  }

  Future<void> downloadComplete(String mangaTitle, String chapterName) async {
    if (!_on('notif_download_complete')) return;
    final t = _t;
    await _show(
      channelId: _chDownloads,
      channelName: t.notifChannelDownloadsName,
      channelDesc: t.notifChannelDownloadsDesc,
      title: t.notifDownloadCompleteTitle,
      body: '$mangaTitle · $chapterName',
      group: 'downloads',
    );
  }

  Future<void> downloadError(String mangaTitle, String chapterName) async {
    if (!_on('notif_download_error')) return;
    final t = _t;
    await _show(
      channelId: _chDownloads,
      channelName: t.notifChannelDownloadsName,
      channelDesc: t.notifChannelDownloadsDesc,
      title: t.notifDownloadFailedTitle,
      body: '$mangaTitle · $chapterName',
      group: 'downloads',
    );
  }

  /// One summary notification fired when the whole download queue drains — not
  /// one per chapter/episode. Gated on the same `notif_download_complete` toggle;
  /// if everything failed it uses the "failed" title instead.
  Future<void> downloadsFinished(
      {required int completed, required int failed}) async {
    if (completed + failed <= 0) return;
    if (!_on('notif_download_complete')) return;
    final t = _t;
    final title = completed > 0
        ? t.notifDownloadsDoneTitle
        : t.notifDownloadFailedTitle;
    final body = failed > 0
        ? t.notifDownloadsDoneBodyFailed(completed, failed)
        : t.notifDownloadsDoneBody(completed);
    await _show(
      channelId: _chDownloads,
      channelName: t.notifChannelDownloadsName,
      channelDesc: t.notifChannelDownloadsDesc,
      title: title,
      body: body,
      group: 'downloads',
    );
  }

  /// "New chapters found" after a library update (gated on notif_new_chapters).
  /// One grouped notification per run — single title shows the title + count,
  /// multiple shows "N new chapters across M titles" (no per-title spam).
  Future<void> newChaptersFound({
    required int totalNew,
    required int titleCount,
    String? singleTitle,
  }) async {
    if (totalNew <= 0 || !_on('notif_new_chapters')) return;
    final t = _t;
    final single =
        titleCount <= 1 && singleTitle != null && singleTitle.isNotEmpty;
    await _show(
      channelId: _chUpdates,
      channelName: t.notifChannelUpdatesName,
      channelDesc: t.notifChannelUpdatesDesc,
      title: single ? singleTitle : t.notifLibraryUpdatedTitle,
      body: single
          ? t.notifNewChapters(totalNew)
          : t.notifLibrarySummaryBody(totalNew, titleCount),
      group: 'updates',
    );
  }

  /// Installed extensions have updates available (gated on
  /// adv_extension_update_notify, default off).
  Future<void> extensionUpdates(int count) async {
    if (count <= 0 || !_on('adv_extension_update_notify', def: false)) return;
    final t = _t;
    await _show(
      channelId: _chUpdates,
      channelName: t.notifChannelUpdatesName,
      channelDesc: t.notifChannelUpdatesDesc,
      title: t.notifExtensionUpdatesTitle,
      body: t.notifExtensionUpdates(count),
      group: 'updates',
    );
  }

  /// Optional "library update finished" summary on every completed run
  /// (gated on notif_library_update, default off).
  Future<void> libraryUpdateFinished({
    required int totalNew,
    required int titleCount,
  }) async {
    if (!_on('notif_library_update', def: false)) return;
    final t = _t;
    await _show(
      channelId: _chUpdates,
      channelName: t.notifChannelUpdatesName,
      channelDesc: t.notifChannelUpdatesDesc,
      title: t.notifLibraryUpdatedTitle,
      body: t.notifLibrarySummaryBody(totalNew, titleCount),
      group: 'updates',
    );
  }
}
