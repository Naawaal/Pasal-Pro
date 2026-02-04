import 'package:isar/isar.dart';
import 'package:pasal_pro/features/cheques/data/datasources/cheque_local_datasource.dart';
import 'package:pasal_pro/features/cheques/data/models/cheque_model.dart';

/// Implementation of local data source using Isar database
class ChequeLocalDataSourceImpl implements ChequeLocalDataSource {
  final Isar _isar;

  ChequeLocalDataSourceImpl(this._isar);

  /// Add new cheque to database
  @override
  Future<ChequeModel> addCheque(ChequeModel cheque) async {
    final id = await _isar.writeTxn(() async {
      return _isar.chequeModels.put(cheque);
    });
    cheque.id = id;
    return cheque;
  }

  /// Get all active cheques, sorted by due date
  @override
  Future<List<ChequeModel>> getAllCheques() async {
    return _isar.chequeModels
        .filter()
        .isActiveEqualTo(true)
        .sortByDueDate()
        .findAll();
  }

  /// Get cheque by ID if it's active
  @override
  Future<ChequeModel?> getChequeById(int id) async {
    final cheque = await _isar.chequeModels.get(id);
    if (cheque != null && cheque.isActive) {
      return cheque;
    }
    return null;
  }

  /// Update cheque status
  @override
  Future<ChequeModel> updateChequeStatus(int id, String newStatus) async {
    final cheque = await _isar.chequeModels.get(id);
    if (cheque == null) {
      throw Exception('Cheque not found');
    }

    cheque.status = newStatus;

    await _isar.writeTxn(() async {
      await _isar.chequeModels.put(cheque);
    });

    return cheque;
  }

  /// Soft delete cheque by marking isActive as false
  @override
  Future<void> deleteCheque(int id) async {
    final cheque = await _isar.chequeModels.get(id);
    if (cheque == null) {
      throw Exception('Cheque not found');
    }

    cheque.isActive = false;

    await _isar.writeTxn(() async {
      await _isar.chequeModels.put(cheque);
    });
  }

  /// Get cheques filtered by status
  /// Status can be: 'pending', 'cleared', 'overdue', 'due_soon'
  @override
  Future<List<ChequeModel>> getChequesByStatus(String status) async {
    final now = DateTime.now();
    final oneWeekLater = now.add(const Duration(days: 7));

    switch (status) {
      case 'cleared':
        return _isar.chequeModels
            .filter()
            .isActiveEqualTo(true)
            .statusEqualTo('cleared')
            .sortByDueDate()
            .findAll();

      case 'pending':
        return _isar.chequeModels
            .filter()
            .isActiveEqualTo(true)
            .statusEqualTo('pending')
            .dueDateGreaterThan(oneWeekLater) // Not due soon
            .sortByDueDate()
            .findAll();

      case 'due_soon':
        // Due within next 7 days but not overdue
        return _isar.chequeModels
            .filter()
            .isActiveEqualTo(true)
            .statusEqualTo('pending')
            .dueDateBetween(now, oneWeekLater)
            .sortByDueDate()
            .findAll();

      case 'overdue':
        return _isar.chequeModels
            .filter()
            .isActiveEqualTo(true)
            .statusEqualTo('pending')
            .dueDateLessThan(now)
            .sortByDueDate()
            .findAll();

      default:
        // Return all active
        return _isar.chequeModels
            .filter()
            .isActiveEqualTo(true)
            .sortByDueDate()
            .findAll();
    }
  }
}
