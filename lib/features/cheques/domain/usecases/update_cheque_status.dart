import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/domain/repositories/cheque_repository.dart';
import 'package:pasal_pro/core/errors/failures.dart';

/// Use case: Update cheque status
class UpdateChequeStatus {
  final ChequeRepository repository;

  UpdateChequeStatus(this.repository);

  Future<Result<Cheque>> call(int id, String newStatus) async {
    // Validate status
    const validStatuses = ['pending', 'cleared', 'overdue'];
    if (!validStatuses.contains(newStatus)) {
      return Error(ValidationFailure(message: 'Invalid status: $newStatus'));
    }

    return repository.updateChequeStatus(id, newStatus);
  }
}
