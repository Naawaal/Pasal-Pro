import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/domain/repositories/cheque_repository.dart';

/// Use case: Add a new cheque
class AddCheque {
  final ChequeRepository repository;

  AddCheque(this.repository);

  Future<Result<Cheque>> call(Cheque cheque) async {
    // Validate business rules
    if (cheque.amount <= 0) {
      return Error(ValidationFailure(message: 'Amount must be greater than 0'));
    }
    if (cheque.partyName.trim().isEmpty) {
      return Error(ValidationFailure(message: 'Party name is required'));
    }

    if (cheque.chequeNumber.trim().isEmpty) {
      return Error(ValidationFailure(message: 'Cheque number is required'));
    }

    // Add to repository
    return repository.addCheque(cheque);
  }
}
