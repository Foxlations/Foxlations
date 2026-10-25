import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../core/app_nav.dart';
import '../../core/models/manga_model.dart';
import '../../core/models/chapter_model.dart';
import '../widgets/manga_image.dart';
import '../../core/providers/library_provider.dart';
import '../../core/providers/vault_provider.dart';
import '../../core/services/settings_store.dart';
import '../../core/services/app_logger.dart';
import '../../core/providers/source_provider.dart';
import '../../core/providers/library_type_provider.dart';
import '../../core/providers/incognito_provider.dart';
import '../../core/providers/download_provider.dart';
import '../../core/services/library_update_service.dart';
import '../../core/models/library_settings.dart';
import '../../core/utils/library_query.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../widgets/ds/ds.dart';
import '../../theme/app_tokens.dart';
import '../manga_detail_screen/migrate_screen.dart';
import '../widgets/update_prompt.dart';
import './widgets/library_options_sheet.dart';
import './widgets/library_stats_widget.dart';
import '../../l10n/app_localizations.dart';

/// SharedPreferences key for the persisted set of `${sourceId}::${mangaUrl}`
/// strings the user has bookmarked at the manga level. Read by reader_screen
/// to honor the "Include Bookmarked Chapters" download setting.
const String kBookmarkedMangaIdsKey = 'bookmarked_manga_ids';

// Safely extract origin from a URL, returning null for relative paths.
String? _originOf(String? url) {
  if (url == null) return null;
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return null;
  try { return uri.origin; } catch (_) { return null; }
}

// ── Reading Status ────────────────────────────────────────────
enum MangaReadingStatus { all, reading, completed, onHold, dropped, planToRead }

/// State of the drop-down library-update banner: progress while [done] is
/// false, then the run [result] summary.
class _UpdateBanner {
  final bool done;
  final int checked;
  final int total;
  final String? title;
  final LibraryUpdateResult? result;
  const _UpdateBanner({
    required this.done,
    this.checked = 0,
    this.total = 0,
    this.title,
    this.result,
  });
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin, RouteAware {
  bool _isSearchActive = false;
  String _searchQuery = '';
  /// Derived from the Display tab so the sheet and the toolbar toggle can't
  /// disagree - previously this was independent state, which meant choosing a
  /// display mode in the sheet had no effect on what was actually rendered.
  bool get _isGridView =>
      _librarySettings.displayMode == LibraryDisplayMode.grid;
  bool _showStats = false;
  bool _showBookmarksOnly = false;
  final Set<String> _bookmarkedIds = {};
  String? _selectedCategory; // null = "All"
  int _swipeDir = 1; // last category-swipe direction, for the slide animation
  bool _isRefreshing = false;
  // Live "checked / total" during a library update - a ValueNotifier so only the
  // small header indicator rebuilds, not the whole screen, on every tick.
  final ValueNotifier<(int checked, int total)?> _updateProgress =
      ValueNotifier(null);
  // The drop-down update banner: progress while updating, then the summary
  // (tap → Retry failed / Update skipped). Auto-hides after a short delay.
  final ValueNotifier<_UpdateBanner?> _updateBanner = ValueNotifier(null);
  Timer? _bannerHideTimer;
  LibrarySettings _librarySettings = const LibrarySettings();

  // Multi-select mode
  bool _isSelectMode = false;
  final Set<String> _selectedMangaIds = {};

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // ── Filtered-list memoization ──────────────────────────────────────────────
  // _activeManga (type filter) and _applyFilters (category/bookmark/search +
  // applyLibraryQuery sort) are each called several times per build AND re-run on
  // every rebuild - provider ping, search keystroke, options-sheet slider tick.
  // Cache the last result keyed on its inputs; the providers' dataVersion bumps
  // on any data change (over-bump = safe recompute), so the cache can't go stale.
  List<LibraryManga>? _memoActive;
  Object? _memoActiveKey;
  List<LibraryManga>? _memoFiltered;
  Object? _memoFilteredKey;

  bool get _isVaultMode => context.watch<VaultProvider>().vaultActive;

  // Helpers to get data from the active provider (vault or normal)
  List<LibraryManga> _activeManga(BuildContext context) {
    final vault = context.read<VaultProvider>();
    final vaultActive = vault.vaultActive;
    final all = vaultActive
        ? vault.manga
        : context.read<LibraryProvider>().manga;
    // Filter to the content type chosen from the Library tab's long-press menu.
    // 'all' shows everything (the default); otherwise keep only entries whose
    // content type matches. Prefer the entry's stored contentType (stamped at
    // add-time) so a novel/anime whose source is gone still classifies correctly;
    // fall back to the source's itemType, then 'manga', so nothing silently vanishes.
    final type = context.read<LibraryTypeProvider>().type;
    // The type filter depends only on the source list identity + the chosen type
    // (chapter changes don't affect it), so no dataVersion in this key.
    final key = Object.hash(identityHashCode(all), vaultActive, type);
    if (key == _memoActiveKey && _memoActive != null) return _memoActive!;
    final List<LibraryManga> result;
    if (type == 'all') {
      result = all;
    } else {
      final sp = context.read<SourceProvider>();
      result = all.where((m) {
        // O(1) itemType lookup (cached map) instead of a per-item source scan.
        final t = m.contentTypeOr(sp.installedItemType(m.sourceId));
        return t == type;
      }).toList();
    }
    _memoActiveKey = key;
    _memoActive = result;
    return result;
  }

  List<String> _activeCategoryNames(BuildContext context) {
    final vault = context.read<VaultProvider>();
    final cats = vault.vaultActive ? vault.categories : context.read<LibraryProvider>().categories;
    return cats.map((c) => c.name).toList();
  }

  /// The category tabs actually on screen, in tab order - mirrors what the
  /// tab strip shows (vault vs normal, and the "Hide empty categories"
  /// setting). Used by both the tab strip and the swipe-between-categories
  /// gesture so they can't disagree about what "next"/"previous" means.
  List<String> _visibleCategories(BuildContext context) {
    final vault = context.read<VaultProvider>();
    var cats = vault.vaultActive
        ? vault.categories.map((c) => c.name).toList()
        : context.read<LibraryProvider>().categories.map((c) => c.name).toList();
    if (_librarySettings.hideEmptyCategories) {
      final used = <String>{
        for (final m in _activeManga(context)) ...m.categories,
      };
      cats = cats.where(used.contains).toList();
    }
    return cats;
  }

  /// Move to the adjacent category on a horizontal swipe. [dir] is +1 for the
  /// next category (swipe left) and -1 for the previous (swipe right). Clamps
  /// at the ends (no wrap). A bookmarks-only view counts as sitting just before
  /// the first category, so swiping left from it lands on the first tab.
  void _swipeCategory(int dir) {
    final cats = _visibleCategories(context);
    if (cats.isEmpty) return;
    final idx = _showBookmarksOnly
        ? -1
        : (_selectedCategory == null ? -1 : cats.indexOf(_selectedCategory!));
    final next = idx + dir;
    if (next < 0 || next >= cats.length) return;
    setState(() {
      _swipeDir = dir;
      _selectedCategory = cats[next];
      _showBookmarksOnly = false;
    });
  }

  Future<void> _checkForUpdates() => _refreshLibrary();

  /// [scoped] limits the check to the entries currently on screen (the selected
  /// category), which is what "Category Update" means.
  Future<void> _refreshLibrary(
      {bool scoped = false,
      List<LibraryManga>? only,
      bool ignoreSkipRules = false}) async {
    if (_isRefreshing) return;
    final subset = only ??
        (scoped
            ? _activeManga(context)
                .where((m) =>
                    _selectedCategory == null ||
                    m.categories.contains(_selectedCategory))
                .toList()
            : null);
    setState(() => _isRefreshing = true);
    _updateProgress.value = null;
    _bannerHideTimer?.cancel();
    _updateBanner.value = const _UpdateBanner(done: false);
    // A (re)load of the library is a good moment to reconcile the downloaded
    // index with disk (covers pull-to-refresh and the "Check for updates" tap).
    _refreshDownloadedIndex();
    final libraryProvider = context.read<LibraryProvider>();
    final sourceProvider = context.read<SourceProvider>();
    final result = await LibraryUpdateService.checkForUpdates(
      libraryProvider: libraryProvider,
      sourceProvider: sourceProvider,
      only: subset,
      ignoreSkipRules: ignoreSkipRules,
      downloadProvider: context.read<DownloadProvider>(),
      onProgress: (checked, total, title) {
        _updateProgress.value = (checked, total);
        _updateBanner.value = _UpdateBanner(
            done: false, checked: checked, total: total, title: title);
      },
    );
    _updateProgress.value = null;
    if (!mounted) return;
    setState(() => _isRefreshing = false);
    // Show the summary in the banner; auto-hide after a bit (tap keeps it).
    _updateBanner.value = _UpdateBanner(done: true, result: result);
    _bannerHideTimer?.cancel();
    _bannerHideTimer = Timer(const Duration(seconds: 12), () {
      if (mounted) _updateBanner.value = null;
    });
  }

  /// Tapping the summary banner opens this menu: retry the failed titles, or
  /// force-update the skipped ones (ongoing/hiatus only - completed won't gain
  /// chapters). No actions available → just the counts.
  void _openUpdateSummaryMenu(LibraryUpdateResult result) {
    _bannerHideTimer?.cancel(); // keep the banner while the menu is open
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final skippedUpdatable = result.skippedUpdatable;

    // New-chapter count per title, so the Completed category can show how many
    // chapters each title gained.
    final newChaptersByUrl = <String, int>{};
    for (final u in result.updates) {
      newChaptersByUrl[u.mangaUrl] = (newChaptersByUrl[u.mangaUrl] ?? 0) + 1;
    }

    void openDetail(LibraryManga m) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, AppRoutes.mangaDetail, arguments: {
        'isVault': context.read<VaultProvider>().vaultActive,
        'mangaUrl': m.url,
        'sourceId': m.sourceId,
        'title': m.title,
        'coverUrl': m.coverUrl,
      });
    }

    // Any retry/update closes the sheet; the banner then shows live progress.
    void retry(List<LibraryManga> titles, {bool ignoreSkipRules = false}) {
      if (titles.isEmpty) return;
      Navigator.of(context).pop();
      _refreshLibrary(only: titles, ignoreSkipRules: ignoreSkipRules);
    }

    String cap(String s) =>
        s.isEmpty ? t.libraryStatusUnknown : s[0].toUpperCase() + s.substring(1);

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetCtx).size.height * 0.8),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 2),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: cs.outline.withAlpha(77),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(t.libraryUpdateTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    t.libraryUpdateCounts(
                        result.completed, result.skipped, result.failed),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: cs.outline)),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  if (result.completed > 0)
                    _buildUpdateCategory(
                      cs: cs,
                      icon: Icons.check_circle_rounded,
                      color: cs.primary,
                      label: t.libraryCompleted,
                      titles: result.completedTitles,
                      subtitleFor: (m) {
                        final n = newChaptersByUrl[m.url] ?? 0;
                        return n > 0
                            ? t.libraryNewChaptersCount(n)
                            : t.libraryUpToDate;
                      },
                      onTapItem: openDetail,
                    ),
                  if (result.skipped > 0)
                    _buildUpdateCategory(
                      cs: cs,
                      icon: Icons.skip_next_rounded,
                      color: cs.tertiary,
                      label: t.librarySkipped,
                      titles: result.skippedTitles,
                      actionLabel: skippedUpdatable.isNotEmpty
                          ? t.libraryUpdateCount(skippedUpdatable.length)
                          : null,
                      onAction: skippedUpdatable.isNotEmpty
                          ? () => retry(skippedUpdatable, ignoreSkipRules: true)
                          : null,
                      subtitleFor: (m) => skippedUpdatable.contains(m)
                          ? t.libraryStatusTapUpdate(cap(m.status))
                          : t.libraryStatusNoNewChapters(cap(m.status)),
                      trailingFor: (m) => skippedUpdatable.contains(m)
                          ? IconButton(
                              icon: Icon(Icons.download_rounded,
                                  size: 20, color: cs.primary),
                              tooltip: t.libraryUpdateThisTitle,
                              onPressed: () =>
                                  retry([m], ignoreSkipRules: true))
                          : null,
                      onTapItem: openDetail,
                    ),
                  if (result.failed > 0)
                    _buildUpdateCategory(
                      cs: cs,
                      icon: Icons.error_outline_rounded,
                      color: cs.error,
                      label: t.libraryFailed,
                      titles: result.failedTitles,
                      actionLabel: t.libraryRetryAll,
                      onAction: () => retry(result.failedTitles),
                      subtitleFor: (m) => t.libraryUpdateFailedTapOpen,
                      trailingFor: (m) => IconButton(
                          icon: Icon(Icons.refresh_rounded,
                              size: 20, color: cs.primary),
                          tooltip: t.libraryRetryThisTitle,
                          onPressed: () => retry([m])),
                      onTapItem: openDetail,
                    ),
                  if (result.completed == 0 &&
                      result.skipped == 0 &&
                      result.failed == 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Text(t.libraryNoTitlesChecked,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: cs.outline)),
                    ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  /// One stacked, expandable category in the update-summary sheet: a header with
  /// the count + an optional whole-category action, expanding to the individual
  /// titles (each tappable to open, with an optional per-item action).
  Widget _buildUpdateCategory({
    required ColorScheme cs,
    required IconData icon,
    required Color color,
    required String label,
    required List<LibraryManga> titles,
    required String Function(LibraryManga) subtitleFor,
    required void Function(LibraryManga) onTapItem,
    bool initiallyExpanded = false,
    String? actionLabel,
    VoidCallback? onAction,
    Widget? Function(LibraryManga)? trailingFor,
  }) {
    final t = AppLocalizations.of(context);
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Row(children: [
        Expanded(
          child: Text(t.libraryCategoryWithCount(label, titles.length),
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8)),
            child: Text(actionLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700, color: color)),
          ),
      ]),
      children: titles.map((m) {
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(left: 36, right: 8),
          title: Text(m.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium),
          subtitle: Text(subtitleFor(m),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: cs.outline)),
          trailing: trailingFor?.call(m),
          onTap: () => onTapItem(m),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _loadLibrarySettings();

    // Throttled to once every 12 hours inside the service, and it swallows its
    // own failures - a missing network or an unreachable site must never block
    // the library from loading.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      UpdatePrompt.maybeShow(context);
      // Populate the downloaded-manga index once the first frame has the
      // library list available.
      _refreshDownloadedIndex();
    });
  }

  Future<void> _loadLibrarySettings() async {
    final s = await LibrarySettings.load();
    if (mounted) setState(() => _librarySettings = s);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) routeObserver.subscribe(this, route);
  }

  // Returning from Settings > Library (a pushed route) - re-read the display
  // preferences it may have changed, e.g. "Hide empty categories".
  @override
  void didPopNext() => _loadLibrarySettings();

  void _applyLibrarySettings(LibrarySettings next) {
    setState(() => _librarySettings = next);
    next.save();
  }

  void _openLibraryOptions() {
    LibraryOptionsSheet.show(
      context,
      settings: _librarySettings,
      sources: _librarySources(context),
      onChanged: _applyLibrarySettings,
    );
  }

  /// The "More" menu: update scopes plus the entry-level actions.
  Future<void> _openMoreMenu() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final inCategory = _selectedCategory != null;
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            for (final item in [
              if (inCategory)
                (
                  'category',
                  Icons.refresh_rounded,
                  t.libraryCategoryUpdate,
                  t.libraryCategoryUpdateDesc(_selectedCategory ?? '')
                ),
              (
                'global',
                Icons.public_rounded,
                t.libraryGlobalUpdate,
                t.libraryGlobalUpdateDesc
              ),
              (
                'summary',
                Icons.info_outline_rounded,
                t.libraryUpdatesSummary,
                t.libraryUpdatesSummaryDesc
              ),
              ('select', Icons.check_circle_outline_rounded, t.librarySelect, ''),
              ('random', Icons.shuffle_rounded, t.libraryOpenRandomEntry, ''),
            ])
              ListTile(
                leading: Icon(item.$2, color: cs.primary, size: 22),
                title: Text(item.$3,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface)),
                subtitle: item.$4.isEmpty
                    ? null
                    : Text(item.$4,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.outline)),
                onTap: () => Navigator.pop(ctx, item.$1),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (!mounted || choice == null) return;

    switch (choice) {
      case 'category':
      case 'global':
        // Category Update reuses the same checker, scoped to what's on screen;
        // Global ignores the category filter and checks the whole library.
        await _refreshLibrary(
          scoped: choice == 'category',
        );
        break;
      case 'summary':
        await _showUpdatesSummary();
        break;
      case 'select':
        setState(() => _isSelectMode = true);
        break;
      case 'random':
        final list = _applyFilters(_activeManga(context));
        if (list.isEmpty) {
          AppTheme.showSnackBar(context, t.libraryEmpty);
          break;
        }
        final pick = list[DateTime.now().microsecond % list.length];
        Navigator.pushNamed(context, AppRoutes.mangaDetail, arguments: {
          'isVault': context.read<VaultProvider>().vaultActive,
          'mangaUrl': pick.url,
          'sourceId': pick.sourceId,
          'title': pick.title,
          'coverUrl': pick.coverUrl,
        });
        break;
    }
  }

  Future<void> _showUpdatesSummary() async {
    final updates = await LibraryUpdateService.loadUpdates();
    final last = await LibraryUpdateService.getLastUpdate();
    if (!mounted) return;
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final when = last == null
        ? t.libraryNever
        : DateFormat('yyyy-MM-dd HH:mm').format(last);
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cs.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        title: Text(t.libraryUpdatesSummary,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.libraryLastChecked(when),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.outline)),
            const SizedBox(height: 8),
            Text(
              updates.isEmpty
                  ? t.libraryNoNewChaptersLastCheck
                  : t.libraryEntriesWithNewChapters(updates.length),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: cs.onSurface),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.libraryClose),
          ),
        ],
      ),
    );
  }

  /// Sources present in the library, for the Filter tab's Sources list.
  List<({String id, String name})> _librarySources(BuildContext context) {
    final installed = context.read<SourceProvider>().installedSources;
    final ids = _activeManga(context).map((m) => m.sourceId).toSet();
    final named = <String, String>{};
    for (final id in ids) {
      final match = installed.where((s) => s.source.id == id);
      named[id] = match.isNotEmpty ? match.first.source.name : id;
    }
    final entries = named.entries
        .map((e) => (id: e.key, name: e.value))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return entries;
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(kBookmarkedMangaIdsKey) ?? [];
    if (mounted) {
      setState(() {
        _bookmarkedIds
          ..clear()
          ..addAll(ids);
      });
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchController.dispose();
    _searchFocus.dispose();
    _updateProgress.dispose();
    _bannerHideTimer?.cancel();
    _updateBanner.dispose();
    super.dispose();
  }

  List<LibraryManga> _applyFilters(List<LibraryManga> manga) {
    // The "Downloaded" filter needs the manga-level download index, which lives
    // in DownloadProvider (download state is tracked outside the manga model).
    final dl = context.read<DownloadProvider>();
    final dlKeys = dl.downloadedMangaKeys;
    final s = _librarySettings;
    // Memo key = everything the result depends on. Both providers' dataVersion
    // cover in-place data changes; downloadedCount tracks the download index
    // (downloadedMangaKeys allocates a fresh wrapper each call, so it can't be
    // keyed by identity). A pure display change (items-per-row, badge toggles)
    // leaves every component unchanged → cache hit, no re-filter/re-sort.
    final key = Object.hash(
      identityHashCode(manga),
      context.read<LibraryProvider>().dataVersion,
      context.read<VaultProvider>().dataVersion,
      _selectedCategory,
      _showBookmarksOnly,
      identityHashCode(_bookmarkedIds),
      _searchQuery,
      s.filterUnread,
      s.filterCompleted,
      s.filterDownloaded,
      identityHashCode(s.filterSourceIds),
      s.sort,
      s.sortAscending,
      dl.downloadedCount,
    );
    if (key == _memoFilteredKey && _memoFiltered != null) return _memoFiltered!;

    var list = manga;
    if (_selectedCategory != null) {
      list = list.where((m) => m.categories.contains(_selectedCategory)).toList();
    }
    if (_showBookmarksOnly) {
      String k(LibraryManga m) => '${m.sourceId}::${m.url}';
      list = list.where((m) => _bookmarkedIds.contains(k(m))).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((m) => m.title.toLowerCase().contains(q)).toList();
    }
    final result = applyLibraryQuery(list, s, downloadedKeys: dlKeys);
    _memoFilteredKey = key;
    _memoFiltered = result;
    return result;
  }

  /// Rescan disk for which library entries have downloaded chapters so the
  /// "Downloaded" filter and the downloaded badge reflect reality. Kept off the
  /// hot rebuild path - called from initState and library (re)loads, never from
  /// build().
  void _refreshDownloadedIndex() {
    if (!mounted) return;
    // Scan the WHOLE library - every content type, plus the vault - not just the
    // active tab. The index is clear()..addAll()'d on each rebuild, so feeding it
    // only the current tab's entries would drop downloaded titles of other types
    // and the "Downloaded" filter would wrongly hide them.
    final all = <LibraryManga>[
      ...context.read<LibraryProvider>().manga,
      ...context.read<VaultProvider>().manga,
    ];
    final seen = <String>{};
    final entries = <({String sourceId, String url, String title})>[];
    for (final m in all) {
      if (seen.add('${m.sourceId}::${m.url}')) {
        entries.add((sourceId: m.sourceId, url: m.url, title: m.title));
      }
    }
    context.read<DownloadProvider>().refreshDownloadedMangaIndex(entries);
  }

  void _onSearchToggle() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchQuery = '';
        _searchController.clear();
      } else {
        Future.delayed(const Duration(milliseconds: 150), () {
          _searchFocus.requestFocus();
        });
      }
    });
  }

  String _mangaKey(LibraryManga m) => '${m.sourceId}::${m.url}';

  // Multi-select helpers
  void _enterSelectMode(LibraryManga manga) {
    setState(() {
      _isSelectMode = true;
      _selectedMangaIds.add(_mangaKey(manga));
    });
  }

  void _exitSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedMangaIds.clear();
    });
  }

  void _toggleSelect(LibraryManga manga) {
    final key = _mangaKey(manga);
    setState(() {
      if (_selectedMangaIds.contains(key)) {
        _selectedMangaIds.remove(key);
        if (_selectedMangaIds.isEmpty) _isSelectMode = false;
      } else {
        _selectedMangaIds.add(key);
      }
    });
  }

  void _selectAll(List<LibraryManga> manga) {
    setState(() {
      _selectedMangaIds.addAll(manga.map(_mangaKey));
    });
  }

  void _deselectAll() {
    setState(() => _selectedMangaIds.clear());
  }

  List<LibraryManga> _getSelectedManga() {
    final all = _activeManga(context);
    return all.where((m) => _selectedMangaIds.contains(_mangaKey(m))).toList();
  }

  /// Opt-in: whether the "Move to vault" batch action shows in the NORMAL library.
  /// Off by default so enabling it is a deliberate choice (it hints the vault exists).
  /// Always available while already inside the vault (to move items out).
  static const _showVaultMoveKey = 'vault_show_library_move';
  bool get _showLibraryVaultMove {
    final vault = context.read<VaultProvider>();
    if (vault.vaultActive) return true;
    return vault.vaultEnabled &&
        (SettingsStore.instance.getBool(_showVaultMoveKey) ?? false);
  }

  /// Move the selected titles into the vault (from the normal library) or out of
  /// it (while in vault mode), carrying their chapters/progress.
  Future<void> _batchVaultMove() async {
    final t = AppLocalizations.of(context);
    final items = _getSelectedManga();
    if (items.isEmpty) return;
    final lib = context.read<LibraryProvider>();
    final vault = context.read<VaultProvider>();
    final toVault = !vault.vaultActive;
    // Moving INTO the vault writes to its encrypted boxes, which are only open
    // while unlocked. If they're closed the write silently no-ops - and we'd
    // still delete the originals below, losing the titles. Refuse unless the
    // vault is unlocked. (Moving OUT only happens from inside the vault, which
    // already requires it to be open.)
    if (toVault && !vault.isUnlocked) {
      AppTheme.showSnackBar(context, t.libraryUnlockVaultFirst);
      return;
    }
    // Gather first, then move the whole batch in one provider call so the
    // library reloads/notifies once (not once per title).
    final toAdd = <(LibraryManga, List<LibraryChapter>)>[];
    final keys = <(String, String)>[];
    for (final m in items) {
      final ch = toVault
          ? lib.fullChapters(m.sourceId, m.url)
          : vault.fullChapters(m.sourceId, m.url);
      toAdd.add((m, ch));
      keys.add((m.sourceId, m.url));
    }
    var ok = 0;
    try {
      if (toVault) {
        await vault.addEntriesWithChaptersBulk(toAdd);
        await lib.removeMangaBulk(keys);
      } else {
        await lib.addEntriesWithChaptersBulk(toAdd);
        await vault.removeMangaBulk(keys);
      }
      ok = items.length;
    } catch (e) {
      logger.error('Vault move failed (toVault=$toVault)',
          category: LogCategory.library, detail: '$e');
    }
    if (!mounted) return;
    _exitSelectMode();
    AppTheme.showSnackBar(
        context,
        ok == 0
            ? (toVault
                ? t.libraryCouldNotMoveToVault
                : t.libraryCouldNotMoveOutOfVault)
            : (toVault
                ? t.libraryMovedToVault(ok)
                : t.libraryMovedOutOfVault(ok)));
  }

  // Vault-aware provider helpers
  void _doSetCategoriesBulk(List<(String, String, List<String>)> items) {
    final vault = context.read<VaultProvider>();
    if (vault.vaultActive) {
      vault.setMangaCategoriesBulk(items);
    } else {
      context.read<LibraryProvider>().setMangaCategoriesBulk(items);
    }
  }

  void _showMoveCategorySheet(List<LibraryManga> mangaList) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final catNames = _activeCategoryNames(context);
    if (catNames.isEmpty) return;

    // Start with intersection of all selected manga's categories
    final commonCats = mangaList.first.categories.toSet();
    for (final m in mangaList.skip(1)) {
      commonCats.retainAll(m.categories);
    }
    final selected = Set<String>.from(commonCats);

    showModalBottomSheet(
      context: context,
      // Grow past the half-screen cap and bound the height so a long category
      // list scrolls while Save stays reachable.
      isScrollControlled: true,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 36, height: 4,
                      decoration: BoxDecoration(color: cs.outline, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Text(t.libraryMoveToCategory,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: cs.onSurface)),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        ...catNames.map((cat) {
                          final isIn = selected.contains(cat);
                          return InkWell(
                            onTap: () => setSheetState(() {
                              if (isIn) { selected.remove(cat); } else { selected.add(cat); }
                            }),
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                              child: Row(children: [
                                Icon(isIn ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                    size: 20, color: isIn ? cs.primary : cs.outline),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(cat, style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600, color: cs.onSurface)),
                                ),
                              ]),
                            ),
                          );
                        }),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        final cats = selected.toList();
                        _doSetCategoriesBulk(
                            [for (final m in mangaList) (m.sourceId, m.url, cats)]);
                        if (_isSelectMode) _exitSelectMode();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary, foregroundColor: cs.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(t.librarySave, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: cs.onPrimary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Batch actions for multi-select. Each hands the whole selection to the active
  // provider in one bulk call, so the library reloads/notifies once (not per item).
  List<(String, String)> _selectedKeys() =>
      [for (final m in _getSelectedManga()) (m.sourceId, m.url)];

  void _batchMarkRead() {
    final keys = _selectedKeys();
    final vault = context.read<VaultProvider>();
    if (vault.vaultActive) {
      vault.markAllReadBulk(keys);
    } else {
      context.read<LibraryProvider>().markAllReadBulk(keys);
    }
    _exitSelectMode();
  }

  void _batchMarkUnread() {
    final keys = _selectedKeys();
    final vault = context.read<VaultProvider>();
    if (vault.vaultActive) {
      vault.markAllUnreadBulk(keys);
    } else {
      context.read<LibraryProvider>().markAllUnreadBulk(keys);
    }
    _exitSelectMode();
  }

  void _batchRemove() {
    final keys = _selectedKeys();
    final vault = context.read<VaultProvider>();
    if (vault.vaultActive) {
      vault.removeMangaBulk(keys);
    } else {
      context.read<LibraryProvider>().removeMangaBulk(keys);
    }
    _exitSelectMode();
  }

  void _batchMoveCategory() {
    _showMoveCategorySheet(_getSelectedManga());
  }

  /// Bulk migrate: send each selected entry to the single-entry migrate screen
  /// in turn.
  ///
  /// Deliberately sequential rather than "pick one target source and move
  /// everything". Titles differ between sources - punctuation, romanisation,
  /// season suffixes - so an automatic match would silently attach the wrong
  /// series. Stepping through lets each candidate be confirmed (and previewed
  /// with "Show entry") before anything is replaced.
  Future<void> _batchMigrate() async {
    final selected = _getSelectedManga();
    if (selected.isEmpty) return;
    _exitSelectMode();

    // Fresh queue - clear any prefetch cache left over from a previous batch.
    MigrateScreen.resetSearchCache();

    for (var i = 0; i < selected.length; i++) {
      if (!mounted) return;
      final m = selected[i];
      // MigrateScreen returns `true` when it finished an entry (migrate/copy)
      // and `null` when the user pressed Back - Back cancels the whole queue.
      final done = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => MigrateScreen(
            sourceId: m.sourceId,
            mangaUrl: m.url,
            mangaTitle: m.title,
            // Shown in the app bar so it's clear where you are in the queue.
            queuePosition: i + 1,
            queueTotal: selected.length,
            // Prefetch the next entry's search while this one is on screen, so
            // the following screen opens with results already loaded.
            nextQuery: i + 1 < selected.length ? selected[i + 1].title : null,
            nextSourceId:
                i + 1 < selected.length ? selected[i + 1].sourceId : null,
          ),
        ),
      );
      if (done != true) break; // backed out - stop the batch

      // A short loading buffer between entries so the hand-off from one migrate
      // screen to the next reads as a deliberate transition, not a flash.
      if (i + 1 < selected.length && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.pop(context); // dismiss the buffer
      }
    }
  }

  int get _totalUnread {
    final manga = _activeManga(context);
    final lib = context.read<LibraryProvider>();
    return manga.fold(0, (sum, m) => sum + lib.unreadForManga(m));
  }

  LibraryManga? get _lastReadManga {
    final manga = _activeManga(context);
    // Single O(N) pass for the most-recently-read entry - no full sort just to
    // pick one item (this runs on every library rebuild).
    LibraryManga? best;
    DateTime bestAt = DateTime(2000);
    for (final m in manga) {
      if (m.readChapters > 0 && m.lastReadChapterUrl != null) {
        final at = m.lastReadAt ?? DateTime(2000);
        if (best == null || at.isAfter(bestAt)) {
          best = m;
          bestAt = at;
        }
      }
    }
    return best;
  }

  /// Columns for the grid - whatever the user picked in "Items per row".
  ///
  /// This used to cap the count by screen width (4 on a phone, 5 at 600dp, 6 at
  /// 840dp) while the picker still offered up to 6. On a phone that silently
  /// swallowed the choice: selecting 5 or 6 changed the number on screen but
  /// never the grid. The setting is already bounded to 2..6 when it's stored,
  /// so honour it - a user asking for six small covers has asked for exactly
  /// that, and can step back down if they don't like it.
  int _getColumnCount(BuildContext context) {
    return _librarySettings.itemsPerRow.clamp(2, 6);
  }

  PreferredSizeWidget _buildSelectAppBar(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: cs.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: Colors.white),
        onPressed: _exitSelectMode,
      ),
      title: Text(t.librarySelectedCount(_selectedMangaIds.length),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.select_all_rounded, color: Colors.white),
          tooltip: t.librarySelectAll,
          onPressed: () {
            final filtered = _applyFilters(_activeManga(context));
            _selectAll(filtered);
          },
        ),
        if (_selectedMangaIds.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.deselect_rounded, color: Colors.white),
            tooltip: t.libraryDeselectAll,
            onPressed: _deselectAll,
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBatchBar(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    final catNames = _activeCategoryNames(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (catNames.isNotEmpty)
              _BatchButton(icon: Icons.drive_file_move_rounded, label: t.libraryBatchMove, onTap: _batchMoveCategory),
            _BatchButton(icon: Icons.done_all_rounded, label: t.libraryBatchRead, onTap: _batchMarkRead),
            _BatchButton(icon: Icons.remove_done_rounded, label: t.libraryBatchUnread, onTap: _batchMarkUnread),
            _BatchButton(icon: Icons.swap_horiz_rounded, label: t.libraryBatchMigrate, onTap: _batchMigrate),
            if (_showLibraryVaultMove)
              _BatchButton(
                  icon: _isVaultMode
                      ? Icons.lock_open_rounded
                      : Icons.lock_outline_rounded,
                  label: _isVaultMode ? t.libraryMoveOut : t.libraryToVault,
                  onTap: _batchVaultMove),
            _BatchButton(icon: Icons.delete_outline_rounded, label: t.libraryBatchRemove, onTap: _batchRemove),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final columnCount = _getColumnCount(context);
    final isVault = _isVaultMode;
    // Depend on the content type so switching Manga/Anime/Novels (from the
    // Library tab's long-press menu) rebuilds the whole screen and re-filters
    // every list below via _activeManga.
    final contentType = context.watch<LibraryTypeProvider>().type;
    // Rebuild when the downloaded-manga SET changes (a chapter finished), so the
    // "Downloaded" filter/badges stay in sync - but NOT on every per-image
    // progress tick (which a plain watch did, re-filtering the whole library
    // several times a second during downloads).
    context.select<DownloadProvider, int>((d) => d.downloadedCount);
    final addLabel = switch (contentType) {
      'anime' => t.libraryAddAnime,
      'novel' => t.libraryAddLNs,
      'all' => t.libraryAdd,
      _ => t.libraryAddManga,
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: _isSelectMode
            ? _buildSelectAppBar(cs)
            : _LibraryAppBar(
                isSearchActive: _isSearchActive,
                searchController: _searchController,
                searchFocus: _searchFocus,
                totalUnread: _totalUnread,
                isGridView: _isGridView,
                showStats: _showStats,
                isVaultMode: isVault,
                onSearchToggle: _onSearchToggle,
                onSearchChanged: (q) => setState(() => _searchQuery = q),
                onViewToggle: () => _applyLibrarySettings(
                      _librarySettings.copyWith(
                        displayMode: _isGridView
                            ? LibraryDisplayMode.list
                            : LibraryDisplayMode.grid,
                      ),
                    ),
                onStatsTap: () => setState(() => _showStats = !_showStats),
                onRefresh: _checkForUpdates,
                onOptionsTap: _openLibraryOptions,
                onMoreTap: _openMoreMenu,
                hasActiveFilter: _librarySettings.hasActiveFilter,
                isRefreshing: _isRefreshing,
                updateProgress: _updateProgress,
              ),
        body: SafeArea(
          child: _showStats
              ? const LibraryStatsWidget()
              : Column(
                  children: [
                    // Category tabs with bookmark toggle
                    Consumer2<LibraryProvider, VaultProvider>(
                      builder: (_, library, vault, _) {
                        // Type-filtered (via _visibleCategories) so a category
                        // counts as "empty" when it has no entries of the current
                        // library, and so the tabs match the swipe gesture's idea
                        // of order.
                        final cats = _visibleCategories(context);
                        // Auto-select first category if none selected, or if
                        // the current selection isn't valid in the active mode
                        // (e.g. after toggling vault, the previous mode's
                        // category names don't exist in the new list).
                        if (cats.isNotEmpty &&
                            (_selectedCategory == null ||
                                !cats.contains(_selectedCategory))) {
                          _selectedCategory = cats.first;
                        }
                        // Per-category entry counts for the "Show number of
                        // items" setting. Computed once here (off the chip
                        // build path) only when the setting is on.
                        final counts = <String, int>{};
                        if (_librarySettings.showTabCounts) {
                          // Single pass over the library instead of one full
                          // scan per category (was O(categories × entries)).
                          for (final m in _activeManga(context)) {
                            for (final c in m.categories) {
                              counts[c] = (counts[c] ?? 0) + 1;
                            }
                          }
                        }
                        return _CategoryTabs(
                          categories: cats,
                          selected: _selectedCategory,
                          onSelected: (cat) => setState(() {
                            // Turn the cube the right way when tapping a tab
                            // (swipes set _swipeDir in _swipeCategory).
                            int idxOf(String? c) =>
                                c == null ? -1 : cats.indexOf(c);
                            final from = _showBookmarksOnly
                                ? -1
                                : idxOf(_selectedCategory);
                            final to = idxOf(cat);
                            if (to != from) _swipeDir = to > from ? 1 : -1;
                            _selectedCategory = cat;
                            _showBookmarksOnly = false;
                          }),
                          showBookmarksOnly: _showBookmarksOnly,
                          bookmarkCount: _bookmarkedIds.length,
                          onBookmarkToggle: () => setState(
                              () => _showBookmarksOnly = !_showBookmarksOnly),
                          showTabCounts: _librarySettings.showTabCounts,
                          categoryCounts: counts,
                        );
                      },
                    ),
                    // Library-update progress / summary banner (drops down).
                    ValueListenableBuilder<_UpdateBanner?>(
                      valueListenable: _updateBanner,
                      builder: (_, banner, _) => AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        alignment: Alignment.topCenter,
                        child: banner == null
                            ? const SizedBox(width: double.infinity)
                            : _UpdateProgressBanner(
                                banner: banner,
                                onTapSummary: banner.result == null
                                    ? null
                                    : () => _openUpdateSummaryMenu(
                                        banner.result!),
                                onDismiss: () {
                                  _bannerHideTimer?.cancel();
                                  _updateBanner.value = null;
                                },
                              ),
                      ),
                    ),
                    // Continue reading banner
                    Consumer2<LibraryProvider, VaultProvider>(
                      builder: (_, library, vault, _) {
                        final lastRead = _lastReadManga;
                        // Only the "Banner" mode shows the top banner; the
                        // Resume-button and Off modes suppress it (the FAB
                        // carries resume instead).
                        if (lastRead == null ||
                            _librarySettings.continueMode !=
                                LibraryContinueMode.banner) {
                          return const SizedBox.shrink();
                        }
                        return _ContinueReadingBanner(
                          manga: lastRead,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.mangaDetail,
                            arguments: {
                              'isVault': context.read<VaultProvider>().vaultActive,
                              'mangaUrl': lastRead.url,
                              'sourceId': lastRead.sourceId,
                              'title': lastRead.title,
                              'coverUrl': lastRead.coverUrl,
                              'resume': true,
                            },
                          ),
                        );
                      },
                    ),
                    // Main content
                    Expanded(
                      child: Consumer2<LibraryProvider, VaultProvider>(
                        builder: (_, library, vault, _) {
                          // Route through _activeManga so the grid honours the
                          // current library type (All / Manga / Anime / LN).
                          final activeManga = _activeManga(context);
                          final filtered = _applyFilters(activeManga);

                          // Pull down anywhere to update the category the user
                          // is currently viewing (all entries when on "All").
                          Widget withPullToRefresh(Widget child) =>
                              RefreshIndicator(
                                onRefresh: () => _refreshLibrary(scoped: true),
                                child: child,
                              );

                          void onTap(LibraryManga m) {
                            if (_isSelectMode) {
                              _toggleSelect(m);
                            } else {
                              Navigator.pushNamed(context, AppRoutes.mangaDetail,
                                arguments: {
                                  'isVault': context.read<VaultProvider>().vaultActive,
                                  'mangaUrl': m.url,
                                  'sourceId': m.sourceId,
                                  'title': m.title,
                                  'coverUrl': m.coverUrl,
                                });
                            }
                          }
                          void onLong(LibraryManga m) {
                            if (_isSelectMode) {
                              _toggleSelect(m);
                            } else {
                              _enterSelectMode(m);
                            }
                          }

                          final Widget inner = filtered.isEmpty
                              ? ListView(
                                  // A plain Center can't be pulled; a
                                  // scrollable list can.
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.sizeOf(context)
                                              .height *
                                          0.6,
                                      child: _EmptyState(
                                        isSearching: _searchQuery.isNotEmpty,
                                        searchQuery: _searchQuery,
                                        isBookmarkFilter: _showBookmarksOnly,
                                      ),
                                    ),
                                  ],
                                )
                              : _isGridView
                                  ? _LibraryGrid(
                                      mangaList: filtered,
                                      columnCount: columnCount,
                                      selectedIds: _isSelectMode
                                          ? _selectedMangaIds
                                          : null,
                                      badgeUnread: _librarySettings.badgeUnread,
                                      badgeDownloaded:
                                          _librarySettings.badgeDownloaded,
                                      badgeLanguage:
                                          _librarySettings.badgeLanguage,
                                      badgeLocal: _librarySettings.badgeLocal,
                                      cardTitle: _librarySettings.cardTitle,
                                      cardBadges: _librarySettings.cardBadges,
                                      cardProgress:
                                          _librarySettings.cardProgress,
                                      onTap: onTap,
                                      onLongPress: onLong,
                                    )
                                  : _LibraryList(
                                      mangaList: filtered,
                                      selectedIds: _isSelectMode
                                          ? _selectedMangaIds
                                          : null,
                                      badgeUnread: _librarySettings.badgeUnread,
                                      badgeDownloaded:
                                          _librarySettings.badgeDownloaded,
                                      onTap: onTap,
                                      onLongPress: onLong,
                                    );

                          // Cube-rotate the grid/list when the category changes:
                          // the outgoing face turns away toward one side while the
                          // incoming face turns in from the other (a 3D cube).
                          // Keyed on the filter state so a real category change
                          // animates but a data refresh (same key) doesn't flicker.
                          // ClipRect keeps the turning faces inside the content box.
                          final animated = ClipRect(
                            // ONE shared perspective for both faces, so the cube
                            // turns as a single rigid object instead of two faces
                            // spinning from separate vanishing points (which read
                            // as "one goes, then the other").
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.0016),
                              child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 460),
                              switchInCurve: Curves.easeInOutCubic,
                              switchOutCurve: Curves.easeInOutCubic,
                              transitionBuilder: (child, animation) =>
                                  LayoutBuilder(
                                builder: (context, constraints) {
                                  final w = constraints.maxWidth;
                                  return AnimatedBuilder(
                                    animation: animation,
                                    builder: (context, _) {
                                      final dir = _swipeDir.toDouble();
                                      final leaving = animation.status ==
                                              AnimationStatus.reverse ||
                                          animation.status ==
                                              AnimationStatus.dismissed;
                                      final v = animation.value; // 0..1
                                      final away =
                                          1 - v; // 1 = edge-on, 0 = centered
                                      // Entering rides in on the +dir face of the
                                      // cube; leaving turns away on the -dir face.
                                      final sign = leaving ? -dir : dir;
                                      // No perspective here - it's on the shared
                                      // parent so both faces project from one
                                      // vanishing point and turn as one cube. Each
                                      // face slides to the side and turns; the
                                      // negative rotateY makes the corner point
                                      // TOWARD the viewer (convex / "outside").
                                      final m = Matrix4.identity()
                                        ..multiply(Matrix4.translationValues(
                                            sign * 0.5 * w * away, 0, 0))
                                        ..rotateY(-sign * 1.40 * away); // ~80°
                                      return Opacity(
                                        opacity: (0.5 + 0.5 * v).clamp(0.0, 1.0),
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: m,
                                          child: child,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              child: KeyedSubtree(
                                key: ValueKey(
                                    '${_selectedCategory ?? '_all'}|$_showBookmarksOnly|$_isGridView'),
                                child: inner,
                              ),
                            ),
                            ),
                          );

                          // Horizontal fling anywhere in the content area moves
                          // to the adjacent category (vertical scroll + taps
                          // still pass through to the grid).
                          return GestureDetector(
                            onHorizontalDragEnd: (d) {
                              final v = d.primaryVelocity ?? 0;
                              if (v <= -250) {
                                _swipeCategory(1);
                              } else if (v >= 250) {
                                _swipeCategory(-1);
                              }
                            },
                            child: withPullToRefresh(animated),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: _isSelectMode ? _buildBatchBar(cs) : null,
        floatingActionButton: !_showStats && !_isSelectMode
            // Wrapped so the Resume-mode FAB re-targets when the most-recently
            // read entry changes (build() itself only reads the library).
            ? Consumer2<LibraryProvider, VaultProvider>(
                builder: (_, _, _, _) =>
                    _buildLibraryFab(context, cs, addLabel),
              )
            : null,
      ),
    );
  }

  /// The library home FAB. Normally the "+ Add" button (jumps to Browse). In
  /// Resume-button mode, when there's a most-recently-read entry, it becomes a
  /// Resume FAB that reopens that entry at its saved spot; with nothing read
  /// yet it falls back to the + Add button so the corner is never dead.
  Widget _buildLibraryFab(BuildContext context, ColorScheme cs, String addLabel) {
    final t = AppLocalizations.of(context);
    final resumeMode =
        _librarySettings.continueMode == LibraryContinueMode.resumeButton;
    final lastRead = resumeMode ? _lastReadManga : null;

    final IconData icon;
    final String label;
    final VoidCallback onPressed;
    if (lastRead != null) {
      icon = Icons.play_arrow_rounded;
      label = t.detailResume;
      onPressed = () => Navigator.pushNamed(
            context,
            AppRoutes.mangaDetail,
            arguments: {
              'isVault': context.read<VaultProvider>().vaultActive,
              'mangaUrl': lastRead.url,
              'sourceId': lastRead.sourceId,
              'title': lastRead.title,
              'coverUrl': lastRead.coverUrl,
              'resume': true,
            },
          );
    } else {
      icon = Icons.add_rounded;
      label = addLabel;
      // Switch to the Browse TAB (keeps the bottom nav bar) rather than pushing
      // Browse as a full-screen route over the shell, which hid the nav bar and
      // left the user stuck.
      onPressed = () => navTabRequest.value = 'browse';
    }

    return FloatingActionButton.extended(
      heroTag: 'library_fab',
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700, color: cs.onPrimary)),
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────
class _LibraryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchActive;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final int totalUnread;
  final bool isGridView;
  final bool showStats;
  final bool isVaultMode;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onViewToggle;
  final VoidCallback onStatsTap;
  final VoidCallback? onRefresh;
  final bool isRefreshing;
  final ValueNotifier<(int checked, int total)?>? updateProgress;
  final VoidCallback onOptionsTap;
  final VoidCallback onMoreTap;
  final bool hasActiveFilter;

  const _LibraryAppBar({
    required this.isSearchActive,
    required this.searchController,
    required this.searchFocus,
    required this.totalUnread,
    required this.isGridView,
    required this.showStats,
    this.isVaultMode = false,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onViewToggle,
    required this.onStatsTap,
    required this.onOptionsTap,
    required this.onMoreTap,
    this.hasActiveFilter = false,
    this.onRefresh,
    this.isRefreshing = false,
    this.updateProgress,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    // The stats view ignores the search query (it reads the providers directly
    // and has its own content-type toggle), so never show the search field while
    // stats are up - the header then carries just the title + the back toggle.
    final effectiveSearch = isSearchActive && !showStats;
    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      scrolledUnderElevation: 2,
      automaticallyImplyLeading: false,
      title: AnimatedSwitcher(
        duration: AppTheme.standard,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation, curve: AppTheme.primaryCurve)),
            child: child,
          ),
        ),
        child: effectiveSearch
            ? _SearchField(
                key: const ValueKey('search'),
                controller: searchController,
                focusNode: searchFocus,
                onChanged: onSearchChanged)
            : _TitleRow(
                key: const ValueKey('title'), totalUnread: totalUnread, isVaultMode: isVaultMode),
      ),
      actions: [
        // Persistent reminder that incognito mode is on (no history / tracker
        // updates while reading). Shown in every app-bar state, search included.
        if (context.watch<IncognitoProvider>().enabled)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Tooltip(
              message: t.libraryIncognitoActive,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: oledIconChip(context,
                    color: AppTheme.warning,
                    fill: AppTheme.warning.withAlpha(30),
                    radius: AppTheme.radiusFull),
                child: const Icon(Icons.visibility_off_outlined,
                    size: 16, color: AppTheme.warning),
              ),
            ),
          ),
        if (!effectiveSearch) ...[
          if (!showStats)
            _AppBarAction(
              icon: Icons.search_rounded,
              onTap: onSearchToggle,
              tooltip: t.librarySearchLibrary,
            ),
          // Refresh is always the plain action - the drop-down "Updating…"
          // banner is the sole progress indicator (no redundant header spinner).
          // _refreshLibrary no-ops while a run is already in flight.
          if (!showStats && onRefresh != null)
            _AppBarAction(
              icon: Icons.refresh_rounded,
              onTap: onRefresh!,
              tooltip: t.libraryCheckForUpdates,
            ),
          // Filter / Sort / Display. Dot marks that a filter is narrowing the
          // list, so a "missing" entry is never a mystery.
          if (!showStats)
            Stack(
              alignment: Alignment.center,
              children: [
                _AppBarAction(
                  icon: Icons.filter_list_rounded,
                  onTap: onOptionsTap,
                  tooltip: t.libraryFilterSortDisplay,
                ),
                if (hasActiveFilter)
                  Positioned(
                    top: 12,
                    right: 10,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          _AppBarAction(
            icon: showStats
                ? Icons.collections_bookmark_outlined
                : Icons.bar_chart_rounded,
            onTap: onStatsTap,
            tooltip: showStats ? t.libraryLibrary : t.libraryStats,
          ),
          if (!showStats)
            _AppBarAction(
              icon: Icons.more_vert_rounded,
              onTap: onMoreTap,
              tooltip: t.libraryMore,
            ),
        ] else
          _AppBarAction(
            icon: Icons.close_rounded,
            onTap: onSearchToggle,
            tooltip: t.libraryCloseSearch,
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _TitleRow extends StatelessWidget {
  final int totalUnread;
  final bool isVaultMode;
  const _TitleRow({super.key, required this.totalUnread, this.isVaultMode = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isVaultMode) ...[
          Icon(Icons.shield_rounded, size: 18, color: cs.primary),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(isVaultMode ? t.libraryVault : t.libraryLibrary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800, color: cs.onSurface)),
        ),
        if (totalUnread > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
            child: Text(totalUnread > 99 ? '99+' : '$totalUnread',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800, color: cs.onPrimary)),
          ),
        ],
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _SearchField({
    super.key, required this.controller,
    required this.focusNode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
      child: TextField(
        controller: controller, focusNode: focusNode, onChanged: onChanged,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: t.librarySearchHint,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: cs.outline),
          prefixIcon: Icon(Icons.search_rounded, size: 18, color: cs.outline),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          filled: false),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}

class _AppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  const _AppBarAction({required this.icon, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          splashColor: cs.primary.withAlpha(26),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 22, color: cs.onSurface)),
        ),
      ),
    );
  }
}

// ── Category Tabs ───────────────────────────────────────────
class _CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;
  final bool showBookmarksOnly;
  final int bookmarkCount;
  final VoidCallback onBookmarkToggle;
  final bool showTabCounts;
  final Map<String, int> categoryCounts;

  const _CategoryTabs({
    required this.categories,
    required this.selected,
    required this.onSelected,
    required this.showBookmarksOnly,
    required this.bookmarkCount,
    required this.onBookmarkToggle,
    this.showTabCounts = false,
    this.categoryCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tabs = [...categories];

    return Container(
      height: 48,
      color: cs.surface,
      child: Row(
        children: [
          // Bookmark toggle
          GestureDetector(
            onTap: onBookmarkToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: showBookmarksOnly
                    ? cs.primary.withAlpha(26)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                border: Border.all(
                  color: showBookmarksOnly ? cs.primary : Colors.transparent,
                  width: 1.5)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    showBookmarksOnly
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 14,
                    color: showBookmarksOnly ? cs.primary : cs.outline),
                  if (bookmarkCount > 0) ...[
                    const SizedBox(width: 4),
                    Text('$bookmarkCount',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: showBookmarksOnly ? cs.primary : cs.outline)),
                  ],
                ],
              ),
            ),
          ),
          Container(width: 1, height: 24, color: cs.surfaceContainerHighest),
          // Category chips
          Expanded(
            child: Builder(builder: (context) {
              // Resolve the two label styles ONCE. Building the style inside
              // itemBuilder meant every chip re-resolved it on every frame of a
              // drag - which is what made this strip stutter.
              final baseStyle = Theme.of(context).textTheme.bodySmall;
              final selectedStyle = baseStyle?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary);
              final unselectedStyle = baseStyle?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.outline);
              return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: tabs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final label = tabs[index];
                final isSelected = selected == label && !showBookmarksOnly;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelected(label),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    child: AnimatedContainer(
                      duration: AppTheme.fastMicro,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primary.withAlpha(26)
                            : cs.surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusFull),
                        border: Border.all(
                          color: isSelected
                              ? cs.primary
                              : Colors.transparent,
                          width: 1.5)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label,
                              style: isSelected
                                  ? selectedStyle
                                  : unselectedStyle),
                          if (showTabCounts) ...[
                            const SizedBox(width: 5),
                            Text('${categoryCounts[label] ?? 0}',
                                style: isSelected
                                    ? selectedStyle
                                    : unselectedStyle),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Continue Reading Banner ──────────────────────────────────
/// Drop-down banner showing library-update progress, then the run summary
/// (tappable to open the retry/update-skipped menu).
class _UpdateProgressBanner extends StatelessWidget {
  final _UpdateBanner banner;
  final VoidCallback? onTapSummary;
  final VoidCallback onDismiss;
  const _UpdateProgressBanner(
      {required this.banner, this.onTapSummary, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final done = banner.done;
    final r = banner.result;
    final hasActions =
        done && r != null && (r.failed > 0 || r.skippedUpdatable.isNotEmpty);
    final text = done
        ? (r == null
            ? t.libraryUpdateComplete
            : t.libraryUpdateCounts(r.completed, r.skipped, r.failed))
        : (banner.total > 0
            ? t.libraryUpdatingProgress(
                banner.title ?? '', banner.checked, banner.total)
            : t.libraryUpdating);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
        color: cs.primary.withAlpha(24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withAlpha(60)),
      ),
      child: InkWell(
        onTap: done ? onTapSummary : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
          child: Row(children: [
            Icon(done ? Icons.check_circle_rounded : Icons.sync_rounded,
                size: 18, color: cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface)),
                    if (!done) ...[
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: banner.total > 0
                              ? banner.checked / banner.total
                              : null,
                          minHeight: 4,
                          color: cs.primary,
                          backgroundColor: cs.onSurface.withAlpha(30),
                        ),
                      ),
                    ] else if (hasActions) ...[
                      const SizedBox(height: 2),
                      Text(t.libraryTapRetryUpdateSkipped,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: cs.outline)),
                    ],
                  ]),
            ),
            if (done)
              IconButton(
                icon: Icon(Icons.close_rounded, size: 18, color: cs.outline),
                onPressed: onDismiss,
                visualDensity: VisualDensity.compact,
              ),
          ]),
        ),
      ),
    );
  }
}

class _ContinueReadingBanner extends StatelessWidget {
  final LibraryManga manga;
  final VoidCallback onTap;

  const _ContinueReadingBanner({required this.manga, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    // Anime items read "Watching" / "Episode" instead of "Reading" / "Chapter".
    final isAnime = (manga.contentType ?? '') == 'anime';
    final progress = manga.totalChapters > 0
        ? manga.readChapters / manga.totalChapters
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.primary.withAlpha(80))),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: manga.coverUrl.isNotEmpty
                  ? MangaImage(
                      imageUrl: manga.coverUrl, width: 36, height: 50,
                      referer: _originOf(manga.url),
                      fit: BoxFit.cover)
                  : Container(width: 36, height: 50, color: cs.surfaceContainerHighest),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isAnime ? t.libraryContinueWatching : t.libraryContinueReading,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10, fontWeight: FontWeight.w600,
                          color: cs.primary, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(manga.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700, color: cs.onSurface)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress, minHeight: 3,
                            backgroundColor: cs.primary.withAlpha(40),
                            valueColor: AlwaysStoppedAnimation<Color>(cs.primary)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                          isAnime
                              ? t.libraryEpisodeProgress(
                                  manga.readChapters, manga.totalChapters)
                              : t.libraryChapterProgress(
                                  manga.readChapters, manga.totalChapters),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 10, color: cs.outline)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
              child: Icon(Icons.play_arrow_rounded, size: 16, color: cs.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Library Grid ─────────────────────────────────────────────
class _LibraryGrid extends StatefulWidget {
  final List<LibraryManga> mangaList;
  final int columnCount;
  final Set<String>? selectedIds;
  final bool badgeUnread;
  final bool badgeDownloaded;
  final bool badgeLanguage;
  final bool badgeLocal;
  final LibraryCardTitle cardTitle;
  final LibraryCardBadges cardBadges;
  final LibraryCardProgress cardProgress;
  final ValueChanged<LibraryManga> onTap;
  final ValueChanged<LibraryManga> onLongPress;

  const _LibraryGrid({
    required this.mangaList, required this.columnCount,
    this.selectedIds,
    this.badgeUnread = true,
    this.badgeDownloaded = true,
    this.badgeLanguage = false,
    this.badgeLocal = false,
    this.cardTitle = LibraryCardTitle.onCover,
    this.cardBadges = LibraryCardBadges.barUnder,
    this.cardProgress = LibraryCardProgress.percent,
    required this.onTap, required this.onLongPress});

  @override
  State<_LibraryGrid> createState() => _LibraryGridState();
}

class _LibraryGridState extends State<_LibraryGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _itemAnimations;

  // Only the first screenful gets the staggered entrance. Allocating an
  // AnimationController (+ Ticker + delayed timer) for EVERY item meant a
  // 1000-item library spun up 1000 tickers on mount/category-switch, which
  // dominated that cost; items past this just render (itemBuilder falls back to
  // a bare card when index is beyond the animation list).
  static const int _maxEntranceAnimations = 16;

  @override
  void initState() {
    super.initState();
    final n = widget.mangaList.length;
    final count = n > _maxEntranceAnimations ? _maxEntranceAnimations : n;
    _itemControllers = List.generate(count,
        (i) => AnimationController(vsync: this, duration: AppTheme.entrance));
    _itemAnimations = _itemControllers
        .map((c) => CurvedAnimation(parent: c, curve: AppTheme.primaryCurve))
        .toList();
    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: (i * 40).clamp(0, 400)), () {
        if (mounted) _itemControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _itemControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A below-cover title or a badge bar adds a row under the cover, so the cell
    // needs to be taller; an all-on-cover card is mostly just the cover.
    final hasUnder = widget.cardTitle == LibraryCardTitle.below ||
        widget.cardBadges == LibraryCardBadges.barUnder;
    // Carded cells: a touch taller to absorb the card padding; every cell at a
    // given column count is identical, so all cards match in height.
    final aspect = hasUnder ? 0.50 : 0.60;
    return GridView.builder(
      // Always scrollable so pull-to-refresh triggers even when the grid
      // doesn't fill the screen.
      physics: const AlwaysScrollableScrollPhysics(),
      // Pre-build ~a row or two beyond the viewport so covers start loading
      // before they scroll into view (fewer placeholder pops on fast scroll).
      // ignore: deprecated_member_use
      cacheExtent: 600,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columnCount,
        childAspectRatio: aspect, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: widget.mangaList.length,
      itemBuilder: (_, index) {
        final m = widget.mangaList[index];
        final isSelected = widget.selectedIds?.contains('${m.sourceId}::${m.url}') ?? false;
        final card = _MangaGridCard(
          // Key by manga identity so Flutter never recycles one card's state
          // (and its kept-alive cover image) onto a different title - that
          // recycling is what made covers "dupe" onto neighbours during updates.
          key: ValueKey('${m.sourceId}::${m.url}'),
          manga: m,
          isSelected: isSelected,
          badgeUnread: widget.badgeUnread,
          badgeDownloaded: widget.badgeDownloaded,
          badgeLanguage: widget.badgeLanguage,
          badgeLocal: widget.badgeLocal,
          cardTitle: widget.cardTitle,
          cardBadges: widget.cardBadges,
          cardProgress: widget.cardProgress,
          onTap: () => widget.onTap(m),
          onLongPress: () => widget.onLongPress(m));
        if (index >= _itemAnimations.length) return card;
        return FadeTransition(
          opacity: _itemAnimations[index],
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
                .animate(_itemAnimations[index]),
            child: card));
      },
    );
  }
}

// ── Grid Card ────────────────────────────────────────────────
class _MangaGridCard extends StatefulWidget {
  final LibraryManga manga;
  final bool isSelected;
  final bool badgeUnread;
  final bool badgeDownloaded;
  final bool badgeLanguage;
  final bool badgeLocal;
  final LibraryCardTitle cardTitle;
  final LibraryCardBadges cardBadges;
  final LibraryCardProgress cardProgress;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const _MangaGridCard({
    super.key,
    required this.manga,
    this.isSelected = false,
    this.badgeUnread = true,
    this.badgeDownloaded = true,
    this.badgeLanguage = false,
    this.badgeLocal = false,
    this.cardTitle = LibraryCardTitle.onCover,
    this.cardBadges = LibraryCardBadges.barUnder,
    this.cardProgress = LibraryCardProgress.percent,
    required this.onTap,
    required this.onLongPress});

  @override
  State<_MangaGridCard> createState() => _MangaGridCardState();
}

class _MangaGridCardState extends State<_MangaGridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() { _pressController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final m = widget.manga;
    final unread = context.read<LibraryProvider>().unreadForManga(m);
    final progress = m.totalChapters > 0
        ? (m.readChapters / m.totalChapters).clamp(0.0, 1.0) : 0.0;
    final showUnread = widget.badgeUnread && unread > 0;
    final showDownloaded = widget.badgeDownloaded &&
        context
            .read<DownloadProvider>()
            .isMangaDownloaded('${m.sourceId}::${m.url}');

    // Language / local badges need the installed source. Both default OFF, so
    // this lookup only runs when the user turns one of them on.
    String? langCode;
    var isLocal = false;
    if (widget.badgeLanguage || widget.badgeLocal) {
      final src =
          context.read<SourceProvider>().getInstalledSource(m.sourceId)?.source;
      if (src != null) {
        if (widget.badgeLanguage && src.lang.isNotEmpty && src.lang != 'all') {
          langCode = src.lang.split('-').first.toUpperCase();
        }
        if (widget.badgeLocal) {
          isLocal = src.repoUrl.isNotEmpty && !src.repoUrl.startsWith('http');
        }
      }
    }

    final titleOver = widget.cardTitle == LibraryCardTitle.onCover;
    final titleBelow = widget.cardTitle == LibraryCardTitle.below;
    final badgesBar = widget.cardBadges == LibraryCardBadges.barUnder;
    final badgesCorner = widget.cardBadges == LibraryCardBadges.cornerOnCover;
    final badgesOnCover = widget.cardBadges == LibraryCardBadges.bottomOnCover;
    final progLine = widget.cardProgress == LibraryCardProgress.line;
    final progMini = widget.cardProgress == LibraryCardProgress.miniBar;
    final progPct = widget.cardProgress == LibraryCardProgress.percent;

    final anyBadgeEnabled = widget.badgeUnread ||
        widget.badgeDownloaded ||
        widget.badgeLanguage ||
        widget.badgeLocal;

    const green = Color(0xFF34D399);
    const amber = Color(0xFFF0C850);
    final pct = (progress * 100).round();
    TextStyle badgeText(Color c) => Theme.of(context).textTheme.labelSmall!
        .copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: c, height: 1.0);
    // One badge shape everywhere: a fixed 18px-tall pill with the same padding /
    // radius, so a row of mixed text + icon badges always lines up.
    Widget badge(Color bg, Widget child) => Container(
          height: 18,
          padding: const EdgeInsets.symmetric(horizontal: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: child,
        );
    // The badge set - the same wherever it's placed. Reading progress rides
    // along as a %-pill or a mini-bar when those styles are chosen.
    final pills = <Widget>[
      if (showUnread)
        badge(cs.primary,
            Text(unread > 99 ? '99+' : '$unread', style: badgeText(cs.onPrimary))),
      if (showDownloaded)
        badge(cs.surfaceContainerHighest,
            const Icon(Icons.download_done_rounded, size: 12, color: green)),
      if (langCode != null)
        badge(cs.surfaceContainerHighest,
            Text(langCode, style: badgeText(cs.onSurfaceVariant))),
      if (isLocal)
        badge(cs.surfaceContainerHighest,
            const Icon(Icons.folder_rounded, size: 12, color: amber)),
      if (progPct && progress > 0)
        badge(cs.primary.withValues(alpha: 0.16),
            Text('$pct%', style: badgeText(cs.primary))),
      if (progMini && progress > 0)
        badge(
            cs.surfaceContainerHighest,
            SizedBox(
              width: 28, height: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Stack(children: [
                  Container(color: cs.onSurface.withValues(alpha: 0.15)),
                  FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: progress,
                    child: Container(color: cs.primary)),
                ]),
              ),
            )),
    ];

    // Thin full-width progress line - sits under the cover, above the badge
    // bar, so it never crosses the artwork.
    Widget progressLine() => Padding(
          padding: const EdgeInsets.only(top: 6, left: 1, right: 1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 4,
              child: Stack(children: [
                Container(color: cs.onSurface.withValues(alpha: 0.15)),
                FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: progress,
                  child: Container(color: cs.primary)),
              ]),
            ),
          ),
        );

    final coverChildren = <Widget>[
      m.coverUrl.isNotEmpty
          ? MangaImage(imageUrl: m.coverUrl, fit: BoxFit.cover,
              referer: _originOf(m.url))
          : Container(color: cs.surfaceContainerHighest,
              child: Icon(Icons.image_rounded, color: cs.outline, size: 32)),
      if (titleOver) ...[
        Positioned(bottom: 0, left: 0, right: 0, child: Container(
          height: 76, decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xDD000000)])))),
        Positioned(bottom: 7, left: 8, right: 8,
          child: Text(m.title, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11.5, fontWeight: FontWeight.w700,
                  color: Colors.white, height: 1.2,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 4)]))),
      ],
      // Corner badges (stacked top-right).
      if (badgesCorner && pills.isNotEmpty)
        PositionedDirectional(top: 6, end: 6,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final p in pills)
                Padding(padding: const EdgeInsets.only(bottom: 4), child: p),
            ])),
      // Bottom-left badges - wrap upward so extra badges stack into a row above
      // the bottom one, raised clear of the on-cover title.
      if (badgesOnCover && pills.isNotEmpty)
        PositionedDirectional(
          start: 6, end: 6, bottom: titleOver ? 32 : 6,
          child: Wrap(
            spacing: 4, runSpacing: 3,
            verticalDirection: VerticalDirection.up,
            children: pills)),
      if (widget.isSelected) ...[
        Container(color: cs.primary.withAlpha(60)),
        PositionedDirectional(top: 6, start: 6,
          child: Container(width: 24, height: 24,
            decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, size: 16, color: Colors.white))),
      ],
    ];

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) => _pressController.reverse(),
      onTapCancel: () => _pressController.reverse(),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        // Carded: every entry is a raised surface with a hairline border + radius
        // so it reads as one contained object and is defined on any background
        // (incl. OLED). Follows the theme via AppSurfaces.
        child: Container(
          decoration: BoxDecoration(
            color: AppSurfaces.of(context).raised,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Stack(fit: StackFit.expand, children: coverChildren),
              ),
            ),
            if (progLine) progressLine(),
            // Fixed-height single row so every card's badge strip is identical
            // (extra badges clip at the edge rather than wrapping to a 2nd row,
            // which would make cards different heights).
            if (badgesBar && (anyBadgeEnabled || progPct || progMini))
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 1, right: 1),
                child: SizedBox(
                  height: 18,
                  child: pills.isEmpty
                      ? null
                      : ClipRect(
                          child: OverflowBox(
                            maxWidth: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              for (var i = 0; i < pills.length; i++) ...[
                                if (i > 0) const SizedBox(width: 5),
                                pills[i],
                              ],
                            ]),
                          ),
                        ),
                ),
              ),
            if (titleBelow)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 1, right: 1),
                child: SizedBox(
                  height: 30,
                  child: Text(m.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 11.5, fontWeight: FontWeight.w600,
                          color: cs.onSurface, height: 1.22)),
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }
}

// ── Library List ─────────────────────────────────────────────
class _LibraryList extends StatelessWidget {
  final List<LibraryManga> mangaList;
  final Set<String>? selectedIds;
  final bool badgeUnread;
  final bool badgeDownloaded;
  final ValueChanged<LibraryManga> onTap;
  final ValueChanged<LibraryManga> onLongPress;
  const _LibraryList({
    required this.mangaList,
    this.selectedIds,
    this.badgeUnread = true,
    this.badgeDownloaded = true,
    required this.onTap,
    required this.onLongPress});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'reading': return AppTheme.success;
      case 'completed': return AppTheme.secondary;
      case 'on hold': return AppTheme.warning;
      case 'dropped': return AppTheme.error;
      default: return AppTheme.mutedDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      // ignore: deprecated_member_use
      cacheExtent: 600,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
      itemCount: mangaList.length,
      itemBuilder: (_, index) {
        final manga = mangaList[index];
        final unread = context.read<LibraryProvider>().unreadForManga(manga);
        final isSelected = selectedIds?.contains('${manga.sourceId}::${manga.url}') ?? false;
        final showUnread = badgeUnread && unread > 0;
        final showDownloaded = badgeDownloaded &&
            context
                .read<DownloadProvider>()
                .isMangaDownloaded('${manga.sourceId}::${manga.url}');
        return Material(
          // Key by manga identity so a recycled row never shows a neighbour's
          // kept-alive cover (the list-view counterpart of the grid fix).
          key: ValueKey('${manga.sourceId}::${manga.url}'),
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(manga),
            onLongPress: () => onLongPress(manga),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary.withAlpha(30) : cs.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border(left: BorderSide(color: isSelected ? cs.primary : _statusColor(manga.status), width: 3))),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    child: manga.coverUrl.isNotEmpty
                        ? MangaImage(imageUrl: manga.coverUrl, width: 52, height: 72, fit: BoxFit.cover,
                            referer: _originOf(manga.url))
                        : Container(width: 52, height: 72, color: cs.surfaceContainerHighest)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(manga.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: cs.onSurface)),
                      const SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.library_books_rounded, size: 11, color: cs.outline),
                        const SizedBox(width: 3),
                        Text(t.libraryListChapters(manga.readChapters, manga.totalChapters),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.outline)),
                      ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _statusColor(manga.status).withAlpha(38),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
                          child: Text(manga.status.isEmpty ? t.libraryStatusUnknown : manga.status,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(manga.status)))),
                        const Spacer(),
                        if (showDownloaded)
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: cs.tertiary,
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
                            child: Icon(Icons.download_done_rounded,
                                size: 12, color: cs.onTertiary)),
                        if (showDownloaded && showUnread)
                          const SizedBox(width: 6),
                        if (showUnread)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
                            child: Text(unread > 99 ? '99+' : '$unread',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w800, color: cs.onPrimary))),
                      ]),
                    ],
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Empty State ──────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isSearching;
  final String searchQuery;
  final bool isBookmarkFilter;
  const _EmptyState({required this.isSearching, required this.searchQuery, this.isBookmarkFilter = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isBookmarkFilter ? Icons.bookmark_border_rounded : Icons.collections_bookmark_outlined,
              size: 64, color: cs.outline.withAlpha(128)),
            const SizedBox(height: 16),
            Text(
              isBookmarkFilter ? t.libraryNoBookmarks
                  : isSearching ? t.libraryNoResults : t.libraryEmpty,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
            const SizedBox(height: 8),
            Text(
              isBookmarkFilter
                  ? t.libraryNoBookmarksDesc
                  : isSearching
                      ? t.libraryNoResultsDesc(searchQuery)
                      : t.libraryEmptyDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.outline)),
          ],
        ),
      ),
    );
  }
}

class _BatchButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BatchButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: cs.onSurface),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: cs.onSurface)),
          ],
        ),
      ),
    );
  }
}
