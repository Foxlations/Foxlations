import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/app_logger.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_tokens.dart';

/// A lightweight dictionary lookup shown from the light-novel reader's selection
/// toolbar ("Define"). Fetches the free, key-less dictionaryapi.dev and renders
/// the word, pronunciation and meanings. Fully self-contained and best-effort:
/// an offline / not-found lookup shows a friendly message, never an error.
class DictionarySheet extends StatefulWidget {
  const DictionarySheet({super.key, required this.word});

  final String word;

  /// Opens the sheet for [raw] (reduced to its first word). No-op if empty.
  static void show(BuildContext context, String raw) {
    final m = RegExp(r"[A-Za-z][A-Za-z'’\-]*").firstMatch(raw);
    final word = (m?.group(0) ?? '').toLowerCase();
    if (word.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DictionarySheet(word: word),
    );
  }

  @override
  State<DictionarySheet> createState() => _DictionarySheetState();
}

class _Meaning {
  _Meaning(this.partOfSpeech, this.definitions);
  final String partOfSpeech;
  final List<(String, String?)> definitions; // (definition, example?)
}

class _DictionarySheetState extends State<DictionarySheet> {
  bool _loading = true;
  bool _netError = false; // true = couldn't reach the API (vs genuinely no entry)
  String? _phonetic;
  List<_Meaning> _meanings = const [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  static const _ua = 'Mozilla/5.0 (compatible; Foxlations)';

  Future<void> _fetch() async {
    // Try dictionaryapi.dev first, then fall back to Wiktionary (Wikimedia
    // infra, far more reliable, since dictionaryapi.dev 530s or rate-limits a lot).
    final primary = await _lookupPrimary();
    if (primary != null && primary.$2.isNotEmpty) {
      _apply(primary.$1, primary.$2);
      return;
    }
    final fallback = await _lookupWiktionary();
    if (fallback != null && fallback.$2.isNotEmpty) {
      _apply(fallback.$1, fallback.$2);
      return;
    }
    // No definitions. It's only a connection problem if we couldn't reach
    // EITHER source (a reached-but-empty source means a genuine "no entry").
    final reachedAny = primary != null || fallback != null;
    if (mounted) {
      setState(() {
        _loading = false;
        _netError = !reachedAny;
      });
    }
  }

  void _apply(String? phonetic, List<_Meaning> meanings) {
    if (mounted) {
      setState(() {
        _loading = false;
        _phonetic = (phonetic != null && phonetic.isNotEmpty) ? phonetic : null;
        _meanings = meanings;
      });
    }
  }

  /// dictionaryapi.dev. Returns (phonetic, meanings) when reached (meanings
  /// empty = no entry), or null when the source couldn't be reached.
  Future<(String?, List<_Meaning>)?> _lookupPrimary() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.dictionaryapi.dev/api/v2/entries/en/${Uri.encodeComponent(widget.word)}'),
        headers: const {'User-Agent': _ua, 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 8));
      if (res.statusCode == 404) return (null, const <_Meaning>[]); // no entry
      if (res.statusCode != 200) {
        await logger.warning('Dictionary lookup failed',
            category: LogCategory.network,
            detail: '${widget.word}: HTTP ${res.statusCode}');
        return null;
      }
      final data = jsonDecode(res.body);
      if (data is! List || data.isEmpty) return (null, const <_Meaning>[]);
      String? phonetic;
      final meanings = <_Meaning>[];
      for (final entry in data) {
        if (entry is! Map) continue;
        phonetic ??= (entry['phonetic'] as String?)?.trim();
        if ((phonetic == null || phonetic.isEmpty) &&
            entry['phonetics'] is List) {
          for (final p in entry['phonetics']) {
            final t = (p is Map ? p['text'] : null) as String?;
            if (t != null && t.trim().isNotEmpty) {
              phonetic = t.trim();
              break;
            }
          }
        }
        if (entry['meanings'] is List) {
          for (final m in entry['meanings']) {
            if (m is! Map) continue;
            final pos = (m['partOfSpeech'] as String?)?.trim() ?? '';
            final defs = <(String, String?)>[];
            if (m['definitions'] is List) {
              for (final d in m['definitions']) {
                if (d is! Map) continue;
                final def = (d['definition'] as String?)?.trim();
                if (def == null || def.isEmpty) continue;
                final ex = (d['example'] as String?)?.trim();
                defs.add((def, (ex != null && ex.isNotEmpty) ? ex : null));
              }
            }
            if (defs.isNotEmpty) meanings.add(_Meaning(pos, defs));
          }
        }
      }
      return (phonetic, meanings);
    } catch (e) {
      await logger.warning('Dictionary lookup error',
          category: LogCategory.network, detail: '${widget.word}: $e');
      return null;
    }
  }

  /// Wiktionary REST API fallback. Its definitions are HTML, so they're stripped
  /// to plain text. Same return contract as [_lookupPrimary].
  Future<(String?, List<_Meaning>)?> _lookupWiktionary() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://en.wiktionary.org/api/rest_v1/page/definition/${Uri.encodeComponent(widget.word)}'),
        headers: const {'User-Agent': _ua, 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 8));
      if (res.statusCode == 404) return (null, const <_Meaning>[]);
      if (res.statusCode != 200) {
        await logger.warning('Wiktionary lookup failed',
            category: LogCategory.network,
            detail: '${widget.word}: HTTP ${res.statusCode}');
        return null;
      }
      final data = jsonDecode(res.body);
      final en = data is Map ? data['en'] : null;
      if (en is! List) return (null, const <_Meaning>[]); // no English section
      final meanings = <_Meaning>[];
      for (final m in en) {
        if (m is! Map) continue;
        final pos = (m['partOfSpeech'] as String?)?.trim().toLowerCase() ?? '';
        final defs = <(String, String?)>[];
        if (m['definitions'] is List) {
          for (final d in m['definitions']) {
            if (d is! Map) continue;
            final def = _stripHtml((d['definition'] as String?) ?? '');
            if (def.isEmpty) continue;
            String? ex;
            final pex = d['parsedExamples'];
            if (pex is List && pex.isNotEmpty && pex.first is Map) {
              final e = _stripHtml((pex.first['example'] as String?) ?? '');
              if (e.isNotEmpty) ex = e;
            }
            defs.add((def, ex));
          }
        }
        if (defs.isNotEmpty) meanings.add(_Meaning(pos, defs));
      }
      return (null, meanings);
    } catch (e) {
      await logger.warning('Wiktionary lookup error',
          category: LogCategory.network, detail: '${widget.word}: $e');
      return null;
    }
  }

  /// Strip HTML tags + common entities from a Wiktionary definition.
  String _stripHtml(String s) {
    final out = s
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
    return out.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      margin: EdgeInsets.only(bottom: bottom),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: cs.outline.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(widget.word,
                        style: GoogleFonts.notoSerif(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface)),
                  ),
                  if (_phonetic != null) ...[
                    const SizedBox(width: 10),
                    Text(_phonetic!,
                        style: GoogleFonts.robotoMono(
                            fontSize: 13, color: cs.onSurfaceVariant)),
                  ],
                ],
              ),
            ),
            Flexible(child: _body(cs)),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _body(ColorScheme cs) {
    final t = AppLocalizations.of(context);
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_meanings.isEmpty) {
      final msg = _netError
          ? t.dictNetworkError
          : t.dictNoDefinition(widget.word);
      return Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 8, AppSpacing.lg, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(_netError ? Icons.wifi_off_rounded : Icons.search_off_rounded,
                color: cs.outline, size: 20),
            const SizedBox(width: 10),
            Expanded(
                child:
                    Text(msg, style: TextStyle(color: cs.onSurfaceVariant))),
          ]),
          if (_netError)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _netError = false;
                  });
                  _fetch();
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(t.readerRetry),
              ),
            ),
        ]),
      );
    }
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 8),
      children: [
        for (final m in _meanings) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(m.partOfSpeech,
                style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
          ),
          for (var i = 0; i < m.definitions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${i + 1}.  ${m.definitions[i].$1}',
                      style: TextStyle(
                          fontSize: 15, height: 1.35, color: cs.onSurface)),
                  if (m.definitions[i].$2 != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 22, top: 3),
                      child: Text('“${m.definitions[i].$2}”',
                          style: TextStyle(
                              fontSize: 13.5,
                              fontStyle: FontStyle.italic,
                              color: cs.onSurfaceVariant)),
                    ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
