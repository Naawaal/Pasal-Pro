import 'package:flutter/material.dart';

/// Dashboard-specific spacing and layout constants
/// Built on AppResponsive breakpoints (1366px, 1920px, 2560px)
class DashboardSpacing {
  DashboardSpacing._();

  // Card spacing values (consistent across all breakpoints)
  static const double cardPaddingHorizontal = 20.0;
  static const double cardPaddingVertical = 20.0;
  static const double cardGap = 16.0; // Gap between metric cards
  static const double cardBorderRadius = 8.0; // Modern flat design

  // Section spacing
  static const double sectionGap = 32.0; // Gap between major sections
  static const double sectionPaddingSmall = 24.0; // @1366px
  static const double sectionPaddingMedium = 32.0; // @1920px
  static const double sectionPaddingLarge = 32.0; // @2560px (capped width)

  // Row heights
  static const double metricCardHeightMin =
      140.0; // Min height for metric cards
  static const double activityItemHeight = 48.0; // Activity feed row height

  // Text sizing for metric cards (research-based)
  static const double metricValueFontSize = 28.0; // Large metric number
  static const double metricTitleFontSize = 12.0; // Secondary, muted
  static const double metricTrendFontSize = 14.0; // Trend indicator
  static const double metricTimestampFontSize = 11.0; // Helper text

  // Icon sizing in cards
  static const double metricIconSize = 32.0; // Icon in metric card
  static const double activityIconSize = 20.0; // Icon in activity feed
  static const double statusBadgeSize = 18.0; // Status indicator in activity

  // Hover & interaction spacing
  static const double hoverShadowBlur = 12.0;
  static const double hoverShadowSpread = 0.0;
  static const double hoverShadowOpacity = 0.08;

  // Response delays
  static const Duration hoverTransitionDuration = Duration(milliseconds: 150);
  static const Duration updateAnimationDuration = Duration(milliseconds: 200);

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

  /// Get card padding (consistent across all breakpoints)
  static EdgeInsets getCardPadding() {
    return const EdgeInsets.symmetric(
      horizontal: cardPaddingHorizontal,
      vertical: cardPaddingVertical,
    );
  }

  /// Get activity feed padding
  static EdgeInsets getActivityItemPadding() {
    return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0);
  }
}
