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

  static const paperDark = Color(0xFF121411);
  static const inkDark = Color(0xFFE7E2D8);
  static const sageDark = Color(0xFF8FB59C);
  static const ruleDark = Color(0xFF2A2B26);
  static const mutedDark = Color(0xFF9A9C94);
  static const mutedStrongDark = Color(0xFFB8BAB2);
  static const surfaceDark = Color(0xFF1B1C18);
}

abstract final class KalorieSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 28.0;
  static const screen = 24.0;
  static const radius = 12.0;
  static const radiusSheet = 16.0;
  static const buttonHeight = 52.0;
}

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

  final scheme = ColorScheme(
    brightness: brightness,
    primary: sage,
    onPrimary: isDark ? KalorieColors.paperDark : Colors.white,
    secondary: sage,
    onSecondary: isDark ? KalorieColors.paperDark : Colors.white,
    error: const Color(0xFF8C4A3A),
    onError: Colors.white,
    surface: surface,
    onSurface: ink,
    outline: rule,
    outlineVariant: rule,
  );

  final textTheme = ThemeData(brightness: brightness).textTheme.apply(
    bodyColor: ink,
    displayColor: ink,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: paper,
    canvasColor: paper,
    textTheme: textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w500,
        height: 0.95,
        letterSpacing: -1.6,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.6,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        fontSize: 15,
        height: 1.4,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        fontSize: 13,
        height: 1.35,
        color: muted,
      ),
      labelSmall: textTheme.labelSmall?.copyWith(
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w500,
        color: muted,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: paper,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: ink,
        fontWeight: FontWeight.w500,
        fontSize: 17,
      ),
    ),
    dividerColor: rule,
    dividerTheme: DividerThemeData(color: rule, thickness: 0.5, space: 1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: sage,
      foregroundColor: isDark ? KalorieColors.paperDark : Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: paper,
      elevation: 0,
      height: 64,
      indicatorColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? ink : muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: selected ? 24 : 22,
          color: selected ? sage : muted,
        );
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: rule),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: rule),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KalorieSpace.radius),
        borderSide: BorderSide(color: sage, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: sage,
        foregroundColor: isDark ? KalorieColors.paperDark : Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(KalorieSpace.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KalorieSpace.radiusSheet),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: sage),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      selectedColor: sage.withValues(alpha: 0.12),
      side: BorderSide(color: rule),
      labelStyle: TextStyle(color: ink, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      showCheckmark: false,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: mutedStrong,
      textColor: ink,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      minVerticalPadding: 16,
      subtitleTextStyle: TextStyle(
        fontSize: 13,
        height: 1.35,
        color: muted.withValues(alpha: 0.82),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ink,
      contentTextStyle: TextStyle(color: paper, fontSize: 15),
      actionTextColor: KalorieColors.sageDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      dragHandleSize: const Size(32, 4),
      showDragHandle: true,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
