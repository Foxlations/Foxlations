import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/beta_provider.dart';
import '../../../widgets/beta_badge.dart';
import '../../../core/services/gaze_scroll_service.dart';
import '../../../core/services/settings_store.dart';
import '../../../core/services/tilt_scroll_service.dart';
import '../../reader_screen/widgets/gaze_calibration_screen.dart';

/// Reader preference keys. The reader screen and ReaderProvider read from
/// these same keys, so toggling here takes effect on the next chapter open.
class ReaderPrefs {
  // Stored as int (ReadingMode enum index). Same key the reader uses.
  static const readingMode = 'reader_reading_mode';
  static const scaleType = 'reader_scale_type';
  static const navLayout = 'reader_nav_layout';
  static const bgColor = 'reader_bg_color';
  static const keepScreenOn = 'reader_keep_screen_on';
  static const showPageNumber = 'reader_show_page_num';
  static const fullscreen = 'reader_fullscreen';
  static const grayscale = 'reader_grayscale';
  static const warmTint = 'reader_warm_tint';
  static const brightness = 'reader_brightness';
  static const dualPage = 'reader_dual_page';
  static const dualPageSplit = 'reader_dual_page_split';
  static const invertColors = 'reader_invert_colors';
  static const invertTapZones = 'reader_invert_tap';
  static const volumeKeys = 'reader_volume_keys';
  static const volumeScrollSpeed = 'reader_volume_scroll_speed';
  static const gazeEnabled = 'reader_gaze_enabled';
  static const gazeMode = 'reader_gaze_mode';
  static const gazeThreshold = 'reader_gaze_threshold';
  static const gazeDwell = 'reader_gaze_dwell';
  static const gazeSmoothing = 'reader_gaze_smoothing';
  static const tiltEnabled = 'reader_tilt_enabled';
  static const tiltThreshold = 'reader_tilt_threshold';
  static const tiltSmoothing = 'reader_tilt_smoothing';
  static const autoPreload = 'reader_auto_preload';
  static const autoCrop = 'reader_auto_crop';
  static const fontSize = 'reader_font_size';
  static const radialEnabled = 'reader_radial_enabled';
  static const radialSide = 'reader_radial_side';
}

/// Reading mode labels — kept in sync with [ReadingMode] enum order
/// (ltr, rtl, vertical, webtoon) so the int index round-trips cleanly.
const _readingModeLabels = ['LTR', 'RTL', 'Vertical', 'Webtoon'];

class ReaderSettingsPage extends StatefulWidget {
  const ReaderSettingsPage({super.key});
  @override
  State<ReaderSettingsPage> createState() => _ReaderSettingsPageState();
}

class _ReaderSettingsPageState extends State<ReaderSettingsPage> {
  String _readingMode = 'LTR';
  String _scaleType = 'Fit Screen';
  String _navLayout = 'Right & Left';
  String _bgColor = 'Black';
  bool _keepScreenOn = true;
  bool _showPageNumber = true;
  bool _fullscreen = true;
  bool _grayscale = false;
  bool _invertColors = false;
  bool _invertTapZones = false;
  bool _volumeKeys = false;
  double _volumeScrollSpeed = 600.0;
  bool _autoPreload = true;
  bool _autoCrop = false;
  double _fontSize = 16.0;
  double _warmTint = 0.0;
  double _brightness = 1.0;
  bool _dualPage = false;
  bool _dualPageSplit = false;
  bool _gazeSupported = false;
  bool _gazeEnabled = false;
  String _gazeMode = 'Both';
  double _gazeThreshold = 0.8;
  double _gazeDwell = 300;
  double _gazeSmoothing = 0.25;
  bool _tiltEnabled = false;
  double _tiltThreshold = 0.20;
  double _tiltSmoothing = 0.20;
  bool _radialEnabled = false;
  String _radialSide = 'right';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final p = SettingsStore.instance;
    setState(() {
      // ReaderProvider stores reading mode as ReadingMode enum index.
      final modeIdx = (p.getInt(ReaderPrefs.readingMode) ?? 0)
          .clamp(0, _readingModeLabels.length - 1);
      _readingMode = _readingModeLabels[modeIdx];
      _scaleType = p.getString(ReaderPrefs.scaleType) ?? 'Fit Screen';
      _navLayout = p.getString(ReaderPrefs.navLayout) ?? 'Right & Left';
      _bgColor = p.getString(ReaderPrefs.bgColor) ?? 'Black';
      _keepScreenOn = p.getBool(ReaderPrefs.keepScreenOn) ?? true;
      _showPageNumber = p.getBool(ReaderPrefs.showPageNumber) ?? true;
      _fullscreen = p.getBool(ReaderPrefs.fullscreen) ?? true;
      _grayscale = p.getBool(ReaderPrefs.grayscale) ?? false;
      _invertColors = p.getBool(ReaderPrefs.invertColors) ?? false;
      _invertTapZones = p.getBool(ReaderPrefs.invertTapZones) ?? false;
      _volumeKeys = p.getBool(ReaderPrefs.volumeKeys) ?? false;
      _volumeScrollSpeed = p.getDouble(ReaderPrefs.volumeScrollSpeed) ?? 600.0;
      _autoPreload = p.getBool(ReaderPrefs.autoPreload) ?? true;
      _autoCrop = p.getBool(ReaderPrefs.autoCrop) ?? false;
      _fontSize = p.getDouble(ReaderPrefs.fontSize) ?? 16.0;
      _warmTint = (p.getDouble(ReaderPrefs.warmTint) ?? 0.0).clamp(0.0, 1.0);
      _brightness = (p.getDouble(ReaderPrefs.brightness) ?? 1.0).clamp(0.15, 1.0);
      _dualPage = p.getBool(ReaderPrefs.dualPage) ?? false;
      _dualPageSplit = p.getBool(ReaderPrefs.dualPageSplit) ?? false;
      _gazeEnabled = p.getBool(ReaderPrefs.gazeEnabled) ?? false;
      _gazeMode = _nativeToDisplay(p.getString(ReaderPrefs.gazeMode) ?? 'combined');
      _gazeThreshold = p.getDouble(ReaderPrefs.gazeThreshold) ?? 0.8;
      _gazeDwell = p.getDouble(ReaderPrefs.gazeDwell) ?? 300;
      _gazeSmoothing = p.getDouble(ReaderPrefs.gazeSmoothing) ?? 0.25;
      _tiltEnabled = p.getBool(ReaderPrefs.tiltEnabled) ?? false;
      _tiltThreshold = p.getDouble(ReaderPrefs.tiltThreshold) ?? 0.20;
      _tiltSmoothing = p.getDouble(ReaderPrefs.tiltSmoothing) ?? 0.20;
      _radialEnabled = p.getBool(ReaderPrefs.radialEnabled) ?? false;
      _radialSide = p.getString(ReaderPrefs.radialSide) ?? 'right';
    });
    final gazeSupported = await GazeScroll.isSupported();
    if (mounted) setState(() => _gazeSupported = gazeSupported);
  }

  Future<void> _setBool(String key, bool value) async {
    await SettingsStore.instance.setBool(key, value);
  }

  Future<void> _setString(String key, String value) async {
    await SettingsStore.instance.setString(key, value);
  }

  Future<void> _setDouble(String key, double value) async {
    await SettingsStore.instance.setDouble(key, value);
  }

  // Hands-free (gaze) scrolling: display labels map to native mode ids.
  String _displayToNative(String d) =>
      d == 'Eyes' ? 'eyesOnly' : (d == 'Head' ? 'headOnly' : 'combined');
  String _nativeToDisplay(String n) =>
      n == 'eyesOnly' ? 'Eyes' : (n == 'headOnly' ? 'Head' : 'Both');

  /// Gaze scrolling uses the front camera; warn (camera + battery) before enabling.
  Future<bool> _confirmIosGaze() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.readerGazeCameraTitle,
            style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Text(t.readerGazeCameraWarning,
            style: GoogleFonts.manrope(fontSize: 13)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.readerCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.readerEnable)),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _calibrateGaze() async {
    await GazeScroll.updateSettings(GazeSettings(
      mode: _displayToNative(_gazeMode),
      threshold: _gazeThreshold,
      dwellMs: _gazeDwell.round(),
      smoothing: _gazeSmoothing,
    ));
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const GazeCalibrationScreen()));
  }

  // Volume / tilt / gaze are mutually exclusive scroll inputs — turning one on
  // turns the others off (state + prefs) so they never fight over the loop.
  void _selectScrollInput(String on) {
    setState(() {
      _volumeKeys = on == 'volume';
      _tiltEnabled = on == 'tilt';
      _gazeEnabled = on == 'gaze';
    });
    _setBool(ReaderPrefs.volumeKeys, _volumeKeys);
    _setBool(ReaderPrefs.tiltEnabled, _tiltEnabled);
    _setBool(ReaderPrefs.gazeEnabled, _gazeEnabled);
  }

  Future<void> _calibrateTilt() async {
    final t = AppLocalizations.of(context);
    TiltScroll.updateSettings(
        TiltSettings(threshold: _tiltThreshold, smoothing: _tiltSmoothing));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.readerTiltCalibrating),
        duration: const Duration(milliseconds: 1400)));
    await TiltScroll.calibrate(durationMs: 1200);
  }

  /// iOS can't intercept the volume buttons; the workaround watches the system volume
  /// and pins it to 50%, so warn the user (esp. that playing audio gets stuck) first.
  Future<bool> _confirmIosVolume() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.readerExperimentalOnIos,
            style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Text(
          t.readerIosVolumeWarning,
          style: GoogleFonts.manrope(fontSize: 13),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.readerCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.readerEnable)),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final beta = context.watch<BetaProvider>().enabled;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface, elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context)),
        title: Text(t.readerTitle,
            style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: 8, bottom: 8 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          _SectionHeader(title: t.readerPreferences),
          _SegmentedTile(icon: Icons.auto_stories_rounded, iconColor: cs.primary,
              title: t.readerReadingMode,
              options: _readingModeLabels,
              selected: _readingMode,
              onChanged: (v) async {
                setState(() => _readingMode = v);
                final idx = _readingModeLabels.indexOf(v);
                if (idx >= 0) {
                  await SettingsStore.instance.setInt(ReaderPrefs.readingMode, idx);
                }
              }),
          _SliderTile(icon: Icons.text_fields_rounded, iconColor: cs.primary,
              title: t.readerFontSize, value: _fontSize, min: 10, max: 24, divisions: 14,
              onChanged: (v) {
                setState(() => _fontSize = v);
                _setDouble(ReaderPrefs.fontSize, v);
              }),
          _SwitchTile(icon: Icons.skip_next_rounded, iconColor: cs.primary,
              title: t.readerAutoPreloadNextChapter, subtitle: t.readerAutoPreloadNextChapterSubtitle,
              value: _autoPreload, onChanged: (v) {
                setState(() => _autoPreload = v);
                _setBool(ReaderPrefs.autoPreload, v);
              }),
          const SizedBox(height: 8),
          _SectionHeader(title: t.readerReadingMode),
          _SwitchTile(icon: Icons.filter_b_and_w_rounded, iconColor: cs.primary,
              title: t.readerGrayscale, subtitle: t.readerGrayscaleSubtitle,
              value: _grayscale, onChanged: (v) {
                setState(() => _grayscale = v);
                _setBool(ReaderPrefs.grayscale, v);
              }),
          if (beta)
            _SwitchTile(icon: Icons.crop_rounded, iconColor: cs.primary,
                title: t.readerAutoCrop, subtitle: t.readerAutoCropSubtitle,
                value: _autoCrop, onChanged: (v) {
                  setState(() => _autoCrop = v);
                  _setBool(ReaderPrefs.autoCrop, v);
                }),
          _SwitchTile(icon: Icons.invert_colors_rounded, iconColor: cs.primary,
              title: t.readerInvertColors, subtitle: t.readerInvertColorsSubtitle,
              value: _invertColors, onChanged: (v) {
                setState(() => _invertColors = v);
                _setBool(ReaderPrefs.invertColors, v);
              }),
          const SizedBox(height: 8),
          const _SectionHeader(title: 'Eye comfort'),
          _SliderTile(icon: Icons.wb_twilight_rounded, iconColor: AppTheme.warning,
              title: 'Warm filter', value: _warmTint, min: 0, max: 1, divisions: 10,
              onChanged: (v) {
                setState(() => _warmTint = v);
                _setDouble(ReaderPrefs.warmTint, v);
              }),
          _SliderTile(icon: Icons.brightness_6_rounded, iconColor: AppTheme.warning,
              title: 'Brightness', value: _brightness, min: 0.15, max: 1, divisions: 17,
              onChanged: (v) {
                setState(() => _brightness = v);
                _setDouble(ReaderPrefs.brightness, v);
              }),
          const SizedBox(height: 8),
          _SectionHeader(title: t.readerDisplay),
          _ChoiceTile(icon: Icons.aspect_ratio_rounded, iconColor: AppTheme.success,
              title: t.readerScaleType, value: _scaleType,
              options: const ['Fit Screen', 'Stretch', 'Fit Width', 'Fit Height', 'Original Size', 'Smart Fit'],
              onChanged: (v) {
                setState(() => _scaleType = v);
                _setString(ReaderPrefs.scaleType, v);
              }),
          _ChoiceTile(icon: Icons.format_color_fill_rounded, iconColor: AppTheme.success,
              title: t.readerBackgroundColor, value: _bgColor,
              options: const ['Black', 'Gray', 'White', 'Automatic'],
              onChanged: (v) {
                setState(() => _bgColor = v);
                _setString(ReaderPrefs.bgColor, v);
              }),
          _SwitchTile(icon: Icons.auto_stories_rounded, iconColor: AppTheme.success,
              title: 'Double pages',
              subtitle: 'Show two pages side-by-side when the phone is in '
                  'landscape (page-by-page modes only)',
              value: _dualPage, onChanged: (v) {
                setState(() => _dualPage = v);
                _setBool(ReaderPrefs.dualPage, v);
              }),
          if (_dualPage)
            _SwitchTile(icon: Icons.open_in_full_rounded, iconColor: AppTheme.success,
                title: 'Split wide pages',
                subtitle: 'Give a wide double-page spread its own screen instead '
                    'of pairing it with another page',
                value: _dualPageSplit, onChanged: (v) {
                  setState(() => _dualPageSplit = v);
                  _setBool(ReaderPrefs.dualPageSplit, v);
                }),
          _SwitchTile(icon: Icons.brightness_high_rounded, iconColor: AppTheme.success,
              title: t.readerKeepScreenOn, subtitle: t.readerKeepScreenOnSubtitle,
              value: _keepScreenOn, onChanged: (v) {
                setState(() => _keepScreenOn = v);
                _setBool(ReaderPrefs.keepScreenOn, v);
              }),
          _SwitchTile(icon: Icons.numbers_rounded, iconColor: AppTheme.success,
              title: t.readerShowPageNumber, subtitle: t.readerShowPageNumberSubtitle,
              value: _showPageNumber, onChanged: (v) {
                setState(() => _showPageNumber = v);
                _setBool(ReaderPrefs.showPageNumber, v);
              }),
          _SwitchTile(icon: Icons.fullscreen_rounded, iconColor: AppTheme.success,
              title: t.readerFullscreen, subtitle: t.readerFullscreenSubtitle,
              value: _fullscreen, onChanged: (v) {
                setState(() => _fullscreen = v);
                _setBool(ReaderPrefs.fullscreen, v);
              }),
          const SizedBox(height: 8),
          _SectionHeader(title: t.readerNavigation),
          _ChoiceTile(icon: Icons.touch_app_rounded, iconColor: AppTheme.secondary,
              title: t.readerNavigationLayout, value: _navLayout,
              options: const ['Right & Left', 'L-shaped', 'Kindle-like', 'Edge', 'Disabled'],
              onChanged: (v) {
                setState(() => _navLayout = v);
                _setString(ReaderPrefs.navLayout, v);
              }),
          _SwitchTile(icon: Icons.swap_horiz_rounded, iconColor: AppTheme.secondary,
              title: t.readerInvertTapZones, subtitle: t.readerInvertTapZonesSubtitle,
              value: _invertTapZones, onChanged: (v) {
                setState(() => _invertTapZones = v);
                _setBool(ReaderPrefs.invertTapZones, v);
              }),
          if (beta) ...[
            _SwitchTile(icon: Icons.volume_up_rounded, iconColor: AppTheme.secondary,
                title: t.readerVolumeKeys,
                subtitle: t.readerVolumeKeysSubtitle,
                betaTrailing: true,
                value: _volumeKeys, onChanged: (v) async {
                  // iOS has no real volume-button API — warn before enabling.
                  if (v && Platform.isIOS && !await _confirmIosVolume()) return;
                  _selectScrollInput(v ? 'volume' : 'none');
                }),
            if (_volumeKeys)
              _SliderTile(icon: Icons.speed_rounded, iconColor: AppTheme.secondary,
                  title: t.readerHoldScrollSpeed, value: _volumeScrollSpeed,
                  min: 150, max: 2000, divisions: 37,
                  onChanged: (v) {
                    setState(() => _volumeScrollSpeed = v);
                    _setDouble(ReaderPrefs.volumeScrollSpeed, v);
                  }),
          ],
          const SizedBox(height: 8),
          _SectionHeader(title: t.readerRadialMenu),
          _SwitchTile(icon: Icons.blur_circular_rounded, iconColor: AppTheme.secondary,
              title: t.readerRadialMenu, subtitle: t.readerRadialMenuSubtitle,
              value: _radialEnabled, onChanged: (v) {
                setState(() => _radialEnabled = v);
                _setBool(ReaderPrefs.radialEnabled, v);
              }),
          if (_radialEnabled)
            _ChoiceTile(icon: Icons.align_horizontal_right_rounded,
                iconColor: AppTheme.secondary,
                title: t.readerRadialCorner,
                value: _radialSide == 'left' ? 'Left' : 'Right',
                options: const ['Left', 'Right'],
                onChanged: (v) {
                  final side = v == 'Left' ? 'left' : 'right';
                  setState(() => _radialSide = side);
                  _setString(ReaderPrefs.radialSide, side);
                }),
          if (beta) ...[
          const SizedBox(height: 8),
          _SectionHeader(title: t.readerTiltScroll, beta: true),
          _SwitchTile(icon: Icons.screen_rotation_rounded, iconColor: AppTheme.secondary,
              title: t.readerTiltScroll, subtitle: t.readerTiltScrollSubtitle,
              value: _tiltEnabled, onChanged: (v) {
                _selectScrollInput(v ? 'tilt' : 'none');
              }),
          if (_tiltEnabled) ...[
            _SliderTile(icon: Icons.tune_rounded, iconColor: AppTheme.secondary,
                title: t.readerGazeSensitivity, value: _tiltThreshold,
                min: 0.08, max: 0.5, divisions: 21,
                onChanged: (v) {
                  setState(() => _tiltThreshold = v);
                  _setDouble(ReaderPrefs.tiltThreshold, v);
                }),
            _SliderTile(icon: Icons.blur_on_rounded, iconColor: AppTheme.secondary,
                title: t.readerGazeSmoothing, value: _tiltSmoothing,
                min: 0.05, max: 0.5, divisions: 18,
                onChanged: (v) {
                  setState(() => _tiltSmoothing = v);
                  _setDouble(ReaderPrefs.tiltSmoothing, v);
                }),
            _SliderTile(icon: Icons.speed_rounded, iconColor: AppTheme.secondary,
                title: t.readerScrollSpeed, value: _volumeScrollSpeed,
                min: 150, max: 2000, divisions: 37,
                onChanged: (v) {
                  setState(() => _volumeScrollSpeed = v);
                  _setDouble(ReaderPrefs.volumeScrollSpeed, v);
                }),
            ListTile(
              leading: Icon(Icons.center_focus_strong_rounded,
                  color: AppTheme.secondary),
              title: Text(t.readerGazeCalibrate,
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
              subtitle: Text(t.readerTiltCalibrateSubtitle,
                  style: GoogleFonts.manrope(fontSize: 12)),
              onTap: _calibrateTilt,
            ),
          ],
          if (_gazeSupported) ...[
            const SizedBox(height: 8),
            _SectionHeader(title: t.readerGazeScroll, beta: true),
            _SwitchTile(icon: Icons.visibility_rounded, iconColor: AppTheme.secondary,
                title: t.readerGazeScroll, subtitle: t.readerGazeScrollSubtitle,
                value: _gazeEnabled, onChanged: (v) async {
                  if (v && !await _confirmIosGaze()) return;
                  _selectScrollInput(v ? 'gaze' : 'none');
                }),
            if (_gazeEnabled) ...[
              _ChoiceTile(icon: Icons.control_camera_rounded, iconColor: AppTheme.secondary,
                  title: t.readerGazeMode, value: _gazeMode,
                  options: const ['Eyes', 'Head', 'Both'],
                  onChanged: (v) {
                    setState(() => _gazeMode = v);
                    _setString(ReaderPrefs.gazeMode, _displayToNative(v));
                  }),
              _SliderTile(icon: Icons.tune_rounded, iconColor: AppTheme.secondary,
                  title: t.readerGazeSensitivity, value: _gazeThreshold,
                  min: 0.25, max: 0.9, divisions: 13,
                  onChanged: (v) {
                    setState(() => _gazeThreshold = v);
                    _setDouble(ReaderPrefs.gazeThreshold, v);
                  }),
              _SliderTile(icon: Icons.timer_outlined, iconColor: AppTheme.secondary,
                  title: t.readerGazeHoldTime, value: _gazeDwell,
                  min: 150, max: 800, divisions: 13,
                  onChanged: (v) {
                    setState(() => _gazeDwell = v);
                    _setDouble(ReaderPrefs.gazeDwell, v);
                  }),
              _SliderTile(icon: Icons.blur_on_rounded, iconColor: AppTheme.secondary,
                  title: t.readerGazeSmoothing, value: _gazeSmoothing,
                  min: 0.1, max: 0.6, divisions: 25,
                  onChanged: (v) {
                    setState(() => _gazeSmoothing = v);
                    _setDouble(ReaderPrefs.gazeSmoothing, v);
                  }),
              _SliderTile(icon: Icons.speed_rounded, iconColor: AppTheme.secondary,
                  title: t.readerScrollSpeed, value: _volumeScrollSpeed,
                  min: 150, max: 2000, divisions: 37,
                  onChanged: (v) {
                    setState(() => _volumeScrollSpeed = v);
                    _setDouble(ReaderPrefs.volumeScrollSpeed, v);
                  }),
              ListTile(
                leading: Icon(Icons.center_focus_strong_rounded,
                    color: AppTheme.secondary),
                title: Text(t.readerGazeCalibrate,
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                subtitle: Text(t.readerGazeCalibrateSubtitle,
                    style: GoogleFonts.manrope(fontSize: 12)),
                onTap: _calibrateGaze,
              ),
            ],
          ],
          ], // end: hands-free (beta)
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Shared Tile Widgets ──────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool beta;
  const _SectionHeader({required this.title, this.beta = false});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(children: [
        Text(title.toUpperCase(),
            style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: cs.primary)),
        if (beta) ...[const SizedBox(width: 8), const BetaBadge()],
      ]),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title; final String subtitle;
  final bool value; final ValueChanged<bool> onChanged;
  final bool betaTrailing;
  const _SwitchTile({required this.icon, required this.iconColor, required this.title,
      required this.subtitle, required this.value, required this.onChanged,
      this.betaTrailing = false});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Row(children: [
        Container(width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface))),
            if (betaTrailing) ...[const SizedBox(width: 8), const BetaBadge()],
          ]),
          Text(subtitle, style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
        ])),
        Switch(value: value, onChanged: onChanged, activeThumbColor: cs.onPrimary, activeTrackColor: cs.primary),
      ]),
    );
  }
}

class _SegmentedTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title;
  final List<String> options; final String selected; final ValueChanged<String> onChanged;
  const _SegmentedTile({required this.icon, required this.iconColor, required this.title,
      required this.options, required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(color: iconColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18)),
          const SizedBox(width: 12),
          Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 6, runSpacing: 6, children: options.map((opt) {
          final isSelected = opt == selected;
          return GestureDetector(
            onTap: () => onChanged(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : cs.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(color: isSelected ? cs.primary : cs.outlineVariant)),
              child: Text(opt, style: GoogleFonts.manrope(fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? cs.onPrimary : cs.onSurface)),
            ),
          );
        }).toList()),
      ]),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title;
  final double value; final double min; final double max; final int? divisions;
  final ValueChanged<double> onChanged;
  const _SliderTile({required this.icon, required this.iconColor, required this.title,
      required this.value, required this.min, required this.max, this.divisions, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Column(children: [
        Row(children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(color: iconColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: cs.primary.withAlpha(26), borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
            child: Text(value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: cs.primary))),
        ]),
        SliderTheme(
          data: SliderThemeData(activeTrackColor: cs.primary, inactiveTrackColor: cs.surface,
              thumbColor: cs.primary, overlayColor: cs.primary.withAlpha(26)),
          child: Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged)),
      ]),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title; final String value;
  final List<String> options; final ValueChanged<String> onChanged;
  const _ChoiceTile({required this.icon, required this.iconColor, required this.title,
      required this.value, required this.options, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(context: context, backgroundColor: cs.surface,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge))),
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 36, height: 4,
                  decoration: BoxDecoration(color: cs.outline, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(title, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: cs.onSurface)),
              Divider(color: cs.outlineVariant),
              ...options.map((opt) {
                final isSelected = opt == value;
                return InkWell(
                  onTap: () { onChanged(opt); Navigator.pop(context); },
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                        color: isSelected ? cs.primary.withAlpha(26) : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
                    child: Row(children: [
                      Expanded(child: Text(opt, style: GoogleFonts.manrope(
                          fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: cs.onSurface))),
                      if (isSelected) Icon(Icons.check_rounded, size: 18, color: cs.primary),
                    ])));
              }),
            ])));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: cs.outlineVariant)),
        child: Row(children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(color: iconColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface))),
          Text(value, style: GoogleFonts.manrope(fontSize: 13, color: cs.outline)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20),
        ])));
  }
}
