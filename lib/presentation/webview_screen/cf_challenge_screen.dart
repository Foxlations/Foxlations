import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/services/app_navigator.dart';
import '../../core/services/webview_service.dart';
import '../../l10n/app_localizations.dart';

/// In-progress interactive solves, keyed by domain, so concurrent extension
/// requests to the same site don't stack multiple challenge screens.
final Map<String, Future<bool>> _interactiveLocks = {};

/// Show the interactive Cloudflare challenge screen for [url] (a visible
/// WebView the user completes, e.g. a Turnstile checkbox). Returns true once
/// the challenge is solved and cookies are captured. De-duplicated per domain.
Future<bool> solveCloudflareInteractively(String url) {
  final nav = rootNavigatorKey.currentState;
  if (nav == null) return Future.value(false);
  final domain = WebViewService().normalizeDomain(Uri.parse(url).host);
  final existing = _interactiveLocks[domain];
  if (existing != null) return existing;

  final future = nav
      .push<bool>(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CfChallengeScreen(url: url),
      ))
      .then((v) => v ?? false)
      .whenComplete(() => _interactiveLocks.remove(domain));
  _interactiveLocks[domain] = future;
  return future;
}

class CfChallengeScreen extends StatefulWidget {
  final String url;
  const CfChallengeScreen({super.key, required this.url});

  @override
  State<CfChallengeScreen> createState() => _CfChallengeScreenState();
}

class _CfChallengeScreenState extends State<CfChallengeScreen> {
  bool _done = false;
  InAppWebViewController? _controller;

  // Shared heuristic (see webview_service) so the two CF detectors stay in sync.
  Future<bool> _isChallenge(InAppWebViewController c) =>
      isCloudflareChallengePage(c);

  Future<void> _check() async {
    if (_done || _controller == null) return;
    if (!await _isChallenge(_controller!)) {
      _done = true;
      await WebViewService().storeCookiesFrom(widget.url, _controller!);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.miscVerifyHuman,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          color: cs.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            t.miscCfInstructions,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              clearCache: false,
            ),
            onWebViewCreated: (c) => _controller = c,
            onLoadStop: (c, _) async => _check(),
            onUpdateVisitedHistory: (c, _, _) async => _check(),
          ),
        ),
      ]),
    );
  }
}
