# Architecture Documentation

**Status:** Phase 7 - Complete  
**Last Updated:** February 5, 2026

---

## 📐 Design Patterns & Architecture

### Clean Architecture (3-Layer Pattern)

Pasal Pro follows **Clean Architecture** with domain-driven design:

```
┌─────────────────────────────────────────┐
│  PRESENTATION LAYER                     │
│  ├─ Pages (ConsumerStatefulWidget)      │
│  ├─ Widgets (ConsumerWidget)            │
│  └─ Providers (Riverpod)                │
├─────────────────────────────────────────┤
│  DOMAIN LAYER                           │
│  ├─ Entities (Pure Dart, Immutable)     │
│  ├─ Repositories (Abstractions)         │
│  └─ Use Cases (Business Logic)          │
├─────────────────────────────────────────┤
│  DATA LAYER                             │
│  ├─ Models (@Collection Isar)           │
│  ├─ Data Sources (Database Access)      │
│  └─ Repository Implementations          │
└─────────────────────────────────────────┘
        ↓ Dependencies Flow Inward ↓
```

### Key Principles

1. **Dependency Inversion:** High-level modules depend on abstractions
2. **Single Responsibility:** Each class has one reason to change
3. **Separation of Concerns:** Clear boundaries between layers
4. **Testability:** Domain logic has zero external dependencies
5. **Immutability:** Domain entities are immutable where possible

---

## 📁 Feature Module Structure

Each feature follows a consistent structure:

```
lib/features/<feature>/
├── domain/                          # Pure Dart (no framework deps)
│   ├── entities/
│   │   └── product.dart            # Business models, immutable
│   ├── repositories/
│   │   └── product_repository.dart # Abstract interfaces
│   └── usecases/
│       ├── get_products.dart
│       ├── create_product.dart
│       ├── update_stock.dart
│       └── search_products.dart
│
├── data/                            # Database + Implementation
│   ├── models/
│   │   └── product_model.dart       # @Collection() Isar models
│   ├── datasources/
│   │   └── product_local_datasource.dart  # Raw queries
│   └── repositories/
│       └── product_repository_impl.dart   # Repository impl
│
└── presentation/                    # UI + State Management
    ├── providers/
    │   └── product_providers.dart   # Riverpod providers
    ├── pages/
    │   └── products_page.dart       # Full screens
    └── widgets/
        ├── product_card.dart
        ├── product_form.dart
        └── product_list.dart
```

### Layer Responsibilities

#### Domain Layer

- **Entities:** Immutable business models
  - Methods: Business logic (e.g., `profitMargin`, `isLowStock`)
  - No database/framework knowledge
- **Repositories:** Abstract contracts
  - Interface only (no implementation)
  - Define what data operations exist
- **Use Cases:** Single-responsibility operations
  - Orchestrate domain logic
  - Return `Result<T>` (Success | Error)

#### Data Layer

- **Models:** Isar @Collection classes
  - Database schema definition
  - Auto-generated getters/setters
  - `toEntity()` conversion method
- **Data Sources:** Raw database access
  - Single-purpose query methods
  - No business logic
- **Repositories:** Concrete implementations
  - Implement abstract interfaces
  - Use data sources
  - Transform models ↔ entities

#### Presentation Layer

- **Providers:** Riverpod state management
  - `FutureProvider` for async data
  - `StateNotifierProvider` for mutable state
  - Auto-dispose for memory efficiency
- **Pages:** Full screens (ConsumerStatefulWidget)
  - Watch providers
  - Handle navigation
  - Coordinate widgets
- **Widgets:** Reusable components (ConsumerWidget)
  - Single responsibility
  - Max 250 lines
  - Composed from smaller widgets

---

## 🔄 Data Flow Architecture

### Successful Operation Flow

```
User Action (Button Tap)
    ↓
Page/Widget Updates Provider
    ↓
Provider calls Use Case
    ↓
Use Case validates input
    ↓
Use Case calls Repository method
    ↓
Repository calls Data Source (Isar)
    ↓
Database returns Model
    ↓
Data Source converts Model → Entity
    ↓
Repository returns Result<Entity>
    ↓
Use Case returns Result (success)
    ↓
Provider emits updated state
    ↓
Widget rebuilds with new data
```

### Error Handling Flow

```
Database Error
    ↓
Data Source throws Exception
    ↓
Repository catches and returns Error(Failure)
    ↓
Use Case returns Error(Failure)
    ↓
Provider emits error state
    ↓
Widget shows error message
```

---

## 🏛️ State Management: Riverpod

### Provider Patterns Used

#### 1. FutureProvider (Async Data)

```dart
// Fetch data from repository
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getProducts();
  return result.fold(
    onSuccess: (products) => products,
    onError: (failure) => throw failure,
  );
});
```

**Use Case:** Fetching static data, minimal user interaction

#### 2. StateNotifierProvider (Mutable State)

```dart
// Mutable cart state
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// StateNotifier implementation
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState.initial());

  void addItem(Product product, int quantity) {
    state = state.copyWith(items: [...state.items, item]);
  }
}
```

**Use Case:** Shopping cart, form state, filters

#### 3. AutoDispose (Memory Management)

```dart
// Temporary state that auto-disposes when unused
final searchResultsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider);
  // Rebuilds when query changes
  // Disposes when no widgets watch it
});
```

**Use Case:** Search results, temporary filters

#### 4. Provider Dependencies

```dart
// One provider depends on another
final low StockProvider = FutureProvider<List<Product>>((ref) {
  // Automatically rebuilds when productsProvider changes
  final products = ref.watch(productsProvider);
  return products.whenData((p) => p.where((x) => x.isLowStock).toList());
});
```

**Pattern:** Composition over duplication

---

## 💾 Database Architecture: Isar

### Model-Entity Relationship

```
Database (Isar)
    ↓
ProductModel (@Collection)      Data Layer
    ↓ toEntity()
Product (Entity)               Domain Layer
    ↓ Used in
Use Cases & UI                Presentation Layer
```

### Isar Collections

```dart
@Collection()
class ProductModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;  // For search

  late double costPrice;
  late double sellingPrice;
  late int stockPieces;

  @Ignore()
  double get profitPerPiece => sellingPrice - costPrice;
}
```

**Key Patterns:**

- **Id:** Auto-increment primary key
- **Indexed Fields:** For fast queries (name, barcode)
- **Ignored Fields:** Computed properties
- **Required Fields:** Use `late` for non-nullable

### Query Patterns

```dart
// Get all active products
final products = isar.productModels
    .filter()
    .isActiveEqualTo(true)
    .findAll();

// Search by name
final results = isar.productModels
    .filter()
    .nameContains('rice')
    .findAll();

// Low stock alert
final lowStock = isar.productModels
    .filter()
    .stockPiecesLessThanOrEqualTo(threshold)
    .findAll();

// Atomic transaction
await isar.writeTxn(() async {
  await isar.salesModels.put(sale);
  await isar.transactionModels.put(transaction);
});
```

---

## 🎯 Key Architectural Patterns

### 1. Result Type (Sealed Class)

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

// Usage in use cases
Future<Result<Product>> createProduct(Product product) async {
  if (!isValid(product)) {
    return Error(ValidationFailure(...));
  }
  try {
    final result = await repository.create(product);
    return Success(result);
  } catch (e) {
    return Error(DatabaseFailure(...));
  }
}
```

**Benefits:**

- No exceptions in business logic
- Explicit error handling
- Type-safe success/error
- Exhaustive pattern matching

### 2. Failure Type Hierarchy

```dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required message}) : super(message);
}

class BusinessFailure extends Failure {
  const BusinessFailure({required message}) : super(message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(message) : super(message);
}
```

**Usage:** Different error types → Different UI responses

### 3. Entity Immutability

```dart
class Product extends Equatable {
  final int id;
  final String name;
  // ... other fields

  const Product({
    required this.id,
    required this.name,
    // ...
  });

  // Immutable copy
  Product copyWith({
    String? name,
    int? stockPieces,
    // ...
  }) => Product(
    id: id,
    name: name ?? this.name,
    stockPieces: stockPieces ?? this.stockPieces,
  );

  @override
  List<Object?> get props => [id, name, ...];
}
```

**Benefits:**

- Predictable state changes
- Easy testing
- Clear intent (no mutations)

---

## 🔌 Feature Integration

### Cross-Feature Dependencies

```
Dashboard
  ├── Watches: Products, Sales, Customers, Cheques
  └── Provides: Real-time statistics

Sales
  ├── Watches: Products (stock validation)
  ├── Watches: Customers (credit check)
  └── Creates: Sale + Transaction records

Customers
  ├── Watches: Transactions (balance calc)
  └── Created by: Sales (new customer)

Products
  └── Queried by: Sales, Dashboard, Customers

Cheques
  ├── Watches: Customers (payment tracking)
  └── Updates: Customer ledger
```

### Provider Composition

```dart
// Sales watching products for validation
class FastSaleNotifier extends StateNotifier<FastSaleState> {
  final Ref ref;

  void addItem(int productId, int qty) {
    // Watch products to validate stock
    final productsAsync = ref.watch(productsProvider);

    productsAsync.whenData((products) {
      final product = products.firstWhere((p) => p.id == productId);
      if (product.stockPieces >= qty) {
        // Add to cart
      }
    });
  }
}
```

---

## 📊 Responsive Design Architecture

### Breakpoint System

```
Mobile (<1024px)
    ↓
Tablet (1024-1366px)
    ↓
Desktop (1366-1920px)
    ↓
4K (2560px+)
```

### Layout Strategy

```dart
if (AppResponsive.isMedium(context)) {
  // 2-column layout
} else if (AppResponsive.isLarge(context)) {
  // 3-column layout
}

// Responsive padding
final padding = AppResponsive.getValue(
  context,
  small: 8,
  medium: 12,
  large: 16,
  xLarge: 20,
);
```

---

## 🧪 Testing Architecture

### Test Layers

```
Unit Tests (Domain)
  ↓ No dependencies
  ↓ Fast (<100ms each)
  ↓ 100% coverage

Integration Tests (Data)
  ↓ Mock Isar
  ↓ Medium speed
  ↓ 80%+ coverage

Widget Tests (UI)
  ↓ Render widgets
  ↓ Slower
  ↓ 60%+ coverage
```

### Test Strategy

```dart
// Unit test - no mocks needed
test('profitMargin calculates correctly', () {
  final product = Product(...);
  expect(product.profitMargin, 20.0);
});

// Integration test - mock repository
test('createProduct validates input', () async {
  final mockRepo = MockProductRepository();
  final usecase = CreateProduct(mockRepo);

  final result = await usecase(invalidParams);
  expect(result, isA<Error>());
});

// Widget test - render UI
testWidgets('ProductCard displays name', (WidgetTester tester) async {
  await tester.pumpWidget(ProductCard(product: product));
  expect(find.text('Rice'), findsOneWidget);
});
```

---

## 🎨 Design System Architecture

### Design Tokens (Mix)

```dart
// Colors
PasalColorToken.primary.token.resolve(context)
PasalColorToken.error.token.resolve(context)

// Spacing
PasalSpaceToken.small.token   // 8px
PasalSpaceToken.medium.token  // 16px
PasalSpaceToken.large.token   // 24px

// Typography
PasalTextStyle.headline1
PasalTextStyle.bodyMedium
```

**Benefits:**

- Centralized theme
- Consistent spacing
- Easy dark mode support

---

## 🚀 Performance Considerations

### Critical Metrics

- **Sale Entry:** < 2 seconds
- **Product Search:** < 100ms
- **Database Queries:** < 100ms
- **Widget Build:** < 16ms

### Optimization Techniques

1. **Query Indexing**

   ```dart
   @Index(type: IndexType.value)  // For contains queries
   late String name;
   ```

2. **Provider AutoDispose**

   ```dart
   final searchProvider = FutureProvider.autoDispose(...);
   ```

3. **Widget Composition**
   - Smaller, composable widgets
   - Avoid widget tree bloat
   - Memoize expensive computations

4. **Database Transactions**
   ```dart
   await isar.writeTxn(() async {
     // Atomic multi-model updates
   });
   ```

---

## 📖 Summary

Pasal Pro uses **Clean Architecture** with:

- **Domain Layer:** Pure business logic
- **Data Layer:** Isar database + repository implementations
- **Presentation Layer:** Riverpod + Flutter UI
- **Cross-cutting:** Result types, failure hierarchy, design tokens

This architecture ensures:
✅ Testability (domain has no deps)
✅ Maintainability (clear separation)
✅ Scalability (feature-based structure)
✅ Flexibility (swappable implementations)

See [DEVELOPMENT.md](DEVELOPMENT.md) for setup guide.

Pasal Pro uses **Clean Architecture** with:

- **Domain Layer:** Pure business logic
- **Data Layer:** Isar database + repository implementations
- **Presentation Layer:** Riverpod + Flutter UI
- **Cross-cutting:** Result types, failure hierarchy, design tokens

This architecture ensures:
✅ Testability (domain has no deps)
✅ Maintainability (clear separation)
✅ Scalability (feature-based structure)
✅ Flexibility (swappable implementations)

See [DEVELOPMENT.md](DEVELOPMENT.md) for setup guide.
