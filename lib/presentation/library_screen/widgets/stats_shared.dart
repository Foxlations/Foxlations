import 'package:flutter/material.dart';
import '../../../core/models/manga_model.dart';
import '../../../core/utils/url_utils.dart';
import '../../widgets/manga_image.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';

/// Shared building blocks for the Reading Insights redesign - used by both the
/// Library > Stats view and the standalone Podium screen so they read
/// identically. All user-facing copy here is intentionally plain English (draft).

/// The ordered content-type scopes and their toggle labels.
const List<(String, String)> kStatsTypes = [
  ('all', 'All'),
  ('manga', 'Manga'),
  ('anime', 'Anime'),
  ('novel', 'Novels'),
];

/// "Xh Ym" / "Xm" time string from whole seconds.
String statsTimeText(int seconds) {
  final mins = seconds ~/ 60;
  final h = mins ~/ 60;
  final m = mins % 60;
  return h > 0 ? '${h}h ${m}m' : '${m}m';
}

/// A coarse "how long ago" label from a timestamp - "today", "N days ago",
/// "N weeks ago", "N months ago", "N years ago". Used by the Backlog list.
String statsRelativeAge(DateTime d) {
  final days = DateTime.now().difference(d).inDays;
  if (days <= 0) return 'today';
  if (days < 7) return '$days ${days == 1 ? 'day' : 'days'} ago';
  if (days < 30) {
    final w = days ~/ 7;
    return '$w ${w == 1 ? 'week' : 'weeks'} ago';
  }
  if (days < 365) {
    final mo = days ~/ 30;
    return '$mo ${mo == 1 ? 'month' : 'months'} ago';
  }
  final y = days ~/ 365;
  return '$y ${y == 1 ? 'year' : 'years'} ago';
}

/// A big total-time display with the h/m units set smaller + muted.
Widget statsBigTime(
  BuildContext context, {
  required int seconds,
  required double numSize,
  required Color numColor,
  required Color unitColor,
}) {
  final mins = seconds ~/ 60;
  final h = mins ~/ 60;
  final m = mins % 60;
  final unitSize = numSize * 0.62;
  final unitStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: unitSize, fontWeight: FontWeight.w700, color: unitColor);
  final spans = <InlineSpan>[];
  if (h > 0) {
    spans
      ..add(TextSpan(text: '$h'))
      ..add(TextSpan(text: 'h ', style: unitStyle))
      ..add(TextSpan(text: '$m'))
      ..add(TextSpan(text: 'm', style: unitStyle));
  } else {
    spans
      ..add(TextSpan(text: '$m'))
      ..add(TextSpan(text: 'm', style: unitStyle));
  }
  return Text.rich(
    TextSpan(
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: numSize,
          fontWeight: FontWeight.w800,
          color: numColor,
          height: 1.05),
      children: spans,
    ),
  );
}

/// Full-width All / Manga / Anime / Novels segmented toggle.
class StatsTypeToggle extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;
  const StatsTypeToggle({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: kStatsTypes.map((e) {
          final selected = e.$1 == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.$1),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: selected ? cs.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Center(
                  child: Text(
                    e.$2,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected ? cs.onPrimary : cs.outline,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Uppercase section header with an optional trailing action (e.g. "See all ›").
class StatsSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const StatsSectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 20, 2, AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: cs.outline,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A small rounded accent pill used as a [StatsSectionHeader] trailing badge
/// (e.g. "12 waiting", "7 / 33 earned"). Fully themed via the color scheme.
class StatsPillBadge extends StatelessWidget {
  final String text;
  const StatsPillBadge(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: cs.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: cs.primary,
        ),
      ),
    );
  }
}

/// A ranked "cover · title · time" row used in the preview list and the
/// below-podium ranking.
class StatsTitleTimeRow extends StatelessWidget {
  final int rank;
  final LibraryManga manga;
  final int seconds;

  /// When true the rank number is muted (used below the podium, ranks 4+).
  final bool dim;

  const StatsTitleTimeRow({
    super.key,
    required this.rank,
    required this.manga,
    required this.seconds,
    this.dim = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: dim ? cs.outline : cs.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            child: manga.coverUrl.isNotEmpty
                ? MangaImage(
                    imageUrl: manga.coverUrl,
                    width: 30,
                    height: 40,
                    fit: BoxFit.cover,
                    referer: safeOrigin(manga.url),
                  )
                : Container(
                    width: 30,
                    height: 40,
                    color: cs.surface,
                    child: Icon(Icons.image_rounded, size: 14, color: cs.outline),
                  ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              manga.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: cs.onSurface),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            statsTimeText(seconds),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700, color: cs.outline),
          ),
        ],
      ),
    );
  }
}

/// One segment of a breakdown bar.
class StatsBarSegment {
  final String label;
  final int count;
  final Color color;
  const StatsBarSegment(this.label, this.count, this.color);
}

/// A horizontal segmented bar + wrapping legend (Manga/Anime/Novels by type, or
/// Reading/Completed/On hold/Other by status).
class StatsBreakdownCard extends StatelessWidget {
  final List<StatsBarSegment> segments;
  const StatsBreakdownCard({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = segments.fold<int>(0, (s, e) => s + e.count);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          child: SizedBox(
            height: 14,
            child: total == 0
                ? ColoredBox(color: cs.outlineVariant)
                : Row(
                    children: segments
                        .where((e) => e.count > 0)
                        .map((e) => Expanded(
                              flex: e.count,
                              child: ColoredBox(color: e.color),
                            ))
                        .toList(),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: segments.map((e) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                      color: e.color,
                      borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(width: 6),
                Text(
                  e.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: cs.outline),
                ),
                const SizedBox(width: 5),
                Text(
                  '${e.count}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
