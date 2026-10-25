import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/update_service.dart';
import '../../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../webview_screen/webview_screen.dart';

/// Tells the user a newer build exists.
///
/// Android gets a download action (a sideloaded APK has nothing else to update
/// it). iOS gets an informational sheet pointing at AltStore, because iOS
/// cannot install an IPA fetched from a browser - offering a download there
/// would look like an update path and then dead-end.
class UpdatePrompt {
  /// Checks in the background and shows the prompt if one is due.
  /// Safe to call from a screen's initState; silently does nothing otherwise.
  static Future<void> maybeShow(BuildContext context,
      {bool force = false}) async {
    final release = await UpdateService.check(force: force);
    if (release == null) {
      if (force && context.mounted) {
        AppTheme.showSnackBar(
            context, AppLocalizations.of(context).appOnLatestVersion);
      }
      return;
    }
    if (!force && await UpdateService.alreadyDismissed(release.buildNumber)) {
      return;
    }
    if (!context.mounted) return;
    await _show(context, release);
  }

  static Future<void> _show(BuildContext context, AppRelease r) async {
    final cs = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (ctx) => _UpdateSheet(release: r),
    );
    await UpdateService.dismiss(r.buildNumber);
  }
}

class _UpdateSheet extends StatelessWidget {
  final AppRelease release;
  const _UpdateSheet({required this.release});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final isIOS = Platform.isIOS;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Row(
                children: [
                  Icon(Icons.system_update_rounded, color: cs.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.appUpdateAvailable,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface)),
                        Text(t.appVersionBuild(release.version, release.buildNumber),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12.5, color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (release.notes.isNotEmpty)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: SingleChildScrollView(
                    child: Text(
                      release.notes.trim(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.45, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: isIOS ? _iosActions(context, cs) : _androidActions(context, cs),
            ),
          ],
        ),
      ),
    );
  }

  // ── Android: go straight to the APK ───────────────────────────────────────
  Widget _androidActions(BuildContext context, ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Opened in the in-app browser, which hands the download to
              // Android's download manager; tapping the finished file runs the
              // system installer. Installing directly would need the
              // REQUEST_INSTALL_PACKAGES permission and a FileProvider.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                    url: release.apkUrl,
                    title: t.appDownloadUpdate,
                  ),
                ),
              );
            },
            child: Text(t.appDownloadVersion(release.version),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 14.5, fontWeight: FontWeight.w700, color: cs.onPrimary)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          t.appApkDownloadHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11.5, color: cs.onSurfaceVariant),
        ),
      ],
    );
  }

  // ── iOS: AltStore does the updating ───────────────────────────────────────
  Widget _iosActions(BuildContext context, ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: cs.primary.withAlpha(60)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: cs.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  t.appIosUpdateHint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5, height: 1.4, color: cs.onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.primary,
              side: BorderSide(color: cs.primary.withAlpha(120)),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
            ),
            onPressed: () async {
              await Clipboard.setData(
                  const ClipboardData(text: UpdateService.sourceUrl));
              if (context.mounted) {
                Navigator.pop(context);
                AppTheme.showSnackBar(context, t.appSourceUrlCopied);
              }
            },
            child: Text(t.appCopyAltstoreUrl,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.primary)),
          ),
        ),
      ],
    );
  }
}
