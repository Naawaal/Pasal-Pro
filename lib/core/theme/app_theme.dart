import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';

/// Modern Flat Design theme configuration for Pasal Pro
/// Research-backed design system (not Material 3 defaults)
/// Features: Modern flat aesthetics, bold color accents, accessibility-first
class AppTheme {
  AppTheme._();

  /// Light theme configuration - Modern Flat Design
  static ThemeData get lightTheme {
    return _buildLightTheme();
  }

  /// Dark theme configuration - Modern Flat Design (optional)
  static ThemeData get darkTheme {
    return _buildDarkTheme();
  }

  /// Semantic color getters for business logic
  static Color get profitColor => AppColors.successGreen;
  static Color get lossColor => AppColors.dangerRed;
  static Color get lowStockColor => AppColors.warningOrange;

  /// Build light theme with modern flat design
  static ThemeData _buildLightTheme() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.successGreen,
      tertiary: AppColors.warningOrange,
      error: AppColors.dangerRed,
      surface: AppColors.bgWhite,
      onPrimary: AppColors.bgWhite,
      onSecondary: AppColors.bgWhite,
      onTertiary: AppColors.bgWhite,
      onError: AppColors.bgWhite,
      onSurface: AppColors.textPrimary,
    );

    return _buildTheme(colorScheme);
  }

  /// Build dark theme (optional future use)
  static ThemeData _buildDarkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.darkAccentBlue,
      secondary: AppColors.successGreen,
      tertiary: AppColors.warningOrange,
      error: AppColors.dangerRed,
      surface: AppColors.darkCardBg,
      onPrimary: AppColors.darkBg,
      onSecondary: AppColors.darkBg,
      onTertiary: AppColors.darkBg,
      onError: AppColors.darkBg,
      onSurface: AppColors.darkTextPrimary,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Typography - Inter font (modern flat design standard)
      textTheme: _buildTextTheme(colorScheme),
      fontFamily: 'NotoSans', // Fallback to existing font, can upgrade to Inter
      // Card theme - Ultra flat (no shadow, minimal border)
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Input decoration theme - Modern flat style
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borderColorDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        hintStyle: TextStyle(
          color: AppColors.textTertiary,
          fontStyle: FontStyle.italic,
        ),
      ),

      // Filled button theme (primary action)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Outlined button theme (secondary action)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          side: const BorderSide(color: AppColors.borderColorDark),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Text button theme (tertiary action)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          minimumSize: const Size(0, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // App bar theme - Compact (48px height)
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 48,
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.surface,
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Navigation rail theme (for future desktop nav)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: AppColors.primaryBlue.withValues(alpha: 0.1),
        elevation: 0,
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Large headline (28px)
      displayLarge: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      ),

      // Section header (20px)
      headlineLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),

      // Card title (16px)
      titleLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),

      // Body large (16px)
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),

      // Body regular (14px) - default
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),

      // Body small (12px)
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0,
        color: AppColors.textSecondary,
      ),

      // Label (12px, semibold)
      labelLarge: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      ),
    );
  }
}
