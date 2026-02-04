import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';

/// Ultra-Modern Flat Design Theme
/// Zero Material 3 - Pure contemporary flat aesthetics
class AppTheme {
  AppTheme._();

  // Semantic color getters for business logic
  static Color get profitColor => AppColors.green500;
  static Color get lossColor => AppColors.red500;
  static Color get lowStockColor => AppColors.orange500;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        surface: AppColors.background,
        surfaceContainerHighest: AppColors.surfaceHover,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        error: AppColors.red500,
        outline: AppColors.border,
      ),

      // Modern flat card theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.border),
        ),
      ),

      // Borderless input theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: AppColors.textTertiary),
      ),

      // Clean app bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
