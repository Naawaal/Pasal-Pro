import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/data/datasources/cheque_local_datasource.dart';
import 'package:pasal_pro/features/cheques/data/models/cheque_model.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/domain/repositories/cheque_repository.dart';

/// Implementation of Cheque Repository using Isar database
class ChequeRepositoryImpl implements ChequeRepository {
  final ChequeLocalDataSource _localDataSource;

  ChequeRepositoryImpl(this._localDataSource);

  @override
  Future<Result<Cheque>> addCheque(Cheque cheque) async {
    try {
      final model = ChequeModel.fromEntity(cheque);
      final result = await _localDataSource.addCheque(model);
      return Success(result.toEntity());
    } catch (e) {
      return Error(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Cheque>>> getAllCheques() async {
    try {
      final models = await _localDataSource.getAllCheques();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Error(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Cheque>> getChequeById(int id) async {
    try {
      final model = await _localDataSource.getChequeById(id);
      if (model == null) {
        return Error(DatabaseFailure(message: 'Cheque not found'));
      }
      return Success(model.toEntity());
    } catch (e) {
      return Error(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Cheque>> updateChequeStatus(int id, String newStatus) async {
    try {
      final model = await _localDataSource.updateChequeStatus(id, newStatus);
      return Success(model.toEntity());
    } catch (e) {
      return Error(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteCheque(int id) async {
    try {
      await _localDataSource.deleteCheque(id);
      return Success(null);
    } catch (e) {
      return Error(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Cheque>>> getChequesByStatus(String status) async {
    try {
      final models = await _localDataSource.getChequesByStatus(status);
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Error(DatabaseFailure(message: e.toString()));
    }
  }
}
