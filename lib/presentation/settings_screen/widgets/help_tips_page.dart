import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import '../../tutorial/tutorial_screen.dart';

/// Settings → Help & Tips: replay the tutorial, join the community, and a few
/// quick pointers.
class HelpTipsPage extends StatelessWidget {
  const HelpTipsPage({super.key});

  Future<void> _openDiscord() async {
    try {
      await launchUrl(Uri.parse(discordInviteUrl),
          mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final tips = <(IconData, String, String)>[
      (Icons.extension_rounded, t.helpTipsNoContentTitle, t.helpTipsNoContentBody),
      (Icons.swipe_rounded, t.helpTipsGesturesTitle, t.helpTipsGesturesBody),
      (Icons.lock_rounded, t.helpTipsVaultTitle, t.helpTipsVaultBody),
      (Icons.sync_rounded, t.helpTipsUpdateTitle, t.helpTipsUpdateBody),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(t.helpTipsTitle,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          ListTile(
            leading: Icon(Icons.school_rounded, color: cs.primary),
            title: Text(t.helpTipsViewTutorial,
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(t.helpTipsViewTutorialSub,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.outline)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TutorialScreen())),
          ),
          ListTile(
            leading: Icon(Icons.forum_rounded, color: cs.primary),
            title: Text(t.helpTipsDiscord,
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(t.helpTipsDiscordSub,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.outline)),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: _openDiscord,
          ),
          const Divider(height: 24),
          AppSectionLabel(
            t.helpTipsSectionTips,
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
          ),
          for (final (icon, title, body) in tips)
            ListTile(
              leading: Icon(icon, color: cs.outline),
              title: Text(title,
                  style: Theme.of(context).textTheme.titleSmall),
              subtitle: Text(body,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12.5, color: cs.outline)),
            ),
        ],
      ),
    );
  }
}
