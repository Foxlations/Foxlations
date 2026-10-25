import 'dart:async';
import 'dart:io' show Platform, File;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, Clipboard, ClipboardData;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:hyphenatorx/languages/language_en_us.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:path_provider/path_provider.dart';

import '../../core/models/manga_model.dart';
import '../../core/providers/library_provider.dart';
import '../../core/providers/vault_provider.dart';
import '../../core/providers/library_like.dart';
import '../../core/services/image_loader.dart';
import '../widgets/type_toggle.dart';
import '../reader_screen/widgets/radial_reader_menu.dart';
import '../reader_screen/widgets/radial_config.dart';
import '../reader_screen/widgets/reader_save_throttle.dart';
import 'novel_reader_options.dart';
import 'widgets/dictionary_sheet.dart';
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
import '../../core/services/read_time_tracker.dart';
import '../../theme/app_theme.dart';
import '../../core/services/tts/neural_tts_service.dart';
import '../../eval/lib.dart';
import '../../l10n/app_localizations.dart';

part 'novel_reader_screen_tts.dart';

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

  /// True when reading a VAULT novel - routes progress/read-marks to the vault.
  final bool isVault;

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
    this.isVault = false,
  });

  @override
  State<NovelReaderScreen> createState() => _NovelReaderScreenState();
}

class _NovelReaderScreenState extends State<NovelReaderScreen> with _NovelTts {
  final ScrollController _scrollController = ScrollController();
  // Volume-key hold detection: tap = scroll ~a screen, hold = slow fluid scroll.
  Timer? _holdTimer;
  Timer? _holdScrollTimer;
  bool _holdScrolling = false;
  double _volScrollSpeed = 600.0;
  // Hands-free (gaze) scrolling - iOS only; feeds the same fluid-scroll loop.
  Timer? _gazeTimer;
  int _gazeDelta = 0;
  double _gazeSpeed = 0;
  bool _gazeActive = false;
  bool _tiltActive = false;
  // Immersive HUD: tap the page to hide/reveal the top + bottom bars.
  bool _hudVisible = true;
  // Enabled LN wheel-action keys in the user's order (radial customization),
  // read once when the reader opens.
  final List<String> _radialOrder = RadialMenuConfig.enabledOrder('novel');
  // Radial reader menu (shared with the manga reader). Default on; the classic
  // top/bottom bars remain as a fallback when this is off.
  bool _novelRadialEnabled = true;
  String _novelRadialStyle = 'wheel';
  // Continuous-text reading has no "pages", so we persist the exact SCROLL OFFSET
  // (debounced) and restore it, so "continue" lands where you actually stopped.
  final ReaderSaveThrottle _saveThrottle = ReaderSaveThrottle();
  @override
  LibraryLike? _lib;
  // Accumulates ACTIVE read time per novel for Reading Insights. Pinged on
  // scroll + chapter change; idles out when untouched or backgrounded.
  ReadTimeTracker? _timeTracker;
  double _lastOffset = 0;
  // Latest text the reader has selected (via the whole-page SelectionArea), so
  // the context menu can offer "Define" on it. Selection works while reading,
  // not only on the paragraph TTS happens to be on.
  String _selectedText = '';
  // Tap-to-reveal is detected with a raw Listener, not a GestureDetector:
  // SelectionArea's touch recognizer (TapAndHorizontalDrag) wins the gesture
  // arena and would swallow an ancestor onTap. A Listener sees pointer events
  // regardless of the arena, so a quick, still press toggles the bars while a
  // long-press / drag is left to selection and scrolling.
  Offset? _tapDownPos;
  int _tapDownMs = 0;
  // Height of the open radial settings panel (null when none). The Listen pill
  // lifts clear of a panel, not just the shorter tail base.
  double? _radialPanelHeight;
  @override
  List<String> _paragraphs = [];
  // The paragraphs as rendered: soft hyphens (U+00AD) inserted inside long
  // words when hyphenation is on, so justified lines break mid-word instead of
  // leaving big gaps. Kept separate from _paragraphs so TTS, resume and the
  // highlight offsets still work off the original text. Stripped back out for
  // copy / Define (see _stripSoftHyphens).
  List<String> _displayParagraphs = [];
  bool _loading = true;
  String? _error;
  double _fontSize = 18;
  // Reader theme for eye comfort: default (app theme), sepia, warm, gray, oled.
  String _novelTheme = 'default';
  // Text customization.
  double _lineHeight = 1.7;
  String _textAlign = 'left'; // left | justify | center
  double _hMargin = 20.0;
  bool _hyphenate = true; // soft-hyphenate long words (helps justified text)
  String _fontFamily = 'serif'; // serif | sans | mono

  // English Liang-pattern hyphenator (pure Dart, bundled patterns). Built once,
  // lazily, and only touched when hyphenation is on. The '­' symbol is a
  // soft hyphen: invisible unless the line breaker uses it.
  static Hyphenator? _hyphenatorCache;
  static Hyphenator get _hyphenator =>
      _hyphenatorCache ??= Hyphenator(Language_en_us(), symbol: '­');

  static const String _softHyphen = '­';
  String _stripSoftHyphens(String s) => s.replaceAll(_softHyphen, '');

  /// Recompute [_displayParagraphs] from [_paragraphs] for the current
  /// hyphenation setting. Cheap: chapters are text-light and the hyphenator
  /// caches per word.
  void _rebuildDisplayParagraphs() {
    _displayParagraphs = _hyphenate
        ? [for (final p in _paragraphs) _hyphenator.hyphenateText(p)]
        : _paragraphs;
  }

  // ── Page-flip (paged) layout ─────────────────────────────────
  // 'scroll' (continuous, the default) or 'paged' (swipe between discrete
  // pages, e-reader style). Paged keeps the same paragraph widgets, so TTS
  // highlight, selection and hyphenation all behave the same; only the
  // container changes.
  String _novelLayout = 'scroll';
  final PageController _novelPageController = PageController();
  List<List<int>> _novelPages = []; // paragraph indices per page
  int _novelPage = 0;
  // Signature of the inputs the pagination depends on; when it changes we
  // repaginate (viewport, font, spacing, margins, alignment, hyphenation,
  // paragraph count).
  String _novelPagedSig = '';
  // On first paged layout, land on the resumed position (via startFraction);
  // afterwards a reflow just preserves the paragraph you were on.
  bool _novelPagedRestorePending = false;
  // When switching INTO paged mode mid-read, the paragraph to land the first
  // page on (captured from the scroll position before the switch).
  int? _novelPagedAnchorOverride;

  @override
  bool get _paged => _novelLayout == 'paged';

  /// Group paragraphs into pages that fit [box] for the current text [style].
  /// Paragraph-granular: a page ends at a paragraph boundary (natural for a
  /// novel), and a paragraph taller than a whole page gets its own page (which
  /// can scroll vertically as a fallback).
  List<List<int>> _paginate(Size box, TextStyle style) {
    const gap = 16.0; // the bottom margin between paragraphs
    final pages = <List<int>>[];
    var cur = <int>[];
    var used = 0.0;
    final tp = TextPainter(
        textDirection: TextDirection.ltr, textAlign: _textAlignValue());
    for (var i = 0; i < _paragraphs.length; i++) {
      final text =
          i < _displayParagraphs.length ? _displayParagraphs[i] : _paragraphs[i];
      tp.text = TextSpan(text: text, style: style);
      tp.layout(maxWidth: box.width);
      final h = tp.height + gap;
      if (cur.isNotEmpty && used + h > box.height) {
        pages.add(cur);
        cur = <int>[];
        used = 0;
      }
      cur.add(i);
      used += h;
    }
    if (cur.isNotEmpty) pages.add(cur);
    tp.dispose();
    return pages.isEmpty ? [<int>[]] : pages;
  }

  /// The paragraph index the reader is currently on, in either layout, used to
  /// keep your place across a reflow or a layout switch.
  int _novelAnchorParagraph() {
    if (_paged) {
      if (_novelPages.isNotEmpty &&
          _novelPage < _novelPages.length &&
          _novelPages[_novelPage].isNotEmpty) {
        return _novelPages[_novelPage].first;
      }
      return 0;
    }
    return _firstVisibleParagraph();
  }

  /// Switch between scroll and paged layouts, keeping your place.
  void _setNovelLayout(String mode) {
    if (mode == _novelLayout) return;
    final anchor = _novelAnchorParagraph();
    setState(() {
      _novelLayout = mode;
      _novelPagedSig = ''; // force a repaginate for the new box
      if (mode == 'paged') {
        _novelPagedAnchorOverride = anchor;
        _novelPagedRestorePending = false;
      }
    });
    SettingsStore.instance.setString('novel_layout', mode);
    if (mode == 'scroll') {
      // Land the scroll view on the paragraph the current page started on.
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToParagraph(anchor));
    }
  }

  /// Ensure paragraph [i] is visible in scroll mode (used when leaving paged).
  void _scrollToParagraph(int i) {
    if (i < 0 || i >= _paraKeys.length) return;
    final ctx = _paraKeys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 250), alignment: 0.02);
    }
  }

  /// In paged mode, flip to the page that holds paragraph [i] (used to follow
  /// TTS as it reads across page boundaries).
  @override
  void _novelPageForParagraph(int i, {bool animate = true}) {
    if (!_paged || _novelPages.isEmpty || !_novelPageController.hasClients) return;
    for (var pi = 0; pi < _novelPages.length; pi++) {
      if (_novelPages[pi].contains(i)) {
        if (pi != _novelPage) {
          animate
              ? _novelPageController.animateToPage(pi,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut)
              : _novelPageController.jumpToPage(pi);
        }
        return;
      }
    }
  }

  /// Next page in paged mode, rolling onto the next chapter past the last page.
  void _novelNextPage() {
    if (!_novelPageController.hasClients) return;
    if (_novelPage < _novelPages.length - 1) {
      _novelPageController.nextPage(
          duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    } else if (_hasNext) {
      _go(-1); // chapter list is newest-first → next chapter = index-1
    }
  }

  /// Previous page, rolling onto the previous chapter before the first page.
  void _novelPrevPage() {
    if (!_novelPageController.hasClients) return;
    if (_novelPage > 0) {
      _novelPageController.previousPage(
          duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    } else if (_hasPrev) {
      _go(1);
    }
  }

  // Curated reading fonts (id → display name), grouped serif → sans →
  // accessible → mono. 'serif'/'sans'/'mono' keep their old meaning so saved
  // preferences carry over. Rendered via GoogleFonts (downloaded + cached once).
  TextStyle _fontFor(String id, TextStyle base) => switch (id) {
        'lora' => GoogleFonts.lora(textStyle: base),
        'merriweather' => GoogleFonts.merriweather(textStyle: base),
        'bitter' => GoogleFonts.bitter(textStyle: base),
        'literata' => GoogleFonts.literata(textStyle: base),
        'ebGaramond' => GoogleFonts.ebGaramond(textStyle: base),
        'ptSerif' => GoogleFonts.ptSerif(textStyle: base),
        'sans' => GoogleFonts.notoSans(textStyle: base),
        'inter' => GoogleFonts.inter(textStyle: base),
        'openSans' => GoogleFonts.openSans(textStyle: base),
        'nunitoSans' => GoogleFonts.nunitoSans(textStyle: base),
        'atkinson' => GoogleFonts.atkinsonHyperlegible(textStyle: base),
        'lexend' => GoogleFonts.lexend(textStyle: base),
        'mono' => GoogleFonts.robotoMono(textStyle: base),
        _ => GoogleFonts.notoSerif(textStyle: base),
      };

  TextStyle _novelTextStyle(Color color) => _fontFor(_fontFamily,
      TextStyle(fontSize: _fontSize, height: _lineHeight, color: color));

  /// Shared scrollable font list (live preview - each name is drawn in its own
  /// font). [onColor]/[accent] let it suit both the dark radial panel and the
  /// light settings sheet; [refresh] re-runs the host. Selecting persists.
  Widget _fontListView(Color onColor, Color accent, void Function() refresh) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        for (final (id, label) in novelFonts)
          GestureDetector(
            onTap: () {
              setState(() => _fontFamily = id);
              SettingsStore.instance.setString('novel_font_family', id);
              refresh();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 3),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: _fontFamily == id
                    ? accent.withValues(alpha: 0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _fontFamily == id
                        ? accent
                        : onColor.withValues(alpha: 0.18)),
              ),
              child: Row(children: [
                Expanded(
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _fontFor(
                          id,
                          TextStyle(
                              fontSize: 15,
                              color: onColor,
                              fontWeight: FontWeight.w600))),
                ),
                if (_fontFamily == id)
                  Icon(Icons.check_rounded, size: 18, color: accent),
              ]),
            ),
          ),
      ],
    );
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

  /// The single reader menu opened by the top-bar "Aa" button - everything that
  /// used to live as separate top-bar icons (text size, font, theme, alignment,
  /// spacing, margins) plus Listen (TTS), in one coral-accented sheet.
  void _openReaderMenu() {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                            color: cs.outline,
                            borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 16),
                  _sheetLabel('Text size', cs),
                  Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(children: [
                      IconButton(
                        icon: const Icon(Icons.text_decrease_rounded),
                        tooltip: t.readerSmallerText,
                        onPressed: () {
                          _setFontSize(_fontSize - 1);
                          setSheet(() {});
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text('${_fontSize.round()} pt',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.text_increase_rounded),
                        tooltip: t.readerLargerText,
                        onPressed: () {
                          _setFontSize(_fontSize + 1);
                          setSheet(() {});
                        },
                      ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  _sheetLabel('Font', cs),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: _fontListView(
                        cs.onSurface, cs.primary, () => setSheet(() {})),
                  ),
                  const SizedBox(height: 14),
                  _sheetLabel('Reader theme', cs),
                  Row(children: [
                    for (final (id, bg, fg) in const [
                      ('default', null, null),
                      ('sepia', Color(0xFFF4ECD8), Color(0xFF5B4636)),
                      ('warm', Color(0xFFFBF0E0), Color(0xFF3A2E22)),
                      ('gray', Color(0xFF1E1E1E), Color(0xFFD2D2D2)),
                      ('oled', Color(0xFF000000), Color(0xFFC2C2C2)),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _novelTheme = id);
                            p.setString('novel_reader_theme', id);
                            setSheet(() {});
                          },
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: bg ?? cs.surfaceContainerHighest,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMedium),
                              border: Border.all(
                                  color: _novelTheme == id
                                      ? cs.primary
                                      : cs.outlineVariant,
                                  width: _novelTheme == id ? 2 : 1),
                            ),
                            child: Center(
                              child: Text('A',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: fg ?? cs.onSurface)),
                            ),
                          ),
                        ),
                      ),
                  ]),
                  const SizedBox(height: 14),
                  _sheetLabel('Reading mode', cs),
                  TypeToggle(
                    items: const [
                      TypeToggleItem('scroll', 'Scroll'),
                      TypeToggleItem('paged', 'Paged'),
                    ],
                    selectedId: _novelLayout,
                    onChanged: (id) {
                      _setNovelLayout(id);
                      setSheet(() {});
                    },
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(child: _sheetLabel('Hyphenation', cs)),
                      Switch(
                        value: _hyphenate,
                        onChanged: (v) {
                          setState(() {
                            _hyphenate = v;
                            _rebuildDisplayParagraphs();
                          });
                          setSheet(() {});
                          p.setBool('novel_hyphenate', v);
                        },
                      ),
                    ],
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
                  if (_ttsSupported) ...[
                    const SizedBox(height: 10),
                    InkWell(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                      onTap: () {
                        Navigator.pop(context);
                        _ttsActive ? _stopTts() : _startTts();
                      },
                      onLongPress: () {
                        Navigator.pop(context);
                        _openTtsTuning();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Row(children: [
                          Icon(
                              _ttsActive
                                  ? Icons.headset_off_rounded
                                  : Icons.headphones_rounded,
                              size: 19,
                              color: cs.primary),
                          const SizedBox(width: 10),
                          Text(_ttsActive ? t.readerTtsStop : t.readerListen,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface)),
                          const Spacer(),
                          Icon(Icons.chevron_right_rounded,
                              size: 18, color: cs.outline),
                        ]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary)),
        ),
      );

  late int _index;
  @override
  late String _url;
  @override
  String? _title;

  @override
  List<GlobalKey> _paraKeys = [];

  @override
  void initState() {
    super.initState();
    _index = widget.currentIndex;
    _url = widget.chapterUrl;
    _title = widget.chapterTitle;
    // Font size is per-reader and now PERSISTED - it used to reset to 18 on
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
    _hyphenate = p.getBool('novel_hyphenate') ?? true;
    _hMargin = (p.getDouble('novel_margin') ?? 20.0).clamp(8.0, 48.0);
    _fontFamily = p.getString('novel_font_family') ?? 'serif';
    _novelLayout = p.getString('novel_layout') ?? 'scroll';
    // Starting in paged mode with a saved position: land on it once the first
    // pagination is known (paged resume is fraction-based, see _saveProgress).
    _novelPagedRestorePending =
        _paged && (widget.startFraction > 0 || widget.startOffset > 0);
    _novelRadialEnabled = p.getBool('novel_radial_enabled') ?? true;
    _novelRadialStyle = p.getString('novel_radial_style') ?? 'wheel';
    _applyScreenPrefs();
    _scrollController.addListener(_saveProgress);
    _timeTracker = ReadTimeTracker(onCredit: (secs) async {
      final url = widget.mangaUrl;
      if (!mounted || url == null) return;
      await _store.addReadTime(widget.sourceId, url, secs);
    })..start();
    _load();
    _maybeEnableVolumeKeys();
    _maybeEnableGaze();
    _maybeEnableTilt();
    _loadTtsRate();
  }

  /// Honour the shared reader prefs the manga reader already respects - the
  /// novel reader ignored both, so the screen could sleep mid-read and
  /// fullscreen never applied.
  void _applyScreenPrefs() {
    // Per-reader now: novels have their own keep-on / fullscreen, falling back
    // to the old shared key so existing choices carry over.
    final keepOn = SettingsStore.instance.getBool('novel_keep_screen_on') ??
        SettingsStore.instance.getBool('reader_keep_screen_on') ??
        true;
    if (keepOn) WakelockPlus.enable().catchError((_) {});
    final fullscreen =
        SettingsStore.instance.getBool('novel_fullscreen') ??
            SettingsStore.instance.getBool('reader_fullscreen') ??
            false;
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

  /// The owning store for this novel (vault vs public library), selected by the
  /// [isVault] flag threaded through navigation.
  @override
  LibraryLike get _store => widget.isVault
      ? context.read<VaultProvider>()
      : context.read<LibraryProvider>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lib ??= _store;
  }

  // Persist the scroll offset (as the manga's lastReadPage) a second after scrolling
  // stops, so it survives quick exits without saving on every pixel.
  void _saveProgress() {
    if (_paged) {
      _saveProgressPaged();
      return;
    }
    if (!_scrollController.hasClients) return;
    _timeTracker?.ping(); // scrolling counts as active reading
    _lastOffset = _scrollController.offset;
    if (widget.mangaUrl == null) return;
    // Reaching (near) the bottom = finished this chapter → mark read + sync
    // trackers, once. Novels never did this, so their unread counts never
    // dropped from reading and bound trackers never advanced.
    if (!_markedRead && _currentFraction() >= 0.98) _markReadIfEnd();
    _saveThrottle.trailing(const Duration(seconds: 1), () {
      if (!mounted || _lib == null) return;
      _lib!.updateNovelProgress(widget.sourceId, widget.mangaUrl!, _url,
          _lastOffset.round(), _currentFraction());
    });
  }

  /// Paged-mode progress: a fraction over the page count (mode-agnostic, so a
  /// switch to scroll resumes at the same spot). Offset is left 0; paged resume
  /// reads the fraction, not a pixel offset.
  void _saveProgressPaged() {
    _timeTracker?.ping();
    if (widget.mangaUrl == null || _novelPages.length < 2) return;
    final frac = (_novelPage / (_novelPages.length - 1)).clamp(0.0, 1.0);
    _saveThrottle.trailing(const Duration(seconds: 1), () {
      if (!mounted || _lib == null) return;
      _lib!.updateNovelProgress(
          widget.sourceId, widget.mangaUrl!, _url, 0, frac);
    });
  }

  bool _markedRead = false;
  void _markReadIfEnd() {
    final mangaUrl = widget.mangaUrl;
    if (_markedRead || mangaUrl == null || _lib == null) return;
    _markedRead = true;
    if (!IncognitoProvider.active) {
      _lib!.markChapterRead(widget.sourceId, mangaUrl, _url, active: true);
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
    _volScrollSpeed = prefs.getDouble('reader_volume_scroll_speed') ?? 600.0;
    // iOS: the volume buttons no longer scroll or turn pages; they only tune the
    // manga auto-scroll speed, which this reader doesn't have. So capture them on
    // Android only.
    if (!Platform.isAndroid) return;
    final beta = prefs.getBool('beta_features_enabled') ?? false; // volume-key nav is beta
    final on = beta && (prefs.getBool('reader_volume_keys') ?? false);
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
    _neuralPlayingSub?.cancel();
    _neuralPauseDebounce?.cancel();
    _neuralPlayer?.dispose();
    if (_ttsActive) ttsMediaSession?.unbind();
    _gazeTimer?.cancel();
    _saveThrottle.cancel();
    _timeTracker?.dispose();
    _scrollController.removeListener(_saveProgress);
    // Flush the final reading position. Paged mode stores a fraction over the
    // page count (offset 0); scroll mode its pixel offset + fraction.
    if (widget.mangaUrl != null && _lib != null) {
      if (_paged && _novelPages.length > 1) {
        final frac = (_novelPage / (_novelPages.length - 1)).clamp(0.0, 1.0);
        _lib!.updateNovelProgress(
            widget.sourceId, widget.mangaUrl!, _url, 0, frac);
      } else if (_lastOffset > 0) {
        _lib!.updateNovelProgress(widget.sourceId, widget.mangaUrl!, _url,
            _lastOffset.round(), _currentFraction());
      }
    }
    _holdTimer?.cancel();
    _holdScrollTimer?.cancel();
    _scrollController.dispose();
    _novelPageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    _markedRead = false; // new chapter - allow marking it read on reaching its end
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
      _rebuildDisplayParagraphs();
      // New chapter text → the paged layout must repaginate from the top.
      _novelPages = [];
      _novelPage = 0;
      _novelPagedSig = '';
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

  @override
  bool get _hasPrev =>
      widget.chapters != null && _index < widget.chapters!.length - 1;
  @override
  bool get _hasNext => widget.chapters != null && _index > 0;

  @override
  void _go(int delta) {
    final chapters = widget.chapters;
    if (chapters == null) return;
    final next = _index + delta;
    if (next < 0 || next >= chapters.length) return;
    _timeTracker?.ping(); // changing chapter counts as active reading
    setState(() {
      _index = next;
      _url = (chapters[next]['url'] ?? '').toString();
      _title = (chapters[next]['name'] ?? '').toString();
    });
    _load();
  }

  // ── Text-to-speech ──────────────────────────────────────
  /// Adds a "Define" action to the text-selection toolbar (dictionary lookup),
  /// keeping the platform's default actions (Copy / Select all / …).
  Widget _novelSelectionMenu(
      BuildContext context, SelectableRegionState state) {
    final items = List<ContextMenuButtonItem>.of(state.contextMenuButtonItems);
    // The rendered text may carry soft hyphens (hyphenation); strip them so
    // Define and Copy get clean words, not words with invisible breaks in them.
    final clean = _stripSoftHyphens(_selectedText);
    final selected = clean.trim();
    // Copy the clean text rather than the hyphenated selection.
    for (var i = 0; i < items.length; i++) {
      if (items[i].type == ContextMenuButtonType.copy) {
        items[i] = ContextMenuButtonItem(
          type: ContextMenuButtonType.copy,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: clean));
            state.hideToolbar();
          },
        );
      }
    }
    if (selected.isNotEmpty && selected.length <= 40) {
      items.insert(
        0,
        ContextMenuButtonItem(
          label: AppLocalizations.of(context).novelDefine,
          onPressed: () {
            state.hideToolbar();
            DictionarySheet.show(context, selected);
          },
        ),
      );
    }
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: state.contextMenuAnchors,
      buttonItems: items,
    );
  }

  /// The paragraph currently being read: the active sentence is coloured +
  /// bolded on top of the paragraph's soft background. Plain text when the
  /// engine hasn't reported a sentence yet (or doesn't support progress).
  Widget _readingParagraph(String text, TextStyle style, ColorScheme cs) {
    if (_ttsSentence < 0 || _ttsSentence >= _ttsSentences.length) {
      return Text(text, textAlign: _textAlignValue(), style: style);
    }
    final s = _ttsSentences[_ttsSentence].$1.clamp(0, text.length);
    final e = _ttsSentences[_ttsSentence].$2.clamp(s, text.length);
    final sentenceHl =
        _ttsSentenceColor != null ? Color(_ttsSentenceColor!) : cs.primary;
    final wordHl =
        _ttsWordColor != null ? Color(_ttsWordColor!) : cs.primary;
    final active = style.copyWith(color: sentenceHl, fontWeight: FontWeight.w700);
    // The current word (if the engine reported one, and it sits inside the lit
    // sentence) gets its own colour + a soft pill on top of the sentence colour.
    // Falls back to the whole sentence when there's no word yet or it maps outside.
    final wordStyle = active.copyWith(
        color: wordHl, backgroundColor: wordHl.withValues(alpha: 0.18));
    final hasWord = _ttsWordStart >= s && _ttsWordEnd > _ttsWordStart && _ttsWordEnd <= e;
    final sentence = <TextSpan>[];
    if (hasWord) {
      if (_ttsWordStart > s) {
        sentence.add(TextSpan(text: text.substring(s, _ttsWordStart), style: active));
      }
      sentence.add(TextSpan(
          text: text.substring(_ttsWordStart, _ttsWordEnd), style: wordStyle));
      if (_ttsWordEnd < e) {
        sentence.add(TextSpan(text: text.substring(_ttsWordEnd, e), style: active));
      }
    } else {
      sentence.add(TextSpan(text: text.substring(s, e), style: active));
    }
    return Text.rich(
      TextSpan(style: style, children: [
        if (s > 0) TextSpan(text: text.substring(0, s)),
        ...sentence,
        if (e < text.length) TextSpan(text: text.substring(e)),
      ]),
      textAlign: _textAlignValue(),
    );
  }

  @override
  int _firstVisibleParagraph() {
    final topGuard = MediaQuery.paddingOf(context).top + kToolbarHeight;
    for (var i = 0; i < _paraKeys.length; i++) {
      final box = _paraKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy >= topGuard - 40) return i;
    }
    return 0;
  }

  void _toggleHud() => setState(() => _hudVisible = !_hudVisible);

  // ── Radial reader menu (shared RadialReaderMenu) ───────────────────────────

  double _scrollProgress() {
    if (!_scrollController.hasClients) return 0;
    final pos = _scrollController.position;
    // maxScrollExtent asserts hasContentDimensions - reading it during the first
    // layout (before the list is measured) throws a null-check error.
    if (!pos.hasContentDimensions) return 0;
    final max = pos.maxScrollExtent;
    if (max <= 0) return 0;
    return (pos.pixels / max).clamp(0.0, 1.0);
  }

  /// Reading progress 0..1 for the HUD, in whichever layout is active: the page
  /// position in paged mode, the scroll fraction in scroll mode.
  double _novelProgress() {
    if (_paged) {
      return _novelPages.length < 2
          ? 0
          : (_novelPage / (_novelPages.length - 1)).clamp(0.0, 1.0);
    }
    return _scrollProgress();
  }

  /// Seek the reader to fraction [frac] (0..1) from a HUD progress drag.
  void _seekNovel(double frac) {
    final v = frac.clamp(0.0, 1.0);
    if (_paged) {
      if (!_novelPageController.hasClients || _novelPages.length < 2) return;
      _novelPageController.jumpToPage((v * (_novelPages.length - 1)).round());
    } else if (_scrollController.hasClients &&
        _scrollController.position.hasContentDimensions) {
      _scrollController.jumpTo(v * _scrollController.position.maxScrollExtent);
    }
  }

  // (bg, fg) for a theme id - used to paint the little theme swatches.
  (Color?, Color) _themeColorsFor(String id) => switch (id) {
        'sepia' => (const Color(0xFFF4ECD8), const Color(0xFF5B4636)),
        'warm' => (const Color(0xFFFBF0E0), const Color(0xFF3A2E22)),
        'gray' => (const Color(0xFF1E1E1E), const Color(0xFFD2D2D2)),
        'oled' => (const Color(0xFF000000), const Color(0xFFC2C2C2)),
        _ => (null, Colors.white),
      };

  @override
  Widget _pLabel(String s) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(s.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: cs.onSurfaceVariant)),
        ),
      );
  }

  Widget _pSeg(List<List<String>> items, String current,
      void Function(String) onPick, Color accent) {
    final cs = Theme.of(context).colorScheme;
    return Row(children: [
      for (int i = 0; i < items.length; i++)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == items.length - 1 ? 0 : 6),
            child: GestureDetector(
              onTap: () => onPick(items[i][0]),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: current == items[i][0]
                      ? accent
                      : cs.onSurface.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                      color: current == items[i][0]
                          ? accent
                          : cs.outlineVariant),
                ),
                child: Text(items[i][1],
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color:
                            current == items[i][0] ? cs.onPrimary : cs.onSurface)),
              ),
            ),
          ),
        ),
    ]);
  }

  @override
  Widget _pSlider(double value, double min, double max, int div, Color accent,
      ValueChanged<double> onChanged) {
    final cs = Theme.of(context).colorScheme;
    return Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: div,
        activeColor: accent,
        inactiveColor: cs.onSurface.withValues(alpha: 0.3),
        onChanged: onChanged,
      );
  }

  Widget _tailChevron(IconData icon, VoidCallback? onTap) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon,
              size: 22,
              color: onTap != null
                  ? cs.onPrimary
                  : cs.onPrimary.withValues(alpha: 0.4)),
        ),
      );
  }

  // The tail base: ‹ chapter · progress slider · % · › chapter. Title/chapter
  // are already in the top-left back pill, so they're not repeated here.
  Widget _novelTailBase() {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (_, _) {
        final p = _novelProgress();
        return Row(children: [
          _tailChevron(
              Icons.chevron_left_rounded, _hasPrev ? () => _go(1) : null),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                activeTrackColor: cs.onPrimary,
                inactiveTrackColor: cs.onPrimary.withValues(alpha: 0.3),
                thumbColor: cs.onPrimary,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 13),
              ),
              child: Slider(
                value: p,
                onChanged: _seekNovel,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text('${(p * 100).round()}%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800, color: cs.onPrimary)),
          _tailChevron(
              Icons.chevron_right_rounded, _hasNext ? () => _go(-1) : null),
        ]);
      },
    );
  }

  Widget _radialSizePanel(Color accent) {
    final cs = Theme.of(context).colorScheme;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _pLabel('Text size'),
          Row(children: [
            Expanded(
                child: _pSlider(_fontSize, 12, 30, 18, accent,
                    (v) => _setFontSize(v))),
            const SizedBox(width: 8),
            Text('${_fontSize.round()} pt',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface)),
          ]),
        ],
      );
  }

  Widget _radialFontPanel(Color accent) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _pLabel('Font'),
          // Bound the list so it scrolls within the panel instead of overflowing
          // (the panel is 320 tall; leave room for the label). Without this the
          // shrinkWrap list took its full content height and clipped.
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: _fontListView(Colors.white, accent, () => setState(() {})),
          ),
        ],
      );

  Widget _radialThemePanel(Color accent) {
    final cs = Theme.of(context).colorScheme;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _pLabel('Reader theme'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['default', 'sepia', 'warm', 'gray', 'oled'].map((id) {
              final (bg, fg) = _themeColorsFor(id);
              final sel = _novelTheme == id;
              return GestureDetector(
                onTap: () {
                  setState(() => _novelTheme = id);
                  SettingsStore.instance.setString('novel_reader_theme', id);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bg ?? cs.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: sel ? accent : cs.outlineVariant,
                        width: sel ? 3 : 1),
                  ),
                  child: Text('A',
                      style: TextStyle(
                          color: bg == null ? cs.onSurface : fg,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                ),
              );
            }).toList(),
          ),
        ],
      );
  }

  Widget _radialAlignPanel(Color accent) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _pLabel('Reading mode'),
          _pSeg(const [
            ['scroll', 'Scroll'],
            ['paged', 'Paged']
          ], _novelLayout, (id) => _setNovelLayout(id), accent),
          _pLabel('Alignment'),
          _pSeg(const [
            ['left', 'Left'],
            ['justify', 'Justify'],
            ['center', 'Center']
          ], _textAlign, (id) {
            setState(() => _textAlign = id);
            SettingsStore.instance.setString('novel_text_align', id);
          }, accent),
          _pLabel('Hyphenation'),
          _pSeg(const [
            ['on', 'On'],
            ['off', 'Off']
          ], _hyphenate ? 'on' : 'off', (id) {
            setState(() {
              _hyphenate = id == 'on';
              _rebuildDisplayParagraphs();
            });
            SettingsStore.instance.setBool('novel_hyphenate', id == 'on');
          }, accent),
        ],
      );

  Widget _radialSpacingPanel(Color accent) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _pLabel('Line spacing'),
          _pSlider(_lineHeight, 1.2, 2.4, 12, accent, (v) {
            setState(() => _lineHeight = v);
            SettingsStore.instance.setDouble('novel_line_height', v);
          }),
          _pLabel('Margins'),
          _pSlider(_hMargin, 8, 48, 20, accent, (v) {
            setState(() => _hMargin = v);
            SettingsStore.instance.setDouble('novel_margin', v);
          }),
        ],
      );

  // Swatches for the reading highlight colour. "Accent" (null / stored 0)
  // follows the theme; the rest are fixed ARGB values that read on both light
  // and dark reader backgrounds.
  Widget _buildNovelRadial(ColorScheme cs, AppLocalizations t) {
    final accent = cs.primary;
    // Keyed to the customizer (RadialMenuConfig.novel); the saved order then
    // filters + sequences these.
    final available = <String, RadialAction>{
      'size': RadialAction(
          icon: Icons.format_size_rounded,
          label: t.novelActionSize,
          panelHeight: 172,
          panelBuilder: (ctx, r) => _radialSizePanel(accent)),
      'font': RadialAction(
          icon: Icons.font_download_rounded,
          label: t.readerTabFont,
          panelHeight: 320,
          panelBuilder: (ctx, r) => _radialFontPanel(accent)),
      'theme': RadialAction(
          icon: Icons.palette_rounded,
          label: t.novelActionTheme,
          panelHeight: 188,
          panelBuilder: (ctx, r) => _radialThemePanel(accent)),
      'align': RadialAction(
          icon: Icons.format_align_left_rounded,
          label: t.novelActionAlign,
          panelHeight: 320,
          panelBuilder: (ctx, r) => _radialAlignPanel(accent)),
      'spacing': RadialAction(
          icon: Icons.format_line_spacing_rounded,
          label: t.novelActionSpacing,
          panelHeight: 238,
          panelBuilder: (ctx, r) => _radialSpacingPanel(accent)),
      if (_ttsSupported)
        'listen': RadialAction(
            icon: Icons.headphones_rounded,
            label: t.novelActionListen,
            panelHeight: 334,
            panelBuilder: (ctx, r) => _radialListenPanel(accent)),
    };
    final actions = [
      for (final k in _radialOrder)
        if (available[k] != null) available[k]!,
    ];
    return RadialReaderMenu(
      leftSide: false,
      style: _novelRadialStyle,
      title: widget.mangaTitle ?? t.readerReadingTitle,
      chapter: _title,
      titleExpanded: _hudVisible,
      visible: _hudVisible,
      onBack: () => Navigator.of(context).maybePop(),
      tailBase: _novelTailBase(),
      panelAccent: accent,
      showPageLabel: false,
      onOpenChanged: (open) {
        if (open && !_hudVisible) setState(() => _hudVisible = true);
      },
      onPanelChanged: (h) {
        if (h != _radialPanelHeight) setState(() => _radialPanelHeight = h);
      },
      actions: actions,
    );
  }

  /// One paragraph as rendered in both layouts: the spoken paragraph gets the
  /// highlight treatment (from the original text so its offsets line up), every
  /// other paragraph is plain, hyphenated Text.
  Widget _paragraphWidget(int i, ColorScheme cs, Color themeText) {
    final active = _ttsActive && i == _ttsIndex;
    return Container(
      key: i < _paraKeys.length ? _paraKeys[i] : null,
      margin: const EdgeInsets.only(bottom: 16),
      padding: active
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : EdgeInsets.zero,
      decoration: active
          ? BoxDecoration(
              color: cs.primary.withAlpha(28),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: active
          ? _readingParagraph(_paragraphs[i], _novelTextStyle(themeText), cs)
          : Text(
              i < _displayParagraphs.length
                  ? _displayParagraphs[i]
                  : _paragraphs[i],
              textAlign: _textAlignValue(),
              style: _novelTextStyle(themeText),
            ),
    );
  }

  /// Continuous scroll layout (the default). A SingleChildScrollView (not a
  /// lazy list) so the full scroll extent is known immediately for the draggable
  /// progress thumb; novel chapters are text-light, so laying it all out is cheap.
  Widget _scrollContent(
      ColorScheme cs, Color themeText, double topPad, double bottomPad) {
    return SingleChildScrollView(
      controller: _scrollController,
      // Pad past the floating top + bottom bars so the first/last lines aren't
      // hidden behind them when the HUD is revealed.
      padding:
          EdgeInsets.fromLTRB(_hMargin, topPad + 60, _hMargin, 120 + bottomPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < _paragraphs.length; i++)
            _paragraphWidget(i, cs, themeText),
        ],
      ),
    );
  }

  /// Page-flip layout: paragraphs packed into viewport-sized pages, swiped
  /// horizontally. Repaginates whenever the box or text metrics change, keeping
  /// your place (the resumed position on first layout, else the current page).
  Widget _pagedContent(
      ColorScheme cs, Color themeText, double topPad, double bottomPad) {
    final style = _novelTextStyle(themeText);
    const double padTopExtra = 60, padBottomExtra = 90;
    return LayoutBuilder(builder: (ctx, c) {
      final boxW = (c.maxWidth - 2 * _hMargin).clamp(1.0, double.infinity);
      final boxH = (c.maxHeight - (topPad + padTopExtra) - (bottomPad + padBottomExtra))
          .clamp(1.0, double.infinity);
      final box = Size(boxW, boxH);
      final sig = '${boxW.round()}x${boxH.round()}|$_fontSize|$_lineHeight'
          '|$_fontFamily|$_textAlign|$_hyphenate|${_paragraphs.length}';
      if (sig != _novelPagedSig) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _repaginate(box, style, sig);
        });
      }
      if (_novelPages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return PageView.builder(
        controller: _novelPageController,
        itemCount: _novelPages.length,
        onPageChanged: (p) {
          setState(() => _novelPage = p);
          _saveProgress();
          if (p >= _novelPages.length - 1) _markReadIfEnd();
        },
        itemBuilder: (_, pi) {
          final idxs = _novelPages[pi];
          return Padding(
            padding: EdgeInsets.fromLTRB(
                _hMargin, topPad + padTopExtra, _hMargin, bottomPad + padBottomExtra),
            // Per-page selection: a SelectionArea around the whole PageView would
            // claim horizontal drags and break swipe-to-turn, so each page owns
            // its own (selection is by long-press, within a page).
            child: SelectionArea(
              onSelectionChanged: (c) => _selectedText = c?.plainText ?? '',
              contextMenuBuilder: _novelSelectionMenu,
              // A page normally fits; the scroll view is a fallback for a single
              // paragraph taller than the viewport.
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final i in idxs) _paragraphWidget(i, cs, themeText)
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  /// Recompute pages for [box] and land on the right one, then sync the
  /// controller. Called off a post-frame callback (never during build).
  void _repaginate(Size box, TextStyle style, String sig) {
    final pages = _paginate(box, style);
    int target;
    if (_novelPagedRestorePending) {
      _novelPagedRestorePending = false;
      final frac = widget.startFraction > 0 ? widget.startFraction : 0.0;
      target = (frac * (pages.length - 1)).round().clamp(0, pages.length - 1);
    } else {
      // Preserve the paragraph you were on across a reflow or a layout switch.
      final anchor = _novelPagedAnchorOverride ?? _novelAnchorParagraph();
      _novelPagedAnchorOverride = null;
      target = 0;
      for (var pi = 0; pi < pages.length; pi++) {
        if (pages[pi].contains(anchor)) {
          target = pi;
          break;
        }
      }
    }
    setState(() {
      _novelPages = pages;
      _novelPagedSig = sig;
      _novelPage = target;
    });
    // A chapter that fits on a single page never fires onPageChanged, so it
    // would never get marked read. Mark it here once it is laid out (the whole
    // chapter is on screen). _markReadIfEnd no-ops if already marked.
    if (pages.length <= 1) _markReadIfEnd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _novelPageController.hasClients &&
          _novelPageController.page?.round() != target) {
        _novelPageController.jumpToPage(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final (themeBg, themeText) = _themeColors(cs);
    final topPad = MediaQuery.viewPaddingOf(context).top;
    final bottomPad = MediaQuery.viewPaddingOf(context).bottom;

    final Widget content;
    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline_rounded, color: cs.error, size: 40),
          const SizedBox(height: 12),
          Text(_error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13, color: cs.outline)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _load, child: Text(t.readerRetry)),
        ]),
      );
    } else {
      content = _paged
          ? _pagedContent(cs, themeText, topPad, bottomPad)
          : _scrollContent(cs, themeText, topPad, bottomPad);
    }

    final showBottomBar =
        !_loading && _error == null && widget.chapters != null;

    return Scaffold(
      backgroundColor: themeBg,
      body: Stack(
        children: [
          // Reading surface - tap anywhere to hide/reveal the bars.
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (e) {
                _tapDownPos = e.position;
                _tapDownMs = DateTime.now().millisecondsSinceEpoch;
              },
              onPointerUp: (e) {
                final dt = DateTime.now().millisecondsSinceEpoch - _tapDownMs;
                final moved = _tapDownPos == null
                    ? 0.0
                    : (e.position - _tapDownPos!).distance;
                // A quick, still press is a tap. A long-press or a drag belongs
                // to selection / scrolling / swiping, so leave it.
                if (dt >= 300 || moved >= 20) return;
                // Paged mode with the bars hidden: the left/right edges turn
                // pages (e-reader style); the middle reveals the bars. Swiping
                // still turns pages too (the PageView handles that).
                if (_paged && !_hudVisible) {
                  final w = MediaQuery.sizeOf(context).width;
                  final x = e.position.dx;
                  if (x < w * 0.28) {
                    _novelPrevPage();
                    return;
                  }
                  if (x > w * 0.72) {
                    _novelNextPage();
                    return;
                  }
                }
                _toggleHud();
              },
              // Whole-page selection so you can select / copy / Define any word
              // while reading, not only the paragraph TTS is on. Selection is by
              // long-press; taps are handled above so they still reveal the bars.
              // In paged mode the SelectionArea moves INSIDE each page (see
              // _pagedContent): a SelectionArea here would fight the PageView for
              // horizontal drags, breaking the swipe-to-turn gesture.
              child: _paged
                  ? content
                  : SelectionArea(
                      onSelectionChanged: (c) =>
                          _selectedText = c?.plainText ?? '',
                      contextMenuBuilder: _novelSelectionMenu,
                      child: content,
                    ),
            ),
          ),
          if (_novelRadialEnabled) ...[
            // The shared radial replaces the classic bars: button fans the
            // option bubbles; picking one grows the tail into the settings,
            // above the title/chapter + progress base.
            if (!_loading && _error == null)
              Positioned.fill(
                  key: const ValueKey('novel-chrome'),
                  child: _buildNovelRadial(cs, t)),
          ] else ...[
            // Top bar - slides up out of view when hidden.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_hudVisible,
                child: AnimatedSlide(
                  offset: _hudVisible ? Offset.zero : const Offset(0, -1),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: _hudVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 160),
                    child: _topBar(cs, t, topPad),
                  ),
                ),
              ),
            ),
            // Bottom: ONE flush panel (progress + chapter nav + Listen), opaque
            // through the safe area so no reading text peeks under it. Its height
            // follows what's showing, so nothing reserves an empty slot.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.bottomCenter,
                curve: Curves.easeOut,
                child: (showBottomBar && (_hudVisible || _ttsActive))
                    ? _novelBottomPanel(cs, t, bottomPad)
                    : const SizedBox(width: double.infinity),
              ),
            ),
          ],
          // Floating Listen control - in radial mode there's no persistent TTS
          // bar, so this keeps a pause/play (+ stop) on screen while it reads.
          // It reads _ttsPlaying from the main tree (unlike the radial panel),
          // so it always reflects the real state - including a notification
          // pause. LAST child in the Stack → never reshuffles the radial.
          if (_novelRadialEnabled && _ttsActive)
            Positioned.fill(
              child: LayoutBuilder(builder: (ctx, c) {
                final custom = _ttsPillAlign;
                // The default spot rides just above the radial tail when the bars
                // are shown and drops near the bottom when they hide. A custom
                // (dragged) spot is lifted the same way ONLY when it sits in the
                // tail zone at the bottom; a pill parked higher up is left alone.
                final Alignment effective;
                final panelH = _radialPanelHeight;
                if (panelH != null && !_draggingPill && c.maxHeight > 0) {
                  // A settings panel is open: the pill rides above the panel top.
                  // The panel grows up by panelH from the tail base (~y 0.78), so
                  // move the pill up from there by the panel height plus a small
                  // gap, matching how it rides above the tail.
                  final y =
                      (0.78 - 2 * (panelH + 36) / c.maxHeight).clamp(-0.45, 0.78);
                  effective = Alignment(custom?.x ?? 0, y);
                } else if (custom == null) {
                  effective = Alignment(0, _hudVisible ? 0.78 : 0.92);
                } else if (!_draggingPill && _hudVisible && custom.y > 0.82) {
                  effective = Alignment(custom.x, 0.78);
                } else {
                  effective = custom;
                }
                final pill = GestureDetector(
                  onLongPressStart: (_) {
                    if (!_draggingPill) setState(() => _draggingPill = true);
                  },
                  onLongPressMoveUpdate: (d) {
                    final rb = ctx.findRenderObject() as RenderBox?;
                    if (rb == null || c.maxWidth <= 0 || c.maxHeight <= 0) {
                      return;
                    }
                    final lp = rb.globalToLocal(d.globalPosition);
                    setState(() => _ttsPillAlign = Alignment(
                        ((lp.dx / c.maxWidth) * 2 - 1).clamp(-1.0, 1.0),
                        ((lp.dy / c.maxHeight) * 2 - 1).clamp(-1.0, 1.0)));
                  },
                  onLongPressEnd: (_) {
                    final a = _ttsPillAlign;
                    if (a != null) {
                      SettingsStore.instance.setDouble('novel_tts_pill_ax', a.x);
                      SettingsStore.instance.setDouble('novel_tts_pill_ay', a.y);
                    }
                    setState(() => _draggingPill = false);
                  },
                  child: _ttsFloatingPill(),
                );
                // One animated path: it eases on a raise/lower or a HUD toggle,
                // but follows the finger instantly while dragging.
                return AnimatedAlign(
                  alignment: effective,
                  // Match the radial panel's grow/shrink (260ms easeOutCubic) so
                  // the pill rises and settles in step with the panel.
                  duration: _draggingPill
                      ? Duration.zero
                      : const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  child: pill,
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _topBar(ColorScheme cs, AppLocalizations t, double topPad) {
    final chap = _title ?? widget.mangaTitle ?? t.readerReadingTitle;
    final novel = widget.mangaTitle;
    final hasNovel = novel != null && novel.isNotEmpty && novel != chap;
    return Container(
      padding: EdgeInsets.only(top: topPad),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: ConstrainedBox(
        // Min height, not fixed, so the title lines can grow at large accessibility
        // text sizes instead of overflowing the bar.
        constraints: const BoxConstraints(minHeight: 54),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: cs.onSurface,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasNovel)
                  Text(novel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: cs.outline)),
                Text(chap,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface)),
              ],
            ),
          ),
          if (_gazeActive || _tiltActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                  _gazeActive
                      ? Icons.visibility_rounded
                      : Icons.screen_rotation_rounded,
                  size: 20,
                  color: cs.primary),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Material(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                onTap: _openReaderMenu,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(child: Icon(Icons.text_fields_rounded, size: 20)),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _novelBottomPanel(ColorScheme cs, AppLocalizations t, double bottomPad) {
    final total = widget.chapters?.length ?? 0;
    final pos = total > 0 ? total - _index : 0;
    final n = _chapterNumberOf(_title ?? '');
    final mainLabel = 'Chapter ${n > 0 ? n : pos}';
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      // The safe-area pad is INSIDE the coloured box, so the fill reaches the
      // very bottom edge and no reading text shows through under the controls.
      padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hudVisible) ...[
            _novelProgressBar(cs),
            const SizedBox(height: 8),
            Row(children: [
              _navChip(cs, t.readerPrevious, Icons.chevron_left_rounded,
                  leading: true, onTap: _hasPrev ? () => _go(1) : null),
              Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(mainLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface)),
                  if (total > 0)
                    Text('$pos / $total',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: cs.outline)),
                ]),
              ),
              _navChip(cs, t.readerNext, Icons.chevron_right_rounded,
                  leading: false, onTap: _hasNext ? () => _go(-1) : null),
            ]),
          ],
          if (_ttsActive) ...[
            if (_hudVisible)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: cs.outlineVariant),
              ),
            _novelListenRow(cs, t),
          ],
        ],
      ),
    );
  }

  /// Draggable chapter progress: tap or drag anywhere on the track to seek.
  Widget _novelProgressBar(ColorScheme cs) {
    return ListenableBuilder(
      listenable: _scrollController,
      builder: (_, _) {
        final f = _novelProgress().clamp(0.0, 1.0);
        return LayoutBuilder(builder: (ctx, c) {
          void seek(double dx) {
            if (c.maxWidth <= 0) return;
            _seekNovel((dx / c.maxWidth).clamp(0.0, 1.0));
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => seek(d.localPosition.dx),
            onHorizontalDragUpdate: (d) => seek(d.localPosition.dx),
            child: SizedBox(
              height: 22,
              child: Stack(alignment: Alignment.centerLeft, children: [
                Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: cs.outlineVariant,
                        borderRadius: BorderRadius.circular(3))),
                FractionallySizedBox(
                  widthFactor: f,
                  alignment: Alignment.centerLeft,
                  child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(3))),
                ),
                Align(
                  alignment: Alignment(f * 2 - 1, 0),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.28),
                            blurRadius: 3,
                            offset: const Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
      },
    );
  }

  Widget _navChip(ColorScheme cs, String label, IconData icon,
      {required bool leading, required VoidCallback? onTap}) {
    final fg = onTap != null ? cs.onSurface : cs.outline.withAlpha(110);
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (leading) ...[Icon(icon, size: 16, color: fg), const SizedBox(width: 3)],
            Text(label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
            if (!leading) ...[const SizedBox(width: 3), Icon(icon, size: 16, color: fg)],
          ]),
        ),
      ),
    );
  }

}
