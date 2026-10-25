import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_lock_provider.dart';
import '../../l10n/app_localizations.dart';

/// Covers the app with a lock screen while [AppLockProvider.locked] is true and
/// auto-prompts for device authentication once per lock episode. If the user
/// dismisses the prompt they stay locked with a manual "Unlock" button to retry.
class AppLockGate extends StatefulWidget {
  final Widget child;
  const AppLockGate({super.key, required this.child});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> {
  bool _promptedThisLock = false;

  Future<void> _tryUnlock() async {
    final t = AppLocalizations.of(context);
    await context.read<AppLockProvider>().unlock(t.securityUnlockReason);
  }

  @override
  Widget build(BuildContext context) {
    final locked = context.watch<AppLockProvider>().locked;
    if (!locked) {
      _promptedThisLock = false;
      return widget.child;
    }

    // Auto-prompt exactly once per lock episode.
    if (!_promptedThisLock) {
      _promptedThisLock = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.read<AppLockProvider>().locked) _tryUnlock();
      });
    }

    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: Scaffold(
        backgroundColor: cs.surface,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_rounded, size: 56, color: cs.primary),
              const SizedBox(height: 18),
              Text(
                t.securityLockedTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _tryUnlock,
                icon: const Icon(Icons.lock_open_rounded, size: 18),
                label: Text(t.securityUnlock),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
