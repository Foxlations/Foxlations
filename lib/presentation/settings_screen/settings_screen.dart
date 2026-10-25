import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../theme/app_tokens.dart';
import '../widgets/ds/ds.dart';
import '../../core/providers/beta_provider.dart';
import './widgets/about_settings_page.dart';
import './widgets/help_tips_page.dart';
import './widgets/library_settings_page.dart';
import './widgets/reader_settings_page.dart';
import './widgets/player_settings_page.dart';
import './widgets/downloads_settings_page.dart';
import './widgets/download_queue_page.dart';
import './widgets/browse_settings_page.dart';
import './widgets/appearance_settings_page.dart';
import './widgets/language_settings_page.dart';
import './widgets/notifications_settings_page.dart';
import './widgets/security_settings_page.dart';
import './widgets/advanced_settings_page.dart';
import './widgets/tracking_settings_page.dart';
import './widgets/ai_settings_page.dart';
import './widgets/backup_settings_page.dart';
import '../../l10n/app_localizations.dart';

// First screen migrated onto the design system (P2). Category icon colours are
// the deliberate per-category palette (kept as seeds); the tile's tinted icon
// background now derives from that one seed instead of a hardcoded dark/light
// pair, and all type/surfaces come from the theme + tokens.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _push(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final beta = context.watch<BetaProvider>().enabled;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.settingsTitle),
      ),
      body: ListView(
        // Pad the bottom by the device's system-bar inset so the last rows clear
        // the Android navigation bar instead of scrolling under it.
        padding: EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.md + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          _SettingsSectionHeader(title: t.settingsSectionApp),
          _SettingsNavTile(
            icon: Icons.palette_rounded,
            iconColor: const Color(0xFFFF7A5C),
            title: t.settingsAppearanceTitle,
            subtitle: t.settingsAppearanceSubtitle,
            onTap: () => _push(context, const AppearanceSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF3B82F6),
            title: t.settingsLanguageTitle,
            subtitle: t.settingsLanguageEntrySubtitle,
            onTap: () => _push(context, const LanguageSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.notifications_rounded,
            iconColor: const Color(0xFFEF4444),
            title: t.settingsNotificationsTitle,
            subtitle: t.settingsNotificationsSubtitle,
            onTap: () => _push(context, const NotificationsSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.storage_rounded,
            iconColor: const Color(0xFF06B6D4),
            title: t.settingsStorageTitle,
            subtitle: t.settingsStorageSubtitle,
            onTap: () => _push(context, const DownloadsSettingsPage()),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SettingsSectionHeader(title: t.settingsSectionManga),
          _SettingsNavTile(
            icon: Icons.library_books_rounded,
            iconColor: cs.primary,
            title: t.settingsLibraryTitle,
            subtitle: t.settingsLibrarySubtitle,
            onTap: () => _push(context, const LibrarySettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.menu_book_rounded,
            iconColor: const Color(0xFF4CAF82),
            title: t.settingsReaderTitle,
            subtitle: t.settingsReaderSubtitle,
            onTap: () => _push(context, const ReaderSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.play_circle_outline_rounded,
            iconColor: const Color(0xFFE0554A),
            title: t.settingsPlayerTitle,
            subtitle: t.settingsPlayerSubtitle,
            onTap: () => _push(context, const PlayerSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.download_rounded,
            iconColor: const Color(0xFF7C6FF7),
            title: t.settingsDownloadsTitle,
            subtitle: t.settingsDownloadsSubtitle,
            onTap: () => _push(context, const DownloadQueuePage()),
          ),
          _SettingsNavTile(
            icon: Icons.track_changes_rounded,
            iconColor: const Color(0xFF2E51A2),
            title: t.settingsTrackingTitle,
            subtitle: t.settingsTrackingSubtitle,
            onTap: () => _push(context, const TrackingSettingsPage()),
          ),
          if (beta)
            _SettingsNavTile(
              icon: Icons.translate_rounded,
              iconColor: const Color(0xFF7C6FF7),
              title: t.settingsAiTitle,
              subtitle: t.settingsAiSubtitle,
              onTap: () => _push(context, const AiSettingsPage()),
            ),
          _SettingsNavTile(
            icon: Icons.explore_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: t.settingsBrowseTitle,
            subtitle: t.settingsBrowseSubtitle,
            onTap: () => _push(context, const BrowseSettingsPage()),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SettingsSectionHeader(title: t.settingsSectionSystem),
          _SettingsNavTile(
            icon: Icons.backup_rounded,
            iconColor: const Color(0xFF16A085),
            title: t.settingsBackupTitle,
            subtitle: t.settingsBackupSubtitle,
            onTap: () => _push(context, const BackupSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.security_rounded,
            iconColor: const Color(0xFF5865F2),
            title: t.settingsSecurityTitle,
            subtitle: t.settingsSecuritySubtitle,
            onTap: () => _push(context, const SecuritySettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.settings_applications_rounded,
            iconColor: cs.onSurfaceVariant,
            title: t.settingsAdvancedTitle,
            subtitle: t.settingsAdvancedSubtitle,
            onTap: () => _push(context, const AdvancedSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.info_rounded,
            iconColor: const Color(0xFF4CAF82),
            title: t.settingsAboutTitle,
            subtitle: t.settingsAboutSubtitle,
            onTap: () => _push(context, const AboutSettingsPage()),
          ),
          _SettingsNavTile(
            icon: Icons.help_outline_rounded,
            iconColor: const Color(0xFF4CAF82),
            title: t.helpTipsTitle,
            subtitle: t.settingsHelpSubtitle,
            onTap: () => _push(context, const HelpTipsPage()),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// ── Section header ──────────────────────────────────────────
class _SettingsSectionHeader extends StatelessWidget {
  final String title;
  const _SettingsSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppSectionLabel(
      title,
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
    );
  }
}

// ── Settings nav tile ────────────────────────────────────────
class _SettingsNavTile extends StatelessWidget {
  final IconData icon;

  /// The category's seed colour (the deliberate per-category palette). The
  /// tinted icon background is derived from it, so it adapts to the theme.
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsNavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: AppCard(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: oledIconChip(context,
                  color: iconColor,
                  fill: iconColor.withValues(alpha: isDark ? 0.22 : 0.14)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
