import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/source_provider.dart';
import '../../../core/services/settings_store.dart';
import '../../../l10n/app_localizations.dart';
import '../../../presentation/webview_screen/webview_screen.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';

class BrowseSettingsPage extends StatefulWidget {
  const BrowseSettingsPage({super.key});

  @override
  State<BrowseSettingsPage> createState() => _BrowseSettingsPageState();
}

class _BrowseSettingsPageState extends State<BrowseSettingsPage> {
  bool _adBlockEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    setState(() {
      _adBlockEnabled =
          SettingsStore.instance.getBool(WebViewScreen.adBlockKey) ?? true;
    });
  }

  Future<void> _setAdBlock(bool value) async {
    setState(() => _adBlockEnabled = value);
    await SettingsStore.instance.setBool(WebViewScreen.adBlockKey, value);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final source = context.watch<SourceProvider>();

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
          t.browseTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          AppSettingsSectionHeader(title: t.browseSectionSources),
          AppSettingsSwitchTile(
            icon: Icons.eighteen_up_rating_rounded,
            iconColor: AppTheme.error,
            title: t.browseShowNsfw,
            subtitle: t.browseShowNsfwDesc,
            value: source.showNsfw,
            onChanged: source.setShowNsfw,
          ),
          AppSettingsSwitchTile(
            icon: Icons.push_pin_rounded,
            iconColor: cs.primary,
            title: t.browsePinnedOnly,
            subtitle: t.browsePinnedOnlyBrowseDesc,
            value: source.pinnedOnlyBrowse,
            onChanged: source.setPinnedOnlyBrowse,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.browseSectionGlobalSearch),
          AppSettingsSwitchTile(
            icon: Icons.travel_explore_rounded,
            iconColor: cs.primary,
            title: t.browsePinnedOnly,
            subtitle: t.browsePinnedOnlyGlobalSearchDesc,
            value: source.pinnedOnlyGlobalSearch,
            onChanged: source.setPinnedOnlyGlobalSearch,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.browseSectionWebView),
          AppSettingsSwitchTile(
            icon: Icons.block_rounded,
            iconColor: AppTheme.warning,
            title: t.browseAdBlocker,
            subtitle: t.browseAdBlockerDesc,
            value: _adBlockEnabled,
            onChanged: _setAdBlock,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.browseSectionExtensions),
          AppSettingsSwitchTile(
            icon: Icons.system_update_alt_rounded,
            iconColor: AppTheme.secondary,
            title: t.browseAutoUpdate,
            subtitle: t.browseAutoUpdateDesc,
            value: source.autoUpdateExtensions,
            onChanged: source.setAutoUpdateExtensions,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
