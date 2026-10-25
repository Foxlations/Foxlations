import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rhttp/rhttp.dart' as rhttp;
import 'app_logger.dart';
import 'cookie_store.dart';
import 'doh/doh_resolver.dart';
import 'local_source_service.dart';
import 'settings_store.dart';

/// Outcome of a direct (non-HLS) episode download, so the caller can retry an
/// HLS playlist that was served without an .m3u8 URL instead of keeping it.
enum _DirectResult { ok, playlist, failed }

/// Content type for the on-disk download layout. Downloads live under
/// `<section>/<Manga|Anime|Light Novels>/<Title (sourceId)>/…` so the Files app
/// shows readable, type-grouped folders instead of numeric source-ID folders.
enum DownloadKind { manga, anime, novel }

/// Page/skip counts from a background PDF build.
class _PdfBuildResult {
  const _PdfBuildResult(this.pages, this.skipped);
  final int pages;
  final int skipped;
}

/// A resolved DASH track: its init segment (if any) and ordered media segment
/// URLs, plus the Representation element (for codec/size metadata).
class _DashTrack {
  const _DashTrack(this.rep, this.initUrl, this.mediaUrls);
  final XmlElement rep;
  final String? initUrl;
  final List<String> mediaUrls;
}

/// Build a chapter PDF (one image per page) and write it to [outPath]. Runs in a
/// background isolate via [Isolate.run] - decoding, JPEG re-encoding and saving
/// are CPU-bound and would otherwise freeze the UI - so it must be top-level and
/// must not touch the logger or any main-isolate state. Writes nothing (and
/// returns 0 pages) if no image decodes.
Future<_PdfBuildResult> _buildChapterPdf(
    List<String> imagePaths, String outPath) async {
  final doc = pw.Document();
  var pages = 0;
  var skipped = 0;
  for (final path in imagePaths) {
    // PDF's MemoryImage only accepts JPEG/PNG; pages named .jpg may really be
    // webp/gif bytes, so decode + re-encode to JPEG for a valid, sized image.
    final decoded = img.decodeImage(File(path).readAsBytesSync());
    if (decoded == null) {
      skipped++;
      continue;
    }
    final memImage = pw.MemoryImage(img.encodeJpg(decoded, quality: 90));
    doc.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat(decoded.width.toDouble(), decoded.height.toDouble()),
        margin: pw.EdgeInsets.zero,
        build: (context) =>
            pw.Center(child: pw.Image(memImage, fit: pw.BoxFit.contain)),
      ),
    );
    pages++;
  }
  if (pages == 0) return _PdfBuildResult(0, skipped);
  await File(outPath).writeAsBytes(await doc.save());
  return _PdfBuildResult(pages, skipped);
}

/// Downloads manga chapter images to local storage.
///
/// Storage structure:
///   {downloadDir}/library/{sourceId}/{mangaTitle}/{chapterName}/001.jpg
///   {downloadDir}/vault/{sourceId}/{mangaTitle}/{chapterName}/001.jpg
class DownloadService {
  static DownloadService? _instance;
  factory DownloadService() => _instance ??= DownloadService._();
  DownloadService._();

  rhttp.RhttpClient? _client;
  static const _downloadPathKey = 'download_path';

  Future<rhttp.RhttpClient> _getClient() async {
    if (_client != null) return _client!;
    _client = await rhttp.RhttpClient.create(
      settings: rhttp.ClientSettings(
        throwOnStatusCode: false,
        tlsSettings: const rhttp.TlsSettings(verifyCertificates: false),
        dnsSettings: dohDnsSettingsOrNull(),
      ),
    );
    return _client!;
  }

  /// Drop the cached HTTP client so the next download rebuilds it - used when
  /// the DNS-over-HTTPS setting changes (applies without an app restart).
  void resetHttpClient() {
    _client?.dispose();
    _client = null;
  }

  /// Get the base download directory. Uses custom path if set, otherwise app documents.
  Future<String> getBasePath() async {
    final custom = SettingsStore.instance.getString(_downloadPathKey);
    if (custom != null && custom.isNotEmpty && await Directory(custom).exists()) {
      return custom;
    }
    // Default path
    final dir = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Foxlations/downloads';
    }
    return '${dir.path}/Foxlations/downloads';
  }

  /// Set a custom download directory.
  Future<void> setDownloadPath(String path) async {
    await SettingsStore.instance.setString(_downloadPathKey, path);
  }

  /// Clear custom download path (revert to default).
  Future<void> clearDownloadPath() async {
    await SettingsStore.instance.remove(_downloadPathKey);
  }

  /// Get the current download path setting (empty = default).
  Future<String> getDownloadPathSetting() async {
    return SettingsStore.instance.getString(_downloadPathKey) ?? '';
  }

  /// Sanitize a string for use as a directory name.
  String _sanitize(String name) {
    return name
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\.+$'), '')
        .trim();
  }

  /// Top-level, human-readable folder for each content type.
  static String _kindFolder(DownloadKind kind) {
    switch (kind) {
      case DownloadKind.manga:
        return 'Manga';
      case DownloadKind.anime:
        return 'Anime';
      case DownloadKind.novel:
        return 'Light Novels';
    }
  }

  static const List<String> _kindFolders = ['Manga', 'Anime', 'Light Novels'];

  /// Per-title folder name - the title with its numeric source ID appended, so
  /// same-named titles from different sources stay in separate folders.
  String _titleFolder(String title, String sourceId) =>
      '${_sanitize(title)} ($sourceId)';

  /// `<base>/<section>/<Type>/<Title (sourceId)>` for a downloaded title.
  Future<String> _itemDir(
      DownloadKind kind, String sourceId, String title,
      {bool isVault = false}) async {
    final base = await getBasePath();
    final section = isVault ? 'vault' : 'library';
    return '$base/$section/${_kindFolder(kind)}/${_titleFolder(title, sourceId)}';
  }

  /// Get the directory path for a chapter's downloaded images (manga) or text
  /// (novel). [isVault] separates vault from library; [kind] picks the top-level
  /// content-type folder (novels pass [DownloadKind.novel]).
  Future<String> getChapterDir(
      String sourceId, String mangaTitle, String chapterName,
      {bool isVault = false, DownloadKind kind = DownloadKind.manga}) async {
    final itemDir =
        await _itemDir(kind, sourceId, mangaTitle, isVault: isVault);
    return '$itemDir/${_sanitize(chapterName)}';
  }

  /// Check if a chapter is fully downloaded (loose images OR a packed CBZ/PDF).
  Future<bool> isChapterDownloaded(
      String sourceId, String mangaTitle, String chapterName,
      {bool isVault = false}) async {
    final dir = await getChapterDir(sourceId, mangaTitle, chapterName, isVault: isVault);
    final d = Directory(dir);
    if (await d.exists()) {
      final count = await d.list().where((f) => f.path.endsWith('.jpg')).length;
      if (count > 0) return true;
    }
    // "Save as CBZ/PDF" archives the images into a sibling file and deletes the
    // folder - so a packed chapter has no loose images but is still downloaded.
    return await _packedChapterFile(dir) != null;
  }

  /// Get local image paths for a downloaded chapter (sorted). Falls back to
  /// unpacking a sibling CBZ/PDF (converted download) so those read offline too.
  Future<List<String>> getLocalPages(
      String sourceId, String mangaTitle, String chapterName,
      {bool isVault = false}) async {
    final dir = await getChapterDir(sourceId, mangaTitle, chapterName, isVault: isVault);
    final d = Directory(dir);
    if (await d.exists()) {
      final files = await d.list().toList();
      final jpgs = files
          .where((f) => f.path.endsWith('.jpg'))
          .map((f) => f.path)
          .toList();
      if (jpgs.isNotEmpty) {
        jpgs.sort();
        return jpgs;
      }
    }
    // Packed into a sibling .cbz/.pdf - unpack via the local-source reader
    // (shared ZipDecoder / PDF rasterizer) and read those extracted pages.
    final packed = await _packedChapterFile(dir);
    if (packed != null) {
      try {
        return await LocalSourceService().getChapterPages(
          LocalChapter(name: '', path: packed, isArchive: true),
        );
      } catch (e) {
        await logger.warning(
            'Offline: failed unpacking downloaded "$chapterName"',
            category: LogCategory.download, detail: e.toString());
      }
    }
    return [];
  }

  /// The sibling archive a chapter's images were packed into (CBZ preferred),
  /// or null if it was never converted. See [convertToCbz]/[convertToPdf] - the
  /// packed file sits at `<chapterDir>.cbz` / `.pdf`.
  Future<String?> _packedChapterFile(String chapterDir) async {
    for (final ext in const ['cbz', 'pdf']) {
      final p = '$chapterDir.$ext';
      if (await File(p).exists()) return p;
    }
    return null;
  }

  // ── Light novels ─────────────────────────────────────────────────────────
  // A novel chapter is a single HTML document, not a set of images. It lives in
  // the same per-chapter folder as a manga chapter (so delete/size/rescan all
  // work unchanged) as a single `content.html` file.

  /// Path to a downloaded novel chapter's HTML, whether or not it exists yet.
  Future<String> getNovelChapterPath(
      String sourceId, String novelTitle, String chapterName,
      {bool isVault = false}) async {
    final dir = await getChapterDir(sourceId, novelTitle, chapterName,
        isVault: isVault, kind: DownloadKind.novel);
    return '$dir/content.html';
  }

  /// Whether a novel chapter's text is saved for offline reading.
  Future<bool> isNovelChapterDownloaded(
      String sourceId, String novelTitle, String chapterName,
      {bool isVault = false}) async {
    final path = await getNovelChapterPath(sourceId, novelTitle, chapterName,
        isVault: isVault);
    return File(path).exists();
  }

  /// Read a downloaded novel chapter's HTML, or null if it isn't downloaded.
  Future<String?> readNovelChapter(
      String sourceId, String novelTitle, String chapterName,
      {bool isVault = false}) async {
    final path = await getNovelChapterPath(sourceId, novelTitle, chapterName,
        isVault: isVault);
    final f = File(path);
    if (!await f.exists()) return null;
    try {
      return await f.readAsString();
    } catch (e) {
      await logger.warning('Novel: failed reading offline chapter "$chapterName"',
          category: LogCategory.download, detail: e.toString());
      return null;
    }
  }

  /// Save a novel chapter's already-fetched HTML for offline reading.
  Future<bool> downloadNovelChapter({
    required String sourceId,
    required String novelTitle,
    required String chapterName,
    required String htmlContent,
    bool isVault = false,
  }) async {
    if (htmlContent.trim().isEmpty) return false;
    final dir = await getChapterDir(sourceId, novelTitle, chapterName,
        isVault: isVault, kind: DownloadKind.novel);
    await Directory(dir).create(recursive: true);
    try {
      await File('$dir/content.html').writeAsString(htmlContent);
      return true;
    } catch (e) {
      await logger.error('Novel: failed saving offline chapter "$chapterName"',
          category: LogCategory.download, detail: e.toString());
      return false;
    }
  }

  /// Download a chapter's images.
  Future<bool> downloadChapter({
    required String sourceId,
    required String mangaTitle,
    required String chapterName,
    required List<String> imageUrls,
    Map<String, String> headers = const {},
    bool isVault = false,
    void Function(int completed, int total)? onProgress,
  }) async {
    if (imageUrls.isEmpty) return false;

    final dir = await getChapterDir(sourceId, mangaTitle, chapterName, isVault: isVault);
    await Directory(dir).create(recursive: true);

    final client = await _getClient();
    final cookieStore = CookieStore();
    final storedUA = await cookieStore.getUserAgent();

    // All pages in a chapter share a host, so the Cookie/UA headers are the same
    // for every page - build them ONCE instead of per image.
    final baseHeaders = Map<String, String>.from(headers);
    final cookieHeader = await cookieStore.getCookieHeader(imageUrls.first);
    if (cookieHeader != null) baseHeaders['Cookie'] = cookieHeader;
    baseHeaders.putIfAbsent('User-Agent', () => storedUA);

    int completed = 0;
    int failed = 0;

    Future<void> fetchOne(int i) async {
      final url = imageUrls[i];
      final fileName = '${(i + 1).toString().padLeft(3, '0')}.jpg';
      final filePath = '$dir/$fileName';

      // Skip if already downloaded
      if (await File(filePath).exists()) {
        completed++;
        onProgress?.call(completed, imageUrls.length);
        return;
      }

      // Download with retry (isolated per page - a flaky page's backoff no
      // longer blocks the rest of the chapter now that pages run in parallel).
      bool success = false;
      for (int attempt = 0; attempt < 3 && !success; attempt++) {
        try {
          final response = await client.requestBytes(
            method: rhttp.HttpMethod.get,
            url: url,
            headers: rhttp.HttpHeaders.rawMap(baseHeaders),
          );
          if (response.statusCode == 200 && response.body.isNotEmpty) {
            await File(filePath).writeAsBytes(response.body);
            success = true;
          }
        } catch (e) {
          debugPrint('[Download] Retry ${attempt + 1}/3 for $url: $e');
          if (attempt < 2) await Future.delayed(Duration(seconds: attempt + 1));
        }
      }

      if (success) {
        completed++;
      } else {
        failed++;
        debugPrint('[Download] Failed after 3 attempts: $url');
      }
      onProgress?.call(completed, imageUrls.length);
    }

    // Page images are plain HTTP GETs (no source/JVM/JS call - the page list was
    // already fetched), so they're safe to download in parallel on every
    // platform. A small cap keeps us under CDN per-host rate limits; the shared
    // rhttp client pools connections across them. The i→filename mapping is
    // preserved because each worker keeps its own index.
    const imageConcurrency = 5;
    var next = 0;
    Future<void> worker() async {
      while (true) {
        final i = next++;
        if (i >= imageUrls.length) break;
        await fetchOne(i);
      }
    }

    await Future.wait(List.generate(imageConcurrency, (_) => worker()));

    debugPrint('[Download] Chapter "$chapterName": $completed/${imageUrls.length} '
        '(${failed > 0 ? "$failed failed" : "complete"})');
    if (failed > 0) {
      // Surface failed downloads in the in-app log (not just debugPrint).
      await logger.warning(
          'Download: $failed/${imageUrls.length} pages failed - "$chapterName"',
          category: LogCategory.network, detail: 'Source: $sourceId');
    }
    return failed == 0;
  }

  /// Delete a downloaded chapter/episode, covering every content type and every
  /// on-disk shape it can take:
  ///   - manga  → a per-chapter image folder
  ///   - novel  → the same per-chapter folder (holds content.html)
  ///   - packed → a sibling `chapter.cbz` / `.pdf`, PLUS the folder its reader
  ///              leaves behind (`chapter.cbz_extracted` / `chapter.pdf_pages`)
  ///   - anime  → a single media FILE (`episode.mp4/.mkv/.ts/.webm`), not a folder
  /// Earlier this only removed the image folder OR the archive and returned at
  /// the first hit, so anime episodes and a CBZ's extracted folder were never
  /// cleaned up. Now it clears every matching artifact in both sections.
  Future<void> deleteChapter(
      String sourceId, String mangaTitle, String chapterName,
      {bool isVault = false}) async {
    final base = await getBasePath();
    final itemName = _sanitize(chapterName);
    var deletedAny = false;

    Future<void> rmDir(String path) async {
      final d = Directory(path);
      if (await d.exists()) {
        await d.delete(recursive: true);
        debugPrint('[Download] Deleted folder: $path');
        deletedAny = true;
      }
    }

    Future<void> rmFile(String path) async {
      final f = File(path);
      if (await f.exists()) {
        await f.delete();
        debugPrint('[Download] Deleted file: $path');
        deletedAny = true;
      }
    }

    // The content type isn't passed in, so sweep every type folder in both
    // sections. The title folder is name-keyed (`<title> (<sourceId>)`), so
    // these never collide across unrelated titles/types.
    final titleDirName = _titleFolder(mangaTitle, sourceId);
    for (final sec in const ['library', 'vault']) {
      // Manga & novel chapters are a per-chapter FOLDER under Manga / Light
      // Novels, optionally packed into a sibling CBZ/PDF whose reader leaves an
      // extracted-images / rasterized-pages folder next to it.
      for (final type in const ['Manga', 'Light Novels']) {
        final chapterDir = '$base/$sec/$type/$titleDirName/$itemName';
        await rmDir(chapterDir);
        for (final ext in const ['cbz', 'pdf']) {
          await rmFile('$chapterDir.$ext');
          await rmDir('$chapterDir.${ext}_extracted'); // ZipDecoder output (CBZ)
          await rmDir('$chapterDir.${ext}_pages'); // rasterized pages (PDF)
        }
      }
      // Anime episode: a single media FILE, or (for DASH) a per-episode FOLDER
      // holding video.mp4 [+ audio.mp4].
      final animeDir = '$base/$sec/Anime/$titleDirName';
      for (final ext in const ['mp4', 'mkv', 'ts', 'webm']) {
        await rmFile('$animeDir/$itemName.$ext');
      }
      await rmDir('$animeDir/$itemName');
    }

    if (!deletedAny) {
      debugPrint('[Download] Nothing found to delete for "$chapterName" '
          '(source: $sourceId, title: $mangaTitle)');
    }
  }

  /// Delete all downloads for a title (manga, anime or novel). The content type
  /// isn't passed in, so remove the title folder from every type folder in both
  /// sections.
  Future<void> deleteManga(String sourceId, String mangaTitle,
      {bool isVault = false}) async {
    final base = await getBasePath();
    final titleDirName = _titleFolder(mangaTitle, sourceId);
    for (final sec in const ['library', 'vault']) {
      for (final type in _kindFolders) {
        final dir = Directory('$base/$sec/$type/$titleDirName');
        if (await dir.exists()) await dir.delete(recursive: true);
      }
    }
  }

  /// Convert a downloaded chapter folder to a CBZ archive.
  /// Returns the CBZ file path, or null on failure.
  Future<String?> convertToCbz({
    required String sourceId,
    required String mangaTitle,
    required String chapterName,
    bool isVault = false,
    String? author,
    String? description,
    List<String>? genres,
  }) async {
    final dir = await getChapterDir(sourceId, mangaTitle, chapterName, isVault: isVault);
    final d = Directory(dir);
    if (!await d.exists()) return null;

    final files = await d.list().toList();
    final images = files.where((f) {
      final ext = f.path.split('.').last.toLowerCase();
      return ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp' || ext == 'gif';
    }).toList();
    images.sort((a, b) => a.path.compareTo(b.path));

    if (images.isEmpty) return null;

    final archive = Archive();

    // Add images
    for (final img in images) {
      final bytes = await File(img.path).readAsBytes();
      final name = img.path.split('/').last.split('\\').last;
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    // Add ComicInfo.xml metadata
    final comicInfo = StringBuffer();
    comicInfo.writeln('<?xml version="1.0" encoding="utf-8"?>');
    comicInfo.writeln('<ComicInfo>');
    comicInfo.writeln('  <Series>${_xmlEscape(mangaTitle)}</Series>');
    comicInfo.writeln('  <Title>${_xmlEscape(chapterName)}</Title>');
    if (author != null) comicInfo.writeln('  <Writer>${_xmlEscape(author)}</Writer>');
    if (description != null) comicInfo.writeln('  <Summary>${_xmlEscape(description)}</Summary>');
    if (genres != null && genres.isNotEmpty) {
      comicInfo.writeln('  <Genre>${_xmlEscape(genres.join(', '))}</Genre>');
    }
    comicInfo.writeln('  <PageCount>${images.length}</PageCount>');
    comicInfo.writeln('</ComicInfo>');

    final xmlBytes = utf8.encode(comicInfo.toString());
    archive.addFile(ArchiveFile('ComicInfo.xml', xmlBytes.length, xmlBytes));

    // Write CBZ
    final encoder = ZipEncoder();
    final zipData = encoder.encode(archive);

    final mangaDir =
        await _itemDir(DownloadKind.manga, sourceId, mangaTitle, isVault: isVault);
    final cbzPath = '$mangaDir/${_sanitize(chapterName)}.cbz';
    await File(cbzPath).writeAsBytes(zipData);

    // Optionally delete the image folder after archiving
    await d.delete(recursive: true);

    debugPrint('[Download] Created CBZ: $cbzPath (${(zipData.length / 1024).toStringAsFixed(0)} KB)');
    return cbzPath;
  }

  /// Convert a downloaded chapter folder to a single PDF (one image per page).
  /// Each page is sized to its image so aspect ratio is preserved and there are
  /// no margins. Returns the PDF path, or null on failure.
  Future<String?> convertToPdf({
    required String sourceId,
    required String mangaTitle,
    required String chapterName,
    bool isVault = false,
    bool deleteFolder = true,
  }) async {
    final dir = await getChapterDir(sourceId, mangaTitle, chapterName, isVault: isVault);
    final d = Directory(dir);
    if (!await d.exists()) return null;

    final files = await d.list().toList();
    final images = files.where((f) {
      final ext = f.path.split('.').last.toLowerCase();
      return ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp' || ext == 'gif';
    }).toList();
    images.sort((a, b) => a.path.compareTo(b.path));

    if (images.isEmpty) return null;
    final imagePaths = images.map((f) => f.path).toList();

    final mangaDir =
        await _itemDir(DownloadKind.manga, sourceId, mangaTitle, isVault: isVault);
    final pdfPath = '$mangaDir/${_sanitize(chapterName)}.pdf';

    // Decoding every page, re-encoding to JPEG, building the document and
    // saving it are all CPU-bound and used to run on the UI isolate - which
    // froze the whole app solid while a chapter converted. Do it in a
    // background isolate instead; it writes the PDF itself and returns only the
    // page/skip counts.
    _PdfBuildResult result;
    try {
      result =
          await Isolate.run(() => _buildChapterPdf(imagePaths, pdfPath));
    } catch (e) {
      await logger.error('PDF conversion failed (kept as images)',
          category: LogCategory.download, detail: '"$chapterName"\n$e');
      return null;
    }

    // Every page failed to decode (e.g. the source serves AVIF, which the image
    // package can't read). Keep the image folder so the chapter is still
    // readable, and surface why instead of leaving a half-done download.
    if (result.pages == 0) {
      await logger.error(
          'PDF conversion failed - no decodable pages (kept as images)',
          category: LogCategory.download,
          detail: 'Source: $sourceId · "$chapterName" · ${imagePaths.length} files');
      return null;
    }
    if (result.skipped > 0) {
      await logger.warning(
          'PDF: ${result.skipped}/${imagePaths.length} pages were undecodable and dropped',
          category: LogCategory.download, detail: '"$chapterName"');
    }

    if (deleteFolder) {
      try {
        await d.delete(recursive: true);
      } catch (_) {}
    }
    debugPrint('[Download] Created PDF: $pdfPath (${result.pages} pages)');
    return pdfPath;
  }

  /// Get the directory path for an anime series' downloaded episodes.
  Future<String> getAnimeDir(String sourceId, String animeTitle) async {
    return _itemDir(DownloadKind.anime, sourceId, animeTitle);
  }

  /// Check if an episode is downloaded.
  Future<bool> isEpisodeDownloaded(
      String sourceId, String animeTitle, String episodeName) async {
    final dir = await getAnimeDir(sourceId, animeTitle);
    final name = _sanitize(episodeName);
    for (final ext in ['mp4', 'mkv', 'ts', 'webm']) {
      if (await File('$dir/$name.$ext').exists()) return true;
      // A per-episode folder (DASH, or an episode kept with subtitle/audio
      // tracks) stores the video as video.<ext>.
      if (await File('$dir/$name/video.$ext').exists()) return true;
    }
    return false;
  }

  /// Get the local file path for a downloaded episode (null if not found).
  Future<String?> getEpisodePath(
      String sourceId, String animeTitle, String episodeName) async {
    final dir = await getAnimeDir(sourceId, animeTitle);
    final name = _sanitize(episodeName);
    for (final ext in ['mp4', 'mkv', 'ts', 'webm']) {
      final path = '$dir/$name.$ext';
      if (await File(path).exists()) return path;
    }
    // A per-episode folder (DASH, or an episode kept with subtitle/audio
    // tracks): the main video is video.<ext>, with sibling audio.mp4 / tracks
    // the player attaches.
    for (final ext in ['mp4', 'ts', 'mkv', 'webm']) {
      final path = '$dir/$name/video.$ext';
      if (await File(path).exists()) return path;
    }
    return null;
  }

  /// Download an anime episode. Handles direct video URLs and HLS (.m3u8).
  /// Progress callback receives (bytesReceived, totalBytes) - total is -1 for
  /// HLS until the segment count is known, then switches to (segmentsDone, segmentsTotal).
  Future<bool> downloadEpisode({
    required String sourceId,
    required String animeTitle,
    required String episodeName,
    required String videoUrl,
    Map<String, String> headers = const {},
    List<({String url, String label})> subtitles = const [],
    List<({String url, String label})> audios = const [],
    void Function(int received, int total)? onProgress,
  }) async {
    final dir = await getAnimeDir(sourceId, animeTitle);
    await Directory(dir).create(recursive: true);
    final name = _sanitize(episodeName);
    final lower = videoUrl.toLowerCase();
    final isDash = lower.contains('.mpd');
    final isHls = lower.contains('m3u8');
    // Keep subtitle / extra-audio tracks (so offline matches streaming) by
    // storing the episode as a per-episode FOLDER alongside tracks.json. DASH
    // always uses a folder; a plain episode with no extra tracks stays a single
    // file (the original, well-tested path, left untouched below).
    final rich = subtitles.isNotEmpty || audios.isNotEmpty;

    bool videoOk;
    if (isDash) {
      videoOk = await _downloadDash(videoUrl, dir, name, headers, onProgress);
    } else if (rich) {
      final folder = '$dir/$name';
      await Directory(folder).create(recursive: true);
      if (isHls) {
        videoOk = await _downloadHls(videoUrl, folder, 'video', headers, onProgress);
      } else {
        final ext = _videoExtension(videoUrl);
        final r = await _downloadDirect(
            videoUrl, '$folder/video.$ext', headers, onProgress);
        videoOk = r == _DirectResult.ok ||
            (r == _DirectResult.playlist &&
                await _downloadHls(videoUrl, folder, 'video', headers, onProgress));
      }
      if (!videoOk) {
        try {
          final d = Directory(folder);
          if (await d.exists()) await d.delete(recursive: true);
        } catch (_) {}
      }
    } else if (isHls) {
      return _downloadHls(videoUrl, dir, name, headers, onProgress);
    } else {
      // Direct file. Some sources hand back an HLS playlist without an .m3u8
      // URL - if so, fall back to the segment downloader instead of saving the
      // playlist text as "video".
      final ext = _videoExtension(videoUrl);
      final result =
          await _downloadDirect(videoUrl, '$dir/$name.$ext', headers, onProgress);
      switch (result) {
        case _DirectResult.ok:
          return true;
        case _DirectResult.playlist:
          return _downloadHls(videoUrl, dir, name, headers, onProgress);
        case _DirectResult.failed:
          return false;
      }
    }

    if (!videoOk) return false;
    // Fetch the subtitle / external-audio files next to the video.
    if (rich) await _saveEpisodeTracks(dir, name, subtitles, audios, headers);
    return true;
  }

  /// Download an episode's subtitle (+ external audio) tracks into its folder
  /// and record them in tracks.json so the player can offer them offline.
  Future<void> _saveEpisodeTracks(
      String dir,
      String name,
      List<({String url, String label})> subtitles,
      List<({String url, String label})> audios,
      Map<String, String> headers) async {
    final folder = '$dir/$name';
    await Directory(folder).create(recursive: true);
    final subMeta = <Map<String, String>>[];
    final audMeta = <Map<String, String>>[];
    for (var i = 0; i < subtitles.length; i++) {
      final ext = _subExtension(subtitles[i].url);
      final file = 'sub_$i.$ext';
      if (await _downloadTrackFile(subtitles[i].url, '$folder/$file', headers)) {
        subMeta.add({'file': file, 'label': subtitles[i].label});
      }
    }
    for (var i = 0; i < audios.length; i++) {
      final ext = _videoExtension(audios[i].url);
      final file = 'extaudio_$i.$ext';
      if (await _downloadTrackFile(audios[i].url, '$folder/$file', headers)) {
        audMeta.add({'file': file, 'label': audios[i].label});
      }
    }
    try {
      await File('$folder/tracks.json')
          .writeAsString(jsonEncode({'subtitles': subMeta, 'extAudios': audMeta}));
    } catch (_) {}
  }

  String _subExtension(String url) {
    final path = (Uri.tryParse(url)?.path ?? url).toLowerCase();
    for (final e in const ['vtt', 'ass', 'ssa', 'srt']) {
      if (path.endsWith('.$e')) return e;
    }
    return 'vtt';
  }

  /// Download a small sidecar file (subtitle / audio track). Best-effort: a
  /// failure just omits that track rather than failing the whole episode.
  Future<bool> _downloadTrackFile(
      String url, String savePath, Map<String, String> headers) async {
    final cookieStore = CookieStore();
    final storedUA = await cookieStore.getUserAgent();
    final cookieHeader = await cookieStore.getCookieHeader(url);
    final mergedHeaders = Map<String, String>.from(headers);
    mergedHeaders.putIfAbsent('User-Agent', () => storedUA);
    if (cookieHeader != null) mergedHeaders['Cookie'] = cookieHeader;
    final dio = Dio(BaseOptions(
      headers: mergedHeaders,
      receiveTimeout: const Duration(minutes: 5),
      connectTimeout: const Duration(seconds: 30),
    ));
    try {
      await dio.download(url, savePath);
      final f = File(savePath);
      return await f.exists() && await f.length() > 0;
    } catch (e) {
      debugPrint('[Download] track fetch failed: $e');
      return false;
    } finally {
      dio.close();
    }
  }

  String _videoExtension(String url) {
    final path = Uri.tryParse(url)?.path ?? url;
    final ext = path.split('.').last.toLowerCase().split('?').first;
    const known = {'mp4', 'mkv', 'webm', 'avi', 'mov', 'ts'};
    return known.contains(ext) ? ext : 'mp4';
  }

  /// Download a direct video file (streams to disk). Validates that what landed
  /// is actually video - not an HTML/JSON error page or an HLS playlist that was
  /// served without an .m3u8 URL - so the player never opens an 8 KB "video".
  Future<_DirectResult> _downloadDirect(
    String url,
    String savePath,
    Map<String, String> headers,
    void Function(int, int)? onProgress,
  ) async {
    if (await File(savePath).exists()) return _DirectResult.ok;
    final cookieStore = CookieStore();
    final storedUA = await cookieStore.getUserAgent();
    final cookieHeader = await cookieStore.getCookieHeader(url);

    final mergedHeaders = Map<String, String>.from(headers);
    mergedHeaders.putIfAbsent('User-Agent', () => storedUA);
    if (cookieHeader != null) mergedHeaders['Cookie'] = cookieHeader;

    final dio = Dio(BaseOptions(
      headers: mergedHeaders,
      receiveTimeout: const Duration(minutes: 30),
      connectTimeout: const Duration(seconds: 30),
    ));

    try {
      await dio.download(url, savePath, onReceiveProgress: onProgress);
      final f = File(savePath);
      if (!await f.exists()) return _DirectResult.failed;
      final len = await f.length();
      // A real episode is many MB. Anything tiny is a playlist or an error page
      // masquerading as video - sniff the head and classify.
      if (len < 512 * 1024) {
        final head = (await _readHead(f, 256)).trimLeft();
        if (head.startsWith('#EXTM3U')) {
          await f.delete();
          return _DirectResult.playlist;
        }
        final lower = head.toLowerCase();
        if (lower.startsWith('<') || lower.startsWith('{') || len < 1024) {
          await f.delete();
          await logger.error('Episode download got non-video data (${len}B)',
              category: LogCategory.network, detail: url);
          return _DirectResult.failed;
        }
      }
      return _DirectResult.ok;
    } catch (e) {
      debugPrint('[Download] Direct video failed: $e');
      await logger.error('Episode download failed',
          category: LogCategory.network, detail: '$url\n$e');
      try {
        final f = File(savePath);
        if (await f.exists()) await f.delete();
      } catch (_) {}
      return _DirectResult.failed;
    } finally {
      dio.close();
    }
  }

  /// Fetch [urls] with bounded [concurrency] but write them to [out] strictly
  /// in order (buffering out-of-order arrivals and flushing the contiguous
  /// prefix as it completes, so memory stays bounded). [transform] post-
  /// processes each segment by index (HLS AES decrypt). Returns true only if
  /// every segment downloaded; stops on the first failure. This is what makes
  /// segmented (HLS/DASH) downloads fast instead of one-at-a-time.
  @visibleForTesting
  Future<bool> fetchSegmentsOrdered(
    Dio dio,
    List<String> urls,
    IOSink out, {
    int concurrency = 6,
    List<int> Function(List<int> bytes, int index)? transform,
    void Function(int completed)? onCompleted,
  }) async {
    if (urls.isEmpty) return true;
    final ready = <int, List<int>>{};
    var nextWrite = 0;
    var nextFetch = 0;
    var completed = 0;
    var failed = false;

    Future<void> worker() async {
      while (!failed) {
        final i = nextFetch++;
        if (i >= urls.length) return;
        List<int>? bytes;
        try {
          final r = await dio.get<List<int>>(urls[i],
              options: Options(responseType: ResponseType.bytes));
          bytes = r.data;
        } catch (e) {
          debugPrint('[Download] segment $i failed: $e');
          failed = true;
          return;
        }
        if (bytes == null || bytes.isEmpty) {
          failed = true;
          return;
        }
        try {
          ready[i] = transform != null ? transform(bytes, i) : bytes;
        } catch (e) {
          debugPrint('[Download] segment $i transform failed: $e');
          failed = true;
          return;
        }
        // Flush the in-order prefix. Synchronous (no await), so two workers
        // can't interleave here.
        while (ready.containsKey(nextWrite)) {
          out.add(ready.remove(nextWrite)!);
          nextWrite++;
          completed++;
          onCompleted?.call(completed);
        }
      }
    }

    final workers = concurrency < urls.length ? concurrency : urls.length;
    await Future.wait(List.generate(workers, (_) => worker()));
    return !failed && nextWrite == urls.length;
  }

  /// Download an HLS stream: fetch every segment, AES-128-decrypt it when the
  /// playlist is encrypted (EXT-X-KEY), and concatenate into one .ts. Returns
  /// false (and deletes the partial file) if any segment is missing or the
  /// playlist uses encryption we can't handle - anime HLS is usually AES-128,
  /// and the old concatenate-raw path produced an unplayable file ("Failed to
  /// recognize file format").
  Future<bool> _downloadHls(
    String m3u8Url,
    String dir,
    String name,
    Map<String, String> headers,
    void Function(int, int)? onProgress,
  ) async {
    final savePath = '$dir/$name.ts';
    if (await File(savePath).exists()) return true;

    final cookieStore = CookieStore();
    final storedUA = await cookieStore.getUserAgent();
    final cookieHeader = await cookieStore.getCookieHeader(m3u8Url);

    final mergedHeaders = Map<String, String>.from(headers);
    mergedHeaders.putIfAbsent('User-Agent', () => storedUA);
    if (cookieHeader != null) mergedHeaders['Cookie'] = cookieHeader;

    final dio = Dio(BaseOptions(
      headers: mergedHeaders,
      receiveTimeout: const Duration(minutes: 5),
      connectTimeout: const Duration(seconds: 30),
    ));

    Future<void> cleanup() async {
      try {
        final f = File(savePath);
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }

    try {
      final playlistRes = await dio.get<String>(m3u8Url);
      var playlist = playlistRes.data ?? '';
      if (!playlist.contains('#EXTM3U')) {
        await logger.error('HLS: response was not a playlist',
            category: LogCategory.network,
            detail: '$m3u8Url\n(${playlist.length} bytes)');
        return false;
      }

      // Master playlist → pick the first variant stream.
      if (playlist.contains('#EXT-X-STREAM-INF')) {
        final variantLine = playlist
            .split('\n')
            .firstWhere((l) => l.trim().isNotEmpty && !l.startsWith('#'),
                orElse: () => '');
        if (variantLine.isEmpty) return false;
        final variantUrl = _resolveUri(variantLine.trim(), m3u8Url);
        final variantRes = await dio.get<String>(variantUrl);
        playlist = variantRes.data ?? '';
        m3u8Url = variantUrl;
      }

      // AES-128 decryption setup (EXT-X-KEY). One key for the whole playlist is
      // the common case; mid-list key rotation isn't handled.
      enc.Encrypter? decrypter;
      Uint8List? explicitIv;
      var mediaSeq = 0;
      final seqMatch =
          RegExp(r'#EXT-X-MEDIA-SEQUENCE:\s*(\d+)').firstMatch(playlist);
      if (seqMatch != null) mediaSeq = int.tryParse(seqMatch.group(1)!) ?? 0;

      final keyMatch = RegExp(r'#EXT-X-KEY:([^\r\n]+)').firstMatch(playlist);
      if (keyMatch != null) {
        final attrs = keyMatch.group(1)!;
        final method =
            RegExp(r'METHOD=([A-Za-z0-9-]+)').firstMatch(attrs)?.group(1);
        if (method != null && method != 'NONE') {
          if (method != 'AES-128') {
            await logger.error('HLS: unsupported encryption "$method"',
                category: LogCategory.network, detail: m3u8Url);
            return false;
          }
          final keyUri = RegExp(r'URI="([^"]+)"').firstMatch(attrs)?.group(1);
          if (keyUri == null) {
            await logger.error('HLS: AES-128 key has no URI',
                category: LogCategory.network, detail: m3u8Url);
            return false;
          }
          final keyUrl = _resolveUri(keyUri, m3u8Url);
          final keyRes = await dio.get<List<int>>(keyUrl,
              options: Options(responseType: ResponseType.bytes));
          final keyBytes = keyRes.data;
          if (keyBytes == null || keyBytes.length != 16) {
            await logger.error('HLS: AES-128 key fetch failed',
                category: LogCategory.network, detail: keyUrl);
            return false;
          }
          decrypter = enc.Encrypter(enc.AES(
              enc.Key(Uint8List.fromList(keyBytes)),
              mode: enc.AESMode.cbc,
              padding: null));
          final ivHex =
              RegExp(r'IV=0[xX]([0-9A-Fa-f]+)').firstMatch(attrs)?.group(1);
          if (ivHex != null) explicitIv = _hexToBytes(ivHex);
        }
      }

      // Segment URLs (every non-tag line), in order.
      final segments = playlist
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && !l.startsWith('#'))
          .map((l) => _resolveUri(l, m3u8Url))
          .toList();
      if (segments.isEmpty) return false;
      onProgress?.call(0, segments.length);

      final outFile = File(savePath).openWrite(mode: FileMode.writeOnly);
      bool ok;
      try {
        // Decrypt each segment by its index (IV = explicit, or the segment's
        // media-sequence number) as it arrives.
        final decrypter0 = decrypter;
        ok = await fetchSegmentsOrdered(
          dio,
          segments,
          outFile,
          transform: decrypter0 == null
              ? null
              : (bytes, i) {
                  final iv = enc.IV(explicitIv ?? _seqIv(mediaSeq + i));
                  return _stripPkcs7(decrypter0.decryptBytes(
                      enc.Encrypted(Uint8List.fromList(bytes)),
                      iv: iv));
                },
          onCompleted: (c) => onProgress?.call(c, segments.length),
        );
      } finally {
        await outFile.close();
      }

      final len =
          await File(savePath).exists() ? await File(savePath).length() : 0;
      if (!ok || len < 256 * 1024) {
        await cleanup();
        await logger.error('HLS download incomplete - not saved (${len}B)',
            category: LogCategory.network, detail: m3u8Url);
        return false;
      }
      return true;
    } catch (e) {
      await cleanup();
      debugPrint('[Download] HLS download failed: $e');
      await logger.error('Episode (HLS) download failed',
          category: LogCategory.network, detail: '$m3u8Url\n$e');
      return false;
    } finally {
      dio.close();
    }
  }

  /// Resolve a possibly-relative URI against a playlist/base URL.
  String _resolveUri(String uri, String baseUrl) {
    if (uri.startsWith('http://') || uri.startsWith('https://')) return uri;
    try {
      return Uri.parse(baseUrl).resolve(uri).toString();
    } catch (_) {
      final base = baseUrl.substring(0, baseUrl.lastIndexOf('/') + 1);
      return '$base$uri';
    }
  }

  /// First [n] bytes of a file as a latin1 string (cheap content sniffing).
  Future<String> _readHead(File f, int n) async {
    final raf = await f.open();
    try {
      final len = await f.length();
      final bytes = await raf.read(len < n ? len : n);
      return latin1.decode(bytes, allowInvalid: true);
    } finally {
      await raf.close();
    }
  }

  /// Parse a hex string (e.g. an EXT-X-KEY IV) into bytes.
  Uint8List _hexToBytes(String hex) {
    final clean = hex.length.isOdd ? '0$hex' : hex;
    final out = Uint8List(clean.length ~/ 2);
    for (var i = 0; i < out.length; i++) {
      out[i] = int.parse(clean.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return out;
  }

  /// Default HLS IV = the segment's media-sequence number as a 16-byte
  /// big-endian value (used when EXT-X-KEY carries no explicit IV).
  Uint8List _seqIv(int seq) {
    final iv = Uint8List(16);
    for (var i = 15; i >= 0 && seq > 0; i--) {
      iv[i] = seq & 0xff;
      seq >>= 8;
    }
    return iv;
  }

  /// Strip PKCS7 padding (HLS AES-128 segments are PKCS7-padded per RFC 8216),
  /// but only when the trailer is a valid PKCS7 block - otherwise leave as-is.
  List<int> _stripPkcs7(List<int> data) {
    if (data.isEmpty) return data;
    final pad = data.last;
    if (pad < 1 || pad > 16 || pad > data.length) return data;
    for (var i = data.length - pad; i < data.length; i++) {
      if (data[i] != pad) return data;
    }
    return data.sublist(0, data.length - pad);
  }

  // ── MPEG-DASH (.mpd) ──────────────────────────────────────────────────────
  // DASH splits audio and video into separate segment streams described by an
  // XML manifest. We pick the best video + best audio Representation, download
  // and concatenate each one's init + media segments into a self-contained
  // fragmented-MP4, and store them per-episode. The player then plays
  // `video.mp4` and attaches `audio.mp4` as an external audio track (its
  // existing separate-audio path) - no muxing or local DASH demuxer needed. A
  // single muxed Representation is stored as a plain `<name>.mp4`.

  /// Download a DASH episode. Returns false (and cleans up) on any failure.
  Future<bool> _downloadDash(String mpdUrl, String dir, String name,
      Map<String, String> headers, void Function(int, int)? onProgress) async {
    final outDir = '$dir/$name';
    if (await File('$outDir/video.mp4').exists() ||
        await File('$dir/$name.mp4').exists()) {
      return true;
    }

    final cookieStore = CookieStore();
    final storedUA = await cookieStore.getUserAgent();
    final cookieHeader = await cookieStore.getCookieHeader(mpdUrl);
    final mergedHeaders = Map<String, String>.from(headers);
    mergedHeaders.putIfAbsent('User-Agent', () => storedUA);
    if (cookieHeader != null) mergedHeaders['Cookie'] = cookieHeader;

    final dio = Dio(BaseOptions(
      headers: mergedHeaders,
      receiveTimeout: const Duration(minutes: 10),
      connectTimeout: const Duration(seconds: 30),
    ));

    Future<void> cleanup() async {
      try {
        final d = Directory(outDir);
        if (await d.exists()) await d.delete(recursive: true);
      } catch (_) {}
      try {
        final f = File('$dir/$name.mp4');
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }

    try {
      final res = await dio.get<String>(mpdUrl);
      final text = res.data ?? '';
      if (!text.contains('<MPD')) {
        await logger.error('DASH: response was not a manifest',
            category: LogCategory.network, detail: mpdUrl);
        return false;
      }
      final mpd = XmlDocument.parse(text).rootElement;
      final period = mpd.findAllElements('Period').firstOrNull;
      if (period == null) {
        await logger.error('DASH: manifest has no Period',
            category: LogCategory.network, detail: mpdUrl);
        return false;
      }

      final totalSec = _parseIsoDuration(
              mpd.getAttribute('mediaPresentationDuration')) ??
          _parseIsoDuration(period.getAttribute('duration')) ??
          0.0;

      final mpdBase =
          _joinBase(mpdUrl, mpd.findElements('BaseURL').firstOrNull?.innerText.trim());
      final periodBase = _joinBase(
          mpdBase, period.findElements('BaseURL').firstOrNull?.innerText.trim());

      _DashTrack? video;
      _DashTrack? audio;
      for (final as in period.findElements('AdaptationSet')) {
        final reps = as.findElements('Representation').toList();
        if (reps.isEmpty) continue;
        // Highest bandwidth wins.
        reps.sort((a, b) => (int.tryParse(b.getAttribute('bandwidth') ?? '0') ?? 0)
            .compareTo(int.tryParse(a.getAttribute('bandwidth') ?? '0') ?? 0));
        final rep = reps.first;
        final mime = (rep.getAttribute('mimeType') ??
                as.getAttribute('mimeType') ??
                as.getAttribute('contentType') ??
                '')
            .toLowerCase();
        final isAudio = mime.startsWith('audio') ||
            as.getAttribute('contentType') == 'audio';
        final isVideo = mime.startsWith('video') ||
            as.getAttribute('contentType') == 'video' ||
            rep.getAttribute('width') != null;
        final asBase = _joinBase(
            periodBase, as.findElements('BaseURL').firstOrNull?.innerText.trim());
        final seg = _repSegments(rep, as, asBase, totalSec);
        final track = _DashTrack(rep, seg.$1, seg.$2);
        if (isAudio && audio == null) {
          audio = track;
        } else if (isVideo && video == null) {
          video = track;
        } else if (video == null) {
          video = track; // unclassified / muxed
        }
      }

      if (video == null || video.mediaUrls.isEmpty) {
        await logger.error('DASH: no downloadable video track',
            category: LogCategory.network, detail: mpdUrl);
        return false;
      }
      final muxed = audio == null;

      final totalSegs = _trackSegCount(video) +
          (audio != null ? _trackSegCount(audio) : 0);
      var done = 0;
      onProgress?.call(0, totalSegs);

      Future<bool> fetchTrack(_DashTrack t, String outPath) async {
        final out = File(outPath).openWrite(mode: FileMode.writeOnly);
        final base = done;
        bool ok;
        try {
          final urls = [if (t.initUrl != null) t.initUrl!, ...t.mediaUrls];
          ok = await fetchSegmentsOrdered(
            dio,
            urls,
            out,
            onCompleted: (c) {
              done = base + c;
              onProgress?.call(done, totalSegs);
            },
          );
        } finally {
          await out.close();
        }
        return ok;
      }

      if (muxed) {
        final singlePath = '$dir/$name.mp4';
        final ok = await fetchTrack(video, singlePath);
        final len =
            await File(singlePath).exists() ? await File(singlePath).length() : 0;
        if (!ok || len < 256 * 1024) {
          await cleanup();
          await logger.error('DASH download incomplete - not saved (${len}B)',
              category: LogCategory.network, detail: mpdUrl);
          return false;
        }
        return true;
      }

      await Directory(outDir).create(recursive: true);
      final vOk = await fetchTrack(video, '$outDir/video.mp4');
      final aOk = vOk && await fetchTrack(audio, '$outDir/audio.mp4');
      final vLen = await File('$outDir/video.mp4').exists()
          ? await File('$outDir/video.mp4').length()
          : 0;
      final aLen = await File('$outDir/audio.mp4').exists()
          ? await File('$outDir/audio.mp4').length()
          : 0;
      if (!vOk || !aOk || vLen < 256 * 1024 || aLen < 16 * 1024) {
        await cleanup();
        await logger.error('DASH download incomplete - not saved',
            category: LogCategory.network,
            detail: '$mpdUrl\nvideo ${vLen}B, audio ${aLen}B');
        return false;
      }
      return true;
    } catch (e) {
      await cleanup();
      debugPrint('[Download] DASH download failed: $e');
      await logger.error('Episode (DASH) download failed',
          category: LogCategory.network, detail: '$mpdUrl\n$e');
      return false;
    } finally {
      dio.close();
    }
  }

  int _trackSegCount(_DashTrack t) =>
      (t.initUrl != null ? 1 : 0) + t.mediaUrls.length;

  /// Resolve a Representation's init + ordered media segment URLs, handling the
  /// common DASH addressing modes: SegmentTemplate (with a SegmentTimeline or a
  /// fixed segment duration), SegmentList, and a plain single-file BaseURL.
  (String?, List<String>) _repSegments(
      XmlElement rep, XmlElement adaptSet, String baseUrl, double totalSec) {
    final repId = rep.getAttribute('id') ?? '';
    final bw = rep.getAttribute('bandwidth') ?? '';
    final repBase =
        _joinBase(baseUrl, rep.findElements('BaseURL').firstOrNull?.innerText.trim());

    final st = rep.findElements('SegmentTemplate').firstOrNull ??
        adaptSet.findElements('SegmentTemplate').firstOrNull;
    if (st != null) {
      final initTmpl = st.getAttribute('initialization');
      final mediaTmpl = st.getAttribute('media');
      final startNumber = int.tryParse(st.getAttribute('startNumber') ?? '1') ?? 1;
      final timescale = int.tryParse(st.getAttribute('timescale') ?? '1') ?? 1;
      final initUrl = initTmpl != null
          ? _joinBase(repBase, _fillTemplate(initTmpl, repId: repId, bandwidth: bw))
          : null;
      final media = <String>[];
      final timeline = st.findElements('SegmentTimeline').firstOrNull;
      if (timeline != null) {
        var number = startNumber;
        var time = 0;
        for (final s in timeline.findElements('S')) {
          final t = int.tryParse(s.getAttribute('t') ?? '');
          final d = int.tryParse(s.getAttribute('d') ?? '0') ?? 0;
          final r = int.tryParse(s.getAttribute('r') ?? '0') ?? 0;
          if (t != null) time = t;
          for (var k = 0; k <= r; k++) {
            if (mediaTmpl != null) {
              media.add(_joinBase(
                  repBase,
                  _fillTemplate(mediaTmpl,
                      repId: repId, bandwidth: bw, number: number, time: time)));
            }
            number++;
            time += d;
          }
        }
      } else if (mediaTmpl != null) {
        final dur = int.tryParse(st.getAttribute('duration') ?? '0') ?? 0;
        if (dur > 0 && totalSec > 0) {
          final count = (totalSec * timescale / dur).ceil();
          for (var i = 0; i < count; i++) {
            media.add(_joinBase(
                repBase,
                _fillTemplate(mediaTmpl,
                    repId: repId,
                    bandwidth: bw,
                    number: startNumber + i,
                    time: i * dur)));
          }
        }
      }
      return (initUrl, media);
    }

    final sl = rep.findElements('SegmentList').firstOrNull ??
        adaptSet.findElements('SegmentList').firstOrNull;
    if (sl != null) {
      final init = sl.findElements('Initialization').firstOrNull?.getAttribute('sourceURL');
      final initUrl = init != null ? _joinBase(repBase, init) : null;
      final media = sl
          .findElements('SegmentURL')
          .map((e) => _joinBase(repBase, e.getAttribute('media') ?? ''))
          .where((u) => u.isNotEmpty)
          .toList();
      return (initUrl, media);
    }

    // SegmentBase / plain BaseURL: the Representation is a single on-demand file.
    return (null, [repBase]);
  }

  /// Fill a DASH template ($RepresentationID$, $Bandwidth$, $Number$, $Time$,
  /// with optional %0Nd zero-padding, and $$ -> $).
  String _fillTemplate(String tmpl,
      {String repId = '', String bandwidth = '', int? number, int? time}) {
    var out = tmpl
        .replaceAll(r'$RepresentationID$', repId)
        .replaceAll(r'$Bandwidth$', bandwidth);
    String sub(String s, String field, int? value) =>
        s.replaceAllMapped(RegExp('\\\$$field(%0\\d+d)?\\\$'), (m) {
          if (value == null) return m.group(0)!;
          final fmt = m.group(1);
          if (fmt != null) {
            final w = int.parse(RegExp(r'%0(\d+)d').firstMatch(fmt)!.group(1)!);
            return value.toString().padLeft(w, '0');
          }
          return value.toString();
        });
    out = sub(out, 'Number', number);
    out = sub(out, 'Time', time);
    return out.replaceAll(r'$$', r'$');
  }

  /// Resolve a possibly-relative DASH URL/BaseURL against a base.
  String _joinBase(String base, String? rel) {
    if (rel == null || rel.isEmpty) return base;
    if (rel.startsWith('http://') || rel.startsWith('https://')) return rel;
    try {
      return Uri.parse(base).resolve(rel).toString();
    } catch (_) {
      final b = base.substring(0, base.lastIndexOf('/') + 1);
      return '$b$rel';
    }
  }

  /// Parse an ISO-8601 duration (e.g. `PT1H23M45.6S`) to seconds.
  double? _parseIsoDuration(String? s) {
    if (s == null) return null;
    final m = RegExp(
            r'^PT(?:(\d+(?:\.\d+)?)H)?(?:(\d+(?:\.\d+)?)M)?(?:(\d+(?:\.\d+)?)S)?$')
        .firstMatch(s.trim());
    if (m == null) return null;
    final h = double.tryParse(m.group(1) ?? '0') ?? 0;
    final min = double.tryParse(m.group(2) ?? '0') ?? 0;
    final sec = double.tryParse(m.group(3) ?? '0') ?? 0;
    return h * 3600 + min * 60 + sec;
  }

  // Thin test hooks for the pure DASH-manifest parsing (no network/instance
  // state), so the segment-enumeration logic can be unit-tested.
  @visibleForTesting
  (String?, List<String>) dashRepSegmentsForTest(
          XmlElement rep, XmlElement adaptSet, String baseUrl, double totalSec) =>
      _repSegments(rep, adaptSet, baseUrl, totalSec);
  @visibleForTesting
  String dashFillTemplateForTest(String tmpl,
          {String repId = '', String bandwidth = '', int? number, int? time}) =>
      _fillTemplate(tmpl,
          repId: repId, bandwidth: bandwidth, number: number, time: time);
  @visibleForTesting
  double? dashParseIsoDurationForTest(String? s) => _parseIsoDuration(s);

  String _xmlEscape(String s) =>
      s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

  /// Returns the set of '{sourceId}::{url}' for library entries that have at
  /// least one downloaded chapter/episode on disk. Lists each type folder
  /// (Manga/Anime/Light Novels) once, so passing the whole library is cheap.
  ///
  /// Only the normal library section is scanned - the library screen's
  /// "Downloaded" filter is for the normal library. Robust to missing
  /// directories: an absent tree or an unreadable folder contributes no keys
  /// instead of throwing.
  Future<Set<String>> downloadedMangaKeys(
      Iterable<({String sourceId, String url, String title})> entries) async {
    final result = <String>{};
    final list = entries.toList();
    if (list.isEmpty) return result;

    final base = await getBasePath();

    // Collect the names of existing, non-empty title folders across every
    // content-type folder in the library section.
    final present = <String>{};
    for (final type in _kindFolders) {
      final typeDir = Directory('$base/library/$type');
      if (!await typeDir.exists()) continue;
      try {
        await for (final child in typeDir.list(followLinks: false)) {
          if (child is! Directory) continue;
          final name = child.path.split('/').last.split('\\').last;
          // Non-empty = holds at least one chapter folder / episode / packed file.
          final empty = await child.list(followLinks: false).isEmpty;
          if (!empty) present.add(name);
        }
      } catch (_) {
        // Unreadable type directory - skip it rather than fail the scan.
        continue;
      }
    }
    if (present.isEmpty) return result;

    for (final e in list) {
      if (present.contains(_titleFolder(e.title, e.sourceId))) {
        result.add('${e.sourceId}::${e.url}');
      }
    }
    return result;
  }

  /// Given a manga/anime/novel's chapters, return the subset of chapter URLs
  /// that are already downloaded on disk (library OR vault) - a non-empty
  /// chapter folder (images or a novel's content.html) or a packed .cbz/.pdf
  /// sibling file. Used to re-detect downloads the app made before its tracking
  /// set was lost (e.g. a reinstall or data wipe keeps the files but clears the
  /// SharedPreferences index), so chapter checkmarks come back on their own.
  Future<Set<String>> downloadedChapterUrls(
    String sourceId,
    String mangaTitle,
    Iterable<({String url, String name})> chapters,
  ) async {
    final chapterList = chapters.toList();
    if (chapterList.isEmpty) return {};

    final base = await getBasePath();
    final titleDir = _titleFolder(mangaTitle, sourceId);

    // Chapter name (sanitized) → downloaded. A chapter is downloaded as a
    // non-empty folder (manga images / novel content.html) or a sibling file
    // (packed .cbz/.pdf, or an anime episode .mp4/.mkv/.ts/.webm). Type isn't
    // known here, so scan every type folder in both sections.
    final downloaded = <String>{};
    for (final section in const ['library', 'vault']) {
      for (final type in _kindFolders) {
        final dir = Directory('$base/$section/$type/$titleDir');
        if (!await dir.exists()) continue;
        try {
          await for (final child in dir.list(followLinks: false)) {
            final name = child.path.split('/').last.split('\\').last;
            if (child is Directory) {
              final empty = await child.list(followLinks: false).isEmpty;
              if (!empty) downloaded.add(name);
            } else if (child is File) {
              final dot = name.lastIndexOf('.');
              if (dot < 0) continue;
              final ext = name.substring(dot + 1).toLowerCase();
              if (const ['cbz', 'pdf', 'mp4', 'mkv', 'ts', 'webm']
                  .contains(ext)) {
                downloaded.add(name.substring(0, dot));
              }
            }
          }
        } catch (_) {
          // Unreadable directory - skip this type/section.
        }
      }
    }
    if (downloaded.isEmpty) return {};

    final result = <String>{};
    for (final ch in chapterList) {
      if (downloaded.contains(_sanitize(ch.name))) result.add(ch.url);
    }
    return result;
  }

  /// One-time migration from the old `<section>/<sourceId>/<title>/…` layout to
  /// the readable `<section>/<Type>/<Title (sourceId)>/…` layout. The content
  /// type is inferred from each title folder's contents (media files → anime,
  /// chapter folders with content.html → novel, else manga). Idempotent: the
  /// new type folders (Manga/Anime/Light Novels) are skipped, and an existing
  /// destination is merged into rather than overwritten, so interrupting and
  /// re-running it is safe. Only old numeric-sourceId folders are touched, so it
  /// never conflicts with freshly-created downloads.
  Future<void> migrateDownloadLayout() async {
    final base = await getBasePath();
    for (final section in const ['library', 'vault']) {
      final sectionDir = Directory('$base/$section');
      if (!await sectionDir.exists()) continue;

      List<FileSystemEntity> sources;
      try {
        sources = await sectionDir.list(followLinks: false).toList();
      } catch (_) {
        continue;
      }

      for (final sourceEntity in sources) {
        if (sourceEntity is! Directory) continue;
        final sourceId = sourceEntity.path.split('/').last.split('\\').last;
        if (_kindFolders.contains(sourceId)) continue; // already-new folder

        List<FileSystemEntity> titles;
        try {
          titles = await sourceEntity.list(followLinks: false).toList();
        } catch (_) {
          continue;
        }

        for (final titleEntity in titles) {
          if (titleEntity is! Directory) continue;
          final titleName = titleEntity.path.split('/').last.split('\\').last;
          final kind = await _detectKind(titleEntity);
          final destParent = Directory('$base/$section/${_kindFolder(kind)}');
          await destParent.create(recursive: true);
          final dest = Directory('${destParent.path}/$titleName ($sourceId)');
          try {
            if (!await dest.exists()) {
              await titleEntity.rename(dest.path); // same fs → fast move
            } else {
              // Merge: move each child that doesn't already exist, then drop
              // the emptied old folder.
              await for (final child
                  in titleEntity.list(followLinks: false)) {
                final childName =
                    child.path.split('/').last.split('\\').last;
                final target = '${dest.path}/$childName';
                if (!await Directory(target).exists() &&
                    !await File(target).exists()) {
                  await child.rename(target);
                }
              }
              if (await titleEntity.list(followLinks: false).isEmpty) {
                await titleEntity.delete();
              }
            }
          } catch (e) {
            debugPrint('[Download] layout migration failed for "$titleName": $e');
          }
        }

        // Remove the old numeric source folder once its titles have moved.
        try {
          if (await sourceEntity.list(followLinks: false).isEmpty) {
            await sourceEntity.delete();
          }
        } catch (_) {}
      }
    }
  }

  /// Infer a downloaded title folder's content type from its contents.
  Future<DownloadKind> _detectKind(Directory titleDir) async {
    var hasNovel = false;
    try {
      await for (final child in titleDir.list(followLinks: false)) {
        final name = child.path.split('/').last.split('\\').last;
        if (child is File) {
          final dot = name.lastIndexOf('.');
          final ext = dot >= 0 ? name.substring(dot + 1).toLowerCase() : '';
          if (const ['mp4', 'mkv', 'ts', 'webm'].contains(ext)) {
            return DownloadKind.anime; // a media file → anime episodes
          }
        } else if (child is Directory) {
          if (await File('${child.path}/content.html').exists()) {
            hasNovel = true; // a chapter folder with HTML → novel
          }
        }
      }
    } catch (_) {}
    return hasNovel ? DownloadKind.novel : DownloadKind.manga;
  }

  /// Get total download size in bytes for library, vault, or both.
  Future<int> getTotalSize({bool? isVault}) async {
    final base = await getBasePath();
    final dirs = <String>[];
    if (isVault == null || !isVault) dirs.add('$base/library');
    if (isVault == null || isVault) dirs.add('$base/vault');

    int total = 0;
    for (final dirPath in dirs) {
      final dir = Directory(dirPath);
      if (!await dir.exists()) continue;
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          total += await entity.length();
        }
      }
    }
    return total;
  }
}
