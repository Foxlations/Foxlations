import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../core/providers/vault_provider.dart';
import '../../core/providers/library_like.dart';
import '../../core/providers/tracking_provider.dart';
import '../../core/providers/download_provider.dart';
import '../../core/providers/incognito_provider.dart';
import '../library_screen/library_screen.dart' show kBookmarkedMangaIdsKey;
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../widgets/manga_image.dart';
import '../widgets/type_toggle.dart';
import 'widgets/reader_translation_provider_sheet.dart';
import 'widgets/reader_translation_overlay.dart';
import 'widgets/radial_reader_menu.dart';
import 'widgets/reader_save_throttle.dart';
import 'widgets/radial_config.dart';
import '../../core/services/ai_translation_service.dart';
import '../../core/services/koharu_service.dart';
import '../../core/services/volume_keys.dart';
import '../../core/services/gaze_scroll_service.dart';
import '../../core/services/tilt_scroll_service.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/read_time_tracker.dart';
import '../../core/services/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reader_color_filters.dart';
import 'widgets/reader_zoom_view.dart';
import 'widgets/marquee_text.dart';

part 'reader_screen_translation.dart';
part 'reader_screen_handsfree.dart';

class ReaderScreen extends StatelessWidget {
  final String chapterUrl;
  final String sourceId;
  final String? mangaUrl;
  final String? chapterTitle;
  final String? mangaTitle;
  final List<Map<String, dynamic>>? chapters;
  final int currentIndex;
  final int startPage;

  /// True when reading a VAULT title - routes progress/read-marks to the vault.
  final bool isVault;

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
    this.isVault = false,
  });

  @override
  Widget build(BuildContext context) {
    final sourceProvider = context.read<SourceProvider>();
    final installed = sourceProvider.resolveInstalled(sourceId);

    if (installed == null) {
      final t = AppLocalizations.of(context);
      final cs = Theme.of(context).colorScheme;
      return Scaffold(
        // A plain Center had no way back out - the user was stuck on a black
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.readerSourceNotInstalledHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        mangaUrl: mangaUrl ?? '',
        chapters: chapters,
        currentIndex: currentIndex,
        startPage: startPage,
      )..loadPages(),
      child: _ReaderBody(
        sourceId: sourceId,
        mangaUrl: mangaUrl,
        chapterUrl: chapterUrl,
        chapterTitle: chapterTitle,
        mangaTitle: mangaTitle,
        startPage: startPage,
        isVault: isVault,
      ),
    );
  }
}

class _ReaderBody extends StatefulWidget {
  final String sourceId;
  final String? mangaUrl;
  final String chapterUrl;
  final String? chapterTitle;
  final String? mangaTitle;
  final int startPage;
  final bool isVault;

  const _ReaderBody({
    required this.sourceId,
    this.mangaUrl,
    required this.chapterUrl,
    this.chapterTitle,
    this.mangaTitle,
    this.startPage = 0,
    this.isVault = false,
  });

  @override
  State<_ReaderBody> createState() => _ReaderBodyState();
}

class _ReaderBodyState extends State<_ReaderBody>
    with TickerProviderStateMixin, WidgetsBindingObserver, _ReaderTranslation, _ReaderHandsFree {
  late final AnimationController _hudController;
  late final Animation<double> _hudAnimation;
  @override
  PageController? _pageController;
  ScrollController? _scrollController;
  // Positioned list for accurate page tracking in vertical scroll mode
  final ItemScrollController _itemScrollController = ItemScrollController();
  @override
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  // Relative pixel scrolling for volume-key smooth scroll in continuous modes.
  @override
  final ScrollOffsetController _scrollOffsetController = ScrollOffsetController();
  bool _isInteracting = false; // User is touching HUD elements
  // Last first-visible position, to tell a real scroll from a spurious itemPositions
  // re-emit (layout passes, e.g. the rebuild when a tap reveals the HUD).
  int? _lastFirstIndex;
  double? _lastLeadingEdge;
  // HUD shows briefly on entry, then hides once the first page image loads.
  // Once the user taps/scrolls (or the fallback fires), the initial phase is
  // "resolved" and the HUD is purely tap/scroll-driven after that.
  bool _initialHudResolved = false;
  DateTime? _enteredAt;
  // Last wakelock state we pushed to the OS, so build() only calls the plugin
  // when the "Keep Screen On" setting actually changes rather than every frame.
  bool? _wakelockApplied;
  // Accumulates ACTIVE read time per title for Reading Insights. Pinged on page
  // turns / HUD taps; idles out when untouched or backgrounded.
  ReadTimeTracker? _timeTracker;

  // Dual-page (landscape) reader: the current page→slot grouping, the pages
  // detected as wide double-spreads (shown on their own when split-wide is on),
  // and whether dual-page was active on the previous build (so a rotation that
  // flips the mode can re-anchor the controller onto the right spread).
  List<List<int>> _slots = const [];
  final Set<int> _widePages = {};
  // Pages that came back much taller than wide - long-strip manhua / webtoon
  // pages that slipped into a paged mode. Never squeeze them into half a
  // spread; always give them their own slot (a safety net so dual-page in
  // landscape degrades gracefully for vertical-strip content).
  final Set<int> _tallPages = {};
  // A regroup (dual toggled by a rotation, the shift flag flipped, or a wide/
  // tall page just detected) changed the slot grouping, so the PageController
  // must be re-anchored onto the slot that still holds the current page.
  bool _regroupPending = false;
  // Per-manga "shift double pages": flips the spread parity (cover solo vs.
  // cover paired) for manga whose two-page spreads land split by default.
  bool _dualShift = false;
  bool? _lastDualActive;

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
    // Flush the within-page scroll position when the app backgrounds.
    WidgetsBinding.instance.addObserver(this);

    // Precise within-page resume (continuous mode): the saved scroll fraction
    // for the chapter we're opening, applied to the resume page once its image
    // lays out. Absent / ~0 → land at the page top, as before.
    _pendingResumePage = widget.startPage;
    final savedFrac = SettingsStore.instance
        .getDouble('reader_pagefrac_${widget.sourceId}_${widget.chapterUrl}');
    if (savedFrac != null && savedFrac > 0.01) {
      _pendingResumeFrac = savedFrac;
      // Safety net: if the target page never reports loaded (error / wrong
      // index), stop waiting so we don't retry forever.
      Future.delayed(const Duration(seconds: 6),
          () => _pendingResumeFrac = null);
    }

    // Load AI provider and show HUD briefly on open.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reader = context.read<ReaderProvider>();
      _hudController.forward();
      reader.toggleHud();
      _enteredAt = DateTime.now();
      // Fallback: if no page image ever reports loaded (e.g. all error out),
      // still end the entry phase so the HUD doesn't sit there forever.
      Future.delayed(const Duration(seconds: 5), _resolveInitialHud);
      _loadProviderName();
    });
    // Volume-button page navigation (Android, opt-in). Only while a reader is open - 
    // disabled again in dispose so the buttons control volume elsewhere. Read the pref
    // directly so a not-yet-loaded provider can't leave it off.
    _maybeEnableVolumeKeys();
    _maybeEnableGaze();
    _maybeEnableTilt();
    _loadBookmarks();
    _loadRadialSettings();
    _timeTracker = ReadTimeTracker(onCredit: (secs) async {
      final url = widget.mangaUrl;
      if (!mounted || url == null) return;
      await _store.addReadTime(widget.sourceId, url, secs);
    })..start();
  }

  Future<void> _loadRadialSettings() async {
    final prefs = SettingsStore.instance;
    if (!mounted) return;
    setState(() {
      _radialEnabled = prefs.getBool('reader_radial_enabled') ?? true;
      _radialStyle = prefs.getString('reader_radial_style') ?? 'wheel';
      _radialOrder = RadialMenuConfig.enabledOrder('manga');
      _radialTailNav = RadialMenuConfig.tailChapterNav('manga');
      _radialLeftSide =
          (prefs.getString('reader_radial_side') ?? 'right') == 'left';
      _dualShift =
          prefs.getBool('dual_shift_${widget.sourceId}_${widget.mangaUrl}') ??
              false;
    });
  }

  // True while the iOS volume capture is held for auto-scroll speed control, so
  // we release it again when auto-scroll stops.
  bool _volumeForSpeedActive = false;

  Future<void> _maybeEnableVolumeKeys() async {
    final prefs = SettingsStore.instance;
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    // iOS: the volume buttons no longer navigate; they only tune the auto-scroll
    // speed, and only while it is running (see _startAutoScroll). So capture them
    // up front on Android only.
    if (!Platform.isAndroid) return;
    final beta = prefs.getBool('beta_features_enabled') ?? false; // volume-key nav is beta
    final on = beta && (prefs.getBool('reader_volume_keys') ?? false);
    if (on && mounted) {
      VolumeKeys.enable(_onVolumeKey);
    }
  }

  /// iOS only: grab the volume buttons while auto-scrolling so they tune the
  /// speed (opt-in via the same setting). No-op elsewhere.
  void _maybeStartVolumeForSpeed() {
    if (!Platform.isIOS || _volumeForSpeedActive) return;
    final prefs = SettingsStore.instance;
    final on = (prefs.getBool('beta_features_enabled') ?? false) &&
        (prefs.getBool('reader_volume_keys') ?? false);
    if (!on) return;
    _volumeForSpeedActive = true;
    VolumeKeys.enable(_onVolumeKey);
  }

  void _stopVolumeForSpeed() {
    if (!_volumeForSpeedActive) return;
    _volumeForSpeedActive = false;
    VolumeKeys.disable();
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
  @override
  double _volScrollSpeed = 600.0;
  // Hands-free auto-scroll (continuous / webtoon): a steady ticked scroll at the
  // user's speed until paused, the chapter ends, or the app backgrounds.
  Timer? _autoScrollTimer;
  bool _autoScrolling = false;
  final Set<String> _bookmarks = {};

  // In-reader radial control (opt-in) - see RadialReaderMenu. When enabled it
  // replaces the classic top/bottom bars with two corner anchors.
  bool _radialEnabled = false;
  String _radialStyle = 'wheel';
  bool _radialLeftSide = false;
  // Enabled wheel-action keys in the user's order (manga customization). Loaded
  // on open + refreshed when the radial settings are re-read.
  List<String> _radialOrder = RadialMenuConfig.enabledOrder('manga');
  // Opt-in prev/next chapter arrows on the slider tail (manga).
  bool _radialTailNav = RadialMenuConfig.tailChapterNav('manga');

  /// Volume-key handler. dir = 'up'|'down', phase = 'down'|'up'.
  /// - Paged (ltr/rtl): each press flips one page.
  /// - Continuous (webtoon/vertical): a quick TAP scrolls ~a screen; HOLDING scrolls
  ///   slowly and fluidly (like dragging) until released.
  void _onVolumeKey(String dir, String phase) {
    if (!mounted) return;
    // iOS: the volume buttons only tune the auto-scroll speed (up faster, down
    // slower), never navigate. The capture is only held while auto-scrolling, so
    // outside that the buttons behave normally. Android keeps page-turn.
    if (Platform.isIOS) {
      if (_autoScrolling && phase == 'down') {
        _nudgeAutoScrollSpeed(dir == 'up' ? 1 : -1);
      }
      return;
    }
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
  @override
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
    final screen = MediaQuery.sizeOf(context).height * 0.85;
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

  bool _isContinuous(ReaderProvider reader) =>
      reader.readingMode == ReadingMode.vertical ||
      reader.readingMode == ReadingMode.webtoon;

  /// Nudge the auto-scroll speed by one step (dir +1 faster, -1 slower),
  /// matching the stepper in the settings surfaces. Used by the iOS volume
  /// buttons while auto-scrolling; [setAutoScrollSpeed] clamps + persists.
  void _nudgeAutoScrollSpeed(int dir) {
    final reader = context.read<ReaderProvider>();
    reader.setAutoScrollSpeed(reader.settings.autoScrollSpeed + dir * 20);
    HapticFeedback.selectionClick();
  }

  void _toggleAutoScroll(ReaderProvider reader) =>
      _autoScrolling ? _stopAutoScroll() : _startAutoScroll(reader);

  /// Start hands-free auto-scroll: a steady ticked scroll at the user's speed.
  /// Across chapter boundaries it just keeps going (the next chapter appends);
  /// it stops only at the very end, when switched out of a scrolling mode, or
  /// when paused / backgrounded.
  void _startAutoScroll(ReaderProvider reader) {
    if (!_isContinuous(reader)) return;
    _autoScrollTimer?.cancel();
    setState(() => _autoScrolling = true);
    _applyWakelock(true); // keep the screen awake while it scrolls itself
    _maybeStartVolumeForSpeed(); // iOS: volume buttons now tune the speed
    HapticFeedback.selectionClick();
    // Clear the chrome for a clean hands-free view; the pill stays (its own
    // visibility is gated on _autoScrolling), so pause is still one tap away.
    if (reader.showHud) {
      _hudController.reverse();
      reader.toggleHud();
    }
    const tick = Duration(milliseconds: 33); // ~30fps; linear tweens smooth it
    _autoScrollTimer = Timer.periodic(tick, (_) {
      if (!mounted || !_autoScrolling) return;
      final r = context.read<ReaderProvider>();
      if (!_isContinuous(r) || (r.isLastChapter && _atVeryEnd(r))) {
        _stopAutoScroll();
        return;
      }
      final px = r.settings.autoScrollSpeed * (tick.inMilliseconds / 1000.0);
      try {
        _scrollOffsetController.animateScroll(
            offset: px, duration: tick, curve: Curves.linear);
      } catch (_) {}
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    _stopVolumeForSpeed(); // iOS: hand the volume buttons back
    if (!_autoScrolling) return;
    _autoScrolling = false;
    if (mounted) {
      setState(() {});
      _applyWakelock(context.read<ReaderProvider>().settings.keepScreenOn);
    }
  }

  /// Pause auto-scroll AND bring the controls back - the behaviour for both a
  /// tap on the page and a tap on the page pill while it's running.
  void _pauseAutoScroll() {
    _stopAutoScroll();
    if (!mounted) return;
    final reader = context.read<ReaderProvider>();
    if (!reader.showHud) {
      reader.toggleHud();
      _hudController.forward();
      _scheduleAutoHide(reader);
    }
  }

  /// True once the end card is reached and fully on screen - the bottom of the
  /// loaded strip (only meaningful on the last chapter, where nothing appends).
  bool _atVeryEnd(ReaderProvider reader) {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return false;
    final last = positions.reduce((a, b) => a.index > b.index ? a : b);
    return last.index >= reader.totalPages && last.itemTrailingEdge <= 1.02;
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

    // How far into the current page the viewport sits (0..1 of the page's
    // height) - negative leadingEdge means the page top has scrolled off the
    // top. Persisted (throttled) so Continue can land on the exact spot of a
    // long webtoon page, not just its top. Also apply any pending resume now.
    final fh = firstVisible.itemTrailingEdge - firstVisible.itemLeadingEdge;
    _lastFrac = fh > 0 ? (-firstVisible.itemLeadingEdge / fh).clamp(0.0, 1.0) : 0.0;
    _lastFracChapter = reader.chapterUrlForPage(page);
    // Keep this cheap - it runs on every scroll tick. We do NOT persist here:
    // SettingsStore re-serializes the whole prefs file per write, which made
    // scrolling janky. The in-memory value is flushed on exit (dispose) and when
    // the app backgrounds (didChangeAppLifecycleState).
    if (_pendingResumeFrac != null) _applyResumeFraction();

    if (page != reader.currentPage) {
      reader.setPage(page); // notifies → the slider/pill rebuild off currentPage
      _updateProgress(reader, page);
      _initialHudResolved = true; // a real scroll ends the entry phase
      // Velocity-aware image warming: the list only builds within minCacheExtent,
      // so a fast scroller can outrun it - warm a speed-scaled run of pages ahead.
      _recordAdvance();
      _precacheAhead(reader, page);
    }

    // Only treat this as a SCROLL when the viewport actually moved. itemPositions
    // re-emits on layout passes too - notably the rebuild that happens when a tap
    // reveals the HUD - and hiding on those spurious emits made the HUD vanish the
    // instant it appeared ("I tap and it disappears almost instantly"). Compare the
    // first-visible item's index + leading edge against the last to detect real motion.
    final movedIndex = _lastFirstIndex != null && firstVisible.index != _lastFirstIndex;
    final movedEdge = _lastLeadingEdge != null &&
        (firstVisible.itemLeadingEdge - _lastLeadingEdge!).abs() > 0.004;
    final scrolled = movedIndex || movedEdge;
    _lastFirstIndex = firstVisible.index;
    _lastLeadingEdge = firstVisible.itemLeadingEdge;

    // A real scroll hides the controls - but only once the entry phase is over, so
    // layout settling as pages load doesn't yank the HUD away on first open.
    if (scrolled && _initialHudResolved && reader.showHud && !_isInteracting) {
      _hudController.reverse();
      reader.toggleHud();
    }

    // Fetch the next chapter BEFORE the user reaches the end, with a runway that
    // grows the faster they scroll - so a seamless read never stalls at the seam
    // waiting on the network (only when auto-preload is on in Reader settings).
    final lastVisible = positions.reduce((a, b) => a.index > b.index ? a : b);
    if (reader.settings.autoPreload &&
        lastVisible.index >= reader.totalPages - 1 - _dynamicAhead &&
        !reader.isLoadingNext &&
        !reader.isLastChapter &&
        !reader.nextChapterError) {
      reader.loadNextChapter();
    }

    // Live translation: as new pages scroll into view, translate them. Cheap
    // no-op for pages already done or in flight (guarded in _translatePage).
    if (_isTranslationActive) _translateVisiblePages();
  }

  // Per-chapter bookmarks - shared with the detail screen via the same key.
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
    } catch (e) {
      logger.warning('Failed to load reader bookmarks',
          category: LogCategory.general, detail: '$e');
    }
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
    } catch (e) {
      logger.warning('Failed to save reader bookmark',
          category: LogCategory.general, detail: '$e');
    }
  }

  // Captured from _updateProgress so dispose can refresh the owning store's
  // "Continue reading" ONCE on exit - the per-page save no longer notifies.
  // Whichever one this title belongs to is set; the other stays null.
  LibraryProvider? _libRef;
  VaultProvider? _vaultRef;

  // The chapter the last progress-save belonged to. Crossing forward into a
  // later chapter marks the one left behind as read, so reading straight
  // through boundaries (continuous mode) finishes each chapter like a book - 
  // paged mode already marks at each chapter's last page.
  int _lastProgressChapterIndex = -1;
  String? _lastProgressChapterUrl;

  // Precise within-page resume for long (webtoon/manhua) pages. In continuous
  // mode we also remember HOW FAR down the current page the viewport is (0..1 of
  // the page's height), per chapter, and on reopen scroll back into that page by
  // the same fraction - so Continue lands on the exact spot, not the page top.
  double _lastFrac = 0; // live fraction into the current page (updated on scroll)
  String? _lastFracChapter; // chapter that _lastFrac belongs to
  double? _pendingResumeFrac; // fraction to restore on open (null once applied)
  int _pendingResumePage = 0; // the page index the pending fraction applies to
  bool _resumeTargetLoaded = false; // target page's image has sized → safe to scroll

  // Progress saves (manga resume pointer + per-chapter page) are THROTTLED.
  // updateReadingProgress does two Hive disk writes, so firing it on every page
  // change during a fast continuous scroll piled up unbounded async writes - 
  // jank, and OOM/crashes on a long binge. Coalesce to at most one save per
  // window, and flush the exact final position on exit / background.
  final ReaderSaveThrottle _progressSave = ReaderSaveThrottle();
  String? _pendingSaveChapterUrl;
  int _pendingSavePage = 0;

  /// The owning store for this title (vault vs public library), selected by the
  /// [isVault] flag threaded through navigation. All progress / read-mark writes
  /// go through this so a vault title never leaks into the plaintext boxes.
  LibraryLike get _store => widget.isVault
      ? context.read<VaultProvider>()
      : context.read<LibraryProvider>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // dispose may not run when the user swipes to the home screen / switches
    // apps, so flush the within-page scroll position on backgrounding.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _stopAutoScroll(); // don't keep scrolling in the background
      _flushProgressSave();
      _persistFraction();
    }
  }

  @override
  void dispose() {
    // Flush the pending reading position + within-page scroll fraction so
    // Continue lands precisely where we're leaving off (both are kept in memory
    // during scroll - throttled / per-frame-free - to keep scrolling smooth).
    WidgetsBinding.instance.removeObserver(this);
    _flushProgressSave();
    _persistFraction();
    // One reload so the owning store reflects where we left off (progress was
    // saved per-page without notifying, to avoid rebuilding the grid each flip).
    _libRef?.reload();
    _vaultRef?.reloadIfOpen();
    _timeTracker?.dispose();
    VolumeKeys.disable();
    GazeScroll.disable();
    TiltScroll.disable();
    _gazeTimer?.cancel();
    _navResetTimer?.cancel();
    _holdTimer?.cancel();
    _holdScrollTimer?.cancel();
    _autoScrollTimer?.cancel();
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
  /// desired state differs from what we last pushed - build() runs on every
  /// frame and the plugin call is a platform round-trip. Wrapped so an
  /// unsupported platform (or a transient failure) can never crash the reader.
  void _applyWakelock(bool on) {
    if (_wakelockApplied == on) return;
    _wakelockApplied = on;
    WakelockPlus.toggle(enable: on).catchError((_) {});
  }

  void _toggleHud(ReaderProvider reader) {
    _timeTracker?.ping(); // a screen tap counts as active reading
    _initialHudResolved = true; // a screen tap means the user is driving now
    // While auto-scrolling, a tap PAUSES it and brings the controls back - the
    // quick, obvious way to stop without hunting for a menu.
    if (_autoScrolling) {
      _pauseAutoScroll();
      return;
    }
    // Don't hide while the user is mid-interaction with a HUD control.
    if (reader.showHud && _isInteracting) return;
    // Flip the source of truth FIRST, then drive the animation to match it. Driving
    // the controller off the OLD state (as before) could leave showHud=true while the
    // fade sat at 0 - the HUD was "shown" but invisible, so a tap appeared to do nothing
    // ("the menu doesn't reappear"). Syncing to the new state makes tap-to-reveal reliable
    // in BOTH the classic bars and the radial wheel (whose visibility follows showHud).
    reader.toggleHud();
    if (reader.showHud) {
      _hudController.forward(); // tap to reveal - stays until next tap or scroll
    } else {
      _hudController.reverse();
    }
  }

  /// Called when a page image finishes loading. The first one to load ends the
  /// "show briefly on entry" phase and hides the HUD - after a short minimum so
  /// it's actually on screen for a beat first.
  void _onPageImageLoaded([int? index]) {
    // The page we're resuming onto just got its real size - now the within-page
    // scroll can land accurately. (A placeholder has no true height yet.)
    if (index != null &&
        _pendingResumeFrac != null &&
        index == _pendingResumePage) {
      _resumeTargetLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _applyResumeFraction();
      });
    }
    if (_initialHudResolved || !mounted) return;
    final elapsed =
        DateTime.now().difference(_enteredAt ?? DateTime.now()).inMilliseconds;
    final wait = elapsed < 700 ? 700 - elapsed : 0;
    Future.delayed(Duration(milliseconds: wait), _resolveInitialHud);
  }

  /// Remember the latest reading position and ensure a save fires within the
  /// throttle window (leading timer, coalesces every change in the window into
  /// one Hive write). The exact final position is flushed on exit / background.
  void _scheduleProgressSave(String chapterUrl, int localPage) {
    _pendingSaveChapterUrl = chapterUrl;
    _pendingSavePage = localPage;
    _progressSave.leading(const Duration(milliseconds: 700), _flushProgressSave);
  }

  void _flushProgressSave() {
    _progressSave.cancel();
    final ch = _pendingSaveChapterUrl;
    if (ch == null || widget.mangaUrl == null) return;
    _pendingSaveChapterUrl = null;
    final LibraryLike? store = widget.isVault ? _vaultRef : _libRef;
    store?.updateReadingProgress(
        widget.sourceId, widget.mangaUrl!, ch, _pendingSavePage);
  }

  /// Persist how far into the current page we are (0..1), keyed by the chapter,
  /// so a later Continue can scroll back to the exact spot of a long page.
  void _persistFraction() {
    final ch = _lastFracChapter;
    if (ch == null || widget.mangaUrl == null) return;
    try {
      SettingsStore.instance
          .setDouble('reader_pagefrac_${widget.sourceId}_$ch', _lastFrac);
    } catch (_) {}
  }

  /// Scroll the resume page so the saved fraction of its height sits above the
  /// viewport top - the precise long-page resume. One-shot: cleared the moment
  /// it runs (or when the user has already scrolled to a different page).
  void _applyResumeFraction() {
    final frac = _pendingResumeFrac;
    if (frac == null || !_resumeTargetLoaded || !mounted) return;
    final positions = _itemPositionsListener.itemPositions.value;
    ItemPosition? target;
    for (final p in positions) {
      if (p.index == _pendingResumePage) {
        target = p;
        break;
      }
    }
    if (target == null) return; // not laid out this frame - retry next tick
    // If the reader has already moved to a different page, don't yank it back.
    final visible = positions.where((p) => p.itemTrailingEdge > 0);
    if (visible.isNotEmpty) {
      final firstIdx =
          visible.reduce((a, b) => a.index < b.index ? a : b).index;
      if (firstIdx != _pendingResumePage) {
        _pendingResumeFrac = null;
        return;
      }
    }
    final heightVp = target.itemTrailingEdge - target.itemLeadingEdge;
    if (heightVp <= 0) return;
    _pendingResumeFrac = null; // one-shot, before the async scroll
    final vpH = MediaQuery.sizeOf(context).height;
    final alreadyIn = -target.itemLeadingEdge; // viewport-fractions already in
    final deltaPx = (frac * heightVp - alreadyIn) * vpH;
    if (deltaPx.abs() < 2) return;
    try {
      _scrollOffsetController.animateScroll(
          offset: deltaPx,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut);
    } catch (_) {}
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
  // control (slider/menu). NOT used for a plain screen tap - a tapped-open HUD
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
      builder: (_, reader, _) {
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
              // Tap anywhere - even on loading/error/gaps - toggles the controls.
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

              // Eye-comfort overlays - above the pages, below the controls, and
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
                  top: MediaQuery.paddingOf(context).top + 8,
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
                  top: MediaQuery.paddingOf(context).top + 8,
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                        ]),
                      ),
                    ),
                  ),
                ),

              // Persistent "page / total" readout for the CLASSIC layout - sits
              // while reading and fades out when the bars appear. In radial mode
              // the RadialReaderMenu owns this (the pill morphs into the button),
              // so it's drawn there instead. Honors showPageNumber.
              if (!_radialEnabled &&
                  reader.totalPages > 0 &&
                  reader.settings.showPageNumber)
                _buildPageIndicator(context, reader),

              // Controls: the opt-in radial replaces the classic bars when on.
              if (_radialEnabled)
                Positioned.fill(
                    key: const ValueKey('reader-chrome'),
                    child: _buildRadial(context, reader, t))
              else if (reader.showHud || _hudController.isAnimating)
                IgnorePointer(
                  key: const ValueKey('reader-chrome'),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _onBg.withAlpha(210), fontSize: 13),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                    foregroundColor: _onBg.withAlpha(230),
                    side: BorderSide(color: _onBg.withAlpha(90))),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => reader.loadPages(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(t.readerRetry, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final s = reader.settings;
    final fit = _boxFitFor(s.scaleType);
    final filter = imageColorFilter(s);
    final rtl = reader.readingMode == ReadingMode.rtl;

    // Dual-page: two pages side-by-side, only in landscape + a paged mode. The
    // whole reader (controller, nav, slider) then works in "slot" space, where
    // a slot is one or two page indices; in single-page mode every slot is one
    // page, so the slot index equals the page index and behaviour is unchanged.
    final dualActive = s.dualPageLandscape &&
        MediaQuery.orientationOf(context) == Orientation.landscape;
    _slots = dualActive
        ? _dualPageSlots(reader, s.dualPageSplitWide, _dualShift)
        : [for (var i = 0; i < reader.pages.length; i++) <int>[i]];
    final curSlot = _slotOfPage(_slots, reader.currentPage);

    _pageController ??= PageController(initialPage: curSlot);
    // The slot grouping changed - dual flipped on/off by a rotation, the shift
    // toggle moved, or a wide/tall page was just detected and regrouped - so the
    // controller's index now points at a stale slot. Re-anchor it onto the slot
    // that still holds the current page. A normal swipe sets currentPage to the
    // landed slot's page (see onPageChanged), so curSlot stays matched and this
    // fires no jump; it only corrects a grouping change.
    final dualChanged = _lastDualActive != dualActive;
    _lastDualActive = dualActive;
    if (dualChanged || _regroupPending) {
      _regroupPending = false;
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
            reader.setPage(lead); // notifies → the slider/pill rebuild off currentPage
            _recordAdvance();
            _precacheAhead(reader, lead);
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
                pages.last >= reader.totalPages - 1 - _dynamicAhead) {
              reader.loadNextChapter();
            }
          },
          itemBuilder: (_, slot) {
            final pages = _slots[slot];
            if (pages.length == 1) {
              return GestureDetector(
                onLongPress: () => _showPageMenu(pages.first),
                child: ZoomableView(
                  child: _pagedPage(reader, pages.first, fit, filter,
                      reportSize: dualActive),
                ),
              );
            }
            // Two-up spread. The PageView is already reversed for RTL, so within
            // the slot the earlier page goes on the right there.
            final a = pages[0], b = pages[1];
            final leftPage = rtl ? b : a;
            final rightPage = rtl ? a : b;
            return ZoomableView(
              child: Row(
                children: [
                  for (final p in [leftPage, rightPage])
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () => _showPageMenu(p),
                        child: _pagedPage(reader, p, fit, filter,
                            reportSize: dualActive),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        // Tap zones - layout/inversion driven by Reader settings.
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
  /// and any translation overlay applied - shared by the single-page and
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

  /// Groups page indices into display "slots" for the dual-page reader.
  ///
  /// Pairing restarts at every chapter (a spread never straddles two chapters,
  /// which the page→chapter metadata makes a cheap check). Within a chapter the
  /// FIRST page is shown on its own by default - the cover - so the interior
  /// facing pages line up as real two-page spreads instead of landing split
  /// across the gutter; [shift] flips that (cover paired, pairing offset by one)
  /// for sources whose spreads sit the other way. A page detected as a wide
  /// double-spread scan (when [splitWide] is on) or as an over-tall strip gets
  /// its own slot so it isn't squeezed into half the screen. The grouping is a
  /// pure function of page metadata + the detected sets, so it's stable across
  /// rebuilds (the controller is re-anchored when it changes - see
  /// [_regroupPending]).
  List<List<int>> _dualPageSlots(
      ReaderProvider reader, bool splitWide, bool shift) {
    final pages = reader.pages;
    final n = pages.length;
    final slots = <List<int>>[];
    bool isolated(int i) =>
        (splitWide && _widePages.contains(i)) || _tallPages.contains(i);
    var i = 0;
    while (i < n) {
      if (isolated(i)) {
        slots.add([i]);
        i += 1;
        continue;
      }
      // Cover: the first page of its chapter, shown solo so the spreads after
      // it line up - unless the manga is shifted.
      if (pages[i].localIndex == 0 && !shift) {
        slots.add([i]);
        i += 1;
        continue;
      }
      final canPair = i + 1 < n &&
          pages[i + 1].chapterIndex == pages[i].chapterIndex &&
          !isolated(i + 1);
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

  /// A page's real dimensions came back: classify it as a wide double-spread
  /// (landscape scan) or an over-tall strip so the next build can give it its
  /// own slot. Flags a regroup so the controller re-anchors onto the current
  /// page instead of jumping when the grouping shifts under it.
  void _onPageIntrinsicSize(int i, Size size) {
    if (!mounted || size.height <= 0 || size.width <= 0) return;
    final wide = size.width > size.height;
    // Much taller than wide → a long-strip / webtoon page; isolate it rather
    // than cram it into half a spread. 2.0 clears normal manga pages (~1.4:1).
    final tall = size.height > size.width * 2.0;
    var changed = false;
    if (wide != _widePages.contains(i)) {
      wide ? _widePages.add(i) : _widePages.remove(i);
      changed = true;
    }
    if (tall != _tallPages.contains(i)) {
      tall ? _tallPages.add(i) : _tallPages.remove(i);
      changed = true;
    }
    if (changed) setState(() => _regroupPending = true);
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

    // Pages are drawn fit-to-width, so a wide (landscape) viewport blows each
    // page up to fill it. Cap the strip to a comfortable reading width and
    // centre it - this both tames the "zoomed in" landscape look and keeps the
    // content clear of the notch / Dynamic Island + home indicator, which sit
    // on the long edges in landscape. Portrait is unchanged (cap >= width).
    final size = MediaQuery.sizeOf(context);
    final pad = MediaQuery.paddingOf(context);
    final isLandscape = size.width > size.height;
    final avail = size.width - pad.horizontal;
    final contentWidth =
        isLandscape ? (avail > 720.0 ? 720.0 : avail) : size.width;

    return ZoomableView(
      child: Center(
        child: SizedBox(
          width: contentWidth,
          child: ScrollablePositionedList.builder(
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13, color: _onBg.withAlpha(165))),
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

          // Check if this page index is a chapter boundary - show divider
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
        ),
      ),
    ),
    );
  }


  // ── Velocity-aware preload ───────────────────────────────────────────────
  // A fast reader gets more pages warmed ahead (and the next chapter fetched
  // sooner), so they don't run into a stall; a slow reader warms little and
  // spares the bandwidth. Driven by a smoothed time-between-advances.
  DateTime? _lastAdvanceAt;
  double _advanceEmaMs = 1200; // EMA of ms between page advances (start slow)

  /// Fold the latest page-advance interval into the smoothed turn speed.
  void _recordAdvance() {
    final now = DateTime.now();
    final last = _lastAdvanceAt;
    _lastAdvanceAt = now;
    if (last == null) return;
    final dt = now.difference(last).inMilliseconds.toDouble();
    // Drop pauses (a break, or the initial settle) so they don't skew the pace.
    if (dt <= 0 || dt > 8000) return;
    _advanceEmaMs = _advanceEmaMs * 0.6 + dt * 0.4;
  }

  /// Pages to warm ahead / chapter-load runway, from the smoothed turn speed.
  int get _dynamicAhead {
    final ms = _advanceEmaMs;
    if (ms < 300) return 10;
    if (ms < 500) return 8;
    if (ms < 800) return 6;
    if (ms < 1300) return 4;
    return 3;
  }

  /// Warm the next few page images into ImageLoader's cache so a forward flip in
  /// paged mode doesn't stall on the network - PageView.builder only builds the
  /// adjacent page, so without this each flip can wait on the next image. Fire-
  /// and-forget; the byte cache is keyed by URL, so the page's MangaImage then
  /// hits it. Referer handling mirrors MangaImage so the warm fetch succeeds.
  void _precacheAhead(ReaderProvider reader, int fromPage) {
    final ahead = _dynamicAhead;
    for (var i = fromPage + 1;
        i <= fromPage + ahead && i < reader.pages.length;
        i++) {
      final p = reader.pages[i];
      if (p.url.isEmpty) continue;
      var referer = p.headers?['Referer'] ?? p.url;
      if (p.headers?['Referer'] == null) {
        final uri = Uri.tryParse(referer);
        if (uri != null && uri.host.isNotEmpty) {
          referer = referer.replaceFirst('://${uri.host}', '://www.${uri.host}');
        }
      }
      if (!referer.endsWith('/')) referer = '$referer/';
      unawaited(ImageLoader().loadImage(p.url, headers: {'Referer': referer}));
    }
  }

  Widget _buildPageImage(ReaderPage pageUrl, int index) {
    final reader = context.read<ReaderProvider>();
    final filter = imageColorFilter(reader.settings);
    final translatedBytes = _isTranslationActive ? _koharuImageCache[index] : null;

    Widget image;
    // Local file (downloaded chapter)
    if (pageUrl.url.startsWith('file://')) {
      final path = pageUrl.url.replaceFirst('file://', '');
      image = Image.file(
        File(path),
        fit: BoxFit.fitWidth,
        width: double.infinity,
        // Local pages have no network onLoaded; signal the resume path once the
        // first frame is laid out so a downloaded long page resumes precisely.
        frameBuilder: (_, child, frame, _) {
          if (frame != null) _onPageImageLoaded(index);
          return child;
        },
        errorBuilder: (_, _, _) => SizedBox(
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
        onLoaded: () => _onPageImageLoaded(index),
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
    // image (no letterbox) - the overlay maps bounds straight onto it. koharu
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

  void _applyColorPreset(ReaderProvider reader,
      {required double sepia,
      required double contrast,
      required double saturation,
      double? warmTint}) {
    reader.setColorAdjust(
        sepia: sepia, contrast: contrast, saturation: saturation);
    reader.saveColorAdjust();
    if (warmTint != null) {
      reader.setEyeComfort(warmTint: warmTint);
      reader.saveEyeComfort();
    }
  }

  /// Shared image colour controls (preset chips + sepia / contrast / saturation
  /// sliders), used by both the classic settings sheet and the radial panel.
  /// [refresh] re-runs the host so the sliders track live.
  Widget _colorAdjustControls(ReaderProvider reader, void Function() refresh) {
    final s = reader.settings;
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    Widget chip(String name, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              onTap();
              refresh();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Text(name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface)),
            ),
          ),
        );
    Widget adj(String label, IconData icon, double value, double min,
            double max, int div, ValueChanged<double> onCh) =>
        Row(children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 10),
          SizedBox(
              width: 78,
              child: Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: cs.onSurface))),
          Expanded(
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: div,
              activeColor: cs.primary,
              inactiveColor: cs.onSurface.withValues(alpha: 0.3),
              onChanged: (v) {
                onCh(v);
                refresh();
              },
              onChangeEnd: (_) => reader.saveColorAdjust(),
            ),
          ),
        ]);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          chip(t.readerFilterReset,
              () => _applyColorPreset(reader, sepia: 0, contrast: 1, saturation: 1, warmTint: 0)),
          chip(t.readerFilterPaper,
              () => _applyColorPreset(reader, sepia: 0.45, contrast: 1.0, saturation: 0.85, warmTint: 0.15)),
          chip(t.readerFilterNight,
              () => _applyColorPreset(reader, sepia: 0.2, contrast: 0.95, saturation: 0.9, warmTint: 0.55)),
          chip(t.readerFilterVivid,
              () => _applyColorPreset(reader, sepia: 0, contrast: 1.15, saturation: 1.25)),
        ]),
      ),
      const SizedBox(height: 6),
      adj(t.readerFilterSepia, Icons.filter_vintage_rounded, s.sepia, 0, 1, 10,
          (v) => reader.setColorAdjust(sepia: v)),
      adj(t.readerFilterContrast, Icons.contrast_rounded, s.contrast, 0.5, 1.5, 20,
          (v) => reader.setColorAdjust(contrast: v)),
      adj(t.readerFilterSaturation, Icons.palette_outlined, s.saturation, 0, 2, 20,
          (v) => reader.setColorAdjust(saturation: v)),
    ]);
  }

  /// Auto-scroll speed control (−/readout/+) shared by the radial panel and the
  /// classic settings sheet. [refresh] re-runs the host on change.
  Widget _autoScrollSpeedRow(ReaderProvider reader, void Function() refresh) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final speed = reader.settings.autoScrollSpeed.round();
    void bump(double d) {
      reader.setAutoScrollSpeed(reader.settings.autoScrollSpeed + d);
      refresh();
    }
    Widget btn(IconData icon, VoidCallback onTap) => IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: onTap,
          icon: Icon(icon, size: 22, color: cs.primary),
        );
    return Row(children: [
      Icon(Icons.speed_rounded, size: 20, color: cs.primary),
      const SizedBox(width: 10),
      Expanded(
        child: Text(t.readerAutoScrollSpeed,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: cs.onSurface)),
      ),
      btn(Icons.remove_rounded, () => bump(-20)),
      SizedBox(
        width: 34,
        child: Text('$speed',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()])),
      ),
      btn(Icons.add_rounded, () => bump(20)),
    ]);
  }

  /// Auto-scroll controls for the settings surfaces (continuous/webtoon only):
  /// an optional play/pause toggle (classic sheet - the radial has a wheel
  /// action instead) plus the speed stepper.
  Widget _autoScrollControls(ReaderProvider reader, void Function() refresh,
      {required bool withToggle}) {
    if (!_isContinuous(reader)) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Column(children: [
      if (withToggle)
        Row(children: [
          Icon(Icons.play_circle_outline_rounded, size: 20, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(t.readerAutoScroll,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSurface)),
          ),
          Switch(
            value: _autoScrolling,
            onChanged: (_) {
              _toggleAutoScroll(reader);
              refresh();
            },
          ),
        ]),
      _autoScrollSpeedRow(reader, refresh),
    ]);
  }

  Widget _buildChapterTransition(BuildContext context, ChapterBoundary boundary) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    // Blend the band into the reader's own background so the seam between two
    // chapters is invisible instead of a hard navy slab (which clashed on the
    // white / OLED / custom backgrounds). A faint accent pip carries the break.
    final bg = _bgColorFor(context.read<ReaderProvider>().settings.bgColor, context);
    Widget caps(String s, Color c) => Text(s.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.6, color: c));
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (boundary.prevChapterName != null) ...[
            caps(t.readerFinishedLabel, _onBg.withAlpha(110)),
            const SizedBox(height: 5),
            Text(boundary.prevChapterName!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13, color: _onBg.withAlpha(150)),
                textAlign: TextAlign.center),
            const SizedBox(height: 22),
          ],
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(28),
              shape: BoxShape.circle,
              border: Border.all(color: cs.primary.withAlpha(110)),
            ),
            child: Icon(Icons.arrow_downward_rounded, color: cs.primary, size: 22),
          ),
          if (boundary.nextChapterName != null) ...[
            const SizedBox(height: 22),
            caps(t.readerUpNextLabel, cs.primary.withAlpha(210)),
            const SizedBox(height: 5),
            Text(boundary.nextChapterName!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15, fontWeight: FontWeight.w700, color: _onBg.withAlpha(225)),
                textAlign: TextAlign.center),
          ],
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16, fontWeight: FontWeight.w700, color: _onBg.withAlpha(200)),
        ),
        const SizedBox(height: 8),
        if (isLast)
          Text(t.readerLatestChapterAvailable,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13, color: _onBg.withAlpha(165)),
              textAlign: TextAlign.center)
        else if (onNext != null)
          FilledButton.icon(
            icon: const Icon(Icons.skip_next_rounded, size: 20),
            label: Text(t.readerLoadNextChapter,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
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
  Widget _buildRadial(
      BuildContext context, ReaderProvider reader, AppLocalizations t) {
    final cs = _chapterSlider(reader);
    // Every wheel action this reader can currently show, keyed to the customizer
    // (RadialMenuConfig). Availability (continuous-only auto-scroll, optional
    // translate) is decided here; the saved order then filters + sequences them.
    final available = <String, RadialAction>{
      'settings': RadialAction(
          icon: Icons.tune_rounded,
          label: t.readerSettings,
          panelHeight: 352,
          panelBuilder: (ctx, refresh) =>
              _radialSettingsPanel(ctx, reader, refresh)),
      'bookmark': RadialAction(
          icon: _bookmarks.contains(reader.currentChapterUrl)
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          label: t.readerBookmark,
          onTap: _toggleCurrentBookmark),
      if (_isContinuous(reader))
        'autoscroll': RadialAction(
            icon: _autoScrolling
                ? Icons.pause_circle_outline_rounded
                : Icons.play_circle_outline_rounded,
            label: 'Auto-scroll',
            onTap: () => _toggleAutoScroll(reader)),
      'prev': RadialAction(
          icon: Icons.keyboard_double_arrow_left_rounded,
          label: t.readerPreviousChapter,
          enabled: reader.hasPreviousChapter,
          onTap: () {
            if (reader.hasPreviousChapter) reader.goToPreviousChapter();
          }),
      'next': RadialAction(
          icon: Icons.keyboard_double_arrow_right_rounded,
          label: t.readerNextChapter,
          enabled: reader.hasNextChapter,
          onTap: () {
            if (reader.hasNextChapter) reader.goToNextChapter();
          }),
      'scroll': _gazeSupported
          ? RadialAction(
              icon: _gazeActive
                  ? Icons.visibility_rounded
                  : Icons.visibility_outlined,
              label: t.readerGazeScroll,
              onTap: _toggleGaze)
          : RadialAction(
              icon: Icons.screen_rotation_rounded,
              label: t.readerTiltScroll,
              onTap: _toggleTilt),
      if (_translationEnabled)
        'translate': RadialAction(
            icon: Icons.translate_rounded,
            label: t.readerAiTranslate,
            onTap: _toggleTranslationActive),
    };
    final actions = [
      for (final k in _radialOrder)
        if (available[k] != null) available[k]!,
    ];
    return RadialReaderMenu(
      leftSide: _radialLeftSide,
      style: _radialStyle,
      // The wheel FAB and back button hide while reading, like the classic bars - they
      // fade out on a tap/scroll (showHud false) and back in on the next tap. While the
      // wheel is actually open they stay regardless (handled inside the widget).
      visible: reader.showHud,
      title: _readerTitle(t),
      chapter: _chapterLabel(reader).isNotEmpty ? _chapterLabel(reader) : null,
      titleExpanded: reader.showHud,
      onBack: () => Navigator.pop(context),
      page: cs.page,
      totalPages: cs.total,
      onSeek: cs.seek,
      panelAccent: Theme.of(context).colorScheme.primary,
      showPageLabel: reader.settings.showPageNumber,
      autoScrolling: _autoScrolling,
      autoScrollSpeed: reader.settings.autoScrollSpeed.round(),
      onAutoScrollPause: _pauseAutoScroll,
      showChapterNav: _radialTailNav,
      prevEnabled: reader.hasPreviousChapter,
      nextEnabled: reader.hasNextChapter,
      onPrevChapter: () {
        if (reader.hasPreviousChapter) reader.goToPreviousChapter();
      },
      onNextChapter: () {
        if (reader.hasNextChapter) reader.goToNextChapter();
      },
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
      actions: actions,
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
        top: MediaQuery.paddingOf(context).top + 4,
        left: 8,
        right: 8,
        bottom: 24,
      ),
      child: Row(
        children: [
          HudButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
            tooltip: t.readerBack,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarqueeText(
                  _readerTitle(t),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: reader.settings.fontSize * 0.6875,
                      fontWeight: FontWeight.w500,
                      color: _onBg.withAlpha(200),
                      shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                  ),
              ],
            ),
          ),
          if (_gazeSupported)
            HudButton(
              icon: _gazeActive
                  ? Icons.visibility_rounded
                  : Icons.visibility_outlined,
              onTap: _toggleGaze,
              onLongPress:
                  (_gazeActive || _tiltActive) ? _openHandsFreeMenu : null,
              tooltip: t.readerGazeScroll,
            )
          else
            HudButton(
              icon: Icons.screen_rotation_rounded,
              onTap: _toggleTilt,
              onLongPress:
                  (_gazeActive || _tiltActive) ? _openHandsFreeMenu : null,
              tooltip: t.readerTiltScroll,
            ),
          const SizedBox(width: 8),
          HudButton(
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
  /// The chapter label for the HUD - the chapter the user is currently on
  /// (derived from the page), falling back to the opened chapter's title.
  String _chapterLabel(ReaderProvider reader) {
    final name = reader.chapterNameForPage(reader.currentPage);
    return name.isNotEmpty ? name : (widget.chapterTitle ?? '');
  }

  /// The manga title for the HUD. Some entry points open the reader without a
  /// title (it arrives as an empty string, not null), so fall back to a generic
  /// label rather than showing a blank line.
  String _readerTitle(AppLocalizations t) {
    final mt = (widget.mangaTitle ?? '').trim();
    return mt.isEmpty ? t.readerTitle : mt;
  }

  ({int page, int total, void Function(int) seek}) _chapterSlider(
      ReaderProvider reader) {
    // Derive straight from the authoritative currentPage - it is correct from
    // the first frame (set to the resume page on load, and kept current on every
    // scroll, swipe, seek and chapter change). An earlier mirror field lagged
    // behind it until the first interaction, so the readout showed the wrong
    // page on open until you tapped or scrolled.
    final cur = reader.currentPage;
    final r = reader.chapterRangeForPage(cur);
    final total = (r.end - r.start).clamp(1, 1 << 30);
    final page = (cur - r.start).clamp(0, total - 1);
    return (
      page: page,
      total: total,
      seek: (localPage) {
        final global = (r.start + localPage).clamp(0, reader.totalPages - 1);
        reader.setPage(global);
        _jumpToPage(reader, global);
      },
    );
  }

  /// The small "page / total" chip (style A · pill). Visible while reading and
  /// faded out whenever the controls are up - driven by [ReverseAnimation] of
  /// the HUD animation, so it mirrors the bars/radial exactly. Positioned at the
  /// radial action-button corner in radial mode (where the hidden FAB would be),
  /// otherwise bottom-right.
  Widget _buildPageIndicator(BuildContext context, ReaderProvider reader) {
    final cs = _chapterSlider(reader);
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    // Classic layout only (in radial the RadialReaderMenu draws its own morphing
    // pill). Sits in the SAME corner the radial button uses - right by default,
    // left if the radial button is placed there - at the same low baseline, so
    // the pill never jumps when radial mode is toggled on/off.
    final double bottom = safeBottom + 20;
    final double? right = _radialLeftSide ? null : 18;
    final double? left = _radialLeftSide ? 18 : null;
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: ReverseAnimation(_hudAnimation),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(184),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(color: Colors.white.withAlpha(26)),
            ),
            child: _autoScrolling
                // Auto-scrolling: the pill shows the pause glyph + speed (+ page);
                // a tap anywhere on the page pauses it (see _toggleHud).
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.pause_rounded,
                        size: 15,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 3),
                    Text('${reader.settings.autoScrollSpeed.round()}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    Text('  ·  ${cs.page + 1} / ${cs.total}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withAlpha(140))),
                  ])
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: '${cs.page + 1}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: ' / ${cs.total}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withAlpha(140)),
                      ),
                    ]),
                  ),
          ),
        ),
      ),
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
        bottom: MediaQuery.paddingOf(context).bottom + 12,
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: reader.settings.fontSize * 0.75,
                      fontWeight: FontWeight.w700,
                      color: _onBg.withAlpha(200),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          // AI Translation toggle + provider (hidden if disabled in settings).
          // Pills mirror the app's chip language (pill radius, accent-when-active,
          // frosted hairline otherwise) but keep white-on-dark for legibility over
          // the page image.
          if (_translationEnabled) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _toggleTranslationActive,
                child: AnimatedContainer(
                  duration: AppTheme.standard,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: _isTranslationActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white.withAlpha(31),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    border: Border.all(
                      color: _isTranslationActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white.withAlpha(66), width: 1),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (_isTranslating)
                      SizedBox(width: 14, height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                                _isTranslationActive
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Colors.white)))
                    else
                      Icon(Icons.translate_rounded, size: 14,
                          color: _isTranslationActive
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      _isTranslating ? t.readerTranslating : t.readerAiTranslate,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _isTranslationActive
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.white70),
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showProviderSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(31),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(color: Colors.white.withAlpha(66)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(_selectedProviderName,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: _onBg.withAlpha(210))),
                      const SizedBox(width: 3),
                      Icon(Icons.expand_more_rounded, size: 14, color: _onBg.withAlpha(160)),
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
              HudButton(
                icon: Icons.skip_previous_rounded,
                onTap: reader.hasPreviousChapter
                    ? () => reader.goToPreviousChapter()
                    : () {},
                tooltip: t.readerPreviousChapter,
                size: 20,
              ),
              const SizedBox(width: 24),
              HudButton(
                icon: _bookmarks.contains(reader.currentChapterUrl)
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                onTap: _toggleCurrentBookmark,
                tooltip: t.readerBookmark,
                size: 18,
              ),
              const SizedBox(width: 24),
              HudButton(
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
  // ── Long-press page menu: Share / Save / Set as cover / Recognize text ──────

  /// Bytes for a page - the in-memory cache (what MangaImage already loaded) for
  /// remote pages, or disk for downloaded (`file://`) pages.
  @override
  Future<Uint8List?> _pageBytes(ReaderPage p) async {
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
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  color: cs.onSurface)),
        ]),
      ),
    );
  }

  Future<void> _sharePage(ReaderPage page) async {
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

  Future<void> _savePage(ReaderPage page) async {
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

  Future<void> _setPageAsCover(ReaderPage page) async {
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

  Future<void> _recognizePageText(ReaderPage page) async {
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
            style: TextStyle(
                fontWeight: FontWeight.w700, color: cs.onSurface)),
        content: SingleChildScrollView(
          child: SelectableText(
            hasText ? text : t.readerPageOcrEmpty,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: hasText ? cs.onSurface : cs.outline),
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
    // Lift the reading HUD out of the way while the menu is up: the bottom bar's
    // page slider otherwise sits awkwardly behind the sheet. Hide it now and
    // bring it back (on the usual auto-hide timer) once the sheet is dismissed.
    final hudWasShown = reader.showHud;
    if (hudWasShown) {
      _hudController.reverse();
      reader.toggleHud();
    }
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.onSurface)),
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
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: isSelected ? Theme.of(context).colorScheme.primary : cs.onSurface,
                                )),
                            Text(_modeSubtitle(mode),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w400, color: cs.outline)),
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: cs.onSurface))),
              Switch(
                  value: _radialEnabled,
                  onChanged: (v) {
                    _setRadialEnabled(v);
                    setSheet(() {});
                  }),
            ]),
            _dualShiftRow(reader, () => setSheet(() {})),
            _autoScrollControls(reader, () => setSheet(() {}), withToggle: true),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(t.readerEyeComfort,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.outline)),
            ),
            Row(children: [
              Icon(Icons.wb_twilight_rounded, size: 20, color: AppTheme.warning),
              const SizedBox(width: 10),
              SizedBox(
                  width: 72,
                  child: Text(t.readerEyeComfortWarm,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface))),
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
                  child: Text(t.readerEyeComfortBrightness,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface))),
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
            const SizedBox(height: 8),
            _colorAdjustControls(reader, () => setSheet(() {})),
          ],
        ),
      ),
      ),
      ),
      ),
    ).whenComplete(() {
      if (!mounted || !hudWasShown) return;
      if (!reader.showHud) {
        _hudController.forward();
        reader.toggleHud();
        _scheduleAutoHide(reader);
      }
    });
  }

  Future<void> _setRadialEnabled(bool v) async {
    setState(() => _radialEnabled = v);
    await SettingsStore.instance.setBool('reader_radial_enabled', v);
  }

  Future<void> _setDualShift(bool v) async {
    setState(() {
      _dualShift = v;
      _regroupPending = true; // re-pair, then re-anchor onto the current page
    });
    await SettingsStore.instance
        .setBool('dual_shift_${widget.sourceId}_${widget.mangaUrl}', v);
  }

  /// "Shift double pages" switch, shown only while the two-page spread layout is
  /// actually engaged (landscape + the setting on). Per-manga, so it sits with
  /// the in-reader controls rather than global Settings. [refresh] re-runs the
  /// host sheet so the switch updates in place.
  Widget _dualShiftRow(ReaderProvider reader, void Function() refresh) {
    final dualActive = reader.settings.dualPageLandscape &&
        MediaQuery.orientationOf(context) == Orientation.landscape;
    if (!dualActive) return const SizedBox.shrink();
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(children: [
        Icon(Icons.import_contacts_rounded, size: 20, color: cs.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.readerShiftPages,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: cs.onSurface)),
              Text(t.readerShiftPagesDesc,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w400, color: cs.outline)),
            ],
          ),
        ),
        Switch(
          value: _dualShift,
          onChanged: (v) {
            _setDualShift(v);
            refresh();
          },
        ),
      ]),
    );
  }

  /// The reader settings that now live in the radial's expanding tail (dark
  /// panel, white-on-dark), replacing the old modal sheet. The page slider stays
  /// as the tail base below this. [refresh] re-runs the builder on change.
  Widget _radialSettingsPanel(
      BuildContext ctx, ReaderProvider reader, void Function() refresh) {
    final t = AppLocalizations.of(ctx);
    final cs = Theme.of(ctx).colorScheme;
    final accent = cs.primary;
    Widget label(String s) => Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(s.toUpperCase(),
                style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: cs.onSurfaceVariant)),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        label(t.readerReadingMode),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ReadingMode.values.map((mode) {
            final sel = mode == reader.readingMode;
            return GestureDetector(
              onTap: () {
                reader.setReadingMode(mode);
                refresh();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: sel
                      ? accent
                      : cs.onSurface.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                      color: sel ? accent : cs.outlineVariant),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_modeIcon(mode),
                      size: 16, color: sel ? cs.onPrimary : cs.onSurface),
                  const SizedBox(width: 6),
                  Text(_modeLabel(mode),
                      style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: sel ? cs.onPrimary : cs.onSurface)),
                ]),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Radial on/off, so you can switch back to the classic controls from
        // inside the radial itself (the classic settings sheet has the same
        // toggle; this was missing here).
        Row(children: [
          Icon(Icons.blur_circular_rounded, size: 18, color: accent),
          const SizedBox(width: 10),
          Expanded(
              child: Text(t.readerRadialMenu,
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: cs.onSurface))),
          Switch(
            value: _radialEnabled,
            onChanged: (v) {
              _setRadialEnabled(v);
              refresh();
            },
          ),
        ]),
        _dualShiftRow(reader, refresh),
        _autoScrollControls(reader, refresh, withToggle: false),
        const SizedBox(height: 10),
        label(t.readerEyeComfort),
        Row(children: [
          const Icon(Icons.wb_twilight_rounded,
              size: 18, color: AppTheme.warning),
          Expanded(
            child: Slider(
              value: reader.settings.warmTint.clamp(0.0, 1.0),
              min: 0,
              max: 1,
              divisions: 10,
              activeColor: cs.primary,
              inactiveColor: cs.onSurface.withValues(alpha: 0.3),
              onChanged: (v) {
                reader.setEyeComfort(warmTint: v);
                refresh();
              },
              onChangeEnd: (_) => reader.saveEyeComfort(),
            ),
          ),
        ]),
        Row(children: [
          const Icon(Icons.brightness_6_rounded,
              size: 18, color: AppTheme.warning),
          Expanded(
            child: Slider(
              value: reader.settings.brightness.clamp(0.15, 1.0),
              min: 0.15,
              max: 1,
              divisions: 17,
              activeColor: cs.primary,
              inactiveColor: cs.onSurface.withValues(alpha: 0.3),
              onChanged: (v) {
                reader.setEyeComfort(brightness: v);
                refresh();
              },
              onChangeEnd: (_) => reader.saveEyeComfort(),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        _colorAdjustControls(reader, refresh),
      ],
    );
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
    _timeTracker?.ping(); // a page turn counts as active reading
    if (widget.mangaUrl == null) return;
    try {
      final libraryProvider = _store;
      // Capture the concrete owning provider for the single refresh on dispose.
      if (libraryProvider is LibraryProvider) _libRef = libraryProvider;
      if (libraryProvider is VaultProvider) _vaultRef = libraryProvider;
      // Persist the page RELATIVE TO ITS CHAPTER, not the session-global index
      // into reader.pages (which spans every chapter loaded this session).
      // Resume reopens just the last-read chapter and applies the saved page as
      // its start, so a global index landed the reader AHEAD by however many
      // pages of earlier chapters were loaded that session (the "resume a few
      // pages too far" bug, most visible in continuous mode).
      final r = reader.chapterRangeForPage(page);
      final localPage = (page - r.start).clamp(0, 1 << 30);
      // Save against the chapter that actually OWNS this page, not
      // reader.currentChapterUrl - the latter follows _currentChapterIndex,
      // which drifts to the NEXT chapter once it preloads, so near the end of a
      // chapter it would pin this chapter's page onto the next chapter (resume
      // jumped a chapter ahead).
      final owningChapterUrl = reader.chapterUrlForPage(page);
      // Throttled: coalesce rapid page changes into one Hive write per window
      // (flushed exactly on exit/background) instead of writing every change.
      _scheduleProgressSave(owningChapterUrl, localPage);
      // Crossed forward into a later chapter → mark the one left behind read.
      // This is the continuous-mode case (you scroll straight past a boundary);
      // the last-page check below still covers paged mode and the final chapter.
      final curChapterIdx = (page >= 0 && page < reader.pages.length)
          ? reader.pages[page].chapterIndex
          : -1;
      if (curChapterIdx != -1) {
        if (_lastProgressChapterUrl != null &&
            _lastProgressChapterIndex != -1 &&
            curChapterIdx > _lastProgressChapterIndex &&
            !IncognitoProvider.active) {
          libraryProvider.markChapterRead(
            widget.sourceId,
            widget.mangaUrl!,
            _lastProgressChapterUrl!,
            active: true,
          );
        }
        _lastProgressChapterIndex = curChapterIdx;
        _lastProgressChapterUrl = owningChapterUrl;
      }
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
      // (the manual "mark as read" on the detail screen still works - only this
      // automatic, reading-driven one is suppressed). _syncTracking is a no-op
      // in incognito too (guarded in TrackingProvider.syncChapterRead).
      if (page >= reader.totalPages - 1) {
        if (!IncognitoProvider.active) {
          libraryProvider.markChapterRead(
            widget.sourceId,
            widget.mangaUrl!,
            reader.currentChapterUrl,
            active: true, // genuine in-app read → counts toward the stats
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
    } catch (e) {
      logger.warning('Tracker chapter sync failed',
          category: LogCategory.general, detail: '$e');
    }
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

// _ZoomableView and _HudButton moved to widgets/reader_zoom_view.dart
// (ZoomableView / HudButton).
