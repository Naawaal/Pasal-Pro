import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

/// Transaction types
enum TransactionType {
  sale, // Regular sale
  purchase, // Inventory purchase
  expense, // Business expense
  payment, // Customer payment (balance settlement)
}

/// Isar database model for Transaction
@Collection()
class TransactionModel {
  /// Auto-incrementing ID
  Id id = Isar.autoIncrement;

  /// Transaction date and time (indexed for queries)
  @Index()
  late DateTime date;

  /// Transaction type
  @Enumerated(EnumType.name)
  late TransactionType type;

  /// Product ID (null for non-sale transactions)
  late int? productId;

  /// Product name (cached for performance)
  String? productName;

  /// Customer ID (null for cash transactions)
  late int? customerId;

  /// Customer name (cached for performance)
  String? customerName;

  /// Quantity in pieces
  late int qtyPieces;

  /// Unit price (price per piece)
  late double unitPrice;

  /// Cost price per piece (for profit calculation)
  late double costPrice;

  /// Total amount (qty × unit price)
  late double totalAmount;

  /// Profit amount (total - cost)
  late double profit;

  /// Is this a credit transaction?
  @Index()
  late bool isCredit;

  /// Payment status (for credit transactions)
  late bool isPaid;

  /// Notes or description (optional)
  String? notes;

  /// Creation timestamp
  late DateTime createdAt;

  /// Computed: Profit margin percentage
  @Ignore()
  double get profitMargin {
    if (totalAmount == 0) return 0.0;
    return (profit / (totalAmount - profit)) * 100;
  }

  /// Computed: Is this transaction today?
  @Ignore()
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
