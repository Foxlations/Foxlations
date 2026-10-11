import '../services/settings_store.dart';

/// How the library list is ordered.
///
/// "Latest chapter" is still absent: it needs a parsed per-chapter upload date,
/// and `LibraryChapter.dateUpload` is an unparsed source-supplied String whose
/// format varies per site. Sorting by it would be wrong more often than right.
enum LibrarySort {
  alphabetical('Alphabetical'),
  lastRead('Last Read'),
  unread('Unread'),
  totalChapters('Total chapters'),
  chapterFetchDate('Chapter fetch date'),
  dateAdded('Date Added');

  const LibrarySort(this.label);
  final String label;
}

/// How each entry is drawn.
enum LibraryDisplayMode {
  grid('Grid'),
  list('List'),
  descriptiveList('Descriptive List');

  const LibraryDisplayMode(this.label);
  final String label;
}

/// Tri-state library filter (Mihon-style):
/// off = no filter · include = show only matches · exclude = hide matches.
enum LibraryFilterState {
  off,
  include,
  exclude;

  /// The cycle the filter cells walk on each tap: off → include → exclude → off.
  LibraryFilterState get next => switch (this) {
        LibraryFilterState.off => LibraryFilterState.include,
        LibraryFilterState.include => LibraryFilterState.exclude,
        LibraryFilterState.exclude => LibraryFilterState.off,
      };

  bool get isActive => this != LibraryFilterState.off;
}

/// Where the title sits on a grid cover card.
enum LibraryCardTitle {
  onCover('On cover'),
  below('Below cover'),
  hidden('Hidden');

  const LibraryCardTitle(this.label);
  final String label;
}

/// Where the badges sit on a grid cover card.
enum LibraryCardBadges {
  barUnder('Bar under cover'),
  cornerOnCover('Corner on cover'),
  bottomOnCover('Bottom-left on cover');

  const LibraryCardBadges(this.label);
  final String label;
}

/// How reading progress is drawn on a grid cover card.
enum LibraryCardProgress {
  line('Line'),
  miniBar('Mini bar'),
  percent('Percent'),
  off('Off');

  const LibraryCardProgress(this.label);
  final String label;
}

/// User-controlled library filter / sort / display state.
///
/// Persisted globally (not per-category) — a single set of preferences applies
/// to every tab, which is the simpler contract and matches how the rest of the
/// app stores settings. Changing this to per-category later only requires
/// suffixing the pref keys with the category name.
class LibrarySettings {
  // Filters (tri-state: off / include / exclude)
  final LibraryFilterState filterUnread;
  final LibraryFilterState filterCompleted;
  final LibraryFilterState filterDownloaded;
  final Set<String> filterSourceIds;

  // Sort
  final LibrarySort sort;
  final bool sortAscending;

  // Display
  final LibraryDisplayMode displayMode;
  final int itemsPerRow;
  final bool badgeUnread;
  final bool badgeDownloaded;
  final bool badgeLanguage;
  final bool badgeLocal;
  final bool showTabCounts;

  // Grid cover-card layout (configured live from the options sheet).
  final LibraryCardTitle cardTitle;
  final LibraryCardBadges cardBadges;
  final LibraryCardProgress cardProgress;

  // Read-only mirror of a setting owned by the Settings > Library page (written
  // there under 'lib_hide_empty_cats'). Loaded here so the library screen, which
  // already consumes this model, can act on it. Not written by [save] — the
  // settings page is the single writer.
  final bool hideEmptyCategories;

  const LibrarySettings({
    this.filterUnread = LibraryFilterState.off,
    this.filterCompleted = LibraryFilterState.off,
    this.filterDownloaded = LibraryFilterState.off,
    this.filterSourceIds = const {},
    this.sort = LibrarySort.alphabetical,
    this.sortAscending = true,
    this.displayMode = LibraryDisplayMode.grid,
    this.itemsPerRow = 3,
    this.badgeUnread = true,
    this.badgeDownloaded = true,
    this.badgeLanguage = false,
    this.badgeLocal = false,
    this.showTabCounts = false,
    this.cardTitle = LibraryCardTitle.onCover,
    this.cardBadges = LibraryCardBadges.barUnder,
    this.cardProgress = LibraryCardProgress.percent,
    this.hideEmptyCategories = false,
  });

  bool get hasActiveFilter =>
      filterUnread.isActive ||
      filterCompleted.isActive ||
      filterDownloaded.isActive ||
      filterSourceIds.isNotEmpty;

  int get activeFilterCount =>
      (filterUnread.isActive ? 1 : 0) +
      (filterCompleted.isActive ? 1 : 0) +
      (filterDownloaded.isActive ? 1 : 0) +
      (filterSourceIds.isEmpty ? 0 : 1);

  LibrarySettings copyWith({
    LibraryFilterState? filterUnread,
    LibraryFilterState? filterCompleted,
    LibraryFilterState? filterDownloaded,
    Set<String>? filterSourceIds,
    LibrarySort? sort,
    bool? sortAscending,
    LibraryDisplayMode? displayMode,
    int? itemsPerRow,
    bool? badgeUnread,
    bool? badgeDownloaded,
    bool? badgeLanguage,
    bool? badgeLocal,
    bool? showTabCounts,
    LibraryCardTitle? cardTitle,
    LibraryCardBadges? cardBadges,
    LibraryCardProgress? cardProgress,
    bool? hideEmptyCategories,
  }) {
    return LibrarySettings(
      filterUnread: filterUnread ?? this.filterUnread,
      filterCompleted: filterCompleted ?? this.filterCompleted,
      filterDownloaded: filterDownloaded ?? this.filterDownloaded,
      filterSourceIds: filterSourceIds ?? this.filterSourceIds,
      sort: sort ?? this.sort,
      sortAscending: sortAscending ?? this.sortAscending,
      displayMode: displayMode ?? this.displayMode,
      itemsPerRow: itemsPerRow ?? this.itemsPerRow,
      badgeUnread: badgeUnread ?? this.badgeUnread,
      badgeDownloaded: badgeDownloaded ?? this.badgeDownloaded,
      badgeLanguage: badgeLanguage ?? this.badgeLanguage,
      badgeLocal: badgeLocal ?? this.badgeLocal,
      showTabCounts: showTabCounts ?? this.showTabCounts,
      cardTitle: cardTitle ?? this.cardTitle,
      cardBadges: cardBadges ?? this.cardBadges,
      cardProgress: cardProgress ?? this.cardProgress,
      hideEmptyCategories: hideEmptyCategories ?? this.hideEmptyCategories,
    );
  }

  // ── persistence ───────────────────────────────────────────────────────────
  // Tri-state filters persist as an int (LibraryFilterState.index). New keys so
  // they never collide with the pre-tri-state bool values still under the old
  // keys — those are migrated once on load.
  static const _kFilterUnread = 'lib_filter_unread_s';
  static const _kFilterCompleted = 'lib_filter_completed_s';
  static const _kFilterDownloaded = 'lib_filter_downloaded_s';
  static const _kFilterUnreadOld = 'lib_filter_unread';
  static const _kFilterCompletedOld = 'lib_filter_completed';
  static const _kFilterDownloadedOld = 'lib_filter_downloaded';
  static const _kFilterSources = 'lib_filter_sources';
  static const _kSort = 'lib_sort';
  static const _kSortAsc = 'lib_sort_asc';
  static const _kDisplayMode = 'lib_display_mode';
  static const _kItemsPerRow = 'lib_items_per_row';
  static const _kBadgeUnread = 'lib_badge_unread';
  static const _kBadgeDownloaded = 'lib_badge_downloaded';
  static const _kBadgeLanguage = 'lib_badge_language';
  static const _kBadgeLocal = 'lib_badge_local';
  static const _kTabCounts = 'lib_tab_counts';
  static const _kCardTitle = 'lib_card_title';
  static const _kCardBadges = 'lib_card_badges';
  static const _kCardProgress = 'lib_card_progress';

  static Future<LibrarySettings> load() async {
    final p = SettingsStore.instance;
    T byName<T extends Enum>(List<T> values, String? name, T fallback) =>
        values.firstWhere((v) => v.name == name, orElse: () => fallback);

    LibraryFilterState triState(String key, String oldKey) {
      final i = p.getInt(key);
      if (i != null) {
        return LibraryFilterState
            .values[i.clamp(0, LibraryFilterState.values.length - 1)];
      }
      // Migrate a pre-tri-state bool: true → include, false/absent → off.
      return (p.getBool(oldKey) ?? false)
          ? LibraryFilterState.include
          : LibraryFilterState.off;
    }

    return LibrarySettings(
      filterUnread: triState(_kFilterUnread, _kFilterUnreadOld),
      filterCompleted: triState(_kFilterCompleted, _kFilterCompletedOld),
      filterDownloaded: triState(_kFilterDownloaded, _kFilterDownloadedOld),
      filterSourceIds: (p.getStringList(_kFilterSources) ?? const []).toSet(),
      sort: byName(LibrarySort.values, p.getString(_kSort), LibrarySort.alphabetical),
      sortAscending: p.getBool(_kSortAsc) ?? true,
      displayMode: byName(LibraryDisplayMode.values, p.getString(_kDisplayMode),
          LibraryDisplayMode.grid),
      itemsPerRow: (p.getInt(_kItemsPerRow) ?? 3).clamp(2, 6),
      badgeUnread: p.getBool(_kBadgeUnread) ?? true,
      badgeDownloaded: p.getBool(_kBadgeDownloaded) ?? true,
      badgeLanguage: p.getBool(_kBadgeLanguage) ?? false,
      badgeLocal: p.getBool(_kBadgeLocal) ?? false,
      showTabCounts: p.getBool(_kTabCounts) ?? false,
      cardTitle: byName(LibraryCardTitle.values, p.getString(_kCardTitle),
          LibraryCardTitle.onCover),
      cardBadges: byName(LibraryCardBadges.values, p.getString(_kCardBadges),
          LibraryCardBadges.barUnder),
      cardProgress: byName(LibraryCardProgress.values,
          p.getString(_kCardProgress), LibraryCardProgress.percent),
      hideEmptyCategories: p.getBool('lib_hide_empty_cats') ?? false,
    );
  }

  Future<void> save() async {
    final p = SettingsStore.instance;
    await p.setInt(_kFilterUnread, filterUnread.index);
    await p.setInt(_kFilterCompleted, filterCompleted.index);
    await p.setInt(_kFilterDownloaded, filterDownloaded.index);
    await p.setStringList(_kFilterSources, filterSourceIds.toList());
    await p.setString(_kSort, sort.name);
    await p.setBool(_kSortAsc, sortAscending);
    await p.setString(_kDisplayMode, displayMode.name);
    await p.setInt(_kItemsPerRow, itemsPerRow);
    await p.setBool(_kBadgeUnread, badgeUnread);
    await p.setBool(_kBadgeDownloaded, badgeDownloaded);
    await p.setBool(_kBadgeLanguage, badgeLanguage);
    await p.setBool(_kBadgeLocal, badgeLocal);
    await p.setBool(_kTabCounts, showTabCounts);
    await p.setString(_kCardTitle, cardTitle.name);
    await p.setString(_kCardBadges, cardBadges.name);
    await p.setString(_kCardProgress, cardProgress.name);
  }

  /// Clears every stored preference so the next [load] returns the defaults.
  static Future<void> resetToDefaults() async {
    final p = SettingsStore.instance;
    for (final k in const [
      _kFilterUnread, _kFilterCompleted, _kFilterDownloaded,
      _kFilterUnreadOld, _kFilterCompletedOld, _kFilterDownloadedOld,
      _kFilterSources, _kSort, _kSortAsc, _kDisplayMode, _kItemsPerRow,
      _kBadgeUnread, _kBadgeDownloaded, _kBadgeLanguage, _kBadgeLocal,
      _kTabCounts, _kCardTitle, _kCardBadges, _kCardProgress,
    ]) {
      await p.remove(k);
    }
  }
}
