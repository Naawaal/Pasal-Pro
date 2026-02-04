import 'package:isar/isar.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/features/products/data/models/customer_model.dart';

/// Local data source for customers using Isar database
class CustomerLocalDataSource {
  final Isar _isar;

  CustomerLocalDataSource(this._isar);

  /// Create or update a customer
  Future<int> saveCustomer(CustomerModel customer) async {
    try {
      AppLogger.info('Saving customer: ${customer.name}');
      final id = await _isar.writeTxn(() async {
        return await _isar.customerModels.put(customer);
      });
      AppLogger.info('Customer saved with ID: $id');
      return id;
    } catch (e) {
      AppLogger.error('Failed to save customer: $e');
      rethrow;
    }
  }

  /// Get all customers (active only by default)
  Future<List<CustomerModel>> getAllCustomers({
    bool includeInactive = false,
  }) async {
    try {
      final query = includeInactive
          ? _isar.customerModels.where().sortByCreatedAtDesc()
          : _isar.customerModels
                .filter()
                .isActiveEqualTo(true)
                .sortByCreatedAtDesc();

      final customers = await query.findAll();
      AppLogger.info('Retrieved ${customers.length} customers');
      return customers;
    } catch (e) {
      AppLogger.error('Failed to get customers: $e');
      rethrow;
    }
  }

  /// Get customer by ID
  Future<CustomerModel?> getCustomerById(int id) async {
    try {
      final customer = await _isar.customerModels.get(id);
      if (customer != null) {
        AppLogger.info('Retrieved customer: ${customer.name}');
      }
      return customer;
    } catch (e) {
      AppLogger.error('Failed to get customer by ID: $e');
      rethrow;
    }
  }

  /// Search customers by name or phone
  Future<List<CustomerModel>> searchCustomers(
    String query, {
    bool includeInactive = false,
  }) async {
    try {
      final normalized = query.trim();
      final filter = _isar.customerModels.filter().group(
        (q) => q
            .nameContains(normalized, caseSensitive: false)
            .or()
            .phoneContains(normalized, caseSensitive: false),
      );

      final results = includeInactive
          ? await filter.findAll()
          : await filter.isActiveEqualTo(true).findAll();

      AppLogger.info('Search found ${results.length} customers for "$query"');
      return results;
    } catch (e) {
      AppLogger.error('Failed to search customers: $e');
      rethrow;
    }
  }

  /// Get customers with outstanding balance
  Future<List<CustomerModel>> getCustomersWithBalance({
    bool includeInactive = false,
  }) async {
    try {
      final filter = _isar.customerModels.filter().group(
        (q) => q.balanceGreaterThan(0).and().isActiveEqualTo(!includeInactive),
      );

      final customers = await filter.sortByBalanceDesc().findAll();

      AppLogger.info('Found ${customers.length} customers with balance');
      return customers;
    } catch (e) {
      AppLogger.error('Failed to get customers with balance: $e');
      rethrow;
    }
  }

  /// Get customers over credit limit
  Future<List<CustomerModel>> getOverCreditLimit({
    bool includeInactive = false,
  }) async {
    try {
      final customers = await getAllCustomers(includeInactive: includeInactive);
      final overLimit = customers.where((c) => c.isOverCreditLimit).toList()
        ..sort(
          (a, b) =>
              (b.balance - b.creditLimit).compareTo(a.balance - a.creditLimit),
        );

      AppLogger.info('Found ${overLimit.length} customers over credit limit');
      return overLimit;
    } catch (e) {
      AppLogger.error('Failed to get over-limit customers: $e');
      rethrow;
    }
  }

  /// Update customer balance
  Future<void> updateBalance(int customerId, double newBalance) async {
    try {
      AppLogger.info('Updating balance for customer $customerId: $newBalance');
      final customer = await _isar.customerModels.get(customerId);
      if (customer != null) {
        customer.balance = newBalance;
        customer.updatedAt = DateTime.now();
        await _isar.writeTxn(() async {
          await _isar.customerModels.put(customer);
        });
        AppLogger.info('Balance updated successfully');
      }
    } catch (e) {
      AppLogger.error('Failed to update balance: $e');
      rethrow;
    }
  }

  /// Delete customer (soft delete)
  Future<void> deleteCustomer(int customerId) async {
    try {
      AppLogger.info('Deleting customer ID: $customerId');
      final customer = await _isar.customerModels.get(customerId);
      if (customer != null) {
        customer.isActive = false;
        customer.updatedAt = DateTime.now();
        await _isar.writeTxn(() async {
          await _isar.customerModels.put(customer);
        });
        AppLogger.info('Customer deleted (soft)');
      }
    } catch (e) {
      AppLogger.error('Failed to delete customer: $e');
      rethrow;
    }
  }

  /// Restore deleted customer
  Future<void> restoreCustomer(int customerId) async {
    try {
      AppLogger.info('Restoring customer ID: $customerId');
      final customer = await _isar.customerModels.get(customerId);
      if (customer != null) {
        customer.isActive = true;
        customer.updatedAt = DateTime.now();
        await _isar.writeTxn(() async {
          await _isar.customerModels.put(customer);
        });
        AppLogger.info('Customer restored');
      }
    } catch (e) {
      AppLogger.error('Failed to restore customer: $e');
      rethrow;
    }
  }
}
