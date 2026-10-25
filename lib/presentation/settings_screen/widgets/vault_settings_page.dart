import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vault_provider.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/services/settings_store.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import 'vault_contents_page.dart';

class VaultSettingsPage extends StatelessWidget {
  const VaultSettingsPage({super.key});

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_rounded, size: 20, color: cs.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(t.setdVaultTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface)),
          ],
        ),
      ),
      body: Consumer<VaultProvider>(
        builder: (context, vault, _) {
          return ListView(
            padding: EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
            children: [
              AppSettingsSectionHeader(title: t.setdVaultSectionAccess),
              AppSettingsSwitchTile(
                icon: Icons.shield_rounded,
                iconColor: cs.primary,
                title: t.setdVaultEnable,
                subtitle:
                    t.setdVaultEnableDesc,
                value: vault.vaultEnabled,
                onChanged: (v) => vault.setVaultEnabled(v),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppSettingsSectionHeader(title: t.setdVaultSectionSecurity),
              AppSettingsNavTile(
                icon: Icons.lock_rounded,
                iconColor: AppTheme.warning,
                title: vault.hasPassword ? t.setdVaultChangePassword : t.setdVaultSetPassword,
                subtitle: vault.hasPassword
                    ? t.setdVaultPasswordSetDesc
                    : t.setdVaultPasswordUnsetDesc,
                onTap: () => _showPasswordDialog(context, vault),
              ),
              if (vault.hasPassword)
                AppSettingsNavTile(
                  icon: Icons.theater_comedy_rounded,
                  iconColor: AppTheme.warning,
                  title: vault.hasDecoyPassword
                      ? t.setdVaultChangeDecoyPassword
                      : t.setdVaultSetDecoyPassword,
                  subtitle: t.setdVaultDecoyPasswordDesc,
                  onTap: () => _showDecoyDialog(context, vault),
                ),
              if (vault.hasPassword)
                FutureBuilder<bool>(
                  future: vault.deviceSupportsBiometric(),
                  builder: (ctx, snap) {
                    if (snap.data != true) return const SizedBox.shrink();
                    return StatefulBuilder(
                      builder: (ctx, setLocal) => AppSettingsSwitchTile(
                        icon: Icons.fingerprint_rounded,
                        iconColor: cs.primary,
                        title: t.setdVaultBiometricUnlock,
                        subtitle: t.setdVaultBiometricDesc,
                        value: vault.biometricEnabled,
                        onChanged: (v) async {
                          if (v) {
                            final pw = await _promptPassword(
                                context, t.setdVaultConfirmPasswordTitle);
                            if (pw == null) return;
                            final ok = await vault.enableBiometric(pw);
                            if (context.mounted) {
                              AppTheme.showSnackBar(
                                  context,
                                  ok
                                      ? t.setdVaultBiometricEnabled
                                      : t.appWrongPassword);
                            }
                          } else {
                            await vault.disableBiometric();
                          }
                          setLocal(() {});
                        },
                      ),
                    );
                  },
                ),
              if (vault.vaultEnabled)
                StatefulBuilder(
                  builder: (ctx, setLocal) => AppSettingsSwitchTile(
                    icon: Icons.vibration_rounded,
                    iconColor: AppTheme.warning,
                    title: t.setdVaultShakeToExit,
                    subtitle: t.setdVaultShakeToExitDesc,
                    value:
                        SettingsStore.instance.getBool('vault_panic_shake') ?? false,
                    onChanged: (v) {
                      SettingsStore.instance.setBool('vault_panic_shake', v);
                      setLocal(() {});
                    },
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              AppSettingsSectionHeader(title: t.setdVaultSectionCategories),
              AppSettingsNavTile(
                icon: Icons.category_rounded,
                iconColor: AppTheme.secondary,
                title: t.setdVaultEditCategories,
                subtitle: t.setdVaultEditCategoriesDesc,
                onTap: () {
                  // Categories live in the vault's encrypted box, which is only
                  // open while unlocked. Editing it while locked silently fails
                  // (and the list reads back empty), so prompt to unlock first.
                  if (vault.hasPassword && !vault.isUnlocked) {
                    AppTheme.showSnackBar(
                        context, t.setdVaultUnlockFirstSnack);
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const _EditVaultCategoriesPage()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppSettingsSectionHeader(title: t.setdVaultSectionContents),
              AppSettingsNavTile(
                icon: Icons.swap_vert_rounded,
                iconColor: cs.primary,
                title: t.setdVaultManageContents,
                subtitle: t.setdVaultManageContentsDesc,
                onTap: () {
                  // Moving requires the vault unlocked, so prompt first when a
                  // password is set and it isn't open yet.
                  if (vault.hasPassword && !vault.isUnlocked) {
                    AppTheme.showSnackBar(
                        context, t.setdVaultUnlockFirstSnack);
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VaultContentsPage()),
                  );
                },
              ),
              if (vault.vaultEnabled)
                StatefulBuilder(
                  builder: (ctx, setLocal) => AppSettingsSwitchTile(
                    icon: Icons.drive_file_move_rounded,
                    iconColor: cs.primary,
                    title: t.setdVaultLibraryMoveAction,
                    subtitle: t.setdVaultLibraryMoveActionDesc,
                    value: SettingsStore.instance
                            .getBool('vault_show_library_move') ??
                        false,
                    onChanged: (v) {
                      SettingsStore.instance
                          .setBool('vault_show_library_move', v);
                      setLocal(() {});
                    },
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              AppSettingsSectionHeader(title: t.setdVaultSectionHiddenSources),
              AppSettingsNavTile(
                icon: Icons.visibility_off_rounded,
                iconColor: cs.primary,
                title: t.setdVaultOnlySources,
                subtitle: t.setdVaultHiddenSourcesCount(vault.vaultSourceIds.length),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const _HiddenSourcesPage()),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppSettingsSectionHeader(title: t.setdVaultSectionInfo),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(15),
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(color: cs.primary.withAlpha(40)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 18, color: cs.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t.setdVaultInfoText,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurface,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  /// Simple obscured-password prompt; returns the entered text or null if cancelled.
  Future<String?> _promptPassword(BuildContext context, String title) {
    final controller = TextEditingController();
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: t.setdVaultPasswordHint,
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t.setdActionCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: Text(t.setdActionConfirm)),
        ],
      ),
    );
  }

  void _showDecoyDialog(BuildContext context, VaultProvider vault) {
    final controller = TextEditingController();
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    String? error;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: cs.surface,
          title: Text(
              vault.hasDecoyPassword
                  ? t.setdVaultDecoyPasswordDialogTitle
                  : t.setdVaultSetDecoyPassword,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
                t.setdVaultDecoyPasswordExplain,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: t.setdVaultDecoyPasswordHint,
                errorText: error,
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
              ),
            ),
          ]),
          actions: [
            if (vault.hasDecoyPassword)
              TextButton(
                onPressed: () async {
                  await vault.setDecoyPassword(null);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(t.setdActionRemove,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: AppTheme.error)),
              ),
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t.setdActionCancel)),
            FilledButton(
              onPressed: () async {
                if (controller.text.isEmpty) {
                  setD(() => error = t.setdVaultEnterPassword);
                  return;
                }
                final ok = await vault.setDecoyPassword(controller.text);
                if (!ctx.mounted) return;
                if (ok) {
                  Navigator.pop(ctx);
                  AppTheme.showSnackBar(context, t.setdVaultDecoyPasswordSet);
                } else {
                  setD(() => error = t.setdVaultDecoyMustDiffer);
                }
              },
              child: Text(t.setdActionSave),
            ),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog(BuildContext context, VaultProvider vault) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    String? error;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: cs.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(vault.hasPassword ? t.setdVaultChangePassword : t.setdVaultSetPassword,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: cs.onSurface)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              if (vault.hasPassword)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: currentController,
                    obscureText: true,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
                    decoration: InputDecoration(
                      hintText: t.setdVaultCurrentPasswordHint,
                      hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.outline),
                      filled: true, fillColor: cs.surfaceContainerHighest,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              TextField(
                controller: newController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: t.setdVaultNewPasswordHint,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.outline),
                  filled: true, fillColor: cs.surfaceContainerHighest,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: t.setdVaultConfirmPasswordHint,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.outline),
                  errorText: error,
                  filled: true, fillColor: cs.surfaceContainerHighest,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t.setdActionCancel, style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.outline))),
              FilledButton(
                onPressed: () async {
                  // Verifying now derives the key and opens the encrypted
                  // boxes, so it's async and takes ~1s.
                  if (vault.hasPassword &&
                      !await vault.unlock(currentController.text)) {
                    setDialogState(() => error = t.setdVaultCurrentPasswordWrong);
                    return;
                  }
                  final newPw = newController.text;
                  final confirmPw = confirmController.text;
                  if (newPw.isNotEmpty && newPw != confirmPw) {
                    setDialogState(() => error = t.setdVaultPasswordsMismatch);
                    return;
                  }
                  setDialogState(() => error = newPw.isEmpty
                      ? t.setdVaultRemovingEncryption
                      : t.setdVaultEncrypting);
                  await vault.setPassword(newPw.isEmpty ? null : newPw);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  if (!context.mounted) return;
                  AppTheme.showSnackBar(
                      context,
                      newPw.isEmpty
                          ? t.setdVaultPasswordRemoved
                          : t.setdVaultPasswordSet);
                },
                style: FilledButton.styleFrom(backgroundColor: cs.primary),
                child: Text(t.setdActionSave, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: cs.onPrimary))),
            ],
          );
        },
      ),
    );
  }
}

// ── Edit Vault Categories Page ──────────────────────────────
class _EditVaultCategoriesPage extends StatelessWidget {
  const _EditVaultCategoriesPage();

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
        title: Text(t.setdVaultSectionCategories,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        child: const Icon(Icons.add_rounded),
      ),
      body: Consumer<VaultProvider>(
        builder: (context, vault, _) {
          final categories = vault.categories;

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category_outlined,
                      size: 64, color: cs.outline.withAlpha(128)),
                  const SizedBox(height: AppSpacing.lg),
                  Text(t.setdVaultNoCategories,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(t.setdTapToAddCategory,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: cs.outline)),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
            buildDefaultDragHandles: false,
            itemCount: categories.length,
            proxyDecorator: (child, index, animation) {
              return Material(
                elevation: 4,
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                child: child,
              );
            },
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final names = categories.map((c) => c.name).toList();
              final item = names.removeAt(oldIndex);
              names.insert(newIndex, item);
              vault.reorderCategories(names);
            },
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _CategoryTile(
                key: ValueKey(cat.name),
                name: cat.name,
                index: index,
                onRename: () => _showRenameDialog(context, vault, cat.name),
                onDelete: () => _showDeleteConfirm(context, vault, cat.name),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final vault = context.read<VaultProvider>();
    final controller = TextEditingController();
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        title: Text(t.setdNewCategory,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: t.setdCategoryNameHint,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.outline),
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                borderSide: BorderSide.none),
          ),
          onSubmitted: (value) {
            final name = value.trim();
            if (name.isNotEmpty) {
              vault.addCategory(name);
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.setdActionCancel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.outline)),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                vault.addCategory(name);
                Navigator.pop(ctx);
              }
            },
            child: Text(t.setdActionAdd,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.primary)),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
      BuildContext context, VaultProvider vault, String oldName) {
    final controller = TextEditingController(text: oldName);
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        title: Text(t.setdRenameCategory,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: t.setdCategoryNameHint,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.outline),
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                borderSide: BorderSide.none),
          ),
          onSubmitted: (value) {
            final name = value.trim();
            if (name.isNotEmpty && name != oldName) {
              vault.renameCategory(oldName, name);
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.setdActionCancel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.outline)),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty && name != oldName) {
                vault.renameCategory(oldName, name);
                Navigator.pop(ctx);
              }
            },
            child: Text(t.setdActionSave,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.primary)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(
      BuildContext context, VaultProvider vault, String name) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        title: Text(t.setdDeleteCategory,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: Text(
            t.setdVaultDeleteCategoryConfirm(name),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.setdActionCancel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.outline)),
          ),
          TextButton(
            onPressed: () {
              vault.removeCategory(name);
              Navigator.pop(ctx);
            },
            child: Text(t.setdActionDelete,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ──────────────────────────────────────────
class _CategoryTile extends StatelessWidget {
  final String name;
  final int index;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _CategoryTile({
    super.key,
    required this.name,
    required this.index,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.drag_handle_rounded,
                  size: 20, color: cs.outline),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface)),
          ),
          IconButton(
            icon: Icon(Icons.edit_rounded, size: 18, color: cs.outline),
            onPressed: onRename,
            splashRadius: 20,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                size: 18, color: AppTheme.error),
            onPressed: onDelete,
            splashRadius: 20,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}




// ── Hidden Sources Page ────────────────────────────────────
class _HiddenSourcesPage extends StatefulWidget {
  const _HiddenSourcesPage();

  @override
  State<_HiddenSourcesPage> createState() => _HiddenSourcesPageState();
}

class _HiddenSourcesPageState extends State<_HiddenSourcesPage> {
  String _query = '';

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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.setdVaultOnlySources,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: Consumer2<SourceProvider, VaultProvider>(
        builder: (context, sourceProvider, vault, _) {
          var installed = sourceProvider.installedSources;
          if (_query.isNotEmpty) {
            final q = _query.toLowerCase();
            installed = installed.where((s) => s.source.name.toLowerCase().contains(q)).toList();
          }
          if (installed.isEmpty && _query.isEmpty) {
            return Center(child: Text(t.setdVaultNoInstalledSources,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.outline)));
          }

          return ListView(
            padding: EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  t.setdVaultHiddenSourcesToggleHint,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.outline, height: 1.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: t.setdVaultSearchSourcesHint,
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.outline),
                    prefixIcon: Icon(Icons.search_rounded, size: 20, color: cs.outline),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              ...installed.map((s) {
                final source = s.source;
                final isHidden = vault.isSourceInVault(source.id);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isHidden ? cs.primary.withAlpha(15) : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: isHidden ? Border.all(color: cs.primary.withAlpha(80)) : null,
                  ),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: cs.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text(
                        source.name.isNotEmpty ? source.name[0].toUpperCase() : '?',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: cs.primary),
                      )),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(source.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600, color: cs.onSurface)),
                        Text(source.baseUrl, style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w400, color: cs.outline), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    )),
                    Switch(
                      value: isHidden,
                      onChanged: (_) => vault.toggleVaultSource(source.id),
                      activeThumbColor: cs.onPrimary,
                      activeTrackColor: cs.primary,
                    ),
                  ]),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
