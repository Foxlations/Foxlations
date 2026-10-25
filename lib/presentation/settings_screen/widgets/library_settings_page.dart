import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/library_provider.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/models/library_settings.dart';
import '../../../core/services/library_update_service.dart';
import '../../../core/services/settings_store.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import 'source_migrate_screen.dart';

class LibrarySettingsPage extends StatefulWidget {
  const LibrarySettingsPage({super.key});

  @override
  State<LibrarySettingsPage> createState() => _LibrarySettingsPageState();
}

class _LibrarySettingsPageState extends State<LibrarySettingsPage> {
  bool _hideEmptyCategories = false;
  LibraryContinueMode _continueMode = LibraryContinueMode.banner;
  String _defaultCategory = '';
  bool _wifiOnly = true;
  bool _chargingOnly = false;
  String _updateFrequency = 'Manual';
  bool _skipNotStarted = false;
  bool _skipHasUnread = false;
  bool _skipCompleted = false;
  bool _showUpdateCount = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _hideEmptyCategories =
          SettingsStore.instance.getBool('lib_hide_empty_cats') ?? false;
      _continueMode = LibraryContinueMode.values.firstWhere(
        (m) => m.name == SettingsStore.instance.getString('lib_continue_mode'),
        orElse: () => LibraryContinueMode.banner,
      );
      _defaultCategory =
          SettingsStore.instance.getString('lib_default_category') ?? '';
      _wifiOnly = SettingsStore.instance.getBool('lib_update_wifi_only') ?? true;
      _chargingOnly =
          SettingsStore.instance.getBool('lib_update_charging_only') ?? false;
      _updateFrequency =
          SettingsStore.instance.getString('lib_update_frequency') ?? 'Manual';
      _skipNotStarted =
          SettingsStore.instance.getBool('lib_skip_not_started') ?? false;
      _skipHasUnread =
          SettingsStore.instance.getBool('lib_skip_has_unread') ?? false;
      _skipCompleted =
          SettingsStore.instance.getBool('lib_skip_completed') ?? false;
      _showUpdateCount =
          SettingsStore.instance.getBool('lib_show_update_count') ?? true;
    });
  }

  Future<void> _save(String key, dynamic value) async {
    if (value is bool) await SettingsStore.instance.setBool(key, value);
    if (value is String) await SettingsStore.instance.setString(key, value);
  }

  /// Re-fetch every library item's cover from its source, with a cancellable
  /// progress dialog (sequential on iOS; see LibraryUpdateService.refreshCovers).
  Future<void> _refreshCovers() async {
    final lib = context.read<LibraryProvider>();
    final src = context.read<SourceProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context);
    final total = lib.manga.length;
    if (total == 0) {
      messenger.showSnackBar(
          SnackBar(content: Text(t.setdLibraryNoItemsToRefresh)));
      return;
    }

    final progress = ValueNotifier<int>(0);
    var cancelled = false;
    BuildContext? dialogCtx;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogCtx = ctx;
        final cs = Theme.of(ctx).colorScheme;
        return AlertDialog(
          backgroundColor: cs.surface,
          title: Text(t.setdLibraryRefreshingCovers),
          content: ValueListenableBuilder<int>(
            valueListenable: progress,
            builder: (_, done, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: done / total,
                    minHeight: 8,
                    color: cs.primary,
                    backgroundColor: cs.onSurface.withAlpha(38),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('$done / $total', textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                cancelled = true;
                Navigator.of(ctx).pop();
              },
              child: Text(t.readerTtsStop),
            ),
          ],
        );
      },
    );

    final changed = await LibraryUpdateService.refreshCovers(
      sourceProvider: src,
      libraryProvider: lib,
      shouldCancel: () => cancelled,
      onProgress: (done, _) => progress.value = done,
    );
    progress.dispose();

    // Close the progress dialog (unless the user already tapped Stop).
    if (!cancelled && (dialogCtx?.mounted ?? false)) {
      Navigator.of(dialogCtx!).pop();
    }
    messenger.showSnackBar(SnackBar(
      content: Text(cancelled
          ? t.setdLibraryCoverRefreshStopped
          : t.setdLibraryCoversRefreshed(changed)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    // Default-category chooser: "Always ask" plus every existing category.
    final categoryNames =
        context.watch<LibraryProvider>().categories.map((c) => c.name).toList();
    final defaultCategoryDisplay = categoryNames.contains(_defaultCategory)
        ? _defaultCategory
        : t.setdLibraryAlwaysAsk;

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
          t.setdLibraryTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          AppSettingsSectionHeader(title: t.setdLibrarySectionContinueReading),
          AppSettingsChoiceTile(
            icon: Icons.play_circle_outline_rounded,
            iconColor: cs.primary,
            title: t.setdLibraryContinueShowAs,
            value: _continueMode.label,
            options: LibraryContinueMode.values.map((m) => m.label).toList(),
            onChanged: (v) {
              final mode = LibraryContinueMode.values.firstWhere(
                (m) => m.label == v,
                orElse: () => LibraryContinueMode.banner,
              );
              setState(() => _continueMode = mode);
              _save('lib_continue_mode', mode.name);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setdLibrarySectionCategories),
          AppSettingsNavTile(
            icon: Icons.category_rounded,
            iconColor: cs.primary,
            title: t.setdLibraryEditCategories,
            subtitle: t.setdLibraryEditCategoriesDesc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _EditCategoriesPage()),
            ),
          ),
          AppSettingsSwitchTile(
            icon: Icons.folder_off_rounded,
            iconColor: cs.primary,
            title: t.setdLibraryHideEmpty,
            subtitle: t.setdLibraryHideEmptyDesc,
            value: _hideEmptyCategories,
            onChanged: (v) { setState(() => _hideEmptyCategories = v); _save('lib_hide_empty_cats', v); },
          ),
          AppSettingsChoiceTile(
            icon: Icons.label_rounded,
            iconColor: cs.primary,
            title: t.setdLibraryDefaultCategory,
            value: defaultCategoryDisplay,
            options: [t.setdLibraryAlwaysAsk, ...categoryNames],
            onChanged: (v) {
              final name = v == t.setdLibraryAlwaysAsk ? '' : v;
              setState(() => _defaultCategory = name);
              _save('lib_default_category', name);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setdLibrarySectionGlobalUpdate),
          AppSettingsChoiceTile(
            icon: Icons.schedule_rounded,
            iconColor: AppTheme.success,
            title: t.setdLibraryUpdateFrequency,
            value: _updateFrequency,
            options: const [
              'Manual',
              'Every 12 hours',
              'Daily',
              'Every 2 days',
              'Weekly',
            ],
            onChanged: (v) { setState(() => _updateFrequency = v); _save('lib_update_frequency', v); },
          ),
          AppSettingsSwitchTile(
            icon: Icons.wifi_rounded,
            iconColor: AppTheme.success,
            title: t.setdLibraryWifiOnly,
            subtitle: t.setdLibraryWifiOnlyDesc,
            value: _wifiOnly,
            onChanged: (v) { setState(() => _wifiOnly = v); _save('lib_update_wifi_only', v); },
          ),
          AppSettingsSwitchTile(
            icon: Icons.battery_charging_full_rounded,
            iconColor: AppTheme.success,
            title: t.setdLibraryChargingOnly,
            subtitle: t.setdLibraryChargingOnlyDesc,
            value: _chargingOnly,
            onChanged: (v) { setState(() => _chargingOnly = v); _save('lib_update_charging_only', v); },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setdLibrarySectionRestrictions),
          AppSettingsSwitchTile(
            icon: Icons.visibility_off_rounded,
            iconColor: AppTheme.warning,
            title: t.setdLibrarySkipNotStarted,
            subtitle: t.setdLibrarySkipNotStartedDesc,
            value: _skipNotStarted,
            onChanged: (v) { setState(() => _skipNotStarted = v); _save('lib_skip_not_started', v); },
          ),
          AppSettingsSwitchTile(
            icon: Icons.mark_email_unread_rounded,
            iconColor: AppTheme.warning,
            title: t.setdLibrarySkipHasUnread,
            subtitle: t.setdLibrarySkipHasUnreadDesc,
            value: _skipHasUnread,
            onChanged: (v) { setState(() => _skipHasUnread = v); _save('lib_skip_has_unread', v); },
          ),
          AppSettingsSwitchTile(
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppTheme.warning,
            title: t.setdLibrarySkipCompleted,
            subtitle: t.setdLibrarySkipCompletedDesc,
            value: _skipCompleted,
            onChanged: (v) { setState(() => _skipCompleted = v); _save('lib_skip_completed', v); },
          ),
          AppSettingsSwitchTile(
            icon: Icons.notifications_active_rounded,
            iconColor: AppTheme.warning,
            title: t.setdLibraryShowUpdateCount,
            subtitle: t.setdLibraryShowUpdateCountDesc,
            value: _showUpdateCount,
            onChanged: (v) { setState(() => _showUpdateCount = v); _save('lib_show_update_count', v); },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setdLibrarySectionData),
          AppSettingsNavTile(
            icon: Icons.swap_horiz_rounded,
            iconColor: cs.primary,
            title: t.setdLibraryMigrateSource,
            subtitle: t.setdLibraryMigrateSourceDesc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SourceMigrateScreen()),
            ),
          ),
          AppSettingsNavTile(
            icon: Icons.image_search_rounded,
            iconColor: cs.primary,
            title: t.setdLibraryRefreshCovers,
            subtitle: t.setdLibraryRefreshCoversDesc,
            onTap: _refreshCovers,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// ── Edit Categories Page ────────────────────────────────────
class _EditCategoriesPage extends StatelessWidget {
  const _EditCategoriesPage();

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
        title: Text(t.setdLibraryEditCategories,
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
      body: Consumer<LibraryProvider>(
        builder: (context, library, _) {
          final categories = library.categories;

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category_outlined,
                      size: 64, color: cs.outline.withAlpha(128)),
                  const SizedBox(height: AppSpacing.lg),
                  Text(t.setdLibraryNoCategories,
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
            padding: const EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, 80),
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
              library.reorderCategories(names);
            },
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _CategoryTile(
                key: ValueKey(cat.name),
                name: cat.name,
                index: index,
                onRename: () =>
                    _showRenameDialog(context, library, cat.name),
                onDelete: () =>
                    _showDeleteConfirm(context, library, cat.name),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final library = context.read<LibraryProvider>();
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
            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: Theme.of(ctx)
              .textTheme
              .bodyLarge
              ?.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: t.setdCategoryNameHint,
            hintStyle: Theme.of(ctx)
                .textTheme
                .bodyLarge
                ?.copyWith(color: cs.outline),
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                borderSide: BorderSide.none),
          ),
          onSubmitted: (value) {
            final name = value.trim();
            if (name.isNotEmpty) {
              library.addCategory(name);
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.setdActionCancel,
                style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.outline)),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                library.addCategory(name);
                Navigator.pop(ctx);
              }
            },
            child: Text(t.setdActionAdd,
                style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.primary)),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
      BuildContext context, LibraryProvider library, String oldName) {
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
            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: Theme.of(ctx)
              .textTheme
              .bodyLarge
              ?.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: t.setdCategoryNameHint,
            hintStyle: Theme.of(ctx)
                .textTheme
                .bodyLarge
                ?.copyWith(color: cs.outline),
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                borderSide: BorderSide.none),
          ),
          onSubmitted: (value) {
            final name = value.trim();
            if (name.isNotEmpty && name != oldName) {
              library.renameCategory(oldName, name);
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.setdActionCancel,
                style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.outline)),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty && name != oldName) {
                library.renameCategory(oldName, name);
                Navigator.pop(ctx);
              }
            },
            child: Text(t.setdActionSave,
                style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.primary)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(
      BuildContext context, LibraryProvider library, String name) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        title: Text(t.setdDeleteCategory,
            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: Text(
            t.setdLibraryDeleteCategoryConfirm(name),
            style: Theme.of(ctx)
                .textTheme
                .bodyLarge
                ?.copyWith(color: cs.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.setdActionCancel,
                style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: cs.outline)),
          ),
          TextButton(
            onPressed: () {
              library.removeCategory(name);
              Navigator.pop(ctx);
            },
            child: Text(t.setdActionDelete,
                style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}

// ── Category Tile (used in Edit Categories page) ────────────
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
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

