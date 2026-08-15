import 'package:flutter/material.dart';

import '../../data/local/collections/enums.dart';
import '../l10n/generated/app_localizations.dart';

class SourceChip extends StatelessWidget {
  const SourceChip({super.key, required this.source});

  final FoodSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = switch (source) {
      FoodSource.off => l10n.sourceOff,
      FoodSource.nevo => l10n.sourceNevo,
      FoodSource.custom => l10n.sourceCustom,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 0.8,
          fontSize: 10,
        ),
      ),
    );
  }
}
