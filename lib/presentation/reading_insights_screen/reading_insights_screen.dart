import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/manga_model.dart';
import '../../core/providers/library_provider.dart';
import '../../core/providers/vault_provider.dart';
import '../../core/providers/source_provider.dart';
import '../../core/utils/url_utils.dart';
import '../../theme/app_theme.dart';
import '../widgets/manga_image.dart';
import '../library_screen/widgets/stats_shared.dart';
import '../../l10n/app_localizations.dart';

/// The Podium - a focused ranking of the library (or vault) by total time
/// read/watched. Opened from the Stats page's total-time hero and "See all".
/// Carries the same All / Manga / Anime / Novels scope toggle as the Stats page.
class ReadingInsightsScreen extends StatefulWidget {
  final bool isVault;
  final String? initialType;

  const ReadingInsightsScreen({
    super.key,
    this.isVault = false,
    this.initialType,
  });

  @override
  State<ReadingInsightsScreen> createState() => _ReadingInsightsScreenState();
}

class _ReadingInsightsScreenState extends State<ReadingInsightsScreen> {
  late String _type;

  @override
  void initState() {
    super.initState();
    final init = widget.initialType;
    _type = (init != null && kStatsTypes.any((e) => e.$1 == init)) ? init : 'all';
  }

  List<String> _monthNames(AppLocalizations t) => [
    t.insightsMonthJanuary, t.insightsMonthFebruary, t.insightsMonthMarch,
    t.insightsMonthApril, t.insightsMonthMay, t.insightsMonthJune,
    t.insightsMonthJuly, t.insightsMonthAugust, t.insightsMonthSeptember,
    t.insightsMonthOctober, t.insightsMonthNovember, t.insightsMonthDecember,
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    // Rebuild on the active provider so a live time update reflects here.
    if (widget.isVault) {
      context.watch<VaultProvider>();
    } else {
      context.watch<LibraryProvider>();
    }
    final all = widget.isVault
        ? context.read<VaultProvider>().manga
        : context.read<LibraryProvider>().manga;
    final sp = context.read<SourceProvider>();

    final list = (_type == 'all'
        ? all.toList()
        : all
            .where((m) =>
                m.contentTypeOr(sp.installedItemType(m.sourceId)) == _type)
            .toList())
      ..sort((a, b) => b.timeSpentSeconds.compareTo(a.timeSpentSeconds));

    final totalSeconds = list.fold<int>(0, (s, m) => s + m.timeSpentSeconds);

    // "Tracked since <Month Year>" from the earliest entry, else a soft fallback.
    DateTime? earliest;
    for (final m in list) {
      if (earliest == null || m.addedAt.isBefore(earliest)) earliest = m.addedAt;
    }
    final since = earliest == null
        ? t.insightsEstimatedFromHistory
        : t.insightsTrackedSince(
            _monthNames(t)[earliest.month - 1], '${earliest.year}');

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(t.insightsTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18, fontWeight: FontWeight.w800, color: cs.onSurface)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
          children: [
            StatsTypeToggle(
                current: _type, onChanged: (t) => setState(() => _type = t)),
            const SizedBox(height: 18),
            if (list.isEmpty)
              _empty(cs)
            else ...[
              Center(
                child: statsBigTime(context,
                    seconds: totalSeconds,
                    numSize: 42,
                    numColor: cs.onSurface,
                    unitColor: cs.outline),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(since,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.outline)),
              ),
              const SizedBox(height: 18),
              _Podium(top: list.take(3).toList()),
              const SizedBox(height: 8),
              ...list.skip(3).toList().asMap().entries.map((e) => StatsTitleTimeRow(
                    rank: e.key + 4,
                    manga: e.value,
                    seconds: e.value.timeSpentSeconds,
                    dim: true,
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _empty(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.emoji_events_outlined, size: 56, color: cs.outlineVariant),
            const SizedBox(height: 14),
            Text(t.insightsEmptyTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface)),
            const SizedBox(height: 6),
            Text(t.insightsEmptyBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.outline)),
          ],
        ),
      );
  }
}

// ── Podium (top 3) ───────────────────────────────────────────────
class _Podium extends StatelessWidget {
  final List<LibraryManga> top;
  const _Podium({required this.top});

  @override
  Widget build(BuildContext context) {
    // Layout order: 2nd (left, shorter), 1st (centre, tallest), 3rd (right).
    final slots = <(int, double)>[];
    if (top.length > 1) slots.add((1, 88));
    slots.add((0, 108));
    if (top.length > 2) slots.add((2, 78));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: slots.map((s) {
        final idx = s.$1;
        if (idx >= top.length) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: _PodiumCol(
            manga: top[idx],
            rank: idx + 1,
            coverHeight: s.$2,
          ),
        );
      }).toList(),
    );
  }
}

class _PodiumCol extends StatelessWidget {
  final LibraryManga manga;
  final int rank;
  final double coverHeight;
  const _PodiumCol({
    required this.manga,
    required this.rank,
    required this.coverHeight,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const coverWidth = 74.0;
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          SizedBox(
            width: coverWidth,
            height: coverHeight + 10,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  child: manga.coverUrl.isNotEmpty
                      ? MangaImage(
                          imageUrl: manga.coverUrl,
                          width: coverWidth,
                          height: coverHeight,
                          fit: BoxFit.cover,
                          referer: safeOrigin(manga.url),
                        )
                      : Container(
                          width: coverWidth,
                          height: coverHeight,
                          color: cs.surfaceContainerHighest,
                          child: Icon(Icons.image_rounded,
                              color: cs.outline, size: 20),
                        ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.surface, width: 2),
                    ),
                    child: Center(
                      child: Text('$rank',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onPrimary)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            manga.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700, color: cs.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            statsTimeText(manga.timeSpentSeconds),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 11.5, fontWeight: FontWeight.w800, color: cs.primary),
          ),
        ],
      ),
    );
  }
}
