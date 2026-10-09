import '../../eval/model/m_manga.dart';

/// Keep only search results whose title actually matches [query].
///
/// Many source `search()` implementations silently fall back to a popular /
/// browse listing when the site ignores the query parameter (e.g. Next.js
/// static browse endpoints, or APIs that only honor a `sort`). Without this the
/// UI shows unrelated "popular" titles as if they were search hits.
///
/// A result matches if its title contains the whole query, or contains every
/// (2+ char) query word. Case-insensitive. Empty query → returned unchanged.
List<MManga> filterSearchResults(List<MManga> list, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty || list.isEmpty) return list;
  final words = q.split(RegExp(r'\s+')).where((w) => w.length > 1).toList();
  return list.where((m) {
    final n = (m.name ?? '').toLowerCase();
    if (n.isEmpty) return false;
    if (n.contains(q)) return true;
    return words.isNotEmpty && words.every((w) => n.contains(w));
  }).toList();
}

/// Approximate variant of [filterSearchResults]: tolerant of word-order,
/// filler-word and minor-typo differences (so "I'm destined to greatness" still
/// finds "I'm Destined For Greatness"), and returns the matches sorted by
/// relevance (best first).
///
/// A title matches if it contains the whole query, OR at least ~60% of the
/// query's (2+ char) words appear — each either as a substring or within edit
/// distance 1 of a title word. Punctuation is ignored.
List<MManga> approxFilterSearchResults(List<MManga> list, String query) {
  final q = _normalizeSearch(query);
  if (q.isEmpty || list.isEmpty) return list;
  final qWords = q.split(' ').where((w) => w.length > 1).toList();
  if (qWords.isEmpty) return list;

  final scored = <MapEntry<MManga, double>>[];
  for (final m in list) {
    final name = _normalizeSearch(m.name ?? '');
    if (name.isEmpty) continue;
    final score = _matchScore(name, q, qWords);
    if (score > 0) scored.add(MapEntry(m, score));
  }
  scored.sort((a, b) => b.value.compareTo(a.value));
  return scored.map((e) => e.key).toList();
}

String _normalizeSearch(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();

double _matchScore(String name, String q, List<String> qWords) {
  if (name.contains(q)) return 100; // whole-query substring = best
  final nameWords = name.split(' ').where((w) => w.isNotEmpty).toList();
  var hits = 0;
  for (final w in qWords) {
    if (name.contains(w)) {
      hits++;
      continue;
    }
    // Typo tolerance: a title word within edit distance 1.
    if (nameWords.any((nw) => _within1(nw, w))) hits++;
  }
  final frac = hits / qWords.length;
  if (frac < 0.6) return 0;
  return frac * 10;
}

/// True if [a] and [b] are equal or within Levenshtein distance 1 (early-exit).
bool _within1(String a, String b) {
  if (a == b) return true;
  final la = a.length, lb = b.length;
  if ((la - lb).abs() > 1) return false;
  var i = 0, j = 0, edits = 0;
  while (i < la && j < lb) {
    if (a[i] == b[j]) {
      i++;
      j++;
      continue;
    }
    if (++edits > 1) return false;
    if (la > lb) {
      i++; // deletion from a
    } else if (lb > la) {
      j++; // insertion into a
    } else {
      i++;
      j++; // substitution
    }
  }
  if (i < la || j < lb) edits++; // one trailing extra char
  return edits <= 1;
}
