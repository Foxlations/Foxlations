import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/models/player_settings.dart';
import '../../eval/model/m_video.dart';
import '../../eval/lib.dart';
import '../../core/providers/source_provider.dart';
import '../../core/providers/library_provider.dart';
import '../../core/providers/vault_provider.dart';
import '../../core/providers/library_like.dart';
import '../../core/providers/tracking_provider.dart';
import '../../core/providers/incognito_provider.dart';
import '../../core/services/download_service.dart';
import '../../core/services/aniskip_service.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/read_time_tracker.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/duration_format.dart';

class PlayerScreen extends StatefulWidget {
  final String sourceId;
  final String episodeUrl;
  final String? episodeTitle;
  final String? animeTitle;

  /// The anime's library url. Needed to persist/restore playback position
  /// (episodes are stored as chapters). Null → progress isn't tracked.
  final String? mangaUrl;

  /// The full episode list ({url, name}, in the detail screen's order) and this
  /// episode's index in it, enabling in-player Next/Previous + autoplay. Null → single.
  final List<Map<String, dynamic>>? episodes;
  final int currentIndex;

  /// True when watching a VAULT anime - routes progress/seen-marks to the vault.
  final bool isVault;

  const PlayerScreen({
    super.key,
    required this.sourceId,
    required this.episodeUrl,
    this.episodeTitle,
    this.animeTitle,
    this.mangaUrl,
    this.episodes,
    this.currentIndex = 0,
    this.isVault = false,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final Player _player;
  late final VideoController _controller;
  final FocusNode _focus = FocusNode();

  List<MVideo> _videos = [];
  int _currentVideoIndex = 0;

  // Current episode (mutable - Next/Previous swap it in place).
  late List<Map<String, dynamic>> _episodes;
  late int _epIndex;

  bool _isLoading = true;
  String? _error;
  final List<StreamSubscription<dynamic>> _subs = [];

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  LibraryLike? _lib;
  // Accumulates ACTIVE watch time per anime for Reading Insights. Pinged on
  // playback position updates; a paused video stops pinging and idles out.
  ReadTimeTracker? _timeTracker;
  int _resumeSeconds = 0;
  Duration _lastSaved = Duration.zero;
  Duration _seekTarget = Duration.zero;

  PlayerSettings _settings = const PlayerSettings();
  double _speed = 1.0;
  double _subDelay = 0.0; // seconds
  BoxFit _fit = BoxFit.contain;
  bool _locked = false;

  // Skip intro/outro: the current video's markers, plus which one (if any) we're
  // inside right now and which have already been auto-skipped.
  List<MTimeStamp> _stamps = [];
  MTimeStamp? _activeStamp;
  final Set<int> _skipped = {};

  String get _epUrl => (_epIndex >= 0 && _epIndex < _episodes.length)
      ? (_episodes[_epIndex]['url'] as String? ?? widget.episodeUrl)
      : widget.episodeUrl;
  String? get _epTitle => (_epIndex >= 0 && _epIndex < _episodes.length)
      ? (_episodes[_epIndex]['name'] as String?)
      : widget.episodeTitle;
  bool get _hasPrev => _episodes.isNotEmpty && _epIndex > 0;
  bool get _hasNext =>
      _episodes.isNotEmpty && _epIndex >= 0 && _epIndex < _episodes.length - 1;

  /// The owning store for this anime (vault vs public library), selected by the
  /// [isVault] flag threaded through navigation.
  LibraryLike get _store => widget.isVault
      ? context.read<VaultProvider>()
      : context.read<LibraryProvider>();

  /// Saved playback position (seconds) for the current episode, from the owning
  /// store (vault or public library) so vault anime resumes like normal.
  int _episodeResume() =>
      _lib?.episodeLastPosition(widget.sourceId, _epUrl) ?? 0;

  @override
  void initState() {
    super.initState();
    // logLevel: warn pipes libmpv's own warnings/errors (bad codec, unreadable
    // file, unsupported protocol, HLS failure) into stream.log → the in-app log,
    // so a "stuck at 00:00 / no duration" stall is diagnosable instead of silent.
    _player = Player(
        configuration: const PlayerConfiguration(logLevel: MPVLogLevel.warn));
    _controller = VideoController(_player);
    // Episodes come NEWEST-first from the source; store oldest-first and remap
    // the opened index so "next" (index+1) is the LATER episode. Same bug/fix as
    // the manga reader - autoplay/next used to go to the previous episode.
    final eps = widget.episodes ?? const <Map<String, dynamic>>[];
    _episodes = eps.reversed.toList();
    _epIndex = eps.isEmpty
        ? 0
        : (eps.length - 1 - widget.currentIndex).clamp(0, eps.length - 1);
    _lib = _store;
    _resumeSeconds = _episodeResume();
    _timeTracker = ReadTimeTracker(onCredit: (secs) async {
      final url = widget.mangaUrl;
      if (!mounted || url == null) return;
      await _store.addReadTime(widget.sourceId, url, secs);
    })..start();
    WakelockPlus.enable();
    _setupListeners();
    _init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _init() async {
    final s = await PlayerSettings.load();
    if (mounted) setState(() { _settings = s; _speed = s.defaultSpeed; });
    await _loadVideoList();
  }

  void _setupListeners() {
    _subs.addAll([
      _player.stream.position.listen((pos) {
        _position = pos;
        _timeTracker?.ping(); // position advances only while playing → active watch
        _maybeSaveProgress(pos);
        _updateSkip(pos);
      }),
      _player.stream.duration.listen((dur) {
        _duration = dur;
        // Fetch AniSkip intro/outro ranges once we know the episode length.
        if (dur.inSeconds > 0 && !_aniskipTried) {
          _aniskipTried = true;
          _loadAniSkip();
        }
      }),
      _player.stream.completed.listen((done) {
        if (done) {
          _markSeen();
          if (_settings.autoplayNext && _hasNext) _playEpisode(_epIndex + 1);
        }
      }),
      // Surface libmpv playback errors (bad codec, dead stream url, HLS failure) in the
      // in-app log so player problems are diagnosable, not just a silent stall.
      _player.stream.error.listen((e) {
        logger.error('Player error: $e', category: LogCategory.general);
      }),
      // libmpv's own diagnostics (why a file/stream won't demux or decode).
      _player.stream.log.listen((l) {
        logger.warning('mpv[${l.level}] ${l.prefix}: ${l.text}',
            category: LogCategory.general);
      }),
    ]);
  }

  Future<void> _loadVideoList() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      // Play a DOWNLOADED episode from disk if we have it - the player used to
      // always go to the network, so downloaded episodes couldn't be watched
      // offline at all.
      final localPath = await DownloadService().getEpisodePath(
          widget.sourceId, widget.animeTitle ?? '', _epTitle ?? '');
      if (localPath != null) {
        // A per-episode folder keeps the video as `<ep>/video.<ext>` plus, for
        // DASH, a sibling `audio.mp4`, and a `tracks.json` listing the subtitle
        // and extra-audio files downloaded with it - so offline playback offers
        // the same audio/subtitle options as streaming.
        List<MTrack>? localAudios;
        List<MTrack>? localSubs;
        final match = RegExp(r'^(.*)/video\.[^/]+$').firstMatch(localPath);
        if (match != null) {
          final folder = match.group(1)!;
          final audios = <MTrack>[];
          final subs = <MTrack>[];
          final audioMp4 = File('$folder/audio.mp4');
          if (await audioMp4.exists()) {
            audios.add(MTrack(file: audioMp4.path, label: 'Audio'));
          }
          final tracksFile = File('$folder/tracks.json');
          if (await tracksFile.exists()) {
            try {
              final meta = jsonDecode(await tracksFile.readAsString())
                  as Map<String, dynamic>;
              for (final s in (meta['subtitles'] as List? ?? const [])) {
                subs.add(MTrack(
                    file: '$folder/${s['file']}', label: s['label'] as String?));
              }
              for (final a in (meta['extAudios'] as List? ?? const [])) {
                audios.add(MTrack(
                    file: '$folder/${a['file']}', label: a['label'] as String?));
              }
            } catch (_) {}
          }
          if (audios.isNotEmpty) localAudios = audios;
          if (subs.isNotEmpty) localSubs = subs;
        }
        final local = MVideo(localPath, 'Downloaded', localPath,
            audios: localAudios, subtitles: localSubs);
        if (mounted) {
          setState(() {
            _videos = [local];
            _currentVideoIndex = 0;
            _stamps = const [];
            _skipped.clear();
            _isLoading = false;
          });
          if (_resumeSeconds > 10 && mounted) {
            final resume = await _askResume(_resumeSeconds);
            _seekTarget =
                resume ? Duration(seconds: _resumeSeconds) : Duration.zero;
          }
          await _openVideo(local);
        }
        return;
      }

      final sp = context.read<SourceProvider>();
      final installed = sp.resolveInstalled(widget.sourceId);
      if (installed == null) throw Exception('Source not installed');

      final videos = await withExtensionService(
        installed.source,
        installed.sourceCode,
        (service) => service.getVideoList(_epUrl),
      );
      if (videos.isEmpty) throw Exception('No video sources found');

      if (mounted) {
        setState(() {
          _videos = videos;
          _currentVideoIndex = 0;
          _stamps = videos.first.timestamps ?? [];
          _skipped.clear();
          _isLoading = false;
        });
        logger.info('Resume: saved position = ${_resumeSeconds}s for $_epUrl',
            category: LogCategory.general);
        if (_resumeSeconds > 10 && mounted) {
          final resume = await _askResume(_resumeSeconds);
          _seekTarget = resume ? Duration(seconds: _resumeSeconds) : Duration.zero;
        }
        await _openVideo(videos.first);
      }
    } catch (e, st) {
      logger.error('Video load failed: $e',
          category: LogCategory.extension, detail: st.toString());
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _openVideo(MVideo video) async {
    final seekTo = _seekTarget;
    _seekTarget = Duration.zero;
    final resuming = seekTo > Duration.zero;
    // Resume is platform-split: iOS resumes reliably only when opened PLAYING and then
    // sought; Android resumes reliably only when opened PAUSED, sought, then played - 
    // seeking during active playback on Android is silently dropped and restarts at 0
    // (opening paused was the pre-rewrite behaviour that worked on Android; the media
    // still demuxes and reports a duration while paused).
    final openPlaying = !resuming || Platform.isIOS;
    logger.info(
        'Player open: ${video.url} (headers: ${video.headers?.length ?? 0}, playing: $openPlaying)',
        category: LogCategory.general);
    await _player.open(Media(video.url, httpHeaders: video.headers ?? {}),
        play: openPlaying);
    await _player.setRate(_speed);
    // Some anime sources return a video-only stream plus a SEPARATE audio track
    // (Aniyomi's ExoPlayer merges these automatically). media_kit opens only the
    // video url, so without attaching the external audio the episode plays silent.
    // A source only populates `audios` when the stream lacks embedded audio, so
    // this is a no-op for normal muxed streams.
    final extAudio = video.audios;
    if (extAudio != null &&
        extAudio.isNotEmpty &&
        (extAudio.first.file?.isNotEmpty ?? false)) {
      await _player.setAudioTrack(
          AudioTrack.uri(extAudio.first.file!, title: extAudio.first.label));
    }
    if (resuming) {
      // Check the already-known duration first (the stream event can fire before we
      // subscribe), otherwise wait for it - a seek before the media is loaded is dropped.
      var dur = _player.state.duration;
      if (dur <= Duration.zero) {
        dur = await _player.stream.duration
            .firstWhere((d) => d > Duration.zero)
            .timeout(const Duration(seconds: 15), onTimeout: () => Duration.zero);
      }
      if (dur > Duration.zero && seekTo < dur) {
        await _player.seek(seekTo);
        if (!openPlaying) await _player.play(); // Android: start from the seeked point
        await _monitorResume(seekTo); // safety net: re-seek if it slips back to 0
      } else {
        logger.error(
            dur <= Duration.zero
                ? 'Resume seek skipped: media reported no duration'
                : 'Resume seek skipped: target ${seekTo.inSeconds}s >= duration ${dur.inSeconds}s',
            category: LogCategory.general);
        if (!openPlaying) await _player.play();
      }
    }
  }

  /// Safety net after a resume seek: verify playback actually holds at [target] and
  /// re-seek if it slips. On Android, even the open-paused → seek → play path can slip
  /// back to 0 once buffering finishes; on iOS the first seek holds so this settles
  /// immediately.
  Future<void> _monitorResume(Duration target) async {
    // The caller already sought (and, on Android, opened paused → sought → played).
    // Android can still slip back to 0 once the initial buffer finishes, so watch the
    // real position stream for a while and re-seek whenever it falls back; only treat it
    // as settled once playback has ADVANCED past the target (proof it's genuinely playing
    // from the resume point, not just momentarily parked there).
    final deadline = DateTime.now().add(const Duration(seconds: 12));
    var reseeks = 0;
    var settled = false;
    final sub = _player.stream.position.listen((pos) {
      if (settled || !mounted) return;
      if (pos >= target + const Duration(seconds: 2)) {
        settled = true;
        logger.info(
            'Resume: settled at ${pos.inSeconds}s after $reseeks re-seek(s)',
            category: LogCategory.general);
      } else if (pos < target - const Duration(seconds: 10) && reseeks < 10) {
        reseeks++;
        logger.info(
            'Resume: fell back to ${pos.inSeconds}s, re-seeking to ${target.inSeconds}s',
            category: LogCategory.general);
        _player.seek(target);
      }
    });
    while (!settled && mounted && DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    await sub.cancel();
    if (!settled) {
      logger.error('Resume: never settled at ${target.inSeconds}s',
          category: LogCategory.general);
    }
  }

  /// Jump to another episode in-place: persist the current one, swap the target in,
  /// re-check its saved resume point, and reload.
  Future<void> _playEpisode(int index) async {
    if (index < 0 || index >= _episodes.length) return;
    _saveNow();
    setState(() {
      _epIndex = index;
      _seekTarget = Duration.zero;
      _lastSaved = Duration.zero;
      _position = Duration.zero;
      _markedSeen = false;
      _aniskipTried = false;
    });
    _resumeSeconds = _episodeResume();
    await _loadVideoList();
  }

  /// "Continue where you left off / Start from the beginning" prompt (anime only).
  Future<bool> _askResume(int seconds) async {
    final t = AppLocalizations.of(context);
    final at = _fmt(Duration(seconds: seconds));
    final choice = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(t.miscResumePlaybackTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(t.miscStoppedWatchingAt(at)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.miscStartOver)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.miscContinueAt(at))),
        ],
      ),
    );
    return choice ?? true;
  }

  void _maybeSaveProgress(Duration pos) {
    if (pos.inSeconds <= 0) return;
    if ((pos - _lastSaved).abs() < const Duration(seconds: 5)) return;
    _lastSaved = pos;
    _saveNow();
  }

  void _saveNow({bool notify = false}) {
    final mangaUrl = widget.mangaUrl;
    if (mangaUrl == null || _lib == null || _position.inSeconds <= 0) return;
    final atEnd =
        _duration > Duration.zero && _position >= _duration - const Duration(seconds: 15);
    _lib!.updateEpisodeProgress(widget.sourceId, mangaUrl, _epUrl,
        atEnd ? 0 : _position.inSeconds,
        totalSeconds: _duration.inSeconds,
        notify: notify);
    if (atEnd) _markSeen();
  }

  // Mark the episode seen + push to trackers once, when it finishes. The player
  // only ever saved the resume position, so anime never auto-advanced "seen",
  // library unread counts stayed wrong, and bound trackers never updated.
  bool _markedSeen = false;
  void _markSeen() {
    final mangaUrl = widget.mangaUrl;
    if (_markedSeen || mangaUrl == null || _lib == null) return;
    _markedSeen = true;
    if (!IncognitoProvider.active) {
      _lib!.markChapterRead(widget.sourceId, mangaUrl, _epUrl, active: true);
    }
    try {
      final n = _episodeNumberOf(_epTitle ?? '');
      if (n > 0) {
        context
            .read<TrackingProvider>()
            .syncChapterRead('${widget.sourceId}_$mangaUrl', n);
      }
    } catch (_) {}
  }

  /// Best-effort episode number from its title (prefers an ep/episode-labelled
  /// number, else the last number).
  int _episodeNumberOf(String name) {
    final labeled = RegExp(
            r'(?:episode|epis|ep|e|#)\s*[.:]?\s*(\d+(?:\.\d+)?)',
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

  bool _aniskipTried = false;

  /// Pull intro/outro skip ranges from AniSkip when the source didn't supply
  /// its own, using the anime's MyAnimeList id from its tracker binding.
  Future<void> _loadAniSkip() async {
    if (_stamps.isNotEmpty) return; // the source already gave timestamps
    final mangaUrl = widget.mangaUrl;
    if (mangaUrl == null) return;
    var malId = 0;
    try {
      final bindings = context
          .read<TrackingProvider>()
          .bindingsFor('${widget.sourceId}_$mangaUrl');
      for (final b in bindings) {
        if (b.trackerId == 'myanimelist') {
          malId = int.tryParse(b.mediaId) ?? 0;
          break;
        }
      }
    } catch (_) {}
    if (malId <= 0) return;
    final ep = _episodeNumberOf(_epTitle ?? '');
    if (ep <= 0) return;
    final stamps = await AniSkipService.instance.fetch(
      malId: malId,
      episodeNumber: ep,
      episodeLengthSeconds: _duration.inSeconds,
    );
    if (!mounted || stamps.isEmpty || _stamps.isNotEmpty) return;
    setState(() => _stamps = stamps);
  }

  void _updateSkip(Duration pos) {
    if (_stamps.isEmpty) {
      if (_activeStamp != null) setState(() => _activeStamp = null);
      return;
    }
    final secs = pos.inMilliseconds / 1000.0;
    MTimeStamp? active;
    int? idx;
    for (var i = 0; i < _stamps.length; i++) {
      // Don't re-show a window the user already skipped/dismissed - even if a
      // keyframe seek landed a hair before its end.
      if (_skipped.contains(i)) continue;
      final s = _stamps[i];
      if (secs >= s.start && secs < s.end) {
        active = s;
        idx = i;
        break;
      }
    }
    if (active != null && idx != null && _settings.autoSkipIntro) {
      _skipped.add(idx);
      _player.seek(Duration(milliseconds: (active.end * 1000).round()));
      if (_activeStamp != null) setState(() => _activeStamp = null);
      return;
    }
    if (active != _activeStamp) {
      setState(() => _activeStamp = active);
    } else if (active != null) {
      // Same window, new position - rebuild so the countdown ticks down live.
      setState(() {});
    }
  }

  void _seekBy(int seconds) {
    var target = _position + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (_duration > Duration.zero && target > _duration) target = _duration;
    _player.seek(target);
  }

  void _setSpeed(double s) {
    setState(() => _speed = s);
    _player.setRate(s);
  }

  void _cycleFit() {
    setState(() {
      _fit = _fit == BoxFit.contain
          ? BoxFit.cover
          : _fit == BoxFit.cover
              ? BoxFit.fill
              : BoxFit.contain;
    });
  }

  Future<void> _switchQuality(int index) async {
    final pos = _position;
    setState(() {
      _currentVideoIndex = index;
      _stamps = _videos[index].timestamps ?? _stamps;
    });
    await _openVideo(_videos[index]);
    await Future.delayed(const Duration(milliseconds: 500));
    await _player.seek(pos);
  }

  void _bumpVolume(double delta) {
    final v = (_player.state.volume + delta).clamp(0.0, 100.0);
    _player.setVolume(v);
  }

  void _setSubDelay(double seconds) {
    setState(() => _subDelay = seconds);
    // sub-delay isn't on the cross-platform Player API - reach the native handle.
    try {
      (_player.platform as dynamic)?.setProperty('sub-delay', _subDelay.toString());
    } catch (_) {}
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _locked) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.space || k == LogicalKeyboardKey.mediaPlayPause) {
      _player.playOrPause();
    } else if (k == LogicalKeyboardKey.arrowRight) {
      _seekBy(_settings.seekForwardSeconds);
    } else if (k == LogicalKeyboardKey.arrowLeft) {
      _seekBy(-_settings.seekBackwardSeconds);
    } else if (k == LogicalKeyboardKey.arrowUp) {
      _bumpVolume(5);
    } else if (k == LogicalKeyboardKey.arrowDown) {
      _bumpVolume(-5);
    } else if (k == LogicalKeyboardKey.keyM) {
      _bumpVolume(_player.state.volume > 0 ? -100 : 100);
    } else if (k == LogicalKeyboardKey.keyN && _hasNext) {
      _playEpisode(_epIndex + 1);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // ── pickers ─────────────────────────────────────────────────────────────────
  Widget _sheet(String title, List<Widget> children) => ConstrainedBox(
        // Landscape has little vertical room; cap the sheet and let the options
        // scroll so the last row (e.g. Subtitle delay) is never clipped off-screen.
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...children,
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  void _openSheet(Widget content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      // Let the sheet grow past the default ~half-height so tall option lists fit
      // in landscape; _sheet caps + scrolls the content. SafeArea insets the bottom.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(child: content),
    );
  }

  void _showQualityPicker() {
    final t = AppLocalizations.of(context);
    _openSheet(_sheet(t.miscQuality, [
        ..._videos.asMap().entries.map((e) => ListTile(
              title: Text(e.value.quality.isEmpty ? t.miscSourceIndex(e.key) : e.value.quality,
                  style: const TextStyle(color: Colors.white)),
              trailing: e.key == _currentVideoIndex
                  ? const Icon(Icons.check_rounded, color: Colors.white)
                  : null,
              onTap: () {
                Navigator.pop(context);
                _switchQuality(e.key);
              },
            )),
      ]));
  }

  void _showSubtitlePicker() {
    final t = AppLocalizations.of(context);
    final subs =
        _videos.isNotEmpty ? (_videos[_currentVideoIndex].subtitles ?? []) : <MTrack>[];
    _openSheet(StatefulBuilder(
      builder: (ctx, setSheet) => _sheet(t.miscSubtitles, [
        ListTile(
          title: Text(t.miscSubtitleOff, style: const TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            _player.setSubtitleTrack(SubtitleTrack.no());
          },
        ),
        ...subs.map((track) => ListTile(
              title: Text(track.label ?? track.file ?? t.miscUnknownTrack,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                if (track.file != null) {
                  _player.setSubtitleTrack(SubtitleTrack.uri(track.file!, title: track.label));
                }
              },
            )),
        const Divider(color: Colors.white24),
        ListTile(
          title: Text(t.miscSubtitleDelay,
              style: const TextStyle(color: Colors.white)),
          subtitle: Text('${_subDelay.toStringAsFixed(1)}s',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
              onPressed: () => setSheet(() => _setSubDelay(_subDelay - 0.5)),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () => setSheet(() => _setSubDelay(_subDelay + 0.5)),
            ),
          ]),
        ),
      ]),
    ));
  }

  void _showAudioPicker() {
    final t = AppLocalizations.of(context);
    final audios =
        _videos.isNotEmpty ? (_videos[_currentVideoIndex].audios ?? []) : <MTrack>[];
    _openSheet(_sheet(t.miscAudio, [
      ...audios.map((track) => ListTile(
            title: Text(track.label ?? track.file ?? t.miscUnknownTrack,
                style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              if (track.file != null) {
                _player.setAudioTrack(AudioTrack.uri(track.file!, title: track.label));
              }
            },
          )),
    ]));
  }

  void _showSpeedPicker() {
    final t = AppLocalizations.of(context);
    _openSheet(_sheet(t.miscPlaybackSpeed, [
        for (final s in const [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])
          ListTile(
            title: Text('${s}x', style: const TextStyle(color: Colors.white)),
            trailing: s == _speed
                ? const Icon(Icons.check_rounded, color: Colors.white)
                : null,
            onTap: () {
              Navigator.pop(context);
              _setSpeed(s);
            },
          ),
      ]));
  }

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    _subs.clear();
    _focus.dispose();
    _timeTracker?.dispose();
    WakelockPlus.disable();
    _saveNow(notify: true);
    _player.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  String _fmt(Duration d) => formatDuration(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: _onKey,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _error != null
                ? _buildError()
                : Stack(
                    children: [
                      Positioned.fill(child: _videoWithControls()),
                      if (_activeStamp != null && !_settings.autoSkipIntro)
                        _skipButton(),
                      // Manual Skip-Intro button near the start, for sources that
                      // don't provide intro markers. Hidden once a source marker
                      // is active (its own button shows) or past the intro window.
                      if (_settings.showIntroSkipButton &&
                          !_locked &&
                          _activeStamp == null &&
                          _position > const Duration(seconds: 2) &&
                          _position < const Duration(minutes: 3))
                        _manualSkipButton(),
                      if (_locked) Positioned.fill(child: _lockOverlay()),
                    ],
                  ),
      ),
    );
  }

  Widget _videoWithControls() {
    return MaterialVideoControlsTheme(
      normal: _controlsTheme(),
      fullscreen: _controlsTheme(),
      child: Video(
        controller: _controller,
        controls: MaterialVideoControls,
        fit: _fit,
      ),
    );
  }

  MaterialVideoControlsThemeData _controlsTheme() {
    final hasSubs =
        _videos.isNotEmpty && (_videos[_currentVideoIndex].subtitles?.isNotEmpty ?? false);
    final hasAudio =
        _videos.isNotEmpty && (_videos[_currentVideoIndex].audios?.isNotEmpty ?? false);
    // We drive our OWN immersive landscape (not media_kit's fullscreen), so media_kit
    // applies no safe-area padding and the controls sit flush at the screen edges - 
    // the seek bar + time clip under the bottom/gesture area in landscape. Inset them
    // by the device's real system insets (plus a small floor for the bottom).
    final vp = MediaQuery.viewPaddingOf(context);
    return MaterialVideoControlsThemeData(
      seekOnDoubleTap: true,
      seekOnDoubleTapBackwardDuration: Duration(seconds: _settings.seekBackwardSeconds),
      seekOnDoubleTapForwardDuration: Duration(seconds: _settings.seekForwardSeconds),
      speedUpOnLongPress: _settings.longPressSpeedUp,
      speedUpFactor: _settings.speedFactor,
      volumeGesture: _settings.volumeGesture,
      brightnessGesture: _settings.brightnessGesture,
      // `padding` wraps the ENTIRE controls column (top bar, center buttons, seek bar,
      // time), so putting the bottom inset here lifts the seek bar + time off the screen
      // edge regardless of media_kit's internal row order. Floor of 16 so it clears the
      // gesture area even when the OS reports viewPadding.bottom == 0 in immersive mode.
      padding: EdgeInsets.only(
          top: vp.top,
          left: 8 + vp.left,
          right: 8 + vp.right,
          bottom: 16 + vp.bottom),
      seekBarMargin: const EdgeInsets.symmetric(horizontal: 8),
      bottomButtonBarMargin: const EdgeInsets.only(left: 16, right: 16),
      seekBarThumbColor: Colors.white,
      seekBarColor: Colors.white24,
      seekBarPositionColor: Colors.white,
      seekBarBufferColor: Colors.white38,
      topButtonBar: [
        _topBtn(Icons.arrow_back_rounded, () => Navigator.pop(context)),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.animeTitle != null)
                Text(widget.animeTitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
              if (_epTitle != null)
                Text(_epTitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, fontSize: 12),
                    overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        if (hasSubs) _topBtn(Icons.subtitles_outlined, _showSubtitlePicker),
        if (hasAudio) _topBtn(Icons.multitrack_audio_rounded, _showAudioPicker),
        if (_videos.length > 1) _topBtn(Icons.hd_outlined, _showQualityPicker),
        _topBtn(Icons.speed_rounded, _showSpeedPicker),
        _topBtn(Icons.aspect_ratio_rounded, _cycleFit),
        _topBtn(Icons.lock_open_rounded, () => setState(() => _locked = true)),
      ],
      primaryButtonBar: [
        if (_hasPrev)
          MaterialCustomButton(
            onPressed: () => _playEpisode(_epIndex - 1),
            icon: const Icon(Icons.skip_previous_rounded, color: Colors.white),
            iconSize: 30,
          ),
        MaterialCustomButton(
          onPressed: () => _seekBy(-_settings.seekBackwardSeconds),
          icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
          iconSize: 30,
        ),
        const SizedBox(width: 8),
        MaterialPlayOrPauseButton(iconSize: 48),
        const SizedBox(width: 8),
        MaterialCustomButton(
          onPressed: () => _seekBy(_settings.seekForwardSeconds),
          icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
          iconSize: 30,
        ),
        if (_hasNext)
          MaterialCustomButton(
            onPressed: () => _playEpisode(_epIndex + 1),
            icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
            iconSize: 30,
          ),
      ],
      // No fullscreen button - the player already forces immersive landscape, so a
      // second media_kit fullscreen layer would just fight our orientation setup.
      bottomButtonBar: const [
        MaterialPositionIndicator(),
        Spacer(),
      ],
    );
  }

  Widget _topBtn(IconData icon, VoidCallback onPressed) => MaterialCustomButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      );

  Widget _skipButton() {
    final t = AppLocalizations.of(context);
    final s = _activeStamp!;
    // Live countdown of the remaining window, so a user part-way through sees
    // how much is left to skip.
    final remaining =
        (s.end - _position.inMilliseconds / 1000.0).ceil().clamp(0, 5999);
    final label = s.isOutro ? t.miscSkipOutro : t.miscSkipIntro;
    return Positioned(
      right: 24,
      bottom: 96,
      child: SafeArea(
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black.withValues(alpha: 0.6),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // Dismiss immediately (a keyframe seek can land just before s.end
            // and otherwise leave the button up).
            final i = _stamps.indexOf(s);
            if (i >= 0) _skipped.add(i);
            _player.seek(Duration(milliseconds: (s.end * 1000).round()));
            setState(() => _activeStamp = null);
          },
          icon: const Icon(Icons.fast_forward_rounded, size: 18),
          label: Text('$label  ${remaining}s'),
        ),
      ),
    );
  }

  // Always-available manual intro skip (no source marker needed). Jumps forward
  // by the configured amount (default 85s ≈ a typical opening).
  Widget _manualSkipButton() {
    final t = AppLocalizations.of(context);
    final secs = _settings.introSkipSeconds;
    return Positioned(
      right: 24,
      bottom: 96,
      child: SafeArea(
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black.withValues(alpha: 0.45),
            foregroundColor: Colors.white,
          ),
          onPressed: () => _seekBy(secs),
          icon: const Icon(Icons.fast_forward_rounded, size: 18),
          label: Text('${t.miscSkipIntro}  +${secs}s'),
        ),
      ),
    );
  }

  Widget _lockOverlay() {
    final t = AppLocalizations.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: SafeArea(
            child: IconButton(
              icon: const Icon(Icons.lock_rounded, color: Colors.white),
              tooltip: t.miscUnlockControls,
              onPressed: () => setState(() => _locked = false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    final t = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white54, size: 52),
          const SizedBox(height: 16),
          Text(_error ?? t.miscUnknownError,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadVideoList,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(t.miscRetry),
          ),
        ],
      ),
    );
  }
}
