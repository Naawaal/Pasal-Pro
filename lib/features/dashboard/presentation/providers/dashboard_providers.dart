import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/presentation/providers/customer_providers.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/usecases/get_products.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';
import 'package:pasal_pro/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';

/// Provides access to SalesLocalDataSource
final salesDataSourceProvider = FutureProvider<SalesLocalDataSource>((
  ref,
) async {
  final db = await DatabaseService.instance.database;
  return SalesLocalDataSource(db);
});

/// Today's total sales amount
final todaySalesAmountProvider = FutureProvider<double>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  return dataSource.getTodaySalesAmount();
});

/// Today's total profit
final todayProfitProvider = FutureProvider<double>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  return dataSource.getTodayProfit();
});

/// Today's transaction count
final todayTransactionCountProvider = FutureProvider<int>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  final sales = await dataSource.getTodaySales();
  return sales.length;
});

/// Products with low stock
final lowStockProductsProvider = FutureProvider<List<Product>>((ref) async {
  final getProducts = ref.read(getProductsProvider);
  final result = await getProducts(
    const GetProductsParams(includeInactive: false),
  );

  final products = result.fold(
    onSuccess: (data) => data,
    onError: (_) => <Product>[],
  );

  return products.where((p) => p.isLowStock).toList();
});

/// Total inventory value (cost)
final inventoryValueCostProvider = FutureProvider<double>((ref) async {
  final getProducts = ref.read(getProductsProvider);
  final result = await getProducts(
    const GetProductsParams(includeInactive: false),
  );

  final products = result.fold(
    onSuccess: (data) => data,
    onError: (_) => <Product>[],
  );

  return products.fold<double>(
    0,
    (sum, p) => sum + (p.costPrice * p.stockPieces),
  );
});

/// Total inventory value (selling price)
final inventoryValueSellingProvider = FutureProvider<double>((ref) async {
  final getProducts = ref.read(getProductsProvider);
  final result = await getProducts(
    const GetProductsParams(includeInactive: false),
  );

  final products = result.fold(
    onSuccess: (data) => data,
    onError: (_) => <Product>[],
  );

  return products.fold<double>(
    0,
    (sum, p) => sum + (p.sellingPrice * p.stockPieces),
  );
});

/// Low stock count
final lowStockCountProvider = FutureProvider<int>((ref) async {
  final products = await ref.watch(lowStockProductsProvider.future);
  return products.length;
});

/// Recent sales activity (last 10 transactions)
final recentActivityProvider = FutureProvider<List<SaleModel>>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  final allSales = await dataSource.getAllSales();
  // Return last 10 sales in descending order (most recent first)
  return allSales.take(10).toList();
});

/// Today's cash sales
final todayCashSalesProvider = FutureProvider<double>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  final todaySales = await dataSource.getTodaySales();
  final cashSales = todaySales
      .where((s) => s.paymentMethod == SalePaymentMethod.cash)
      .fold<double>(0, (sum, s) => sum + s.subtotal);
  return cashSales;
});

/// Today's credit sales
final todayCreditSalesProvider = FutureProvider<double>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  final todaySales = await dataSource.getTodaySales();
  final creditSales = todaySales
      .where((s) => s.paymentMethod == SalePaymentMethod.credit)
      .fold<double>(0, (sum, s) => sum + s.subtotal);
  return creditSales;
});

/// Total outstanding customer credit
final totalOutstandingCreditProvider = FutureProvider<double>((ref) async {
  final customersAsync = await ref.watch(customersProvider.future);
  final totalCredit = customersAsync.fold<double>(
    0,
    (sum, customer) => sum + (customer.balance > 0 ? customer.balance : 0),
  );
  return totalCredit;
});

/// Total active customers
final totalCustomersProvider = FutureProvider<int>((ref) async {
  final customersAsync = await ref.watch(customersProvider.future);
  return customersAsync.length;
});

/// Yesterday's total sales amount
final yesterdaySalesAmountProvider = FutureProvider<double>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return dataSource
      .getSalesByDate(yesterday)
      .then(
        (sales) => sales.fold<double>(0.0, (sum, sale) => sum + sale.subtotal),
      );
});

/// Yesterday's total profit
final yesterdayProfitProvider = FutureProvider<double>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return dataSource.getProfitByDate(yesterday);
});

/// Yesterday's transaction count
final yesterdayTransactionCountProvider = FutureProvider<int>((ref) async {
  final dataSource = await ref.watch(salesDataSourceProvider.future);
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  final sales = await dataSource.getSalesByDate(yesterday);
  return sales.length;
});

/// Trend data for display
class TrendData {
  final String percentage; // e.g., "+12%", "-5%"
  final bool isPositive;
  final String label;

  TrendData({
    required this.percentage,
    required this.isPositive,
    required this.label,
  });
}

/// Calculate trend percentage between two values
double _calculateTrendPercentage(double today, double yesterday) {
  if (yesterday == 0) {
    return today > 0 ? 100.0 : 0.0;
  }
  return ((today - yesterday) / yesterday) * 100;
}

/// Trends for dashboard metrics (sales, profit, transactions, low stock)
final dashboardTrendsProvider = FutureProvider<List<TrendData>>((ref) async {
  final todaySales = await ref.watch(todaySalesAmountProvider.future);
  final yesterdaySales = await ref.watch(yesterdaySalesAmountProvider.future);

  final todayProfit = await ref.watch(todayProfitProvider.future);
  final yesterdayProfit = await ref.watch(yesterdayProfitProvider.future);

  final todayTransactions = await ref.watch(
    todayTransactionCountProvider.future,
  );
  final yesterdayTransactions = await ref.watch(
    yesterdayTransactionCountProvider.future,
  );

  final todayLowStock = await ref.watch(lowStockCountProvider.future);
  // For low stock, we can use the same value (it's a snapshot)
  // Alternatively, fetch historical count from products table
  // For now, we'll show it as stable
  const yesterdayLowStock = 0;

  // Calculate percentages
  final salesTrend = _calculateTrendPercentage(todaySales, yesterdaySales);
  final profitTrend = _calculateTrendPercentage(todayProfit, yesterdayProfit);
  final transactionTrend = _calculateTrendPercentage(
    todayTransactions.toDouble(),
    yesterdayTransactions.toDouble(),
  );
  final stockTrend = _calculateTrendPercentage(
    todayLowStock.toDouble(),
    yesterdayLowStock.toDouble(),
  );

  // Format percentages
  String formatTrend(double trend) {
    final sign = trend > 0 ? '+' : '';
    return '$sign${trend.toStringAsFixed(1)}%';
  }

  return [
    TrendData(
      percentage: formatTrend(salesTrend),
      isPositive: salesTrend >= 0,
      label: 'vs yesterday',
    ),
    TrendData(
      percentage: formatTrend(profitTrend),
      isPositive: profitTrend >= 0,
      label: 'vs yesterday',
    ),
    TrendData(
      percentage: formatTrend(transactionTrend),
      isPositive: transactionTrend <= 0, // Lower is better for transactions
      label: 'vs yesterday',
    ),
    TrendData(
      percentage: formatTrend(stockTrend),
      isPositive: stockTrend <= 0, // Lower is better for low stock items
      label: 'vs yesterday',
    ),
  ];
});

/// Store stats for dashboard
final storeStatsProvider = FutureProvider<StoreStats>((ref) async {
  final todaySales = await ref.watch(todaySalesAmountProvider.future);
  final todayProfit = await ref.watch(todayProfitProvider.future);
  final todayTransactions = await ref.watch(
    todayTransactionCountProvider.future,
  );
  final lowStock = await ref.watch(lowStockCountProvider.future);
  final cashSales = await ref.watch(todayCashSalesProvider.future);
  final creditSales = await ref.watch(todayCreditSalesProvider.future);
  final outstandingCredit = await ref.watch(
    totalOutstandingCreditProvider.future,
  );
  final totalCustomers = await ref.watch(totalCustomersProvider.future);
  final inventoryCost = await ref.watch(inventoryValueCostProvider.future);
  final inventorySelling = await ref.watch(
    inventoryValueSellingProvider.future,
  );

  return StoreStats(
    todaySalesAmount: todaySales,
    todayProfit: todayProfit,
    todayTransactions: todayTransactions,
    lowStockCount: lowStock,
    todayCashSales: cashSales,
    todayCreditSales: creditSales,
    outstandingCredit: outstandingCredit,
    totalCustomers: totalCustomers,
    inventoryCostValue: inventoryCost,
    inventorySellingValue: inventorySelling,
  );
});

/// Store Stats data class
class StoreStats {
  final double todaySalesAmount;
  final double todayProfit;
  final int todayTransactions;
  final int lowStockCount;
  final double todayCashSales;
  final double todayCreditSales;
  final double outstandingCredit;
  final int totalCustomers;
  final double inventoryCostValue;
  final double inventorySellingValue;

  StoreStats({
    required this.todaySalesAmount,
    required this.todayProfit,
    required this.todayTransactions,
    required this.lowStockCount,
    required this.todayCashSales,
    required this.todayCreditSales,
    required this.outstandingCredit,
    required this.totalCustomers,
    required this.inventoryCostValue,
    required this.inventorySellingValue,
  });

  /// Profit margin percentage
  double get profitMargin =>
      todaySalesAmount > 0 ? (todayProfit / todaySalesAmount) * 100 : 0.0;

  /// Potential profit if all credit converts to cash
  double get potentialProfit => todayProfit + (outstandingCredit * 0.15);
}
