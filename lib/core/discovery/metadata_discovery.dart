import 'discovery_models.dart';

/// A metadata service that can power the Discover feed (trending / by-genre /
/// personalized recommendations). Implemented by the trackers that have a
/// browsable catalog (AniList, MyAnimeList) - kept separate from the [Tracker]
/// contract so a tracker that only syncs progress doesn't have to pretend to
/// recommend.
///
/// AniList's GraphQL is public, so its discovery works with no login; MAL's API
/// needs the user's token, so it only contributes once connected. [isAvailable]
/// reflects that at runtime.
abstract class MetadataDiscovery {
  /// Stable id, matching the tracker id when it is one ('anilist').
  String get discoveryId;

  /// Display name for the source switcher (e.g. 'AniList', 'MyAnimeList').
  String get discoveryName;

  /// True when this source can serve a feed right now (public API, or connected).
  bool get isAvailable;

  /// Whether [feed] honors a genre filter. AniList does; MAL's ranking endpoint
  /// does not, so the UI hides genre chips when only MAL is available.
  bool get supportsGenreFilter;

  /// Whether this source can produce "because you read X" recommendations from
  /// the signed-in user's own list. Requires the user to be authenticated, so it
  /// is false for a public / logged-out source. Defaults to false; a source that
  /// can't personalize need not override [personalized].
  bool get supportsPersonalization => false;

  /// Recommendations seeded from the signed-in user's list ("because you read
  /// X"). Each returned item's [DiscoverItem.reason] names the seed title.
  /// Returns empty when unsupported or not signed in - the feed then stays
  /// trending/popular only.
  Future<List<DiscoverItem>> personalized({
    required DiscoverKind kind,
    int page = 1,
  }) async =>
      const [];

  /// The canonical genre list for [kind], for the filter chips. May be empty if
  /// the source has no browsable genre taxonomy.
  Future<List<String>> genres(DiscoverKind kind);

  /// A page of recommendations for [kind], optionally constrained to [genres]
  /// (AND-ed) and ordered by [sort]. Pages are 1-based. Returns an empty list on
  /// any failure - Discover degrades to another source rather than erroring.
  Future<List<DiscoverItem>> feed({
    required DiscoverKind kind,
    List<String> genres = const [],
    DiscoverSort sort = DiscoverSort.trending,
    int page = 1,
  });
}
