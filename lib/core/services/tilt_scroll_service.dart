import 'dart:async';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import 'app_logger.dart';

/// A tilt-driven scroll intent. Mirrors the gaze service so the readers can feed
/// both through the same scroll loop.
enum TiltDirection { up, down, none }

class TiltEvent {
  final TiltDirection direction;
  final double intensity; // 0..1

  const TiltEvent(this.direction, this.intensity);
}

/// Tunable tilt parameters (radians of pitch relative to the calibrated rest).
class TiltSettings {
  /// How far to tilt past rest before scrolling starts.
  final double threshold;

  /// Once scrolling, how close to rest before it stops (hysteresis; < threshold).
  final double deadzone;

  /// Low-pass smoothing factor (0..1).
  final double smoothing;

  const TiltSettings({
    this.threshold = 0.20,
    this.deadzone = 0.09,
    this.smoothing = 0.20,
  });
}

/// Tilt-to-scroll: derives the phone's forward/back pitch from the accelerometer
/// (sensors_plus) and turns it into scroll intents. Pure Dart, cross-platform
/// (iOS + Android, no native code). Emits the same {direction, intensity} shape
/// as the gaze service so the reader reuses one scroll loop.
///
/// The two are mutually exclusive at the settings level (only one hands-free
/// input drives the loop at a time).
class TiltScroll {
  static StreamSubscription<AccelerometerEvent>? _sub;
  static void Function(TiltEvent)? _onEvent;
  static TiltSettings _settings = const TiltSettings();

  static const _period = Duration(milliseconds: 33); // ~30 Hz

  static double _filtered = 0;
  static bool _hasSample = false;
  static double _baseline = 0;
  static bool _calibrating = false;
  static final List<double> _calSamples = [];
  static TiltDirection _lastDir = TiltDirection.none;
  static double _lastIntensity = 0;

  /// Every phone has an accelerometer, so tilt is always available.
  static Future<bool> isSupported() async => true;

  static Future<void> enable(void Function(TiltEvent) onEvent) async {
    _onEvent = onEvent;
    _hasSample = false;
    _lastDir = TiltDirection.none;
    await _sub?.cancel();
    _sub = accelerometerEventStream(samplingPeriod: _period)
        .listen(_onAccel, onError: (_) {});
    logger.info('Tilt scroll enabled', category: LogCategory.general);
  }

  static Future<void> disable() async {
    await _sub?.cancel();
    _sub = null;
    _onEvent = null;
    _lastDir = TiltDirection.none;
  }

  static void updateSettings(TiltSettings s) => _settings = s;

  /// Record the resting phone angle as the baseline that thresholds measure from.
  static Future<void> calibrate(
      {int durationMs = 1200, void Function()? onDone}) async {
    _calSamples.clear();
    _calibrating = true;
    final wasRunning = _sub != null;
    if (!wasRunning) {
      _hasSample = false;
      _sub = accelerometerEventStream(samplingPeriod: _period)
          .listen(_onAccel, onError: (_) {});
    }
    await Future.delayed(Duration(milliseconds: durationMs));
    _calibrating = false;
    if (_calSamples.isNotEmpty) {
      _baseline = _calSamples.reduce((a, b) => a + b) / _calSamples.length;
    }
    if (!wasRunning) {
      await _sub?.cancel();
      _sub = null;
    }
    onDone?.call();
  }

  static void _onAccel(AccelerometerEvent e) {
    // Forward/back pitch in the device Y-Z plane (left/right roll about X ignored).
    final pitch = math.atan2(e.y, e.z);
    final a = _settings.smoothing.clamp(0.01, 1.0);
    if (_hasSample) {
      _filtered += a * (pitch - _filtered);
    } else {
      _filtered = pitch;
      _hasSample = true;
    }
    if (_calibrating) {
      _calSamples.add(_filtered);
      return;
    }
    _evaluate();
  }

  static void _evaluate() {
    final delta = _filtered - _baseline;
    // Hysteresis: cross [threshold] to start, fall back within [deadzone] to stop.
    final active = _lastDir != TiltDirection.none;
    final gate = active ? _settings.deadzone : _settings.threshold;
    TiltDirection dir = TiltDirection.none;
    double intensity = 0;
    if (delta > gate) {
      dir = TiltDirection.down;
      intensity = _intensity(delta - _settings.deadzone);
    } else if (delta < -gate) {
      dir = TiltDirection.up;
      intensity = _intensity(-delta - _settings.deadzone);
    }
    _emit(dir, intensity);
  }

  static double _intensity(double over) => (over / 0.35).clamp(0.0, 1.0);

  static void _emit(TiltDirection dir, double intensity) {
    if (dir == _lastDir && (intensity - _lastIntensity).abs() < 0.08) return;
    _lastDir = dir;
    _lastIntensity = intensity;
    _onEvent?.call(TiltEvent(dir, intensity));
  }
}
