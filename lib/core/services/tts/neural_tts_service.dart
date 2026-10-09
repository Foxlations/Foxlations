import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

import '../app_logger.dart';

/// A downloadable offline neural voice (a sherpa-onnx Piper / VITS model).
///
/// Model archives are the official sherpa-onnx `tts-models` releases (.tar.bz2).
/// Only permissively-licensed voices are listed (ship CC0 / CC-BY only; attribute
/// CC-BY in About). Fully offline once downloaded.
class NeuralVoice {
  final String id;
  final String label;
  final String locale;
  final String url; // .tar.bz2 release archive
  final String dirName; // top-level folder inside the archive
  final String modelFile; // *.onnx inside dirName
  final int sizeMb;
  final String license;
  const NeuralVoice({
    required this.id,
    required this.label,
    required this.locale,
    required this.url,
    required this.dirName,
    required this.modelFile,
    required this.sizeMb,
    required this.license,
  });

  static const ljspeech = NeuralVoice(
    id: 'en_US-ljspeech-medium',
    label: 'English — LJSpeech (neural)',
    locale: 'en-US',
    url:
        'https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-ljspeech-medium.tar.bz2',
    dirName: 'vits-piper-en_US-ljspeech-medium',
    modelFile: 'en_US-ljspeech-medium.onnx',
    sizeMb: 63,
    license: 'Public Domain (LJ Speech)',
  );
  static const libritts = NeuralVoice(
    id: 'en_US-libritts_r-medium',
    label: 'English — LibriTTS-R (neural, multi-voice)',
    locale: 'en-US',
    url:
        'https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-libritts_r-medium.tar.bz2',
    dirName: 'vits-piper-en_US-libritts_r-medium',
    modelFile: 'en_US-libritts_r-medium.onnx',
    sizeMb: 76,
    license: 'CC-BY-4.0 (LibriTTS-R)',
  );

  static const all = <NeuralVoice>[ljspeech, libritts];
  static NeuralVoice byId(String? id) =>
      all.firstWhere((v) => v.id == id, orElse: () => all.first);
}

/// Offline neural text-to-speech via sherpa-onnx (Piper VITS). Downloads the
/// model on first use, then synthesizes a chunk of text to a WAV file the reader
/// plays. Everything is offline after the one-time download. All operations are
/// best-effort and never throw to the UI — callers check [isReady] / the return
/// value. Experimental: gated behind Advanced → Experimental in the UI.
class NeuralTtsService {
  NeuralTtsService._();
  static final NeuralTtsService instance = NeuralTtsService._();

  static bool _bindingsReady = false;
  sherpa.OfflineTts? _tts;
  String? _loadedVoiceId;
  bool _busy = false;

  bool get isReady => _tts != null;
  String? get loadedVoiceId => _loadedVoiceId;

  Future<Directory> _modelsDir() async {
    final base = await getApplicationSupportDirectory();
    final d = Directory('${base.path}/neural_tts');
    if (!await d.exists()) await d.create(recursive: true);
    return d;
  }

  Future<Directory> _voiceDir(NeuralVoice v) async =>
      Directory('${(await _modelsDir()).path}/${v.dirName}');

  /// True when the model + tokens for [v] are already on disk.
  Future<bool> isDownloaded(NeuralVoice v) async {
    final dir = await _voiceDir(v);
    return File('${dir.path}/${v.modelFile}').exists().then((m) async =>
        m && await File('${dir.path}/tokens.txt').exists());
  }

  /// Download + extract [v]'s model archive. [onProgress] gets 0..1. Returns
  /// true on success (or if already present).
  Future<bool> download(NeuralVoice v,
      {void Function(double)? onProgress}) async {
    try {
      if (await isDownloaded(v)) {
        onProgress?.call(1);
        return true;
      }
      final dir = await _modelsDir();
      final archivePath = '${dir.path}/${v.id}.tar.bz2';
      await Dio().download(v.url, archivePath, onReceiveProgress: (r, t) {
        if (t > 0) onProgress?.call((r / t).clamp(0.0, 1.0));
      });
      // .tar.bz2 -> bunzip -> untar into _modelsDir()/<dirName>/...
      final raw = await File(archivePath).readAsBytes();
      final tarBytes = BZip2Decoder().decodeBytes(raw);
      final archive = TarDecoder().decodeBytes(tarBytes);
      for (final f in archive) {
        if (!f.isFile) continue;
        final out = File('${dir.path}/${f.name}');
        await out.parent.create(recursive: true);
        await out.writeAsBytes(f.content as List<int>);
      }
      try {
        await File(archivePath).delete();
      } catch (_) {}
      return isDownloaded(v);
    } catch (e) {
      logger.error('Neural TTS download failed (${v.id})',
          category: LogCategory.network, detail: e.toString());
      return false;
    }
  }

  /// Ensure the engine is loaded with [v] (downloading if needed). Returns true
  /// when [isReady] with that voice.
  Future<bool> ensureReady(NeuralVoice v,
      {void Function(double)? onProgress}) async {
    if (_tts != null && _loadedVoiceId == v.id) return true;
    if (_busy) return false;
    _busy = true;
    try {
      if (!_bindingsReady) {
        sherpa.initBindings();
        _bindingsReady = true;
      }
      if (!await download(v, onProgress: onProgress)) return false;
      final dir = await _voiceDir(v);
      _tts?.free();
      _tts = sherpa.OfflineTts(sherpa.OfflineTtsConfig(
        model: sherpa.OfflineTtsModelConfig(
          vits: sherpa.OfflineTtsVitsModelConfig(
            model: '${dir.path}/${v.modelFile}',
            tokens: '${dir.path}/tokens.txt',
            dataDir: '${dir.path}/espeak-ng-data',
          ),
          numThreads: 2,
          provider: 'cpu',
          debug: false,
        ),
      ));
      _loadedVoiceId = v.id;
      return true;
    } catch (e) {
      logger.error('Neural TTS init failed (${v.id})',
          category: LogCategory.extension, detail: e.toString());
      _tts = null;
      _loadedVoiceId = null;
      return false;
    } finally {
      _busy = false;
    }
  }

  /// Synthesize [text] to a temp WAV file; returns the path, or null on failure.
  /// [speed] 1.0 = normal. The native generate() is synchronous and CPU-bound,
  /// so callers synthesize a paragraph at a time (short enough to stay smooth).
  Future<String?> synthesizeToWav(String text,
      {double speed = 1.0, int sid = 0}) async {
    final tts = _tts;
    if (tts == null || text.trim().isEmpty) return null;
    try {
      final audio = tts.generate(text: text, sid: sid, speed: speed);
      if (audio.samples.isEmpty || audio.sampleRate <= 0) return null;
      final tmp = await getTemporaryDirectory();
      final path =
          '${tmp.path}/ntts_${DateTime.now().microsecondsSinceEpoch}.wav';
      final ok = sherpa.writeWave(
          filename: path, samples: audio.samples, sampleRate: audio.sampleRate);
      return ok ? path : null;
    } catch (e) {
      logger.error('Neural TTS synth failed',
          category: LogCategory.extension, detail: e.toString());
      return null;
    }
  }

  void dispose() {
    try {
      _tts?.free();
    } catch (_) {}
    _tts = null;
    _loadedVoiceId = null;
  }
}
