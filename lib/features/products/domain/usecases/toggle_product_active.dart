import 'package:equatable/equatable.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Toggles product active status.
class ToggleProductActive {
  final ProductRepository _repository;

  const ToggleProductActive(this._repository);

  Future<Result<Product>> call(ToggleProductActiveParams params) async {
    if (params.productId <= 0) {
      return const Error(ValidationFailure(message: 'Product id is invalid.'));
    }

    final result = await _repository.getProductById(params.productId);
    return result.fold(
      onSuccess: (product) {
        final updated = product.copyWith(
          isActive: params.isActive,
          updatedAt: params.updatedAt,
        );
        return _repository.updateProduct(updated);
      },
      onError: Error.new,
    );
  }
}

class ToggleProductActiveParams extends Equatable {
  final int productId;
  final bool isActive;
  final DateTime updatedAt;

  ToggleProductActiveParams({
    required this.productId,
    required this.isActive,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [productId, isActive, updatedAt];
}
