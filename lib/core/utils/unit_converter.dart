/// Unit conversion utilities for carton ↔ pieces
class UnitConverter {
  UnitConverter._();

  /// Convert cartons to pieces
  /// Example: 2.5 cartons × 12 pieces/carton = 30 pieces
  static int cartonsToPieces(double cartons, int piecesPerCarton) {
    if (cartons < 0 || piecesPerCarton <= 0) {
      throw ArgumentError('Invalid input for unit conversion');
    }
    return (cartons * piecesPerCarton).round();
  }

  /// Convert pieces to cartons
  /// Example: 30 pieces ÷ 12 pieces/carton = 2.5 cartons
  static double piecesToCartons(int pieces, int piecesPerCarton) {
    if (pieces < 0 || piecesPerCarton <= 0) {
      throw ArgumentError('Invalid input for unit conversion');
    }
    return pieces / piecesPerCarton;
  }

  /// Calculate price per piece from carton price
  /// Example: Rs 120 per carton ÷ 12 pieces = Rs 10 per piece
  static double cartonPriceToPiecePrice(
    double cartonPrice,
    int piecesPerCarton,
  ) {
    if (cartonPrice < 0 || piecesPerCarton <= 0) {
      throw ArgumentError('Invalid input for price conversion');
    }
    return cartonPrice / piecesPerCarton;
  }

  /// Calculate carton price from piece price
  /// Example: Rs 10 per piece × 12 pieces = Rs 120 per carton
  static double piecePriceToCartonPrice(
    double piecePrice,
    int piecesPerCarton,
  ) {
    if (piecePrice < 0 || piecesPerCarton <= 0) {
      throw ArgumentError('Invalid input for price conversion');
    }
    return piecePrice * piecesPerCarton;
  }

  /// Format quantity display (e.g., "2 cartons + 6 pieces" or "30 pieces")
  static String formatQuantity(int totalPieces, int piecesPerCarton) {
    if (totalPieces < 0 || piecesPerCarton <= 0) {
      return '0 pieces';
    }

    if (totalPieces < piecesPerCarton) {
      return '$totalPieces pieces';
    }

    final cartons = totalPieces ~/ piecesPerCarton;
    final remainingPieces = totalPieces % piecesPerCarton;

    if (remainingPieces == 0) {
      return '$cartons ${cartons == 1 ? 'carton' : 'cartons'}';
    }

    return '$cartons ${cartons == 1 ? 'carton' : 'cartons'} + $remainingPieces pieces';
  }

  /// Calculate total price from quantity and unit price
  static double calculatePrice({
    required int pieces,
    required double pricePerPiece,
  }) {
    if (pieces < 0 || pricePerPiece < 0) {
      throw ArgumentError('Invalid input for price calculation');
    }
    return pieces * pricePerPiece;
  }

  /// Calculate profit margin
  static double calculateProfit({
    required double sellingPrice,
    required double costPrice,
  }) {
    if (sellingPrice < 0 || costPrice < 0) {
      throw ArgumentError('Invalid input for profit calculation');
    }
    return sellingPrice - costPrice;
  }

  /// Calculate profit margin percentage
  static double calculateProfitMargin({
    required double sellingPrice,
    required double costPrice,
  }) {
    if (costPrice == 0) return 0.0;
    final profit = calculateProfit(
      sellingPrice: sellingPrice,
      costPrice: costPrice,
    );
    return (profit / costPrice) * 100;
  }
}
