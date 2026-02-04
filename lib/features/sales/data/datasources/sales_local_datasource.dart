import 'package:isar/isar.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';

/// Local data source for sales using Isar database
/// Handles all CRUD operations and queries for sales transactions
class SalesLocalDataSource {
  final Isar _isar;

  SalesLocalDataSource(this._isar);

  /// Save a new sale to the database
  Future<int> saveSale(SaleModel sale) async {
    try {
      AppLogger.info('Saving sale with ${sale.items.length} items');

      final id = await _isar.writeTxn(() async {
        return await _isar.saleModels.put(sale);
      });

      AppLogger.info('Sale saved successfully with ID: $id');
      return id;
    } catch (e) {
      AppLogger.error('Failed to save sale: $e');
      rethrow;
    }
  }

  /// Get all sales (active only)
  Future<List<SaleModel>> getAllSales() async {
    try {
      final sales = await _isar.saleModels
          .filter()
          .isActiveEqualTo(true)
          .sortByCreatedAtDesc()
          .findAll();

      AppLogger.info('Retrieved ${sales.length} sales');
      return sales;
    } catch (e) {
      AppLogger.error('Failed to get sales: $e');
      rethrow;
    }
  }

  /// Get sales for a specific date
  Future<List<SaleModel>> getSalesByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final sales = await _isar.saleModels
          .filter()
          .createdAtBetween(startOfDay, endOfDay)
          .and()
          .isActiveEqualTo(true)
          .sortByCreatedAtDesc()
          .findAll();

      AppLogger.info('Retrieved ${sales.length} sales for $date');
      return sales;
    } catch (e) {
      AppLogger.error('Failed to get sales by date: $e');
      rethrow;
    }
  }

  /// Get today's sales
  Future<List<SaleModel>> getTodaySales() async {
    return getSalesByDate(DateTime.now());
  }

  /// Get total profit for a specific date
  Future<double> getProfitByDate(DateTime date) async {
    try {
      final sales = await getSalesByDate(date);
      final totalProfit = sales.fold<double>(
        0.0,
        (sum, sale) => sum + sale.totalProfit,
      );

      AppLogger.info(
        'Total profit for $date: Rs${totalProfit.toStringAsFixed(2)}',
      );
      return totalProfit;
    } catch (e) {
      AppLogger.error('Failed to get profit by date: $e');
      rethrow;
    }
  }

  /// Get today's total profit
  Future<double> getTodayProfit() async {
    return getProfitByDate(DateTime.now());
  }

  /// Get today's total sales amount
  Future<double> getTodaySalesAmount() async {
    try {
      final sales = await getTodaySales();
      final totalAmount = sales.fold<double>(
        0.0,
        (sum, sale) => sum + sale.subtotal,
      );

      AppLogger.info('Today total sales: Rs${totalAmount.toStringAsFixed(2)}');
      return totalAmount;
    } catch (e) {
      AppLogger.error('Failed to get today sales amount: $e');
      rethrow;
    }
  }

  /// Get sales between date range
  Future<List<SaleModel>> getSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );

      final sales = await _isar.saleModels
          .filter()
          .createdAtBetween(start, end)
          .and()
          .isActiveEqualTo(true)
          .sortByCreatedAtDesc()
          .findAll();

      AppLogger.info('Retrieved ${sales.length} sales for range');
      return sales;
    } catch (e) {
      AppLogger.error('Failed to get sales by date range: $e');
      rethrow;
    }
  }

  /// Delete a sale (soft delete)
  Future<void> deleteSale(int saleId) async {
    try {
      AppLogger.info('Deleting sale ID: $saleId');

      final sale = await _isar.saleModels.get(saleId);
      if (sale != null) {
        await _isar.writeTxn(() async {
          sale.isActive = false;
          await _isar.saleModels.put(sale);
        });
      }

      AppLogger.info('Sale deleted: $saleId');
    } catch (e) {
      AppLogger.error('Failed to delete sale: $e');
      rethrow;
    }
  }

  /// Get count of sales for today
  Future<int> getTodayCount() async {
    try {
      final sales = await getTodaySales();
      return sales.length;
    } catch (e) {
      AppLogger.error('Failed to get today count: $e');
      rethrow;
    }
  }

  /// Clear all sales (for testing only)
  Future<void> clearAll() async {
    try {
      AppLogger.warning('Clearing all sales from database');

      await _isar.writeTxn(() async {
        await _isar.saleModels.clear();
      });

      AppLogger.info('All sales cleared');
    } catch (e) {
      AppLogger.error('Failed to clear sales: $e');
      rethrow;
    }
  }
}
