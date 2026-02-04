import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Standardized spacing values using Gap widget
/// Usage: AppSpacing.small, AppSpacing.medium, AppSpacing.large
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
}
