import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/domain/repositories/customer_repository.dart';

/// Use case to fetch all customers from the repository
class GetCustomers {
  final CustomerRepository repository;

  const GetCustomers(this.repository);

  Future<Result<List<Customer>>> call({bool includeInactive = false}) =>
      repository.getCustomers(includeInactive: includeInactive);
}
