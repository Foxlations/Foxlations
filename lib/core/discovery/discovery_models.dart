// Shared types for the Discover feature - the recommendation feed that suggests
// new series to add or save for later. Kept separate from the tracker models so
// the discovery layer doesn't drag reading-status vocabulary into itself.

/// The three content lanes Discover serves. Mirrors the app's content-type split
/// ('manga' | 'anime' | 'novel'); [wire] is that string form used elsewhere.
enum DiscoverKind {
  manga,
  anime,
  novel;

  /// The 'manga' | 'anime' | 'novel' string the rest of the app uses
  /// (LibraryManga.contentType, MangaSource.itemType).
  String get wire {
    switch (this) {
      case DiscoverKind.manga:
        return 'manga';
      case DiscoverKind.anime:
        return 'anime';
      case DiscoverKind.novel:
        return 'novel';
    }
  }

  static DiscoverKind fromWire(String? s) {
    switch (s) {
      case 'anime':
        return DiscoverKind.anime;
      case 'novel':
        return DiscoverKind.novel;
      default:
        return DiscoverKind.manga;
    }
  }
}

/// How a feed is ordered.
enum DiscoverSort { trending, popular }

/// One recommendation card. It carries only metadata - a match to an installed
/// source (so it can actually be read) is resolved separately and lazily, since
/// not every recommended title exists in the user's sources.
class DiscoverItem {
  /// Where it came from: a tracker id ('anilist' / 'myanimelist') or, for the
  /// no-tracker fallback feed, `source:<sourceId>`.
  final String origin;

  /// The origin's own id - a tracker media id, or the source manga URL.
  final String id;

  final String title;
  final String coverUrl;
  final String summary;
  final List<String> genres;

  /// Normalized 0-10 (0 = unknown).
  final double score;

  /// Public link to the entry (AniList/MAL page), for "open in browser".
  final String url;

  final DiscoverKind kind;

  /// For a personalized "because you read X" pick, the seed title X that led
  /// here (null for trending/popular/genre picks). Only ever set when the user
  /// is signed in to the metadata source.
  final String? reason;

  const DiscoverItem({
    required this.origin,
    required this.id,
    required this.title,
    required this.kind,
    this.coverUrl = '',
    this.summary = '',
    this.genres = const [],
    this.score = 0,
    this.url = '',
    this.reason,
  });

  /// Stable identity for de-duping across pages/sources and against the
  /// wishlist (title-based, since the same series has different ids per origin).
  String get dedupeKey => title.trim().toLowerCase();
}
