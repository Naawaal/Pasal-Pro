import 'package:equatable/equatable.dart';

/// Domain entity representing a customer
class Customer extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final double balance; // Positive = owes us, Negative = we owe them
  final double creditLimit; // 0 = no limit
  final double totalPurchases;
  final int transactionCount;
  final DateTime? lastTransactionAt;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Customer({
    required this.id,
    required this.name,
    required this.balance,
    required this.creditLimit,
    required this.totalPurchases,
    required this.transactionCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.lastTransactionAt,
    this.notes,
  });

  /// Customer owes us money
  bool get hasBalance => balance > 0;

  /// Customer is over credit limit
  bool get isOverCreditLimit {
    if (creditLimit == 0) return false;
    return balance > creditLimit;
  }

  /// Available credit for customer
  double get availableCredit {
    if (creditLimit == 0) return double.infinity;
    return (creditLimit - balance).clamp(0, double.infinity);
  }

  /// Average transaction value
  double get averageTransaction {
    if (transactionCount == 0) return 0;
    return totalPurchases / transactionCount;
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    double? balance,
    double? creditLimit,
    double? totalPurchases,
    int? transactionCount,
    DateTime? lastTransactionAt,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      creditLimit: creditLimit ?? this.creditLimit,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      transactionCount: transactionCount ?? this.transactionCount,
      lastTransactionAt: lastTransactionAt ?? this.lastTransactionAt,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    balance,
    creditLimit,
    totalPurchases,
    transactionCount,
    lastTransactionAt,
    isActive,
    notes,
    createdAt,
    updatedAt,
  ];
}
