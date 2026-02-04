/// Business logic entity for cheque tracking
/// Represents a cheque with status and validation logic
class Cheque {
  final int? id;
  final String partyName;
  final double amount;
  final String chequeNumber;
  final DateTime dueDate;
  final String status; // 'pending', 'cleared', 'overdue'
  final DateTime createdDate;
  final bool isActive;

  Cheque({
    this.id,
    required this.partyName,
    required this.amount,
    required this.chequeNumber,
    required this.dueDate,
    required this.status,
    required this.createdDate,
    this.isActive = true,
  });

  /// Check if cheque is due within next 7 days
  bool get isDueSoon {
    if (status == 'cleared') return false;
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;
    return daysUntilDue >= 0 && daysUntilDue <= 7;
  }

  /// Check if cheque is overdue
  bool get isOverdue {
    if (status == 'cleared') return false;
    return DateTime.now().isAfter(dueDate);
  }

  /// Check if cheque is still pending
  bool get isPending => status == 'pending';

  /// Check if cheque is cleared
  bool get isCleared => status == 'cleared';

  /// Get display status with icon context
  String getDisplayStatus() {
    if (isCleared) return '✓ Cleared';
    if (isOverdue) return '⚠️ Overdue';
    if (isDueSoon) return '⏰ Due Soon';
    return '⏳ Pending';
  }

  /// Days remaining until due
  int get daysUntilDue {
    return dueDate.difference(DateTime.now()).inDays;
  }

  /// Create a copy with modified fields
  Cheque copyWith({
    int? id,
    String? partyName,
    double? amount,
    String? chequeNumber,
    DateTime? dueDate,
    String? status,
    DateTime? createdDate,
    bool? isActive,
  }) {
    return Cheque(
      id: id ?? this.id,
      partyName: partyName ?? this.partyName,
      amount: amount ?? this.amount,
      chequeNumber: chequeNumber ?? this.chequeNumber,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() =>
      'Cheque(id: $id, partyName: $partyName, amount: $amount, chequeNumber: $chequeNumber, dueDate: $dueDate, status: $status)';
}
