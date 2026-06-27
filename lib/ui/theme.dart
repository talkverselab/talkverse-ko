import 'package:flutter/material.dart';
import 'package:k_universe/ui/colors.dart';
import 'package:k_universe/ui/typography.dart';

ThemeData buildLightTheme() {
  final cs = ColorScheme.fromSeed(
    seedColor: KColors.softPink,
    brightness: Brightness.light,
    primary: KColors.softPink,
    onPrimary: Colors.white,
    secondary: KColors.lilac,
    onSecondary: Colors.white,
    tertiary: KColors.buttercream,
    onTertiary: KColors.ink,
    surface: KColors.surface,
    onSurface: KColors.ink,
    surfaceContainerLowest: KColors.surface,
    surfaceContainerLow: KColors.bgCream,
    surfaceContainer: KColors.bgCream,
    surfaceContainerHigh: KColors.surfaceTint,
    surfaceContainerHighest: KColors.surfaceTint,
    primaryContainer: const Color(0xFFFFDDE6),
    onPrimaryContainer: const Color(0xFF5C1F32),
    secondaryContainer: const Color(0xFFE8DEFB),
    onSecondaryContainer: const Color(0xFF32214E),
    tertiaryContainer: const Color(0xFFFFEFC9),
    onTertiaryContainer: const Color(0xFF4A3611),
    outlineVariant: const Color(0xFFF4E6DA),
  );
  return _baseTheme(cs, KColors.bgCream);
}

ThemeData buildDarkTheme() {
  final cs = ColorScheme.fromSeed(
    seedColor: KColors.softPink,
    brightness: Brightness.dark,
    primary: KColors.softPink,
    onPrimary: Colors.white,
    secondary: KColors.lilac,
    onSecondary: Colors.white,
    tertiary: KColors.buttercream,
    onTertiary: KColors.ink,
    surface: KColors.darkSurface,
    onSurface: Colors.white,
  );
  return _baseTheme(cs, KColors.darkBg);
}

ThemeData _baseTheme(ColorScheme cs, Color scaffoldBg) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    scaffoldBackgroundColor: scaffoldBg,
    textTheme: const TextTheme(
      headlineLarge: KType.headlineLarge,
      headlineMedium: KType.headlineMedium,
      titleLarge: KType.titleLarge,
      titleMedium: KType.titleMedium,
      bodyLarge: KType.bodyLarge,
      bodyMedium: KType.bodyMedium,
      labelLarge: KType.labelLarge,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: cs.outlineVariant, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: scaffoldBg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: cs.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: KType.titleLarge.copyWith(
          color: cs.onSurface, fontSize: 22, fontWeight: FontWeight.w800),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        textStyle: KType.labelLarge.copyWith(
            fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.2),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: cs.surface,
      indicatorColor: cs.primaryContainer,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return KType.labelLarge.copyWith(
          fontSize: 11.5,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? cs.primary : KColors.inkSoft,
          letterSpacing: 0.3,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 26,
          color: selected ? cs.onPrimaryContainer : KColors.inkSoft,
        );
      }),
      height: 72,
      elevation: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: cs.outlineVariant,
      thickness: 1,
      space: 1,
    ),
  );
}
