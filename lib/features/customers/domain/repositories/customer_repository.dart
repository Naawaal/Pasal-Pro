import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';

/// Repository interface for customer operations
abstract class CustomerRepository {
  /// Get all customers
  Future<Result<List<Customer>>> getCustomers({bool includeInactive = false});

  /// Get customer by ID
  Future<Result<Customer>> getCustomerById(int id);

  /// Create new customer
  Future<Result<Customer>> createCustomer(Customer customer);

  /// Update existing customer
  Future<Result<Customer>> updateCustomer(Customer customer);

  /// Delete customer (soft delete)
  Future<Result<void>> deleteCustomer(int id, {bool hardDelete = false});

  /// Search customers by name or phone
  Future<Result<List<Customer>>> searchCustomers({
    required String query,
    bool includeInactive = false,
  });

  /// Update customer balance
  Future<Result<void>> updateBalance(int customerId, double newBalance);

  /// Get customers with outstanding balance
  Future<Result<List<Customer>>> getCustomersWithBalance({
    bool includeInactive = false,
  });

  /// Get customers over credit limit
  Future<Result<List<Customer>>> getOverCreditLimit({
    bool includeInactive = false,
  });
}
