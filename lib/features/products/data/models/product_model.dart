import 'package:isar/isar.dart';

part 'product_model.g.dart';

/// Isar database model for Product
@Collection()
class ProductModel {
  /// Auto-incrementing ID
  Id id = Isar.autoIncrement;

  /// Product name (indexed for fast search)
  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  /// Cost price per piece (what we pay)
  late double costPrice;

  /// Selling price per piece (what customer pays)
  late double sellingPrice;

  /// Number of pieces in one carton
  /// Default: 12 (common for beverages, snacks)
  late int piecesPerCarton;

  /// Current stock in pieces (loose count)
  late int stockPieces;

  /// Low stock threshold for alerts
  late int lowStockThreshold;

  /// Category for grouping (optional)
  String? category;

  /// Barcode/SKU for scanning (optional, indexed)
  @Index(unique: true, replace: true, type: IndexType.hash)
  String? barcode;

  /// Is product active (for soft delete)
  late bool isActive;

  /// Creation timestamp
  late DateTime createdAt;

  /// Last update timestamp
  late DateTime updatedAt;

  /// Computed: Profit per piece
  @Ignore()
  double get profitPerPiece => sellingPrice - costPrice;

  /// Computed: Profit margin percentage
  @Ignore()
  double get profitMargin {
    if (costPrice == 0) return 0.0;
    return (profitPerPiece / costPrice) * 100;
  }

  /// Computed: Is stock low?
  @Ignore()
  bool get isLowStock => stockPieces <= lowStockThreshold;

  /// Computed: Selling price per carton
  @Ignore()
  double get sellingPricePerCarton => sellingPrice * piecesPerCarton;

  /// Computed: Cost price per carton
  @Ignore()
  double get costPricePerCarton => costPrice * piecesPerCarton;
}
