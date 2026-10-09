import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/installed_source_model.dart';
import '../../core/models/source_settings.dart';
import '../../core/providers/source_provider.dart';
import '../../core/providers/vault_provider.dart';
import '../../core/services/webview_service.dart';
import '../../eval/lib.dart';
import '../../eval/model/m_manga.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/search_filter.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../widgets/manga_image.dart';

class GlobalSearchScreen extends StatefulWidget {
  /// When set (e.g. long-pressing a title on the detail screen), the search box
  /// is prefilled and the search runs automatically.
  final String? initialQuery;

  /// Optional content-type scope to start on ('manga' | 'anime' | 'novel').
  /// Set when long-pressing a tag on the detail page so results come back
  /// pre-filtered to the title's own type.
  final String? initialType;
  const GlobalSearchScreen({super.key, this.initialQuery, this.initialType});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  bool _hasSearched = false;
  // Content-type scope: 'all' | 'manga' | 'anime' | 'novel'.
  String _typeFilter = 'all';
  // The sources being searched, in display order.
  List<InstalledSource> _sources = [];
  // Per-source state. A source is "done" once _sourceLoading[id] == false; then
  // it's an error (_sourceError[id]), a hit (_results[id] non-empty), or empty.
  final Map<String, List<MManga>> _results = {};
  final Map<String, bool> _sourceLoading = {};
  // Per-source failure reason to show in its row (null = no error). Holds the clean
  // source message (SourceError.toString()), e.g. "Open in WebView to set necessary cookies".
  final Map<String, String?> _sourceError = {};

  @override
  void initState() {
    super.initState();
    const allowedTypes = {'all', 'manga', 'anime', 'novel'};
    final type = widget.initialType;
    if (type != null && allowedTypes.contains(type)) {
      _typeFilter = type;
    }
    final initial = widget.initialQuery?.trim() ?? '';
    if (initial.isNotEmpty) {
      _searchController.text = initial;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _search(initial);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    // Backing out of a global search should stop the sources still grinding
    // through Cloudflare challenges — don't leave a batch of headless solvers
    // running for 30s each after the screen is gone.
    WebViewService().cancelPending();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    _focusNode.unfocus();

    final sourceProvider = context.read<SourceProvider>();
    final vaultProvider = context.read<VaultProvider>();
    var sources = sourceProvider.installedSources;

    // Honour the per-source "Skip in global search" option.
    sources = sources
        .where((s) => !SourceSettings.cached(s.source.id).excludeFromGlobalSearch)
        .toList();

    // Hide vault sources when not in vault mode.
    if (!vaultProvider.vaultActive) {
      sources =
          sources.where((s) => !vaultProvider.isSourceInVault(s.source.id)).toList();
    }

    // NSFW filter (Browse settings).
    if (!sourceProvider.showNsfw) {
      sources = sources.where((s) => !s.source.isNsfw).toList();
    }

    // Pinned-only filter for global search (Browse settings).
    if (sourceProvider.pinnedOnlyGlobalSearch) {
      final prefs = await SharedPreferences.getInstance();
      final pinned = (prefs.getStringList('pinned_source_ids') ?? []).toSet();
      sources = sources.where((s) => pinned.contains(s.source.id)).toList();
    }

    // Content-type filter (All / Manga / Anime / Novels).
    if (_typeFilter != 'all') {
      sources =
          sources.where((s) => s.source.itemType == _typeFilter).toList();
    }

    if (!mounted) return;
    setState(() {
      _hasSearched = true;
      _sources = sources;
      _results.clear();
      _sourceError.clear();
      _sourceLoading
        ..clear()
        ..addEntries(sources.map((s) => MapEntry(s.source.id, true)));
    });

    // Search every source (concurrent; iOS JS sources serialize internally).
    for (final source in sources) {
      _searchSource(source, query);
    }
  }

  Future<void> _searchSource(InstalledSource installed, String query) async {
    final id = installed.source.id;
    try {
      final result = await withExtensionService(
        installed.source,
        installed.sourceCode,
        (service) => service.search(query, 1, []),
      );
      // Approximate match: tolerant of word order / filler words / minor typos,
      // and drops sources that fall back to a popular listing for the query.
      final matched = approxFilterSearchResults(result.list, query);
      if (mounted) {
        setState(() {
          _results[id] = matched.take(12).toList();
          _sourceError[id] = null;
        });
      }
    } catch (e) {
      // e.toString() is the clean source message (see SourceError); show it in the row.
      if (mounted) setState(() => _sourceError[id] = e.toString());
    }
    if (mounted) setState(() => _sourceLoading[id] = false);
  }

  void _retrySource(InstalledSource installed) {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _sourceLoading[installed.source.id] = true;
      _sourceError[installed.source.id] = null;
    });
    _searchSource(installed, query);
  }

  void _clear() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _sources = [];
      _results.clear();
      _sourceLoading.clear();
      _sourceError.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final sourceProvider = context.watch<SourceProvider>();
    final sourceCount = sourceProvider.installedSources.length;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface, size: 22),
            onPressed: () => Navigator.pop(context)),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onSubmitted: _search,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            style: GoogleFonts.manrope(fontSize: 13, color: cs.onSurface),
            decoration: InputDecoration(
                isDense: true,
                hintText: t.browseSearchAllSourcesHint,
                hintStyle: GoogleFonts.manrope(fontSize: 13, color: cs.outline),
                prefixIcon: Icon(Icons.travel_explore_rounded,
                    size: 18, color: cs.primary),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, minHeight: 40),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (_, val, _) => val.text.isNotEmpty
                        ? GestureDetector(
                            onTap: _clear,
                            child: Icon(Icons.close_rounded,
                                size: 16, color: cs.outline))
                        : const SizedBox.shrink()),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4))),
        ),
        titleSpacing: 0,
        actions: const [SizedBox(width: 8)],
        bottom: _buildTypeFilterBar(cs),
      ),
      body: _buildBody(context, cs, sourceCount),
    );
  }

  /// Content-type scope chips under the search bar (All / Manga / Anime / Novels).
  PreferredSizeWidget _buildTypeFilterBar(ColorScheme cs) {
    const types = [
      ('all', 'All'),
      ('manga', 'Manga'),
      ('anime', 'Anime'),
      ('novel', 'Novels'),
    ];
    return PreferredSize(
      preferredSize: const Size.fromHeight(46),
      child: SizedBox(
        height: 46,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          children: [
            for (final (id, label) in types) ...[
              ChoiceChip(
                label: Text(label),
                selected: _typeFilter == id,
                onSelected: (_) => _onTypeFilterChanged(id),
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                labelStyle: GoogleFonts.manrope(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _typeFilter == id ? cs.onPrimary : cs.onSurface),
                selectedColor: cs.primary,
                backgroundColor: cs.surfaceContainerHighest,
                side: BorderSide(
                    color:
                        _typeFilter == id ? cs.primary : cs.outlineVariant),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  void _onTypeFilterChanged(String id) {
    if (_typeFilter == id) return;
    setState(() => _typeFilter = id);
    // Re-run the search with the new scope if there's an active query.
    final q = _searchController.text.trim();
    if (q.isNotEmpty) _search(q);
  }

  Widget _buildBody(BuildContext context, ColorScheme cs, int sourceCount) {
    final t = AppLocalizations.of(context);
    if (sourceCount == 0) {
      return _buildEmptyState(
          cs, t.browseNoSourcesInstalled, t.browseNoSourcesInstalledDesc);
    }

    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                    color: cs.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(Icons.travel_explore_rounded,
                    size: 36, color: cs.primary)),
            const SizedBox(height: 20),
            Text(t.browseSearchAllSources,
                style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface)),
            const SizedBox(height: 8),
            Text(t.browseSearchSourcesAtOnce(sourceCount),
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 13, color: cs.outline)),
          ]),
        ),
      );
    }

    return ListView(
      padding:
          EdgeInsets.only(bottom: 80 + MediaQuery.of(context).viewPadding.bottom),
      children: [
        for (final installed in _sources)
          _buildSourceSection(context, cs, t, installed),
      ],
    );
  }

  Widget _buildSourceSection(BuildContext context, ColorScheme cs,
      AppLocalizations t, InstalledSource installed) {
    final id = installed.source.id;
    final name = installed.source.name;
    final loading = _sourceLoading[id] ?? false;
    final error = _sourceError[id];
    final results = _results[id] ?? const <MManga>[];

    Widget stateWidget;
    if (loading) {
      stateWidget = const Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (error != null) {
      stateWidget = Padding(
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
        child: Row(children: [
          Icon(Icons.error_outline_rounded, size: 16, color: cs.outline),
          const SizedBox(width: 8),
          Expanded(
              child: Text(error.isEmpty ? t.globalSearchSourceFailed : error,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      GoogleFonts.manrope(fontSize: 12, color: cs.outline))),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => _retrySource(installed),
            style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
            child: Text(t.detailRetry,
                style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
          ),
        ]),
      );
    } else if (results.isEmpty) {
      stateWidget = Padding(
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
        child: Text(t.globalSearchSourceNoResults,
            style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
      );
    } else {
      stateWidget = SizedBox(
        height: 190,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemCount: results.length,
          itemBuilder: (_, i) {
            final manga = results[i];
            return _MangaCard(
              key: ValueKey('${id}_${manga.link ?? i}'),
              name: manga.name ?? '',
              coverUrl: manga.imageUrl ?? '',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.mangaDetail, arguments: {
                'mangaUrl': manga.link ?? '',
                'sourceId': id,
                'title': manga.name,
                'coverUrl': manga.imageUrl,
              }),
            );
          },
        ),
      );
    }

    return Column(
      key: ValueKey('src_$id'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 6),
          child: Row(children: [
            Expanded(
              child: Text(name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                      letterSpacing: 1.0)),
            ),
            if (results.isNotEmpty)
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.sourceCatalog, arguments: {
                  'sourceId': id,
                  'sourceName': name,
                  'searchQuery': _searchController.text.trim(),
                }),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(t.browseSeeAll,
                      style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: cs.primary)),
                  Icon(Icons.chevron_right_rounded, size: 16, color: cs.primary),
                ]),
              ),
          ]),
        ),
        stateWidget,
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme cs, String title, String subtitle) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.explore_off_rounded, size: 48, color: cs.outline),
      const SizedBox(height: 12),
      Text(title,
          style: GoogleFonts.manrope(
              fontSize: 15, fontWeight: FontWeight.w700, color: cs.onSurface)),
      const SizedBox(height: 6),
      Text(subtitle,
          style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
    ]));
  }
}

class _MangaCard extends StatelessWidget {
  final String name;
  final String coverUrl;
  final VoidCallback onTap;

  const _MangaCard(
      {super.key,
      required this.name,
      required this.coverUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          width: 100,
          child: Column(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: SizedBox(
                    width: 100,
                    height: 135,
                    child: coverUrl.isNotEmpty
                        ? MangaImage(imageUrl: coverUrl, fit: BoxFit.cover)
                        : Container(
                            color: cs.surfaceContainerHighest,
                            child:
                                Icon(Icons.image_rounded, color: cs.outline)))),
            const SizedBox(height: 4),
            Text(name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface)),
          ])),
    );
  }
}
