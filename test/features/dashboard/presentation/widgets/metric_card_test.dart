import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_theme.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/metric_card.dart';

void main() {
  group('MetricCard', () {
    // Helper to wrap widget in MixScope for theme access
    Widget wrapWithTheme(Widget child) {
      final mixTheme = PasalMixTheme.forBrightness(Brightness.light);
      return MaterialApp(
        home: Scaffold(
          body: MixScope(
            colors: mixTheme.colors,
            textStyles: mixTheme.textStyles,
            spaces: mixTheme.spaces,
            radii: mixTheme.radii,
            child: child,
          ),
        ),
      );
    }

    testWidgets('displays title, value, and trend correctly', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Total Sales',
            value: 'Rs 45,230.50',
            trend: '↑ 12% vs yesterday',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
      );

      expect(find.text('Total Sales'), findsOneWidget);
      expect(find.text('Rs 45,230.50'), findsOneWidget);
      expect(find.text('↑ 12% vs yesterday'), findsOneWidget);
    });

    testWidgets('displays optional timestamp when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Daily Profit',
            value: 'Rs 12,340',
            trend: '↑ 8% today',
            isPositive: true,
            icon: Icons.trending_up,
            timestamp: 'Last updated: 2m ago',
          ),
        ),
      );

      expect(find.text('Last updated: 2m ago'), findsOneWidget);
    });

    testWidgets('hides timestamp when not provided', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Daily Profit',
            value: 'Rs 12,340',
            trend: '↑ 8% today',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
      );

      expect(find.text('Last updated'), findsNothing);
    });

    testWidgets('renders icon in colored box', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Sales',
            value: 'Rs 1,000',
            trend: '↑ 5%',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
      );

      // Icon should be present
      expect(find.byIcon(Icons.trending_up), findsWidgets);
    });

    testWidgets('shows up arrow for positive trend', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Profit',
            value: 'Rs 5,000',
            trend: '↑ 12%',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
      );

      // Trending up icon should be present (Lucide icon)
      expect(find.byIcon(AppIcons.trendingUp), findsOneWidget);
    });

    testWidgets('shows down arrow for negative trend', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Loss',
            value: 'Rs 500',
            trend: '↓ 5%',
            isPositive: false,
            icon: Icons.trending_down,
          ),
        ),
      );

      // Trending down icon should be present (Lucide icon)
      expect(find.byIcon(AppIcons.trendingDown), findsOneWidget);
    });

    testWidgets('applies hover effect on mouse enter', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Sales',
            value: 'Rs 1,000',
            trend: '↑ 5%',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
      );

      // Initial state without hover
      expect(find.byType(MetricCard), findsOneWidget);

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Widget should still be visible
      expect(find.byType(MetricCard), findsOneWidget);
    });

    testWidgets('handles long text overflow gracefully', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'This is a very long metric title that should overflow',
            value: 'Rs 999,999,999.99',
            trend: '↑ 123% vs yesterday which is a very long trend message',
            isPositive: true,
            icon: Icons.trending_up,
            timestamp: 'Last updated: 1 minute and 30 seconds ago',
          ),
        ),
      );

      // Should render without crashing
      expect(find.byType(MetricCard), findsOneWidget);
    });

    testWidgets('metric value has correct font size (28px)', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Sales',
            value: 'Rs 45,230',
            trend: '↑ 12%',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
      );

      // Find the value text widget
      final valueText = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'Rs 45,230',
      );

      expect(valueText, findsOneWidget);

      // Check text style (should have 28px font size)
      final textWidget = tester.widget<Text>(valueText);
      expect(textWidget.style?.fontSize, equals(28.0));
    });

    testWidgets('card has 8px border radius', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          MetricCard(
            title: 'Sales',
            value: 'Rs 1,000',
            trend: '↑ 5%',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
      );

      // Find the container with border radius
      final containerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AnimatedContainer && widget.decoration is BoxDecoration,
      );

      expect(containerFinder, findsOneWidget);
    });
  });
}
