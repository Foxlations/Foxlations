import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/tracking_provider.dart';
import '../../../core/tracking/tracker.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../tracking/tracker_oauth_screen.dart';
import '../../widgets/ds/ds.dart';

class TrackingSettingsPage extends StatelessWidget {
  const TrackingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final tracking = context.watch<TrackingProvider>();
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: cs.onSurface, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text(t.trackTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: 8, bottom: 8 + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          AppSettingsSectionHeader(title: t.trackServices),
          for (final t in tracking.trackers) _TrackerTile(tracker: t),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              t.trackServicesDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.outline, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TrackerTile extends StatelessWidget {
  final Tracker tracker;
  const _TrackerTile({required this.tracker});

  IconData get _icon {
    switch (tracker.id) {
      case 'anilist':
        return Icons.auto_graph_rounded;
      case 'kitsu':
        return Icons.pets_rounded;
      default:
        return Icons.track_changes_rounded;
    }
  }

  Future<void> _connect(BuildContext context) async {
    final tp = context.read<TrackingProvider>();
    if (tracker.authType == TrackerAuthType.credentials) {
      await _credentialsLogin(context, tp);
    } else {
      await _oauthLogin(context, tp);
    }
  }

  Future<void> _credentialsLogin(
      BuildContext context, TrackingProvider tp) async {
    final userCtl = TextEditingController();
    final passCtl = TextEditingController();
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.trackLogInTo(tracker.name)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: userCtl,
            autocorrect: false,
            decoration: InputDecoration(labelText: t.trackEmailOrUsername),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passCtl,
            obscureText: true,
            decoration: InputDecoration(labelText: t.trackPassword),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t.trackCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t.trackLogIn)),
        ],
      ),
    );
    if (ok != true) return;
    final success = await tp.connectWithCredentials(
        tracker.id, userCtl.text.trim(), passCtl.text);
    if (context.mounted) {
      AppTheme.showSnackBar(
          context,
          success
              ? t.trackConnectedTo(tracker.name)
              : t.trackLoginFailed);
    }
  }

  Future<void> _oauthLogin(BuildContext context, TrackingProvider tp) async {
    final t = AppLocalizations.of(context);
    var cid = tp.clientId(tracker.id);
    if (cid.isEmpty) {
      final entered = await _promptClientId(context, tp);
      if (entered == null || entered.isEmpty) return;
      cid = entered;
    }
    final url = tp.authorizeUrl(tracker.id);
    if (url == null) {
      if (context.mounted) {
        AppTheme.showSnackBar(context, t.trackSetClientIdFirst);
      }
      return;
    }
    final captured = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => TrackerOAuthScreen(
          authorizeUrl: url,
          trackerName: tracker.name,
          usesCode: tracker.oauthUsesCode,
          redirectUri: tracker.oauthRedirect,
        ),
      ),
    );
    if (captured == null || captured.isEmpty) {
      // Manual token paste only helps token flows; a PKCE code can't be pasted
      // (it is single-use and tied to the in-flight verifier).
      if (!tracker.oauthUsesCode && context.mounted) {
        await _manualToken(context, tp);
      }
      return;
    }
    final ok = await tp.completeOAuth(tracker.id, captured);
    if (context.mounted) {
      AppTheme.showSnackBar(context,
          ok ? t.trackConnectedTo(tracker.name) : t.trackCouldNotCompleteSignIn);
    }
  }

  Future<String?> _promptClientId(
      BuildContext context, TrackingProvider tp) async {
    final ctl = TextEditingController(text: tp.clientId(tracker.id));
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.trackClientIdTitle(tracker.name)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            t.trackClientIdDescription(tracker.name),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: ctl,
            autocorrect: false,
            decoration: InputDecoration(labelText: t.trackClientId),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t.trackCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t.trackSave)),
        ],
      ),
    );
    if (ok != true) return null;
    await tp.setClientId(tracker.id, ctl.text.trim());
    return ctl.text.trim();
  }

  Future<void> _manualToken(BuildContext context, TrackingProvider tp) async {
    final ctl = TextEditingController();
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.trackPasteAccessToken),
        content: TextField(
          controller: ctl,
          maxLines: 3,
          autocorrect: false,
          decoration: InputDecoration(
              hintText: t.trackPasteTokenHint),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t.trackCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t.trackConnect)),
        ],
      ),
    );
    if (ok != true || ctl.text.trim().isEmpty) return;
    final connected = await tp.connectWithToken(tracker.id, ctl.text.trim());
    if (context.mounted) {
      AppTheme.showSnackBar(context,
          connected ? t.trackConnectedTo(tracker.name) : t.trackCouldNotVerifyToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final connected = tracker.isAuthenticated;
    final color = Color(tracker.colorValue);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: oledIconChip(context,
              color: color, fill: color.withAlpha(25)),
          child: Icon(_icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tracker.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface)),
            const SizedBox(height: 2),
            Text(
              connected
                  ? (tracker.username != null
                      ? t.trackConnectedAs(tracker.username!)
                      : t.trackConnected)
                  : (tracker.authType == TrackerAuthType.oauth
                      ? t.trackTapConnectToAuthorize
                      : t.trackSignInWithAccount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: connected ? AppTheme.success : cs.outline),
            ),
          ]),
        ),
        if (!connected && tracker.authType == TrackerAuthType.oauth)
          IconButton(
            tooltip: t.trackClientId,
            icon: Icon(Icons.key_rounded, size: 18, color: cs.outline),
            onPressed: () =>
                _promptClientId(context, context.read<TrackingProvider>()),
          ),
        GestureDetector(
          onTap: () => connected
              ? context.read<TrackingProvider>().disconnect(tracker.id)
              : _connect(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: connected
                  ? AppTheme.error.withAlpha(26)
                  : cs.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(
                  color: connected ? AppTheme.error : cs.primary, width: 1),
            ),
            child: Text(connected ? t.trackDisconnect : t.trackConnect,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: connected ? AppTheme.error : cs.primary)),
          ),
        ),
      ]),
    );
  }
}

