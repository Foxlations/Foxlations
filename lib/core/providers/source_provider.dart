import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/source_model.dart';
import '../models/installed_source_model.dart';
import '../models/source_settings.dart';
import '../services/app_logger.dart';
import '../services/repo_service.dart';
import '../services/settings_store.dart';
import '../services/source_manager.dart';
import '../services/notification_service.dart';

class SourceProvider extends ChangeNotifier {
  // Browse preference keys (also referenced from BrowseSettingsPage).
  static const _showNsfwKey = 'browse_show_nsfw';
  static const _pinnedOnlyBrowseKey = 'browse_pinned_only';
  static const _pinnedOnlyGlobalSearchKey = 'browse_global_search_pinned_only';
  static const _autoUpdateExtKey = 'browse_auto_update_extensions';
  // The single pinned-source list — shared by the Sources tab, global search,
  // and each source's settings. Centralised here so a pin made in one place is
  // reflected everywhere immediately (the old per-widget cache went stale).
  static const _pinnedSourceIdsKey = 'pinned_source_ids';

  final RepoService _repoService = RepoService();
  final SourceManager _sourceManager = SourceManager();

  List<String> _repoUrls = [];
  final Map<String, RepoIndexResult> _repoIndexes = {};
  List<InstalledSource> _installedSources = [];
  // Ids with an install in flight — guards against a double-tap racing two
  // concurrent installs of the same source into duplicate entries.
  final Set<String> _installing = {};
  bool _isLoading = false;
  String? _error;

  /// Wired by the app shell: fired after a source is installed so library/vault
  /// entries a restore stranded on that source's name can be re-linked to it
  /// (see LibraryProvider.relinkSources) without waiting for the next launch.
  void Function()? onInstalledChanged;

  /// Installed sources as an id → display-name map, for the re-link pass.
  Map<String, String> get installedIdToName =>
      {for (final s in _installedSources) s.source.id: s.source.name};

  // Cached id → itemType map so the library's content-type filter can classify
  // each entry in O(1) instead of a linear getInstalledSource scan per item.
  // Rebuilt only when the installed-source list is replaced (identity check).
  List<InstalledSource>? _itemTypeCacheFor;
  Map<String, String> _itemTypeCache = const {};
  String installedItemType(String sourceId, [String fallback = 'manga']) {
    if (!identical(_itemTypeCacheFor, _installedSources)) {
      _itemTypeCache = {
        for (final s in _installedSources) s.source.id: s.source.itemType,
      };
      _itemTypeCacheFor = _installedSources;
    }
    return _itemTypeCache[sourceId] ?? fallback;
  }

  // Browse preferences (persisted)
  bool _showNsfw = false;
  bool _pinnedOnlyBrowse = false;
  bool _pinnedOnlyGlobalSearch = false;
  bool _autoUpdateExtensions = false;
  Set<String> _pinnedSourceIds = {};

  List<String> get repoUrls => _repoUrls;
  Map<String, RepoIndexResult> get repoIndexes => _repoIndexes;
  List<InstalledSource> get installedSources => _installedSources;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get showNsfw => _showNsfw;
  bool get pinnedOnlyBrowse => _pinnedOnlyBrowse;
  bool get pinnedOnlyGlobalSearch => _pinnedOnlyGlobalSearch;
  bool get autoUpdateExtensions => _autoUpdateExtensions;

  /// The set of pinned source ids (single source of truth for pinning).
  Set<String> get pinnedSourceIds => _pinnedSourceIds;
  bool isSourcePinned(String id) => _pinnedSourceIds.contains(id);

  /// Pin/unpin a source — persists and notifies so every view updates at once.
  Future<void> toggleSourcePin(String id) async {
    if (!_pinnedSourceIds.remove(id)) _pinnedSourceIds.add(id);
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          _pinnedSourceIdsKey, _pinnedSourceIds.toList());
    } catch (_) {/* best effort */}
  }

  /// Re-read pins from disk (e.g. after a source-settings page changed them)
  /// and notify, so the Sources tab reflects the change immediately.
  Future<void> reloadPinnedSources() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _pinnedSourceIds =
          (prefs.getStringList(_pinnedSourceIdsKey) ?? const []).toSet();
      notifyListeners();
    } catch (_) {/* best effort */}
  }

  /// All available sources across all repos.
  List<MangaSource> get allSources =>
      _repoIndexes.values.expand((r) => r.sources).toList();

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load browse preferences first so consumers see the right values on
      // their initial build.
      _showNsfw = SettingsStore.instance.getBool(_showNsfwKey) ?? false;
      _pinnedOnlyBrowse =
          SettingsStore.instance.getBool(_pinnedOnlyBrowseKey) ?? false;
      _pinnedOnlyGlobalSearch =
          SettingsStore.instance.getBool(_pinnedOnlyGlobalSearchKey) ?? false;
      _autoUpdateExtensions =
          SettingsStore.instance.getBool(_autoUpdateExtKey) ?? false;
      try {
        final prefs = await SharedPreferences.getInstance();
        _pinnedSourceIds =
            (prefs.getStringList(_pinnedSourceIdsKey) ?? const []).toSet();
      } catch (_) {}

      _repoUrls = await _repoService.getSavedRepos();
      _installedSources = await _sourceManager.getInstalledSources();
      // SourceSettings.cached() is read from sync hot paths (search fan-out,
      // update loop), so it must be warm before those run.
      await SourceSettings.preload(_installedSources.map((s) => s.source.id));
      // The HTTP layer checks desktop mode by host on every request and can't
      // await, so the host set has to be in memory before any source runs.
      await SourceSettings.preloadDesktopHosts();

      // Load cached indexes
      for (final url in _repoUrls) {
        final cached = await _repoService.getCachedIndex(url);
        if (!cached.isEmpty) {
          _repoIndexes[url] = cached;
        }
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();

    // If auto-update is on, refresh installed extension code in the
    // background. Doesn't block the initial app load.
    if (_autoUpdateExtensions) {
      // ignore: unawaited_futures
      refreshAllSourceCode();
    } else if (_installedSources.isNotEmpty) {
      // Otherwise just refresh the repo indexes (small JSON) in the background so
      // the "updates available" badge reflects the latest published versions,
      // then notify if any are available (Advanced > Extension update notify).
      // ignore: unawaited_futures
      refreshReposQuiet().then((_) => _maybeNotifyExtensionUpdates());
    }
  }

  Future<void> setShowNsfw(bool value) async {
    if (_showNsfw == value) return;
    _showNsfw = value;
    await SettingsStore.instance.setBool(_showNsfwKey, value);
    notifyListeners();
  }

  Future<void> setPinnedOnlyBrowse(bool value) async {
    if (_pinnedOnlyBrowse == value) return;
    _pinnedOnlyBrowse = value;
    await SettingsStore.instance.setBool(_pinnedOnlyBrowseKey, value);
    notifyListeners();
  }

  Future<void> setPinnedOnlyGlobalSearch(bool value) async {
    if (_pinnedOnlyGlobalSearch == value) return;
    _pinnedOnlyGlobalSearch = value;
    await SettingsStore.instance.setBool(_pinnedOnlyGlobalSearchKey, value);
    notifyListeners();
  }

  Future<void> setAutoUpdateExtensions(bool value) async {
    if (_autoUpdateExtensions == value) return;
    _autoUpdateExtensions = value;
    await SettingsStore.instance.setBool(_autoUpdateExtKey, value);
    notifyListeners();
  }

  /// Notify about available extension updates (Advanced > Extension update
  /// notify, default off). Fired after the quiet repo-index refresh on launch.
  void _maybeNotifyExtensionUpdates() {
    if (!(SettingsStore.instance.getBool('adv_extension_update_notify') ??
        false)) {
      return;
    }
    final count = sourcesWithUpdates.length;
    if (count > 0) NotificationService.instance.extensionUpdates(count);
  }

  Future<void> refreshRepos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      for (final url in _repoUrls) {
        try {
          _repoIndexes[url] = await _repoService.fetchRepoIndex(url);
        } catch (e) {
          // Keep cached version on failure
          debugPrint('Failed to refresh $url: $e');
        }
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch a repo's index WITHOUT saving it, so a confirm dialog (e.g. the
  /// deep-link auto-install) can show the repo's name and source count before
  /// the user commits. Returns null if the fetch fails.
  Future<RepoIndexResult?> previewRepo(String url) async {
    try {
      return await _repoService.fetchRepoIndex(url);
    } catch (e) {
      debugPrint('[SourceProvider] previewRepo failed: $e');
      return null;
    }
  }

  Future<void> addRepo(String url, {RepoIndexResult? prefetched}) async {
    await _repoService.addRepo(url);
    _repoUrls = await _repoService.getSavedRepos();

    try {
      // Reuse an index already fetched for a preview (deep-link confirm) so a
      // big repo is not downloaded + parsed twice.
      _repoIndexes[url] = prefetched ?? await _repoService.fetchRepoIndex(url);
    } catch (e) {
      debugPrint('[SourceProvider] addRepo fetch failed: $e');
      await logger.error('Failed to fetch repo: $url',
          category: LogCategory.repo, detail: e.toString());
    }

    notifyListeners();
  }

  Future<void> removeRepo(String url) async {
    // Uninstall all sources that came from this repo
    final toRemove = _installedSources
        .where((s) => s.source.repoUrl == url)
        .map((s) => s.source.id)
        .toList();
    for (final id in toRemove) {
      await _sourceManager.uninstallSource(id);
    }

    await _repoService.removeRepo(url);
    _repoUrls = await _repoService.getSavedRepos();
    _repoIndexes.remove(url);
    _installedSources = await _sourceManager.getInstalledSources();
    notifyListeners();
  }

  /// Non-destructive "reinstall": re-fetch the repo index, then re-download +
  /// re-install the sources already installed from it (so they pick up upstream
  /// fixes / re-convert their jar). Does NOT touch the user's other repos or
  /// uninstall anything. Returns how many sources were reinstalled.
  Future<int> reinstallRepo(String url) async {
    RepoIndexResult? fresh;
    try {
      fresh = await _repoService.fetchRepoIndex(url);
      _repoIndexes[url] = fresh;
      notifyListeners();
    } catch (e) {
      await logger.error('Failed to refresh repo: $url',
          category: LogCategory.repo, detail: e.toString());
    }
    final installedFromRepo =
        _installedSources.where((s) => s.source.repoUrl == url).toList();
    var done = 0;
    for (final inst in installedFromRepo) {
      // Prefer the fresh index entry (latest version/urls); fall back to the
      // installed source's own config.
      final src = fresh?.sources
              .where((s) => s.id == inst.source.id)
              .cast<MangaSource?>()
              .firstWhere((_) => true, orElse: () => null) ??
          inst.source;
      try {
        await _sourceManager.installSource(src);
        done++;
      } catch (e) {
        await logger.error('Reinstall failed: ${inst.source.name}',
            category: LogCategory.repo, detail: e.toString());
      }
    }
    _installedSources = await _sourceManager.getInstalledSources();
    notifyListeners();
    return done;
  }

  Future<void> installSource(MangaSource source) async {
    // Ignore a duplicate tap while this source is already installing.
    if (!_installing.add(source.id)) return;
    try {
      await _sourceManager.installSource(source);
      _installedSources = await _sourceManager.getInstalledSources();
      notifyListeners();
      onInstalledChanged?.call();
    } catch (e) {
      _error = 'Install failed: $e';
      notifyListeners();
      rethrow;
    } finally {
      _installing.remove(source.id);
    }
  }

  Future<void> uninstallSource(String sourceId) async {
    await _sourceManager.uninstallSource(sourceId);
    _installedSources = await _sourceManager.getInstalledSources();
    notifyListeners();
  }

  /// Re-downloads a single installed source's code from its remote URL.
  Future<void> refreshSourceCode(String sourceId) async {
    try {
      await _sourceManager.refreshSourceCode(sourceId);
      _installedSources = await _sourceManager.getInstalledSources();
      notifyListeners();
    } catch (e) {
      _error = 'Refresh failed: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Re-downloads every installed source's code. Returns how many succeeded.
  Future<int> refreshAllSourceCode() async {
    final count = await _sourceManager.refreshAllSourceCode();
    _installedSources = await _sourceManager.getInstalledSources();
    notifyListeners();
    return count;
  }

  // ── Extension update detection ────────────────────────────────────────────
  // Compares each installed source's stored version against the current version
  // in its repo index (matched by the stable source id). Drives the "N updates"
  // badge on the Browse tab + the list header in the Extensions tab.

  Map<String, MangaSource> get _availableById {
    final m = <String, MangaSource>{};
    for (final s in allSources) {
      m[s.id] = s;
    }
    return m;
  }

  List<int> _verParts(String v) => v
      .split(RegExp(r'[.\-+ ]'))
      .map((x) => int.tryParse(x.replaceAll(RegExp(r'\D'), '')) ?? 0)
      .toList();

  bool _isNewer(String repoV, String installedV) {
    final pa = _verParts(repoV);
    final pb = _verParts(installedV);
    final n = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < n; i++) {
      final va = i < pa.length ? pa[i] : 0;
      final vb = i < pb.length ? pb[i] : 0;
      if (va != vb) return va > vb;
    }
    return false;
  }

  /// Installed sources whose repo now offers a newer version.
  List<InstalledSource> get sourcesWithUpdates {
    final byId = _availableById;
    return _installedSources.where((s) {
      final repo = byId[s.source.id];
      return repo != null && _isNewer(repo.version, s.source.version);
    }).toList();
  }

  /// Sources with updates that belong to the CURRENT space: only vaulted sources
  /// when the vault is open, only non-vault sources otherwise — so a vaulted
  /// source's update never surfaces in the normal Browse view (and vice-versa).
  List<InstalledSource> updatesForContext({
    required bool vaultActive,
    required Set<String> vaultIds,
  }) {
    return sourcesWithUpdates.where((s) {
      final inVault = vaultIds.contains(s.source.id);
      return vaultActive ? inVault : !inVault;
    }).toList();
  }

  bool hasUpdate(String sourceId) {
    final repo = _availableById[sourceId];
    if (repo == null) return false;
    for (final s in _installedSources) {
      if (s.source.id == sourceId) return _isNewer(repo.version, s.source.version);
    }
    return false;
  }

  /// Update one source: re-install from its repo entry, which records the new
  /// version and re-downloads the code/jar (installSource upserts by id).
  /// Returns true if a repo entry was found and (re)installed; false if there was
  /// no matching repo source to update from.
  Future<bool> updateSource(String sourceId) async {
    final repo = _availableById[sourceId];
    if (repo == null) return false;
    await installSource(repo);
    return true;
  }

  /// Update the given sources from their repo entries. Returns how many succeeded.
  /// Callers pass the ids for the current space (see [updatesForContext]) so a
  /// hidden vaulted source is never updated from the normal view.
  Future<int> updateAll(List<String> ids) async {
    var n = 0;
    for (final id in ids) {
      try {
        if (await updateSource(id)) n++;
      } catch (_) {}
    }
    return n;
  }

  /// Refresh repo indexes in the background (no loading spinner) so the update
  /// badge reflects the latest published versions without a manual pull-to-refresh.
  Future<void> refreshReposQuiet() async {
    for (final url in _repoUrls) {
      try {
        _repoIndexes[url] = await _repoService.fetchRepoIndex(url);
      } catch (_) {}
    }
    notifyListeners();
  }

  /// Resolve an installed source for a (possibly stranded) library source id.
  ///
  /// A Tachiyomi/Mihon restore that ran before the matching source was installed
  /// saves each entry's source as the backup's source NAME (e.g. "Asura Scans"),
  /// not an installed id — so once the source is installed, a plain id lookup
  /// still misses and the library wrongly reports "source not installed". This
  /// falls back to matching that stored value against installed source names so
  /// the entry opens against the real source.
  InstalledSource? resolveInstalled(String sourceId) {
    final direct = getInstalledSource(sourceId);
    if (direct != null) return direct;
    if (sourceId.isEmpty) return null;
    String norm(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final want = norm(sourceId);
    if (want.isEmpty) return null;
    // Exact normalised name first ("Asura Scans" == "asurascans")…
    for (final s in _installedSources) {
      if (norm(s.source.name) == want) return s;
    }
    // …then containment ("Asura Scans (EN)" vs "Asura Scans").
    for (final s in _installedSources) {
      final n = norm(s.source.name);
      if (n.isNotEmpty && (n.contains(want) || want.contains(n))) return s;
    }
    return null;
  }

  /// Human name for a source id — the installed extension's name if present,
  /// otherwise a repo entry's name if the source is known but not installed
  /// (e.g. a title restored from a backup before its source was reinstalled),
  /// and finally the raw id so the detail page always shows *something*.
  String sourceDisplayName(String sourceId) {
    final inst = resolveInstalled(sourceId);
    if (inst != null) return inst.source.name;
    final avail = _availableById[sourceId];
    if (avail != null) return avail.name;
    return sourceId;
  }

  bool isInstalled(String sourceId) => _sourceManager.isInstalled(sourceId);

  InstalledSource? getInstalledSource(String sourceId) {
    try {
      return _installedSources.firstWhere((s) => s.source.id == sourceId);
    } catch (_) {
      return null;
    }
  }
}
