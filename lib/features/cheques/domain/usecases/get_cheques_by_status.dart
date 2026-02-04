import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/domain/repositories/cheque_repository.dart';

/// Use case: Get cheques filtered by status
class GetChequesByStatus {
  final ChequeRepository repository;

  GetChequesByStatus(this.repository);

  Future<Result<List<Cheque>>> call(String status) async {
    return repository.getChequesByStatus(status);
  }
}
