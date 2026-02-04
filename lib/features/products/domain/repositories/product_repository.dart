import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

/// Contract for product data operations.
abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({bool includeInactive = false});

  Future<Result<Product>> getProductById(int id);

  Future<Result<Product>> createProduct(Product product);

  Future<Result<Product>> updateProduct(Product product);

  Future<Result<void>> deleteProduct(int id, {bool hardDelete = false});

  Future<Result<List<Product>>> searchProducts({
    required String query,
    String? category,
    bool includeInactive = false,
  });
}
