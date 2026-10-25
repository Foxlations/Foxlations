# Foxlations component gallery (Widgetbook)

A dev-only catalogue of the design system. It renders the **real app theme and
widgets**, so it can't drift from the app — change a token, hot-reload, and
every entry updates. It is never part of the shipped build (`widgetbook` is a
`dev_dependency`).

## Run it

```
flutter run -t widgetbook/main.dart -d <device>
```

- `-d chrome` / `-d macos` / `-d windows` is usually the fastest to iterate in.
- Use the **theme switcher** in the top toolbar to flip **Dark / OLED / Light**,
  and the **text-scale** addon to check large-font layouts.

## What's in it

- **Tokens → Colour** — the `ColorScheme`, the `AppSurfaces` roles, and the
  semantic colours, as labelled swatches with hex values.
- **Tokens → Type scale** — every Manrope text style in the theme.
- **Tokens → Spacing & radius** — the `AppSpacing` scale and the radius tokens.
- **Components** — the eight P1 primitives from
  `lib/presentation/widgets/ds/ds.dart`: AppSectionLabel, AppCard, AppChip,
  AppSliderRow, AppStatCard, AppEmptyState, AppIconPill and AppSheet, each
  previewed (and some interactive) in every theme.

## Adding a component (P1 onward)

Add a `WidgetbookUseCase` under the relevant `WidgetbookComponent` in
`widgetbook/main.dart`, wrapping the widget in `_Gallery(child: …)` so it gets
the padded, theme-aware scaffold. Keep real example content (titles, chapters)
rather than lorem ipsum.
