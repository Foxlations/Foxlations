import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../theme/app_tokens.dart';
import 'marquee_text.dart';

/// One entry in the radial wheel.
///
/// If [panelBuilder] is set, picking this action doesn't fire [onTap] - instead
/// the fused tail **grows upward**, the builder's settings scrolling above the
/// tail's base (the page slider on manga, title/chapter on novels). The metaball
/// attachment to the button is kept; the tail just gets taller.
class RadialAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final Widget Function(BuildContext context, void Function() refresh)?
      panelBuilder;

  /// Height (logical px) the tail grows to when this action's panel is open.
  final double panelHeight;

  const RadialAction(
      {required this.icon,
      required this.label,
      this.onTap = _noop,
      this.enabled = true,
      this.panelBuilder,
      this.panelHeight = 220});
  static void _noop() {}
}

/// The opt-in in-reader radial control (see the approved mockup).
///
/// One morphing corner element carries the whole thing:
///   * While reading (controls hidden) it's a small dark **page pill**
///     ("4 / 20") in the bottom corner - the same spot the classic page
///     indicator uses, so it never jumps when you toggle radial on/off.
///   * Tap to reveal controls and the pill **morphs into the round button**
///     (accent) while the page **slider flows out of it as one fused shape**
///     (a gooey metaball tail, not a separate floating bar).
///   * Hold / tap the button to fan the [actions] out in the upper arc; slide
///     onto one and release to pick, or tap it (latched) to choose.
///
/// The fuse is done with a blur → alpha-threshold layer so the tail melts into
/// the button; the crisp text / icons / slider ride on top, unfiltered.
class RadialReaderMenu extends StatefulWidget {
  final bool leftSide;

  /// Picker style: 'wheel' fans the actions in an arc (default), 'tail' stacks
  /// them as a slim icon-only column that grows up the right edge from the +
  /// button, gooey-attached to the base.
  final String style;

  // Back pill
  final String title;
  final String? chapter;
  final bool titleExpanded; // driven by the reader's HUD tap state
  /// When false the chrome fades to its "reading" rest state: the back pill
  /// hides and the corner element becomes the page pill. Ignored while the
  /// wheel is open (you can't be reading then).
  final bool visible;
  final VoidCallback onBack;

  // Wheel actions (hands-free is omitted by the caller when unsupported)
  final List<RadialAction> actions;

  // Page slider
  final int page; // 0-based
  final int totalPages;
  final ValueChanged<int> onSeek;

  /// Whether to show the "page / total" label in the reading pill (follows the
  /// reader's show-page-number setting). When false the resting state is a bare
  /// round handle instead of a labelled pill.
  final bool showPageLabel;

  /// Notifies the reader when the wheel opens/closes, so it can expand the
  /// title pill and pause auto-hide while the wheel is up.
  final ValueChanged<bool>? onOpenChanged;

  /// Notifies the reader of the open settings panel's height (null when none),
  /// so a floating control (the novel Listen pill) can lift clear of it.
  final ValueChanged<double?>? onPanelChanged;

  /// When non-null the fused tail shows this (the novel reader's title/chapter +
  /// progress) instead of the page slider. Still metaball-attached to the button.
  final Widget? tailBase;

  /// Auto-scroll (continuous reader): when true, the resting page pill shows a
  /// pause glyph + [autoScrollSpeed], and tapping the pill calls
  /// [onAutoScrollPause] instead of opening the wheel - so the control lives
  /// right in the page-of-page pill while it runs.
  final bool autoScrolling;
  final int autoScrollSpeed;
  final VoidCallback? onAutoScrollPause;

  /// Optional prev/next CHAPTER arrows flanking the page slider on the tail
  /// (manga). Off by default; shown only when [showChapterNav] is true.
  final bool showChapterNav;
  final bool prevEnabled;
  final bool nextEnabled;
  final VoidCallback? onPrevChapter;
  final VoidCallback? onNextChapter;

  /// Reader-theme colours for the expanding settings panel that grows out of the
  /// tail. Defaults to the dark overlay the manga reader shipped with.
  final Color panelColor;
  final Color panelOnColor;
  final Color panelAccent;

  const RadialReaderMenu({
    super.key,
    required this.leftSide,
    this.style = 'wheel',
    required this.title,
    required this.chapter,
    required this.titleExpanded,
    this.visible = true,
    required this.onBack,
    required this.actions,
    this.page = 0,
    this.totalPages = 0,
    this.onSeek = _noSeek,
    this.showPageLabel = true,
    this.onOpenChanged,
    this.onPanelChanged,
    this.tailBase,
    this.autoScrolling = false,
    this.autoScrollSpeed = 0,
    this.onAutoScrollPause,
    this.showChapterNav = false,
    this.prevEnabled = false,
    this.nextEnabled = false,
    this.onPrevChapter,
    this.onNextChapter,
    this.panelColor = const Color(0xFF201E28),
    this.panelOnColor = Colors.white,
    this.panelAccent = const Color(0xFF8A7CFF),
  });

  static void _noSeek(int _) {}

  @override
  State<RadialReaderMenu> createState() => _RadialReaderMenuState();
}

class _RadialReaderMenuState extends State<RadialReaderMenu>
    with TickerProviderStateMixin {
  // Geometry (logical px). Tunable - the user refines on-device.
  static const double _fabSize = 56; // round button diameter
  static const double _tailH = 30; // slider-tail height (< _fabSize)
  static const double _optSize = 44;
  static const double _radius = 150; // fan radius for the options arc
  static const double _fabMarginX = 18;
  static const double _fabMarginBottom = 20; // button bottom ↔ safe area

  // Fan (wheel open/close) and morph (pill ↔ button) animations.
  late final AnimationController _fan =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 240));
  late final AnimationController _morph = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
      value: widget.visible ? 1.0 : 0.0);
  // Grows the tail up into the settings panel (metaball stays fused to button).
  late final AnimationController _panelAnim = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 260));

  final GlobalKey _rootKey = GlobalKey();

  bool _open = false;
  bool _latched = false; // opened by tap, stays until dismissed
  int? _active; // highlighted option during a drag
  double? _dragValue; // live page-slider value while dragging
  int? _panel; // index of the action whose settings panel grows out of the tail

  @override
  void didUpdateWidget(covariant RadialReaderMenu old) {
    super.didUpdateWidget(old);
    _syncMorph();
  }

  // The corner is a button (morph→1) whenever controls are up or the wheel is
  // open; otherwise it rests as the page pill (morph→0).
  void _syncMorph() {
    final wantButton = widget.visible || _open || _panel != null;
    if (wantButton && _morph.status != AnimationStatus.forward &&
        _morph.value != 1.0) {
      _morph.forward();
    } else if (!wantButton &&
        _morph.status != AnimationStatus.reverse &&
        _morph.value != 0.0) {
      _morph.reverse();
    }
  }

  @override
  void dispose() {
    _fan.dispose();
    _morph.dispose();
    _panelAnim.dispose();
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
    widget.onOpenChanged?.call(open || _panel != null);
    _syncMorph();
    setState(() {});
  }

  // Grow the tail into the settings panel for the chosen action (closes the fan,
  // keeps the chrome up). Tapping the button again returns to the fan.
  void _openPanel(int i) {
    _open = false;
    _fan.reverse();
    _latched = false;
    _active = null;
    _panelAnim.removeStatusListener(_onPanelClosed);
    setState(() => _panel = i);
    _panelAnim.forward(from: 0);
    widget.onOpenChanged?.call(true);
    // Tell the reader how tall the panel is (only actions that have a settings
    // panel count; a bare tail is not a panel), so a floating pill can lift.
    final a = widget.actions[i];
    widget.onPanelChanged?.call(a.panelBuilder != null ? a.panelHeight : null);
    _syncMorph();
  }

  void _closePanel() {
    if (_panel == null) return;
    // Reverse the grow so the tail slides back down to normal, then clear the
    // panel. Keeping _panel set during the reverse is what makes it animate
    // instead of vanishing abruptly.
    _panelAnim
      ..removeStatusListener(_onPanelClosed)
      ..addStatusListener(_onPanelClosed)
      ..reverse();
    widget.onOpenChanged?.call(_open);
    widget.onPanelChanged?.call(null); // panel closing → let the pill drop back
    _syncMorph();
    setState(() {});
  }

  void _onPanelClosed(AnimationStatus status) {
    if (status != AnimationStatus.dismissed) return;
    _panelAnim.removeStatusListener(_onPanelClosed);
    if (mounted) {
      setState(() => _panel = null);
      _syncMorph();
    }
  }

  // ── option geometry ────────────────────────────────────────────────────────

  /// Angles (degrees, CCW from +x) for the upper arc, so the fan never overlaps
  /// the slider that shares the bottom.
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

  bool get _tail => widget.style == 'tail';

  // Tail layout: vertical spacing between icon slots, and the gap from the
  // button up to the first slot.
  static const double _tailStep = _optSize + 10;
  double get _tailFirstGap => _fabSize / 2 + _optSize / 2 + 12;

  /// Enabled action count (the tail's height follows this).
  int get _enabledCount =>
      widget.actions.where((a) => a.enabled).length;

  /// The vertical slot for action [i] among the enabled ones (tail mode).
  int _tailSlot(int i) {
    var slot = 0;
    for (var k = 0; k < i && k < widget.actions.length; k++) {
      if (widget.actions[k].enabled) slot++;
    }
    return slot;
  }

  /// Tail height from the button up to the top of the topmost icon, at full fan.
  double get _tailFullHeight {
    final n = _enabledCount;
    if (n == 0) return 0;
    return _tailFirstGap + (n - 1) * _tailStep + _optSize / 2 + _fabSize / 2;
  }

  Offset _optionCenter(int i, Offset fab, double t) {
    if (_tail) {
      // Stack straight up from the button centre (flush right, no indent).
      final e = Curves.easeOutBack.transform(t.clamp(0.0, 1.0));
      final dy = (_tailFirstGap + _tailSlot(i) * _tailStep) * e;
      return fab + Offset(0, -dy);
    }
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
    if (i != null && i >= 0 && i < widget.actions.length) {
      final a = widget.actions[i];
      if (a.enabled) {
        if (a.panelBuilder != null) {
          _openPanel(i);
          return;
        }
        _setOpen(false);
        a.onTap();
        return;
      }
    }
    _setOpen(false);
  }

  String get _pageLabel {
    final total = widget.totalPages <= 0 ? 1 : widget.totalPages;
    return '${widget.page + 1} / $total';
  }

  /// Resting pill width, sized to the label (clamped). Collapses to the button
  /// diameter when there's no label to show.
  double get _pillWidth {
    // While auto-scrolling the pill carries a pause glyph + speed (+ page), so
    // it needs more room than the plain "page / total" label.
    if (widget.autoScrolling) {
      final extra = widget.showPageLabel ? _pageLabel.length * 7.5 : 0;
      return (72 + extra).clamp(_fabSize, 172).toDouble();
    }
    if (!widget.showPageLabel) return _fabSize;
    return (34 + _pageLabel.length * 7.5).clamp(_fabSize, 118).toDouble();
  }

  // ── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final safeBottom = MediaQuery.paddingOf(context).bottom;
      final fab = _fabCenter(size, safeBottom);

      return Stack(key: _rootKey, children: [
        // Scrim - dims the page behind the open wheel OR the settings panel.
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !(_open || _panel != null),
            child: AnimatedOpacity(
              opacity: (_open || _panel != null) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: GestureDetector(
                onTap: () {
                  _setOpen(false);
                  _closePanel();
                },
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
          ),
        ),

        _buildBackPill(context),
        // Wheel: bubbles fan up, away from the corner, so they sit behind it.
        // Tail: the icons sit ON the goo capsule, so they must be drawn AFTER
        // (on top of) the corner or the capsule hides them.
        if (!_tail) ..._buildOptions(context, size, safeBottom, fab, cs),
        _buildCorner(context, size, safeBottom, cs),
        if (_tail) ..._buildOptions(context, size, safeBottom, fab, cs),
      ]);
    });
  }

  // ── morphing corner: gooey pill ⇄ button + fused slider tail ───────────────

  Widget _buildCorner(
      BuildContext context, Size size, double safeBottom, ColorScheme cs) {
    final bottom = safeBottom + _fabMarginBottom;
    final accent = cs.primary;
    final surfaces = AppSurfaces.of(context);
    final pillColor = surfaces.chip; // resting pill - theme / OLED aware
    final left = widget.leftSide;
    final tailH = _tailH; // both readers use the thin tail now
    final expanded = _panel != null &&
        _panel! < widget.actions.length &&
        widget.actions[_panel!].panelBuilder != null;
    final targetH = expanded ? widget.actions[_panel!].panelHeight : tailH;

    return Positioned.fill(
      child: AnimatedBuilder(
      animation: Listenable.merge([_morph, _fan, _panelAnim]),
      builder: (context, _) {
        final m = Curves.easeOutCubic.transform(_morph.value); // 0 pill → 1 btn
        final blobColor = Color.lerp(pillColor, accent, m)!;
        final blobW = ui.lerpDouble(_pillWidth, _fabSize, m)!;
        final blobH = ui.lerpDouble(_tailH, _fabSize, m)!;
        final blobR = blobH / 2;

        // Slider tail grows with the morph (it belongs to the button state).
        final tailT = Curves.easeOutCubic.transform(_morph.value);
        // Panel grow: the fused tail rises from tailH up to the action's height,
        // staying one metaball shape attached to the button.
        final pv =
            expanded ? Curves.easeOutCubic.transform(_panelAnim.value) : 0.0;
        final shapeH = ui.lerpDouble(tailH, targetH, pv)!;

        // The raw shapes: the fused tail/panel + the morphing pill/button.
        final blobStack = Stack(children: [
          // fused tail - grows UP into the settings panel when expanded
          if (tailT > 0.01)
            Positioned(
              bottom: bottom,
              left: left ? _fabMarginX + 8 : 16,
              right: left ? 16 : _fabMarginX + 8,
              height: shapeH,
              child: Transform.scale(
                scaleX: expanded ? 1.0 : tailT,
                scaleY: 1.0,
                alignment: left ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(
                        ui.lerpDouble(_tailH / 2, 26, pv)!),
                  ),
                ),
              ),
            ),
          // tail-mode picker column: a slim capsule grown up the right edge from
          // the button by the fan. Same width + edge as the button, so the outer
          // (right) side is one straight line - no indent.
          if (_tail && _fan.value > 0.01 && _panel == null)
            Positioned(
              bottom: bottom,
              left: left ? _fabMarginX : null,
              right: left ? null : _fabMarginX,
              width: _fabSize,
              height: _tailFullHeight *
                  Curves.easeOutCubic.transform(_fan.value.clamp(0.0, 1.0)),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: blobColor,
                  borderRadius: BorderRadius.circular(_fabSize / 2),
                ),
              ),
            ),
          // morphing pill ⇄ button
          Positioned(
            bottom: bottom,
            left: left ? _fabMarginX : null,
            right: left ? null : _fabMarginX,
            width: blobW,
            height: blobH,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: blobColor,
                borderRadius: BorderRadius.circular(blobR),
              ),
            ),
          ),
        ]);

        // ---- gooey blob layer (non-interactive) ----
        // RepaintBoundary caches the expensive blur raster, so a parent rebuild
        // (e.g. the eye-comfort live preview firing notifyListeners on every
        // drag frame) doesn't re-rasterise the goo while the animations are idle.
        final goo = RepaintBoundary(
            child: IgnorePointer(
          child: tailT <= 0.02
              ? blobStack
              : ColorFiltered(
                  colorFilter: const ColorFilter.matrix(<double>[
                    1, 0, 0, 0, 0, //
                    0, 1, 0, 0, 0, //
                    0, 0, 1, 0, 0, //
                    0, 0, 0, 22, -2550, //
                  ]),
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: blobStack,
                  ),
                ),
        ));

        // ---- crisp overlay: text / icon / slider / settings, unfiltered ----
        final overlay = Stack(children: [
          // resting page label (fades out as it becomes the button)
          if (widget.showPageLabel || widget.autoScrolling)
            Positioned(
              bottom: bottom,
              left: left ? _fabMarginX : null,
              right: left ? null : _fabMarginX,
              width: _pillWidth,
              height: _tailH,
              child: Opacity(
                opacity: (1 - m * 1.6).clamp(0.0, 1.0),
                // While auto-scrolling the pill IS the control - tap it to pause.
                // Otherwise it's a passive label (taps fall through to the FAB).
                child: widget.autoScrolling
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onAutoScrollPause?.call(),
                        child: Center(child: _pageLabelText(cs)),
                      )
                    : IgnorePointer(child: Center(child: _pageLabelText(cs))),
              ),
            ),
          // Absorb taps anywhere on the panel so they don't fall through to the
          // dismiss-scrim. Padded well beyond the panel's hard rect because the
          // metaball blur makes the VISIBLE panel bleed past its bounds - without
          // this pad, tapping the soft/fuzzy edge of the panel still closed it.
          // Only taps clearly outside (the dimmed page) or the +/× button close.
          if (expanded)
            Positioned(
              bottom: 0,
              left: (left ? _fabMarginX + 8 : 16) - 16,
              right: (left ? 16 : _fabMarginX + 8) - 16,
              height: bottom + shapeH + 22,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
              ),
            ),
          // settings content - fills the grown panel above the base + button
          if (expanded)
            Positioned(
              bottom: bottom + _fabSize + 6,
              left: (left ? _fabMarginX + 8 : 16) + 12,
              right: (left ? 16 : _fabMarginX + 8) + 12,
              height: (shapeH - _fabSize - 24).clamp(0.0, size.height),
              child: IgnorePointer(
                ignoring: pv < 0.6,
                child: Opacity(
                  opacity: ((pv - 0.35) / 0.65).clamp(0.0, 1.0),
                  child: _buildPanelContent(context),
                ),
              ),
            ),
          // button icon (fades in)
          Positioned(
            bottom: bottom,
            left: left ? _fabMarginX : null,
            right: left ? null : _fabMarginX,
            width: _fabSize,
            height: _fabSize,
            child: IgnorePointer(
              child: Opacity(
                opacity: ((m - 0.4) / 0.6).clamp(0.0, 1.0),
                child: Center(
                  child: Transform.rotate(
                    angle: _fan.value * (math.pi / 4),
                    child: Icon(Icons.add_rounded,
                        color: cs.onPrimary, size: 26),
                  ),
                ),
              ),
            ),
          ),
          // tail content - page slider (manga) or progress slider (novel). It's
          // clip-revealed from the button side so it slides in/out together with
          // the fused tail instead of just fading in place.
          if (tailT > 0.02)
            (widget.tailBase != null
                ? _buildTailBaseUi(context, bottom, tailH, tailT)
                : _buildSliderUi(context, size, safeBottom, bottom, cs, tailT)),
          // hit target over the button (open / latch / slide-to-pick)
          Positioned(
            bottom: bottom,
            left: left ? _fabMarginX : null,
            right: left ? null : _fabMarginX,
            width: _fabSize,
            height: _fabSize,
            child: IgnorePointer(
              ignoring: !(widget.visible || _open || _panel != null),
              child: _fabGestures(context),
            ),
          ),
        ]);

        final corner = Stack(children: [
          Positioned.fill(child: goo),
          Positioned.fill(child: overlay),
        ]);
        // Novels have no resting page pill - fade the whole corner out while
        // reading so nothing lingers until the HUD is revealed.
        return widget.tailBase != null
            ? Opacity(opacity: m.clamp(0.0, 1.0), child: corner)
            : corner;
      },
      ),
    );
  }

  Widget _buildPanelContent(BuildContext context) {
    final i = _panel;
    if (i == null || i >= widget.actions.length) return const SizedBox.shrink();
    final a = widget.actions[i];
    if (a.panelBuilder == null) return const SizedBox.shrink();
    // A near-black inner window inside the purple shape - the metaball reads as
    // a thick frame/border around clean, padded settings (the "purple frame").
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.of(context).sunken,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      // The panel runs its own refresh through a local StatefulBuilder, so
      // rebuilding a chip or slider inside it never rebuilds the expensive
      // metaball goo (which is what made the eye-comfort sliders feel jittery).
      child: StatefulBuilder(
        builder: (ctx, setInner) {
          void refresh() {
            if (mounted) setInner(() {});
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
            children: [a.panelBuilder!(ctx, refresh)],
          );
        },
      ),
    );
  }

  Widget _pageLabelText(ColorScheme cs) {
    final total = widget.totalPages <= 0 ? 1 : widget.totalPages;
    final pageText = TextStyle(
        color: cs.onSurface,
        fontSize: 12.5,
        fontWeight: FontWeight.w800,
        fontFeatures: const [ui.FontFeature.tabularFigures()]);
    // Auto-scrolling: the pill becomes the control - a pause glyph + speed, with
    // the page count trailing (dimmed) when there's room. Tapping it pauses.
    if (widget.autoScrolling) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pause_rounded, size: 16, color: cs.primary),
          const SizedBox(width: 3),
          Text('${widget.autoScrollSpeed}', style: pageText),
          if (widget.showPageLabel) ...[
            Text('  ·  ', style: pageText.copyWith(color: cs.onSurfaceVariant)),
            Text('${widget.page + 1}/$total',
                style: pageText.copyWith(
                    fontWeight: FontWeight.w600, color: cs.onSurfaceVariant)),
          ],
        ],
      );
    }
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: '${widget.page + 1}'),
        TextSpan(
            text: ' / $total',
            style: TextStyle(color: cs.onSurfaceVariant)),
      ]),
      maxLines: 1,
      style: pageText,
    );
  }

  Widget _fabGestures(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_panel != null) {
          // From a settings panel, the button returns to the options fan.
          _closePanel();
          _setOpen(true);
          setState(() => _latched = true);
        } else if (_open) {
          _setOpen(false);
        } else {
          _setOpen(true);
          setState(() => _latched = true);
        }
      },
      onLongPressStart: (_) => _setOpen(true),
      onLongPressMoveUpdate: (d) {
        final size = _rootKey.currentContext?.size ?? MediaQuery.sizeOf(context);
        _updateActive(
            d.globalPosition, size, MediaQuery.paddingOf(context).bottom);
      },
      onLongPressEnd: (_) {
        if (_active != null) {
          _commit();
        } else {
          setState(() => _latched = true);
        }
      },
    );
  }

  // The slider UI that rides on the fused tail (number + track).
  Widget _buildSliderUi(BuildContext context, Size size, double safeBottom,
      double bottom, ColorScheme cs, double reveal) {
    final total = widget.totalPages;
    final left = widget.leftSide;
    final label = Text('${widget.page + 1}/${total <= 0 ? 1 : total}',
        style: TextStyle(
            color: cs.onPrimary.withValues(alpha: 0.85),
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            fontFeatures: const [ui.FontFeature.tabularFigures()]));

    final track = SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        activeTrackColor: cs.onPrimary,
        inactiveTrackColor: cs.onPrimary.withValues(alpha: 0.3),
        thumbColor: cs.onPrimary,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 13),
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

    // Number sits at the far end of the tail, track flows toward the button.
    final children = left
        ? [Expanded(child: track), const SizedBox(width: 6), label]
        : [label, const SizedBox(width: 6), Expanded(child: track)];

    // Optional prev/next chapter arrows at the tail ends (manga, opt-in).
    Widget navBtn(IconData icon, bool enabled, VoidCallback? onTap) =>
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Icon(icon,
                size: 19,
                color: cs.onPrimary.withValues(alpha: enabled ? 0.9 : 0.3)),
          ),
        );
    final rowChildren = widget.showChapterNav
        ? [
            navBtn(Icons.skip_previous_rounded, widget.prevEnabled,
                widget.onPrevChapter),
            const SizedBox(width: 3),
            ...children,
            const SizedBox(width: 3),
            navBtn(Icons.skip_next_rounded, widget.nextEnabled,
                widget.onNextChapter),
          ]
        : children;

    return Positioned(
      bottom: bottom,
      // Tuck the near end under the button; the far end stops short of the edge.
      left: left ? _fabSize + _fabMarginX - 2 : 22,
      right: left ? 22 : _fabSize + _fabMarginX - 2,
      height: _tailH,
      child: IgnorePointer(
        ignoring: !(widget.visible || _open),
        child: _revealTail(
          reveal: reveal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: rowChildren),
          ),
        ),
      ),
    );
  }

  // Wraps tail content so it reveals from the button side (a horizontal wipe +
  // fade) in lockstep with the fused tail's scale, so the slider / title ride
  // in and out with the tail instead of popping in place.
  Widget _revealTail({required double reveal, required Widget child}) {
    final r = reveal.clamp(0.0, 1.0);
    return Opacity(
      opacity: r,
      child: ClipRect(
        clipper: _TailRevealClipper(fraction: r, fromRight: !widget.leftSide),
        child: child,
      ),
    );
  }

  // Expanding back button → title pill.
  Widget _buildBackPill(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final expanded = widget.titleExpanded || _open;
    final top = MediaQuery.paddingOf(context).top + 10;
    // The pill sits in a min-width Row, which hands its children UNBOUNDED
    // width - so the title needs an explicit cap or the marquee can't tell how
    // much room it has (and a long title just clips at the pill edge). Cap it to
    // the pill's available space: screen minus the 14+60 side margins, the 44
    // back-button and the 16 right padding.
    final maxTitleW =
        (MediaQuery.sizeOf(context).width - 134).clamp(80.0, double.infinity);
    // The back button is ALWAYS visible while reading: when the HUD hides, the
    // title collapses (AnimatedSize below) so the pill slides down to just the
    // back-arrow circle, which stays visible and tappable over the page.
    return Positioned(
      top: top,
      left: 14,
      right: 60,
      child: IgnorePointer(
        ignoring: false,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: 1.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 44,
              constraints: const BoxConstraints(minWidth: 44),
              // A theme surface + border + shadow so the pill reads over any
              // page while following the selected theme / OLED. Slightly
              // translucent so it still feels like a floating control.
              decoration: BoxDecoration(
                color: cs.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: cs.outlineVariant),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 2)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                InkResponse(
                  onTap: widget.onBack,
                  radius: 24,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        color: cs.onSurface, size: 18),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxTitleW),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MarqueeText(widget.title,
                                    style: TextStyle(
                                        color: cs.onSurface,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800)),
                                if (widget.chapter != null)
                                  Text(widget.chapter!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                              ],
                            ),
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

  List<Widget> _buildOptions(BuildContext context, Size size, double safeBottom,
      Offset fab, ColorScheme cs) {
    final accent = cs.primary;
    final surfaces = AppSurfaces.of(context);
    return List.generate(widget.actions.length, (i) {
      final a = widget.actions[i];
      // Tail shows only enabled actions (its height follows that count).
      if (_tail && !a.enabled) return const SizedBox.shrink();
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
                opacity: t.clamp(0.0, 1.0),
                child: GestureDetector(
                  onTap: _latched && a.enabled
                      ? () {
                          if (a.panelBuilder != null) {
                            _openPanel(i);
                            return;
                          }
                          _setOpen(false);
                          a.onTap();
                        }
                      : null,
                  child: AnimatedScale(
                    scale: active ? 1.22 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    child: Container(
                      decoration: _tail
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: active
                                  ? cs.onPrimary.withValues(alpha: 0.22)
                                  : Colors.transparent)
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              color: active ? accent : surfaces.chip,
                              border: Border.all(color: cs.outlineVariant),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.45),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4)),
                              ],
                            ),
                      child: Icon(a.icon,
                          size: _tail ? 23 : 21,
                          color: _tail
                              ? (a.enabled
                                  ? cs.onPrimary
                                  : cs.onPrimary.withValues(alpha: 0.4))
                              : (active
                                  ? cs.onPrimary
                                  : (a.enabled
                                      ? cs.onSurface
                                      : cs.onSurface.withValues(alpha: 0.35)))),
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

  // Novel tail content: title/chapter + progress, riding on the fused tail (the
  // manga reader uses _buildSliderUi here instead).
  Widget _buildTailBaseUi(
      BuildContext context, double bottom, double tailH, double reveal) {
    final left = widget.leftSide;
    return Positioned(
      bottom: bottom,
      left: left ? _fabSize + _fabMarginX - 2 : 22,
      right: left ? 22 : _fabSize + _fabMarginX - 2,
      height: tailH,
      child: IgnorePointer(
        ignoring: !(widget.visible || _open || _panel != null),
        child: _revealTail(
          reveal: reveal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(child: widget.tailBase),
          ),
        ),
      ),
    );
  }
}

/// Reveals a tail child from the button side: the clip grows from `fraction` 0
/// (nothing shown) to 1 (fully shown), wiping out of the button so the content
/// slides in / out with the fused tail.
class _TailRevealClipper extends CustomClipper<Rect> {
  _TailRevealClipper({required this.fraction, required this.fromRight});

  final double fraction;
  final bool fromRight;

  @override
  Rect getClip(Size size) {
    final w = (size.width * fraction).clamp(0.0, size.width);
    return fromRight
        ? Rect.fromLTWH(size.width - w, 0, w, size.height)
        : Rect.fromLTWH(0, 0, w, size.height);
  }

  @override
  bool shouldReclip(_TailRevealClipper old) =>
      old.fraction != fraction || old.fromRight != fromRight;
}
