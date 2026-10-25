import 'dart:io';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/beta_badge.dart';
import '../../../core/services/gaze_scroll_service.dart';
import '../../../core/services/settings_store.dart';
import '../../../core/services/tilt_scroll_service.dart';
import '../../reader_screen/widgets/gaze_calibration_screen.dart';
import '../../widgets/ds/ds.dart';
import 'reader_settings_page.dart' show ReaderPrefs;
import 'settings_tiles.dart';

/// Hands-free & motion controls, shared by both readers and reached from the
/// bottom of each reader settings tab. Volume buttons, tilt-to-scroll and
/// gaze-to-scroll all drive the same scroll loop, so they are mutually exclusive
/// (turning one on turns the others off). Everything here is a beta feature.
class HandsFreeScrollSettingsPage extends StatefulWidget {
  const HandsFreeScrollSettingsPage({super.key});

  @override
  State<HandsFreeScrollSettingsPage> createState() =>
      _HandsFreeScrollSettingsPageState();
}

class _HandsFreeScrollSettingsPageState
    extends State<HandsFreeScrollSettingsPage> {
  bool _volumeKeys = false;
  double _volumeScrollSpeed = 600.0;
  bool _gazeSupported = false;
  bool _gazeEnabled = false;
  String _gazeMode = 'combined'; // native id: combined / eyesOnly / headOnly
  double _gazeThreshold = 0.8;
  double _gazeDwell = 300;
  double _gazeSmoothing = 0.25;
  bool _tiltEnabled = false;
  double _tiltThreshold = 0.20;
  double _tiltSmoothing = 0.20;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = SettingsStore.instance;
    setState(() {
      _volumeKeys = p.getBool(ReaderPrefs.volumeKeys) ?? false;
      _volumeScrollSpeed = p.getDouble(ReaderPrefs.volumeScrollSpeed) ?? 600.0;
      _gazeEnabled = p.getBool(ReaderPrefs.gazeEnabled) ?? false;
      _gazeMode = p.getString(ReaderPrefs.gazeMode) ?? 'combined';
      _gazeThreshold = p.getDouble(ReaderPrefs.gazeThreshold) ?? 0.8;
      _gazeDwell = p.getDouble(ReaderPrefs.gazeDwell) ?? 300;
      _gazeSmoothing = p.getDouble(ReaderPrefs.gazeSmoothing) ?? 0.25;
      _tiltEnabled = p.getBool(ReaderPrefs.tiltEnabled) ?? false;
      _tiltThreshold = p.getDouble(ReaderPrefs.tiltThreshold) ?? 0.20;
      _tiltSmoothing = p.getDouble(ReaderPrefs.tiltSmoothing) ?? 0.20;
    });
    final gazeSupported = await GazeScroll.isSupported();
    if (mounted) setState(() => _gazeSupported = gazeSupported);
  }

  Future<void> _setBool(String key, bool value) =>
      SettingsStore.instance.setBool(key, value);
  Future<void> _setDouble(String key, double value) =>
      SettingsStore.instance.setDouble(key, value);
  Future<void> _setString(String key, String value) =>
      SettingsStore.instance.setString(key, value);

  // Tilt / gaze (and, on Android, volume page-turn) are mutually exclusive
  // scroll inputs; turning one on turns the others off so they never fight over
  // the loop. On iOS the volume buttons are NOT a scroll input (they only tune
  // auto-scroll speed), so they stay independent and are left untouched here.
  void _selectScrollInput(String on) {
    setState(() {
      if (!Platform.isIOS) _volumeKeys = on == 'volume';
      _tiltEnabled = on == 'tilt';
      _gazeEnabled = on == 'gaze';
    });
    if (!Platform.isIOS) _setBool(ReaderPrefs.volumeKeys, _volumeKeys);
    _setBool(ReaderPrefs.tiltEnabled, _tiltEnabled);
    _setBool(ReaderPrefs.gazeEnabled, _gazeEnabled);
  }

  /// iOS can't intercept the volume buttons; the workaround watches the system
  /// volume and pins it to 50%, so warn the user (esp. that playing audio gets
  /// stuck) first.
  Future<bool> _confirmIosVolume() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.readerExperimentalOnIos,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        content: Text(t.readerIosVolumeWarning,
            style: Theme.of(context).textTheme.bodyMedium),
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
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        content: Text(t.readerGazeCameraWarning,
            style: Theme.of(context).textTheme.bodyMedium),
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
      mode: _gazeMode,
      threshold: _gazeThreshold,
      dwellMs: _gazeDwell.round(),
      smoothing: _gazeSmoothing,
    ));
    if (!mounted) return;
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const GazeCalibrationScreen()));
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w700);
    // Gaze-mode choices: stored as the native id, shown as a localized label.
    final gazeModes = <(String, String)>[
      ('eyesOnly', t.readerGazeModeEyes),
      ('headOnly', t.readerGazeModeHead),
      ('combined', t.readerGazeModeBoth),
    ];
    String gazeLabel(String id) =>
        gazeModes.firstWhere((e) => e.$1 == id, orElse: () => gazeModes.last).$2;
    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(t.readerHandsFreeMotion, style: titleStyle),
          const SizedBox(width: 8),
          const BetaBadge(),
        ]),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                  t.readerHandsFreeIntro,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: cs.outline)),
            ),

            // ── Volume buttons ─────────────────────────────────
            SettingsSectionHeader(title: t.readerVolumeButtons, beta: true),
            if (Platform.isIOS)
              // iOS: the volume buttons only tune the manga auto-scroll speed,
              // and only while it is running (they never turn pages). So this is
              // its own control, independent of tilt / gaze.
              AppSettingsSwitchTile(
                  icon: Icons.volume_up_rounded,
                  iconColor: AppTheme.secondary,
                  title: t.readerVolumeAutoScroll,
                  subtitle: t.readerVolumeAutoScrollSubtitle,
                  value: _volumeKeys,
                  onChanged: (v) async {
                    if (v && !await _confirmIosVolume()) return;
                    setState(() => _volumeKeys = v);
                    _setBool(ReaderPrefs.volumeKeys, v);
                  })
            else ...[
              AppSettingsSwitchTile(
                  icon: Icons.volume_up_rounded,
                  iconColor: AppTheme.secondary,
                  title: t.readerVolumeKeys,
                  subtitle: t.readerVolumeKeysSubtitle,
                  value: _volumeKeys,
                  onChanged: (v) => _selectScrollInput(v ? 'volume' : 'none')),
              if (_volumeKeys)
                SettingsSliderTile(
                    icon: Icons.speed_rounded,
                    iconColor: AppTheme.secondary,
                    title: t.readerHoldScrollSpeed,
                    value: _volumeScrollSpeed,
                    min: 150,
                    max: 2000,
                    divisions: 37,
                    onChanged: (v) {
                      setState(() => _volumeScrollSpeed = v);
                      _setDouble(ReaderPrefs.volumeScrollSpeed, v);
                    }),
            ],

            // ── Tilt to scroll ─────────────────────────────────
            SettingsSectionHeader(title: t.readerTiltScroll, beta: true),
            AppSettingsSwitchTile(
                icon: Icons.screen_rotation_rounded,
                iconColor: AppTheme.secondary,
                title: t.readerTiltScroll,
                subtitle: t.readerTiltScrollSubtitle,
                value: _tiltEnabled,
                onChanged: (v) => _selectScrollInput(v ? 'tilt' : 'none')),
            if (_tiltEnabled) ...[
              SettingsSliderTile(
                  icon: Icons.tune_rounded,
                  iconColor: AppTheme.secondary,
                  title: t.readerGazeSensitivity,
                  value: _tiltThreshold,
                  min: 0.08,
                  max: 0.5,
                  divisions: 21,
                  onChanged: (v) {
                    setState(() => _tiltThreshold = v);
                    _setDouble(ReaderPrefs.tiltThreshold, v);
                  }),
              SettingsSliderTile(
                  icon: Icons.blur_on_rounded,
                  iconColor: AppTheme.secondary,
                  title: t.readerGazeSmoothing,
                  value: _tiltSmoothing,
                  min: 0.05,
                  max: 0.5,
                  divisions: 18,
                  onChanged: (v) {
                    setState(() => _tiltSmoothing = v);
                    _setDouble(ReaderPrefs.tiltSmoothing, v);
                  }),
              SettingsSliderTile(
                  icon: Icons.speed_rounded,
                  iconColor: AppTheme.secondary,
                  title: t.readerScrollSpeed,
                  value: _volumeScrollSpeed,
                  min: 150,
                  max: 2000,
                  divisions: 37,
                  onChanged: (v) {
                    setState(() => _volumeScrollSpeed = v);
                    _setDouble(ReaderPrefs.volumeScrollSpeed, v);
                  }),
              ListTile(
                leading: Icon(Icons.center_focus_strong_rounded,
                    color: AppTheme.secondary),
                title: Text(t.readerGazeCalibrate,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(t.readerTiltCalibrateSubtitle,
                    style: Theme.of(context).textTheme.bodySmall),
                onTap: _calibrateTilt,
              ),
            ],

            // ── Gaze to scroll (iOS front-camera) ──────────────
            if (_gazeSupported) ...[
              SettingsSectionHeader(title: t.readerGazeScroll, beta: true),
              AppSettingsSwitchTile(
                  icon: Icons.visibility_rounded,
                  iconColor: AppTheme.secondary,
                  title: t.readerGazeScroll,
                  subtitle: t.readerGazeScrollSubtitle,
                  value: _gazeEnabled,
                  onChanged: (v) async {
                    if (v && !await _confirmIosGaze()) return;
                    _selectScrollInput(v ? 'gaze' : 'none');
                  }),
              if (_gazeEnabled) ...[
                AppSettingsChoiceTile(
                    icon: Icons.control_camera_rounded,
                    iconColor: AppTheme.secondary,
                    title: t.readerGazeMode,
                    value: gazeLabel(_gazeMode),
                    options: gazeModes.map((e) => e.$2).toList(),
                    onChanged: (v) {
                      final id = gazeModes.firstWhere((e) => e.$2 == v).$1;
                      setState(() => _gazeMode = id);
                      _setString(ReaderPrefs.gazeMode, id);
                    }),
                SettingsSliderTile(
                    icon: Icons.tune_rounded,
                    iconColor: AppTheme.secondary,
                    title: t.readerGazeSensitivity,
                    value: _gazeThreshold,
                    min: 0.25,
                    max: 0.9,
                    divisions: 13,
                    onChanged: (v) {
                      setState(() => _gazeThreshold = v);
                      _setDouble(ReaderPrefs.gazeThreshold, v);
                    }),
                SettingsSliderTile(
                    icon: Icons.timer_outlined,
                    iconColor: AppTheme.secondary,
                    title: t.readerGazeHoldTime,
                    value: _gazeDwell,
                    min: 150,
                    max: 800,
                    divisions: 13,
                    onChanged: (v) {
                      setState(() => _gazeDwell = v);
                      _setDouble(ReaderPrefs.gazeDwell, v);
                    }),
                SettingsSliderTile(
                    icon: Icons.blur_on_rounded,
                    iconColor: AppTheme.secondary,
                    title: t.readerGazeSmoothing,
                    value: _gazeSmoothing,
                    min: 0.1,
                    max: 0.6,
                    divisions: 25,
                    onChanged: (v) {
                      setState(() => _gazeSmoothing = v);
                      _setDouble(ReaderPrefs.gazeSmoothing, v);
                    }),
                SettingsSliderTile(
                    icon: Icons.speed_rounded,
                    iconColor: AppTheme.secondary,
                    title: t.readerScrollSpeed,
                    value: _volumeScrollSpeed,
                    min: 150,
                    max: 2000,
                    divisions: 37,
                    onChanged: (v) {
                      setState(() => _volumeScrollSpeed = v);
                      _setDouble(ReaderPrefs.volumeScrollSpeed, v);
                    }),
                ListTile(
                  leading: Icon(Icons.center_focus_strong_rounded,
                      color: AppTheme.secondary),
                  title: Text(t.readerGazeCalibrate,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text(t.readerGazeCalibrateSubtitle,
                      style: Theme.of(context).textTheme.bodySmall),
                  onTap: _calibrateGaze,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
