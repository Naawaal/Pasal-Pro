import 'package:equatable/equatable.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Fetches products from the repository.
class GetProducts {
  final ProductRepository _repository;

  const GetProducts(this._repository);

  Future<Result<List<Product>>> call(GetProductsParams params) async {
    return _repository.getProducts(includeInactive: params.includeInactive);
  }
}

class GetProductsParams extends Equatable {
  final bool includeInactive;

  const GetProductsParams({this.includeInactive = false});

  @override
  List<Object?> get props => [includeInactive];
}
