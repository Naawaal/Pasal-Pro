import 'package:equatable/equatable.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Fetches a single product by id.
class GetProductById {
  final ProductRepository _repository;

  const GetProductById(this._repository);

  Future<Result<Product>> call(GetProductByIdParams params) async {
    if (params.id <= 0) {
      return const Error(ValidationFailure(message: 'Product id is invalid.'));
    }

    return _repository.getProductById(params.id);
  }
}

class GetProductByIdParams extends Equatable {
  final int id;

  const GetProductByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
