import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/cookie_store.dart';
import '../../core/services/settings_store.dart';
import '../../core/services/webview_service.dart';
import '../../core/utils/adblock.dart';
import '../../l10n/app_localizations.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final bool cloudflareMode;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.cloudflareMode = false,
  });

  /// Preference key for adblock toggle.
  static const adBlockKey = 'webview_adblock_enabled';

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _controller;
  bool _isLoading = true;
  bool _adBlockEnabled = true;
  // Surfaced when the page/challenge fails to load (previously a silent white
  // screen). A watchdog also sets a message if nothing finishes loading.
  String? _loadError;
  Timer? _watchdog;
  // The UA the WebView loads with. Must match the one the app uses for requests so a
  // cf_clearance solved here is valid afterwards (cf_clearance is UA-bound). Without a
  // realistic UA (and DOM storage), Cloudflare's challenge page renders BLANK in WKWebView.
  String? _userAgent;
  // Origin of the page currently committed in the webview. The redirect guard
  // compares a pending navigation against this to tell "same site" from a jump
  // off-site; null until the first page loads so the initial navigation (and its
  // own redirects) is never blocked.
  String? _currentOrigin;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  /// Gate for [InAppWebView.shouldOverrideUrlLoading]: cancel the ad "redirect
  /// hijack" — a page auto-navigating the main frame to a DIFFERENT site without
  /// the user tapping anything — plus non-web schemes (intent://, market://, …)
  /// that yank you into another app. Everything the user actually clicks
  /// (LINK_ACTIVATED / a real gesture), same-site navigation, and the first load
  /// is allowed, so normal clicking-around still works. Off while solving
  /// Cloudflare and when the ad-block toggle is off.
  Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
      InAppWebViewController controller, NavigationAction action) async {
    if (widget.cloudflareMode || !_adBlockEnabled) {
      return NavigationActionPolicy.ALLOW;
    }
    if (action.isForMainFrame == false) return NavigationActionPolicy.ALLOW;
    final uri = action.request.url;
    if (uri == null) return NavigationActionPolicy.ALLOW;
    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'about') return NavigationActionPolicy.ALLOW;
    // Non-web schemes are app-redirect ads (open the store / another app).
    if (scheme != 'http' && scheme != 'https') {
      logger.warning('[WebView] blocked non-web navigation: $uri',
          category: LogCategory.network);
      return NavigationActionPolicy.CANCEL;
    }
    final type = action.navigationType;
    final userInitiated = (action.hasGesture ?? false) ||
        type == NavigationType.LINK_ACTIVATED ||
        type == NavigationType.FORM_SUBMITTED ||
        type == NavigationType.FORM_RESUBMITTED ||
        type == NavigationType.BACK_FORWARD ||
        type == NavigationType.RELOAD;
    final cur = _currentOrigin;
    String? targetOrigin;
    try {
      targetOrigin = uri.origin;
    } catch (_) {}
    if (!userInitiated && cur != null && targetOrigin != null && targetOrigin != cur) {
      logger.warning('[WebView] blocked auto-redirect to $uri (from $cur)',
          category: LogCategory.network);
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  Future<void> _prepare() async {
    final ua = await CookieStore().getUserAgent();
    if (!mounted) return;
    setState(() {
      _adBlockEnabled =
          SettingsStore.instance.getBool(WebViewScreen.adBlockKey) ?? true;
      _userAgent = ua;
    });
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    super.dispose();
  }

  Future<void> _injectAdBlock(InAppWebViewController controller) async {
    if (_adBlockEnabled) {
      await controller.evaluateJavascript(source: adBlockScript);
    }
  }

  /// If nothing finishes loading in time, replace the (otherwise blank) screen
  /// with a message instead of leaving the user staring at white.
  void _startWatchdog() {
    _watchdog?.cancel();
    _watchdog = Timer(const Duration(seconds: 30), () {
      if (mounted && _isLoading) {
        setState(() => _loadError =
            'The page is taking a long time to load. Cloudflare may be '
            'blocking this request — try Reload, or go back and retry.');
        logger.warning('[WebView] load watchdog fired for ${widget.url}',
            category: LogCategory.network);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _controller?.goBack(),
            tooltip: t.appBack,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_rounded),
            onPressed: () => _controller?.goForward(),
            tooltip: t.appForward,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller?.reload(),
            tooltip: t.appReload,
          ),
          if (widget.cloudflareMode)
            IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: _extractCookiesAndClose,
              tooltip: t.appDoneSaveCookies,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (v) {
              if (v == 'external') _openInExternalBrowser();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'external',
                child: Row(
                  children: [
                    const Icon(Icons.open_in_new_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(t.detailOpenInBrowser),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: _isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      body: _userAgent == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                InAppWebView(
                  webViewEnvironment: webViewEnvironment,
                  initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    // A real browser UA so a Cloudflare challenge renders here
                    // (cf_clearance is UA-bound). On iOS the two flags below are
                    // no-ops (WKWebView has DOM storage on by default and the
                    // iOS cookie knob is sharedCookiesEnabled), so set that too —
                    // the Turnstile iframe needs a consistent cookie store or it
                    // paints blank. domStorage/thirdPartyCookies apply on Android.
                    userAgent: _userAgent,
                    domStorageEnabled: true,
                    thirdPartyCookiesEnabled: true,
                    sharedCookiesEnabled: true,
                    // Ad-junk hardening: no JS-spawned popup windows, no second
                    // window at all, and media can't autoplay (ad videos) — a
                    // reader never needs any of these. useShouldOverrideUrlLoading
                    // turns on the navigation guard below (redirect hijacks).
                    javaScriptCanOpenWindowsAutomatically: false,
                    supportMultipleWindows: false,
                    allowsInlineMediaPlayback: true,
                    mediaPlaybackRequiresUserGesture: true,
                    useShouldOverrideUrlLoading: true,
                    isFraudulentWebsiteWarningEnabled: false,
                    transparentBackground: false,
                  ),
                  onWebViewCreated: (controller) => _controller = controller,
                  // A page that tries to spawn a new window/tab (target=_blank,
                  // window.open) is almost always an ad popup/popunder here — never
                  // open a second webview; return false to drop it.
                  onCreateWindow: (controller, action) async => false,
                  // Block the redirect hijack: a page auto-navigating you OFF the
                  // current site without a tap. Allow the initial load, same-site
                  // navigation, and anything you actually clicked.
                  shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
                  onLoadStart: (_, _) {
                    _startWatchdog();
                    if (mounted) {
                      setState(() {
                        _isLoading = true;
                        _loadError = null;
                      });
                    }
                  },
                  onLoadStop: (controller, url) async {
                    _watchdog?.cancel();
                    // Anchor the redirect guard on the page that actually loaded.
                    if (url != null) {
                      try {
                        _currentOrigin = url.origin;
                      } catch (_) {}
                    }
                    if (mounted) setState(() => _isLoading = false);
                    // Adblock can strip challenge DOM, so skip it while solving
                    // Cloudflare — only inject for normal browsing.
                    if (!widget.cloudflareMode) {
                      await _injectAdBlock(controller);
                    }
                    // Extract cookies on every page load
                    if (url != null) {
                      final cookies = await CookieManager.instance(
                              webViewEnvironment: webViewEnvironment)
                          .getCookies(
                        url: WebUri(url.toString()),
                        webViewController: controller,
                      );
                      if (cookies.isNotEmpty) {
                        final domain = url.host;
                        final cookieMap = <String, String>{};
                        for (final c in cookies) {
                          cookieMap[c.name] = c.value.toString();
                        }
                        await CookieStore().setCookies(domain, cookieMap);
                      }
                    }
                  },
                  // Surface load failures (previously a silent white screen) to
                  // the in-app log + an on-screen message.
                  onReceivedError: (controller, request, error) {
                    logger.error(
                        '[WebView] load error ${error.type}: ${error.description}',
                        category: LogCategory.network,
                        detail: request.url.toString());
                    if ((request.isForMainFrame ?? true) && mounted) {
                      setState(() {
                        _isLoading = false;
                        _loadError = error.description;
                      });
                      _watchdog?.cancel();
                    }
                  },
                  onReceivedHttpError: (controller, request, errorResponse) {
                    logger.warning(
                        '[WebView] HTTP ${errorResponse.statusCode} for ${request.url}',
                        category: LogCategory.network);
                  },
                ),
                if (_loadError != null) _buildErrorBanner(t),
              ],
            ),
    );
  }

  Widget _buildErrorBanner(AppLocalizations t) {
    final cs = Theme.of(context).colorScheme;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        color: cs.errorContainer,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(children: [
              Icon(Icons.error_outline_rounded, color: cs.onErrorContainer, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(_loadError!,
                    style: TextStyle(color: cs.onErrorContainer, fontSize: 12.5)),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _loadError = null);
                  _controller?.reload();
                },
                child: Text(t.appReload),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  /// Open the page currently shown (which may differ from the initial url after
  /// navigation) in the user's default browser. Forces an external launch rather
  /// than routing through ExternalBrowser, which would re-open the in-app WebView
  /// when the "external browser" setting is off — here the user asked for it.
  Future<void> _openInExternalBrowser() async {
    final current = (await _controller?.getUrl())?.toString() ?? widget.url;
    bool ok = false;
    try {
      ok = await launchUrl(Uri.parse(current),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      logger.error('[WebView] external open failed: $e',
          category: LogCategory.general, detail: current);
    }
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).webviewOpenFailed)),
      );
    }
  }

  Future<void> _extractCookiesAndClose() async {
    if (_controller != null) {
      final url = await _controller!.getUrl();
      if (url != null) {
        final domain = url.host;
        final cookies = await CookieManager.instance(webViewEnvironment: webViewEnvironment).getCookies(
          url: WebUri(url.toString()),
          webViewController: _controller,
        );
        if (cookies.isNotEmpty) {
          final cookieMap = <String, String>{};
          for (final c in cookies) {
            cookieMap[c.name] = c.value.toString();
          }
          await CookieStore().setCookies(domain, cookieMap);
          // Also store for normalized domain
          final normalized = WebViewService().normalizeDomain(domain);
          if (normalized != domain) {
            await CookieStore().setCookies(normalized, cookieMap);
          }
        }
      }
    }
    if (mounted) Navigator.pop(context, true);
  }
}
