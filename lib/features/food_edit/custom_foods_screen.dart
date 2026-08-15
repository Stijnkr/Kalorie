import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/day_summary.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/panel.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/food.dart';
import '../../data/providers.dart';

class CustomFoodsScreen extends ConsumerWidget {
  const CustomFoodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = context.tones;
    final foods = ref.watch(customFoodsProvider).value ?? const <Food>[];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.ownProducts,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
                    child: Text(
                      l10n.ownProductsIntro,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                    ),
                  ),
                  if (foods.isNotEmpty)
                    KaloriePanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < foods.length; i++) ...[
                            if (i != 0) const KalorieHairline(),
                            InkWell(
                              onTap: () =>
                                  context.push('/food/${foods[i].id}/edit'),
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(minHeight: 64),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    12,
                                    16,
                                    12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              foods[i].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            Text(
                                              foods[i].brand ??
                                                  l10n.per100g,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(color: tones.hint),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${displayKcal(foods[i].kcal100g)}',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
                      child: Text(
                        l10n.ownProductsEmpty,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: tones.hint),
                      ),
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: KalorieSpace.buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/add/custom?stay=1'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      icon: StrokeIcon(
                        StrokeShape.plus,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(l10n.newOwnProduct),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
