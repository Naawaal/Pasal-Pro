import 'package:pasal_pro/features/cheques/data/models/cheque_model.dart';

/// Abstract local data source for cheque operations
abstract class ChequeLocalDataSource {
  /// Add cheque to database
  Future<ChequeModel> addCheque(ChequeModel cheque);

  /// Get all active cheques
  Future<List<ChequeModel>> getAllCheques();

  /// Get cheque by ID
  Future<ChequeModel?> getChequeById(int id);

  /// Update cheque status
  Future<ChequeModel> updateChequeStatus(int id, String newStatus);

  /// Delete cheque (soft delete)
  Future<void> deleteCheque(int id);

  /// Get cheques by status
  Future<List<ChequeModel>> getChequesByStatus(String status);
}
