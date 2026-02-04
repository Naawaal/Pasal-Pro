import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/data/repositories/product_repository_impl.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';
import 'package:pasal_pro/features/products/domain/usecases/create_product.dart';
import 'package:pasal_pro/features/products/domain/usecases/delete_product.dart';
import 'package:pasal_pro/features/products/domain/usecases/get_products.dart';
import 'package:pasal_pro/features/products/domain/usecases/search_products.dart';
import 'package:pasal_pro/features/products/domain/usecases/toggle_product_active.dart';
import 'package:pasal_pro/features/products/domain/usecases/update_product.dart';
import 'package:pasal_pro/features/products/domain/usecases/update_stock.dart';

/// Provides database access for the product feature.
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

/// Provides the ProductRepository implementation.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final databaseService = ref.read(databaseServiceProvider);
  return ProductRepositoryImpl(databaseService);
});

/// Provides use cases.
final getProductsProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.read(productRepositoryProvider));
});

final createProductProvider = Provider<CreateProduct>((ref) {
  return CreateProduct(ref.read(productRepositoryProvider));
});

final updateProductProvider = Provider<UpdateProduct>((ref) {
  return UpdateProduct(ref.read(productRepositoryProvider));
});

final deleteProductProvider = Provider<DeleteProduct>((ref) {
  return DeleteProduct(ref.read(productRepositoryProvider));
});

final searchProductsProvider = Provider<SearchProducts>((ref) {
  return SearchProducts(ref.read(productRepositoryProvider));
});

final updateStockProvider = Provider<UpdateStock>((ref) {
  return UpdateStock(ref.read(productRepositoryProvider));
});

final toggleProductActiveProvider = Provider<ToggleProductActive>((ref) {
  return ToggleProductActive(ref.read(productRepositoryProvider));
});

/// State controller for products list.
class ProductsController extends StateNotifier<AsyncValue<List<Product>>> {
  final GetProducts _getProducts;
  final DeleteProduct _deleteProduct;
  final ToggleProductActive _toggleProductActive;

  ProductsController({
    required GetProducts getProducts,
    required DeleteProduct deleteProduct,
    required ToggleProductActive toggleProductActive,
  })  : _getProducts = getProducts,
        _deleteProduct = deleteProduct,
        _toggleProductActive = toggleProductActive,
        super(const AsyncValue.loading());

  Future<void> loadProducts({bool includeInactive = false}) async {
    state = const AsyncValue.loading();
    final result = await _getProducts(GetProductsParams(
      includeInactive: includeInactive,
    ));

    state = _toAsyncValue(result);
  }

  Future<void> deleteProduct(int id, {bool hardDelete = false}) async {
    final result = await _deleteProduct(
      DeleteProductParams(id: id, hardDelete: hardDelete),
    );

    result.fold(
      onSuccess: (_) => loadProducts(),
      onError: (failure) => state = AsyncValue.error(
        failure.message,
        StackTrace.current,
      ),
    );
  }

  Future<void> toggleActive(int id, bool isActive) async {
    final result = await _toggleProductActive(
      ToggleProductActiveParams(productId: id, isActive: isActive),
    );

    result.fold(
      onSuccess: (_) => loadProducts(includeInactive: true),
      onError: (failure) => state = AsyncValue.error(
        failure.message,
        StackTrace.current,
      ),
    );
  }

  AsyncValue<List<Product>> _toAsyncValue(Result<List<Product>> result) {
    return result.fold(
      onSuccess: (data) => AsyncValue.data(data),
      onError: (failure) => AsyncValue.error(
        failure.message,
        StackTrace.current,
      ),
    );
  }
}

final productsControllerProvider =
    StateNotifierProvider<ProductsController, AsyncValue<List<Product>>>(
  (ref) => ProductsController(
    getProducts: ref.read(getProductsProvider),
    deleteProduct: ref.read(deleteProductProvider),
    toggleProductActive: ref.read(toggleProductActiveProvider),
  )..loadProducts(),
);

/// Search provider for product queries.
final productSearchProvider =
    StateNotifierProvider<ProductSearchController, AsyncValue<List<Product>>>(
  (ref) => ProductSearchController(
    searchProducts: ref.read(searchProductsProvider),
  ),
);

class ProductSearchController extends StateNotifier<AsyncValue<List<Product>>> {
  final SearchProducts _searchProducts;

  ProductSearchController({required SearchProducts searchProducts})
      : _searchProducts = searchProducts,
        super(const AsyncValue.data([]));

  Future<void> search(String query, {String? category}) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    final result = await _searchProducts(
      SearchProductsParams(query: query, category: category),
    );
    state = _toAsyncValue(result);
  }

  void clear() {
    state = const AsyncValue.data([]);
  }

  AsyncValue<List<Product>> _toAsyncValue(Result<List<Product>> result) {
    return result.fold(
      onSuccess: (data) => AsyncValue.data(data),
      onError: (failure) => AsyncValue.error(
        failure.message,
        StackTrace.current,
      ),
    );
  }
}

/// Selection provider for UI interactions.
final selectedProductProvider = StateProvider<Product?>((ref) => null);

/// Convenience helper for error mapping.
Failure? failureFromAsyncError(Object error) {
  if (error is Failure) return error;
  return null;
}
