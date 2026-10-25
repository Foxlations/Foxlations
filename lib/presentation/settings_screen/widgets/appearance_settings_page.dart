import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'nav_order_page.dart';
import 'settings_tiles.dart';
import '../../../core/providers/nav_prefs_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';

// ── Theme Breed Data ─────────────────────────────────────────
class ThemeBreed {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final Color primaryLight;
  final Color primaryDark;
  final Color accentLight;
  final Color accentDark;
  final Color backgroundLight;
  final Color backgroundDark;

  const ThemeBreed({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.primaryLight,
    required this.primaryDark,
    required this.accentLight,
    required this.accentDark,
    required this.backgroundLight,
    required this.backgroundDark,
  });
}

const List<ThemeBreed> kThemeBreeds = [
  ThemeBreed(
    id: 'red_fox',
    name: 'Red Fox',
    emoji: '🦊',
    description: 'Classic orange & white',
    primaryLight: Color(0xFFE85D4A),
    primaryDark: Color(0xFFFF7A5C),
    accentLight: Color(0xFFF59E0B),
    accentDark: Color(0xFFFFB830),
    backgroundLight: Color(0xFFFFF8F5),
    backgroundDark: Color(0xFF1A1008),
  ),
  ThemeBreed(
    id: 'arctic_fox',
    name: 'Arctic Fox',
    emoji: '🤍',
    description: 'Snow white & ice blue',
    primaryLight: Color(0xFF5B9BD5),
    primaryDark: Color(0xFF90C8F0),
    accentLight: Color(0xFF7EC8E3),
    accentDark: Color(0xFFAEDFF7),
    backgroundLight: Color(0xFFF5F8FF),
    backgroundDark: Color(0xFF0D1520),
  ),
  ThemeBreed(
    id: 'silver_fox',
    name: 'Silver Fox',
    emoji: '🩶',
    description: 'Sleek black & silver',
    primaryLight: Color(0xFF6B7280),
    primaryDark: Color(0xFFB0B8C8),
    accentLight: Color(0xFF9CA3AF),
    accentDark: Color(0xFFD1D5DB),
    backgroundLight: Color(0xFFF4F5F7),
    backgroundDark: Color(0xFF0F1117),
  ),
  ThemeBreed(
    id: 'marble_fox',
    name: 'Marble Fox',
    emoji: '🖤',
    description: 'Black & white contrast',
    primaryLight: Color(0xFF1F2937),
    primaryDark: Color(0xFFF9FAFB),
    accentLight: Color(0xFF374151),
    accentDark: Color(0xFFE5E7EB),
    backgroundLight: Color(0xFFF9FAFB),
    backgroundDark: Color(0xFF111827),
  ),
  ThemeBreed(
    id: 'cross_fox',
    name: 'Cross Fox',
    emoji: '🟤',
    description: 'Warm brown & amber',
    primaryLight: Color(0xFF92400E),
    primaryDark: Color(0xFFD97706),
    accentLight: Color(0xFFB45309),
    accentDark: Color(0xFFF59E0B),
    backgroundLight: Color(0xFFFFFBF5),
    backgroundDark: Color(0xFF1C1208),
  ),
  ThemeBreed(
    id: 'fennec_fox',
    name: 'Fennec Fox',
    emoji: '🏜️',
    description: 'Sandy desert tones',
    primaryLight: Color(0xFFD4A574),
    primaryDark: Color(0xFFE8C49A),
    accentLight: Color(0xFFC8956C),
    accentDark: Color(0xFFDDB88A),
    backgroundLight: Color(0xFFFDF8F0),
    backgroundDark: Color(0xFF1A1508),
  ),
  ThemeBreed(
    id: 'digi_fox',
    name: 'Digi Fox',
    emoji: '💜',
    description: 'Digital purple & violet',
    primaryLight: Color(0xFF7C3AED),
    primaryDark: Color(0xFF9D5CF6),
    accentLight: Color(0xFFA855F7),
    accentDark: Color(0xFFC084FC),
    backgroundLight: Color(0xFFF5F0FF),
    backgroundDark: Color(0xFF0F0A1A),
  ),
];

// ── Appearance Settings Page ─────────────────────────────────
class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() =>
      _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  String _selectedBreedId = 'red_fox';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    setState(() {
      _selectedBreedId = context.read<ThemeProvider>().breedId;
    });
  }

  ThemeBreed get _currentBreed => kThemeBreeds.firstWhere(
        (b) => b.id == _selectedBreedId,
        orElse: () => kThemeBreeds.first,
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final primaryColor =
        isDark ? _currentBreed.primaryDark : _currentBreed.primaryLight;

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
        title: Text(t.setdAppearanceTitle),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          AppSettingsSectionHeader(title: t.setdAppearanceSectionTheme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.82,
              children: [
                for (final breed in kThemeBreeds)
                  _BreedTile(
                    breed: breed,
                    isSelected: breed.id == _selectedBreedId,
                    previewPrimary:
                        isDark ? breed.primaryDark : breed.primaryLight,
                    previewAccent:
                        isDark ? breed.accentDark : breed.accentLight,
                    previewBg: isDark ? breed.backgroundDark : breed.backgroundLight,
                    primaryColor: primaryColor,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedBreedId = breed.id);
                      context.read<ThemeProvider>().setBreed(breed.id);
                    },
                  ),
              ],
            ),
          ),
          _paletteSection(themeProvider, cs),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setdAppearanceSectionDisplay),
          _DarkModeTile(
            isDark: isDark,
            primaryColor: primaryColor,
            onToggle: () => themeProvider.toggleTheme(),
          ),
          _InvertColorsTile(
            value: themeProvider.invertColors,
            primaryColor: primaryColor,
            onChanged: themeProvider.setInvertColors,
          ),
          _OledTile(
            value: themeProvider.oledBlack,
            enabled: isDark,
            primaryColor: primaryColor,
            onChanged: themeProvider.setOledBlack,
          ),
          _NavOrderTile(primaryColor: primaryColor),
          _StartTabTile(primaryColor: primaryColor),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // Palette-flip strength: how far the theme's hue takes over the app surfaces.
  Widget _paletteSection(ThemeProvider tp, ColorScheme cs) {
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        AppSettingsSectionHeader(title: t.setdAppearanceSectionPalette),
        SettingsSliderTile(
          icon: Icons.format_color_fill_rounded,
          iconColor: cs.primary,
          title: t.setdAppearanceThemeStrength,
          value: tp.flipStrength * 100,
          min: 0,
          max: 100,
          divisions: 20,
          onChanged: (v) => tp.setFlipStrength(v / 100),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xs),
          child: Text(t.setdAppearanceThemeStrengthDesc,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: cs.outline)),
        ),
      ],
    );
  }
}

// ── Breed Tile ───────────────────────────────────────────────
class _BreedTile extends StatelessWidget {
  final ThemeBreed breed;
  final bool isSelected;
  final Color previewPrimary;
  final Color previewAccent;
  final Color previewBg;
  final Color primaryColor;
  final VoidCallback onTap;

  const _BreedTile({
    required this.breed,
    required this.isSelected,
    required this.previewPrimary,
    required this.previewAccent,
    required this.previewBg,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withAlpha(26)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected ? primaryColor : cs.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(children: [
                      Expanded(flex: 2, child: Container(color: previewPrimary)),
                      Expanded(flex: 1, child: Container(color: previewAccent)),
                      Expanded(flex: 1, child: Container(color: previewBg)),
                    ]),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
                      child: const Icon(Icons.check_rounded,
                          size: 12, color: Colors.white),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 6),
            Text('${breed.emoji} ${breed.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.onSurface)),
          ],
        ),
      ),
    );
  }
}

// ── Invert Colors Tile ───────────────────────────────────────
class _InvertColorsTile extends StatelessWidget {
  final bool value;
  final Color primaryColor;
  final ValueChanged<bool> onChanged;

  const _InvertColorsTile({
    required this.value,
    required this.primaryColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: oledIconChip(context,
                  color: primaryColor,
                  fill: primaryColor.withAlpha(25),
                  radius: 12.0),
              child: Icon(
                Icons.invert_colors_rounded,
                color: primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.setdAppearanceInvertColors,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.setdAppearanceInvertColorsDesc,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.outline),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: cs.onPrimary,
              activeTrackColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Navigation-bar reorder tile ──────────────────────────────
class _NavOrderTile extends StatelessWidget {
  final Color primaryColor;
  const _NavOrderTile({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const NavOrderPage())),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: oledIconChip(context,
                  color: primaryColor,
                  fill: primaryColor.withAlpha(25),
                  radius: 12.0),
              child: Icon(Icons.reorder_rounded, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.setdAppearanceNavOrder,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                  const SizedBox(height: 2),
                  Text(t.setdAppearanceNavOrderDesc,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.outline)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.outline),
          ],
        ),
      ),
    );
  }
}

// ── Launch-tab (Open to) choice tile ─────────────────────────
class _StartTabTile extends StatelessWidget {
  final Color primaryColor;
  const _StartTabTile({required this.primaryColor});

  // id -> localized label, in canonical order so the picker list is stable.
  Map<String, String> _labels(AppLocalizations t) => {
        'library': t.appNavLibrary,
        'updates': t.appNavUpdates,
        'browse': t.appNavBrowse,
        'discover': t.appNavDiscover,
        'more': t.appNavMore,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final nav = context.watch<NavPrefsProvider>();
    final labels = _labels(t);
    final current = labels[nav.startTabId] ?? labels['library']!;
    return GestureDetector(
      onTap: () => _pick(context, nav, labels, cs, t),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: oledIconChip(context,
                  color: primaryColor,
                  fill: primaryColor.withAlpha(25),
                  radius: 12.0),
              child: Icon(Icons.home_rounded, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.setdAppearanceStartTab,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                  const SizedBox(height: 2),
                  Text(t.setdAppearanceStartTabDesc,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.outline)),
                ],
              ),
            ),
            Text(current,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.outline)),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.chevron_right_rounded, color: cs.outline),
          ],
        ),
      ),
    );
  }

  void _pick(BuildContext context, NavPrefsProvider nav,
      Map<String, String> labels, ColorScheme cs, AppLocalizations t) {
    const icons = <String, IconData>{
      'library': Icons.collections_bookmark_rounded,
      'updates': Icons.update_rounded,
      'browse': Icons.explore_rounded,
      'discover': Icons.auto_awesome_rounded,
      'more': Icons.more_horiz_rounded,
    };
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(t.setdAppearanceStartTab,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            for (final e in labels.entries)
              ListTile(
                leading: Icon(icons[e.key] ?? Icons.home_rounded,
                    color: e.key == nav.startTabId ? cs.primary : cs.outline),
                title: Text(e.value),
                trailing: e.key == nav.startTabId
                    ? Icon(Icons.check_rounded, color: cs.primary)
                    : null,
                onTap: () {
                  nav.setStartTab(e.key);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── OLED Pure-Black Tile ─────────────────────────────────────
class _OledTile extends StatelessWidget {
  final bool value;

  /// OLED is a dark-mode option, so the control is disabled (and dimmed) when
  /// the app is in light mode. The stored preference is kept either way.
  final bool enabled;
  final Color primaryColor;
  final ValueChanged<bool> onChanged;

  const _OledTile({
    required this.value,
    required this.enabled,
    required this.primaryColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return GestureDetector(
      onTap: enabled ? () => onChanged(!value) : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: oledIconChip(context,
                    color: primaryColor,
                    fill: primaryColor.withAlpha(25),
                    radius: 12.0),
                child: Icon(Icons.contrast_rounded,
                    color: primaryColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.setdAppearanceOledBlack,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      enabled
                          ? t.setdAppearanceOledBlackDesc
                          : 'Only applies in dark mode',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.outline),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeThumbColor: cs.onPrimary,
                activeTrackColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dark Mode Tile ───────────────────────────────────────────
class _DarkModeTile extends StatelessWidget {
  final bool isDark;
  final Color primaryColor;
  final VoidCallback onToggle;

  const _DarkModeTile({
    required this.isDark,
    required this.primaryColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: oledIconChip(context,
                  color: primaryColor,
                  fill: primaryColor.withAlpha(25),
                  radius: 12.0),
              child: Icon(
                isDark
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDark ? t.setdAppearanceDarkMode : t.setdAppearanceLightMode,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDark ? t.setdAppearanceCurrentlyDark : t.setdAppearanceCurrentlyLight,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.outline),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (_) => onToggle(),
              activeThumbColor: cs.onPrimary,
              activeTrackColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
