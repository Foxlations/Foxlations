import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
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

  /// Drop the cached HTTP client so the next download rebuilds it — used when
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

  /// Get the directory path for a chapter's downloaded images.
  /// [isVault] separates vault downloads from library downloads.
  Future<String> getChapterDir(
      String sourceId, String mangaTitle, String chapterName,
      {bool isVault = false}) async {
    final base = await getBasePath();
    final section = isVault ? 'vault' : 'library';
    final sanitizedManga = _sanitize(mangaTitle);
    final sanitizedChapter = _sanitize(chapterName);
    return '$base/$section/$sourceId/$sanitizedManga/$sanitizedChapter';
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
    // folder — so a packed chapter has no loose images but is still downloaded.
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
    // Packed into a sibling .cbz/.pdf — unpack via the local-source reader
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
  /// or null if it was never converted. See [convertToCbz]/[convertToPdf] — the
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
        isVault: isVault);
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
        isVault: isVault);
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
    // for every page — build them ONCE instead of per image.
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

      // Download with retry (isolated per page — a flaky page's backoff no
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

    // Page images are plain HTTP GETs (no source/JVM/JS call — the page list was
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
          'Download: $failed/${imageUrls.length} pages failed — "$chapterName"',
          category: LogCategory.network, detail: 'Source: $sourceId');
    }
    return failed == 0;
  }

  /// Delete a downloaded chapter (folder or CBZ file).
  Future<void> deleteChapter(
      String sourceId, String mangaTitle, String chapterName,
      {bool isVault = false}) async {
    // Try deleting the image folder
    final dir = await getChapterDir(sourceId, mangaTitle, chapterName, isVault: isVault);
    final d = Directory(dir);
    if (await d.exists()) {
      await d.delete(recursive: true);
      debugPrint('[Download] Deleted folder: $dir');
      return;
    }

    // Try deleting a packaged CBZ/PDF file
    final base = await getBasePath();
    final section = isVault ? 'vault' : 'library';
    final mangaDir = '$base/$section/$sourceId/${_sanitize(mangaTitle)}';
    for (final ext in ['cbz', 'pdf']) {
      final packedPath = '$mangaDir/${_sanitize(chapterName)}.$ext';
      final packedFile = File(packedPath);
      if (await packedFile.exists()) {
        await packedFile.delete();
        debugPrint('[Download] Deleted ${ext.toUpperCase()}: $packedPath');
        return;
      }
    }

    // Also try both vault and library if isVault wasn't specified correctly
    for (final sec in ['library', 'vault']) {
      final tryDir = '$base/$sec/$sourceId/${_sanitize(mangaTitle)}/${_sanitize(chapterName)}';
      if (await Directory(tryDir).exists()) {
        await Directory(tryDir).delete(recursive: true);
        debugPrint('[Download] Deleted folder (found in $sec): $tryDir');
        return;
      }
      for (final ext in ['cbz', 'pdf']) {
        final tryPacked = '$tryDir.$ext';
        if (await File(tryPacked).exists()) {
          await File(tryPacked).delete();
          debugPrint('[Download] Deleted ${ext.toUpperCase()} (found in $sec): $tryPacked');
          return;
        }
      }
    }

    debugPrint('[Download] Nothing found to delete for "$chapterName" (source: $sourceId, manga: $mangaTitle)');
  }

  /// Delete all downloads for a manga.
  Future<void> deleteManga(String sourceId, String mangaTitle,
      {bool isVault = false}) async {
    final base = await getBasePath();
    final section = isVault ? 'vault' : 'library';
    final dir = Directory('$base/$section/$sourceId/${_sanitize(mangaTitle)}');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
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

    final base = await getBasePath();
    final section = isVault ? 'vault' : 'library';
    final mangaDir = '$base/$section/$sourceId/${_sanitize(mangaTitle)}';
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

    final doc = pw.Document();
    int pageCount = 0;

    for (final imgFile in images) {
      final raw = await File(imgFile.path).readAsBytes();
      // The PDF `MemoryImage` only accepts JPEG/PNG. Downloaded pages are named
      // .jpg but may actually be webp/gif bytes, so decode + re-encode to JPEG
      // to guarantee a valid, embeddable image and known dimensions.
      final normalized = _toJpegForPdf(raw);
      if (normalized == null) {
        debugPrint('[Download] Skipping undecodable page: ${imgFile.path}');
        continue;
      }
      final memImage = pw.MemoryImage(normalized.bytes);
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            normalized.width.toDouble(),
            normalized.height.toDouble(),
          ),
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Center(
            child: pw.Image(memImage, fit: pw.BoxFit.contain),
          ),
        ),
      );
      pageCount++;
    }

    if (pageCount == 0) return null;

    final base = await getBasePath();
    final section = isVault ? 'vault' : 'library';
    final mangaDir = '$base/$section/$sourceId/${_sanitize(mangaTitle)}';
    final pdfPath = '$mangaDir/${_sanitize(chapterName)}.pdf';
    final bytes = await doc.save();
    await File(pdfPath).writeAsBytes(bytes);

    if (deleteFolder) await d.delete(recursive: true);

    debugPrint('[Download] Created PDF: $pdfPath (${(bytes.length / 1024).toStringAsFixed(0)} KB, $pageCount pages)');
    return pdfPath;
  }

  /// Decode arbitrary image bytes and re-encode as JPEG for PDF embedding.
  /// Returns the JPEG bytes plus pixel dimensions, or null if undecodable.
  ({Uint8List bytes, int width, int height})? _toJpegForPdf(Uint8List raw) {
    final decoded = img.decodeImage(raw);
    if (decoded == null) return null;
    final jpg = img.encodeJpg(decoded, quality: 90);
    return (bytes: jpg, width: decoded.width, height: decoded.height);
  }

  /// Get the directory path for an anime series' downloaded episodes.
  Future<String> getAnimeDir(String sourceId, String animeTitle) async {
    final base = await getBasePath();
    return '$base/library/$sourceId/${_sanitize(animeTitle)}';
  }

  /// Check if an episode is downloaded.
  Future<bool> isEpisodeDownloaded(
      String sourceId, String animeTitle, String episodeName) async {
    final dir = await getAnimeDir(sourceId, animeTitle);
    final name = _sanitize(episodeName);
    for (final ext in ['mp4', 'mkv', 'ts', 'webm']) {
      if (await File('$dir/$name.$ext').exists()) return true;
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
    return null;
  }

  /// Download an anime episode. Handles direct video URLs and HLS (.m3u8).
  /// Progress callback receives (bytesReceived, totalBytes) — total is -1 for
  /// HLS until the segment count is known, then switches to (segmentsDone, segmentsTotal).
  Future<bool> downloadEpisode({
    required String sourceId,
    required String animeTitle,
    required String episodeName,
    required String videoUrl,
    Map<String, String> headers = const {},
    void Function(int received, int total)? onProgress,
  }) async {
    final dir = await getAnimeDir(sourceId, animeTitle);
    await Directory(dir).create(recursive: true);
    final name = _sanitize(episodeName);

    if (videoUrl.contains('.m3u8')) {
      return _downloadHls(videoUrl, dir, name, headers, onProgress);
    } else {
      final ext = _videoExtension(videoUrl);
      return _downloadDirect(videoUrl, '$dir/$name.$ext', headers, onProgress);
    }
  }

  String _videoExtension(String url) {
    final path = Uri.tryParse(url)?.path ?? url;
    final ext = path.split('.').last.toLowerCase().split('?').first;
    const known = {'mp4', 'mkv', 'webm', 'avi', 'mov', 'ts'};
    return known.contains(ext) ? ext : 'mp4';
  }

  /// Download a direct video file using Dio (streams to disk, tracks progress).
  Future<bool> _downloadDirect(
    String url,
    String savePath,
    Map<String, String> headers,
    void Function(int, int)? onProgress,
  ) async {
    if (await File(savePath).exists()) return true;
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
      await dio.download(
        url,
        savePath,
        onReceiveProgress: onProgress,
      );
      return await File(savePath).exists();
    } catch (e) {
      debugPrint('[Download] Direct video failed: $e');
      await logger.error('Episode download failed',
          category: LogCategory.network, detail: '$url\n$e');
      return false;
    } finally {
      dio.close();
    }
  }

  /// Download an HLS stream by fetching all .ts segments and concatenating.
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

    try {
      // Fetch the playlist
      final playlistRes = await dio.get<String>(m3u8Url);
      var playlist = playlistRes.data ?? '';

      // If master playlist (has #EXT-X-STREAM-INF), pick the first variant
      if (playlist.contains('#EXT-X-STREAM-INF')) {
        final variantLine = playlist
            .split('\n')
            .firstWhere((l) => l.trim().isNotEmpty && !l.startsWith('#'),
                orElse: () => '');
        if (variantLine.isEmpty) return false;
        final variantUrl = variantLine.startsWith('http')
            ? variantLine.trim()
            : '${m3u8Url.substring(0, m3u8Url.lastIndexOf('/') + 1)}${variantLine.trim()}';
        final variantRes = await dio.get<String>(variantUrl);
        playlist = variantRes.data ?? '';
        m3u8Url = variantUrl;
      }

      // Collect segment URLs
      final base = m3u8Url.substring(0, m3u8Url.lastIndexOf('/') + 1);
      final segments = playlist
          .split('\n')
          .where((l) => l.trim().isNotEmpty && !l.startsWith('#'))
          .map((l) => l.trim().startsWith('http') ? l.trim() : '$base${l.trim()}')
          .toList();

      if (segments.isEmpty) return false;
      onProgress?.call(0, segments.length);

      // Download segments and concatenate into a single .ts file
      final outFile = File(savePath).openWrite(mode: FileMode.writeOnly);
      int done = 0;
      for (final seg in segments) {
        try {
          final segRes = await dio.get<List<int>>(
            seg,
            options: Options(responseType: ResponseType.bytes),
          );
          if (segRes.data != null) outFile.add(segRes.data!);
        } catch (e) {
          debugPrint('[Download] HLS segment failed: $seg — $e');
        }
        done++;
        onProgress?.call(done, segments.length);
      }
      await outFile.close();
      return await File(savePath).exists();
    } catch (e) {
      debugPrint('[Download] HLS download failed: $e');
      await logger.error('Episode (HLS) download failed',
          category: LogCategory.network, detail: '$m3u8Url\n$e');
      return false;
    } finally {
      dio.close();
    }
  }

  String _xmlEscape(String s) =>
      s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

  /// Returns the set of '{sourceId}::{url}' for library entries that have at
  /// least one downloaded chapter folder on disk. Scans each source directory
  /// once, so passing the whole library is cheap.
  ///
  /// Only the normal library section is scanned (`isVault: false`) — the
  /// library screen's "Downloaded" filter is for the normal library. Robust to
  /// missing directories: an absent base/library tree, or an unreadable source
  /// folder, simply contributes no keys instead of throwing.
  Future<Set<String>> downloadedMangaKeys(
      Iterable<({String sourceId, String url, String title})> entries) async {
    final result = <String>{};
    final list = entries.toList();
    if (list.isEmpty) return result;

    final base = await getBasePath();

    // Group entries by source so each source directory is listed exactly once.
    final bySource =
        <String, List<({String sourceId, String url, String title})>>{};
    for (final e in list) {
      bySource.putIfAbsent(e.sourceId, () => []).add(e);
    }

    for (final entry in bySource.entries) {
      final sourceDir = Directory('$base/library/${entry.key}');
      if (!await sourceDir.exists()) continue;

      // Collect the names of existing, non-empty manga folders in this source.
      final nonEmptyFolders = <String>{};
      try {
        await for (final child in sourceDir.list(followLinks: false)) {
          if (child is! Directory) continue;
          final name = child.path.split('/').last.split('\\').last;
          // Non-empty = contains at least one sub-entry (chapter folder or
          // packed CBZ/PDF).
          final empty = await child.list(followLinks: false).isEmpty;
          if (!empty) nonEmptyFolders.add(name);
        }
      } catch (_) {
        // Unreadable source directory — skip it rather than fail the scan.
        continue;
      }

      for (final e in entry.value) {
        if (nonEmptyFolders.contains(_sanitize(e.title))) {
          result.add('${e.sourceId}::${e.url}');
        }
      }
    }

    return result;
  }

  /// Given a manga/anime/novel's chapters, return the subset of chapter URLs
  /// that are already downloaded on disk (library OR vault) — a non-empty
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
    final sanitizedManga = _sanitize(mangaTitle);

    final folders = <String>{}; // non-empty chapter folders (sanitized names)
    final packed = <String>{}; // packed chapter files, sanitized name w/o ext
    for (final section in const ['library', 'vault']) {
      final mangaDir = Directory('$base/$section/$sourceId/$sanitizedManga');
      if (!await mangaDir.exists()) continue;
      try {
        await for (final child in mangaDir.list(followLinks: false)) {
          final name = child.path.split('/').last.split('\\').last;
          if (child is Directory) {
            final empty = await child.list(followLinks: false).isEmpty;
            if (!empty) folders.add(name);
          } else if (child is File) {
            final dot = name.lastIndexOf('.');
            final ext = dot >= 0 ? name.substring(dot + 1).toLowerCase() : '';
            if (ext == 'cbz' || ext == 'pdf') {
              packed.add(name.substring(0, dot));
            }
          }
        }
      } catch (_) {
        // Unreadable manga directory — skip this section.
      }
    }
    if (folders.isEmpty && packed.isEmpty) return {};

    final result = <String>{};
    for (final ch in chapterList) {
      final s = _sanitize(ch.name);
      if (folders.contains(s) || packed.contains(s)) result.add(ch.url);
    }
    return result;
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
