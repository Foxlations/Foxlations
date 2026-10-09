import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/vault_provider.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/services/settings_store.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
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
            const SizedBox(width: 8),
            Text(t.setdVaultTitle,
                style: GoogleFonts.manrope(
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
                top: 8, bottom: 8 + MediaQuery.of(context).viewPadding.bottom),
            children: [
              _SectionHeader(title: t.setdVaultSectionAccess),
              _SwitchTile(
                icon: Icons.shield_rounded,
                iconColor: cs.primary,
                title: t.setdVaultEnable,
                subtitle:
                    t.setdVaultEnableDesc,
                value: vault.vaultEnabled,
                onChanged: (v) => vault.setVaultEnabled(v),
              ),
              const SizedBox(height: 8),
              _SectionHeader(title: t.setdVaultSectionSecurity),
              _NavTile(
                icon: Icons.lock_rounded,
                iconColor: AppTheme.warning,
                title: vault.hasPassword ? t.setdVaultChangePassword : t.setdVaultSetPassword,
                subtitle: vault.hasPassword
                    ? t.setdVaultPasswordSetDesc
                    : t.setdVaultPasswordUnsetDesc,
                onTap: () => _showPasswordDialog(context, vault),
              ),
              if (vault.hasPassword)
                _NavTile(
                  icon: Icons.theater_comedy_rounded,
                  iconColor: AppTheme.warning,
                  title: vault.hasDecoyPassword
                      ? 'Change decoy password'
                      : 'Set decoy password',
                  subtitle:
                      'A second password that opens a separate, empty-looking vault',
                  onTap: () => _showDecoyDialog(context, vault),
                ),
              if (vault.hasPassword)
                FutureBuilder<bool>(
                  future: vault.deviceSupportsBiometric(),
                  builder: (ctx, snap) {
                    if (snap.data != true) return const SizedBox.shrink();
                    return StatefulBuilder(
                      builder: (ctx, setLocal) => _SwitchTile(
                        icon: Icons.fingerprint_rounded,
                        iconColor: cs.primary,
                        title: 'Unlock with biometrics',
                        subtitle: 'Use Face ID / fingerprint to open the vault',
                        value: vault.biometricEnabled,
                        onChanged: (v) async {
                          if (v) {
                            final pw = await _promptPassword(
                                context, 'Confirm vault password');
                            if (pw == null) return;
                            final ok = await vault.enableBiometric(pw);
                            if (context.mounted) {
                              AppTheme.showSnackBar(
                                  context,
                                  ok
                                      ? 'Biometric unlock enabled'
                                      : 'Wrong password');
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
                  builder: (ctx, setLocal) => _SwitchTile(
                    icon: Icons.vibration_rounded,
                    iconColor: AppTheme.warning,
                    title: 'Shake to exit',
                    subtitle:
                        'While in the vault, shake the phone to instantly leave it',
                    value:
                        SettingsStore.instance.getBool('vault_panic_shake') ?? false,
                    onChanged: (v) {
                      SettingsStore.instance.setBool('vault_panic_shake', v);
                      setLocal(() {});
                    },
                  ),
                ),
              const SizedBox(height: 8),
              _SectionHeader(title: t.setdVaultSectionCategories),
              _NavTile(
                icon: Icons.category_rounded,
                iconColor: AppTheme.secondary,
                title: t.setdVaultEditCategories,
                subtitle: t.setdVaultEditCategoriesDesc,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const _EditVaultCategoriesPage()),
                ),
              ),
              const SizedBox(height: 8),
              _SectionHeader(title: t.setdVaultSectionContents),
              _NavTile(
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
                  builder: (ctx, setLocal) => _SwitchTile(
                    icon: Icons.drive_file_move_rounded,
                    iconColor: cs.primary,
                    title: 'Move-to-vault in library',
                    subtitle:
                        'Add a "Move to vault" action when selecting titles in your library',
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
              const SizedBox(height: 8),
              _SectionHeader(title: t.setdVaultSectionHiddenSources),
              _NavTile(
                icon: Icons.visibility_off_rounded,
                iconColor: cs.primary,
                title: t.setdVaultOnlySources,
                subtitle: t.setdVaultHiddenSourcesCount(vault.vaultSourceIds.length),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const _HiddenSourcesPage()),
                ),
              ),
              const SizedBox(height: 8),
              _SectionHeader(title: t.setdVaultSectionInfo),
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
                          style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: cs.onSurface,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(title,
            style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          style: GoogleFonts.manrope(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Password',
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
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Confirm')),
        ],
      ),
    );
  }

  void _showDecoyDialog(BuildContext context, VaultProvider vault) {
    final controller = TextEditingController();
    final cs = Theme.of(context).colorScheme;
    String? error;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: cs.surface,
          title: Text(
              vault.hasDecoyPassword ? 'Decoy password' : 'Set decoy password',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
                'Entering this instead of your real password opens a separate, '
                'isolated vault — so you can hand over the phone without revealing '
                'your real content.',
                style: GoogleFonts.manrope(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              style: GoogleFonts.manrope(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Decoy password',
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
                child: Text('Remove',
                    style: GoogleFonts.manrope(color: AppTheme.error)),
              ),
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (controller.text.isEmpty) {
                  setD(() => error = 'Enter a password');
                  return;
                }
                final ok = await vault.setDecoyPassword(controller.text);
                if (!ctx.mounted) return;
                if (ok) {
                  Navigator.pop(ctx);
                  AppTheme.showSnackBar(context, 'Decoy password set');
                } else {
                  setD(() => error = 'Must differ from your real password');
                }
              },
              child: const Text('Save'),
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
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: cs.onSurface)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              if (vault.hasPassword)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: currentController,
                    obscureText: true,
                    style: GoogleFonts.manrope(fontSize: 14, color: cs.onSurface),
                    decoration: InputDecoration(
                      hintText: t.setdVaultCurrentPasswordHint,
                      hintStyle: GoogleFonts.manrope(fontSize: 14, color: cs.outline),
                      filled: true, fillColor: cs.surfaceContainerHighest,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              TextField(
                controller: newController,
                obscureText: true,
                style: GoogleFonts.manrope(fontSize: 14, color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: t.setdVaultNewPasswordHint,
                  hintStyle: GoogleFonts.manrope(fontSize: 14, color: cs.outline),
                  filled: true, fillColor: cs.surfaceContainerHighest,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                style: GoogleFonts.manrope(fontSize: 14, color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: t.setdVaultConfirmPasswordHint,
                  hintStyle: GoogleFonts.manrope(fontSize: 14, color: cs.outline),
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
                child: Text(t.setdActionCancel, style: GoogleFonts.manrope(
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
                child: Text(t.setdActionSave, style: GoogleFonts.manrope(fontWeight: FontWeight.w700))),
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
            style: GoogleFonts.manrope(
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
                  const SizedBox(height: 16),
                  Text(t.setdVaultNoCategories,
                      style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                  const SizedBox(height: 8),
                  Text(t.setdTapToAddCategory,
                      style:
                          GoogleFonts.manrope(fontSize: 13, color: cs.outline)),
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
            style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.manrope(fontSize: 14, color: cs.onSurface),
          decoration: InputDecoration(
            hintText: t.setdCategoryNameHint,
            hintStyle: GoogleFonts.manrope(fontSize: 14, color: cs.outline),
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
                style: GoogleFonts.manrope(
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
                style: GoogleFonts.manrope(
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
            style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.manrope(fontSize: 14, color: cs.onSurface),
          decoration: InputDecoration(
            hintText: t.setdCategoryNameHint,
            hintStyle: GoogleFonts.manrope(fontSize: 14, color: cs.outline),
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
                style: GoogleFonts.manrope(
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
                style: GoogleFonts.manrope(
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
            style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: Text(
            t.setdVaultDeleteCategoryConfirm(name),
            style: GoogleFonts.manrope(fontSize: 14, color: cs.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.setdActionCancel,
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600, color: cs.outline)),
          ),
          TextButton(
            onPressed: () {
              vault.removeCategory(name);
              Navigator.pop(ctx);
            },
            child: Text(t.setdActionDelete,
                style: GoogleFonts.manrope(
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(name,
                style: GoogleFonts.manrope(
                    fontSize: 14,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(title.toUpperCase(),
          style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: cs.primary)),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface)),
              Text(subtitle,
                  style: GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: cs.onPrimary,
          activeTrackColor: cs.primary,
        ),
      ]),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface)),
                  Text(subtitle,
                      style: GoogleFonts.manrope(
                          fontSize: 12, color: cs.outline)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20),
          ],
        ),
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
            style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
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
                style: GoogleFonts.manrope(fontSize: 14, color: cs.outline)));
          }

          return ListView(
            padding: EdgeInsets.only(
                top: 8, bottom: 8 + MediaQuery.of(context).viewPadding.bottom),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  t.setdVaultHiddenSourcesToggleHint,
                  style: GoogleFonts.manrope(fontSize: 12, color: cs.outline, height: 1.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  style: GoogleFonts.manrope(fontSize: 14, color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: t.setdVaultSearchSourcesHint,
                    hintStyle: GoogleFonts.manrope(fontSize: 14, color: cs.outline),
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
                        style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: cs.primary),
                      )),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(source.name, style: GoogleFonts.manrope(
                            fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
                        Text(source.baseUrl, style: GoogleFonts.manrope(
                            fontSize: 11, color: cs.outline), maxLines: 1, overflow: TextOverflow.ellipsis),
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
