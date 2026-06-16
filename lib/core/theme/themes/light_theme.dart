import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData theme(Color seedColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    final Color headerFg = seedColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;

    final double lum = seedColor.computeLuminance();
    final Color navBg = lum < 0.3
        ? Color.lerp(seedColor, Colors.white, 0.3)!
        : seedColor;
    final Color navFg = navBg.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: seedColor,
        foregroundColor: headerFg,
        elevation: 0,
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
        backgroundColor: navBg,
        indicatorColor: navFg.withAlpha(40),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: navFg, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: navBg,
        selectedItemColor: navFg,
        unselectedItemColor: navFg.withAlpha(180),
      ),
    );
  }
}
