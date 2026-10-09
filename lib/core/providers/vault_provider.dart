import 'package:flutter/foundation.dart' hide Category;
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import '../models/manga_model.dart';
import '../models/chapter_model.dart';
import '../models/category_model.dart';
import '../services/library_service.dart';
import '../services/secure_store.dart';
import '../services/vault_crypto.dart';

/// Arguments for the off-thread key derivation.
class _KdfRequest {
  final String password;
  final Uint8List salt;
  final int iterations;
  const _KdfRequest(this.password, this.salt, this.iterations);
}

/// PBKDF2 with 50k iterations takes ~1s in pure Dart, which would jank the UI
/// on the main isolate — so it runs via `compute`. Must be top-level.
Uint8List _deriveKeyIsolate(_KdfRequest r) =>
    VaultCrypto.deriveKey(r.password, r.salt, iterations: r.iterations);

class VaultProvider extends ChangeNotifier {
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

  List<LibraryManga> get manga => _manga;
  List<Category> get categories => _categories;
  bool get initialized => _initialized;

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
    // — the plaintext Hive files were readable by anything with filesystem
    // access. Now the boxes stay encrypted and closed until [unlock] supplies
    // the key derived from the password.
    if (!hasPassword) {
      await _vaultService.init();
      _manga = _vaultService.getAllManga();
      _categories = _vaultService.getCategories();
    }
    _initialized = true;
    notifyListeners();
  }

  // ── Password protection ─────────────────────────────────────
  bool get hasPassword =>
      (_settingsBox?.get('vault_verifier') as String?)?.isNotEmpty ?? false;

  /// True once [unlock] has succeeded — i.e. the encrypted boxes are open.
  bool get isUnlocked => !hasPassword || _vaultService.isOpen;

  Uint8List _saltOrNew() {
    final stored = _settingsBox?.get('vault_salt');
    if (stored is List && stored.isNotEmpty) {
      return Uint8List.fromList(stored.cast<int>());
    }
    return VaultCrypto.newSalt();
  }

  /// Derives the key, checks it against the stored verifier, and — only on
  /// success — opens the encrypted boxes and loads their contents.
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
    // cached chapter lists) BEFORE closing — vault_chapters is deleted below,
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
    if (hasPassword || _decoyActive) {
      await _vaultService.close();
      _manga = [];
      _categories = [];
    }
    // Always reset to the real vault (closed) so the next unlock starts clean.
    _decoyActive = false;
    _vaultService = LibraryService(prefix: 'vault');
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
    await _vaultService.addCategory(name);
    _categories = _vaultService.getCategories();
    notifyListeners();
  }

  Future<void> removeCategory(String name) async {
    await _vaultService.removeCategory(name);
    _categories = _vaultService.getCategories();
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> reorderCategories(List<String> orderedNames) async {
    await _vaultService.reorderCategories(orderedNames);
    _categories = _vaultService.getCategories();
    notifyListeners();
  }

  Future<void> renameCategory(String oldName, String newName) async {
    await _vaultService.renameCategory(oldName, newName);
    _categories = _vaultService.getCategories();
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> setMangaCategories(
      String sourceId, String url, List<String> cats) async {
    final manga = _vaultService.getManga(sourceId, url);
    if (manga != null) {
      manga.categories = cats;
      await _vaultService.updateManga(manga);
      _manga = _vaultService.getAllManga();
      notifyListeners();
    }
  }

  // ── Manga management ────────────────────────────────────────
  bool isInLibrary(String sourceId, String url) {
    return _vaultService.isInLibrary(sourceId, url);
  }

  Future<void> addToLibrary(LibraryManga manga) async {
    await _vaultService.addManga(manga);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Cache the source's browsable URL on this vault entry (instant cold-start
  /// "Open in WebView"). Quiet — no notify.
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
    await _vaultService.addEntryWithChapters(manga, chapters);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Bulk add — one reload + one notify for the whole batch (moving many titles
  /// otherwise reloaded the full list + rebuilt the UI per item = O(N*M)).
  Future<void> addEntriesWithChaptersBulk(
      List<(LibraryManga, List<LibraryChapter>)> entries) async {
    for (final (m, ch) in entries) {
      await _vaultService.addEntryWithChapters(m, ch);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  /// Bulk remove — one reload + one notify for the whole batch.
  Future<void> removeMangaBulk(List<(String, String)> keys) async {
    for (final (sid, url) in keys) {
      await _vaultService.removeManga(sid, url);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> markAllReadBulk(List<(String, String)> keys) async {
    for (final (sid, url) in keys) {
      await _vaultService.markAllChaptersRead(sid, url);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> markAllUnreadBulk(List<(String, String)> keys) async {
    for (final (sid, url) in keys) {
      await _vaultService.markAllChaptersUnread(sid, url);
    }
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> setMangaCategoriesBulk(
      List<(String, String, List<String>)> items) async {
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

  Future<void> updateReadingProgress(
      String sourceId, String mangaUrl, String chapterUrl, int page) async {
    // Persist only (fires per page turn; not shown live) — see the note on
    // LibraryProvider.updateReadingProgress.
    await _vaultService.updateReadingProgress(
        sourceId, mangaUrl, chapterUrl, page);
  }

  Future<void> cacheChapters(String sourceId, String mangaUrl, List<Map<String, dynamic>> chapters) async {
    final libChapters = chapters.map((c) => LibraryChapter(
      sourceId: sourceId,
      mangaUrl: mangaUrl,
      chapterUrl: c['url'] as String? ?? '',
      title: c['name'] as String? ?? '',
      dateUpload: c['dateUpload'] as String?,
    )).toList();
    await _vaultService.cacheChapters(sourceId, mangaUrl, libChapters);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  List<LibraryChapter> getCachedChapters(String sourceId, String mangaUrl) {
    return _vaultService.getCachedChapters(sourceId, mangaUrl);
  }

  Future<void> markChapterRead(
      String sourceId, String mangaUrl, String chapterUrl) async {
    await _vaultService.markChapterRead(sourceId, mangaUrl, chapterUrl);
    notifyListeners();
  }

  /// Bulk mark (mirrors LibraryProvider) — lets a vault migration replay read
  /// state into the VAULT box instead of the library's.
  Future<void> markChaptersRead(
      String sourceId, String mangaUrl, List<String> chapterUrls) async {
    if (chapterUrls.isEmpty) return;
    await _vaultService.markChaptersRead(sourceId, mangaUrl, chapterUrls);
    notifyListeners();
  }

  bool isChapterRead(String sourceId, String chapterUrl) {
    return _vaultService.isChapterRead(sourceId, chapterUrl);
  }

  Future<void> markAllRead(String sourceId, String url) async {
    await _vaultService.markAllChaptersRead(sourceId, url);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  Future<void> markAllUnread(String sourceId, String url) async {
    await _vaultService.markAllChaptersUnread(sourceId, url);
    _manga = _vaultService.getAllManga();
    notifyListeners();
  }

  // ── Reading stats ──────────────────────────────────────────────────
  Map<DateTime, int> getReadActivityByDay({int days = 365, Set<String>? sourceIds}) =>
      _vaultService.getReadActivityByDay(days: days, sourceIds: sourceIds);

  int getCurrentReadingStreak({Set<String>? sourceIds}) =>
      _vaultService.getCurrentReadingStreak(sourceIds: sourceIds);
  int getLongestReadingStreak({Set<String>? sourceIds}) =>
      _vaultService.getLongestReadingStreak(sourceIds: sourceIds);
}
