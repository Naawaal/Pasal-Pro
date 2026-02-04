import 'package:isar/isar.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/core/errors/failures.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/data/models/product_model.dart';
import 'package:pasal_pro/features/products/data/models/product_model_mapper.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

/// Isar-backed implementation of ProductRepository.
class ProductRepositoryImpl implements ProductRepository {
  final DatabaseService _databaseService;

  const ProductRepositoryImpl(this._databaseService);

  @override
  Future<Result<List<Product>>> getProducts({
    bool includeInactive = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final query = includeInactive
          ? db.productModels.where()
          : db.productModels.filter().isActiveEqualTo(true);
      final models = await query.findAll();
      final entities = models.map(ProductModelMapper.toEntity).toList();
      return Success(entities);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to fetch products', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to load products.'));
    }
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    try {
      final db = await _databaseService.database;
      final model = await db.productModels.get(id);
      if (model == null) {
        return const Error(NotFoundFailure(message: 'Product not found.'));
      }
      return Success(ProductModelMapper.toEntity(model));
    } catch (error, stackTrace) {
      AppLogger.error('Failed to fetch product', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to load product.'));
    }
  }

  @override
  Future<Result<Product>> createProduct(Product product) async {
    try {
      final db = await _databaseService.database;
      final model = ProductModelMapper.toModel(product);
      await db.writeTxn(() async {
        await db.productModels.put(model);
      });
      final created = await db.productModels.get(model.id);
      if (created == null) {
        return const Error(
          DatabaseFailure(message: 'Failed to create product.'),
        );
      }
      return Success(ProductModelMapper.toEntity(created));
    } catch (error, stackTrace) {
      AppLogger.error('Failed to create product', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to create product.'));
    }
  }

  @override
  Future<Result<Product>> updateProduct(Product product) async {
    try {
      final db = await _databaseService.database;
      final existing = await db.productModels.get(product.id);
      if (existing == null) {
        return const Error(NotFoundFailure(message: 'Product not found.'));
      }
      final model = ProductModelMapper.toModel(product);
      await db.writeTxn(() async {
        await db.productModels.put(model);
      });
      final updated = await db.productModels.get(model.id);
      if (updated == null) {
        return const Error(
          DatabaseFailure(message: 'Failed to update product.'),
        );
      }
      return Success(ProductModelMapper.toEntity(updated));
    } catch (error, stackTrace) {
      AppLogger.error('Failed to update product', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to update product.'));
    }
  }

  @override
  Future<Result<void>> deleteProduct(int id, {bool hardDelete = false}) async {
    try {
      final db = await _databaseService.database;
      final model = await db.productModels.get(id);
      if (model == null) {
        return const Error(NotFoundFailure(message: 'Product not found.'));
      }

      if (hardDelete) {
        await db.writeTxn(() async {
          await db.productModels.delete(id);
        });
        return const Success(null);
      }

      model.isActive = false;
      model.updatedAt = DateTime.now();
      await db.writeTxn(() async {
        await db.productModels.put(model);
      });
      return const Success(null);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to delete product', error, stackTrace);
      return const Error(DatabaseFailure(message: 'Failed to delete product.'));
    }
  }

  @override
  Future<Result<List<Product>>> searchProducts({
    required String query,
    String? category,
    bool includeInactive = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final normalized = query.trim();
      final filter = db.productModels.filter().group(
        (q) => q
            .nameContains(normalized, caseSensitive: false)
            .or()
            .barcodeEqualTo(normalized, caseSensitive: false)
            .or()
            .categoryEqualTo(category ?? normalized, caseSensitive: false),
      );

      final results = includeInactive
          ? await filter.findAll()
          : await filter.isActiveEqualTo(true).findAll();

      final entities = results.map(ProductModelMapper.toEntity).toList();
      return Success(entities);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to search products', error, stackTrace);
      return const Error(
        DatabaseFailure(message: 'Failed to search products.'),
      );
    }
  }
}
