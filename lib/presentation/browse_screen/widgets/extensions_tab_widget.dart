import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  String _typeFilter = 'manga';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Consumer2<SourceProvider, VaultProvider>(
      builder: (_, provider, vault, _) {
        var allSources = provider.allSources;

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

        // Get languages
        final languages = <String>{'all'};
        for (final s in allSources) {
          languages.add(s.lang);
        }

        // Repositories present for this content type (url -> friendly name), for
        // the filter modal's Repository tab. Built before the lang/repo filters
        // so each option list reflects the whole type, not the other filter.
        final repoNames = <String, String>{};
        for (final s in allSources) {
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

        // Language filter
        if (_selectedLangs.isNotEmpty) {
          allSources =
              allSources.where((s) => _selectedLangs.contains(s.lang)).toList();
        }
        // Repository filter
        if (_selectedRepos.isNotEmpty) {
          allSources = allSources
              .where((s) => _selectedRepos.contains(s.repoUrl))
              .toList();
        }

        // Split into installed / available
        final installed = <MangaSource>[];
        final available = <MangaSource>[];
        final repoIds = <String>{};
        for (final s in allSources) {
          repoIds.add(s.id);
          if (provider.isInstalled(s.id)) {
            installed.add(s);
          } else {
            available.add(s);
          }
        }
        // Add orphaned installed sources (no longer in any repo)
        final q = widget.searchQuery.toLowerCase();
        for (final s in provider.installedSources) {
          if (!repoIds.contains(s.source.id)) {
            if (!vault.vaultActive && vault.isSourceInVault(s.source.id)) continue;
            if (s.source.itemType != _typeFilter) continue;
            if (q.isEmpty || s.source.name.toLowerCase().contains(q)) {
              installed.add(s.source);
            }
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

        return Column(
          children: [
            // Manga / Anime type toggle
            _buildTypeToggle(cs),
            // Filter bar
            if (languages.length > 2 || repoList.length > 1)
              _buildFilterBar(
                  cs, languages.toList(), repoList, allSources.length),
            if (languages.length > 2 || repoList.length > 1)
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
                                  onUpdateAll: () => _updateAll(
                                      context, provider, updateIds.toList()),
                                ),
                                ...updateSources.map((s) => _ExtensionRow(
                                      source: s,
                                      isInstalled: true,
                                      needsUpdate: true,
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
                                      onInstall: () =>
                                          provider.installSource(s),
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

  Widget _buildTypeToggle(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.surfaceContainerHighest)),
      ),
      child: Row(
        children: [
          for (final type in ['manga', 'anime', 'novel'])
            GestureDetector(
              onTap: () => setState(() {
                _typeFilter = type;
                _selectedLangs.clear();
                _selectedRepos.clear();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _typeFilter == type ? cs.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  type == 'manga'
                      ? t.browseManga
                      : type == 'anime'
                          ? t.browseAnime
                          : t.browseNovels,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: _typeFilter == type ? FontWeight.w700 : FontWeight.w500,
                    color: _typeFilter == type ? cs.primary : cs.outline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ColorScheme cs, List<String> languages,
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
            onTap: () => _openFilterModal(languages, repos),
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
                  ? _selectedLangs.map((l) => l.toUpperCase()).join(', ')
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

  /// A centered floating dialog with Language + Repository tabs, each a
  /// scrollable multi-select chip list.
  void _openFilterModal(
      List<String> languages, List<({String url, String name})> repos) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final langs = [
      'all',
      ...languages.where((l) => l != 'all').toList()..sort(),
    ];
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

              Widget langTab() => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        for (final lang in langs)
                          _filterChip(
                            cs,
                            label: lang == 'all'
                                ? t.browseAllLanguages
                                : lang.toUpperCase(),
                            selected: lang == 'all'
                                ? _selectedLangs.isEmpty
                                : _selectedLangs.contains(lang),
                            onTap: () {
                              if (lang == 'all') {
                                _selectedLangs.clear();
                              } else if (!_selectedLangs.remove(lang)) {
                                _selectedLangs.add(lang);
                              }
                              refresh();
                            },
                          ),
                      ],
                    ),
                  );

              Widget repoTab() => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        _filterChip(
                          cs,
                          label: t.browseAllRepositories,
                          selected: _selectedRepos.isEmpty,
                          onTap: () {
                            _selectedRepos.clear();
                            refresh();
                          },
                        ),
                        for (final r in repos)
                          _filterChip(
                            cs,
                            label: r.name,
                            selected: _selectedRepos.contains(r.url),
                            onTap: () {
                              if (!_selectedRepos.remove(r.url)) {
                                _selectedRepos.add(r.url);
                              }
                              refresh();
                            },
                          ),
                      ],
                    ),
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
    );
  }

  Widget _filterChip(ColorScheme cs,
      {required String label,
      required bool selected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : cs.onSurface,
          ),
        ),
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
    final n = await provider.updateAll(ids);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.browseUpdatedSources(n)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Update a single source. Mirrors [_updateAll]: awaits, surfaces the outcome as
  /// a snackbar, and logs any failure — the per-row button used to be fire-and-forget,
  /// so a failing install just silently did nothing while "Update all" appeared to work.
  Future<void> _updateOne(
      BuildContext context, SourceProvider provider, String id) async {
    final t = AppLocalizations.of(context);
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
  const _UpdatesHeader({required this.count, required this.onUpdateAll});

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

  const _ExtensionRow({
    required this.source,
    required this.isInstalled,
    required this.onInstall,
    this.onSettings,
    this.onTap,
    this.needsUpdate = false,
    this.onUpdate,
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
                  onPressed: onUpdate,
                  child: Text(t.browseUpdate,
                      style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                )
              else
                _InstallButton(
                  isInstalled: isInstalled,
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

  const _InstallButton({
    required this.isInstalled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final color = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onPressed,
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
        child: Text(
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
