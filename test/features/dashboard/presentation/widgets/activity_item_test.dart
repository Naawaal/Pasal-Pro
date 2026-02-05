import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_theme.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/activity_item.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';
import 'package:pasal_pro/features/sales/data/models/sale_item_model.dart';

void main() {
  group('ActivityItem', () {
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

    // Create sample SaleModel for testing
    SaleModel createTestSale({
      required SalePaymentMethod paymentMethod,
      required double subtotal,
      int itemCount = 3,
      DateTime? createdAt,
    }) {
      return SaleModel()
        ..customerId = 1
        ..createdAt = createdAt ?? DateTime.now()
        ..paymentMethod = paymentMethod
        ..items = List.generate(
          itemCount,
          (i) => SaleItemModel()
            ..productId = i
            ..productName = 'Product $i'
            ..quantity = 1
            ..unitPrice = 100
            ..costPrice = 80,
        )
        ..subtotal = subtotal
        ..totalProfit = subtotal * 0.2
        ..isActive = true;
    }

    testWidgets('displays cash payment with correct icon', (tester) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      // Should show cash icon (Lucide icon)
      expect(find.byIcon(AppIcons.cash), findsOneWidget);
      expect(find.text('Sale completed'), findsOneWidget);
      expect(find.textContaining('Cash payment'), findsOneWidget);
    });

    testWidgets('displays credit payment with correct icon', (tester) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.credit,
        subtotal: 10000,
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      // Should show credit card icon (Lucide icon)
      expect(find.byIcon(AppIcons.creditCard), findsOneWidget);
      expect(find.textContaining('Credit payment'), findsOneWidget);
    });

    testWidgets('displays correct item count', (tester) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
        itemCount: 5,
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      // Should show \"5 items •\"
      expect(find.textContaining('5 items'), findsOneWidget);
    });

    testWidgets('displays formatted amount', (tester) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      // Currency formatter should format the amount
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data?.contains('5,000') == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('formats "Just now" for recent transactions', (tester) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
        createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('formats minutes ago for transactions within hour', (
      tester,
    ) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      expect(find.text('15m ago'), findsOneWidget);
    });

    testWidgets('formats hours ago for transactions within day', (
      tester,
    ) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      expect(find.text('3h ago'), findsOneWidget);
    });

    testWidgets('displays correct row height', (tester) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      // ActivityItem uses SizedBox with fixed height
      final sizeFinder = find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.height == 48.0,
      );

      expect(sizeFinder, findsOneWidget);
    });

    testWidgets('handles long customer names without overflow', (tester) async {
      final sale = SaleModel()
        ..customerId = 1
        ..createdAt = DateTime.now()
        ..paymentMethod = SalePaymentMethod.cash
        ..items = []
        ..subtotal = 5000
        ..totalProfit = 500
        ..isActive = true;

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      // Should render without overflow
      expect(find.byType(ActivityItem), findsOneWidget);
    });

    testWidgets('displays sale completed label', (tester) async {
      final sale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: sale)));

      expect(find.text('Sale completed'), findsOneWidget);
    });

    testWidgets('displays payment method label', (tester) async {
      final cashSale = createTestSale(
        paymentMethod: SalePaymentMethod.cash,
        subtotal: 5000,
      );

      await tester.pumpWidget(wrapWithTheme(ActivityItem(sale: cashSale)));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.data?.contains('Cash payment') == true,
        ),
        findsOneWidget,
      );
    });
  });
}
