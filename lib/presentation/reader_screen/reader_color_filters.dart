import 'package:flutter/material.dart';

import '../../core/providers/reader_provider.dart';

/// Image colour adjustments for the reader, as 4x5 colour matrices folded into a
/// single [ColorFilter]. Pure functions, kept out of the reader screen so the
/// screen file stays focused on layout and gestures.

/// Returns a ColorFilter that applies the configured saturation / contrast /
/// sepia / grayscale / invert, or null if none are active.
ColorFilter? imageColorFilter(ReaderSettings s) {
  // Applied in order: saturation -> contrast -> sepia -> grayscale -> invert.
  // Each is a 4x5 colour matrix; the list is folded into one (GPU-cheap).
  final filters = <List<double>>[];
  if (s.saturation != 1.0) filters.add(saturationMatrix(s.saturation));
  if (s.contrast != 1.0) filters.add(contrastMatrix(s.contrast));
  if (s.sepia > 0) filters.add(sepiaMatrix(s.sepia));
  if (s.grayscale) {
    filters.add(const [
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);
  }
  if (s.invertColors) {
    filters.add(const [
      -1, 0, 0, 0, 255,
      0, -1, 0, 0, 255,
      0, 0, -1, 0, 255,
      0, 0, 0, 1, 0,
    ]);
  }
  if (filters.isEmpty) return null;
  var m = filters.first;
  for (var i = 1; i < filters.length; i++) {
    m = composeMatrices(m, filters[i]);
  }
  return ColorFilter.matrix(m);
}

/// Saturation: 1 = unchanged, 0 = grayscale, >1 = more vivid.
List<double> saturationMatrix(double s) {
  const lr = 0.2126, lg = 0.7152, lb = 0.0722;
  final ir = (1 - s) * lr, ig = (1 - s) * lg, ib = (1 - s) * lb;
  return [
    ir + s, ig,     ib,     0, 0,
    ir,     ig + s, ib,     0, 0,
    ir,     ig,     ib + s, 0, 0,
    0,      0,      0,      1, 0,
  ];
}

/// Contrast around the 0.5 midpoint (channels are 0..255 here, so 127.5).
List<double> contrastMatrix(double c) {
  final t = (1 - c) * 127.5;
  return [
    c, 0, 0, 0, t,
    0, c, 0, 0, t,
    0, 0, c, 0, t,
    0, 0, 0, 1, 0,
  ];
}

/// Sepia blended identity to full by [a] (0..1).
List<double> sepiaMatrix(double a) {
  final i = 1 - a;
  return [
    i + a * 0.393, a * 0.769,     a * 0.189,     0, 0,
    a * 0.349,     i + a * 0.686, a * 0.168,     0, 0,
    a * 0.272,     a * 0.534,     i + a * 0.131, 0, 0,
    0,             0,             0,             1, 0,
  ];
}

/// 4x5 color matrix multiplication (b applied after a).
List<double> composeMatrices(List<double> a, List<double> b) {
  final out = List<double>.filled(20, 0);
  for (var row = 0; row < 4; row++) {
    for (var col = 0; col < 5; col++) {
      var sum = 0.0;
      for (var k = 0; k < 4; k++) {
        sum += b[row * 5 + k] * a[k * 5 + col];
      }
      if (col == 4) sum += b[row * 5 + 4];
      out[row * 5 + col] = sum;
    }
  }
  return out;
}
