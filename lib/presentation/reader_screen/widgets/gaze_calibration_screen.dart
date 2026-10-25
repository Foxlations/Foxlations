import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/services/settings_store.dart';

import '../../../core/services/gaze_scroll_service.dart';
import '../../../l10n/app_localizations.dart';

/// Guided 5-point gaze calibration (iOS). The user follows a target to the centre
/// and each corner, holding still while a ring fills; the engine averages each
/// window. From the centre we take the neutral baseline, and from the four corners
/// the signed horizontal/vertical *range* of the user's gaze. That range is what
/// makes the live dot line up (it maps through the measured extents, not a guessed
/// scale), corrects the front-camera mirror (handedness comes from where the user
/// actually looked), and lets "up" and "down" take equal effort despite ARKit's
/// weaker eyeLookUp. The model is persisted so it survives restarts (see
/// GazeScroll.enable restoring it).
class GazeCalibrationScreen extends StatefulWidget {
  const GazeCalibrationScreen({super.key});

  @override
  State<GazeCalibrationScreen> createState() => _GazeCalibrationScreenState();
}

enum _CalPhase { calibrating, success, test, done }

class _GazeCalibrationScreenState extends State<GazeCalibrationScreen>
    with TickerProviderStateMixin {
  _CalPhase _phase = _CalPhase.calibrating;
  double _gx = 0, _gy = 0; // live gaze vector, normalized to the calibrated range

  // Targets as fractions of the body: centre first, then the four corners. The
  // inset must match the dot mapping below so a fully-deflected gaze (±1) lands
  // exactly on the corner it was calibrated against.
  static const double _inset = 0.10;
  // A "+" pattern (centre, then pure top/bottom/left/right) - pure-axis gaze is
  // cleaner to map than the diagonal corners, which couple up/down with left/right.
  static const List<Offset> _targets = [
    Offset(0.5, 0.5),
    Offset(0.5, _inset),
    Offset(0.5, 1 - _inset),
    Offset(_inset, 0.5),
    Offset(1 - _inset, 0.5),
  ];
  int _pointIndex = 0;
  final List<Map<String, double>> _samples = [];

  /// Set when the eye signal didn't respond to looking around (too dark, or the
  /// eyes aren't resolving) - we fall back to head-tilt, which works in any light.
  bool _eyesDead = false;

  late final AnimationController _ring;
  late final AnimationController _pulse;

  final ScrollController _testScroll = ScrollController();
  Timer? _testLoop;
  int _testDelta = 0;
  double _testSpeed = 600;

  @override
  void initState() {
    super.initState();
    _ring = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _startCalibration();
  }

  Future<void> _startCalibration() async {
    if (!mounted) return;
    setState(() {
      _phase = _CalPhase.calibrating;
      _pointIndex = 0;
      _samples.clear();
      _eyesDead = false;
    });
    // Seed the engine with any saved model so the live dot is roughly aligned
    // while we capture; the fresh model replaces it when we finish.
    try {
      final prefs = SettingsStore.instance;
      if (prefs.containsKey('reader_gaze_span_down')) {
        await GazeScroll.setModel({
          'v': prefs.getDouble('reader_gaze_base_v') ?? 0,
          'h': prefs.getDouble('reader_gaze_base_h') ?? 0,
          'p': prefs.getDouble('reader_gaze_base_p') ?? 0,
          'down': prefs.getDouble('reader_gaze_span_down') ?? 0.45,
          'up': prefs.getDouble('reader_gaze_span_up') ?? -0.35,
          'right': prefs.getDouble('reader_gaze_span_right') ?? 0.35,
          'left': prefs.getDouble('reader_gaze_span_left') ?? -0.35,
          'pdown': prefs.getDouble('reader_gaze_span_pdown') ?? 0.25,
          'pup': prefs.getDouble('reader_gaze_span_pup') ?? -0.22,
        });
      }
    } catch (_) {}
    await GazeScroll.setPreview(true, onPreview: (gx, gy) {
      if (mounted) setState(() { _gx = gx; _gy = gy; });
    });
    _runPoint(0);
  }

  Future<void> _runPoint(int i) async {
    if (!mounted) return;
    setState(() => _pointIndex = i);
    // Give the eyes a moment to reach the new target before sampling.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _ring.forward(from: 0);
    final sample = await _captureSample(1500);
    if (!mounted) return;
    _samples.add(sample);
    if (i == 0) {
      // Lock the neutral centre once, here, so the corner points are all measured
      // against a stable centre. Every capture uses adopt:false, so nothing else
      // ever moves the baseline mid-sequence - the five points build one model.
      await GazeScroll.applyBaseline(
          sample['v'] ?? 0, sample['h'] ?? 0, sample['p'] ?? 0);
    }
    if (i + 1 < _targets.length) {
      _runPoint(i + 1);
    } else {
      _finishCalibration();
    }
  }

  Future<Map<String, double>> _captureSample(int ms) {
    final c = Completer<Map<String, double>>();
    // adopt:false - never let a single point overwrite the neutral baseline.
    GazeScroll.calibrate(
        durationMs: ms,
        adopt: false,
        onDone: (b) {
          if (!c.isCompleted) c.complete(b);
        });
    return c.future;
  }

  Future<void> _finishCalibration() async {
    if (_samples.length < _targets.length) return;
    final center = _samples[0], top = _samples[1], bottom = _samples[2];
    final left = _samples[3], right = _samples[4];
    double v(Map<String, double> m) => m['v'] ?? 0;
    double h(Map<String, double> m) => m['h'] ?? 0;
    double p(Map<String, double> m) => m['p'] ?? 0;

    // Neutral = midpoint of the actual top/bottom (and left/right) extremes, which
    // is more stable than a separately-captured centre that can drift.
    final cV = (v(top) + v(bottom)) / 2;
    final cH = (h(left) + h(right)) / 2;
    final cP = p(center);
    final model = <String, double>{
      'v': cV, 'h': cH, 'p': cP,
      'down': v(bottom) - cV,
      'up': v(top) - cV,
      'right': h(right) - cH,
      'left': h(left) - cH,
      'pdown': p(bottom) - cP,
      'pup': p(top) - cP,
    };

    try {
      final prefs = SettingsStore.instance;
      await prefs.setDouble('reader_gaze_base_v', cV);
      await prefs.setDouble('reader_gaze_base_h', cH);
      await prefs.setDouble('reader_gaze_base_p', cP);
      await prefs.setDouble('reader_gaze_span_down', model['down']!);
      await prefs.setDouble('reader_gaze_span_up', model['up']!);
      await prefs.setDouble('reader_gaze_span_right', model['right']!);
      await prefs.setDouble('reader_gaze_span_left', model['left']!);
      await prefs.setDouble('reader_gaze_span_pdown', model['pdown']!);
      await prefs.setDouble('reader_gaze_span_pup', model['pup']!);
    } catch (_) {}
    await GazeScroll.setModel(model);

    // If looking to all four corners barely moved the eye signal, the eyes aren't
    // resolving (too dark). Head pose still tracks in the dark, so fall back to
    // head-tilt control and tell the user why.
    final eyeRange = [model['down']!, model['up']!, model['right']!, model['left']!]
        .map((e) => e.abs())
        .reduce((a, b) => a > b ? a : b);
    _eyesDead = eyeRange < 0.06;
    if (_eyesDead) {
      try {
        final prefs = SettingsStore.instance;
        await prefs.setString('reader_gaze_mode', 'headOnly');
        await GazeScroll.updateSettings(GazeSettings(
          mode: 'headOnly',
          threshold: prefs.getDouble('reader_gaze_threshold') ?? 0.5,
          dwellMs: (prefs.getDouble('reader_gaze_dwell') ?? 300).round(),
          smoothing: prefs.getDouble('reader_gaze_smoothing') ?? 0.25,
        ));
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() => _phase = _CalPhase.success);
    _pulse.forward(from: 0);
    await Future.delayed(Duration(milliseconds: _eyesDead ? 2400 : 1100));
    if (mounted) _startTest();
  }

  Future<void> _startTest() async {
    // Keep the preview stream on so the dot stays visible during the test.
    if (!mounted) return;
    setState(() => _phase = _CalPhase.test);
    final prefs = SettingsStore.instance;
    _testSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    await GazeScroll.enable((e) {
      if (!mounted) return;
      if (e.direction == GazeDirection.none) {
        _stopTestScroll();
        return;
      }
      _testDelta = e.direction == GazeDirection.down ? 1 : -1;
      _beginTestScroll(e.intensity);
    });
  }

  void _beginTestScroll(double intensity) {
    const tick = Duration(milliseconds: 100);
    final speed = _testSpeed * (0.35 + 0.65 * intensity.clamp(0.0, 1.0));
    void once() {
      if (!mounted || !_testScroll.hasClients || _testDelta == 0) return;
      final target = (_testScroll.offset + _testDelta * speed * 0.1)
          .clamp(0.0, _testScroll.position.maxScrollExtent);
      _testScroll.animateTo(target, duration: tick, curve: Curves.linear);
    }

    once();
    _testLoop ??= Timer.periodic(tick, (_) {
      if (!mounted || _testDelta == 0) {
        _testLoop?.cancel();
        _testLoop = null;
        return;
      }
      once();
    });
  }

  void _stopTestScroll() {
    _testDelta = 0;
    _testLoop?.cancel();
    _testLoop = null;
  }

  Future<void> _finishTest() async {
    _stopTestScroll();
    await GazeScroll.setPreview(false);
    await GazeScroll.disable();
    if (mounted) setState(() => _phase = _CalPhase.done);
  }

  @override
  void dispose() {
    _ring.dispose();
    _pulse.dispose();
    _testLoop?.cancel();
    _testScroll.dispose();
    GazeScroll.setPreview(false);
    GazeScroll.disable();
    super.dispose();
  }

  // Normalized gaze (±1 across the calibrated range) → a screen fraction that
  // lands ±1 exactly on the corner targets. No mirror term: handedness lives in
  // the calibrated span signs.
  double _fracX(double w) =>
      (0.5 + (0.5 - _inset) * _gx).clamp(0.05, 0.95) * w;
  double _fracY(double h) =>
      (0.5 + (0.5 - _inset) * _gy).clamp(0.05, 0.95) * h;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(t.readerCalibrateTitle),
      ),
      body: LayoutBuilder(
        builder: (ctx, box) {
          final dotX = _fracX(box.maxWidth);
          final dotY = _fracY(box.maxHeight);

          switch (_phase) {
            case _CalPhase.calibrating:
              final target = _targets[_pointIndex];
              final tx = target.dx * box.maxWidth;
              final ty = target.dy * box.maxHeight;
              return Stack(children: [
                Positioned(
                  top: 16,
                  left: 24,
                  right: 24,
                  child: Column(children: [
                    Text(
                        t.readerCalibratePointOf(
                            _pointIndex + 1, _targets.length),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(t.readerCalibrateGetReady,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 13)),
                  ]),
                ),
                // Target + progress ring at the current point.
                Positioned(
                  left: tx - 48,
                  top: ty - 48,
                  child: AnimatedBuilder(
                    animation: _ring,
                    builder: (_, _) => SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: _ring.value,
                        strokeWidth: 5,
                        color: cs.primary,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: tx - 15,
                    top: ty - 15,
                    child: const Icon(Icons.center_focus_strong_rounded,
                        color: Colors.white, size: 30)),
                // Live gaze dot.
                Positioned(
                  left: dotX - 12,
                  top: dotY - 12,
                  child: IgnorePointer(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary.withValues(alpha: 0.35),
                        border: Border.all(color: Colors.white70, width: 2),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 64,
                  left: 24,
                  right: 24,
                  child: Text(t.readerCalibrateInstruction,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15)),
                ),
              ]);

            case _CalPhase.success:
              return Center(
                child: ScaleTransition(
                  scale:
                      CurvedAnimation(parent: _pulse, curve: Curves.elasticOut),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                          _eyesDead
                              ? Icons.nightlight_round
                              : Icons.check_circle_rounded,
                          color: cs.primary,
                          size: 72),
                      const SizedBox(height: 12),
                      Text(
                          _eyesDead
                              ? t.readerCalibrateDarkTitle
                              : t.readerCalibrateSuccess,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      if (_eyesDead) ...[
                        const SizedBox(height: 10),
                        Text(t.readerCalibrateDarkBody,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      ],
                    ]),
                  ),
                ),
              );

            case _CalPhase.test:
              return Stack(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                    child: Text(
                        _eyesDead
                            ? t.readerCalibrateTestPromptHead
                            : t.readerCalibrateTestPrompt,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 15)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _testScroll,
                      itemCount: 50,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 9),
                        child: Text(t.readerCalibrateSampleLine(i + 1),
                            style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                                height: 1.6)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        24, 8, 24, 16 + MediaQuery.of(ctx).padding.bottom),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: _finishTest,
                          child: Text(t.readerCalibrateDoneTest)),
                    ),
                  ),
                ]),
                if (!_eyesDead)
                  Positioned(
                    left: dotX - 10,
                    top: dotY - 10,
                    child: IgnorePointer(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary.withValues(alpha: 0.4),
                          border: Border.all(color: Colors.white70, width: 2),
                        ),
                      ),
                    ),
                  ),
              ]);

            case _CalPhase.done:
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.verified_rounded, color: cs.primary, size: 56),
                  const SizedBox(height: 24),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    OutlinedButton.icon(
                      onPressed: _startCalibration,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(t.readerCalibrateRedo),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38)),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () => Navigator.pop(context, true),
                      icon: const Icon(Icons.check_rounded),
                      label: Text(t.readerCalibrateKeep),
                    ),
                  ]),
                ]),
              );
          }
        },
      ),
    );
  }
}
