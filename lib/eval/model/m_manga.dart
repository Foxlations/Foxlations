import 'm_chapter.dart';

enum MangaStatus {
  ongoing,
  completed,
  onHiatus,
  canceled,
  publishingFinished,
  unknown,
}

class MManga {
  String? name;
  String? link;
  String? imageUrl;
  String? description;
  String? author;
  String? artist;
  MangaStatus? status;
  List<String>? genre;
  List<MChapter>? chapters;

  /// The source's own browsable page URL for this item ("Open in browser").
  /// For Tachiyomi this is `getMangaUrl()`/`getAnimeUrl()`, for LNReader the
  /// plugin's `resolveUrl()` - which can differ from `baseUrl + link` when a
  /// source fetches details from an API. Null when the source didn't provide
  /// one (the app then falls back to joining [link] onto the base URL).
  String? webUrl;

  MManga({
    this.name,
    this.link,
    this.imageUrl,
    this.description,
    this.author,
    this.artist,
    this.status = MangaStatus.unknown,
    this.genre,
    this.chapters,
    this.webUrl,
  });

  factory MManga.fromJson(Map<String, dynamic> json) {
    return MManga(
      name: json['name'] as String?,
      link: json['link'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      author: json['author'] as String?,
      artist: json['artist'] as String?,
      webUrl: (json['webUrl'] as String?)?.isNotEmpty == true
          ? json['webUrl'] as String?
          : null,
      status: switch (json['status'] as int?) {
        0 => MangaStatus.ongoing,
        1 => MangaStatus.completed,
        2 => MangaStatus.onHiatus,
        3 => MangaStatus.canceled,
        4 => MangaStatus.publishingFinished,
        _ => MangaStatus.unknown,
      },
      genre: (json['genre'] as List?)?.map((e) => e.toString()).toList() ?? [],
      chapters: (json['chapters'] as List?)
              ?.map((e) => MChapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'imageUrl': imageUrl,
        'description': description,
        'author': author,
        'artist': artist,
        'status': status?.index ?? 5,
        'genre': genre,
        'webUrl': webUrl,
        'chapters': chapters?.map((c) => c.toJson()).toList() ?? [],
      };
}
