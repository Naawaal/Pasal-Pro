import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';

/// Standardized spacing values using Gap widget
/// Usage: AppSpacing.small, AppSpacing.medium, AppSpacing.large
///
/// For responsive spacing based on screen size, use:
/// - AppSpacing.responsivePadding(context)
/// - AppSpacing.responsiveSymmetricPadding(context)
class AppSpacing {
  AppSpacing._();

  // Vertical spacing
  static const xxSmall = Gap(4);
  static const xSmall = Gap(8);
  static const small = Gap(12);
  static const medium = Gap(16);
  static const large = Gap(24);
  static const xLarge = Gap(32);
  static const xxLarge = Gap(48);
  static const xxxLarge = Gap(64);

  // Horizontal spacing using SizedBox (Gap is primarily for vertical)
  static const hXxSmall = SizedBox(width: 4);
  static const hXSmall = SizedBox(width: 8);
  static const hSmall = SizedBox(width: 12);
  static const hMedium = SizedBox(width: 16);
  static const hLarge = SizedBox(width: 24);
  static const hXLarge = SizedBox(width: 32);
  static const hXxLarge = SizedBox(width: 48);

  // Common padding values
  static const paddingXxSmall = EdgeInsets.all(4);
  static const paddingXSmall = EdgeInsets.all(8);
  static const paddingSmall = EdgeInsets.all(12);
  static const paddingMedium = EdgeInsets.all(16);
  static const paddingLarge = EdgeInsets.all(24);
  static const paddingXLarge = EdgeInsets.all(32);

  // Asymmetric padding
  static const paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: 12);
  static const paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: 16);
  static const paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: 24);

  static const paddingVerticalSmall = EdgeInsets.symmetric(vertical: 12);
  static const paddingVerticalMedium = EdgeInsets.symmetric(vertical: 16);
  static const paddingVerticalLarge = EdgeInsets.symmetric(vertical: 24);

  // List item spacing
  static const listItemGap = Gap(12);
  static const listSectionGap = Gap(24);

  // Form spacing
  static const formFieldGap = Gap(16);
  static const formSectionGap = Gap(32);

  // Card spacing
  static const cardPadding = EdgeInsets.all(16);
  static const cardMargin = EdgeInsets.all(8);

  // ✨ RESPONSIVE SPACING (Phase 1 Enhancement)
  // Use these methods for layouts that adapt to screen size

  /// Get responsive padding based on screen size
  /// Returns: 8px (small), 12px (medium), 16px (large), 20px (xLarge)
  ///
  /// Usage:
  /// ```dart
  /// Padding(
  ///   padding: AppSpacing.responsivePadding(context),
  ///   child: MyWidget(),
  /// )
  /// ```
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(
      AppResponsive.getValue<double>(
        context,
        small: 8,
        medium: 12,
        large: 16,
        xLarge: 20,
      ),
    );
  }

  /// Get responsive symmetric padding for horizontal or vertical direction
  ///
  /// Usage (horizontal):
  /// ```dart
  /// Padding(
  ///   padding: AppSpacing.responsiveSymmetricPadding(context, horizontal: true),
  ///   child: MyRow(),
  /// )
  /// ```
  static EdgeInsets responsiveSymmetricPadding(
    BuildContext context, {
    bool horizontal = true,
  }) {
    final padding = AppResponsive.getValue<double>(
      context,
      small: 8,
      medium: 12,
      large: 16,
      xLarge: 20,
    );

    if (horizontal) {
      return EdgeInsets.symmetric(horizontal: padding, vertical: 0);
    }
    return EdgeInsets.symmetric(vertical: padding, horizontal: 0);
  }

  /// Get responsive gap for spacing between widgets in a column/row
  /// Returns: 12px (small), 16px (medium), 20px (large), 24px (xLarge)
  static Gap responsiveGap(BuildContext context) {
    return Gap(
      AppResponsive.getValue<double>(
        context,
        small: 12,
        medium: 16,
        large: 20,
        xLarge: 24,
      ),
    );
  }
}
