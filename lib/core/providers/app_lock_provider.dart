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
  static const lockDelayKey = 'sec_app_lock_timeout';

  final LocalAuthentication _auth = LocalAuthentication();
  bool _enabled = false;
  bool _locked = false;
  bool _authInProgress = false;
  int _lockAfterMinutes = 0;
  DateTime? _backgroundedAt;

  bool get enabled => _enabled;

  /// Whether the lock screen should currently cover the app.
  bool get locked => _enabled && _locked;

  /// Idle grace period before re-locking on resume. 0 = lock immediately on
  /// background (the original behaviour).
  int get lockAfterMinutes => _lockAfterMinutes;

  Future<void> initialize() async {
    _enabled = SettingsStore.instance.getBool(enabledKey) ?? false;
    _lockAfterMinutes = SettingsStore.instance.getInt(lockDelayKey) ?? 0;
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

  Future<void> setLockAfterMinutes(int m) async {
    final v = m < 0 ? 0 : m;
    if (_lockAfterMinutes == v) return;
    _lockAfterMinutes = v;
    notifyListeners();
    await SettingsStore.instance.setInt(lockDelayKey, v);
  }

  /// Relock — call when the app goes to the background.
  void lock() {
    if (_enabled && !_locked) {
      _locked = true;
      notifyListeners();
    }
  }

  /// Call when the app is backgrounded. Records the time so [onResumed] can
  /// apply the idle grace period. With no delay set (0) this keeps today's
  /// behaviour of locking immediately on background.
  void onPaused() {
    _backgroundedAt = DateTime.now();
    if (_enabled && _lockAfterMinutes == 0 && !_locked) {
      _locked = true;
      notifyListeners();
    }
  }

  /// Call when the app returns to the foreground. Re-locks only if the idle
  /// grace period has elapsed since it was backgrounded; if already locked
  /// (e.g. immediate lock) this does nothing.
  void onResumed() {
    if (_enabled &&
        !_locked &&
        _lockAfterMinutes > 0 &&
        _backgroundedAt != null &&
        DateTime.now().difference(_backgroundedAt!).inMinutes >=
            _lockAfterMinutes) {
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
