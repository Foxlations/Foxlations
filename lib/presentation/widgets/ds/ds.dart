// Foxlations design-system primitives (P1 of the consistency program).
//
// Small, composable widgets built ENTIRELY on the tokens - AppSpacing,
// AppSurfaces, the ColorScheme, the Manrope textTheme and AppTheme's radius /
// motion. No inline GoogleFonts, no literal Color(0x…). Screens compose these
// instead of restyling from scratch; every one is previewed in the Widgetbook
// gallery (widgetbook/main.dart) across Dark / OLED / Light.
import 'package:flutter/material.dart';

import 'package:manga_reader/theme/app_theme.dart';
import 'package:manga_reader/theme/app_tokens.dart';

/// Decoration for a small tinted icon chip. In OLED the fill drops to
/// transparent (the pure-black surface shows through) and the colour moves to a
/// hairline outline, so the chip reads via its outline + icon instead of a lit
/// fill. In every other theme it keeps [fill] exactly as before.
BoxDecoration oledIconChip(
  BuildContext context, {
  required Color color,
  required Color fill,
  double? radius,
}) {
  final oled = AppSurfaces.isOled(context);
  return BoxDecoration(
    color: oled ? Colors.transparent : fill,
    borderRadius: BorderRadius.circular(radius ?? AppTheme.radiusMedium),
    border: oled ? Border.all(color: color.withValues(alpha: 0.5)) : null,
  );
}

/// Uppercase caps section header, e.g. "READING MODE". Pairs a label with an
/// optional trailing action.
class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel(
    this.text, {
    super.key,
    this.trailing,
    this.padding,
    this.color,
  });

  final String text;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  /// Overrides the label colour (defaults to the secondary-text token). Pass a
  /// theme token such as `colorScheme.primary`, never a literal.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: 0.8,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    );
    return Padding(
      padding:
          padding ??
          const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(text.toUpperCase(), style: style)),
          ?trailing,
        ],
      ),
    );
  }
}

/// The base surface container - consistent fill, radius, border and padding.
/// [sunken] uses the inset-well colour; pass [onTap] for a tappable card.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.sunken = false,
    this.border = true,
    this.radius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool sunken;
  final bool border;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final s = AppSurfaces.of(context);
    final r = radius ?? AppTheme.radiusMedium;
    final bg = sunken ? s.sunken : s.raised;
    final shape = BorderRadius.circular(r);
    final decoration = BoxDecoration(
      borderRadius: shape,
      border: border ? Border.all(color: s.hairline) : null,
    );
    if (onTap == null) {
      return Container(
        padding: padding,
        decoration: decoration.copyWith(color: bg),
        child: child,
      );
    }
    return Material(
      color: bg,
      borderRadius: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}

// ── Settings tiles ───────────────────────────────────────────────────────────
// Shared settings-page rows. Every Settings sub-page used to re-declare its own
// private _SectionHeader / _SwitchTile / _ChoiceTile / _NavTile; these are the
// single canonical versions so they can't drift.

/// An accent section header for a Settings page group.
class AppSettingsSectionHeader extends StatelessWidget {
  final String title;
  const AppSettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppSectionLabel(
      title,
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
    );
  }
}

/// A Settings navigation row - icon chip + title/subtitle + chevron.
class AppSettingsNavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AppSettingsNavTile({
    super.key,
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
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 3,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: AppSpacing.md,
        ),
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
              decoration: oledIconChip(
                context,
                color: iconColor,
                fill: iconColor.withAlpha(25),
                radius: 10,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: cs.outline),
                  ),
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

/// A Settings switch row. [titleTrailing] (e.g. a BETA badge) sits next to the
/// title when provided.
class AppSettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? titleTrailing;

  const AppSettingsSwitchTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.titleTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            decoration: oledIconChip(
              context,
              color: iconColor,
              fill: iconColor.withAlpha(25),
              radius: 10,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    if (titleTrailing != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      titleTrailing!,
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.outline),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: cs.onPrimary,
            activeTrackColor: cs.primary,
          ),
        ],
      ),
    );
  }
}

/// A Settings choice row - opens a bottom-sheet picker of [options].
class AppSettingsChoiceTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const AppSettingsChoiceTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 3,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: AppSpacing.md,
        ),
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
              decoration: oledIconChip(
                context,
                color: iconColor,
                fill: iconColor.withAlpha(25),
                radius: 10,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.outline),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      // Scroll-controlled + height-capped so a long option list (e.g. the 14
      // reader fonts) scrolls instead of overflowing off the bottom.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      // One bounded, scrollable ListView holds the whole sheet: a Flexible +
      // shrinkWrap list inside a min-height Column doesn't get a real scroll
      // extent, so a long list just sprang back. This scrolls reliably.
      builder: (_) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.7),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              Divider(color: cs.outlineVariant),
              ...options.map((opt) {
                final isSelected = opt == value;
                return InkWell(
                  onTap: () {
                    onChanged(opt);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primary.withAlpha(26)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: cs.onSurface,
                                ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_rounded, size: 18, color: cs.primary),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
