import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/domain/repositories/customer_repository.dart';
import 'package:pasal_pro/features/customers/domain/usecases/index.dart';

// Database Service Provider
final customerDatabaseProvider = FutureProvider<Object>((ref) async {
  return await DatabaseService.instance.database;
});

// Repository Provider
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(DatabaseService.instance);
});

// Use case providers
final getCustomersUseCaseProvider = Provider<GetCustomers>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return GetCustomers(repository);
});

final searchCustomersUseCaseProvider = Provider<SearchCustomers>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return SearchCustomers(repository);
});

final createCustomerUseCaseProvider = Provider<CreateCustomer>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return CreateCustomer(repository);
});

final updateCustomerUseCaseProvider = Provider<UpdateCustomer>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return UpdateCustomer(repository);
});

final deleteCustomerUseCaseProvider = Provider<DeleteCustomer>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return DeleteCustomer(repository);
});

// Query Providers
/// Fetch all customers
final customersProvider = FutureProvider.autoDispose<List<Customer>>((
  ref,
) async {
  final getCustomers = ref.watch(getCustomersUseCaseProvider);
  final result = await getCustomers(includeInactive: false);
  return result.fold(
    onSuccess: (customers) => customers,
    onError: (error) {
      throw Exception(error.message);
    },
  );
});

/// Search customers by query
final searchCustomersProvider = FutureProvider.autoDispose
    .family<List<Customer>, String>((ref, searchQuery) async {
      if (searchQuery.isEmpty) {
        return const [];
      }
      final searchCustomersUseCase = ref.watch(searchCustomersUseCaseProvider);
      final result = await searchCustomersUseCase(
        searchQuery,
        includeInactive: false,
      );
      return result.fold(
        onSuccess: (customers) => customers,
        onError: (error) {
          throw Exception(error.message);
        },
      );
    });

/// Fetch customers with outstanding balance
final customersWithBalanceProvider = FutureProvider.autoDispose<List<Customer>>(
  (ref) async {
    final repository = ref.watch(customerRepositoryProvider);
    final result = await repository.getCustomersWithBalance();
    return result.fold(
      onSuccess: (customers) => customers,
      onError: (error) {
        throw Exception(error.message);
      },
    );
  },
);

/// Fetch customers over credit limit
final customersOverCreditLimitProvider =
    FutureProvider.autoDispose<List<Customer>>((ref) async {
      final repository = ref.watch(customerRepositoryProvider);
      final result = await repository.getOverCreditLimit();
      return result.fold(
        onSuccess: (customers) => customers,
        onError: (error) {
          throw Exception(error.message);
        },
      );
    });

// State Notifier for CRUD operations
class CustomerNotifier extends StateNotifier<AsyncValue<Customer?>> {
  final CustomerRepository repository;

  CustomerNotifier(this.repository) : super(const AsyncValue.data(null));

  /// Create a new customer
  Future<void> createCustomer(Customer customer) async {
    state = const AsyncValue.loading();
    final result = await repository.createCustomer(customer);
    state = result.fold(
      onSuccess: (created) => AsyncValue.data(created),
      onError: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }

  /// Update an existing customer
  Future<void> updateCustomer(Customer customer) async {
    state = const AsyncValue.loading();
    final result = await repository.updateCustomer(customer);
    state = result.fold(
      onSuccess: (updated) => AsyncValue.data(updated),
      onError: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }

  /// Delete a customer (soft delete by default)
  Future<void> deleteCustomer(int customerId, {bool hardDelete = false}) async {
    state = const AsyncValue.loading();
    final result = await repository.deleteCustomer(
      customerId,
      hardDelete: hardDelete,
    );
    state = result.fold(
      onSuccess: (_) => const AsyncValue.data(null),
      onError: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }
}

/// State notifier for customer CRUD operations
final customerNotifierProvider =
    StateNotifierProvider.autoDispose<CustomerNotifier, AsyncValue<Customer?>>((
      ref,
    ) {
      final repository = ref.watch(customerRepositoryProvider);
      return CustomerNotifier(repository);
    });
