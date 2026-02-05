import 'package:equatable/equatable.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

/// Represents a single line item in a sale/transaction
class SaleItem extends Equatable {
  final Product product;
  final num quantity; // In pieces or weight (kg/g) depending on product type
  final double unitPrice; // Selling price per piece/unit at time of sale

  const SaleItem({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  /// Total price for this item (quantity * unitPrice)
  double get totalPrice => quantity * unitPrice;

  /// Total cost (cost basis) for this item
  double get totalCost => quantity * product.costPrice;

  /// Profit for this item
  double get profit => totalPrice - totalCost;

  /// Profit margin percentage for this item
  double get profitMargin {
    if (totalCost == 0) return 0.0;
    return (profit / totalCost) * 100;
  }

  @override
  List<Object?> get props => [product.id, quantity, unitPrice];

  /// Create a copy with optional field updates
  SaleItem copyWith({Product? product, num? quantity, double? unitPrice}) {
    return SaleItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
