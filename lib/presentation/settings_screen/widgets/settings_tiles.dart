import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/beta_badge.dart';
import '../../widgets/ds/ds.dart';

/// Uppercase caps section header for the settings screens, with an optional beta
/// badge. Shared between the reader settings page and its sub-pages so they read
/// as one screen.
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final bool beta;
  const SettingsSectionHeader({super.key, required this.title, this.beta = false});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(children: [
        Text(title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: cs.primary)),
        if (beta) ...[const SizedBox(width: 8), const BetaBadge()],
      ]),
    );
  }
}

/// A carded slider row: tinted icon chip, title, a pill showing the current
/// value, and the slider itself. Used throughout the reader settings.
class SettingsSliderTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  const SettingsSliderTile(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.title,
      required this.value,
      required this.min,
      required this.max,
      this.divisions,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Column(children: [
        Row(children: [
          Container(
              width: 36,
              height: 36,
              decoration: oledIconChip(context,
                  color: iconColor, fill: iconColor.withAlpha(25), radius: 10),
              child: Icon(icon, color: iconColor, size: 18)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600, color: cs.onSurface))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: cs.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull)),
            child: Text(
                value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700, color: cs.primary)),
          ),
        ]),
        SliderTheme(
            data: SliderThemeData(
                activeTrackColor: cs.primary,
                inactiveTrackColor: cs.surface,
                thumbColor: cs.primary,
                overlayColor: cs.primary.withAlpha(26)),
            child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged)),
      ]),
    );
  }
}
