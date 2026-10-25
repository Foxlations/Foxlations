import 'package:flutter/material.dart';
import '../../../core/services/settings_store.dart';
import '../../../core/services/notification_service.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import '../../../l10n/app_localizations.dart';

/// Notification preference keys. Delivered via [NotificationService]
/// (flutter_local_notifications); each toggle gates whether its event fires.
class NotificationPrefs {
  static const newChapters = 'notif_new_chapters';
  static const libraryUpdate = 'notif_library_update';
  static const downloadComplete = 'notif_download_complete';
  static const downloadError = 'notif_download_error';
  static const sound = 'notif_sound';
  static const vibration = 'notif_vibration';
  static const groupNotifications = 'notif_group';
}

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _newChapters = true;
  bool _downloadComplete = true;
  bool _downloadError = true;
  bool _libraryUpdate = false;
  bool _sound = true;
  bool _vibration = true;
  bool _groupNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    // Prompt for OS notification permission when the user opens this page.
    NotificationService.instance.requestPermission();
  }

  Future<void> _loadPrefs() async {
    setState(() {
      _newChapters =
          SettingsStore.instance.getBool(NotificationPrefs.newChapters) ?? true;
      _libraryUpdate =
          SettingsStore.instance.getBool(NotificationPrefs.libraryUpdate) ??
              false;
      _downloadComplete =
          SettingsStore.instance.getBool(NotificationPrefs.downloadComplete) ??
              true;
      _downloadError =
          SettingsStore.instance.getBool(NotificationPrefs.downloadError) ??
              true;
      _sound = SettingsStore.instance.getBool(NotificationPrefs.sound) ?? true;
      _vibration =
          SettingsStore.instance.getBool(NotificationPrefs.vibration) ?? true;
      _groupNotifications =
          SettingsStore.instance.getBool(NotificationPrefs.groupNotifications) ??
              true;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    await SettingsStore.instance.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface, elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context)),
        title: Text(t.setxNotifTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          AppSettingsSectionHeader(title: t.setxNotifSectionChapterUpdates),
          AppSettingsSwitchTile(icon: Icons.new_releases_rounded, iconColor: cs.primary,
              title: t.setxNotifNewChaptersTitle, subtitle: t.setxNotifNewChaptersSubtitle,
              value: _newChapters, onChanged: (v) {
                setState(() => _newChapters = v);
                _setBool(NotificationPrefs.newChapters, v);
              }),
          AppSettingsSwitchTile(icon: Icons.update_rounded, iconColor: cs.primary,
              title: t.setxNotifLibraryUpdatesTitle, subtitle: t.setxNotifLibraryUpdatesSubtitle,
              value: _libraryUpdate, onChanged: (v) {
                setState(() => _libraryUpdate = v);
                _setBool(NotificationPrefs.libraryUpdate, v);
              }),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxNotifSectionDownloads),
          AppSettingsSwitchTile(icon: Icons.download_done_rounded, iconColor: AppTheme.success,
              title: t.setxNotifDownloadCompleteTitle, subtitle: t.setxNotifDownloadCompleteSubtitle,
              value: _downloadComplete, onChanged: (v) {
                setState(() => _downloadComplete = v);
                _setBool(NotificationPrefs.downloadComplete, v);
              }),
          AppSettingsSwitchTile(icon: Icons.error_outline_rounded, iconColor: AppTheme.error,
              title: t.setxNotifDownloadErrorTitle, subtitle: t.setxNotifDownloadErrorSubtitle,
              value: _downloadError, onChanged: (v) {
                setState(() => _downloadError = v);
                _setBool(NotificationPrefs.downloadError, v);
              }),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxNotifSectionBehavior),
          AppSettingsSwitchTile(icon: Icons.volume_up_rounded, iconColor: AppTheme.secondary,
              title: t.setxNotifSoundTitle, subtitle: t.setxNotifSoundSubtitle,
              value: _sound, onChanged: (v) {
                setState(() => _sound = v);
                _setBool(NotificationPrefs.sound, v);
              }),
          AppSettingsSwitchTile(icon: Icons.vibration_rounded, iconColor: AppTheme.secondary,
              title: t.setxNotifVibrationTitle, subtitle: t.setxNotifVibrationSubtitle,
              value: _vibration, onChanged: (v) {
                setState(() => _vibration = v);
                _setBool(NotificationPrefs.vibration, v);
              }),
          AppSettingsSwitchTile(icon: Icons.groups_rounded, iconColor: AppTheme.secondary,
              title: t.setxNotifGroupTitle, subtitle: t.setxNotifGroupSubtitle,
              value: _groupNotifications, onChanged: (v) {
                setState(() => _groupNotifications = v);
                _setBool(NotificationPrefs.groupNotifications, v);
              }),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
