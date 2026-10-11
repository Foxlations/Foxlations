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

  // Copy before sorting: the caller's list may be an unmodifiable view of the
  // Hive box, and sorting in place would reorder the box's own iteration order.
  final sorted = List<LibraryManga>.from(list);
  final epoch = DateTime.fromMillisecondsSinceEpoch(0);

  int cmp(LibraryManga a, LibraryManga b) {
    switch (settings.sort) {
      case LibrarySort.alphabetical:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case LibrarySort.lastRead:
        return (a.lastReadAt ?? epoch).compareTo(b.lastReadAt ?? epoch);
      case LibrarySort.unread:
        return unreadOf(a).compareTo(unreadOf(b));
      case LibrarySort.totalChapters:
        return a.totalChapters.compareTo(b.totalChapters);
      case LibrarySort.chapterFetchDate:
        // Never-fetched entries sort as oldest, so ascending puts the entries
        // that have gone longest without a chapter check at the top.
        return (a.lastChapterFetchAt ?? epoch)
            .compareTo(b.lastChapterFetchAt ?? epoch);
      case LibrarySort.dateAdded:
        return a.addedAt.compareTo(b.addedAt);
    }
  }

  sorted.sort((a, b) {
    final result = cmp(a, b);
    // Stable tie-break on title so equal keys don't shuffle between rebuilds.
    final tie = result != 0
        ? result
        : a.title.toLowerCase().compareTo(b.title.toLowerCase());
    return settings.sortAscending ? tie : -tie;
  });

  return sorted;
}
