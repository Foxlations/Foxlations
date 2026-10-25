import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/build_config.dart';
import '../../../core/providers/beta_provider.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/services/doh/doh_provider.dart';
import '../../../core/services/doh/doh_resolver.dart';
import '../../../core/services/download_service.dart';
import '../../../core/services/image_loader.dart';
import '../../../eval/kotlin/jvm_bridge.dart';
import '../../../core/services/settings_store.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_tokens.dart';
import '../../widgets/ds/ds.dart';
import '../../../l10n/app_localizations.dart';
import 'gaze_lab_screen.dart';

/// Advanced preference keys. Switches persist; some have no runtime effect
/// yet (DNS-over-HTTPS, third-party extensions, external browser) - those
/// will be wired up when their underlying features land.
class AdvancedPrefs {
  static const verboseLogging = 'adv_verbose_logging';
  static const dnsOverHttps = 'adv_dns_over_https';
  static const dnsProvider = 'adv_dns_provider';
  static const thirdPartyExtensions = 'adv_third_party_extensions';
  static const extensionUpdateNotify = 'adv_extension_update_notify';
  static const externalBrowser = 'adv_external_browser';
}

class AdvancedSettingsPage extends StatefulWidget {
  const AdvancedSettingsPage({super.key});
  @override
  State<AdvancedSettingsPage> createState() => _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  bool _verboseLogging = false;
  bool _dnsOverHttps = false;
  String _dnsProvider = 'Cloudflare';
  List<DohProvider> _customDns = [];
  bool _thirdPartyExtensions = false;
  bool _extensionUpdateNotify = true;
  bool _externalBrowser = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    setState(() {
      _verboseLogging =
          SettingsStore.instance.getBool(AdvancedPrefs.verboseLogging) ?? false;
      _dnsOverHttps =
          SettingsStore.instance.getBool(AdvancedPrefs.dnsOverHttps) ?? false;
      _dnsProvider =
          SettingsStore.instance.getString(AdvancedPrefs.dnsProvider) ??
              'Cloudflare';
      _customDns = DohCustomStore.load();
      _thirdPartyExtensions =
          SettingsStore.instance.getBool(AdvancedPrefs.thirdPartyExtensions) ??
              false;
      _extensionUpdateNotify =
          SettingsStore.instance.getBool(AdvancedPrefs.extensionUpdateNotify) ??
              true;
      _externalBrowser =
          SettingsStore.instance.getBool(AdvancedPrefs.externalBrowser) ??
              false;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    await SettingsStore.instance.setBool(key, value);
  }

  Future<void> _setString(String key, String value) async {
    await SettingsStore.instance.setString(key, value);
  }

  // ── DNS-over-HTTPS provider management ───────────────────────────────────

  /// Apply a DoH change immediately (without an app restart) by dropping the
  /// cached HTTP clients + resolver cache so the next request rebuilds them.
  void _applyDnsChange() {
    DohResolver.instance.clearCache();
    // Force cached source-extension clients to rebuild with the new DNS setting
    // on their next request (ImageLoader/DownloadService are reset outright).
    DohResolver.instance.bumpClientGeneration();
    ImageLoader().resetHttpClient();
    DownloadService().resetHttpClient();
    // Push to the Kotlin extension lane too (Android OkHttp Dns / iOS JVM
    // resolver). Best-effort; no-op when there's no embedded JVM/ART host.
    final doh = jvmDohConfig();
    FoxJvm.setDoh(doh.enabled, doh.url);
  }

  /// Display label of the currently-selected provider.
  String _selectedDnsLabel() {
    final p = DohProviders.byId(_dnsProvider, _customDns);
    return p?.label ?? DohProviders.cloudflare.label;
  }

  Future<void> _selectDns(String id) async {
    setState(() => _dnsProvider = id);
    await _setString(AdvancedPrefs.dnsProvider, id);
    _applyDnsChange();
  }

  void _openDnsProviderSheet() {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheet) {
          Widget row(DohProvider p) {
            final selected = p.id == _dnsProvider;
            return ListTile(
              leading: Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: selected ? cs.primary : cs.outline),
              title: Text(p.label,
                  style: Theme.of(context).textTheme.titleSmall),
              subtitle: Text(p.queryUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 11, color: cs.outline)),
              trailing: p.isCustom
                  ? IconButton(
                      icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                      tooltip: t.setxAdvancedDnsDelete,
                      onPressed: () async {
                        await _confirmDeleteCustomDns(p);
                        setSheet(() {});
                      },
                    )
                  : null,
              onTap: () {
                _selectDns(p.id);
                Navigator.pop(sheetCtx);
              },
            );
          }

          return SafeArea(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Row(children: [
                  Text(t.setxAdvancedDnsProviderTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ]),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ...DohProviders.presets.map(row),
                    ..._customDns.map(row),
                    ListTile(
                      leading: Icon(Icons.add_rounded, color: cs.primary),
                      title: Text(t.setxAdvancedDnsAddCustom,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: cs.primary)),
                      onTap: () async {
                        final added = await _addCustomDnsDialog();
                        if (added) setSheet(() {});
                      },
                    ),
                  ]),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  /// Add-custom dialog (name + https URL). Returns true if one was added.
  Future<bool> _addCustomDnsDialog() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final nameCtl = TextEditingController();
    final urlCtl = TextEditingController();
    final added = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        String? error;
        return StatefulBuilder(
          builder: (ctx, setDlg) => AlertDialog(
            backgroundColor: cs.surface,
            title: Text(t.setxAdvancedDnsAddCustom),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: nameCtl,
                decoration: InputDecoration(
                    labelText: t.setxAdvancedDnsName,
                    hintText: t.setxAdvancedDnsNameHint),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: urlCtl,
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: t.setxAdvancedDnsUrlLabel,
                  hintText: 'https://example.com/dns-query',
                  errorText: error,
                ),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(t.setxAdvancedCancel)),
              FilledButton(
                onPressed: () {
                  final url = urlCtl.text.trim();
                  if (!DohProviders.isValidUrl(url)) {
                    setDlg(() => error = t.setxAdvancedDnsInvalidUrl);
                    return;
                  }
                  Navigator.pop(ctx, true);
                },
                child: Text(t.setxAdvancedDnsAdd),
              ),
            ],
          ),
        );
      },
    );

    if (added == true) {
      final provider = await DohCustomStore.add(nameCtl.text, urlCtl.text);
      setState(() => _customDns = DohCustomStore.load());
      await _selectDns(provider.id); // select the new one
      nameCtl.dispose();
      urlCtl.dispose();
      return true;
    }
    nameCtl.dispose();
    urlCtl.dispose();
    return false;
  }

  Future<void> _confirmDeleteCustomDns(DohProvider p) async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(t.setxAdvancedDnsDeleteTitle),
        content: Text(t.setxAdvancedDnsDeleteBody(p.label)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.setxAdvancedCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.setxAdvancedDnsDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await DohCustomStore.remove(p.id);
    setState(() => _customDns = DohCustomStore.load());
    // If the deleted one was selected, fall back to Cloudflare.
    if (_dnsProvider == p.id) {
      await _selectDns(DohProviders.cloudflare.id);
    }
  }

  Future<void> _clearChapterCache() async {
    ImageLoader().clearCache();
    if (mounted) {
      AppTheme.showSnackBar(
          context, AppLocalizations.of(context).setxAdvancedCacheCleared);
    }
  }

  Future<void> _confirmClearDatabase() async {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        title: Text(t.setxAdvancedClearDbTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface)),
        content: Text(
          t.setxAdvancedClearDbBody,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.setxAdvancedCancel,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: cs.outline)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.setxAdvancedClear,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Clear both library and vault hive boxes. Names match LibraryService.
    for (final prefix in ['library', 'vault']) {
      for (final suffix in ['_manga', '_chapters', '_categories']) {
        try {
          if (Hive.isBoxOpen('$prefix$suffix')) {
            await Hive.box('$prefix$suffix').clear();
          }
        } catch (e) {
          await logger.error('Failed to clear box $prefix$suffix',
              category: LogCategory.general, detail: e.toString());
        }
      }
    }
    if (mounted) {
      AppTheme.showSnackBar(context, t.setxAdvancedDbCleared);
    }
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface, elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context)),
        title: Text(t.setxAdvancedTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
      ),
      body: ListView(
        padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm + MediaQuery.viewPaddingOf(context).bottom),
        children: [
          AppSettingsSectionHeader(title: t.setxAdvancedSectionBeta),
          AppSettingsSwitchTile(
              icon: Icons.science_rounded,
              iconColor: AppTheme.warning,
              title: t.setxAdvancedBeta,
              subtitle: t.setxAdvancedBetaDesc,
              value: context.watch<BetaProvider>().enabled,
              onChanged: (v) => context.read<BetaProvider>().setEnabled(v)),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxAdvancedSectionLogging),
          AppSettingsSwitchTile(icon: Icons.bug_report_rounded, iconColor: cs.outline,
              title: t.setxAdvancedVerboseLoggingTitle, subtitle: t.setxAdvancedVerboseLoggingSubtitle,
              value: _verboseLogging, onChanged: (v) {
                setState(() => _verboseLogging = v);
                _setBool(AdvancedPrefs.verboseLogging, v);
              }),
          _ActionTile(icon: Icons.list_alt_rounded, iconColor: AppTheme.warning,
              title: t.setxAdvancedViewErrorLogsTitle, subtitle: t.setxAdvancedViewErrorLogsSubtitle,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ErrorLogViewerPage()))),
          // Dev-only - never ships in public builds (built without FOX_DEV).
          if (Platform.isIOS && kDevBuild)
            _ActionTile(icon: Icons.center_focus_strong_rounded,
                iconColor: AppTheme.secondary,
                title: 'Gaze Lab (dev)',
                subtitle: 'Live eye-tracking tuning + manual calibration',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GazeLabScreen()))),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxAdvancedSectionNetwork),
          AppSettingsSwitchTile(icon: Icons.dns_rounded, iconColor: const Color(0xFF06B6D4),
              title: t.setxAdvancedDnsOverHttpsTitle, subtitle: t.setxAdvancedDnsOverHttpsSubtitle,
              value: _dnsOverHttps, onChanged: (v) async {
                setState(() => _dnsOverHttps = v);
                // Await the write so _applyDnsChange reads the NEW flag value
                // (jvmDohConfig/dohDnsSettingsOrNull both read it from the store).
                await _setBool(AdvancedPrefs.dnsOverHttps, v);
                _applyDnsChange();
              }),
          if (_dnsOverHttps)
            _DnsProviderTile(
              selectedLabel: _selectedDnsLabel(),
              onTap: _openDnsProviderSheet,
            ),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxAdvancedSectionExtensions),
          AppSettingsSwitchTile(icon: Icons.extension_rounded, iconColor: AppTheme.warning,
              title: t.setxAdvancedThirdPartyTitle, subtitle: t.setxAdvancedThirdPartySubtitle,
              value: _thirdPartyExtensions, onChanged: (v) {
                setState(() => _thirdPartyExtensions = v);
                _setBool(AdvancedPrefs.thirdPartyExtensions, v);
              }),
          AppSettingsSwitchTile(icon: Icons.system_update_alt_rounded, iconColor: AppTheme.warning,
              title: t.setxAdvancedExtUpdateTitle, subtitle: t.setxAdvancedExtUpdateSubtitle,
              value: _extensionUpdateNotify, onChanged: (v) {
                setState(() => _extensionUpdateNotify = v);
                _setBool(AdvancedPrefs.extensionUpdateNotify, v);
              }),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxAdvancedSectionBrowser),
          AppSettingsSwitchTile(icon: Icons.open_in_browser_rounded, iconColor: AppTheme.secondary,
              title: t.setxAdvancedExternalBrowserTitle, subtitle: t.setxAdvancedExternalBrowserSubtitle,
              value: _externalBrowser, onChanged: (v) {
                setState(() => _externalBrowser = v);
                _setBool(AdvancedPrefs.externalBrowser, v);
              }),
          const SizedBox(height: AppSpacing.sm),
          AppSettingsSectionHeader(title: t.setxAdvancedSectionData),
          _ActionTile(icon: Icons.cleaning_services_rounded, iconColor: AppTheme.error,
              title: t.setxAdvancedClearCacheTitle, subtitle: t.setxAdvancedClearCacheSubtitle,
              onTap: _clearChapterCache),
          _ActionTile(icon: Icons.delete_sweep_rounded, iconColor: AppTheme.error,
              title: t.setxAdvancedClearDbEntryTitle, subtitle: t.setxAdvancedClearDbEntrySubtitle,
              onTap: _confirmClearDatabase),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title; final String subtitle;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.iconColor, required this.title,
      required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: cs.outlineVariant)),
        child: Row(children: [
          Container(width: 36, height: 36,
              decoration: oledIconChip(context, color: iconColor, fill: iconColor.withAlpha(25), radius: 10),
              child: Icon(icon, color: iconColor, size: 18)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
          ])),
          Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20),
        ]),
      ),
    );
  }
}

// ── Error Log Viewer ───────────────────────────────────────────────────────────

class ErrorLogViewerPage extends StatefulWidget {
  const ErrorLogViewerPage({super.key});
  @override
  State<ErrorLogViewerPage> createState() => _ErrorLogViewerPageState();
}

class _ErrorLogViewerPageState extends State<ErrorLogViewerPage> {
  LogCategory? _selectedCategory;
  LogLevel? _minLevel;

  Map<LogCategory?, String> _categoryLabels(AppLocalizations t) =>
      <LogCategory?, String>{
        null: t.setxAdvancedLogAll,
        LogCategory.repo: t.setxAdvancedLogCatRepo,
        LogCategory.extension: t.setxAdvancedLogCatExtension,
        LogCategory.network: t.setxAdvancedLogCatNetwork,
        LogCategory.install: t.setxAdvancedLogCatInstall,
        LogCategory.library: t.setxAdvancedLogCatLibrary,
        LogCategory.general: t.setxAdvancedLogCatGeneral,
      };

  Map<LogLevel?, String> _levelLabels(AppLocalizations t) =>
      <LogLevel?, String>{
        null: t.setxAdvancedLogAll,
        LogLevel.debug: t.setxAdvancedLogLvlDebug,
        LogLevel.info: t.setxAdvancedLogLvlInfo,
        LogLevel.warning: t.setxAdvancedLogLvlWarning,
        LogLevel.error: t.setxAdvancedLogLvlError,
      };

  Color _levelColor(LogLevel level, ColorScheme cs) {
    switch (level) {
      case LogLevel.debug: return cs.outline;
      case LogLevel.info: return AppTheme.success;
      case LogLevel.warning: return AppTheme.warning;
      case LogLevel.error: return AppTheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface, elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface, size: 20),
          onPressed: () => Navigator.pop(context)),
        title: Text(t.setxAdvancedErrorLogsTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: cs.outline),
            tooltip: t.setxAdvancedClearAllLogsTooltip,
            onPressed: () => _confirmClear(context)),
        ],
      ),
      body: Column(children: [
        // Filter bar
        Container(
          color: cs.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            Expanded(child: _FilterDropdown<LogCategory?>(
              label: t.setxAdvancedFilterCategory, value: _selectedCategory, items: _categoryLabels(t),
              onChanged: (v) => setState(() => _selectedCategory = v), cs: cs)),
            const SizedBox(width: 8),
            Expanded(child: _FilterDropdown<LogLevel?>(
              label: t.setxAdvancedFilterLevel, value: _minLevel, items: _levelLabels(t),
              onChanged: (v) => setState(() => _minLevel = v), cs: cs)),
          ]),
        ),
        // Log list
        Expanded(
          child: ValueListenableBuilder<List<LogEntry>>(
            valueListenable: AppLogger.instance.logsNotifier,
            builder: (context, allLogs, _) {
              final filtered = AppLogger.instance.getFiltered(
                category: _selectedCategory, minLevel: _minLevel);
              final reversed = filtered.reversed.toList();
              if (reversed.isEmpty) {
                return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle_outline_rounded, color: cs.outline, size: 48),
                  const SizedBox(height: 12),
                  Text(t.setxAdvancedNoLogs, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15, color: cs.outline, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(t.setxAdvancedNoLogsSubtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.outline)),
                ]));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: reversed.length,
                itemBuilder: (context, index) {
                  final entry = reversed[index];
                  return _LogEntryTile(entry: entry, levelColor: _levelColor(entry.level, cs), cs: cs);
                });
            }),
        ),
      ]),
    );
  }

  void _confirmClear(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(t.setxAdvancedClearLogsTitle,
          style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface)),
      content: Text(t.setxAdvancedClearLogsBody,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.outline)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
            child: Text(t.setxAdvancedCancel, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.outline))),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await AppLogger.instance.clearLogs();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(t.setxAdvancedLogsCleared, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
            }
          },
          child: Text(t.setxAdvancedClear, style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.error, fontWeight: FontWeight.w700))),
      ],
    ));
  }
}

class _LogEntryTile extends StatefulWidget {
  final LogEntry entry;
  final Color levelColor;
  final ColorScheme cs;
  const _LogEntryTile({required this.entry, required this.levelColor, required this.cs});
  @override
  State<_LogEntryTile> createState() => _LogEntryTileState();
}

class _LogEntryTileState extends State<_LogEntryTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final cs = widget.cs;
    final t = AppLocalizations.of(context);
    final timeStr = DateFormat('HH:mm:ss').format(entry.timestamp);

    return GestureDetector(
      onTap: () { if (entry.detail != null) setState(() => _expanded = !_expanded); },
      onLongPress: () {
        Clipboard.setData(ClipboardData(
          text: '[${entry.levelLabel}][${entry.categoryLabel}] ${entry.message}'
              '${entry.detail != null ? '\n${entry.detail}' : ''}'));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t.setxAdvancedCopiedToClipboard, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
          backgroundColor: cs.primary, behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.outlineVariant)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.levelColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(5)),
                child: Text(entry.levelLabel, style: GoogleFonts.sourceCodePro(
                    fontSize: 10, fontWeight: FontWeight.w700, color: widget.levelColor))),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(5)),
                child: Text(entry.categoryLabel, style: GoogleFonts.sourceCodePro(
                    fontSize: 10, fontWeight: FontWeight.w600, color: cs.primary))),
              const Spacer(),
              Text(timeStr, style: GoogleFonts.sourceCodePro(fontSize: 10, color: cs.outline)),
              if (entry.detail != null) ...[
                const SizedBox(width: 4),
                Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    size: 16, color: cs.outline),
              ],
            ])),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Text(entry.message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface),
                overflow: TextOverflow.ellipsis, maxLines: _expanded ? 10 : 2)),
          if (_expanded && entry.detail != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(6)),
              child: Text(entry.detail!, style: GoogleFonts.sourceCodePro(fontSize: 11, color: cs.outline))),
        ]),
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;
  final ColorScheme cs;
  const _FilterDropdown({required this.label, required this.value,
      required this.items, required this.onChanged, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: cs.surface,
          borderRadius: BorderRadius.circular(8), border: Border.all(color: cs.outlineVariant)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value, isExpanded: true, dropdownColor: cs.surfaceContainerHighest,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface),
          hint: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline)),
          items: items.entries.map((e) => DropdownMenuItem<T>(
            value: e.key,
            child: Text(e.value, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface)),
          )).toList(),
          onChanged: (v) { if (v != null || null is T) onChanged(v as T); },
        ),
      ),
    );
  }
}

/// Tappable tile that shows the selected DoH provider and opens the manager.
class _DnsProviderTile extends StatelessWidget {
  final String selectedLabel;
  final VoidCallback onTap;
  const _DnsProviderTile({required this.selectedLabel, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: cs.outlineVariant)),
        child: Row(children: [
          Container(width: 36, height: 36,
              decoration: oledIconChip(context, color: const Color(0xFF06B6D4), fill: const Color(0xFF06B6D4).withAlpha(25), radius: 10),
              child: const Icon(Icons.cloud_rounded, color: Color(0xFF06B6D4), size: 18)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text('DNS provider', style: Theme.of(context).textTheme.titleSmall)),
          Text(selectedLabel, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.outline)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20),
        ]),
      ),
    );
  }
}
