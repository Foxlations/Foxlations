import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import '../services/settings_store.dart';
import '../services/app_logger.dart';

/// App lock (Settings > Security). When enabled, the app is covered by a lock
/// screen on cold start and whenever it returns from the background, requiring
/// device authentication (biometric or device passcode via [local_auth]) to
/// enter. No custom PIN — it reuses the device's own credential, so there's
/// nothing to store or reset.
class AppLockProvider extends ChangeNotifier {
  static const enabledKey = 'sec_app_lock';
  static const biometricsKey = 'sec_biometrics';

  final LocalAuthentication _auth = LocalAuthentication();
  bool _enabled = false;
  bool _locked = false;
  bool _authInProgress = false;

  bool get enabled => _enabled;

  /// Whether the lock screen should currently cover the app.
  bool get locked => _enabled && _locked;

  Future<void> initialize() async {
    _enabled = SettingsStore.instance.getBool(enabledKey) ?? false;
    _locked = _enabled; // require an unlock on cold start
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    if (!value) _locked = false;
    notifyListeners();
    await SettingsStore.instance.setBool(enabledKey, value);
  }

  /// Relock — call when the app goes to the background.
  void lock() {
    if (_enabled && !_locked) {
      _locked = true;
      notifyListeners();
    }
  }

  /// Prompt the OS for authentication. Returns true once unlocked. Never traps
  /// the user: if the device has no biometric/passcode set up (so a lock can't
  /// be enforced), it unlocks instead of leaving them stuck.
  Future<bool> unlock(String localizedReason) async {
    if (!_enabled) return true;
    if (_authInProgress) return false;
    _authInProgress = true;
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) {
        _locked = false;
        notifyListeners();
        return true;
      }
      final ok = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          // Allow the device passcode as a fallback, so a failed/absent
          // biometric still has a way in.
          biometricOnly: false,
        ),
      );
      if (ok) {
        _locked = false;
        notifyListeners();
      }
      return ok;
    } catch (e) {
      logger.error('App unlock failed: $e', category: LogCategory.general);
      return false;
    } finally {
      _authInProgress = false;
    }
  }
}
