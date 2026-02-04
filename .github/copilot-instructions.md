# Pasal Pro - AI Coding Agent Instructions

**Project:** Digital Khata/POS system for Nepali wholesale shops  
**Platform:** Flutter Desktop (Windows/Linux/macOS primary)  
**Architecture:** Clean Architecture + Offline-first (Isar DB)

---

## 🏗️ Architecture Overview

### Clean Architecture Layers

```
features/<feature>/
├── domain/           # Pure Dart business logic
│   ├── entities/     # Business models (immutable)
│   ├── repositories/ # Abstract interfaces
│   └── usecases/     # Single-responsibility business operations
├── data/             # Implementation details
│   ├── models/       # Isar database models with .g.dart
│   ├── datasources/  # local_datasource.dart (Isar)
│   └── repositories/ # Concrete repository implementations
└── presentation/     # UI layer
    ├── providers/    # Riverpod state management (NOT bloc/)
    ├── pages/        # Full screen widgets
    └── widgets/      # Reusable components
```

**Key Patterns:**

- **Domain entities** → pure Dart, business logic methods (e.g., `profitMargin`, `isLowStock`)
- **Data models** → Isar `@Collection()` with `.g.dart` generation, map to/from entities
- **Result type** → `Result<T>` sealed class (`Success<T>` | `Error<T>`) for error handling
- **Repository pattern** → Domain defines interface, Data implements with Isar

### State Management: Riverpod

Use `flutter_riverpod` providers, NOT BLoC. Example pattern:

```dart
// Provider file: <feature>_providers.dart
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});
```

---

## 🛠️ Development Workflows

### After Modifying Isar Models

Always run code generation when changing `@Collection()` classes:

```bash
dart run build_runner build --delete-conflicting-outputs
# Or watch mode during development:
dart run build_runner watch
```

### Running the App

```bash
flutter run -d windows   # Primary platform
flutter run -d linux
flutter run -d macos
```

### Before Committing

```bash
flutter analyze    # Zero warnings allowed
flutter test       # All tests must pass
dart format .      # Auto-format code
```

---

## 📏 Code Quality Standards

### File Size Limits (STRICT)

```yaml
Hard Limits:
  - Widget files: 250 lines max
  - Other Dart: 300 lines max
  - Functions: 50 lines max
  - build() methods: 30 lines max
```

**Enforcement:** Extract widgets to separate files when approaching limits. Use composition over complexity.

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
```

### Class Member Order

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

  // 5. Lifecycle methods
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

---

## 🎨 UI Standards

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
**Ref:** [lib/core/constants/app_icons.dart](lib/core/constants/app_icons.dart)

### Theme Colors

```dart
// Use theme colors, NOT hardcoded hex
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.error

// Business-specific colors in AppTheme:
AppTheme.profitColor   // Green (#4CAF50)
AppTheme.lossColor     // Red (#F44336)
AppTheme.creditColor   // Orange (#FF9800)
```

---

## 🗄️ Database Patterns (Isar)

### Model Structure

```dart
import 'package:isar/isar.dart';
part 'product_model.g.dart';

@Collection()
class ProductModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)  // Fast search
  late String name;

  late double costPrice;
  late double sellingPrice;

  // Computed properties (not stored)
  @Ignore()
  double get profitMargin => (sellingPrice - costPrice) / costPrice * 100;
}
```

### Index Guidelines

- **Value index:** Full-text search (`@Index(type: IndexType.value, caseSensitive: false)`)
- **Hash index:** Exact match lookup (`@Index(type: IndexType.hash)`)
- **Unique index:** Primary keys, barcodes (`@Index(unique: true, replace: true)`)

### Repository Pattern

```dart
// Domain layer: Abstract interface
abstract class ProductRepository {
  Future<Result<List<Product>>> getAllProducts();
  Future<Result<Product>> getProductById(int id);
}

// Data layer: Isar implementation
class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource _localDataSource;

  @override
  Future<Result<List<Product>>> getAllProducts() async {
    try {
      final models = await _localDataSource.getAllProducts();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
```

---

## 🌐 Localization (Nepali + English)

- **Currency:** Use `CurrencyFormatter.format(amount)` → `Rs. 1,234.56`
- **Dates:** Use `DateFormatter.formatDate(date)` → Nepali calendar support planned
- **Units:** Use `UnitConverter` for carton ↔ pieces conversions

---

## 🧪 Testing Standards

### Test Coverage

- **Core utilities:** 100% required (enforced in Phase 0)
- **Use cases:** 100% required (business logic validation)
- **Repositories:** Mock Isar with `isar_test` package
- **UI widgets:** Test user interactions, not implementation

### Test File Naming

```
lib/features/products/domain/usecases/get_products.dart
test/features/products/domain/usecases/get_products_test.dart
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
