import 'dart:async';
import 'package:hive/hive.dart';
import 'app_logger.dart';
import '../models/manga_model.dart';
import '../models/chapter_model.dart';
import '../models/category_model.dart';

class LibraryService {
  final String _prefix;

  LibraryService({String prefix = 'library'}) : _prefix = prefix;

  Box<LibraryManga>? _mangaBox;
  Box<LibraryChapter>? _chapterBox;
  Box<Category>? _categoryBox;

  // Cached per-entry read/total tally, so [unreadCount] (hit once per library
  // card on every rebuild, and folded over the whole library for the header)
  // is an O(1) map lookup instead of an O(all chapters) box scan each call.
  // Built lazily in one pass and dropped whenever the chapter box changes
  // (the watch() below fires on every put/delete/save, including direct writes
  // from a backup restore), so it can never serve a stale count.
  Map<String, int>? _readTally;
  Map<String, int>? _totalTally;
  StreamSubscription<BoxEvent>? _chapterWatch;

  bool get isOpen => _mangaBox?.isOpen ?? false;

  /// Closes the boxes and drops the in-memory copies, so locking the vault
  /// actually evicts its data rather than just hiding it behind a flag.
  Future<void> close() async {
    await _chapterWatch?.cancel();
    _chapterWatch = null;
    _readTally = _totalTally = null;
    await _mangaBox?.close();
    await _chapterBox?.close();
    await _categoryBox?.close();
    _mangaBox = _chapterBox = null;
    _categoryBox = null;
  }

  static const _defaultCategories = [
    'Reading',
    'Completed',
    'On Hold',
    'Dropped',
    'Plan to Read',
  ];

  /// [cipher] encrypts the underlying Hive files at rest. Used by the vault so
  /// its contents are unreadable without the user's password — Hive refuses to
  /// open an encrypted box with the wrong key, so this is the actual access
  /// control, not the password prompt in the UI.
  Future<void> init({HiveAesCipher? cipher}) async {
    // Open the three boxes concurrently (start all, then await) — opening a box
    // deserializes its whole contents, and doing them in series added each box's
    // load to startup. They're independent, so overlap them.
    final mangaF = Hive.openBox<LibraryManga>('${_prefix}_manga',
        encryptionCipher: cipher);
    final chapterF = Hive.openBox<LibraryChapter>('${_prefix}_chapters',
        encryptionCipher: cipher);
    final categoryF = Hive.openBox<Category>('${_prefix}_categories',
        encryptionCipher: cipher);
    _mangaBox = await mangaF;
    _chapterBox = await chapterF;
    _categoryBox = await categoryF;
    // Drop the cached read tally on any chapter change so it's rebuilt fresh.
    _chapterWatch?.cancel();
    _readTally = _totalTally = null;
    _chapterWatch = _chapterBox!.watch().listen((_) {
      _readTally = null;
      _totalTally = null;
    });
    // Seed default categories on first run
    if (_categoryBox!.isEmpty) {
      for (int i = 0; i < _defaultCategories.length; i++) {
        await _categoryBox!.add(Category(name: _defaultCategories[i], order: i));
      }
    }
  }

  // ── Categories ──────────────────────────────────────────────
  List<Category> getCategories() {
    final cats = _categoryBox?.values.toList() ?? [];
    cats.sort((a, b) => a.order.compareTo(b.order));
    return cats;
  }

  Future<void> addCategory(String name) async {
    final order = (_categoryBox?.values.length ?? 0);
    final cat = Category(name: name, order: order);
    await _categoryBox?.add(cat);
  }

  Future<void> removeCategory(String name) async {
    final entry = _categoryBox?.values.cast<Category?>().firstWhere(
        (c) => c!.name == name,
        orElse: () => null);
    if (entry != null) {
      // Remove this category from all manga
      for (final manga in _mangaBox?.values ?? <LibraryManga>[]) {
        if (manga.categories.contains(name)) {
          manga.categories = List<String>.from(manga.categories)..remove(name);
          await manga.save();
        }
      }
      await entry.delete();
    }
  }

  Future<void> reorderCategories(List<String> orderedNames) async {
    for (int i = 0; i < orderedNames.length; i++) {
      final cat = _categoryBox?.values.cast<Category?>().firstWhere(
          (c) => c!.name == orderedNames[i],
          orElse: () => null);
      if (cat != null) {
        cat.order = i;
        await cat.save();
      }
    }
  }

  Future<void> renameCategory(String oldName, String newName) async {
    final cat = _categoryBox?.values.cast<Category?>().firstWhere(
        (c) => c!.name == oldName,
        orElse: () => null);
    if (cat != null) {
      cat.name = newName;
      await cat.save();
      // Update all manga referencing this category
      for (final manga in _mangaBox?.values ?? <LibraryManga>[]) {
        final idx = manga.categories.indexOf(oldName);
        if (idx != -1) {
          manga.categories = List<String>.from(manga.categories)
            ..[idx] = newName;
          await manga.save();
        }
      }
    }
  }

  List<LibraryManga> getAllManga() {
    return _mangaBox?.values.toList() ?? [];
  }

  LibraryManga? getManga(String sourceId, String url) {
    // The box is keyed by uniqueKey ('${sourceId}_$url'), so this is a direct
    // O(1) get — it used to scan every value (O(N)), which made per-card and
    // per-page-turn callers pay O(N) (and the unread badge O(N²)).
    return _mangaBox?.get('${sourceId}_$url');
  }

  bool isInLibrary(String sourceId, String url) {
    return getManga(sourceId, url) != null;
  }

  /// Cache the source's browsable page URL on the stored entry so "Open in
  /// WebView" is instant after a cold start (no embedded-JVM re-resolve).
  /// No-ops if the entry isn't in this box or the url is unchanged.
  Future<void> setWebUrl(String sourceId, String url, String? webUrl) async {
    if (webUrl == null || webUrl.isEmpty) return;
    final m = getManga(sourceId, url);
    if (m != null && m.webUrl != webUrl) {
      m.webUrl = webUrl;
      await m.save();
    }
  }

  Future<void> addManga(LibraryManga manga) async {
    await _mangaBox?.put(
        manga.uniqueKey, manga.isInBox ? manga.clone() : manga);
  }

  /// Adds an entry together with its full chapter objects, preserving per-
  /// chapter read state and page progress. Used when moving a title between the
  /// normal library and the vault so nothing is lost in the transfer.
  Future<void> addEntryWithChapters(
      LibraryManga manga, List<LibraryChapter> chapters) async {
    // Detach an entry that's still bound to its source box — Hive won't put the
    // same instance into two boxes.
    await _mangaBox?.put(
        manga.uniqueKey, manga.isInBox ? manga.clone() : manga);
    for (final ch in chapters) {
      // Re-home the chapter to this box exactly as-is (isRead/lastPageRead/
      // readAt intact); the destination has no prior copy to merge with.
      await _chapterBox?.put(ch.uniqueKey, ch.isInBox ? ch.clone() : ch);
    }
  }

  /// Permanently re-link entries a Tachiyomi/Mihon restore left pointing at a
  /// source NAME (because the matching source wasn't installed at restore time)
  /// onto the now-installed source id, rewriting the manga AND its chapters under
  /// the new id so library grouping / unread badges are correct too — not just
  /// opening (that's the runtime fallback in SourceProvider.resolveInstalled).
  ///
  /// [installedIdToName] is id → display name. Idempotent: entries already on an
  /// installed id, with no name match, or whose target key already exists (a real
  /// entry for that source — never clobbered), are left untouched. Returns the
  /// number of entries healed.
  Future<int> relinkSources(Map<String, String> installedIdToName) async {
    final box = _mangaBox;
    if (box == null || installedIdToName.isEmpty) return 0;
    final installedIds = installedIdToName.keys.toSet();
    String norm(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    String? matchId(String strayId) {
      final want = norm(strayId);
      if (want.isEmpty) return null;
      for (final e in installedIdToName.entries) {
        if (norm(e.value) == want) return e.key;
      }
      for (final e in installedIdToName.entries) {
        final n = norm(e.value);
        if (n.isNotEmpty && (n.contains(want) || want.contains(n))) return e.key;
      }
      return null;
    }

    // Snapshot first — we mutate the boxes while iterating.
    final strays =
        box.values.where((m) => !installedIds.contains(m.sourceId)).toList();
    var healed = 0;
    for (final m in strays) {
      final newId = matchId(m.sourceId);
      if (newId == null || newId == m.sourceId) continue;
      final newMangaKey = '${newId}_${m.url}';
      // Don't clobber a real entry that already exists for the installed source.
      if (box.containsKey(newMangaKey)) continue;

      final oldSourceId = m.sourceId;
      // Re-key this entry's chapters (clone — Hive won't re-put a bound object).
      final chs = _chapterBox?.values
              .where((c) => c.sourceId == oldSourceId && c.mangaUrl == m.url)
              .toList() ??
          const <LibraryChapter>[];
      for (final c in chs) {
        await _chapterBox?.delete(c.uniqueKey);
        final nc = c.clone()..sourceId = newId;
        await _chapterBox?.put(nc.uniqueKey, nc);
      }
      // Re-key the manga.
      final nm = m.clone()..sourceId = newId;
      await box.delete(m.uniqueKey);
      await box.put(nm.uniqueKey, nm);
      healed++;
    }
    if (healed > 0) _readTally = _totalTally = null; // chapter keys changed
    return healed;
  }

  /// The full chapter objects for an entry (with read state), for moving.
  List<LibraryChapter> getFullChapters(String sourceId, String mangaUrl) {
    return _chapterBox?.values
            .where((c) => c.sourceId == sourceId && c.mangaUrl == mangaUrl)
            .toList() ??
        [];
  }

  Future<void> removeManga(String sourceId, String url) async {
    final key = '${sourceId}_$url';
    await _mangaBox?.delete(key);
    // Also remove associated chapters
    final chapterKeys = _chapterBox?.keys.where((k) {
      final chapter = _chapterBox?.get(k);
      return chapter?.sourceId == sourceId && chapter?.mangaUrl == url;
    }).toList();
    if (chapterKeys != null) {
      // Delete from the CHAPTER box — this deleted from the manga box before,
      // so removed titles leaked their chapters forever and the chapter box
      // (which several O(N) scans walk) only ever grew.
      await _chapterBox?.deleteAll(chapterKeys);
    }
  }

  Future<void> updateManga(LibraryManga manga) async {
    await _mangaBox?.put(manga.uniqueKey, manga);
  }

  /// Overrides a library entry's cover with a local file (reader "Set as cover").
  /// [coverPath] is a filesystem path; stored as a `file://` URL that MangaImage
  /// renders directly. Returns false if the manga isn't in the library.
  Future<bool> setCover(String sourceId, String mangaUrl, String coverPath) async {
    final manga = getManga(sourceId, mangaUrl);
    if (manga == null) return false;
    manga.coverUrl = 'file://$coverPath';
    await updateManga(manga);
    return true;
  }

  Future<void> updateReadingProgress(
    String sourceId,
    String mangaUrl,
    String chapterUrl,
    int page,
  ) async {
    final manga = getManga(sourceId, mangaUrl);
    logger.info(
        'Reading-progress save: page=$page found=${manga != null} key=${sourceId}_$mangaUrl',
        category: LogCategory.library);
    if (manga != null) {
      manga.lastReadChapterUrl = chapterUrl;
      manga.lastReadPage = page;
      manga.lastReadAt = DateTime.now();
      await manga.save();
    }
  }

  /// Novel reading position. Stores the exact scroll [offset] plus a reflow-safe
  /// [fraction] (0..1) of total height, so "Resume" survives font-size changes.
  Future<void> updateNovelProgress(
    String sourceId,
    String mangaUrl,
    String chapterUrl,
    int offset,
    double fraction,
  ) async {
    final manga = getManga(sourceId, mangaUrl);
    if (manga != null) {
      manga.lastReadChapterUrl = chapterUrl;
      manga.novelProgressOffset = offset;
      manga.novelProgressFraction = fraction;
      manga.lastReadPage = offset; // back-compat; typed fields authoritative
      manga.lastReadAt = DateTime.now();
      await manga.save();
    }
  }

  /// Anime playback position. Episodes ride as chapters, so the position (seconds) is
  /// stored on the episode's LibraryChapter.lastPageRead, and the manga's last-watched
  /// pointer is aimed at it so "Resume" reopens the right episode.
  Future<void> updateEpisodeProgress(
    String sourceId,
    String mangaUrl,
    String episodeUrl,
    int positionSeconds, {
    int totalSeconds = 0,
  }) async {
    final key = '${sourceId}_$episodeUrl';
    var ch = _chapterBox?.get(key);
    if (ch != null) {
      ch.lastPageRead = positionSeconds;
      await ch.save();
    } else {
      ch = LibraryChapter(
        sourceId: sourceId,
        mangaUrl: mangaUrl,
        chapterUrl: episodeUrl,
        title: '',
        lastPageRead: positionSeconds,
      );
      await _chapterBox?.put(key, ch);
    }
    final manga = getManga(sourceId, mangaUrl);
    if (manga != null) {
      manga.lastReadChapterUrl = episodeUrl;
      manga.lastWatchSeconds = positionSeconds;
      if (totalSeconds > 0) manga.totalSeconds = totalSeconds;
      manga.lastReadPage = positionSeconds; // back-compat; typed fields authoritative
      manga.lastReadAt = DateTime.now();
      await manga.save();
    }
  }

  /// Saved playback position (seconds) for an episode, or 0 if none.
  int episodeLastPosition(String sourceId, String episodeUrl) =>
      _chapterBox?.get('${sourceId}_$episodeUrl')?.lastPageRead ?? 0;

  // Chapter tracking
  List<LibraryChapter> getChapters(String sourceId, String mangaUrl) {
    return _chapterBox?.values
            .where((c) => c.sourceId == sourceId && c.mangaUrl == mangaUrl)
            .toList() ??
        [];
  }

  Future<void> markChapterRead(
      String sourceId, String mangaUrl, String chapterUrl) async {
    final key = '${sourceId}_$chapterUrl';
    var chapter = _chapterBox?.get(key);
    if (chapter != null) {
      chapter.isRead = true;
      chapter.readAt = DateTime.now();
      await chapter.save();
    } else {
      chapter = LibraryChapter(
        sourceId: sourceId,
        mangaUrl: mangaUrl,
        chapterUrl: chapterUrl,
        title: '',
        isRead: true,
        readAt: DateTime.now(),
      );
      await _chapterBox?.put(key, chapter);
    }
    await _recountReadChapters(sourceId, mangaUrl);
  }

  /// Mark many chapters of one entry read in a single pass, recounting ONCE at
  /// the end. [markChapterRead] recounts after every chapter (an O(all chapters)
  /// box scan each time), so replaying a long read-history one chapter at a time
  /// — e.g. during a migrate — was O(matched × library). This keeps it O(library).
  Future<void> markChaptersRead(
      String sourceId, String mangaUrl, Iterable<String> chapterUrls) async {
    for (final chapterUrl in chapterUrls) {
      final key = '${sourceId}_$chapterUrl';
      var chapter = _chapterBox?.get(key);
      if (chapter != null) {
        chapter.isRead = true;
        chapter.readAt = DateTime.now();
        await chapter.save();
      } else {
        await _chapterBox?.put(
            key,
            LibraryChapter(
              sourceId: sourceId,
              mangaUrl: mangaUrl,
              chapterUrl: chapterUrl,
              title: '',
              isRead: true,
              readAt: DateTime.now(),
            ));
      }
    }
    await _recountReadChapters(sourceId, mangaUrl);
  }

  /// Keep the denormalized `manga.readChapters` counter — which the library
  /// badge reads as `totalChapters - readChapters` — in step with the per-chapter
  /// `isRead` flags. Called whenever a single chapter's read state changes, so
  /// the badge counts DOWN as the user reads instead of showing a static total.
  Future<void> _recountReadChapters(String sourceId, String mangaUrl) async {
    final manga = getManga(sourceId, mangaUrl);
    if (manga == null) return;
    final read = _chapterBox?.values
            .where((c) =>
                c.sourceId == sourceId && c.mangaUrl == mangaUrl && c.isRead)
            .length ??
        0;
    // totalChapters is authoritative when known (0 = not fetched yet); never
    // report more read than exist.
    manga.readChapters = manga.totalChapters > 0 && read > manga.totalChapters
        ? manga.totalChapters
        : read;
    await manga.save();
  }

  bool isChapterRead(String sourceId, String chapterUrl) {
    final key = '${sourceId}_$chapterUrl';
    return _chapterBox?.get(key)?.isRead ?? false;
  }

  /// Unread-chapter count for the library badge, computed from the *actual*
  /// cached chapters' read flags rather than the denormalized
  /// `totalChapters - readChapters` counters. Those counters can drift (a stale
  /// `totalChapters` from an over-reporting source, or a reader mark that didn't
  /// recount), which is what left the badge stuck at "99+" even after reading
  /// most chapters. When chapters are cached (the manga's detail was opened),
  /// this is ground truth; otherwise it falls back to the counters.
  /// Build the per-entry read/total tally in a single pass over the chapter box.
  /// Cached until the box next changes (see the watch() in [init]).
  void _ensureTally() {
    if (_readTally != null && _totalTally != null) return;
    final read = <String, int>{};
    final total = <String, int>{};
    final values = _chapterBox?.values;
    if (values != null) {
      for (final c in values) {
        final k = '${c.sourceId}\u0001${c.mangaUrl}';
        total[k] = (total[k] ?? 0) + 1;
        if (c.isRead) read[k] = (read[k] ?? 0) + 1;
      }
    }
    _readTally = read;
    _totalTally = total;
  }

  int unreadCount(String sourceId, String mangaUrl) {
    _ensureTally();
    final k = '$sourceId\u0001$mangaUrl';
    var total = _totalTally![k] ?? 0;
    var read = _readTally![k] ?? 0;
    if (total == 0) {
      // No cached chapters yet — fall back to the denormalized counters.
      final manga = getManga(sourceId, mangaUrl);
      if (manga == null) return 0;
      total = manga.totalChapters;
      read = manga.readChapters;
    }
    final unread = total - read;
    return unread < 0 ? 0 : unread;
  }

  Future<void> markChapterUnread(
      String sourceId, String mangaUrl, String chapterUrl) async {
    final key = '${sourceId}_$chapterUrl';
    final chapter = _chapterBox?.get(key);
    if (chapter != null) {
      chapter.isRead = false;
      chapter.readAt = null;
      await chapter.save();
    }
    await _recountReadChapters(sourceId, mangaUrl);
  }

  Future<void> markAllChaptersRead(String sourceId, String mangaUrl) async {
    // Flip every cached chapter's read flag so the per-chapter state and the
    // badge counter agree — otherwise a later single mark read/unread would
    // recount only the cached flags and wipe the "all read" state.
    final now = DateTime.now();
    final keys = _chapterBox?.keys.where((k) {
      final ch = _chapterBox?.get(k);
      return ch?.sourceId == sourceId && ch?.mangaUrl == mangaUrl;
    }).toList();
    if (keys != null) {
      for (final k in keys) {
        final ch = _chapterBox?.get(k);
        if (ch != null && !ch.isRead) {
          ch.isRead = true;
          ch.readAt = now;
          await ch.save();
        }
      }
    }
    final manga = getManga(sourceId, mangaUrl);
    if (manga != null) {
      manga.readChapters = manga.totalChapters;
      await manga.save();
    }
  }

  // ── Chapter cache ───────────────────────────────────────────
  /// Cache chapters for a library manga (called after getDetail).
  /// Records each chapter's position in the input list as `sourceIndex` so
  /// that [getCachedChapters] can return them in the original source order
  /// rather than Hive's key insertion order (which causes alphabetical
  /// "Chapter 1, 10, 100, 101..." flickering on first load).
  Future<void> cacheChapters(String sourceId, String mangaUrl, List<LibraryChapter> chapters) async {
    final box = _chapterBox;
    if (box == null) return;
    // Build the whole batch first, then write it in ONE putAll. A per-chapter
    // `await put` was O(N) separate disk/encryption transactions — on the
    // encrypted vault box a 3000-chapter title took many seconds (and could
    // appear to hang/error); putAll commits it as a single write.
    final batch = <dynamic, LibraryChapter>{};
    for (var i = 0; i < chapters.length; i++) {
      final ch = chapters[i];
      ch.sourceIndex = i;
      final key = ch.uniqueKey;
      final existing = box.get(key);
      if (existing != null) {
        // Preserve read state and page progress
        ch.isRead = existing.isRead;
        ch.lastPageRead = existing.lastPageRead;
        ch.readAt = existing.readAt;
      }
      batch[key] = ch;
    }
    await box.putAll(batch);

    // Update total chapters count on manga
    final manga = getManga(sourceId, mangaUrl);
    if (manga != null) {
      manga.totalChapters = chapters.length;
      await manga.save();
    }
  }

  /// Get cached chapters for a manga (for instant detail screen load)
  List<LibraryChapter> getCachedChapters(String sourceId, String mangaUrl) {
    final list = _chapterBox?.values
        .where((c) => c.sourceId == sourceId && c.mangaUrl == mangaUrl)
        .toList() ?? <LibraryChapter>[];
    final hasIndices = list.any((c) => c.sourceIndex != null);
    if (hasIndices) {
      // Cached after the sourceIndex fix — preserve the source's exact
      // order. Any stragglers without an index sort to the end.
      list.sort((a, b) {
        final ai = a.sourceIndex;
        final bi = b.sourceIndex;
        if (ai == null && bi == null) return 0;
        if (ai == null) return 1;
        if (bi == null) return -1;
        return ai.compareTo(bi);
      });
    } else {
      // Pre-fix cache — Hive's iteration order is unreliable here
      // (markChapterRead can splice records into the box at random points).
      // Fall back to natural-numeric sort on the chapter title, descending,
      // which matches how almost every source returns chapters (newest
      // first). The first background refresh will stamp real sourceIndex
      // values and switch to the branch above.
      list.sort((a, b) {
        final na = _parseChapterNumber(a.title);
        final nb = _parseChapterNumber(b.title);
        if (na == null && nb == null) return a.title.compareTo(b.title);
        if (na == null) return 1;
        if (nb == null) return -1;
        return nb.compareTo(na);
      });
    }
    return list;
  }

  static final _chapterNumberRegExp = RegExp(r'(\d+(?:\.\d+)?)');
  static double? _parseChapterNumber(String title) {
    final match = _chapterNumberRegExp.firstMatch(title);
    if (match == null) return null;
    return double.tryParse(match.group(1)!);
  }

  Future<void> markAllChaptersUnread(String sourceId, String mangaUrl) async {
    final manga = getManga(sourceId, mangaUrl);
    if (manga != null) {
      manga.readChapters = 0;
      manga.lastReadChapterUrl = null;
      manga.lastReadPage = 0;
      await manga.save();
    }
    // Flip each cached chapter's read flag OFF in place — this used to DELETE
    // the chapter records, which also dropped the cached chapter list and its
    // source ordering, so the detail screen showed no chapters until a refetch.
    final keys = _chapterBox?.keys.where((k) {
      final ch = _chapterBox?.get(k);
      return ch?.sourceId == sourceId && ch?.mangaUrl == mangaUrl;
    }).toList();
    if (keys != null) {
      for (final k in keys) {
        final ch = _chapterBox?.get(k);
        if (ch != null && ch.isRead) {
          ch.isRead = false;
          ch.readAt = null;
          await ch.save();
        }
      }
    }
  }

  // ── Reading stats ──────────────────────────────────────────────────
  /// Returns a map of `date (midnight) → number of chapters read on that
  /// day`, restricted to the last [days] days. Used by the activity
  /// heatmap.
  /// [sourceIds], when given, restricts the count to chapters from those
  /// sources — used to make the stats page reflect only the current content
  /// type (Manga / Anime / Light Novels). Null counts every source.
  Map<DateTime, int> getReadActivityByDay({int days = 365, Set<String>? sourceIds}) {
    final now = DateTime.now();
    final cutoff = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));
    final activity = <DateTime, int>{};
    if (_chapterBox == null) return activity;
    for (final ch in _chapterBox!.values) {
      final r = ch.readAt;
      if (r == null || !ch.isRead) continue;
      if (sourceIds != null && !sourceIds.contains(ch.sourceId)) continue;
      final day = DateTime(r.year, r.month, r.day);
      if (day.isBefore(cutoff)) continue;
      activity[day] = (activity[day] ?? 0) + 1;
    }
    return activity;
  }

  /// Current streak: consecutive days ending today (or yesterday) on
  /// which at least one chapter was read.
  int getCurrentReadingStreak({Set<String>? sourceIds}) {
    final activity = getReadActivityByDay(days: 365, sourceIds: sourceIds);
    if (activity.isEmpty) return 0;
    final now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day);
    // Allow the streak to be "alive" if user hasn't read yet today but did
    // read yesterday — start counting from yesterday in that case.
    if ((activity[day] ?? 0) == 0) {
      day = day.subtract(const Duration(days: 1));
      if ((activity[day] ?? 0) == 0) return 0;
    }
    var streak = 0;
    while ((activity[day] ?? 0) > 0) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Longest streak ever recorded in the chapter history.
  int getLongestReadingStreak({Set<String>? sourceIds}) {
    final activity = getReadActivityByDay(days: 365, sourceIds: sourceIds);
    if (activity.isEmpty) return 0;
    final dates = activity.keys.toList()..sort();
    var longest = 1;
    var current = 1;
    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else if (diff > 1) {
        current = 1;
      }
    }
    return longest;
  }
}
