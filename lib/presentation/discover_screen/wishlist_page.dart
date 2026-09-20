import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/manga_model.dart';
import '../../core/providers/discover_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../widgets/manga_image.dart';

/// "Saved for later" — recommendations kept until an installed source carries
/// them. Tap an entry to search your sources; if one is found it moves into the
/// library. Swipe to remove.
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Keys currently being matched against installed sources.
  final Set<String> _searching = {};

  Future<void> _findSource(LibraryManga entry) async {
    final t = AppLocalizations.of(context);
    final d = context.read<DiscoverProvider>();
    setState(() => _searching.add(entry.uniqueKey));
    final match = await d.findSourceForWishlist(entry);
    if (!mounted) return;
    setState(() => _searching.remove(entry.uniqueKey));
    if (match == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.discoverNoSourceYet)));
      return;
    }
    await d.addWishlistMatchToLibrary(entry, match);
    if (!mounted) return;
    final sourceId = match.source.source.id;
    final url = match.manga.link ?? '';
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(t.discoverAddedToLibrary),
      action: SnackBarAction(
        label: t.discoverRead,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.mangaDetail,
            arguments: {
              'mangaUrl': url,
              'sourceId': sourceId,
              'title': match.manga.name ?? entry.title,
              'coverUrl': match.manga.imageUrl ?? entry.coverUrl,
            }),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final d = context.watch<DiscoverProvider>();
    final items = d.wishlist;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(t.discoverWishlistTitle,
            style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_border_rounded,
                        size: 48, color: cs.outline),
                    const SizedBox(height: 12),
                    Text(t.discoverWishlistEmpty,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(t.discoverWishlistEmptyHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final entry = items[i];
                final busy = _searching.contains(entry.uniqueKey);
                return Dismissible(
                  key: ValueKey(entry.uniqueKey),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium)),
                    child: Icon(Icons.delete_outline_rounded,
                        color: cs.onErrorContainer),
                  ),
                  onDismissed: (_) => d.removeFromWishlist(entry.uniqueKey),
                  child: _WishlistTile(
                    entry: entry,
                    busy: busy,
                    onFindSource: () => _findSource(entry),
                  ),
                );
              },
            ),
    );
  }
}

class _WishlistTile extends StatelessWidget {
  final LibraryManga entry;
  final bool busy;
  final VoidCallback onFindSource;
  const _WishlistTile(
      {required this.entry, required this.busy, required this.onFindSource});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: busy ? null : onFindSource,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: SizedBox(
                  width: 46,
                  height: 64,
                  child: MangaImage(imageUrl: entry.coverUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    if (entry.genres.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(entry.genres.take(3).join(' • '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : TextButton(
                      onPressed: onFindSource,
                      child: Text(t.discoverFindSource),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
