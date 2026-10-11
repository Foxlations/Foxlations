import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// One item in a [TypeToggle] — an id, its label, and an optional badge count
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(covariant TypeToggle old) {
    super.didUpdateWidget(old);
    if (old.selectedId != widget.selectedId || old.items.length != widget.items.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    }
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : cs.onSurfaceVariant,
              ),
              child: Text(it.label),
            ),
            if (it.badge > 0)
              Positioned(
                top: -6,
                right: -10,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 15),
                  height: 15,
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: cs.surfaceContainerHighest, width: 2),
                  ),
                  child: Text(
                    it.badge > 99 ? '99+' : '${it.badge}',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
