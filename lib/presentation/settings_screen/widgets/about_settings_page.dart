import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
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
  // Update these once a public repo exists.
  static const _sourceCodeUrl = 'https://github.com/ghotato/foxlations';
  static const _bugReportUrl = 'https://github.com/ghotato/foxlations/issues';

  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _info = info);
    });
  }

  String get _versionLabel {
    if (_info == null) return '';
    return 'Version ${_info!.version} (Build ${_info!.buildNumber})';
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
        title: Text(
          t.setxAboutTitle,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: 12, bottom: 12 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          // App hero card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
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
                const SizedBox(height: 12),
                Text(
                  'Foxlations',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _versionLabel,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: cs.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: t.setxAboutSectionApp),
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
          const SizedBox(height: 8),
          _SectionHeader(title: t.setxAboutSectionLegal),
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
          const SizedBox(height: 8),
          _SectionHeader(title: t.setxAboutSectionLinks),
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
            subtitle: 'Join the community',
            onTap: () => _openDiscord(context),
          ),
          const SizedBox(height: 24),
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
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.55),
            child: SingleChildScrollView(
              child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChangelogItem('Backups no longer include your vault unless you check “Include vault” '
                'when making one — and it asks you to unlock first (Face/Touch ID or password). It '
                'was previously included automatically whenever the vault happened to be unlocked.'),
            _ChangelogItem('Privacy fix: importing a Foxlations backup that includes vault titles '
                'now asks you to unlock so they’re restored straight into the vault — they’re never '
                'put in your public library (and are simply skipped if you don’t unlock).'),
            _ChangelogItem('Restoring a backup now asks to confirm first, so you can cancel if you '
                'picked the wrong file.'),
            _ChangelogItem('After importing a backup you can now organize its categories: keep '
                'them as-is, send a category’s titles into one of your existing categories, or '
                '(after unlocking) into a vault category.'),
            _ChangelogItem('“Open in WebView” is now instant on a cold start for titles you’ve '
                'opened before — the page link is remembered, so it no longer waits for the source '
                'engine to warm up.'),
            _ChangelogItem('Adding a title to the Vault is now much faster — its chapters are saved '
                'in one batch instead of one-by-one, so big titles no longer hang or time out.'),
            _ChangelogItem('Backing out of a global search now stops any sources still working '
                'through a Cloudflare check, instead of leaving them running in the background.'),
            _ChangelogItem('Installing a source while you’re in the Vault now adds it to the Vault '
                'automatically, so it stays in your private space.'),
            _ChangelogItem('The in-app browser now blocks the ad junk: auto-playing videos, pop-up '
                'windows, and redirects that yank you off the page to an ad site — while still '
                'letting you tap around and open pages normally.'),
            _ChangelogItem('The in-app browser now has an “Open in browser” option (⋮ menu) that '
                'hands the current page to your phone’s default browser.'),
            _ChangelogItem('Downloads you already had are now re-detected after reinstalling or '
                'updating the app — your downloaded chapters show as downloaded again without '
                'needing to re-download them.'),
            _ChangelogItem('Downloads now send a single “downloads complete” notification when '
                'the whole queue finishes, instead of one per chapter.'),
            _ChangelogItem('The download menu now says “episodes” instead of “chapters” for '
                'anime.'),
            _ChangelogItem('The Downloads screen is now a live download manager — watch each '
                'chapter download with a progress bar, pause or resume the whole queue, cancel '
                'individual items, change how many download at once, and see what finished this '
                'session. All the download settings moved behind the gear icon at the top.'),
            _ChangelogItem('Fixed “Open in WebView” on a title opening the wrong page (a 404 or '
                'the site homepage). It now opens the item’s real source page — using the '
                'source’s own link — for manga, anime and novels.'),
            _ChangelogItem('Light-novel chapter lists now load in full instead of stopping at the '
                'first 100 chapters.'),
            _ChangelogItem('Updating extensions now shows a spinner so you can tell it’s working — '
                'on “Update all” and on individual installs and updates.'),
            _ChangelogItem('Library updates are now lighter: they just check for the newest '
                'chapters instead of re-scanning every page. The update summary also starts with '
                'its categories collapsed.'),
            _ChangelogItem('Chapters with no release date no longer show a stray “0”.'),
            _ChangelogItem('New (experimental): an offline NEURAL voice for “Listen” — far more '
                'natural than the robotic system voices, and it runs fully on-device after a '
                'one-time download. Turn it on from the reader’s Listen settings (needs '
                'Experimental enabled in Advanced).'),
            _ChangelogItem('The lock-screen “Now Playing” for “Listen” now shows the cover art '
                'and a chapter timeline.'),
            _ChangelogItem('Novel “Listen” improvements: the voice picker now has a search box, '
                'a language filter, and — on iPhone/iPad — a Normal / Enhanced / Premium quality '
                'filter. Tip: download Enhanced/Premium voices in your device’s Spoken-Content '
                'settings and they’ll appear here.'),
            _ChangelogItem('“Listen” now cleans up stylized text before reading — drawn-out '
                'letters, repeated “!!!/???”, and *SFX*/symbol clutter are no longer spelled '
                'out letter by letter.'),
            _ChangelogItem('Changing the “Listen” speed, pitch or voice mid-chapter now resumes '
                'from the current sentence instead of restarting the paragraph — no more '
                'double-reading a line or the highlight drifting out of sync.'),
            _ChangelogItem('Fixed light-novel chapter lists showing in a scrambled order — they '
                'now sort by chapter number reliably (no more toggling first/latest to fix it).'),
            _ChangelogItem('A deeper fix for the iPhone/iPad crash that could hit after the '
                'app had been running a while or came back from the background — the embedded '
                'extension engine no longer aborts when the system sends it a signal.'),
            _ChangelogItem('Fixed the novel “Listen” button: long-press it to change the voice, '
                'speed and pitch (it wasn’t opening before).'),
            _ChangelogItem('“Create compatible backup” now lets you pick the app: Mihon/'
                'Tachiyomi, Aniyomi, Tachimanga, Mangayomi or LNReader — then choose which '
                'content types to include, and the file is built to match that app. Manga, '
                'anime and light novels are kept distinct. Foxlations backups now use a shorter '
                '“.fox” name (older .fxbackup files still restore).'),
            _ChangelogItem('Fixed images not loading on some sources (e.g. Manganato). Pages '
                'now send the correct referer, so the image server stops blocking them.'),
            _ChangelogItem('The library-update summary is now expandable. Each category '
                '(completed / skipped / failed) opens to show every title, so you can retry a '
                'whole group or just one entry.'),
            _ChangelogItem('Fixed the “Downloaded” library filter hiding titles — it now shows '
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
                'page in Settings to replay it any time. Plus a Foxlations Discord — find it '
                'in About or Help & Tips (and come say hi!).'),
            _ChangelogItem('Library updates now show live progress. A drop-down banner on the '
                'Library screen shows “Updating (title) X/X” as it runs, then a summary — '
                '“X completed, X skipped, X failed”. There’s also a matching notification so '
                'you can watch progress from outside the app, ending with “Update complete”.'),
            _ChangelogItem('Tap the finished-update banner to open a menu: Retry the failed '
                'titles, or force-update the skipped ones (ongoing & hiatus only — completed '
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
                'Cloudflare, Google, Quad9 or AdGuard — or add your own custom DoH servers '
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
                'every library item’s cover art from its source and reloads it — handy when a '
                'site changes its artwork. Shows progress and can be stopped; your own '
                'set-as-cover images are left untouched.'),
            _ChangelogItem('Fixed downloaded chapters saved as CBZ/PDF not reading offline. '
                'Chapters you downloaded with “Save as CBZ/PDF” are now recognized as '
                'downloaded and open straight from the saved file (no re-downloading from the '
                'internet).'),
            _ChangelogItem('Fewer crashes when reopening the app from the background (iPhone/'
                'iPad). The app now holds onto its own crash-signal handlers for the whole '
                'time it’s backgrounded — not just once it’s back on screen — so a stray '
                'system signal during wake-up no longer trips the extension engine, and '
                'dropped network sockets no longer take the app down on resume.'),
            _ChangelogItem('Novel “Listen” now plays in the background with lock-screen '
                'controls. Reading keeps going when you lock the screen or switch apps, and '
                'the lock screen / notification shows the chapter with play, pause, stop and '
                'next/previous-chapter buttons (also works with headset and Bluetooth '
                'controls).'),
            _ChangelogItem('iPhone/iPad: adding a local-source folder now works. Pick any '
                'folder (On My iPhone, iCloud Drive, etc.) in Browse → Local and Foxlations '
                'keeps access to it across launches — so your own manga folders stay readable '
                'and visible in the Files app, instead of the old “folders aren’t supported on '
                'iOS” message.'),
            _ChangelogItem('Richer “Listen” (text-to-speech) for novels. The voice now '
                'highlights the exact sentence being read (not just the paragraph), and a new '
                'tune button in the Listen bar adds a Pitch slider alongside Speed — both '
                'saved between sessions.'),
            _ChangelogItem('Light novels can now be downloaded for offline reading. Use the '
                'download button on a novel chapter (or the bulk “Download” menu) and the '
                'chapter’s text is saved to your device — the reader then opens it instantly '
                'with no network, and “Download ahead while reading” works for novels too.'),
            _ChangelogItem('Double-page reading. Turn your phone sideways and the manga '
                'reader can now show two pages at once, like an open book — enable “Double '
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
                'settings) — works on basically any tracked anime, not just the rare source '
                'that ships its own timestamps.'),
            _ChangelogItem('Download-ahead now downloads more than one chapter. “Download '
                'ahead while reading” has a new “Chapters ahead” option (1/2/3/5/10), so your '
                'next several chapters are ready before you get to them.'),
            _ChangelogItem('Light-novel reader customization. A new text-settings button (the '
                'sliders icon) lets you pick the font (Serif / Sans / Mono), text alignment '
                '(Left / Justify / Center), line spacing, and page margins — all saved.'),
            _ChangelogItem('Easier-on-the-eyes reading. The manga reader has a new “Eye '
                'comfort” section in reader settings — a Warm filter (reduces blue light) and '
                'a Brightness dim that can go darker than your phone’s minimum, for reading in '
                'the dark. The light-novel reader now has reader themes too (Sepia, Warm, '
                'Gray, Black/OLED) via the palette button up top.'),
            _ChangelogItem('Fixed chapter/episode navigation going BACKWARDS. “Next chapter” '
                '(and auto-advance, and next-episode autoplay) was jumping to the older '
                'chapter instead of the newer one, and opening the first chapter left “Next” '
                'greyed out so you were stuck. Now Next goes forward, Previous goes back, and '
                'the chapter/episode name in the header updates correctly.'),
            _ChangelogItem('More failures now surface in the debug logs: a scheduled backup '
                'that fails, and a source’s categories failing to load — no more silent '
                'failures there.'),
            _ChangelogItem('Removing a title from your library now shows a quick “Removed — '
                'Undo”, so an accidental tap on the heart is easy to take back (and it '
                'restores your read progress). Also, more background failures — tracker '
                'syncs and episode downloads — now show up in the debug logs instead of '
                'failing silently.'),
            _ChangelogItem('Under-the-hood cleanup — removed a batch of old unused code and a '
                'stray asset, and tidied up some warnings. No behaviour change; just a leaner, '
                'tidier app.'),
            _ChangelogItem('A few smaller fixes: newly-added or just-restored titles no longer '
                'flood the Updates screen with their whole back catalogue on the first update '
                'check; imported “finished” series from a Mihon/Tachiyomi backup now show as '
                'Completed (not Ongoing); and episode downloads now pick the highest-quality '
                'video reliably.'),
            _ChangelogItem('Anime and light novels now track progress properly. Finishing an '
                'episode or a novel chapter now marks it watched/read, counts down the unread '
                'badge, and updates your linked trackers (MAL/AniList/Kitsu) — previously only '
                'manga did this. And downloaded episodes finally play from the device offline '
                'instead of always streaming from the network.'),
            _ChangelogItem('Fixed two ways reading progress could vanish. Setting or changing '
                'your vault password no longer wipes the read progress and chapter lists of '
                'vaulted titles, and “Mark all unread” no longer blanks out the chapter list '
                '(it just marks them unread now).'),
            _ChangelogItem('Migrate-a-source now works for the vault and shows all the right '
                'sources. It was only ever looking at your normal library — so in the vault it '
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
                'goes offline or changes) now explains what’s happening and what to do — '
                'update the source, or remove it if the site is gone.'),
            _ChangelogItem('Fixed covers and pages not loading on some sites (e.g. Manganato/'
                'MangaFire). Their image servers use certificates our image loader was '
                'rejecting even though downloading the same images already worked — now '
                'viewing works too. Also fixed sources that return a relative cover path, and '
                'the in-reader AI translation now reuses the already-loaded page instead of '
                're-fetching it.'),
            _ChangelogItem('Image failures now show up in the logs, and Retry actually '
                'retries. When a cover or page won’t load, the reason (e.g. “blocked by the '
                'server (403)”, a timeout, or an HTTP error) now appears in More → Debug logs '
                'instead of failing silently. And tapping Retry now genuinely re-requests — '
                'including after you solve a Cloudflare check — instead of doing nothing once '
                'a site had been skipped. Failed downloads are logged too.'),
            _ChangelogItem('Faster cold start. The app now does its independent startup work '
                'in parallel and opens the library faster, and it waits until after the first '
                'screen is up to set up things that aren’t needed to get going (the Cloudflare '
                'helper, crash-report check and notification channels).'),
            _ChangelogItem('The library itself is smoother now, especially when it’s big. '
                'Opening, switching categories/types, scrolling and even typing in search '
                'did a lot of redundant work every frame — the entry list, counts and '
                '“Continue reading” are now computed the light way, the entrance animation '
                'only runs for the first screenful instead of every title, and downloading in '
                'the background no longer re-filters the whole library several times a second. '
                'Covers also pre-load just before they scroll into view.'),
            _ChangelogItem('Speed pass — downloads, library and images are all faster. '
                'Chapter pages now download several at a time instead of one-by-one (much '
                'faster chapters). Library lookups that ran on every page turn, every cover '
                'and every badge were rebuilding far too much — those are now direct/cached, '
                'so a big library scrolls smoother and reading no longer rebuilds the library '
                'behind you. Covers now decode at the size they’re shown (big memory + scroll '
                'win) and duplicate image requests are merged. Also fixed a storage leak where '
                'a removed title left its chapters behind forever.'),
            _ChangelogItem('Library updates are faster and show progress. The check no '
                'longer rebuilds the whole grid after every single title (which made a big '
                'library crawl), and the refresh spinner now shows a live “checked / total” '
                'count. On Android it also checks several titles at once.'),
            _ChangelogItem('Fixed covers “duping” onto the wrong titles. In a big library — '
                'especially mid-update — a cover could show up on a neighbouring title '
                'because the grid reused a cell’s image. Cards are now tied to their title so '
                'that can’t happen.'),
            _ChangelogItem('Import your library from Mangayomi. The “Import from another '
                'app” option now accepts Mangayomi backups (.backup) — manga, anime and '
                'light novels in one file — matching each title to your installed sources by '
                'name (anything not yet installed re-links once you add the source). The '
                'import section also now lists everything it accepts: Mihon/Tachiyomi & '
                'forks, Aniyomi, Tachimanga and Mangayomi.'),
            _ChangelogItem('Tachimanga backups now keep their sources. Tachimanga’s '
                '“Mihon-compatible” export stores each source’s name and ID in the opposite '
                'order from Mihon, so every title came in with no source and matched nothing. '
                'Imports now read either order — a 1,000-title Tachimanga backup that detected '
                'zero sources now links the vast majority to your installed ones.'),
            _ChangelogItem('Restored titles now re-link to their source permanently — '
                'automatically. When you install a source (or on the next launch, or right '
                'after a restore), any entries that were stuck pointing at the source’s name '
                'are rewritten to the real source, so they not only open but also group and '
                'show unread counts correctly. No manual migrating needed.'),
            _ChangelogItem('Restored titles whose source you’ve since installed now open. '
                'When a Tachiyomi/Mihon backup was restored before its source was installed, '
                'the entry got stuck pointing at the source’s name rather than its real ID — '
                'so even after installing the source, the title still said “source not '
                'installed”. Those entries now re-link to the installed source by name and '
                'open normally.'),
            _ChangelogItem('No more dead-end when a chapter’s source isn’t installed. '
                'Opening a title whose source is missing (common right after restoring a '
                'backup) used to drop you on a blank “Source not installed” screen with no '
                'way back — it now has a back button and tells you to install the source '
                'from Extensions.'),
            _ChangelogItem('The title page now shows which source it’s from. Handy after a '
                'restore for spotting which extension you still need to install.'),
            _ChangelogItem('Installed sources show their repo again (e.g. Keiyoushi) instead '
                'of “custom”. The repo a source came from wasn’t being saved, so after a '
                'restart the Sources list fell back to the generic framework label — it’s '
                'now stored (and recovered from the repo URL for sources installed earlier).'),
            _ChangelogItem('Extension updates now show which type they’re under. The '
                'Manga / Anime / Novels toggle on the Extensions page now carries a small '
                'count badge on the type that has updates — so when the bottom bar shows an '
                'update, you can see at a glance whether it’s a manga, anime, or light-novel '
                'source instead of only finding it under the first tab.'),
            _ChangelogItem('Big libraries and bulk moves are much faster. Moving titles in or '
                'out of the vault, and the library’s multi-select actions (mark read/unread, '
                'remove, move category), now update the whole batch in one pass instead of '
                'redrawing after every single title — so large selections no longer crawl. '
                'A big library also scrolls more smoothly: the unread badges are now counted '
                'once and cached instead of recomputed for every cover on every frame. '
                'Migrating with a long read-history is faster too.'),
            _ChangelogItem('Fixed the vault “move a category” picker not scrolling — if you '
                'have a lot of categories, the list now scrolls.'),
            _ChangelogItem('Unlock the vault with biometrics. Turn on Face ID / fingerprint '
                'in Vault settings (confirm your password once) and it’ll offer biometrics on '
                'unlock.'),
            _ChangelogItem('Decoy password. Set a second password that opens a separate, '
                'isolated vault — hand over your phone without revealing your real content. '
                'Your real vault stays encrypted and untouched.'),
            _ChangelogItem('Backups now include your vault. When the vault is unlocked, its '
                'titles are saved into backups (native and Tachiyomi/Mihon) as normal entries '
                'under “Vault-…” categories — so they’re not lost and stay portable.'),
            _ChangelogItem('Panic exit for the vault. Turn on “Shake to exit” in Vault '
                'settings and, while you’re in the vault, a quick shake drops you straight '
                'back to your normal library.'),
            _ChangelogItem('More vault moving options. Moving a whole category now lets you '
                'pick which category it lands in on the other side. And you can turn on '
                '“Move-to-vault in library” (Vault settings) to move selected titles straight '
                'into (or out of) the vault from the library’s selection menu.'),
            _ChangelogItem('Vault move screen, revamped. A To Vault / From Vault toggle '
                'switches direction, and you can move titles one at a time, multi-select '
                '(long-press), move all at once, or move a whole category in or out — with '
                'a search box and Undo.'),
            _ChangelogItem('The anime Categories tab works now. Open an anime source’s '
                'Categories tab, tap a genre (Action, Comedy, …) and you’ll browse only that '
                'category — built from the source’s own genre filters.'),
            _ChangelogItem('Titles without a cover look right now. Some sources (e.g. certain '
                'anime sources like AniHQ) don’t include cover art in their listing — those '
                'now show a neutral placeholder instead of a “Retry” button on every title. '
                'The cover still loads on the title’s page.'),
            _ChangelogItem('The repo options menu now shows Discord/website when a repo '
                'lists them (Keiyoushi’s Discord was being dropped before it reached the '
                'menu). Give the repo a moment to refresh, or tap Reinstall sources.'),
            _ChangelogItem('Fixed the blank “Solve Cloudflare” screen. The in-app browser '
                'opened the site fine but the Cloudflare challenge itself came up white — it '
                'was missing a real browser identity and page storage the challenge needs. '
                'It now loads properly so you can complete the check.'),
            _ChangelogItem('Tap a repository for options. In Extension Repositories, tapping '
                'a repo now opens a menu: reinstall its sources, copy the repo URL, open its '
                'GitHub page, open its Discord (if it lists one), or delete it.'),
            _ChangelogItem('Anime sources you already installed now repair themselves. '
                'Anime added before the last update kept showing “Failed to load / '
                'VerifyError” because the old converted copy was cached — they now re-fix on '
                'first open automatically, no reinstall or repo refresh needed.'),
            _ChangelogItem('Fixed reader controls vanishing the instant you tapped (webtoon '
                'mode). Revealing the controls triggered a layout refresh that the reader '
                'mistook for a scroll and hid them again a frame later — now only a real '
                'scroll hides them, so a tap brings them up and they stay.'),
            _ChangelogItem('Anime extensions really load on iOS now. The previous attempt '
                'didn’t take on the embedded engine (it ignores the verification switch); '
                'this regenerates the extension bytecode after conversion so the sources load '
                'properly — no more “Failed to load / VerifyError”.'),
            _ChangelogItem('Reader controls now get out of your way. While you read, a '
                'tap or scroll hides everything — including the radial wheel and the back '
                'button — and a tap anywhere brings the controls back (that “tap doesn’t '
                'bring the menu back” bug is fixed, in both the classic and radial layouts).'),
            _ChangelogItem('Sources now tell you what’s wrong. When a source fails, the '
                'error screen shows its real message — “log in”, “open in WebView”, “not '
                'available in your region”, and so on — instead of a generic error, so you '
                'know what to do. Global search shows the reason per source too. (Full '
                'technical detail still goes to More → Debug logs.)'),
            _ChangelogItem('Anime extensions now load on iOS. Aniyomi-style anime sources '
                'were failing to load on the embedded engine; most now work. (A few still '
                'need more work — see the notes — so report any that misbehave.)'),
            _ChangelogItem('Fixed two source errors. Some sources (e.g. Mangageko) '
                'failed to open a title with an "uninitialized title" error; and after '
                'the app had been in the background, Cloudflare-protected sources '
                '(e.g. Manganato) could stop loading until a restart. Both are fixed, '
                'and the Cloudflare helper now re-arms itself and logs to More → Debug '
                'logs if it ever can’t start.'),
            _ChangelogItem('Swiping between library categories now turns like a 3D '
                'cube — the category you leave rotates away as the next one turns in.'),
            _ChangelogItem('Hands-free scrolling (beta): more accurate eye tracking. '
                'It now projects where your eyes are aimed onto the screen for a '
                'better-aligned gaze, with a Raw/Geometric switch in Gaze Lab. '
                'Re-run calibration after updating.'),
            _ChangelogItem('Hands-free scrolling (beta) holds steadier when you move '
                'the phone: it now uses the phone’s motion sensors so tilting or '
                'shifting the device no longer counts as a head tilt. Re-run gaze '
                'calibration once after updating.'),
            _ChangelogItem('Global search, rebuilt. Searching across sources now shows '
                'every source as its own row with its own state — results, "no results", '
                'or a failure you can retry per-source — and matching is fuzzier, so '
                'near-miss titles still turn up. Long-press a title on its detail page to '
                'search it everywhere.'),
            _ChangelogItem('Long-press a page in the reader for a quick menu: Share, Save '
                'the image, Set it as the cover, or Recognize text (OCR) on the page.'),
            _ChangelogItem('Your settings actually stick now. Every setting is saved '
                'the instant you change it, so nothing reverts if you close the app '
                'right after — the fix that was only on the theme now covers them all.'),
            _ChangelogItem('Incognito mode. Settings → Security & Privacy adds a private '
                'mode that pauses reading history and tracker updates for manga, anime '
                'and novels; a badge in the library bar reminds you it is on.'),
            _ChangelogItem('Notifications. Get notified about new chapters after a library '
                'update, and when downloads finish or fail — each with its own toggle in '
                'Settings → Notifications.'),
            _ChangelogItem('App lock. Settings → Security & Privacy can now require your '
                'fingerprint, face, or device passcode to open the app, re-locking '
                'whenever it goes to the background.'),
            _ChangelogItem('Secure screen. A new Security toggle hides the app in the '
                'recent-apps switcher (and blocks screenshots on Android).'),
            _ChangelogItem('More settings that now do something: auto-download new chapters, '
                'open links in your system browser, verbose logging, and extension-update '
                'alerts — all previously just switches that saved but did nothing.'),
            _ChangelogItem('Library display fixes. The "Downloaded" filter no longer hides '
                'your whole library, downloaded titles get a badge, the unread/downloaded '
                'badge toggles work, and categories can show their item counts.'),
            _ChangelogItem('iOS: fixed the crash when reopening the app after it had been '
                'in the background for a while.'),
            _ChangelogItem('A fresh cold-boot animation. Opening the app now shows the '
                'fox logo and then reveals your library with one of a few short '
                'transitions, picked at random each launch — a zoom, a gust of autumn '
                'leaves, a warm glow, or a split down the middle.'),
            _ChangelogItem('Your theme sticks right away. Switching light/dark or '
                'picking a theme is now saved to disk the instant you change it, so it '
                'is remembered even if you close the app immediately afterwards.'),
            _ChangelogItem('The Continue bar speaks anime. When the last thing you '
                'opened is a show, it now reads "Continue Watching" with an episode '
                'count, instead of "Continue Reading" with a chapter count.'),
            _ChangelogItem('Reader controls get out of the way. The bars show for a '
                'moment when you open a chapter, then tuck away as soon as the page '
                'loads. Tap once to bring them back; tap again — or start scrolling — '
                'to hide them.'),
            _ChangelogItem('Listen to light novels. The novel reader can now read a '
                'chapter aloud — tap the headphones icon, with play/pause and a speed '
                'control, and the current paragraph highlights and scrolls into view. '
                'It rolls on into the next chapter so you can keep listening '
                'hands-free.'),
            _ChangelogItem('Pick a voice for Listen. The novel reader\'s read-aloud '
                'now has a voice picker — choose any of the voices installed on your '
                'device (accents, languages), and it remembers your pick.'),
            _ChangelogItem('Import your anime library too. Restoring a Tachiyomi-style '
                'backup now also brings in anime (from Aniyomi backups) with watched '
                'episodes — not just manga and novels.'),
            _ChangelogItem('Skip the intro on any source. The player now shows a Skip '
                'Intro button near the start of an episode even when the source has no '
                'markers — tap to jump ahead (85s by default, adjustable in Player '
                'settings). Source-marked openings and auto-skip still work as before.'),
            _ChangelogItem('Pure-black (OLED) theme. A new Appearance toggle makes dark '
                'mode use a true-black background — crisper contrast and less battery '
                'use on OLED screens.'),
            _ChangelogItem('Auto-crop page borders. A new Reader setting trims solid '
                'white/black margins off pages so they fill the screen. It runs in the '
                'background and caches each page, so scrolling stays smooth.'),
            _ChangelogItem('Pages fail to load far less — and retry when they do. '
                'Reader images now retry automatically on transient server/Cloudflare '
                'errors (with backoff), and load with a concurrency cap so sites are '
                'less likely to rate-limit them. If a page still can\'t load, just tap '
                'it to try again.'),
            _ChangelogItem('Rearrange your tabs. A new Appearance setting '
                '(Navigation bar) lets you drag the bottom tabs into whatever order '
                'you like.'),
            _ChangelogItem('Beta features switch. Experimental features — hands-free '
                'and volume-key scrolling, RepoForge, AI translation and auto-crop — '
                'are now behind an opt-in "Beta features" toggle in Advanced settings '
                '(off by default) and clearly marked BETA.'),
            _ChangelogItem('Discover new series. A new Discover tab suggests manga, '
                'anime and light novels one at a time — tap Next for another, add it '
                'to your library when one of your sources carries it, or save it for '
                'later. Filter by genre, and link a tracker for picks based on what '
                'you have already read.'),
            _ChangelogItem('One-tap source install. On a source site, its "add to '
                'app" button now opens Foxlations and adds the repo for you — just '
                'confirm, no copy-pasting URLs.'),
            _ChangelogItem('Faster, lighter source lists. Large source repos now load '
                'from a compact index that is a fraction of the size, so adding and '
                'refreshing them is quicker on mobile data.'),
            _ChangelogItem('Filter Browse by language and repository. The filter is now '
                'a pop-up with Language and Repository tabs — pick any combination to '
                'narrow a long source list, and it scrolls.'),
            _ChangelogItem('Nine languages, and growing. The whole app is translated '
                'into English, Spanish, Portuguese, French, German, Italian, Japanese, '
                'Chinese and Arabic — pick yours in Settings > Language, or follow your '
                'device. More can now be added by the community.'),
            _ChangelogItem('Right-to-left layouts. Arabic and other right-to-left '
                'languages now mirror the whole interface correctly.'),
            _ChangelogItem('Manga, anime and novels are their own thing. Each type now '
                'keeps its own progress — a manga page, an episode time, or a novel '
                'scroll position — so Continue lands in the right place for each.'),
            _ChangelogItem('Fixes. Manga now reliably continues from your saved page; '
                'moving titles in and out of the vault works again and keeps your '
                'progress; and you can no longer install the same extension twice.'),
            _ChangelogItem('Foxlations 1.0.0 — the first official release. The '
                'headline: it now runs on-device extensions for manga, manhwa, '
                'manhua, light novels and anime, right on your device, and video '
                'picks up where you left off — reopen an episode to continue or '
                'start over. Everything else below.'),
            _ChangelogItem('Anime is here. Add an anime source and stream episodes '
                'in the built-in player. The app converts the extension on your '
                'device and finds the video for you.'),
            _ChangelogItem('Light novels remember your place. Continue now returns you '
                'to the exact spot you scrolled to — novels have no pages, so it saves '
                'your scroll position, not a page number.'),
            _ChangelogItem('Volume-button reading, done right. Tap volume to turn a page '
                '(left-to-right) or scroll a screen (webtoon); HOLD to scroll slowly and '
                'fluidly like dragging, at a speed you can set in Reader settings. Now on '
                'iOS too (experimental — it warns you first, since it pins media volume '
                'to 50% while reading). The video player keeps normal volume control.'),
            _ChangelogItem('Video resume that sticks (Android). Continuing an episode now '
                're-seeks until it actually holds at your spot — Android was accepting the '
                'seek then quietly restarting from 0.'),
            _ChangelogItem('Player seek bar no longer clipped. In landscape the progress '
                'bar and time were jammed against the bottom edge; they now sit above '
                'the system/gesture area.'),
            _ChangelogItem('Resume actually resumes. Picking "Continue" on an episode '
                'now reliably jumps to where you left off — the player waits for the '
                'video to load before seeking, instead of silently starting over.'),
            _ChangelogItem('Player menus fit the screen. The subtitle, audio, quality '
                'and speed pickers now scroll and cap their height, so options like '
                '"Subtitle delay" no longer get cut off the bottom in landscape.'),
            _ChangelogItem('Nothing hides under the navigation bar (Android). Settings '
                'and every other screen now pad themselves by your phone\'s actual '
                'system-bar size — gesture pill, 3-button bar, or none — so the last '
                'row never sits under the bottom bar, on any device.'),
            _ChangelogItem('The per-source "Update" button works. Updating one source '
                'from the list now confirms it updated (or tells you why it didn\'t) '
                'instead of quietly doing nothing; "Update all" is unchanged.'),
            _ChangelogItem('No more crashing when you reopen the app (iOS). Returning '
                'to Foxlations from the background after using a source no longer '
                'closes it — the extension engine now hands signal handling back to '
                'the app between jobs. Player and video-load problems also show up in '
                'the in-app log now (More → Debug logs).'),
            _ChangelogItem('Anime sound and details, fixed. Episodes that stream '
                'their audio as a separate track now play with sound, and sources '
                'that report a full web address for a title (instead of a short path) '
                'load their details and episodes again instead of failing.'),
            _ChangelogItem('Kotlin extensions run on-device. Alongside JavaScript '
                'and Dart, Foxlations now runs Kotlin manga, light-novel and anime '
                'extensions directly — so most existing source repos just work, no '
                'computer or server needed.'),
            _ChangelogItem('Gets past Cloudflare. Protected sources clear the check '
                'with a quick in-app verify step, and the app remembers it.'),
            _ChangelogItem('Big repos, sorted properly. Sources from large repos '
                'now show their real language and content rating — filter '
                'by language, and safe-for-work sources appear without turning on '
                '18+ content.'),
            _ChangelogItem('Reading & watching, fixed up. Light-novel chapters open '
                'and read, comic pages (and their images) load on sources that key '
                'off internal IDs, added repos come back instantly on relaunch, and '
                'anime now remembers where you stopped — reopen an episode to '
                'continue or start over.'),
            _ChangelogItem('Sources survive updates. Installed extensions no longer '
                '"fail to load" after an app re-sign or reinstall — their files are '
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
              style: GoogleFonts.manrope(
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
      padding: const EdgeInsets.only(bottom: 8),
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
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: cs.primary,
        ),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: cs.outline,
                    ),
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
