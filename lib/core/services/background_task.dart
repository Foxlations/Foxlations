import 'dart:io';
import 'package:flutter/services.dart';

/// Asks the OS to keep the app alive while a download is running, so an
/// in-progress download isn't killed the instant the app is backgrounded.
///
/// iOS only: bridges `UIApplication.beginBackgroundTask`/`endBackgroundTask`
/// (a few minutes of grace after backgrounding). On every other platform the
/// channel isn't registered, so the calls no-op. Full "download while the app
/// is closed" isn't possible on iOS for our segment-fetch pipeline - the Dart
/// queue is persisted and resumed instead (DownloadProvider).
class BackgroundTask {
  BackgroundTask._();
  static const _channel = MethodChannel('foxlations/background');

  /// Reserve background time (call when a download becomes active). Idempotent.
  static Future<void> begin() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod('begin');
    } catch (_) {
      // Channel not registered (non-JVM build / older app) - ignore.
    }
  }

  /// Release the reserved background time (call when the queue drains).
  static Future<void> end() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod('end');
    } catch (_) {}
  }
}
