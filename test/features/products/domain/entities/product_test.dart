import 'package:flutter_test/flutter_test.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

void main() {
  group('Product Entity', () {
    final now = DateTime.now();

    final testProduct = Product(
      id: 1,
      name: 'Rice',
      costPrice: 50.0,
      sellingPrice: 60.0,
      piecesPerCarton: 12,
      stockPieces: 100,
      lowStockThreshold: 20,
      isActive: true,
      createdAt: now,
      updatedAt: now,
      quantityType: 'units',
    );

    group('Profit Calculations', () {
      test('profitPerPiece calculates correctly', () {
        final profit = testProduct.profitPerPiece;
        expect(profit, 10.0);
      });

      test('profitMargin calculates percentage correctly', () {
        final margin = testProduct.profitMargin;
        expect(margin, 20.0); // (10 / 50) * 100
      });

      test('profitMargin returns 0 when cost price is zero', () {
        final product = testProduct.copyWith(costPrice: 0.0);
        expect(product.profitMargin, 0.0);
      });

      test('profitMargin handles negative cost correctly', () {
        final product = testProduct.copyWith(costPrice: -10.0);
        final margin = product.profitMargin;
        expect(margin, -700.0); // (70 / -10) * 100
      });
    });

    group('Stock Management', () {
      test('isLowStock returns true when stock <= threshold', () {
        final product = testProduct.copyWith(
          stockPieces: 20,
          lowStockThreshold: 20,
        );
        expect(product.isLowStock, true);
      });

      test('isLowStock returns false when stock > threshold', () {
        final product = testProduct.copyWith(
          stockPieces: 21,
          lowStockThreshold: 20,
        );
        expect(product.isLowStock, false);
      });

      test('isLowStock returns true when stock < threshold', () {
        final product = testProduct.copyWith(
          stockPieces: 19,
          lowStockThreshold: 20,
        );
        expect(product.isLowStock, true);
      });

      test('isLowStock returns true when stock is zero', () {
        final product = testProduct.copyWith(
          stockPieces: 0,
          lowStockThreshold: 20,
        );
        expect(product.isLowStock, true);
      });
    });

    group('Carton Pricing', () {
      test('sellingPricePerCarton calculates correctly', () {
        final price = testProduct.sellingPricePerCarton;
        expect(price, 720.0); // 60.0 * 12
      });

      test('costPricePerCarton calculates correctly', () {
        final price = testProduct.costPricePerCarton;
        expect(price, 600.0); // 50.0 * 12
      });

      test('carton prices scale with piecesPerCarton', () {
        final product = testProduct.copyWith(piecesPerCarton: 24);
        expect(product.sellingPricePerCarton, 1440.0); // 60 * 24
        expect(product.costPricePerCarton, 1200.0); // 50 * 24
      });
    });

    group('CopyWith', () {
      test('copyWith creates new instance with updated fields', () {
        final updated = testProduct.copyWith(name: 'Wheat', stockPieces: 50);

        expect(updated.name, 'Wheat');
        expect(updated.stockPieces, 50);
        expect(updated.id, testProduct.id); // Unchanged fields
        expect(updated.costPrice, testProduct.costPrice);
      });

      test('copyWith preserves nullable fields when not provided', () {
        final updated = testProduct.copyWith(name: 'Updated');
        expect(updated.category, testProduct.category);
        expect(updated.barcode, testProduct.barcode);
        expect(updated.imageUrl, testProduct.imageUrl);
      });

      test('copyWith can update nullable fields', () {
        final updated = testProduct.copyWith(
          category: 'Grains',
          barcode: '123456',
        );
        expect(updated.category, 'Grains');
        expect(updated.barcode, '123456');
      });
    });

    group('Equality', () {
      test('two products with same properties are equal', () {
        final product1 = Product(
          id: 1,
          name: 'Rice',
          costPrice: 50.0,
          sellingPrice: 60.0,
          piecesPerCarton: 12,
          stockPieces: 100,
          lowStockThreshold: 20,
          isActive: true,
          createdAt: now,
          updatedAt: now,
          quantityType: 'units',
        );

        final product2 = Product(
          id: 1,
          name: 'Rice',
          costPrice: 50.0,
          sellingPrice: 60.0,
          piecesPerCarton: 12,
          stockPieces: 100,
          lowStockThreshold: 20,
          isActive: true,
          createdAt: now,
          updatedAt: now,
          quantityType: 'units',
        );

        expect(product1, product2);
      });

      test('products with different ids are not equal', () {
        final product1 = testProduct;
        final product2 = testProduct.copyWith(id: 2);
        expect(product1, isNot(product2));
      });

      test('products with different names are not equal', () {
        final product1 = testProduct;
        final product2 = testProduct.copyWith(name: 'Different');
        expect(product1, isNot(product2));
      });
    });

    group('Quantity Type', () {
      test('product can be created with units type', () {
        final product = testProduct.copyWith(quantityType: 'units');
        expect(product.quantityType, 'units');
      });

      test('product can be created with weight type', () {
        final product = testProduct.copyWith(quantityType: 'weight');
        expect(product.quantityType, 'weight');
      });

      test('copyWith preserves quantityType when not provided', () {
        final updated = testProduct.copyWith(name: 'Updated');
        expect(updated.quantityType, testProduct.quantityType);
      });

      test('products with different quantityType are not equal', () {
        final product1 = testProduct.copyWith(quantityType: 'units');
        final product2 = testProduct.copyWith(quantityType: 'weight');
        expect(product1, isNot(product2));
      });
    });

    group('Edge Cases', () {
      test('handles very high prices correctly', () {
        final product = testProduct.copyWith(
          costPrice: 1000000.0,
          sellingPrice: 1500000.0,
        );
        expect(product.profitPerPiece, 500000.0);
        expect(product.profitMargin, 50.0);
      });

      test('handles very small prices correctly', () {
        final product = testProduct.copyWith(
          costPrice: 0.01,
          sellingPrice: 0.02,
        );
        expect(product.profitPerPiece, 0.01);
        expect(product.profitMargin, 100.0);
      });

      test('handles same cost and selling price', () {
        final product = testProduct.copyWith(
          costPrice: 50.0,
          sellingPrice: 50.0,
        );
        expect(product.profitPerPiece, 0.0);
        expect(product.profitMargin, 0.0);
      });

      test('handles selling price less than cost price', () {
        final product = testProduct.copyWith(
          costPrice: 60.0,
          sellingPrice: 50.0,
        );
        expect(product.profitPerPiece, -10.0);
        expect(product.profitMargin, isNegative);
      });
    });
  });
}
