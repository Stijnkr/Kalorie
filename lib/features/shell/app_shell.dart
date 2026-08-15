import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/stroke_icon.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _TabBar(
        currentIndex: navigationShell.currentIndex,
        onSelect: (index) {
          HapticFeedback.selectionClick();
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: [
          (StrokeShape.ring, l10n.tabToday),
          (StrokeShape.square, l10n.tabHistory),
          (StrokeShape.dots, l10n.tabMore),
        ],
      ),
    );
  }
}

/// Doorschijnende balk met haarlijn, zoals in het prototype.
class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.currentIndex,
    required this.onSelect,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;
  final List<(StrokeShape, String)> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.94),
            border: Border(
              top: BorderSide(color: theme.colorScheme.outline, width: 0.5),
            ),
          ),
          child: SizedBox(
            height: KalorieSpace.tabBar + bottomInset,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 8, bottomInset),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _Tab(
                        shape: items[i].$1,
                        label: items[i].$2,
                        selected: i == currentIndex,
                        onTap: () => onSelect(i),
                        activeColor: theme.colorScheme.primary,
                        idleColor: theme.textTheme.bodySmall?.color ??
                            tones.hint,
                        labelColor: theme.colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.shape,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.activeColor,
    required this.idleColor,
    required this.labelColor,
  });

  final StrokeShape shape;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color idleColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : idleColor;
    return InkResponse(
      onTap: onTap,
      containedInkWell: false,
      radius: 32,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
              child: Center(
                child: StrokeIcon(
                  shape,
                  size: shape == StrokeShape.dots ? 20 : 16,
                  color: color,
                  strokeWidth: 2,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                height: 1,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? labelColor : idleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
