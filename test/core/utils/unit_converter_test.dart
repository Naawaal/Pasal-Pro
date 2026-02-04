import 'package:flutter_test/flutter_test.dart';
import 'package:pasal_pro/core/utils/unit_converter.dart';

void main() {
  group('UnitConverter - Cartons to Pieces', () {
    test('converts cartons to pieces correctly', () {
      expect(UnitConverter.cartonsToPieces(2.0, 12), 24);
      expect(UnitConverter.cartonsToPieces(2.5, 12), 30);
      expect(UnitConverter.cartonsToPieces(1.0, 24), 24);
      expect(UnitConverter.cartonsToPieces(0.5, 10), 5);
    });

    test('handles zero cartons', () {
      expect(UnitConverter.cartonsToPieces(0.0, 12), 0);
    });

    test('throws on invalid input', () {
      expect(
        () => UnitConverter.cartonsToPieces(-1.0, 12),
        throwsArgumentError,
      );
      expect(() => UnitConverter.cartonsToPieces(2.0, 0), throwsArgumentError);
    });
  });

  group('UnitConverter - Pieces to Cartons', () {
    test('converts pieces to cartons correctly', () {
      expect(UnitConverter.piecesToCartons(24, 12), 2.0);
      expect(UnitConverter.piecesToCartons(30, 12), 2.5);
      expect(UnitConverter.piecesToCartons(5, 10), 0.5);
    });

    test('handles partial cartons', () {
      expect(UnitConverter.piecesToCartons(25, 12), closeTo(2.08, 0.01));
    });
  });

  group('UnitConverter - Price Calculations', () {
    test('calculates piece price from carton price', () {
      expect(UnitConverter.cartonPriceToPiecePrice(120.0, 12), 10.0);
      expect(UnitConverter.cartonPriceToPiecePrice(100.0, 20), 5.0);
    });

    test('calculates carton price from piece price', () {
      expect(UnitConverter.piecePriceToCartonPrice(10.0, 12), 120.0);
    });

    test('calculates total price', () {
      expect(
        UnitConverter.calculatePrice(pieces: 30, pricePerPiece: 10.0),
        300.0,
      );
    });
  });

  group('UnitConverter - Profit Calculations', () {
    test('calculates profit correctly', () {
      expect(
        UnitConverter.calculateProfit(sellingPrice: 150.0, costPrice: 100.0),
        50.0,
      );
    });

    test('calculates profit margin percentage', () {
      expect(
        UnitConverter.calculateProfitMargin(
          sellingPrice: 150.0,
          costPrice: 100.0,
        ),
        50.0, // 50% profit margin
      );
    });

    test('handles zero cost price in margin calculation', () {
      expect(
        UnitConverter.calculateProfitMargin(
          sellingPrice: 100.0,
          costPrice: 0.0,
        ),
        0.0,
      );
    });
  });

  group('UnitConverter - Format Quantity', () {
    test('formats pieces only', () {
      expect(UnitConverter.formatQuantity(5, 12), '5 pieces');
    });

    test('formats cartons only', () {
      expect(UnitConverter.formatQuantity(24, 12), '2 cartons');
    });

    test('formats carton and pieces', () {
      expect(UnitConverter.formatQuantity(30, 12), '2 cartons + 6 pieces');
    });

    test('formats single carton', () {
      expect(UnitConverter.formatQuantity(12, 12), '1 carton');
    });
  });
}
