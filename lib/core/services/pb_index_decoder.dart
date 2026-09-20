import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Decodes a keiyoushi/Mihon "ExtensionStore" `index.pb` (gzip-compressed
/// protobuf — the compact index, ~13x smaller than index.json) into the SAME
/// Map that `jsonDecode(index.json)` yields, so the existing repo-index parser
/// (RepoService._parseIndex → MangaSource.fromJson) consumes it unchanged.
///
/// Wire schema (keiyoushi/extensions-source .github/scripts/index.proto, itself
/// from mihonapp/tachiyomix index/index.proto):
///   Index         { name=1, badgeLabel=2, signingKey=3, contact=4,
///                   extensionList=101, extensionListUrl=102 }
///   Contact       { website=1, discord=2 }
///   ExtensionList { extensions=1 (repeated) }
///   Extension     { name=1, packageName=2, resources=3, extensionLib=4,
///                   versionCode=5 (int64), versionName=6,
///                   contentWarning=7 (enum), sources=8 (repeated) }
///   Resources     { apkUrl=1, iconUrl=2, jarUrl=501 }
///   Source        { id=1 (int64), name=2, language=3, homeUrl=4,
///                   mirrorUrls=5 (repeated), message=7 }
///   ContentWarning enum: 0 UNSPECIFIED, 1 SAFE, 2 MIXED, 3 NSFW
/// int64 fields are surfaced as strings and the enum as its name — matching
/// protobuf-JSON — so the output is byte-compatible with index.json. NOTE:
/// jarUrl lives at the unusual field 501 (Mihon's own model omits it; we need
/// it for JVM `.jar` extensions).
///
/// Returns null (so the caller falls back to index.json) if the bytes aren't a
/// usable index — bad gzip/protobuf, or the `extensionListUrl` form (a pointer
/// to a separate list) rather than an embedded, non-empty `extensionList`.
Map<String, dynamic>? decodePbIndex(List<int> raw) {
  try {
    var bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
    // index.pb is gzip inside the body (no Content-Encoding), so inflate it.
    if (bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b) {
      bytes = Uint8List.fromList(GZipDecoder().decodeBytes(bytes));
    }
    final index = _decodeIndex(bytes);
    final el = index['extensionList'];
    if (el is! Map ||
        el['extensions'] is! List ||
        (el['extensions'] as List).isEmpty) {
      return null; // empty, or the extensionListUrl form → use the JSON path
    }
    return index;
  } catch (_) {
    return null;
  }
}

const _warnNames = <int, String>{
  0: 'CONTENT_WARNING_UNSPECIFIED',
  1: 'CONTENT_WARNING_SAFE',
  2: 'CONTENT_WARNING_MIXED',
  3: 'CONTENT_WARNING_NSFW',
};

/// Minimal protobuf wire reader (varint + length-delimited; the schema uses no
/// fixed32/64 or packed fields).
class _Reader {
  final Uint8List b;
  int pos = 0;
  final int end;
  _Reader(this.b) : end = b.length;

  bool get hasMore => pos < end;

  int varint() {
    var result = 0, shift = 0;
    while (true) {
      final byte = b[pos++];
      result |= (byte & 0x7f) << shift;
      if ((byte & 0x80) == 0) return result;
      shift += 7;
    }
  }

  String str() {
    final len = varint();
    final s = pos;
    pos += len;
    return utf8.decode(Uint8List.sublistView(b, s, pos), allowMalformed: true);
  }

  Uint8List sub() {
    final len = varint();
    final s = pos;
    pos += len;
    return Uint8List.sublistView(b, s, pos);
  }

  void skip(int wire) {
    switch (wire) {
      case 0:
        varint();
        break;
      case 1:
        pos += 8;
        break;
      case 2:
        pos += varint();
        break;
      case 5:
        pos += 4;
        break;
      default:
        throw const FormatException('bad protobuf wire type');
    }
  }
}

Map<String, dynamic> _decodeIndex(Uint8List b) {
  final r = _Reader(b);
  final m = <String, dynamic>{};
  while (r.hasMore) {
    final tag = r.varint();
    switch (tag >> 3) {
      case 1:
        m['name'] = r.str();
        break;
      case 2:
        m['badgeLabel'] = r.str();
        break;
      case 3:
        m['signingKey'] = r.str();
        break;
      case 4:
        m['contact'] = _decodeContact(r.sub());
        break;
      case 101:
        m['extensionList'] = _decodeExtensionList(r.sub());
        break;
      case 102:
        m['extensionListUrl'] = r.str();
        break;
      default:
        r.skip(tag & 7);
    }
  }
  return m;
}

Map<String, dynamic> _decodeContact(Uint8List b) {
  final r = _Reader(b);
  final m = <String, dynamic>{};
  while (r.hasMore) {
    final tag = r.varint();
    switch (tag >> 3) {
      case 1:
        m['website'] = r.str();
        break;
      case 2:
        m['discord'] = r.str();
        break;
      default:
        r.skip(tag & 7);
    }
  }
  return m;
}

Map<String, dynamic> _decodeExtensionList(Uint8List b) {
  final r = _Reader(b);
  final exts = <dynamic>[];
  while (r.hasMore) {
    final tag = r.varint();
    if (tag >> 3 == 1) {
      exts.add(_decodeExtension(r.sub()));
    } else {
      r.skip(tag & 7);
    }
  }
  return {'extensions': exts};
}

Map<String, dynamic> _decodeExtension(Uint8List b) {
  final r = _Reader(b);
  final m = <String, dynamic>{};
  final sources = <dynamic>[];
  while (r.hasMore) {
    final tag = r.varint();
    switch (tag >> 3) {
      case 1:
        m['name'] = r.str();
        break;
      case 2:
        m['packageName'] = r.str();
        break;
      case 3:
        m['resources'] = _decodeResources(r.sub());
        break;
      case 4:
        m['extensionLib'] = r.str();
        break;
      case 5:
        m['versionCode'] = r.varint().toString(); // int64 → string
        break;
      case 6:
        m['versionName'] = r.str();
        break;
      case 7:
        m['contentWarning'] =
            _warnNames[r.varint()] ?? 'CONTENT_WARNING_UNSPECIFIED';
        break;
      case 8:
        sources.add(_decodeSource(r.sub()));
        break;
      default:
        r.skip(tag & 7);
    }
  }
  if (sources.isNotEmpty) m['sources'] = sources;
  return m;
}

Map<String, dynamic> _decodeResources(Uint8List b) {
  final r = _Reader(b);
  final m = <String, dynamic>{};
  while (r.hasMore) {
    final tag = r.varint();
    switch (tag >> 3) {
      case 1:
        m['apkUrl'] = r.str();
        break;
      case 2:
        m['iconUrl'] = r.str();
        break;
      case 501:
        m['jarUrl'] = r.str();
        break;
      default:
        r.skip(tag & 7);
    }
  }
  return m;
}

Map<String, dynamic> _decodeSource(Uint8List b) {
  final r = _Reader(b);
  final m = <String, dynamic>{};
  final mirrors = <dynamic>[];
  while (r.hasMore) {
    final tag = r.varint();
    switch (tag >> 3) {
      case 1:
        m['id'] = r.varint().toString(); // int64 → string
        break;
      case 2:
        m['name'] = r.str();
        break;
      case 3:
        m['language'] = r.str();
        break;
      case 4:
        m['homeUrl'] = r.str();
        break;
      case 5:
        mirrors.add(r.str());
        break;
      case 7:
        m['message'] = r.str();
        break;
      default:
        r.skip(tag & 7);
    }
  }
  if (mirrors.isNotEmpty) m['mirrorUrls'] = mirrors;
  return m;
}
