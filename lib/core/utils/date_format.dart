import 'package:intl/intl.dart';

/// Formats a date string (timestamp in ms or ISO date) to a relative
/// label within 7 days ("Today", "Yesterday", "2 days ago", …)
/// and falls back to a formatted date after that.
String formatChapterDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';

  DateTime? date;

  // Try parsing as milliseconds timestamp first.
  final ms = int.tryParse(raw);
  if (ms != null) {
    // A purely-numeric value that's 0 or negative isn't a real timestamp - 
    // LNReader (and some other) plugins emit "0" when a chapter has no release
    // date. Show nothing rather than a literal "0".
    if (ms <= 0) return '';
    date = DateTime.fromMillisecondsSinceEpoch(ms);
  }

  // Try ISO / common date string parsing
  date ??= DateTime.tryParse(raw);

  if (date == null) return raw; // Return as-is if unparseable

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateDay = DateTime(date.year, date.month, date.day);
  final diff = today.difference(dateDay).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (diff >= 2 && diff <= 7) return '$diff days ago';

  return DateFormat.yMMMd().format(date); // e.g. "Mar 25, 2026"
}
