import 'package:flutter/material.dart';
import 'themes/light_theme.dart';
import 'themes/dark_theme.dart';
import 'themes/high_contrast_theme.dart';

class AppTheme {
  static ThemeData light(Color seedColor) => LightTheme.theme(seedColor);
  static ThemeData dark(Color seedColor) => DarkTheme.theme(seedColor);
  static ThemeData highContrast() => HighContrastTheme.theme();
}
