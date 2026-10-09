import 'package:flutter/foundation.dart';
import '../services/settings_store.dart';

/// Global "incognito" (private) mode. While ON, the app records NO reading /
/// watching / listening progress and does NOT auto-update trackers — manga,
/// anime and novels alike. Everything else (browsing, downloading, manual
/// "mark as read", manual tracker edits) works normally. Off by default.
///
/// [active] is a synchronous static mirror of [enabled] so context-free code
/// (the [LibraryProvider] progress choke points and [TrackingProvider] auto
/// sync) can cheaply check it before persisting, without a BuildContext.
///
/// Persisted through [SettingsStore] (durable, fsync'd), so the choice survives
/// an immediate force-quit.
class IncognitoProvider extends ChangeNotifier {
  static const prefsKey = 'incognito_enabled';

  /// Synchronous mirror of [enabled] for gating in non-widget code.
  static bool active = false;

  bool _enabled = false;
  bool get enabled => _enabled;

  Future<void> initialize() async {
    _enabled = SettingsStore.instance.getBool(prefsKey) ?? false;
    active = _enabled;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    active = value;
    notifyListeners();
    await SettingsStore.instance.setBool(prefsKey, value);
  }
}
