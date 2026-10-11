import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/incognito_provider.dart';
import '../../../core/providers/app_lock_provider.dart';
import '../../../core/services/settings_store.dart';
import '../../../core/services/secure_screen_service.dart';

/// Security preference keys. Toggling persists the choice — runtime
/// enforcement (app lock screen, biometric prompt, FLAG_SECURE) requires
/// platform plugins (local_auth / window flags) which are not yet wired up.
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
            style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: 8, bottom: 8 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          _SectionHeader(title: t.setxSecuritySectionAppLock),
          _SwitchTile(icon: Icons.lock_rounded, iconColor: const Color(0xFF5865F2),
              title: t.setxSecurityAppLockTitle, subtitle: t.setxSecurityAppLockSubtitle,
              value: context.watch<AppLockProvider>().enabled,
              onChanged: (v) => context.read<AppLockProvider>().setEnabled(v)),
          if (context.watch<AppLockProvider>().enabled)
            _LockDelayTile(
                value: context.watch<AppLockProvider>().lockAfterMinutes,
                onChanged: (v) =>
                    context.read<AppLockProvider>().setLockAfterMinutes(v)),
          // Biometrics unlock is not wired (local_auth) yet — hidden rather than
          // shipped as a toggle that does nothing. Re-add when enforcement lands.
          const SizedBox(height: 8),
          _SectionHeader(title: t.setxSecuritySectionPrivacy),
          _SwitchTile(icon: Icons.visibility_off_outlined, iconColor: AppTheme.warning,
              title: t.setxSecurityIncognitoTitle, subtitle: t.setxSecurityIncognitoSubtitle,
              value: context.watch<IncognitoProvider>().enabled,
              onChanged: (v) => context.read<IncognitoProvider>().setEnabled(v)),
          _SwitchTile(icon: Icons.phonelink_lock_rounded, iconColor: AppTheme.warning,
              title: t.setxSecuritySecureScreenTitle, subtitle: t.setxSecuritySecureScreenSubtitle,
              value: _secureScreen, onChanged: (v) {
                setState(() => _secureScreen = v);
                _setBool(SecurityPrefs.secureScreen, v);
                SecureScreenService.setEnabled(v);
              }),
          // "Hide notification content" isn't wired to the notification builder
          // yet — hidden rather than shown as a non-functional toggle.
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(title.toUpperCase(),
          style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: cs.primary)),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title; final String subtitle;
  final bool value; final ValueChanged<bool> onChanged;
  const _SwitchTile({required this.icon, required this.iconColor, required this.title,
      required this.subtitle, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Row(children: [
        Container(width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
          Text(subtitle, style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
        ])),
        Switch(value: value, onChanged: onChanged, activeThumbColor: cs.onPrimary, activeTrackColor: cs.primary),
      ]),
    );
  }
}

/// "Lock after" idle-timeout selector. Mirrors [_SwitchTile]'s styling but
/// trails a popup menu of grace-period options instead of a switch.
class _LockDelayTile extends StatelessWidget {
  final int value; final ValueChanged<int> onChanged;
  const _LockDelayTile({required this.value, required this.onChanged});

  static const _options = <int>[0, 1, 2, 5, 10];
  static String _label(int m) => m == 0 ? 'Immediately' : '$m minute${m == 1 ? '' : 's'}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Row(children: [
        Container(width: 36, height: 36,
            decoration: BoxDecoration(color: const Color(0xFF5865F2).withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.timer_outlined, color: Color(0xFF5865F2), size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Lock after', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
          Text('Wait this long before re-locking on reopen', style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
        ])),
        PopupMenuButton<int>(
          initialValue: value,
          onSelected: onChanged,
          itemBuilder: (_) => [
            for (final m in _options)
              PopupMenuItem<int>(value: m,
                  child: Text(_label(m), style: GoogleFonts.manrope(fontSize: 14))),
          ],
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(_label(value), style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: cs.primary)),
            Icon(Icons.arrow_drop_down_rounded, color: cs.primary, size: 20),
          ]),
        ),
      ]),
    );
  }
}
