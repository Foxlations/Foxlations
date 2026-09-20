import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the user-selected app UI language.
///
/// A `null` [locale] means "follow the system language" — the app then resolves
/// against [MaterialApp.supportedLocales]. The choice is persisted so it survives
/// restarts. Sibling of [ThemeProvider]: initialized once in the root MultiProvider
/// and read by the MaterialApp's `locale`.
class LocaleProvider extends ChangeNotifier {
  static const _prefsKey = 'app_locale';

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefsKey);
      if (code != null && code.isNotEmpty) {
        _locale = _parse(code);
        notifyListeners();
      }
    } catch (_) {
      // No stored preference (or storage unavailable) → follow the system.
    }
  }

  /// Set the app language. Pass `null` to follow the system default.
  Future<void> setLocale(Locale? locale) async {
    if (_localesEqual(_locale, locale)) return;
    _locale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (locale == null) {
        await prefs.remove(_prefsKey);
      } else {
        await prefs.setString(_prefsKey, _format(locale));
      }
    } catch (_) {
      // Persisting is best-effort; the in-memory choice still applies this run.
    }
  }

  static bool _localesEqual(Locale? a, Locale? b) =>
      a?.languageCode == b?.languageCode && a?.countryCode == b?.countryCode;

  static Locale _parse(String code) {
    final parts = code.split('_');
    return parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
  }

  static String _format(Locale l) =>
      (l.countryCode == null || l.countryCode!.isEmpty)
          ? l.languageCode
          : '${l.languageCode}_${l.countryCode}';
}
