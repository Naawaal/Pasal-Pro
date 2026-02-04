import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pasal_pro/core/constants/app_constants.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/features/products/data/models/customer_model.dart';
import 'package:pasal_pro/features/products/data/models/product_model.dart';
import 'package:pasal_pro/features/products/data/models/transaction_model.dart';

/// Singleton service for managing Isar database
class DatabaseService {
  DatabaseService._();
  static final instance = DatabaseService._();

  Isar? _isar;

  /// Get Isar instance (initialize if needed)
  Future<Isar> get database async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }
    _isar = await _initDatabase();
    return _isar!;
  }

  /// Initialize Isar database
  Future<Isar> _initDatabase() async {
    try {
      AppLogger.info('Initializing Isar database...');

      final dir = await getApplicationDocumentsDirectory();

      final isar = await Isar.open(
        [ProductModelSchema, CustomerModelSchema, TransactionModelSchema],
        directory: dir.path,
        name: AppConstants.databaseName,
        inspector: true, // Enable Isar Inspector for debugging
      );

      AppLogger.info('Isar database initialized successfully');
      return isar;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize database', e, stackTrace);
      rethrow;
    }
  }

  /// Close database
  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
      AppLogger.info('Database closed');
    }
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.writeTxn(() async {
      await db.clear();
    });
    AppLogger.warning('All database data cleared');
  }

  /// Get database size in bytes
  Future<int> getDatabaseSize() async {
    final db = await database;
    return await db.getSize();
  }

  /// Compact database (optimize storage)
  Future<void> compact() async {
    final db = await database;
    await db.writeTxn(() async {
      // Isar automatically compacts on write transactions
    });
    AppLogger.info('Database compacted');
  }

  /// Export database to JSON (for backup)
  Future<Map<String, dynamic>> exportToJson() async {
    final db = await database;

    final products = await db.productModels.where().findAll();
    final customers = await db.customerModels.where().findAll();
    final transactions = await db.transactionModels.where().findAll();

    return {
      'version': AppConstants.databaseVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'products': products.map(_productToJson).toList(),
      'customers': customers.map(_customerToJson).toList(),
      'transactions': transactions.map(_transactionToJson).toList(),
    };
  }

  /// Helper: Convert ProductModel to JSON
  Map<String, dynamic> _productToJson(ProductModel p) => {
    'id': p.id,
    'name': p.name,
    'costPrice': p.costPrice,
    'sellingPrice': p.sellingPrice,
    'piecesPerCarton': p.piecesPerCarton,
    'stockPieces': p.stockPieces,
    'lowStockThreshold': p.lowStockThreshold,
    'category': p.category,
    'barcode': p.barcode,
    'isActive': p.isActive,
    'createdAt': p.createdAt.toIso8601String(),
    'updatedAt': p.updatedAt.toIso8601String(),
  };

  /// Helper: Convert CustomerModel to JSON
  Map<String, dynamic> _customerToJson(CustomerModel c) => {
    'id': c.id,
    'name': c.name,
    'phone': c.phone,
    'balance': c.balance,
    'creditLimit': c.creditLimit,
    'totalPurchases': c.totalPurchases,
    'transactionCount': c.transactionCount,
    'lastTransactionAt': c.lastTransactionAt?.toIso8601String(),
    'isActive': c.isActive,
    'notes': c.notes,
    'createdAt': c.createdAt.toIso8601String(),
    'updatedAt': c.updatedAt.toIso8601String(),
  };

  /// Helper: Convert TransactionModel to JSON
  Map<String, dynamic> _transactionToJson(TransactionModel t) => {
    'id': t.id,
    'date': t.date.toIso8601String(),
    'type': t.type.name,
    'productId': t.productId,
    'productName': t.productName,
    'customerId': t.customerId,
    'customerName': t.customerName,
    'qtyPieces': t.qtyPieces,
    'unitPrice': t.unitPrice,
    'costPrice': t.costPrice,
    'totalAmount': t.totalAmount,
    'profit': t.profit,
    'isCredit': t.isCredit,
    'isPaid': t.isPaid,
    'notes': t.notes,
    'createdAt': t.createdAt.toIso8601String(),
  };
}
