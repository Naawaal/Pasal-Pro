import 'package:isar/isar.dart';
import 'package:pasal_pro/features/products/data/models/product_model.dart';
import 'package:pasal_pro/features/products/data/models/product_model_mapper.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale_item.dart';

part 'sale_item_model.g.dart';

/// Isar model for persisting a line item in a sale transaction
@embedded
class SaleItemModel {
  /// Reference to the product (stored by product ID)
  late int productId;

  /// Product name (snapshot at time of sale)
  late String productName;

  /// Product barcode (snapshot at time of sale)
  String? barcode;

  /// Quantity purchased in this transaction (int for units, double for weight)
  late double quantity;

  /// Unit selling price at time of purchase
  late double unitPrice;

  /// Cost price per unit (snapshot at time of sale)
  late double costPrice;

  SaleItemModel();

  /// Convert to domain entity (requires Product object for reference)
  SaleItem toEntity(ProductModel productModel) {
    return SaleItem(
      product: ProductModelMapper.toEntity(productModel),
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }

  /// Create model from domain entity
  factory SaleItemModel.fromEntity(SaleItem entity) {
    final model = SaleItemModel()
      ..productId = entity.product.id
      ..productName = entity.product.name
      ..barcode = entity.product.barcode
      ..quantity = entity.quantity.toDouble()
      ..unitPrice = entity.unitPrice
      ..costPrice = entity.product.costPrice;
    return model;
  }
}
