import 'package:flutter/material.dart';
import 'aura_colors.dart';

class AuraTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AuraColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AuraColors.auraViolet,
        secondary: AuraColors.auraRose,
        tertiary: AuraColors.auraCyan,
        surface: AuraColors.surfaceDark,
        background: AuraColors.backgroundDark,
        error: Colors.redAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: AuraColors.surfaceDarkElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AuraColors.glassBorderDark, width: 1),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AuraColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AuraColors.auraViolet,
        secondary: AuraColors.auraRose,
        tertiary: AuraColors.auraCyan,
        surface: AuraColors.surfaceLight,
        background: AuraColors.backgroundLight,
        error: Colors.redAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: AuraColors.surfaceLightElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AuraColors.glassBorderLight, width: 1),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }
}
