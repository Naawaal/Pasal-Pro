import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Desktop-first responsive breakpoints for Pasal Pro
///
/// Targets:
/// - 1366px: 15" laptop (1280 viewport)
/// - 1920px: 24" monitor (default)
/// - 2560px: 4K monitor (premium)
///
/// Usage:
/// ```dart
/// final gridCols = AppResponsive.getValue(
///   context,
///   small: 1,
///   medium: 2,
///   large: 3,
///   xLarge: 4,
/// );
/// ```
class AppResponsive {
  AppResponsive._();

  // Breakpoint thresholds
  static const double breakpointSmall = 1024; // Tablet minimum
  static const double breakpointMedium = 1366; // Laptop standard
  static const double breakpointLarge = 1920; // Desktop standard
  static const double breakpointXLarge = 2560; // 4K monitors

  /// Create responsive breakpoints for ResponsiveBreakpoints.builder
  /// Returns list of breakpoint configurations for use in MaterialApp.builder
  static List<Breakpoint> getBreakpoints() => [
    const Breakpoint(start: 0, end: breakpointSmall, name: MOBILE),
    const Breakpoint(
      start: breakpointSmall,
      end: breakpointMedium,
      name: TABLET,
    ),
    const Breakpoint(
      start: breakpointMedium,
      end: breakpointLarge,
      name: DESKTOP,
    ),
    const Breakpoint(start: breakpointLarge, end: double.infinity, name: '4K'),
  ];

  /// Get responsive value based on current active breakpoint
  ///
  /// Example: Get number of grid columns based on resolution
  /// ```dart
  /// final cols = AppResponsive.getValue(
  ///   context,
  ///   small: 1,
  ///   medium: 2,
  ///   large: 3,
  ///   xLarge: 4,
  /// );
  /// ```
  static T getValue<T>(
    BuildContext context, {
    required T small,
    required T medium,
    required T large,
    required T xLarge,
  }) {
    return ResponsiveValue<T>(
      context,
      defaultValue: small,
      conditionalValues: [
        Condition.equals(name: MOBILE, value: small),
        Condition.equals(name: TABLET, value: medium),
        Condition.equals(name: DESKTOP, value: large),
        Condition.largerThan(name: DESKTOP, value: xLarge),
      ],
    ).value;
  }

  /// Check if currently on small screen (tablets, <1366px)
  static bool isSmall(BuildContext context) =>
      ResponsiveBreakpoints.of(context).equals(MOBILE);

  /// Check if currently on medium screen (laptops, 1366-1920px)
  static bool isMedium(BuildContext context) =>
      ResponsiveBreakpoints.of(context).equals(TABLET);

  /// Check if currently on large screen (24" monitor, 1920-2560px)
  static bool isLarge(BuildContext context) =>
      ResponsiveBreakpoints.of(context).equals(DESKTOP);

  /// Check if currently on 4K screen (2560px+)
  static bool is4K(BuildContext context) =>
      ResponsiveBreakpoints.of(context).largerThan(DESKTOP);

  /// Get responsive font size
  /// Useful for headlines, body text that scale with resolution
  static double getResponsiveFontSize(
    BuildContext context, {
    required double small,
    required double medium,
    required double large,
    required double xLarge,
  }) {
    return getValue<double>(
      context,
      small: small,
      medium: medium,
      large: large,
      xLarge: xLarge,
    );
  }

  /// Get responsive padding for main content areas
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.all(
      getValue<double>(context, small: 8, medium: 12, large: 16, xLarge: 20),
    );
  }

  /// Get responsive padding for specific direction
  static EdgeInsets getResponsiveSymmetricPadding(
    BuildContext context, {
    bool horizontal = true,
  }) {
    final padding = getValue<double>(
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

  /// Get current breakpoint name for debugging
  static String getBreakpointName(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    if (breakpoints.largerThan(DESKTOP)) return '4K';
    if (breakpoints.equals(DESKTOP)) return DESKTOP;
    if (breakpoints.equals(TABLET)) return TABLET;
    return MOBILE;
  }

  /// Get responsive number of grid columns for adaptive layouts
  /// - Small: 1 col
  /// - Medium: 2 cols
  /// - Large: 3 cols
  /// - XLarge: 4 cols
  static int getGridColumns(
    BuildContext context, {
    int customSmall = 1,
    int customMedium = 2,
    int customLarge = 3,
    int customXLarge = 4,
  }) {
    return getValue<int>(
      context,
      small: customSmall,
      medium: customMedium,
      large: customLarge,
      xLarge: customXLarge,
    );
  }

  /// Get responsive max width for content constraint on large screens
  /// Prevents content from stretching too wide on 4K displays
  static double getMaxContentWidth(BuildContext context) {
    return getValue<double>(
      context,
      small: double.infinity, // Full width on small
      medium: double.infinity, // Full width on medium
      large: 1400, // Constrain on large
      xLarge: 1600, // Slightly wider on 4K
    );
  }

  /// Get responsive section gap between items
  static double getSectionGap(BuildContext context) {
    return getValue<double>(
      context,
      small: 12,
      medium: 16,
      large: 20,
      xLarge: 24,
    );
  }

  /// Get responsive page padding
  static EdgeInsets getPagePadding(BuildContext context) {
    final padding = getValue<double>(
      context,
      small: 12,
      medium: 16,
      large: 24,
      xLarge: 32,
    );
    return EdgeInsets.all(padding);
  }

  /// Check if layout should stack vertically (mobile/tablet)
  static bool shouldStack(BuildContext context) =>
      !ResponsiveBreakpoints.of(context).largerThan(TABLET);

  /// Check if screen is in landscape multi-column mode (desktop+)
  static bool isMultiColumn(BuildContext context) =>
      ResponsiveBreakpoints.of(context).largerThan(TABLET);

  /// Get responsive list item cross axis extent for GridView
  /// Automatically calculates based on available width and desired columns
  static double getGridItemExtent(BuildContext context) {
    final cols = getGridColumns(context);
    // Rough calculation: (available width - padding - gaps) / columns
    return (MediaQuery.of(context).size.width - 48) / cols;
  }
}
