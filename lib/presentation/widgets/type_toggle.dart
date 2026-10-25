import 'package:flutter/material.dart';

/// One item in a [TypeToggle] - an id, its label, and an optional badge count
/// (e.g. pending updates for that content type).
class TypeToggleItem {
  final String id;
  final String label;
  final int badge;
  const TypeToggleItem(this.id, this.label, {this.badge = 0});
}

/// The app-wide content-type switcher (All / Manga / Anime / Novel …), used by
/// Discover, global search and Browse so they all look the same. A segmented
/// pill track whose purple highlight slides and resizes to the selected item.
class TypeToggle extends StatefulWidget {
  final List<TypeToggleItem> items;
  final String selectedId;
  final ValueChanged<String> onChanged;

  const TypeToggle({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  State<TypeToggle> createState() => _TypeToggleState();
}

class _TypeToggleState extends State<TypeToggle> {
  final GlobalKey _stackKey = GlobalKey();
  final Map<String, GlobalKey> _segKeys = {};
  Rect? _hl; // highlight rect, relative to the stack

  GlobalKey _keyFor(String id) => _segKeys.putIfAbsent(id, () => GlobalKey());

  void _measure() {
    if (!mounted) return;
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final segBox =
        _segKeys[widget.selectedId]?.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || segBox == null) return;
    final pos = segBox.localToGlobal(Offset.zero, ancestor: stackBox);
    final r = Rect.fromLTWH(pos.dx, 0, segBox.size.width, segBox.size.height);
    if (r != _hl) setState(() => _hl = r);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Depend on the system text scale so a font-size change rebuilds (then
    // re-measures) us even without a parent rebuild.
    MediaQuery.textScalerOf(context);
    // Re-measure after layout so the sliding highlight follows the selected
    // segment after ANY change that moves or resizes it (selection, badge count,
    // rotation, text scale, locale label widths, theme). _measure only calls
    // setState on a real change, so this settles in a frame and never loops.
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outline.withAlpha(36)),
      ),
      child: Stack(
        key: _stackKey,
        children: [
          if (_hl != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 340),
              curve: Curves.easeOutCubic,
              left: _hl!.left,
              top: 0,
              height: _hl!.height,
              width: _hl!.width,
              child: Container(
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withAlpha(90),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final it in widget.items) _segment(cs, it),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segment(ColorScheme cs, TypeToggleItem it) {
    final selected = it.id == widget.selectedId;
    return GestureDetector(
      key: _keyFor(it.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onChanged(it.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        // Inline label + badge (was a floating Positioned badge that clipped the
        // pill edge and clashed in colour). The badge sits after the label, flips
        // to an inverted chip when selected, and rides inside the pill cleanly.
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : cs.onSurfaceVariant,
              ),
              child: Text(it.label),
            ),
            if (it.badge > 0) ...[
              const SizedBox(width: 7),
              Container(
                constraints: const BoxConstraints(minWidth: 18),
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : cs.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  it.badge > 99 ? '99+' : '${it.badge}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    color: selected ? cs.primary : cs.onPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
