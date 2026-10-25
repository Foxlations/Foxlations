/// Light-novel reader option lists, shared between the in-reader menu and the
/// Settings > Reader (Light novel) tab so the two stay in sync. Ids are the
/// values written to the `novel_*` prefs; labels are what the user sees.
library;

const List<(String, String)> novelFonts = [
  ('serif', 'Noto Serif'),
  ('lora', 'Lora'),
  ('merriweather', 'Merriweather'),
  ('bitter', 'Bitter'),
  ('literata', 'Literata'),
  ('ebGaramond', 'EB Garamond'),
  ('ptSerif', 'PT Serif'),
  ('sans', 'Noto Sans'),
  ('inter', 'Inter'),
  ('openSans', 'Open Sans'),
  ('nunitoSans', 'Nunito Sans'),
  ('atkinson', 'Atkinson Hyperlegible'),
  ('lexend', 'Lexend'),
  ('mono', 'Roboto Mono'),
];

const List<(String, String)> novelThemes = [
  ('default', 'Default'),
  ('sepia', 'Sepia'),
  ('warm', 'Warm'),
  ('gray', 'Gray'),
  ('oled', 'OLED'),
];

const List<(String, String)> novelAligns = [
  ('left', 'Left'),
  ('justify', 'Justify'),
  ('center', 'Center'),
];

/// Font-size bounds for the novel reader (shared with the settings mirror).
const double novelFontSizeMin = 12;
const double novelFontSizeMax = 30;
const double novelLineHeightMin = 1.2;
const double novelLineHeightMax = 2.4;
const double novelMarginMin = 8;
const double novelMarginMax = 48;
