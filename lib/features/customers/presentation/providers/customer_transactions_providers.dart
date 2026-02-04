import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';

/// Provider to access the sales datasource
final salesLocalDataSourceProvider = FutureProvider<SalesLocalDataSource>((
  ref,
) async {
  final isar = await DatabaseService.instance.database;
  return SalesLocalDataSource(isar);
});

/// Fetch all transactions for a specific customer
/// Takes customerId as parameter
final customerTransactionsProvider =
    FutureProvider.family<List<SaleModel>, int>((ref, customerId) async {
      final salesDataSourceAsync = ref.watch(salesLocalDataSourceProvider);
      return salesDataSourceAsync.when(
        data: (salesDataSource) =>
            salesDataSource.getSalesByCustomer(customerId),
        loading: () => throw Exception('Loading datasource...'),
        error: (error, stackTrace) =>
            throw Exception('Failed to load datasource: $error'),
      );
    });

/// Calculate customer's total purchased amount
final customerTotalPurchasesProvider = FutureProvider.family<double, int>((
  ref,
  customerId,
) async {
  final salesDataSourceAsync = ref.watch(salesLocalDataSourceProvider);
  return salesDataSourceAsync.when(
    data: (salesDataSource) =>
        salesDataSource.getCustomerTotalPurchases(customerId),
    loading: () => throw Exception('Loading datasource...'),
    error: (error, stackTrace) =>
        throw Exception('Failed to load datasource: $error'),
  );
});

/// Get customer's current credit balance
final customerCreditBalanceProvider = FutureProvider.family<double, int>((
  ref,
  customerId,
) async {
  final salesDataSourceAsync = ref.watch(salesLocalDataSourceProvider);
  return salesDataSourceAsync.when(
    data: (salesDataSource) => salesDataSource.getCustomerBalance(customerId),
    loading: () => throw Exception('Loading datasource...'),
    error: (error, stackTrace) =>
        throw Exception('Failed to load datasource: $error'),
  );
});

/// Calculate total items purchased by customer
final customerTotalItemsProvider = FutureProvider.family<int, int>((
  ref,
  customerId,
) async {
  final transactions = await ref.watch(
    customerTransactionsProvider(customerId).future,
  );
  return transactions.fold<int>(0, (sum, sale) => sum + sale.items.length);
});

/// Calculate average transaction amount for customer
final customerAverageTransactionProvider = FutureProvider.family<double, int>((
  ref,
  customerId,
) async {
  final transactions = await ref.watch(
    customerTransactionsProvider(customerId).future,
  );
  if (transactions.isEmpty) return 0;
  final totalAmount = transactions.fold<double>(
    0,
    (sum, sale) => sum + sale.subtotal,
  );
  return totalAmount / transactions.length;
});
