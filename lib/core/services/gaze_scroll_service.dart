import 'dart:io';

import 'package:flutter/services.dart';
import 'settings_store.dart';

import 'app_logger.dart';

/// A scroll intent from the native ARKit gaze engine.
enum GazeDirection { up, down, none }

class GazeEvent {
  final GazeDirection direction;

  /// 0..1 - how far past threshold the gaze is; scales scroll speed.
  final double intensity;

  const GazeEvent(this.direction, this.intensity);
}

/// Tunable gaze parameters, pushed to the native [GazeScroller].
class GazeSettings {
  /// 'eyesOnly' | 'headOnly' | 'combined'.
  final String mode;
  final double threshold;
  final int dwellMs;
  final double smoothing;
  final bool useLookAt;

  /// Project the gaze ray onto the screen plane for a geometric on-screen point
  /// (more accurate) instead of the raw lookAtPoint magnitudes.
  final bool useGeometric;

  const GazeSettings({
    this.mode = 'combined',
    this.threshold = 0.8,
    this.dwellMs = 300,
    this.smoothing = 0.25,
    this.useLookAt = true,
    this.useGeometric = true,
  });

  Map<String, dynamic> toMap() => {
        'mode': mode,
        'threshold': threshold,
        'dwellMs': dwellMs,
        'smoothing': smoothing,
        'useLookAt': useLookAt,
        'useGeometric': useGeometric,
      };
}

/// Hands-free (gaze) scrolling - an iOS-only bridge to the native ARKit engine
/// on the `foxlations/gaze` channel. Mirrors [VolumeKeys]' reverse-invoke
/// streaming pattern (native pushes `onGaze` into this handler).
///
/// The feature is unavailable off iOS and on devices without a TrueDepth camera;
/// always gate UI on [isSupported].
class GazeScroll {
  static const _channel = MethodChannel('foxlations/gaze');

  static bool _handlerSet = false;
  static void Function(GazeEvent)? _onGaze;
  static void Function(double gx, double gy)? _onPreview;
  static void Function(Map<String, double> debug)? _onPreviewDebug;
  static void Function(Map<String, double> baseline)? _onCalibrated;

  /// True only on iOS devices with Face ID / A12+ (ARFaceTrackingConfiguration).
  static Future<bool> isSupported() async {
    if (!Platform.isIOS) return false;
    try {
      return (await _channel.invokeMethod<bool>('isSupported')) ?? false;
    } catch (_) {
      return false;
    }
  }

  static void _ensureHandler() {
    if (_handlerSet) return;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onGaze':
          if (call.arguments is Map) {
            final m = Map<String, dynamic>.from(call.arguments as Map);
            _onGaze?.call(GazeEvent(
              _dir(m['direction'] as String?),
              (m['intensity'] as num?)?.toDouble() ?? 0,
            ));
          }
          break;
        case 'onGazePreview':
          if (call.arguments is Map) {
            final m = Map<String, dynamic>.from(call.arguments as Map);
            _onPreview?.call((m['gx'] as num?)?.toDouble() ?? 0,
                (m['gy'] as num?)?.toDouble() ?? 0);
            _onPreviewDebug?.call({
              'gx': (m['gx'] as num?)?.toDouble() ?? 0,
              'gy': (m['gy'] as num?)?.toDouble() ?? 0,
              'fv': (m['fv'] as num?)?.toDouble() ?? 0,
              'fh': (m['fh'] as num?)?.toDouble() ?? 0,
              'fp': (m['fp'] as num?)?.toDouble() ?? 0,
            });
          }
          break;
        case 'onCalibrated':
          final m = call.arguments is Map
              ? Map<String, dynamic>.from(call.arguments as Map)
              : const <String, dynamic>{};
          final baseline = {
            'v': (m['v'] as num?)?.toDouble() ?? 0.0,
            'h': (m['h'] as num?)?.toDouble() ?? 0.0,
            'p': (m['p'] as num?)?.toDouble() ?? 0.0,
          };
          final cb = _onCalibrated;
          _onCalibrated = null;
          cb?.call(baseline);
          break;
      }
      return null;
    });
    _handlerSet = true;
  }

  /// Start face tracking; [onGaze] receives scroll intents on the UI thread.
  static Future<void> enable(void Function(GazeEvent) onGaze) async {
    if (!Platform.isIOS) return;
    _onGaze = onGaze;
    _ensureHandler();
    // Restore a saved calibration, if the user has calibrated before. Prefer the
    // full 5-point model (baseline + measured range); fall back to a baseline-only
    // calibration saved by an older build.
    try {
      final prefs = SettingsStore.instance;
      if (prefs.containsKey('reader_gaze_span_down')) {
        await setModel({
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
      } else if (prefs.containsKey('reader_gaze_base_v')) {
        await applyBaseline(
          prefs.getDouble('reader_gaze_base_v') ?? 0,
          prefs.getDouble('reader_gaze_base_h') ?? 0,
          prefs.getDouble('reader_gaze_base_p') ?? 0,
        );
      }
    } catch (_) {}
    try {
      await _channel.invokeMethod('setActive', true);
      logger.info('Gaze scroll enabled', category: LogCategory.general);
    } catch (e) {
      logger.error('Gaze scroll enable failed: $e', category: LogCategory.general);
    }
  }

  /// Stop face tracking and release the camera.
  static Future<void> disable() async {
    if (!Platform.isIOS) return;
    _onGaze = null;
    try {
      await _channel.invokeMethod('setActive', false);
    } catch (_) {}
  }

  /// Push tunables to the native engine.
  static Future<void> updateSettings(GazeSettings s) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod('updateSettings', s.toMap());
    } catch (_) {}
  }

  /// Sample the gaze/head signal over [durationMs] and return the average via
  /// [onDone]. With [adopt] true it also becomes the neutral baseline (single-point
  /// calibration); multi-point calibration passes `adopt: false` so sampling a
  /// corner never shifts the engine's centre, then applies the combined model with
  /// [setModel] at the end.
  static Future<void> calibrate(
      {int durationMs = 1500,
      bool adopt = true,
      void Function(Map<String, double> baseline)? onDone}) async {
    if (!Platform.isIOS) return;
    _onCalibrated = onDone;
    _ensureHandler();
    try {
      await _channel
          .invokeMethod('calibrate', {'durationMs': durationMs, 'adopt': adopt});
    } catch (_) {
      _onCalibrated = null;
    }
  }

  /// Toggle the live 2D gaze preview stream (for the calibration dot).
  /// [onPreview] receives (gx, gy) relative to the calibrated centre.
  static Future<void> setPreview(bool on,
      {void Function(double gx, double gy)? onPreview,
      void Function(Map<String, double> debug)? onDebug}) async {
    if (!Platform.isIOS) return;
    _onPreview = onPreview;
    _onPreviewDebug = onDebug;
    _ensureHandler();
    try {
      await _channel.invokeMethod('setPreview', on);
    } catch (_) {}
  }

  /// Restore a saved gaze baseline (from a prior baseline-only calibration).
  static Future<void> applyBaseline(double v, double h, double p) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod('setBaseline', {'v': v, 'h': h, 'p': p});
    } catch (_) {}
  }

  /// Apply a full 5-point calibration model: neutral centre (v/h/p) plus the
  /// signed range spans (down/up/right/left eye, pdown/pup head pitch). The engine
  /// normalizes all gaze signals against these, so both the dot and the scroll
  /// thresholds track the user's own measured range.
  static Future<void> setModel(Map<String, double> model) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod('setModel', model);
    } catch (_) {}
  }

  static GazeDirection _dir(String? s) {
    switch (s) {
      case 'up':
        return GazeDirection.up;
      case 'down':
        return GazeDirection.down;
      default:
        return GazeDirection.none;
    }
  }
}
