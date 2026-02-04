import 'package:equatable/equatable.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Updates an existing product with business validation.
class UpdateProduct {
  final ProductRepository _repository;

  const UpdateProduct(this._repository);

  Future<Result<Product>> call(UpdateProductParams params) async {
    final validation = _validate(params.product);
    if (validation != null) {
      return Error(validation);
    }

    return _repository.updateProduct(params.product);
  }

  Failure? _validate(Product product) {
    if (product.id <= 0) {
      return const ValidationFailure(message: 'Product id is invalid.');
    }
    if (product.name.trim().isEmpty) {
      return const ValidationFailure(message: 'Product name is required.');
    }
    if (product.costPrice < 0 || product.sellingPrice < 0) {
      return const ValidationFailure(
        message: 'Prices must be zero or greater.',
      );
    }
    if (product.sellingPrice < product.costPrice) {
      return const BusinessFailure(
        message: 'Selling price must be equal or higher than cost price.',
      );
    }
    if (product.piecesPerCarton <= 0) {
      return const ValidationFailure(
        message: 'Pieces per carton must be greater than zero.',
      );
    }
    if (product.stockPieces < 0) {
      return const ValidationFailure(message: 'Stock cannot be negative.');
    }
    if (product.lowStockThreshold < 0) {
      return const ValidationFailure(
        message: 'Low stock threshold cannot be negative.',
      );
    }
    return null;
  }
}

class UpdateProductParams extends Equatable {
  final Product product;

  const UpdateProductParams({required this.product});

  @override
  List<Object?> get props => [product];
}
