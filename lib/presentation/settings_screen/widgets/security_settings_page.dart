import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/incognito_provider.dart';
import '../../../core/providers/app_lock_provider.dart';
import '../../../core/services/settings_store.dart';
import '../../../core/services/secure_screen_service.dart';

/// Security preference keys. App lock and biometrics are enforced at runtime by
/// AppLockProvider; screen security (FLAG_SECURE / screenshot block) by
/// secure_screen_service. These string keys are still read/written directly by
/// those call sites rather than through the constants below.
class SecurityPrefs {
  static const appLock = 'sec_app_lock';
  static const biometrics = 'sec_biometrics';
  static const secureScreen = 'sec_secure_screen';
  static const hideNotificationContent = 'sec_hide_notif_content';
}

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});
  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _secureScreen = false;

  @override
  void initState() {
    super.initState();
    // SettingsStore is loaded before runApp, so these reads are synchronous.
    _secureScreen =
        SettingsStore.instance.getBool(SecurityPrefs.secureScreen) ?? false;
  }

  Future<void> _setBool(String key, bool value) =>
      SettingsStore.instance.setBool(key, value);

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
        title: Text(t.setxSecurityTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          AppSettingsSectionHeader(title: t.setxSecuritySectionAppLock),
          AppSettingsSwitchTile(icon: Icons.lock_rounded, iconColor: const Color(0xFF5865F2),
              title: t.setxSecurityAppLockTitle, subtitle: t.setxSecurityAppLockSubtitle,
              value: context.watch<AppLockProvider>().enabled,
              onChanged: (v) => context.read<AppLockProvider>().setEnabled(v)),
          if (context.watch<AppLockProvider>().enabled)
            _LockDelayTile(
                value: context.watch<AppLockProvider>().lockAfterMinutes,
                onChanged: (v) =>
                    context.read<AppLockProvider>().setLockAfterMinutes(v)),
          // Biometrics unlock is not wired (local_auth) yet - hidden rather than
          // shipped as a toggle that does nothing. Re-add when enforcement lands.
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxSecuritySectionPrivacy),
          AppSettingsSwitchTile(icon: Icons.visibility_off_outlined, iconColor: AppTheme.warning,
              title: t.setxSecurityIncognitoTitle, subtitle: t.setxSecurityIncognitoSubtitle,
              value: context.watch<IncognitoProvider>().enabled,
              onChanged: (v) => context.read<IncognitoProvider>().setEnabled(v)),
          AppSettingsSwitchTile(icon: Icons.phonelink_lock_rounded, iconColor: AppTheme.warning,
              title: t.setxSecuritySecureScreenTitle, subtitle: t.setxSecuritySecureScreenSubtitle,
              value: _secureScreen, onChanged: (v) {
                setState(() => _secureScreen = v);
                _setBool(SecurityPrefs.secureScreen, v);
                SecureScreenService.setEnabled(v);
              }),
          // "Hide notification content" isn't wired to the notification builder
          // yet - hidden rather than shown as a non-functional toggle.
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// "Lock after" idle-timeout selector. Mirrors [_SwitchTile]'s styling but
/// trails a popup menu of grace-period options instead of a switch.
class _LockDelayTile extends StatelessWidget {
  final int value; final ValueChanged<int> onChanged;
  const _LockDelayTile({required this.value, required this.onChanged});

  static const _options = <int>[0, 1, 2, 5, 10];
  static String _label(AppLocalizations t, int m) =>
      m == 0 ? t.setxSecurityLockAfterImmediately : t.setxSecurityLockAfterMinutes(m);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Row(children: [
        Container(width: 36, height: 36,
            decoration: oledIconChip(context, color: const Color(0xFF5865F2), fill: const Color(0xFF5865F2).withAlpha(25), radius: 10),
            child: const Icon(Icons.timer_outlined, color: Color(0xFF5865F2), size: 18)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.setxSecurityLockAfterTitle, style: Theme.of(context).textTheme.titleSmall),
          Text(t.setxSecurityLockAfterSubtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
        ])),
        PopupMenuButton<int>(
          initialValue: value,
          onSelected: onChanged,
          itemBuilder: (_) => [
            for (final m in _options)
              PopupMenuItem<int>(value: m,
                  child: Text(_label(t, m), style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 14))),
          ],
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(_label(t, value), style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: cs.primary)),
            Icon(Icons.arrow_drop_down_rounded, color: cs.primary, size: 20),
          ]),
        ),
      ]),
    );
  }
}
