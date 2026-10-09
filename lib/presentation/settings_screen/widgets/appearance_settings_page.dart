import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'nav_order_page.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

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
        title: Text(
          t.setdAppearanceTitle,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: 8, bottom: 8 + MediaQuery.of(context).viewPadding.bottom),
        children: [
          _SectionHeader(title: t.setdAppearanceSectionTheme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.82,
              children: kThemeBreeds.map((breed) {
                final isSelected = breed.id == _selectedBreedId;
                final previewPrimary =
                    isDark ? breed.primaryDark : breed.primaryLight;
                final previewAccent =
                    isDark ? breed.accentDark : breed.accentLight;
                final previewBg =
                    isDark ? breed.backgroundDark : breed.backgroundLight;
                return _BreedTile(
                  breed: breed,
                  isSelected: isSelected,
                  previewPrimary: previewPrimary,
                  previewAccent: previewAccent,
                  previewBg: previewBg,
                  primaryColor: primaryColor,
                  onTap: () async {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedBreedId = breed.id);
                    context.read<ThemeProvider>().setBreed(breed.id);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          _SectionHeader(title: t.setdAppearanceSectionDisplay),
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
            primaryColor: primaryColor,
            onChanged: themeProvider.setOledBlack,
          ),
          _NavOrderTile(primaryColor: primaryColor),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: cs.primary,
        ),
      ),
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
        padding: const EdgeInsets.all(8),
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
                style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface)),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12.0),
              ),
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
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.setdAppearanceInvertColorsDesc,
                    style: GoogleFonts.manrope(
                        fontSize: 12, color: cs.outline),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(Icons.reorder_rounded, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.setdAppearanceNavOrder,
                      style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                  const SizedBox(height: 2),
                  Text(t.setdAppearanceNavOrderDesc,
                      style:
                          GoogleFonts.manrope(fontSize: 12, color: cs.outline)),
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

// ── OLED Pure-Black Tile ─────────────────────────────────────
class _OledTile extends StatelessWidget {
  final bool value;
  final Color primaryColor;
  final ValueChanged<bool> onChanged;

  const _OledTile({
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(Icons.contrast_rounded, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.setdAppearanceOledBlack,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.setdAppearanceOledBlackDesc,
                    style: GoogleFonts.manrope(fontSize: 12, color: cs.outline),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12.0),
              ),
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
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDark ? t.setdAppearanceCurrentlyDark : t.setdAppearanceCurrentlyLight,
                    style: GoogleFonts.manrope(
                        fontSize: 12, color: cs.outline),
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
