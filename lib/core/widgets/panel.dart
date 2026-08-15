import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Inset groep op `surface`, met een haarlijn zodat blokken los van elkaar lezen.
class KaloriePanel extends StatelessWidget {
  const KaloriePanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(KalorieSpace.radiusSheet),
          border: Border.all(color: theme.colorScheme.outline, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(KalorieSpace.radiusSheet),
          child: padding == null
              ? child
              : Padding(padding: padding!, child: child),
        ),
      ),
    );
  }
}

/// Scheiding tussen rijen binnen een paneel: één pixel, volle breedte.
class KalorieHairline extends StatelessWidget {
  const KalorieHairline({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
  });

  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: indent, endIndent: endIndent);
  }
}

/// Zet rijen onder elkaar in één paneel met haarlijnen ertussen.
class KaloriePanelList extends StatelessWidget {
  const KaloriePanelList({
    super.key,
    required this.children,
    this.margin,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return KaloriePanel(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i != 0) const KalorieHairline(),
            children[i],
          ],
        ],
      ),
    );
  }
}
