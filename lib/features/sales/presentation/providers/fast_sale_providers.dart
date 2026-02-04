import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';
import 'package:pasal_pro/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale_item.dart';

// ============================================================================
// Data Source & Persistence
// ============================================================================

/// Provider for the sales local data source
final salesLocalDataSourceProvider = FutureProvider<SalesLocalDataSource>((
  ref,
) async {
  final isar = await DatabaseService.instance.database;
  return SalesLocalDataSource(isar);
});

// ============================================================================
// Current Sale State (Cart Items & Metadata)
// ============================================================================

/// Provider that manages the current sale being built
final currentSaleProvider = StateNotifierProvider<CurrentSaleNotifier, Sale>((
  ref,
) {
  return CurrentSaleNotifier();
});

class CurrentSaleNotifier extends StateNotifier<Sale> {
  CurrentSaleNotifier()
    : super(
        Sale(
          items: [],
          paymentMethod: PaymentMethod.cash,
          createdAt: DateTime.now(),
        ),
      );

  /// Add a product to the sale with specified quantity and selling price
  void addItem(Product product, int quantity, [double? sellingPrice]) {
    if (quantity <= 0) return;

    final price = sellingPrice ?? product.sellingPrice;

    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Update existing item
      final updatedItem = state.items[existingIndex].copyWith(
        quantity: state.items[existingIndex].quantity + quantity,
      );
      final newItems = List<SaleItem>.from(state.items);
      newItems[existingIndex] = updatedItem;
      state = state.copyWith(items: newItems);
    } else {
      // Add new item
      final newItem = SaleItem(
        product: product,
        quantity: quantity,
        unitPrice: price,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  /// Update quantity of an existing cart item
  void updateItemQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = state.items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (index < 0) return;

    final updatedItem = state.items[index].copyWith(quantity: newQuantity);
    final newItems = List<SaleItem>.from(state.items);
    newItems[index] = updatedItem;
    state = state.copyWith(items: newItems);
  }

  /// Remove an item from the sale
  void removeItem(int productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  /// Update payment method
  void setPaymentMethod(PaymentMethod method) {
    state = state.copyWith(paymentMethod: method);
  }

  /// Clear all items from the sale
  void clearAll() {
    state = Sale(
      items: [],
      paymentMethod: state.paymentMethod,
      createdAt: DateTime.now(),
    );
  }

  /// Get the current sale (finalize for saving)
  Sale getCurrentSale() => state;

  /// Save current sale to database and clear the form
  Future<void> saveSaleToDatabase(SalesLocalDataSource dataSource) async {
    try {
      if (state.items.isEmpty) return;

      // Convert domain Sale to Isar SaleModel
      final saleModel = SaleModel.fromEntity(state);

      // Save to database
      await dataSource.saveSale(saleModel);

      // Clear the sale for next entry
      clearAll();
    } catch (e) {
      rethrow;
    }
  }
}

// ============================================================================
// Search & Product List State
// ============================================================================

/// Search query for product filtering
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered products based on search query
final filteredProductsProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final allProductsAsyncValue = ref.watch(productsControllerProvider);

  return allProductsAsyncValue.when(
    data: (products) {
      if (searchQuery.isEmpty) {
        return products.where((p) => p.isActive).toList();
      }
      return products
          .where(
            (p) =>
                p.isActive &&
                (p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    (p.barcode?.contains(searchQuery) ?? false)),
          )
          .toList();
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});

/// Recently added products (for quick access in Fast Sale)
final recentProductsProvider =
    StateNotifierProvider<RecentProductsNotifier, List<Product>>((ref) {
      return RecentProductsNotifier();
    });

class RecentProductsNotifier extends StateNotifier<List<Product>> {
  RecentProductsNotifier() : super([]);

  void addRecent(Product product) {
    // Remove if already exists
    state = state.where((p) => p.id != product.id).toList();

    // Add to front and limit to 5 items
    state = [product, ...state].take(5).toList();
  }

  void clear() {
    state = [];
  }
}

// ============================================================================
// UI State (Quantity Input, etc)
// ============================================================================

/// Currently selected product for quantity input (null = none selected)
final selectedProductProvider = StateProvider<Product?>((ref) => null);

/// Quantity input field value
final quantityInputProvider = StateProvider<int>((ref) => 1);

/// Reset quantity input to default
final quantityInputNotifierProvider =
    StateNotifierProvider<QuantityInputNotifier, int>((ref) {
      return QuantityInputNotifier();
    });

class QuantityInputNotifier extends StateNotifier<int> {
  QuantityInputNotifier() : super(1);

  void setQuantity(int value) {
    if (value > 0) {
      state = value;
    }
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 1) {
      state--;
    }
  }

  void reset() {
    state = 1;
  }
}
