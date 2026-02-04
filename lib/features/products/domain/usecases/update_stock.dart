import 'package:equatable/equatable.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Updates product stock by applying a delta.
class UpdateStock {
  final ProductRepository _repository;

  const UpdateStock(this._repository);

  Future<Result<Product>> call(UpdateStockParams params) async {
    if (params.productId <= 0) {
      return const Error(ValidationFailure(message: 'Product id is invalid.'));
    }
    if (params.delta == 0) {
      return const Error(
        ValidationFailure(message: 'Stock delta cannot be zero.'),
      );
    }

    final result = await _repository.getProductById(params.productId);
    return result.fold(
      onSuccess: (product) {
        final nextStock = product.stockPieces + params.delta;
        if (nextStock < 0) {
          return const Error(
            BusinessFailure(message: 'Insufficient stock for this update.'),
          );
        }
        final updated = product.copyWith(
          stockPieces: nextStock,
          updatedAt: params.updatedAt,
        );
        return _repository.updateProduct(updated);
      },
      onError: Error.new,
    );
  }
}

class UpdateStockParams extends Equatable {
  final int productId;
  final int delta;
  final DateTime updatedAt;

  UpdateStockParams({
    required this.productId,
    required this.delta,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [productId, delta, updatedAt];
}
