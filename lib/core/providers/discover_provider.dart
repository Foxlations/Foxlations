import 'dart:math';

import 'package:flutter/foundation.dart';

import '../discovery/discovery_models.dart';
import '../discovery/metadata_discovery.dart';
import '../models/installed_source_model.dart';
import '../models/manga_model.dart';
import '../models/source_model.dart';
import '../services/wishlist_service.dart';
import '../../eval/lib.dart';
import '../../eval/model/m_manga.dart';
import '../utils/search_filter.dart';
import 'library_provider.dart';
import 'source_provider.dart';
import 'tracking_provider.dart';
import 'vault_provider.dart';

/// A recommended title matched to an installed source, so it can actually be
/// read: the source to run and the source's own manga entry.
class SourceMatch {
  final InstalledSource source;
  final MManga manga;
  const SourceMatch({required this.source, required this.manga});
}

/// Drives the Discover feed: one recommendation card at a time (Next pulls a new
/// one), sourced from a metadata service (AniList/MAL) with a fall-back to the
/// installed sources' own popular listings when no metadata source can answer.
///
/// Each card lazily resolves whether an installed source carries it: a match
/// enables "Add to Library", otherwise the user can "Save for later" (wishlist).
/// Feeds are per content type - the UI switches [kind] between manga/anime/novel.
class DiscoverProvider extends ChangeNotifier {
  // Injected after construction (see main.dart) - long-lived app singletons.
  late final TrackingProvider tracking;
  late final SourceProvider sources;
  late final LibraryProvider library;
  late final VaultProvider vault;

  final WishlistService _wishlist = WishlistService();
  final Random _random = Random();

  bool _initialized = false;
  bool get initialized => _initialized;

  DiscoverKind _kind = DiscoverKind.manga;
  DiscoverKind get kind => _kind;

  DiscoverSort _sort = DiscoverSort.trending;
  DiscoverSort get sort => _sort;

  // Genre filter (AND-ed). Only meaningful when the active source supports it.
  final Set<String> _genreFilter = {};
  Set<String> get genreFilter => _genreFilter;
  List<String> _availableGenres = const [];
  List<String> get availableGenres => _availableGenres;

  MetadataDiscovery? _activeSource;
  // User-chosen discovery source id (null = auto: the first available, which is
  // the public AniList). Only meaningful once more than one source is available.
  String? _preferredSourceId;

  /// True when a genre filter can be applied (the active metadata source honors
  /// it). Drives whether the UI shows the genre chips.
  bool get supportsGenreFilter => _activeSource?.supportsGenreFilter ?? false;

  /// Metadata sources usable right now - AniList always (public), MAL/others
  /// only once signed in.
  List<MetadataDiscovery> get availableSources => tracking.discoverySources;

  MetadataDiscovery? get activeSource => _activeSource;
  String? get activeSourceId => _activeSource?.discoveryId;

  /// Only offer a tracker switcher when there's an actual choice - i.e. the user
  /// is signed into a second source beyond the always-on public AniList. Not
  /// signed into anything ⇒ one source ⇒ no switcher shown.
  bool get canSwitchSource => availableSources.length > 1;

  // Personalized "because you read X" pool, blended into the feed when the
  // active source supports it (user signed in). Empty otherwise.
  final List<DiscoverItem> _personalPool = [];
  int _personalCursor = 0;
  int _shownCount = 0;

  final List<DiscoverItem> _queue = [];
  final Set<String> _seen = {};

  DiscoverItem? _current;
  DiscoverItem? get current => _current;

  bool _loading = false;
  bool get loading => _loading;

  /// True once a feed load has completed and produced nothing to show.
  bool _exhausted = false;
  bool get isEmpty => _exhausted && _current == null;

  // Per-card source match (async).
  SourceMatch? _match;
  SourceMatch? get match => _match;
  bool _matching = false;
  bool get matching => _matching;
  bool get canAddToLibrary => _match != null;

  // Cards acted on this session, for the card's button state.
  final Set<String> _added = {};
  bool get currentAdded =>
      _current != null && _added.contains(_current!.dedupeKey);
  bool get currentSaved =>
      _current != null && _wishlist.containsTitle(_current!.title);

  int _page = 1;

  Future<void> initialize() async {
    if (_initialized) return;
    await _wishlist.init();
    _initialized = true;
    notifyListeners();
  }

  List<LibraryManga> get wishlist => _wishlist.getAll();
  int get wishlistCount => _wishlist.getAll().length;

  /// Whether any installed source could carry titles of the current [kind] - the
  /// UI uses this to explain why matches/adds may not be available.
  bool get hasSourcesForKind => _sourcesForKind().isNotEmpty;

  // ── feed control ────────────────────────────────────────────────────────────

  Future<void> setKind(DiscoverKind kind, {bool force = false}) async {
    if (_kind == kind && !force && _current != null) return;
    _kind = kind;
    _genreFilter.clear();
    _availableGenres = const [];
    await _reload();
  }

  Future<void> setSort(DiscoverSort sort) async {
    if (_sort == sort) return;
    _sort = sort;
    await _reload();
  }

  /// Switch which metadata source powers the feed (from the tracker switcher).
  Future<void> setSource(String discoveryId) async {
    if (_preferredSourceId == discoveryId &&
        _activeSource?.discoveryId == discoveryId) {
      return;
    }
    _preferredSourceId = discoveryId;
    await _reload();
  }

  Future<void> toggleGenre(String genre) async {
    if (!_genreFilter.add(genre)) _genreFilter.remove(genre);
    await _reload();
  }

  Future<void> clearGenres() async {
    if (_genreFilter.isEmpty) return;
    _genreFilter.clear();
    await _reload();
  }

  /// Rebuild the feed from scratch for the current kind/sort/genre selection.
  Future<void> _reload() async {
    _queue.clear();
    _seen.clear();
    _personalPool.clear();
    _personalCursor = 0;
    _shownCount = 0;
    _current = null;
    _match = null;
    _matching = false;
    _exhausted = false;
    _page = 1;
    _activeSource = _pickSource();
    _loading = true;
    notifyListeners();
    // Load the genre list for the chips (best-effort) alongside the first page.
    if (_activeSource?.supportsGenreFilter == true && _availableGenres.isEmpty) {
      // ignore: unawaited_futures
      _loadGenres();
    }
    // Personalization is a *factor* only when signed in (source supports it).
    // A genre filter is an explicit narrowing, so pause personalization while
    // one is active and resume it when cleared.
    if (_activeSource?.supportsPersonalization == true && _genreFilter.isEmpty) {
      // ignore: unawaited_futures
      _loadPersonal();
    }
    await next(initial: true);
  }

  Future<void> _loadPersonal() async {
    final src = _activeSource;
    if (src == null || !src.supportsPersonalization) return;
    try {
      final items = await src.personalized(kind: _kind);
      _personalPool
        ..clear()
        ..addAll(items.where((it) => !_isExcluded(it)));
      _personalCursor = 0;
      if (_personalPool.isNotEmpty) notifyListeners();
    } catch (_) {/* personalization is best-effort */}
  }

  /// Ensure a feed exists - called when the screen first opens.
  Future<void> ensureLoaded() async {
    if (_current != null || _loading) return;
    await _reload();
  }

  MetadataDiscovery? _pickSource() {
    final available = tracking.discoverySources;
    if (available.isEmpty) return null;
    // Honor an explicit user choice while it's still available.
    if (_preferredSourceId != null) {
      for (final s in available) {
        if (s.discoveryId == _preferredSourceId) return s;
      }
    }
    // Auto: when a genre filter is active, prefer a source that can honor it.
    if (_genreFilter.isNotEmpty) {
      for (final s in available) {
        if (s.supportsGenreFilter) return s;
      }
    }
    return available.first;
  }

  Future<void> _loadGenres() async {
    try {
      final g = await _activeSource?.genres(_kind) ?? const [];
      if (g.isNotEmpty) {
        _availableGenres = g;
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Advance to the next recommendation.
  Future<void> next({bool initial = false}) async {
    if (!initial) {
      _loading = true;
      notifyListeners();
    }

    final item = await _takeNext();
    if (item == null) {
      // Nothing left to show.
      _current = null;
      _loading = false;
      _exhausted = true;
      _match = null;
      _matching = false;
      notifyListeners();
      return;
    }

    _seen.add(item.dedupeKey);
    _shownCount++;
    _current = item;
    _loading = false;
    _exhausted = false;
    notifyListeners();
    // Resolve a readable source in the background; prefetch more cards.
    // ignore: unawaited_futures
    _resolveMatch(item);
    if (_queue.length < 4) {
      // ignore: unawaited_futures
      _refill();
    }
  }

  /// Pick the next card, blending a personalized "because you read X" pick in
  /// roughly every third slot when the pool is populated (signed in). Falls back
  /// across trending ⇄ personalized so the deck never dead-ends early.
  Future<DiscoverItem?> _takeNext() async {
    final wantPersonal = _personalPool.isNotEmpty && _shownCount % 3 == 2;
    if (wantPersonal) {
      final p = _nextFromPersonal();
      if (p != null) return p;
    }
    await _ensureQueue();
    while (_queue.isNotEmpty) {
      final it = _queue.removeAt(0);
      if (_seen.contains(it.dedupeKey) || _isExcluded(it)) continue;
      return it;
    }
    // Trending exhausted - use any remaining personalized picks.
    return _nextFromPersonal();
  }

  DiscoverItem? _nextFromPersonal() {
    while (_personalCursor < _personalPool.length) {
      final it = _personalPool[_personalCursor++];
      if (_seen.contains(it.dedupeKey) || _isExcluded(it)) continue;
      return it;
    }
    return null;
  }

  Future<void> _ensureQueue() async {
    var tries = 0;
    while (_queue.isEmpty && tries < 3) {
      tries++;
      final batch = await _fetchPage();
      if (batch.isEmpty) break;
      for (final it in batch) {
        if (_seen.contains(it.dedupeKey)) continue;
        if (_isExcluded(it)) continue;
        _queue.add(it);
      }
    }
  }

  Future<void> _refill() async {
    if (_queue.length >= 4) return;
    final batch = await _fetchPage();
    for (final it in batch) {
      if (_seen.contains(it.dedupeKey)) continue;
      if (_isExcluded(it)) continue;
      _queue.add(it);
    }
    if (_queue.isNotEmpty) notifyListeners();
  }

  /// Fetch one page from the active metadata source; when it can't answer (no
  /// tracker reachable, or its results ran out) fall back to the installed
  /// sources' popular listings so Discover still works offline / logged-out.
  Future<List<DiscoverItem>> _fetchPage() async {
    final src = _activeSource;
    if (src != null) {
      try {
        final items = await src.feed(
          kind: _kind,
          genres: _genreFilter.toList(),
          sort: _sort,
          page: _page,
        );
        _page++;
        if (items.isNotEmpty) return items;
      } catch (_) {/* fall through to source popular */}
    }
    return _sourcePopularFallback();
  }

  Future<List<DiscoverItem>> _sourcePopularFallback() async {
    // Genre filtering isn't reliable across arbitrary sources, so the fallback
    // ignores it (the UI hides genre chips when no metadata source is active).
    final pool = _sourcesForKind()..shuffle(_random);
    final pick = pool.take(3);
    final out = <DiscoverItem>[];
    for (final s in pick) {
      try {
        final page = 1 + _random.nextInt(3);
        final res = await withExtensionService(
          s.source,
          s.sourceCode,
          (svc) => svc.getPopular(page),
        );
        for (final m in res.list) {
          out.add(_itemFromMManga(m, s.source));
        }
      } catch (_) {}
    }
    out.shuffle(_random);
    return out;
  }

  // ── source matching ─────────────────────────────────────────────────────────

  Future<void> _resolveMatch(DiscoverItem item) async {
    // A fallback item already IS a source result - it carries its own match.
    if (item.origin.startsWith('source:')) {
      final s = sources.getInstalledSource(item.origin.substring(7));
      if (s != null && _current?.dedupeKey == item.dedupeKey) {
        _match = SourceMatch(
          source: s,
          manga: MManga(name: item.title, link: item.id, imageUrl: item.coverUrl),
        );
        notifyListeners();
      }
      return;
    }
    _match = null;
    _matching = true;
    notifyListeners();
    final found = await _findMatch(item);
    // Only apply if this is still the visible card (user may have hit Next).
    if (_current?.dedupeKey == item.dedupeKey) {
      _match = found;
      _matching = false;
      notifyListeners();
    }
  }

  /// Search installed sources of the current kind for [item]'s title, returning
  /// the first confident title match. Capped and run in parallel to stay snappy.
  Future<SourceMatch?> _findMatch(DiscoverItem item) async {
    final candidates = _sourcesForKind().take(8).toList();
    if (candidates.isEmpty) return null;
    final results = await Future.wait(candidates.map((s) async {
      try {
        final res = await withExtensionService(
          s.source,
          s.sourceCode,
          (svc) => svc.search(item.title, 1, const []),
        );
        final matched = filterSearchResults(res.list, item.title);
        for (final m in matched) {
          if ((m.link ?? '').isNotEmpty && _titlesMatch(m.name ?? '', item.title)) {
            return SourceMatch(source: s, manga: m);
          }
        }
      } catch (_) {}
      return null;
    }));
    for (final r in results) {
      if (r != null) return r;
    }
    return null;
  }

  // ── actions ──────────────────────────────────────────────────────────────────

  /// Add the current card to the library via its resolved source match.
  /// Returns false if there's no readable source (caller should Save for later).
  Future<bool> addCurrentToLibrary() async {
    final item = _current;
    final m = _match;
    if (item == null || m == null) return false;
    final entry = LibraryManga(
      sourceId: m.source.source.id,
      url: m.manga.link ?? '',
      title: m.manga.name?.isNotEmpty == true ? m.manga.name! : item.title,
      coverUrl:
          m.manga.imageUrl?.isNotEmpty == true ? m.manga.imageUrl! : item.coverUrl,
      author: m.manga.author,
      description:
          m.manga.description?.isNotEmpty == true ? m.manga.description : item.summary,
      genres: (m.manga.genre?.isNotEmpty == true ? m.manga.genre! : item.genres),
      status: _statusWire(m.manga.status),
      contentType: _kind.wire,
    );
    await library.addToLibrary(entry);
    // If it was on the wishlist under a metadata key, retire that entry.
    await _wishlist.remove('${item.origin}_${item.id}');
    _added.add(item.dedupeKey);
    notifyListeners();
    return true;
  }

  /// Save the current card for later (metadata-only wishlist entry).
  Future<void> saveCurrentForLater() async {
    final item = _current;
    if (item == null) return;
    await _wishlist.add(LibraryManga(
      sourceId: item.origin,
      url: item.id,
      title: item.title,
      coverUrl: item.coverUrl,
      description: item.summary,
      genres: item.genres,
      contentType: _kind.wire,
    ));
    notifyListeners();
  }

  Future<void> removeFromWishlist(String key) async {
    await _wishlist.remove(key);
    notifyListeners();
  }

  /// Try to find an installed source for a saved-for-later entry so it can be
  /// pulled into the library. Returns the match (or null); does not add.
  Future<SourceMatch?> findSourceForWishlist(LibraryManga entry) {
    return _findMatch(DiscoverItem(
      origin: entry.sourceId,
      id: entry.url,
      title: entry.title,
      kind: DiscoverKind.fromWire(entry.contentType),
    ));
  }

  /// Promote a matched wishlist entry into the library, dropping it from the
  /// wishlist.
  Future<void> addWishlistMatchToLibrary(
      LibraryManga entry, SourceMatch m) async {
    await library.addToLibrary(LibraryManga(
      sourceId: m.source.source.id,
      url: m.manga.link ?? '',
      title: m.manga.name?.isNotEmpty == true ? m.manga.name! : entry.title,
      coverUrl: m.manga.imageUrl?.isNotEmpty == true
          ? m.manga.imageUrl!
          : entry.coverUrl,
      author: m.manga.author,
      description: m.manga.description?.isNotEmpty == true
          ? m.manga.description
          : entry.description,
      genres: (m.manga.genre?.isNotEmpty == true ? m.manga.genre! : entry.genres),
      status: _statusWire(m.manga.status),
      contentType: entry.contentType ?? _kind.wire,
    ));
    await _wishlist.remove(entry.uniqueKey);
    notifyListeners();
  }

  // ── helpers ──────────────────────────────────────────────────────────────────

  List<InstalledSource> _sourcesForKind() {
    var list =
        sources.installedSources.where((s) => _sourceMatchesKind(s.source));
    // Discover is a normal (non-vault) browsing surface: hide vault sources
    // unless the vault is open, matching global search.
    if (!vault.vaultActive) {
      list = list.where((s) => !vault.isSourceInVault(s.source.id));
    }
    if (!sources.showNsfw) {
      list = list.where((s) => !s.source.isNsfw);
    }
    return list.toList();
  }

  bool _sourceMatchesKind(MangaSource s) {
    switch (_kind) {
      case DiscoverKind.anime:
        return s.isAnime;
      case DiscoverKind.novel:
        return s.isNovel;
      case DiscoverKind.manga:
        return !s.isAnime && !s.isNovel;
    }
  }

  /// A recommendation is excluded once it's already in the library OR saved for
  /// later - the user has acted on it, so don't surface it again.
  bool _isExcluded(DiscoverItem item) =>
      _isInLibrary(item) || _wishlist.containsTitle(item.title);

  bool _isInLibrary(DiscoverItem item) {
    // Metadata items have no source key, so match by (normalized) title against
    // the current library.
    final t = _norm(item.title);
    if (t.isEmpty) return false;
    for (final m in library.manga) {
      if (m.contentTypeOr('manga') != _kind.wire) continue;
      if (_norm(m.title) == t) return true;
    }
    return false;
  }

  DiscoverItem _itemFromMManga(MManga m, MangaSource source) => DiscoverItem(
        origin: 'source:${source.id}',
        id: m.link ?? '',
        title: m.name ?? 'Unknown',
        kind: _kind,
        coverUrl: m.imageUrl ?? '',
        summary: m.description ?? '',
        genres: m.genre ?? const [],
        url: '',
      );

  String _statusWire(MangaStatus? s) {
    switch (s) {
      case MangaStatus.completed:
        return 'completed';
      case MangaStatus.onHiatus:
        return 'hiatus';
      case MangaStatus.canceled:
        return 'canceled';
      case MangaStatus.ongoing:
      case MangaStatus.publishingFinished:
        return 'ongoing';
      default:
        return 'unknown';
    }
  }

  String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();

  bool _titlesMatch(String a, String b) {
    final na = _norm(a);
    final nb = _norm(b);
    if (na.isEmpty || nb.isEmpty) return false;
    return na == nb || na.contains(nb) || nb.contains(na);
  }
}
