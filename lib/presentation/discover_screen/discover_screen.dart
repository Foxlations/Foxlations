import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/discovery/discovery_models.dart';
import '../../core/providers/discover_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../widgets/manga_image.dart';
import '../widgets/type_toggle.dart';
import 'wishlist_page.dart';

/// The Discover tab - a recommendation deck. One card at a time; Next pulls a
/// fresh pick. Add to Library when an installed source carries it, otherwise
/// Save for later. Feeds are per content type (Manga / Anime / Novels).
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final d = context.watch<DiscoverProvider>();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(t.discoverTitle,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          // Tracker switcher - only when there's a real choice (a second source
          // beyond the always-on public AniList, i.e. the user signed in).
          if (d.canSwitchSource)
            PopupMenuButton<String>(
              tooltip: t.discoverSource,
              onSelected: d.setSource,
              itemBuilder: (_) => d.availableSources
                  .map((s) => PopupMenuItem(
                        value: s.discoveryId,
                        child: Row(
                          children: [
                            Icon(
                              s.discoveryId == d.activeSourceId
                                  ? Icons.check_rounded
                                  : Icons.circle_outlined,
                              size: 18,
                              color: s.discoveryId == d.activeSourceId
                                  ? cs.primary
                                  : cs.outline,
                            ),
                            const SizedBox(width: 8),
                            Text(s.discoveryName),
                          ],
                        ),
                      ))
                  .toList(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(d.activeSource?.discoveryName ?? '',
                        style: TextStyle(
                            color: cs.primary, fontWeight: FontWeight.w700)),
                    Icon(Icons.arrow_drop_down_rounded, color: cs.primary),
                  ],
                ),
              ),
            ),
          // Sort: Trending / Popular.
          PopupMenuButton<DiscoverSort>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: t.discoverSort,
            initialValue: d.sort,
            onSelected: d.setSort,
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: DiscoverSort.trending,
                  child: Text(t.discoverSortTrending)),
              PopupMenuItem(
                  value: DiscoverSort.popular,
                  child: Text(t.discoverSortPopular)),
            ],
          ),
          // Saved for later (wishlist), with a count badge.
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                tooltip: t.discoverWishlistTitle,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const WishlistPage())),
              ),
              if (d.wishlistCount > 0)
                PositionedDirectional(
                  end: 4,
                  top: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                        d.wishlistCount > 99 ? '99+' : '${d.wishlistCount}',
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          _KindSelector(current: d.kind, onChanged: d.setKind),
          if (d.supportsGenreFilter && d.availableGenres.isNotEmpty)
            _GenreBar(provider: d),
          Expanded(child: _DeckArea(provider: d)),
          _ActionBar(provider: d),
        ],
      ),
    );
  }
}

/// Manga / Anime / Novels switcher.
class _KindSelector extends StatelessWidget {
  final DiscoverKind current;
  final ValueChanged<DiscoverKind> onChanged;
  const _KindSelector({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    String label(DiscoverKind k) {
      switch (k) {
        case DiscoverKind.manga:
          return t.discoverKindManga;
        case DiscoverKind.anime:
          return t.discoverKindAnime;
        case DiscoverKind.novel:
          return t.discoverKindNovel;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: TypeToggle(
        items: DiscoverKind.values
            .map((k) => TypeToggleItem(k.wire, label(k)))
            .toList(),
        selectedId: current.wire,
        onChanged: (id) =>
            onChanged(DiscoverKind.values.firstWhere((k) => k.wire == id)),
      ),
    );
  }
}

/// Genre filter as an expand-in-place pill: collapsed it's a single "Genres"
/// capsule with an active count; tapping it grows the capsule and reveals the
/// genre options inside, scrolling sideways (custom pills, not Material chips).
class _GenreBar extends StatefulWidget {
  final DiscoverProvider provider;
  const _GenreBar({required this.provider});

  @override
  State<_GenreBar> createState() => _GenreBarState();
}

class _GenreBarState extends State<_GenreBar> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = widget.provider;
    final count = provider.genreFilter.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeOutCubic,
            height: 38,
            width: _open ? constraints.maxWidth : 138,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: _open
                  ? cs.primary.withValues(alpha: 0.12)
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _open ? cs.primary : cs.outlineVariant,
                width: _open ? 1.3 : 1,
              ),
            ),
            child: Row(
              children: [
                // The icon toggles the pill open/closed.
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => setState(() => _open = !_open),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 0, 7, 0),
                    child: Icon(Icons.tune_rounded,
                        size: 18,
                        color: _open ? cs.primary : cs.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(-0.06, 0), end: Offset.zero)
                            .animate(anim),
                        child: child,
                      ),
                    ),
                    child: _open
                        ? _chips(cs, provider)
                        : _collapsedLabel(cs, count),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _collapsedLabel(ColorScheme cs, int count) {
    final t = AppLocalizations.of(context);
    return GestureDetector(
      key: const ValueKey('closed'),
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _open = true),
      child: Row(
        children: [
          Text(t.discoverGenres,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface)),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                  color: cs.primary, borderRadius: BorderRadius.circular(999)),
              child: Text('$count',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: cs.onPrimary)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chips(ColorScheme cs, DiscoverProvider provider) {
    final list = ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 2, right: 10),
      children: [
        for (final g in provider.availableGenres) ...[
          _chip(cs, g, provider.genreFilter.contains(g),
              () => provider.toggleGenre(g)),
          const SizedBox(width: 6),
        ],
        if (provider.genreFilter.isNotEmpty)
          Center(
            child: TextButton(
              onPressed: provider.clearGenres,
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text(AppLocalizations.of(context).discoverClearGenres,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary)),
            ),
          ),
      ],
    );
    // Fade the chips out at both ends instead of hard-cutting them against the
    // capsule's rounded edges as they scroll.
    return ShaderMask(
      key: const ValueKey('open'),
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.black,
          Colors.black,
          Colors.transparent
        ],
        stops: [0.0, 0.04, 0.95, 1.0],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: list,
    );
  }

  Widget _chip(ColorScheme cs, String g, bool on, VoidCallback onTap) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: on ? cs.primary : cs.surface,
            borderRadius: BorderRadius.circular(999),
            border:
                Border.all(color: on ? Colors.transparent : cs.outlineVariant),
          ),
          child: Text(g,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: on ? cs.onPrimary : cs.onSurfaceVariant)),
        ),
      ),
    );
  }
}

/// The card area: loading spinner, empty state, or the current recommendation.
class _DeckArea extends StatelessWidget {
  final DiscoverProvider provider;
  const _DeckArea({required this.provider});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final item = provider.current;

    if (item == null) {
      if (provider.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      // Empty / exhausted.
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_outlined, size: 48, color: cs.outline),
              const SizedBox(height: 12),
              Text(t.discoverEmpty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(t.discoverEmptyHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant)),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => provider.setKind(provider.kind, force: true),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(t.discoverRetry),
              ),
            ],
          ),
        ),
      );
    }

    return _DiscoverCard(item: item);
  }
}

class _DiscoverCard extends StatelessWidget {
  final DiscoverItem item;
  const _DiscoverCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    // A fresh card per title so the cover image resets. The cover fills the whole
    // card; title / genres / synopsis sit over a bottom scrim so there's no dead
    // space regardless of how much text a title has.
    return Padding(
      key: ValueKey(item.dedupeKey),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: cs.surfaceContainerHighest),
            MangaImage(imageUrl: item.coverUrl, fit: BoxFit.cover),
            // Bottom scrim so overlaid text stays legible over any cover.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black],
                  stops: [0.35, 0.82, 1.0],
                ),
              ),
            ),
            // Score badge.
            if (item.score > 0)
              PositionedDirectional(
                top: 12,
                start: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 15, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(item.score.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ),
            // Text overlay.
            PositionedDirectional(
              start: 18,
              end: 18,
              bottom: 18,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.reason != null && item.reason!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              t.discoverBecauseYouRead(item.reason!),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 21,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  if (item.genres.isNotEmpty) ...[
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: item.genres.take(3).map((g) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(g,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                    ),
                  ],
                  if (item.summary.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(item.summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: Colors.white70)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Save / Add buttons + the prominent Next button.
class _ActionBar extends StatelessWidget {
  final DiscoverProvider provider;
  const _ActionBar({required this.provider});

  Future<void> _add(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final match = provider.match;
    final ok = await provider.addCurrentToLibrary();
    if (!context.mounted) return;
    if (ok && match != null) {
      final sourceId = match.source.source.id;
      final url = match.manga.link ?? '';
      final title = match.manga.name ?? '';
      final cover = match.manga.imageUrl ?? '';
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.discoverAddedToLibrary),
        action: SnackBarAction(
          label: t.discoverRead,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.mangaDetail,
              arguments: {
                'mangaUrl': url,
                'sourceId': sourceId,
                'title': title,
                'coverUrl': cover,
              }),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final hasCard = provider.current != null;
    final added = provider.currentAdded;
    final saved = provider.currentSaved;

    // Add button state.
    Widget addLabel;
    VoidCallback? onAdd;
    if (added) {
      addLabel = Text(t.discoverAdded);
    } else if (provider.matching) {
      addLabel = Text(t.discoverFindingSource);
    } else if (provider.canAddToLibrary) {
      addLabel = Text(t.discoverAddToLibrary);
      onAdd = () => _add(context);
    } else {
      addLabel = Text(t.discoverNoSourceMatch);
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: !hasCard || saved
                        ? null
                        : () => provider.saveCurrentForLater(),
                    icon: Icon(saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded),
                    label: Text(saved
                        ? t.discoverSaved
                        : t.discoverSaveForLater),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onAdd,
                    icon: added
                        ? const Icon(Icons.check_rounded)
                        : provider.matching
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.add_rounded),
                    label: addLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: provider.loading ? null : () => provider.next(),
                icon: const Icon(Icons.skip_next_rounded),
                label: Text(t.discoverNext,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
