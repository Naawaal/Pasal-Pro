import 'package:equatable/equatable.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Searches products by name, barcode, or category.
class SearchProducts {
  final ProductRepository _repository;

  const SearchProducts(this._repository);

  Future<Result<List<Product>>> call(SearchProductsParams params) async {
    if (params.query.trim().isEmpty) {
      return const Error(
        ValidationFailure(message: 'Search query cannot be empty.'),
      );
    }

    return _repository.searchProducts(
      query: params.query,
      category: params.category,
      includeInactive: params.includeInactive,
    );
  }
}

class SearchProductsParams extends Equatable {
  final String query;
  final String? category;
  final bool includeInactive;

  const SearchProductsParams({
    required this.query,
    this.category,
    this.includeInactive = false,
  });

  @override
  List<Object?> get props => [query, category, includeInactive];
}
