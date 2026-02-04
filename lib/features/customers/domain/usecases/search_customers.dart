import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/domain/repositories/customer_repository.dart';

/// Use case to search customers by query string
class SearchCustomers {
  final CustomerRepository repository;

  const SearchCustomers(this.repository);

  Future<Result<List<Customer>>> call(
    String query, {
    bool includeInactive = false,
  }) => repository.searchCustomers(
    query: query,
    includeInactive: includeInactive,
  );
}
