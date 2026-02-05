import 'package:equatable/equatable.dart';

/// Domain entity representing a product in the catalog.
class Product extends Equatable {
  final int id;
  final String name;
  final double costPrice;
  final double sellingPrice;
  final int piecesPerCarton;
  final int stockPieces;
  final int lowStockThreshold;
  final String? category;
  final String? barcode;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String quantityType; // 'units' or 'weight'

  const Product({
    required this.id,
    required this.name,
    required this.costPrice,
    required this.sellingPrice,
    required this.piecesPerCarton,
    required this.stockPieces,
    required this.lowStockThreshold,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.quantityType,
    this.category,
    this.barcode,
    this.imageUrl,
  });

  double get profitPerPiece => sellingPrice - costPrice;

  double get profitMargin {
    if (costPrice == 0) return 0.0;
    return (profitPerPiece / costPrice) * 100;
  }

  bool get isLowStock => stockPieces <= lowStockThreshold;

  double get sellingPricePerCarton => sellingPrice * piecesPerCarton;

  double get costPricePerCarton => costPrice * piecesPerCarton;

  Product copyWith({
    int? id,
    String? name,
    double? costPrice,
    double? sellingPrice,
    int? piecesPerCarton,
    int? stockPieces,
    int? lowStockThreshold,
    String? category,
    String? barcode,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? quantityType,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      piecesPerCarton: piecesPerCarton ?? this.piecesPerCarton,
      stockPieces: stockPieces ?? this.stockPieces,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      category: category ?? this.category,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quantityType: quantityType ?? this.quantityType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    costPrice,
    sellingPrice,
    piecesPerCarton,
    stockPieces,
    lowStockThreshold,
    category,
    barcode,
    imageUrl,
    isActive,
    createdAt,
    updatedAt,
    quantityType,
  ];
}
