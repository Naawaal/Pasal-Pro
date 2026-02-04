import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/data/datasources/customer_local_datasource.dart';
import 'package:pasal_pro/features/customers/data/models/customer_model_mapper.dart';
import 'package:pasal_pro/features/products/data/models/customer_model.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/domain/repositories/customer_repository.dart';

/// Isar-backed implementation of CustomerRepository
class CustomerRepositoryImpl implements CustomerRepository {
  final DatabaseService _databaseService;

  const CustomerRepositoryImpl(this._databaseService);

  @override
  Future<Result<List<Customer>>> getCustomers({
    bool includeInactive = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);
      final models = await dataSource.getAllCustomers(
        includeInactive: includeInactive,
      );
      final entities = CustomerModelMapper.toEntityList(models);
      return Success(entities);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to fetch customers', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to load customers.'));
    }
  }

  @override
  Future<Result<Customer>> getCustomerById(int id) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);
      final model = await dataSource.getCustomerById(id);
      if (model == null) {
        return const Error(NotFoundFailure(message: 'Customer not found.'));
      }
      return Success(CustomerModelMapper.toEntity(model));
    } catch (error, stackTrace) {
      AppLogger.error('Failed to fetch customer', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to load customer.'));
    }
  }

  @override
  Future<Result<Customer>> createCustomer(Customer customer) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);
      final model = CustomerModelMapper.toModel(customer);
      final id = await dataSource.saveCustomer(model);

      final created = await dataSource.getCustomerById(id.toInt());
      if (created == null) {
        return const Error(
          DatabaseFailure(message: 'Failed to create customer.'),
        );
      }
      return Success(CustomerModelMapper.toEntity(created));
    } catch (error, stackTrace) {
      AppLogger.error('Failed to create customer', error, stackTrace);
      return const Error(
        DatabaseFailure(message: 'Failed to create customer.'),
      );
    }
  }

  @override
  Future<Result<Customer>> updateCustomer(Customer customer) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);

      final existing = await dataSource.getCustomerById(customer.id);
      if (existing == null) {
        return const Error(NotFoundFailure(message: 'Customer not found.'));
      }

      final model = CustomerModelMapper.toModel(customer);
      await dataSource.saveCustomer(model);

      final updated = await dataSource.getCustomerById(customer.id);
      if (updated == null) {
        return const Error(
          DatabaseFailure(message: 'Failed to update customer.'),
        );
      }
      return Success(CustomerModelMapper.toEntity(updated));
    } catch (error, stackTrace) {
      AppLogger.error('Failed to update customer', error, stackTrace);
      return const Error(
        DatabaseFailure(message: 'Failed to update customer.'),
      );
    }
  }

  @override
  Future<Result<void>> deleteCustomer(int id, {bool hardDelete = false}) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);

      if (hardDelete) {
        await db.writeTxn(() async {
          await db.customerModels.delete(id);
        });
      } else {
        await dataSource.deleteCustomer(id);
      }
      return const Success(null);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to delete customer', error, stackTrace);
      return const Error(
        DatabaseFailure(message: 'Failed to delete customer.'),
      );
    }
  }

  @override
  Future<Result<List<Customer>>> searchCustomers({
    required String query,
    bool includeInactive = false,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return Success(
          await getCustomers(includeInactive: includeInactive).then((result) {
            return result.fold(onSuccess: (data) => data, onError: (_) => []);
          }),
        );
      }

      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);
      final models = await dataSource.searchCustomers(
        query,
        includeInactive: includeInactive,
      );
      final entities = CustomerModelMapper.toEntityList(models);
      return Success(entities);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to search customers', error, stackTrace);
      return const Error(
        DatabaseFailure(message: 'Failed to search customers.'),
      );
    }
  }

  @override
  Future<Result<void>> updateBalance(int customerId, double newBalance) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);
      await dataSource.updateBalance(customerId, newBalance);
      return const Success(null);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to update balance', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to update balance.'));
    }
  }

  @override
  Future<Result<List<Customer>>> getCustomersWithBalance({
    bool includeInactive = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);
      final models = await dataSource.getCustomersWithBalance(
        includeInactive: includeInactive,
      );
      final entities = CustomerModelMapper.toEntityList(models);
      return Success(entities);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch customers with balance',
        error,
        stackTrace,
      );
      return const Error(
        DatabaseFailure(message: 'Failed to load customers with balance.'),
      );
    }
  }

  @override
  Future<Result<List<Customer>>> getOverCreditLimit({
    bool includeInactive = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final dataSource = CustomerLocalDataSource(db);
      final models = await dataSource.getOverCreditLimit(
        includeInactive: includeInactive,
      );
      final entities = CustomerModelMapper.toEntityList(models);
      return Success(entities);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch over-limit customers',
        error,
        stackTrace,
      );
      return const Error(
        DatabaseFailure(message: 'Failed to load over-limit customers.'),
      );
    }
  }
}
