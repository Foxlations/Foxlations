import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/manga_model.dart';
import '../models/chapter_model.dart';
import '../models/category_model.dart';
import 'app_logger.dart';
import 'settings_store.dart';

/// A backup file on disk (native `.fox` — or legacy `.fxbackup` — or
/// Tachiyomi/Mihon `.tachibk`).
class BackupFile {
  final String path;
  final String name; // display, e.g. 20260720-23:12
  final DateTime date;
  final int sizeBytes;
  final bool isTachiyomi;
  final bool isAuto;
  const BackupFile(this.path, this.name, this.date, this.sizeBytes,
      this.isTachiyomi, this.isAuto);
}

enum BackupFrequency { off, daily, weekly, monthly }

/// The on-disk format a compatible backup is written in.
enum BackupFormat { tachibk, mangayomi, lnreader }

/// A reader app the user can export a compatible backup for. The export dialog
/// renders straight from [all] and only offers the content types the app
/// supports, so adding a new target app is a one-line change here (plus a
/// branch in [BackupService.createCompatBackup] if it needs a new format).
class BackupTarget {
  final String id;
  final String label;
  final BackupFormat format;
  final bool manga;
  final bool anime;
  final bool novel;
  const BackupTarget({
    required this.id,
    required this.label,
    required this.format,
    this.manga = true,
    this.anime = false,
    this.novel = false,
  });

  /// Add new target apps here.
  static const all = <BackupTarget>[
    BackupTarget(
        id: 'mihon',
        label: 'Mihon / Tachiyomi',
        format: BackupFormat.tachibk,
        manga: true),
    BackupTarget(
        id: 'aniyomi',
        label: 'Aniyomi',
        format: BackupFormat.tachibk,
        manga: true,
        anime: true),
    BackupTarget(
        id: 'tachimanga',
        label: 'Tachimanga',
        format: BackupFormat.tachibk,
        manga: true),
    BackupTarget(
        id: 'mangayomi',
        label: 'Mangayomi',
        format: BackupFormat.mangayomi,
        manga: true,
        anime: true,
        novel: true),
    BackupTarget(
        id: 'lnreader',
        label: 'LNReader',
        format: BackupFormat.lnreader,
        manga: false,
        novel: true),
  ];
}

/// Create/restore library backups — a native gzipped-JSON format, plus
/// read/write of the Tachiyomi/Mihon gzipped-protobuf `.tachibk` format for
/// cross-app migration. Also manages automatic scheduled backups.
class BackupService {
  static const _repoPrefsKey = 'extension_repo_urls';
  static const _freqKey = 'backup_frequency';
  static const _lastAutoKey = 'backup_last_auto';
  static const _maxAutoKept = 8;

  // ── boxes (already opened by the library/tracking services) ──
  Box<LibraryManga> get _mangaBox => Hive.box<LibraryManga>('library_manga');
  Box<LibraryChapter> get _chapterBox =>
      Hive.box<LibraryChapter>('library_chapters');
  Box<Category> get _categoryBox => Hive.box<Category>('library_categories');
  Box? get _trackingBox =>
      Hive.isBoxOpen('tracking') ? Hive.box('tracking') : null;

  Future<Directory> _backupDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/Foxlations/backups');
    await dir.create(recursive: true);
    return dir;
  }

  String _stamp(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}${two(d.month)}${two(d.day)}-${two(d.hour)}${two(d.minute)}';
  }

  String _displayName(String fileStamp) {
    // 20260720-2312 -> 20260720-23:12
    final m = RegExp(r'(\d{8})-(\d{2})(\d{2})').firstMatch(fileStamp);
    return m != null ? '${m.group(1)}-${m.group(2)}:${m.group(3)}' : fileStamp;
  }

  // ─────────────────────────── native format ───────────────────────────

  Map<String, dynamic> _mangaToMap(LibraryManga m) => {
        'sourceId': m.sourceId,
        'url': m.url,
        'title': m.title,
        'coverUrl': m.coverUrl,
        'author': m.author,
        'description': m.description,
        'genres': m.genres,
        'status': m.status,
        'addedAt': m.addedAt.millisecondsSinceEpoch,
        'lastReadAt': m.lastReadAt?.millisecondsSinceEpoch,
        'lastReadChapterUrl': m.lastReadChapterUrl,
        'lastReadPage': m.lastReadPage,
        'contentType': m.contentType,
        'lastWatchSeconds': m.lastWatchSeconds,
        'totalSeconds': m.totalSeconds,
        'novelProgressOffset': m.novelProgressOffset,
        'novelProgressFraction': m.novelProgressFraction,
        'totalChapters': m.totalChapters,
        'readChapters': m.readChapters,
        'categories': m.categories,
        'lastChapterFetchAt': m.lastChapterFetchAt?.millisecondsSinceEpoch,
      };

  LibraryManga _mangaFromMap(Map m) => LibraryManga(
        sourceId: (m['sourceId'] ?? '').toString(),
        url: (m['url'] ?? '').toString(),
        title: (m['title'] ?? '').toString(),
        coverUrl: (m['coverUrl'] ?? '').toString(),
        author: m['author'] as String?,
        description: m['description'] as String?,
        genres: (m['genres'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        status: (m['status'] ?? 'unknown').toString(),
        addedAt: DateTime.fromMillisecondsSinceEpoch(
            (m['addedAt'] as num?)?.toInt() ?? 0),
        lastReadAt: m['lastReadAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch((m['lastReadAt'] as num).toInt())
            : null,
        lastReadChapterUrl: m['lastReadChapterUrl'] as String?,
        lastReadPage: (m['lastReadPage'] as num?)?.toInt() ?? 0,
        contentType: m['contentType'] as String?,
        lastWatchSeconds: (m['lastWatchSeconds'] as num?)?.toInt() ?? 0,
        totalSeconds: (m['totalSeconds'] as num?)?.toInt() ?? 0,
        novelProgressOffset: (m['novelProgressOffset'] as num?)?.toInt() ?? 0,
        novelProgressFraction: (m['novelProgressFraction'] as num?)?.toDouble() ?? 0.0,
        totalChapters: (m['totalChapters'] as num?)?.toInt() ?? 0,
        readChapters: (m['readChapters'] as num?)?.toInt() ?? 0,
        categories:
            (m['categories'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        lastChapterFetchAt: m['lastChapterFetchAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (m['lastChapterFetchAt'] as num).toInt())
            : null,
      );

  Map<String, dynamic> _chapterToMap(LibraryChapter c) => {
        'sourceId': c.sourceId,
        'mangaUrl': c.mangaUrl,
        'chapterUrl': c.chapterUrl,
        'title': c.title,
        'chapterNumber': c.chapterNumber,
        'scanlator': c.scanlator,
        'dateUpload': c.dateUpload,
        'isRead': c.isRead,
        'lastPageRead': c.lastPageRead,
        'readAt': c.readAt?.millisecondsSinceEpoch,
        'sourceIndex': c.sourceIndex,
      };

  LibraryChapter _chapterFromMap(Map c) => LibraryChapter(
        sourceId: (c['sourceId'] ?? '').toString(),
        mangaUrl: (c['mangaUrl'] ?? '').toString(),
        chapterUrl: (c['chapterUrl'] ?? '').toString(),
        title: (c['title'] ?? '').toString(),
        chapterNumber: (c['chapterNumber'] as num?)?.toDouble(),
        scanlator: c['scanlator'] as String?,
        dateUpload: c['dateUpload'] as String?,
        isRead: c['isRead'] as bool? ?? false,
        lastPageRead: (c['lastPageRead'] as num?)?.toInt() ?? 0,
        readAt: c['readAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch((c['readAt'] as num).toInt())
            : null,
        sourceIndex: (c['sourceIndex'] as num?)?.toInt(),
      );

  /// Create a native backup. Returns the file path.
  Future<String> createBackup(
      {DateTime? now, bool auto = false, bool includeVault = false}) async {
    final ts = now ?? DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final tracking = <String, dynamic>{};
    final tb = _trackingBox;
    if (tb != null) {
      for (final k in tb.keys) {
        if (k is String && k.startsWith('bind_')) tracking[k] = tb.get(k);
      }
    }
    final mangaList = _mangaBox.values.map(_mangaToMap).toList();
    final chapterList = _chapterBox.values.map(_chapterToMap).toList();
    final categoryList = _categoryBox.values
        .map((c) => {'name': c.name, 'order': c.order})
        .toList();

    // Include the vault's contents WHEN it's unlocked (its boxes are open),
    // represented as NORMAL library entries whose categories are namespaced
    // "Vault-<category>" (or plain "Vault" when uncategorised). This keeps vault
    // titles in the backup — portable to other apps — without a special format;
    // they just land under Vault- categories on import. Locked vaults are skipped.
    if (includeVault && Hive.isBoxOpen('vault_manga')) {
      final vMangaBox = Hive.box<LibraryManga>('vault_manga');
      final seen = <String>{};
      for (final m in vMangaBox.values) {
        final map = _mangaToMap(m);
        map['categories'] =
            m.categories.isEmpty ? ['Vault'] : m.categories.map((c) => 'Vault-$c').toList();
        mangaList.add(map);
        for (final c in (map['categories'] as List)) {
          seen.add(c.toString());
        }
      }
      if (Hive.isBoxOpen('vault_chapters')) {
        chapterList.addAll(
            Hive.box<LibraryChapter>('vault_chapters').values.map(_chapterToMap));
      }
      // Declare the namespaced categories (ordered after the normal ones).
      var order = 1000;
      for (final name in seen) {
        categoryList.add({'name': name, 'order': order++});
      }
    }

    final data = {
      'format': 'foxlations-native',
      'version': 1,
      'createdAt': ts.millisecondsSinceEpoch,
      'manga': mangaList,
      'chapters': chapterList,
      'categories': categoryList,
      'repos': prefs.getStringList(_repoPrefsKey) ?? const [],
      'tracking': tracking,
    };
    final gz = GZipEncoder().encode(utf8.encode(jsonEncode(data)));
    final dir = await _backupDir();
    final file = File(
        '${dir.path}/foxlations-${_stamp(ts)}${auto ? '-auto' : ''}.fox');
    await file.writeAsBytes(gz);
    return file.path;
  }

  /// Peek a .fox backup: does it carry vault titles (any "Vault"/"Vault-"
  /// category)? Used to prompt a vault unlock before import so those titles land
  /// in the vault instead of being skipped. Best-effort; false on any error.
  Future<bool> backupHasVault(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final json = utf8.decode(GZipDecoder().decodeBytes(bytes));
      final data = jsonDecode(json) as Map<String, dynamic>;
      bool vaultName(String n) => n == 'Vault' || n.startsWith('Vault-');
      for (final c in (data['categories'] as List? ?? const [])) {
        if (vaultName(((c as Map)['name'] ?? '').toString())) {
          return true;
        }
      }
      for (final m in (data['manga'] as List? ?? const [])) {
        final cats = ((m as Map)['categories'] as List? ?? const [])
            .map((e) => e.toString());
        if (cats.any(vaultName)) return true;
      }
    } catch (_) {}
    return false;
  }

  /// Restore a native backup (merges into the current library).
  Future<void> restoreBackup(String path) async {
    final bytes = await File(path).readAsBytes();
    final json = utf8.decode(GZipDecoder().decodeBytes(bytes));
    final data = jsonDecode(json) as Map<String, dynamic>;

    // Vault titles are packed in the backup as library entries under
    // "Vault-<cat>"/"Vault" categories (see createBackup). On restore they must
    // go BACK into the vault, NEVER the public library. Route them to the vault
    // boxes when the vault is unlocked; SKIP them entirely when it's locked, so
    // importing a backup can never surface vault content in public.
    final vMangaBox = Hive.isBoxOpen('vault_manga')
        ? Hive.box<LibraryManga>('vault_manga')
        : null;
    final vChapterBox = Hive.isBoxOpen('vault_chapters')
        ? Hive.box<LibraryChapter>('vault_chapters')
        : null;
    final vCategoryBox = Hive.isBoxOpen('vault_categories')
        ? Hive.box<Category>('vault_categories')
        : null;
    bool isVaultCats(List<String> cats) =>
        cats.any((c) => c == 'Vault' || c.startsWith('Vault-'));
    List<String> stripVault(List<String> cats) => cats
        .where((c) => c != 'Vault')
        .map((c) => c.startsWith('Vault-') ? c.substring(6) : c)
        .toList();

    final vaultKeys = <String>{}; // manga keys routed into the vault
    for (final m in (data['manga'] as List? ?? const [])) {
      final manga = _mangaFromMap(m as Map);
      if (isVaultCats(manga.categories)) {
        if (vMangaBox != null) {
          vaultKeys.add(manga.uniqueKey);
          manga.categories = stripVault(manga.categories);
          await vMangaBox.put(manga.uniqueKey, manga);
        }
        // locked → skip; vault content never lands in the public library
      } else {
        await _mangaBox.put(manga.uniqueKey, manga);
      }
    }
    for (final c in (data['chapters'] as List? ?? const [])) {
      final ch = _chapterFromMap(c as Map);
      if (vaultKeys.contains('${ch.sourceId}_${ch.mangaUrl}')) {
        if (vChapterBox != null) await vChapterBox.put(ch.uniqueKey, ch);
      } else {
        await _chapterBox.put(ch.uniqueKey, ch);
      }
    }
    final existingCats = _categoryBox.values.map((c) => c.name).toSet();
    final existingVaultCats =
        vCategoryBox?.values.map((c) => c.name).toSet() ?? <String>{};
    for (final c in (data['categories'] as List? ?? const [])) {
      final name = (c as Map)['name']?.toString() ?? '';
      if (name.isEmpty) continue;
      final order = (c['order'] as num?)?.toInt() ?? 0;
      if (name == 'Vault' || name.startsWith('Vault-')) {
        // Vault category → the vault's own category box (stripped), if unlocked;
        // never the public library.
        final stripped = name == 'Vault' ? '' : name.substring(6);
        if (vCategoryBox != null &&
            stripped.isNotEmpty &&
            !existingVaultCats.contains(stripped)) {
          await vCategoryBox.add(Category(name: stripped, order: order));
          existingVaultCats.add(stripped);
        }
        continue;
      }
      if (!existingCats.contains(name)) {
        await _categoryBox.add(Category(name: name, order: order));
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final repos = (prefs.getStringList(_repoPrefsKey) ?? []).toSet();
    for (final r in (data['repos'] as List? ?? const [])) {
      repos.add(r.toString());
    }
    await prefs.setStringList(_repoPrefsKey, repos.toList());
    final tb = _trackingBox;
    if (tb != null) {
      final tr = data['tracking'] as Map?;
      if (tr != null) {
        for (final entry in tr.entries) {
          await tb.put(entry.key, entry.value);
        }
      }
    }
  }

  // ───────────────────── Tachiyomi / Mihon (.tachibk) ─────────────────────

  int _sourceIdHash(String s) {
    // Stable positive 63-bit hash of a Foxlations source id, used as the
    // Tachiyomi int64 `source`. Won't match a foreign app's extension ids, but
    // preserves the data and round-trips within Foxlations (via backupSources).
    var h = 1125899906842597; // prime
    for (final c in s.codeUnits) {
      h = (31 * h + c) & 0x7FFFFFFFFFFFFFFF;
    }
    return h;
  }

  /// Export the library to a Tachiyomi/Mihon-compatible `.tachibk`.
  ///
  /// Most Tachiyomi/Mihon forks are manga-only, so manga always exports; anime
  /// and light novels are opt-in ([includeAnime]/[includeNovels]) and carried as
  /// ordinary entries so any fork imports them.
  Future<String> createTachiyomiBackup(
      {DateTime? now,
      bool includeManga = true,
      bool includeAnime = false,
      bool includeNovels = false,
      bool includeVault = false}) async {
    bool included(LibraryManga m) {
      final t = m.contentType ?? 'manga';
      if (t == 'anime') return includeAnime;
      if (t == 'novel') return includeNovels;
      return includeManga; // manga (and anything untyped)
    }

    final ts = now ?? DateTime.now();
    String typeOf(LibraryManga m) {
      final t = m.contentType ?? 'manga';
      return (t == 'anime' || t == 'novel') ? t : 'manga';
    }

    // Vault contents (when unlocked) ride along under namespaced "Vault-<cat>"
    // (or plain "Vault") categories, so another app sees them as ordinary titles.
    final hasVault = includeVault && Hive.isBoxOpen('vault_manga');
    final vaultMangas = hasVault
        ? Hive.box<LibraryManga>('vault_manga').values.toList()
        : const <LibraryManga>[];
    List<String> catsFor(LibraryManga m, bool vault) => vault
        ? (m.categories.isEmpty
            ? ['Vault']
            : m.categories.map((c) => 'Vault-$c').toList())
        : m.categories;

    // Collect the entries to export, split by side so types are preserved:
    // manga + novels go in backupManga (field 1), anime in backupAnime (field 3).
    // Each side keeps its own category index + source list (the Aniyomi layout).
    final base = _categoryBox.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final mangaCatNames = <String>[for (final c in base) c.name];
    final animeCatNames = <String>[];
    void ensureCat(List<String> names, String n) {
      if (!names.contains(n)) names.add(n);
    }

    final entries =
        <({LibraryManga m, bool vault, List<String> cats, String type})>[];
    void addEntry(LibraryManga m, bool vault) {
      if (!included(m)) return;
      final type = typeOf(m);
      final cats = catsFor(m, vault);
      entries.add((m: m, vault: vault, cats: cats, type: type));
      for (final c in cats) {
        ensureCat(type == 'anime' ? animeCatNames : mangaCatNames, c);
      }
    }

    for (final m in _mangaBox.values) {
      addEntry(m, false);
    }
    if (hasVault) {
      for (final m in vaultMangas) {
        addEntry(m, true);
      }
    }

    final mangaCatOrder = {
      for (var i = 0; i < mangaCatNames.length; i++) mangaCatNames[i]: i
    };
    final animeCatOrder = {
      for (var i = 0; i < animeCatNames.length; i++) animeCatNames[i]: i
    };
    final sources = <String, int>{}; // manga/novel sourceId -> hash (field 101)
    final animeSources = <String, int>{}; // anime sourceId -> hash (field 103)
    final root = _ProtoWriter();

    final vch = hasVault && Hive.isBoxOpen('vault_chapters')
        ? Hive.box<LibraryChapter>('vault_chapters').values
        : const <LibraryChapter>[];
    Iterable<LibraryChapter> chaptersFor(LibraryManga m, bool vault) =>
        (vault ? vch : _chapterBox.values)
            .where((c) => c.sourceId == m.sourceId && c.mangaUrl == m.url);

    void writeEntry(LibraryManga m, List<String> catRefs,
        Iterable<LibraryChapter> chapters, String type) {
      final isAnime = type == 'anime';
      final srcMap = isAnime ? animeSources : sources;
      final catOrder = isAnime ? animeCatOrder : mangaCatOrder;
      srcMap[m.sourceId] = _sourceIdHash(m.sourceId);
      final bm = _ProtoWriter();
      bm.varint(1, srcMap[m.sourceId]!);
      bm.string(2, m.url);
      bm.string(3, m.title);
      if (m.author != null) bm.string(5, m.author!);
      if (m.description != null) bm.string(6, m.description!);
      for (final g in m.genres) bm.string(7, g);
      bm.varint(8, _statusToTachi(m.status));
      bm.string(9, m.coverUrl);
      bm.varint(13, m.addedAt.millisecondsSinceEpoch);
      for (final c in chapters) {
        final bc = _ProtoWriter();
        bc.string(1, c.chapterUrl);
        bc.string(2, c.title);
        if (c.scanlator != null) bc.string(3, c.scanlator!);
        bc.boolean(4, c.isRead);
        bc.varint(6, c.lastPageRead);
        if (c.chapterNumber != null) bc.floatUnconditional(9, c.chapterNumber!);
        if (c.sourceIndex != null) bc.varintUnconditional(10, c.sourceIndex!);
        bm.message(16, bc.toBytes());
      }
      // categories (by order index — index 0 is valid, so write unconditionally)
      for (final cat in catRefs) {
        final idx = catOrder[cat];
        if (idx != null) bm.varintUnconditional(17, idx);
      }
      bm.boolean(100, true); // favorite
      // Foxlations round-trip: anime already rides backupAnime (field 3); novels
      // ride backupManga, so stamp the type in a high custom field other apps
      // skip, and our importer reads it back to restore 'novel' typing.
      if (type == 'novel') bm.string(500, 'novel');
      root.message(isAnime ? 3 : 1, bm.toBytes());
    }

    for (final e in entries) {
      writeEntry(e.m, e.cats, chaptersFor(e.m, e.vault), e.type);
    }

    // categories: manga/novel -> field 2, anime -> field 4.
    for (var i = 0; i < mangaCatNames.length; i++) {
      final bc = _ProtoWriter();
      bc.string(1, mangaCatNames[i]);
      bc.varint(2, i);
      root.message(2, bc.toBytes());
    }
    for (var i = 0; i < animeCatNames.length; i++) {
      final bc = _ProtoWriter();
      bc.string(1, animeCatNames[i]);
      bc.varint(2, i);
      root.message(4, bc.toBytes());
    }
    // sources (name = foxlations sourceId, so our own restores recover it):
    // manga/novel -> field 101, anime -> field 103.
    // BackupSource = { name = field 1 (string), sourceId = field 2 (int64) } —
    // the order Mihon/Tachiyomi/Aniyomi/Tachimanga all use. Writing sourceId
    // first is a wire-type mismatch that makes their decoder reject the whole
    // file. (Our own importer keys on wire type, so round-trips are unaffected.)
    for (final e in sources.entries) {
      final bs = _ProtoWriter();
      bs.string(1, e.key);
      bs.varint(2, e.value);
      root.message(101, bs.toBytes());
    }
    for (final e in animeSources.entries) {
      final bs = _ProtoWriter();
      bs.string(1, e.key);
      bs.varint(2, e.value);
      root.message(103, bs.toBytes());
    }

    final gz = GZipEncoder().encode(root.toBytes());
    final dir = await _backupDir();
    final file = File('${dir.path}/foxlations-${_stamp(ts)}.tachibk');
    await file.writeAsBytes(gz);
    return file.path;
  }

  /// Foxlations status string → Mangayomi `Status` enum index
  /// (0 ongoing, 1 completed, 2 canceled, 3 unknown, 4 onHiatus).
  int _statusToMangayomi(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return 0;
      case 'completed':
        return 1;
      case 'canceled':
      case 'cancelled':
        return 2;
      case 'hiatus':
      case 'onhiatus':
        return 4;
      default:
        return 3;
    }
  }

  /// Export to a Mangayomi-compatible `*.backup` — a ZIP wrapping a single
  /// `*.backup.db` JSON of { version, manga[], chapters[], categories[],
  /// extensions[] }. Mangayomi handles manga, anime AND light novels in one file
  /// (`itemType` 0/1/2), so this is also our anime-only / novel-only path. The
  /// schema mirrors what [_restoreMangayomiJson] reads.
  Future<String> createMangayomiBackup(
      {DateTime? now,
      bool includeManga = true,
      bool includeAnime = true,
      bool includeNovels = true,
      bool includeVault = false}) async {
    final ts = now ?? DateTime.now();
    int itemTypeOf(LibraryManga m) {
      switch (m.contentType ?? 'manga') {
        case 'anime':
          return 1;
        case 'novel':
          return 2;
        default:
          return 0;
      }
    }

    bool included(LibraryManga m) {
      switch (itemTypeOf(m)) {
        case 1:
          return includeAnime;
        case 2:
          return includeNovels;
        default:
          return includeManga;
      }
    }

    // Categories → sequential ids (Mangayomi keys manga.categories by int id).
    final catId = <String, int>{};
    final categoriesJson = <Map<String, dynamic>>[];
    int categoryIdFor(String name, int forItemType) =>
        catId.putIfAbsent(name, () {
          final id = categoriesJson.length + 1;
          categoriesJson
              .add({'id': id, 'name': name, 'forItemType': forItemType});
          return id;
        });
    for (final c in (_categoryBox.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order)))) {
      categoryIdFor(c.name, 0);
    }

    // Sources (extensions) → sequential ids keyed by foxlations sourceId, so our
    // own restore recovers the source by name.
    final srcId = <String, int>{};
    final extensionsJson = <Map<String, dynamic>>[];
    int sourceIdFor(LibraryManga m) => srcId.putIfAbsent(m.sourceId, () {
          final id = srcId.length + 1;
          extensionsJson
              .add({'id': id, 'name': m.sourceId, 'itemType': itemTypeOf(m)});
          return id;
        });

    final mangaJson = <Map<String, dynamic>>[];
    final chaptersJson = <Map<String, dynamic>>[];
    var nextMangaId = 1;
    var nextChapterId = 1;

    void writeManga(LibraryManga m, List<String> catRefs,
        Iterable<LibraryChapter> chapters) {
      final type = itemTypeOf(m);
      final mid = nextMangaId++;
      final sid = sourceIdFor(m);
      final catIds = [for (final n in catRefs) categoryIdFor(n, type)];
      mangaJson.add({
        'id': mid,
        'source': m.sourceId,
        'sourceId': sid,
        'name': m.title,
        'link': m.url,
        'imageUrl': m.coverUrl,
        'author': m.author ?? '',
        'description': m.description ?? '',
        'genre': m.genres,
        'status': _statusToMangayomi(m.status),
        'itemType': type,
        'dateAdded': m.addedAt.millisecondsSinceEpoch,
        'categories': catIds,
        'favorite': true,
        'isLocalArchive': false,
        'lang': 'en',
      });
      for (final c in chapters) {
        chaptersJson.add({
          'id': nextChapterId++,
          'mangaId': mid,
          'name': c.title,
          'url': c.chapterUrl,
          'scanlator': c.scanlator ?? '',
          'dateUpload': c.dateUpload ?? '',
          'isRead': c.isRead,
          'lastPageRead': c.lastPageRead.toString(),
        });
      }
    }

    for (final m in _mangaBox.values) {
      if (!included(m)) continue;
      writeManga(
          m,
          m.categories,
          _chapterBox.values
              .where((c) => c.sourceId == m.sourceId && c.mangaUrl == m.url));
    }
    // Vault entries (opt-in, when unlocked) under "Vault-<cat>" / "Vault" categories.
    if (includeVault && Hive.isBoxOpen('vault_manga')) {
      final vaultMangas = Hive.box<LibraryManga>('vault_manga').values;
      final vch = Hive.isBoxOpen('vault_chapters')
          ? Hive.box<LibraryChapter>('vault_chapters').values
          : const <LibraryChapter>[];
      for (final m in vaultMangas) {
        if (!included(m)) continue;
        final cats = m.categories.isEmpty
            ? ['Vault']
            : m.categories.map((c) => 'Vault-$c').toList();
        writeManga(m, cats,
            vch.where((c) => c.sourceId == m.sourceId && c.mangaUrl == m.url));
      }
    }

    final data = {
      'version': '1.0',
      'manga': mangaJson,
      'chapters': chaptersJson,
      'categories': categoriesJson,
      'extensions': extensionsJson,
    };
    final dbBytes = utf8.encode(jsonEncode(data));
    final dbName = 'foxlations-${_stamp(ts)}.backup.db';
    final archive = Archive()
      ..addFile(ArchiveFile(dbName, dbBytes.length, dbBytes));
    final zip = ZipEncoder().encode(archive);
    final dir = await _backupDir();
    final file = File('${dir.path}/foxlations-${_stamp(ts)}.backup');
    await file.writeAsBytes(zip);
    return file.path;
  }

  /// Foxlations status → LNReader NovelStatus string.
  String _statusToLnreader(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return 'Ongoing';
      case 'completed':
        return 'Completed';
      case 'hiatus':
      case 'onhiatus':
        return 'Hiatus';
      case 'canceled':
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  /// Export an LNReader-importable backup: a ZIP (entries at root) with a
  /// `Version.json` manifest (formatVersion 2 + sections), one
  /// `NovelAndChapters/<n>.json` per novel (flat novel object + `chapters`), and
  /// a `Category.json`. LNReader is light-novels only and resolves a novel's
  /// source by (pluginId, path) — our novel lane runs LNReader's own plugins, so
  /// pluginId = our sourceId and path = the novel url line up.
  Future<String> createLnreaderBackup(
      {DateTime? now, bool includeVault = false}) async {
    final ts = now ?? DateTime.now();
    bool isNovel(LibraryManga m) => (m.contentType ?? 'manga') == 'novel';

    final novels = <({LibraryManga m, bool vault})>[
      for (final m in _mangaBox.values)
        if (isNovel(m)) (m: m, vault: false),
    ];
    if (includeVault && Hive.isBoxOpen('vault_manga')) {
      for (final m in Hive.box<LibraryManga>('vault_manga').values) {
        if (isNovel(m)) novels.add((m: m, vault: true));
      }
    }
    final vch = Hive.isBoxOpen('vault_chapters')
        ? Hive.box<LibraryChapter>('vault_chapters').values
        : const <LibraryChapter>[];

    final archive = Archive();
    void addJson(String name, Object data) {
      final bytes = utf8.encode(jsonEncode(data));
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    // REQUIRED manifest: formatVersion 2 + sections, or LNReader falls back to
    // the legacy path and demands a download.zip we don't ship.
    addJson('Version.json', {
      'appVersion': 'Foxlations',
      'formatVersion': 2,
      'sections': {
        'library': true,
        'settings': false,
        'plugins': false,
        'downloadedFiles': false,
      },
    });

    final catNovelIds = <String, List<int>>{};
    var nextId = 1;
    for (final e in novels) {
      final m = e.m;
      final id = nextId++;
      final chapters = (e.vault ? vch : _chapterBox.values)
          .where((c) => c.sourceId == m.sourceId && c.mangaUrl == m.url);
      final cover = m.coverUrl;
      addJson('NovelAndChapters/$id.json', {
        'id': id,
        'path': m.url,
        'pluginId': m.sourceId,
        'name': m.title,
        // http(s) covers are kept as remote URLs; anything else LNReader expects
        // as a stored file under Covers/ (which we don't ship), so blank it.
        'cover': cover.startsWith('http') ? cover : '',
        'summary': m.description ?? '',
        'author': m.author ?? '',
        'genres': m.genres.join(', '), // LNReader stores genres as one string
        'status': _statusToLnreader(m.status),
        'inLibrary': true,
        'isLocal': false,
        'chapters': [
          for (final c in chapters)
            {
              'path': c.chapterUrl,
              'name': c.title,
              'unread': !c.isRead,
              'bookmark': false,
              'page': c.lastPageRead.toString(),
              'position': 0,
              if (c.chapterNumber != null) 'chapterNumber': c.chapterNumber,
              'scanlator': c.scanlator ?? '',
              'releaseTime': c.dateUpload ?? '',
            }
        ],
      });
      final cats = e.vault
          ? (m.categories.isEmpty
              ? ['Vault']
              : m.categories.map((c) => 'Vault-$c').toList())
          : m.categories;
      for (final cn in cats) {
        (catNovelIds[cn] ??= []).add(id);
      }
    }

    if (catNovelIds.isNotEmpty) {
      var sort = 0;
      final cats = <Map<String, dynamic>>[];
      for (final e in catNovelIds.entries) {
        sort++;
        // Skip ids 1 (Default) and 2 (Local) which LNReader reserves; it matches
        // our categories back by name anyway.
        cats.add(
            {'id': sort + 2, 'name': e.key, 'sort': sort, 'novelIds': e.value});
      }
      addJson('Category.json', cats);
    }

    final zip = ZipEncoder().encode(archive);
    final dir = await _backupDir();
    final file = File('${dir.path}/foxlations-${_stamp(ts)}-lnreader.zip');
    await file.writeAsBytes(zip);
    return file.path;
  }

  /// Export a backup made compatible with [target]: the right format, and only
  /// the content types that app supports (further narrowed by the include flags
  /// the user chose in the export dialog).
  Future<String> createCompatBackup({
    required BackupTarget target,
    DateTime? now,
    bool includeManga = true,
    bool includeAnime = true,
    bool includeNovels = true,
    bool includeVault = false,
  }) {
    final m = includeManga && target.manga;
    final a = includeAnime && target.anime;
    final n = includeNovels && target.novel;
    switch (target.format) {
      case BackupFormat.tachibk:
        return createTachiyomiBackup(
            now: now,
            includeManga: m,
            includeAnime: a,
            includeNovels: n,
            includeVault: includeVault);
      case BackupFormat.mangayomi:
        return createMangayomiBackup(
            now: now,
            includeManga: m,
            includeAnime: a,
            includeNovels: n,
            includeVault: includeVault);
      case BackupFormat.lnreader:
        return createLnreaderBackup(
            now: now, includeVault: includeVault); // novels only by nature
    }
  }

  /// Restore from a Tachiyomi/Mihon `.tachibk`. Matches each manga's source to
  /// an installed Foxlations source by the backup's source name when possible.
  /// Returns how many manga were imported.
  // ───────────────────────── Mangayomi (.backup) ─────────────────────────
  // Mangayomi (kodjodevf) exports a ZIP named *.backup whose single entry is a
  // *.backup.db file: JSON of { version, manga[], chapters[], categories[],
  // extensions[](sources), ... } where each is a model .toJson(). It covers
  // manga, anime AND novels in one file. Matching to installed sources is by
  // source NAME (manga.source), the same as the Tachiyomi path, so unresolved
  // entries re-link once their source is installed (see relinkSources).

  /// Returns the decoded Mangayomi `*.backup.db` JSON if [bytes] is a Mangayomi
  /// ZIP, else null (so a .tmb/Tachimanga ZIP falls through to the proto path).
  String? _extractMangayomiJson(Uint8List bytes) {
    if (bytes.length < 4 || bytes[0] != 0x50 || bytes[1] != 0x4B) {
      return null; // not a ZIP
    }
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      return null; // encrypted or unreadable ZIP — let the caller's path error
    }
    final db = archive.files.cast<ArchiveFile?>().firstWhere(
          (f) => f!.isFile && f.name.toLowerCase().endsWith('.backup.db'),
          orElse: () => null,
        );
    if (db == null) return null; // a ZIP, but not Mangayomi's
    try {
      return utf8.decode(db.content as List<int>);
    } catch (_) {
      return null;
    }
  }

  String? _nullIfEmpty(dynamic v) {
    final s = v?.toString() ?? '';
    return s.isEmpty ? null : s;
  }

  DateTime _msToDate(dynamic v) =>
      v is int && v > 0 ? DateTime.fromMillisecondsSinceEpoch(v) : DateTime.now();

  /// Mangayomi `Status` enum → Foxlations status string.
  /// (enum order: ongoing, completed, canceled, unknown, onHiatus,
  /// publishingFinished).
  String _statusFromMangayomi(dynamic v) {
    switch (v is int ? v : 3) {
      case 0:
        return 'ongoing';
      case 1:
        return 'completed';
      case 2:
        return 'canceled';
      case 4:
        return 'hiatus';
      case 5:
        return 'completed'; // publishingFinished
      default:
        return 'unknown';
    }
  }

  /// Mangayomi `ItemType` (0 manga / 1 anime / 2 novel) → Foxlations contentType.
  String _itemTypeToContentType(dynamic v) {
    switch (v is int ? v : 0) {
      case 1:
        return 'anime';
      case 2:
        return 'novel';
      default:
        return 'manga';
    }
  }

  Future<int> _restoreMangayomiJson(
      String jsonStr, Map<String, String> installedSources) async {
    final root = jsonDecode(jsonStr);
    if (root is! Map) {
      throw const FormatException('Unrecognised Mangayomi backup.');
    }
    final mangaList = (root['manga'] as List?) ?? const [];
    final chapterList = (root['chapters'] as List?) ?? const [];
    final categoryList = (root['categories'] as List?) ?? const [];
    final extList = (root['extensions'] as List?) ?? const []; // sources

    // Mangayomi category id -> name (for mapping manga.categories int ids).
    final catById = <int, String>{};
    for (final c in categoryList.whereType<Map>()) {
      final id = c['id'];
      final name = (c['name'] ?? '').toString();
      if (id is int && name.isNotEmpty) catById[id] = name;
    }
    // Source id -> name, a fallback when a manga's `source` name is blank.
    final srcById = <int, String>{};
    for (final s in extList.whereType<Map>()) {
      final id = s['id'];
      final name = (s['name'] ?? '').toString();
      if (id is int && name.isNotEmpty) srcById[id] = name;
    }
    // Chapters grouped by their owning manga's id.
    final chaptersByManga = <int, List<Map>>{};
    for (final c in chapterList.whereType<Map>()) {
      final mid = c['mangaId'];
      if (mid is int) (chaptersByManga[mid] ??= []).add(c);
    }

    // Create any categories we don't already have.
    final existingCats = _categoryBox.values.map((e) => e.name).toSet();
    for (final name in catById.values) {
      if (!existingCats.contains(name)) {
        await _categoryBox.add(Category(name: name, order: _categoryBox.length));
        existingCats.add(name);
      }
    }

    var imported = 0;
    for (final m in mangaList.whereType<Map>()) {
      if (m['isLocalArchive'] == true) continue; // can't import local archives
      final link = (m['link'] ?? '').toString();
      final title = (m['name'] ?? '').toString();
      if (link.isEmpty || title.isEmpty) continue;

      var sourceName = (m['source'] ?? '').toString();
      if (sourceName.isEmpty) {
        final sid = m['sourceId'];
        if (sid is int) sourceName = srcById[sid] ?? '';
      }
      final sourceId = resolveBackupSourceId(sourceName, installedSources);

      final cats = <String>[];
      final rawCats = m['categories'];
      if (rawCats is List) {
        for (final ci in rawCats) {
          if (ci is int && catById.containsKey(ci)) cats.add(catById[ci]!);
        }
      }
      final genres =
          (m['genre'] as List?)?.map((e) => e.toString()).toList() ??
              const <String>[];
      final mid = m['id'];
      final chs = (mid is int ? chaptersByManga[mid] : null) ?? const <Map>[];

      final manga = LibraryManga(
        sourceId: sourceId,
        url: link,
        title: title,
        coverUrl: (m['imageUrl'] ?? '').toString(),
        author: _nullIfEmpty(m['author']),
        description: _nullIfEmpty(m['description']),
        genres: genres,
        status: _statusFromMangayomi(m['status']),
        addedAt: _msToDate(m['dateAdded']),
        categories: cats,
        contentType: _itemTypeToContentType(m['itemType']),
        totalChapters: chs.length,
        readChapters: chs.where((c) => c['isRead'] == true).length,
      );
      await _mangaBox.put(manga.uniqueKey, manga);

      for (final c in chs) {
        final cUrl = (c['url'] ?? '').toString();
        if (cUrl.isEmpty) continue;
        final ch = LibraryChapter(
          sourceId: sourceId,
          mangaUrl: link,
          chapterUrl: cUrl,
          title: (c['name'] ?? '').toString(),
          scanlator: _nullIfEmpty(c['scanlator']),
          dateUpload: _nullIfEmpty(c['dateUpload']),
          isRead: c['isRead'] == true,
          lastPageRead:
              int.tryParse((c['lastPageRead'] ?? '').toString()) ?? 0,
        );
        await _chapterBox.put(ch.uniqueKey, ch);
      }
      imported++;
    }
    return imported;
  }

  Future<int> restoreTachiyomiBackup(String path,
      {Map<String, String> installedSources = const {}}) async {
    final bytes = await File(path).readAsBytes();
    // Mangayomi backups are a ZIP wrapping a *.backup.db JSON (manga/anime/
    // novel in one file) — detect and route to the JSON importer before the
    // protobuf path, which only understands Tachiyomi/Mihon/Aniyomi.
    final mangayomiJson = _extractMangayomiJson(bytes);
    if (mangayomiJson != null) {
      return _restoreMangayomiJson(mangayomiJson, installedSources);
    }
    final data = unwrapBackupBytes(bytes);
    final r = _ProtoReader(data);

    final sourceNames = <int, String>{}; // manga source int64 -> name
    final animeSourceNames = <int, String>{}; // Aniyomi anime source int64 -> name
    final mangaMsgs = <Uint8List>[];
    final animeMsgs = <Uint8List>[]; // Aniyomi backupAnime messages
    final categoryNames = <int, String>{};
    final animeCatNames = <int, String>{};

    while (r.hasMore) {
      final t = r.readTag();
      switch (t.field) {
        case 1: // backupManga
          mangaMsgs.add(r.readBytes());
          break;
        case 2: // backupCategory
          final cr = _ProtoReader(r.readBytes());
          String name = '';
          int order = 0;
          while (cr.hasMore) {
            final ct = cr.readTag();
            if (ct.field == 1 && ct.wire == 2) {
              name = cr.readStringValue();
            } else if (ct.field == 2 && ct.wire == 0) {
              order = cr.readVarint();
            } else {
              cr.skip(ct.wire);
            }
          }
          if (name.isNotEmpty) categoryNames[order] = name;
          break;
        case 3: // backupAnime (Aniyomi)
          animeMsgs.add(r.readBytes());
          break;
        case 4: // backupAnimeCategory (Aniyomi)
          final cr = _ProtoReader(r.readBytes());
          String name = '';
          int order = 0;
          while (cr.hasMore) {
            final ct = cr.readTag();
            if (ct.field == 1 && ct.wire == 2) {
              name = cr.readStringValue();
            } else if (ct.field == 2 && ct.wire == 0) {
              order = cr.readVarint();
            } else {
              cr.skip(ct.wire);
            }
          }
          if (name.isNotEmpty) animeCatNames[order] = name;
          break;
        case 101: // backupSource
          // The standard order (Mihon/Tachiyomi/Aniyomi/Tachimanga) is
          // { name = field 1 (string), sourceId = field 2 (int64) }. We still
          // match on the WIRE TYPE rather than the field number so an app that
          // ever emits them swapped also parses — the varint is the id, the
          // string is the name.
          final sr = _ProtoReader(r.readBytes());
          int id = 0;
          String name = '';
          while (sr.hasMore) {
            final st = sr.readTag();
            if (st.wire == 0) {
              id = sr.readVarint();
            } else if (st.wire == 2) {
              name = sr.readStringValue();
            } else {
              sr.skip(st.wire);
            }
          }
          sourceNames[id] = name;
          break;
        case 103: // backupAnimeSource (Aniyomi)
          // Same wire-type-based parse as backupSource above, so field order
          // never matters.
          final sr = _ProtoReader(r.readBytes());
          int id = 0;
          String name = '';
          while (sr.hasMore) {
            final st = sr.readTag();
            if (st.wire == 0) {
              id = sr.readVarint();
            } else if (st.wire == 2) {
              name = sr.readStringValue();
            } else {
              sr.skip(st.wire);
            }
          }
          animeSourceNames[id] = name;
          break;
        default:
          r.skip(t.wire);
      }
    }

    // Restore categories.
    final existingCats = _categoryBox.values.map((c) => c.name).toSet();
    for (final e in categoryNames.entries) {
      if (!existingCats.contains(e.value)) {
        await _categoryBox.add(Category(name: e.value, order: e.key));
      }
    }
    final orderToCat = categoryNames;

    var imported = 0;
    for (final mm in mangaMsgs) {
      final mr = _ProtoReader(mm);
      int source = 0;
      String url = '', title = '', author = '', description = '', cover = '';
      final genres = <String>[];
      final catIdx = <int>[];
      int status = 0;
      int dateAdded = 0;
      final chapters = <LibraryChapter>[];
      while (mr.hasMore) {
        final t = mr.readTag();
        switch (t.field) {
          case 1:
            source = mr.readVarint();
            break;
          case 2:
            url = mr.readStringValue();
            break;
          case 3:
            title = mr.readStringValue();
            break;
          case 5:
            author = mr.readStringValue();
            break;
          case 6:
            description = mr.readStringValue();
            break;
          case 7:
            genres.add(mr.readStringValue());
            break;
          case 8:
            status = mr.readVarint();
            break;
          case 9:
            cover = mr.readStringValue();
            break;
          case 13:
            dateAdded = mr.readVarint();
            break;
          case 16:
            chapters.add(_readTachiChapter(mr.readBytes()));
            break;
          case 17:
            catIdx.add(mr.readVarint());
            break;
          default:
            mr.skip(t.wire);
        }
      }
      if (url.isEmpty || title.isEmpty) continue;

      // Map source int64 -> a Foxlations source id.
      final backupName = sourceNames[source] ?? '';
      final sourceId = _resolveSourceId(backupName, installedSources);

      final manga = LibraryManga(
        sourceId: sourceId,
        url: url,
        title: title,
        coverUrl: cover,
        author: author.isEmpty ? null : author,
        description: description.isEmpty ? null : description,
        genres: genres,
        status: _statusFromTachi(status),
        addedAt: dateAdded > 0
            ? DateTime.fromMillisecondsSinceEpoch(dateAdded)
            : DateTime.now(),
        categories: catIdx
            .map((i) => orderToCat[i])
            .whereType<String>()
            .toList(),
        totalChapters: chapters.length,
        readChapters: chapters.where((c) => c.isRead).length,
      );
      await _mangaBox.put(manga.uniqueKey, manga);
      for (final c in chapters) {
        c.sourceId = sourceId;
        c.mangaUrl = url;
        await _chapterBox.put(c.uniqueKey, c);
      }
      imported++;
    }

    // ── Aniyomi anime entries (backupAnime). Same field layout as manga, but
    // episodes carry a `seen` flag instead of `read`; imported as contentType
    // 'anime' so the app treats them as shows. ──
    for (final e in animeCatNames.entries) {
      if (!_categoryBox.values.any((c) => c.name == e.value)) {
        await _categoryBox.add(Category(name: e.value, order: e.key));
      }
    }
    for (final am in animeMsgs) {
      final ar = _ProtoReader(am);
      int source = 0;
      String url = '', title = '', author = '', description = '', cover = '';
      final genres = <String>[];
      final catIdx = <int>[];
      int status = 0, dateAdded = 0;
      final episodes = <LibraryChapter>[];
      while (ar.hasMore) {
        final t = ar.readTag();
        switch (t.field) {
          case 1:
            source = ar.readVarint();
            break;
          case 2:
            url = ar.readStringValue();
            break;
          case 3:
            title = ar.readStringValue();
            break;
          case 5:
            author = ar.readStringValue();
            break;
          case 6:
            description = ar.readStringValue();
            break;
          case 7:
            genres.add(ar.readStringValue());
            break;
          case 8:
            status = ar.readVarint();
            break;
          case 9:
            cover = ar.readStringValue();
            break;
          case 13:
            dateAdded = ar.readVarint();
            break;
          case 16:
            episodes.add(_readTachiEpisode(ar.readBytes()));
            break;
          case 17:
            catIdx.add(ar.readVarint());
            break;
          default:
            ar.skip(t.wire);
        }
      }
      if (url.isEmpty || title.isEmpty) continue;
      final backupName = animeSourceNames[source] ?? '';
      final sourceId = _resolveSourceId(backupName, installedSources);
      final anime = LibraryManga(
        sourceId: sourceId,
        url: url,
        title: title,
        coverUrl: cover,
        author: author.isEmpty ? null : author,
        description: description.isEmpty ? null : description,
        genres: genres,
        status: _statusFromTachi(status),
        contentType: 'anime',
        addedAt: dateAdded > 0
            ? DateTime.fromMillisecondsSinceEpoch(dateAdded)
            : DateTime.now(),
        categories:
            catIdx.map((i) => animeCatNames[i]).whereType<String>().toList(),
        totalChapters: episodes.length,
        readChapters: episodes.where((c) => c.isRead).length,
      );
      await _mangaBox.put(anime.uniqueKey, anime);
      for (final c in episodes) {
        c.sourceId = sourceId;
        c.mangaUrl = url;
        await _chapterBox.put(c.uniqueKey, c);
      }
      imported++;
    }

    return imported;
  }

  // Aniyomi BackupEpisode: like BackupChapter but field 4 is `seen` (not read),
  // field 6 is lastSecondSeen. Wire-guarded so small schema drift just skips a
  // field instead of desyncing the reader.
  LibraryChapter _readTachiEpisode(Uint8List bytes) {
    final r = _ProtoReader(bytes);
    String url = '', name = '', scanlator = '';
    bool seen = false;
    double number = -1;
    int sourceOrder = 0, dateUpload = 0;
    while (r.hasMore) {
      final t = r.readTag();
      if (t.field == 1 && t.wire == 2) {
        url = r.readStringValue();
      } else if (t.field == 2 && t.wire == 2) {
        name = r.readStringValue();
      } else if (t.field == 3 && t.wire == 2) {
        scanlator = r.readStringValue();
      } else if (t.field == 4 && t.wire == 0) {
        seen = r.readVarint() != 0;
      } else if (t.field == 9 && t.wire == 0) {
        dateUpload = r.readVarint();
      } else if (t.field == 10 && t.wire == 5) {
        number = r.readFloat();
      } else if (t.field == 11 && t.wire == 0) {
        sourceOrder = r.readVarint();
      } else {
        r.skip(t.wire);
      }
    }
    return LibraryChapter(
      sourceId: '',
      mangaUrl: '',
      chapterUrl: url,
      title: name,
      scanlator: scanlator.isEmpty ? null : scanlator,
      isRead: seen,
      chapterNumber: number >= 0 ? number : null,
      dateUpload: dateUpload > 0 ? dateUpload.toString() : null,
      sourceIndex: sourceOrder,
    );
  }

  LibraryChapter _readTachiChapter(Uint8List bytes) {
    final r = _ProtoReader(bytes);
    String url = '', name = '', scanlator = '';
    bool read = false;
    int lastPage = 0, dateUpload = 0;
    double number = -1;
    int sourceOrder = 0;
    while (r.hasMore) {
      final t = r.readTag();
      switch (t.field) {
        case 1:
          url = r.readStringValue();
          break;
        case 2:
          name = r.readStringValue();
          break;
        case 3:
          scanlator = r.readStringValue();
          break;
        case 4:
          read = r.readVarint() != 0;
          break;
        case 6:
          lastPage = r.readVarint();
          break;
        case 8:
          dateUpload = r.readVarint();
          break;
        case 9:
          number = r.readFloat();
          break;
        case 10:
          sourceOrder = r.readVarint();
          break;
        default:
          r.skip(t.wire);
      }
    }
    return LibraryChapter(
      sourceId: '',
      mangaUrl: '',
      chapterUrl: url,
      title: name,
      scanlator: scanlator.isEmpty ? null : scanlator,
      isRead: read,
      lastPageRead: lastPage,
      chapterNumber: number >= 0 ? number : null,
      dateUpload: dateUpload > 0 ? dateUpload.toString() : null,
      sourceIndex: sourceOrder,
    );
  }

  String _resolveSourceId(String backupName, Map<String, String> installed) =>
      resolveBackupSourceId(backupName, installed);

  int _statusToTachi(String s) {
    switch (s) {
      case 'ongoing':
        return 1;
      case 'completed':
        return 2;
      case 'hiatus':
        return 6;
      case 'canceled':
      case 'cancelled':
        return 5;
      default:
        return 0;
    }
  }

  String _statusFromTachi(int s) {
    switch (s) {
      case 1:
        return 'ongoing';
      case 4: // publishing finished → the series is complete
        return 'completed';
      case 2:
        return 'completed';
      case 5:
        return 'canceled';
      case 6:
        return 'hiatus';
      default:
        return 'unknown';
    }
  }

  // ───────────────────────── listing / auto ─────────────────────────

  Future<List<BackupFile>> listBackups() async {
    final dir = await _backupDir();
    final files = <BackupFile>[];
    await for (final e in dir.list()) {
      if (e is! File) continue;
      final base = e.uri.pathSegments.last;
      // '.fox' is the current native extension; '.fxbackup' is still recognized
      // so backups made by older builds keep showing up and restoring.
      if (!base.endsWith('.fox') &&
          !base.endsWith('.fxbackup') &&
          !base.endsWith('.tachibk')) {
        continue;
      }
      final stat = await e.stat();
      final stampMatch = RegExp(r'(\d{8}-\d{4})').firstMatch(base);
      files.add(BackupFile(
        e.path,
        stampMatch != null ? _displayName(stampMatch.group(1)!) : base,
        stat.modified,
        stat.size,
        base.endsWith('.tachibk'),
        base.contains('-auto'),
      ));
    }
    files.sort((a, b) => b.date.compareTo(a.date));
    return files;
  }

  Future<void> deleteBackup(String path) async {
    final f = File(path);
    if (await f.exists()) await f.delete();
  }

  Future<BackupFrequency> getFrequency() async {
    final v = SettingsStore.instance.getString(_freqKey) ?? 'off';
    return BackupFrequency.values
        .firstWhere((f) => f.name == v, orElse: () => BackupFrequency.off);
  }

  Future<void> setFrequency(BackupFrequency f) async {
    await SettingsStore.instance.setString(_freqKey, f.name);
  }

  Duration? _interval(BackupFrequency f) {
    switch (f) {
      case BackupFrequency.daily:
        return const Duration(days: 1);
      case BackupFrequency.weekly:
        return const Duration(days: 7);
      case BackupFrequency.monthly:
        return const Duration(days: 30);
      case BackupFrequency.off:
        return null;
    }
  }

  /// Run an automatic backup if the configured interval has elapsed. Safe to
  /// call on every app launch — no-ops when off or not yet due. Prunes old
  /// automatic backups to [_maxAutoKept].
  Future<void> maybeRunAuto() async {
    final freq = await getFrequency();
    final interval = _interval(freq);
    if (interval == null) return;
    final last = SettingsStore.instance.getInt(_lastAutoKey) ?? 0;
    final now = DateTime.now();
    if (now.millisecondsSinceEpoch - last < interval.inMilliseconds) return;
    try {
      await createBackup(now: now, auto: true);
      await SettingsStore.instance.setInt(_lastAutoKey, now.millisecondsSinceEpoch);
      await _pruneAuto();
    } catch (e, s) {
      // A failed scheduled backup was invisible — the user thought backups were
      // running. Surface it (still non-throwing).
      await logger.error('Automatic backup failed',
          category: LogCategory.general, detail: '$e\n$s');
    }
  }

  Future<void> _pruneAuto() async {
    final autos = (await listBackups()).where((b) => b.isAuto).toList();
    if (autos.length <= _maxAutoKept) return;
    for (final b in autos.skip(_maxAutoKept)) {
      await deleteBackup(b.path);
    }
  }
}

// ─────────────────────── minimal protobuf codec ───────────────────────

class _ProtoWriter {
  final BytesBuilder _b = BytesBuilder();

  void _rawVarint(int value) {
    var v = value;
    while (true) {
      if ((v & ~0x7F) == 0) {
        _b.addByte(v);
        return;
      }
      _b.addByte((v & 0x7F) | 0x80);
      v = v >>> 7;
    }
  }

  void _tag(int field, int wire) => _rawVarint((field << 3) | wire);

  void varint(int field, int value) {
    if (value == 0) return;
    _tag(field, 0);
    _rawVarint(value);
  }

  /// Always write, even for 0 — required for repeated fields / index values
  /// where 0 is meaningful (e.g. category index 0, chapter source order 0).
  void varintUnconditional(int field, int value) {
    _tag(field, 0);
    _rawVarint(value);
  }

  void floatUnconditional(int field, double value) {
    _tag(field, 5);
    final bd = ByteData(4)..setFloat32(0, value, Endian.little);
    _b.add(bd.buffer.asUint8List());
  }

  void boolean(int field, bool value) {
    if (!value) return;
    _tag(field, 0);
    _rawVarint(1);
  }

  void string(int field, String value) {
    if (value.isEmpty) return;
    final bytes = utf8.encode(value);
    _tag(field, 2);
    _rawVarint(bytes.length);
    _b.add(bytes);
  }

  void message(int field, List<int> msg) {
    _tag(field, 2);
    _rawVarint(msg.length);
    _b.add(msg);
  }

  void float(int field, double value) {
    if (value == 0) return;
    _tag(field, 5);
    final bd = ByteData(4)..setFloat32(0, value, Endian.little);
    _b.add(bd.buffer.asUint8List());
  }

  Uint8List toBytes() => _b.toBytes();
}

/// Maps a Tachiyomi backup's source name onto an installed Foxlations source.
///
/// [installed] is id → display name. Matching MUST go against the names:
/// Tachiyomi backups identify a source by its human name ("Asura Scans"),
/// whereas our ids are numeric (from the repo index) or a derived hash. The
/// original code compared the backup's name against installed *ids*, which
/// could never match, so every restored entry kept a sourceId nothing could
/// resolve and the library showed no source for any of them.
String resolveBackupSourceId(
    String backupName, Map<String, String> installed) {
  if (backupName.isEmpty) return backupName;
  // Our own .tachibk exports write the Foxlations sourceId into the name.
  if (installed.containsKey(backupName)) return backupName;

  String norm(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  final want = norm(backupName);
  if (want.isEmpty) return backupName;

  // Exact (normalised) name first — "Asura Scans" == "asurascans".
  for (final e in installed.entries) {
    if (norm(e.value) == want) return e.key;
  }
  // Then containment, which catches "Asura Scans (EN)" vs "Asura Scans".
  for (final e in installed.entries) {
    final n = norm(e.value);
    if (n.isEmpty) continue;
    if (n.contains(want) || want.contains(n)) return e.key;
  }
  return backupName; // imported, but it won't open until the source exists
}

/// Unwrap a backup file down to raw protobuf bytes.
///
/// The extension is not trusted — different apps wrap the same payload
/// differently and users rename files:
///   * Tachiyomi/Mihon `.tachibk` / `.proto.gz` → gzip (magic `1f 8b`)
///   * Tachimanga `.tmb`                        → ZIP  (magic `50 4b`)
///   * already-extracted payloads               → raw protobuf
///
/// Sniffing the magic bytes means a `.tmb` renamed to `.tachibk` (or the
/// reverse) still restores, instead of dying deep inside the proto parser with
/// an unhelpful RangeError.
Uint8List unwrapBackupBytes(Uint8List raw, {int depth = 0}) {
  if (raw.length >= 2 && raw[0] == 0x1F && raw[1] == 0x8B) {
    return Uint8List.fromList(GZipDecoder().decodeBytes(raw));
  }

  if (raw.length >= 4 && raw[0] == 0x50 && raw[1] == 0x4B) {
    if (depth > 1) {
      throw const FormatException('Backup archive is nested too deeply.');
    }
    final archive = ZipDecoder().decodeBytes(raw);
    final files = archive.files.where((f) => f.isFile).toList();
    if (files.isEmpty) {
      throw const FormatException('Backup archive is empty.');
    }
    // Prefer an entry that names itself a backup; otherwise the largest file,
    // which in practice is the library payload rather than a cover thumbnail.
    bool looksLikeBackup(String n) {
      final l = n.toLowerCase();
      return l.endsWith('.proto.gz') ||
          l.endsWith('.tachibk') ||
          l.endsWith('.proto') ||
          l.contains('backup');
    }

    final candidates = files.where((f) => looksLikeBackup(f.name)).toList();
    final chosen = (candidates.isNotEmpty ? candidates : files)
      ..sort((a, b) => b.size.compareTo(a.size));
    return unwrapBackupBytes(chosen.first.content, depth: depth + 1);
  }

  // No known container — assume it is already raw protobuf.
  return raw;
}

/// Minimal protobuf reader.
///
/// Every read is bounds-checked. Previously any surprise in the stream — an
/// unexpected wire type, a field written by a newer Tachiyomi fork, a container
/// we mis-detected — walked straight off the end of the buffer and surfaced as
/// a bare `RangeError (length): Not in inclusive range 0..17: 18`, which says
/// nothing about what actually went wrong. Now it throws a [FormatException]
/// naming the offset, so a bad backup produces a message a user can act on.
class _ProtoReader {
  final Uint8List _d;
  int _pos = 0;
  _ProtoReader(this._d);

  bool get hasMore => _pos < _d.length;
  int get _remaining => _d.length - _pos;

  Never _bad(String what) => throw FormatException(
      'Malformed backup: $what (at byte $_pos of ${_d.length})');

  int readVarint() {
    int result = 0, shift = 0;
    while (true) {
      if (_pos >= _d.length) _bad('truncated varint');
      final b = _d[_pos++];
      result |= (b & 0x7F) << shift;
      if ((b & 0x80) == 0) break;
      shift += 7;
      if (shift > 63) _bad('varint longer than 10 bytes');
    }
    return result;
  }

  ({int field, int wire}) readTag() {
    final t = readVarint();
    return (field: t >> 3, wire: t & 7);
  }

  Uint8List readBytes() {
    final len = readVarint();
    if (len < 0 || len > _remaining) {
      _bad('length-delimited field claims $len bytes, $_remaining remain');
    }
    final b = Uint8List.sublistView(_d, _pos, _pos + len);
    _pos += len;
    return b;
  }

  String readStringValue() {
    // Tolerate mildly invalid UTF-8 rather than aborting a whole restore.
    return utf8.decode(readBytes(), allowMalformed: true);
  }

  double readFloat() {
    if (_remaining < 4) _bad('truncated 32-bit value');
    final bd = ByteData.sublistView(_d, _pos, _pos + 4);
    _pos += 4;
    return bd.getFloat32(0, Endian.little);
  }

  void skip(int wire) {
    switch (wire) {
      case 0:
        readVarint();
        break;
      case 1:
        if (_remaining < 8) _bad('truncated 64-bit value');
        _pos += 8;
        break;
      case 2:
        final n = readVarint();
        if (n < 0 || n > _remaining) {
          _bad('nested field claims $n bytes, $_remaining remain');
        }
        _pos += n;
        break;
      case 5:
        if (_remaining < 4) _bad('truncated 32-bit value');
        _pos += 4;
        break;
      default:
        // Wire types 3/4 (deprecated groups) and 6/7 are not valid here.
        _bad('unsupported wire type $wire');
    }
  }
}
