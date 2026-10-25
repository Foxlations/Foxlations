import 'dart:io' show Platform;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Lock-screen / notification media controls for the novel "Listen" (TTS).
///
/// The TTS engine itself stays in the novel reader (so the sentence highlight
/// keeps working); this handler only mirrors play state to the OS media session
/// and routes the remote buttons (play / pause / stop / next / previous chapter)
/// back to the reader via the callbacks it registers in [bind]. Keeping the
/// playback state "playing" is also what lets audio_service hold a foreground
/// service (Android) / active audio session (iOS) so reading continues with the
/// screen locked.
class TtsAudioHandler extends BaseAudioHandler {
  VoidCallback? _onPlay;
  VoidCallback? _onPause;
  VoidCallback? _onStop;
  VoidCallback? _onNext;
  VoidCallback? _onPrevious;

  /// Attach the active reader's controls. Called when "Listen" starts.
  void bind({
    VoidCallback? onPlay,
    VoidCallback? onPause,
    VoidCallback? onStop,
    VoidCallback? onNext,
    VoidCallback? onPrevious,
  }) {
    _onPlay = onPlay;
    _onPause = onPause;
    _onStop = onStop;
    _onNext = onNext;
    _onPrevious = onPrevious;
  }

  /// Detach (reader closed / stopped) and hide the media session.
  void unbind() {
    _onPlay = _onPause = _onStop = _onNext = _onPrevious = null;
    playbackState.add(PlaybackState(
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
    mediaItem.add(null);
  }

  Duration _position = Duration.zero;
  double _speed = 1.0;

  /// Show (or update) what's being read on the lock screen / notification.
  /// [artPath] is a LOCAL image file (the cover, fetched + cached by the reader
  /// so art-loading honours the source's TLS/Referer). [duration] is the
  /// estimated chapter length, so the OS shows a timeline/scrubber.
  void setNowPlaying(
      {required String chapter,
      required String book,
      String? artPath,
      Duration? duration}) {
    mediaItem.add(MediaItem(
      id: chapter.isEmpty ? book : chapter,
      title: chapter.isEmpty ? book : chapter,
      artist: book,
      album: book,
      duration: duration,
      artUri: (artPath != null && artPath.isNotEmpty)
          ? Uri.file(artPath)
          : null,
    ));
  }

  /// Update just the playback position (the OS interpolates between updates
  /// using [_speed], so per-paragraph updates animate a smooth timeline).
  void setPosition(Duration position, {double speed = 1.0}) {
    _position = position;
    _speed = speed;
    final s = playbackState.value;
    playbackState.add(s.copyWith(
      updatePosition: position,
      speed: s.playing ? speed : 0,
    ));
  }

  /// Reflect play/pause + which chapter-skip buttons are available.
  void setPlaying(bool playing,
      {bool hasNext = false,
      bool hasPrevious = false,
      Duration? position,
      double? speed}) {
    if (position != null) _position = position;
    if (speed != null) _speed = speed;
    playbackState.add(PlaybackState(
      controls: [
        if (hasPrevious) MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        if (hasNext) MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      processingState: AudioProcessingState.ready,
      playing: playing,
      updatePosition: _position,
      speed: playing ? _speed : 0,
    ));
  }

  // ── Remote commands (lock screen / headset / Bluetooth) → reader ──
  @override
  Future<void> play() async => _onPlay?.call();

  @override
  Future<void> pause() async => _onPause?.call();

  @override
  Future<void> stop() async {
    _onStop?.call();
    unbind();
  }

  @override
  Future<void> skipToNext() async => _onNext?.call();

  @override
  Future<void> skipToPrevious() async => _onPrevious?.call();
}

/// The one media session for the app, or null when audio_service couldn't be
/// initialised (desktop/unsupported, or a failure) - callers must null-check.
TtsAudioHandler? ttsMediaSession;

/// Initialise the media session once, before runApp. Android/iOS only - other
/// platforms keep [ttsMediaSession] null and TTS runs without lock-screen
/// controls. Never throws: a failure just leaves the session unavailable.
Future<void> initTtsMediaSession() async {
  if (!(Platform.isAndroid || Platform.isIOS)) return;
  try {
    ttsMediaSession = await AudioService.init(
      builder: () => TtsAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.foxlations.tts',
        androidNotificationChannelName: 'Listen',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  } catch (e, s) {
    ttsMediaSession = null;
    await logger.error('TTS media session init failed',
        category: LogCategory.general, detail: '$e\n$s');
  }
}
