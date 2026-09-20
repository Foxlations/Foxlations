import 'dart:convert';
import 'package:http/http.dart' as http;

import '../discovery/discovery_models.dart';
import '../discovery/metadata_discovery.dart';
import 'tracker.dart';
import 'tracker_models.dart';

/// AniList (anilist.co) — GraphQL API, OAuth2 **implicit grant** (no client
/// secret). The user authorizes at [authorizeUrl]; the pin page shows an access
/// token they paste back via [authenticateWithToken]. Token is valid ~1 year.
///
/// Also powers the Discover feed via [MetadataDiscovery]: AniList's GraphQL is
/// public, so trending/genre queries work with no login.
class AniListTracker extends Tracker implements MetadataDiscovery {
  static const _graphql = 'https://graphql.anilist.co';

  String? _token;
  String? _username;

  @override
  String get id => 'anilist';
  @override
  String get name => 'AniList';
  @override
  int get colorValue => 0xFF02A9FF;
  @override
  TrackerAuthType get authType => TrackerAuthType.oauth;

  @override
  bool get isAuthenticated => _token != null;
  @override
  String? get username => _username;

  @override
  Map<String, dynamic> exportSession() =>
      {'token': _token, 'username': _username};

  @override
  void restoreSession(Map<String, dynamic> data) {
    _token = data['token'] as String?;
    _username = data['username'] as String?;
  }

  @override
  void logout() {
    _token = _username = null;
  }

  @override
  String authorizeUrl(String clientId) =>
      'https://anilist.co/api/v2/oauth/authorize'
      '?client_id=$clientId&response_type=token';

  Future<Map<String, dynamic>?> _query(String query,
      Map<String, dynamic> variables) async {
    final res = await http.post(
      Uri.parse(_graphql),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'query': query, 'variables': variables}),
    );
    if (res.statusCode != 200) return null;
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return body['data'] as Map<String, dynamic>?;
  }

  @override
  Future<bool> authenticateWithToken(String token) async {
    _token = token.trim();
    final data = await _query('query { Viewer { id name } }', const {});
    final viewer = data?['Viewer'] as Map<String, dynamic>?;
    if (viewer == null) {
      _token = null;
      return false;
    }
    _username = viewer['name']?.toString();
    return true;
  }

  @override
  Future<List<TrackSearchResult>> search(String query) async {
    const q = r'''
query ($s: String) {
  Page(perPage: 15) {
    media(search: $s, type: MANGA) {
      id
      title { romaji english }
      chapters
      coverImage { large medium }
      description(asHtml: false)
      siteUrl
    }
  }
}''';
    final data = await _query(q, {'s': query});
    final media = (data?['Page']?['media'] as List?) ?? const [];
    return media.map((raw) {
      final m = raw as Map<String, dynamic>;
      final title = (m['title']?['english'] ?? m['title']?['romaji'] ?? 'Unknown')
          .toString();
      return TrackSearchResult(
        mediaId: m['id'].toString(),
        title: title,
        coverUrl:
            (m['coverImage']?['large'] ?? m['coverImage']?['medium'] ?? '')
                .toString(),
        totalChapters: (m['chapters'] as num?)?.toInt() ?? 0,
        summary: (m['description'] ?? '')
            .toString()
            .replaceAll(RegExp(r'<[^>]+>'), ''),
        url: (m['siteUrl'] ?? '').toString(),
      );
    }).toList();
  }

  @override
  Future<TrackRecord?> refresh(String mediaId) async {
    if (!isAuthenticated) return null;
    const q = r'''
query ($id: Int) {
  Media(id: $id) {
    chapters
    mediaListEntry {
      status
      progress
      score(format: POINT_10_DECIMAL)
    }
  }
}''';
    final data = await _query(q, {'id': int.tryParse(mediaId) ?? 0});
    final media = data?['Media'] as Map<String, dynamic>?;
    final entry = media?['mediaListEntry'] as Map<String, dynamic>?;
    if (entry == null) return null;
    return TrackRecord(
      trackerId: id,
      mediaId: mediaId,
      status: _fromAniStatus(entry['status']?.toString()),
      lastChapterRead: (entry['progress'] as num?)?.toInt() ?? 0,
      totalChapters: (media?['chapters'] as num?)?.toInt() ?? 0,
      score: (entry['score'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  Future<bool> push(TrackRecord r) async {
    if (!isAuthenticated) return false;
    const m = r'''
mutation ($id: Int, $status: MediaListStatus, $progress: Int, $score: Float) {
  SaveMediaListEntry(mediaId: $id, status: $status, progress: $progress, score: $score) {
    id
  }
}''';
    final data = await _query(m, {
      'id': int.tryParse(r.mediaId) ?? 0,
      'status': _toAniStatus(r.status),
      'progress': r.lastChapterRead,
      'score': r.score,
    });
    return data?['SaveMediaListEntry'] != null;
  }

  // ── discovery (MetadataDiscovery) ──────────────────────────────────────────

  @override
  String get discoveryId => id;

  @override
  String get discoveryName => name;

  /// AniList's public GraphQL serves trending/genre queries without a token, so
  /// Discover works before the user links anything.
  @override
  bool get isAvailable => true;

  @override
  bool get supportsGenreFilter => true;

  /// "Because you read X" needs the user's own list, which requires a token.
  @override
  bool get supportsPersonalization => isAuthenticated;

  List<String>? _genreCache;

  @override
  Future<List<String>> genres(DiscoverKind kind) async {
    // AniList has one shared genre collection across media types.
    if (_genreCache != null) return _genreCache!;
    final data = await _query('query { GenreCollection }', const {});
    final list = (data?['GenreCollection'] as List?)
            ?.map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList() ??
        const <String>[];
    if (list.isNotEmpty) _genreCache = list;
    return list;
  }

  @override
  Future<List<DiscoverItem>> feed({
    required DiscoverKind kind,
    List<String> genres = const [],
    DiscoverSort sort = DiscoverSort.trending,
    int page = 1,
  }) async {
    // AniList lumps light novels under type MANGA (format NOVEL); split them out
    // so the manga lane never shows novels and vice-versa. Build the media()
    // args WITHOUT any null filter: AniList reads an explicit `format: null` as
    // "format IS null" (matches nothing), which silently emptied the manga lane
    // when it was passed alongside format_not.
    final type = kind == DiscoverKind.anime ? 'ANIME' : 'MANGA';
    final args = StringBuffer(r'type: $type, sort: $sort, isAdult: false');
    if (kind == DiscoverKind.novel) {
      args.write(', format: NOVEL');
    } else if (kind == DiscoverKind.manga) {
      args.write(', format_not: NOVEL');
    }
    if (genres.isNotEmpty) args.write(r', genre_in: $genres');
    final q = '''
query (\$page: Int, \$type: MediaType, \$sort: [MediaSort]${genres.isNotEmpty ? r', $genres: [String]' : ''}) {
  Page(page: \$page, perPage: 30) {
    media($args) {
      id
      title { romaji english }
      coverImage { extraLarge large }
      description(asHtml: false)
      genres
      averageScore
      siteUrl
    }
  }
}''';
    final data = await _query(q, {
      'page': page,
      'type': type,
      'sort':
          sort == DiscoverSort.trending ? ['TRENDING_DESC'] : ['POPULARITY_DESC'],
      if (genres.isNotEmpty) 'genres': genres,
    });
    final media = (data?['Page']?['media'] as List?) ?? const [];
    return media.map((raw) {
      final m = raw as Map<String, dynamic>;
      final title =
          (m['title']?['english'] ?? m['title']?['romaji'] ?? 'Unknown')
              .toString();
      return DiscoverItem(
        origin: id,
        id: m['id'].toString(),
        title: title,
        kind: kind,
        coverUrl:
            (m['coverImage']?['extraLarge'] ?? m['coverImage']?['large'] ?? '')
                .toString(),
        summary: (m['description'] ?? '')
            .toString()
            .replaceAll(RegExp(r'<[^>]+>'), '')
            .trim(),
        genres:
            (m['genres'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        score: ((m['averageScore'] as num?)?.toDouble() ?? 0) / 10.0,
        url: (m['siteUrl'] ?? '').toString(),
      );
    }).toList();
  }

  @override
  Future<List<DiscoverItem>> personalized({
    required DiscoverKind kind,
    int page = 1,
  }) async {
    if (!isAuthenticated || _username == null) return const [];
    final type = kind == DiscoverKind.anime ? 'ANIME' : 'MANGA';

    // 1) The user's list → candidate seeds + the set of media they already have
    //    (so recommendations never suggest something already on their list).
    const listQ = r'''
query ($user: String, $type: MediaType) {
  MediaListCollection(userName: $user, type: $type) {
    lists {
      entries {
        score(format: POINT_100)
        media { id format title { romaji english } }
      }
    }
  }
}''';
    final listData = await _query(listQ, {'user': _username, 'type': type});
    final lists =
        (listData?['MediaListCollection']?['lists'] as List?) ?? const [];
    final owned = <int>{};
    final seeds = <({int id, String title, double score})>[];
    for (final l in lists) {
      final entries = ((l as Map)['entries'] as List?) ?? const [];
      for (final e in entries) {
        final media = ((e as Map)['media'] as Map?);
        if (media == null) continue;
        if (!_formatMatchesKind(kind, media['format']?.toString())) continue;
        final mid = (media['id'] as num?)?.toInt();
        if (mid == null) continue;
        owned.add(mid);
        final title =
            (media['title']?['english'] ?? media['title']?['romaji'] ?? '')
                .toString();
        if (title.isEmpty) continue;
        seeds.add((
          id: mid,
          title: title,
          score: (e['score'] as num?)?.toDouble() ?? 0,
        ));
      }
    }
    if (seeds.isEmpty) return const [];
    // Seed from their highest-rated titles.
    seeds.sort((a, b) => b.score.compareTo(a.score));
    final topSeeds = seeds.take(8).toList();

    // 2) Recommendations for those seeds, in one query (id_in).
    const recQ = r'''
query ($ids: [Int], $type: MediaType) {
  Page(perPage: 50) {
    media(id_in: $ids, type: $type) {
      id
      recommendations(sort: RATING_DESC, perPage: 6) {
        nodes {
          mediaRecommendation {
            id
            title { romaji english }
            coverImage { extraLarge large }
            description(asHtml: false)
            genres
            averageScore
            siteUrl
            format
          }
        }
      }
    }
  }
}''';
    final recData = await _query(
        recQ, {'ids': topSeeds.map((s) => s.id).toList(), 'type': type});
    final media = (recData?['Page']?['media'] as List?) ?? const [];
    final seedTitleById = {for (final s in topSeeds) s.id: s.title};

    final out = <DiscoverItem>[];
    final picked = <int>{};
    for (final raw in media) {
      final seedId = ((raw as Map)['id'] as num?)?.toInt();
      final seedTitle = seedTitleById[seedId] ?? '';
      final nodes = (raw['recommendations']?['nodes'] as List?) ?? const [];
      for (final n in nodes) {
        final rm = ((n as Map)['mediaRecommendation'] as Map?);
        if (rm == null) continue;
        final rid = (rm['id'] as num?)?.toInt();
        if (rid == null || owned.contains(rid) || !picked.add(rid)) continue;
        if (!_formatMatchesKind(kind, rm['format']?.toString())) continue;
        final title =
            (rm['title']?['english'] ?? rm['title']?['romaji'] ?? 'Unknown')
                .toString();
        out.add(DiscoverItem(
          origin: id,
          id: rid.toString(),
          title: title,
          kind: kind,
          coverUrl:
              (rm['coverImage']?['extraLarge'] ?? rm['coverImage']?['large'] ?? '')
                  .toString(),
          summary: (rm['description'] ?? '')
              .toString()
              .replaceAll(RegExp(r'<[^>]+>'), '')
              .trim(),
          genres: (rm['genres'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
          score: ((rm['averageScore'] as num?)?.toDouble() ?? 0) / 10.0,
          url: (rm['siteUrl'] ?? '').toString(),
          reason: seedTitle,
        ));
      }
    }
    out.shuffle();
    return out;
  }

  /// AniList type MANGA covers both manga and light novels (format NOVEL); keep
  /// each Discover lane pure. Anime is already scoped by type ANIME.
  bool _formatMatchesKind(DiscoverKind kind, String? format) {
    switch (kind) {
      case DiscoverKind.anime:
        return true;
      case DiscoverKind.novel:
        return format == 'NOVEL';
      case DiscoverKind.manga:
        return format != 'NOVEL';
    }
  }

  String _toAniStatus(TrackStatus s) {
    switch (s) {
      case TrackStatus.reading:
        return 'CURRENT';
      case TrackStatus.planToRead:
        return 'PLANNING';
      case TrackStatus.completed:
        return 'COMPLETED';
      case TrackStatus.onHold:
        return 'PAUSED';
      case TrackStatus.dropped:
        return 'DROPPED';
      case TrackStatus.rereading:
        return 'REPEATING';
    }
  }

  TrackStatus _fromAniStatus(String? s) {
    switch (s) {
      case 'PLANNING':
        return TrackStatus.planToRead;
      case 'COMPLETED':
        return TrackStatus.completed;
      case 'PAUSED':
        return TrackStatus.onHold;
      case 'DROPPED':
        return TrackStatus.dropped;
      case 'REPEATING':
        return TrackStatus.rereading;
      default:
        return TrackStatus.reading;
    }
  }
}
