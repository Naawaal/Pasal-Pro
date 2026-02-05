import 'package:pasal_pro/features/products/data/models/product_model.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

/// Maps between ProductModel (Isar) and Product domain entity.
class ProductModelMapper {
  const ProductModelMapper._();

  static Product toEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      costPrice: model.costPrice,
      sellingPrice: model.sellingPrice,
      piecesPerCarton: model.piecesPerCarton,
      stockPieces: model.stockPieces,
      lowStockThreshold: model.lowStockThreshold,
      category: model.category,
      barcode: model.barcode,
      imageUrl: model.imageUrl,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      quantityType: model.quantityType,
    );
  }

  static ProductModel toModel(Product entity) {
    final model = ProductModel()
      ..name = entity.name
      ..costPrice = entity.costPrice
      ..sellingPrice = entity.sellingPrice
      ..piecesPerCarton = entity.piecesPerCarton
      ..stockPieces = entity.stockPieces
      ..lowStockThreshold = entity.lowStockThreshold
      ..category = entity.category
      ..barcode = entity.barcode
      ..imageUrl = entity.imageUrl
      ..isActive = entity.isActive
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..quantityType = entity.quantityType;

    if (entity.id > 0) {
      model.id = entity.id;
    }

    return model;
  }
}
