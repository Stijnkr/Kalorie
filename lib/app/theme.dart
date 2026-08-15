import 'package:flutter/material.dart';

abstract final class KalorieColors {
  static const paper = Color(0xFFF4F1EA);
  static const ink = Color(0xFF1A211C);
  static const sage = Color(0xFF3F5A4A);
  static const sageSoft = Color(0xFF7A9A86);
  static const rule = Color(0xFFE4DDD2);
  static const muted = Color(0xFF6E736C);
  static const mutedStrong = Color(0xFF545A54);
  static const surface = Color(0xFFFBFAF6);
  static const hint = Color(0xFF8A8F88);
  static const faint = Color(0xFFB3ABA0);
  static const handle = Color(0xFFD6CEC2);
  static const dashed = Color(0xFFC9C1B5);
  static const danger = Color(0xFF8C4A3A);

  static const paperDark = Color(0xFF121411);
  static const inkDark = Color(0xFFE7E2D8);
  static const sageDark = Color(0xFF8FB59C);
  static const ruleDark = Color(0xFF2A2B26);
  static const mutedDark = Color(0xFF9A9C94);
  static const mutedStrongDark = Color(0xFFB8BAB2);
  static const surfaceDark = Color(0xFF1B1C18);
  static const hintDark = Color(0xFF83867E);
  static const faintDark = Color(0xFF5F625B);
  static const handleDark = Color(0xFF3A3C35);
  static const dashedDark = Color(0xFF4A4C44);
  static const dangerDark = Color(0xFFD08A76);
}

abstract final class KalorieSpace {
  /// Marge rondom de kaarten op een scherm.
  static const screen = 16.0;
  static const radius = 12.0;
  static const radiusSheet = 16.0;
  static const buttonHeight = 52.0;

  /// Hoogte van de tabbalk uit het prototype (inclusief homebalk-ruimte).
  static const tabBar = 66.0;
}

/// Tinten die Material niet kent maar het prototype wel: subtiel grijs voor
/// subtitels, haarlijn-grijs voor chevrons, en de doorschijnende sage-vlakken.
@immutable
class KalorieTones extends ThemeExtension<KalorieTones> {
  const KalorieTones({
    required this.hint,
    required this.faint,
    required this.handle,
    required this.dashed,
    required this.tint,
    required this.track,
    required this.sageSoft,
    required this.danger,
  });

  /// Subtitels onder een naam (13 px).
  final Color hint;

  /// Chevrons, kruisjes, lege waarden.
  final Color faint;

  /// Greep bovenaan een bottom sheet.
  final Color handle;

  /// Streepjeslijn van het dagdoel in de weekgrafiek.
  final Color dashed;

  /// Vlak achter de ronde plus-knop.
  final Color tint;

  /// Achtergrond van voortgangsbalkjes.
  final Color track;

  final Color sageSoft;
  final Color danger;

  @override
  KalorieTones copyWith({
    Color? hint,
    Color? faint,
    Color? handle,
    Color? dashed,
    Color? tint,
    Color? track,
    Color? sageSoft,
    Color? danger,
  }) {
    return KalorieTones(
      hint: hint ?? this.hint,
      faint: faint ?? this.faint,
      handle: handle ?? this.handle,
      dashed: dashed ?? this.dashed,
      tint: tint ?? this.tint,
      track: track ?? this.track,
      sageSoft: sageSoft ?? this.sageSoft,
      danger: danger ?? this.danger,
    );
  }

  @override
  KalorieTones lerp(ThemeExtension<KalorieTones>? other, double t) {
    if (other is! KalorieTones) return this;
    return KalorieTones(
      hint: Color.lerp(hint, other.hint, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
      handle: Color.lerp(handle, other.handle, t)!,
      dashed: Color.lerp(dashed, other.dashed, t)!,
      tint: Color.lerp(tint, other.tint, t)!,
      track: Color.lerp(track, other.track, t)!,
      sageSoft: Color.lerp(sageSoft, other.sageSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension KalorieToneAccess on BuildContext {
  KalorieTones get tones => Theme.of(this).extension<KalorieTones>()!;
}

const _tnum = [FontFeature.tabularFigures()];

ThemeData kalorieTheme({required Brightness brightness}) {
  final isDark = brightness == Brightness.dark;
  final ink = isDark ? KalorieColors.inkDark : KalorieColors.ink;
  final paper = isDark ? KalorieColors.paperDark : KalorieColors.paper;
  final sage = isDark ? KalorieColors.sageDark : KalorieColors.sage;
  final muted = isDark ? KalorieColors.mutedDark : KalorieColors.muted;
  final mutedStrong =
      isDark ? KalorieColors.mutedStrongDark : KalorieColors.mutedStrong;
  final rule = isDark ? KalorieColors.ruleDark : KalorieColors.rule;
  final surface = isDark ? KalorieColors.surfaceDark : KalorieColors.surface;
  final danger = isDark ? KalorieColors.dangerDark : KalorieColors.danger;
  final onSage = isDark ? KalorieColors.paperDark : Colors.white;

  final tones = KalorieTones(
    hint: isDark ? KalorieColors.hintDark : KalorieColors.hint,
    faint: isDark ? KalorieColors.faintDark : KalorieColors.faint,
    handle: isDark ? KalorieColors.handleDark : KalorieColors.handle,
    dashed: isDark ? KalorieColors.dashedDark : KalorieColors.dashed,
    tint: sage.withValues(alpha: isDark ? 0.16 : 0.10),
    track: sage.withValues(alpha: isDark ? 0.20 : 0.13),
    sageSoft: isDark ? KalorieColors.sageDark : KalorieColors.sageSoft,
    danger: danger,
  );

  final scheme = ColorScheme(
    brightness: brightness,
    primary: sage,
    onPrimary: onSage,
    secondary: sage,
    onSecondary: onSage,
    error: danger,
    onError: Colors.white,
    surface: surface,
    onSurface: ink,
    outline: rule,
    outlineVariant: rule,
  );

  final base = ThemeData(brightness: brightness).textTheme.apply(
    bodyColor: ink,
    displayColor: ink,
  );

  final textTheme = base.copyWith(
    // 56 px — "kcal over" op de dagkaart en het gewicht.
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 56,
      fontWeight: FontWeight.w500,
      height: 0.95,
      letterSpacing: -1.6,
      fontFeatures: _tnum,
    ),
    // 44 px — kcal in het portiescherm.
    displayMedium: base.displayMedium?.copyWith(
      fontSize: 44,
      fontWeight: FontWeight.w500,
      height: 1,
      letterSpacing: -1.2,
      fontFeatures: _tnum,
    ),
    // 40 px — dagdoel in Doelen.
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 40,
      fontWeight: FontWeight.w500,
      height: 1,
      letterSpacing: -1,
      fontFeatures: _tnum,
    ),
    // 34 px — onboarding-kop.
    headlineLarge: base.headlineLarge?.copyWith(
      fontSize: 34,
      fontWeight: FontWeight.w500,
      height: 1.12,
      letterSpacing: -1,
    ),
    // 28 px — productnaam in het portiescherm.
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      height: 1.15,
      letterSpacing: -0.6,
    ),
    // 22 px — macrocijfer, weekgemiddelde.
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      height: 1.1,
      fontFeatures: _tnum,
    ),
    // 17 px — schermtitels en kcal-waarden in rijen.
    titleMedium: base.titleMedium?.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0,
      fontFeatures: _tnum,
    ),
    // 15 px medium — links en knoplabels binnen kaarten.
    titleSmall: base.titleSmall?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 15,
      height: 1.55,
      fontWeight: FontWeight.w400,
      color: mutedStrong,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 15,
      height: 1.35,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: 13,
      height: 1.35,
      fontWeight: FontWeight.w400,
      color: muted,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: 12,
      height: 1.5,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: muted,
    ),
    // 11 px met spatiëring — rubriekkopjes als "MAALTIJD".
    labelSmall: base.labelSmall?.copyWith(
      fontSize: 11,
      height: 1,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w400,
      color: muted,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: paper,
    canvasColor: paper,
    extensions: [tones],
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: paper,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      titleTextStyle: textTheme.titleMedium?.copyWith(color: ink),
    ),
    dividerColor: rule,
    dividerTheme: DividerThemeData(color: rule, thickness: 1, space: 1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: sage,
      foregroundColor: onSage,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: textTheme.bodyMedium?.copyWith(color: tones.hint),
      labelStyle: textTheme.bodyMedium?.copyWith(color: muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: rule, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: rule, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: sage, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: danger, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: danger, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: sage,
        foregroundColor: onSage,
        disabledBackgroundColor: sage.withValues(alpha: 0.4),
        disabledForegroundColor: onSage.withValues(alpha: 0.85),
        elevation: 0,
        minimumSize: const Size.fromHeight(KalorieSpace.buttonHeight),
        textStyle: textTheme.titleMedium,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KalorieSpace.radiusSheet),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        minimumSize: const Size.fromHeight(KalorieSpace.buttonHeight),
        textStyle: textTheme.titleSmall,
        side: BorderSide(color: rule, width: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KalorieSpace.radiusSheet),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: sage,
        textStyle: textTheme.titleSmall,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: muted,
        minimumSize: const Size(44, 44),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      selectedColor: sage,
      side: BorderSide(color: rule, width: 0.5),
      labelStyle: TextStyle(color: ink, fontSize: 13),
      secondaryLabelStyle: TextStyle(color: onSage, fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      showCheckmark: false,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: mutedStrong,
      textColor: ink,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 14,
      titleTextStyle: textTheme.bodyMedium,
      subtitleTextStyle: textTheme.bodySmall?.copyWith(color: tones.hint),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ink,
      contentTextStyle: TextStyle(color: paper, fontSize: 15, height: 1.3),
      actionTextColor: KalorieColors.sageDark,
      behavior: SnackBarBehavior.floating,
      insetPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: paper,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalBarrierColor: KalorieColors.ink.withValues(alpha: 0.32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(KalorieSpace.radiusSheet),
        ),
      ),
      dragHandleColor: tones.handle,
      dragHandleSize: const Size(32, 4),
      showDragHandle: true,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleMedium,
      contentTextStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: sage,
      linearTrackColor: tones.track,
    ),
    splashFactory: InkRipple.splashFactory,
  );
}
