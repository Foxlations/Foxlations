import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

import '../../core/services/app_logger.dart';
import '../../core/services/doh/doh_resolver.dart';

/// Error thrown for a source-reported failure. [message] is the clean, human part
/// (what to show on screen - e.g. "Open in WebView to set necessary cookies"); [detail]
/// is the full host string (exception type + root cause + stack frames) kept for the
/// Debug log. `toString()` is the clean message, so widgets that render `e.toString()`
/// (the reader/browse/detail error views, global-search rows) show the actionable line
/// rather than a stack trace. It still contains any "cloudflare"/"403" marker from the
/// leading segment, so the Android CF-retry heuristic keeps working.
class SourceError implements Exception {
  final String message;
  final String detail;
  SourceError(this.message, this.detail);
  @override
  String toString() => message;
}

/// Pull the human-readable part out of the host's `describe(t)` string
/// ("Type: message | root: … | at frame | frame …"): drop everything from " | root:",
/// then strip a leading "SomethingException:/Error:" when a real message follows it.
String humanizeSourceError(String raw) {
  final lower = raw.toLowerCase();
  // Known-cryptic source failures → actionable guidance. "Failed to find
  // buildId" means the extension couldn't read the site's page data - in
  // practice the site has moved, changed its layout, or gone down (e.g. Flame
  // Comics' flamecomics.xyz now redirects to Discord), so no extension version
  // can read it until it's updated/re-pointed.
  if (lower.contains('buildid')) {
    return "This source couldn't read the site - it may have moved, changed, or "
        "gone down. Try updating the source (Browse → Extensions); if that "
        "doesn't help, the site is likely offline and the source can be removed.";
  }
  var msg = raw.split(' | root:').first.trim();
  final m = RegExp(r'^[\w.$]+(?:Exception|Error):\s*(.+)$').firstMatch(msg);
  final inner = m?.group(1)?.trim();
  if (inner != null && inner.isNotEmpty && inner != 'null') msg = inner;
  if (msg.isEmpty || msg == 'null') msg = 'The source reported an error.';
  return msg;
}

/// Dart side of the embedded-JVM MethodChannel (M5.1).
///
/// The native `foxlations/jvm` channel is only registered in the JVM build
/// (`-DFOXLATIONS_JVM`); in a normal build [probe] returns a "not available"
/// message instead of throwing, so callers stay simple. Later milestones add the
/// real source methods (getPopular/getDetail/getPageList/…) behind
/// `KotlinExtensionService`; for now this is just the boot + fetch self-test.
class FoxJvm {
  static const MethodChannel _channel = MethodChannel('foxlations/jvm');

  // ── iOS reopen-from-background crash mitigation ──────────────────────────
  // On iOS the embedded Zero VM aborts (os_bsd_zero.cpp ShouldNotCall() via the
  // unimplemented ucontext_get_pc stub, from the JVM crash-signal handler) when
  // a JVM op runs in the unstable window right after the app returns from the
  // background - the process is still restoring its threads + signal handlers.
  // Holding JVM calls briefly after a resume lets that settle first. (The real
  // fix is implementing ucontext_get_pc in the bsd_zero libjvm; this only
  // shrinks the app-side crash window.)
  static const Duration _resumeQuietPeriod = Duration(seconds: 3);
  static DateTime? _resumedAt;

  /// Hard cap on a single JVM round-trip. Without it the MethodChannel future
  /// never settles when a Kotlin source hangs (a dead site, a stuck OkHttp read)
  /// and every screen behind the call spins forever. Matches the JS lane's 40s
  /// cap (core/services/isolate_service.dart).
  static const Duration _invokeTimeout = Duration(seconds: 40);

  /// Call from the app lifecycle observer on resume. Opens a short quiet period
  /// that [_awaitResumeQuiet] holds JVM calls through (iOS only; no-op elsewhere).
  static void markResumed() {
    if (Platform.isIOS) _resumedAt = DateTime.now();
  }

  /// On iOS, waits out any remaining post-resume quiet period before a JVM op.
  static Future<void> _awaitResumeQuiet() async {
    if (!Platform.isIOS) return;
    final at = _resumedAt;
    if (at == null) return;
    final remaining = _resumeQuietPeriod - DateTime.now().difference(at);
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    _resumedAt = null; // window passed - stop gating until the next resume
  }

  /// Boots the embedded Zero VM (once) and runs the Suwayomi-hosted MangaDex
  /// fetch self-test, returning its human-readable report. Never throws.
  static Future<String> probe() async {
    try {
      final result = await _channel.invokeMethod<String>('probe');
      return result ?? '(no report)';
    } on MissingPluginException {
      return 'JVM channel not available - this build has no embedded JVM.';
    } on PlatformException catch (e) {
      return 'JVM probe error: ${e.message ?? e.code}';
    }
  }

  /// Boots the embedded JVM ahead of time (best-effort, never throws) so the first
  /// real source call doesn't pay the one-time bootstrap cost. The app calls this in
  /// the background when Browse opens and Kotlin sources are installed.
  static Future<void> warmup() async {
    try {
      await _awaitResumeQuiet();
      await _channel.invokeMethod<String>('invoke', jsonEncode({'method': 'warmup'}));
      // Push the current DoH config once the lane is up.
      final doh = jvmDohConfig();
      await setDoh(doh.enabled, doh.url);
    } catch (e) {
      // Best-effort warm-up (e.g. a non-JVM build has no channel). Debug-level
      // so it only shows with verbose logging on, not on every Browse open.
      AppLogger.instance.debug('JVM warmup skipped: $e',
          category: LogCategory.extension);
    }
  }

  /// Push the DNS-over-HTTPS config to the Kotlin extension lane (Android ART's
  /// OkHttp Dns / the embedded JVM's DoH resolver). Best-effort, never throws.
  /// Called after warmup and whenever the DoH setting changes.
  static Future<void> setDoh(bool enabled, String url) async {
    try {
      await _channel.invokeMethod<String>('invoke',
          jsonEncode({'method': 'setDoh', 'dohEnabled': enabled, 'dohUrl': url}));
    } catch (e) {
      // Best-effort; debug-level so a channel-less build doesn't spam the log.
      AppLogger.instance.debug('JVM setDoh failed: $e',
          category: LogCategory.extension);
    }
  }

  /// M5.2: send a JSON [request] ({method, jar, lang?, page?, query?, url?}) to
  /// `SourceRunner.invoke` on the JVM and return the decoded JSON response
  /// (a Map for MPages/MManga, a List for getPageList). Throws on an error
  /// response or a missing channel so `KotlinExtensionService` surfaces it.
  static Future<dynamic> invoke(Map<String, dynamic> request) async {
    await _awaitResumeQuiet();
    final String resp;
    try {
      resp = await _channel
              .invokeMethod<String>('invoke', jsonEncode(request))
              .timeout(_invokeTimeout) ??
          '{"error":"null response"}';
    } on MissingPluginException {
      throw Exception('JVM channel not available - this build has no embedded JVM.');
    } on PlatformException catch (e) {
      throw Exception('JVM invoke error: ${e.message ?? e.code}');
    } on TimeoutException {
      // The native side never answered - surface a clean source error in the
      // same shape callers already expect from an error response, instead of
      // leaving the Future pending and the screen spinning forever.
      const msg = 'The source timed out - it may be down or blocking requests. '
          'Try again, or check the site.';
      final detail = 'JVM invoke timed out after ${_invokeTimeout.inSeconds}s: '
          'method=${request['method']} jar=${request['jar']}';
      AppLogger.instance.error('Source error: $msg',
          category: LogCategory.extension, detail: detail);
      throw SourceError(msg, detail);
    }
    final decoded = jsonDecode(resp);
    if (decoded is Map && decoded['error'] != null) {
      final raw = decoded['error'].toString();
      // Full detail (type + root cause + frames) always goes to More → Debug logs;
      // the UI gets the clean, actionable line via SourceError.toString().
      AppLogger.instance.error(
        'Source error: ${humanizeSourceError(raw)}',
        category: LogCategory.extension,
        detail: 'method=${request['method']} jar=${request['jar']}\n$raw',
      );
      throw SourceError(humanizeSourceError(raw), raw);
    }
    return decoded;
  }
}
