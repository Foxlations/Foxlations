import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Legacy SharedPreferences keys - only read once, to migrate old installs.
  static const _themeKey = 'theme_mode';
  static const _breedKey = 'theme_breed';
  static const _invertKey = 'theme_invert_colors';

  ThemeMode _themeMode = ThemeMode.dark;
  String _breedId = 'red_fox';
  bool _invertColors = false;
  bool _oledBlack = false;
  // Palette flip: 0 = neutral dark/light surfaces (the original look), 1 = the
  // theme's hue takes over the backgrounds/surfaces. Applies to the preset
  // breeds; a custom theme sets its surfaces explicitly instead.
  double _flipStrength = 0.0;
  File? _file;

  ThemeMode get themeMode => _themeMode;
  String get breedId => _breedId;
  bool get invertColors => _invertColors;
  bool get oledBlack => _oledBlack;
  double get flipStrength => _flipStrength;

  /// Get the primary color for the current breed and brightness.
  Color primaryColor(Brightness brightness) {
    final breed = themeBreeds[_breedId] ?? themeBreeds['red_fox']!;
    return brightness == Brightness.dark ? breed.primaryDark : breed.primaryLight;
  }

  Color accentColor(Brightness brightness) {
    final breed = themeBreeds[_breedId] ?? themeBreeds['red_fox']!;
    return brightness == Brightness.dark ? breed.accentDark : breed.accentLight;
  }

  /// The background / surface / highest-container / on-surface colours for a
  /// brightness, after applying the palette flip. Fed into AppTheme so the whole
  /// app follows.
  ({Color background, Color surface, Color surfaceHighest, Color onSurface})
      surfacesFor(Brightness b) {
    final neutral = b == Brightness.dark
        ? (
            background: const Color(0xFF12121C),
            surface: const Color(0xFF1E1E2E),
            surfaceHighest: const Color(0xFF2A2A3E),
            onSurface: const Color(0xFFE8E8F0),
          )
        : (
            background: const Color(0xFFF5F5F5),
            surface: const Color(0xFFFFFFFF),
            surfaceHighest: const Color(0xFFE8E8EC),
            onSurface: const Color(0xFF1A1A2E),
          );
    final s = _flipStrength.clamp(0.0, 1.0);
    if (s <= 0.001) return neutral;
    // Tint toward the theme hue. The "bold" end (s = 1) is a clearly coloured
    // surface; the slider lerps the neutral look toward it.
    final hue = HSLColor.fromColor(primaryColor(b)).hue;
    final tinted = b == Brightness.dark
        ? (
            background: HSLColor.fromAHSL(1, hue, 0.45, 0.10).toColor(),
            surface: HSLColor.fromAHSL(1, hue, 0.42, 0.15).toColor(),
            surfaceHighest: HSLColor.fromAHSL(1, hue, 0.40, 0.21).toColor(),
            onSurface: neutral.onSurface,
          )
        : (
            background: HSLColor.fromAHSL(1, hue, 0.50, 0.92).toColor(),
            surface: HSLColor.fromAHSL(1, hue, 0.60, 0.97).toColor(),
            surfaceHighest: HSLColor.fromAHSL(1, hue, 0.45, 0.88).toColor(),
            onSurface: neutral.onSurface,
          );
    return (
      background: Color.lerp(neutral.background, tinted.background, s)!,
      surface: Color.lerp(neutral.surface, tinted.surface, s)!,
      surfaceHighest:
          Color.lerp(neutral.surfaceHighest, tinted.surfaceHighest, s)!,
      onSurface: neutral.onSurface,
    );
  }

  Future<File> _prefsFile() async {
    final cached = _file;
    if (cached != null) return cached;
    final dir = await getApplicationSupportDirectory();
    return _file = File('${dir.path}/theme_prefs.json');
  }

  Future<void> initialize() async {
    // Durable file store first. Unlike NSUserDefaults/SharedPreferences - whose
    // writes sit in an in-memory cache that only flushes periodically, so a quick
    // force-quit right after a change loses it - this file is fsync'd on write,
    // so the theme sticks even if the app is closed immediately after switching.
    try {
      final file = await _prefsFile();
      if (await file.exists()) {
        final m = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        _themeMode = m['mode'] == 'light' ? ThemeMode.light : ThemeMode.dark;
        _breedId = (m['breed'] as String?) ?? 'red_fox';
        _invertColors = (m['invert'] as bool?) ?? false;
        _oledBlack = (m['oled'] as bool?) ?? false;
        _flipStrength = ((m['flip'] as num?)?.toDouble() ?? 0.0).clamp(0.0, 1.0);
        // Custom themes were removed; fall back if a saved selection points at one.
        if (_breedId.startsWith('custom')) _breedId = 'red_fox';
        notifyListeners();
        return;
      }
    } catch (_) {
      // Unreadable/corrupt - fall through and re-derive + rewrite below.
    }
    // No file yet: migrate any existing SharedPreferences values, then write the
    // durable copy so future launches read it instead.
    try {
      final prefs = await SharedPreferences.getInstance();
      _themeMode = prefs.getString(_themeKey) == 'light'
          ? ThemeMode.light
          : ThemeMode.dark;
      _breedId = prefs.getString(_breedKey) ?? 'red_fox';
      _invertColors = prefs.getBool(_invertKey) ?? false;
      _oledBlack = prefs.getBool('theme_oled') ?? false;
    } catch (_) {
      // No prefs either - keep the defaults.
    }
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final data = jsonEncode({
      'mode': _themeMode == ThemeMode.dark ? 'dark' : 'light',
      'breed': _breedId,
      'invert': _invertColors,
      'oled': _oledBlack,
      'flip': _flipStrength,
    });
    try {
      final file = await _prefsFile();
      // flush:true fsyncs, so the value is on disk before this returns.
      await file.writeAsString(data, flush: true);
    } catch (_) {
      // Best-effort - a failed write just means it falls back to the last saved.
    }
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners(); // flip the UI immediately
    await _save(); // then persist durably
  }

  Future<void> setBreed(String breedId) async {
    _breedId = breedId;
    notifyListeners();
    await _save();
  }

  Future<void> setInvertColors(bool value) async {
    if (_invertColors == value) return;
    _invertColors = value;
    notifyListeners();
    await _save();
  }

  Future<void> setOledBlack(bool value) async {
    if (_oledBlack == value) return;
    _oledBlack = value;
    notifyListeners();
    await _save();
  }

  Timer? _flipSaveTimer;
  void setFlipStrength(double value) {
    final v = value.clamp(0.0, 1.0);
    if ((v - _flipStrength).abs() < 0.001) return;
    _flipStrength = v;
    notifyListeners(); // live preview
    // Debounce the fsync so dragging the slider doesn't write the file per step.
    _flipSaveTimer?.cancel();
    _flipSaveTimer = Timer(const Duration(milliseconds: 400), _save);
  }

  /// All available theme breeds.
  static const Map<String, ThemeBreedColors> themeBreeds = {
    'red_fox': ThemeBreedColors(
      primaryLight: Color(0xFFE85D4A), primaryDark: Color(0xFFFF7A5C),
      accentLight: Color(0xFFF59E0B), accentDark: Color(0xFFFFB830),
      backgroundDark: Color(0xFF1A1008),
    ),
    'arctic_fox': ThemeBreedColors(
      primaryLight: Color(0xFF5B9BD5), primaryDark: Color(0xFF90C8F0),
      accentLight: Color(0xFF7EC8E3), accentDark: Color(0xFFAEDFF7),
      backgroundDark: Color(0xFF0D1520),
    ),
    'silver_fox': ThemeBreedColors(
      primaryLight: Color(0xFF6B7280), primaryDark: Color(0xFFB0B8C8),
      accentLight: Color(0xFF9CA3AF), accentDark: Color(0xFFD1D5DB),
      backgroundDark: Color(0xFF0F1117),
    ),
    'marble_fox': ThemeBreedColors(
      primaryLight: Color(0xFF1F2937), primaryDark: Color(0xFFF9FAFB),
      accentLight: Color(0xFF374151), accentDark: Color(0xFFE5E7EB),
      backgroundDark: Color(0xFF111827),
    ),
    'cross_fox': ThemeBreedColors(
      primaryLight: Color(0xFF92400E), primaryDark: Color(0xFFD97706),
      accentLight: Color(0xFFB45309), accentDark: Color(0xFFF59E0B),
      backgroundDark: Color(0xFF1C1208),
    ),
    'fennec_fox': ThemeBreedColors(
      primaryLight: Color(0xFFD4A574), primaryDark: Color(0xFFE8C49A),
      accentLight: Color(0xFFC8956C), accentDark: Color(0xFFDDB88A),
      backgroundDark: Color(0xFF1A1508),
    ),
    'digi_fox': ThemeBreedColors(
      primaryLight: Color(0xFF7C3AED), primaryDark: Color(0xFF9D5CF6),
      accentLight: Color(0xFFA855F7), accentDark: Color(0xFFC084FC),
      backgroundDark: Color(0xFF0F0A1A),
    ),
  };
}

class ThemeBreedColors {
  final Color primaryLight;
  final Color primaryDark;
  final Color accentLight;
  final Color accentDark;
  final Color backgroundDark;

  const ThemeBreedColors({
    required this.primaryLight,
    required this.primaryDark,
    required this.accentLight,
    required this.accentDark,
    required this.backgroundDark,
  });
}
