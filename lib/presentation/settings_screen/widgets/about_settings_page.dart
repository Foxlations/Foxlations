import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import '../../tutorial/tutorial_screen.dart' show discordInviteUrl;
import '../../../l10n/app_localizations.dart';
import '../../widgets/update_prompt.dart';
import 'vault_settings_page.dart';

class AboutSettingsPage extends StatefulWidget {
  const AboutSettingsPage({super.key});

  @override
  State<AboutSettingsPage> createState() => _AboutSettingsPageState();
}

class _AboutSettingsPageState extends State<AboutSettingsPage> {
  static const _sourceCodeUrl = 'https://github.com/Foxlations/Foxlations';
  static const _bugReportUrl = 'https://github.com/Foxlations/Foxlations/issues';

  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _info = info);
    });
  }

  String _versionLabel(AppLocalizations t) {
    if (_info == null) return '';
    return t.setxAboutVersionBuild(_info!.version, _info!.buildNumber);
  }

  String get _version => _info?.version ?? '';

  // Secret vault opener: tap the Foxlations logo 9× (moved here from Appearance
  // settings). Fast consecutive taps only, so it isn't triggered by accident.
  int _logoTapCount = 0;
  DateTime _lastLogoTap = DateTime(2000);

  void _onLogoTap(BuildContext context) {
    final now = DateTime.now();
    _logoTapCount =
        now.difference(_lastLogoTap).inMilliseconds < 600 ? _logoTapCount + 1 : 1;
    _lastLogoTap = now;

    if (_logoTapCount >= 7 && _logoTapCount < 9) {
      final remaining = 9 - _logoTapCount;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: Text(
              '$remaining more tap${remaining == 1 ? '' : 's'} to open vault settings'),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
        ));
    }
    if (_logoTapCount >= 9) {
      _logoTapCount = 0;
      ScaffoldMessenger.of(context).clearSnackBars();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VaultSettingsPage()),
      );
    }
  }

  Future<void> _copyLink(BuildContext context, String url, String label) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      AppTheme.showSnackBar(
          context, AppLocalizations.of(context).setxAboutLinkCopied(label));
    }
  }

  /// Open the Discord invite in the Discord app / browser; copy it if that fails.
  Future<void> _openDiscord(BuildContext context) async {
    try {
      final ok = await launchUrl(Uri.parse(discordInviteUrl),
          mode: LaunchMode.externalApplication);
      if (ok) return;
    } catch (_) {}
    if (context.mounted) _copyLink(context, discordInviteUrl, 'Discord');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.setxAboutTitle),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.md + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          // App hero card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onLogoTap(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/foxlations.png',
                      width: 72,
                      height: 72,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Foxlations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _versionLabel(t),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppSettingsSectionHeader(title: t.setxAboutSectionApp),
          _ActionTile(
            icon: Icons.new_releases_rounded,
            iconColor: cs.primary,
            iconBg: isDark
                ? const Color(0xFF3D1A10)
                : const Color(0xFFFFEDE8),
            title: t.setxAboutWhatsNewTitle,
            subtitle: t.setxAboutWhatsNewSubtitle,
            onTap: () => _showChangelog(context),
          ),
          _ActionTile(
            icon: Icons.system_update_rounded,
            iconColor: AppTheme.success,
            iconBg: isDark
                ? const Color(0xFF0D2E1E)
                : const Color(0xFFE6F7EF),
            title: t.setxAboutCheckUpdatesTitle,
            subtitle: t.setxAboutCheckUpdatesSubtitle,
            // Previously this always claimed "Already on the latest version"
            // without checking anything. It now reads the same latest.json the
            // download page uses, so the app and site can't disagree.
            onTap: () => UpdatePrompt.maybeShow(context, force: true),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxAboutSectionLegal),
          _ActionTile(
            icon: Icons.description_rounded,
            iconColor: AppTheme.secondary,
            iconBg: isDark
                ? const Color(0xFF1A1640)
                : const Color(0xFFEEEDFF),
            title: t.setxAboutLicensesTitle,
            subtitle: t.setxAboutLicensesSubtitle,
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Foxlations',
              applicationVersion: _version,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxAboutSectionLinks),
          _ActionTile(
            icon: Icons.code_rounded,
            iconColor: cs.outline,
            iconBg: cs.surfaceContainerHighest,
            title: t.setxAboutSourceCodeTitle,
            subtitle: t.setxAboutSourceCodeSubtitle,
            onTap: () => _copyLink(context, _sourceCodeUrl, t.setxAboutSourceCodeLabel),
          ),
          _ActionTile(
            icon: Icons.bug_report_rounded,
            iconColor: AppTheme.error,
            iconBg: isDark
                ? const Color(0xFF2E0A0A)
                : const Color(0xFFFFEEEE),
            title: t.setxAboutReportBugTitle,
            subtitle: t.setxAboutReportBugSubtitle,
            onTap: () => _copyLink(context, _bugReportUrl, t.setxAboutBugReportLabel),
          ),
          _ActionTile(
            icon: Icons.forum_rounded,
            iconColor: const Color(0xFF5865F2),
            iconBg: isDark
                ? const Color(0xFF1A1C2E)
                : const Color(0xFFEDEFFF),
            title: 'Discord',
            subtitle: t.setxAboutDiscordSubtitle,
            onTap: () => _openDiscord(context),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showChangelog(BuildContext context) {
    final t = AppLocalizations.of(context);
    final versionTitle = _version.isNotEmpty
        ? t.setxAboutWhatsNewVersioned(_version)
        : t.setxAboutWhatsNewTitle;
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cs.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Text(
          versionTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.55),
            child: SingleChildScrollView(
              child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChangelogItem('Reader: the title at the top now always shows the real title. It could go '
                'blank after the app refreshed a title from its source (which dropped the name); the '
                'title is now kept. A long title also gently scrolls so you can read the whole name.'),
            _ChangelogItem('Appearance: the "Open to" row now matches the size of the other settings '
                'around it.'),
            _ChangelogItem('Under the hood: split the light-novel reader file too (the Listen /'
                'text-to-speech subsystem moved to its own file). Nothing you will see; the Listen '
                'feature works exactly as before.'),
            _ChangelogItem('Under the hood: split the large manga-reader file into smaller pieces '
                '(image translation and hands-free scrolling now live in their own files). Nothing '
                'you will see; it just keeps the code tidy.'),
            _ChangelogItem('Translations: the whole app is now translatable. Nearly every screen, '
                'menu, dialog and message has been pulled into the translation system, so the '
                'community can translate Foxlations into any language on Weblate. Nothing changes in '
                'English; this just unlocks the rest.'),
            _ChangelogItem('Appearance: choose which tab the app opens on. Settings > Appearance > '
                '"Open to" lets you pick Library, Updates, Browse, Discover, or More as your launch screen.'),
            _ChangelogItem('Under the hood: the Cloudflare challenge-page detection now lives in one '
                'shared place for both the headless and interactive solvers, so it stays consistent.'),
            _ChangelogItem('Under the hood: split the large reader screen file into smaller pieces and '
                'cleaned up code comments. Nothing you will see, it just keeps the codebase tidy.'),
            _ChangelogItem('Light novel reader (paged mode): a chapter that fits on a single page now '
                'gets marked read like any other.'),
            _ChangelogItem('Light novel reader: the font list in the in-reader menu now scrolls, so you '
                'can reach every font instead of just the first few.'),
            _ChangelogItem('Removed the custom themes option. The "Theme color strength" slider stays, '
                'so you can still tint the whole app with any of the built-in themes.'),
            _ChangelogItem('Fixed the long option lists (like the reader fonts) springing back instead '
                'of scrolling. They scroll properly now.'),
            _ChangelogItem('Light novel reader: tuned the Listen pill when a settings panel is open. It '
                'now lifts to just above the panel instead of too far up, and slides back in step with '
                'the panel closing.'),
            _ChangelogItem('Appearance: custom themes are now saved. Tap the "Custom" tile in the theme '
                'grid to make one, name it, and it shows up alongside the built-in themes. Long-press a '
                'saved custom theme to edit or delete it. You can keep as many as you like.'),
            _ChangelogItem('Settings: the font list (and other long option lists) now scrolls instead of '
                'running off the bottom of the screen.'),
            _ChangelogItem('Light novel reader: the floating Listen pill now lifts clear of an open '
                'settings panel, not just the shorter tail, so it no longer sits on top of the controls.'),
            _ChangelogItem('Appearance: a "Theme color strength" slider under Settings > Appearance. '
                'Slide it up and the theme color takes over the whole app (backgrounds and surfaces), '
                'not just the accents. At 0 it looks the way it always has.'),
            _ChangelogItem('Appearance: a custom theme. Pick your own accent, background, surface, and '
                'text colors with a built-in color picker, with a live preview and a contrast warning '
                'if a combination would be hard to read.'),
            _ChangelogItem('iOS: the volume buttons no longer turn pages or scroll in the reader. They '
                'now only tune the manga auto-scroll speed, and only while it is running, so they stop '
                'getting in the way of normal reading. Android volume behavior is unchanged.'),
            _ChangelogItem('Light novel reader: a new page-flip mode. Settings > Reader > Light novel > '
                'Reading mode (or the in-reader menu) switches between the usual scroll and discrete '
                'pages you swipe or tap the edges to turn, like an e-reader. It follows along when you '
                'Listen and keeps your place when you resume or change the text size.'),
            _ChangelogItem('Light novel reader: hyphenation. Long words now break across lines so '
                'justified text has even spacing instead of big gaps. On by default; turn it off under '
                'the reader text options. Copy and Define still give you the clean word.'),
            _ChangelogItem('Reader settings: the hands-free options (tilt, gaze, and the volume buttons) '
                'now live together on one "Hands-free & motion" page, reached from the bottom of both the '
                'Manga and Light novel tabs.'),
            _ChangelogItem('iOS: while the manga reader is auto-scrolling, the volume buttons speed it up '
                'or slow it down instead of turning pages. Needs the volume-button option on. Android '
                'volume behaviour is unchanged.'),
            _ChangelogItem('Reader: the page number on the slider now reads correctly the moment a '
                'chapter opens. It used to show the wrong page until you tapped or scrolled, because '
                'it trailed a stale copy of your position instead of the live one.'),
            _ChangelogItem('Radial "Tail" style fixes: the action icons now show on the tail (they '
                'were hidden behind it). "Customize wheel" is renamed "Customize menu" now that there '
                'are two styles, and it opens scoped to the reader whose settings you are in: the Manga '
                'tab shows only the manga actions, the Light novel tab only the novel ones.'),
            _ChangelogItem('Reader radial menu: a new "Tail" style, a slim column of icons that grows '
                'up from the + button, as an alternative to the fanned wheel. Pick Wheel or Tail '
                'separately for each reader under Settings > Reader > Menu style. (First cut of the '
                'look; it may get tweaked.)'),
            _ChangelogItem('Settings > Reader is now split by reader. A Manga / Light novel switch at '
                'the top shows just that reader\'s settings, and the light-novel side now has its font, '
                'size, line spacing, margins, alignment, theme, and the Listen controls (speed, pitch, '
                'highlight colours) right in settings, not only while reading. Fullscreen and '
                'keep-screen-on are separate for each reader now, so you can have one on for manga and '
                'off for novels. Dropped a font-size setting that did nothing.'),
            _ChangelogItem('Light-novel reader (classic bars, with the radial turned off): the bottom '
                'controls are one solid panel now, flush to the bottom edge, so reading text no longer '
                'peeks out under them. Progress is a bar you can drag to scrub through the chapter, and '
                'the sentence and word highlight colours are reachable right from the Listen row.'),
            _ChangelogItem('Settings > Reader: the "Light novel radial menu" toggle now sits right '
                'below the manga radial toggle, and the "Customize wheel" shortcut shows whenever '
                'either reader has its radial turned on.'),
            _ChangelogItem('Light-novel Listen: the play/pause pill now slides up smoothly when you '
                'show the bars and settles just above the radial, instead of jumping up near the '
                'middle. If you\'ve dragged it to a spot that sits over the radial, it lifts out of the '
                'way while the bars are up and drops back when they hide. A pill parked higher up stays '
                'where you left it.'),
            _ChangelogItem('Light-novel Listen: the "Reset pill position" control is a proper button '
                'now, so it\'s obviously tappable.'),
            _ChangelogItem('Light-novel Define: added a Wiktionary fallback. The main dictionary was '
                'returning a server error (it was down on their end); now when that happens, Define '
                'falls back to Wiktionary so word lookups keep working.'),
            _ChangelogItem('Light-novel Listen: the play/pause pill no longer sits on top of the '
                'radial wheel. It lifts above the controls when you show the bars and drops back when '
                'you hide them, and you can long-press the pill and drag it anywhere on screen (it '
                'stays put; reset it from the Listen panel).'),
            _ChangelogItem('Light-novel Listen: the sentence highlight and the current-word highlight '
                'can now be different colours. Pick each one in the Listen panel (Accent follows the '
                'app theme), so you could have, say, a purple sentence and a red word.'),
            _ChangelogItem('Light-novel Define: it now tells you whether the dictionary couldn\'t be '
                'reached versus a word having no entry, with a Retry button, and the real error lands '
                'in Debug logs so connection problems are easier to pin down.'),
            _ChangelogItem('Light-novel reader: you can now switch it back to the classic top and '
                'bottom bars instead of the radial wheel, under Settings > Reader > Light novel radial '
                'menu. Manga and novels each have their own switch for it.'),
            _ChangelogItem('Light-novel Listen: you can pick the colour the reading highlight uses. '
                'Open the Listen panel on the wheel and tap a colour, or leave it on Accent to follow '
                'the app theme.'),
            _ChangelogItem('Light-novel reader: fixed the bars and the radial wheel not hiding when '
                'you tap the page or start Listen (the new text selection had taken over the tap). '
                'Tapping now hides and reveals them again, and starting Listen tucks them away. '
                'Selecting text still works by long-pressing.'),
            _ChangelogItem('Light-novel reader: you can now select text while you\'re just reading, '
                'not only while Listen is speaking. Long-press to grab a word or passage, then copy it '
                'or tap Define for the built-in dictionary. Tapping still shows and hides the bars.'),
            _ChangelogItem('Light novels now remember your place in every chapter, not just the one '
                'you had open last. Open any chapter from the list and it picks up where you left off, '
                'the way manga and anime already do. Finished chapters still start from the top.'),
            _ChangelogItem('Light-novel Listen (text-to-speech): it now lights up the exact word as '
                'it\'s read, riding on top of the current sentence, so following along is easier. And '
                'when you pause and then play again it picks up from the sentence you were on, instead '
                'of jumping back to the start of the paragraph. (Device voices; the offline neural voice '
                'still highlights by paragraph, as it has no per-word timing.)'),
            _ChangelogItem('Reader internals: the manga reader and the novel reader now share one '
                'small piece of code for deciding how often your place is saved as you read, instead '
                'of each keeping its own copy. Behaviour is the same, but the tuning that keeps '
                'scrolling smooth now lives in one spot and can\'t drift between the two readers.'),
            _ChangelogItem('Under-the-hood tidy-up: pulled out a handful of leftover styling '
                'building-blocks nothing was using anymore, and pointed a lot of the scattered text '
                'styling back at the app\'s shared fonts instead of re-declaring them by hand in each '
                'screen. Nothing looks different, it\'s just leaner and more consistent inside.'),
            _ChangelogItem('Internal: storage, keychain, and repo-refresh failures that used to fail '
                'silently now leave a trace, so those problems are easier to diagnose if they happen.'),
            _ChangelogItem('Cleanup: removed the leftover "RepoForge" mention from the Experimental-features '
                'description (that tool was retired), stopped writing a log line on every reading-progress '
                'save, fixed some stale comments, and auto-fixed a batch of lint warnings. No behaviour change.'),
            _ChangelogItem('Fixed a crash that could happen if you backed out of a slow source while it was '
                'still loading, and a small memory leak in the tracker search box.'),
            _ChangelogItem('Layout hardening: the All / Manga / Anime / Novels toggle highlight lines up '
                'again after you rotate or change the system font size; the reader menus are protected from '
                'a layout bug that used to break their animations; and the light-novel top bar and TTS '
                'filter chips no longer overflow at large text sizes.'),
            _ChangelogItem('Global search: the search box now draws as one clean rounded field instead of '
                'the fill clipping out of the purple outline, and it lines up with the back button.'),
            _ChangelogItem('Light-novel Listen (TTS): fixed the in-app play/pause falling out of sync when '
                'you pause from the notification / lock screen - the controls now mirror the real playback '
                'state. And there\'s a floating play/pause (+ stop) control on screen while it reads, so you '
                'can pause without opening the wheel.'),
            _ChangelogItem('Light-novel reader: select a word and tap "Define" - a built-in dictionary '
                '(pronunciation + meanings by part of speech) slides up without leaving your page. '
                'Offline-friendly: it shows a gentle note if it can\'t reach the dictionary.'),
            _ChangelogItem('Light-novel reader: a proper font picker - 14 curated reading fonts (Lora, '
                'Merriweather, Literata, EB Garamond, Bitter, Inter, Open Sans, and the dyslexia-friendly '
                'Atkinson Hyperlegible & Lexend, among others) in place of just Serif / Sans / Mono. Each is '
                'previewed in its own typeface; pick it from the Font panel. Your existing choice carries over.'),
            _ChangelogItem('Reader: you can now add prev / next chapter arrows beside the page slider on the '
                'radial tail (manga) - turn on "Chapter arrows on the slider" in Settings → Reader → '
                'Customize wheel (Manga tab). They appear flanking the slider when the wheel is open.'),
            _ChangelogItem('Reader: auto-scroll now lives INSIDE the page-of-page pill while it runs - the '
                'pill shows a pause icon + the current speed (and the page count), and tapping it pauses and '
                'brings the controls back. Replaces the separate corner control; works in both the radial '
                'and classic layouts. (Change the speed from the wheel\'s auto-scroll settings.)'),
            _ChangelogItem('Reader: NEW radial-menu customization - Settings → Reader → Customize wheel. Drag '
                'to reorder the wheel actions and toggle which ones appear, set up separately for the manga '
                'reader and the light-novel reader (they share the wheel but have different actions). More '
                'radial options (what rides on the slider tail, merging auto-scroll into the page pill) are '
                'coming next.'),
            _ChangelogItem('Reader: the auto-scroll control now stays visible while it\'s running - a compact '
                'pill tucked into the page-number corner with pause and speed − / +, so you can see it\'s on '
                'and adjust it without reopening a menu. It\'s a corner control now (not a floating bar), and '
                'tapping the page still pauses.'),
            _ChangelogItem('Reader: fixed the radial menu + back-button animations not playing (a regression '
                'from the auto-scroll build - its floating control was remounting the menu on every tap). '
                'Auto-scroll is now built into the controls instead of a floating bar: in the radial wheel '
                'it\'s a play/pause action (speed lives in reader settings); in the classic layout it\'s a '
                'toggle + speed in the settings sheet. While it\'s running, just tap the screen to pause.'),
            _ChangelogItem('Reader: new image colour & contrast controls (every layout) - Sepia, Contrast '
                'and Saturation sliders join Warm/Brightness under "Eye comfort" (tap the reader → settings '
                'or radial). Plus one-tap presets: Paper, Night (blue-light), Vivid and Reset. It\'s all a '
                'single GPU colour filter, so there\'s no performance cost.'),
            _ChangelogItem('Reader: hands-free AUTO-SCROLL for webtoon / continuous mode. Tap the screen to '
                'show the controls, hit play on the new scroll pill, and the page scrolls itself at your '
                'pace - use − / + to set the speed (it\'s remembered). It keeps going across chapter breaks, '
                'keeps the screen awake while running, and pauses when you background the app or reach the '
                'end. Paged modes are unaffected.'),
            _ChangelogItem('Reader: fixed the reader saving your position far too aggressively while reading, '
                'which could make the app lag or even crash on long sessions. Progress now saves at most a '
                'few times a second (and exactly when you leave or background the app) instead of on every '
                'single page turn - lighter on the device, and your resume point is still accurate.'),
            _ChangelogItem('Reader: fixed continuous / webtoon scrolling going laggy - the new precise '
                'long-page resume was saving your position to disk far too often while you scrolled. It now '
                'keeps it in memory and only writes on exit or when the app backgrounds, so scrolling is '
                'smooth again (resume accuracy is unchanged).'),
            _ChangelogItem('Reader: in continuous / webtoon mode, Continue now remembers your exact spot '
                'WITHIN a page, not just which page - so stopping halfway down a long webtoon strip and '
                'coming back drops you right back at that point once the page loads (saved per chapter).'),
            _ChangelogItem('Reader: smarter preloading - the reader now watches how fast you\'re reading and '
                'warms up more pages ahead (and fetches the next chapter sooner) when you\'re moving quickly, '
                'so fast readers stop hitting the "loading" pause mid-flip or at a chapter break; slower '
                'readers load less and save data. Applies to both paged and continuous/webtoon modes.'),
            _ChangelogItem('Reader: the chapter-break divider in continuous / webtoon mode got a cleaner look '
                ' - it blends into your reader background now (no more out-of-place dark bar on white / OLED / '
                'custom themes) with a tidy "Finished / Up next" layout and an accent marker.'),
            _ChangelogItem('Reader: your place is now saved per chapter, not just one bookmark for the whole '
                'title. Open any chapter from the list and it resumes exactly where you left off inside it '
                '(already-finished chapters start fresh from the top). And reading straight through chapter '
                'breaks - the seamless continuous / webtoon flow - now marks each chapter you pass as read, '
                'like finishing pages in a book, instead of only the last one.'),
            _ChangelogItem('Reader: each manga now remembers its own reading mode (LTR / RTL / Vertical / '
                'Webtoon). Set a webtoon to Webtoon and a manga to right-to-left, and each one reopens the '
                'way you left it; brand-new titles still start in your default mode from Settings → Reader.'),
            _ChangelogItem('Reader (two-page / landscape): reworked how spreads are paired so they actually '
                'line up. The first page of each chapter is now shown on its own by default - like a book '
                'cover - so the facing pages after it pair as real two-page spreads instead of landing split '
                'down the middle. Wide double-spread scans and over-tall (webtoon-style) pages always get '
                'their own page now instead of being squeezed into half the screen, and spreads no longer '
                'jump around as pages finish loading. If a particular manga\'s spreads still sit the wrong '
                'way, flip the new "Shift double pages" switch in the reader settings (and the radial menu) '
                'to nudge the pairing by one - it\'s remembered per manga.'),
            _ChangelogItem('Reader: in continuous / webtoon mode, landscape no longer blows every page up to '
                'fill the wide screen - the strip is now capped to a comfortable reading width and centred. '
                'That also keeps it clear of the notch / Dynamic Island and home indicator, which sit on the '
                'long edges when the phone is sideways. Portrait is unchanged.'),
            _ChangelogItem('About page: the icon tiles now use the same outlined style as the rest of Settings '
                'on the pure-black (OLED) theme, instead of solid-filled squares.'),
            _ChangelogItem('Reader: zoom now works in EVERY layout - including continuous/webtoon, which had '
                'none before. Double-tap to zoom in on the exact spot you tapped (double-tap again to reset), '
                'or pinch with two fingers for fine control. Panning only kicks in while zoomed, so normal '
                'page-turns and scrolling are unchanged at 1×.'),
            _ChangelogItem('Reader: reworked how the reader tracks chapters under the hood - every page now '
                'carries its own chapter, so the page slider, the chapter title, Resume and mark-as-read stay '
                'correct across chapter boundaries no matter how chapters preload. Groundwork for a batch of '
                'reader improvements; reading works exactly as before.'),
            _ChangelogItem('Reader: fixed Resume landing in the wrong place - it could jump a few pages too '
                'far, or even open the next chapter, when continuing (especially in continuous mode). Your '
                'spot now saves against the exact chapter and page you\'re on, so Resume returns you right '
                'where you left off.'),
            _ChangelogItem('Reader: the radial menu\'s settings now include the Radial on/off switch, so you '
                'can flip back to the classic controls from inside the radial itself (it was only in the '
                'classic settings sheet before).'),
            _ChangelogItem('Stats: the content-type selector (All / Manga / Anime / Novels) is now a rounded '
                'pill to match the toggles elsewhere in the app.'),
            _ChangelogItem('iOS: much smaller app download - the embedded Kotlin-extension engine shed '
                '~90 MB of unused server/desktop code (a bundled JavaScript engine, fonts, database and web '
                'server the on-device runner never touches). No change to what works. (Android was slimmed '
                'in an earlier update.)'),
            _ChangelogItem('Internal: removed another batch of dead translation strings left behind by '
                'earlier screen redesigns (keeping the ones whose features are still around, to translate '
                'as coverage grows).'),
            _ChangelogItem('Settings consistency: every Settings page now shares one set of row styles '
                '(section headers, switches, choice and navigation rows) instead of its own near-copies, so '
                'they all look identical. Tidied ~700 lines of duplicated code behind the scenes; no change '
                'to what any setting does.'),
            _ChangelogItem('Fixed the update-count badges on the Manga / Anime / Novels switch - they used '
                'to clip the pill edge and clash in colour; they\'re now clean inline chips. And the Browse '
                'count on the bottom bar gets an outline so it no longer blends into the icon.'),
            _ChangelogItem('Internal cleanup from the RepoForge removal (leftover translation strings and an '
                'unused import).'),
            _ChangelogItem('Retired the in-app RepoForge source builder (and the Source Creator) to '
                'streamline the app - that work is moving to a dedicated standalone tool. Adding, '
                'subscribing to and installing extension repositories is completely unchanged.'),
            _ChangelogItem('Much smaller download: the bundled native libraries are now compressed inside '
                'the APK (they were shipping uncompressed), cutting the Android download roughly in half with '
                'no features removed. First launch is a touch slower while they unpack once.'),
            _ChangelogItem('Trimmed a couple of unused packages from the build.'),
            _ChangelogItem('Stats now count only what you ACTUALLY read/watched in the app - reaching the '
                'end of a chapter, episode or novel chapter. Marking things read (including bulk "mark all") '
                'no longer inflates your chapters-read, milestones, personality, streak or activity heatmap. '
                '(Your library progress and unread badges are unchanged - those still track everything you '
                'mark read.)'),
            _ChangelogItem('Stats: total time read/watched now reflects only genuinely-tracked reading time '
                ' - the old rough per-chapter estimate for titles you only marked read has been removed.'),
            _ChangelogItem('Reader: polished the normal (non-radial) controls to match the rest of the app '
                ' - cleaner translation / provider pills, consistent text, and a subtle outline on the HUD '
                'buttons. The dark gradient and over-page legibility are kept.'),
            _ChangelogItem('Reader: opening the settings menu now tucks the reading controls away so the '
                'page slider no longer sits awkwardly behind the sheet - they fade back in when you close it.'),
            _ChangelogItem('Library: new "Continue reading" setting (Settings → Library) - keep the Continue '
                'banner at the top (default), swap the + button for a Resume button in the easier-to-reach '
                'bottom-right corner, or turn it off entirely.'),
            _ChangelogItem('Finished the app-wide consistency pass - Browse, RepoForge, Tracking, Source '
                'Creator, Global Search, Updates, Insights and the Tutorial now use the shared design '
                'system too. The whole app is consistent now.'),
            _ChangelogItem('Reader & player: the in-reader menus, sheets and dialogs now use the shared '
                'design system too - the reading surface, the HUD and your reader theme are untouched.'),
            _ChangelogItem('Library: redesigned the grid - each entry is now a defined card (a surface '
                'with a hairline border and rounded cover) instead of a bare floating cover, so it reads '
                'clearly on any background including OLED. Badges are unified to one consistent size, and '
                'all cards match in height.'),
            _ChangelogItem('Reader: the back button is always visible now - when the controls hide it '
                'collapses to a back-arrow circle instead of disappearing.'),
            _ChangelogItem('Reader: tapping the in-reader settings panel no longer closes it by accident '
                'near its edges - only tapping outside the panel, or the +/× button, closes it.'),
            _ChangelogItem('Details: the Remove / Tracking / WebView buttons keep a hairline outline in '
                'OLED so they stay visible instead of blending into the black.'),
            _ChangelogItem('The in-reader radial menu now follows your selected theme and OLED - its '
                'panel, pill, option bubbles and controls use your accent colour and flip light / dark / '
                'pure-black with the app, instead of being a fixed dark overlay. (The reading surface and '
                'your reader theme stay exactly as you set them.)'),
            _ChangelogItem('The Details page (title info, chapters/episodes, and the source-migration '
                'screens) now uses the shared design system too - consistent typography throughout.'),
            _ChangelogItem('The Library screen - the grid, the display/filter options, and the stats tab '
                ' - now uses the shared design system: consistent typography and theme-aware colours.'),
            _ChangelogItem('Appearance: Pure black (OLED) is a dark-mode option, so its toggle is now '
                'disabled in light mode instead of still reading as "on" - your setting is remembered for '
                'when you switch back to dark.'),
            _ChangelogItem('OLED: the outlined icon-chip style now applies across every Settings page '
                '(Reader, Library, Downloads, Security, Vault and the rest), so they all match.'),
            _ChangelogItem('OLED: the icon chips on the Settings and Appearance pages now show a coloured '
                'outline + icon on black instead of a filled tint, matching the pure-black look (dark and '
                'light themes are unchanged).'),
            _ChangelogItem('OLED fix: settings tiles, chips and input fields are now fully black instead '
                'of a slightly-lit grey - their hairline borders keep everything cleanly separated.'),
            _ChangelogItem('The entire Settings section now uses the shared design system - consistent '
                'typography, spacing, and theme-aware colours across every settings page.'),
            _ChangelogItem('OLED dark mode is now pure black across the whole app - app bars, cards, sheets '
                'and dialogs - with subtle outlines so everything stays easy to tell apart.'),
            _ChangelogItem('Started an app-wide visual consistency pass. The main Settings screen is the '
                'first to move onto a new shared design system - cleaner tiles, consistent spacing, and '
                'icon colours that adapt to the theme. More screens to follow.'),
            _ChangelogItem('In-reader settings: tapping the purple panel no longer closes it by accident, '
                'the eye-comfort sliders are smooth instead of jittery, and the slider / title tucks into '
                'and out of the button together with the tail.'),
            _ChangelogItem('Swipe from the left edge to go back on the Details and Settings pages, like '
                'the rest of the app.'),
            _ChangelogItem('Reader: the page slider / progress bar now fades in and out with the rest of '
                'the options instead of popping; the light-novel reader no longer leaves a little bubble '
                'in the corner while reading.'),
            _ChangelogItem('Details page: the back button now stays visible over bright cover art, and the '
                'title fades up into the top bar once you scroll past it.'),
            _ChangelogItem('Reader back button stays visible on any page now - a more solid pill with a '
                'shadow and a shadowed arrow, so bright or dark pages no longer hide it.'),
            _ChangelogItem('Light-novel reader: ‹ › chapter buttons are back on the progress bar for '
                'one-tap next/previous chapter (they dim at the first/last chapter).'),
            _ChangelogItem('Reader options now sit in a dark window framed by the purple tail, with more '
                'breathing room so the controls no longer hug the edges.'),
            _ChangelogItem('Reader options now slide closed - the panel animates back down into the tail '
                'instead of snapping shut.'),
            _ChangelogItem('Manga: fixed the page slider briefly showing the last page for a moment when '
                'opening a new chapter.'),
            _ChangelogItem('Reader options now grow up out of the tail as one accent panel that stays '
                'gooey-fused to the button (instead of a separate floating card).'),
            _ChangelogItem('Fixed a crash when opening some light-novel chapters (progress was read '
                'before the page had finished measuring).'),
            _ChangelogItem('Light-novel reader bar is now just a draggable reading-progress slider - the '
                'title and chapter already show in the top-left.'),
            _ChangelogItem('Fixed a blank grey panel that briefly covered the light-novel reader when '
                'opening a chapter (a background web request was rendering full-screen on iOS).'),
            _ChangelogItem('The details page now remembers your chapter order (oldest/newest and sort) '
                'between opens.'),
            _ChangelogItem('New radial reader menu - light novels now use the same in-reader control as '
                'manga. Tap the page to reveal it, tap the round button to fan the options, then tap one '
                'and the fused tail grows upward (still attached to the button) to reveal that setting - '
                'text size, font, theme, alignment, spacing, Listen - above the base: the page slider on '
                'manga, the title/chapter + progress on novels. Everything that doesn’t fit scrolls.'),
            _ChangelogItem('Light-novel reader: tapping the text now reveals the bars too (not only the '
                'margins), and the side scrollbar has been removed for a cleaner page.'),
            _ChangelogItem('Details page: the cover now fades smoothly into the page as you scroll up, '
                'instead of cutting off abruptly.'),
            _ChangelogItem('Downloads keep going when you leave the app: an in-progress download '
                'continues for a bit after you background it, and anything left is resumed '
                'automatically the next time you open the app. (iOS can’t download with the app fully '
                'closed, so it picks back up when you return.)'),
            _ChangelogItem('The details page cover now fades smoothly into the background instead of '
                'ending on a hard edge.'),
            _ChangelogItem('Anime downloads now keep their subtitle and audio tracks, so a downloaded '
                'episode has the same subtitle and audio options as streaming - subbed anime works '
                'offline.'),
            _ChangelogItem('Anime sources that stream via MPEG-DASH (e.g. AnimeOnsen) can now be '
                'downloaded for offline watching (video + audio).'),
            _ChangelogItem('“Save as PDF” no longer freezes the app - the conversion now runs in the '
                'background while you keep using the app.'),
            _ChangelogItem('The light-novel reader’s side scrollbar no longer jumps around when you drag '
                'it.'),
            _ChangelogItem('Downloaded files are now organised into readable folders - Manga, Anime and '
                'Light Novels, then each title (with its source ID appended so same-named titles stay '
                'separate), then the chapters/episodes - instead of the old random number folders. Your '
                'existing downloads are moved into the new layout automatically on first launch.'),
            _ChangelogItem('Anime downloads now play. Downloaded episodes that got stuck at 00:00 or '
                '“couldn’t recognize the file” now download and play correctly - encrypted streams are '
                'handled properly - and a download that fails no longer leaves a broken file behind for '
                'you to tap on. (Streaming was unaffected.)'),
            _ChangelogItem('Deleting a download now works everywhere. Anime episodes delete from inside '
                'the app (no more having to remove them in Files), and deleting a chapter you saved as '
                'CBZ or PDF also clears the leftover extracted-images folder it used to leave behind.'),
            _ChangelogItem('Fixed the light-novel reader showing a blank grey screen when you opened a '
                'chapter.'),
            _ChangelogItem('“Save as PDF” now keeps the chapter readable as images when a page can’t be '
                'converted (and records why in Debug logs), instead of quietly leaving the images with '
                'no PDF.'),
            _ChangelogItem('iOS: the app now installs cleanly through SideStore.'),
            _ChangelogItem('Next / Previous chapter now reliably goes to the right chapter on every '
                'source. Readers now follow the source’s real chapter order, so no more jumping to a '
                'far-off chapter or stepping backwards - this fixes light novels in particular.'),
            _ChangelogItem('Light-novel sources that only loaded about 100 chapters (e.g. Novel Phoenix) '
                'now load the complete chapter list, even for novels with thousands of chapters. A '
                'chapter page that errors mid-load no longer throws the whole list away.'),
            _ChangelogItem('The light-novel reader has been redesigned to match the rest of the app: '
                'tap the page to hide or reveal the bars, the novel and chapter name show at the top, all '
                'the text options (size, font, theme, spacing, listen) are tucked into one button, and '
                'the bottom bar has Previous / Next plus a chapter progress bar. A draggable side '
                'scrollbar makes moving through long chapters easier.'),
            _ChangelogItem('Stats has three new sections: Backlog (titles you added but never started, '
                'oldest first), Milestones (collectible badges for chapters read, hours, streaks, '
                'formats and more), and Reading personality (your reading archetype from your habits).'),
            _ChangelogItem('Anime and light-novel time is now counted under the right type in Stats '
                'instead of sometimes being lumped in with manga.'),
            _ChangelogItem('New - Reading Insights: see your total time read & watched. The Stats page '
                'now has a tappable “Total time” card that opens a podium of your most-read titles; '
                'switch between All / Manga / Anime / Novels. Time is tracked as you read going forward '
                'and estimated from your reading history to start.'),
            _ChangelogItem('Stats page redesigned to be clearer: a labelled activity heatmap '
                '(brighter = more), tiles for Titles / Completed / Chapters read / Day streak, a '
                'library breakdown by type (or by status), a top-genre line, and “most read” now ranks '
                'by time spent. The unused search bar on the Stats page is gone.'),
            _ChangelogItem('Vault reliability + privacy overhaul: moving a title into a locked vault no '
                'longer silently loses it; a no-password vault no longer stops saving changes after you '
                'background the app; creating categories while locked is prevented; and opening or '
                'reading a vault title now keeps its chapters, progress and stats inside the vault '
                'instead of leaking into the normal library - so your normal and vault stats are fully '
                'separate. (Any reads that previously leaked are moved back into the vault on unlock.)'),
            _ChangelogItem('Light-novel (LNReader) sources now use the same browser-like network path '
                'as the rest of the app, so more of them get through TLS / Cloudflare blocking.'),
            _ChangelogItem('Experimental in-reader radial control: the page indicator now morphs into '
                'the action button and the page slider flows out of it as one shape (enable the radial '
                'reader in reader settings).'),
            _ChangelogItem('More silent failures now show up in More → Debug logs (source loading, '
                'Cloudflare, DNS, light-novel sources), and the “Open random” library shortcut no '
                'longer crashes.'),
            _ChangelogItem('Library covers no longer flash a spinning circle over the grid while they '
                'load (so a background update no longer covers part of your library) - a calm '
                'placeholder tile shows instead until the cover arrives.'),
            _ChangelogItem('Migrate now only searches sources of the same type - a manga looks only on '
                'manga sources, anime only on anime, novels only on novels - so you no longer get '
                'mismatched results or an empty “no manga found”.'),
            _ChangelogItem('Tap a title on the details page to copy it to the clipboard; long-press it to '
                'search it across all your sources.'),
            _ChangelogItem('The Updates tab badge now counts up live as new chapters are found, and '
                'clears the instant you tap “Clear all” instead of lingering until you leave the tab.'),
            _ChangelogItem('Discover: added a Remove button to wishlist entries (you no longer have to '
                'swipe), and fixed the genre options clipping off the edge of the “Genres” pill.'),
            _ChangelogItem('The global-search header was restyled to match the new look - the back button '
                'and search field are now matching rounded cells, with the field highlighting as you type.'),
            _ChangelogItem('Big speed + reliability pass: the library opens and scrolls smoother on '
                'large collections (it no longer re-filters and re-sorts the whole list on every '
                'little change), queueing lots of chapters is quicker, and the stats page opens faster.'),
            _ChangelogItem('Sources are steadier: a stuck source now times out instead of spinning '
                'forever, Cloudflare is solved once per site instead of several times at once, and a '
                'bug that showed duplicate reader pages is fixed.'),
            _ChangelogItem('Migrate now finds a title on other sources even when they spell its name a '
                'little differently (fuzzy matching), instead of coming up empty.'),
            _ChangelogItem('Library cards are now yours to arrange - in the library options → '
                'Display: put the title on the cover, below it, or hide it; place the badges in a bar '
                'under the cover, in the corner, or stacked on the cover bottom; and show reading '
                'progress as a thin line, a mini bar, or a % badge. Local sources get a small folder '
                'badge, and a legend spells out what each badge means.'),
            _ChangelogItem('Library Filter / Sort / Display was restyled to match the rest of the app. '
                'Filters are now tri-state: tap once to show only those, again to hide them, again to '
                'clear. Sort rows show their ↑/↓ direction.'),
            _ChangelogItem('Browse: local sources you built in RepoForge (“My Sources”) now appear in '
                'the Repository filter.'),
            _ChangelogItem('Discover: the genre filter is now a single “Genres” pill that expands in '
                'place when you tap it, instead of a permanent strip of chips.'),
            _ChangelogItem('Reader & novel settings: the font, alignment and gaze-mode pickers now use '
                'the app’s sliding pill control instead of Material chips.'),
            _ChangelogItem('New: a Default category so new titles file themselves automatically '
                '(Settings → Library), and an App-lock “Lock after” timeout so a quick app-switch no '
                'longer forces you to re-authenticate (Settings → Security).'),
            _ChangelogItem('Library stats: “Chapters read” and “Most-read series” now count your '
                'actual read chapters - including ones imported or marked read manually - so they '
                'match the unread badge, streak and heatmap instead of undercounting.'),
            _ChangelogItem('Light-novel (LNReader) sources: fixed a crash when opening some sources, '
                'and every request now goes through the Cloudflare-aware path - so more sources load, '
                'and a blocked one shows an “Open in WebView” button instead of silently showing nothing.'),
            _ChangelogItem('When a source fails it now tells you why - Cloudflare, site unreachable, or '
                '“needs an update” - instead of a blank “nothing found”. Full details stay in Debug logs.'),
            _ChangelogItem('Browse: the Repository filter now matches the Language filter, and the '
                'Manga / Anime / Novel switch is one consistent control (with a sliding highlight) across '
                'Browse, Search and Discover. Pinned sources stay in sync everywhere you pin them.'),
            _ChangelogItem('Chapter list: sort by source order, chapter number or upload date, plus a new '
                '“Downloaded” filter.'),
            _ChangelogItem('Removed two Security toggles that weren’t wired up yet (biometrics, hide '
                'notification content) so nothing looks like it works when it doesn’t.'),
            _ChangelogItem('Library updates: new chapters now show on each title the moment they’re '
                'found instead of only when the whole check finishes; the Updates tab refreshes '
                'when you open it (so a Category Update actually shows up there); the redundant '
                'spinner in the Library header is gone (the progress banner covers it); and the '
                '“skip titles you haven’t started” filter now respects chapters you’ve marked read, '
                'including ones imported from another app, instead of skipping them.'),
            _ChangelogItem('Browse language filter overhaul: the same language is no longer listed '
                'twice when repositories label it differently (e.g. “English” and “EN” now merge), '
                'languages show full names, and the picker is a searchable grid where you can pin '
                'your languages to the top. Filtering by a repository now only shows the languages '
                'that repository actually has.'),
            _ChangelogItem('Light-novel (LNReader) sources: fixed a batch of sources that silently '
                'returned nothing, clearer error messages when a source fails, and a source blocked '
                'by Cloudflare now shows an “Open in WebView” button to solve the challenge (and '
                'retries through the in-app browser) instead of just appearing empty.'),
            _ChangelogItem('Fixed some sources (e.g. Manganato) failing to load with a “no A '
                'record” error when DNS-over-HTTPS was set to a filtering provider like Quad9 or '
                'AdGuard - the app now falls back across Cloudflare and Google so a blocked domain '
                'still resolves. (Switching your DNS provider to Cloudflare in Advanced also fixes it.)'),
            _ChangelogItem('The “Chapter fetch date” library sort now only moves a title when it '
                'actually gets new chapters, not every time the app checks for updates.'),
            _ChangelogItem('Backups no longer include your vault unless you check “Include vault” '
                'when making one - and it asks you to unlock first (Face/Touch ID or password). It '
                'was previously included automatically whenever the vault happened to be unlocked.'),
            _ChangelogItem('Privacy fix: importing a Foxlations backup that includes vault titles '
                'now asks you to unlock so they’re restored straight into the vault - they’re never '
                'put in your public library (and are simply skipped if you don’t unlock).'),
            _ChangelogItem('Restoring a backup now asks to confirm first, so you can cancel if you '
                'picked the wrong file.'),
            _ChangelogItem('After importing a backup you can now organize its categories: keep '
                'them as-is, send a category’s titles into one of your existing categories, or '
                '(after unlocking) into a vault category.'),
            _ChangelogItem('“Open in WebView” is now instant on a cold start for titles you’ve '
                'opened before - the page link is remembered, so it no longer waits for the source '
                'engine to warm up.'),
            _ChangelogItem('Adding a title to the Vault is now much faster - its chapters are saved '
                'in one batch instead of one-by-one, so big titles no longer hang or time out.'),
            _ChangelogItem('Backing out of a global search now stops any sources still working '
                'through a Cloudflare check, instead of leaving them running in the background.'),
            _ChangelogItem('Installing a source while you’re in the Vault now adds it to the Vault '
                'automatically, so it stays in your private space.'),
            _ChangelogItem('The in-app browser now blocks the ad junk: auto-playing videos, pop-up '
                'windows, and redirects that yank you off the page to an ad site - while still '
                'letting you tap around and open pages normally.'),
            _ChangelogItem('The in-app browser now has an “Open in browser” option (⋮ menu) that '
                'hands the current page to your phone’s default browser.'),
            _ChangelogItem('Downloads you already had are now re-detected after reinstalling or '
                'updating the app - your downloaded chapters show as downloaded again without '
                'needing to re-download them.'),
            _ChangelogItem('Downloads now send a single “downloads complete” notification when '
                'the whole queue finishes, instead of one per chapter.'),
            _ChangelogItem('The download menu now says “episodes” instead of “chapters” for '
                'anime.'),
            _ChangelogItem('The Downloads screen is now a live download manager - watch each '
                'chapter download with a progress bar, pause or resume the whole queue, cancel '
                'individual items, change how many download at once, and see what finished this '
                'session. All the download settings moved behind the gear icon at the top.'),
            _ChangelogItem('Fixed “Open in WebView” on a title opening the wrong page (a 404 or '
                'the site homepage). It now opens the item’s real source page - using the '
                'source’s own link - for manga, anime and novels.'),
            _ChangelogItem('Light-novel chapter lists now load in full instead of stopping at the '
                'first 100 chapters.'),
            _ChangelogItem('Updating extensions now shows a spinner so you can tell it’s working - '
                'on “Update all” and on individual installs and updates.'),
            _ChangelogItem('Library updates are now lighter: they just check for the newest '
                'chapters instead of re-scanning every page. The update summary also starts with '
                'its categories collapsed.'),
            _ChangelogItem('Chapters with no release date no longer show a stray “0”.'),
            _ChangelogItem('New (experimental): an offline NEURAL voice for “Listen” - far more '
                'natural than the robotic system voices, and it runs fully on-device after a '
                'one-time download. Turn it on from the reader’s Listen settings (needs '
                'Experimental enabled in Advanced).'),
            _ChangelogItem('The lock-screen “Now Playing” for “Listen” now shows the cover art '
                'and a chapter timeline.'),
            _ChangelogItem('Novel “Listen” improvements: the voice picker now has a search box, '
                'a language filter, and - on iPhone/iPad - a Normal / Enhanced / Premium quality '
                'filter. Tip: download Enhanced/Premium voices in your device’s Spoken-Content '
                'settings and they’ll appear here.'),
            _ChangelogItem('“Listen” now cleans up stylized text before reading - drawn-out '
                'letters, repeated “!!!/???”, and *SFX*/symbol clutter are no longer spelled '
                'out letter by letter.'),
            _ChangelogItem('Changing the “Listen” speed, pitch or voice mid-chapter now resumes '
                'from the current sentence instead of restarting the paragraph - no more '
                'double-reading a line or the highlight drifting out of sync.'),
            _ChangelogItem('Fixed light-novel chapter lists showing in a scrambled order - they '
                'now sort by chapter number reliably (no more toggling first/latest to fix it).'),
            _ChangelogItem('A deeper fix for the iPhone/iPad crash that could hit after the '
                'app had been running a while or came back from the background - the embedded '
                'extension engine no longer aborts when the system sends it a signal.'),
            _ChangelogItem('Fixed the novel “Listen” button: long-press it to change the voice, '
                'speed and pitch (it wasn’t opening before).'),
            _ChangelogItem('“Create compatible backup” now lets you pick the app: Mihon/'
                'Tachiyomi, Aniyomi, Tachimanga, Mangayomi or LNReader - then choose which '
                'content types to include, and the file is built to match that app. Manga, '
                'anime and light novels are kept distinct. Foxlations backups now use a shorter '
                '“.fox” name (older .fxbackup files still restore).'),
            _ChangelogItem('Fixed images not loading on some sources (e.g. Manganato). Pages '
                'now send the correct referer, so the image server stops blocking them.'),
            _ChangelogItem('The library-update summary is now expandable. Each category '
                '(completed / skipped / failed) opens to show every title, so you can retry a '
                'whole group or just one entry.'),
            _ChangelogItem('Fixed the “Downloaded” library filter hiding titles - it now shows '
                'anything with at least one downloaded chapter or episode, across manga, anime '
                'and novels.'),
            _ChangelogItem('Long-press a genre/tag on a title’s page to search that tag across '
                'all your sources, auto-filtered to that content type.'),
            _ChangelogItem('The first-run tutorial is now a visual, illustrated walkthrough. The '
                'in-reader reading-mode settings now scroll so every option is reachable.'),
            _ChangelogItem('Turning DNS-over-HTTPS off now takes effect right away everywhere, '
                'and fewer crashes when reopening the app from the background (iPhone/iPad).'),
            _ChangelogItem('Global search can now be scoped by type. New All / Manga / Anime / '
                'Novels chips under the search bar let you search every source (default) or '
                'narrow it to just one kind of content.'),
            _ChangelogItem('New: a quick tutorial for first-time users, and a “Help & Tips” '
                'page in Settings to replay it any time. Plus a Foxlations Discord - find it '
                'in About or Help & Tips (and come say hi!).'),
            _ChangelogItem('Library updates now show live progress. A drop-down banner on the '
                'Library screen shows “Updating (title) X/X” as it runs, then a summary - '
                '“X completed, X skipped, X failed”. There’s also a matching notification so '
                'you can watch progress from outside the app, ending with “Update complete”.'),
            _ChangelogItem('Tap the finished-update banner to open a menu: Retry the failed '
                'titles, or force-update the skipped ones (ongoing & hiatus only - completed '
                'series are left alone since they won’t get new chapters), even if your skip '
                'rules would normally skip them.'),
            _ChangelogItem('Manga reader fixes from your feedback: the chapter title up top '
                'now updates as you move between chapters (next/prev, scrolling or flipping); '
                'the reader can now rotate to landscape so Double Pages actually works; and '
                '“Eye comfort” (warm filter + brightness) is now adjustable right inside the '
                'reader’s settings (⚙), not just the main Reader settings.'),
            _ChangelogItem('Skip Intro/Outro (AniSkip) now shows a live countdown of the skip '
                'window and disappears the moment you press it or once the window passes.'),
            _ChangelogItem('Novel “Listen”: long-press the headphones button to change voice, '
                'speed and pitch without starting playback, and it now resumes from where you '
                'left off instead of the top.'),
            _ChangelogItem('DNS-over-HTTPS: fixed “no A record” errors on some providers '
                '(Google now uses the right endpoint; the others fall back to Cloudflare so a '
                'lookup never fails). Cleaner progress bar on “Refresh library covers”.'),
            _ChangelogItem('DNS-over-HTTPS (Advanced → DNS-over-HTTPS). Encrypts your DNS '
                'lookups for privacy and to get around ISP-level domain blocking. Pick '
                'Cloudflare, Google, Quad9 or AdGuard - or add your own custom DoH servers '
                '(they show up in the picker and can be deleted). Applies to image loading, '
                'downloads, and both the built-in and Kotlin extension sources. Off by '
                'default, and it falls back to normal DNS if a lookup fails so it can’t break '
                'your connection.'),
            _ChangelogItem('Cloudflare solve screen improvements (iPhone/iPad). The manual '
                '“Open in WebView” screen now sets the iOS-specific cookie option the Turnstile '
                'challenge needs, skips the ad-blocker while solving, and surfaces any load '
                'error (in the debug logs + on screen) instead of a silent white page. The '
                'automatic bypass also now uses a proper browser identity so it fails less '
                'often.'),
            _ChangelogItem('New: “Refresh library covers” (Library settings → Data). Re-fetches '
                'every library item’s cover art from its source and reloads it - handy when a '
                'site changes its artwork. Shows progress and can be stopped; your own '
                'set-as-cover images are left untouched.'),
            _ChangelogItem('Fixed downloaded chapters saved as CBZ/PDF not reading offline. '
                'Chapters you downloaded with “Save as CBZ/PDF” are now recognized as '
                'downloaded and open straight from the saved file (no re-downloading from the '
                'internet).'),
            _ChangelogItem('Fewer crashes when reopening the app from the background (iPhone/'
                'iPad). The app now holds onto its own crash-signal handlers for the whole '
                'time it’s backgrounded - not just once it’s back on screen - so a stray '
                'system signal during wake-up no longer trips the extension engine, and '
                'dropped network sockets no longer take the app down on resume.'),
            _ChangelogItem('Novel “Listen” now plays in the background with lock-screen '
                'controls. Reading keeps going when you lock the screen or switch apps, and '
                'the lock screen / notification shows the chapter with play, pause, stop and '
                'next/previous-chapter buttons (also works with headset and Bluetooth '
                'controls).'),
            _ChangelogItem('iPhone/iPad: adding a local-source folder now works. Pick any '
                'folder (On My iPhone, iCloud Drive, etc.) in Browse → Local and Foxlations '
                'keeps access to it across launches - so your own manga folders stay readable '
                'and visible in the Files app, instead of the old “folders aren’t supported on '
                'iOS” message.'),
            _ChangelogItem('Richer “Listen” (text-to-speech) for novels. The voice now '
                'highlights the exact sentence being read (not just the paragraph), and a new '
                'tune button in the Listen bar adds a Pitch slider alongside Speed - both '
                'saved between sessions.'),
            _ChangelogItem('Light novels can now be downloaded for offline reading. Use the '
                'download button on a novel chapter (or the bulk “Download” menu) and the '
                'chapter’s text is saved to your device - the reader then opens it instantly '
                'with no network, and “Download ahead while reading” works for novels too.'),
            _ChangelogItem('Double-page reading. Turn your phone sideways and the manga '
                'reader can now show two pages at once, like an open book - enable “Double '
                'pages” in Reader settings (page-by-page modes only). There’s also an optional '
                '“Split wide pages” so a full double-spread gets its own screen instead of '
                'being squished next to another page.'),
            _ChangelogItem('RepoForge no longer loses your work. The “Create source” editor '
                'now warns before you back out with unsaved changes, so a half-built source '
                'definition isn’t thrown away by an accidental swipe or Back press.'),
            _ChangelogItem('Smarter library updates (fewer wasted checks = less chance of '
                'getting rate-limited). New restrictions in Library settings: skip titles you '
                'still have unread chapters on, and skip completed series. These cut down how '
                'often sources are hit during an update.'),
            _ChangelogItem('Skip Intro / Skip Outro for anime (AniSkip). For anime linked to '
                'MyAnimeList, the player now pulls real opening/ending times from the AniSkip '
                'community database and shows a skip button (or auto-skips, per your player '
                'settings) - works on basically any tracked anime, not just the rare source '
                'that ships its own timestamps.'),
            _ChangelogItem('Download-ahead now downloads more than one chapter. “Download '
                'ahead while reading” has a new “Chapters ahead” option (1/2/3/5/10), so your '
                'next several chapters are ready before you get to them.'),
            _ChangelogItem('Light-novel reader customization. A new text-settings button (the '
                'sliders icon) lets you pick the font (Serif / Sans / Mono), text alignment '
                '(Left / Justify / Center), line spacing, and page margins - all saved.'),
            _ChangelogItem('Easier-on-the-eyes reading. The manga reader has a new “Eye '
                'comfort” section in reader settings - a Warm filter (reduces blue light) and '
                'a Brightness dim that can go darker than your phone’s minimum, for reading in '
                'the dark. The light-novel reader now has reader themes too (Sepia, Warm, '
                'Gray, Black/OLED) via the palette button up top.'),
            _ChangelogItem('Fixed chapter/episode navigation going BACKWARDS. “Next chapter” '
                '(and auto-advance, and next-episode autoplay) was jumping to the older '
                'chapter instead of the newer one, and opening the first chapter left “Next” '
                'greyed out so you were stuck. Now Next goes forward, Previous goes back, and '
                'the chapter/episode name in the header updates correctly.'),
            _ChangelogItem('More failures now surface in the debug logs: a scheduled backup '
                'that fails, and a source’s categories failing to load - no more silent '
                'failures there.'),
            _ChangelogItem('Removing a title from your library now shows a quick “Removed - '
                'Undo”, so an accidental tap on the heart is easy to take back (and it '
                'restores your read progress). Also, more background failures - tracker '
                'syncs and episode downloads - now show up in the debug logs instead of '
                'failing silently.'),
            _ChangelogItem('Under-the-hood cleanup - removed a batch of old unused code and a '
                'stray asset, and tidied up some warnings. No behaviour change; just a leaner, '
                'tidier app.'),
            _ChangelogItem('A few smaller fixes: newly-added or just-restored titles no longer '
                'flood the Updates screen with their whole back catalogue on the first update '
                'check; imported “finished” series from a Mihon/Tachiyomi backup now show as '
                'Completed (not Ongoing); and episode downloads now pick the highest-quality '
                'video reliably.'),
            _ChangelogItem('Anime and light novels now track progress properly. Finishing an '
                'episode or a novel chapter now marks it watched/read, counts down the unread '
                'badge, and updates your linked trackers (MAL/AniList/Kitsu) - previously only '
                'manga did this. And downloaded episodes finally play from the device offline '
                'instead of always streaming from the network.'),
            _ChangelogItem('Fixed two ways reading progress could vanish. Setting or changing '
                'your vault password no longer wipes the read progress and chapter lists of '
                'vaulted titles, and “Mark all unread” no longer blanks out the chapter list '
                '(it just marks them unread now).'),
            _ChangelogItem('Migrate-a-source now works for the vault and shows all the right '
                'sources. It was only ever looking at your normal library - so in the vault it '
                'showed the wrong (often empty) list and couldn’t migrate vaulted titles. It '
                'now uses whichever library you’re in, won’t offer vaulted sources as targets '
                'outside the vault, explains an empty list, and refreshes as sources load. '
                'Migrating a vaulted title now keeps its read progress, and chapter-number '
                'matching is smarter (no more grabbing a volume or year).'),
            _ChangelogItem('Novel reader fixes. Your font size now sticks instead of resetting '
                'every time you open a chapter, and the novel reader now keeps the screen on '
                'and respects fullscreen like the manga reader does.'),
            _ChangelogItem('Fixed the library “Add” button leaving you stuck. It now switches '
                'to the Browse tab (with the bottom nav bar intact) instead of opening Browse '
                'as a full screen that hid the nav bar.'),
            _ChangelogItem('Clearer message when a source’s site is down or has moved. The '
                'cryptic “Failed to find buildId” error (seen when a site like Flame Comics '
                'goes offline or changes) now explains what’s happening and what to do - '
                'update the source, or remove it if the site is gone.'),
            _ChangelogItem('Fixed covers and pages not loading on some sites (e.g. Manganato/'
                'MangaFire). Their image servers use certificates our image loader was '
                'rejecting even though downloading the same images already worked - now '
                'viewing works too. Also fixed sources that return a relative cover path, and '
                'the in-reader AI translation now reuses the already-loaded page instead of '
                're-fetching it.'),
            _ChangelogItem('Image failures now show up in the logs, and Retry actually '
                'retries. When a cover or page won’t load, the reason (e.g. “blocked by the '
                'server (403)”, a timeout, or an HTTP error) now appears in More → Debug logs '
                'instead of failing silently. And tapping Retry now genuinely re-requests - '
                'including after you solve a Cloudflare check - instead of doing nothing once '
                'a site had been skipped. Failed downloads are logged too.'),
            _ChangelogItem('Faster cold start. The app now does its independent startup work '
                'in parallel and opens the library faster, and it waits until after the first '
                'screen is up to set up things that aren’t needed to get going (the Cloudflare '
                'helper, crash-report check and notification channels).'),
            _ChangelogItem('The library itself is smoother now, especially when it’s big. '
                'Opening, switching categories/types, scrolling and even typing in search '
                'did a lot of redundant work every frame - the entry list, counts and '
                '“Continue reading” are now computed the light way, the entrance animation '
                'only runs for the first screenful instead of every title, and downloading in '
                'the background no longer re-filters the whole library several times a second. '
                'Covers also pre-load just before they scroll into view.'),
            _ChangelogItem('Speed pass - downloads, library and images are all faster. '
                'Chapter pages now download several at a time instead of one-by-one (much '
                'faster chapters). Library lookups that ran on every page turn, every cover '
                'and every badge were rebuilding far too much - those are now direct/cached, '
                'so a big library scrolls smoother and reading no longer rebuilds the library '
                'behind you. Covers now decode at the size they’re shown (big memory + scroll '
                'win) and duplicate image requests are merged. Also fixed a storage leak where '
                'a removed title left its chapters behind forever.'),
            _ChangelogItem('Library updates are faster and show progress. The check no '
                'longer rebuilds the whole grid after every single title (which made a big '
                'library crawl), and the refresh spinner now shows a live “checked / total” '
                'count. On Android it also checks several titles at once.'),
            _ChangelogItem('Fixed covers “duping” onto the wrong titles. In a big library - '
                'especially mid-update - a cover could show up on a neighbouring title '
                'because the grid reused a cell’s image. Cards are now tied to their title so '
                'that can’t happen.'),
            _ChangelogItem('Import your library from Mangayomi. The “Import from another '
                'app” option now accepts Mangayomi backups (.backup) - manga, anime and '
                'light novels in one file - matching each title to your installed sources by '
                'name (anything not yet installed re-links once you add the source). The '
                'import section also now lists everything it accepts: Mihon/Tachiyomi & '
                'forks, Aniyomi, Tachimanga and Mangayomi.'),
            _ChangelogItem('Tachimanga backups now keep their sources. Tachimanga’s '
                '“Mihon-compatible” export stores each source’s name and ID in the opposite '
                'order from Mihon, so every title came in with no source and matched nothing. '
                'Imports now read either order - a 1,000-title Tachimanga backup that detected '
                'zero sources now links the vast majority to your installed ones.'),
            _ChangelogItem('Restored titles now re-link to their source permanently - '
                'automatically. When you install a source (or on the next launch, or right '
                'after a restore), any entries that were stuck pointing at the source’s name '
                'are rewritten to the real source, so they not only open but also group and '
                'show unread counts correctly. No manual migrating needed.'),
            _ChangelogItem('Restored titles whose source you’ve since installed now open. '
                'When a Tachiyomi/Mihon backup was restored before its source was installed, '
                'the entry got stuck pointing at the source’s name rather than its real ID - '
                'so even after installing the source, the title still said “source not '
                'installed”. Those entries now re-link to the installed source by name and '
                'open normally.'),
            _ChangelogItem('No more dead-end when a chapter’s source isn’t installed. '
                'Opening a title whose source is missing (common right after restoring a '
                'backup) used to drop you on a blank “Source not installed” screen with no '
                'way back - it now has a back button and tells you to install the source '
                'from Extensions.'),
            _ChangelogItem('The title page now shows which source it’s from. Handy after a '
                'restore for spotting which extension you still need to install.'),
            _ChangelogItem('Installed sources show their repo again (e.g. Keiyoushi) instead '
                'of “custom”. The repo a source came from wasn’t being saved, so after a '
                'restart the Sources list fell back to the generic framework label - it’s '
                'now stored (and recovered from the repo URL for sources installed earlier).'),
            _ChangelogItem('Extension updates now show which type they’re under. The '
                'Manga / Anime / Novels toggle on the Extensions page now carries a small '
                'count badge on the type that has updates - so when the bottom bar shows an '
                'update, you can see at a glance whether it’s a manga, anime, or light-novel '
                'source instead of only finding it under the first tab.'),
            _ChangelogItem('Big libraries and bulk moves are much faster. Moving titles in or '
                'out of the vault, and the library’s multi-select actions (mark read/unread, '
                'remove, move category), now update the whole batch in one pass instead of '
                'redrawing after every single title - so large selections no longer crawl. '
                'A big library also scrolls more smoothly: the unread badges are now counted '
                'once and cached instead of recomputed for every cover on every frame. '
                'Migrating with a long read-history is faster too.'),
            _ChangelogItem('Fixed the vault “move a category” picker not scrolling - if you '
                'have a lot of categories, the list now scrolls.'),
            _ChangelogItem('Unlock the vault with biometrics. Turn on Face ID / fingerprint '
                'in Vault settings (confirm your password once) and it’ll offer biometrics on '
                'unlock.'),
            _ChangelogItem('Decoy password. Set a second password that opens a separate, '
                'isolated vault - hand over your phone without revealing your real content. '
                'Your real vault stays encrypted and untouched.'),
            _ChangelogItem('Backups now include your vault. When the vault is unlocked, its '
                'titles are saved into backups (native and Tachiyomi/Mihon) as normal entries '
                'under “Vault-…” categories - so they’re not lost and stay portable.'),
            _ChangelogItem('Panic exit for the vault. Turn on “Shake to exit” in Vault '
                'settings and, while you’re in the vault, a quick shake drops you straight '
                'back to your normal library.'),
            _ChangelogItem('More vault moving options. Moving a whole category now lets you '
                'pick which category it lands in on the other side. And you can turn on '
                '“Move-to-vault in library” (Vault settings) to move selected titles straight '
                'into (or out of) the vault from the library’s selection menu.'),
            _ChangelogItem('Vault move screen, revamped. A To Vault / From Vault toggle '
                'switches direction, and you can move titles one at a time, multi-select '
                '(long-press), move all at once, or move a whole category in or out - with '
                'a search box and Undo.'),
            _ChangelogItem('The anime Categories tab works now. Open an anime source’s '
                'Categories tab, tap a genre (Action, Comedy, …) and you’ll browse only that '
                'category - built from the source’s own genre filters.'),
            _ChangelogItem('Titles without a cover look right now. Some sources (e.g. certain '
                'anime sources like AniHQ) don’t include cover art in their listing - those '
                'now show a neutral placeholder instead of a “Retry” button on every title. '
                'The cover still loads on the title’s page.'),
            _ChangelogItem('The repo options menu now shows Discord/website when a repo '
                'lists them (Keiyoushi’s Discord was being dropped before it reached the '
                'menu). Give the repo a moment to refresh, or tap Reinstall sources.'),
            _ChangelogItem('Fixed the blank “Solve Cloudflare” screen. The in-app browser '
                'opened the site fine but the Cloudflare challenge itself came up white - it '
                'was missing a real browser identity and page storage the challenge needs. '
                'It now loads properly so you can complete the check.'),
            _ChangelogItem('Tap a repository for options. In Extension Repositories, tapping '
                'a repo now opens a menu: reinstall its sources, copy the repo URL, open its '
                'GitHub page, open its Discord (if it lists one), or delete it.'),
            _ChangelogItem('Anime sources you already installed now repair themselves. '
                'Anime added before the last update kept showing “Failed to load / '
                'VerifyError” because the old converted copy was cached - they now re-fix on '
                'first open automatically, no reinstall or repo refresh needed.'),
            _ChangelogItem('Fixed reader controls vanishing the instant you tapped (webtoon '
                'mode). Revealing the controls triggered a layout refresh that the reader '
                'mistook for a scroll and hid them again a frame later - now only a real '
                'scroll hides them, so a tap brings them up and they stay.'),
            _ChangelogItem('Anime extensions really load on iOS now. The previous attempt '
                'didn’t take on the embedded engine (it ignores the verification switch); '
                'this regenerates the extension bytecode after conversion so the sources load '
                'properly - no more “Failed to load / VerifyError”.'),
            _ChangelogItem('Reader controls now get out of your way. While you read, a '
                'tap or scroll hides everything - including the radial wheel and the back '
                'button - and a tap anywhere brings the controls back (that “tap doesn’t '
                'bring the menu back” bug is fixed, in both the classic and radial layouts).'),
            _ChangelogItem('Sources now tell you what’s wrong. When a source fails, the '
                'error screen shows its real message - “log in”, “open in WebView”, “not '
                'available in your region”, and so on - instead of a generic error, so you '
                'know what to do. Global search shows the reason per source too. (Full '
                'technical detail still goes to More → Debug logs.)'),
            _ChangelogItem('Anime extensions now load on iOS. Aniyomi-style anime sources '
                'were failing to load on the embedded engine; most now work. (A few still '
                'need more work - see the notes - so report any that misbehave.)'),
            _ChangelogItem('Fixed two source errors. Some sources (e.g. Mangageko) '
                'failed to open a title with an "uninitialized title" error; and after '
                'the app had been in the background, Cloudflare-protected sources '
                '(e.g. Manganato) could stop loading until a restart. Both are fixed, '
                'and the Cloudflare helper now re-arms itself and logs to More → Debug '
                'logs if it ever can’t start.'),
            _ChangelogItem('Swiping between library categories now turns like a 3D '
                'cube - the category you leave rotates away as the next one turns in.'),
            _ChangelogItem('Hands-free scrolling (beta): more accurate eye tracking. '
                'It now projects where your eyes are aimed onto the screen for a '
                'better-aligned gaze, with a Raw/Geometric switch in Gaze Lab. '
                'Re-run calibration after updating.'),
            _ChangelogItem('Hands-free scrolling (beta) holds steadier when you move '
                'the phone: it now uses the phone’s motion sensors so tilting or '
                'shifting the device no longer counts as a head tilt. Re-run gaze '
                'calibration once after updating.'),
            _ChangelogItem('Global search, rebuilt. Searching across sources now shows '
                'every source as its own row with its own state - results, "no results", '
                'or a failure you can retry per-source - and matching is fuzzier, so '
                'near-miss titles still turn up. Long-press a title on its detail page to '
                'search it everywhere.'),
            _ChangelogItem('Long-press a page in the reader for a quick menu: Share, Save '
                'the image, Set it as the cover, or Recognize text (OCR) on the page.'),
            _ChangelogItem('Your settings actually stick now. Every setting is saved '
                'the instant you change it, so nothing reverts if you close the app '
                'right after - the fix that was only on the theme now covers them all.'),
            _ChangelogItem('Incognito mode. Settings → Security & Privacy adds a private '
                'mode that pauses reading history and tracker updates for manga, anime '
                'and novels; a badge in the library bar reminds you it is on.'),
            _ChangelogItem('Notifications. Get notified about new chapters after a library '
                'update, and when downloads finish or fail - each with its own toggle in '
                'Settings → Notifications.'),
            _ChangelogItem('App lock. Settings → Security & Privacy can now require your '
                'fingerprint, face, or device passcode to open the app, re-locking '
                'whenever it goes to the background.'),
            _ChangelogItem('Secure screen. A new Security toggle hides the app in the '
                'recent-apps switcher (and blocks screenshots on Android).'),
            _ChangelogItem('More settings that now do something: auto-download new chapters, '
                'open links in your system browser, verbose logging, and extension-update '
                'alerts - all previously just switches that saved but did nothing.'),
            _ChangelogItem('Library display fixes. The "Downloaded" filter no longer hides '
                'your whole library, downloaded titles get a badge, the unread/downloaded '
                'badge toggles work, and categories can show their item counts.'),
            _ChangelogItem('iOS: fixed the crash when reopening the app after it had been '
                'in the background for a while.'),
            _ChangelogItem('A fresh cold-boot animation. Opening the app now shows the '
                'fox logo and then reveals your library with one of a few short '
                'transitions, picked at random each launch - a zoom, a gust of autumn '
                'leaves, a warm glow, or a split down the middle.'),
            _ChangelogItem('Your theme sticks right away. Switching light/dark or '
                'picking a theme is now saved to disk the instant you change it, so it '
                'is remembered even if you close the app immediately afterwards.'),
            _ChangelogItem('The Continue bar speaks anime. When the last thing you '
                'opened is a show, it now reads "Continue Watching" with an episode '
                'count, instead of "Continue Reading" with a chapter count.'),
            _ChangelogItem('Reader controls get out of the way. The bars show for a '
                'moment when you open a chapter, then tuck away as soon as the page '
                'loads. Tap once to bring them back; tap again - or start scrolling - '
                'to hide them.'),
            _ChangelogItem('Listen to light novels. The novel reader can now read a '
                'chapter aloud - tap the headphones icon, with play/pause and a speed '
                'control, and the current paragraph highlights and scrolls into view. '
                'It rolls on into the next chapter so you can keep listening '
                'hands-free.'),
            _ChangelogItem('Pick a voice for Listen. The novel reader\'s read-aloud '
                'now has a voice picker - choose any of the voices installed on your '
                'device (accents, languages), and it remembers your pick.'),
            _ChangelogItem('Import your anime library too. Restoring a Tachiyomi-style '
                'backup now also brings in anime (from Aniyomi backups) with watched '
                'episodes - not just manga and novels.'),
            _ChangelogItem('Skip the intro on any source. The player now shows a Skip '
                'Intro button near the start of an episode even when the source has no '
                'markers - tap to jump ahead (85s by default, adjustable in Player '
                'settings). Source-marked openings and auto-skip still work as before.'),
            _ChangelogItem('Pure-black (OLED) theme. A new Appearance toggle makes dark '
                'mode use a true-black background - crisper contrast and less battery '
                'use on OLED screens.'),
            _ChangelogItem('Auto-crop page borders. A new Reader setting trims solid '
                'white/black margins off pages so they fill the screen. It runs in the '
                'background and caches each page, so scrolling stays smooth.'),
            _ChangelogItem('Pages fail to load far less - and retry when they do. '
                'Reader images now retry automatically on transient server/Cloudflare '
                'errors (with backoff), and load with a concurrency cap so sites are '
                'less likely to rate-limit them. If a page still can\'t load, just tap '
                'it to try again.'),
            _ChangelogItem('Rearrange your tabs. A new Appearance setting '
                '(Navigation bar) lets you drag the bottom tabs into whatever order '
                'you like.'),
            _ChangelogItem('Beta features switch. Experimental features - hands-free '
                'and volume-key scrolling, RepoForge, AI translation and auto-crop - '
                'are now behind an opt-in "Beta features" toggle in Advanced settings '
                '(off by default) and clearly marked BETA.'),
            _ChangelogItem('Discover new series. A new Discover tab suggests manga, '
                'anime and light novels one at a time - tap Next for another, add it '
                'to your library when one of your sources carries it, or save it for '
                'later. Filter by genre, and link a tracker for picks based on what '
                'you have already read.'),
            _ChangelogItem('One-tap source install. On a source site, its "add to '
                'app" button now opens Foxlations and adds the repo for you - just '
                'confirm, no copy-pasting URLs.'),
            _ChangelogItem('Faster, lighter source lists. Large source repos now load '
                'from a compact index that is a fraction of the size, so adding and '
                'refreshing them is quicker on mobile data.'),
            _ChangelogItem('Filter Browse by language and repository. The filter is now '
                'a pop-up with Language and Repository tabs - pick any combination to '
                'narrow a long source list, and it scrolls.'),
            _ChangelogItem('Nine languages, and growing. The whole app is translated '
                'into English, Spanish, Portuguese, French, German, Italian, Japanese, '
                'Chinese and Arabic - pick yours in Settings > Language, or follow your '
                'device. More can now be added by the community.'),
            _ChangelogItem('Right-to-left layouts. Arabic and other right-to-left '
                'languages now mirror the whole interface correctly.'),
            _ChangelogItem('Manga, anime and novels are their own thing. Each type now '
                'keeps its own progress - a manga page, an episode time, or a novel '
                'scroll position - so Continue lands in the right place for each.'),
            _ChangelogItem('Fixes. Manga now reliably continues from your saved page; '
                'moving titles in and out of the vault works again and keeps your '
                'progress; and you can no longer install the same extension twice.'),
            _ChangelogItem('Foxlations 1.0.0 - the first official release. The '
                'headline: it now runs on-device extensions for manga, manhwa, '
                'manhua, light novels and anime, right on your device, and video '
                'picks up where you left off - reopen an episode to continue or '
                'start over. Everything else below.'),
            _ChangelogItem('Anime is here. Add an anime source and stream episodes '
                'in the built-in player. The app converts the extension on your '
                'device and finds the video for you.'),
            _ChangelogItem('Light novels remember your place. Continue now returns you '
                'to the exact spot you scrolled to - novels have no pages, so it saves '
                'your scroll position, not a page number.'),
            _ChangelogItem('Volume-button reading, done right. Tap volume to turn a page '
                '(left-to-right) or scroll a screen (webtoon); HOLD to scroll slowly and '
                'fluidly like dragging, at a speed you can set in Reader settings. Now on '
                'iOS too (experimental - it warns you first, since it pins media volume '
                'to 50% while reading). The video player keeps normal volume control.'),
            _ChangelogItem('Video resume that sticks (Android). Continuing an episode now '
                're-seeks until it actually holds at your spot - Android was accepting the '
                'seek then quietly restarting from 0.'),
            _ChangelogItem('Player seek bar no longer clipped. In landscape the progress '
                'bar and time were jammed against the bottom edge; they now sit above '
                'the system/gesture area.'),
            _ChangelogItem('Resume actually resumes. Picking "Continue" on an episode '
                'now reliably jumps to where you left off - the player waits for the '
                'video to load before seeking, instead of silently starting over.'),
            _ChangelogItem('Player menus fit the screen. The subtitle, audio, quality '
                'and speed pickers now scroll and cap their height, so options like '
                '"Subtitle delay" no longer get cut off the bottom in landscape.'),
            _ChangelogItem('Nothing hides under the navigation bar (Android). Settings '
                'and every other screen now pad themselves by your phone\'s actual '
                'system-bar size - gesture pill, 3-button bar, or none - so the last '
                'row never sits under the bottom bar, on any device.'),
            _ChangelogItem('The per-source "Update" button works. Updating one source '
                'from the list now confirms it updated (or tells you why it didn\'t) '
                'instead of quietly doing nothing; "Update all" is unchanged.'),
            _ChangelogItem('No more crashing when you reopen the app (iOS). Returning '
                'to Foxlations from the background after using a source no longer '
                'closes it - the extension engine now hands signal handling back to '
                'the app between jobs. Player and video-load problems also show up in '
                'the in-app log now (More → Debug logs).'),
            _ChangelogItem('Anime sound and details, fixed. Episodes that stream '
                'their audio as a separate track now play with sound, and sources '
                'that report a full web address for a title (instead of a short path) '
                'load their details and episodes again instead of failing.'),
            _ChangelogItem('Kotlin extensions run on-device. Alongside JavaScript '
                'and Dart, Foxlations now runs Kotlin manga, light-novel and anime '
                'extensions directly - so most existing source repos just work, no '
                'computer or server needed.'),
            _ChangelogItem('Gets past Cloudflare. Protected sources clear the check '
                'with a quick in-app verify step, and the app remembers it.'),
            _ChangelogItem('Big repos, sorted properly. Sources from large repos '
                'now show their real language and content rating - filter '
                'by language, and safe-for-work sources appear without turning on '
                '18+ content.'),
            _ChangelogItem('Reading & watching, fixed up. Light-novel chapters open '
                'and read, comic pages (and their images) load on sources that key '
                'off internal IDs, added repos come back instantly on relaunch, and '
                'anime now remembers where you stopped - reopen an episode to '
                'continue or start over.'),
            _ChangelogItem('Sources survive updates. Installed extensions no longer '
                '"fail to load" after an app re-sign or reinstall - their files are '
                'found again automatically, so you don\'t have to re-add them.'),
            _ChangelogItem('Clearer and quicker. Cloudflare-protected sources show a '
                '"Bypassing Cloudflare…" notice and whether it succeeded, and the '
                'extension engine warms up in the background when you open Browse, so '
                'the first source you open loads sooner.'),
            _ChangelogItem('More light novels read cleanly. API-based novel sources '
                '(like Novel Archive) now show the chapter text instead of a stray '
                'link.'),
            _ChangelogItem('No more closing on return. Coming back to the app after '
                'it sat in the background no longer crashes, and unexpected errors '
                'now show up in the in-app log (More → Debug logs).'),
            _ChangelogItem('Plus everything from the recent updates: in-reader AI '
                'translation over the speech bubbles, the Manga / Anime / Light '
                'Novel library filters, swipe between categories, and the unread '
                'badge that counts down as you read.'),
          ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.setxAboutClose,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangelogItem extends StatelessWidget {
  final String text;
  const _ChangelogItem(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsetsDirectional.only(top: 6, end: 10),
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              // Same chip as every other settings page: outlined + transparent
              // on OLED, soft tinted fill otherwise (see oledIconChip).
              decoration: oledIconChip(context, color: iconColor, fill: iconBg),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.outline),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: cs.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
