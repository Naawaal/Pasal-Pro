import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasal_pro/features/dashboard/constants/dashboard_spacing.dart';

void main() {
  group('DashboardSpacing', () {
    test('card padding constants are defined correctly', () {
      expect(DashboardSpacing.cardPaddingHorizontal, equals(20.0));
      expect(DashboardSpacing.cardPaddingVertical, equals(20.0));
    });

    test('card gap is 16px', () {
      expect(DashboardSpacing.cardGap, equals(16.0));
    });

    test('card border radius is 8px', () {
      expect(DashboardSpacing.cardBorderRadius, equals(8.0));
    });

    test('section gap is 32px', () {
      expect(DashboardSpacing.sectionGap, equals(32.0));
    });

    test('section padding values are correct', () {
      expect(DashboardSpacing.sectionPaddingSmall, equals(24.0)); // @1366px
      expect(DashboardSpacing.sectionPaddingMedium, equals(32.0)); // @1920px
      expect(DashboardSpacing.sectionPaddingLarge, equals(32.0)); // @2560px
    });

    test('metric card height minimum is defined', () {
      expect(DashboardSpacing.metricCardHeightMin, equals(140.0));
    });

    test('activity item height is 48px', () {
      expect(DashboardSpacing.activityItemHeight, equals(48.0));
    });

    test('metric value font size is 28px', () {
      expect(DashboardSpacing.metricValueFontSize, equals(28.0));
    });

    test('metric title font size is 12px', () {
      expect(DashboardSpacing.metricTitleFontSize, equals(12.0));
    });

    test('metric trend font size is 14px', () {
      expect(DashboardSpacing.metricTrendFontSize, equals(14.0));
    });

    test('metric timestamp font size is 11px', () {
      expect(DashboardSpacing.metricTimestampFontSize, equals(11.0));
    });

    test('icon sizes are defined correctly', () {
      expect(DashboardSpacing.metricIconSize, equals(32.0));
      expect(DashboardSpacing.activityIconSize, equals(20.0));
      expect(DashboardSpacing.statusBadgeSize, equals(18.0));
    });

    test('hover shadow parameters are defined', () {
      expect(DashboardSpacing.hoverShadowBlur, equals(12.0));
      expect(DashboardSpacing.hoverShadowSpread, equals(0.0));
      expect(DashboardSpacing.hoverShadowOpacity, equals(0.08));
    });

    test('animation durations are correct', () {
      expect(
        DashboardSpacing.hoverTransitionDuration,
        equals(const Duration(milliseconds: 150)),
      );
      expect(
        DashboardSpacing.updateAnimationDuration,
        equals(const Duration(milliseconds: 200)),
      );
    });

    testWidgets('getResponsiveSectionPadding returns correct padding', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final padding = DashboardSpacing.getResponsiveSectionPadding(
                  context,
                );

                // At 1920px, should use medium padding (32.0)
                expect(padding.horizontal, equals(32.0 * 2));
                expect(padding.vertical, equals(32.0 * 2));

                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getCardPadding returns fixed padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final padding = DashboardSpacing.getCardPadding();

                expect(padding.horizontal, equals(20.0 * 2));
                expect(padding.vertical, equals(20.0 * 2));

                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getActivityItemPadding returns correct padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final padding = DashboardSpacing.getActivityItemPadding();

                expect(padding.horizontal, equals(12.0 * 2));
                expect(padding.vertical, equals(0.0));

                return Container();
              },
            ),
          ),
        ),
      );
    });

    /// Test responsive padding at different breakpoints
    testWidgets('responsive padding scales correctly at 1366px', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1366, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final padding = DashboardSpacing.getResponsiveSectionPadding(
                  context,
                );

                // At 1366px, should use small padding (24.0)
                expect(padding.horizontal, equals(24.0 * 2));

                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('responsive padding scales correctly at 2560px', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(2560, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final padding = DashboardSpacing.getResponsiveSectionPadding(
                  context,
                );

                // At 2560px, should use large padding (32.0)
                expect(padding.horizontal, equals(32.0 * 2));

                return Container();
              },
            ),
          ),
        ),
      );
    });
  });
}
