import 'dart:async';
import 'package:flutter/widgets.dart';

/// Accumulates ACTIVE read/watch time for Reading Insights.
///
/// A reader/player creates one, calls [ping] on each interaction (page turn,
/// scroll, playback progress), and the tracker credits [interval] seconds per
/// tick - but only while there was activity within [idleAfter] AND the app is
/// foregrounded. So leaving a reader open untouched, or backgrounding the app,
/// never inflates the total. [onCredit] is the vault-aware store write
/// (`store.addReadTime(...)`); it's quiet/persist-only, so ticking is cheap.
class ReadTimeTracker {
  final Future<void> Function(int seconds) onCredit;
  final Duration interval;
  final Duration idleAfter;

  Timer? _timer;
  DateTime _lastActive = DateTime.now();

  ReadTimeTracker({
    required this.onCredit,
    this.interval = const Duration(seconds: 30),
    this.idleAfter = const Duration(minutes: 3),
  });

  /// Begin ticking. Safe to call more than once.
  void start() {
    _lastActive = DateTime.now();
    _timer ??= Timer.periodic(interval, (_) => _tick());
  }

  /// Mark activity - call on page turn / scroll / playback progress.
  void ping() => _lastActive = DateTime.now();

  void _tick() {
    final state = WidgetsBinding.instance.lifecycleState;
    final foreground = state == null || state == AppLifecycleState.resumed;
    if (!foreground) return;
    if (DateTime.now().difference(_lastActive) <= idleAfter) {
      onCredit(interval.inSeconds);
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
