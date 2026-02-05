import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Sales feature-specific spacing and layout constants
/// Built on AppResponsive breakpoints (1366px, 1920px, 2560px)
///
/// Usage:
/// ```dart
/// Gap(SalesSpacing.inputFieldSpacing) // Vertical spacing
/// SalesSpacing.inputFieldSpacing // Direct double value
/// ```
class SalesSpacing {
  SalesSpacing._();

  // Gap Widget Shortcuts (like AppSpacing)
  static const Gap xSmall = Gap(8);
  static const Gap small = Gap(12);
  static const Gap medium = Gap(16);
  static const Gap large = Gap(24);

  // Form structure spacing
  static const double formPaddingHorizontal = 20.0;
  static const double formPaddingVertical = 20.0;
  static const double inputFieldSpacing = 16.0; // Gap between form fields
  static const double formSectionGap = 24.0; // Gap between form sections

  // Input field dimensions
  static const double inputFieldHeight = 56.0; // Material 3 standard
  static const double inputBorderRadius = 8.0; // Modern flat design
  static const double inputBorderWidth = 1.0;
  static const double inputContentPadding = 16.0;

  // Profit display box (prominent KPI)
  static const double profitBoxPadding = 16.0;
  static const double profitBoxBorderRadius = 8.0;
  static const double profitBoxFontSize = 28.0; // Match dashboard metric cards
  static const double profitBoxLabelFontSize = 12.0;
  static const double profitBoxMarginFontSize = 14.0;

  // Sales log table
  static const double logRowHeight =
      52.0; // Slightly larger than 48px for data density
  static const double logRowHoverElevation = 2.0;
  static const double logHeaderPadding = 12.0;
  static const double logCellPadding = 12.0;
  static const double logIconSize = 20.0;
  static const double logBorderRadius = 8.0;

  // Button dimensions
  static const double submitButtonHeight = 48.0; // Touchable minimum
  static const double submitButtonBorderRadius = 8.0;
  static const double removeButtonSize = 32.0; // Icon button in log
  static const double undoButtonHeight = 40.0;

  // Typography sizing
  static const double fieldLabelFontSize = 13.0;
  static const double fieldHintFontSize = 14.0;
  static const double fieldInputFontSize = 16.0;
  static const double fieldErrorFontSize = 12.0;
  static const double logHeaderFontSize = 12.0;
  static const double logCellFontSize = 14.0;
  static const double totalsFontSize = 16.0; // Daily totals display
  static const double totalsValueFontSize = 24.0; // Daily totals values

  // Autocomplete dropdown
  static const double dropdownMaxHeight = 300.0;
  static const double dropdownItemHeight = 56.0;
  static const double dropdownBorderRadius = 8.0;
  static const double dropdownElevation = 8.0;

  // Animations & transitions
  static const int hoverTransitionDurationMs = 150;
  static const Duration hoverTransitionDuration = Duration(milliseconds: 150);
  static const int entryAddAnimationDurationMs = 200;
  static const Duration entryAddAnimationDuration = Duration(milliseconds: 200);
  static const Duration entryRemoveAnimationDuration = Duration(
    milliseconds: 150,
  );
  static const Duration profitBoxScaleInDuration = Duration(milliseconds: 200);
  static const Duration undoTimeoutDuration = Duration(seconds: 5);

  // Hover effects
  static const double hoverElevation = 2.0;
  static const double hoverShadowBlur = 8.0;
  static const double hoverShadowOpacity = 0.08;

  // Responsive section padding (matches dashboard pattern)
  static const double sectionPaddingSmall = 24.0; // @1366px
  static const double sectionPaddingMedium = 32.0; // @1920px
  static const double sectionPaddingLarge = 32.0; // @2560px (capped width)

  // Layout proportions (40/60 split for form/log)
  static const double formColumnFlex = 40.0;
  static const double logColumnFlex = 60.0;

  /// Get form padding (no context needed)
  static EdgeInsets getFormPadding() {
    return const EdgeInsets.symmetric(
      horizontal: formPaddingHorizontal,
      vertical: formPaddingVertical,
    );
  }

  /// Get responsive section padding based on screen size
  /// Returns appropriate padding for different breakpoints
  static EdgeInsets getResponsiveSectionPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 2560) {
      // 4K: max-width constrained, centered padding
      return const EdgeInsets.symmetric(
        horizontal: sectionPaddingLarge,
        vertical: sectionPaddingLarge,
      );
    } else if (width >= 1920) {
      // Desktop
      return const EdgeInsets.symmetric(
        horizontal: sectionPaddingMedium,
        vertical: sectionPaddingMedium,
      );
    } else {
      // Laptop
      return const EdgeInsets.symmetric(
        horizontal: sectionPaddingSmall,
        vertical: sectionPaddingSmall,
      );
    }
  }

  /// Get input field padding (consistent across all breakpoints)
  static EdgeInsets getInputFieldPadding() {
    return const EdgeInsets.symmetric(
      horizontal: inputContentPadding,
      vertical: inputContentPadding,
    );
  }

  /// Get log cell padding
  static EdgeInsets getLogCellPadding() {
    return const EdgeInsets.symmetric(
      horizontal: logCellPadding,
      vertical: logCellPadding,
    );
  }

  /// Get profit box padding
  static EdgeInsets getProfitBoxPadding() {
    return const EdgeInsets.all(profitBoxPadding);
  }

  /// Get responsive input spacing between fields
  static double getResponsiveInputSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1920) {
      return inputFieldSpacing * 1.25; // 20px on larger screens
    }
    return inputFieldSpacing; // 16px default
  }
}
