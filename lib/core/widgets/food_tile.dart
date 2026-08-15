import 'package:flutter/material.dart';

import '../../data/local/collections/food.dart';
import '../day_summary.dart';
import 'source_chip.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({
    super.key,
    required this.food,
    this.onTap,
    this.trailing,
  });

  final Food food;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = [
      if (food.brand != null && food.brand!.isNotEmpty) food.brand,
      '${displayKcal(food.kcal100g)} kcal / 100 g',
    ].join(' · ');

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      title: Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      leading: SourceChip(source: food.source),
      trailing: trailing ??
          Text(
            '${displayMacro(food.protein100g)} / ${displayMacro(food.carbs100g)} / ${displayMacro(food.fat100g)}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
    );
  }
}
