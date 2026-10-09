import 'package:hive/hive.dart';

class LibraryManga extends HiveObject {
  String sourceId;
  String url;
  String title;
  String coverUrl;
  String? author;
  String? description;
  List<String> genres;
  String status; // ongoing, completed, hiatus, canceled, unknown
  DateTime addedAt;
  DateTime? lastReadAt;
  String? lastReadChapterUrl;
  int lastReadPage;
  int totalChapters;
  int readChapters;
  List<String> categories;

  /// When this entry's chapter list was last fetched from its source.
  /// Nullable because entries saved before this field existed have no value
  /// (Hive returns null for an absent field, so old records still read).
  DateTime? lastChapterFetchAt;

  // ── Content-type separation (added post-v1) ──────────────────────────────
  // Each media type keeps its progress in its OWN field, so a stored number is
  // never ambiguous (manga=page, anime=seconds, novel=offset+fraction). Entries
  // saved before this split have these absent (null/0); the readers fall back to
  // [lastReadPage] for those, which used to hold the per-type value. [lastReadPage]
  // stays as manga's page index AND that legacy fallback.

  /// 'manga' | 'anime' | 'novel'. The durable per-entry type, set when the entry
  /// is added to the library. Null on pre-migration records — resolve from the
  /// source's itemType when null (see [LibraryManga] callers / contentTypeOr).
  String? contentType;

  /// Anime: resume position, in whole seconds.
  int lastWatchSeconds;

  /// Anime: total episode duration, in seconds (for "% watched"). 0 = unknown.
  int totalSeconds;

  /// Novel: exact scroll/char offset for pixel-accurate restore when nothing
  /// about the layout changed.
  int novelProgressOffset;

  /// Novel: 0.0–1.0 fraction through the chapter — reflow-safe resume that
  /// survives font-size / reader-width changes (offset alone drifts when the
  /// text reflows).
  double novelProgressFraction;

  /// The source's browsable page URL ("Open in browser"), cached from the last
  /// getDetail so a cold-start "Open in WebView" is instant instead of waiting
  /// for the embedded JVM to boot + re-resolve it (see MManga.webUrl).
  String? webUrl;

  LibraryManga({
    required this.sourceId,
    required this.url,
    required this.title,
    required this.coverUrl,
    this.author,
    this.description,
    this.genres = const [],
    this.status = 'unknown',
    DateTime? addedAt,
    this.lastReadAt,
    this.lastReadChapterUrl,
    this.lastReadPage = 0,
    this.totalChapters = 0,
    this.readChapters = 0,
    this.categories = const [],
    this.lastChapterFetchAt,
    this.contentType,
    this.lastWatchSeconds = 0,
    this.totalSeconds = 0,
    this.novelProgressOffset = 0,
    this.novelProgressFraction = 0.0,
    this.webUrl,
  }) : addedAt = addedAt ?? DateTime.now();

  String get uniqueKey => '${sourceId}_$url';

  /// The stored [contentType], or [fallback] when this is a pre-migration record
  /// that never stored one (resolve [fallback] from the source's itemType).
  String contentTypeOr(String fallback) =>
      (contentType == null || contentType!.isEmpty) ? fallback : contentType!;

  /// Effective anime resume position (seconds): the typed field, falling back to
  /// the legacy overloaded lastReadPage for entries saved before the split.
  int get watchSecondsOr => lastWatchSeconds != 0 ? lastWatchSeconds : lastReadPage;

  /// Effective novel scroll offset, same legacy fallback as [watchSecondsOr].
  int get novelOffsetOr =>
      novelProgressOffset != 0 ? novelProgressOffset : lastReadPage;

  /// A detached copy (not bound to any Hive box). Needed to move an entry
  /// between boxes: Hive forbids putting the same HiveObject instance into two
  /// boxes ("cannot be stored in two different boxes").
  LibraryManga clone() => LibraryManga(
        sourceId: sourceId,
        url: url,
        title: title,
        coverUrl: coverUrl,
        author: author,
        description: description,
        genres: List<String>.from(genres),
        status: status,
        addedAt: addedAt,
        lastReadAt: lastReadAt,
        lastReadChapterUrl: lastReadChapterUrl,
        lastReadPage: lastReadPage,
        totalChapters: totalChapters,
        readChapters: readChapters,
        categories: List<String>.from(categories),
        lastChapterFetchAt: lastChapterFetchAt,
        contentType: contentType,
        lastWatchSeconds: lastWatchSeconds,
        totalSeconds: totalSeconds,
        novelProgressOffset: novelProgressOffset,
        novelProgressFraction: novelProgressFraction,
      );
}

class LibraryMangaAdapter extends TypeAdapter<LibraryManga> {
  @override
  final int typeId = 0;

  @override
  LibraryManga read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return LibraryManga(
      sourceId: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      coverUrl: fields[3] as String,
      author: fields[4] as String?,
      description: fields[5] as String?,
      genres: (fields[6] as List?)?.cast<String>() ?? [],
      status: fields[7] as String? ?? 'unknown',
      addedAt: fields[8] as DateTime?,
      lastReadAt: fields[9] as DateTime?,
      lastReadChapterUrl: fields[10] as String?,
      lastReadPage: fields[11] as int? ?? 0,
      totalChapters: fields[12] as int? ?? 0,
      readChapters: fields[13] as int? ?? 0,
      categories: (fields[14] as List?)?.cast<String>() ?? [],
      // Field 15 was added later — absent on older records, hence null-safe.
      lastChapterFetchAt: fields[15] as DateTime?,
      // Fields 16-20: content-type split (post-v1). Absent on older records.
      contentType: fields[16] as String?,
      lastWatchSeconds: fields[17] as int? ?? 0,
      totalSeconds: fields[18] as int? ?? 0,
      novelProgressOffset: fields[19] as int? ?? 0,
      novelProgressFraction: (fields[20] as num?)?.toDouble() ?? 0.0,
      // Field 21 — cached browsable URL (post-1.2). Absent on older records.
      webUrl: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryManga obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.sourceId)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.coverUrl)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.genres)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.addedAt)
      ..writeByte(9)
      ..write(obj.lastReadAt)
      ..writeByte(10)
      ..write(obj.lastReadChapterUrl)
      ..writeByte(11)
      ..write(obj.lastReadPage)
      ..writeByte(12)
      ..write(obj.totalChapters)
      ..writeByte(13)
      ..write(obj.readChapters)
      ..writeByte(14)
      ..write(obj.categories)
      ..writeByte(15)
      ..write(obj.lastChapterFetchAt)
      ..writeByte(16)
      ..write(obj.contentType)
      ..writeByte(17)
      ..write(obj.lastWatchSeconds)
      ..writeByte(18)
      ..write(obj.totalSeconds)
      ..writeByte(19)
      ..write(obj.novelProgressOffset)
      ..writeByte(20)
      ..write(obj.novelProgressFraction)
      ..writeByte(21)
      ..write(obj.webUrl);
  }
}
