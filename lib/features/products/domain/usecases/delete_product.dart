import 'package:equatable/equatable.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Deletes a product (soft delete by default).
class DeleteProduct {
  final ProductRepository _repository;

  const DeleteProduct(this._repository);

  Future<Result<void>> call(DeleteProductParams params) async {
    if (params.id <= 0) {
      return const Error(ValidationFailure(message: 'Product id is invalid.'));
    }

    return _repository.deleteProduct(params.id, hardDelete: params.hardDelete);
  }
}

class DeleteProductParams extends Equatable {
  final int id;
  final bool hardDelete;

  const DeleteProductParams({required this.id, this.hardDelete = false});

  @override
  List<Object?> get props => [id, hardDelete];
}
