import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/download_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import 'downloads_settings_page.dart';

/// The Downloads screen: a live queue manager. Shows what's downloading right
/// now with per-item progress, lets the user pause/resume the whole queue or
/// cancel individual items, tune concurrency inline, and peek at what finished
/// this session. All the download *settings* (auto-download, format, location,
/// storage) live one tap away behind the gear icon.
class DownloadQueuePage extends StatelessWidget {
  const DownloadQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.dlQueueTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        actions: [
          IconButton(
            tooltip: t.dlQueueSettingsTooltip,
            icon: Icon(Icons.settings_rounded, color: cs.onSurface, size: 22),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DownloadsSettingsPage()),
            ),
          ),
          Consumer<DownloadProvider>(
            builder: (_, dl, _) {
              final hasActive = dl.activeDownloads.isNotEmpty;
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: cs.onSurface),
                onSelected: (v) {
                  if (v == 'cancel_all') dl.cancelAll();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'cancel_all',
                    enabled: hasActive,
                    child: Text(t.dlQueueCancelAll,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 14)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<DownloadProvider>(
        builder: (_, dl, _) {
          final active = dl.activeDownloads;
          final bottom = MediaQuery.viewPaddingOf(context).bottom;
          return Column(
            children: [
              _RecentRow(count: dl.recentCompleted.length),
              _ControlsRow(provider: dl),
              if (dl.isPaused && active.isNotEmpty) _PausedBanner(),
              Expanded(
                child: active.isEmpty
                    ? _EmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 4, bottom: 16 + bottom),
                        itemCount: active.length,
                        itemBuilder: (_, i) =>
                            _DownloadRow(task: active[i], provider: dl),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// "Recently Downloaded" nav row at the top of the queue screen.
class _RecentRow extends StatelessWidget {
  final int count;
  const _RecentRow({required this.count});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Material(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecentDownloadsPage()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.download_done_rounded,
                      color: cs.primary, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.dlQueueRecent,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface),
                  ),
                ),
                if (count > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('$count',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.primary)),
                  ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The two pill buttons: Pause/Resume and Concurrent downloads.
class _ControlsRow extends StatelessWidget {
  final DownloadProvider provider;
  const _ControlsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final paused = provider.isPaused;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _Pill(
              icon: paused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
              label: paused ? t.dlQueueResume : t.dlQueuePause,
              onTap: () =>
                  paused ? provider.resumeQueue() : provider.pauseQueue(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Pill(
              icon: Icons.bolt_rounded,
              label: t.dlQueueConcurrent(provider.simultaneousDownloads),
              onTap: () => _pickConcurrency(context, provider),
            ),
          ),
        ],
      ),
    );
  }

  void _pickConcurrency(BuildContext context, DownloadProvider provider) {
    final cs = Theme.of(context).colorScheme;
    const choices = ['1', '2', '3', '5', '10'];
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppLocalizations.of(context)
                    .dlQueueConcurrent(provider.simultaneousDownloads),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700),
              ),
            ),
            Divider(color: cs.outlineVariant),
            ...choices.map((c) => ListTile(
                  title: Text(c, style: Theme.of(context).textTheme.bodyLarge),
                  trailing: c == provider.simultaneousDownloads
                      ? Icon(Icons.check_rounded, color: cs.primary, size: 20)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    provider.saveStringSetting('dl_simultaneous', c);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Pill({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Fixed height so the two pills always line up, even when one label wraps
    // to a second line (e.g. "Concurrent downloads: 2").
    return SizedBox(
      height: 52,
      child: Material(
        color: cs.primary.withAlpha(28),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: cs.primary, size: 19),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PausedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(Icons.pause_circle_outline_rounded,
              size: 18, color: cs.onSurface),
          const SizedBox(width: 10),
          Text(t.dlQueuePaused,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface)),
        ],
      ),
    );
  }
}

/// One row in the live queue: type icon, title/chapter, progress, cancel.
class _DownloadRow extends StatelessWidget {
  final DownloadTask task;
  final DownloadProvider provider;
  const _DownloadRow({required this.task, required this.provider});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final downloading = task.status == DownloadStatus.downloading;
    // Image chapters report real page counts; novel/anime report 0/1 while the
    // single file streams, so show an indeterminate bar there.
    final hasProgress = downloading && task.total > 0 && !task.isNovel;

    final (icon, color) = _typeVisual(cs);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.mangaTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface),
                ),
                Text(
                  task.chapterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.outline),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: hasProgress ? task.progress : null,
                    minHeight: 5,
                    backgroundColor: cs.outlineVariant.withAlpha(90),
                    valueColor: AlwaysStoppedAnimation(
                        downloading ? cs.primary : cs.outline),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusText(t),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: downloading ? cs.primary : cs.outline),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: t.dlQueueCancelItem,
            icon: Icon(Icons.close_rounded, color: cs.outline, size: 20),
            onPressed: () =>
                provider.cancelTask(task.sourceId, task.chapterUrl),
          ),
        ],
      ),
    );
  }

  String _statusText(AppLocalizations t) {
    if (task.status == DownloadStatus.queued) return t.dlQueueStatusQueued;
    if (task.total > 1 && !task.isNovel) {
      return t.dlQueueProgress('${task.completed}', '${task.total}');
    }
    return t.dlQueueStatusDownloading;
  }

  (IconData, Color) _typeVisual(ColorScheme cs) {
    if (task.isAnime) {
      return (Icons.movie_rounded, const Color(0xFFE0554A));
    }
    if (task.isNovel) {
      return (Icons.menu_book_rounded, const Color(0xFF4CAF82));
    }
    return (Icons.auto_stories_rounded, cs.primary);
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '(˘•_•˘)',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 44,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withAlpha(140)),
          ),
          const SizedBox(height: 18),
          Text(
            t.dlQueueEmpty,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withAlpha(160)),
          ),
        ],
      ),
    );
  }
}

/// The "Recently Downloaded" list (session-scoped).
class RecentDownloadsPage extends StatelessWidget {
  const RecentDownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.dlQueueRecentTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface),
        ),
        actions: [
          Consumer<DownloadProvider>(
            builder: (_, dl, _) => dl.recentCompleted.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: dl.clearRecent,
                    child: Text(t.dlQueueRecentClear,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.primary)),
                  ),
          ),
        ],
      ),
      body: Consumer<DownloadProvider>(
        builder: (_, dl, _) {
          final recent = dl.recentCompleted;
          if (recent.isEmpty) {
            return Center(
              child: Text(
                t.dlQueueRecentEmpty,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15, color: cs.onSurface.withAlpha(150)),
              ),
            );
          }
          final bottom = MediaQuery.viewPaddingOf(context).bottom;
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottom),
            itemCount: recent.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 2),
                  child: Text(
                    t.dlQueueRecentNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.outline),
                  ),
                );
              }
              final task = recent[i - 1];
              final (icon, color) = task.isAnime
                  ? (Icons.movie_rounded, const Color(0xFFE0554A))
                  : task.isNovel
                      ? (Icons.menu_book_rounded, const Color(0xFF4CAF82))
                      : (Icons.auto_stories_rounded, cs.primary);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: color.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 19),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.mangaTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface)),
                          Text(task.chapterName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.outline)),
                        ],
                      ),
                    ),
                    Icon(Icons.check_circle_rounded,
                        color: AppTheme.success, size: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
