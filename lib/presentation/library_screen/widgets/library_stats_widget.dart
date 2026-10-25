import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/models/manga_model.dart';
import '../../../core/providers/library_provider.dart';
import '../../../core/providers/vault_provider.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/utils/url_utils.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/manga_image.dart';
import 'stats_shared.dart';

/// The Library > Stats view. A single scrollable "Reading Insights" page with an
/// in-page All / Manga / Anime / Novels toggle that rescopes every stat (this
/// replaces relying on the Library tab's current content type), a tappable
/// total-time hero that opens the Podium, stat tiles, a GitHub-style activity
/// heatmap, a library breakdown bar and a most-read-by-time preview.
class LibraryStatsWidget extends StatefulWidget {
  const LibraryStatsWidget({super.key});

  @override
  State<LibraryStatsWidget> createState() => _LibraryStatsWidgetState();
}

class _LibraryStatsWidgetState extends State<LibraryStatsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // In-page content-type scope. 'all' shows everything; the others filter by the
  // entry's own contentType (null → 'manga'). Independent of the Library tab's
  // type so the user can inspect any slice without leaving the stats view.
  String _statsType = 'all';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVault = context.watch<VaultProvider>().vaultActive;

    if (isVault) {
      return Consumer<VaultProvider>(
        builder: (_, vault, _) => _StatsContent(
          allManga: vault.manga,
          statsType: _statsType,
          onTypeChanged: (t) => setState(() => _statsType = t),
          fadeAnim: _fadeAnim,
          isVault: true,
        ),
      );
    }

    return Consumer<LibraryProvider>(
      builder: (_, library, _) => _StatsContent(
        allManga: library.manga,
        statsType: _statsType,
        onTypeChanged: (t) => setState(() => _statsType = t),
        fadeAnim: _fadeAnim,
        isVault: false,
      ),
    );
  }
}

class _StatsContent extends StatelessWidget {
  /// The active provider's FULL list - the content-type filter is applied here,
  /// inside the widget, from [statsType].
  final List<LibraryManga> allManga;
  final String statsType;
  final ValueChanged<String> onTypeChanged;
  final Animation<double> fadeAnim;
  final bool isVault;

  const _StatsContent({
    required this.allManga,
    required this.statsType,
    required this.onTypeChanged,
    required this.fadeAnim,
    required this.isVault,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final sp = context.read<SourceProvider>();

    // Scope to the chosen content type. When an entry never stored one, resolve
    // from its source's itemType so older anime/novel entries aren't counted as
    // manga.
    final List<LibraryManga> list = statsType == 'all'
        ? allManga
        : allManga
            .where((m) =>
                m.contentTypeOr(sp.installedItemType(m.sourceId)) == statsType)
            .toList();

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isVault)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(Icons.shield_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(t.libraryVaultStats,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.primary)),
              ],
            ),
          ),
        StatsTypeToggle(current: statsType, onChanged: onTypeChanged),
      ],
    );

    if (list.isEmpty) {
      return FadeTransition(
        opacity: fadeAnim,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            header,
            const SizedBox(height: 40),
            _EmptyStatsView(isVault: isVault, contentType: statsType),
          ],
        ),
      );
    }

    // The gamified stats count only chapters ACTIVELY read in-app (reaching the
    // end in the reader/player), NOT every chapter marked read - so a bulk
    // "mark all" no longer inflates chapters-read, milestones, personality,
    // streak or the heatmap. (Library progress/unread badges still use the full
    // read tally; that's unchanged.)
    final libraryP = context.read<LibraryProvider>();
    final vaultP = isVault ? context.read<VaultProvider>() : null;
    int readOf(LibraryManga m) => isVault
        ? vaultP!.activeReadCountForManga(m)
        : libraryP.activeReadCountForManga(m);

    final sourceIds = list.map((m) => m.sourceId).toSet();

    final totalSeconds = list.fold<int>(0, (s, m) => s + m.timeSpentSeconds);
    final titles = list.length;
    final completed = list
        .where((m) => m.status.toLowerCase() == 'completed')
        .length;
    final chaptersRead = list.fold<int>(0, (s, m) => s + readOf(m));

    final int currentStreak;
    final Map<DateTime, int> activity;
    if (isVault) {
      final vault = context.read<VaultProvider>();
      currentStreak = vault.getCurrentReadingStreak(sourceIds: sourceIds);
      activity = vault.getReadActivityByDay(days: 77, sourceIds: sourceIds);
    } else {
      currentStreak = libraryP.getCurrentReadingStreak(sourceIds: sourceIds);
      activity = libraryP.getReadActivityByDay(days: 77, sourceIds: sourceIds);
    }

    // Longest run of consecutive days with any reading inside the 77-day
    // activity window (that window is the hard cap - so no streak milestone
    // above 30 is defined).
    int longestStreak = 0;
    {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      var run = 0;
      for (var i = 0; i < 77; i++) {
        final day = today.subtract(Duration(days: i));
        final c = activity[DateTime(day.year, day.month, day.day)] ?? 0;
        if (c > 0) {
          run++;
          if (run > longestStreak) longestStreak = run;
        } else {
          run = 0;
        }
      }
    }

    // Per-type chapter/episode tallies + how many distinct formats are in play.
    final hours = totalSeconds ~/ 3600;
    var mangaCh = 0, animeEp = 0, novelCh = 0;
    final typesStarted = <String>{};
    final typesAll = <String>{};
    for (final m in list) {
      final type = m.contentTypeOr(sp.installedItemType(m.sourceId));
      final read = readOf(m);
      switch (type) {
        case 'anime':
          animeEp += read;
          break;
        case 'novel':
          novelCh += read;
          break;
        default:
          mangaCh += read;
      }
      typesAll.add(type);
      if (read > 0) typesStarted.add(type);
    }
    const kFormats = {'manga', 'anime', 'novel'};
    final formatsPresent =
        (typesStarted.isNotEmpty ? typesStarted : typesAll)
            .where(kFormats.contains)
            .length;
    final titlesStarted = list.where((m) => readOf(m) > 0).length;

    // Most-read genre (weighted by chapters read + 1 so an unread title still
    // counts its presence but read titles dominate). Skipped when empty.
    final genreWeight = <String, int>{};
    for (final m in list) {
      final w = readOf(m) + 1;
      for (final g in m.genres) {
        if (g.trim().isEmpty) continue;
        genreWeight[g] = (genreWeight[g] ?? 0) + w;
      }
    }
    String? topGenre;
    if (genreWeight.isNotEmpty) {
      topGenre = (genreWeight.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value)))
          .first
          .key;
    }

    // ── Backlog: added but never started, oldest first (up to 6 shown). ──
    final backlog = list.where((m) => readOf(m) == 0).toList()
      ..sort((a, b) => a.addedAt.compareTo(b.addedAt));
    final backlogShown = backlog.take(6).toList();

    // ── Milestones: data-driven badge roster from in-scope counts. ──
    final badges = _milestoneBadges(
      t,
      chaptersRead: chaptersRead,
      hours: hours,
      longestStreak: longestStreak,
      titles: list.length,
      sources: sourceIds.length,
      formatsPresent: formatsPresent,
      mangaCh: mangaCh,
      animeEp: animeEp,
      novelCh: novelCh,
    );
    final earnedBadges = badges.where((b) => b.earned).toList()
      ..sort((a, b) => b.target.compareTo(a.target));
    final lockedBadges = badges.where((b) => !b.earned).toList()
      ..sort((a, b) => b.ratio.compareTo(a.ratio));
    final orderedBadges = [...earnedBadges, ...lockedBadges];
    final nextUp = lockedBadges.isNotEmpty ? lockedBadges.first : null;

    // ── Reading personality: five 0..1 axes → one archetype. ──
    final axisVolume = (chaptersRead / 1000).clamp(0.0, 1.0);
    final axisDepth =
        ((chaptersRead / math.max(1, titlesStarted)) / 50).clamp(0.0, 1.0);
    final axisConsistency = (longestStreak / 30).clamp(0.0, 1.0);
    final axisBreadth = (titlesStarted / 50).clamp(0.0, 1.0);
    final axisVariety = (formatsPresent / 3).clamp(0.0, 1.0);

    String archName, archDesc;
    if (titlesStarted == 0) {
      archName = t.libraryArchetypeNewcomer;
      archDesc = t.libraryArchetypeNewcomerDesc;
    } else if (axisVariety >= 0.66 &&
        axisVariety >=
            math.max(math.max(axisVolume, axisDepth),
                math.max(axisConsistency, axisBreadth))) {
      archName = t.libraryArchetypeOmnivore;
      archDesc = t.libraryArchetypeOmnivoreDesc;
    } else {
      final cands = <(String, String, double)>[
        (t.libraryArchetypeBinger, t.libraryArchetypeBingerDesc, axisVolume),
        (t.libraryArchetypeCompletionist,
            t.libraryArchetypeCompletionistDesc, axisDepth),
        (t.libraryArchetypeDevoted, t.libraryArchetypeDevotedDesc,
            axisConsistency),
        (t.libraryArchetypeExplorer, t.libraryArchetypeExplorerDesc,
            axisBreadth),
      ];
      var best = cands.first;
      for (final c in cands) {
        if (c.$3 > best.$3) best = c;
      }
      archName = best.$1;
      archDesc = best.$2;
    }
    final personalityChips = <String>[
      t.libraryChaptersCount(chaptersRead),
      longestStreak > 0
          ? t.libraryBestStreakDays(longestStreak)
          : t.librarySeriesCount(titlesStarted),
    ];

    void openDetail(LibraryManga m) {
      Navigator.pushNamed(context, AppRoutes.mangaDetail, arguments: {
        'isVault': isVault,
        'mangaUrl': m.url,
        'sourceId': m.sourceId,
        'title': m.title,
        'coverUrl': m.coverUrl,
      });
    }

    void openPodium() {
      Navigator.pushNamed(context, AppRoutes.readingInsights, arguments: {
        'isVault': isVault,
        'contentType': statsType,
      });
    }

    return FadeTransition(
      opacity: fadeAnim,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          header,
          const SizedBox(height: 14),
          // (1) Total-time hero - tap → Podium.
          _HeroTotalTime(seconds: totalSeconds, onTap: openPodium),
          const SizedBox(height: 12),
          // (2) 2×2 tile grid.
          _TileGrid(
            titles: titles,
            completed: completed,
            chaptersRead: chaptersRead,
            streak: currentStreak,
          ),
          // (3) Reading activity heatmap.
          StatsSectionHeader(t.libraryReadingActivity),
          Text(t.libraryChaptersPerDayHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
          const SizedBox(height: 10),
          _ActivityHeatmap(activity: activity),
          // (4) Library breakdown.
          if (statsType == 'all') ...[
            StatsSectionHeader(t.libraryByType),
            _TypeBreakdown(list: list),
          ] else ...[
            StatsSectionHeader(t.libraryByStatus),
            _StatusBreakdown(list: list),
          ],
          // (5) Most-read genre.
          if (topGenre != null) ...[
            const SizedBox(height: 14),
            _GenreChip(genre: topGenre),
          ],
          // (6) Backlog - added but never started.
          StatsSectionHeader(t.libraryBacklog,
              trailing: StatsPillBadge(t.libraryWaitingCount(backlog.length))),
          Text(t.libraryAddedNeverStarted,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
          const SizedBox(height: 8),
          if (backlogShown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(t.libraryNothingWaiting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: cs.outline)),
            )
          else
            ...backlogShown.map((m) => _BacklogRow(
                  manga: m,
                  typeLabel: m.contentTypeOr(sp.installedItemType(m.sourceId)),
                  onOpen: () => openDetail(m),
                )),
          // (7) Milestones.
          StatsSectionHeader(t.libraryMilestones,
              trailing: StatsPillBadge(
                  '${earnedBadges.length} / ${badges.length}')),
          _MilestonesCard(badges: orderedBadges, nextUp: nextUp),
          // (8) Reading personality.
          StatsSectionHeader(t.libraryReadingPersonality),
          _PersonalityCard(
            archetype: archName,
            description: archDesc,
            axes: [
              axisVolume,
              axisDepth,
              axisConsistency,
              axisBreadth,
              axisVariety,
            ],
            chips: personalityChips,
          ),
        ],
      ),
    );
  }
}

// ── Total-time hero ──────────────────────────────────────────────
class _HeroTotalTime extends StatelessWidget {
  final int seconds;
  final VoidCallback onTap;
  const _HeroTotalTime({required this.seconds, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primary.withAlpha(46), cs.primary.withAlpha(15)],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(color: cs.primary.withAlpha(77)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(Icons.timer_rounded, size: 22, color: cs.onPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  statsBigTime(context,
                      seconds: seconds,
                      numSize: 28,
                      numColor: cs.onSurface,
                      unitColor: cs.outline),
                  const SizedBox(height: 2),
                  Text(t.libraryTotalTimeRead,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: cs.outline)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

// ── 2×2 tile grid ────────────────────────────────────────────────
class _TileGrid extends StatelessWidget {
  final int titles;
  final int completed;
  final int chaptersRead;
  final int streak;
  const _TileGrid({
    required this.titles,
    required this.completed,
    required this.chaptersRead,
    required this.streak,
  });

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Column(
      children: [
        Row(children: [
          Expanded(child: _Tile(value: '$titles', label: t.libraryStatTitles)),
          const SizedBox(width: 9),
          Expanded(child: _Tile(value: '$completed', label: t.libraryCompleted)),
        ]),
        const SizedBox(height: 9),
        Row(children: [
          Expanded(
              child: _Tile(
                  value: _fmt(chaptersRead), label: t.libraryStatChaptersRead)),
          const SizedBox(width: 9),
          Expanded(
              child: _Tile(
                  value: '$streak', label: t.libraryStatDayStreak, fire: true)),
        ]),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String value;
  final String label;
  final bool fire;
  const _Tile({required this.value, required this.label, this.fire = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (fire) ...[
                const Text('🔥', style: TextStyle(fontSize: 15)),
                const SizedBox(width: 4),
              ],
              Text(value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface)),
            ],
          ),
          const SizedBox(height: 3),
          Text(label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600, color: cs.outline)),
        ],
      ),
    );
  }
}

// ── Activity heatmap (GitHub-style) ──────────────────────────────
class _ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> activity;
  const _ActivityHeatmap({required this.activity});

  static const int _weeks = 11;

  Color _cell(int count, ColorScheme cs) {
    if (count <= 0) return cs.outlineVariant;
    if (count <= 2) return cs.primary.withAlpha(77);
    if (count <= 5) return cs.primary.withAlpha(140);
    if (count <= 10) return cs.primary.withAlpha(204);
    return cs.primary;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Columns are weeks (oldest → newest), rows are weekdays (Mon → Sun). The
    // last column holds today; anchor the grid to the Sunday on/after today.
    final endSunday = today.add(Duration(days: 7 - today.weekday));
    final start = endSunday.subtract(const Duration(days: _weeks * 7 - 1));

    int countAt(DateTime d) => activity[DateTime(d.year, d.month, d.day)] ?? 0;

    // ── Summary / trend over the activity map ──
    int activeDays35 = 0;
    for (int i = 0; i < 35; i++) {
      if (countAt(today.subtract(Duration(days: i))) > 0) activeDays35++;
    }
    int thisWeek = 0, lastWeek = 0;
    for (int i = 0; i < 7; i++) {
      thisWeek += countAt(today.subtract(Duration(days: i)));
    }
    for (int i = 7; i < 14; i++) {
      lastWeek += countAt(today.subtract(Duration(days: i)));
    }
    int? trendPct;
    if (lastWeek > 0) {
      trendPct = (((thisWeek - lastWeek) / lastWeek) * 100).round();
    }

    const dayLabels = ['M', '', 'W', '', 'F', '', ''];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (ctx, c) {
            const labelW = 14.0;
            const gap = 3.0;
            final avail = c.maxWidth - labelW - gap;
            final cell = ((avail - (_weeks - 1) * gap) / _weeks)
                .clamp(6.0, 22.0)
                .toDouble();

            Widget vcell(Widget child, {bool last = false}) => Padding(
                  padding: EdgeInsets.only(bottom: last ? 0 : gap),
                  child: SizedBox(height: cell, child: child),
                );

            // Day-label column.
            final labelCol = SizedBox(
              width: labelW,
              child: Column(
                children: List.generate(
                    7,
                    (r) => vcell(
                          last: r == 6,
                          Center(
                            child: Text(dayLabels[r],
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: cs.outline)),
                          ),
                        )),
              ),
            );

            // Week columns.
            final cols = List.generate(_weeks, (w) {
              return Padding(
                padding: EdgeInsets.only(right: w == _weeks - 1 ? 0 : gap),
                child: SizedBox(
                  width: cell,
                  child: Column(
                    children: List.generate(7, (r) {
                      final date = start.add(Duration(days: w * 7 + r));
                      final future = date.isAfter(today);
                      return vcell(
                        last: r == 6,
                        Container(
                          decoration: BoxDecoration(
                            color: future
                                ? Colors.transparent
                                : _cell(countAt(date), cs),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            });

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [labelCol, const SizedBox(width: gap), ...cols],
            );
          }),
          const SizedBox(height: 8),
          // Less → More legend.
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(t.libraryHeatmapLess,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10.5, fontWeight: FontWeight.w400, color: cs.outline)),
              const SizedBox(width: 5),
              ...[0, 2, 5, 10, 20].map((v) => Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: _cell(v, cs),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )),
              const SizedBox(width: 5),
              Text(t.libraryHeatmapMore,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10.5, fontWeight: FontWeight.w400, color: cs.outline)),
            ],
          ),
          const SizedBox(height: 10),
          // Summary.
          Text(
            t.libraryActivitySummary(activeDays35, thisWeek),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.5, fontWeight: FontWeight.w600, color: cs.onSurface),
          ),
          if (trendPct != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                    trendPct >= 0
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 13,
                    color: trendPct >= 0 ? AppTheme.success : cs.outline),
                const SizedBox(width: 3),
                Text(t.libraryTrendVsLastWeek(trendPct.abs()),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: trendPct >= 0 ? AppTheme.success : cs.outline)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Library-by-type breakdown (All mode) ─────────────────────────
class _TypeBreakdown extends StatelessWidget {
  final List<LibraryManga> list;
  const _TypeBreakdown({required this.list});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final sp = context.read<SourceProvider>();
    var manga = 0, anime = 0, novel = 0;
    for (final m in list) {
      switch (m.contentTypeOr(sp.installedItemType(m.sourceId))) {
        case 'anime':
          anime++;
          break;
        case 'novel':
          novel++;
          break;
        default:
          manga++;
      }
    }
    final segments = <StatsBarSegment>[
      StatsBarSegment(t.discoverKindManga, manga, cs.primary),
      StatsBarSegment(t.discoverKindAnime, anime, AppTheme.secondary),
      StatsBarSegment(t.discoverKindNovel, novel, const Color(0xFF9333EA)),
    ];
    return StatsBreakdownCard(segments: segments);
  }
}

// ── Library-by-status breakdown (single type) ────────────────────
class _StatusBreakdown extends StatelessWidget {
  final List<LibraryManga> list;
  const _StatusBreakdown({required this.list});

  /// Bucket the source's publication status into the four display groups.
  static String _bucket(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'ongoing':
      case 'reading':
      case 'releasing':
        return 'Reading';
      case 'hiatus':
      case 'on hold':
        return 'On hold';
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final counts = <String, int>{'Reading': 0, 'Completed': 0, 'On hold': 0, 'Other': 0};
    for (final m in list) {
      counts[_bucket(m.status)] = (counts[_bucket(m.status)] ?? 0) + 1;
    }
    final segments = <StatsBarSegment>[
      StatsBarSegment(t.libraryStatusReading, counts['Reading']!, const Color(0xFF5F86A8)),
      StatsBarSegment(t.libraryStatusCompleted, counts['Completed']!, AppTheme.success),
      StatsBarSegment(t.libraryStatusOnHold, counts['On hold']!, AppTheme.warning),
      StatsBarSegment(t.libraryStatusOther, counts['Other']!, cs.outline),
    ];
    return StatsBreakdownCard(segments: segments);
  }
}

// ── Most-read genre chip ─────────────────────────────────────────
class _GenreChip extends StatelessWidget {
  final String genre;
  const _GenreChip({required this.genre});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: cs.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: cs.primary.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer_rounded, size: 14, color: cs.primary),
          const SizedBox(width: 7),
          Flexible(
            child: Text(t.libraryMostReadGenre(genre),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface)),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────
class _EmptyStatsView extends StatelessWidget {
  final bool isVault;
  final String contentType;
  const _EmptyStatsView({this.isVault = false, this.contentType = 'all'});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final word = switch (contentType) {
      'anime' => t.libraryContentWordAnime,
      'novel' => t.libraryContentWordLightNovels,
      'manga' => t.libraryContentWordManga,
      _ => t.libraryContentWordManga,
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isVault ? Icons.shield_outlined : Icons.auto_graph_rounded,
                size: 56, color: cs.outlineVariant),
            const SizedBox(height: 16),
            Text(
              t.libraryNoStatsYet,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              isVault
                  ? t.libraryEmptyStatsVault(word)
                  : t.libraryEmptyStatsLibrary(word),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.outline),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Backlog row ──────────────────────────────────────────────────
// A "cover · title · added-ago · Start" row for titles with 0 chapters read.
// Modelled on [StatsTitleTimeRow]'s cover + layout; tapping anywhere (or the
// Start pill) opens the manga detail.
class _BacklogRow extends StatelessWidget {
  final LibraryManga manga;
  final String typeLabel;
  final VoidCallback onOpen;
  const _BacklogRow({
    required this.manga,
    required this.typeLabel,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          children: [
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
                      child:
                          Icon(Icons.image_rounded, size: 14, color: cs.outline),
                    ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    manga.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.libraryBacklogAddedAge(
                        statsRelativeAge(manga.addedAt), typeLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: cs.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onOpen,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(28),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Text(t.libraryStart,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: cs.primary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Milestone badge model ────────────────────────────────────────
// A single collectible achievement. Everything is derived from counts the
// stats page already has, so the roster is pure data and trivial to extend.
class _Badge {
  final String name;
  final String description;
  final IconData icon;
  final int current;
  final int target;
  final String unit;
  const _Badge(
    this.name,
    this.description,
    this.icon,
    this.current,
    this.target,
    this.unit,
  );

  bool get earned => current >= target;

  /// Completion fraction, clamped to <1 while unearned (used to rank next-up).
  double get ratio => target <= 0 ? 1 : (current / target).clamp(0.0, 1.0);

  String get earnedCaption => '$target $unit';
  String get lockedCaption => '$current / $target';
}

/// The full milestone roster, built from in-scope tallies. Ordered by category
/// then tier; the UI re-sorts (earned first, then nearest-to-completion).
List<_Badge> _milestoneBadges(
  AppLocalizations t, {
  required int chaptersRead,
  required int hours,
  required int longestStreak,
  required int titles,
  required int sources,
  required int formatsPresent,
  required int mangaCh,
  required int animeEp,
  required int novelCh,
}) {
  final chapters = t.libraryUnitChapters;
  final hoursUnit = t.libraryUnitHours;
  final days = t.libraryUnitDays;
  final titlesUnit = t.libraryUnitTitles;
  final sourcesUnit = t.libraryUnitSources;
  final formats = t.libraryUnitFormats;
  final episodes = t.libraryUnitEpisodes;
  return [
    // Volume - total chapters read.
    _Badge(t.libraryBadgeFirstSteps, t.libraryBadgeFirstStepsDesc,
        Icons.flag_rounded, chaptersRead, 1, chapters),
    _Badge(t.libraryBadgeGettingStarted, t.libraryBadgeGettingStartedDesc,
        Icons.auto_stories_rounded, chaptersRead, 10, chapters),
    _Badge(t.libraryBadgeBookworm, t.libraryBadgeBookwormDesc,
        Icons.menu_book_rounded, chaptersRead, 50, chapters),
    _Badge(t.libraryBadgeCenturion, t.libraryBadgeCenturionDesc,
        Icons.military_tech_rounded, chaptersRead, 100, chapters),
    _Badge(t.libraryBadgeDevourer, t.libraryBadgeDevourerDesc,
        Icons.local_library_rounded, chaptersRead, 250, chapters),
    _Badge(t.libraryBadgeQuincentenary, t.libraryBadgeQuincentenaryDesc,
        Icons.emoji_events_rounded, chaptersRead, 500, chapters),
    _Badge(t.libraryBadgeMarathoner, t.libraryBadgeMarathonerDesc,
        Icons.rocket_launch_rounded, chaptersRead, 1000, chapters),
    _Badge(t.libraryBadgeChapterFiend, t.libraryBadgeChapterFiendDesc,
        Icons.bolt_rounded, chaptersRead, 2500, chapters),
    _Badge(t.libraryBadgeLoremaster, t.libraryBadgeLoremasterDesc,
        Icons.workspace_premium_rounded, chaptersRead, 5000, chapters),
    _Badge(t.libraryBadgeTenThousandClub, t.libraryBadgeTenThousandClubDesc,
        Icons.diamond_rounded, chaptersRead, 10000, chapters),
    // Time - total hours spent.
    _Badge(t.libraryBadgeFirstHour, t.libraryBadgeFirstHourDesc,
        Icons.schedule_rounded, hours, 1, hoursUnit),
    _Badge(t.libraryBadgeGettingComfortable,
        t.libraryBadgeGettingComfortableDesc, Icons.weekend_rounded, hours, 10,
        hoursUnit),
    _Badge(t.libraryBadgeWeekendLost, t.libraryBadgeWeekendLostDesc,
        Icons.hourglass_bottom_rounded, hours, 50, hoursUnit),
    _Badge(t.libraryBadgeDedicated, t.libraryBadgeDedicatedDesc,
        Icons.timer_rounded, hours, 100, hoursUnit),
    _Badge(t.libraryBadgeTimeSink, t.libraryBadgeTimeSinkDesc,
        Icons.hourglass_full_rounded, hours, 250, hoursUnit),
    _Badge(t.libraryBadgeImmersed, t.libraryBadgeImmersedDesc,
        Icons.self_improvement_rounded, hours, 500, hoursUnit),
    _Badge(t.libraryBadgeEternal, t.libraryBadgeEternalDesc,
        Icons.all_inclusive_rounded, hours, 1000, hoursUnit),
    // Streak - longest consecutive-day run (77-day window cap).
    _Badge(t.libraryBadgeWarmingUp, t.libraryBadgeWarmingUpDesc,
        Icons.whatshot_rounded, longestStreak, 3, days),
    _Badge(t.libraryBadgeHotStreak, t.libraryBadgeHotStreakDesc,
        Icons.local_fire_department_rounded, longestStreak, 7, days),
    _Badge(t.libraryBadgeFortnight, t.libraryBadgeFortnightDesc,
        Icons.calendar_month_rounded, longestStreak, 14, days),
    _Badge(t.libraryBadgeDevoted, t.libraryBadgeDevotedDesc,
        Icons.star_rounded, longestStreak, 30, days),
    // Collection - library size.
    _Badge(t.libraryBadgeStarterShelf, t.libraryBadgeStarterShelfDesc,
        Icons.shelves, titles, 10, titlesUnit),
    _Badge(t.libraryBadgeBibliophile, t.libraryBadgeBibliophileDesc,
        Icons.collections_bookmark_rounded, titles, 50, titlesUnit),
    _Badge(t.libraryBadgeCurator, t.libraryBadgeCuratorDesc,
        Icons.inventory_2_rounded, titles, 100, titlesUnit),
    _Badge(t.libraryBadgeArchivist, t.libraryBadgeArchivistDesc,
        Icons.archive_rounded, titles, 250, titlesUnit),
    // Breadth - distinct sources.
    _Badge(t.libraryBadgeExplorer, t.libraryBadgeExplorerDesc,
        Icons.explore_rounded, sources, 5, sourcesUnit),
    _Badge(t.libraryBadgeGlobetrotter, t.libraryBadgeGlobetrotterDesc,
        Icons.travel_explore_rounded, sources, 15, sourcesUnit),
    _Badge(t.libraryBadgeBoundless, t.libraryBadgeBoundlessDesc,
        Icons.public_rounded, sources, 30, sourcesUnit),
    // Variety - formats in rotation.
    _Badge(t.libraryBadgeDabbler, t.libraryBadgeDabblerDesc,
        Icons.category_rounded, formatsPresent, 2, formats),
    _Badge(t.libraryBadgeOmnivore, t.libraryBadgeOmnivoreDesc,
        Icons.layers_rounded, formatsPresent, 3, formats),
    // Per-format depth.
    _Badge(t.libraryBadgeMangaDevotee, t.libraryBadgeMangaDevoteeDesc,
        Icons.import_contacts_rounded, mangaCh, 500, chapters),
    _Badge(t.libraryBadgeBingeWatcher, t.libraryBadgeBingeWatcherDesc,
        Icons.movie_rounded, animeEp, 250, episodes),
    _Badge(t.libraryBadgeNovelNerd, t.libraryBadgeNovelNerdDesc,
        Icons.auto_stories_rounded, novelCh, 250, chapters),
  ];
}

// ── Milestones card (next-up ring + badge grid) ──────────────────
class _MilestonesCard extends StatelessWidget {
  /// Earned first, then locked ordered by nearest-to-completion.
  final List<_Badge> badges;

  /// The single unearned badge with the highest completion ratio, or null
  /// when every milestone is earned.
  final _Badge? nextUp;
  const _MilestonesCard({required this.badges, required this.nextUp});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nextUp == null)
            Row(
              children: [
                Icon(Icons.celebration_rounded, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(t.libraryAllMilestonesUnlocked,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.primary)),
                ),
              ],
            )
          else
            _NextUpHero(badge: nextUp!),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 9,
              crossAxisSpacing: 9,
              mainAxisExtent: 104,
            ),
            itemCount: badges.length,
            itemBuilder: (_, i) => _BadgeTile(badge: badges[i]),
          ),
        ],
      ),
    );
  }
}

class _NextUpHero extends StatelessWidget {
  final _Badge badge;
  const _NextUpHero({required this.badge});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Row(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(64),
                painter: _RingPainter(
                  ratio: badge.ratio,
                  track: cs.outlineVariant,
                  fill: cs.primary,
                ),
              ),
              Text('${(badge.ratio * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface)),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.libraryNextUp,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: cs.outline)),
              const SizedBox(height: 2),
              Text(badge.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface)),
              const SizedBox(height: 1),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: cs.outline),
                  children: [
                    TextSpan(
                        text: '${badge.current}',
                        style: TextStyle(color: cs.primary)),
                    TextSpan(text: ' / ${badge.target} ${badge.unit}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final _Badge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final earned = badge.earned;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: earned ? cs.primary : cs.surfaceContainerHighest,
          ),
          child: Icon(badge.icon,
              size: 18, color: earned ? cs.onPrimary : cs.outline),
        ),
        const SizedBox(height: 5),
        Text(
          badge.name,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 10,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: earned ? cs.onSurface : cs.outline),
        ),
        const SizedBox(height: 2),
        Text(
          earned ? badge.earnedCaption : badge.lockedCaption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9, fontWeight: FontWeight.w700, color: cs.outline),
        ),
      ],
    );
    return Tooltip(
      message: badge.description,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 9, 4, 8),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
              color: earned ? cs.primary.withAlpha(77) : cs.outlineVariant),
        ),
        child: Stack(
          children: [
            Center(
              child: Opacity(opacity: earned ? 1 : 0.55, child: content),
            ),
            if (!earned)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(Icons.lock_rounded, size: 11, color: cs.outline),
              ),
          ],
        ),
      ),
    );
  }
}

/// Draws the next-up completion ring: a full track circle + a rounded arc from
/// the top for [ratio].
class _RingPainter extends CustomPainter {
  final double ratio;
  final Color track;
  final Color fill;
  _RingPainter({required this.ratio, required this.track, required this.fill});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 7.0;
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - stroke) / 2;
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawCircle(center, radius, bg);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * ratio.clamp(0.0, 1.0),
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.ratio != ratio || old.track != track || old.fill != fill;
}

// ── Reading personality card (archetype + 5-axis radar) ──────────
class _PersonalityCard extends StatelessWidget {
  final String archetype;
  final String description;
  final List<double> axes; // Volume, Depth, Consistency, Breadth, Variety
  final List<String> chips;
  const _PersonalityCard({
    required this.archetype,
    required this.description,
    required this.axes,
    required this.chips,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Text(t.libraryYourReadingType,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: cs.outline)),
          const SizedBox(height: 3),
          Text(archetype,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: cs.primary)),
          const SizedBox(height: 6),
          Text(description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface)),
          const SizedBox(height: 10),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: AspectRatio(
                aspectRatio: 240 / 216,
                child: CustomPaint(
                  painter: _RadarPainter(
                    values: axes,
                    labels: [
                      t.libraryAxisVolume,
                      t.libraryAxisDepth,
                      t.libraryAxisConsistency,
                      t.libraryAxisBreadth,
                      t.libraryAxisVariety,
                    ],
                    grid: cs.outlineVariant,
                    stroke: cs.primary,
                    fill: cs.primary.withAlpha(51),
                    label: cs.outline,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            alignment: WrapAlignment.center,
            children: chips
                .map((c) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Text(c,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// A 5-axis radar: concentric grid rings + spokes, a filled accent polygon with
/// vertex dots, and axis labels. Sized to fill its box (kept ~square by the
/// caller's AspectRatio).
class _RadarPainter extends CustomPainter {
  final List<double> values; // 0..1
  final List<String> labels;
  final Color grid;
  final Color stroke;
  final Color fill;
  final Color label;
  _RadarPainter({
    required this.values,
    required this.labels,
    required this.grid,
    required this.stroke,
    required this.fill,
    required this.label,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n < 3) return;
    const labelPad = 22.0;
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - labelPad;
    if (radius <= 0) return;

    Offset pt(int i, double r) {
      final a = -math.pi / 2 + i * 2 * math.pi / n;
      return center + Offset(math.cos(a) * r, math.sin(a) * r);
    }

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = grid;

    // Concentric rings.
    for (final ring in [0.25, 0.5, 0.75, 1.0]) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final p = pt(i, radius * ring);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Spokes.
    for (var i = 0; i < n; i++) {
      canvas.drawLine(center, pt(i, radius), gridPaint);
    }

    // Data polygon.
    final dataPath = Path();
    for (var i = 0; i < n; i++) {
      final p = pt(i, radius * values[i].clamp(0.0, 1.0));
      if (i == 0) {
        dataPath.moveTo(p.dx, p.dy);
      } else {
        dataPath.lineTo(p.dx, p.dy);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, Paint()..color = fill);
    canvas.drawPath(
      dataPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..color = stroke,
    );

    // Vertex dots.
    final dot = Paint()..color = stroke;
    for (var i = 0; i < n; i++) {
      canvas.drawCircle(pt(i, radius * values[i].clamp(0.0, 1.0)), 2.6, dot);
    }

    // Axis labels.
    for (var i = 0; i < n; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          // Painter has no BuildContext to inherit the theme font, so name the
          // family explicitly (matches the Manrope type scale used elsewhere).
          style: GoogleFonts.manrope(
              fontSize: 9, fontWeight: FontWeight.w700, color: label),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final anchor = pt(i, radius + 13);
      tp.paint(
        canvas,
        anchor - Offset(tp.width / 2, tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.values != values ||
      old.stroke != stroke ||
      old.fill != fill ||
      old.grid != grid ||
      old.label != label;
}
