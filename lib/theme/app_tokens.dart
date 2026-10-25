import 'package:flutter/material.dart';

/// Design tokens that fill the two gaps in [AppTheme] (see the design audit):
/// a spacing scale, and named surface roles so the ~16 near-identical dark
/// greys scattered across the app collapse to a handful of intentional tokens.
///
/// These are additive - nothing here changes existing screens until they're
/// migrated onto the tokens. New/updated UI should pad with [AppSpacing] and
/// read surfaces via `AppSurfaces.of(context)` instead of literal `Color(0x…)`.

/// 8-pt-ish spacing scale. The one real gap in the existing theme: padding was
/// previously picked per widget (7, 9, 10, 13, 15…), so nothing shared a
/// rhythm. Pad and gap with these.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Named surface roles, exposed as a [ThemeExtension] so they follow the active
/// theme (dark / OLED / light) automatically.
@immutable
class AppSurfaces extends ThemeExtension<AppSurfaces> {
  const AppSurfaces({
    required this.raised,
    required this.sunken,
    required this.panel,
    required this.chip,
    required this.hairline,
    required this.overlay,
  });

  /// A card or sheet sitting above the page.
  final Color raised;

  /// An inset "well" cut into a surface (e.g. the reader radial's inner window).
  final Color sunken;

  /// Body of a sheet, menu or popover.
  final Color panel;

  /// Chip / segmented-control background.
  final Color chip;

  /// 1px borders and dividers.
  final Color hairline;

  /// Scrim behind modals and the open radial.
  final Color overlay;

  /// Reads the surfaces for the current theme, falling back to [dark] if the
  /// extension isn't registered (so it's always safe to call).
  static AppSurfaces of(BuildContext context) =>
      Theme.of(context).extension<AppSurfaces>() ?? dark;

  /// True when the pure-black OLED theme is active (its surface is #000000).
  static bool isOled(BuildContext context) =>
      Theme.of(context).colorScheme.surface == const Color(0xFF000000);

  static const AppSurfaces dark = AppSurfaces(
    raised: Color(0xFF252538),
    sunken: Color(0xFF15141B),
    panel: Color(0xFF201E28),
    chip: Color(0xFF2A2A3E),
    hairline: Color(0xFF3A3A4E),
    overlay: Color(0x8C000000),
  );

  // OLED: every surface is pure black so unlit pixels stay off; structure is
  // kept with a slightly brighter hairline (borders + dividers) instead of
  // lighter fills. Chips keep a barely-there fill so they still read as
  // interactive.
  static const AppSurfaces oledDark = AppSurfaces(
    raised: Color(0xFF000000),
    sunken: Color(0xFF000000),
    panel: Color(0xFF000000),
    chip: Color(0xFF0C0C11),
    hairline: Color(0xFF30303A),
    overlay: Color(0xCC000000),
  );

  static const AppSurfaces light = AppSurfaces(
    raised: Color(0xFFFFFFFF),
    sunken: Color(0xFFF0F0F5),
    panel: Color(0xFFFFFFFF),
    chip: Color(0xFFE8E8EC),
    hairline: Color(0xFFD8D8DC),
    overlay: Color(0x66000000),
  );

  @override
  AppSurfaces copyWith({
    Color? raised,
    Color? sunken,
    Color? panel,
    Color? chip,
    Color? hairline,
    Color? overlay,
  }) {
    return AppSurfaces(
      raised: raised ?? this.raised,
      sunken: sunken ?? this.sunken,
      panel: panel ?? this.panel,
      chip: chip ?? this.chip,
      hairline: hairline ?? this.hairline,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppSurfaces lerp(ThemeExtension<AppSurfaces>? other, double t) {
    if (other is! AppSurfaces) return this;
    return AppSurfaces(
      raised: Color.lerp(raised, other.raised, t)!,
      sunken: Color.lerp(sunken, other.sunken, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      chip: Color.lerp(chip, other.chip, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}
