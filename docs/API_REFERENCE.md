# API Reference

**Status:** Phase 7 - Documentation  
**Last Updated:** February 5, 2026  
**Scope:** Domain entities, repositories, and key providers

---

## 🏗️ Architecture Layers

This reference covers the **public API** of each layer:

- **Domain:** Business entities and use cases (no framework dependencies)
- **Data:** Repository interfaces (abstraction layer)
- **Presentation:** Riverpod providers (state management)

---

## 📦 Core Module (lib/core/)

### Result<T> - Error Handling

Sealed class for explicit error handling. All async operations return `Result<T>`.

```dart
import 'package:pasal_pro/core/utils/result.dart';

// Success case
Result<List<Product>> success = Success([product1, product2]);

// Error case
Result<List<Product>> error = Error(DatabaseFailure('Connection failed'));

// Pattern matching
result.when(
  data: (products) => print('Got ${products.length} products'),
  error: (failure) => print('Error: ${failure.message}'),
);
```

**Types:**

| Type         | Purpose                      | Example                  |
| ------------ | ---------------------------- | ------------------------ |
| `Success<T>` | Contains data of type T      | `Success<List<Product>>` |
| `Error<T>`   | Contains failure information | `Error<List<Product>>`   |

### Failure Hierarchy

```dart
import 'package:pasal_pro/core/errors/failures.dart';

// Base class
abstract class Failure {}

// Subclasses
class ValidationFailure extends Failure {
  final String message;
  ValidationFailure(this.message);
}

class BusinessFailure extends Failure {
  final String message;
  BusinessFailure(this.message);
}

class DatabaseFailure extends Failure {
  final String message;
  DatabaseFailure(this.message);
}
```

### CurrencyFormatter

Format numbers as Nepali Rupees.

```dart
import 'package:pasal_pro/core/utils/currency_formatter.dart';

// Basic formatting
String formatted = CurrencyFormatter.format(1234.56);
// Output: "Rs. 1,234.56"

// With precision
String precise = CurrencyFormatter.format(1234.567, fractionDigits: 2);
// Output: "Rs. 1,234.57"

// Parse from string
double amount = CurrencyFormatter.parse('Rs. 1,234.56');
// Output: 1234.56
```

### DateFormatter

Format dates with relative time ("just now", "2 hours ago").

```dart
import 'package:pasal_pro/core/utils/date_formatter.dart';

// Relative time
String relative = DateFormatter.formatDate(DateTime.now().subtract(Duration(hours: 2)));
// Output: "2h ago"

// Specific date format
String formatted = DateFormatter.format(date, format: 'dd MMM yyyy');
// Output: "05 Feb 2026"

// Parse string to DateTime
DateTime dt = DateFormatter.parse('2026-02-05');
```

### UnitConverter

Convert between cartons and pieces.

```dart
import 'package:pasal_pro/core/utils/unit_converter.dart';

// Cartons to pieces
int pieces = UnitConverter.cartonsToPieces(2, piecesPerCarton: 12);
// Output: 24

// Pieces to cartons
int cartons = UnitConverter.piecesToCartons(24, piecesPerCarton: 12);
// Output: 2

// With partial carton
int full = UnitConverter.fullCartons(25, piecesPerCarton: 12);
// Output: 2
```

### AppSpacing (Design Tokens)

Consistent spacing throughout the app.

```dart
import 'package:pasal_pro/core/constants/app_spacing.dart';

// Use spacing between widgets
Column(
  children: [
    Text('Title'),
    AppSpacing.medium,      // 16px vertical gap
    Text('Content'),
    AppSpacing.large,       // 24px vertical gap
  ],
)

// Available: xxSmall (4px), xSmall (8px), small (12px),
//            medium (16px), large (24px), xLarge (32px), xxLarge (48px)
// Horizontal: AppSpacing.hMedium, etc.
```

### AppIcons

Lucide Icons collection for consistent iconography.

```dart
import 'package:pasal_pro/core/constants/app_icons.dart';

Icon(AppIcons.store)        // Business icon
Icon(AppIcons.rupee)        // Financial icon
Icon(AppIcons.success)      // Status icon
Icon(AppIcons.lowStock)     // Custom business icon

// Categories: Navigation, Business, Financial, Status, Inventory, etc.
```

### AppColors

Business-specific colors matching brand.

```dart
import 'package:pasal_pro/core/constants/app_colors.dart';

// Profit/Loss
AppColors.profitColor  // Green (#4CAF50)
AppColors.lossColor    // Red (#F44336)

// Financial states
AppColors.creditColor  // Orange (#FF9800)
AppColors.bgLight      // Light background
AppColors.bgDark       // Dark background
```

---

## 🏢 Products Feature (lib/features/products/)

### Product Entity

```dart
import 'package:pasal_pro/features/products/domain/entities/product.dart';

// Create product
final product = Product(
  id: 1,
  name: 'Basmati Rice',
  costPrice: 45.0,
  sellingPrice: 55.0,
  piecesPerCarton: 12,
  stockPieces: 100,
  lowStockThreshold: 20,
  category: 'Grains',
  barcode: 'RICE001',
  isActive: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Business methods
double margin = product.profitMargin;          // Percentage
double profitPerPiece = product.profitPerPiece; // Price difference
bool lowStock = product.isLowStock;            // Threshold check
double cartPricePerPiece = product.sellingPrice * product.piecesPerCarton;

// Immutability
final updated = product.copyWith(
  stockPieces: 90,
  updatedAt: DateTime.now(),
);
```

### ProductRepository

```dart
import 'package:pasal_pro/features/products/domain/repositories/product_repository.dart';

abstract class ProductRepository {
  // Get all products
  Future<Result<List<Product>>> getAllProducts();

  // Get by ID
  Future<Result<Product>> getProductById(int id);

  // Search by name
  Future<Result<List<Product>>> searchProducts(String query);

  // Add new product
  Future<Result<void>> addProduct(Product product);

  // Update product
  Future<Result<void>> updateProduct(Product product);

  // Delete product
  Future<Result<void>> deleteProduct(int id);

  // Get low stock products
  Future<Result<List<Product>>> getLowStockProducts();

  // Update stock after sale
  Future<Result<void>> updateStock(int productId, int quantitySold);
}
```

### ProductDataSource (Isar Queries)

```dart
// Located in: data/datasources/product_local_datasource.dart
// Implementation details (private, not in public API)

// But typical queries:
// - Get all: isar.productModels.where().findAll()
// - Search: isar.productModels.filter().nameContains(query).findAll()
// - Low stock: isar.productModels.filter().stockPiecesLessThan(threshold)
```

---

## 🛒 Sales Feature (lib/features/sales/)

### Sale Entity

```dart
import 'package:pasal_pro/features/sales/domain/entities/sale.dart';

// Create sale
final sale = Sale(
  id: 1,
  customerId: 5,          // Optional (null for cash sale)
  items: [],              // List of SaleItem
  totalAmount: 2750.00,
  paymentMethod: 'cash',  // 'cash' or 'credit'
  isCompleted: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Add items (mutable during entry)
sale.items.add(SaleItem(
  productId: 1,
  quantityPieces: 12,
  sellingPrice: 55.0,
  subtotal: 660.0,
));

// Calculate totals
double subtotal = sale.items.fold(0, (sum, item) => sum + item.subtotal);
double discountAmount = sale.totalAmount - subtotal;
```

### SaleRepository

```dart
import 'package:pasal_pro/features/sales/domain/repositories/sale_repository.dart';

abstract class SaleRepository {
  // Get all sales
  Future<Result<List<Sale>>> getAllSales();

  // Get recent sales
  Future<Result<List<Sale>>> getRecentSales(int limit);

  // Get sales for date range
  Future<Result<List<Sale>>> getSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  // Add new sale (updates inventory & customer ledger)
  Future<Result<void>> addSale(Sale sale);

  // Get sales for customer
  Future<Result<List<Sale>>> getCustomerSales(int customerId);

  // Calculate daily revenue
  Future<Result<double>> getDailyRevenue(DateTime date);
}
```

---

## 👥 Customers Feature (lib/features/customers/)

### Customer Entity

```dart
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';

// Create customer
final customer = Customer(
  id: 1,
  name: 'Sharma Shop',
  phone: '9851234567',
  address: 'Thamel, Kathmandu',
  creditLimit: 50000.0,
  currentCredit: 12500.0,  // Amount owed
  isActive: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Business logic
double availableCredit = customer.creditLimit - customer.currentCredit;
bool canBuyOnCredit = availableCredit > 0;
double creditPercentage = (customer.currentCredit / customer.creditLimit) * 100;

// Update credit after payment
final updated = customer.copyWith(
  currentCredit: customer.currentCredit - paymentAmount,
);
```

### CustomerRepository

```dart
import 'package:pasal_pro/features/customers/domain/repositories/customer_repository.dart';

abstract class CustomerRepository {
  // Get all customers
  Future<Result<List<Customer>>> getAllCustomers();

  // Get by ID
  Future<Result<Customer>> getCustomerById(int id);

  // Search customers
  Future<Result<List<Customer>>> searchCustomers(String query);

  // Add customer
  Future<Result<void>> addCustomer(Customer customer);

  // Update customer
  Future<Result<void>> updateCustomer(Customer customer);

  // Get customers with pending credit
  Future<Result<List<Customer>>> getActiveCreditors();

  // Update customer credit
  Future<Result<void>> updateCustomerCredit(int customerId, double amount);

  // Get total credit owed (all customers)
  Future<Result<double>> getTotalCreditOwed();
}
```

### Transaction Entity (Ledger entry)

```dart
import 'package:pasal_pro/features/customers/domain/entities/transaction.dart';

// Automatic creation on credit sale
final transaction = Transaction(
  customerId: 5,
  type: 'credit',          // 'credit', 'payment', 'adjustment'
  amount: 2750.0,
  saleId: 42,              // Reference to original sale
  description: 'Sale #42 - Rice + Lentils',
  createdAt: DateTime.now(),
);

// Used for customer balance calculation
// Balance = sum of all transactions for customer
```

---

## 📋 Cheques Feature (lib/features/cheques/)

### Cheque Entity

```dart
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';

// Record received cheque
final cheque = Cheque(
  id: 1,
  customerId: 5,
  chequeNumber: 'ABC123456',
  bankName: 'Nepal Bank Limited',
  issueDate: DateTime.now(),
  dueDate: DateTime.now().add(Duration(days: 30)),
  amount: 10000.0,
  status: 'pending',       // 'pending', 'cleared', 'bounced'
  isActive: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Business status
bool isOverdue = cheque.dueDate.isBefore(DateTime.now());
bool isCleared = cheque.status == 'cleared';
```

### ChequeRepository

```dart
import 'package:pasal_pro/features/cheques/domain/repositories/cheque_repository.dart';

abstract class ChequeRepository {
  // Get all cheques
  Future<Result<List<Cheque>>> getAllCheques();

  // Get pending cheques
  Future<Result<List<Cheque>>> getPendingCheques();

  // Get overdue cheques
  Future<Result<List<Cheque>>> getOverdueCheques();

  // Get cheques for customer
  Future<Result<List<Cheque>>> getCustomerCheques(int customerId);

  // Add cheque
  Future<Result<void>> addCheque(Cheque cheque);

  // Update status (pending → cleared/bounced)
  Future<Result<void>> updateChequeStatus(int chequeId, String newStatus);
}
```

---

## 📊 Dashboard Feature (lib/features/dashboard/)

### Dashboard Metrics (Calculated from other features)

```dart
import 'package:pasal_pro/features/dashboard/domain/entities/dashboard_metric.dart';

// Metrics auto-calculated on dashboard page load
// No explicit entity, but values include:

class DashboardMetrics {
  // Sales metrics
  double totalSales;        // Sum of all sale amounts (today)
  int totalTransactions;    // Count of sales (today)
  double averageSaleValue;  // totalSales / totalTransactions

  // Profit metrics
  double totalProfit;       // sum( (selling - cost) * quantity sold )
  double profitMargin;      // (totalProfit / totalSales) * 100

  // Customer credit
  double totalCredit;       // Sum of all customer debts
  int creditorsCount;       // Customers with pending credit

  // Inventory
  int lowStockCount;        // Products below threshold
  int totalProductCount;    // Total product types

  // Cheque tracking
  double pendingCheques;    // Sum of pending cheque amounts
  int overdueCount;         // Cheques past due date

  // Activity
  List<Sale> recentTransactions;  // Last 10 sales
}
```

---

## 🔌 Riverpod Providers (Presentation)

### Product Providers

```dart
import 'package:pasal_pro/features/products/presentation/providers/product_providers.dart';

// Get all products (async - fetches from DB)
ref.watch(productsProvider)
// Returns: AsyncValue<List<Product>>

// Get product by ID (parameterized)
ref.watch(productByIdProvider(42))
// Returns: AsyncValue<Product>

// Search products (updates with query)
ref.watch(searchQueryProvider)        // String
ref.watch(searchResultsProvider)      // AsyncValue<List<Product>>

// Manually refresh
ref.invalidate(productsProvider);

// Update product stock
ref.read(productsProvider.notifier).updateStock(productId, newCount);
```

### Sales Providers

```dart
import 'package:pasal_pro/features/sales/presentation/providers/sale_providers.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';

// Current sale being entered (mutable)
ref.watch(fastSaleProvider)
// Returns: FastSaleState (cart items, total)

// Add item to current sale
ref.read(fastSaleProvider.notifier).addItem(productId, quantity);

// Remove item
ref.read(fastSaleProvider.notifier).removeItem(productId);

// Finalize and save sale
ref.read(fastSaleProvider.notifier).finalizeSale();

// Get recent sales
ref.watch(recentSalesProvider)
// Returns: AsyncValue<List<Sale>>

// Daily revenue
ref.watch(dailyRevenueProvider(date))
// Returns: AsyncValue<double>
```

### Customer Providers

```dart
import 'package:pasal_pro/features/customers/presentation/providers/customer_providers.dart';

// Get all customers
ref.watch(customersProvider)
// Returns: AsyncValue<List<Customer>>

// Get customers with credit
ref.watch(activeCreditorsProvider)
// Returns: AsyncValue<List<Customer>>

// Total credit owed
ref.watch(totalCreditProvider)
// Returns: AsyncValue<double>

// Customer by ID
ref.watch(customerByIdProvider(5))
// Returns: AsyncValue<Customer>
```

### Dashboard Providers

```dart
import 'package:pasal_pro/features/dashboard/presentation/providers/dashboard_providers.dart';

// All dashboard metrics
ref.watch(dashboardMetricsProvider)
// Returns: AsyncValue<DashboardMetrics>

// Individual metrics
ref.watch(dailySalesProvider)          // Today's total
ref.watch(dailyProfitProvider)         // Today's profit
ref.watch(lowStockProductsProvider)    // Warning items
ref.watch(pendingCheqeuesProvider)     // Cheque tracking

// Auto-refresh every 30 seconds (internal)
// Manual refresh: ref.invalidate(dashboardMetricsProvider)
```

---

## 🎛️ State Management Pattern

### Using Providers in Widgets

```dart
// Read-only access (doesn't rebuild on change)
final value = ref.read(myProvider);

// Watch (rebuilds when provider changes)
final asyncValue = ref.watch(myProvider);
asyncValue.when(
  data: (value) => Text('Data: $value'),
  loading: () => CircularProgressIndicator(),
  error: (err, st) => Text('Error: $err'),
);

// StateNotifier - Mutate state
ref.read(fastSaleProvider.notifier).addItem(...);
```

### Provider Composition

```dart
// One provider depends on another
final filteredProductsProvider = FutureProvider((ref) async {
  final allProducts = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider);

  return allProducts.whenData((products) =>
    products.where((p) => p.name.contains(query)).toList()
  );
});
// Auto-updates when either upstream provider changes
```

---

## 🗄️ Database Models (Implementation Detail)

Located in `data/models/`, these are internal (not part of public API).

Example structure:

```dart
@Collection()
class ProductModel {
  Id id = Isar.autoIncrement;
  @Index(type: IndexType.value, caseSensitive: false)
  late String name;
  late double costPrice;
  // ... more fields
}
```

Conversion: `ProductModel.toEntity()` → `Product` entity

---

## ❌ What NOT to Use

```dart
// ❌ Don't use setState() - use Riverpod instead
setState(() { _products = newProducts; });

// ❌ Don't hardcode colors - use AppColors
color: Color(0xFF4CAF50);

// ❌ Don't hardcode spacing - use AppSpacing
SizedBox(height: 16)

// ❌ Don't use print() - use AppLogger
print('Debug message')

// ❌ Don't access Isar directly - use repository
final isar = Isar.getInstance();  // Wrong!

// ❌ Don't throw exceptions - return Result<T>
throw CustomException();
```

---

## 📚 Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - System design
- [DEVELOPMENT.md](DEVELOPMENT.md) - Developer setup
- [TESTING.md](TESTING.md) - Testing entities and repositories

---

## Summary

**Domain Entities:**

- `Product`, `Sale`, `SaleItem`, `Customer`, `Transaction`, `Cheque`

**Repositories (Abstract):**

- `ProductRepository`, `SaleRepository`, `CustomerRepository`, `ChequeRepository`

**Core Utilities:**

- `Result<T>`, `CurrencyFormatter`, `DateFormatter`, `UnitConverter`

**Providers:**

- `FutureProvider` for data, `StateNotifierProvider` for mutable state

**Usage Pattern:**

```
Provider → Repository → DataSource → Database
           (Domain)      (Data)        (Isar)
             ↓
            Widget (watches provider, displays data)
```
