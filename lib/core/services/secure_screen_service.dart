import 'dart:io';
import 'package:flutter/services.dart';
import 'settings_store.dart';

/// "Secure Screen" (Settings > Security). Hides app content in the OS recent-apps
/// switcher (and, on Android, blocks screenshots/screen recording via FLAG_SECURE).
/// iOS can't block screenshots, so there it covers the window with a blur while the
/// app is inactive. Driven over the `foxlations/secure` platform channel.
class SecureScreenService {
  static const _channel = MethodChannel('foxlations/secure');
  static const prefsKey = 'sec_secure_screen';

  /// Push the persisted setting to the platform. Call once at startup.
  static Future<void> apply() =>
      setEnabled(SettingsStore.instance.getBool(prefsKey) ?? false);

  static Future<void> setEnabled(bool enabled) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    try {
      await _channel.invokeMethod('setSecure', enabled);
    } catch (_) {
      // Channel not available (e.g. during early startup) — the next apply() or
      // toggle will re-push the value.
    }
  }
}
