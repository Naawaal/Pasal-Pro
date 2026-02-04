import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';

/// Abstract repository for cheque operations
abstract class ChequeRepository {
  /// Add a new cheque
  /// Returns the created cheque with ID or error
  Future<Result<Cheque>> addCheque(Cheque cheque);

  /// Get all cheques (active only)
  /// Returns list of all non-deleted cheques
  Future<Result<List<Cheque>>> getAllCheques();

  /// Get cheque by ID
  /// Returns specific cheque or error if not found
  Future<Result<Cheque>> getChequeById(int id);

  /// Update cheque status
  /// Changes status: 'pending' → 'cleared' or 'overdue'
  Future<Result<Cheque>> updateChequeStatus(int id, String newStatus);

  /// Delete cheque (soft delete)
  /// Sets isActive to false
  Future<Result<void>> deleteCheque(int id);

  /// Get cheques by status filter
  /// Filters: 'pending', 'cleared', 'overdue', 'due_soon'
  Future<Result<List<Cheque>>> getChequesByStatus(String status);
}
