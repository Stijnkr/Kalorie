import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import 'stroke_icon.dart';

/// Kop van een overlay-scherm: chevron terug, titel, optionele actie rechts.
class KalorieOverlayHeader extends StatelessWidget {
  const KalorieOverlayHeader({
    super.key,
    required this.title,
    this.onBack,
    this.action,
    this.closeIcon = false,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? action;

  /// Kruisje in plaats van een chevron (scanner, nieuw product).
  final bool closeIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
      child: Row(
        children: [
          if (onBack != null)
            KalorieTapTarget(
              onTap: onBack!,
              child: StrokeIcon(
                closeIcon ? StrokeShape.close : StrokeShape.chevronLeft,
                size: closeIcon ? 14 : 16,
                color: onSurface,
                strokeWidth: closeIcon ? 1.7 : 1.8,
              ),
            )
          else
            const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: context.tones.hint),
                  ),
              ],
            ),
          ),
          if (action != null) action! else const SizedBox(width: 14),
        ],
      ),
    );
  }
}

/// Vierkant raakvlak van 44×44 zoals in het prototype, zonder Material-ripple
/// die de rustige vlakken zou opbreken.
class KalorieTapTarget extends StatelessWidget {
  const KalorieTapTarget({
    super.key,
    required this.child,
    required this.onTap,
    this.size = 44,
    this.enabled = true,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback onTap;
  final double size;
  final bool enabled;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = InkResponse(
      onTap: enabled ? onTap : null,
      radius: size / 2,
      containedInkWell: false,
      child: SizedBox(
        width: size,
        height: size,
        child: Opacity(opacity: enabled ? 1 : 0.3, child: Center(child: child)),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// Pill-vormige keuzeknop (portie, filter, maaltijd).
class KaloriePill extends StatelessWidget {
  const KaloriePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.large = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Iets ruimere variant voor de onboarding.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sage = theme.colorScheme.primary;
    return Material(
      color: selected ? sage : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: large ? 16 : 14,
            vertical: large ? 10 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? sage : theme.colorScheme.outline,
              width: 0.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: large ? 14 : 13,
              height: 1.2,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Schakelaar van 46×28 met witte knop, zoals in Instellingen.
class KalorieToggle extends StatelessWidget {
  const KalorieToggle({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final track = value ? theme.colorScheme.primary : context.tones.handle;
    return GestureDetector(
      onTap: onChanged == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onChanged!(!value);
            },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        width: 46,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(99),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Vierkante plus/min-knop met haarlijnrand (portie, doel, gewicht).
class KalorieStepButton extends StatelessWidget {
  const KalorieStepButton({
    super.key,
    required this.plus,
    required this.onTap,
    this.size = 52,
    this.radius = 14,
    this.filled = true,
    this.enabled = true,
  });

  final bool plus;
  final VoidCallback onTap;
  final double size;
  final double radius;

  /// `false` laat de knop op de paginakleur staan (Doelen, Gewicht).
  final bool filled;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: Material(
        color: filled ? theme.colorScheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: enabled
              ? () {
                  HapticFeedback.selectionClick();
                  onTap();
                }
              : null,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: theme.colorScheme.outline, width: 0.5),
            ),
            child: StrokeIcon(
              plus ? StrokeShape.plus : StrokeShape.minus,
              size: size * 0.29,
              color: theme.colorScheme.onSurface,
              strokeWidth: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}

/// Getinte plusknop van 44×44 die een product direct in de dag boekt.
class KalorieQuickAdd extends StatelessWidget {
  const KalorieQuickAdd({
    super.key,
    required this.onTap,
    this.enabled = true,
    this.tooltip,
  });

  final VoidCallback onTap;
  final bool enabled;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = Material(
      color: context.tones.tint,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled
            ? () {
                HapticFeedback.lightImpact();
                onTap();
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: StrokeIcon(
              StrokeShape.plus,
              size: 15,
              color: theme.colorScheme.primary,
              strokeWidth: 1.9,
            ),
          ),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// Voortgangsbalkje met afgeronde uiteinden.
class KalorieBar extends StatelessWidget {
  const KalorieBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color,
    this.animate = true,
  });

  final double value;
  final double height;
  final Color? color;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = color ?? theme.colorScheme.primary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: height,
        child: ColoredBox(
          color: context.tones.track,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: animate
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        color: fill,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: fill,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rij binnen een paneel: naam met ondertitel, optionele waarde en chevron.
class KaloriePanelTile extends StatelessWidget {
  const KaloriePanelTile({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.chevron = false,
    this.minHeight = 56,
    this.titleColor,
    this.titleStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  final String title;
  final String? subtitle;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool chevron;
  final double minHeight;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tones = context.tones;

    final row = Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: (titleStyle ?? theme.textTheme.bodyMedium)
                      ?.copyWith(color: titleColor),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: tones.hint),
                  ),
              ],
            ),
          ),
          if (value != null && value!.isNotEmpty) ...[
            const SizedBox(width: 12),
            Text(value!, style: theme.textTheme.bodySmall),
          ],
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          if (chevron) ...[
            const SizedBox(width: 12),
            StrokeIcon(
              StrokeShape.chevronRight,
              size: 14,
              color: tones.faint,
              strokeWidth: 1.7,
            ),
          ],
        ],
      ),
    );

    final content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: row,
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}

/// Rubriekkopje in kapitalen, bijvoorbeeld "MAALTIJD".
class KalorieSectionLabel extends StatelessWidget {
  const KalorieSectionLabel(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.only(bottom: 10),
  });

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

/// Voetbalk met een gradiënt zodat de lijst onder de knop wegvalt.
class KalorieFooterAction extends StatelessWidget {
  const KalorieFooterAction({
    super.key,
    required this.child,
    this.note,
  });

  final Widget child;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paper = theme.scaffoldBackgroundColor;
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [paper.withValues(alpha: 0), paper],
          stops: const [0, 0.4],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (note != null && note!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 10),
              child: Text(note!, style: theme.textTheme.bodySmall),
            ),
          ],
          child,
        ],
      ),
    );
  }
}
