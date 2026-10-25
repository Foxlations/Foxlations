import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/ds/ds.dart';
import 'settings_tiles.dart';
import 'hands_free_scroll_settings_page.dart';
import '../../../core/providers/beta_provider.dart';
import '../../../core/services/settings_store.dart';
import '../../reader_screen/widgets/radial_menu_settings_page.dart';
import '../../novel_reader_screen/novel_reader_options.dart';

/// Reader preference keys. The reader screen and ReaderProvider read from
/// these same keys, so toggling here takes effect on the next chapter open.
class ReaderPrefs {
  // Stored as int (ReadingMode enum index). Same key the reader uses.
  static const readingMode = 'reader_reading_mode';
  static const scaleType = 'reader_scale_type';
  static const navLayout = 'reader_nav_layout';
  static const bgColor = 'reader_bg_color';
  static const keepScreenOn = 'reader_keep_screen_on';
  static const showPageNumber = 'reader_show_page_num';
  static const fullscreen = 'reader_fullscreen';
  static const grayscale = 'reader_grayscale';
  static const warmTint = 'reader_warm_tint';
  static const brightness = 'reader_brightness';
  static const dualPage = 'reader_dual_page';
  static const dualPageSplit = 'reader_dual_page_split';
  static const invertColors = 'reader_invert_colors';
  static const invertTapZones = 'reader_invert_tap';
  static const volumeKeys = 'reader_volume_keys';
  static const volumeScrollSpeed = 'reader_volume_scroll_speed';
  static const gazeEnabled = 'reader_gaze_enabled';
  static const gazeMode = 'reader_gaze_mode';
  static const gazeThreshold = 'reader_gaze_threshold';
  static const gazeDwell = 'reader_gaze_dwell';
  static const gazeSmoothing = 'reader_gaze_smoothing';
  static const tiltEnabled = 'reader_tilt_enabled';
  static const tiltThreshold = 'reader_tilt_threshold';
  static const tiltSmoothing = 'reader_tilt_smoothing';
  static const autoPreload = 'reader_auto_preload';
  static const autoCrop = 'reader_auto_crop';
  static const radialEnabled = 'reader_radial_enabled';
  static const radialSide = 'reader_radial_side';
  static const novelRadialEnabled = 'novel_radial_enabled';
}

/// Number of reading modes, kept in sync with the [ReadingMode] enum order
/// (ltr, rtl, vertical, webtoon) so the stored int index round-trips cleanly.
const _readingModeCount = 4;

class ReaderSettingsPage extends StatefulWidget {
  const ReaderSettingsPage({super.key});
  @override
  State<ReaderSettingsPage> createState() => _ReaderSettingsPageState();
}

class _ReaderSettingsPageState extends State<ReaderSettingsPage> {
  int _readingModeIdx = 0;
  String _scaleType = 'Fit Screen';
  String _navLayout = 'Right & Left';
  String _bgColor = 'Black';
  bool _keepScreenOn = true;
  bool _showPageNumber = true;
  bool _fullscreen = true;
  bool _grayscale = false;
  bool _invertColors = false;
  bool _invertTapZones = false;
  bool _autoPreload = true;
  bool _autoCrop = false;
  double _warmTint = 0.0;
  double _brightness = 1.0;
  bool _dualPage = false;
  bool _dualPageSplit = false;
  bool _radialEnabled = false;
  String _radialSide = 'right';
  String _radialStyle = 'wheel';
  bool _novelRadialEnabled = true;
  String _novelRadialStyle = 'wheel';

  // Which reader's settings are shown (segmented at the top of the page).
  bool _showNovel = false;
  // Per-reader (novel) copies of the shared toggles.
  bool _novelFullscreen = false;
  bool _novelKeepScreenOn = true;
  // Light-novel text + Listen settings - mirror the in-reader menu (same prefs).
  String _novelFont = 'serif';
  double _novelFontSize = 18;
  double _novelLineHeight = 1.6;
  double _novelMargin = 16;
  String _novelAlign = 'left';
  bool _novelHyphenate = true;
  String _novelLayout = 'scroll';
  String _novelTheme = 'default';
  double _novelTtsRate = 0.5;
  double _novelTtsPitch = 1.0;
  int? _novelSentColor;
  int? _novelWordColor;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final p = SettingsStore.instance;
    setState(() {
      // ReaderProvider stores reading mode as ReadingMode enum index.
      _readingModeIdx = (p.getInt(ReaderPrefs.readingMode) ?? 0)
          .clamp(0, _readingModeCount - 1);
      _scaleType = p.getString(ReaderPrefs.scaleType) ?? 'Fit Screen';
      _navLayout = p.getString(ReaderPrefs.navLayout) ?? 'Right & Left';
      _bgColor = p.getString(ReaderPrefs.bgColor) ?? 'Black';
      _keepScreenOn = p.getBool(ReaderPrefs.keepScreenOn) ?? true;
      _showPageNumber = p.getBool(ReaderPrefs.showPageNumber) ?? true;
      _fullscreen = p.getBool(ReaderPrefs.fullscreen) ?? true;
      _grayscale = p.getBool(ReaderPrefs.grayscale) ?? false;
      _invertColors = p.getBool(ReaderPrefs.invertColors) ?? false;
      _invertTapZones = p.getBool(ReaderPrefs.invertTapZones) ?? false;
      _autoPreload = p.getBool(ReaderPrefs.autoPreload) ?? true;
      _autoCrop = p.getBool(ReaderPrefs.autoCrop) ?? false;
      _warmTint = (p.getDouble(ReaderPrefs.warmTint) ?? 0.0).clamp(0.0, 1.0);
      _brightness = (p.getDouble(ReaderPrefs.brightness) ?? 1.0).clamp(0.15, 1.0);
      _dualPage = p.getBool(ReaderPrefs.dualPage) ?? false;
      _dualPageSplit = p.getBool(ReaderPrefs.dualPageSplit) ?? false;
      _radialEnabled = p.getBool(ReaderPrefs.radialEnabled) ?? false;
      _radialSide = p.getString(ReaderPrefs.radialSide) ?? 'right';
      _radialStyle = p.getString('reader_radial_style') ?? 'wheel';
      _novelRadialEnabled = p.getBool(ReaderPrefs.novelRadialEnabled) ?? true;
      _novelRadialStyle = p.getString('novel_radial_style') ?? 'wheel';
      // Per-reader novel toggles fall back to the (old shared) manga value.
      _novelFullscreen = p.getBool('novel_fullscreen') ?? _fullscreen;
      _novelKeepScreenOn = p.getBool('novel_keep_screen_on') ?? _keepScreenOn;
      _novelFont = p.getString('novel_font_family') ?? 'serif';
      _novelFontSize = (p.getDouble('novel_font_size') ?? 18)
          .clamp(novelFontSizeMin, novelFontSizeMax);
      _novelLineHeight = (p.getDouble('novel_line_height') ?? 1.6)
          .clamp(novelLineHeightMin, novelLineHeightMax);
      _novelMargin = (p.getDouble('novel_margin') ?? 16)
          .clamp(novelMarginMin, novelMarginMax);
      _novelAlign = p.getString('novel_text_align') ?? 'left';
      _novelHyphenate = p.getBool('novel_hyphenate') ?? true;
      _novelLayout = p.getString('novel_layout') ?? 'scroll';
      _novelTheme = p.getString('novel_reader_theme') ?? 'default';
      _novelTtsRate = (p.getDouble('novel_tts_rate') ?? 0.5).clamp(0.25, 1.0);
      _novelTtsPitch = (p.getDouble('novel_tts_pitch') ?? 1.0).clamp(0.5, 2.0);
      final nsc = p.getInt('novel_tts_sentence_color') ?? 0;
      _novelSentColor = nsc == 0 ? null : nsc;
      final nwc = p.getInt('novel_tts_word_color') ?? 0;
      _novelWordColor = nwc == 0 ? null : nwc;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    await SettingsStore.instance.setBool(key, value);
  }

  Future<void> _setString(String key, String value) async {
    await SettingsStore.instance.setString(key, value);
  }

  Future<void> _setDouble(String key, double value) async {
    await SettingsStore.instance.setDouble(key, value);
  }

  Future<void> _setInt(String key, int value) async {
    await SettingsStore.instance.setInt(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final beta = context.watch<BetaProvider>().enabled;
    // Compact reading-mode labels for the segmented control, in ReadingMode enum
    // order (ltr, rtl, vertical, webtoon) so the index maps to the stored value.
    final modeLabels = [
      t.readerModeLtrShort,
      t.readerModeRtlShort,
      t.readerModeVerticalShort,
      t.readerModeWebtoonLabel,
    ];
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface, elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context)),
        title: Text(t.readerTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: 8, bottom: 8 + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          _readerTabs(cs, t),
          if (_showNovel) ..._novelSections(cs, t, beta) else ...[
          SettingsSectionHeader(title: t.readerPreferences),
          _SegmentedTile(icon: Icons.auto_stories_rounded, iconColor: cs.primary,
              title: t.readerReadingMode,
              options: modeLabels,
              selected: modeLabels[_readingModeIdx],
              onChanged: (v) async {
                final idx = modeLabels.indexOf(v);
                if (idx >= 0) {
                  setState(() => _readingModeIdx = idx);
                  await SettingsStore.instance.setInt(ReaderPrefs.readingMode, idx);
                }
              }),
          AppSettingsSwitchTile(icon: Icons.skip_next_rounded, iconColor: cs.primary,
              title: t.readerAutoPreloadNextChapter, subtitle: t.readerAutoPreloadNextChapterSubtitle,
              value: _autoPreload, onChanged: (v) {
                setState(() => _autoPreload = v);
                _setBool(ReaderPrefs.autoPreload, v);
              }),
          const SizedBox(height: 8),
          SettingsSectionHeader(title: t.readerSectionImage),
          AppSettingsSwitchTile(icon: Icons.filter_b_and_w_rounded, iconColor: cs.primary,
              title: t.readerGrayscale, subtitle: t.readerGrayscaleSubtitle,
              value: _grayscale, onChanged: (v) {
                setState(() => _grayscale = v);
                _setBool(ReaderPrefs.grayscale, v);
              }),
          if (beta)
            AppSettingsSwitchTile(icon: Icons.crop_rounded, iconColor: cs.primary,
                title: t.readerAutoCrop, subtitle: t.readerAutoCropSubtitle,
                value: _autoCrop, onChanged: (v) {
                  setState(() => _autoCrop = v);
                  _setBool(ReaderPrefs.autoCrop, v);
                }),
          AppSettingsSwitchTile(icon: Icons.invert_colors_rounded, iconColor: cs.primary,
              title: t.readerInvertColors, subtitle: t.readerInvertColorsSubtitle,
              value: _invertColors, onChanged: (v) {
                setState(() => _invertColors = v);
                _setBool(ReaderPrefs.invertColors, v);
              }),
          const SizedBox(height: 8),
          SettingsSectionHeader(title: t.readerSectionEyeComfort),
          SettingsSliderTile(icon: Icons.wb_twilight_rounded, iconColor: AppTheme.warning,
              title: t.readerWarmFilter, value: _warmTint, min: 0, max: 1, divisions: 10,
              onChanged: (v) {
                setState(() => _warmTint = v);
                _setDouble(ReaderPrefs.warmTint, v);
              }),
          SettingsSliderTile(icon: Icons.brightness_6_rounded, iconColor: AppTheme.warning,
              title: t.readerBrightness, value: _brightness, min: 0.15, max: 1, divisions: 17,
              onChanged: (v) {
                setState(() => _brightness = v);
                _setDouble(ReaderPrefs.brightness, v);
              }),
          const SizedBox(height: 8),
          SettingsSectionHeader(title: t.readerDisplay),
          AppSettingsChoiceTile(icon: Icons.aspect_ratio_rounded, iconColor: AppTheme.success,
              title: t.readerScaleType, value: _scaleType,
              options: const ['Fit Screen', 'Stretch', 'Fit Width', 'Fit Height', 'Original Size', 'Smart Fit'],
              onChanged: (v) {
                setState(() => _scaleType = v);
                _setString(ReaderPrefs.scaleType, v);
              }),
          AppSettingsChoiceTile(icon: Icons.format_color_fill_rounded, iconColor: AppTheme.success,
              title: t.readerBackgroundColor, value: _bgColor,
              options: const ['Black', 'Gray', 'White', 'Automatic'],
              onChanged: (v) {
                setState(() => _bgColor = v);
                _setString(ReaderPrefs.bgColor, v);
              }),
          AppSettingsSwitchTile(icon: Icons.auto_stories_rounded, iconColor: AppTheme.success,
              title: t.readerDoublePages,
              subtitle: t.readerDoublePagesSubtitle,
              value: _dualPage, onChanged: (v) {
                setState(() => _dualPage = v);
                _setBool(ReaderPrefs.dualPage, v);
              }),
          if (_dualPage)
            AppSettingsSwitchTile(icon: Icons.open_in_full_rounded, iconColor: AppTheme.success,
                title: t.readerSplitWidePages,
                subtitle: t.readerSplitWidePagesSubtitle,
                value: _dualPageSplit, onChanged: (v) {
                  setState(() => _dualPageSplit = v);
                  _setBool(ReaderPrefs.dualPageSplit, v);
                }),
          AppSettingsSwitchTile(icon: Icons.brightness_high_rounded, iconColor: AppTheme.success,
              title: t.readerKeepScreenOn, subtitle: t.readerKeepScreenOnSubtitle,
              value: _keepScreenOn, onChanged: (v) {
                setState(() => _keepScreenOn = v);
                _setBool(ReaderPrefs.keepScreenOn, v);
              }),
          AppSettingsSwitchTile(icon: Icons.numbers_rounded, iconColor: AppTheme.success,
              title: t.readerShowPageNumber, subtitle: t.readerShowPageNumberSubtitle,
              value: _showPageNumber, onChanged: (v) {
                setState(() => _showPageNumber = v);
                _setBool(ReaderPrefs.showPageNumber, v);
              }),
          AppSettingsSwitchTile(icon: Icons.fullscreen_rounded, iconColor: AppTheme.success,
              title: t.readerFullscreen, subtitle: t.readerFullscreenSubtitle,
              value: _fullscreen, onChanged: (v) {
                setState(() => _fullscreen = v);
                _setBool(ReaderPrefs.fullscreen, v);
              }),
          const SizedBox(height: 8),
          SettingsSectionHeader(title: t.readerNavigation),
          AppSettingsChoiceTile(icon: Icons.touch_app_rounded, iconColor: AppTheme.secondary,
              title: t.readerNavigationLayout, value: _navLayout,
              options: const ['Right & Left', 'L-shaped', 'Kindle-like', 'Edge', 'Disabled'],
              onChanged: (v) {
                setState(() => _navLayout = v);
                _setString(ReaderPrefs.navLayout, v);
              }),
          AppSettingsSwitchTile(icon: Icons.swap_horiz_rounded, iconColor: AppTheme.secondary,
              title: t.readerInvertTapZones, subtitle: t.readerInvertTapZonesSubtitle,
              value: _invertTapZones, onChanged: (v) {
                setState(() => _invertTapZones = v);
                _setBool(ReaderPrefs.invertTapZones, v);
              }),
          const SizedBox(height: 8),
          SettingsSectionHeader(title: t.readerRadialMenu),
          AppSettingsSwitchTile(icon: Icons.blur_circular_rounded, iconColor: AppTheme.secondary,
              title: t.readerRadialMenu, subtitle: t.readerRadialMenuSubtitle,
              value: _radialEnabled, onChanged: (v) {
                setState(() => _radialEnabled = v);
                _setBool(ReaderPrefs.radialEnabled, v);
              }),
          if (_radialEnabled)
            AppSettingsChoiceTile(icon: Icons.view_agenda_rounded,
                iconColor: AppTheme.secondary,
                title: t.readerMenuStyle,
                value: _radialStyle == 'tail' ? t.readerMenuStyleTail : t.readerMenuStyleWheel,
                options: [t.readerMenuStyleWheel, t.readerMenuStyleTail],
                onChanged: (v) {
                  final s = v == t.readerMenuStyleTail ? 'tail' : 'wheel';
                  setState(() => _radialStyle = s);
                  _setString('reader_radial_style', s);
                }),
          if (_radialEnabled)
            AppSettingsChoiceTile(icon: Icons.align_horizontal_right_rounded,
                iconColor: AppTheme.secondary,
                title: t.readerRadialCorner,
                value: _radialSide == 'left' ? t.readerSideLeft : t.readerSideRight,
                options: [t.readerSideLeft, t.readerSideRight],
                onChanged: (v) {
                  final side = v == t.readerSideLeft ? 'left' : 'right';
                  setState(() => _radialSide = side);
                  _setString(ReaderPrefs.radialSide, side);
                }),
          if (_radialEnabled)
            AppSettingsNavTile(
                icon: Icons.tune_rounded,
                iconColor: AppTheme.secondary,
                title: t.readerCustomizeMenu,
                subtitle: t.readerCustomizeMenuMangaSubtitle,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        const RadialMenuSettingsPage(only: 'manga')))),
          if (beta) _handsFreeNav(t),
          ], // end: manga tab
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Manga / Light novel segmented switch at the top of the page.
  Widget _readerTabs(ColorScheme cs, AppLocalizations t) => _SegmentedTile(
        icon: Icons.menu_book_rounded,
        iconColor: cs.primary,
        title: t.readerSettingsFor,
        options: [t.readerManga, t.readerLightNovel],
        selected: _showNovel ? t.readerLightNovel : t.readerManga,
        onChanged: (v) => setState(() => _showNovel = v == t.readerLightNovel),
      );

  // ── Light novel tab ────────────────────────────────────────────────────────
  List<Widget> _novelSections(ColorScheme cs, AppLocalizations t, bool beta) {
    String fontLabel(String id) =>
        novelFonts.firstWhere((f) => f.$1 == id, orElse: () => novelFonts.first).$2;
    String alignLabel(String id) => novelAligns
        .firstWhere((a) => a.$1 == id, orElse: () => novelAligns.first)
        .$2;
    String themeLabel(String id) => novelThemes
        .firstWhere((th) => th.$1 == id, orElse: () => novelThemes.first)
        .$2;
    return [
      SettingsSectionHeader(title: t.readerSectionLayout),
      AppSettingsChoiceTile(
          icon: Icons.auto_stories_rounded,
          iconColor: cs.primary,
          title: t.readerReadingMode,
          value: _novelLayout == 'paged' ? t.readerNovelLayoutPaged : t.readerNovelLayoutScroll,
          options: [t.readerNovelLayoutScroll, t.readerNovelLayoutPaged],
          onChanged: (label) {
            final id = label == t.readerNovelLayoutPaged ? 'paged' : 'scroll';
            setState(() => _novelLayout = id);
            _setString('novel_layout', id);
          }),
      const SizedBox(height: 8),
      SettingsSectionHeader(title: t.readerSectionText),
      AppSettingsChoiceTile(
          icon: Icons.font_download_rounded,
          iconColor: cs.primary,
          title: t.readerTabFont,
          value: fontLabel(_novelFont),
          options: novelFonts.map((f) => f.$2).toList(),
          onChanged: (label) {
            final id = novelFonts.firstWhere((f) => f.$2 == label).$1;
            setState(() => _novelFont = id);
            _setString('novel_font_family', id);
          }),
      SettingsSliderTile(
          icon: Icons.format_size_rounded,
          iconColor: cs.primary,
          title: t.readerTextSize,
          value: _novelFontSize,
          min: novelFontSizeMin,
          max: novelFontSizeMax,
          divisions: (novelFontSizeMax - novelFontSizeMin).round(),
          onChanged: (v) {
            setState(() => _novelFontSize = v);
            _setDouble('novel_font_size', v);
          }),
      SettingsSliderTile(
          icon: Icons.format_line_spacing_rounded,
          iconColor: cs.primary,
          title: t.readerLineSpacing,
          value: _novelLineHeight,
          min: novelLineHeightMin,
          max: novelLineHeightMax,
          divisions: 12,
          onChanged: (v) {
            setState(() => _novelLineHeight = v);
            _setDouble('novel_line_height', v);
          }),
      SettingsSliderTile(
          icon: Icons.width_normal_rounded,
          iconColor: cs.primary,
          title: t.readerMargins,
          value: _novelMargin,
          min: novelMarginMin,
          max: novelMarginMax,
          divisions: 20,
          onChanged: (v) {
            setState(() => _novelMargin = v);
            _setDouble('novel_margin', v);
          }),
      AppSettingsChoiceTile(
          icon: Icons.format_align_left_rounded,
          iconColor: cs.primary,
          title: t.readerAlignment,
          value: alignLabel(_novelAlign),
          options: novelAligns.map((a) => a.$2).toList(),
          onChanged: (label) {
            final id = novelAligns.firstWhere((a) => a.$2 == label).$1;
            setState(() => _novelAlign = id);
            _setString('novel_text_align', id);
          }),
      AppSettingsSwitchTile(
          icon: Icons.text_rotation_none_rounded,
          iconColor: cs.primary,
          title: t.readerHyphenation,
          subtitle: t.readerHyphenationSubtitle,
          value: _novelHyphenate,
          onChanged: (v) {
            setState(() => _novelHyphenate = v);
            _setBool('novel_hyphenate', v);
          }),
      AppSettingsChoiceTile(
          icon: Icons.palette_rounded,
          iconColor: AppTheme.success,
          title: t.readerReaderTheme,
          value: themeLabel(_novelTheme),
          options: novelThemes.map((th) => th.$2).toList(),
          onChanged: (label) {
            final id = novelThemes.firstWhere((th) => th.$2 == label).$1;
            setState(() => _novelTheme = id);
            _setString('novel_reader_theme', id);
          }),
      const SizedBox(height: 8),
      SettingsSectionHeader(title: t.readerDisplay),
      AppSettingsSwitchTile(
          icon: Icons.brightness_high_rounded,
          iconColor: AppTheme.success,
          title: t.readerKeepScreenOn,
          subtitle: t.readerKeepScreenOnSubtitle,
          value: _novelKeepScreenOn,
          onChanged: (v) {
            setState(() => _novelKeepScreenOn = v);
            _setBool('novel_keep_screen_on', v);
          }),
      AppSettingsSwitchTile(
          icon: Icons.fullscreen_rounded,
          iconColor: AppTheme.success,
          title: t.readerFullscreen,
          subtitle: t.readerFullscreenSubtitle,
          value: _novelFullscreen,
          onChanged: (v) {
            setState(() => _novelFullscreen = v);
            _setBool('novel_fullscreen', v);
          }),
      AppSettingsSwitchTile(
          icon: Icons.skip_next_rounded,
          iconColor: AppTheme.success,
          title: t.readerAutoPreloadNextChapter,
          subtitle: t.readerAutoPreloadNextChapterSubtitle,
          value: _autoPreload,
          onChanged: (v) {
            setState(() => _autoPreload = v);
            _setBool(ReaderPrefs.autoPreload, v);
          }),
      const SizedBox(height: 8),
      SettingsSectionHeader(title: t.readerSectionListen),
      SettingsSliderTile(
          icon: Icons.speed_rounded,
          iconColor: AppTheme.secondary,
          title: t.readerTtsSpeed,
          value: _novelTtsRate / 0.5,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: (v) {
            final rate = (v * 0.5).clamp(0.25, 1.0);
            setState(() => _novelTtsRate = rate);
            _setDouble('novel_tts_rate', rate);
          }),
      SettingsSliderTile(
          icon: Icons.graphic_eq_rounded,
          iconColor: AppTheme.secondary,
          title: t.readerPitch,
          value: _novelTtsPitch,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: (v) {
            setState(() => _novelTtsPitch = v);
            _setDouble('novel_tts_pitch', v);
          }),
      _HighlightColourTile(
          title: t.readerSentenceHighlight,
          current: _novelSentColor,
          onPick: (c) {
            setState(() => _novelSentColor = c);
            _setInt('novel_tts_sentence_color', c ?? 0);
          }),
      _HighlightColourTile(
          title: t.readerWordHighlight,
          current: _novelWordColor,
          onPick: (c) {
            setState(() => _novelWordColor = c);
            _setInt('novel_tts_word_color', c ?? 0);
          }),
      const SizedBox(height: 8),
      SettingsSectionHeader(title: t.readerRadialMenu),
      AppSettingsSwitchTile(
          icon: Icons.blur_circular_rounded,
          iconColor: AppTheme.secondary,
          title: t.readerRadialMenu,
          subtitle: t.readerNovelRadialMenuSubtitle,
          value: _novelRadialEnabled,
          onChanged: (v) {
            setState(() => _novelRadialEnabled = v);
            _setBool(ReaderPrefs.novelRadialEnabled, v);
          }),
      if (_novelRadialEnabled)
        AppSettingsChoiceTile(
            icon: Icons.view_agenda_rounded,
            iconColor: AppTheme.secondary,
            title: t.readerMenuStyle,
            value: _novelRadialStyle == 'tail' ? t.readerMenuStyleTail : t.readerMenuStyleWheel,
            options: [t.readerMenuStyleWheel, t.readerMenuStyleTail],
            onChanged: (v) {
              final s = v == t.readerMenuStyleTail ? 'tail' : 'wheel';
              setState(() => _novelRadialStyle = s);
              _setString('novel_radial_style', s);
            }),
      if (_novelRadialEnabled)
        AppSettingsNavTile(
            icon: Icons.tune_rounded,
            iconColor: AppTheme.secondary,
            title: t.readerCustomizeMenu,
            subtitle: t.readerCustomizeMenuNovelSubtitle,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const RadialMenuSettingsPage(only: 'novel')))),
      if (beta) _handsFreeNav(t),
      const SizedBox(height: 24),
    ];
  }

  // Entry to the shared Hands-free & motion sub-page (volume buttons, tilt and
  // gaze scrolling). Shown at the bottom of either reader tab under beta; the
  // controls apply to scrolling in both readers.
  Widget _handsFreeNav(AppLocalizations t) => AppSettingsNavTile(
        icon: Icons.accessibility_new_rounded,
        iconColor: AppTheme.secondary,
        title: t.readerHandsFreeMotion,
        subtitle: t.readerHandsFreeMotionSubtitle,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const HandsFreeScrollSettingsPage())),
      );
}

// ── Shared Tile Widgets ──────────────────────────────────────
class _SegmentedTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title;
  final List<String> options; final String selected; final ValueChanged<String> onChanged;
  const _SegmentedTile({required this.icon, required this.iconColor, required this.title,
      required this.options, required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: cs.outlineVariant)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 36, height: 36,
              decoration: oledIconChip(context, color: iconColor, fill: iconColor.withAlpha(25), radius: 10),
              child: Icon(icon, color: iconColor, size: 18)),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface)),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 6, runSpacing: 6, children: options.map((opt) {
          final isSelected = opt == selected;
          return GestureDetector(
            onTap: () => onChanged(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : cs.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(color: isSelected ? cs.primary : cs.outlineVariant)),
              child: Text(opt, style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? cs.onPrimary : cs.onSurface)),
            ),
          );
        }).toList()),
      ]),
    );
  }
}

/// A swatch row for the TTS highlight colour (sentence / word). null = follow
/// the theme accent; otherwise a fixed ARGB. Mirrors the in-reader picker.
class _HighlightColourTile extends StatelessWidget {
  final String title;
  final int? current;
  final ValueChanged<int?> onPick;
  const _HighlightColourTile(
      {required this.title, required this.current, required this.onPick});

  static const _presets = <(String, int?)>[
    ('Accent', null),
    ('Amber', 0xFFFFB300),
    ('Green', 0xFF43A047),
    ('Blue', 0xFF1E88E5),
    ('Pink', 0xFFD81B60),
    ('Violet', 0xFF8E24AA),
  ];

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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface)),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 8, children: [
          for (final (_, argb) in _presets)
            GestureDetector(
              onTap: () => onPick(argb),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: argb == null ? cs.primary : Color(argb),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: current == argb ? cs.onSurface : cs.outlineVariant,
                      width: current == argb ? 2.5 : 1),
                ),
                child: current == argb
                    ? const Icon(Icons.check_rounded,
                        size: 15, color: Colors.white)
                    : null,
              ),
            ),
        ]),
      ]),
    );
  }
}

