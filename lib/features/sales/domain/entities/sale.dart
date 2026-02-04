import 'package:equatable/equatable.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale_item.dart';

/// Payment method for a sale
enum PaymentMethod {
  cash('Cash'),
  credit('Credit');

  final String label;
  const PaymentMethod(this.label);
}

/// Represents a complete sale/transaction
class Sale extends Equatable {
  final int? id;
  final int? customerId; // Optional customer reference
  final List<SaleItem> items;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final String? notes;

  const Sale({
    this.id,
    this.customerId,
    required this.items,
    required this.paymentMethod,
    required this.createdAt,
    this.notes,
  });

  /// Total quantity of items in the sale
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal (before any taxes/discounts)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Total profit from this sale
  double get totalProfit => items.fold(0.0, (sum, item) => sum + item.profit);

  /// Average profit margin across all items
  double get averageMargin {
    if (items.isEmpty) return 0.0;
    final totalMarginPoints = items.fold(
      0.0,
      (sum, item) => sum + item.profitMargin,
    );
    return totalMarginPoints / items.length;
  }

  /// Total cost basis for inventory valuation
  double get totalCost => items.fold(0.0, (sum, item) => sum + item.totalCost);

  /// Check if sale is empty
  bool get isEmpty => items.isEmpty;

  /// Check if sale has items
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [id, customerId, items, paymentMethod, createdAt];

  /// Create a copy with optional field updates
  Sale copyWith({
    int? id,
    int? customerId,
    List<SaleItem>? items,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    String? notes,
  }) {
    return Sale(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
