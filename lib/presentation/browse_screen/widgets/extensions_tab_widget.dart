import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/type_toggle.dart';
import '../../../core/models/source_model.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/providers/vault_provider.dart';
import '../../../core/services/app_logger.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import 'browse_source_detail_sheet.dart';
import 'source_icon.dart';
import 'source_settings_page.dart';

class ExtensionsTabWidget extends StatefulWidget {
  final String searchQuery;

  const ExtensionsTabWidget({super.key, this.searchQuery = ''});

  @override
  State<ExtensionsTabWidget> createState() => _ExtensionsTabWidgetState();
}

class _ExtensionsTabWidgetState extends State<ExtensionsTabWidget> {
  final Set<String> _selectedLangs = {}; // empty = all languages
  final Set<String> _selectedRepos = {}; // empty = all repositories (repo urls)
  // Languages the user pinned to the top of the filter. Shared across all
  // content types and persisted; the device language is always treated as
  // pinned on top of these.
  final Set<String> _pinnedLangs = {};
  static const _pinnedPrefsKey = 'browse_pinned_languages';
  String _typeFilter = 'manga';
  // Extension-update progress, so the UI shows a spinner while it runs.
  bool _updatingAll = false;
  final Set<String> _updatingIds = {}; // per-source updates in flight
  final Set<String> _installingIds = {}; // per-source installs in flight

  @override
  void initState() {
    super.initState();
    _loadPinnedLangs();
  }

  Future<void> _loadPinnedLangs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_pinnedPrefsKey) ?? const [];
      if (!mounted || saved.isEmpty) return;
      setState(() => _pinnedLangs
        ..clear()
        ..addAll(saved.map(MangaSource.normalizeLang)));
    } catch (_) {/* prefs unavailable — pins just start empty */}
  }

  Future<void> _savePinnedLangs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_pinnedPrefsKey, _pinnedLangs.toList());
    } catch (_) {/* best effort */}
  }

  /// The device's language as a normalized code (for the "Your languages" pin).
  String get _deviceLang => MangaSource.normalizeLang(
      WidgetsBinding.instance.platformDispatcher.locale.languageCode);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Consumer2<SourceProvider, VaultProvider>(
      builder: (_, provider, vault, _) {
        var allSources = provider.allSources;

        // Fold in installed sources that aren't in any loaded repo index right
        // now: locally-authored RepoForge sources ("My Sources"), or a repo
        // whose index didn't load this session. Without this they'd only reach
        // the grid through a separate orphan path and never show up in the
        // Repository filter or respond to repo/language filtering.
        final catalogIds = allSources.map((s) => s.id).toSet();
        allSources = [
          ...allSources,
          for (final s in provider.installedSources)
            if (!catalogIds.contains(s.source.id)) s.source,
        ];

        // Filter by type (manga / anime)
        allSources = allSources
            .where((s) => s.itemType == _typeFilter)
            .toList();

        // Hide vault-only sources when not in vault mode
        if (!vault.vaultActive) {
          allSources = allSources
              .where((s) => !vault.isSourceInVault(s.id))
              .toList();
        }

        // Hide NSFW sources unless the user opted in (Browse settings).
        if (!provider.showNsfw) {
          allSources = allSources.where((s) => !s.isNsfw).toList();
        }

        // Search filter
        if (widget.searchQuery.isNotEmpty) {
          final q = widget.searchQuery.toLowerCase();
          allSources = allSources
              .where((s) => s.name.toLowerCase().contains(q))
              .toList();
        }

        // Sources after type/vault/nsfw/search, before the lang/repo filters.
        final baseSources = allSources;

        // Repositories present for this content type (url -> friendly name), for
        // the filter modal's Repository tab. Independent of the language filter
        // so the repo list always reflects the whole type.
        final repoNames = <String, String>{};
        for (final s in baseSources) {
          if (s.repoUrl.isNotEmpty) {
            repoNames[s.repoUrl] =
                s.repoName.isNotEmpty ? s.repoName : _repoHost(s.repoUrl);
          }
        }
        final repoList = repoNames.entries
            .map((e) => (url: e.key, name: e.value))
            .toList()
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        // Language options + counts are scoped to the selected repositories, so
        // the filter only offers (and counts) languages those repos actually
        // have — pick a repo and languages it lacks disappear.
        final repoScoped = _selectedRepos.isEmpty
            ? baseSources
            : baseSources
                .where((s) => _selectedRepos.contains(s.repoUrl))
                .toList();
        final languages = <String>{'all'};
        for (final s in repoScoped) {
          languages.add(s.lang);
        }

        // Only apply selected languages that still exist in the repo scope, so a
        // repo switch never silently empties the list via a now-absent language.
        final effectiveLangs =
            _selectedLangs.where(languages.contains).toSet();
        allSources = effectiveLangs.isEmpty
            ? repoScoped
            : repoScoped
                .where((s) => effectiveLangs.contains(s.lang))
                .toList();

        // Split into installed / available. Locally-authored and orphaned
        // installed sources are already folded into allSources above, so they
        // land here under the active repo/language filters like everything else.
        final installed = <MangaSource>[];
        final available = <MangaSource>[];
        for (final s in allSources) {
          if (provider.isInstalled(s.id)) {
            installed.add(s);
          } else {
            available.add(s);
          }
        }

        // Installed sources with a newer version available, scoped to the current
        // space (vault sources only in vault mode) and the manga/anime toggle.
        final updateSources = provider
            .updatesForContext(
                vaultActive: vault.vaultActive, vaultIds: vault.vaultSourceIds)
            .map((s) => s.source)
            .where((s) => s.itemType == _typeFilter)
            .toList();
        final updateIds = updateSources.map((s) => s.id).toSet();
        final installedRest =
            installed.where((s) => !updateIds.contains(s.id)).toList();

        // Per-type update tally (across ALL types, not just the active one) so
        // the toggle can badge the type that actually has the update — otherwise
        // an anime/novel update is invisible behind the manga tab.
        final updatesByType = <String, int>{'manga': 0, 'anime': 0, 'novel': 0};
        for (final s in provider.updatesForContext(
            vaultActive: vault.vaultActive, vaultIds: vault.vaultSourceIds)) {
          final it = s.source.itemType;
          updatesByType[it] = (updatesByType[it] ?? 0) + 1;
        }

        return Column(
          children: [
            // Manga / Anime / Novel type toggle (badged per type with updates)
            _buildTypeToggle(cs, updatesByType),
            // Filter bar
            if (languages.length > 2 ||
                repoList.length > 1 ||
                _selectedLangs.isNotEmpty ||
                _selectedRepos.isNotEmpty)
              _buildFilterBar(cs, baseSources, repoList, allSources.length),
            if (languages.length > 2 ||
                repoList.length > 1 ||
                _selectedLangs.isNotEmpty ||
                _selectedRepos.isNotEmpty)
              Divider(height: 1, color: cs.surfaceContainerHighest),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: allSources.isEmpty && !provider.isLoading
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: _buildEmptyState(cs),
                          ),
                        ],
                      )
                    : provider.isLoading && allSources.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(
                                height: 300,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ],
                          )
                        : ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 100),
                            children: [
                              if (updateSources.isNotEmpty) ...[
                                _UpdatesHeader(
                                  count: updateSources.length,
                                  updating: _updatingAll,
                                  onUpdateAll: () => _updateAll(
                                      context, provider, updateIds.toList()),
                                ),
                                ...updateSources.map((s) => _ExtensionRow(
                                      source: s,
                                      isInstalled: true,
                                      needsUpdate: true,
                                      updating: _updatingAll ||
                                          _updatingIds.contains(s.id),
                                      onUpdate: () =>
                                          _updateOne(context, provider, s.id),
                                      onInstall: () =>
                                          provider.uninstallSource(s.id),
                                      onSettings: () =>
                                          _openSourceSettings(context, s),
                                      onTap: () =>
                                          _showDetail(context, s, true),
                                    )),
                              ],
                              if (installedRest.isNotEmpty) ...[
                                _SectionHeader(
                                    title: t.browseInstalled,
                                    count: installedRest.length),
                                ...installedRest.map((s) => _ExtensionRow(
                                      source: s,
                                      isInstalled: true,
                                      onInstall: () =>
                                          provider.uninstallSource(s.id),
                                      onSettings: () =>
                                          _openSourceSettings(context, s),
                                      onTap: () =>
                                          _showDetail(context, s, true),
                                    )),
                              ],
                              if (available.isNotEmpty) ...[
                                _SectionHeader(
                                    title: t.browseAvailable,
                                    count: available.length),
                                ...available.map((s) => _ExtensionRow(
                                      source: s,
                                      isInstalled: false,
                                      installing:
                                          _installingIds.contains(s.id),
                                      onInstall: () =>
                                          _installOne(context, provider, s),
                                      onTap: () =>
                                          _showDetail(context, s, false),
                                    )),
                              ],
                            ],
                          ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Opens the source's own preferences. Needs the installed record because the
  /// preference list comes from running the extension's getSourcePreferences().
  void _openSourceSettings(BuildContext context, MangaSource source) {
    final installed =
        context.read<SourceProvider>().getInstalledSource(source.id);
    if (installed == null) {
      AppTheme.showSnackBar(
          context, AppLocalizations.of(context).browseSourceNotInstalled);
      return;
    }
    SourceSettingsPage.open(
      context,
      source: installed.source,
      sourceCode: installed.sourceCode,
    );
  }

  Widget _buildTypeToggle(ColorScheme cs, Map<String, int> updatesByType) {
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.surfaceContainerHighest)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TypeToggle(
          items: [
            TypeToggleItem('manga', t.browseManga,
                badge: updatesByType['manga'] ?? 0),
            TypeToggleItem('anime', t.browseAnime,
                badge: updatesByType['anime'] ?? 0),
            TypeToggleItem('novel', t.browseNovels,
                badge: updatesByType['novel'] ?? 0),
          ],
          selectedId: _typeFilter,
          onChanged: (type) => setState(() {
            _typeFilter = type;
            _selectedLangs.clear();
            _selectedRepos.clear();
          }),
        ),
      ),
    );
  }

  Widget _buildFilterBar(ColorScheme cs, List<MangaSource> baseSources,
      List<({String url, String name})> repos, int resultCount) {
    final t = AppLocalizations.of(context);
    final hasFilters = _selectedLangs.isNotEmpty || _selectedRepos.isNotEmpty;
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Filter button — opens a scrollable, tabbed Language / Repository sheet.
          GestureDetector(
            onTap: () => _openFilterModal(baseSources, repos),
            child: AnimatedContainer(
              duration: AppTheme.fastMicro,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: hasFilters ? cs.primary : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_list_rounded,
                      size: 14,
                      color: hasFilters ? Colors.white : cs.onSurface),
                  const SizedBox(width: 4),
                  Text(t.browseFilter,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: hasFilters ? Colors.white : cs.onSurface,
                      )),
                ],
              ),
            ),
          ),
          if (_selectedLangs.isNotEmpty) ...[
            const SizedBox(width: 8),
            _ActiveFilterChip(
              label: _selectedLangs.length <= 2
                  ? _selectedLangs.map(MangaSource.languageName).join(', ')
                  : t.browseLanguagesCount(_selectedLangs.length),
              onRemove: () => setState(() => _selectedLangs.clear()),
            ),
          ],
          if (_selectedRepos.isNotEmpty) ...[
            const SizedBox(width: 8),
            _ActiveFilterChip(
              label: _repoChipLabel(t, repos),
              onRemove: () => setState(() => _selectedRepos.clear()),
            ),
          ],
          const Spacer(),
          Text(t.browseResultCount(resultCount),
              style: GoogleFonts.manrope(fontSize: 11, color: cs.outline)),
        ],
      ),
    );
  }

  String _repoHost(String url) {
    final u = Uri.tryParse(url);
    return (u != null && u.host.isNotEmpty) ? u.host : url;
  }

  String _repoChipLabel(
      AppLocalizations t, List<({String url, String name})> repos) {
    if (_selectedRepos.length == 1) {
      final url = _selectedRepos.first;
      final match = repos.where((r) => r.url == url);
      return match.isNotEmpty ? match.first.name : _repoHost(url);
    }
    return t.browseReposCount(_selectedRepos.length);
  }

  /// A centered floating dialog with Language + Repository tabs. The Language
  /// tab is a searchable grid with a pinned "Your languages" section; its
  /// options are scoped live to the current repository selection.
  void _openFilterModal(
      List<MangaSource> baseSources, List<({String url, String name})> repos) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final searchCtrl = TextEditingController();
    var langQuery = '';
    // Source count per repo (total for this content type — repos stay fully
    // selectable regardless of the language filter).
    final repoCounts = <String, int>{};
    for (final s in baseSources) {
      if (s.repoUrl.isNotEmpty) {
        repoCounts[s.repoUrl] = (repoCounts[s.repoUrl] ?? 0) + 1;
      }
    }
    showDialog<void>(
      context: context,
      builder: (dctx) {
        return DefaultTabController(
          length: 2,
          child: StatefulBuilder(
            builder: (dctx, setModal) {
              void refresh() {
                setModal(() {});
                setState(() {});
              }

              // Languages + counts for the current repo selection, so the grid
              // only offers languages the chosen repos actually have.
              final repoScoped = _selectedRepos.isEmpty
                  ? baseSources
                  : baseSources
                      .where((s) => _selectedRepos.contains(s.repoUrl))
                      .toList();
              final counts = <String, int>{};
              for (final s in repoScoped) {
                counts[s.lang] = (counts[s.lang] ?? 0) + 1;
              }
              final device = _deviceLang;
              int cmp(String a, String b) => MangaSource.languageName(a)
                  .toLowerCase()
                  .compareTo(MangaSource.languageName(b).toLowerCase());
              final query = langQuery.trim().toLowerCase();
              bool matches(String l) =>
                  query.isEmpty ||
                  MangaSource.languageName(l).toLowerCase().contains(query) ||
                  l.toLowerCase().contains(query);

              // "Your languages": device first, then pinned — limited to what
              // the current repo scope actually has.
              final pinnedAvail = <String>[
                if (counts.containsKey(device)) device,
                ..._pinnedLangs
                    .where((l) => l != device && counts.containsKey(l))
                    .toList()
                  ..sort(cmp),
              ].where(matches).toList();
              final pinnedSet = pinnedAvail.toSet();
              final rest = counts.keys
                  .where((l) => !pinnedSet.contains(l) && matches(l))
                  .toList()
                ..sort(cmp);

              void onStar(String lang) {
                if (!_pinnedLangs.remove(lang)) _pinnedLangs.add(lang);
                _savePinnedLangs();
                refresh();
              }

              void onPick(String lang) {
                if (!_selectedLangs.remove(lang)) _selectedLangs.add(lang);
                refresh();
              }

              Widget langTab() {
                final searching = query.isNotEmpty;
                final flat = searching
                    ? (counts.keys.where(matches).toList()
                      ..sort((a, b) {
                        if (a == device) return -1;
                        if (b == device) return 1;
                        return cmp(a, b);
                      }))
                    : const <String>[];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: _langSearchField(cs, searchCtrl, (v) {
                        langQuery = v;
                        setModal(() {});
                      }),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          if (searching) ...[
                            _langGrid(cs, flat, counts, device, onPick, onStar),
                            if (flat.isEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(28),
                                  child: Text('No languages match',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.manrope(
                                          fontSize: 13, color: cs.outline)),
                                ),
                              ),
                          ] else ...[
                            if (pinnedAvail.isNotEmpty) ...[
                              _langHeader(cs, 'Your languages', star: true),
                              _langGrid(cs, pinnedAvail, counts, device, onPick,
                                  onStar),
                            ],
                            _langHeader(cs, t.browseAllLanguages),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 6),
                                child: _langAllCell(cs, repoScoped.length, () {
                                  _selectedLangs.clear();
                                  refresh();
                                }),
                              ),
                            ),
                            _langGrid(
                                cs, rest, counts, device, onPick, onStar),
                          ],
                          const SliverToBoxAdapter(child: SizedBox(height: 14)),
                        ],
                      ),
                    ),
                  ],
                );
              }

              // Mirrors the Language tab: an "All repositories" cell + a compact
              // two-column grid of repo cells with source counts.
              Widget repoTab() => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 14, 16, 6),
                                child: _langCellBox(
                                  cs,
                                  selected: _selectedRepos.isEmpty,
                                  onTap: () {
                                    _selectedRepos.clear();
                                    refresh();
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.browseAllRepositories,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.manrope(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: cs.onSurface,
                                          ),
                                        ),
                                      ),
                                      Text('${baseSources.length}',
                                          style: GoogleFonts.manrope(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: cs.outline)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 2),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 50,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (ctx, i) {
                                    final r = repos[i];
                                    return _langCellBox(
                                      cs,
                                      selected: _selectedRepos.contains(r.url),
                                      onTap: () {
                                        if (!_selectedRepos.remove(r.url)) {
                                          _selectedRepos.add(r.url);
                                        }
                                        refresh();
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              r.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.manrope(
                                                fontSize: 12.5,
                                                height: 1.15,
                                                fontWeight: FontWeight.w600,
                                                color: cs.onSurface,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${repoCounts[r.url] ?? 0}',
                                              style: GoogleFonts.manrope(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: cs.outline)),
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: repos.length,
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 14)),
                          ],
                        ),
                      ),
                    ],
                  );

              return Dialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 64),
                backgroundColor: cs.surface,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                  width: 400,
                  height: (MediaQuery.of(dctx).size.height * 0.6)
                      .clamp(340.0, 560.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 8, 0),
                        child: Row(
                          children: [
                            Text(t.browseFilter,
                                style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface)),
                            const Spacer(),
                            IconButton(
                              icon:
                                  Icon(Icons.close_rounded, color: cs.outline),
                              onPressed: () => Navigator.pop(dctx),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        labelColor: cs.primary,
                        unselectedLabelColor: cs.outline,
                        indicatorColor: cs.primary,
                        tabs: [
                          Tab(text: t.settingsLanguageTitle),
                          Tab(text: t.browseFilterRepository),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(children: [langTab(), repoTab()]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).then((_) => searchCtrl.dispose());
  }

  // ---- Language filter grid (pinned "Your languages" + searchable list) ----

  Widget _langSearchField(ColorScheme cs, TextEditingController ctrl,
      ValueChanged<String> onChanged) {
    return TextField(
      controller: ctrl,
      onChanged: onChanged,
      style: GoogleFonts.manrope(fontSize: 13, color: cs.onSurface),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search languages',
        hintStyle: GoogleFonts.manrope(fontSize: 13, color: cs.outline),
        prefixIcon: Icon(Icons.search_rounded, size: 18, color: cs.outline),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _langHeader(ColorScheme cs, String text, {bool star = false}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 16, 6),
        child: Row(
          children: [
            if (star) ...[
              const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF0C850)),
              const SizedBox(width: 6),
            ],
            Text(
              text.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: cs.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _langGrid(ColorScheme cs, List<String> langs, Map<String, int> counts,
      String device, void Function(String) onPick,
      void Function(String) onStar) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 50,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final lang = langs[i];
            return _langCell(
              cs,
              label: MangaSource.languageName(lang),
              count: counts[lang] ?? 0,
              selected: _selectedLangs.contains(lang),
              pinned: _pinnedLangs.contains(lang),
              isDevice: lang == device,
              onTap: () => onPick(lang),
              onStar: lang == device ? null : () => onStar(lang),
            );
          },
          childCount: langs.length,
        ),
      ),
    );
  }

  Widget _langAllCell(ColorScheme cs, int count, VoidCallback onTap) {
    final selected = _selectedLangs.isEmpty;
    return _langCellBox(
      cs,
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context).browseAllLanguages,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
          Text('$count',
              style: GoogleFonts.manrope(
                  fontSize: 11, fontWeight: FontWeight.w700, color: cs.outline)),
        ],
      ),
    );
  }

  Widget _langCell(ColorScheme cs,
      {required String label,
      required int count,
      required bool selected,
      required bool pinned,
      required bool isDevice,
      required VoidCallback onTap,
      VoidCallback? onStar}) {
    return _langCellBox(
      cs,
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                height: 1.15,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
          if (isDevice)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(left: 5, right: 2),
              decoration: const BoxDecoration(
                  color: Color(0xFF34D399), shape: BoxShape.circle),
            ),
          const SizedBox(width: 4),
          Text('$count',
              style: GoogleFonts.manrope(
                  fontSize: 11, fontWeight: FontWeight.w700, color: cs.outline)),
          if (onStar != null)
            GestureDetector(
              onTap: onStar,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  pinned ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 17,
                  color: pinned ? const Color(0xFFF0C850) : cs.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _langCellBox(ColorScheme cs,
      {required bool selected,
      required VoidCallback onTap,
      required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(11, 6, 8, 6),
        decoration: BoxDecoration(
          color:
              selected ? cs.primary.withAlpha(46) : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : cs.outline.withAlpha(36),
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.extension_rounded, size: 56, color: cs.outline),
          const SizedBox(height: 16),
          Text(
            t.browseNoExtensions,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t.browseNoExtensionsDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: 13, color: cs.outline),
          ),
        ],
      ),
    );
  }

  Future<void> _updateAll(
      BuildContext context, SourceProvider provider, List<String> ids) async {
    final t = AppLocalizations.of(context);
    setState(() => _updatingAll = true);
    try {
      final n = await provider.updateAll(ids);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.browseUpdatedSources(n)),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) setState(() => _updatingAll = false);
    }
  }

  /// Update a single source. Mirrors [_updateAll]: awaits, surfaces the outcome as
  /// a snackbar, and logs any failure — the per-row button used to be fire-and-forget,
  /// so a failing install just silently did nothing while "Update all" appeared to work.
  Future<void> _updateOne(
      BuildContext context, SourceProvider provider, String id) async {
    final t = AppLocalizations.of(context);
    setState(() => _updatingIds.add(id));
    try {
      final ok = await provider.updateSource(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? t.browseSourceUpdated : t.browseNoUpdateAvailable),
        duration: const Duration(seconds: 2),
      ));
    } catch (e, st) {
      logger.error('Source update failed ($id): $e',
          category: LogCategory.install, detail: st.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.browseUpdateFailed(e.toString())),
        duration: const Duration(seconds: 3),
      ));
    } finally {
      if (mounted) setState(() => _updatingIds.remove(id));
    }
  }

  /// Install a single available source. Mirrors [_updateOne]: shows a per-row spinner
  /// while the download/registration runs and surfaces failures instead of the button
  /// silently doing nothing.
  Future<void> _installOne(
      BuildContext context, SourceProvider provider, MangaSource s) async {
    final t = AppLocalizations.of(context);
    final vault = context.read<VaultProvider>();
    setState(() => _installingIds.add(s.id));
    try {
      await provider.installSource(s);
      // Installed while browsing inside the vault → keep it in the vault so it
      // stays in that private space instead of appearing in the normal list.
      if (vault.vaultActive && !vault.isSourceInVault(s.id)) {
        vault.toggleVaultSource(s.id);
      }
    } catch (e, st) {
      logger.error('Source install failed (${s.id}): $e',
          category: LogCategory.install, detail: st.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.browseUpdateFailed(e.toString())),
        duration: const Duration(seconds: 3),
      ));
    } finally {
      if (mounted) setState(() => _installingIds.remove(s.id));
    }
  }

  Future<void> _handleRefresh() async {
    final t = AppLocalizations.of(context);
    final provider = context.read<SourceProvider>();
    // Refresh repo indexes to pick up metadata changes, then re-download
    // cached extension code for all installed sources.
    await provider.refreshRepos();
    try {
      final count = await provider.refreshAllSourceCode();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.browseUpdatedSources(count)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.browseRefreshFailed(e.toString()))),
      );
    }
  }

  void _showDetail(BuildContext context, MangaSource source, bool installed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => BrowseSourceDetailSheet(
        source: source,
        isInstalled: installed,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        '$title ($count)',
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: cs.outline,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// Header for the "updates available" section, with a one-tap "Update all".
class _UpdatesHeader extends StatelessWidget {
  final int count;
  final VoidCallback onUpdateAll;
  final bool updating;
  const _UpdatesHeader(
      {required this.count, required this.onUpdateAll, this.updating = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 6),
      child: Row(
        children: [
          Icon(Icons.system_update_alt_rounded, size: 14, color: cs.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              t.browseUpdatesAvailable(count),
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: cs.primary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (updating)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: cs.primary),
                ),
                const SizedBox(width: 8),
                Text('Updating…',
                    style: GoogleFonts.manrope(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: cs.primary)),
              ]),
            )
          else
            TextButton(
              onPressed: onUpdateAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(t.browseUpdateAll,
                  style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: cs.primary)),
            ),
        ],
      ),
    );
  }
}

class _ExtensionRow extends StatelessWidget {
  final MangaSource source;
  final bool isInstalled;
  final VoidCallback onInstall;
  final VoidCallback? onSettings;
  final VoidCallback? onTap;
  final bool needsUpdate;
  final VoidCallback? onUpdate;
  final bool updating;
  final bool installing;

  const _ExtensionRow({
    required this.source,
    required this.isInstalled,
    required this.onInstall,
    this.onSettings,
    this.onTap,
    this.needsUpdate = false,
    this.onUpdate,
    this.updating = false,
    this.installing = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: cs.primary.withAlpha(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Extension icon
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withAlpha(51),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SourceIcon(
                  source: source,
                  size: 52,
                  radius: 12,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Extension info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Language badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: cs.outline.withAlpha(51), width: 1),
                      ),
                      child: Text(
                        source.lang.toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: cs.outline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Repo name & version
                    Row(
                      children: [
                        Icon(Icons.extension_rounded,
                            size: 12, color: cs.outline),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            source.repoName.isNotEmpty ? source.repoName : source.framework,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                                fontSize: 11, color: cs.outline),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.tag_rounded,
                            size: 12, color: cs.outline),
                        const SizedBox(width: 4),
                        Text(
                          'v${source.version}',
                          style: GoogleFonts.manrope(
                              fontSize: 11, color: cs.outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Not installed → Install. Installed → Settings, which opens the
              // source's own preferences (Remove lives in there).
              if (needsUpdate && onUpdate != null)
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: updating ? null : onUpdate,
                  child: updating
                      ? const SizedBox(
                          width: 13,
                          height: 13,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(t.browseUpdate,
                          style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                )
              else
                _InstallButton(
                  isInstalled: isInstalled,
                  installing: installing,
                  onPressed: isInstalled ? (onSettings ?? onInstall) : onInstall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstallButton extends StatelessWidget {
  final bool isInstalled;
  final VoidCallback onPressed;
  final bool installing;

  const _InstallButton({
    required this.isInstalled,
    required this.onPressed,
    this.installing = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final color = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: installing ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withAlpha(isInstalled ? 102 : 128),
          ),
        ),
        child: installing
            ? SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: color),
              )
            : Text(
                isInstalled ? t.browseSettings : t.browseInstall,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: cs.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: cs.primary.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 14, color: cs.primary),
          ),
        ],
      ),
    );
  }
}
