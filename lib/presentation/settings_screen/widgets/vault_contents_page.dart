import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/manga_model.dart';
import '../../../core/models/chapter_model.dart';
import '../../../core/providers/library_provider.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/providers/vault_provider.dart';
import '../../../core/services/app_logger.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/manga_image.dart';

/// Move titles (with their read progress) between the normal library and the
/// encrypted vault. A direction toggle switches between moving IN and OUT; titles
/// can be moved one at a time, multi-selected, all at once, or by category.
///
/// Only reachable once the vault is unlocked - moving requires the vault's Hive
/// boxes to be open, and the whole point is that locked content is unreadable.
class VaultContentsPage extends StatefulWidget {
  const VaultContentsPage({super.key});

  @override
  State<VaultContentsPage> createState() => _VaultContentsPageState();
}

class _VaultContentsPageState extends State<VaultContentsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // The three content types, resolved from each entry's source.
  static const _types = ['manga', 'anime', 'novel'];
  int _typeIndex = 0;

  /// true = move Library → Vault; false = move Vault → Library.
  bool _toVault = true;
  bool _selectMode = false;
  final Set<String> _selected = {};
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabs.index != _typeIndex) {
          setState(() {
            _typeIndex = _tabs.index;
            _selected.clear();
            _selectMode = false;
          });
        }
      });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  String _key(LibraryManga m) => '${m.sourceId}_${m.url}';

  /// A title's content type comes from its source (LibraryManga has none of its
  /// own). Sources that are no longer installed default to manga.
  String _typeOf(BuildContext context, LibraryManga m) {
    final installed =
        context.read<SourceProvider>().getInstalledSource(m.sourceId);
    return m.contentTypeOr(installed?.source.itemType ?? 'manga');
  }

  /// Move [items] in the current direction. Returns silently on an empty list.
  /// Shows a count snackbar with Undo (which moves them back).
  Future<void> _move(List<LibraryManga> items, bool toVault,
      {bool isUndo = false, String? destCategory}) async {
    if (items.isEmpty) return;
    final lib = context.read<LibraryProvider>();
    final vault = context.read<VaultProvider>();
    // Gather every entry (+ its chapters) first, then hand the whole batch to the
    // provider in one shot: the provider reloads/notifies ONCE instead of once
    // per item, which is what made big moves crawl.
    final toAdd = <(LibraryManga, List<LibraryChapter>)>[];
    final keys = <(String, String)>[];
    for (final m in items) {
      // When a destination category is chosen, the moved copy lands in it
      // (the original is kept in `moved` so Undo restores its categories).
      final entry = destCategory != null
          ? (m.clone()..categories = [destCategory])
          : m;
      final chapters = toVault
          ? lib.fullChapters(m.sourceId, m.url)
          : vault.fullChapters(m.sourceId, m.url);
      toAdd.add((entry, chapters));
      keys.add((m.sourceId, m.url));
    }
    final moved = <LibraryManga>[];
    try {
      if (toVault) {
        await vault.addEntriesWithChaptersBulk(toAdd);
        await lib.removeMangaBulk(keys);
      } else {
        await lib.addEntriesWithChaptersBulk(toAdd);
        await vault.removeMangaBulk(keys);
      }
      moved.addAll(items);
    } catch (e, st) {
      logger.error('Vault bulk move ${toVault ? "IN" : "OUT"} failed: $e',
          category: LogCategory.library, detail: st.toString());
    }
    if (!mounted) return;
    setState(() {
      _selected.clear();
      _selectMode = false;
    });
    if (moved.isEmpty) return;
    final t = AppLocalizations.of(context);
    final msg = toVault
        ? t.setdVaultContentsMovedInCount(moved.length)
        : t.setdVaultContentsMovedOutCount(moved.length);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        action: isUndo
            ? null
            : SnackBarAction(
                label: t.setdActionUndo,
                onPressed: () => _move(moved, !toVault, isUndo: true),
              ),
      ));
  }

  Future<void> _confirmAndMove(List<LibraryManga> items, String what,
      {String? destCategory}) async {
    if (items.isEmpty) return;
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final dest =
        _toVault ? t.setdVaultContentsDestVault : t.setdVaultContentsDestLibrary;
    final into = destCategory != null
        ? t.setdVaultContentsIntoCategory(destCategory)
        : '';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surfaceContainerHighest,
        title: Text(t.setdVaultContentsMoveConfirmTitle(what),
            style: Theme.of(ctx)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        content: Text(
            t.setdVaultContentsMoveConfirmBody(items.length, dest, into),
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.setdActionCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.setdActionMove)),
        ],
      ),
    );
    if (ok == true) await _move(items, _toVault, destCategory: destCategory);
  }

  /// Bottom-sheet category picker. Returns the chosen name, '' for "No category",
  /// or null if dismissed. [counts] optionally shows a trailing count per name.
  Future<String?> _pickCategory(String title, List<String> names,
      {Map<String, int>? counts, bool addNone = false}) async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true, // let the sheet grow, then the list scrolls
      constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(children: [
              Icon(Icons.category_rounded, size: 18, color: cs.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w800, color: cs.onSurface)),
              ),
            ]),
          ),
          Divider(height: 1, color: cs.surfaceContainerHighest),
          if (names.isEmpty && !addNone)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(t.setdVaultContentsNoCategoriesToPick,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 8),
                children: [
                  if (addNone)
                    ListTile(
                      leading: Icon(Icons.inbox_rounded,
                          size: 20, color: cs.onSurfaceVariant),
                      title: Text(t.setdVaultContentsNoCategory,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600)),
                      onTap: () => Navigator.pop(ctx, ''),
                    ),
                  for (final c in names)
                    ListTile(
                      leading: Icon(Icons.folder_rounded, size: 20, color: cs.primary),
                      title: Text(c,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600)),
                      trailing: counts == null
                          ? null
                          : Text('${counts[c] ?? 0}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant)),
                      onTap: () => Navigator.pop(ctx, c),
                    ),
                ],
              ),
            ),
        ]),
      ),
    );
  }

  /// Bulk move every title in a chosen source category, into a chosen destination
  /// category on the other side (the user picks where it lands - not preserved).
  Future<void> _moveByCategory(List<LibraryManga> source) async {
    final t = AppLocalizations.of(context);
    // 1) Which source category to move.
    final srcCats = (_toVault
            ? context.read<LibraryProvider>().categories
            : context.read<VaultProvider>().categories)
        .map((c) => c.name)
        .where((n) => n.isNotEmpty)
        .toList();
    final counts = {
      for (final c in srcCats) c: source.where((m) => m.categories.contains(c)).length
    };
    final picked = await _pickCategory(
        _toVault
            ? t.setdVaultContentsPickSourceLibrary
            : t.setdVaultContentsPickSourceVault,
        srcCats,
        counts: counts);
    if (picked == null || !mounted) return;
    final items = source.where((m) => m.categories.contains(picked)).toList();
    if (items.isEmpty) {
      AppTheme.showSnackBar(context, t.setdVaultContentsNothingIn(picked));
      return;
    }
    // 2) Which destination category on the other side to drop them into.
    final destCats = (_toVault
            ? context.read<VaultProvider>().categories
            : context.read<LibraryProvider>().categories)
        .map((c) => c.name)
        .where((n) => n.isNotEmpty)
        .toList();
    final dest = await _pickCategory(
        _toVault
            ? t.setdVaultContentsPickDestVault
            : t.setdVaultContentsPickDestLibrary,
        destCats,
        addNone: true);
    if (dest == null || !mounted) return; // dismissed
    await _confirmAndMove(items, t.setdVaultContentsMoveEverythingIn(picked),
        destCategory: dest.isEmpty ? null : dest);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final vault = context.watch<VaultProvider>();
    final lib = context.watch<LibraryProvider>();

    // Guard: if the vault is locked, moving can't work - send the user back.
    if (vault.hasPassword && !vault.isUnlocked) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.surface,
          title: Text(t.setdVaultContentsTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: cs.onSurface)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              t.setdVaultContentsLockedMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    final type = _types[_typeIndex];
    final labels = [
      t.setdVaultContentsTabManga,
      t.setdVaultContentsTabAnime,
      t.setdVaultContentsTabNovels,
    ];
    // The side we move FROM, filtered to the current type.
    final source = (_toVault ? lib.manga : vault.manga)
        .where((m) => _typeOf(context, m) == type)
        .toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    final q = _query.trim().toLowerCase();
    final shown = q.isEmpty
        ? source
        : source.where((m) => m.title.toLowerCase().contains(q)).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(t.setdVaultContentsTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700, color: cs.onSurface)),
        actions: [
          IconButton(
            tooltip: _selectMode ? t.setdVaultContentsDone : t.setdVaultContentsSelect,
            icon: Icon(_selectMode ? Icons.close_rounded : Icons.checklist_rounded),
            onPressed: () => setState(() {
              _selectMode = !_selectMode;
              _selected.clear();
            }),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          labelColor: cs.primary,
          unselectedLabelColor: cs.onSurfaceVariant,
          indicatorColor: cs.primary,
          labelStyle: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontSize: 13.5, fontWeight: FontWeight.w700),
          tabs: [for (final l in labels) Tab(text: l)],
        ),
      ),
      body: Column(
        children: [
          // Direction toggle - the easy "move in / move out" switch.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                    value: true,
                    icon: const Icon(Icons.lock_outline_rounded, size: 18),
                    label: Text(t.setdVaultContentsDirToVault)),
                ButtonSegment(
                    value: false,
                    icon: const Icon(Icons.lock_open_rounded, size: 18),
                    label: Text(t.setdVaultContentsDirFromVault)),
              ],
              selected: {_toVault},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() {
                _toVault = s.first;
                _selected.clear();
                _selectMode = false;
              }),
            ),
          ),
          // Search + bulk actions.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: t.setdVaultContentsSearchHint,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: cs.outline),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: cs.outline),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: t.setdVaultContentsMoveCategoryTooltip,
                icon: const Icon(Icons.category_rounded, size: 20),
                onPressed: source.isEmpty ? null : () => _moveByCategory(source),
              ),
              IconButton.filledTonal(
                tooltip: _toVault
                    ? t.setdVaultContentsMoveAllToVault
                    : t.setdVaultContentsMoveAllOut,
                icon: const Icon(Icons.done_all_rounded, size: 20),
                onPressed: shown.isEmpty
                    ? null
                    : () => _confirmAndMove(
                        shown, t.setdVaultContentsMoveAllShown(shown.length)),
              ),
            ]),
          ),
          Expanded(
            child: shown.isEmpty
                ? _empty(cs, source.isEmpty
                    ? (_toVault
                        ? t.setdVaultContentsEmptyLibrary(
                            labels[_typeIndex].toLowerCase())
                        : t.setdVaultContentsEmptyVault(
                            labels[_typeIndex].toLowerCase()))
                    : t.setdVaultContentsNoMatches)
                : ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: (_selected.isEmpty ? 24 : 88) +
                            MediaQuery.viewPaddingOf(context).bottom),
                    itemCount: shown.length,
                    itemBuilder: (_, i) => _entryRow(cs, shown[i]),
                  ),
          ),
        ],
      ),
      bottomSheet: _selected.isEmpty
          ? null
          : _selectionBar(cs, shown),
    );
  }

  Widget _selectionBar(ColorScheme cs, List<LibraryManga> shown) {
    final t = AppLocalizations.of(context);
    final picked = shown.where((m) => _selected.contains(_key(m))).toList();
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, 10 + MediaQuery.viewPaddingOf(context).bottom),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(children: [
        TextButton(
          onPressed: () => setState(() {
            if (_selected.length == shown.length) {
              _selected.clear();
            } else {
              _selected
                ..clear()
                ..addAll(shown.map(_key));
            }
          }),
          child: Text(_selected.length == shown.length
              ? t.setdVaultContentsSelectNone
              : t.setdVaultContentsSelectAll),
        ),
        const Spacer(),
        Text(t.setdVaultContentsSelectedCount(picked.length),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: picked.isEmpty ? null : () => _move(picked, _toVault),
          icon: Icon(_toVault ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
              size: 18),
          label: Text(_toVault
              ? t.setdVaultContentsMoveToVault
              : t.setdVaultContentsMoveOut),
        ),
      ]),
    );
  }

  Widget _empty(ColorScheme cs, String text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        ),
      );

  Widget _entryRow(ColorScheme cs, LibraryManga m) {
    final t = AppLocalizations.of(context);
    final selected = _selected.contains(_key(m));
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 38,
          height: 52,
          child: MangaImage(imageUrl: m.coverUrl, fit: BoxFit.cover),
        ),
      ),
      title: Text(m.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600, color: cs.onSurface)),
      subtitle: Text(
          t.setdVaultContentsReadProgress(m.readChapters, m.totalChapters),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11.5, color: cs.onSurfaceVariant)),
      trailing: _selectMode
          ? Checkbox(
              value: selected,
              onChanged: (_) => _toggle(m),
            )
          : IconButton(
              tooltip: _toVault
                  ? t.setdVaultContentsMoveToVault
                  : t.setdVaultContentsMoveOut,
              icon: Icon(
                  _toVault ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                  color: _toVault ? cs.primary : cs.onSurfaceVariant),
              onPressed: () => _move([m], _toVault),
            ),
      onTap: () => _selectMode ? _toggle(m) : _move([m], _toVault),
      onLongPress: () {
        if (!_selectMode) setState(() => _selectMode = true);
        _toggle(m);
      },
    );
  }

  void _toggle(LibraryManga m) {
    setState(() {
      final k = _key(m);
      if (!_selected.remove(k)) _selected.add(k);
    });
  }
}
