import 'package:flutter/material.dart';
import 'package:rick_and_morty_exporer/app/theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: LightAppColors.primary,
      onPrimary: Colors.white,
      secondary: LightAppColors.secondary,
      onSecondary: Colors.white,
      error: Colors.red.shade700,
      onError: Colors.white,
      surface: LightAppColors.surface,
      onSurface: LightAppColors.textPrimary,
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: LightAppColors.background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: LightAppColors.surface,
        foregroundColor: LightAppColors.textPrimary,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: DarkAppColors.primary,
      onPrimary: Colors.black,
      secondary: DarkAppColors.secondary,
      onSecondary: Colors.black,
      error: Colors.red.shade300,
      onError: Colors.black,
      surface: DarkAppColors.surface,
      onSurface: DarkAppColors.textPrimary,
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: DarkAppColors.background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: DarkAppColors.surface,
        foregroundColor: DarkAppColors.textPrimary,
      ),
      useMaterial3: true,
    );
  }
}
