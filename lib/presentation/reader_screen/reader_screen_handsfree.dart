part of 'reader_screen.dart';

/// Hands-free scrolling for the manga reader: gaze (front-camera, iOS) and tilt
/// input, their mutually-exclusive enable/toggle flow, the fluid scroll loop and
/// the long-press quick-tuning sheet. Split out of [_ReaderBodyState] and mixed
/// straight in, so behaviour is identical to when these members lived inline.
mixin _ReaderHandsFree on State<_ReaderBody> {
  // Hands-free (gaze) scrolling - iOS only.
  Timer? _gazeTimer;
  int _gazeDelta = 0;
  double _gazeSpeed = 0;
  bool _gazeActive = false;
  bool _gazeSupported = false;
  bool _tiltActive = false;

  // Provided by the host State (shared navigation / scroll machinery).
  double get _volScrollSpeed;
  set _volScrollSpeed(double v);
  PageController? get _pageController;
  ScrollOffsetController get _scrollOffsetController;
  void _flipPage(int delta);

  // ── Hands-free (gaze) scrolling ──────────────────────
  // iOS-only: continuous modes drive the fluid scroll loop; paged modes flip one
  // page per look (native emits one decision per dwell).
  Future<void> _maybeEnableGaze() async {
    _gazeSupported = await GazeScroll.isSupported();
    if (mounted) setState(() {});
    if (!_gazeSupported) return;
    final prefs = SettingsStore.instance;
    if (!(prefs.getBool('beta_features_enabled') ?? false)) return; // hands-free is beta
    if (!(prefs.getBool('reader_gaze_enabled') ?? false)) return;
    await _startGaze(prefs);
  }

  Future<void> _startGaze(SettingsStore prefs) async {
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    await GazeScroll.updateSettings(GazeSettings(
      mode: prefs.getString('reader_gaze_mode') ?? 'combined',
      threshold: prefs.getDouble('reader_gaze_threshold') ?? 0.8,
      dwellMs: (prefs.getDouble('reader_gaze_dwell') ?? 300).round(),
      smoothing: prefs.getDouble('reader_gaze_smoothing') ?? 0.25,
      useGeometric: prefs.getBool('reader_gaze_geometric') ?? true,
    ));
    if (!mounted) return;
    await GazeScroll.enable(_onGaze);
    if (mounted) setState(() => _gazeActive = true);
  }

  Future<void> _toggleGaze() async {
    final prefs = SettingsStore.instance;
    if (_gazeActive) {
      await GazeScroll.disable();
      await prefs.setBool('reader_gaze_enabled', false);
      _stopGazeScroll();
      if (mounted) setState(() => _gazeActive = false);
      return;
    }
    if (!await _confirmGazeCamera()) return;
    // Mutual exclusivity: gaze replaces tilt + volume.
    if (_tiltActive) {
      await TiltScroll.disable();
      if (mounted) setState(() => _tiltActive = false);
    }
    VolumeKeys.disable();
    await prefs.setBool('reader_tilt_enabled', false);
    await prefs.setBool('reader_volume_keys', false);
    await prefs.setBool('reader_gaze_enabled', true);
    await _startGaze(prefs);
  }

  Future<bool> _confirmGazeCamera() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.readerGazeCameraTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
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

  void _onGaze(GazeEvent e) {
    if (!mounted) return;
    logger.info(
        'Hands-free: ${e.direction.name} @ ${e.intensity.toStringAsFixed(2)}',
        category: LogCategory.general);
    // Paged modes: one flip per discrete look.
    if (_pageController?.hasClients == true) {
      if (e.direction == GazeDirection.down) {
        _flipPage(1);
      } else if (e.direction == GazeDirection.up) {
        _flipPage(-1);
      }
      return;
    }
    // Continuous modes: fluid scroll loop.
    if (e.direction == GazeDirection.none) {
      _stopGazeScroll();
      return;
    }
    _gazeDelta = e.direction == GazeDirection.down ? 1 : -1;
    _gazeSpeed = _volScrollSpeed * (0.35 + 0.65 * e.intensity.clamp(0.0, 1.0));
    _beginGazeScroll();
  }

  void _beginGazeScroll() {
    const tick = Duration(milliseconds: 100);
    void scrollOnce() {
      if (!mounted || _gazeDelta == 0) return;
      final step = _gazeDelta * _gazeSpeed * (tick.inMilliseconds / 1000.0);
      try {
        _scrollOffsetController.animateScroll(
            offset: step, duration: tick, curve: Curves.linear);
      } catch (_) {}
    }

    scrollOnce();
    _gazeTimer ??= Timer.periodic(tick, (_) {
      if (!mounted || _gazeDelta == 0) {
        _gazeTimer?.cancel();
        _gazeTimer = null;
        return;
      }
      scrollOnce();
    });
  }

  void _stopGazeScroll() {
    _gazeDelta = 0;
    _gazeTimer?.cancel();
    _gazeTimer = null;
  }

  // Tilt-to-scroll reuses the gaze scroll path (mutually exclusive with gaze).
  void _onTilt(TiltEvent e) {
    final dir = e.direction == TiltDirection.down
        ? GazeDirection.down
        : (e.direction == TiltDirection.up
            ? GazeDirection.up
            : GazeDirection.none);
    _onGaze(GazeEvent(dir, e.intensity));
  }

  Future<void> _maybeEnableTilt() async {
    final prefs = SettingsStore.instance;
    if (!(prefs.getBool('beta_features_enabled') ?? false)) return; // hands-free is beta
    if (!(prefs.getBool('reader_tilt_enabled') ?? false)) return;
    await _startTilt(prefs);
  }

  Future<void> _startTilt(SettingsStore prefs) async {
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    TiltScroll.updateSettings(TiltSettings(
      threshold: prefs.getDouble('reader_tilt_threshold') ?? 0.20,
      smoothing: prefs.getDouble('reader_tilt_smoothing') ?? 0.20,
    ));
    await TiltScroll.enable(_onTilt);
    if (mounted) setState(() => _tiltActive = true);
  }

  Future<void> _toggleTilt() async {
    final prefs = SettingsStore.instance;
    if (_tiltActive) {
      await TiltScroll.disable();
      await prefs.setBool('reader_tilt_enabled', false);
      _stopGazeScroll();
      if (mounted) setState(() => _tiltActive = false);
      return;
    }
    // Mutual exclusivity: tilt replaces gaze + volume.
    if (_gazeActive) {
      await GazeScroll.disable();
      await prefs.setBool('reader_gaze_enabled', false);
      if (mounted) setState(() => _gazeActive = false);
    }
    VolumeKeys.disable();
    await prefs.setBool('reader_volume_keys', false);
    await prefs.setBool('reader_tilt_enabled', true);
    await _startTilt(prefs);
  }

  // Long-press the in-reader hands-free toggle → quick options for the active
  // input (sensitivity / speed / mode / recalibrate), applied live.
  Future<void> _openHandsFreeMenu() async {
    if (!_gazeActive && !_tiltActive) return;
    final isGaze = _gazeActive;
    final prefs = SettingsStore.instance;
    if (!mounted) return;
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    double sensitivity = isGaze
        ? (prefs.getDouble('reader_gaze_threshold') ?? 0.8)
        : (prefs.getDouble('reader_tilt_threshold') ?? 0.20);
    double speed = (prefs.getDouble('reader_volume_scroll_speed') ?? 600.0)
        .clamp(150.0, 2000.0);
    String mode = prefs.getString('reader_gaze_mode') ?? 'combined';

    void push() {
      if (isGaze) {
        GazeScroll.updateSettings(GazeSettings(
          mode: mode,
          threshold: sensitivity,
          dwellMs: (prefs.getDouble('reader_gaze_dwell') ?? 300).round(),
          smoothing: prefs.getDouble('reader_gaze_smoothing') ?? 0.25,
          useGeometric: prefs.getBool('reader_gaze_geometric') ?? true,
        ));
      } else {
        TiltScroll.updateSettings(TiltSettings(
          threshold: sensitivity,
          smoothing: prefs.getDouble('reader_tilt_smoothing') ?? 0.20,
        ));
      }
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 16, 20, 16 + MediaQuery.of(sheetCtx).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.readerHandsFreeOptions,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              Text(t.readerGazeSensitivity,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
              Slider(
                value: sensitivity,
                min: isGaze ? 0.25 : 0.08,
                max: isGaze ? 0.9 : 0.5,
                onChanged: (v) => setSheet(() => sensitivity = v),
                onChangeEnd: (v) {
                  prefs.setDouble(
                      isGaze ? 'reader_gaze_threshold' : 'reader_tilt_threshold',
                      v);
                  push();
                },
              ),
              Text(t.readerScrollSpeed,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
              Slider(
                value: speed,
                min: 150,
                max: 2000,
                onChanged: (v) => setSheet(() => speed = v),
                onChangeEnd: (v) {
                  prefs.setDouble('reader_volume_scroll_speed', v);
                  if (mounted) setState(() => _volScrollSpeed = v);
                },
              ),
              if (isGaze) ...[
                Text(t.readerGazeMode,
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
                const SizedBox(height: 6),
                TypeToggle(
                  items: [
                    TypeToggleItem('eyesOnly', t.readerGazeModeEyes),
                    TypeToggleItem('headOnly', t.readerGazeModeHead),
                    TypeToggleItem('combined', t.readerGazeModeBoth),
                  ],
                  selectedId: mode,
                  onChanged: (id) {
                    setSheet(() => mode = id);
                    prefs.setString('reader_gaze_mode', id);
                    push();
                  },
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    _recalibrateHandsFree(isGaze);
                  },
                  icon: const Icon(Icons.center_focus_strong_rounded),
                  label: Text(t.readerGazeCalibrate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _recalibrateHandsFree(bool isGaze) {
    final t = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(isGaze ? t.readerGazeCalibrating : t.readerTiltCalibrating),
        duration: const Duration(milliseconds: 1600)));
    if (isGaze) {
      GazeScroll.calibrate(durationMs: 1500);
    } else {
      TiltScroll.calibrate(durationMs: 1200);
    }
  }
}
