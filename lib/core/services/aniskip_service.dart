import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../eval/model/m_video.dart';
import 'app_logger.dart';

/// Fetches crowd-sourced intro/outro (opening/ending) skip times from the
/// AniSkip API (api.aniskip.com) and maps them to the player's [MTimeStamp]
/// model, so Skip Intro / Skip Outro works on essentially any tracked anime —
/// not just the rare source that ships its own timestamps.
///
/// Keyed off the MyAnimeList id (from the anime's MAL tracker binding) + the
/// episode number + the episode length. Results are cached per (malId, ep) for
/// the session, and every failure is swallowed-but-logged (never blocks
/// playback).
class AniSkipService {
  AniSkipService._();
  static final AniSkipService instance = AniSkipService._();

  final Map<String, List<MTimeStamp>> _cache = {};

  Future<List<MTimeStamp>> fetch({
    required int malId,
    required int episodeNumber,
    required int episodeLengthSeconds,
  }) async {
    if (malId <= 0 || episodeNumber <= 0) return const [];
    final key = '$malId/$episodeNumber';
    final cached = _cache[key];
    if (cached != null) return cached;

    try {
      final uri = Uri.parse('https://api.aniskip.com/v2/skip-times/$malId/'
          '$episodeNumber'
          '?types[]=op&types[]=ed&types[]=mixed-op&types[]=mixed-ed&types[]=recap'
          '&episodeLength=${episodeLengthSeconds > 0 ? episodeLengthSeconds : 0}');
      final resp = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) {
        _cache[key] = const [];
        return const [];
      }
      final body = jsonDecode(resp.body);
      if (body is! Map || body['found'] != true || body['results'] is! List) {
        _cache[key] = const [];
        return const [];
      }
      final stamps = <MTimeStamp>[];
      for (final r in (body['results'] as List).whereType<Map>()) {
        final iv = r['interval'];
        if (iv is! Map) continue;
        final start = (iv['startTime'] as num?)?.toDouble();
        final end = (iv['endTime'] as num?)?.toDouble();
        if (start == null || end == null || end <= start) continue;
        final skipType = (r['skipType'] ?? '').toString();
        stamps.add(MTimeStamp(
          start: start,
          end: end,
          name: _nameFor(skipType),
          type: _typeFor(skipType),
        ));
      }
      stamps.sort((a, b) => a.start.compareTo(b.start));
      _cache[key] = stamps;
      return stamps;
    } catch (e) {
      await logger.warning('AniSkip lookup failed',
          category: LogCategory.network, detail: 'mal=$malId ep=$episodeNumber\n$e');
      _cache[key] = const [];
      return const [];
    }
  }

  // AniSkip skipType → the player's MTimeStamp.type ("Opening"/"Ending") +
  // a human name.
  String _typeFor(String skipType) {
    switch (skipType) {
      case 'ed':
      case 'mixed-ed':
        return 'Ending';
      case 'op':
      case 'mixed-op':
        return 'Opening';
      case 'recap':
        return 'Recap';
      default:
        return 'Other';
    }
  }

  String _nameFor(String skipType) {
    switch (skipType) {
      case 'ed':
      case 'mixed-ed':
        return 'Skip Outro';
      case 'op':
      case 'mixed-op':
        return 'Skip Intro';
      case 'recap':
        return 'Skip Recap';
      default:
        return 'Skip';
    }
  }
}
