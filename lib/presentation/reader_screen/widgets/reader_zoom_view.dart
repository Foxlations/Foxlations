import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Pinch-to-zoom + double-tap-to-zoom wrapper shared by every reading layout.
/// Panning is enabled only while zoomed in, so at 1x single-finger gestures fall
/// through to the page-turn / scroll underneath; double-tap toggles between fit
/// and a focal zoom centred on the tapped point.
class ZoomableView extends StatefulWidget {
  final Widget child;
  const ZoomableView({super.key, required this.child});

  @override
  State<ZoomableView> createState() => _ZoomableViewState();
}

class _ZoomableViewState extends State<ZoomableView>
    with SingleTickerProviderStateMixin {
  static const _doubleTapScale = 2.5;
  final _tc = TransformationController();
  late final AnimationController _anim;
  Animation<Matrix4>? _zoomAnim;
  Offset _tapPos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220))
      ..addListener(() {
        final a = _zoomAnim;
        if (a != null) _tc.value = a.value;
      });
  }

  @override
  void dispose() {
    _anim.dispose();
    _tc.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final zoomedIn = _tc.value.getMaxScaleOnAxis() > 1.01;
    final end = zoomedIn
        ? Matrix4.identity()
        : (Matrix4.identity()
          ..translateByDouble(-_tapPos.dx * (_doubleTapScale - 1),
              -_tapPos.dy * (_doubleTapScale - 1), 0, 1)
          ..scaleByDouble(
              _doubleTapScale, _doubleTapScale, _doubleTapScale, 1));
    _zoomAnim = Matrix4Tween(begin: _tc.value, end: end)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (d) => _tapPos = d.localPosition,
      onDoubleTap: _handleDoubleTap,
      child: ValueListenableBuilder<Matrix4>(
        valueListenable: _tc,
        builder: (_, m, _) => InteractiveViewer(
          transformationController: _tc,
          minScale: 1.0,
          maxScale: 5.0,
          scaleEnabled: true,
          // Pan only once zoomed in; at 1x let the page-turn / scroll through.
          panEnabled: m.getMaxScaleOnAxis() > 1.01,
          child: widget.child,
        ),
      ),
    );
  }
}

/// A round, translucent icon button used across the reader HUD.
class HudButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String tooltip;
  final double size;

  const HudButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.onLongPress,
    required this.tooltip,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          splashColor: Colors.white24,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(102),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(color: Colors.white.withAlpha(26)),
            ),
            child: Icon(icon, size: size, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
