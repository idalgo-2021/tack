import 'package:flutter/material.dart';

class HighContrastTheme {
  static ThemeData theme() {
    const Color surface = Color(0xFF000000);
    const Color onSurface = Color(0xFFFFFFFF);
    const Color primary = Color(0xFFFFFFFF);
    const Color onPrimary = Color(0xFF000000);
    const Color secondary = Color(0xFFB0B0B0);
    const Color onSecondary = Color(0xFF000000);
    const Color surfaceContainer = Color(0xFF1A1A1A);
    const Color surfaceContainerHighest = Color(0xFF2A2A2A);
    const Color error = Color(0xFFFF6B6B);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onSurface,
        surfaceContainerHighest: surfaceContainerHighest,
        surfaceContainer: surfaceContainer,
        surfaceTint: surface,
        primaryContainer: surfaceContainer,
        onPrimaryContainer: onSurface,
        outline: onSurface.withAlpha(80),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: onSurface.withAlpha(40)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: surfaceContainerHighest,
        side: BorderSide(color: onSurface.withAlpha(60)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceContainer,
        indicatorColor: primary.withAlpha(50),
        labelTextStyle: WidgetStatePropertyAll(
          const TextStyle(color: onSurface, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceContainer,
        selectedItemColor: onSurface,
        unselectedItemColor: onSurface,
      ),
      scaffoldBackgroundColor: surface,
      dividerColor: onSurface.withAlpha(40),
    );
  }
}

// ignore_for_file: deprecated_member_use
