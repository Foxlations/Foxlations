import 'dart:async';
import 'dart:io' show Platform, File;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:path_provider/path_provider.dart';

import '../../core/models/manga_model.dart';
import '../../core/providers/library_provider.dart';
import '../../core/services/image_loader.dart';
import '../widgets/type_toggle.dart';
import '../../core/utils/url_utils.dart';
import '../../core/providers/download_provider.dart';
import '../../core/providers/source_provider.dart';
import '../../core/providers/tracking_provider.dart';
import '../../core/providers/incognito_provider.dart';
import '../../core/services/download_service.dart';
import '../../core/services/settings_store.dart';
import '../../core/services/tts_media_session.dart';
import '../../core/services/volume_keys.dart';
import '../../core/services/gaze_scroll_service.dart';
import '../../core/services/tilt_scroll_service.dart';
import 'package:media_kit/media_kit.dart';

import '../../core/services/app_logger.dart';
import '../../core/services/tts/neural_tts_service.dart';
import '../../eval/lib.dart';
import '../../l10n/app_localizations.dart';

/// Text reader for light-novel sources. Fetches the chapter's HTML via the
/// source's `getHtmlContent`, renders it as readable paragraphs, and supports
/// font sizing + previous/next chapter navigation.
class NovelReaderScreen extends StatefulWidget {
  final String chapterUrl;
  final String sourceId;
  final String? mangaUrl;
  final String? chapterTitle;
  final String? mangaTitle;
  final List<Map<String, dynamic>>? chapters;
  final int currentIndex;
  final int startOffset;
  final double startFraction;

  const NovelReaderScreen({
    super.key,
    required this.chapterUrl,
    required this.sourceId,
    this.mangaUrl,
    this.chapterTitle,
    this.mangaTitle,
    this.chapters,
    this.currentIndex = 0,
    this.startOffset = 0,
    this.startFraction = 0.0,
  });

  @override
  State<NovelReaderScreen> createState() => _NovelReaderScreenState();
}

class _NovelReaderScreenState extends State<NovelReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  // Volume-key hold detection: tap = scroll ~a screen, hold = slow fluid scroll.
  Timer? _holdTimer;
  Timer? _holdScrollTimer;
  bool _holdScrolling = false;
  double _volScrollSpeed = 600.0;
  // Hands-free (gaze) scrolling — iOS only; feeds the same fluid-scroll loop.
  Timer? _gazeTimer;
  int _gazeDelta = 0;
  double _gazeSpeed = 0;
  bool _gazeActive = false;
  bool _tiltActive = false;
  // Continuous-text reading has no "pages", so we persist the exact SCROLL OFFSET
  // (debounced) and restore it, so "continue" lands where you actually stopped.
  Timer? _saveThrottle;
  LibraryProvider? _lib;
  double _lastOffset = 0;
  List<String> _paragraphs = [];
  bool _loading = true;
  String? _error;
  double _fontSize = 18;
  // Reader theme for eye comfort: default (app theme), sepia, warm, gray, oled.
  String _novelTheme = 'default';
  // Text customization.
  double _lineHeight = 1.7;
  String _textAlign = 'left'; // left | justify | center
  double _hMargin = 20.0;
  String _fontFamily = 'serif'; // serif | sans | mono

  TextStyle _novelTextStyle(Color color) {
    final base = TextStyle(fontSize: _fontSize, height: _lineHeight, color: color);
    switch (_fontFamily) {
      case 'sans':
        return GoogleFonts.notoSans(textStyle: base);
      case 'mono':
        return GoogleFonts.robotoMono(textStyle: base);
      default:
        return GoogleFonts.notoSerif(textStyle: base);
    }
  }

  TextAlign _textAlignValue() => switch (_textAlign) {
        'justify' => TextAlign.justify,
        'center' => TextAlign.center,
        _ => TextAlign.left,
      };

  // (bg, text) for the current theme; null bg = use the app theme's surface.
  (Color?, Color) _themeColors(ColorScheme cs) {
    switch (_novelTheme) {
      case 'sepia':
        return (const Color(0xFFF4ECD8), const Color(0xFF5B4636));
      case 'warm':
        return (const Color(0xFFFBF0E0), const Color(0xFF3A2E22));
      case 'gray':
        return (const Color(0xFF1E1E1E), const Color(0xFFD2D2D2));
      case 'oled':
        return (const Color(0xFF000000), const Color(0xFFC2C2C2));
      default:
        return (null, cs.onSurface);
    }
  }

  void _openNovelSettings() {
    final cs = Theme.of(context).colorScheme;
    final p = SettingsStore.instance;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: cs.outline,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              _sheetLabel('Font', cs),
              TypeToggle(
                items: const [
                  TypeToggleItem('serif', 'Serif'),
                  TypeToggleItem('sans', 'Sans'),
                  TypeToggleItem('mono', 'Mono'),
                ],
                selectedId: _fontFamily,
                onChanged: (id) {
                  setState(() => _fontFamily = id);
                  setSheet(() {});
                  p.setString('novel_font_family', id);
                },
              ),
              const SizedBox(height: 12),
              _sheetLabel('Alignment', cs),
              TypeToggle(
                items: const [
                  TypeToggleItem('left', 'Left'),
                  TypeToggleItem('justify', 'Justify'),
                  TypeToggleItem('center', 'Center'),
                ],
                selectedId: _textAlign,
                onChanged: (id) {
                  setState(() => _textAlign = id);
                  setSheet(() {});
                  p.setString('novel_text_align', id);
                },
              ),
              const SizedBox(height: 8),
              _sheetLabel('Line spacing', cs),
              Slider(
                value: _lineHeight,
                min: 1.2,
                max: 2.4,
                divisions: 12,
                onChanged: (v) {
                  setState(() => _lineHeight = v);
                  setSheet(() {});
                  p.setDouble('novel_line_height', v);
                },
              ),
              _sheetLabel('Margins', cs),
              Slider(
                value: _hMargin,
                min: 8,
                max: 48,
                divisions: 10,
                onChanged: (v) {
                  setState(() => _hMargin = v);
                  setSheet(() {});
                  p.setDouble('novel_margin', v);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _sheetLabel(String text, ColorScheme cs) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(text,
              style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.primary)),
        ),
      );

  void _pickNovelTheme() {
    final cs = Theme.of(context).colorScheme;
    const themes = [
      ('default', 'Default'),
      ('sepia', 'Sepia'),
      ('warm', 'Warm'),
      ('gray', 'Gray'),
      ('oled', 'Black (OLED)'),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (id, label) in themes)
              ListTile(
                leading: Icon(
                    _novelTheme == id
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: _novelTheme == id ? cs.primary : cs.outline),
                title: Text(label,
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, color: cs.onSurface)),
                onTap: () {
                  setState(() => _novelTheme = id);
                  SettingsStore.instance.setString('novel_reader_theme', id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
  late int _index;
  late String _url;
  String? _title;

  // ── Text-to-speech ("Listen") ──────────────────────────
  FlutterTts? _tts;
  bool _ttsActive = false; // the Listen control bar is shown
  bool _ttsPlaying = false; // currently speaking
  int _ttsIndex = 0; // paragraph being read
  double _ttsRate = 0.5; // flutter_tts rate (0.5 ≈ 1.0×)
  double _ttsPitch = 1.0; // 0.5 (deep) … 2.0 (high); 1.0 = natural
  String? _ttsVoiceName; // chosen device voice (null = system default)
  String? _ttsVoiceLocale;
  List<GlobalKey> _paraKeys = [];
  bool _ttsResumeAfterLoad = false; // keep reading into the next chapter
  // Sentence-level highlight: the character ranges of each sentence in the
  // paragraph being read, and which one the engine is currently speaking (-1 =
  // none yet / progress unsupported → the whole paragraph stays highlighted).
  List<(int, int)> _ttsSentences = const [];
  // Sentence ranges in the NORMALIZED text actually handed to the TTS engine.
  // The engine reports progress offsets into that string, so we map those back
  // to a sentence index here, then highlight the SAME index in _ttsSentences
  // (which indexes the original on-screen text). Same length/order as
  // _ttsSentences, so the index lines up even though the strings differ.
  List<(int, int)> _ttsSpokenSentences = const [];
  // Display-sentence index that spoken-sentence 0 maps to (non-zero when a live
  // speed/voice change re-speaks from the CURRENT sentence instead of the
  // paragraph start, so the user doesn't re-hear what they just heard).
  int _ttsSentenceBase = 0;
  // True while a deliberate stop()+re-speak is in flight (speed/voice/pitch
  // change), so the stop doesn't get mistaken for a natural end and advance /
  // double-read the paragraph.
  bool _ttsRestarting = false;
  // Lock-screen Now-Playing extras: the cover as a local file (so the OS can
  // load it), plus an estimated chapter timeline (per-paragraph start times +
  // total) so a progress bar shows.
  String? _coverArtPath;
  Duration _chapterDuration = Duration.zero;
  List<Duration> _paraStartTimes = const [];
  // Offline neural TTS (sherpa-onnx), gated behind Advanced → Experimental. When
  // the engine is 'neural' AND a model is loaded, paragraphs are synthesized to
  // audio and played via [_neuralPlayer] instead of the OS voices; otherwise it
  // transparently falls back to the device engine.
  String _ttsEngine = 'device';
  String _neuralVoiceId = NeuralVoice.all.first.id;
  Player? _neuralPlayer;
  StreamSubscription<bool>? _neuralDoneSub;
  bool _neuralBusy = false;
  double? _neuralDlProgress;
  bool get _useNeural =>
      _ttsEngine == 'neural' && NeuralTtsService.instance.isReady;
  int _ttsSentence = -1;
  static bool get _ttsSupported =>
      Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isMacOS ||
      Platform.isWindows;

  @override
  void initState() {
    super.initState();
    _index = widget.currentIndex;
    _url = widget.chapterUrl;
    _title = widget.chapterTitle;
    // Font size is per-reader and now PERSISTED — it used to reset to 18 on
    // every chapter open because it was never read from / written to settings.
    _fontSize =
        (SettingsStore.instance.getDouble('novel_font_size') ?? 18.0)
            .clamp(12, 30)
            .toDouble();
    _novelTheme =
        SettingsStore.instance.getString('novel_reader_theme') ?? 'default';
    final p = SettingsStore.instance;
    _lineHeight = (p.getDouble('novel_line_height') ?? 1.7).clamp(1.2, 2.4);
    _textAlign = p.getString('novel_text_align') ?? 'left';
    _hMargin = (p.getDouble('novel_margin') ?? 20.0).clamp(8.0, 48.0);
    _fontFamily = p.getString('novel_font_family') ?? 'serif';
    _applyScreenPrefs();
    _scrollController.addListener(_saveProgress);
    _load();
    _maybeEnableVolumeKeys();
    _maybeEnableGaze();
    _maybeEnableTilt();
    _loadTtsRate();
  }

  /// Honour the shared reader prefs the manga reader already respects — the
  /// novel reader ignored both, so the screen could sleep mid-read and
  /// fullscreen never applied.
  void _applyScreenPrefs() {
    final keepOn = SettingsStore.instance.getBool('reader_keep_screen_on') ?? true;
    if (keepOn) WakelockPlus.enable().catchError((_) {});
    final fullscreen =
        SettingsStore.instance.getBool('reader_fullscreen') ?? false;
    if (fullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void _setFontSize(double v) {
    final clamped = v.clamp(12, 30).toDouble();
    if (clamped == _fontSize) return;
    setState(() => _fontSize = clamped);
    SettingsStore.instance.setDouble('novel_font_size', clamped);
  }

  Future<void> _loadTtsRate() async {
    final prefs = SettingsStore.instance;
    if (mounted) {
      setState(() {
        _ttsRate = prefs.getDouble('novel_tts_rate') ?? 0.5;
        _ttsPitch = (prefs.getDouble('novel_tts_pitch') ?? 1.0).clamp(0.5, 2.0);
        _ttsVoiceName = prefs.getString('novel_tts_voice_name');
        _ttsVoiceLocale = prefs.getString('novel_tts_voice_locale');
        _ttsEngine = prefs.getString('novel_tts_engine') ?? 'device';
        _neuralVoiceId =
            prefs.getString('novel_tts_neural_voice') ?? NeuralVoice.all.first.id;
      });
    }
    // If the neural engine is selected and its model is already downloaded, warm
    // it up so _useNeural flips true without the user re-downloading.
    if (_ttsEngine == 'neural') {
      final v = NeuralVoice.byId(_neuralVoiceId);
      if (await NeuralTtsService.instance.isDownloaded(v)) {
        unawaited(NeuralTtsService.instance.ensureReady(v));
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lib ??= context.read<LibraryProvider>();
  }

  // Persist the scroll offset (as the manga's lastReadPage) a second after scrolling
  // stops, so it survives quick exits without saving on every pixel.
  void _saveProgress() {
    if (!_scrollController.hasClients) return;
    _lastOffset = _scrollController.offset;
    if (widget.mangaUrl == null) return;
    // Reaching (near) the bottom = finished this chapter → mark read + sync
    // trackers, once. Novels never did this, so their unread counts never
    // dropped from reading and bound trackers never advanced.
    if (!_markedRead && _currentFraction() >= 0.98) _markReadIfEnd();
    _saveThrottle?.cancel();
    _saveThrottle = Timer(const Duration(seconds: 1), () {
      if (!mounted || _lib == null) return;
      _lib!.updateNovelProgress(widget.sourceId, widget.mangaUrl!, _url,
          _lastOffset.round(), _currentFraction());
    });
  }

  bool _markedRead = false;
  void _markReadIfEnd() {
    final mangaUrl = widget.mangaUrl;
    if (_markedRead || mangaUrl == null || _lib == null) return;
    _markedRead = true;
    if (!IncognitoProvider.active) {
      _lib!.markChapterRead(widget.sourceId, mangaUrl, _url);
    }
    try {
      final n = _chapterNumberOf(_title ?? '');
      if (n > 0) {
        context
            .read<TrackingProvider>()
            .syncChapterRead('${widget.sourceId}_$mangaUrl', n);
      }
    } catch (_) {}
  }

  int _chapterNumberOf(String name) {
    final labeled = RegExp(
            r'(?:chapter|chap|ch|episode|ep|#)\s*[.:]?\s*(\d+(?:\.\d+)?)',
            caseSensitive: false)
        .firstMatch(name);
    String? s = labeled?.group(1);
    if (s == null) {
      final all = RegExp(r'(\d+(?:\.\d+)?)').allMatches(name).toList();
      if (all.isNotEmpty) s = all.last.group(1);
    }
    final d = double.tryParse(s ?? '');
    return d == null ? 0 : d.floor();
  }

  // Reflow-safe progress: fraction of total scroll height. Novels reflow on
  // font-size/width changes, so a raw offset drifts; the fraction restores the
  // same reading position after a reflow, the offset for an exact match.
  double _currentFraction() {
    if (!_scrollController.hasClients) return 0.0;
    final max = _scrollController.position.maxScrollExtent;
    return max > 0 ? (_lastOffset / max).clamp(0.0, 1.0) : 0.0;
  }

  void _restoreScroll() {
    if (widget.startOffset <= 0 && widget.startFraction <= 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      // Prefer the exact offset; if the content reflowed shorter than where we
      // stopped, fall back to the saved fraction so we land at the same spot.
      final target = (widget.startOffset > 0 && widget.startOffset <= max)
          ? widget.startOffset.toDouble()
          : (widget.startFraction > 0 ? widget.startFraction * max : 0.0);
      _scrollController.jumpTo(target.clamp(0.0, max));
    });
  }

  // Volume-button scrolling (Android, opt-in via Reader settings). Only while this
  // reader is open; disabled again in dispose so the buttons control volume elsewhere.
  Future<void> _maybeEnableVolumeKeys() async {
    final prefs = SettingsStore.instance;
    final beta = prefs.getBool('beta_features_enabled') ?? false; // volume-key nav is beta
    final on = beta && (prefs.getBool('reader_volume_keys') ?? false);
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    if (on && mounted) {
      VolumeKeys.enable(_onVolumeKey);
    }
  }

  /// A quick TAP scrolls ~a screen; HOLDING scrolls slowly and fluidly until released.
  void _onVolumeKey(String dir, String phase) {
    if (!mounted) return;
    final delta = dir == 'down' ? 1 : -1;
    if (phase == 'down') {
      _holdScrolling = false;
      _holdTimer?.cancel();
      _holdTimer = Timer(const Duration(milliseconds: 250), () {
        _holdScrolling = true;
        _beginHoldScroll(delta);
      });
    } else {
      _holdTimer?.cancel();
      if (_holdScrolling) {
        _holdScrolling = false;
        _holdScrollTimer?.cancel();
      } else {
        _tapScroll(delta);
      }
    }
  }

  void _tapScroll(int delta) {
    if (!_scrollController.hasClients) return;
    final page = _scrollController.position.viewportDimension * 0.85;
    final target = (_scrollController.offset + delta * page)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(target,
        duration: const Duration(milliseconds: 220), curve: Curves.easeOutCubic);
  }

  void _beginHoldScroll(int delta) {
    const tick = Duration(milliseconds: 100);
    final step = delta * _volScrollSpeed * (tick.inMilliseconds / 1000.0);
    void scrollOnce() {
      if (!mounted || !_scrollController.hasClients) return;
      final target = (_scrollController.offset + step)
          .clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(target, duration: tick, curve: Curves.linear);
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

  // ── Hands-free (gaze) scrolling ──────────────────────
  // iOS-only: ARKit face tracking (GazeScroll) drives the SAME fluid-scroll loop
  // as the volume hold. Silently absent off iOS / on unsupported devices.
  Future<void> _maybeEnableGaze() async {
    if (!await GazeScroll.isSupported()) return;
    final prefs = SettingsStore.instance;
    if (!(prefs.getBool('beta_features_enabled') ?? false)) return; // hands-free is beta
    if (!(prefs.getBool('reader_gaze_enabled') ?? false)) return;
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

  void _onGaze(GazeEvent e) {
    if (!mounted) return;
    logger.info(
        'Hands-free: ${e.direction.name} @ ${e.intensity.toStringAsFixed(2)}',
        category: LogCategory.general);
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
      if (!mounted || !_scrollController.hasClients || _gazeDelta == 0) return;
      final step = _gazeDelta * _gazeSpeed * (tick.inMilliseconds / 1000.0);
      final target = (_scrollController.offset + step)
          .clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(target, duration: tick, curve: Curves.linear);
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

  // Tilt-to-scroll reuses the same scroll path (mutually exclusive with gaze).
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
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    TiltScroll.updateSettings(TiltSettings(
      threshold: prefs.getDouble('reader_tilt_threshold') ?? 0.20,
      smoothing: prefs.getDouble('reader_tilt_smoothing') ?? 0.20,
    ));
    await TiltScroll.enable(_onTilt);
    if (mounted) setState(() => _tiltActive = true);
  }

  @override
  void dispose() {
    WakelockPlus.disable().catchError((_) {});
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    VolumeKeys.disable();
    GazeScroll.disable();
    TiltScroll.disable();
    _tts?.stop();
    _neuralDoneSub?.cancel();
    _neuralPlayer?.dispose();
    if (_ttsActive) ttsMediaSession?.unbind();
    _gazeTimer?.cancel();
    _saveThrottle?.cancel();
    _scrollController.removeListener(_saveProgress);
    if (widget.mangaUrl != null && _lib != null && _lastOffset > 0) {
      _lib!.updateNovelProgress(widget.sourceId, widget.mangaUrl!, _url,
          _lastOffset.round(), _currentFraction());
    }
    _holdTimer?.cancel();
    _holdScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    _markedRead = false; // new chapter — allow marking it read on reaching its end
    setState(() {
      _loading = true;
      _error = null;
    });
    // Capture the providers + localized fallback before any await so we don't
    // reach across an async gap for them after the offline read.
    final sourceProvider = context.read<SourceProvider>();
    final dlProvider = context.read<DownloadProvider>();
    final noTextMessage = AppLocalizations.of(context).readerNoChapterText;
    try {
      String? html;
      // Offline first: if this chapter's text was downloaded, read it from disk
      // and skip the source call entirely (works with no network).
      final novelTitle = widget.mangaTitle;
      final chapterName = _title;
      if (novelTitle != null &&
          novelTitle.isNotEmpty &&
          chapterName != null &&
          chapterName.isNotEmpty) {
        html = await DownloadService()
            .readNovelChapter(widget.sourceId, novelTitle, chapterName);
      }
      if (html == null) {
        final installed = sourceProvider.resolveInstalled(widget.sourceId);
        if (installed == null) throw Exception('Source not installed');
        html = await withExtensionService(
          installed.source,
          installed.sourceCode,
          (service) => service.getHtmlContent(_url),
        );
      }
      _paragraphs = _toParagraphs(html ?? '');
      _paraKeys = List.generate(_paragraphs.length, (_) => GlobalKey());
      _recomputeTtsTiming(); // estimate the chapter timeline for Now-Playing
      if (_paragraphs.isEmpty) _error = noTextMessage;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) {
      setState(() => _loading = false);
      _restoreScroll();
      if (_error == null) _maybeDownloadAhead(dlProvider);
      // Keep listening into the next chapter.
      if (_ttsResumeAfterLoad) {
        _ttsResumeAfterLoad = false;
        _ttsIndex = 0;
        if (_paragraphs.isNotEmpty && _error == null) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _speakCurrent());
        } else {
          _stopTts();
        }
      }
    }
  }

  /// "Download ahead while reading" for novels: queue the next few chapters'
  /// text so they're ready offline before the reader reaches them. The chapter
  /// list is newest-first, so the next chapters sit at lower indices. The
  /// DownloadProvider dedupes against in-flight + already-downloaded.
  void _maybeDownloadAhead(DownloadProvider dl) {
    if (!dl.downloadWhileReading) return;
    final chapters = widget.chapters;
    final novelTitle = widget.mangaTitle;
    final novelUrl = widget.mangaUrl;
    if (chapters == null || novelUrl == null || novelTitle == null) return;
    final count = dl.downloadAheadCount;
    for (var n = 1; n <= count; n++) {
      final idx = _index - n;
      if (idx < 0) break;
      final url = (chapters[idx]['url'] ?? '').toString();
      if (url.isEmpty) continue;
      dl.enqueueNovelChapter(
        sourceId: widget.sourceId,
        novelUrl: novelUrl,
        novelTitle: novelTitle,
        chapterUrl: url,
        chapterName: (chapters[idx]['name'] ?? '').toString(),
      );
    }
  }

  List<String> _toParagraphs(String html) {
    if (html.trim().isEmpty) return [];
    final doc = html_parser.parse(html);
    var paras = doc
        .querySelectorAll('p')
        .map((e) => e.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (paras.isEmpty) {
      final text = doc.body?.text ?? doc.documentElement?.text ?? '';
      paras = text
          .split(RegExp(r'\n\s*\n|\n'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return paras;
  }

  bool get _hasPrev =>
      widget.chapters != null && _index < widget.chapters!.length - 1;
  bool get _hasNext => widget.chapters != null && _index > 0;

  void _go(int delta) {
    final chapters = widget.chapters;
    if (chapters == null) return;
    final next = _index + delta;
    if (next < 0 || next >= chapters.length) return;
    setState(() {
      _index = next;
      _url = (chapters[next]['url'] ?? '').toString();
      _title = (chapters[next]['name'] ?? '').toString();
    });
    _load();
  }

  // ── Text-to-speech ──────────────────────────────────────
  Future<FlutterTts> _ensureTts() async {
    var tts = _tts;
    if (tts != null) return tts;
    tts = FlutterTts();
    // iOS: use the playback category (+ the app's `audio` background mode) so
    // reading continues with the screen locked / app backgrounded, routing to
    // Bluetooth like other media.
    if (Platform.isIOS) {
      try {
        await tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          ],
          IosTextToSpeechAudioMode.spokenAudio,
        );
      } catch (_) {}
    }
    await tts.setVolume(1.0);
    await tts.setPitch(_ttsPitch);
    await tts.setSpeechRate(_ttsRate);
    await _applyVoice(tts);
    tts.setCompletionHandler(() {
      // _ttsRestarting: this "completion" is really our own stop() during a
      // speed/voice change — don't advance (that caused the double-read).
      if (!mounted || !_ttsPlaying || _ttsRestarting) return;
      _ttsIndex++;
      _ttsSentence = -1;
      _ttsSentenceBase = 0;
      if (_ttsIndex < _paragraphs.length) {
        _speakCurrent();
      } else {
        _onChapterEndTts();
      }
    });
    // A deliberate stop() (speed/voice change, pause) fires this, NOT completion,
    // so it must never advance the paragraph.
    tts.setCancelHandler(() {});
    // Sentence-level highlight: the engine reports the char offset of each word
    // as it's spoken; map it onto the sentence that contains it. Not every
    // platform fires this — when it doesn't, _ttsSentence stays -1 and the whole
    // paragraph stays highlighted.
    tts.setProgressHandler((text, start, end, word) {
      // Offsets are into the NORMALIZED spoken string → map to a sentence index,
      // then highlight that same index on the original on-screen text.
      if (!mounted || _ttsSpokenSentences.isEmpty) return;
      var k = -1;
      for (var j = 0; j < _ttsSpokenSentences.length; j++) {
        if (start >= _ttsSpokenSentences[j].$1 &&
            start < _ttsSpokenSentences[j].$2) {
          k = j;
          break;
        }
      }
      final s = k < 0 ? -1 : _ttsSentenceBase + k;
      if (s != _ttsSentence) setState(() => _ttsSentence = s);
    });
    tts.setErrorHandler((_) {
      if (mounted) setState(() => _ttsPlaying = false);
    });
    _tts = tts;
    return tts;
  }

  String get _ttsPosKey => 'novel_tts_pos:${widget.sourceId}:$_url';

  /// Remember where TTS was so "Listen" resumes there next time.
  void _saveTtsPos() {
    if (_ttsIndex >= 0 && _ttsIndex < _paragraphs.length) {
      SettingsStore.instance.setInt(_ttsPosKey, _ttsIndex);
    }
  }

  Future<void> _startTts() async {
    if (_paragraphs.isEmpty) return;
    // Resume from the saved paragraph if we have one for this chapter, else
    // from the first paragraph currently on screen.
    final saved = SettingsStore.instance.getInt(_ttsPosKey);
    final start = (saved != null && saved >= 0 && saved < _paragraphs.length)
        ? saved
        : _firstVisibleParagraph();
    setState(() {
      _ttsActive = true;
      _ttsPlaying = true;
      _ttsIndex = start;
    });
    _recomputeTtsTiming();
    unawaited(_prepareCoverArt()); // lock-screen cover art (best-effort)
    // Lock-screen / background controls: route the buttons back here.
    ttsMediaSession?.bind(
      onPlay: _ttsRemotePlay,
      onPause: _ttsRemotePause,
      onStop: _stopTts,
      onNext: _ttsRemoteNext,
      onPrevious: _ttsRemotePrev,
    );
    _syncMediaSession();
    await _speakCurrent();
  }

  // ── Lock-screen / notification media session ──────────────
  void _syncMediaSession() {
    final s = ttsMediaSession;
    if (s == null || !_ttsActive) return;
    s.setNowPlaying(
      chapter: _title ?? '',
      book: widget.mangaTitle ?? 'Novel',
      artPath: _coverArtPath,
      duration: _chapterDuration > Duration.zero ? _chapterDuration : null,
    );
    s.setPlaying(_ttsPlaying,
        hasNext: _hasNext,
        hasPrevious: _hasPrev,
        position: _positionForIndex(_ttsIndex),
        speed: 1.0);
  }

  Duration _positionForIndex(int i) {
    if (_paraStartTimes.isEmpty) return Duration.zero;
    return _paraStartTimes[i.clamp(0, _paraStartTimes.length - 1)];
  }

  /// Rough wall-clock timeline so the lock screen shows a progress bar: ~2.6
  /// words/sec at normal rate (flutter_tts 0.5), scaled by the chosen rate. An
  /// estimate — TTS has no true duration — but it tracks closely enough.
  void _recomputeTtsTiming() {
    final wps = (2.6 * (_ttsRate / 0.5)).clamp(0.5, 12.0);
    final starts = <Duration>[];
    var acc = 0.0;
    for (final p in _paragraphs) {
      starts.add(Duration(milliseconds: (acc * 1000).round()));
      final t = p.trim();
      final words = t.isEmpty ? 0 : t.split(RegExp(r'\s+')).length;
      acc += words / wps;
    }
    _paraStartTimes = starts;
    _chapterDuration = Duration(milliseconds: (acc * 1000).round());
  }

  /// Fetch the cover (from the library entry) to a local file via ImageLoader —
  /// which honours the source's TLS/Referer — so the OS Now-Playing art loads.
  Future<void> _prepareCoverArt() async {
    try {
      LibraryManga? m;
      for (final e in (_lib ?? context.read<LibraryProvider>()).manga) {
        if (e.sourceId == widget.sourceId && e.url == widget.mangaUrl) {
          m = e;
          break;
        }
      }
      final cover = m?.coverUrl ?? '';
      if (cover.isEmpty) return;
      final referer = safeOrigin(widget.mangaUrl ?? '');
      final bytes = await ImageLoader().loadImage(cover,
          headers: referer != null ? {'Referer': referer} : null);
      if (bytes == null || bytes.isEmpty || !mounted) return;
      final tmp = await getTemporaryDirectory();
      final path = '${tmp.path}/ntts_cover_${widget.sourceId.hashCode}.img';
      await File(path).writeAsBytes(bytes);
      if (!mounted) return;
      _coverArtPath = path;
      _syncMediaSession(); // push the art now that it's ready
    } catch (_) {}
  }

  void _ttsRemotePlay() {
    if (!_ttsPlaying) _togglePlayPause();
  }

  void _ttsRemotePause() {
    if (_ttsPlaying) _togglePlayPause();
  }

  void _ttsRemoteNext() {
    if (_hasNext) {
      _ttsResumeAfterLoad = true;
      _go(-1); // chapter list is newest-first → next chapter = index-1
    }
  }

  void _ttsRemotePrev() {
    if (_hasPrev) {
      _ttsResumeAfterLoad = true;
      _go(1);
    }
  }

  Future<void> _speakCurrent({int fromSentence = 0}) async {
    if (!mounted || _ttsIndex < 0 || _ttsIndex >= _paragraphs.length) return;
    if (_useNeural) {
      await _speakNeuralCurrent();
      return;
    }
    final para = _paragraphs[_ttsIndex];
    _ttsSentences = _sentenceRanges(para); // full paragraph, for the highlight
    final from = _ttsSentences.isEmpty
        ? 0
        : fromSentence.clamp(0, _ttsSentences.length - 1);
    _ttsSentenceBase = from; // spoken sentence 0 == display sentence [from]
    // Build the normalized string handed to the engine (from sentence [from]
    // onward) + its parallel sentence ranges, so stylized text (onomatopoeia/
    // SFX) isn't spelled out while the on-screen highlight stays aligned: the
    // engine's offsets map via _ttsSpokenSentences (+_ttsSentenceBase), the
    // highlight paints via _ttsSentences.
    final spoken = StringBuffer();
    final spokenRanges = <(int, int)>[];
    for (var i = from; i < _ttsSentences.length; i++) {
      final r = _ttsSentences[i];
      var seg = _normalizeForTts(para.substring(r.$1, r.$2));
      if (seg.trim().isEmpty) seg = ' ';
      final start = spoken.length;
      spoken.write(seg);
      if (!seg.endsWith(' ')) spoken.write(' ');
      spokenRanges.add((start, spoken.length)); // contiguous, incl. separator
    }
    _ttsSpokenSentences = spokenRanges;
    // On a mid-paragraph restart keep the current sentence lit; otherwise wait
    // for the first progress event.
    _ttsSentence = from > 0 ? from : -1;
    setState(() {}); // repaint the highlight
    _saveTtsPos(); // remember where we are so Listen resumes here next time
    _syncMediaSession(); // keep the lock-screen title/controls current
    _scrollToTts();
    final tts = await _ensureTts();
    await tts.setSpeechRate(_ttsRate);
    await tts.setPitch(_ttsPitch);
    final text = spoken.toString().trim();
    await tts.speak(text.isEmpty ? para : text);
  }

  /// Re-speak the current paragraph FROM the current sentence after a live
  /// change (speed / pitch / voice). Gated by [_ttsRestarting] so the deliberate
  /// stop() isn't mistaken for a natural end (which would advance + double-read).
  Future<void> _restartSpeaking() async {
    if (!_ttsPlaying) return;
    final from = _ttsSentence >= 0 ? _ttsSentence : 0;
    _ttsRestarting = true;
    await _tts?.stop();
    await _neuralPlayer?.stop();
    if (!mounted) {
      _ttsRestarting = false;
      return;
    }
    await _speakCurrent(fromSentence: from);
    _ttsRestarting = false;
  }

  // ── Offline neural TTS playback (sherpa-onnx → WAV → media_kit) ──────────
  Player _ensureNeuralPlayer() {
    final existing = _neuralPlayer;
    if (existing != null) return existing;
    final p = Player();
    _neuralDoneSub = p.stream.completed.listen((done) {
      // Each paragraph's audio finishing advances to the next, mirroring the
      // device engine's completion handler.
      if (done && mounted && _ttsPlaying && _useNeural && !_ttsRestarting) {
        _advanceNeural();
      }
    });
    _neuralPlayer = p;
    return p;
  }

  void _advanceNeural() {
    _ttsIndex++;
    _ttsSentence = -1;
    _ttsSentenceBase = 0;
    if (_ttsIndex < _paragraphs.length) {
      _speakNeuralCurrent();
    } else {
      _onChapterEndTts();
    }
  }

  /// Synthesize the current paragraph with the neural engine and play it. The
  /// highlight stays at paragraph level (no per-word progress from the model).
  Future<void> _speakNeuralCurrent() async {
    if (!mounted || _ttsIndex < 0 || _ttsIndex >= _paragraphs.length) return;
    final para = _paragraphs[_ttsIndex];
    _ttsSentences = _sentenceRanges(para);
    _ttsSpokenSentences = const [];
    _ttsSentence = -1; // whole paragraph highlighted (no word-level progress)
    setState(() {});
    _saveTtsPos();
    _syncMediaSession();
    _scrollToTts();
    final text = _normalizeForTts(para);
    final speed = (_ttsRate / 0.5).clamp(0.5, 2.0);
    final path = await NeuralTtsService.instance
        .synthesizeToWav(text.isEmpty ? para : text, speed: speed);
    if (!mounted || !_ttsPlaying) return;
    if (path == null) {
      _advanceNeural(); // synthesis failed — don't stall, move on
      return;
    }
    try {
      final p = _ensureNeuralPlayer();
      await p.open(Media('file://$path'), play: _ttsPlaying);
    } catch (e) {
      logger.error('Neural TTS playback failed',
          category: LogCategory.extension, detail: e.toString());
    }
  }

  /// Clean a chunk of prose for TTS so the voice stops spelling out stylized
  /// text: collapse drawn-out letters ("aaaahhh" -> "aahh"), de-dupe shouted
  /// punctuation, and strip emphasis/SFX markers + symbol clutter it would
  /// otherwise read character by character. The on-screen text is untouched.
  String _normalizeForTts(String s) {
    var out = s;
    // Emphasis / SFX markers: *THUD*, _word_, ~wavy~, `code`, ^sup^.
    out = out.replaceAll(RegExp(r'[*_~`^]+'), ' ');
    // Drawn-out letters: 3+ of the same letter -> 2 ("Nooooo" -> "Noo").
    out = out.replaceAllMapped(
        RegExp(r'([A-Za-z])\1{2,}'), (m) => '${m[1]}${m[1]}');
    // Shouted punctuation runs -> a single mark ("!!!" -> "!").
    out = out.replaceAllMapped(RegExp(r'([!?])\1+'), (m) => m[1]!);
    // Dash runs -> a comma pause; bullets/odd glyph runs -> a space.
    out = out.replaceAll(RegExp(r'[-–—]{2,}'), ', ');
    out = out.replaceAll(RegExp(r'[•·▪◦‣⁃=+<>|\\/]{2,}'), ' ');
    // Collapse the whitespace the substitutions leave behind.
    out = out.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
    return out;
  }

  /// Split a paragraph into sentence character ranges [start, end) for the
  /// progress-driven highlight. Falls back to the whole paragraph as one
  /// "sentence" when there's no terminal punctuation.
  List<(int, int)> _sentenceRanges(String text) {
    final ranges = <(int, int)>[];
    final re = RegExp(r'[^.!?。！？…]*[.!?。！？…]+["”’)\]]*\s*|[^.!?。！？…]+$');
    for (final m in re.allMatches(text)) {
      if (m.end > m.start) ranges.add((m.start, m.end));
    }
    if (ranges.isEmpty && text.isNotEmpty) ranges.add((0, text.length));
    return ranges;
  }

  /// The paragraph currently being read: the active sentence is coloured +
  /// bolded on top of the paragraph's soft background. Plain text when the
  /// engine hasn't reported a sentence yet (or doesn't support progress).
  Widget _readingParagraph(String text, TextStyle style, ColorScheme cs) {
    if (_ttsSentence < 0 || _ttsSentence >= _ttsSentences.length) {
      return SelectableText(text, textAlign: _textAlignValue(), style: style);
    }
    final s = _ttsSentences[_ttsSentence].$1.clamp(0, text.length);
    final e = _ttsSentences[_ttsSentence].$2.clamp(s, text.length);
    final active = style.copyWith(
        color: cs.primary, fontWeight: FontWeight.w700);
    return SelectableText.rich(
      TextSpan(style: style, children: [
        if (s > 0) TextSpan(text: text.substring(0, s)),
        TextSpan(text: text.substring(s, e), style: active),
        if (e < text.length) TextSpan(text: text.substring(e)),
      ]),
      textAlign: _textAlignValue(),
    );
  }

  Future<void> _togglePlayPause() async {
    if (_ttsPlaying) {
      setState(() => _ttsPlaying = false);
      _syncMediaSession();
      if (_useNeural) {
        await _neuralPlayer?.pause();
      } else {
        await _tts?.stop();
      }
    } else {
      if (_ttsIndex >= _paragraphs.length) _ttsIndex = _firstVisibleParagraph();
      setState(() => _ttsPlaying = true);
      _syncMediaSession();
      if (_useNeural && _neuralPlayer != null) {
        await _neuralPlayer!.play(); // resume the paused paragraph
      } else {
        await _speakCurrent();
      }
    }
  }

  Future<void> _stopTts() async {
    _ttsResumeAfterLoad = false;
    setState(() {
      _ttsPlaying = false;
      _ttsActive = false;
      _ttsSentence = -1;
      _ttsSentences = const [];
      _ttsSpokenSentences = const [];
    });
    ttsMediaSession?.unbind();
    await _tts?.stop();
    await _neuralPlayer?.stop();
  }

  void _onChapterEndTts() {
    if (_hasNext) {
      _ttsResumeAfterLoad = true;
      _go(-1); // next chapter (chapter list is newest-first → next = index-1)
    } else {
      _stopTts();
    }
  }

  Future<void> _setTtsRate(double rate) async {
    final r = rate.clamp(0.3, 1.0);
    if (r == _ttsRate) return;
    setState(() => _ttsRate = r);
    final prefs = SettingsStore.instance;
    await prefs.setDouble('novel_tts_rate', r);
    _recomputeTtsTiming(); // rate affects the estimated timeline
    // Apply immediately by re-speaking from the current sentence at the new rate.
    await _restartSpeaking();
  }

  Future<void> _setTtsPitch(double pitch) async {
    final p = pitch.clamp(0.5, 2.0).toDouble();
    if (p == _ttsPitch) return;
    setState(() => _ttsPitch = p);
    await SettingsStore.instance.setDouble('novel_tts_pitch', p);
    await _restartSpeaking();
  }

  /// Bottom sheet with Speed + Pitch sliders for the "Listen" voice.
  void _openTtsTuning() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Text-to-speech',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.record_voice_over_rounded,
                    size: 20, color: cs.primary),
                title: Text('Voice',
                    style: GoogleFonts.manrope(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text(_ttsVoiceName ?? 'System default',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(fontSize: 11, color: cs.outline)),
                trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: () {
                  Navigator.pop(ctx);
                  _openVoicePicker();
                },
              ),
              if (SettingsStore.instance.getBool('beta_features_enabled') ??
                  false)
                _buildNeuralSection(cs, setSheet),
              _ttsSlider(
                icon: Icons.speed_rounded,
                label: 'Speed',
                value: _ttsRate,
                min: 0.3,
                max: 1.0,
                readout: '${(_ttsRate / 0.5).toStringAsFixed(1)}×',
                onChanged: (v) {
                  setSheet(() {});
                  _setTtsRate(v);
                },
              ),
              _ttsSlider(
                icon: Icons.graphic_eq_rounded,
                label: 'Pitch',
                value: _ttsPitch,
                min: 0.5,
                max: 2.0,
                readout: '${_ttsPitch.toStringAsFixed(1)}×',
                onChanged: (v) {
                  setSheet(() {});
                  _setTtsPitch(v);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  /// Experimental engine picker: Device vs offline Neural (sherpa-onnx), with a
  /// one-time model download. Only shown when beta features are enabled.
  Widget _buildNeuralSection(
      ColorScheme cs, void Function(VoidCallback) setSheet) {
    final v = NeuralVoice.byId(_neuralVoiceId);
    final loaded = NeuralTtsService.instance.isReady &&
        NeuralTtsService.instance.loadedVoiceId == v.id;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 8),
      Row(children: [
        Icon(Icons.auto_awesome_rounded, size: 16, color: cs.primary),
        const SizedBox(width: 6),
        Text('Voice engine (experimental)',
            style: GoogleFonts.manrope(
                fontSize: 11, fontWeight: FontWeight.w700, color: cs.outline)),
      ]),
      const SizedBox(height: 6),
      Wrap(spacing: 8, children: [
        ChoiceChip(
          label: const Text('Device'),
          selected: _ttsEngine == 'device',
          onSelected: _neuralBusy ? null : (_) => _setDeviceEngine(setSheet),
        ),
        for (final nv in NeuralVoice.all)
          ChoiceChip(
            label: Text(nv.label,
                style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
            selected: _ttsEngine == 'neural' && _neuralVoiceId == nv.id,
            onSelected:
                _neuralBusy ? null : (_) => _enableNeuralEngine(nv, setSheet),
          ),
      ]),
      if (_neuralDlProgress != null) ...[
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: _neuralDlProgress),
        ),
        const SizedBox(height: 4),
        Text(
            'Downloading ${v.label} — ${((_neuralDlProgress ?? 0) * 100).round()}%',
            style: GoogleFonts.manrope(fontSize: 10, color: cs.outline)),
      ] else if (_ttsEngine == 'neural') ...[
        const SizedBox(height: 6),
        Text(
            loaded
                ? 'Offline neural voice ready · ${v.license}'
                : 'Tap a neural voice to download it (~${v.sizeMb} MB, one time).',
            style: GoogleFonts.manrope(fontSize: 10, color: cs.outline)),
      ],
      const SizedBox(height: 4),
    ]);
  }

  Future<void> _setDeviceEngine(void Function(VoidCallback) setSheet) async {
    setState(() => _ttsEngine = 'device');
    setSheet(() {});
    await SettingsStore.instance.setString('novel_tts_engine', 'device');
    if (_ttsPlaying) await _restartSpeaking();
  }

  Future<void> _enableNeuralEngine(
      NeuralVoice v, void Function(VoidCallback) setSheet) async {
    if (_neuralBusy) return;
    setState(() {
      _neuralBusy = true;
      _neuralDlProgress = 0;
    });
    setSheet(() {});
    final ok = await NeuralTtsService.instance.ensureReady(v, onProgress: (p) {
      if (!mounted) return;
      setState(() => _neuralDlProgress = p);
      setSheet(() {});
    });
    if (!mounted) return;
    setState(() {
      _neuralBusy = false;
      _neuralDlProgress = null;
      if (ok) {
        _ttsEngine = 'neural';
        _neuralVoiceId = v.id;
      }
    });
    setSheet(() {});
    if (ok) {
      await SettingsStore.instance.setString('novel_tts_engine', 'neural');
      await SettingsStore.instance.setString('novel_tts_neural_voice', v.id);
      if (_ttsPlaying) await _restartSpeaking(); // switch over mid-chapter
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Could not set up the offline voice. Check your connection and try again.')));
    }
  }

  Widget _ttsSlider({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required String readout,
    required ValueChanged<double> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Row(children: [
      Icon(icon, size: 18, color: cs.outline),
      const SizedBox(width: 8),
      SizedBox(
          width: 44,
          child: Text(label,
              style: GoogleFonts.manrope(
                  fontSize: 13, fontWeight: FontWeight.w600))),
      Expanded(
        child: Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ),
      SizedBox(
          width: 40,
          child: Text(readout,
              textAlign: TextAlign.end,
              style: GoogleFonts.manrope(
                  fontSize: 13, fontWeight: FontWeight.w700))),
    ]);
  }

  int _firstVisibleParagraph() {
    final topGuard = MediaQuery.of(context).padding.top + kToolbarHeight;
    for (var i = 0; i < _paraKeys.length; i++) {
      final box = _paraKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy >= topGuard - 40) return i;
    }
    return 0;
  }

  void _scrollToTts() {
    final ctx = (_ttsIndex >= 0 && _ttsIndex < _paraKeys.length)
        ? _paraKeys[_ttsIndex].currentContext
        : null;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        alignment: 0.35,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic);
  }

  Future<void> _applyVoice(FlutterTts tts) async {
    if (_ttsVoiceName == null) return;
    try {
      await tts.setVoice({'name': _ttsVoiceName!, 'locale': _ttsVoiceLocale ?? ''});
    } catch (_) {
      // Voice no longer installed — fall back to the system default.
    }
  }

  // Common language codes → friendly names for the voice filter chips.
  static const Map<String, String> _kTtsLangNames = {
    'en': 'English', 'es': 'Spanish', 'ja': 'Japanese', 'ko': 'Korean',
    'zh': 'Chinese', 'fr': 'French', 'de': 'German', 'it': 'Italian',
    'pt': 'Portuguese', 'ru': 'Russian', 'ar': 'Arabic', 'hi': 'Hindi',
    'id': 'Indonesian', 'vi': 'Vietnamese', 'th': 'Thai', 'tr': 'Turkish',
    'nl': 'Dutch', 'pl': 'Polish', 'sv': 'Swedish', 'da': 'Danish',
    'fi': 'Finnish', 'no': 'Norwegian', 'nb': 'Norwegian', 'cs': 'Czech',
    'el': 'Greek', 'he': 'Hebrew', 'hu': 'Hungarian', 'ro': 'Romanian',
    'sk': 'Slovak', 'uk': 'Ukrainian', 'ms': 'Malay', 'fil': 'Filipino',
    'bn': 'Bengali', 'ta': 'Tamil', 'te': 'Telugu', 'ca': 'Catalan',
  };
  String _ttsLangLabel(String code) =>
      _kTtsLangNames[code] ?? code.toUpperCase();

  // iOS voice quality (default/enhanced/premium) → a friendly label.
  String _ttsQualityLabel(String q) {
    switch (q) {
      case 'enhanced':
        return 'Enhanced';
      case 'premium':
        return 'Premium';
      case 'default':
        return 'Normal';
      default:
        return q.isEmpty ? '' : q[0].toUpperCase() + q.substring(1);
    }
  }

  Future<void> _openVoicePicker() async {
    final t = AppLocalizations.of(context);
    final tts = await _ensureTts();
    final voices = <Map<String, String>>[];
    try {
      final raw = await tts.getVoices;
      if (raw is List) {
        for (final v in raw) {
          if (v is Map) {
            final name = v['name']?.toString() ?? '';
            final locale = v['locale']?.toString() ?? '';
            // iOS getVoices includes quality (default/enhanced/premium) +
            // identifier; Android/Windows omit them (empty string here).
            final quality = v['quality']?.toString().toLowerCase() ?? '';
            final id = v['identifier']?.toString() ?? '';
            if (name.isNotEmpty) {
              voices.add({
                'name': name,
                'locale': locale,
                'quality': quality,
                'identifier': id,
              });
            }
          }
        }
      }
    } catch (_) {}
    if (!mounted) return;
    if (voices.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.readerTtsNoVoices)));
      return;
    }
    // Device-language voices first, then by locale, then name.
    final dev = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    voices.sort((a, b) {
      final al = (a['locale'] ?? '').toLowerCase();
      final bl = (b['locale'] ?? '').toLowerCase();
      final ad = al.startsWith(dev) ? 0 : 1;
      final bd = bl.startsWith(dev) ? 0 : 1;
      if (ad != bd) return ad - bd;
      final lc = al.compareTo(bl);
      return lc != 0 ? lc : (a['name'] ?? '').compareTo(b['name'] ?? '');
    });
    final cs = Theme.of(context).colorScheme;
    String langOf(Map<String, String> v) =>
        (v['locale'] ?? '').split(RegExp('[-_]')).first.toLowerCase();
    // Unique language codes present, device language first, then alphabetical.
    final langList = (<String>{for (final v in voices) langOf(v)}
          ..removeWhere((e) => e.isEmpty))
        .toList()
      ..sort((a, b) {
        if (a == dev && b != dev) return -1;
        if (b == dev && a != dev) return 1;
        return a.compareTo(b);
      });
    // iOS exposes per-voice quality; build the quality filter only when that
    // data is present (so it doesn't show up empty on Android/Windows).
    const qualityOrder = ['default', 'enhanced', 'premium'];
    final qualityList = qualityOrder
        .where((qv) => voices.any((v) => (v['quality'] ?? '') == qv))
        .toList();
    final hasQuality = qualityList.length > 1;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        var query = '';
        var langFilter = 'all';
        var qualityFilter = 'all';
        return StatefulBuilder(builder: (ctx, setSheet) {
          final q = query.trim().toLowerCase();
          final filtered = voices.where((v) {
            if (langFilter != 'all' && langOf(v) != langFilter) return false;
            if (qualityFilter != 'all' && (v['quality'] ?? '') != qualityFilter) {
              return false;
            }
            if (q.isEmpty) return true;
            return (v['name'] ?? '').toLowerCase().contains(q) ||
                (v['locale'] ?? '').toLowerCase().contains(q);
          }).toList();
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(ctx).size.height * 0.85),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(children: [
                    Icon(Icons.record_voice_over_rounded,
                        color: cs.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(t.readerTtsVoice,
                        style: GoogleFonts.manrope(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('${filtered.length}',
                        style: GoogleFonts.manrope(
                            fontSize: 12, color: cs.outline)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    onChanged: (s) => setSheet(() => query = s),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search voices',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                if (langList.length > 1)
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        for (final l in <String>['all', ...langList])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(l == 'all' ? 'All' : _ttsLangLabel(l)),
                              selected: langFilter == l,
                              onSelected: (_) =>
                                  setSheet(() => langFilter = l),
                            ),
                          ),
                      ],
                    ),
                  ),
                // iOS only: filter by voice quality (Normal / Enhanced / Premium).
                if (hasQuality)
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        for (final qv in <String>['all', ...qualityList])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(qv == 'all'
                                  ? 'All quality'
                                  : _ttsQualityLabel(qv)),
                              selected: qualityFilter == qv,
                              onSelected: (_) =>
                                  setSheet(() => qualityFilter = qv),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 4),
                Flexible(
                  child: ListView.builder(
                    itemCount: filtered.length + 1,
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        final sel = _ttsVoiceName == null;
                        return ListTile(
                          leading: Icon(
                              sel
                                  ? Icons.check_rounded
                                  : Icons.devices_rounded,
                              color: sel ? cs.primary : cs.outline),
                          title: Text(t.readerTtsSystemVoice),
                          onTap: () {
                            Navigator.pop(ctx);
                            _selectVoice(null, null);
                          },
                        );
                      }
                      final v = filtered[i - 1];
                      final sel = v['name'] == _ttsVoiceName;
                      return ListTile(
                        leading: Icon(
                            sel
                                ? Icons.check_rounded
                                : Icons.record_voice_over_outlined,
                            color: sel ? cs.primary : cs.outline),
                        title: Text(v['name'] ?? '',
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text([
                          v['locale'] ?? '',
                          if ((v['quality'] ?? '').isNotEmpty)
                            _ttsQualityLabel(v['quality']!)
                        ].where((e) => e.isNotEmpty).join(' · ')),
                        onTap: () {
                          Navigator.pop(ctx);
                          _selectVoice(v['name'], v['locale']);
                        },
                      );
                    },
                  ),
                ),
              ]),
            ),
          );
        });
      },
    );
  }

  Future<void> _selectVoice(String? name, String? locale) async {
    setState(() {
      _ttsVoiceName = name;
      _ttsVoiceLocale = locale;
    });
    final prefs = SettingsStore.instance;
    if (name == null) {
      await prefs.remove('novel_tts_voice_name');
      await prefs.remove('novel_tts_voice_locale');
    } else {
      await prefs.setString('novel_tts_voice_name', name);
      await prefs.setString('novel_tts_voice_locale', locale ?? '');
    }
    final tts = await _ensureTts();
    await _applyVoice(tts);
    // Apply immediately by re-speaking from the current sentence in the new
    // voice (gated so the stop() doesn't advance/double-read).
    await _restartSpeaking();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final (themeBg, themeText) = _themeColors(cs);
    return Scaffold(
      backgroundColor: themeBg,
      appBar: AppBar(
        title: Text(_title ?? widget.mangaTitle ?? t.readerReadingTitle,
            style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_gazeActive || _tiltActive)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 4),
              child: Icon(
                  _gazeActive
                      ? Icons.visibility_rounded
                      : Icons.screen_rotation_rounded,
                  size: 20,
                  color: cs.primary),
            ),
          if (_ttsSupported &&
              !_loading &&
              _error == null &&
              _paragraphs.isNotEmpty)
            Tooltip(
              message: _ttsActive ? t.readerTtsStop : t.readerListen,
              // InkResponse handles tap AND long-press in one recognizer so the
              // long-press (voice / speed / pitch) actually fires — a
              // GestureDetector wrapping an IconButton loses the long-press to
              // the button's own tap handler in the gesture arena.
              child: InkResponse(
                radius: 22,
                onTap: () => _ttsActive ? _stopTts() : _startTts(),
                // Long-press to change voice / speed / pitch without starting
                // playback first.
                onLongPress: _openTtsTuning,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(_ttsActive
                      ? Icons.headset_off_rounded
                      : Icons.headphones_rounded),
                ),
              ),
            ),
          IconButton(
            tooltip: t.readerSmallerText,
            icon: const Icon(Icons.text_decrease_rounded),
            onPressed: () => _setFontSize(_fontSize - 1),
          ),
          IconButton(
            tooltip: 'Reader theme',
            icon: const Icon(Icons.palette_outlined),
            onPressed: _pickNovelTheme,
          ),
          IconButton(
            tooltip: 'Text settings',
            icon: const Icon(Icons.tune_rounded),
            onPressed: _openNovelSettings,
          ),
          IconButton(
            tooltip: t.readerLargerText,
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: () => _setFontSize(_fontSize + 1),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.error_outline_rounded, color: cs.error, size: 40),
                  const SizedBox(height: 12),
                  Text(_error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(fontSize: 13, color: cs.outline)),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _load, child: Text(t.readerRetry)),
                ]))
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(_hMargin, 16, _hMargin,
                      32 + MediaQuery.of(context).viewPadding.bottom),
                  itemCount: _paragraphs.length + 1,
                  itemBuilder: (_, i) {
                    if (i == _paragraphs.length) return _navBar(cs);
                    final isReading = _ttsActive && i == _ttsIndex;
                    return Container(
                      key: i < _paraKeys.length ? _paraKeys[i] : null,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: isReading
                          ? const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4)
                          : EdgeInsets.zero,
                      decoration: isReading
                          ? BoxDecoration(
                              color: cs.primary.withAlpha(28),
                              borderRadius: BorderRadius.circular(8),
                            )
                          : null,
                      child: isReading
                          ? _readingParagraph(
                              _paragraphs[i], _novelTextStyle(themeText), cs)
                          : SelectableText(
                              _paragraphs[i],
                              textAlign: _textAlignValue(),
                              style: _novelTextStyle(themeText),
                            ),
                    );
                  },
                ),
      bottomNavigationBar: _ttsActive ? _ttsBar(cs, t) : null,
    );
  }

  Widget _ttsBar(ColorScheme cs, AppLocalizations t) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(children: [
          IconButton(
            icon: Icon(
                _ttsPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
            tooltip: _ttsPlaying ? t.readerTtsStop : t.readerListen,
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: const Icon(Icons.stop_rounded),
            tooltip: t.readerTtsStop,
            onPressed: _stopTts,
          ),
          IconButton(
            icon: const Icon(Icons.record_voice_over_rounded),
            tooltip: t.readerTtsVoice,
            onPressed: _openVoicePicker,
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Speed & pitch',
            onPressed: _openTtsTuning,
          ),
          const Spacer(),
          Icon(Icons.speed_rounded, size: 18, color: cs.outline),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove_rounded),
            tooltip: t.readerTtsSpeed,
            onPressed: () => _setTtsRate(_ttsRate - 0.1),
          ),
          Text('${(_ttsRate / 0.5).toStringAsFixed(1)}×',
              style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface)),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add_rounded),
            tooltip: t.readerTtsSpeed,
            onPressed: () => _setTtsRate(_ttsRate + 0.1),
          ),
        ]),
      ),
    );
  }

  Widget _navBar(ColorScheme cs) {
    if (widget.chapters == null) return const SizedBox.shrink();
    final t = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        OutlinedButton.icon(
          onPressed: _hasPrev ? () => _go(1) : null,
          icon: const Icon(Icons.chevron_left_rounded, size: 18),
          label: Text(t.readerPrevious),
        ),
        OutlinedButton.icon(
          onPressed: _hasNext ? () => _go(-1) : null,
          icon: const Icon(Icons.chevron_right_rounded, size: 18),
          label: Text(t.readerNext),
        ),
      ]),
    );
  }
}
