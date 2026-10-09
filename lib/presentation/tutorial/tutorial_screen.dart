import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/settings_store.dart';

/// Discord invite — also shown in About and the Help & Tips page.
const String discordInviteUrl = 'https://discord.gg/qmGB7h7vsn';

/// Persisted once the user has seen (or skipped) the first-launch tutorial, so
/// it never auto-opens again. See the new-vs-existing-user check in AppShell.
const String tutorialSeenKey = 'tutorial_seen';

/// Swipeable, illustrated first-run tutorial — each slide has a small mockup of
/// the relevant screen. Also replayable from Settings → Help & Tips.
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _count = 6;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    SettingsStore.instance.setBool(tutorialSeenKey, true);
    if (mounted) Navigator.of(context).maybePop();
  }

  void _next() {
    if (_page >= _count - 1) {
      _finish();
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    }
  }

  Future<void> _openDiscord() async {
    try {
      await launchUrl(Uri.parse(discordInviteUrl),
          mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLast = _page == _count - 1;

    final slides = <Widget>[
      _slide(cs,
          art: _WelcomeArt(cs),
          title: 'Welcome to Foxlations',
          body: 'One app for manga and manhwa, anime, and light novels — read, '
              'watch and listen, all from sources you add yourself. No account, '
              'no ads, nothing phoning home.'),
      _slide(cs,
          art: _BrowseArt(cs),
          title: 'Get your content',
          body: 'Foxlations ships empty — you choose the sources. In the Browse '
              'tab, open the ⋯ menu to add an extension repository (a link your '
              'community shares), or build one for almost any site with RepoForge. '
              'Installed sources show up ready to search.'),
      _slide(cs,
          art: _LibraryArt(cs),
          title: 'Build your library',
          body: 'Search a source or use global search across all of them, open a '
              'title, and tap the heart to add it. Your library is organized with '
              'categories (Reading, On-hold, your own…) and a “Continue reading” '
              'shortcut right up top.'),
      _slide(cs,
          art: _ReaderArt(cs),
          title: 'Read your way',
          body: 'Paged, webtoon or double-page; tap the edges to turn pages and '
              'the centre for controls. Dial in eye-comfort (warm filter + dim), '
              'customise the novel reader, let it read novels aloud, and skip '
              'anime intros automatically.'),
      _slide(cs,
          art: _VaultArt(cs),
          title: 'Private & offline',
          body: 'Download chapters and episodes to read with no connection, back '
              'up your whole library, and keep private titles locked away in the '
              'Vault. There’s incognito mode and an app lock too.'),
      _slide(cs,
          art: _CommunityArt(cs),
          title: 'Join the community',
          body: 'Questions, source help, feature requests, or just want to chat? '
              'Come say hi on our Discord — and you can reopen this tour any time '
              'from Settings → Help & Tips.',
          extra: OutlinedButton.icon(
            onPressed: _openDiscord,
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text('Join Discord',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
          )),
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(isLast ? '' : 'Skip',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, color: cs.outline)),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (p) => setState(() => _page = p),
                children: slides,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _count; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _page ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == _page ? cs.primary : cs.outline.withAlpha(90),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(isLast ? 'Get started' : 'Next',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slide(ColorScheme cs,
      {required Widget art,
      required String title,
      required String body,
      Widget? extra}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          SizedBox(height: 260, child: Center(child: art)),
          const SizedBox(height: 28),
          Text(title,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface)),
          const SizedBox(height: 12),
          Text(body,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                  fontSize: 14, height: 1.55, color: cs.outline)),
          if (extra != null) ...[const SizedBox(height: 18), extra],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Illustrations ──────────────────────────────────────────────────────────

/// A small rounded "phone" frame that holds a mini screen mockup.
class _Phone extends StatelessWidget {
  final Widget child;
  const _Phone({required this.child});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 180,
      height: 250,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cs.outlineVariant, width: 2.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 24,
              offset: const Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.all(7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Container(color: cs.surfaceContainerHighest, child: child),
      ),
    );
  }
}

Widget _bar(ColorScheme cs, {double w = 60, double h = 8, Color? c}) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
        color: c ?? cs.outline.withAlpha(55),
        borderRadius: BorderRadius.circular(4)));

class _WelcomeArt extends StatelessWidget {
  final ColorScheme cs;
  const _WelcomeArt(this.cs);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [cs.primary.withAlpha(40), cs.primary.withAlpha(12)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Image.asset('assets/images/foxlations.png',
              width: 80, height: 80),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          children: [
            _pill(cs, 'Manga'),
            _pill(cs, 'Anime'),
            _pill(cs, 'Novels'),
          ],
        ),
      ],
    );
  }

  Widget _pill(ColorScheme cs, String s) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color: cs.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(20)),
        child: Text(s,
            style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cs.primary)),
      );
}

class _BrowseArt extends StatelessWidget {
  final ColorScheme cs;
  const _BrowseArt(this.cs);
  @override
  Widget build(BuildContext context) {
    return _Phone(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bar(cs, w: 70, h: 10, c: cs.onSurface.withAlpha(120)),
            const SizedBox(height: 12),
            // Highlighted "Add repository" row.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.primary, width: 1.5),
              ),
              child: Row(children: [
                Icon(Icons.add_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 8),
                _bar(cs, w: 78, h: 8, c: cs.primary.withAlpha(160)),
              ]),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < 3; i++) ...[
              Row(children: [
                Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                        color: cs.outline.withAlpha(45),
                        borderRadius: BorderRadius.circular(7))),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _bar(cs, w: 84, h: 7),
                  const SizedBox(height: 5),
                  _bar(cs, w: 54, h: 6),
                ]),
              ]),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _LibraryArt extends StatelessWidget {
  final ColorScheme cs;
  const _LibraryArt(this.cs);
  @override
  Widget build(BuildContext context) {
    return _Phone(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bar(cs, w: 54, h: 10, c: cs.onSurface.withAlpha(120)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
                children: List.generate(6, (i) {
                  return Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cs.primary.withAlpha(60 + (i % 3) * 30),
                            cs.primary.withAlpha(22),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    if (i == 0)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Icon(Icons.favorite_rounded,
                            size: 14, color: cs.error),
                      ),
                  ]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderArt extends StatelessWidget {
  final ColorScheme cs;
  const _ReaderArt(this.cs);
  @override
  Widget build(BuildContext context) {
    return _Phone(
      child: Stack(
        children: [
          // "page" of text lines
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 22, 14, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 9; i++) ...[
                  _bar(cs,
                      w: i.isEven ? 150 : 120,
                      h: 7,
                      c: cs.onSurface.withAlpha(45)),
                  const SizedBox(height: 9),
                ],
              ],
            ),
          ),
          // top chapter bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: cs.surface.withAlpha(220),
              child: Row(children: [
                Icon(Icons.arrow_back_rounded,
                    size: 13, color: cs.onSurface.withAlpha(150)),
                const SizedBox(width: 8),
                _bar(cs, w: 70, h: 6, c: cs.onSurface.withAlpha(120)),
              ]),
            ),
          ),
          // bottom reader bar with a slider
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: cs.surface.withAlpha(230),
              child: Row(children: [
                Text('3',
                    style: GoogleFonts.robotoMono(
                        fontSize: 9, color: cs.onSurface.withAlpha(150))),
                const SizedBox(width: 6),
                Expanded(
                  child: Stack(alignment: Alignment.centerLeft, children: [
                    Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color: cs.outline.withAlpha(60),
                            borderRadius: BorderRadius.circular(2))),
                    FractionallySizedBox(
                      widthFactor: 0.4,
                      child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(2))),
                    ),
                    Positioned(
                      left: 62,
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: cs.primary, shape: BoxShape.circle)),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultArt extends StatelessWidget {
  final ColorScheme cs;
  const _VaultArt(this.cs);
  @override
  Widget build(BuildContext context) {
    return _Phone(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.lock_rounded, size: 14, color: cs.primary),
              const SizedBox(width: 6),
              _bar(cs, w: 44, h: 9, c: cs.onSurface.withAlpha(120)),
            ]),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
                children: List.generate(6, (i) {
                  return Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: cs.outline.withAlpha(38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.lock_rounded,
                          size: 16, color: cs.outline.withAlpha(130)),
                    ),
                    if (i == 1 || i == 4)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: cs.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.download_rounded,
                              size: 10, color: Colors.white),
                        ),
                      ),
                  ]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityArt extends StatelessWidget {
  final ColorScheme cs;
  const _CommunityArt(this.cs);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [cs.primary.withAlpha(45), cs.primary.withAlpha(14)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.forum_rounded, size: 64, color: cs.primary),
    );
  }
}
