import 'package:isar/isar.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';

part 'cheque_model.g.dart';

/// Isar database model for Cheque
@Collection()
class ChequeModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String partyName;

  late double amount;

  @Index(type: IndexType.hash, unique: true)
  late String chequeNumber;

  late DateTime dueDate;

  @Index(type: IndexType.value)
  late String status; // 'pending', 'cleared', 'overdue'

  late DateTime createdDate;

  late bool isActive;

  /// Convert database model to domain entity
  Cheque toEntity() {
    return Cheque(
      id: id,
      partyName: partyName,
      amount: amount,
      chequeNumber: chequeNumber,
      dueDate: dueDate,
      status: status,
      createdDate: createdDate,
      isActive: isActive,
    );
  }

  /// Create database model from domain entity
  static ChequeModel fromEntity(Cheque cheque) {
    return ChequeModel()
      ..id = cheque.id ?? Isar.autoIncrement
      ..partyName = cheque.partyName
      ..amount = cheque.amount
      ..chequeNumber = cheque.chequeNumber
      ..dueDate = cheque.dueDate
      ..status = cheque.status
      ..createdDate = cheque.createdDate
      ..isActive = cheque.isActive;
  }
}
