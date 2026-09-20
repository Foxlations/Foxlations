import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/library_provider.dart';
import '../../core/providers/source_provider.dart';
import '../../core/services/volume_keys.dart';
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
  // Continuous-text reading has no "pages", so we persist the exact SCROLL OFFSET
  // (debounced) and restore it, so "continue" lands where you actually stopped.
  Timer? _saveThrottle;
  LibraryProvider? _lib;
  double _lastOffset = 0;
  List<String> _paragraphs = [];
  bool _loading = true;
  String? _error;
  double _fontSize = 18;
  late int _index;
  late String _url;
  String? _title;

  @override
  void initState() {
    super.initState();
    _index = widget.currentIndex;
    _url = widget.chapterUrl;
    _title = widget.chapterTitle;
    _scrollController.addListener(_saveProgress);
    _load();
    _maybeEnableVolumeKeys();
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
    _saveThrottle?.cancel();
    _saveThrottle = Timer(const Duration(seconds: 1), () {
      if (!mounted || _lib == null) return;
      _lib!.updateNovelProgress(widget.sourceId, widget.mangaUrl!, _url,
          _lastOffset.round(), _currentFraction());
    });
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
    final prefs = await SharedPreferences.getInstance();
    final on = prefs.getBool('reader_volume_keys') ?? false;
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

  @override
  void dispose() {
    VolumeKeys.disable();
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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final installed =
          context.read<SourceProvider>().getInstalledSource(widget.sourceId);
      if (installed == null) throw Exception('Source not installed');
      final html = await withExtensionService(
        installed.source,
        installed.sourceCode,
        (service) => service.getHtmlContent(_url),
      );
      _paragraphs = _toParagraphs(html);
      if (_paragraphs.isEmpty) _error = AppLocalizations.of(context).readerNoChapterText;
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) {
      setState(() => _loading = false);
      _restoreScroll();
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title ?? widget.mangaTitle ?? t.readerReadingTitle,
            style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: t.readerSmallerText,
            icon: const Icon(Icons.text_decrease_rounded),
            onPressed: () => setState(
                () => _fontSize = (_fontSize - 1).clamp(12, 30).toDouble()),
          ),
          IconButton(
            tooltip: t.readerLargerText,
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: () => setState(
                () => _fontSize = (_fontSize + 1).clamp(12, 30).toDouble()),
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
                  padding: EdgeInsets.fromLTRB(
                      20, 16, 20, 32 + MediaQuery.of(context).viewPadding.bottom),
                  itemCount: _paragraphs.length + 1,
                  itemBuilder: (_, i) {
                    if (i == _paragraphs.length) return _navBar(cs);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SelectableText(
                        _paragraphs[i],
                        style: GoogleFonts.notoSerif(
                            fontSize: _fontSize, height: 1.7, color: cs.onSurface),
                      ),
                    );
                  },
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
