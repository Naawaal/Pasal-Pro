import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Mix theme maps for Pasal Pro.
/// Provides light and dark token values for MixScope.
class PasalMixTheme {
  PasalMixTheme._();

  /// Returns token maps for the requested brightness.
  static PasalMixThemeData forBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }

  static final light = PasalMixThemeData(
    colors: {
      PasalColorToken.primary.token: AppColors.accent,
      PasalColorToken.onPrimary.token: AppColors.white,
      PasalColorToken.surface.token: AppColors.surface,
      PasalColorToken.surfaceAlt.token: AppColors.background,
      PasalColorToken.surfaceHover.token: AppColors.surfaceHover,
      PasalColorToken.border.token: AppColors.border,
      PasalColorToken.textPrimary.token: AppColors.textPrimary,
      PasalColorToken.textSecondary.token: AppColors.textSecondary,
      PasalColorToken.textTertiary.token: AppColors.textTertiary,
      PasalColorToken.success.token: AppColors.successGreen,
      PasalColorToken.warning.token: AppColors.warningOrange,
      PasalColorToken.error.token: AppColors.dangerRed,
      PasalColorToken.background.token: AppColors.background,
    },
    textStyles: {
      PasalTextStyleToken.headline.token: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'NotoSans',
      ),
      PasalTextStyleToken.title.token: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: 'NotoSans',
      ),
      PasalTextStyleToken.body.token: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSans',
      ),
      PasalTextStyleToken.caption.token: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSans',
      ),
      PasalTextStyleToken.button.token: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontFamily: 'NotoSans',
      ),
    },
    spaces: const {
      PasalSpaceToken.xxSmall: 4.0,
      PasalSpaceToken.xSmall: 8.0,
      PasalSpaceToken.small: 12.0,
      PasalSpaceToken.medium: 16.0,
      PasalSpaceToken.large: 24.0,
      PasalSpaceToken.xLarge: 32.0,
      PasalSpaceToken.xxLarge: 48.0,
      PasalSpaceToken.xxxLarge: 64.0,
    }.map((key, value) => MapEntry(key.token, value)),
    radii: const {
      PasalRadiusToken.small: Radius.circular(6),
      PasalRadiusToken.medium: Radius.circular(8),
      PasalRadiusToken.large: Radius.circular(12),
      PasalRadiusToken.xLarge: Radius.circular(16),
    }.map((key, value) => MapEntry(key.token, value)),
    durations: const {
      PasalDurationToken.fast: Duration(milliseconds: 150),
      PasalDurationToken.normal: Duration(milliseconds: 250),
      PasalDurationToken.slow: Duration(milliseconds: 350),
    }.map((key, value) => MapEntry(key.token, value)),
  );

  static final dark = PasalMixThemeData(
    colors: {
      PasalColorToken.primary.token: AppColors.darkAccentBlue,
      PasalColorToken.onPrimary.token: AppColors.white,
      PasalColorToken.surface.token: AppColors.darkCardBg,
      PasalColorToken.surfaceAlt.token: AppColors.darkBg,
      PasalColorToken.surfaceHover.token: AppColors.darkBorder,
      PasalColorToken.border.token: AppColors.darkBorder,
      PasalColorToken.textPrimary.token: AppColors.darkTextPrimary,
      PasalColorToken.textSecondary.token: AppColors.darkTextSecondary,
      PasalColorToken.textTertiary.token: AppColors.textTertiary,
      PasalColorToken.success.token: AppColors.successGreen,
      PasalColorToken.warning.token: AppColors.warningOrange,
      PasalColorToken.error.token: AppColors.dangerRed,
      PasalColorToken.background.token: AppColors.darkBg,
    },
    textStyles: light.textStyles,
    spaces: light.spaces,
    radii: light.radii,
    durations: light.durations,
  );
}

/// Holds Mix token maps for a theme.
class PasalMixThemeData {
  final Map<ColorToken, Color> colors;
  final Map<TextStyleToken, TextStyle> textStyles;
  final Map<SpaceToken, double> spaces;
  final Map<RadiusToken, Radius> radii;
  final Map<DurationToken, Duration> durations;

  const PasalMixThemeData({
    required this.colors,
    required this.textStyles,
    required this.spaces,
    required this.radii,
    required this.durations,
  });
}
