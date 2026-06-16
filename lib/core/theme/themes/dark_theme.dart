import 'dart:math';
import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData theme(Color seedColor) {
    final Color adjustedSeed = _adjustSeedForDark(seedColor);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: adjustedSeed,
      brightness: Brightness.dark,
    );

    final Color headerFg = colorScheme.onSurface;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: headerFg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: headerFg,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        indicatorColor: colorScheme.primary.withAlpha(50),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withAlpha(180),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }

  static Color _adjustSeedForDark(Color seed) {
    final hsl = HSLColor.fromColor(seed);
    if (hsl.lightness > 0.65) {
      return hsl.withLightness(max(0.65, hsl.lightness * 0.75)).toColor();
    }
    return seed;
  }
}
