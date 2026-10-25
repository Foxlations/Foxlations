class MChapter {
  String? name;
  String? url;
  String? dateUpload;
  String? scanlator;

  /// Source-provided chapter number, when the extension supplies one (LNReader
  /// plugins and Tachiyomi/Aniyomi `SChapter.chapter_number`). This is the
  /// RELIABLE reading-sequence key the readers order by - far more trustworthy
  /// than parsing it out of the name/url. Null when the source doesn't give one.
  double? chapterNumber;

  MChapter({
    this.name,
    this.url,
    this.dateUpload,
    this.scanlator,
    this.chapterNumber,
  });

  factory MChapter.fromJson(Map<String, dynamic> json) {
    return MChapter(
      name: json['name'] as String?,
      url: json['url'] as String?,
      dateUpload: json['dateUpload']?.toString(),
      scanlator: json['scanlator'] as String?,
      chapterNumber: (json['chapterNumber'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'dateUpload': dateUpload,
        'scanlator': scanlator,
        'chapterNumber': chapterNumber,
      };
}
