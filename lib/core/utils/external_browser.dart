import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/settings_store.dart';
import '../services/app_logger.dart';
import '../../routes/app_routes.dart';

/// Opens a source/manga web link the way the user prefers.
///
/// Advanced > "External browser": when ON, hands the link to the system browser;
/// when OFF (default) it uses the in-app WebView (which also carries the
/// Cloudflare cookie jar). Only call this for explicit "open this page" actions - 
/// the Cloudflare challenge and OAuth flows must stay in the in-app WebView.
/// Falls back to the in-app WebView if the external launch fails.
class ExternalBrowser {
  static Future<void> openLink(BuildContext context, String url,
      {String? title}) async {
    final external =
        SettingsStore.instance.getBool('adv_external_browser') ?? false;
    if (external) {
      try {
        final ok = await launchUrl(Uri.parse(url),
            mode: LaunchMode.externalApplication);
        if (ok) return;
      } catch (e) {
        logger.error('External browser launch failed: $e',
            category: LogCategory.general, detail: url);
      }
      // Fall through to the in-app WebView if the external launch didn't take.
    }
    if (!context.mounted) return;
    Navigator.pushNamed(context, AppRoutes.webview,
        arguments: {'url': url, 'title': title});
  }
}
