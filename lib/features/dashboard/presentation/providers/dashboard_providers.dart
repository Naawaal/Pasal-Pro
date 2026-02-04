import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/usecases/get_products.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';
import 'package:pasal_pro/features/sales/data/datasources/sales_local_datasource.dart';

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
