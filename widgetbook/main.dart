// Foxlations component gallery (Widgetbook).
//
// A dev-only catalogue of the design system: tokens now, shared components as
// they land in P1. It renders the REAL app theme, so it can't drift from the
// app. Not part of the shipped build.
//
//   flutter run -t widgetbook/main.dart -d <device>
//
// Use the theme switcher (top toolbar) to flip Dark / OLED / Light.
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'package:manga_reader/theme/app_theme.dart';
import 'package:manga_reader/theme/app_tokens.dart';
import 'package:manga_reader/presentation/widgets/ds/ds.dart';

void main() => runApp(const FoxlationsBook());

class FoxlationsBook extends StatelessWidget {
  const FoxlationsBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Dark', data: AppTheme.darkTheme()),
            WidgetbookTheme(name: 'OLED', data: AppTheme.darkTheme(oled: true)),
            WidgetbookTheme(name: 'Light', data: AppTheme.lightTheme()),
          ],
        ),
        TextScaleAddon(min: 1.0, max: 2.0),
      ],
      directories: [
        WidgetbookFolder(
          name: 'Tokens',
          children: [
            WidgetbookComponent(
              name: 'Colour',
              useCases: [
                WidgetbookUseCase(
                    name: 'Palette',
                    builder: (context) => const _Gallery(child: _ColourSheet())),
              ],
            ),
            WidgetbookComponent(
              name: 'Type scale',
              useCases: [
                WidgetbookUseCase(
                    name: 'Manrope',
                    builder: (context) => const _Gallery(child: _TypeSheet())),
              ],
            ),
            WidgetbookComponent(
              name: 'Spacing & radius',
              useCases: [
                WidgetbookUseCase(
                    name: 'Scales',
                    builder: (context) =>
                        const _Gallery(child: _SpacingRadiusSheet())),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Components',
          children: [
            WidgetbookComponent(name: 'AppSectionLabel', useCases: [
              WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const _Gallery(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSectionLabel('Reading mode'),
                            AppSectionLabel('Eye comfort'),
                          ],
                        ),
                      )),
            ]),
            WidgetbookComponent(name: 'AppCard', useCases: [
              WidgetbookUseCase(
                  name: 'Variants',
                  builder: (context) => _Gallery(
                        child: Column(
                          children: [
                            const AppCard(child: Text('Raised card')),
                            const SizedBox(height: AppSpacing.md),
                            const AppCard(
                                sunken: true, child: Text('Sunken well')),
                            const SizedBox(height: AppSpacing.md),
                            AppCard(
                                onTap: () {},
                                child: const Text('Tappable card')),
                          ],
                        ),
                      )),
            ]),
          ],
        ),
      ],
    );
  }
}

// ── shared scaffold for a use-case ──────────────────────────────────────────
class _Gallery extends StatelessWidget {
  const _Gallery({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: child,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.lg),
      child: Text(text.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.1, fontWeight: FontWeight.w800)),
    );
  }
}

// ── colour ──────────────────────────────────────────────────────────────────
class _ColourSheet extends StatelessWidget {
  const _ColourSheet();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = AppSurfaces.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Scheme'),
        _swatches([
          _Sw('primary', cs.primary),
          _Sw('secondary', cs.secondary),
          _Sw('surface', cs.surface),
          _Sw('onSurface', cs.onSurface),
          _Sw('onSurfaceVariant', cs.onSurfaceVariant),
          _Sw('outline', cs.outline),
          _Sw('outlineVariant', cs.outlineVariant),
        ]),
        const _SectionLabel('Surface roles (AppSurfaces)'),
        _swatches([
          _Sw('raised', s.raised),
          _Sw('sunken', s.sunken),
          _Sw('panel', s.panel),
          _Sw('chip', s.chip),
          _Sw('hairline', s.hairline),
        ]),
        const _SectionLabel('Semantic'),
        _swatches([
          _Sw('success', AppTheme.success),
          _Sw('warning', AppTheme.warning),
          _Sw('error', AppTheme.error),
        ]),
      ],
    );
  }

  Widget _swatches(List<_Sw> items) => Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: items,
      );
}

class _Sw extends StatelessWidget {
  const _Sw(this.name, this.color);
  final String name;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hex = '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: cs.outlineVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          Text(hex,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ── type ──────────────────────────────────────────────────────────────────
class _TypeSheet extends StatelessWidget {
  const _TypeSheet();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final rows = <(String, TextStyle?)>[
      ('displayLarge', t.displayLarge),
      ('displayMedium', t.displayMedium),
      ('titleLarge', t.titleLarge),
      ('titleMedium', t.titleMedium),
      ('titleSmall', t.titleSmall),
      ('bodyLarge', t.bodyLarge),
      ('bodyMedium', t.bodyMedium),
      ('bodySmall', t.bodySmall),
      ('labelLarge', t.labelLarge),
      ('labelMedium', t.labelMedium),
      ('labelSmall', t.labelSmall),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, style) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: t.labelSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                Text('Star-Embracing Swordmaster', style: style),
              ],
            ),
          ),
      ],
    );
  }
}

// ── spacing & radius ───────────────────────────────────────────────────────
class _SpacingRadiusSheet extends StatelessWidget {
  const _SpacingRadiusSheet();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final spacing = <(String, double)>[
      ('xs 4', AppSpacing.xs),
      ('sm 8', AppSpacing.sm),
      ('md 12', AppSpacing.md),
      ('lg 16', AppSpacing.lg),
      ('xl 24', AppSpacing.xl),
      ('xxl 32', AppSpacing.xxl),
    ];
    final radii = <(String, double)>[
      ('small 6', AppTheme.radiusSmall),
      ('medium 12', AppTheme.radiusMedium),
      ('large 20', AppTheme.radiusLarge),
      ('full 100', AppTheme.radiusFull),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Spacing'),
        for (final (name, v) in spacing)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              SizedBox(width: 72, child: Text(name, style: Theme.of(context).textTheme.labelMedium)),
              Container(width: v, height: 14, color: cs.primary),
            ]),
          ),
        const _SectionLabel('Radius'),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final (name, r) in radii)
              Column(children: [
                Container(
                  width: 72,
                  height: 56,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(r),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(name, style: Theme.of(context).textTheme.labelSmall),
              ]),
          ],
        ),
      ],
    );
  }
}
