import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/library_settings.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Bottom sheet with the library's Filter / Sort / Display controls.
///
/// Restyled to the app's filter look: rounded cells, caps section labels,
/// a purple selected state and 2-column grids. Edits are pushed up live through
/// [onChanged] so the grid behind the sheet reflects each change immediately,
/// rather than only on dismiss.
class LibraryOptionsSheet extends StatefulWidget {
  final LibrarySettings settings;
  final List<({String id, String name})> sources;
  final ValueChanged<LibrarySettings> onChanged;

  const LibraryOptionsSheet({
    super.key,
    required this.settings,
    required this.sources,
    required this.onChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required LibrarySettings settings,
    required List<({String id, String name})> sources,
    required ValueChanged<LibrarySettings> onChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LibraryOptionsSheet(
        settings: settings,
        sources: sources,
        onChanged: onChanged,
      ),
    );
  }

  @override
  State<LibraryOptionsSheet> createState() => _LibraryOptionsSheetState();
}

class _LibraryOptionsSheetState extends State<LibraryOptionsSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late LibrarySettings _s;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _s = widget.settings;
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _update(LibrarySettings next) {
    setState(() => _s = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLarge)),
      ),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.72),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          TabBar(
            controller: _tabs,
            labelColor: cs.primary,
            unselectedLabelColor: cs.outline,
            indicatorColor: cs.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: GoogleFonts.manrope(
                fontSize: 13.5, fontWeight: FontWeight.w700),
            unselectedLabelStyle: GoogleFonts.manrope(
                fontSize: 13.5, fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: t.libraryTabFilter),
              Tab(text: t.libraryTabSort),
              Tab(text: t.libraryTabDisplay),
            ],
          ),
          const Divider(height: 1),
          Flexible(
            child: TabBarView(
              controller: _tabs,
              children: [
                _filterTab(cs),
                _sortTab(cs),
                _displayTab(cs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter ────────────────────────────────────────────────────────────────
  Widget _filterTab(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
      children: [
        _sectionLabel(cs, t.libraryTabFilter),
        _cellGrid([
          _triCell(cs, t.libraryUnread, _s.filterUnread,
              (v) => _update(_s.copyWith(filterUnread: v))),
          _triCell(cs, t.libraryCompleted, _s.filterCompleted,
              (v) => _update(_s.copyWith(filterCompleted: v))),
          _triCell(cs, t.libraryDownloaded, _s.filterDownloaded,
              (v) => _update(_s.copyWith(filterDownloaded: v))),
        ]),
        _legend(cs),
        if (widget.sources.isNotEmpty) ...[
          const SizedBox(height: 4),
          _sectionLabel(cs, t.librarySources),
          _cellGrid([
            for (final src in widget.sources)
              _toggleCell(cs, src.name, _s.filterSourceIds.contains(src.id),
                  () {
                final next = Set<String>.from(_s.filterSourceIds);
                next.contains(src.id)
                    ? next.remove(src.id)
                    : next.add(src.id);
                _update(_s.copyWith(filterSourceIds: next));
              }),
          ]),
        ],
      ],
    );
  }

  // ── Sort ──────────────────────────────────────────────────────────────────
  Widget _sortTab(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
      children: [
        _sectionLabel(cs, 'Sort by'),
        for (final option in LibrarySort.values)
          _sortRow(cs, option),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () async {
                await LibrarySettings.resetToDefaults();
                _update(const LibrarySettings());
              },
              child: Text(t.libraryResetToDefault,
                  style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.outline)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sortRow(ColorScheme cs, LibrarySort option) {
    final active = _s.sort == option;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Re-tapping the active sort flips direction.
          if (active) {
            _update(_s.copyWith(sortAscending: !_s.sortAscending));
          } else {
            _update(_s.copyWith(sort: option, sortAscending: true));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: active ? cs.primary.withAlpha(30) : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: active ? cs.primary : cs.outlineVariant,
                width: active ? 1.4 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(option.label,
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                      color: active ? cs.primary : cs.onSurface,
                    )),
              ),
              if (active)
                Icon(
                    _s.sortAscending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 18,
                    color: cs.primary),
            ],
          ),
        ),
      ),
    );
  }

  // ── Display ───────────────────────────────────────────────────────────────
  Widget _displayTab(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
      children: [
        _sectionLabel(cs, t.libraryDisplayMode),
        _cellGrid([
          for (final mode in LibraryDisplayMode.values)
            _toggleCell(cs, mode.label, _s.displayMode == mode,
                () => _update(_s.copyWith(displayMode: mode))),
        ]),
        if (_s.displayMode == LibraryDisplayMode.grid)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(t.libraryItemsPerRow,
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface)),
                ),
                _stepper(cs, Icons.remove_rounded,
                    _s.itemsPerRow > 2
                        ? () => _update(
                            _s.copyWith(itemsPerRow: _s.itemsPerRow - 1))
                        : null),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('${_s.itemsPerRow}',
                      style: GoogleFonts.manrope(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                ),
                _stepper(cs, Icons.add_rounded,
                    _s.itemsPerRow < 6
                        ? () => _update(
                            _s.copyWith(itemsPerRow: _s.itemsPerRow + 1))
                        : null),
              ],
            ),
          ),
        const SizedBox(height: 4),
        _sectionLabel(cs, 'Cover title'),
        _cellGrid([
          for (final o in LibraryCardTitle.values)
            _toggleCell(cs, o.label, _s.cardTitle == o,
                () => _update(_s.copyWith(cardTitle: o))),
        ]),
        _sectionLabel(cs, 'Badge placement'),
        _cellGrid([
          for (final o in LibraryCardBadges.values)
            _toggleCell(cs, o.label, _s.cardBadges == o,
                () => _update(_s.copyWith(cardBadges: o))),
        ]),
        _sectionLabel(cs, 'Reading progress'),
        _cellGrid([
          for (final o in LibraryCardProgress.values)
            _toggleCell(cs, o.label, _s.cardProgress == o,
                () => _update(_s.copyWith(cardProgress: o))),
        ]),
        const SizedBox(height: 4),
        _sectionLabel(cs, t.libraryBadges),
        _cellGrid([
          _toggleCell(cs, t.libraryUnread, _s.badgeUnread,
              () => _update(_s.copyWith(badgeUnread: !_s.badgeUnread))),
          _toggleCell(cs, t.libraryDownloaded, _s.badgeDownloaded,
              () => _update(_s.copyWith(badgeDownloaded: !_s.badgeDownloaded))),
          _toggleCell(cs, 'Language', _s.badgeLanguage,
              () => _update(_s.copyWith(badgeLanguage: !_s.badgeLanguage))),
          _toggleCell(cs, 'Local', _s.badgeLocal,
              () => _update(_s.copyWith(badgeLocal: !_s.badgeLocal))),
        ]),
        _badgeLegend(cs),
        const SizedBox(height: 4),
        _sectionLabel(cs, t.libraryTabs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _toggleCell(cs, t.libraryShowNumberOfItems, _s.showTabCounts,
              () => _update(_s.copyWith(showTabCounts: !_s.showTabCounts)),
              fullWidth: true),
        ),
      ],
    );
  }

  // ── building blocks ─────────────────────────────────────────────────────────
  /// Key to the cover badges — mirrors the pills drawn on the cards so the
  /// icon-only badges (downloaded, local) are self-explanatory.
  Widget _badgeLegend(ColorScheme cs) {
    const green = Color(0xFF34D399);
    const amber = Color(0xFFF0C850);
    TextStyle ps(Color c) => GoogleFonts.manrope(
        fontSize: 9, fontWeight: FontWeight.w800, color: c, height: 1.1);
    Widget chip(Color bg, Widget child, {Color? border}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(5),
            border:
                border == null ? null : Border.all(color: border, width: 0.8),
          ),
          child: child,
        );
    Widget item(Widget badge, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            badge,
            const SizedBox(width: 5),
            Text(label,
                style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: cs.outline)),
          ],
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 6),
      child: Wrap(
        spacing: 14,
        runSpacing: 6,
        children: [
          item(chip(cs.primary, Text('12', style: ps(cs.onPrimary))), 'Unread'),
          item(
              chip(green.withAlpha(38),
                  const Icon(Icons.download_done_rounded, size: 10, color: green),
                  border: green.withAlpha(90)),
              'Downloaded'),
          item(
              chip(cs.surfaceContainerHighest,
                  Text('EN', style: ps(cs.onSurfaceVariant))),
              'Language'),
          item(
              chip(amber.withAlpha(30),
                  const Icon(Icons.folder_rounded, size: 10, color: amber),
                  border: amber.withAlpha(80)),
              'Local'),
        ],
      ),
    );
  }

  Widget _sectionLabel(ColorScheme cs, String text) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
        child: Text(text.toUpperCase(),
            style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: cs.outline)),
      );

  /// Lays cells out two-per-row with even spacing inside a ListView.
  Widget _cellGrid(List<Widget> cells) {
    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 2) {
      rows.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
        // IntrinsicHeight gives the row a definite height (the taller cell) so
        // the two cells match, without the unbounded-height crash that
        // CrossAxisAlignment.stretch causes inside a scrolling ListView.
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cells[i]),
              const SizedBox(width: 6),
              Expanded(
                  child:
                      i + 1 < cells.length ? cells[i + 1] : const SizedBox()),
            ],
          ),
        ),
      ));
    }
    return Column(children: rows);
  }

  /// Tri-state filter cell: off → include (✓, purple) → exclude (✕, red) → off.
  Widget _triCell(ColorScheme cs, String label, LibraryFilterState state,
      ValueChanged<LibraryFilterState> onChanged) {
    final include = state == LibraryFilterState.include;
    final exclude = state == LibraryFilterState.exclude;
    final accent = exclude ? cs.error : cs.primary;
    return _CellShell(
      active: state.isActive,
      accent: accent,
      onTap: () => onChanged(state.next),
      label: label,
      labelColor: state.isActive ? accent : cs.onSurface,
      mark: _Mark(
        filled: state.isActive,
        accent: accent,
        glyph: include
            ? Icons.check_rounded
            : (exclude ? Icons.close_rounded : null),
        idleColor: cs.outline,
      ),
    );
  }

  /// On/off cell (sources, badges, display mode, tab counts).
  Widget _toggleCell(ColorScheme cs, String label, bool on, VoidCallback onTap,
      {bool fullWidth = false}) {
    return _CellShell(
      active: on,
      accent: cs.primary,
      onTap: onTap,
      label: label,
      labelColor: on ? cs.primary : cs.onSurface,
      mark: _Mark(
        filled: on,
        accent: cs.primary,
        glyph: on ? Icons.check_rounded : null,
        idleColor: cs.outline,
      ),
    );
  }

  Widget _legend(ColorScheme cs) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 4),
        child: Row(
          children: [
            Icon(Icons.check_rounded, size: 13, color: cs.primary),
            const SizedBox(width: 3),
            Text('show only',
                style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: cs.outline)),
            const SizedBox(width: 12),
            Icon(Icons.close_rounded, size: 13, color: cs.error),
            const SizedBox(width: 3),
            Text('hide',
                style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: cs.outline)),
          ],
        ),
      );

  Widget _stepper(ColorScheme cs, IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap == null
              ? cs.surfaceContainerHighest
              : cs.primary.withAlpha(38),
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 18, color: onTap == null ? cs.outline : cs.primary),
      ),
    );
  }
}

/// Shared rounded cell used by the filter / sort / display tabs.
class _CellShell extends StatelessWidget {
  final bool active;
  final Color accent;
  final VoidCallback onTap;
  final String label;
  final Color labelColor;
  final Widget mark;
  const _CellShell({
    required this.active,
    required this.accent,
    required this.onTap,
    required this.label,
    required this.labelColor,
    required this.mark,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
        decoration: BoxDecoration(
          color: active ? accent.withAlpha(28) : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: active ? accent : cs.outlineVariant,
              width: active ? 1.4 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: labelColor)),
            ),
            const SizedBox(width: 8),
            mark,
          ],
        ),
      ),
    );
  }
}

/// The 18×18 trailing mark box: a bordered square when off, a filled accent
/// square with a glyph (✓ / ✕) when set.
class _Mark extends StatelessWidget {
  final bool filled;
  final Color accent;
  final IconData? glyph;
  final Color idleColor;
  const _Mark({
    required this.filled,
    required this.accent,
    required this.glyph,
    required this.idleColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: filled ? accent : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: filled ? accent : idleColor, width: 1.5),
      ),
      child: glyph == null
          ? null
          : Icon(glyph, size: 13, color: Colors.white),
    );
  }
}
