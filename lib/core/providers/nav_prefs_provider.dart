import 'package:flutter/foundation.dart';
import '../services/settings_store.dart';

/// Persisted order of the bottom-navigation tabs, so users can arrange the bar
/// however they like. Tabs are identified by stable string ids (never by
/// position), so the app's per-tab behaviour survives any reordering.
class NavPrefsProvider extends ChangeNotifier {
  static const _key = 'nav_tab_order';

  /// All tab ids, in their default order. `more` opens Settings; the other four
  /// are the IndexedStack screens.
  static const List<String> canonical = [
    'library',
    'updates',
    'browse',
    'discover',
    'more',
  ];

  List<String> _order = List.of(canonical);
  List<String> get order => _order;

  Future<void> initialize() async {
    try {
      final saved = SettingsStore.instance.getStringList(_key);
      if (saved != null && _isValid(saved)) {
        _order = saved;
        notifyListeners();
      }
    } catch (_) {
      // Keep the default order.
    }
  }

  // A saved order is only trusted if it's exactly the known set of ids — this
  // self-heals if tabs are added/removed in a future version.
  bool _isValid(List<String> o) =>
      o.length == canonical.length && canonical.every(o.contains);

  Future<void> setOrder(List<String> newOrder) async {
    if (!_isValid(newOrder) || listEquals(newOrder, _order)) return;
    _order = List.of(newOrder);
    notifyListeners();
    try {
      await SettingsStore.instance.setStringList(_key, _order);
    } catch (_) {}
  }

  Future<void> reset() => setOrder(List.of(canonical));
}
