import 'dart:math' as math;

import 'package:flutter/material.dart';

// Fox-coral accent (matches the app's dark-theme colorScheme.primary).
const Color _kPrimary = Color(0xFFFF7A5C);

/// One entry in the radial wheel.
class RadialAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  const RadialAction(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.enabled = true});
}

/// The opt-in in-reader radial control (see the approved mockup).
///
/// Two persistent corner anchors: a back button (top-left) that expands into a
/// pill with the title/chapter, and a wheel FAB (bottom corner, side-selectable).
/// Holding the FAB fans the [actions] out in the upper arc and slides the page
/// slider out of the FAB; slide onto an option and release to pick, or quick-tap
/// to latch it open and tap an option. Everything else on screen stays clear.
///
/// This widget owns only the radial chrome; it draws nothing when reading is
/// undisturbed except the two anchors, so the reader keeps the whole viewport.
class RadialReaderMenu extends StatefulWidget {
  final bool leftSide;

  // Back pill
  final String title;
  final String? chapter;
  final bool titleExpanded; // driven by the reader's HUD tap state
  /// When false the anchors (back pill + wheel FAB) fade out — the reader hides all
  /// controls while reading. Ignored while the wheel is open (you can't be reading then).
  final bool visible;
  final VoidCallback onBack;

  // Wheel actions (hands-free is omitted by the caller when unsupported)
  final List<RadialAction> actions;

  // Page slider
  final int page; // 0-based
  final int totalPages;
  final ValueChanged<int> onSeek;

  /// Notifies the reader when the wheel opens/closes, so it can expand the
  /// title pill and pause auto-hide while the wheel is up.
  final ValueChanged<bool>? onOpenChanged;

  const RadialReaderMenu({
    super.key,
    required this.leftSide,
    required this.title,
    required this.chapter,
    required this.titleExpanded,
    this.visible = true,
    required this.onBack,
    required this.actions,
    required this.page,
    required this.totalPages,
    required this.onSeek,
    this.onOpenChanged,
  });

  @override
  State<RadialReaderMenu> createState() => _RadialReaderMenuState();
}

class _RadialReaderMenuState extends State<RadialReaderMenu>
    with SingleTickerProviderStateMixin {
  // Geometry (logical px). Tunable — the user refines on-device.
  static const double _fabSize = 60;
  static const double _optSize = 46;
  static const double _radius = 162;
  static const double _fabMarginX = 18;
  static const double _fabMarginBottom = 26;

  late final AnimationController _fan =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 240));

  final GlobalKey _rootKey = GlobalKey();

  bool _open = false;
  bool _latched = false; // opened by tap, stays until dismissed
  int? _active; // highlighted option during a drag
  double? _dragValue; // live page-slider value while dragging (thumb-under-finger)

  @override
  void dispose() {
    _fan.dispose();
    super.dispose();
  }

  void _setOpen(bool open) {
    if (_open == open) return;
    _open = open;
    if (open) {
      _fan.forward();
    } else {
      _fan.reverse();
      _latched = false;
      _active = null;
    }
    widget.onOpenChanged?.call(open);
    setState(() {});
  }

  // ── option geometry ────────────────────────────────────────────────────────

  /// Angles (degrees, CCW from +x) for the upper arc, so the fan never overlaps
  /// the slider row that shares the bottom.
  ({double a0, double a1}) get _arc => widget.leftSide
      ? (a0: 92.0, a1: 22.0)
      : (a0: 88.0, a1: 158.0);

  Offset _fabCenter(Size size, double safeBottom) {
    final cx = widget.leftSide
        ? _fabMarginX + _fabSize / 2
        : size.width - _fabMarginX - _fabSize / 2;
    final cy = size.height - safeBottom - _fabMarginBottom - _fabSize / 2;
    return Offset(cx, cy);
  }

  /// Local centre of option [i] at the current fan progress.
  Offset _optionCenter(int i, Offset fab, double t) {
    final n = widget.actions.length;
    final arc = _arc;
    final frac = n <= 1 ? 0.0 : i / (n - 1);
    final ang = (arc.a0 + (arc.a1 - arc.a0) * frac) * math.pi / 180;
    final r = _radius * Curves.easeOutBack.transform(t.clamp(0.0, 1.0));
    return fab + Offset(math.cos(ang) * r, -math.sin(ang) * r);
  }

  // ── gesture ────────────────────────────────────────────────────────────────

  Offset _toLocal(Offset global) {
    final box = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.globalToLocal(global) ?? global;
  }

  void _updateActive(Offset global, Size size, double safeBottom) {
    final local = _toLocal(global);
    final fab = _fabCenter(size, safeBottom);
    int? best;
    double bestDist = 46; // pick threshold
    for (var i = 0; i < widget.actions.length; i++) {
      if (!widget.actions[i].enabled) continue;
      final c = _optionCenter(i, fab, 1.0);
      final d = (local - c).distance;
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }
    if (best != _active) setState(() => _active = best);
  }

  void _commit() {
    final i = _active;
    _setOpen(false);
    if (i != null && i >= 0 && i < widget.actions.length) {
      final a = widget.actions[i];
      if (a.enabled) a.onTap();
    }
  }

  // ── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final safeBottom = MediaQuery.of(context).padding.bottom;
      final fab = _fabCenter(size, safeBottom);

      return Stack(key: _rootKey, children: [
        // Scrim — dims the page behind the open wheel.
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_open,
            child: FadeTransition(
              opacity: _fan.drive(Tween(begin: 0.0, end: 1.0)),
              child: GestureDetector(
                onTap: () => _setOpen(false),
                child: Container(color: Colors.black.withValues(alpha: 0.55)),
              ),
            ),
          ),
        ),

        _buildBackPill(context),
        _buildSlider(context, size, safeBottom, fab),
        ..._buildOptions(context, size, safeBottom, fab),
        _buildFab(context, fab),
      ]);
    });
  }

  // Expanding back button → title pill.
  Widget _buildBackPill(BuildContext context) {
    final expanded = widget.titleExpanded || _open;
    final anchorsShown = widget.visible || _open;
    final top = MediaQuery.of(context).padding.top + 10;
    return Positioned(
      top: top,
      left: 14,
      right: 60,
      child: IgnorePointer(
        ignoring: !anchorsShown,
        child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: anchorsShown ? 1.0 : 0.0,
        child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 44,
          constraints: const BoxConstraints(minWidth: 44),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.42),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            InkResponse(
              onTap: widget.onBack,
              radius: 24,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800)),
                          if (widget.chapter != null)
                            Text(widget.chapter!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.65),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ]),
        ),
        ),
        ),
      ),
    );
  }

  // Slider dock — the track runs into the FAB (FAB is the end-knob).
  Widget _buildSlider(
      BuildContext context, Size size, double safeBottom, Offset fab) {
    final total = widget.totalPages;
    final dockHeight = 42.0;
    final dockBottom = safeBottom + _fabMarginBottom + (_fabSize - dockHeight) / 2;
    // Right side: number on the left, track flows right into the FAB (and vice
    // versa). The dock's FAB-side end tucks under the FAB by design.
    final left = widget.leftSide ? fab.dx : 16.0;
    final right = widget.leftSide ? 16.0 : (size.width - fab.dx);

    final pageLabel = Text('${widget.page + 1}/${total <= 0 ? 1 : total}',
        style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w700));

    final track = SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        activeTrackColor: _kPrimary,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.22),
        thumbColor: _kPrimary,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.5),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      ),
      child: Slider(
        value: _dragValue ??
            (total <= 1
                ? 0
                : widget.page.toDouble().clamp(0, (total - 1).toDouble())),
        min: 0,
        max: total <= 1 ? 1 : (total - 1).toDouble(),
        onChangeStart: (v) => setState(() => _dragValue = v),
        onChanged: (v) {
          setState(() => _dragValue = v);
          widget.onSeek(v.round());
        },
        onChangeEnd: (v) {
          widget.onSeek(v.round());
          setState(() => _dragValue = null);
        },
      ),
    );

    final children = widget.leftSide
        ? [Expanded(child: track), const SizedBox(width: 4), pageLabel]
        : [pageLabel, const SizedBox(width: 4), Expanded(child: track)];

    return Positioned(
      bottom: dockBottom,
      left: left,
      right: right,
      height: dockHeight,
      child: IgnorePointer(
        ignoring: !_open,
        child: FadeTransition(
          opacity: _fan.drive(Tween(begin: 0.0, end: 1.0)),
          child: Container(
            padding: EdgeInsets.only(
              left: widget.leftSide ? 34 : 16,
              right: widget.leftSide ? 16 : 34,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(dockHeight / 2),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Row(children: children),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions(
      BuildContext context, Size size, double safeBottom, Offset fab) {
    return List.generate(widget.actions.length, (i) {
      final a = widget.actions[i];
      return AnimatedBuilder(
        animation: _fan,
        builder: (context, _) {
          final t = _fan.value;
          final c = _optionCenter(i, fab, t);
          final active = _active == i;
          return Positioned(
            left: c.dx - _optSize / 2,
            top: c.dy - _optSize / 2,
            width: _optSize,
            height: _optSize,
            child: IgnorePointer(
              ignoring: !_open || t < 0.5,
              child: Opacity(
                opacity: t,
                child: GestureDetector(
                  onTap: _latched && a.enabled
                      ? () {
                          _setOpen(false);
                          a.onTap();
                        }
                      : null,
                  child: AnimatedScale(
                    scale: active ? 1.22 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? _kPrimary
                            : const Color(0xFF2A2A3F),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: 12,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Icon(a.icon,
                          size: 22,
                          color: active
                              ? const Color(0xFF241014)
                              : (a.enabled
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.35))),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFab(BuildContext context, Offset fab) {
    return Positioned(
      left: fab.dx - _fabSize / 2,
      top: fab.dy - _fabSize / 2,
      width: _fabSize,
      height: _fabSize,
      child: IgnorePointer(
        ignoring: !(widget.visible || _open),
        child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: (widget.visible || _open) ? 1.0 : 0.0,
        child: GestureDetector(
        onTap: () {
          // A plain tap toggles the wheel and latches it open, so options can be
          // tapped instead of slid to.
          if (_open) {
            _setOpen(false);
          } else {
            _setOpen(true);
            setState(() => _latched = true);
          }
        },
        onLongPressStart: (_) => _setOpen(true),
        onLongPressMoveUpdate: (d) {
          final size = _rootKey.currentContext?.size ?? MediaQuery.of(context).size;
          _updateActive(
              d.globalPosition, size, MediaQuery.of(context).padding.bottom);
        },
        onLongPressEnd: (_) {
          if (_active != null) {
            _commit();
          } else {
            // released without landing on an option → latch open for tapping
            setState(() => _latched = true);
          }
        },
        child: AnimatedBuilder(
          animation: _fan,
          builder: (context, child) => Transform.rotate(
            angle: _fan.value * (math.pi / 4),
            child: child,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_kPrimary, Color(0xFFFF5F6E)],
              ),
              boxShadow: [
                BoxShadow(
                    color: _kPrimary.withValues(alpha: 0.5),
                    blurRadius: 22,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
          ),
        ),
      ),
      ),
      ),
    );
  }
}
