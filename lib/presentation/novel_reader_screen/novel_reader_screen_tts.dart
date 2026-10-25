part of 'novel_reader_screen.dart';

/// Text-to-speech ("Listen") for the light-novel reader: the speaking loop,
/// the offline neural engine, device-voice selection, lock-screen media
/// session, the floating pill, and the sentence/word highlight state the
/// renderer paints. Split out of [_NovelReaderScreenState] and mixed straight
/// in, so behaviour is identical to when these members lived inline. Shared
/// rendering / scroll / pagination primitives stay in the host and are reached
/// through the abstract members below.
mixin _NovelTts on State<NovelReaderScreen> {
  // Where the floating Listen pill sits (long-press and drag to move it). null =
  // the default spot, which rides above the radial base when the bars are shown.
  Alignment? _ttsPillAlign;
  bool _draggingPill = false; // true while dragging → follow the finger, no ease

  // ── Text-to-speech ("Listen") ──────────────────────────
  FlutterTts? _tts;
  bool _ttsActive = false; // the Listen control bar is shown
  bool _ttsPlaying = false; // currently speaking
  int _ttsIndex = 0; // paragraph being read
  double _ttsRate = 0.5; // flutter_tts rate (0.5 ≈ 1.0×)
  double _ttsPitch = 1.0; // 0.5 (deep) … 2.0 (high); 1.0 = natural
  String? _ttsVoiceName; // chosen device voice (null = system default)
  String? _ttsVoiceLocale;
  // TTS highlight colours as ARGB, or null to follow the theme accent (the
  // sentence currently being read, and the single word inside it). Stored as 0
  // for "accent" so no separate remove is needed.
  int? _ttsSentenceColor;
  int? _ttsWordColor;
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
  // Mirror the neural player's actual play state into _ttsPlaying, so a pause/
  // play from the lock-screen / notification (which media_kit can handle on its
  // own session) stays in sync with the in-app controls. The debounce swallows
  // the brief gap between paragraphs so it doesn't flicker to "paused".
  StreamSubscription<bool>? _neuralPlayingSub;
  Timer? _neuralPauseDebounce;
  bool _neuralBusy = false;
  double? _neuralDlProgress;
  bool get _useNeural =>
      _ttsEngine == 'neural' && NeuralTtsService.instance.isReady;
  int _ttsSentence = -1;
  // Word-level (karaoke) highlight inside the active sentence: the char span of
  // the word being spoken right now, in the ORIGINAL on-screen text (-1 = none,
  // e.g. the neural engine, which reports no per-word progress). The engine
  // reports offsets into the spoken string, so [_ttsSpokenText] is kept to turn
  // a spoken offset into a word index, then into the same word on screen.
  int _ttsWordStart = -1;
  int _ttsWordEnd = -1;
  String _ttsSpokenText = '';
  bool get _ttsSupported =>
      Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isMacOS ||
      Platform.isWindows;

  // ── Provided by the host State (shared rendering / scroll / pagination) ──
  String get _url;
  List<GlobalKey> get _paraKeys;
  List<String> get _paragraphs;
  String? get _title;
  LibraryLike? get _lib;
  LibraryLike get _store;
  bool get _paged;
  bool get _hasNext;
  bool get _hasPrev;
  set _hudVisible(bool v);
  int _firstVisibleParagraph();
  void _go(int delta);
  void _novelPageForParagraph(int i);
  Widget _pLabel(String s);
  Widget _pSlider(double value, double min, double max, int div, Color accent,
      ValueChanged<double> onChanged);

  Future<void> _loadTtsRate() async {
    final prefs = SettingsStore.instance;
    if (mounted) {
      setState(() {
        _ttsRate = prefs.getDouble('novel_tts_rate') ?? 0.5;
        _ttsPitch = (prefs.getDouble('novel_tts_pitch') ?? 1.0).clamp(0.5, 2.0);
        _ttsVoiceName = prefs.getString('novel_tts_voice_name');
        _ttsVoiceLocale = prefs.getString('novel_tts_voice_locale');
        // Sentence colour: migrate the old single key if present.
        final sc = prefs.getInt('novel_tts_sentence_color') ??
            prefs.getInt('novel_tts_highlight_color') ??
            0;
        _ttsSentenceColor = sc == 0 ? null : sc;
        final wc = prefs.getInt('novel_tts_word_color') ?? 0;
        _ttsWordColor = wc == 0 ? null : wc;
        final px = prefs.getDouble('novel_tts_pill_ax');
        final py = prefs.getDouble('novel_tts_pill_ay');
        _ttsPillAlign =
            (px != null && py != null) ? Alignment(px, py) : null;
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
      // speed/voice change - don't advance (that caused the double-read).
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
    // platform fires this - when it doesn't, _ttsSentence stays -1 and the whole
    // paragraph stays highlighted.
    tts.setProgressHandler((text, start, end, word) {
      // Offsets are into the normalized spoken string. Map to the sentence that
      // contains them, then to the single word inside it being spoken now, and
      // highlight both on the original on-screen text (the word rides on top of
      // the lit sentence, karaoke style).
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
      var ws = -1, we = -1;
      if (k >= 0 &&
          s < _ttsSentences.length &&
          _ttsIndex >= 0 &&
          _ttsIndex < _paragraphs.length) {
        // Word index within the spoken sentence = how many whole words precede
        // `start`; the same-indexed word in the original sentence is the one on
        // screen. Word counts line up per sentence even though the two strings
        // differ (normalization rarely splits a word), and a rare mismatch only
        // nudges the word within an already-lit sentence, so it degrades gently.
        final spokenSentStart = _ttsSpokenSentences[k].$1;
        final cut = start.clamp(spokenSentStart, _ttsSpokenText.length);
        final wordIdx = RegExp(r'\S+')
            .allMatches(_ttsSpokenText.substring(spokenSentStart, cut))
            .length;
        final para = _paragraphs[_ttsIndex];
        final os = _ttsSentences[s].$1.clamp(0, para.length);
        final oe = _ttsSentences[s].$2.clamp(os, para.length);
        final origWords =
            RegExp(r'\S+').allMatches(para.substring(os, oe)).toList();
        if (wordIdx < origWords.length) {
          ws = os + origWords[wordIdx].start;
          we = os + origWords[wordIdx].end;
        }
      }
      if (s != _ttsSentence || ws != _ttsWordStart) {
        setState(() {
          _ttsSentence = s;
          _ttsWordStart = ws;
          _ttsWordEnd = we;
        });
      }
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
      _hudVisible = false; // reading started: get the bars/radial out of the way
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
  /// estimate - TTS has no true duration - but it tracks closely enough.
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

  /// Fetch the cover (from the library entry) to a local file via ImageLoader -
  /// which honours the source's TLS/Referer - so the OS Now-Playing art loads.
  Future<void> _prepareCoverArt() async {
    try {
      LibraryManga? m;
      for (final e in (_lib ?? _store).manga) {
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
    // for the first progress event. The word clears either way until the next
    // progress event lands inside the (new) sentence.
    _ttsSentence = from > 0 ? from : -1;
    _ttsWordStart = -1;
    _ttsWordEnd = -1;
    setState(() {}); // repaint the highlight
    _saveTtsPos(); // remember where we are so Listen resumes here next time
    _syncMediaSession(); // keep the lock-screen title/controls current
    _scrollToTts();
    final tts = await _ensureTts();
    await tts.setSpeechRate(_ttsRate);
    await tts.setPitch(_ttsPitch);
    final text = spoken.toString().trim();
    // Kept so the progress handler can map a spoken offset back to a word; this
    // is the exact string handed to the engine, so the offsets line up.
    _ttsSpokenText = text.isEmpty ? para : text;
    await tts.speak(_ttsSpokenText);
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
    _neuralPlayingSub = p.stream.playing.listen((playing) {
      if (!mounted || !_ttsActive || !_useNeural || _ttsRestarting) return;
      if (playing) {
        _neuralPauseDebounce?.cancel();
        if (!_ttsPlaying) {
          setState(() => _ttsPlaying = true);
          _syncMediaSession();
        }
      } else {
        // Debounce: the short silence between paragraphs also reports !playing,
        // so only treat a persisted pause as a real pause.
        _neuralPauseDebounce?.cancel();
        _neuralPauseDebounce = Timer(const Duration(milliseconds: 450), () {
          if (mounted && _ttsActive && _useNeural && _ttsPlaying) {
            setState(() => _ttsPlaying = false);
            _syncMediaSession();
          }
        });
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
      _advanceNeural(); // synthesis failed - don't stall, move on
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
    // Dash runs (hyphen / en-dash / em-dash in the chapter text) -> a comma
    // pause; bullets/odd glyph runs -> a space. Non-raw so the dash escapes
    // survive a source-wide dash sweep.
    out = out.replaceAll(RegExp('[-–—]{2,}'), ', ');
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
        // The OS engine can't resume mid-utterance, so re-speak from the start
        // of the sentence we paused in, not the whole paragraph again.
        await _speakCurrent(fromSentence: _ttsSentence >= 0 ? _ttsSentence : 0);
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
    final t = AppLocalizations.of(context);
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
              Text(t.novelTts,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.record_voice_over_rounded,
                    size: 20, color: cs.primary),
                title: Text(t.novelVoice,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600)),
                subtitle: Text(_ttsVoiceName ?? t.novelVoiceSystemDefault,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w400, color: cs.outline)),
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
                label: t.readerTtsSpeed,
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
                label: t.readerPitch,
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
    final t = AppLocalizations.of(context);
    final v = NeuralVoice.byId(_neuralVoiceId);
    final loaded = NeuralTtsService.instance.isReady &&
        NeuralTtsService.instance.loadedVoiceId == v.id;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 8),
      Row(children: [
        Icon(Icons.auto_awesome_rounded, size: 16, color: cs.primary),
        const SizedBox(width: 6),
        Text(t.novelVoiceEngine,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700, color: cs.outline)),
      ]),
      const SizedBox(height: 6),
      Wrap(spacing: 8, children: [
        ChoiceChip(
          label: Text(t.novelVoiceDevice),
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
            'Downloading ${v.label} - ${((_neuralDlProgress ?? 0) * 100).round()}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10, fontWeight: FontWeight.w400, color: cs.outline)),
      ] else if (_ttsEngine == 'neural') ...[
        const SizedBox(height: 6),
        Text(
            loaded
                ? 'Offline neural voice ready · ${v.license}'
                : 'Tap a neural voice to download it (~${v.sizeMb} MB, one time).',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10, fontWeight: FontWeight.w400, color: cs.outline)),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600))),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700))),
    ]);
  }

  void _scrollToTts() {
    // Paged mode: flip to the page holding the spoken paragraph instead of
    // scrolling to it.
    if (_paged) {
      _novelPageForParagraph(_ttsIndex);
      return;
    }
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
      // Voice no longer installed - fall back to the system default.
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('${filtered.length}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.outline)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    onChanged: (s) => setSheet(() => query = s),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: t.novelSearchVoices,
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                if (langList.length > 1)
                  SizedBox(
                    // Scale with the text size so the chips don't clip when the
                    // system font is enlarged.
                    height: MediaQuery.textScalerOf(context).scale(38),
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
                    height: MediaQuery.textScalerOf(context).scale(38),
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

  Widget _ttsHighlightRow(
      ColorScheme cs, int? current, ValueChanged<int?> onPick) {
    const presets = <(String, int?)>[
      ('Accent', null),
      ('Amber', 0xFFFFB300),
      ('Green', 0xFF43A047),
      ('Blue', 0xFF1E88E5),
      ('Pink', 0xFFD81B60),
      ('Violet', 0xFF8E24AA),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        for (final (_, argb) in presets)
          GestureDetector(
            onTap: () => onPick(argb),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: argb == null ? cs.primary : Color(argb),
                shape: BoxShape.circle,
                border: Border.all(
                  color: current == argb ? cs.onSurface : cs.outlineVariant,
                  width: current == argb ? 2.5 : 1,
                ),
              ),
              child: current == argb
                  ? const Icon(Icons.check_rounded,
                      size: 15, color: Colors.white)
                  : null,
            ),
          ),
      ],
    );
  }

  Widget _radialListenPanel(Color accent) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _pLabel('Listen · text-to-speech'),
          GestureDetector(
            onTap: () {
              _ttsActive ? _stopTts() : _startTts();
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _ttsActive
                    ? accent
                    : cs.onSurface.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: _ttsActive ? accent : cs.outlineVariant),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(_ttsActive ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    color: _ttsActive ? cs.onPrimary : cs.onSurface, size: 20),
                const SizedBox(width: 8),
                Text(_ttsActive ? 'Stop' : 'Play',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: _ttsActive ? cs.onPrimary : cs.onSurface)),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          _pLabel('Speed'),
          _pSlider(_ttsRate, 0.25, 1.0, 15, accent, (v) {
            setState(() => _ttsRate = v);
            SettingsStore.instance.setDouble('novel_tts_rate', v);
          }),
          _pLabel('Pitch'),
          _pSlider(_ttsPitch, 0.5, 2.0, 15, accent, (v) {
            setState(() => _ttsPitch = v);
            SettingsStore.instance.setDouble('novel_tts_pitch', v);
          }),
          _pLabel('Sentence highlight'),
          _ttsHighlightRow(cs, _ttsSentenceColor, (c) {
            setState(() => _ttsSentenceColor = c);
            SettingsStore.instance.setInt('novel_tts_sentence_color', c ?? 0);
          }),
          const SizedBox(height: 8),
          _pLabel('Word highlight'),
          _ttsHighlightRow(cs, _ttsWordColor, (c) {
            setState(() => _ttsWordColor = c);
            SettingsStore.instance.setInt('novel_tts_word_color', c ?? 0);
          }),
          if (_ttsPillAlign != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    setState(() => _ttsPillAlign = null);
                    SettingsStore.instance.remove('novel_tts_pill_ax');
                    SettingsStore.instance.remove('novel_tts_pill_ay');
                  },
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: Text(t.novelResetPill),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _openTtsTuning,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(t.novelMoreVoices,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant)),
            ),
          ),
        ],
      );
  }

  Widget _ttsFloatingPill() {
    Widget btn(IconData icon, VoidCallback onTap, {double size = 22}) =>
        InkResponse(
          onTap: onTap,
          radius: 22,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: size),
          ),
        );
    return Material(
      color: Colors.black.withAlpha(190),
      shape: const StadiumBorder(
          side: BorderSide(color: Colors.white24, width: 0.5)),
      clipBehavior: Clip.antiAlias,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        btn(_ttsPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            _togglePlayPause,
            size: 27),
        btn(Icons.stop_rounded, _stopTts),
        const SizedBox(width: 4),
      ]),
    );
  }

  Widget _novelListenRow(ColorScheme cs, AppLocalizations t) {
    Widget sq(IconData icon, String tip, VoidCallback onTap,
            {double size = 22}) =>
        IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(icon, size: size),
            color: cs.onSurface,
            tooltip: tip,
            onPressed: onTap);
    final sentence =
        _ttsSentenceColor != null ? Color(_ttsSentenceColor!) : cs.primary;
    final word = _ttsWordColor != null ? Color(_ttsWordColor!) : cs.primary;
    return Row(children: [
      sq(_ttsPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          _ttsPlaying ? t.readerTtsStop : t.readerListen, _togglePlayPause,
          size: 26),
      sq(Icons.stop_rounded, t.readerTtsStop, _stopTts),
      sq(Icons.record_voice_over_rounded, t.readerTtsVoice, _openVoicePicker),
      sq(Icons.tune_rounded, 'Speed & pitch', _openTtsTuning),
      // Highlight colours (sentence + word) - reachable in classic mode now too.
      GestureDetector(
        onTap: _openHighlightColors,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            _hlDot(sentence, cs),
            const SizedBox(width: 5),
            _hlDot(word, cs),
          ]),
        ),
      ),
      const Spacer(),
      IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.remove_rounded),
          color: cs.onSurface,
          tooltip: t.readerTtsSpeed,
          onPressed: () => _setTtsRate(_ttsRate - 0.1)),
      Text('${(_ttsRate / 0.5).toStringAsFixed(1)}×',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
      IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.add_rounded),
          color: cs.onSurface,
          tooltip: t.readerTtsSpeed,
          onPressed: () => _setTtsRate(_ttsRate + 0.1)),
    ]);
  }

  Widget _hlDot(Color c, ColorScheme cs) => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(color: cs.outline, width: 1)),
      );

  void _openHighlightColors() {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                          color: cs.outline,
                          borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 14),
                Text(t.novelHighlightColours,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 14),
                Text(t.novelHighlightSentence,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                _ttsHighlightRow(cs, _ttsSentenceColor, (col) {
                  setState(() => _ttsSentenceColor = col);
                  setSheet(() {});
                  SettingsStore.instance
                      .setInt('novel_tts_sentence_color', col ?? 0);
                }),
                const SizedBox(height: 16),
                Text(t.novelHighlightWord,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                _ttsHighlightRow(cs, _ttsWordColor, (col) {
                  setState(() => _ttsWordColor = col);
                  setSheet(() {});
                  SettingsStore.instance
                      .setInt('novel_tts_word_color', col ?? 0);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
