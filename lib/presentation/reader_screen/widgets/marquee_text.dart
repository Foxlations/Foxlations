import 'dart:async';
import 'package:flutter/material.dart';

/// A single-line label that gently auto-scrolls (marquee) when it is too wide
/// to fit, so long reader titles can be read in full instead of being clipped.
///
/// When the text fits it renders as a plain [Text] (so the pill still hugs a
/// short title). When it overflows it fills the available width and slides the
/// text back and forth with a short pause at each end.
class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  /// Pixels per second the text slides while scrolling.
  final double velocity;

  /// How long to hold still at each end before reversing.
  final Duration pause;

  const MarqueeText(
    this.text, {
    super.key,
    this.style,
    this.velocity = 35,
    this.pause = const Duration(milliseconds: 1400),
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  final ScrollController _controller = ScrollController();
  bool _looping = false;

  @override
  void didUpdateWidget(MarqueeText old) {
    super.didUpdateWidget(old);
    // A new title resets the scroll; the loop restarts from the layout check.
    if (old.text != widget.text) {
      _looping = false;
      if (_controller.hasClients) _controller.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _looping = false;
    _controller.dispose();
    super.dispose();
  }

  void _ensureLooping() {
    if (_looping) return;
    _looping = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loop());
  }

  Future<void> _loop() async {
    while (mounted && _looping && _controller.hasClients) {
      final max = _controller.position.maxScrollExtent;
      if (max <= 1) {
        _looping = false; // no longer overflows (e.g. after a layout change)
        return;
      }
      final travel =
          Duration(milliseconds: (max / widget.velocity * 1000).round());
      await Future.delayed(widget.pause);
      if (!mounted || !_looping || !_controller.hasClients) return;
      await _controller.animateTo(_controller.position.maxScrollExtent,
          duration: travel, curve: Curves.linear);
      if (!mounted || !_looping || !_controller.hasClients) return;
      await Future.delayed(widget.pause);
      if (!mounted || !_looping || !_controller.hasClients) return;
      await _controller.animateTo(0, duration: travel, curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final label = Text(widget.text,
            maxLines: 1, softWrap: false, style: widget.style);
        final maxW = constraints.maxWidth;
        if (!maxW.isFinite) return label;
        final tp = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout();
        // Fits: stay static and hug the text so the pill shrinks to size.
        if (tp.width <= maxW + 0.5) {
          _looping = false;
          return label;
        }
        _ensureLooping();
        return SizedBox(
          width: maxW,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            child: label,
          ),
        );
      },
    );
  }
}
