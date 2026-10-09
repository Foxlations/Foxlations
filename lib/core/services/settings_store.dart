import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide **durable** key/value settings store.
///
/// SharedPreferences / NSUserDefaults keep writes in an in-memory cache that
/// only flushes to disk periodically, so a force-quit right after a change can
/// lose it — the bug behind "I toggled a setting, closed the app, and it
/// reverted". This store mirrors everything in a single JSON file that is
/// fsync'd on every write (`flush: true`), so a value is on disk before the
/// setter's Future completes.
///
/// Reads are synchronous against the in-memory map, so callers must await
/// [load] once at startup (done in `main()` before `runApp`). The API mirrors
/// the subset of `SharedPreferences` the app uses, so call sites migrate with a
/// near-identical shape.
class SettingsStore {
  SettingsStore._();
  static final SettingsStore instance = SettingsStore._();

  File? _file;
  Map<String, dynamic> _data = {};
  bool _loaded = false;

  /// Whether [load] has completed. Reads before this are empty (defaults).
  bool get isLoaded => _loaded;

  /// Load the durable file into memory. On first run (no file yet) imports any
  /// existing SharedPreferences values so upgrading installs keep their
  /// settings instead of resetting to defaults. Idempotent.
  Future<void> load() async {
    if (_loaded) return;
    try {
      final dir = await getApplicationSupportDirectory();
      _file = File('${dir.path}/settings.json');
      if (await _file!.exists()) {
        final decoded = jsonDecode(await _file!.readAsString());
        if (decoded is Map<String, dynamic>) _data = decoded;
      } else {
        await _migrateFromSharedPreferences();
      }
    } catch (_) {
      // Unreadable/corrupt or no storage — keep empty defaults.
    }
    _loaded = true;
  }

  /// One-time import of legacy SharedPreferences values on first load.
  Future<void> _migrateFromSharedPreferences() async {
    try {
      final p = await SharedPreferences.getInstance();
      for (final k in p.getKeys()) {
        final v = p.get(k);
        if (v != null) _data[k] = v;
      }
      if (_data.isNotEmpty) await _flush();
    } catch (_) {}
  }

  bool? getBool(String key) {
    final v = _data[key];
    return v is bool ? v : null;
  }

  String? getString(String key) {
    final v = _data[key];
    return v is String ? v : null;
  }

  int? getInt(String key) {
    final v = _data[key];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return null;
  }

  double? getDouble(String key) {
    final v = _data[key];
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return null;
  }

  List<String>? getStringList(String key) {
    final v = _data[key];
    if (v is List) return v.map((e) => e.toString()).toList();
    return null;
  }

  bool containsKey(String key) => _data.containsKey(key);

  Future<void> setBool(String key, bool value) => _set(key, value);
  Future<void> setString(String key, String value) => _set(key, value);
  Future<void> setInt(String key, int value) => _set(key, value);
  Future<void> setDouble(String key, double value) => _set(key, value);
  Future<void> setStringList(String key, List<String> value) =>
      _set(key, value);

  Future<void> remove(String key) async {
    _data.remove(key);
    await _flush();
  }

  Future<void> _set(String key, Object value) async {
    _data[key] = value;
    await _flush();
  }

  // Serialize writes so overlapping setters can't interleave and clobber the
  // file; each flush encodes a snapshot taken at call time.
  Future<void> _writeChain = Future.value();

  Future<void> _flush() {
    final snapshot = jsonEncode(_data);
    _writeChain = _writeChain.then((_) async {
      try {
        // flush:true fsyncs, so the value is on disk before this returns.
        await _file?.writeAsString(snapshot, flush: true);
      } catch (_) {
        // Best-effort — a failed write falls back to the last saved copy.
      }
    });
    return _writeChain;
  }
}
