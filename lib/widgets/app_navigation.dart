import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'library_type_menu.dart' show libraryTypeIcon;

class AppNavigation extends StatefulWidget {
  /// Tab ids in display order (see NavPrefsProvider.canonical).
  final List<String> tabIds;

  /// The currently-active tab id (always a screen tab — `more` opens Settings).
  final String activeId;

  /// Invoked with the tapped tab's id.
  final ValueChanged<String> onTapId;

  final bool isVaultMode;
  final int updatesBadge;

  /// Count of installed extensions with a newer version available (Browse tab).
  final int browseBadge;

  /// Current Library content type ('manga' | 'anime' | 'novel'); the Library
  /// tab's icon reflects it. Ignored while [isVaultMode] is on.
  final String contentType;

  /// Invoked when the Library tab is long-pressed, with the tab's global rect
  /// so the content-type bubble can anchor itself just above it.
  final void Function(Rect anchor)? onLibraryLongPress;

  const AppNavigation({
    super.key,
    required this.tabIds,
    required this.activeId,
    required this.onTapId,
    this.isVaultMode = false,
    this.updatesBadge = 0,
    this.browseBadge = 0,
    this.contentType = 'manga',
    this.onLibraryLongPress,
  });

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _snakeController;
  late Animation<double> _snakeAnimation;
  int _previousIndex = 0;

  int get _currentIndex {
    final i = widget.tabIds.indexOf(widget.activeId);
    return i < 0 ? 0 : i;
  }

  @override
  void initState() {
    super.initState();
    _snakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _snakeAnimation = CurvedAnimation(
      parent: _snakeController,
      curve: Curves.easeOutCubic,
    );
    _previousIndex = _currentIndex;
  }

  @override
  void didUpdateWidget(AppNavigation old) {
    super.didUpdateWidget(old);
    final oldIdx = old.tabIds.indexOf(old.activeId);
    final newIdx = _currentIndex;
    if (oldIdx != newIdx) {
      _previousIndex = oldIdx < 0 ? newIdx : oldIdx;
      _snakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _snakeController.dispose();
    super.dispose();
  }

  // Icon + label for a tab id. Library's icon is dynamic (content type / vault).
  ({IconData icon, IconData activeIcon, String label}) _meta(
      String id, AppLocalizations t) {
    switch (id) {
      case 'library':
        if (widget.isVaultMode) {
          return (
            icon: Icons.shield_outlined,
            activeIcon: Icons.shield_rounded,
            label: t.appNavVault
          );
        }
        return (
          icon: libraryTypeIcon(widget.contentType),
          activeIcon: libraryTypeIcon(widget.contentType, active: true),
          label: t.appNavLibrary
        );
      case 'updates':
        return (
          icon: Icons.update_outlined,
          activeIcon: Icons.update,
          label: t.appNavUpdates
        );
      case 'browse':
        return (
          icon: Icons.explore_outlined,
          activeIcon: Icons.explore,
          label: t.appNavBrowse
        );
      case 'discover':
        return (
          icon: Icons.auto_awesome_outlined,
          activeIcon: Icons.auto_awesome,
          label: t.appNavDiscover
        );
      case 'more':
      default:
        return (
          icon: Icons.more_horiz_rounded,
          activeIcon: Icons.more_horiz,
          label: t.appNavMore
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final count = widget.tabIds.length;
    final tabWidth = width / count;
    // The tab Row lays out start-to-end, so in RTL index 0 sits on the RIGHT;
    // Positioned.left is always physical-left, so mirror the index for RTL.
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bottomInset = mq.viewPadding.bottom > 0 ? mq.viewPadding.bottom : 8.0;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 64,
        child: Stack(
          children: [
            // Snake indicator
            AnimatedBuilder(
              animation: _snakeAnimation,
              builder: (_, __) {
                double xFor(int i) {
                  final visual = isRtl ? (count - 1 - i) : i;
                  return visual * tabWidth + tabWidth / 2 - 32;
                }

                final fromX = xFor(_previousIndex);
                final toX = xFor(_currentIndex);
                final currentX = fromX + (toX - fromX) * _snakeAnimation.value;
                return Positioned(
                  left: currentX,
                  top: 4,
                  child: Container(
                    width: 64,
                    height: 52,
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
            // Tab buttons
            Row(
              children: List.generate(count, (index) {
                final id = widget.tabIds[index];
                final isActive = id == widget.activeId;
                final m = _meta(id, t);
                return Expanded(
                  child: Builder(
                    builder: (itemContext) => GestureDetector(
                      onTap: () => widget.onTapId(id),
                      // Long-pressing Library opens the content-type bubble,
                      // anchored to this tab's on-screen position.
                      onLongPress:
                          id == 'library' && widget.onLibraryLongPress != null
                              ? () {
                                  final box = itemContext.findRenderObject()
                                      as RenderBox?;
                                  if (box == null || !box.hasSize) return;
                                  widget.onLibraryLongPress!(
                                      box.localToGlobal(Offset.zero) & box.size);
                                }
                              : null,
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AnimatedSwitcher(
                                duration: AppTheme.fastMicro,
                                child: Icon(
                                  isActive ? m.activeIcon : m.icon,
                                  key: ValueKey(
                                      '${isActive}_${widget.isVaultMode}_${id == 'library' ? widget.contentType : ''}'),
                                  size: 22,
                                  color: isActive ? cs.primary : cs.outline,
                                ),
                              ),
                              if (id == 'updates' && widget.updatesBadge > 0)
                                PositionedDirectional(
                                  end: -6,
                                  top: -4,
                                  child: _badge(cs, widget.updatesBadge),
                                ),
                              if (id == 'browse' && widget.browseBadge > 0)
                                PositionedDirectional(
                                  end: -6,
                                  top: -4,
                                  child: _badge(cs, widget.browseBadge),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            m.label,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive ? cs.primary : cs.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(ColorScheme cs, int n) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          n > 99 ? '99+' : '$n',
          style: GoogleFonts.manrope(
              fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white),
        ),
      );
}
