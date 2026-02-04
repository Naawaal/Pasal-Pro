import 'package:isar/isar.dart';
import 'package:pasal_pro/features/sales/data/models/sale_item_model.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale.dart';

part 'sale_model.g.dart';

/// Payment method for a sale (same as domain enum)
enum SalePaymentMethod {
  cash('Cash'),
  credit('Credit');

  final String label;
  const SalePaymentMethod(this.label);
}

/// Isar collection model for sales transactions
/// Stores complete sale records with items, totals, and timestamps
@Collection()
class SaleModel {
  /// Unique identifier (auto-incremented by Isar)
  Id id = Isar.autoIncrement;

  /// Creation date indexed for fast queries by date
  @Index(type: IndexType.value)
  late DateTime createdAt;

  /// Payment method for this sale (0=cash, 1=credit)
  @enumerated
  late SalePaymentMethod paymentMethod;

  /// Line items in this sale (embedded collection)
  late List<SaleItemModel> items;

  /// Optional notes/comments for this sale
  String? notes;

  /// Cached total profit (for fast querying without recalculation)
  late double totalProfit;

  /// Cached subtotal (for fast querying)
  late double subtotal;

  /// Whether this sale is finalized (for future soft-delete support)
  late bool isActive;

  SaleModel();

  /// Convert to domain entity
  /// Note: This requires loading product data separately for full entity conversion
  Sale toEntity() {
    // Map payment method
    final paymentMethod = this.paymentMethod == SalePaymentMethod.cash
        ? PaymentMethod.cash
        : PaymentMethod.credit;

    return Sale(
      id: id > 0 ? id : null,
      items: [], // Items would be populated by repo with product data
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      notes: notes,
    );
  }

  /// Create model from domain entity
  factory SaleModel.fromEntity(Sale entity) {
    final paymentMethod = entity.paymentMethod == PaymentMethod.cash
        ? SalePaymentMethod.cash
        : SalePaymentMethod.credit;

    final model = SaleModel()
      ..createdAt = entity.createdAt
      ..paymentMethod = paymentMethod
      ..items = entity.items.map(SaleItemModel.fromEntity).toList()
      ..notes = entity.notes
      ..totalProfit = entity.totalProfit
      ..subtotal = entity.subtotal
      ..isActive = true;

    if (entity.id != null && entity.id! > 0) {
      model.id = entity.id!;
    }

    return model;
  }
}
