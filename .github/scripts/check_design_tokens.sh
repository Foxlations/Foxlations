#!/usr/bin/env bash
# Design-system token guard (P3 of the consistency program).
#
# Fails if inline typography (GoogleFonts.manrope) or hardcoded colours
# (Color(0x...)) in lib/presentation/ grow beyond the baseline. The baseline is
# the set of INTENTIONAL exceptions left after the app-wide migration:
#   * GoogleFonts.manrope — the reading surfaces + over-page/over-video HUD and
#     the radar-chart CustomPainter (no BuildContext).
#   * Color(0x...) — brand colours (Discord, trackers), illustrative / chart /
#     heatmap hues, the theme-preset palette, per-category seeds, badge hues,
#     and over-image scrims.
#
# New UI must use Theme.of(context).textTheme and the theme / AppSurfaces /
# AppTheme tokens instead. If you genuinely need a new exception, bump the
# matching baseline below in the same commit and note why.
set -euo pipefail

BASE_FONTS=31
BASE_COLORS=125

cd "$(dirname "$0")/../.."

fonts=$(grep -rho 'GoogleFonts\.manrope' lib/presentation/ | wc -l | tr -d ' ')
colors=$(grep -rho 'Color(0x' lib/presentation/ | wc -l | tr -d ' ')

fail=0
if [ "$fonts" -gt "$BASE_FONTS" ]; then
  echo "::error::Inline GoogleFonts.manrope in lib/presentation/ grew to $fonts (baseline $BASE_FONTS)."
  echo "  Use Theme.of(context).textTheme.<slot>.copyWith(...) instead of GoogleFonts.manrope(...)."
  fail=1
fi
if [ "$colors" -gt "$BASE_COLORS" ]; then
  echo "::error::Hardcoded Color(0x…) in lib/presentation/ grew to $colors (baseline $BASE_COLORS)."
  echo "  Use colorScheme / AppSurfaces.of(context) / AppTheme tokens instead of a literal Color(0x…)."
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "design-token guard OK — fonts $fonts/$BASE_FONTS, colours $colors/$BASE_COLORS"
fi
exit "$fail"
