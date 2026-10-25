/// Formats a [Duration] as `m:ss`, growing to `h:mm:ss` once it reaches an
/// hour. Shared by the video player and the anime watch-time label so the two
/// read identically. (`intl` has no duration formatter, so this hand-rolled
/// helper is the canonical one - don't re-inline the math elsewhere.)
String formatDuration(Duration d) {
  final h = d.inHours;
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}
