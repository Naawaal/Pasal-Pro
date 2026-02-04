import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/domain/repositories/customer_repository.dart';

/// Use case to create a new customer
class CreateCustomer {
  final CustomerRepository repository;

  const CreateCustomer(this.repository);

  Future<Result<Customer>> call(Customer customer) =>
      repository.createCustomer(customer);
}
