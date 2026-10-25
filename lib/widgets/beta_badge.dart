import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

/// A small "BETA" chip for marking experimental features.
class BetaBadge extends StatelessWidget {
  const BetaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.warning.withAlpha(38),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.warning.withAlpha(120)),
      ),
      child: Text(
        AppLocalizations.of(context).commonBeta,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: AppTheme.warning,
        ),
      ),
    );
  }
}
