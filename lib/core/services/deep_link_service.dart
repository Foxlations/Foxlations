import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../providers/source_provider.dart';
import 'app_logger.dart';
import 'app_navigator.dart';
import 'repo_service.dart';

/// Handles incoming source-repo "auto install" deep links.
///
/// Aggregator sites put an "add to app" button that opens a link the reader apps
/// register, e.g. `mihon://extension-store?url=<repo-index-url>` (Mihon, the
/// popular upstream), `tachiyomi://add-repo?url=...`, `aniyomi://add-repo?url=...`.
/// We register those schemes so Foxlations shows up in the OS "open with" chooser
/// alongside the other readers, plus our own `foxlations://add-repo?url=...`. They
/// all route to one confirm-then-add flow through [SourceProvider.addRepo] - the
/// same path the in-app "Add repo" field uses.
///
/// The `foxlations` scheme is also the tracker-OAuth redirect (`foxlations://auth`,
/// handled in-WebView); we only act on the repo hosts below, so the two don't
/// collide.
class DeepLinkService {
  DeepLinkService._();

  static final AppLinks _appLinks = AppLinks();
  // iOS-only: native side captures the cold-start launch URL that app_links
  // misses under the implicit-engine embedding (see AppDelegate.swift).
  static const _nativeChannel = MethodChannel('foxlations/deeplink');
  static bool _initialized = false;

  /// A prompt/add is in flight - drop re-deliveries so dialogs never stack.
  static bool _busy = false;

  /// URL we're currently acting on, to collapse a duplicate cold-start + stream
  /// delivery of the same link.
  static String? _lastHandled;

  // Schemes we answer to: ours, plus the upstream apps whose links sites emit.
  static const _schemes = {
    'foxlations',
    'mihon',
    'tachiyomi',
    'aniyomi',
    'mangayomi',
  };

  // Hosts that mean "add this source repo".
  static const _repoHosts = {'add-repo', 'extension-store'};

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    // Links delivered while the app is already running.
    _appLinks.uriLinkStream.listen(_handle, onError: (_) {});
    // iOS: app_links misses the cold-start launch URL under the implicit-engine
    // embedding (openURL races plugin registration), so ask the native side,
    // which captured it in didFinishLaunching before any plugin existed.
    if (Platform.isIOS) {
      try {
        final cold =
            await _nativeChannel.invokeMethod<String>('getColdStartLink');
        if (cold != null && cold.isNotEmpty) {
          final uri = Uri.tryParse(cold);
          if (uri != null) {
            logger.info('DeepLink: native cold-start link $cold',
                category: LogCategory.repo);
            _handle(uri);
            return;
          }
        }
      } catch (_) {/* channel not present */}
    }
    // The link that cold-started the app. On a cold launch app_links can briefly
    // return null before the platform hands it over, so poll a few times.
    for (var i = 0; i < 8; i++) {
      Uri? initial;
      try {
        initial = await _appLinks.getInitialLink();
      } catch (_) {/* not ready */}
      if (initial != null) {
        logger.info('DeepLink: cold-start link $initial',
            category: LogCategory.repo);
        _handle(initial);
        return;
      }
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  static void _handle(Uri uri) {
    if (!_schemes.contains(uri.scheme.toLowerCase())) return;
    // Ignore non-repo hosts (e.g. foxlations://auth, the OAuth redirect).
    if (!_repoHosts.contains(uri.host.toLowerCase())) return;
    final url = uri.queryParameters['url']?.trim();
    if (url == null || url.isEmpty) return;
    if (_busy || url == _lastHandled) return;
    _lastHandled = url;
    logger.info('DeepLink: add-repo request $url', category: LogCategory.repo);
    // Defer past the current frame so the shell/navigator is mounted (cold start).
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _promptAddRepo(url));
  }

  static Future<void> _promptAddRepo(String url, {int attempt = 0}) async {
    if (_busy) return;
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      // Cold start: the shell/navigator isn't mounted yet - retry briefly
      // (up to ~6s) instead of giving up, or the link is silently dropped.
      if (attempt < 30) {
        Future.delayed(const Duration(milliseconds: 200),
            () => _promptAddRepo(url, attempt: attempt + 1));
      } else {
        logger.error('DeepLink: navigator never became ready for $url',
            category: LogCategory.repo);
        _lastHandled = null;
      }
      return;
    }
    _busy = true;
    // Captured before any await so later use is not an across-gap context op.
    final t = AppLocalizations.of(ctx);
    try {
      final sp = ctx.read<SourceProvider>();
      final host = Uri.tryParse(url)?.host ?? url;
      // Fetch (don't persist) so the confirm can name the repo + count its sources.
      RepoIndexResult? preview;
      try {
        preview = await sp.previewRepo(url);
      } catch (_) {/* fall back to host-only confirm */}
      final ctx2 = rootNavigatorKey.currentContext;
      if (ctx2 == null) return;
      final name = preview?.repoName ?? '';
      final count = preview?.totalCount ?? 0;
      final confirmed = await showDialog<bool>(
        context: ctx2,
        useRootNavigator: true,
        builder: (dctx) {
          final cs = Theme.of(dctx).colorScheme;
          return AlertDialog(
            title: Text(t.deeplinkAddRepoTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty) ...[
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(t.repoSourceCount(count),
                      style: TextStyle(
                          color: cs.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                ],
                Text(t.deeplinkFromHost(host),
                    style: TextStyle(color: cs.outline)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dctx, false),
                  child: Text(t.appCancel)),
              FilledButton(
                  onPressed: () => Navigator.pop(dctx, true),
                  child: Text(t.miscAdd)),
            ],
          );
        },
      );
      if (confirmed != true) return;
      final liveCtx = rootNavigatorKey.currentContext;
      if (liveCtx == null) return;
      // Root navigator context, re-fetched and null-checked above.
      // ignore: use_build_context_synchronously
      await liveCtx.read<SourceProvider>().addRepo(url, prefetched: preview);
      rootMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(name.isNotEmpty
              ? t.deeplinkAddedNamed(name)
              : t.deeplinkAdded)));
    } catch (e) {
      logger.error('Deep-link add-repo failed: $e', category: LogCategory.repo);
      rootMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(t.deeplinkAddFailed('$e'))));
    } finally {
      _busy = false;
      _lastHandled = null; // allow the same link to be tapped again later
    }
  }
}
