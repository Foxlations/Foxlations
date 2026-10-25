part of 'reader_screen.dart';

/// AI image-translation for the manga reader: provider selection, per-page
/// OCR/translate (standard bubbles or Koharu full-page), and the state the
/// reader's build() reads to paint overlays. Split out of [_ReaderBodyState]
/// to keep the reader file manageable; it is mixed straight into that State so
/// behaviour is identical to when these members lived inline.
mixin _ReaderTranslation on State<_ReaderBody> {
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
  final Set<int> _pageTranslating = {};
  final Set<int> _pageDone = {}; // attempted (success OR fail) - don't re-run
  bool get _isTranslating => _pageTranslating.isNotEmpty;
  final _translationService = AiTranslationService();
  final _koharuService = KoharuService();
  final Map<int, Uint8List> _koharuImageCache = {};
  late final AnimationController _translationAnimController;
  late final Animation<double> _translationAnimation;

  // Provided by the host State (shared with the image pipeline / scroll tracker).
  Future<Uint8List?> _pageBytes(ReaderPage p);
  ItemPositionsListener get _itemPositionsListener;

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
  /// each page is fetched/OCR'd at most once - repeated scroll callbacks are
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
      // the reader uses - instead of spinning up (and binning) a fresh rhttp
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
    // setting read as disabled - the feature must be opt-in.
    // AI translation is a beta feature - off unless beta is enabled too.
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
}
