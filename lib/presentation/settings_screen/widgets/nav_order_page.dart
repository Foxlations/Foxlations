import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/nav_prefs_provider.dart';
import '../../../l10n/app_localizations.dart';

/// Drag-to-reorder the bottom navigation tabs. Bound to [NavPrefsProvider] so
/// the bar updates live as the user reorders.
class NavOrderPage extends StatelessWidget {
  const NavOrderPage({super.key});

  static ({IconData icon, String label}) _meta(String id, AppLocalizations t) {
    switch (id) {
      case 'library':
        return (icon: Icons.collections_bookmark_rounded, label: t.appNavLibrary);
      case 'updates':
        return (icon: Icons.update_rounded, label: t.appNavUpdates);
      case 'browse':
        return (icon: Icons.explore_rounded, label: t.appNavBrowse);
      case 'discover':
        return (icon: Icons.auto_awesome_rounded, label: t.appNavDiscover);
      case 'more':
      default:
        return (icon: Icons.more_horiz_rounded, label: t.appNavMore);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final nav = context.watch<NavPrefsProvider>();
    final order = nav.order;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.setdAppearanceNavOrder,
            style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: nav.reset,
            child: Text(t.setdAppearanceNavOrderReset),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(t.setdAppearanceNavOrderDesc,
                  style: GoogleFonts.manrope(fontSize: 13, color: cs.outline)),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: order.length,
                onReorder: (oldIndex, newIndex) {
                  final list = List<String>.of(order);
                  if (newIndex > oldIndex) newIndex -= 1;
                  list.insert(newIndex, list.removeAt(oldIndex));
                  nav.setOrder(list);
                },
                itemBuilder: (ctx, i) {
                  final id = order[i];
                  final m = _meta(id, t);
                  return Container(
                    key: ValueKey(id),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(m.icon, size: 22, color: cs.primary),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(m.label,
                              style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface)),
                        ),
                        ReorderableDragStartListener(
                          index: i,
                          child: Icon(Icons.drag_handle_rounded,
                              color: cs.outline),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
