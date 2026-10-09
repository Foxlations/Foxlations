import 'package:flutter/foundation.dart';
import '../services/settings_store.dart';

/// Master switch for experimental ("beta") features — hands-free scrolling,
/// RepoForge, and other items. Off by default; when off those features are
/// hidden in the UI AND their runtime is disabled. Persisted to [prefsKey] so
/// non-provider code (e.g. the reader) can also read it directly.
class BetaProvider extends ChangeNotifier {
  static const prefsKey = 'beta_features_enabled';

  bool _enabled = false;
  bool get enabled => _enabled;

  Future<void> initialize() async {
    try {
      _enabled = SettingsStore.instance.getBool(prefsKey) ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
    try {
      await SettingsStore.instance.setBool(prefsKey, value);
    } catch (_) {}
  }
}
