import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_tokens.dart';
import 'radial_config.dart';

/// Customize the in-reader radial wheel - which actions appear and in what
/// order - separately for the manga reader and the light-novel reader (the two
/// share the wheel widget but expose different actions). Drag to reorder, toggle
/// to show/hide. Saved live via [RadialMenuConfig].
class RadialMenuSettingsPage extends StatefulWidget {
  const RadialMenuSettingsPage({super.key, this.only});

  /// When set ('manga' or 'novel') the page shows only that reader's actions
  /// with no tab bar; otherwise it shows both readers in tabs.
  final String? only;

  @override
  State<RadialMenuSettingsPage> createState() => _RadialMenuSettingsPageState();
}

class _RadialMenuSettingsPageState extends State<RadialMenuSettingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  late List<(String, bool)> _manga = RadialMenuConfig.load('manga');
  late List<(String, bool)> _novel = RadialMenuConfig.load('novel');
  bool _mangaTailNav = RadialMenuConfig.tailChapterNav('manga');

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<(String, bool)> _listFor(String type) => type == 'novel' ? _novel : _manga;

  void _set(String type, List<(String, bool)> entries) {
    setState(() {
      if (type == 'novel') {
        _novel = entries;
      } else {
        _manga = entries;
      }
    });
    RadialMenuConfig.save(type, entries);
  }

  void _reset(String type) =>
      _set(type, [for (final c in RadialMenuConfig.canonicalFor(type)) (c.$1, true)]);

  Widget _tabBody(String type) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final entries = _listFor(type);
    final meta = {
      for (final c in RadialMenuConfig.canonicalFor(type)) c.$1: (c.$2, c.$3)
    };
    final enabledCount = entries.where((e) => e.$2).length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
          child: Text(
              t.readerRadialReorderHint(enabledCount),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.outline)),
        ),
        // Manga-only: prev/next chapter arrows on the page-slider tail (the LN
        // tail shows title/chapter, not a slider).
        if (type == 'manga')
          SwitchListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            secondary: Icon(Icons.swap_horiz_rounded, color: cs.primary),
            title: Text(t.readerChapterArrowsTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 15, color: cs.onSurface)),
            subtitle: Text(t.readerChapterArrowsSubtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.outline)),
            value: _mangaTailNav,
            onChanged: (v) {
              setState(() => _mangaTailNav = v);
              RadialMenuConfig.setTailChapterNav('manga', v);
            },
          ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            itemCount: entries.length,
            onReorder: (oldIndex, newIndex) {
              final list = List<(String, bool)>.of(entries);
              if (newIndex > oldIndex) newIndex -= 1;
              list.insert(newIndex, list.removeAt(oldIndex));
              _set(type, list);
            },
            itemBuilder: (ctx, i) {
              final (key, enabled) = entries[i];
              final m = meta[key] ?? (Icons.circle, key);
              return Container(
                key: ValueKey(key),
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                padding: const EdgeInsets.only(left: 14, right: 6),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(m.$1,
                        size: 22,
                        color: enabled ? cs.primary : cs.outline),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(m.$2,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: enabled ? cs.onSurface : cs.outline)),
                    ),
                    Switch(
                      value: enabled,
                      onChanged: (v) {
                        final list = List<(String, bool)>.of(entries);
                        list[i] = (key, v);
                        _set(type, list);
                      },
                    ),
                    ReorderableDragStartListener(
                      index: i,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.drag_handle_rounded, color: cs.outline),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w700);
    final only = widget.only;
    // Scoped to one reader (opened from that reader's settings tab): no tabs.
    if (only != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              only == 'novel' ? t.readerLightNovelMenu : t.readerMangaMenu,
              style: titleStyle),
          actions: [
            TextButton(
              onPressed: () => _reset(only),
              child: Text(t.readerReset),
            ),
          ],
        ),
        body: SafeArea(child: _tabBody(only)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(t.readerRadialMenu, style: titleStyle),
        actions: [
          TextButton(
            onPressed: () => _reset(_tab.index == 1 ? 'novel' : 'manga'),
            child: Text(t.readerReset),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: [Tab(text: t.readerManga), Tab(text: t.readerLightNovel)],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tab,
          children: [_tabBody('manga'), _tabBody('novel')],
        ),
      ),
    );
  }
}
