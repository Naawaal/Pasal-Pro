import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/domain/repositories/customer_repository.dart';

/// Use case to delete a customer
class DeleteCustomer {
  final CustomerRepository repository;

  const DeleteCustomer(this.repository);

  Future<Result<void>> call(int customerId, {bool hardDelete = false}) =>
      repository.deleteCustomer(customerId, hardDelete: hardDelete);
}
