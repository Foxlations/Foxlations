import 'package:flutter/foundation.dart' hide Category;
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import '../models/manga_model.dart';
import '../models/chapter_model.dart';
import '../models/category_model.dart';
import '../services/library_service.dart';
import '../services/secure_store.dart';
import '../services/vault_crypto.dart';
import '../services/app_logger.dart';
import 'incognito_provider.dart';
import 'library_like.dart';

/// Arguments for the off-thread key derivation.
class _KdfRequest {
  final String password;
  final Uint8List salt;
  final int iterations;
  const _KdfRequest(this.password, this.salt, this.iterations);
}

/// PBKDF2 with 50k iterations takes ~1s in pure Dart, which would jank the UI
/// on the main isolate - so it runs via `compute`. Must be top-level.
Uint8List _deriveKeyIsolate(_KdfRequest r) =>
    VaultCrypto.deriveKey(r.password, r.salt, iterations: r.iterations);

class VaultProvider extends ChangeNotifier implements LibraryLike {
  static const _settingsBoxName = 'vault_settings';

  // Points at the real vault ('vault' prefix) normally, or the decoy vault
  // ('vault_decoy' prefix) when unlocked with the decoy password. Reassigned on
  // unlock/exit so every operation targets whichever vault is open.
  LibraryService _vaultService = LibraryService(prefix: 'vault');
  bool _decoyActive = false;
  Box? _settingsBox;

  /// True when the currently-open vault is the decoy (a separate, isolated vault).
  bool get decoyActive => _decoyActive;

  List<LibraryManga> _manga = [];
  List<Category> _categories = [];
  bool _initialized = false;
  bool _vaultEnabled = true;
  bool _vaultActive = false;
  Set<String> _vaultSourceIds = {};

  @override
  List<LibraryManga> get manga => _manga;
  List<Category> get categories => _categories;
  bool get initialized => _initialized;

  /// Bumped on every notify so the library screen's memoized filtered list
  /// recomputes when vault data changes (over-bumping is safe; see
  /// LibraryProvider.dataVersion).
  int _dataVersion = 0;
  int get dataVersion => _dataVersion;

  @override
  void notifyListeners() {
    _dataVersion++;
    super.notifyListeners();
  }

  /// Guards a vault WRITE: the encrypted boxes are only open while unlocked, and
  /// `LibraryService` accesses them null-safely, so a write attempted while
  /// locked silently no-ops (and would then clobber the in-memory list to empty
  /// on reload). Instead, refuse and log it loudly so the failure is visible in
  /// Debug logs rather than looking like silent data loss. Returns true when the
  /// caller may proceed. UI paths are also gated on [isUnlocked]; this is the
  /// last-line guard.
  bool _ensureOpen(String op) {
    if (_vaultService.isOpen) return true;
    logger.warning('Vault "$op" ignored - vault is locked (boxes closed)',
        category: LogCategory.library);
    return false;
  }

  /// Source IDs that are hidden behind vault mode
  Set<String> get vaultSourceIds => _vaultSourceIds;

  /// Whether the vault feature is accessible (secret setting)
  bool get vaultEnabled => _vaultEnabled;

  /// Whether vault mode is currently active (user tapped in)
  bool get vaultActive => _vaultActive;

  Future<void> initialize() async {
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _vaultEnabled = _settingsBox?.get('enabled', defaultValue: true) ?? true;
    _vaultSourceIds = ((_settingsBox?.get('vault_source_ids') as List?) ?? [])
        .cast<String>().toSet();

    // Vault contents are NOT opened here when a password is set. Previously
    // they were loaded at startup regardless, so the password only hid the UI
    // - the plaintext Hive files were readable by anything with filesystem
    // access. Now the boxes stay encrypted and closed until [unlock] supplies
    // the key derived from the password.
    if (!hasPassword) {
      await _vaultService.init();
      _manga = _vaultService.getAllManga();
      _categories = _vaultService.getCategories();
      await _vaultService.purgeEstimatedReadTime();
      await _migrateLeakedChapters();
    }
    _initialized = true;
    notifyListeners();
  }

  // ── Password protection ─────────────────────────────────────
  bool get hasPassword =>
      (_settingsBox?.get('vault_verifier') as String?)?.isNotEmpty ?? false;

  /// True once [unlock] has succeeded - i.e. the encrypted boxes are open.
  bool get isUnlocked => !hasPassword || _vaultService.isOpen;

  Uint8List _saltOrNew() {
    final stored = _settingsBox?.get('vault_salt');
    if (stored is List && stored.isNotEmpty) {
      return Uint8List.fromList(stored.cast<int>());
    }
    return VaultCrypto.newSalt();
  }

  /// Derives the key, checks it against the stored verifier, and - only on
  /// success - opens the encrypted boxes and loads their contents.
  Future<bool> unlock(String password) async {
    if (!hasPassword) return true;
    final salt = _saltOrNew();
    final iterations =
        (_settingsBox?.get('vault_iterations') as int?) ??
            VaultCrypto.defaultIterations;

    final key = await compute<_KdfRequest, Uint8List>(
      _deriveKeyIsolate,
      _KdfRequest(password, salt, iterations),
    );
    if (VaultCrypto.verifierFor(key) ==
        (_settingsBox?.get('vault_verifier') as String?)) {
      // Real password → open the real vault.
      _decoyActive = false;
      _vaultService = LibraryService(prefix: 'vault');
      await _vaultService.init(cipher: VaultCrypto.cipherFor(key));
      _manga = _vaultService.getAllManga();
      _categories = _vaultService.getCategories();
      await _vaultService.purgeEstimatedReadTime();
      await _migrateLeakedChapters();
      notifyListeners();
      return true;
    }

    // Decoy password → open a SEPARATE, isolated decoy vault instead. Looks and
    // behaves like the real one; the real vault stays encrypted and untouched.
    if (hasDecoyPassword) {
      final dsalt = _decoySaltOrNull();
      final diter = (_settingsBox?.get('vault_decoy_iterations') as int?) ??
          VaultCrypto.defaultIterations;
      if (dsalt != null) {
        final dkey = await compute<_KdfRequest, Uint8List>(
            _deriveKeyIsolate, _KdfRequest(password, dsalt, diter));
        if (VaultCrypto.verifierFor(dkey) ==
            (_settingsBox?.get('vault_decoy_verifier') as String?)) {
          _decoyActive = true;
          _vaultService = LibraryService(prefix: 'vault_decoy');
          await _vaultService.init(cipher: VaultCrypto.cipherFor(dkey));
          _manga = _vaultService.getAllManga();
          _categories = _vaultService.getCategories();
          notifyListeners();
          return true;
        }
      }
    }
    return false;
  }

  // ── Decoy password (opens an isolated fake vault) ────────────
  bool get hasDecoyPassword =>
      (_settingsBox?.get('vault_decoy_verifier') as String?)?.isNotEmpty ?? false;

  Uint8List? _decoySaltOrNull() {
    final stored = _settingsBox?.get('vault_decoy_salt');
    if (stored is List) return Uint8List.fromList(stored.cast<int>());
    return null;
  }

  /// Set or clear the decoy password. Must differ from the real password (a
  /// password is checked against the real verifier first on unlock).
  Future<bool> setDecoyPassword(String? password) async {
    if (_decoyActive) return false; // can't manage decoy from inside the decoy
    if (password == null || password.isEmpty) {
      await _settingsBox?.delete('vault_decoy_verifier');
      await _settingsBox?.delete('vault_decoy_salt');
      await _settingsBox?.delete('vault_decoy_iterations');
      notifyListeners();
      return true;
    }
    final salt = VaultCrypto.newSalt();
    final key = await compute<_KdfRequest, Uint8List>(
        _deriveKeyIsolate, _KdfRequest(password, salt, VaultCrypto.defaultIterations));
    // Reject a decoy equal to the real password (it'd never open the decoy).
    if (hasPassword && await verifyPassword(password)) return false;
    await _settingsBox?.put('vault_decoy_salt', salt.toList());
    await _settingsBox?.put('vault_decoy_iterations', VaultCrypto.defaultIterations);
    await _settingsBox?.put('vault_decoy_verifier', VaultCrypto.verifierFor(key));
    notifyListeners();
    return true;
  }

  /// Sets or clears the vault password.
  ///
  /// Changing it re-encrypts: the current contents are read with the old key
  /// (or from the plaintext boxes on first use), the boxes are deleted, then
  /// rewritten under the new key. Without this, existing vault data would be
  /// stranded in files the new key can't open.
  Future<void> setPassword(String? password) async {
    if (_decoyActive) return; // never touch the real vault from inside the decoy
    // Snapshot each entry WITH its chapters (read flags, resume positions,
    // cached chapter lists) BEFORE closing - vault_chapters is deleted below,
    // and restoring manga alone wiped all vault reading progress.
    final existingManga = List<LibraryManga>.from(_manga);
    final existingChapters = <List<LibraryChapter>>[
      for (final m in existingManga)
        List<LibraryChapter>.from(_vaultService.getFullChapters(m.sourceId, m.url)),
    ];
    final existingCats = _categories.map((c) => c.name).toList();

    await _vaultService.close();
    await Hive.deleteBoxFromDisk('vault_manga');
    await Hive.deleteBoxFromDisk('vault_chapters');
    await Hive.deleteBoxFromDisk('vault_categories');

    if (password == null || password.isEmpty) {
      await _settingsBox?.delete('vault_verifier');
      await _settingsBox?.delete('vault_salt');
      await _settingsBox?.delete('vault_iterations');
      await _vaultService.init();
    } else {
      final salt = VaultCrypto.newSalt();
      final key = await compute<_KdfRequest, Uint8List>(
        _deriveKeyIsolate,
        _KdfRequest(password, salt, VaultCrypto.defaultIterations),
      );
      await _settingsBox?.put('vault_salt', salt.toList());
      await _settingsBox?.put('vault_iterations', VaultCrypto.defaultIterations);
      await _settingsBox?.put('vault_verifier', VaultCrypto.verifierFor(key));
      await _vaultService.init(cipher: VaultCrypto.cipherFor(key));
    }

    // Restore what was there before, now under the new encryption.
    for (final name in existingCats) {
      if (!_vaultService.getCategories().any((c) => c.name == name)) {
        await _vaultService.addCategory(name);
      }
    }
    for (var i = 0; i < existingManga.length; i++) {
      await _vaultService.addEntryWithChapters(
          existingManga[i], existingChapters[i]);
    }
    _manga = _vaultService.getAllManga();
    _categories = _vaultService.getCategories();
    // Keep biometric in sync with a changed/cleared password.
    if (biometricEnabled) {
      if (password == null || password.isEmpty) {
        await disableBiometric();
      } else {
        await SecureStore.writeSecret(_vaultPwSecret, password);
      }
    }
    notifyListeners();
  }

  // ── Biometric unlock (opt-in) ───────────────────────────────
  // The vault key is PBKDF2(password), so biometrics can't derive it directly.
  // Instead the password is stashed in the platform keychain and retrieved only
  // after a successful Face ID / fingerprint (or device-passcode) check.
  static const _vaultPwSecret = 'vault_password';

  bool get biometricEnabled =>
      (_settingsBox?.get('vault_biometric', defaultValue: false) as bool?) ?? false;

  Future<bool> deviceSupportsBiometric() async {
    try {
      return await LocalAuthentication().isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Check [password] against the stored verifier without opening the boxes.
  Future<bool> verifyPassword(String password) async {
    if (!hasPassword) return false;
    final salt = _saltOrNew();
    final iterations = (_settingsBox?.get('vault_iterations') as int?) ??
        VaultCrypto.defaultIterations;
    final key = await compute<_KdfRequest, Uint8List>(
        _deriveKeyIsolate, _KdfRequest(password, salt, iterations));
    return VaultCrypto.verifierFor(key) ==
        (_settingsBox?.get('vault_verifier') as String?);
  }

  /// Enable biometric unlock after confirming the vault [password].
  Future<bool> enableBiometric(String password) async {
    if (!hasPassword) return false;
    if (!await verifyPassword(password)) return false;
    await SecureStore.writeSecret(_vaultPwSecret, password);
    await _settingsBox?.put('vault_biometric', true);
    notifyListeners();
    return true;
  }

  Future<void> disableBiometric() async {
    await SecureStore.deleteSecret(_vaultPwSecret);
    await _settingsBox?.put('vault_biometric', false);
    notifyListeners();
  }

  /// Face ID / fingerprint → retrieve the stored password → unlock.
  Future<bool> unlockWithBiometric() async {
    if (!biometricEnabled) return false;
    try {
      final ok = await LocalAuthentication().authenticate(
        localizedReason: 'Unlock your vault',
        options: const AuthenticationOptions(
            stickyAuth: true, biometricOnly: false),
      );
      if (!ok) return false;
    } catch (_) {
      return false;
    }
    final pw = await SecureStore.readSecret(_vaultPwSecret);
    if (pw == null || pw.isEmpty) return false;
    return unlock(pw);
  }

  // ── Vault mode control ──────────────────────────────────────
  void enterVault() {
    if (!_vaultEnabled) return;
    if (hasPassword && !_vaultService.isOpen) return; // must unlock first
    _vaultActive = true;
    notifyListeners();
  }

  /// Leaving the vault closes the encrypted boxes and drops the decrypted copy
  /// from memory, so the data isn't left readable until the app restarts.
  Future<void> exitVault() async {
    _vaultActive = false;
    // Only tear down the service for the ENCRYPTED paths (password or decoy):
    // close the boxes, drop the decrypted copy, and reset to a fresh closed
    // service so the next unlock starts clean. A NO-PASSWORD vault's boxes were
    // opened once in initialize() and must STAY open - exitVault fires on every
    // app-background (main.dart lifecycle) and on tapping out to the normal
    // library, so swapping in a fresh un-init'd service here left the no-password
    // vault write-dead (isOpen=false) until an app restart.
    if (hasPassword || _decoyActive) {
      await _vaultService.close();
      _manga = [];
      _categories = [];
      _decoyActive = false;
      _vaultService = LibraryService(prefix: 'vault');
    }
    notifyListeners();
  }

  /// One-time cleanup of vault reads that LEAKED into the PUBLIC `library_chapters`
  /// box before the detail/reader stack was routed per-title ([[vault-closed-box-bugs]]
  /// Fix 2). For titles that live ONLY in the vault, move their chapter rows out
  /// of the plaintext library box into the vault box - so stats separate and
  /// nothing vault-related is left readable in plaintext. Only vault-ONLY titles
  /// are touched (never one also in the public library), and it's idempotent
  /// (after the move there's nothing left to move). Runs on unlock.
  Future<void> _migrateLeakedChapters() async {
    if (!_vaultService.isOpen) return;
    final Box<LibraryChapter> libCh;
    final Box<LibraryChapter> vaultCh;
    try {
      libCh = Hive.box<LibraryChapter>('library_chapters');
      vaultCh = Hive.box<LibraryChapter>(
          '${_decoyActive ? 'vault_decoy' : 'vault'}_chapters');
    } catch (_) {
      return; // a box isn't open - nothing to do
    }
    final vaultMangaKeys = _manga.map((m) => m.uniqueKey).toSet();
    if (vaultMangaKeys.isEmpty) return;
    Set<String> libMangaKeys = const {};
    try {
      libMangaKeys = Hive.box<LibraryManga>('library_manga')
          .values
          .map((m) => m.uniqueKey)
          .toSet();
    } catch (_) {}
    final moveKeys = <dynamic>[];
    for (final e in libCh.toMap().entries) {
      final c = e.value;
      final mangaKey = '${c.sourceId}_${c.mangaUrl}';
      if (vaultMangaKeys.contains(mangaKey) &&
          !libMangaKeys.contains(mangaKey)) {
        moveKeys.add(e.key);
      }
    }
    if (moveKeys.isEmpty) return;
    for (final k in moveKeys) {
      final c = libCh.get(k);
      if (c != null && !vaultCh.containsKey(k)) {
        await vaultCh.put(k, c.clone());
      }
      await libCh.delete(k);
    }
    _manga = _vaultService.getAllManga();
    logger.warning(
        'Vault: moved ${moveKeys.length} leaked chapter row(s) out of the public box into the vault',
        category: LogCategory.library);
    notifyListeners();
  }

  void setVaultEnabled(bool enabled) {
    _vaultEnabled = enabled;
    _settingsBox?.put('enabled', enabled);
    if (!enabled) _vaultActive = false;
    notifyListeners();
  }

  // ── Vault source visibility ───────────────────────────────
  bool isSourceInVault(String sourceId) => _vaultSourceIds.contains(sourceId);

  void toggleVaultSource(String sourceId) {
    if (_vaultSourceIds.contains(sourceId)) {
      _vaultSourceIds.remove(sourceId);
    } else {
      _vaultSourceIds.add(sourceId);
    }
    _settingsBox?.put('vault_source_ids', _vaultSourceIds.toList());
    notifyListeners();
  }

  // ── Category management (mirrors LibraryProvider) ───────────
  Future<void> addCategory(String name) async {
    if (!_ensureOpen('addCategory')) return;
    await _vaultService.addCategory(name);
    _categories = _vaultService.getCategories();
    notifyListeners();
  }

  Future<void> removeCategory(String name) async {
    if (!_ensureOpen('removeCategory')) return;
    await _vaultService.removeCategory(name);
    _categories = _vaultService.getCategories();
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> reorderCategories(List<String> orderedNames) async {
    if (!_ensureOpen('reorderCategories')) return;
    await _vaultService.reorderCategories(orderedNames);
    _categories = _vaultService.getCategories();
    notifyListeners();
  }

  Future<void> renameCategory(String oldName, String newName) async {
    if (!_ensureOpen('renameCategory')) return;
    await _vaultService.renameCategory(oldName, newName);
    _categories = _vaultService.getCategories();
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> setMangaCategories(
      String sourceId, String url, List<String> cats) async {
    if (!_ensureOpen('setMangaCategories')) return;
    final manga = _vaultService.getManga(sourceId, url);
    if (manga != null) {
      manga.categories = cats;
      await _vaultService.updateManga(manga);
      _manga = _vaultService.getAllManga();
      notifyListeners();
    }
  }

  // ── Manga management ────────────────────────────────────────
  @override
  bool isInLibrary(String sourceId, String url) {
    return _vaultService.isInLibrary(sourceId, url);
  }

  Future<void> addToLibrary(LibraryManga manga) async {
    if (!_ensureOpen('addToLibrary')) return;
    await _vaultService.addManga(manga);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Cache the source's browsable URL on this vault entry (instant cold-start
  /// "Open in WebView"). Quiet - no notify.
  Future<void> setWebUrl(String sourceId, String url, String? webUrl) =>
      _vaultService.setWebUrl(sourceId, url, webUrl);

  /// Re-read the vault from its boxes if they're open (e.g. after a backup
  /// import routed vault titles straight into the vault box). No-op when locked.
  void reloadIfOpen() {
    if (!_vaultService.isOpen) return;
    _manga = _vaultService.getAllManga();
    _categories = _vaultService.getCategories();
    notifyListeners();
  }

  Future<void> removeFromLibrary(String sourceId, String url) async {
    if (!_ensureOpen('removeFromLibrary')) return;
    await _vaultService.removeManga(sourceId, url);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Full chapter objects (with read state) for an entry, for moving out.
  List<LibraryChapter> fullChapters(String sourceId, String url) =>
      _vaultService.getFullChapters(sourceId, url);

  /// Adds an entry and its chapters into the vault, preserving read progress.
  Future<void> addEntryWithChapters(
      LibraryManga manga, List<LibraryChapter> chapters) async {
    if (!_ensureOpen('addEntryWithChapters')) return;
    await _vaultService.addEntryWithChapters(manga, chapters);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Bulk add - one reload + one notify for the whole batch (moving many titles
  /// otherwise reloaded the full list + rebuilt the UI per item = O(N*M)).
  Future<void> addEntriesWithChaptersBulk(
      List<(LibraryManga, List<LibraryChapter>)> entries) async {
    if (!_ensureOpen('addEntriesWithChaptersBulk')) return;
    for (final (m, ch) in entries) {
      await _vaultService.addEntryWithChapters(m, ch);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Bulk remove - one reload + one notify for the whole batch.
  Future<void> removeMangaBulk(List<(String, String)> keys) async {
    if (!_ensureOpen('removeMangaBulk')) return;
    for (final (sid, url) in keys) {
      await _vaultService.removeManga(sid, url);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> markAllReadBulk(List<(String, String)> keys) async {
    if (!_ensureOpen('markAllReadBulk')) return;
    for (final (sid, url) in keys) {
      await _vaultService.markAllChaptersRead(sid, url);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> markAllUnreadBulk(List<(String, String)> keys) async {
    if (!_ensureOpen('markAllUnreadBulk')) return;
    for (final (sid, url) in keys) {
      await _vaultService.markAllChaptersUnread(sid, url);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> setMangaCategoriesBulk(
      List<(String, String, List<String>)> items) async {
    if (!_ensureOpen('setMangaCategoriesBulk')) return;
    for (final (sid, url, cats) in items) {
      final m = _vaultService.getManga(sid, url);
      if (m != null) {
        m.categories = cats;
        await _vaultService.updateManga(m);
      }
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Re-link vault entries stranded on a source name onto the installed id.
  /// Only meaningful while the vault is unlocked (its boxes are open).
  Future<int> relinkSources(Map<String, String> installedIdToName) async {
    if (!vaultActive) return 0;
    final n = await _vaultService.relinkSources(installedIdToName);
    if (n > 0) {
      _manga = _vaultService.getAllManga();
      notifyListeners();
    }
    return n;
  }

  @override
  Future<void> updateReadingProgress(
      String sourceId, String mangaUrl, String chapterUrl, int page) async {
    // Persist only (fires per page turn; not shown live) - see the note on
    // LibraryProvider.updateReadingProgress.
    await _vaultService.updateReadingProgress(
        sourceId, mangaUrl, chapterUrl, page);
  }

  /// Persist novel reading position into the VAULT (scroll offset + reflow-safe
  /// fraction). Mirrors [LibraryProvider.updateNovelProgress], guarded by
  /// [_ensureOpen] so a locked vault refuses the write.
  @override
  Future<void> updateNovelProgress(
    String sourceId,
    String mangaUrl,
    String chapterUrl,
    int offset,
    double fraction,
  ) async {
    if (!_ensureOpen('updateNovelProgress')) return;
    if (IncognitoProvider.active) return;
    await _vaultService.updateNovelProgress(
        sourceId, mangaUrl, chapterUrl, offset, fraction);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Persist anime playback position into the VAULT (seconds). Mirrors
  /// [LibraryProvider.updateEpisodeProgress] - [notify] gates the reload so the
  /// mid-watch throttle doesn't rebuild the vault grid on every tick.
  @override
  Future<void> updateEpisodeProgress(
    String sourceId,
    String mangaUrl,
    String episodeUrl,
    int positionSeconds, {
    int totalSeconds = 0,
    bool notify = false,
  }) async {
    if (!_ensureOpen('updateEpisodeProgress')) return;
    if (IncognitoProvider.active) return;
    await _vaultService.updateEpisodeProgress(
        sourceId, mangaUrl, episodeUrl, positionSeconds,
        totalSeconds: totalSeconds);
    if (notify) {
      _manga = _vaultService.getAllManga();
      notifyListeners();
    }
  }

  @override
  int episodeLastPosition(String sourceId, String episodeUrl) =>
      _vaultService.episodeLastPosition(sourceId, episodeUrl);

  /// Accumulate active read/watch time (Reading Insights) into the vault entry.
  /// Quiet/persist-only; skipped while locked or reading privately (incognito).
  @override
  Future<void> addReadTime(String sourceId, String mangaUrl, int seconds) async {
    if (IncognitoProvider.active) return;
    if (!_ensureOpen('addReadTime')) return;
    await _vaultService.addReadTime(sourceId, mangaUrl, seconds);
  }

  @override
  Future<void> cacheChapters(String sourceId, String mangaUrl, List<Map<String, dynamic>> chapters) async {
    if (!_ensureOpen('cacheChapters')) return;
    final libChapters = chapters.map((c) => LibraryChapter(
      sourceId: sourceId,
      mangaUrl: mangaUrl,
      chapterUrl: c['url'] as String? ?? '',
      title: c['name'] as String? ?? '',
      dateUpload: c['dateUpload'] as String?,
      chapterNumber: (c['chapterNumber'] as num?)?.toDouble(),
    )).toList();
    await _vaultService.cacheChapters(sourceId, mangaUrl, libChapters);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  @override
  List<LibraryChapter> getCachedChapters(String sourceId, String mangaUrl) {
    return _vaultService.getCachedChapters(sourceId, mangaUrl);
  }

  @override
  Future<void> markChapterRead(
      String sourceId, String mangaUrl, String chapterUrl,
      {bool active = false}) async {
    if (!_ensureOpen('markChapterRead')) return;
    await _vaultService.markChapterRead(sourceId, mangaUrl, chapterUrl,
        active: active);
    notifyListeners();
  }

  @override
  Future<void> markChapterUnread(
      String sourceId, String mangaUrl, String chapterUrl) async {
    if (!_ensureOpen('markChapterUnread')) return;
    await _vaultService.markChapterUnread(sourceId, mangaUrl, chapterUrl);
    notifyListeners();
  }

  /// Bulk mark (mirrors LibraryProvider) - lets a vault migration replay read
  /// state into the VAULT box instead of the library's.
  Future<void> markChaptersRead(
      String sourceId, String mangaUrl, List<String> chapterUrls) async {
    if (!_ensureOpen('markChaptersRead')) return;
    if (chapterUrls.isEmpty) return;
    await _vaultService.markChaptersRead(sourceId, mangaUrl, chapterUrls);
    notifyListeners();
  }

  @override
  bool isChapterRead(String sourceId, String chapterUrl) {
    return _vaultService.isChapterRead(sourceId, chapterUrl);
  }

  @override
  Future<void> markAllRead(String sourceId, String url) async {
    if (!_ensureOpen('markAllRead')) return;
    await _vaultService.markAllChaptersRead(sourceId, url);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  @override
  Future<void> markAllUnread(String sourceId, String url) async {
    if (!_ensureOpen('markAllUnread')) return;
    await _vaultService.markAllChaptersUnread(sourceId, url);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  // ── Reading stats ──────────────────────────────────────────────────
  /// Ground-truth read-chapter count for a vault entry (chapter-box isRead
  /// tally), mirroring [LibraryProvider.readCountForManga] so vault stats use
  /// the same source of truth as the badge/streak/heatmap.
  int readCountForManga(LibraryManga m) =>
      _vaultService.readCount(m.sourceId, m.url);

  /// Chapters actively read in-app for a vault entry (mirrors
  /// [LibraryProvider.activeReadCountForManga]) - the gamified stats' source.
  int activeReadCountForManga(LibraryManga m) =>
      _vaultService.activeReadCount(m.sourceId, m.url);

  Map<DateTime, int> getReadActivityByDay({int days = 365, Set<String>? sourceIds}) =>
      _vaultService.getReadActivityByDay(days: days, sourceIds: sourceIds);

  int getCurrentReadingStreak({Set<String>? sourceIds}) =>
      _vaultService.getCurrentReadingStreak(sourceIds: sourceIds);
  int getLongestReadingStreak({Set<String>? sourceIds}) =>
      _vaultService.getLongestReadingStreak(sourceIds: sourceIds);
}
