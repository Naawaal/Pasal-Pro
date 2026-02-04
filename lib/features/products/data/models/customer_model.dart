import 'package:isar/isar.dart';

part 'customer_model.g.dart';

/// Isar database model for Customer
@Collection()
class CustomerModel {
  /// Auto-incrementing ID
  Id id = Isar.autoIncrement;

  /// Customer name (indexed for fast search)
  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  /// Phone number (optional, indexed for uniqueness)
  @Index(unique: true, replace: true, type: IndexType.hash)
  String? phone;

  /// Current credit balance
  /// Positive = customer owes us (udharo)
  /// Negative = we owe customer (advance payment)
  late double balance;

  /// Credit limit (optional, 0 = no limit)
  late double creditLimit;

  /// Total amount purchased (lifetime)
  late double totalPurchases;

  /// Number of transactions
  late int transactionCount;

  /// Last transaction date
  DateTime? lastTransactionAt;

  /// Is customer active
  late bool isActive;

  /// Notes about customer (optional)
  String? notes;

  /// Creation timestamp
  late DateTime createdAt;

  /// Last update timestamp
  late DateTime updatedAt;

  /// Computed: Has outstanding balance
  @Ignore()
  bool get hasBalance => balance > 0;

  /// Computed: Is over credit limit
  @Ignore()
  bool get isOverCreditLimit {
    if (creditLimit == 0) return false; // No limit
    return balance > creditLimit;
  }

  /// Computed: Available credit
  @Ignore()
  double get availableCredit {
    if (creditLimit == 0) return double.infinity;
    return creditLimit - balance;
  }
}
