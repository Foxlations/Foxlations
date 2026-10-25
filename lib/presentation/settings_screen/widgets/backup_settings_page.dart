import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/library_provider.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/providers/vault_provider.dart';
import '../../../core/services/backup_service.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import '../../../l10n/app_localizations.dart';

class BackupSettingsPage extends StatefulWidget {
  const BackupSettingsPage({super.key});

  @override
  State<BackupSettingsPage> createState() => _BackupSettingsPageState();
}

class _BackupSettingsPageState extends State<BackupSettingsPage> {
  final _service = BackupService();
  List<BackupFile> _backups = [];
  BackupFrequency _frequency = BackupFrequency.off;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final backups = await _service.listBackups();
    final freq = await _service.getFrequency();
    if (mounted) {
      setState(() {
        _backups = backups;
        _frequency = freq;
      });
    }
  }

  /// [verb] is a stable token ('backup' or 'export') that selects the localized
  /// success/failure snackbar, not a display string.
  Future<void> _run(Future<String> Function() action, String verb) async {
    final t = AppLocalizations.of(context);
    final isExport = verb == 'export';
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) {
        AppTheme.showSnackBar(context,
            isExport ? t.setxBackupExportComplete : t.setxBackupCreateComplete);
      }
    } catch (e) {
      if (mounted) {
        AppTheme.showSnackBar(
            context,
            isExport
                ? t.setxBackupExportFailed('$e')
                : t.setxBackupCreateFailed('$e'));
      }
    }
    if (mounted) setState(() => _busy = false);
    await _refresh();
  }

  /// Floating dialog: pick a target app, then the content types it supports,
  /// Make sure the vault is unlocked so it can be included in a backup. No-op if
  /// there's no vault password (or it's already unlocked). Tries Face/Touch ID
  /// first (when enabled), then a password prompt. Returns true if usable.
  Future<bool> _ensureVaultUnlocked() async {
    final vault = context.read<VaultProvider>();
    if (!vault.hasPassword || vault.isUnlocked) return true;
    if (vault.biometricEnabled && await vault.unlockWithBiometric()) return true;
    if (!mounted) return false;
    final t = AppLocalizations.of(context);
    final controller = TextEditingController();
    final pw = await showDialog<String>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text(t.backupUnlockVaultTitle),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(hintText: t.backupUnlockVaultHint),
          onSubmitted: (v) => Navigator.pop(dctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, null),
              child: Text(t.appCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(dctx, controller.text),
              child: Text(t.appUnlock)),
        ],
      ),
    );
    final ok = (pw != null && pw.isNotEmpty) ? await vault.unlock(pw) : false;
    controller.dispose();
    return ok;
  }

  /// Create a Foxlations .fox backup. Vault titles are excluded by default; if
  /// the user has a vault they can opt to include them (unlock-gated).
  Future<void> _createFoxBackup() async {
    final t = AppLocalizations.of(context);
    if (!context.read<VaultProvider>().vaultEnabled) {
      await _run(() => _service.createBackup(), 'backup');
      return;
    }
    var inclVault = false;
    final proceed = await showDialog<bool>(
      context: context,
      builder: (dctx) {
        final cs = Theme.of(dctx).colorScheme;
        return StatefulBuilder(builder: (dctx, setD) {
          return AlertDialog(
            title: Text(t.setxBackupCreateTitle,
                style: Theme.of(dctx).textTheme.titleMedium?.copyWith(
                    fontSize: 17, fontWeight: FontWeight.w700)),
            content: CheckboxListTile(
              value: inclVault,
              onChanged: (v) async {
                if (v == true) {
                  if (await _ensureVaultUnlocked()) {
                    setD(() => inclVault = true);
                  }
                } else {
                  setD(() => inclVault = false);
                }
              },
              title: Text(t.backupIncludeVault,
                  style: Theme.of(dctx).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500)),
              subtitle: Text(t.backupIncludeVaultSubtitle,
                  style: Theme.of(dctx).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400, color: cs.outline)),
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dctx, false),
                  child: Text(t.appCancel)),
              FilledButton(
                  onPressed: () => Navigator.pop(dctx, true),
                  child: Text(t.setxBackupCreateTitle)),
            ],
          );
        });
      },
    );
    if (proceed != true) return;
    await _run(() => _service.createBackup(includeVault: inclVault), 'backup');
  }

  /// then create a backup made compatible with that app.
  Future<void> _exportCompatDialog() async {
    var target = BackupTarget.all.first;
    var inclManga = true, inclAnime = true, inclNovels = true;
    var inclVault = false;
    final t = AppLocalizations.of(context);
    final vaultEnabled = context.read<VaultProvider>().vaultEnabled;
    await showDialog<void>(
      context: context,
      builder: (dctx) {
        final cs = Theme.of(dctx).colorScheme;
        return StatefulBuilder(builder: (dctx, setD) {
          Widget typeTile(String label, bool value, ValueChanged<bool> onCh) =>
              CheckboxListTile(
                value: value,
                onChanged: (v) => setD(() => onCh(v ?? false)),
                title: Text(label,
                    style: Theme.of(dctx).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500)),
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              );
          // At least one type must stay selected for the Create button.
          final anySelected = (target.manga && inclManga) ||
              (target.anime && inclAnime) ||
              (target.novel && inclNovels);
          return AlertDialog(
            title: Text(t.setxBackupCreateCompatTitle,
                style: Theme.of(dctx).textTheme.titleMedium?.copyWith(
                    fontSize: 17, fontWeight: FontWeight.w700)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<BackupTarget>(
                initialValue: target,
                isExpanded: true,
                decoration: InputDecoration(
                    labelText: t.setxBackupTargetApp,
                    border: const OutlineInputBorder()),
                items: [
                  for (final tg in BackupTarget.all)
                    DropdownMenuItem(value: tg, child: Text(tg.label)),
                ],
                onChanged: (v) => setD(() => target = v ?? target),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(t.setxBackupIncludeLabel,
                    style: Theme.of(dctx).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.outline)),
              ),
              if (target.manga)
                typeTile(t.browseManga, inclManga, (v) => inclManga = v),
              if (target.anime)
                typeTile(t.browseAnime, inclAnime, (v) => inclAnime = v),
              if (target.novel)
                typeTile(t.setxBackupTypeNovels, inclNovels, (v) => inclNovels = v),
              // Vault opt-in - off by default; checking it unlocks the vault
              // (Face/Touch ID or password) before the titles are included.
              if (vaultEnabled) ...[
                const Divider(height: 16),
                CheckboxListTile(
                  value: inclVault,
                  onChanged: (v) async {
                    if (v == true) {
                      final ok = await _ensureVaultUnlocked();
                      if (ok) setD(() => inclVault = true);
                    } else {
                      setD(() => inclVault = false);
                    }
                  },
                  title: Text(t.backupIncludeVault,
                      style: Theme.of(dctx).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500)),
                  subtitle: Text(t.backupIncludeVaultSubtitle,
                      style: Theme.of(dctx).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w400, color: cs.outline)),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dctx),
                  child: Text(t.appCancel,
                      style: const TextStyle(fontWeight: FontWeight.w600))),
              FilledButton(
                onPressed: anySelected
                    ? () {
                        Navigator.pop(dctx);
                        _run(
                            () => _service.createCompatBackup(
                                target: target,
                                includeManga: inclManga,
                                includeAnime: inclAnime,
                                includeNovels: inclNovels,
                                includeVault: inclVault),
                            'export');
                      }
                    : null,
                child: Text(t.setxBackupCreateTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _restoreFrom({required bool tachiyomi}) async {
    final res = await FilePicker.pickFiles(type: FileType.any);
    final path = res?.files.single.path;
    if (path == null || !mounted) return;
    // Confirm before importing - the one backup action that changes the library.
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text(t.backupRestoreConfirmTitle),
        content: Text(t.backupRestoreConfirmBody(path.split('/').last)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: Text(t.appCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(dctx, true),
              child: Text(t.setxBackupRestoreTitle)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    // A .fox carrying vault titles → unlock the vault first so they're restored
    // INTO the vault. If it stays locked they're simply skipped (never leaked to
    // the public library); declining the unlock is fine.
    if (!tachiyomi && await _service.backupHasVault(path) && mounted) {
      final vault = context.read<VaultProvider>();
      if (vault.hasPassword && !vault.isUnlocked) {
        await _ensureVaultUnlocked();
      }
    }
    if (!mounted) return;
    await _restorePath(path, tachiyomi: tachiyomi);
  }

  Future<void> _restorePath(String path, {required bool tachiyomi}) async {
    final t = AppLocalizations.of(context);
    setState(() => _busy = true);
    // Snapshot existing category names so we can offer to organize only the
    // ones the backup adds (not pre-existing ones with unrelated items).
    final before =
        context.read<LibraryProvider>().categories.map((c) => c.name).toSet();
    try {
      if (tachiyomi) {
        // id -> display name. Tachiyomi backups name their sources, so the
        // matcher needs the names; passing ids alone could never match.
        final installed = {
          for (final s in context.read<SourceProvider>().installedSources)
            s.source.id: s.source.name,
        };
        final n = await _service.restoreTachiyomiBackup(path,
            installedSources: installed);
        if (mounted) AppTheme.showSnackBar(context, t.setxBackupImportedManga(n));
      } else {
        await _service.restoreBackup(path);
        if (mounted) AppTheme.showSnackBar(context, t.setxBackupRestoreComplete);
      }
      if (mounted) {
        await context.read<LibraryProvider>().reload();
        // Vault titles the backup carried were routed into the vault box - reflect
        // them if the vault's unlocked (no-op when locked).
        context.read<VaultProvider>().reloadIfOpen();
        await context.read<SourceProvider>().refreshRepos();
        // Re-link any entries that matched a source only by name onto the real
        // installed id, so they're not stranded if the source was already here.
        if (mounted) {
          final map = context.read<SourceProvider>().installedIdToName;
          await context.read<LibraryProvider>().relinkSources(map);
        }
      }
    } catch (e) {
      if (mounted) AppTheme.showSnackBar(context, t.setxBackupRestoreFailed(e.toString()));
    }
    if (mounted) setState(() => _busy = false);
    await _refresh();
    // Offer to organize the categories the backup just added (keep as-is, map
    // to a library category, or send to a vault category).
    if (mounted) {
      final lib = context.read<LibraryProvider>();
      final newCats = lib.categories
          .map((c) => c.name)
          .where((n) =>
              n.isNotEmpty &&
              n != 'Vault' &&
              !n.startsWith('Vault-') &&
              !before.contains(n) &&
              lib.manga.any((m) => m.categories.contains(n)))
          .toList();
      if (newCats.isNotEmpty) await _offerOrganize(newCats);
    }
  }

  /// After an import, let the user remap the newly-added categories: keep each,
  /// send it to an existing library category, or (after unlocking) a vault
  /// category. Import already happened as-is, so cancelling changes nothing.
  Future<void> _offerOrganize(List<String> newCats) async {
    final lib = context.read<LibraryProvider>();
    final vault = context.read<VaultProvider>();
    final counts = {
      for (final c in newCats)
        c: lib.manga.where((m) => m.categories.contains(c)).length,
    };
    final result = await showDialog<Map<String, _MapTarget>>(
      context: context,
      builder: (_) => _CategoryMapDialog(
        categories: newCats,
        counts: counts,
        // Public library categories ONLY - vault categories reach the dropdown
        // solely through the "Show vault categories" toggle (and only unlocked).
        libraryCategories: lib.categories
            .map((c) => c.name)
            .where((n) => n != 'Vault' && !n.startsWith('Vault-'))
            .toList(),
        vault: vault,
      ),
    );
    if (result == null || !mounted) return;
    await _applyMapping(result);
  }

  Future<void> _applyMapping(Map<String, _MapTarget> mapping) async {
    final t = AppLocalizations.of(context);
    final lib = context.read<LibraryProvider>();
    final vault = context.read<VaultProvider>();
    setState(() => _busy = true);
    var moved = 0;
    try {
      for (final entry in mapping.entries) {
        final fromCat = entry.key;
        final target = entry.value;
        if (target.keep) continue;
        // Snapshot the affected items first (the list mutates as we reassign).
        final items = lib.manga
            .where((m) => m.categories.contains(fromCat))
            .toList();
        if (target.vaultCat != null) {
          // Send to the vault: copy entry + chapters into the vault box under
          // the chosen vault category, then remove from the library.
          if (!vault.categories.any((c) => c.name == target.vaultCat)) {
            await vault.addCategory(target.vaultCat!);
          }
          for (final m in items) {
            final chapters = lib.fullChapters(m.sourceId, m.url);
            final clone = m.clone()..categories = [target.vaultCat!];
            await vault.addEntryWithChapters(clone, chapters);
            await lib.removeFromLibrary(m.sourceId, m.url);
            moved++;
          }
        } else if (target.libraryCat != null) {
          if (!lib.categories.any((c) => c.name == target.libraryCat)) {
            await lib.addCategory(target.libraryCat!);
          }
          for (final m in items) {
            final next = {...m.categories}
              ..remove(fromCat)
              ..add(target.libraryCat!);
            await lib.setMangaCategories(m.sourceId, m.url, next.toList());
            moved++;
          }
        }
      }
      await lib.reload();
    } catch (e) {
      if (mounted) {
        AppTheme.showSnackBar(context, t.setxBackupRestoreFailed(e.toString()));
      }
    }
    if (mounted) {
      setState(() => _busy = false);
      AppTheme.showSnackBar(context, t.backupOrganizeDone(moved));
    }
    await _refresh();
  }

  Future<void> _pickFrequency() async {
    final choice = await showModalBottomSheet<BackupFrequency>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final f in BackupFrequency.values)
            RadioListTile<BackupFrequency>(
              value: f,
              groupValue: _frequency,
              onChanged: (v) => Navigator.pop(context, v),
              title: Text(_freqLabel(f)),
            ),
        ]),
      ),
    );
    if (choice != null) {
      await _service.setFrequency(choice);
      await _refresh();
    }
  }

  String _freqLabel(BackupFrequency f) {
    final t = AppLocalizations.of(context);
    switch (f) {
      case BackupFrequency.off:
        return t.setxBackupFreqOff;
      case BackupFrequency.daily:
        return t.setxBackupFreqDaily;
      case BackupFrequency.weekly:
        return t.setxBackupFreqWeekly;
      case BackupFrequency.monthly:
        return t.setxBackupFreqMonthly;
    }
  }

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
            onPressed: () => Navigator.pop(context)),
        title: Text(t.setxBackupTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: Stack(children: [
        ListView(padding: EdgeInsets.only(top: 8, bottom: 8 + MediaQuery.viewPaddingOf(context).bottom), children: [
          _header(t.setxBackupSectionFoxlations, cs),
          _action(Icons.save_rounded, t.setxBackupCreateTitle,
              t.setxBackupCreateSubtitle, cs, _createFoxBackup),
          _action(Icons.restore_rounded, t.setxBackupRestoreTitle,
              t.setxBackupRestoreSubtitle, cs,
              () => _restoreFrom(tachiyomi: false)),
          _header(t.setxBackupSectionTachiyomi, cs),
          _action(Icons.ios_share_rounded, t.setxBackupCreateCompatTitle,
              t.setxBackupCreateCompatSubtitle,
              cs, _exportCompatDialog),
          _action(Icons.download_rounded, t.setxBackupRestoreTachiyomiTitle,
              t.setxBackupRestoreTachiyomiSubtitle,
              cs, () => _restoreFrom(tachiyomi: true)),
          _header(t.setxBackupSectionAutomatic, cs),
          ListTile(
            leading: _iconBox(Icons.schedule_rounded, cs),
            title: Text(t.setxBackupFrequency,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600)),
            subtitle: Text(t.setxBackupAutoSubtitle(_freqLabel(_frequency).toLowerCase()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
            trailing: Text(_freqLabel(_frequency),
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: cs.primary)),
            onTap: _pickFrequency,
          ),
          _header(t.setxBackupSectionBackups(_backups.length), cs),
          if (_backups.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Text(t.setxBackupNone,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.5, color: cs.outline)),
            )
          else
            ..._backups.map((b) => _backupRow(b, cs)),
          const SizedBox(height: 24),
        ]),
        if (_busy)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ]),
    );
  }

  Widget _header(String t, ColorScheme cs) => AppSectionLabel(
        t,
        color: cs.primary,
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 18, AppSpacing.lg, 6),
      );

  Widget _iconBox(IconData icon, ColorScheme cs) => Container(
        width: 40,
        height: 40,
        decoration: oledIconChip(context,
            color: cs.primary, fill: cs.primary.withAlpha(25), radius: 10),
        child: Icon(icon, color: cs.primary, size: 20),
      );

  Widget _action(IconData icon, String title, String subtitle, ColorScheme cs,
          VoidCallback onTap) =>
      ListTile(
        leading: _iconBox(icon, cs),
        title: Text(title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
        onTap: _busy ? null : onTap,
      );

  Widget _backupRow(BackupFile b, ColorScheme cs) {
    final t = AppLocalizations.of(context);
    final kb = (b.sizeBytes / 1024).toStringAsFixed(0);
    return ListTile(
      leading: Icon(
        b.isTachiyomi ? Icons.swap_horiz_rounded : Icons.archive_rounded,
        color: b.isAuto ? cs.outline : cs.primary,
      ),
      title: Text(b.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 13.5, fontWeight: FontWeight.w600)),
      subtitle: Text(
        '${b.isTachiyomi ? 'Tachiyomi/Mihon' : 'Foxlations'}'
        '${b.isAuto ? ' · ${t.setxBackupAutoTag}' : ''} · $kb KB',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11.5, color: cs.outline),
      ),
      trailing: PopupMenuButton<String>(
        icon: Icon(Icons.more_vert_rounded, color: cs.outline),
        onSelected: (v) {
          if (v == 'restore') {
            _restorePath(b.path, tachiyomi: b.isTachiyomi);
          } else if (v == 'delete') {
            _service.deleteBackup(b.path).then((_) => _refresh());
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'restore', child: Text(t.setxBackupMenuRestore)),
          PopupMenuItem(value: 'delete', child: Text(t.setxBackupMenuDelete)),
        ],
      ),
    );
  }
}

/// Where a backup category should go. All three null-ish → keep as its own.
class _MapTarget {
  final String? libraryCat; // → this existing/new library category
  final String? vaultCat; // → this vault category (requires unlock)
  const _MapTarget({this.libraryCat, this.vaultCat});
  bool get keep => libraryCat == null && vaultCat == null;
  static const _MapTarget keepTarget = _MapTarget();
}

/// Post-import mapping dialog: one row per newly-added backup category, each
/// with a target picker (Keep / a library category / a vault category). Vault
/// categories only appear after the vault is unlocked.
class _CategoryMapDialog extends StatefulWidget {
  final List<String> categories;
  final Map<String, int> counts;
  final List<String> libraryCategories;
  final VaultProvider vault;
  const _CategoryMapDialog({
    required this.categories,
    required this.counts,
    required this.libraryCategories,
    required this.vault,
  });

  @override
  State<_CategoryMapDialog> createState() => _CategoryMapDialogState();
}

class _CategoryMapDialogState extends State<_CategoryMapDialog> {
  final Map<String, _MapTarget> _targets = {};
  bool _showVault = false;
  bool _unlocking = false;
  final _pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (final c in widget.categories) {
      _targets[c] = _MapTarget.keepTarget;
    }
  }

  @override
  void dispose() {
    _pwController.dispose();
    super.dispose();
  }

  bool get _vaultReady => widget.vault.isUnlocked;

  List<String> get _vaultCats =>
      widget.vault.categories.map((c) => c.name).toList();

  Future<void> _tryUnlock() async {
    setState(() => _unlocking = true);
    final ok = await widget.vault.unlock(_pwController.text);
    if (!mounted) return;
    setState(() => _unlocking = false);
    if (ok) {
      _pwController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    // Encode targets as unique dropdown values.
    final vaultShown = _showVault && _vaultReady;
    String valueOf(_MapTarget m) => (m.vaultCat != null && vaultShown)
        ? 'v:${m.vaultCat}'
        : (m.libraryCat != null ? 'l:${m.libraryCat}' : 'keep');

    return AlertDialog(
      backgroundColor: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
      title: Text(t.backupOrganizeTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700, color: cs.onSurface)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.backupOrganizePrompt(widget.categories.length),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.outline)),
              const SizedBox(height: 12),
              ...widget.categories.map((c) {
                final target = _targets[c]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface)),
                            Text(t.backupOrganizeItemCount(widget.counts[c] ?? 0),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w400, color: cs.outline)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: valueOf(target),
                        underline: const SizedBox.shrink(),
                        items: [
                          DropdownMenuItem(
                              value: 'keep', child: Text(t.backupOrganizeKeep)),
                          ...widget.libraryCategories.map((lc) =>
                              DropdownMenuItem(
                                  value: 'l:$lc', child: Text(lc))),
                          if (_showVault && _vaultReady)
                            ..._vaultCats.map((vc) => DropdownMenuItem(
                                value: 'v:$vc',
                                child: Text(t.backupOrganizeVaultPrefix(vc)))),
                        ],
                        onChanged: (v) {
                          setState(() {
                            if (v == null || v == 'keep') {
                              _targets[c] = _MapTarget.keepTarget;
                            } else if (v.startsWith('v:')) {
                              _targets[c] =
                                  _MapTarget(vaultCat: v.substring(2));
                            } else {
                              _targets[c] =
                                  _MapTarget(libraryCat: v.substring(2));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(t.backupOrganizeShowVault,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface)),
                  ),
                  Switch(
                    value: _showVault,
                    onChanged: (v) => setState(() {
                      _showVault = v;
                      // Turning vault targets off reverts any vault selection to
                      // Keep, so a now-hidden vault value can't linger.
                      if (!v) {
                        _targets.updateAll((k, tgt) =>
                            tgt.vaultCat != null ? _MapTarget.keepTarget : tgt);
                      }
                    }),
                  ),
                ],
              ),
              // Vault is locked → inline unlock before its categories appear.
              if (_showVault && !_vaultReady) ...[
                if (widget.vault.hasPassword) ...[
                  Text(t.backupOrganizeUnlockVault,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.outline)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _pwController,
                        obscureText: true,
                        decoration: const InputDecoration(isDense: true),
                        onSubmitted: (_) => _tryUnlock(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _unlocking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : TextButton(
                            onPressed: _tryUnlock, child: Text(t.appUnlock)),
                  ]),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.backupOrganizeKeepAll),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _targets),
          child: Text(t.backupOrganizeApply),
        ),
      ],
    );
  }
}
