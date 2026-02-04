import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/domain/repositories/cheque_repository.dart';

/// Use case: Get all cheques
class GetAllCheques {
  final ChequeRepository repository;

  GetAllCheques(this.repository);

  Future<Result<List<Cheque>>> call() async {
    return repository.getAllCheques();
  }
}
