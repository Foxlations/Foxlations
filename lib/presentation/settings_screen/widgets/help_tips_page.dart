import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../tutorial/tutorial_screen.dart';

/// Settings → Help & Tips: replay the tutorial, join the community, and a few
/// quick pointers.
class HelpTipsPage extends StatelessWidget {
  const HelpTipsPage({super.key});

  static const _tips = <(IconData, String, String)>[
    (Icons.extension_rounded, 'No content showing?',
        'Add an extension repository in Browse → ⋯ to install sources first.'),
    (Icons.swipe_rounded, 'Reader gestures',
        'Tap the edges to turn pages, the center to show controls; long-press a page for more.'),
    (Icons.lock_rounded, 'The Vault',
        'Move private titles into the Vault to keep them behind a lock.'),
    (Icons.sync_rounded, 'Keep up to date',
        'Pull down on the Library to check for new chapters; set a schedule in Library settings.'),
  ];

  Future<void> _openDiscord() async {
    try {
      await launchUrl(Uri.parse(discordInviteUrl),
          mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Tips',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: Icon(Icons.school_rounded, color: cs.primary),
            title: Text('View tutorial',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
            subtitle: Text('A quick tour of the app',
                style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TutorialScreen())),
          ),
          ListTile(
            leading: Icon(Icons.forum_rounded, color: cs.primary),
            title: Text('Join our Discord',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
            subtitle: Text('Help, requests & community',
                style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: _openDiscord,
          ),
          const Divider(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('TIPS',
                style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.outline,
                    letterSpacing: 0.5)),
          ),
          for (final (icon, title, body) in _tips)
            ListTile(
              leading: Icon(icon, color: cs.outline),
              title: Text(title,
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
              subtitle: Text(body,
                  style: GoogleFonts.manrope(fontSize: 12.5, color: cs.outline)),
            ),
        ],
      ),
    );
  }
}
