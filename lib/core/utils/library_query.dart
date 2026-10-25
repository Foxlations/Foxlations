import '../models/library_settings.dart';
import '../models/manga_model.dart';

/// Applies the user's library filters and sort order.
///
/// Kept as a pure function (no BuildContext, no Hive) so the ordering rules can
/// be unit-tested without spinning up the widget tree.
///
/// [downloadedKeys] holds `sourceId::url` for entries with downloaded chapters;
/// the caller supplies it because download state lives outside the manga model.
List<LibraryManga> applyLibraryQuery(
  List<LibraryManga> input,
  LibrarySettings settings, {
  Set<String> downloadedKeys = const {},
}) {
  String keyOf(LibraryManga m) => '${m.sourceId}::${m.url}';
  int unreadOf(LibraryManga m) =>
      (m.totalChapters - m.readChapters).clamp(0, 1 << 31);

  var list = input;

  // Tri-state: off = keep all, include = keep only matches, exclude = drop
  // matches.
  bool pass(LibraryFilterState state, bool matches) => switch (state) {
        LibraryFilterState.off => true,
        LibraryFilterState.include => matches,
        LibraryFilterState.exclude => !matches,
      };

  if (settings.filterUnread.isActive ||
      settings.filterCompleted.isActive ||
      settings.filterDownloaded.isActive) {
    list = list.where((m) {
      if (!pass(settings.filterUnread, unreadOf(m) > 0)) {
        return false;
      }
      if (!pass(
          settings.filterCompleted, m.status.toLowerCase() == 'completed')) {
        return false;
      }
      if (!pass(settings.filterDownloaded, downloadedKeys.contains(keyOf(m)))) {
        return false;
      }
      return true;
    }).toList();
  }
  if (settings.filterSourceIds.isNotEmpty) {
    list = list
        .where((m) => settings.filterSourceIds.contains(m.sourceId))
        .toList();
  }

  // Decorate-sort-undecorate: lowercasing the title inside the comparator ran
  // it O(n log n) times (~40k transient strings at n=1000). Compute each title's
  // sort key ONCE, sort the decorated list, then strip it. Decorating also
  // copies - the caller's list may be an unmodifiable view of the Hive box, and
  // sorting it in place would reorder the box's own iteration order.
  final epoch = DateTime.fromMillisecondsSinceEpoch(0);
  final decorated = [
    for (final m in list) (m: m, key: m.title.toLowerCase()),
  ];

  decorated.sort((a, b) {
    final result = switch (settings.sort) {
      LibrarySort.alphabetical => a.key.compareTo(b.key),
      LibrarySort.lastRead =>
        (a.m.lastReadAt ?? epoch).compareTo(b.m.lastReadAt ?? epoch),
      LibrarySort.unread => unreadOf(a.m).compareTo(unreadOf(b.m)),
      LibrarySort.totalChapters =>
        a.m.totalChapters.compareTo(b.m.totalChapters),
      // Never-fetched entries sort as oldest, so ascending puts the entries
      // that have gone longest without a chapter check at the top.
      LibrarySort.chapterFetchDate =>
        (a.m.lastChapterFetchAt ?? epoch).compareTo(b.m.lastChapterFetchAt ?? epoch),
      LibrarySort.dateAdded => a.m.addedAt.compareTo(b.m.addedAt),
    };
    // Stable tie-break on the already-lowercased title key.
    final tie = result != 0 ? result : a.key.compareTo(b.key);
    return settings.sortAscending ? tie : -tie;
  });

  return [for (final d in decorated) d.m];
}
