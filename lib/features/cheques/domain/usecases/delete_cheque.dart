import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/domain/repositories/cheque_repository.dart';
import 'package:pasal_pro/core/errors/failures.dart';

/// Use case: Delete cheque
class DeleteCheque {
  final ChequeRepository repository;

  DeleteCheque(this.repository);

  Future<Result<void>> call(int id) async {
    if (id <= 0) {
      return Error(ValidationFailure(message: 'Invalid cheque ID'));
    }

    return repository.deleteCheque(id);
  }
}
