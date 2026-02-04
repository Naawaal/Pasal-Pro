# Pasal Pro - AI Coding Agent Instructions

**Project:** Digital Khata/POS system for Nepali wholesale shops  
**Platform:** Flutter Desktop (Windows/Linux/macOS primary)  
**Current Phase:** Phase 7 Complete ✅ | Dashboard fully functional  
**Status:** Feature-complete core with Phase 1-7 implementations

---

## 🏗️ Architecture Overview

### Clean Architecture (3-Layer Pattern)

```
features/<feature>/
├── domain/           # Pure Dart business logic (no framework deps)
│   ├── entities/     # Immutable data classes (business models)
│   ├── repositories/ # Abstract repository interfaces
│   └── usecases/     # Single-responsibility operations
├── data/             # Isar database + repository implementation
│   ├── models/       # @Collection() classes → .g.dart generation
│   ├── datasources/  # Raw database queries
│   └── repositories/ # Concrete repository implementations
└── presentation/     # UI + state management
    ├── providers/    # Riverpod FutureProvider & StateNotifierProvider
    ├── pages/        # ConsumerStatefulWidget (full screens)
    └── widgets/      # ConsumerWidget (reusable components)
```

### Key Patterns Implemented

- **Domain entities** → Business logic methods (e.g., `profitMargin`, `isLowStock`)
- **Data models** → `@Collection()` Isar models with value indexes
- **Result<T> type** → Sealed class (`Success<T>` | `Error<T>`) for error handling
- **Repository pattern** → Domain abstracts, Data implements with Isar queries
- **Provider pattern** → Riverpod `FutureProvider` for async data, `StateNotifierProvider` for mutable state

### Riverpod Provider Patterns

```dart
// 1. Simple async data fetching
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final isar = await DatabaseService.instance.database;
  return isar.products.where().findAll();
});

// 2. Mutable state with StateNotifier
final currentSaleProvider = StateNotifierProvider<SaleNotifier, Sale>((ref) {
  return SaleNotifier();  // Custom StateNotifier class
});

// 3. Auto-dispose for temporary state (memory efficient)
final searchResultsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final isar = await DatabaseService.instance.database;
  return isar.products.filter().nameContains(query).findAll();
});

// 4. Cache invalidation for manual refresh
ref.invalidate(productsProvider);  // Triggers refetch on next watch()
```

---

## 🛠️ Development Workflows

### Critical: After ANY Isar Model Changes

**Required every time you modify `@Collection()` classes:**

```bash
# Always run after model edits - generates .g.dart files
dart run build_runner build --delete-conflicting-outputs

# Or watch mode during development (auto-regenerates on save)
dart run build_runner watch
```

⚠️ **Without this, imports like `part 'product_model.g.dart'` will fail**

### Running the App (Desktop First)

```bash
flutter run -d windows   # Primary platform (default)
flutter run -d linux     # Linux build
flutter run -d macos     # macOS build (Intel/Apple Silicon)

# Debug with DevTools
flutter run -d windows --devtools
```

### Before Committing Code

```bash
# Check for analysis warnings (MUST BE ZERO)
flutter analyze

# Run all tests
flutter test

# Auto-format code
dart format lib test

# Optional: Generate coverage
flutter test --coverage
```

### Project Structure Discovery

**Key entry points:**

- `lib/main.dart` → Desktop nav rail + theme provider
- `lib/core/` → Shared utilities, theme, constants, database
- `lib/features/` → Feature modules (products, sales, customers, dashboard, cheques, settings)
- `test/` → Unit & widget tests
- `.github/skills/` → Custom AI skill definitions

### Common Development Tasks

| Task                     | Command                                   | Notes                              |
| ------------------------ | ----------------------------------------- | ---------------------------------- |
| Add package              | `flutter pub add <pkg>`                   | Updates pubspec.yaml               |
| Run tests                | `flutter test`                            | Runs all `test/**_test.dart` files |
| Get specific widget tree | Use DevTools > Flutter > Widget Inspector | Inspect live widgets               |
| Check build size         | `flutter build windows --analyze-size`    | Identify bloat                     |
| Watch for changes        | `dart run build_runner watch`             | During model development           |
| Kill all instances       | `taskkill /F /IM pasal_pro.exe`           | Windows cleanup                    |

---

## 📏 Code Quality Standards

### File Size Limits (STRICT - Enforced)

```yaml
Hard Limits:
  - Widget files: 250 lines max
  - Other Dart: 300 lines max
  - Functions: 50 lines max
  - build() methods: 30 lines max
```

**Enforcement:** Extract widgets to separate files when approaching limits. Use composition over complexity. Reference: `.github/skills/flutter-guideline/SKILL.md`

### Naming Conventions

```dart
// Files: snake_case
product_card_widget.dart   // ✅
ProductCard.dart           // ❌

// Private fields: underscore prefix
final _controller = TextEditingController();  // ✅

// Booleans: is/has prefix
bool isActive;      // ✅
bool hasLowStock;   // ✅
bool active;        // ❌

// Collections: plural
List<Product> products;  // ✅
List<Product> product;   // ❌

// Providers: descriptive nouns
final productsProvider = FutureProvider(...)  // ✅
final getProducts = FutureProvider(...)       // ❌
```

### Class Member Order (REQUIRED)

```dart
class MyWidget extends StatelessWidget {
  // 1. Static constants
  static const double _iconSize = 24;

  // 2. Instance variables (public first)
  final String title;

  // 3. Instance variables (private)
  final _controller = TextEditingController();

  // 4. Constructor
  const MyWidget({super.key, required this.title});

  // 5. Lifecycle methods (initState, dispose)
  @override
  void initState() { }

  // 6. Public methods
  void refresh() { }

  // 7. Private methods
  void _loadData() { }

  // 8. Build/UI methods
  @override
  Widget build(BuildContext context) { }

  Widget _buildCard() { }  // Build helpers use _build prefix
}
```

### Comments & Documentation

```dart
// ✅ Explain WHY, not what (code shows what)
// Query products sorted by low stock first to alert users early
final lowStockProducts = products.where((p) => p.stock < p.threshold).toList();

// ❌ Redundant comments
// Get products where stock is less than threshold
final lowStockProducts = products.where((p) => p.stock < p.threshold).toList();

// ✅ Document non-obvious business logic
/// Cost = wholesale price + 15% margin to match competitor pricing strategy
double calculateCost(double wholesalePrice) => wholesalePrice * 1.15;

// ✅ Flag performance-critical sections
// PERFORMANCE: This query runs on every sale - keep indexed
final products = isar.products.where().nameContains(query).findAll();
```

---

## 🎨 UI Standards & Constants

### Spacing: Use AppSpacing (Gap package)

```dart
import 'package:pasal_pro/core/constants/app_spacing.dart';

Column(
  children: [
    Text('First'),
    AppSpacing.small,   // 12px vertical gap
    Text('Second'),
    AppSpacing.medium,  // 16px
    Text('Third'),
  ],
)

Row(
  children: [
    Icon(...),
    AppSpacing.hSmall,  // 12px horizontal
    Text('Label'),
  ],
)
```

**Available:** `xxSmall` (4px), `xSmall` (8px), `small` (12px), `medium` (16px), `large` (24px), `xLarge` (32px), `xxLarge` (48px)  
**Horizontal variants:** Prefix with `h` (e.g., `AppSpacing.hMedium`)

### Icons: Use AppIcons (Lucide)

```dart
import 'package:pasal_pro/core/constants/app_icons.dart';

Icon(AppIcons.store)      // Business
Icon(AppIcons.rupee)      // Financial (indianRupee)
Icon(AppIcons.add)        // Actions (plus)
Icon(AppIcons.success)    // Status (circleCheck)
```

**Categories:** Navigation, CRUD, Business, Financial, Status, Inventory  
**Ref:** [lib/core/constants/app_icons.dart](../lib/core/constants/app_icons.dart)

### Colors: Use Theme + AppColors

```dart
// ✅ Use theme colors
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.error
Theme.of(context).textTheme.bodyMedium

// ✅ Business-specific colors in AppColors
import 'package:pasal_pro/core/constants/app_colors.dart';

AppColors.profitColor   // Green (#4CAF50)
AppColors.lossColor     // Red (#F44336)
AppColors.creditColor   // Orange (#FF9800)
AppColors.bgLight       // Light background
AppColors.bgDark        // Dark background

// ❌ Never hardcode hex values
Color.fromARGB(255, 76, 175, 80)  // NO
```

### Material 3 Theme Structure

The app uses `AppTheme` for consistent Material 3 theming:

```dart
// lib/core/theme/app_theme.dart
AppTheme.lightTheme   // Light mode MaterialTheme
AppTheme.darkTheme    // Dark mode MaterialTheme

// Theme toggling in settings
ref.read(appThemeModeProvider.notifier).state = ThemeMode.dark;
```

---

## 🗄️ Database Patterns (Isar)

### Model Structure & Best Practices

```dart
import 'package:isar/isar.dart';
part 'product_model.g.dart';

@Collection()
class ProductModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)  // For search
  late String name;

  late double costPrice;
  late double sellingPrice;
  late int piecesPerCarton;
  late int stockPieces;
  late int lowStockThreshold;

  String? category;

  @Index(unique: true, replace: true, type: IndexType.hash)  // For barcode
  String? barcode;

  String? imageUrl;

  // ✅ Computed properties NOT stored in DB
  @Ignore()
  double get profitPerPiece => sellingPrice - costPrice;

  @Ignore()
  double get profitMargin {
    if (costPrice == 0) return 0;
    return ((sellingPrice - costPrice) / costPrice) * 100;
  }
}
```

### Index Guidelines

- **Value index:** Full-text search on strings (`@Index(type: IndexType.value, caseSensitive: false)`)
- **Hash index:** Exact match lookup (faster for equality, slower for contains)
- **Unique index:** Enforce uniqueness + primary keys (`@Index(unique: true, replace: true)`)
- **No index on:** Collections not frequently queried, to save memory

### Query Patterns

```dart
// All products
isar.productModels.where().findAll();

// Search by name (indexed)
isar.productModels.filter().nameContains('rice').findAll();

// Filter + sort
isar.productModels
    .filter()
    .stockPiecesLessThan(10)
    .sortByStockPieces()
    .findAll();

// By ID (auto-indexed)
isar.productModels.get(42);

// Count
isar.productModels.filter().categoryEqualTo('grains').count();
```

### Repository Pattern

```dart
// Domain layer: Abstract interface (no Isar deps)
abstract class ProductRepository {
  Future<Result<List<Product>>> getAllProducts();
  Future<Result<void>> addProduct(Product product);
}

// Data layer: Isar implementation (ref: lib/features/products/data/repositories/)
class ProductRepositoryImpl implements ProductRepository {
  final Isar _isar;

  @override
  Future<Result<List<Product>>> getAllProducts() async {
    try {
      final models = await _isar.productModels.where().findAll();
      return Success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
```

### Model-to-Entity Conversion

```dart
// In ProductModel (data/models/product_model.dart)
Product toEntity() => Product(
  id: id.toInt(),
  name: name,
  costPrice: costPrice,
  sellingPrice: sellingPrice,
  // ... other fields
);

// In data source
static ProductModel fromEntity(Product product) => ProductModel()
  ..id = product.id == null ? Isar.autoIncrement : product.id!
  ..name = product.name
  // ... set other fields
```

---

## 🌐 Localization & Formatting

### Currency Formatting

```dart
import 'package:pasal_pro/core/utils/currency_formatter.dart';

// Automatically formats as "Rs. 1,234.56"
String formatted = CurrencyFormatter.format(1234.56);
```

### Date Formatting

```dart
import 'package:pasal_pro/core/utils/date_formatter.dart';

// Returns time ago (e.g., "2m ago", "Just now", or full date)
String timeAgo = DateFormatter.formatDate(DateTime.now());
```

### Unit Conversion

```dart
import 'package:pasal_pro/core/utils/unit_converter.dart';

// Convert between cartons and pieces
int pieces = UnitConverter.cartonsToPieces(2, piecesPerCarton: 12);  // 24 pieces
int cartons = UnitConverter.piecesToCartons(24, piecesPerCarton: 12); // 2 cartons
```

---

## 🧪 Testing Standards

### Test Coverage Requirements

- **Core utilities:** 100% required (enforced in Phase 0)
  - Test all `result.dart` sealed class behavior
  - Test formatters: `CurrencyFormatter`, `DateFormatter`, `UnitConverter`
  - Test business logic in entities (e.g., `profitMargin` calculation)
- **Use cases:** 100% required (business logic validation)
  - Test both success and error paths
  - Mock repositories using `isar_test` package
- **Repositories:** 80%+ with mocked Isar
  - Test database queries and transformations
  - Mock `Isar` using `isar_test` for offline testing
- **UI widgets:** 60%+ focusing on user interactions
  - Test navigation, button taps, text input
  - Use `WidgetTester` for interaction tests
  - Don't test implementation details (e.g., exact spacing)

### Test File Naming & Location

```
lib/features/products/domain/usecases/get_products.dart
test/features/products/domain/usecases/get_products_test.dart

lib/features/products/presentation/widgets/product_card.dart
test/features/products/presentation/widgets/product_card_test.dart
```

### Test Examples

```dart
// test/features/products/domain/usecases/add_product_test.dart
void main() {
  group('AddProduct', () {
    test('should add product when validation passes', () async {
      // Arrange
      final mockRepo = MockProductRepository();
      final usecase = AddProduct(mockRepo);

      // Act
      final result = await usecase(product);

      // Assert
      expect(result, isA<Success>());
    });

    test('should fail when selling price <= cost price', () async {
      // Invalid product has selling price = cost price
      final result = await usecase(invalidProduct);
      expect(result, isA<Error>());
    });
  });
}
```

---

## 📦 Dependencies

### Core Dependencies

- **State:** `flutter_riverpod` (NOT bloc)
- **DB:** `isar` + `isar_flutter_libs`
- **Codegen:** `freezed`, `json_serializable`, `build_runner`
- **UI:** `lucide_icons_flutter`, `gap`, `flutter_form_builder`
- **Desktop:** `window_manager`, `bitsdojo_window`

### Forbidden Patterns

❌ **Don't use:**

- `setState()` in feature code (use Riverpod)
- Magic numbers for spacing (use `AppSpacing`)
- Random icons (use `AppIcons`)
- Direct hex colors in widgets (use `Theme.of(context)`)
- `print()` statements (use `AppLogger.info/warn/error`)

---

## 🎯 Project Context & Implementation Status

### Business Domain

- **Users:** Shop owners (low-tech comfort), staff (medium proficiency)
- **Problem:** Manual paper-based Khata (ledger) systems lead to data loss, calculation errors, slow transactions
- **Solution:** Desktop POS with offline-first Isar DB, 2-second sale entry, hybrid units (cartons+pieces), profit tracking, credit ledger
- **Success Metric:** <2 second transaction time, 85% reduction in entry time (15s → 2s)

### Completed Features (Phases 1-7)

| Phase | Feature                                      | Status      |
| ----- | -------------------------------------------- | ----------- |
| P1    | Product Management (CRUD, search, low-stock) | ✅ Complete |
| P2    | Fast Sales Entry (2-click transactions)      | ✅ Complete |
| P3    | Customers & Credit Ledger                    | ✅ Complete |
| P4    | Cheque Management                            | ✅ Complete |
| P5    | Reports & Analytics                          | ✅ Complete |
| P6    | Settings & Data Export                       | ✅ Complete |
| P7    | Dashboard with Real-time Metrics             | ✅ Complete |

### Key Implemented Patterns

**Desktop Navigation (main.dart):**

- Navigation rail on left (collapsed/expanded toggle)
- App bar with search, sync status, theme selection
- 5 main nav destinations + settings/help/account footer panels
- Keyboard shortcuts support

**State Management (Riverpod):**

- `FutureProvider` for async data (products, sales, stats)
- `StateNotifierProvider` for mutable state (current sale cart, search query)
- Provider invalidation for cache busting on manual refresh
- Auto-dispose providers for temporary UI state

**Dashboard (Phase 7 Complete):**

- Real-time activity feed (last 10 transactions)
- Store statistics aggregation (10+ metrics: sales, profit, credit, stock)
- Auto-refresh every 30 seconds with manual override
- Pull-to-refresh support

**Database (Isar):**

- ProductModel, CustomerModel, SaleModel, SaleItemModel, ChequeModel, TransactionModel
- Indexed queries for fast search (< 100ms)
- Computed properties (@Ignore) for derived fields
- Soft-delete via `isActive` flag

---

## 🤖 AI Skill System

### Available Skills (`.github/skills/`)

The project uses custom AI skills for orchestrated development:

| Skill                   | Purpose                                  | Use When                                |
| ----------------------- | ---------------------------------------- | --------------------------------------- |
| **app-architect**       | Project planning & phased execution      | "Build a feature from scratch"          |
| **flutter-feature**     | Generate Clean Architecture modules      | "Create Product feature with use cases" |
| **flutter-ui**          | Material 3 UI components & layouts       | "Build product card widget"             |
| **flutter-guideline**   | Code quality enforcement (SOLID, limits) | "Check if my code meets standards"      |
| **flutter-refactor**    | Systematic refactoring & modernization   | "Refactor to Clean Architecture"        |
| **design-intelligence** | UI/UX research & pattern discovery       | "Find POS app design inspiration"       |
| **product-manager**     | User stories, acceptance criteria, PRD   | "Define requirements for feature"       |

### When to Invoke Skills

```markdown
# Request a skill by name:

"Use the flutter-feature skill to create the Customer Management feature with these use cases:

- Get all customers
- Add customer
- Update customer balance
- Get customer by ID"

# Or reference by capability:

"I need to research inventory UI patterns. Use design-intelligence skill to find POS apps
that handle stock management well."

# For refactoring:

"Use flutter-refactor skill to improve code quality in lib/features/sales/presentation/"
```

### How Skills Enhance Development

1. **flutter-feature:** Generates boilerplate for domain → data → presentation layers
2. **flutter-ui:** Recommends Material 3 patterns, builds responsive layouts
3. **flutter-guideline:** Ensures file size limits, naming conventions, SOLID principles
4. **design-intelligence:** Analyzes competitor apps, documents design patterns in `assets/design-research/`
5. **app-architect:** Plans multi-phase rollout with skill coordination

### Forbidden Patterns

❌ **Don't use:**

- `setState()` in feature code (use Riverpod)
- Magic numbers for spacing (use `AppSpacing`)
- Random icons (use `AppIcons`)
- Direct hex colors in widgets (use `Theme.of(context)`)
- `print()` statements (use `AppLogger.info/warn/error`)

---

## 🚀 Project Context

**Business Domain:** Nepali wholesale shops (kirana stores)  
**Key Features:** 2-second sale entry, hybrid units (cartons+pieces), profit tracking, credit ledger, offline-first  
**Target Users:** Shop owners (low-tech comfort), staff  
**Success Metric:** <2 second transaction time

**Current Phase:** Phase 0 complete (foundation). Phase 1 in progress (Product Management CRUD).

**Ref Docs:**

- [PRD](docs/PRD.md) - Product requirements, user stories
- [PHASE_0_SUMMARY](docs/PHASE_0_SUMMARY.md) - What's built so far
- [NEXT_STEPS](docs/NEXT_STEPS.md) - Implementation roadmap

---

## 🔧 Skill Integration

This project uses custom AI skills in [.github/skills/](.github/skills/):

- **flutter-feature** → Generate Clean Architecture modules
- **flutter-ui** → Build Material 3 UI components
- **flutter-guideline** → Code quality reference (file limits, SOLID)
- **app-architect** → Project planning, phased execution
- **product-manager** → User stories, acceptance criteria
- **design-intelligence** → UI/UX research, pattern discovery

**Usage:** Mention skills by name (e.g., "Use flutter-feature skill to add a new module") for automatic orchestration.

---

## 🔑 Key Files & Quick Reference

### Core System Files

- `lib/main.dart` - Desktop app shell with nav rail
- `lib/core/database/database_service.dart` - Isar singleton (get via `DatabaseService.instance.database`)
- `lib/core/utils/result.dart` - `Result<T>` error handling sealed class
- `lib/core/errors/failures.dart` - Failure type hierarchy
- `lib/core/constants/` - `app_spacing.dart`, `app_icons.dart`, `app_colors.dart`, `app_constants.dart`
- `lib/core/theme/app_theme.dart` - Material 3 light/dark themes

### Feature Template Structure

```
lib/features/<feature>/
├── domain/entities/product.dart         # Business model
├── domain/repositories/product_repository.dart  # Interface
├── domain/usecases/get_products.dart    # Use case with Result type
├── data/models/product_model.dart       # Isar @Collection()
├── data/datasources/product_local_datasource.dart
├── data/repositories/product_repository_impl.dart
├── presentation/providers/product_providers.dart  # Riverpod
├── presentation/pages/products_page.dart  # ConsumerStatefulWidget
└── presentation/widgets/product_card.dart  # ConsumerWidget
```

### Where to Find Things

- **How to query products by name?** → See `lib/features/products/data/datasources/`
- **How do I format currency?** → `CurrencyFormatter.format(amount)` in `lib/core/utils/currency_formatter.dart`
- **How to add a new Riverpod provider?** → Pattern in `lib/features/sales/presentation/providers/fast_sale_providers.dart`
- **How does the dashboard calculate metrics?** → `lib/features/dashboard/presentation/providers/dashboard_providers.dart`
- **Device/desktop settings?** → `lib/features/settings/` (theme mode, backup timing, etc.)

---

## ⚠️ Common Gotchas

### 1. After Editing Isar Models: MUST Run Code Gen

```bash
# Forgetting this = "part 'product_model.g.dart' not found" error
dart run build_runner build --delete-conflicting-outputs
```

### 2. Riverpod Provider Naming Convention

```dart
// ✅ Correct: Descriptive noun
final productsProvider = FutureProvider<List<Product>>(...)

// ❌ Wrong: Verb-like
final getProducts = FutureProvider<List<Product>>(...)

// ❌ Wrong: Generic
final dataProvider = FutureProvider<List<Product>>(...)
```

### 3. Result Type Usage (Not Optional<T>)

```dart
// ✅ Use Result for repository returns
Future<Result<List<Product>>> getAllProducts();

// ❌ Don't use nullable or Future.catchError
Future<List<Product>?> getAllProducts();

// Success/Error handling
result.when(
  data: (products) => print('Got ${products.length} products'),
  error: (failure) => print('Error: ${failure.message}'),
);
```

### 4. Never Use setState() in Feature Code

```dart
// ❌ Don't do this
void _loadProducts() {
  setState(() => _products = fetchedProducts);
}

// ✅ Use Riverpod instead
final productsProvider = FutureProvider((ref) => fetchProducts());
// Then in widget: final products = ref.watch(productsProvider);
```

### 5. Widget File Size Limit (250 lines)

```dart
// When your widget file approaches 250 lines:
// 1. Extract build helpers to _build* methods in same file
// 2. Extract reusable widgets to separate files
// 3. Move complex logic to providers

// Example: If ProductCard is 200+ lines, extract ProductCardHeader → product_card_header.dart
```

### 6. Query Indexing for Performance

```dart
// ✅ Fast: Using indexed field
isar.products.filter().nameContains('rice').findAll();  // 10ms

// ❌ Slow: No index
isar.products.filter().descriptionContains('organic').findAll();  // 500ms

// Solution: Add index or move to Dart-side filtering
```

### 7. Remember ConsumerStatefulWidget Lifecycle

```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    // Pre-fetch data or setup watchers
  }

  @override
  void dispose() {
    // Clean up subscriptions
    super.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access providers here
    final data = ref.watch(myProvider);
    return ...;
  }
}
```

### 8. Theme Colors: Use Theme.of(), NOT Hardcoded

```dart
// ✅ Works in light/dark mode
color: Theme.of(context).colorScheme.primary

// ❌ Breaks in dark mode
color: Color(0xFF1976D2)

// For business-specific colors
import 'package:pasal_pro/core/constants/app_colors.dart';
color: AppColors.profitColor  // Defined once, used everywhere
```

---

## 📚 Documentation References

- **Full PRD:** [docs/PRD.md](docs/PRD.md) - Product requirements, user personas, use cases
- **Phase Progress:** [docs/PHASE_7_PROGRESS.md](docs/PHASE_7_PROGRESS.md) - Latest implementation details
- **Next Steps:** [docs/NEXT_STEPS.md](docs/NEXT_STEPS.md) - Roadmap for upcoming phases
- **UI Status:** [docs/UI_INTEGRATION_STATUS.md](docs/UI_INTEGRATION_STATUS.md) - Which screens are complete
- **Known Issues:** [docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md) - Bugs and workarounds

---

## 🚀 Development Mindset

1. **Offline-first:** Always design for local Isar DB, cloud sync is Phase 6+
2. **Performance:** Target < 100ms for queries, < 2s for full transaction
3. **Nepali context:** Remember users are low-tech shop owners, keep UI simple
4. **Test coverage:** 100% for domain logic, 80%+ for data layer
5. **Clean Architecture:** Domain ⟶ Data ⟶ Presentation (never skip layers)
6. **Riverpod over BLoC:** Less boilerplate, easier testing, hot-reload friendly
7. **Composition over inheritance:** Use widgets, not deep class hierarchies
