import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../core/services/image_loader.dart';
import '../../core/providers/source_provider.dart';
import '../../core/providers/reader_provider.dart';
import '../../core/providers/library_provider.dart';
import '../../core/providers/tracking_provider.dart';
import '../../core/providers/download_provider.dart';
import '../../core/providers/incognito_provider.dart';
import '../library_screen/library_screen.dart' show kBookmarkedMangaIdsKey;
import '../../l10n/app_localizations.dart';
import '../../eval/model/page_url.dart';
import '../../theme/app_theme.dart';
import '../widgets/manga_image.dart';
import 'widgets/reader_translation_provider_sheet.dart';
import 'widgets/reader_translation_overlay.dart';
import 'widgets/radial_reader_menu.dart';
import '../../core/services/ai_translation_service.dart';
import '../../core/services/koharu_service.dart';
import '../../core/services/volume_keys.dart';
import '../../core/services/gaze_scroll_service.dart';
import '../../core/services/tilt_scroll_service.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderScreen extends StatelessWidget {
  final String chapterUrl;
  final String sourceId;
  final String? mangaUrl;
  final String? chapterTitle;
  final String? mangaTitle;
  final List<Map<String, dynamic>>? chapters;
  final int currentIndex;
  final int startPage;

  const ReaderScreen({
    super.key,
    required this.chapterUrl,
    required this.sourceId,
    this.mangaUrl,
    this.chapterTitle,
    this.mangaTitle,
    this.chapters,
    this.currentIndex = 0,
    this.startPage = 0,
  });

  @override
  Widget build(BuildContext context) {
    final sourceProvider = context.read<SourceProvider>();
    final installed = sourceProvider.resolveInstalled(sourceId);

    if (installed == null) {
      final t = AppLocalizations.of(context);
      final cs = Theme.of(context).colorScheme;
      return Scaffold(
        // A plain Center had no way back out — the user was stuck on a black
        // screen (common after a backup restore before sources are reinstalled).
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.extension_off_rounded, size: 48, color: cs.outline),
                const SizedBox(height: 16),
                Text(
                  t.readerSourceNotInstalled,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.readerSourceNotInstalledHint,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    height: 1.4,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => ReaderProvider(
        installedSource: installed,
        chapterUrl: chapterUrl,
        sourceId: sourceId,
        mangaTitle: mangaTitle ?? '',
        chapters: chapters,
        currentIndex: currentIndex,
        startPage: startPage,
      )..loadPages(),
      child: _ReaderBody(
        sourceId: sourceId,
        mangaUrl: mangaUrl,
        chapterTitle: chapterTitle,
        mangaTitle: mangaTitle,
      ),
    );
  }
}

class _ReaderBody extends StatefulWidget {
  final String sourceId;
  final String? mangaUrl;
  final String? chapterTitle;
  final String? mangaTitle;

  const _ReaderBody({
    required this.sourceId,
    this.mangaUrl,
    this.chapterTitle,
    this.mangaTitle,
  });

  @override
  State<_ReaderBody> createState() => _ReaderBodyState();
}

class _ReaderBodyState extends State<_ReaderBody>
    with TickerProviderStateMixin {
  late final AnimationController _hudController;
  late final Animation<double> _hudAnimation;
  PageController? _pageController;
  ScrollController? _scrollController;
  // Positioned list for accurate page tracking in vertical scroll mode
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  // Relative pixel scrolling for volume-key smooth scroll in continuous modes.
  final ScrollOffsetController _scrollOffsetController = ScrollOffsetController();
  int _sliderPage = 0; // Tracks slider position during drag
  bool _isInteracting = false; // User is touching HUD elements
  // Last first-visible position, to tell a real scroll from a spurious itemPositions
  // re-emit (layout passes, e.g. the rebuild when a tap reveals the HUD).
  int? _lastFirstIndex;
  double? _lastLeadingEdge;
  bool _sliderInitialized = false; // One-time sync after pages load
  // HUD shows briefly on entry, then hides once the first page image loads.
  // Once the user taps/scrolls (or the fallback fires), the initial phase is
  // "resolved" and the HUD is purely tap/scroll-driven after that.
  bool _initialHudResolved = false;
  DateTime? _enteredAt;
  // Last wakelock state we pushed to the OS, so build() only calls the plugin
  // when the "Keep Screen On" setting actually changes rather than every frame.
  bool? _wakelockApplied;

  // Translation state
  bool _translationEnabled = false; // loaded from settings
  bool _isTranslationActive = false;
  final bool _showTranslated = true; // global translated-vs-original toggle
  String _selectedProviderName = 'Claude';
  String _selectedProviderId = 'gemini';
  // Per-page translation. Bubbles keyed by page index so each image carries its
  // own overlay (positions correctly and scrolls with the image); the image
  // size feeds the overlay's letterbox math; _pageTranslating guards re-runs.
  final Map<int, List<TranslationBubble>> _pageBubbles = {};
  final Map<int, Size> _pageImgSize = {};
  // Dual-page (landscape) reader: the current page→slot grouping, the pages
  // detected as wide double-spreads (shown on their own when split-wide is on),
  // and whether dual-page was active on the previous build (so a rotation that
  // flips the mode can re-anchor the controller onto the right spread).
  List<List<int>> _slots = const [];
  final Set<int> _widePages = {};
  bool? _lastDualActive;
  final Set<int> _pageTranslating = {};
  final Set<int> _pageDone = {}; // attempted (success OR fail) — don't re-run
  bool get _isTranslating => _pageTranslating.isNotEmpty;
  final _translationService = AiTranslationService();
  final _koharuService = KoharuService();
  final Map<int, Uint8List> _koharuImageCache = {};
  late final AnimationController _translationAnimController;
  late final Animation<double> _translationAnimation;

  @override
  void initState() {
    super.initState();
    // Default to immersive; the actual mode is reapplied from ReaderSettings
    // once the provider has finished loading prefs (see post-frame callback
    // below).
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Allow landscape while reading (the rest of the app is portrait) so the
    // double-page layout can engage when the phone is turned sideways. Reset on
    // dispose.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _hudController = AnimationController(
      duration: AppTheme.standard,
      vsync: this,
    );
    _hudAnimation = CurvedAnimation(
      parent: _hudController,
      curve: AppTheme.primaryCurve,
    );
    _translationAnimController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this);
    _translationAnimation = CurvedAnimation(
      parent: _translationAnimController, curve: Curves.easeOutBack);

    // Listen for visible page changes in scroll mode
    _itemPositionsListener.itemPositions.addListener(_onPositionChanged);

    // Sync slider, load AI provider, and show HUD briefly on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reader = context.read<ReaderProvider>();
      setState(() => _sliderPage = reader.currentPage);
      _hudController.forward();
      reader.toggleHud();
      _enteredAt = DateTime.now();
      // Fallback: if no page image ever reports loaded (e.g. all error out),
      // still end the entry phase so the HUD doesn't sit there forever.
      Future.delayed(const Duration(seconds: 5), _resolveInitialHud);
      _loadProviderName();
    });
    // Volume-button page navigation (Android, opt-in). Only while a reader is open —
    // disabled again in dispose so the buttons control volume elsewhere. Read the pref
    // directly so a not-yet-loaded provider can't leave it off.
    _maybeEnableVolumeKeys();
    _maybeEnableGaze();
    _maybeEnableTilt();
    _loadBookmarks();
    _loadRadialSettings();
  }

  Future<void> _loadRadialSettings() async {
    final prefs = SettingsStore.instance;
    if (!mounted) return;
    setState(() {
      _radialEnabled = prefs.getBool('reader_radial_enabled') ?? false;
      _radialLeftSide =
          (prefs.getString('reader_radial_side') ?? 'right') == 'left';
    });
  }

  Future<void> _maybeEnableVolumeKeys() async {
    final prefs = SettingsStore.instance;
    final beta = prefs.getBool('beta_features_enabled') ?? false; // volume-key nav is beta
    final on = beta && (prefs.getBool('reader_volume_keys') ?? false);
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    if (on && mounted) {
      VolumeKeys.enable(_onVolumeKey);
    }
  }

  /// Current page index from the freshest source of truth: the PageController's own
  /// page in paged mode, or the top visible item in continuous-scroll mode.
  int _currentReaderPage(ReaderProvider reader) {
    if (_pageController?.hasClients == true) {
      return (_pageController!.page ?? reader.currentPage.toDouble()).round();
    }
    final visible = _itemPositionsListener.itemPositions.value
        .where((p) => p.itemTrailingEdge > 0);
    if (visible.isEmpty) return reader.currentPage;
    return visible.reduce((a, b) => a.index < b.index ? a : b).index;
  }

  // Paged-mode: page being navigated toward via volume keys. Rapid taps accumulate onto
  // this absolute target so they don't fight a mid-flight animation; cleared after idle.
  int? _navTarget;
  Timer? _navResetTimer;
  // Continuous-mode hold detection: _holdTimer distinguishes a tap from a hold; while
  // held, _holdScrollTimer drives a slow fluid scroll at _volScrollSpeed (px/sec).
  Timer? _holdTimer;
  Timer? _holdScrollTimer;
  bool _holdScrolling = false;
  double _volScrollSpeed = 600.0;
  // Hands-free (gaze) scrolling — iOS only.
  Timer? _gazeTimer;
  int _gazeDelta = 0;
  double _gazeSpeed = 0;
  bool _gazeActive = false;
  bool _gazeSupported = false;
  bool _tiltActive = false;
  final Set<String> _bookmarks = {};

  // In-reader radial control (opt-in) — see RadialReaderMenu. When enabled it
  // replaces the classic top/bottom bars with two corner anchors.
  bool _radialEnabled = false;
  bool _radialLeftSide = false;

  /// Volume-key handler. dir = 'up'|'down', phase = 'down'|'up'.
  /// - Paged (ltr/rtl): each press flips one page.
  /// - Continuous (webtoon/vertical): a quick TAP scrolls ~a screen; HOLDING scrolls
  ///   slowly and fluidly (like dragging) until released.
  void _onVolumeKey(String dir, String phase) {
    if (!mounted) return;
    final delta = dir == 'down' ? 1 : -1;
    if (_pageController?.hasClients == true) {
      if (phase == 'down') _flipPage(delta);
      return;
    }
    // Continuous modes.
    if (phase == 'down') {
      _holdScrolling = false;
      _holdTimer?.cancel();
      _holdTimer = Timer(const Duration(milliseconds: 250), () {
        _holdScrolling = true;
        _beginHoldScroll(delta);
      });
    } else {
      // 'up': released. If the hold hadn't started yet it was a tap; otherwise stop.
      _holdTimer?.cancel();
      if (_holdScrolling) {
        _holdScrolling = false;
        _holdScrollTimer?.cancel();
      } else {
        _smoothScrollScreen(delta);
      }
    }
  }

  /// Paged-mode page flip, accumulating rapid taps onto an absolute target.
  void _flipPage(int delta) {
    final reader = context.read<ReaderProvider>();
    final base = _navTarget ?? _currentReaderPage(reader);
    final target = base + delta;
    // In paged mode _currentReaderPage is the controller's slot index, so bound
    // the flip by the slot count (== page count outside dual-page mode).
    final maxSlot = (_slots.isNotEmpty ? _slots.length : reader.totalPages) - 1;
    if (target >= 0 && target <= maxSlot) {
      _navTarget = target;
      _navResetTimer?.cancel();
      _navResetTimer =
          Timer(const Duration(milliseconds: 500), () => _navTarget = null);
      _pageController!.animateToPage(target,
          duration: AppTheme.standard, curve: AppTheme.primaryCurve);
    } else if (delta > 0 && reader.hasNextChapter) {
      _navTarget = null;
      reader.goToNextChapter();
    } else if (delta < 0 && reader.hasPreviousChapter) {
      _navTarget = null;
      reader.goToPreviousChapter();
    }
  }

  /// Continuous-mode single tap: smooth scroll by ~85% of a screen.
  void _smoothScrollScreen(int delta) {
    if (!mounted) return;
    final screen = MediaQuery.of(context).size.height * 0.85;
    try {
      _scrollOffsetController.animateScroll(
          offset: delta * screen,
          duration: AppTheme.standard,
          curve: AppTheme.primaryCurve);
    } catch (_) {}
  }

  /// Continuous-mode hold: fluid scroll at _volScrollSpeed px/sec until released.
  void _beginHoldScroll(int delta) {
    const tick = Duration(milliseconds: 100);
    final step = delta * _volScrollSpeed * (tick.inMilliseconds / 1000.0);
    void scrollOnce() {
      if (!mounted) return;
      try {
        _scrollOffsetController.animateScroll(
            offset: step, duration: tick, curve: Curves.linear);
      } catch (_) {}
    }
    scrollOnce();
    _holdScrollTimer?.cancel();
    _holdScrollTimer = Timer.periodic(tick, (_) {
      if (!mounted || !_holdScrolling) {
        _holdScrollTimer?.cancel();
        return;
      }
      scrollOnce();
    });
  }

  void _onPositionChanged() {
    if (!mounted) return;
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final reader = context.read<ReaderProvider>();
    if (reader.totalPages == 0) return;

    // First visible item = current page
    final validPositions = positions.where((p) => p.itemTrailingEdge > 0);
    if (validPositions.isEmpty) return;
    final firstVisible = validPositions.reduce((a, b) => a.index < b.index ? a : b);
    final page = firstVisible.index.clamp(0, reader.totalPages - 1);

    if (page != reader.currentPage) {
      reader.setPage(page);
      if (mounted) setState(() => _sliderPage = page);
      _updateProgress(reader, page);
      _initialHudResolved = true; // a real scroll ends the entry phase
    }

    // Only treat this as a SCROLL when the viewport actually moved. itemPositions
    // re-emits on layout passes too — notably the rebuild that happens when a tap
    // reveals the HUD — and hiding on those spurious emits made the HUD vanish the
    // instant it appeared ("I tap and it disappears almost instantly"). Compare the
    // first-visible item's index + leading edge against the last to detect real motion.
    final movedIndex = _lastFirstIndex != null && firstVisible.index != _lastFirstIndex;
    final movedEdge = _lastLeadingEdge != null &&
        (firstVisible.itemLeadingEdge - _lastLeadingEdge!).abs() > 0.004;
    final scrolled = movedIndex || movedEdge;
    _lastFirstIndex = firstVisible.index;
    _lastLeadingEdge = firstVisible.itemLeadingEdge;

    // A real scroll hides the controls — but only once the entry phase is over, so
    // layout settling as pages load doesn't yank the HUD away on first open.
    if (scrolled && _initialHudResolved && reader.showHud && !_isInteracting) {
      _hudController.reverse();
      reader.toggleHud();
    }

    // Trigger next chapter when user scrolls to end card (only when
    // auto-preload is enabled in Reader settings).
    final lastVisible = positions.reduce((a, b) => a.index > b.index ? a : b);
    if (reader.settings.autoPreload &&
        lastVisible.index >= reader.totalPages &&
        !reader.isLoadingNext &&
        !reader.isLastChapter &&
        !reader.nextChapterError) {
      reader.loadNextChapter();
    }

    // Live translation: as new pages scroll into view, translate them. Cheap
    // no-op for pages already done or in flight (guarded in _translatePage).
    if (_isTranslationActive) _translateVisiblePages();
  }

  // ── Hands-free (gaze) scrolling ──────────────────────
  // iOS-only: continuous modes drive the fluid scroll loop; paged modes flip one
  // page per look (native emits one decision per dwell).
  Future<void> _maybeEnableGaze() async {
    _gazeSupported = await GazeScroll.isSupported();
    if (mounted) setState(() {});
    if (!_gazeSupported) return;
    final prefs = SettingsStore.instance;
    if (!(prefs.getBool('beta_features_enabled') ?? false)) return; // hands-free is beta
    if (!(prefs.getBool('reader_gaze_enabled') ?? false)) return;
    await _startGaze(prefs);
  }

  Future<void> _startGaze(SettingsStore prefs) async {
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    await GazeScroll.updateSettings(GazeSettings(
      mode: prefs.getString('reader_gaze_mode') ?? 'combined',
      threshold: prefs.getDouble('reader_gaze_threshold') ?? 0.8,
      dwellMs: (prefs.getDouble('reader_gaze_dwell') ?? 300).round(),
      smoothing: prefs.getDouble('reader_gaze_smoothing') ?? 0.25,
      useGeometric: prefs.getBool('reader_gaze_geometric') ?? true,
    ));
    if (!mounted) return;
    await GazeScroll.enable(_onGaze);
    if (mounted) setState(() => _gazeActive = true);
  }

  Future<void> _toggleGaze() async {
    final prefs = SettingsStore.instance;
    if (_gazeActive) {
      await GazeScroll.disable();
      await prefs.setBool('reader_gaze_enabled', false);
      _stopGazeScroll();
      if (mounted) setState(() => _gazeActive = false);
      return;
    }
    if (!await _confirmGazeCamera()) return;
    // Mutual exclusivity: gaze replaces tilt + volume.
    if (_tiltActive) {
      await TiltScroll.disable();
      if (mounted) setState(() => _tiltActive = false);
    }
    VolumeKeys.disable();
    await prefs.setBool('reader_tilt_enabled', false);
    await prefs.setBool('reader_volume_keys', false);
    await prefs.setBool('reader_gaze_enabled', true);
    await _startGaze(prefs);
  }

  Future<bool> _confirmGazeCamera() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.readerGazeCameraTitle,
            style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Text(t.readerGazeCameraWarning,
            style: GoogleFonts.manrope(fontSize: 13)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.readerCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.readerEnable)),
        ],
      ),
    );
    return ok ?? false;
  }

  void _onGaze(GazeEvent e) {
    if (!mounted) return;
    logger.info(
        'Hands-free: ${e.direction.name} @ ${e.intensity.toStringAsFixed(2)}',
        category: LogCategory.general);
    // Paged modes: one flip per discrete look.
    if (_pageController?.hasClients == true) {
      if (e.direction == GazeDirection.down) {
        _flipPage(1);
      } else if (e.direction == GazeDirection.up) {
        _flipPage(-1);
      }
      return;
    }
    // Continuous modes: fluid scroll loop.
    if (e.direction == GazeDirection.none) {
      _stopGazeScroll();
      return;
    }
    _gazeDelta = e.direction == GazeDirection.down ? 1 : -1;
    _gazeSpeed = _volScrollSpeed * (0.35 + 0.65 * e.intensity.clamp(0.0, 1.0));
    _beginGazeScroll();
  }

  void _beginGazeScroll() {
    const tick = Duration(milliseconds: 100);
    void scrollOnce() {
      if (!mounted || _gazeDelta == 0) return;
      final step = _gazeDelta * _gazeSpeed * (tick.inMilliseconds / 1000.0);
      try {
        _scrollOffsetController.animateScroll(
            offset: step, duration: tick, curve: Curves.linear);
      } catch (_) {}
    }

    scrollOnce();
    _gazeTimer ??= Timer.periodic(tick, (_) {
      if (!mounted || _gazeDelta == 0) {
        _gazeTimer?.cancel();
        _gazeTimer = null;
        return;
      }
      scrollOnce();
    });
  }

  void _stopGazeScroll() {
    _gazeDelta = 0;
    _gazeTimer?.cancel();
    _gazeTimer = null;
  }

  // Tilt-to-scroll reuses the gaze scroll path (mutually exclusive with gaze).
  void _onTilt(TiltEvent e) {
    final dir = e.direction == TiltDirection.down
        ? GazeDirection.down
        : (e.direction == TiltDirection.up
            ? GazeDirection.up
            : GazeDirection.none);
    _onGaze(GazeEvent(dir, e.intensity));
  }

  Future<void> _maybeEnableTilt() async {
    final prefs = SettingsStore.instance;
    if (!(prefs.getBool('beta_features_enabled') ?? false)) return; // hands-free is beta
    if (!(prefs.getBool('reader_tilt_enabled') ?? false)) return;
    await _startTilt(prefs);
  }

  Future<void> _startTilt(SettingsStore prefs) async {
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    TiltScroll.updateSettings(TiltSettings(
      threshold: prefs.getDouble('reader_tilt_threshold') ?? 0.20,
      smoothing: prefs.getDouble('reader_tilt_smoothing') ?? 0.20,
    ));
    await TiltScroll.enable(_onTilt);
    if (mounted) setState(() => _tiltActive = true);
  }

  Future<void> _toggleTilt() async {
    final prefs = SettingsStore.instance;
    if (_tiltActive) {
      await TiltScroll.disable();
      await prefs.setBool('reader_tilt_enabled', false);
      _stopGazeScroll();
      if (mounted) setState(() => _tiltActive = false);
      return;
    }
    // Mutual exclusivity: tilt replaces gaze + volume.
    if (_gazeActive) {
      await GazeScroll.disable();
      await prefs.setBool('reader_gaze_enabled', false);
      if (mounted) setState(() => _gazeActive = false);
    }
    VolumeKeys.disable();
    await prefs.setBool('reader_volume_keys', false);
    await prefs.setBool('reader_tilt_enabled', true);
    await _startTilt(prefs);
  }

  // Long-press the in-reader hands-free toggle → quick options for the active
  // input (sensitivity / speed / mode / recalibrate), applied live.
  Future<void> _openHandsFreeMenu() async {
    if (!_gazeActive && !_tiltActive) return;
    final isGaze = _gazeActive;
    final prefs = SettingsStore.instance;
    if (!mounted) return;
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    double sensitivity = isGaze
        ? (prefs.getDouble('reader_gaze_threshold') ?? 0.8)
        : (prefs.getDouble('reader_tilt_threshold') ?? 0.20);
    double speed = (prefs.getDouble('reader_volume_scroll_speed') ?? 600.0)
        .clamp(150.0, 2000.0);
    String mode = prefs.getString('reader_gaze_mode') ?? 'combined';

    void push() {
      if (isGaze) {
        GazeScroll.updateSettings(GazeSettings(
          mode: mode,
          threshold: sensitivity,
          dwellMs: (prefs.getDouble('reader_gaze_dwell') ?? 300).round(),
          smoothing: prefs.getDouble('reader_gaze_smoothing') ?? 0.25,
          useGeometric: prefs.getBool('reader_gaze_geometric') ?? true,
        ));
      } else {
        TiltScroll.updateSettings(TiltSettings(
          threshold: sensitivity,
          smoothing: prefs.getDouble('reader_tilt_smoothing') ?? 0.20,
        ));
      }
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 16, 20, 16 + MediaQuery.of(sheetCtx).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.readerHandsFreeOptions,
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              Text(t.readerGazeSensitivity,
                  style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
              Slider(
                value: sensitivity,
                min: isGaze ? 0.25 : 0.08,
                max: isGaze ? 0.9 : 0.5,
                onChanged: (v) => setSheet(() => sensitivity = v),
                onChangeEnd: (v) {
                  prefs.setDouble(
                      isGaze ? 'reader_gaze_threshold' : 'reader_tilt_threshold',
                      v);
                  push();
                },
              ),
              Text(t.readerScrollSpeed,
                  style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
              Slider(
                value: speed,
                min: 150,
                max: 2000,
                onChanged: (v) => setSheet(() => speed = v),
                onChangeEnd: (v) {
                  prefs.setDouble('reader_volume_scroll_speed', v);
                  if (mounted) setState(() => _volScrollSpeed = v);
                },
              ),
              if (isGaze) ...[
                Text(t.readerGazeMode,
                    style:
                        GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, children: [
                  for (final m in const ['eyesOnly', 'headOnly', 'combined'])
                    ChoiceChip(
                      label: Text(m == 'eyesOnly'
                          ? 'Eyes'
                          : (m == 'headOnly' ? 'Head' : 'Both')),
                      selected: mode == m,
                      onSelected: (_) {
                        setSheet(() => mode = m);
                        prefs.setString('reader_gaze_mode', m);
                        push();
                      },
                    ),
                ]),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    _recalibrateHandsFree(isGaze);
                  },
                  icon: const Icon(Icons.center_focus_strong_rounded),
                  label: Text(t.readerGazeCalibrate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _recalibrateHandsFree(bool isGaze) {
    final t = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(isGaze ? t.readerGazeCalibrating : t.readerTiltCalibrating),
        duration: const Duration(milliseconds: 1600)));
    if (isGaze) {
      GazeScroll.calibrate(durationMs: 1500);
    } else {
      TiltScroll.calibrate(durationMs: 1200);
    }
  }

  // Per-chapter bookmarks — shared with the detail screen via the same key.
  Future<void> _loadBookmarks() async {
    if (widget.mangaUrl == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(
              'manga_bookmarks_${widget.sourceId}_${widget.mangaUrl}') ??
          const [];
      if (mounted && list.isNotEmpty) {
        setState(() => _bookmarks
          ..clear()
          ..addAll(list));
      }
    } catch (_) {}
  }

  Future<void> _toggleCurrentBookmark() async {
    if (widget.mangaUrl == null) return;
    final chapterUrl = context.read<ReaderProvider>().currentChapterUrl;
    if (chapterUrl.isEmpty) return;
    setState(() {
      if (_bookmarks.contains(chapterUrl)) {
        _bookmarks.remove(chapterUrl);
      } else {
        _bookmarks.add(chapterUrl);
      }
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'manga_bookmarks_${widget.sourceId}_${widget.mangaUrl}';
      if (_bookmarks.isEmpty) {
        await prefs.remove(key);
      } else {
        await prefs.setStringList(key, _bookmarks.toList());
      }
    } catch (_) {}
  }

  // Captured from _updateProgress so dispose can refresh the library's
  // "Continue reading" ONCE on exit — the per-page save no longer notifies.
  LibraryProvider? _libRef;

  @override
  void dispose() {
    // One reload so the library reflects where we left off (progress was saved
    // per-page without notifying, to avoid rebuilding the library each flip).
    _libRef?.reload();
    VolumeKeys.disable();
    GazeScroll.disable();
    TiltScroll.disable();
    _gazeTimer?.cancel();
    _navResetTimer?.cancel();
    _holdTimer?.cancel();
    _holdScrollTimer?.cancel();
    _itemPositionsListener.itemPositions.removeListener(_onPositionChanged);
    _hudController.dispose();
    _pageController?.dispose();
    _scrollController?.dispose();
    _translationAnimController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Back to portrait-only for the rest of the app (matches the player's exit).
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Never leave the wakelock held once the reader is gone.
    if (_wakelockApplied == true) {
      WakelockPlus.disable().catchError((_) {});
    }
    super.dispose();
  }

  /// Enables/disables the OS keep-awake lock to match [on], but only when the
  /// desired state differs from what we last pushed — build() runs on every
  /// frame and the plugin call is a platform round-trip. Wrapped so an
  /// unsupported platform (or a transient failure) can never crash the reader.
  void _applyWakelock(bool on) {
    if (_wakelockApplied == on) return;
    _wakelockApplied = on;
    WakelockPlus.toggle(enable: on).catchError((_) {});
  }

  void _toggleHud(ReaderProvider reader) {
    _initialHudResolved = true; // a screen tap means the user is driving now
    // Don't hide while the user is mid-interaction with a HUD control.
    if (reader.showHud && _isInteracting) return;
    // Flip the source of truth FIRST, then drive the animation to match it. Driving
    // the controller off the OLD state (as before) could leave showHud=true while the
    // fade sat at 0 — the HUD was "shown" but invisible, so a tap appeared to do nothing
    // ("the menu doesn't reappear"). Syncing to the new state makes tap-to-reveal reliable
    // in BOTH the classic bars and the radial wheel (whose visibility follows showHud).
    reader.toggleHud();
    if (reader.showHud) {
      _hudController.forward(); // tap to reveal — stays until next tap or scroll
    } else {
      _hudController.reverse();
    }
  }

  /// Called when a page image finishes loading. The first one to load ends the
  /// "show briefly on entry" phase and hides the HUD — after a short minimum so
  /// it's actually on screen for a beat first.
  void _onPageImageLoaded() {
    if (_initialHudResolved || !mounted) return;
    final elapsed =
        DateTime.now().difference(_enteredAt ?? DateTime.now()).inMilliseconds;
    final wait = elapsed < 700 ? 700 - elapsed : 0;
    Future.delayed(Duration(milliseconds: wait), _resolveInitialHud);
  }

  void _resolveInitialHud() {
    if (_initialHudResolved || !mounted) return;
    _initialHudResolved = true;
    final reader = context.read<ReaderProvider>();
    if (reader.showHud && !_isInteracting) {
      _hudController.reverse();
      reader.toggleHud();
    }
  }

  // Re-hide the HUD a few seconds after the user finishes fiddling with a HUD
  // control (slider/menu). NOT used for a plain screen tap — a tapped-open HUD
  // stays until the next tap or scroll.
  void _scheduleAutoHide(ReaderProvider reader) {
    _initialHudResolved = true;
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && reader.showHud && !_isInteracting) {
        _hudController.reverse();
        reader.toggleHud();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Consumer<ReaderProvider>(
      builder: (_, reader, __) {
        // Sync slider to currentPage once pages are loaded
        if (!_sliderInitialized && reader.pages.isNotEmpty) {
          _sliderInitialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _sliderPage = reader.currentPage);
          });
        }
        // Apply fullscreen pref. Re-issued each build so toggling settings
        // mid-session takes effect on the next rebuild.
        SystemChrome.setEnabledSystemUIMode(reader.settings.fullscreen
            ? SystemUiMode.immersiveSticky
            : SystemUiMode.edgeToEdge);
        // Keep the screen awake while reading if enabled. Guarded so it only
        // hits the plugin when the setting changes.
        _applyWakelock(reader.settings.keepScreenOn);
        final onBg = _onBgFor(reader.settings.bgColor, context);
        _onBg = onBg;
        return Scaffold(
          backgroundColor: _bgColorFor(reader.settings.bgColor, context),
          body: Stack(
            children: [
              // Tap anywhere — even on loading/error/gaps — toggles the controls.
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _toggleHud(reader),
                ),
              ),
              // Page content
              if (reader.isLoading && reader.pages.isEmpty)
                Center(
                  child: CircularProgressIndicator(color: onBg),
                )
              else if (reader.error != null && reader.pages.isEmpty)
                _buildError(reader)
              else
                _buildReader(context, reader),

              // Eye-comfort overlays — above the pages, below the controls, and
              // non-interactive. Warm sepia tint for reduced blue light, plus an
              // in-app dim that can go darker than the system's minimum.
              if (reader.settings.warmTint > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: const Color(0xFFFF9500).withAlpha(
                          (reader.settings.warmTint * 0.40 * 255).round()),
                    ),
                  ),
                ),
              if (reader.settings.brightness < 1.0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: Colors.black.withAlpha(
                          ((1.0 - reader.settings.brightness) * 255)
                              .round()
                              .clamp(0, 217)),
                    ),
                  ),
                ),

              if ((_gazeActive || _tiltActive) && !_radialEnabled)
                PositionedDirectional(
                  top: MediaQuery.of(context).padding.top + 8,
                  end: 12,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                          _gazeActive
                              ? Icons.visibility_rounded
                              : Icons.screen_rotation_rounded,
                          size: 16,
                          color: Colors.white),
                    ),
                  ),
                ),

              // Translation bubbles are now drawn per-page (see _buildPageImage
              // and the paginated itemBuilder) so they ride along with each
              // image as the user scrolls, instead of a single viewport overlay
              // that stayed fixed while the page moved underneath it.

              // A subtle top-of-screen indicator while any page is translating.
              if (_translationEnabled && _isTranslationActive && _isTranslating)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(140),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(
                            width: 12, height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          Text(t.readerTranslating,
                            style: GoogleFonts.manrope(
                              fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                        ]),
                      ),
                    ),
                  ),
                ),

              // Controls: the opt-in radial replaces the classic bars when on.
              if (_radialEnabled)
                Positioned.fill(child: _buildRadial(context, reader, t))
              else if (reader.showHud || _hudController.isAnimating)
                IgnorePointer(
                  ignoring: !reader.showHud,
                  child: FadeTransition(
                    opacity: _hudAnimation,
                    child: _buildHud(context, reader),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Foreground for anything painted directly on the reader background.
  ///
  /// Cached so the page/error builders don't need a BuildContext threaded
  /// through them; set from build() where the background is already resolved.
  /// Defaults to white for the common dark case before the first build.
  Color _onBg = Colors.white;

  Widget _buildError(ReaderProvider reader) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded,
              color: _onBg.withAlpha(190), size: 48),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(reader.error!,
                style: GoogleFonts.manrope(color: _onBg.withAlpha(210), fontSize: 13),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(t.readerBack,
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                    foregroundColor: _onBg.withAlpha(230),
                    side: BorderSide(color: _onBg.withAlpha(90))),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => reader.loadPages(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(t.readerRetry, style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReader(BuildContext context, ReaderProvider reader) {
    switch (reader.readingMode) {
      case ReadingMode.ltr:
      case ReadingMode.rtl:
        return _buildPagedReader(context, reader);
      case ReadingMode.vertical:
      case ReadingMode.webtoon:
        return _buildScrollReader(context, reader);
    }
  }

  Widget _buildPagedReader(BuildContext context, ReaderProvider reader) {
    final screenWidth = MediaQuery.of(context).size.width;
    final s = reader.settings;
    final fit = _boxFitFor(s.scaleType);
    final filter = _imageColorFilter(s);
    final rtl = reader.readingMode == ReadingMode.rtl;

    // Dual-page: two pages side-by-side, only in landscape + a paged mode. The
    // whole reader (controller, nav, slider) then works in "slot" space, where
    // a slot is one or two page indices; in single-page mode every slot is one
    // page, so the slot index equals the page index and behaviour is unchanged.
    final dualActive = s.dualPageLandscape &&
        MediaQuery.of(context).orientation == Orientation.landscape;
    _slots = dualActive
        ? _dualPageSlots(reader, s.dualPageSplitWide)
        : [for (var i = 0; i < reader.pages.length; i++) <int>[i]];
    final curSlot = _slotOfPage(_slots, reader.currentPage);

    _pageController ??= PageController(initialPage: curSlot);
    // On a rotation that flips dual on/off, the controller's page index now
    // points at the wrong slot (the grouping changed) — re-anchor it onto the
    // slot holding the current page so the reader doesn't jump.
    if (_lastDualActive != dualActive) {
      _lastDualActive = dualActive;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController?.hasClients == true &&
            (_pageController!.page ?? 0).round() != curSlot) {
          _pageController!.jumpToPage(curSlot);
        }
      });
    }

    void goPrev() {
      final cur = (_pageController?.page ?? 0).round();
      if (cur > 0) {
        _pageController?.previousPage(
          duration: AppTheme.standard,
          curve: AppTheme.primaryCurve,
        );
      } else if (reader.hasPreviousChapter) {
        reader.goToPreviousChapter();
      }
    }

    void goNext() {
      final cur = (_pageController?.page ?? 0).round();
      if (cur < _slots.length - 1) {
        _pageController?.nextPage(
          duration: AppTheme.standard,
          curve: AppTheme.primaryCurve,
        );
      } else if (reader.hasNextChapter) {
        reader.goToNextChapter();
      }
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          reverse: rtl,
          itemCount: _slots.length,
          onPageChanged: (slot) {
            if (slot < 0 || slot >= _slots.length) return;
            final pages = _slots[slot];
            // Track the furthest page in the spread so progress %, the
            // download-ahead trigger and mark-as-read all fire correctly on the
            // final spread even when it's a pair.
            final lead = pages.last;
            reader.setPage(lead);
            setState(() => _sliderPage = lead);
            _updateProgress(reader, lead);
            _initialHudResolved = true; // swiping ends the entry phase
            if (reader.showHud && !_isInteracting) {
              _hudController.reverse();
              reader.toggleHud();
            }
            // Translate every page that just came into view.
            if (_isTranslationActive) {
              for (final p in pages) {
                _translatePage(p);
              }
            }
            // Auto-preload next chapter when within last 2 pages.
            if (s.autoPreload &&
                !reader.isLoadingNext &&
                !reader.isLastChapter &&
                pages.last >= reader.totalPages - 2) {
              reader.loadNextChapter();
            }
          },
          itemBuilder: (_, slot) {
            final pages = _slots[slot];
            if (pages.length == 1) {
              return GestureDetector(
                onLongPress: () => _showPageMenu(pages.first),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: _pagedPage(reader, pages.first, fit, filter,
                      reportSize: dualActive && s.dualPageSplitWide),
                ),
              );
            }
            // Two-up spread. The PageView is already reversed for RTL, so within
            // the slot the earlier page goes on the right there.
            final a = pages[0], b = pages[1];
            final leftPage = rtl ? b : a;
            final rightPage = rtl ? a : b;
            return InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Row(
                children: [
                  for (final p in [leftPage, rightPage])
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () => _showPageMenu(p),
                        child: _pagedPage(reader, p, fit, filter,
                            reportSize: dualActive && s.dualPageSplitWide),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        // Tap zones — layout/inversion driven by Reader settings.
        if (s.navLayout != 'Disabled')
          _buildTapZones(
            screenWidth: screenWidth,
            navLayout: s.navLayout,
            inverted: s.invertTapZones,
            onPrev: goPrev,
            onNext: goNext,
            onCenter: () => _toggleHud(reader),
          ),
      ],
    );
  }

  /// One page of the paged reader (no gesture wrapper), with the colour filter
  /// and any translation overlay applied — shared by the single-page and
  /// dual-page layouts. [reportSize] wires up the wide-page detector.
  Widget _pagedPage(ReaderProvider reader, int i, BoxFit fit,
      ColorFilter? filter,
      {bool reportSize = false}) {
    final pageUrl = reader.pages[i];
    Widget image = MangaImage(
      imageUrl: pageUrl.url,
      referer: pageUrl.headers?['Referer'],
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      translatedBytes: _isTranslationActive ? _koharuImageCache[i] : null,
      onLoaded: _onPageImageLoaded,
      onSize: reportSize ? (size) => _onPageIntrinsicSize(i, size) : null,
      autoCrop: reader.settings.autoCropBorders,
      placeholder: Center(
        child: CircularProgressIndicator(color: _onBg.withAlpha(150)),
      ),
      // No custom errorWidget → MangaImage's built-in retryable error.
    );
    if (filter != null) {
      image = ColorFiltered(colorFilter: filter, child: image);
    }
    // Overlay bubbles (non-koharu providers draw boxes; koharu bakes the
    // translation into translatedBytes above). The overlay fills the page box
    // and maps normalized bounds into the displayed image rect, so it stays put
    // over the text as the page zooms/pans.
    final bubbles = _pageBubbles[i];
    if (_isTranslationActive &&
        _selectedProviderId != 'koharu' &&
        bubbles != null &&
        bubbles.isNotEmpty) {
      image = Stack(
        fit: StackFit.expand,
        children: [
          image,
          Positioned.fill(
            child: ReaderTranslationOverlay(
              bubbles: bubbles,
              animation: _translationAnimation,
              imageSize: _pageImgSize[i],
              fitWidth: fit == BoxFit.fitWidth,
              showTranslated: _showTranslated,
            ),
          ),
        ],
      );
    }
    return image;
  }

  /// Groups page indices into display "slots" for the dual-page reader. Pages
  /// pair up two-at-a-time, except a known wide double-spread (when [splitWide]
  /// is on) gets its own slot so it isn't squished, and a spread never straddles
  /// a chapter boundary.
  List<List<int>> _dualPageSlots(ReaderProvider reader, bool splitWide) {
    final n = reader.pages.length;
    final slots = <List<int>>[];
    var i = 0;
    while (i < n) {
      if (splitWide && _widePages.contains(i)) {
        slots.add([i]);
        i += 1;
        continue;
      }
      final canPair = i + 1 < n &&
          !(splitWide && _widePages.contains(i + 1)) &&
          reader.getBoundaryAt(i + 1) == null;
      if (canPair) {
        slots.add([i, i + 1]);
        i += 2;
      } else {
        slots.add([i]);
        i += 1;
      }
    }
    return slots;
  }

  int _slotOfPage(List<List<int>> slots, int page) {
    for (var s = 0; s < slots.length; s++) {
      if (slots[s].contains(page)) return s;
    }
    return 0;
  }

  /// A page's real dimensions came back: if it's a wide double-spread, remember
  /// it so the next build regroups it onto its own slot. Only pages ahead of the
  /// current one regroup, so the view the user is on doesn't shift under them.
  void _onPageIntrinsicSize(int i, Size size) {
    if (!mounted || size.height <= 0) return;
    final wide = size.width > size.height;
    if (wide && !_widePages.contains(i)) {
      setState(() => _widePages.add(i));
    } else if (!wide && _widePages.contains(i)) {
      setState(() => _widePages.remove(i));
    }
  }

  Widget _buildTapZones({
    required double screenWidth,
    required String navLayout,
    required bool inverted,
    required VoidCallback onPrev,
    required VoidCallback onNext,
    required VoidCallback onCenter,
  }) {
    // Edge layout = thinner side zones (15% each), bigger center.
    final sideFraction = navLayout == 'Edge' ? 0.15 : 0.25;
    final centerFraction = 1.0 - 2 * sideFraction;
    final leftAction = inverted ? onNext : onPrev;
    final rightAction = inverted ? onPrev : onNext;

    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: leftAction,
          child: SizedBox(
              width: screenWidth * sideFraction, height: double.infinity),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onCenter,
          child: SizedBox(
              width: screenWidth * centerFraction, height: double.infinity),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: rightAction,
          child: SizedBox(
              width: screenWidth * sideFraction, height: double.infinity),
        ),
      ],
    );
  }

  Widget _buildScrollReader(BuildContext context, ReaderProvider reader) {
    final t = AppLocalizations.of(context);
    final itemCount = reader.pages.length + 1;

    return ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        scrollOffsetController: _scrollOffsetController,
        itemPositionsListener: _itemPositionsListener,
        initialScrollIndex: reader.currentPage.clamp(0, reader.pages.length - 1),
        itemCount: itemCount,
        minCacheExtent: 2000,
        itemBuilder: (_, i) {
          // End card (after all loaded pages)
          if (i == reader.pages.length) {
            if (reader.isLoadingNext) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(children: [
                  CircularProgressIndicator(color: _onBg.withAlpha(150)),
                  const SizedBox(height: 16),
                  Text(t.readerLoadingNextChapter,
                      style: GoogleFonts.manrope(fontSize: 13, color: _onBg.withAlpha(165))),
                ]),
              );
            }
            if (reader.isLastChapter) {
              return _buildEndCard(context, isLast: true);
            }
            if (reader.nextChapterError) {
              return _buildEndCard(context, isLast: false, onNext: () {
                reader.loadNextChapter();
              });
            }
            // Auto-loading triggered by _onPositionChanged
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(color: _onBg.withAlpha(120)),
              ),
            );
          }

          // Check if this page index is a chapter boundary — show divider
          final boundary = reader.getBoundaryAt(i);
          if (boundary != null) {
            return Column(
              children: [
                _buildChapterTransition(context, boundary),
                _buildPageImage(reader.pages[i], i),
              ],
            );
          }

          return GestureDetector(
            onTap: () => _toggleHud(reader),
            onLongPress: () => _showPageMenu(i),
            child: _buildPageImage(reader.pages[i], i),
          );
        },
    );
  }


  Widget _buildPageImage(PageUrl pageUrl, int index) {
    final reader = context.read<ReaderProvider>();
    final filter = _imageColorFilter(reader.settings);
    final translatedBytes = _isTranslationActive ? _koharuImageCache[index] : null;

    Widget image;
    // Local file (downloaded chapter)
    if (pageUrl.url.startsWith('file://')) {
      final path = pageUrl.url.replaceFirst('file://', '');
      image = Image.file(
        File(path),
        fit: BoxFit.fitWidth,
        width: double.infinity,
        errorBuilder: (_, __, ___) => SizedBox(
          height: 400,
          child: Center(child: Icon(Icons.broken_image_rounded, color: _onBg.withAlpha(150), size: 48)),
        ),
      );
    } else {
      image = MangaImage(
        imageUrl: pageUrl.url,
        referer: pageUrl.headers?['Referer'],
        fit: BoxFit.fitWidth,
        width: double.infinity,
        translatedBytes: translatedBytes,
        onLoaded: _onPageImageLoaded,
        autoCrop: reader.settings.autoCropBorders,
        placeholder: SizedBox(
          height: 400,
          child: Center(child: CircularProgressIndicator(color: _onBg.withAlpha(150))),
        ),
        // No custom errorWidget → MangaImage shows its built-in retryable error.
      );
    }
    if (filter != null) {
      image = ColorFiltered(colorFilter: filter, child: image);
    }
    // Bubbles ride on top of THIS image. In webtoon mode the image is
    // fit-width with intrinsic height, so the item's box equals the displayed
    // image (no letterbox) — the overlay maps bounds straight onto it. koharu
    // bakes its translation into the bytes, so it needs no overlay.
    final bubbles = _pageBubbles[index];
    if (_isTranslationActive &&
        _selectedProviderId != 'koharu' &&
        bubbles != null &&
        bubbles.isNotEmpty) {
      return Stack(
        children: [
          image,
          Positioned.fill(
            child: ReaderTranslationOverlay(
              bubbles: bubbles,
              animation: _translationAnimation,
              imageSize: _pageImgSize[index],
              fitWidth: true,
              showTranslated: _showTranslated,
            ),
          ),
        ],
      );
    }
    return image;
  }

  Widget _buildChapterTransition(BuildContext context, ChapterBoundary boundary) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      color: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          if (boundary.prevChapterName != null)
            Text(t.readerFinishedChapter(boundary.prevChapterName!),
                style: GoogleFonts.manrope(fontSize: 12, color: _onBg.withAlpha(165)),
                textAlign: TextAlign.center),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              Expanded(child: Divider(color: _onBg.withAlpha(120))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.arrow_downward_rounded, color: cs.primary, size: 20),
              ),
              Expanded(child: Divider(color: _onBg.withAlpha(120))),
            ]),
          ),
          if (boundary.nextChapterName != null)
            Text(boundary.nextChapterName!,
                style: GoogleFonts.manrope(
                    fontSize: 14, fontWeight: FontWeight.w700, color: _onBg.withAlpha(200)),
                textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildEndCard(BuildContext context, {required bool isLast, VoidCallback? onNext}) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(children: [
        Icon(
          isLast ? Icons.check_circle_outline_rounded : Icons.arrow_downward_rounded,
          color: isLast ? Colors.white54 : cs.primary,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          isLast ? t.readerAllCaughtUp : t.readerEndOfChapter,
          style: GoogleFonts.manrope(
              fontSize: 16, fontWeight: FontWeight.w700, color: _onBg.withAlpha(200)),
        ),
        const SizedBox(height: 8),
        if (isLast)
          Text(t.readerLatestChapterAvailable,
              style: GoogleFonts.manrope(fontSize: 13, color: _onBg.withAlpha(165)),
              textAlign: TextAlign.center)
        else if (onNext != null)
          FilledButton.icon(
            icon: const Icon(Icons.skip_next_rounded, size: 20),
            label: Text(t.readerLoadNextChapter,
                style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: onNext,
          ),
      ]),
    );
  }

  // ── HUD ────────────────────────────────────────────────────────────────

  /// Toggle AI translation for the visible pages, clearing per-page caches when
  /// turned off. Shared by the classic bottom bar and the radial menu.
  void _toggleTranslationActive() {
    setState(() {
      _isTranslationActive = !_isTranslationActive;
      if (!_isTranslationActive) {
        _pageBubbles.clear();
        _pageImgSize.clear();
        _pageDone.clear();
        _pageTranslating.clear();
        _koharuImageCache.clear();
        _translationAnimController.reset();
      }
    });
    // Kick off translation for whatever's on screen; scrolling then translates
    // new pages as they come into view.
    if (_isTranslationActive) _translateVisiblePages();
  }

  Widget _buildRadial(
      BuildContext context, ReaderProvider reader, AppLocalizations t) {
    final cs = _chapterSlider(reader);
    return RadialReaderMenu(
      leftSide: _radialLeftSide,
      // The wheel FAB and back button hide while reading, like the classic bars — they
      // fade out on a tap/scroll (showHud false) and back in on the next tap. While the
      // wheel is actually open they stay regardless (handled inside the widget).
      visible: reader.showHud,
      title: widget.mangaTitle ?? t.readerTitle,
      chapter: _chapterLabel(reader).isNotEmpty ? _chapterLabel(reader) : null,
      titleExpanded: reader.showHud,
      onBack: () => Navigator.pop(context),
      page: cs.page,
      totalPages: cs.total,
      onSeek: cs.seek,
      onOpenChanged: (open) {
        // Keep the title pill expanded (and auto-hide paused) while the wheel is
        // up; when it closes, let the controls fade on the usual timer.
        if (open && !reader.showHud) {
          _hudController.forward();
          reader.toggleHud();
        } else if (!open && reader.showHud) {
          _scheduleAutoHide(reader);
        }
      },
      actions: [
        RadialAction(
            icon: Icons.tune_rounded,
            label: t.readerSettings,
            onTap: () => _showSettingsSheet(context, reader)),
        RadialAction(
            icon: _bookmarks.contains(reader.currentChapterUrl)
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            label: t.readerBookmark,
            onTap: _toggleCurrentBookmark),
        RadialAction(
            icon: Icons.keyboard_double_arrow_left_rounded,
            label: t.readerPreviousChapter,
            enabled: reader.hasPreviousChapter,
            onTap: () {
              if (reader.hasPreviousChapter) reader.goToPreviousChapter();
            }),
        RadialAction(
            icon: Icons.keyboard_double_arrow_right_rounded,
            label: t.readerNextChapter,
            enabled: reader.hasNextChapter,
            onTap: () {
              if (reader.hasNextChapter) reader.goToNextChapter();
            }),
        if (_gazeSupported)
          RadialAction(
              icon: _gazeActive
                  ? Icons.visibility_rounded
                  : Icons.visibility_outlined,
              label: t.readerGazeScroll,
              onTap: _toggleGaze)
        else
          RadialAction(
              icon: Icons.screen_rotation_rounded,
              label: t.readerTiltScroll,
              onTap: _toggleTilt),
        if (_translationEnabled)
          RadialAction(
              icon: Icons.translate_rounded,
              label: t.readerAiTranslate,
              onTap: _toggleTranslationActive),
      ],
    );
  }

  Widget _buildHud(BuildContext context, ReaderProvider reader) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _isInteracting = true,
          onTapUp: (_) { _isInteracting = false; _scheduleAutoHide(reader); },
          onTapCancel: () { _isInteracting = false; _scheduleAutoHide(reader); },
          child: _buildTopBar(context, reader),
        ),
        const Spacer(),
        GestureDetector(
          onTapDown: (_) => _isInteracting = true,
          onTapUp: (_) { _isInteracting = false; _scheduleAutoHide(reader); },
          onTapCancel: () { _isInteracting = false; _scheduleAutoHide(reader); },
          child: _buildBottomBar(context, reader),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, ReaderProvider reader) {
    final t = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Colors.transparent],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 8,
        right: 8,
        bottom: 24,
      ),
      child: Row(
        children: [
          _HudButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
            tooltip: t.readerBack,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mangaTitle ?? t.readerTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: reader.settings.fontSize * 0.875,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                ),
                if (_chapterLabel(reader).isNotEmpty)
                  Text(
                    _chapterLabel(reader),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: reader.settings.fontSize * 0.6875,
                      fontWeight: FontWeight.w500,
                      color: _onBg.withAlpha(200),
                    ),
                  ),
              ],
            ),
          ),
          if (_gazeSupported)
            _HudButton(
              icon: _gazeActive
                  ? Icons.visibility_rounded
                  : Icons.visibility_outlined,
              onTap: _toggleGaze,
              onLongPress:
                  (_gazeActive || _tiltActive) ? _openHandsFreeMenu : null,
              tooltip: t.readerGazeScroll,
            )
          else
            _HudButton(
              icon: Icons.screen_rotation_rounded,
              onTap: _toggleTilt,
              onLongPress:
                  (_gazeActive || _tiltActive) ? _openHandsFreeMenu : null,
              tooltip: t.readerTiltScroll,
            ),
          const SizedBox(width: 8),
          _HudButton(
            icon: Icons.tune_rounded,
            onTap: () => _showSettingsSheet(context, reader),
            tooltip: t.readerSettings,
          ),
        ],
      ),
    );
  }

  /// Chapter-scoped page-slider model shared by the classic bottom bar and the
  /// radial dock, so the scrubber only moves within the current chapter (not
  /// across every loaded chapter). [page]/[total] are local to the chapter.
  /// The chapter label for the HUD — the chapter the user is currently on
  /// (derived from the page), falling back to the opened chapter's title.
  String _chapterLabel(ReaderProvider reader) {
    final name = reader.chapterNameForPage(_sliderPage);
    return name.isNotEmpty ? name : (widget.chapterTitle ?? '');
  }

  ({int page, int total, void Function(int) seek}) _chapterSlider(
      ReaderProvider reader) {
    final r = reader.chapterRangeForPage(_sliderPage);
    final total = (r.end - r.start).clamp(1, 1 << 30);
    final page = (_sliderPage - r.start).clamp(0, total - 1);
    return (
      page: page,
      total: total,
      seek: (localPage) {
        final global = (r.start + localPage).clamp(0, reader.totalPages - 1);
        setState(() => _sliderPage = global);
        reader.setPage(global);
        _jumpToPage(reader, global);
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ReaderProvider reader) {
    final cs = _chapterSlider(reader);
    final t = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xCC000000), Colors.transparent],
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 12,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        children: [
          // Page slider
          if (reader.totalPages > 0)
            Row(
              children: [
                if (reader.settings.showPageNumber)
                  Text(
                    '${cs.page + 1}',
                    style: GoogleFonts.manrope(
                      fontSize: reader.settings.fontSize * 0.75,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Theme.of(context).colorScheme.primary,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      value: cs.page.toDouble().clamp(0, (cs.total - 1).toDouble()),
                      min: 0,
                      max: (cs.total - 1).toDouble().clamp(1, double.infinity),
                      divisions: cs.total > 1 ? cs.total - 1 : 1,
                      onChangeStart: (_) => _isInteracting = true,
                      onChanged: (value) => cs.seek(value.round()),
                      onChangeEnd: (_) {
                        _isInteracting = false;
                        _scheduleAutoHide(reader);
                      },
                    ),
                  ),
                ),
                if (reader.settings.showPageNumber)
                  Text(
                    '${cs.total}',
                    style: GoogleFonts.manrope(
                      fontSize: reader.settings.fontSize * 0.75,
                      fontWeight: FontWeight.w700,
                      color: _onBg.withAlpha(200),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          // AI Translation toggle + provider (hidden if disabled in settings)
          if (_translationEnabled) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _toggleTranslationActive,
                child: AnimatedContainer(
                  duration: AppTheme.standard,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isTranslationActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white.withAlpha(38),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    border: Border.all(
                      color: _isTranslationActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white38, width: 1),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (_isTranslating)
                      const SizedBox(width: 14, height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white)))
                    else
                      Icon(Icons.translate_rounded, size: 14,
                          color: _isTranslationActive ? Colors.white : Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      _isTranslating ? t.readerTranslating : t.readerAiTranslate,
                      style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700,
                          color: _isTranslationActive ? Colors.white : Colors.white70),
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showProviderSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(31),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(_selectedProviderName,
                          style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: _onBg.withAlpha(200))),
                      const SizedBox(width: 3),
                      Icon(Icons.expand_more_rounded, size: 13, color: _onBg.withAlpha(150)),
                    ]),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Chapter navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HudButton(
                icon: Icons.skip_previous_rounded,
                onTap: reader.hasPreviousChapter
                    ? () => reader.goToPreviousChapter()
                    : () {},
                tooltip: t.readerPreviousChapter,
                size: 20,
              ),
              const SizedBox(width: 24),
              _HudButton(
                icon: _bookmarks.contains(reader.currentChapterUrl)
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                onTap: _toggleCurrentBookmark,
                tooltip: t.readerBookmark,
                size: 18,
              ),
              const SizedBox(width: 24),
              _HudButton(
                icon: Icons.skip_next_rounded,
                onTap: reader.hasNextChapter
                    ? () => reader.goToNextChapter()
                    : () {},
                tooltip: t.readerNextChapter,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Translate every page currently visible on screen. Works for both readers:
  /// webtoon exposes visible indices via [_itemPositionsListener]; paginated
  /// has one page, so we fall back to [ReaderProvider.currentPage].
  void _translateVisiblePages() {
    if (!_isTranslationActive || !_translationEnabled) return;
    final reader = context.read<ReaderProvider>();
    if (reader.pages.isEmpty) return;

    final indices = <int>{};
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      for (final p in positions) {
        if (p.index >= 0 && p.index < reader.pages.length) indices.add(p.index);
      }
    }
    if (indices.isEmpty) {
      indices.add(reader.currentPage.clamp(0, reader.pages.length - 1));
    }
    for (final i in indices) {
      _translatePage(i);
    }
  }

  /// Translate a single page and store the result keyed by [index]. Guarded so
  /// each page is fetched/OCR'd at most once — repeated scroll callbacks are
  /// cheap no-ops. On failure the page is still marked done (no retry storm).
  Future<void> _translatePage(int index) async {
    final reader = context.read<ReaderProvider>();
    if (index < 0 || index >= reader.pages.length) return;
    if (_pageDone.contains(index) || _pageTranslating.contains(index)) return;

    setState(() => _pageTranslating.add(index));

    try {
      final page = reader.pages[index];
      // Fetch via the shared image pipeline (ImageLoader) so it reuses the
      // already-cached page bytes, the pooled client, and the same TLS handling
      // the reader uses — instead of spinning up (and binning) a fresh rhttp
      // client per page, which also re-downloaded the image and failed on the
      // broken-cert CDNs.
      final imageBytes = await _pageBytes(page);
      if (imageBytes == null) {
        if (mounted) setState(() => _pageTranslating.remove(index));
        return;
      }

      // Natural pixel size drives the overlay's letterbox math in paginated
      // (fit-contain) mode. Best-effort; null just means "assume fills box".
      final imgSize = await _decodeImageSize(imageBytes);

      if (_selectedProviderId == 'koharu') {
        final prefs = await SharedPreferences.getInstance();
        final targetLang = prefs.getString('ai_target_language') ?? 'en';
        final translated = await _koharuService.translatePage(
          imageBytes,
          targetLang: targetLang,
          translator: 'google',
        );
        if (mounted) {
          setState(() {
            _koharuImageCache[index] = translated;
            if (imgSize != null) _pageImgSize[index] = imgSize;
            _pageTranslating.remove(index);
            _pageDone.add(index);
          });
        }
        return;
      }

      final cacheKey = '${widget.sourceId}_$index';
      final result = await _translationService.translatePage(imageBytes, cacheKey: cacheKey);

      if (mounted) {
        setState(() {
          _pageBubbles[index] = result.regions.map((r) => TranslationBubble(
            id: '${r.x}_${r.y}',
            bounds: Rect.fromLTWH(r.x, r.y, r.w, r.h),
            originalText: r.originalText,
            translatedText: r.translatedText,
            isTranslated: true,
          )).toList();
          if (imgSize != null) _pageImgSize[index] = imgSize;
          _pageTranslating.remove(index);
          _pageDone.add(index);
        });
        _translationAnimController.forward(from: 0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _pageTranslating.remove(index);
          _pageDone.add(index); // don't hammer a page that keeps failing
        });
        // Only surface the error for the page the user is actually looking at,
        // so background scroll prefetch can't spam snackbars.
        if (index == reader.currentPage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).readerTranslationFailed(e)), duration: const Duration(seconds: 3)));
        }
      }
    }
  }

  /// Decode just the dimensions of an encoded image. Returns null on failure.
  Future<Size?> _decodeImageSize(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final size = Size(image.width.toDouble(), image.height.toDouble());
      image.dispose();
      codec.dispose();
      return size;
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadProviderName() async {
    final name = await ReaderTranslationProviderSheet.getProviderName();
    final prefs = await SharedPreferences.getInstance();
    // Default OFF to match Settings > AI (which also defaults false). The old
    // `?? true` here meant the reader showed the Translate button even when the
    // setting read as disabled — the feature must be opt-in.
    // AI translation is a beta feature — off unless beta is enabled too.
    final enabled = (SettingsStore.instance.getBool('beta_features_enabled') ?? false) &&
        (prefs.getBool('ai_translation_enabled') ?? false);
    final id = prefs.getString('ai_provider') ?? 'gemini';
    if (mounted) setState(() { _selectedProviderName = name; _translationEnabled = enabled; _selectedProviderId = id; });
  }

  void _showProviderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => ReaderTranslationProviderSheet(
        onChanged: () => _loadProviderName(),
      ),
    );
  }

  // ── Long-press page menu: Share / Save / Set as cover / Recognize text ──────

  /// Bytes for a page — the in-memory cache (what MangaImage already loaded) for
  /// remote pages, or disk for downloaded (`file://`) pages.
  Future<Uint8List?> _pageBytes(PageUrl p) async {
    try {
      if (p.url.startsWith('file://')) {
        return await File(p.url.replaceFirst('file://', '')).readAsBytes();
      }
      final referer = p.headers?['Referer'];
      return await ImageLoader()
          .loadImage(p.url, headers: referer != null ? {'Referer': referer} : null);
    } catch (e) {
      logger.error('Page bytes load failed: $e', category: LogCategory.general);
      return null;
    }
  }

  void _pageToast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showPageMenu(int index) {
    final reader = context.read<ReaderProvider>();
    if (index < 0 || index >= reader.pages.length) return;
    final page = reader.pages[index];
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: cs.outline.withAlpha(77),
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            _pageMenuTile(cs, Icons.ios_share_rounded, t.readerPageShare, () {
              Navigator.pop(sheetCtx);
              _sharePage(page);
            }),
            _pageMenuTile(cs, Icons.download_rounded, t.readerPageSave, () {
              Navigator.pop(sheetCtx);
              _savePage(page);
            }),
            _pageMenuTile(cs, Icons.image_rounded, t.readerPageSetCover, () {
              Navigator.pop(sheetCtx);
              _setPageAsCover(page);
            }),
            _pageMenuTile(cs, Icons.text_fields_rounded, t.readerPageRecognizeText,
                () {
              Navigator.pop(sheetCtx);
              _recognizePageText(page);
            }),
          ]),
        ),
      ),
    );
  }

  Widget _pageMenuTile(
      ColorScheme cs, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Row(children: [
          Icon(icon, size: 22, color: cs.primary),
          const SizedBox(width: 16),
          Text(label,
              style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface)),
        ]),
      ),
    );
  }

  Future<void> _sharePage(PageUrl page) async {
    final t = AppLocalizations.of(context);
    final bytes = await _pageBytes(page);
    if (bytes == null) {
      _pageToast(t.readerPageImageUnavailable);
      return;
    }
    try {
      final dir = await getTemporaryDirectory();
      final f = File(
          '${dir.path}/share_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await f.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(f.path, mimeType: 'image/jpeg')]);
    } catch (e) {
      logger.error('Share page failed: $e', category: LogCategory.general);
    }
  }

  Future<void> _savePage(PageUrl page) async {
    final t = AppLocalizations.of(context);
    final bytes = await _pageBytes(page);
    if (bytes == null) {
      _pageToast(t.readerPageImageUnavailable);
      return;
    }
    try {
      await Gal.putImageBytes(bytes, album: 'Foxlations');
      _pageToast(t.readerPageSaved);
    } catch (e) {
      logger.error('Save page failed: $e', category: LogCategory.general);
      _pageToast(t.readerPageSaveFailed);
    }
  }

  Future<void> _setPageAsCover(PageUrl page) async {
    final t = AppLocalizations.of(context);
    if (widget.mangaUrl == null) {
      _pageToast(t.readerPageCoverNeedsLibrary);
      return;
    }
    final bytes = await _pageBytes(page);
    if (bytes == null) {
      _pageToast(t.readerPageImageUnavailable);
      return;
    }
    try {
      final dir = await getApplicationDocumentsDirectory();
      final coversDir = Directory('${dir.path}/covers');
      if (!await coversDir.exists()) await coversDir.create(recursive: true);
      final f = File(
          '${coversDir.path}/${widget.sourceId}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await f.writeAsBytes(bytes);
      if (!mounted) return;
      final ok = await context
          .read<LibraryProvider>()
          .setCover(widget.sourceId, widget.mangaUrl!, f.path);
      _pageToast(ok ? t.readerPageCoverSet : t.readerPageCoverNeedsLibrary);
    } catch (e) {
      logger.error('Set cover failed: $e', category: LogCategory.general);
    }
  }

  Future<void> _recognizePageText(PageUrl page) async {
    final t = AppLocalizations.of(context);
    final bytes = await _pageBytes(page);
    if (bytes == null) {
      _pageToast(t.readerPageImageUnavailable);
      return;
    }
    var text = '';
    try {
      final dir = await getTemporaryDirectory();
      final f =
          File('${dir.path}/ocr_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await f.writeAsBytes(bytes);
      final recognizer = TextRecognizer(script: _ocrScriptForSource());
      try {
        final result =
            await recognizer.processImage(InputImage.fromFilePath(f.path));
        text = result.blocks.map((b) => b.text).join('\n').trim();
      } finally {
        recognizer.close();
        try {
          await f.delete();
        } catch (_) {}
      }
    } catch (e) {
      logger.error('OCR failed: $e', category: LogCategory.general);
    }
    if (!mounted) return;
    _showOcrResult(text);
  }

  TextRecognitionScript _ocrScriptForSource() {
    String? lang;
    try {
      lang = context
          .read<SourceProvider>()
          .getInstalledSource(widget.sourceId)
          ?.source
          .lang;
    } catch (_) {}
    switch ((lang ?? '').toLowerCase()) {
      case 'ja':
        return TextRecognitionScript.japanese;
      case 'ko':
        return TextRecognitionScript.korean;
      case 'zh':
      case 'zh-hans':
      case 'zh-hant':
        return TextRecognitionScript.chinese;
      default:
        return TextRecognitionScript.latin;
    }
  }

  void _showOcrResult(String text) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final hasText = text.trim().isNotEmpty;
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(t.readerPageOcrTitle,
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700, color: cs.onSurface)),
        content: SingleChildScrollView(
          child: SelectableText(
            hasText ? text : t.readerPageOcrEmpty,
            style: GoogleFonts.manrope(
                fontSize: 14, color: hasText ? cs.onSurface : cs.outline),
          ),
        ),
        actions: [
          if (hasText)
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
                Navigator.pop(dctx);
                _pageToast(
                    AppLocalizations.of(context).setxAdvancedCopiedToClipboard);
              },
              child: Text(t.readerPageOcrCopy),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: Text(MaterialLocalizations.of(dctx).closeButtonLabel),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, ReaderProvider reader) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (sheetCtx, setSheet) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetCtx).size.height * 0.85,
        ),
        child: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 32 + MediaQuery.of(sheetCtx).viewPadding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outline.withAlpha(77),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(t.readerReadingMode,
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.w700, color: cs.onSurface)),
            const SizedBox(height: 12),
            ...ReadingMode.values.map((mode) {
              final isSelected = mode == reader.readingMode;
              return GestureDetector(
                onTap: () {
                  reader.setReadingMode(mode);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withAlpha(26)
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Theme.of(context).colorScheme.primary : cs.outlineVariant,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _modeIcon(mode),
                        size: 20,
                        color: isSelected ? Theme.of(context).colorScheme.primary : cs.outline,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_modeLabel(mode),
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Theme.of(context).colorScheme.primary : cs.onSurface,
                                )),
                            Text(_modeSubtitle(mode),
                                style: GoogleFonts.manrope(
                                    fontSize: 11, color: cs.outline)),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded,
                            size: 20, color: cs.primary),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.blur_circular_rounded, size: 20, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(t.readerRadialMenu,
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface))),
              Switch(
                  value: _radialEnabled,
                  onChanged: (v) {
                    _setRadialEnabled(v);
                    setSheet(() {});
                  }),
            ]),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Eye comfort',
                  style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.outline)),
            ),
            Row(children: [
              Icon(Icons.wb_twilight_rounded, size: 20, color: AppTheme.warning),
              const SizedBox(width: 10),
              SizedBox(
                  width: 72,
                  child: Text('Warm',
                      style: GoogleFonts.manrope(
                          fontSize: 13, color: cs.onSurface))),
              Expanded(
                child: Slider(
                  value: reader.settings.warmTint.clamp(0.0, 1.0),
                  min: 0,
                  max: 1,
                  divisions: 10,
                  onChanged: (v) {
                    reader.setEyeComfort(warmTint: v);
                    setSheet(() {});
                  },
                  onChangeEnd: (_) => reader.saveEyeComfort(),
                ),
              ),
            ]),
            Row(children: [
              Icon(Icons.brightness_6_rounded, size: 20, color: AppTheme.warning),
              const SizedBox(width: 10),
              SizedBox(
                  width: 72,
                  child: Text('Brightness',
                      style: GoogleFonts.manrope(
                          fontSize: 13, color: cs.onSurface))),
              Expanded(
                child: Slider(
                  value: reader.settings.brightness.clamp(0.15, 1.0),
                  min: 0.15,
                  max: 1,
                  divisions: 17,
                  onChanged: (v) {
                    reader.setEyeComfort(brightness: v);
                    setSheet(() {});
                  },
                  onChangeEnd: (_) => reader.saveEyeComfort(),
                ),
              ),
            ]),
          ],
        ),
      ),
      ),
      ),
      ),
    );
  }

  Future<void> _setRadialEnabled(bool v) async {
    setState(() => _radialEnabled = v);
    await SettingsStore.instance.setBool('reader_radial_enabled', v);
  }

  void _jumpToPage(ReaderProvider reader, int page) {
    if (reader.readingMode == ReadingMode.ltr ||
        reader.readingMode == ReadingMode.rtl) {
      if (_pageController?.hasClients == true) {
        // The controller is in slot space; map the target page onto its slot
        // (identity outside dual-page mode).
        _pageController!.jumpToPage(
            _slots.isNotEmpty ? _slotOfPage(_slots, page) : page);
      }
    } else {
      // Use ScrollablePositionedList's precise item-based scrolling
      if (_itemScrollController.isAttached) {
        _itemScrollController.jumpTo(index: page);
      }
    }
    _updateProgress(reader, page);
  }

  void _updateProgress(ReaderProvider reader, int page) {
    if (widget.mangaUrl == null) return;
    try {
      final libraryProvider = context.read<LibraryProvider>();
      _libRef = libraryProvider; // for the single refresh on dispose
      libraryProvider.updateReadingProgress(
        widget.sourceId,
        widget.mangaUrl!,
        reader.currentChapterUrl,
        page,
      );
      // Download Ahead While Reading: once the user is committed to a
      // chapter (~30% in), queue the next chapter for download. The
      // DownloadProvider deduplicates against in-flight + already downloaded.
      final dl = context.read<DownloadProvider>();
      if (dl.downloadWhileReading &&
          reader.totalPages > 0 &&
          page >= (reader.totalPages * 0.3).floor()) {
        // Queue the next N chapters (DownloadProvider dedupes against in-flight
        // + already-downloaded, so re-queuing is cheap).
        for (final next in reader.nextChaptersInfo(dl.downloadAheadCount)) {
          if ((next['url'] ?? '').isEmpty) continue;
          dl.enqueueChapter(
            sourceId: widget.sourceId,
            mangaUrl: widget.mangaUrl!,
            mangaTitle: widget.mangaTitle ?? '',
            chapterUrl: next['url']!,
            chapterName: next['name'] ?? '',
          );
        }
      }
      // Mark chapter as read when reaching the last page. Skipped in incognito
      // (the manual "mark as read" on the detail screen still works — only this
      // automatic, reading-driven one is suppressed). _syncTracking is a no-op
      // in incognito too (guarded in TrackingProvider.syncChapterRead).
      if (page >= reader.totalPages - 1) {
        if (!IncognitoProvider.active) {
          libraryProvider.markChapterRead(
            widget.sourceId,
            widget.mangaUrl!,
            reader.currentChapterUrl,
          );
        }
        _syncTracking(reader);
        _applyAutoDeleteRules(reader, dl);
      }
    } catch (e, s) {
      logger.error('Reader progress/mark-read/tracker step failed',
          category: LogCategory.general, detail: '$e\n$s');
    }
  }

  /// Push the just-read chapter's number to any connected trackers bound to
  /// this manga. Fire-and-forget; never interrupts reading.
  void _syncTracking(ReaderProvider reader) {
    if (widget.mangaUrl == null) return;
    try {
      final name = reader.currentChapterName.isNotEmpty
          ? reader.currentChapterName
          : (widget.chapterTitle ?? '');
      final n = _chapterNumberOf(name);
      if (n <= 0) return;
      context
          .read<TrackingProvider>()
          .syncChapterRead('${widget.sourceId}_${widget.mangaUrl}', n);
    } catch (_) {}
  }

  /// Best-effort parse of a chapter number from its title (e.g. "Chapter 45.5"
  /// -> 45). Prefers a number after chapter/ch/ep, else the last number found.
  int _chapterNumberOf(String name) {
    final labeled = RegExp(
            r'(?:chapter|chap|ch|episode|ep|#)\s*[.:]?\s*(\d+(?:\.\d+)?)',
            caseSensitive: false)
        .firstMatch(name);
    String? numStr = labeled?.group(1);
    if (numStr == null) {
      final all = RegExp(r'\d+(?:\.\d+)?').allMatches(name).toList();
      if (all.isNotEmpty) numStr = all.last.group(0);
    }
    if (numStr == null) return 0;
    return (double.tryParse(numStr) ?? 0).floor();
  }

  /// Honors `Delete After Reading`, `Auto-Delete Read Chapters`, and
  /// `Include Bookmarked Chapters` from the Downloads settings page. Called
  /// once the current chapter has been marked as read.
  Future<void> _applyAutoDeleteRules(
      ReaderProvider reader, DownloadProvider dl) async {
    if (widget.mangaUrl == null || (widget.mangaTitle ?? '').isEmpty) return;
    final mangaTitle = widget.mangaTitle!;

    // If this manga is bookmarked and the user hasn't opted into deleting
    // bookmarked chapters, skip both delete rules entirely.
    if (!dl.removeBookmarked) {
      final prefs = await SharedPreferences.getInstance();
      final bookmarks =
          (prefs.getStringList(kBookmarkedMangaIdsKey) ?? []).toSet();
      final mangaKey = '${widget.sourceId}::${widget.mangaUrl}';
      if (bookmarks.contains(mangaKey)) return;
    }

    // 1) Delete the just-read chapter outright if the user opted in.
    if (dl.deleteAfterRead) {
      final currentName = _safeChapterName(reader, reader.currentChapterIndex);
      if (currentName.isNotEmpty &&
          dl.isDownloaded(widget.sourceId, reader.currentChapterUrl)) {
        await dl.deleteDownload(
          widget.sourceId,
          mangaTitle,
          currentName,
          reader.currentChapterUrl,
        );
      }
    }

    // 2) Auto-delete the chapter that's `threshold` positions back, keeping
    //    a sliding window of the most recent reads on disk.
    final threshold = dl.autoDeleteThreshold;
    if (threshold > 0) {
      final old = reader.chapterAtOffset(threshold);
      if (old != null && old['url']!.isNotEmpty) {
        if (dl.isDownloaded(widget.sourceId, old['url']!)) {
          await dl.deleteDownload(
            widget.sourceId,
            mangaTitle,
            old['name'] ?? '',
            old['url']!,
          );
        }
      }
    }
  }

  String _safeChapterName(ReaderProvider reader, int idx) {
    if (idx < 0 || idx >= reader.chaptersCount) return '';
    return reader.chapterAtOffset(reader.currentChapterIndex - idx)?['name'] ?? '';
  }

  // ── Settings helpers ──────────────────────────────────────────────────

  /// Foreground for overlays drawn straight onto the reader background.
  ///
  /// The background is user-selectable and can be **white**, so the hardcoded
  /// `Colors.white` spinners, error text and placeholders these replace were
  /// invisible (1:1 contrast) for anyone using the White or light Automatic
  /// theme. Derive from the actual background instead.
  Color _onBgFor(String name, BuildContext context) =>
      ThemeData.estimateBrightnessForColor(_bgColorFor(name, context)) ==
              Brightness.dark
          ? Colors.white
          : Colors.black87;

  Color _bgColorFor(String name, BuildContext context) {
    switch (name) {
      case 'White':
        return Colors.white;
      case 'Gray':
        return const Color(0xFF1A1A1A);
      case 'Automatic':
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white;
      case 'Black':
      default:
        return Colors.black;
    }
  }

  BoxFit _boxFitFor(String name) {
    switch (name) {
      case 'Stretch':
        return BoxFit.fill;
      case 'Fit Width':
        return BoxFit.fitWidth;
      case 'Fit Height':
        return BoxFit.fitHeight;
      case 'Original Size':
        return BoxFit.none;
      case 'Smart Fit':
        return BoxFit.contain;
      case 'Fit Screen':
      default:
        return BoxFit.contain;
    }
  }

  /// Returns a ColorFilter that applies grayscale and/or invert as configured,
  /// or null if neither is enabled.
  ColorFilter? _imageColorFilter(ReaderSettings s) {
    final filters = <List<double>>[];
    if (s.grayscale) {
      filters.add(const [
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0,      0,      0,      1, 0,
      ]);
    }
    if (s.invertColors) {
      filters.add(const [
        -1, 0, 0, 0, 255,
        0, -1, 0, 0, 255,
        0, 0, -1, 0, 255,
        0, 0, 0, 1, 0,
      ]);
    }
    if (filters.isEmpty) return null;
    if (filters.length == 1) return ColorFilter.matrix(filters.first);
    // Compose: invert ∘ grayscale (apply grayscale first, then invert)
    return ColorFilter.matrix(_composeMatrices(filters[0], filters[1]));
  }

  /// 4x5 color matrix multiplication (b applied after a).
  List<double> _composeMatrices(List<double> a, List<double> b) {
    final out = List<double>.filled(20, 0);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 5; col++) {
        var sum = 0.0;
        for (var k = 0; k < 4; k++) {
          sum += b[row * 5 + k] * a[k * 5 + col];
        }
        if (col == 4) sum += b[row * 5 + 4];
        out[row * 5 + col] = sum;
      }
    }
    return out;
  }

  String _modeLabel(ReadingMode mode) => switch (mode) {
        ReadingMode.ltr => AppLocalizations.of(context).readerModeLtrLabel,
        ReadingMode.rtl => AppLocalizations.of(context).readerModeRtlLabel,
        ReadingMode.vertical => AppLocalizations.of(context).readerModeVerticalLabel,
        ReadingMode.webtoon => AppLocalizations.of(context).readerModeWebtoonLabel,
      };

  String _modeSubtitle(ReadingMode mode) => switch (mode) {
        ReadingMode.ltr => AppLocalizations.of(context).readerModeLtrSubtitle,
        ReadingMode.rtl => AppLocalizations.of(context).readerModeRtlSubtitle,
        ReadingMode.vertical => AppLocalizations.of(context).readerModeVerticalSubtitle,
        ReadingMode.webtoon => AppLocalizations.of(context).readerModeWebtoonSubtitle,
      };

  IconData _modeIcon(ReadingMode mode) => switch (mode) {
        ReadingMode.ltr => Icons.auto_stories_rounded,
        ReadingMode.rtl => Icons.menu_book_rounded,
        ReadingMode.vertical => Icons.swap_vert_rounded,
        ReadingMode.webtoon => Icons.view_day_rounded,
      };
}

// ── HUD Button ─────────────────────────────────────────────────────────

class _HudButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String tooltip;
  final double size;

  const _HudButton({
    required this.icon,
    required this.onTap,
    this.onLongPress,
    required this.tooltip,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          splashColor: Colors.white24,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Icon(icon, size: size, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
