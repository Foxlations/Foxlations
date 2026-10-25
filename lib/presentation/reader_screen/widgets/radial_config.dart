import 'package:flutter/material.dart';

import '../../../core/services/settings_store.dart';

/// User customization of the in-reader radial wheel, stored per content type
/// (manga vs light novel) since the two readers expose different actions.
///
/// Persisted as a compact `key:1,key2:0,...` string per type: the ORDER is the
/// wheel order, and `:1`/`:0` is enabled/disabled. On load it's merged with the
/// canonical list below, so actions added in a later build appear automatically
/// (appended, enabled) without wiping a user's saved order.
class RadialMenuConfig {
  RadialMenuConfig._();

  /// (stable key, icon, human label) for every action the MANGA wheel can show,
  /// in the default order. Availability (e.g. auto-scroll only in continuous
  /// mode) is decided at runtime by the reader, not here.
  static const List<(String, IconData, String)> manga = [
    ('settings', Icons.tune_rounded, 'Settings'),
    ('bookmark', Icons.bookmark_border_rounded, 'Bookmark'),
    ('autoscroll', Icons.play_circle_outline_rounded, 'Auto-scroll'),
    ('prev', Icons.keyboard_double_arrow_left_rounded, 'Previous chapter'),
    ('next', Icons.keyboard_double_arrow_right_rounded, 'Next chapter'),
    ('scroll', Icons.visibility_rounded, 'Gaze / tilt scroll'),
    ('translate', Icons.translate_rounded, 'AI translate'),
  ];

  /// Same, for the LIGHT-NOVEL wheel.
  static const List<(String, IconData, String)> novel = [
    ('size', Icons.format_size_rounded, 'Text size'),
    ('font', Icons.font_download_rounded, 'Font'),
    ('theme', Icons.palette_rounded, 'Theme'),
    ('align', Icons.format_align_left_rounded, 'Alignment'),
    ('spacing', Icons.format_line_spacing_rounded, 'Line spacing'),
    ('listen', Icons.headphones_rounded, 'Listen (TTS)'),
  ];

  static List<(String, IconData, String)> canonicalFor(String type) =>
      type == 'novel' ? novel : manga;

  static String _storeKey(String type) => 'radial_order_$type';

  /// Ordered `(key, enabled)` for [type] (`'manga'` | `'novel'`), the saved
  /// order merged with the canonical list (unknown keys dropped, new keys
  /// appended enabled).
  static List<(String, bool)> load(String type) {
    final canonical = canonicalFor(type);
    final valid = {for (final c in canonical) c.$1};
    final raw = SettingsStore.instance.getString(_storeKey(type)) ?? '';

    final enabled = <String, bool>{};
    final order = <String>[];
    for (final part in raw.split(',')) {
      if (part.isEmpty) continue;
      final i = part.indexOf(':');
      if (i <= 0) continue;
      final k = part.substring(0, i);
      if (!valid.contains(k) || enabled.containsKey(k)) continue;
      enabled[k] = part.substring(i + 1) == '1';
      order.add(k);
    }
    // Append any canonical keys the saved string didn't cover (new actions).
    for (final c in canonical) {
      if (!enabled.containsKey(c.$1)) {
        enabled[c.$1] = true;
        order.add(c.$1);
      }
    }
    return [for (final k in order) (k, enabled[k]!)];
  }

  static Future<void> save(String type, List<(String, bool)> entries) {
    final s = entries.map((e) => '${e.$1}:${e.$2 ? '1' : '0'}').join(',');
    return SettingsStore.instance.setString(_storeKey(type), s);
  }

  /// Enabled action keys, in order - what the reader filters its built actions
  /// by. Availability still applies on top (a key enabled here but unavailable
  /// now, e.g. auto-scroll in a paged mode, is simply skipped by the reader).
  static List<String> enabledOrder(String type) =>
      [for (final e in load(type)) if (e.$2) e.$1];

  // ── Slider-tail chapter arrows (manga only - the LN tail shows title/chapter,
  // not a page slider). Opt-in: prev/next chapter buttons flank the page slider.
  static String _tailNavKey(String type) => 'radial_tailnav_$type';

  static bool tailChapterNav(String type) =>
      SettingsStore.instance.getBool(_tailNavKey(type)) ?? false;

  static Future<void> setTailChapterNav(String type, bool v) =>
      SettingsStore.instance.setBool(_tailNavKey(type), v);
}
