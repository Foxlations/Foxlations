import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Trims near-uniform (solid white/black) margins from a page image.
///
/// Returns cropped JPEG bytes, or `null` when there's nothing worth cropping
/// (no consistent border, can't decode, or the trim would be trivial/degenerate).
/// Pure + top-level so it can run in a background isolate via `compute`.
Uint8List? cropImageBorders(Uint8List bytes) {
  final src = img.decodeImage(bytes);
  if (src == null) return null;
  final w = src.width, h = src.height;
  if (w < 40 || h < 40) return null;

  // Reference border colour = average of the four corners. If the corners
  // disagree a lot there's no uniform border, so don't touch the page.
  final c0 = src.getPixel(0, 0),
      c1 = src.getPixel(w - 1, 0),
      c2 = src.getPixel(0, h - 1),
      c3 = src.getPixel(w - 1, h - 1);
  final br = (c0.r + c1.r + c2.r + c3.r) / 4;
  final bg = (c0.g + c1.g + c2.g + c3.g) / 4;
  final bb = (c0.b + c1.b + c2.b + c3.b) / 4;
  var spread = 0.0;
  for (final c in [c0, c1, c2, c3]) {
    spread += (c.r - br).abs() + (c.g - bg).abs() + (c.b - bb).abs();
  }
  if (spread / 4 > 60) return null; // corners aren't a consistent border

  const tol = 28.0; // per-channel "same as the border" tolerance
  bool isBorder(img.Pixel p) =>
      (p.r - br).abs() < tol && (p.g - bg).abs() < tol && (p.b - bb).abs() < tol;

  // Subsample across the scan line — full per-pixel scans are needlessly heavy.
  final stepX = (w / 180).ceil().clamp(1, 20);
  final stepY = (h / 180).ceil().clamp(1, 20);

  bool rowBorder(int y) {
    int tot = 0, match = 0;
    for (int x = 0; x < w; x += stepX) {
      tot++;
      if (isBorder(src.getPixel(x, y))) match++;
    }
    return tot > 0 && match / tot >= 0.985;
  }

  bool colBorder(int x) {
    int tot = 0, match = 0;
    for (int y = 0; y < h; y += stepY) {
      tot++;
      if (isBorder(src.getPixel(x, y))) match++;
    }
    return tot > 0 && match / tot >= 0.985;
  }

  var top = 0;
  while (top < h ~/ 2 && rowBorder(top)) {
    top++;
  }
  var bottom = h - 1;
  while (bottom > top && rowBorder(bottom)) {
    bottom--;
  }
  var left = 0;
  while (left < w ~/ 2 && colBorder(left)) {
    left++;
  }
  var right = w - 1;
  while (right > left && colBorder(right)) {
    right--;
  }

  // Leave a couple of pixels so we never shave actual content.
  const pad = 2;
  top = (top - pad).clamp(0, h - 1);
  left = (left - pad).clamp(0, w - 1);
  bottom = (bottom + pad).clamp(0, h - 1);
  right = (right + pad).clamp(0, w - 1);

  final cw = right - left + 1, ch = bottom - top + 1;
  if (cw < 20 || ch < 20) return null; // degenerate
  // Only bother if we actually trimmed something meaningful (> 3% of area).
  if ((w * h - cw * ch) / (w * h) < 0.03) return null;

  final cropped = img.copyCrop(src, x: left, y: top, width: cw, height: ch);
  return Uint8List.fromList(img.encodeJpg(cropped, quality: 92));
}
