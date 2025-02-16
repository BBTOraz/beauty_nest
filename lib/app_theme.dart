
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF884b6a);
  static const secondary = Color(0xFF725763);
  static const tertiary = Color(0xFF7f553a);
  static const error = Color(0xFFba1a1a);
  static const onPrimary = Color(0xFFffffff);
  static const onSecondary = Color(0xFFffffff);
  static const onTertiary = Color(0xFFffffff);
  static const onPrimaryContainer = Color(0xFF6d3352);
  static const primaryContainer = Color(0xFFffd8e8);
  static const secondaryContainer = Color(0xFFfdd9e7);
  static const tertiaryContainer = Color(0xFFffdbc8);
  static const onErrorContainer = Color(0xFF93000a);
  static const surfaceDim = Color(0xFFe5d6db);
  static const surface = Color(0xFFfff8f8);
  static const surfaceBright = Color(0xFFfff8f8);
  static const surface_2 = Color(0xFFF5F5F5);
  static const textPrimary = Color(0xFF000000);
  static const overlay = Color(0x66000000);
  static const Color success = Colors.green;
}

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onErrorContainer,
      onSurfaceVariant: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceDim,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}
