# Development Guide

**Status:** Phase 7 - Documentation  
**Last Updated:** February 5, 2026

---

## 🚀 Quick Start

### Prerequisites

- **Flutter:** 3.10+ (with Dart 3.0+)
- **IDE:** VS Code with Flutter extension (or Android Studio)
- **Git:** Latest version
- **Platform:** Windows, Linux, or macOS
- **RAM:** 8GB+ recommended

### Initial Setup (5 minutes)

```bash
# 1. Clone repository
git clone https://github.com/YourOrg/pasal-pro.git
cd pasal-pro

# 2. Get dependencies
flutter pub get

# 3. Generate code (Isar models, freezed, etc.)
dart run build_runner build --delete-conflicting-outputs

# 4. Build and run
flutter run -d windows   # or 'linux' or 'macos'

# 5. Verify in terminal
flutter analyze          # Should show 0 issues
flutter test             # Should show 83 passing tests
```

---

## 📁 Project Structure Navigation

### Quick Reference

```
lib/
├── main.dart                    # App entry + Desktop shell
├── core/
│   ├── database/               # Isar database singleton
│   ├── errors/                 # Failure type hierarchy
│   ├── utils/                  # Helpers (formatters, converters)
│   ├── constants/              # AppSpacing, AppIcons, AppColors
│   └── theme/                  # Material 3 + Mix tokens
└── features/
    ├── products/               # Product CRUD + inventory
    ├── sales/                  # Fast sales entry + cart
    ├── customers/              # Customer ledger + credit
    ├── dashboard/              # Real-time metrics + activity
    ├── cheques/                # Payment tracking
    └── settings/               # App configuration
```

### Finding Code Quickly

| Task                             | Location                                         | Search Hint                           |
| -------------------------------- | ------------------------------------------------ | ------------------------------------- |
| **Add product input field**      | `lib/features/products/presentation/widgets/`    | `product_form_field.dart`             |
| **Customer balance calculation** | `lib/features/customers/domain/entities/`        | `customer.dart`                       |
| **Sales database query**         | `lib/features/sales/data/datasources/`           | `sale_local_datasource.dart`          |
| **Dashboard statistics**         | `lib/features/dashboard/presentation/providers/` | `dashboard_providers.dart`            |
| **Global colors/spacing**        | `lib/core/constants/`                            | `app_colors.dart`, `app_spacing.dart` |
| **Error handling**               | `lib/core/errors/`                               | `failures.dart`                       |

---

## 💻 Development Workflow

### Before Starting Work

```bash
# 1. Update dependencies
flutter pub get

# 2. Generate code (if you added async tools)
dart run build_runner build --delete-conflicting-outputs

# 3. Switch to latest branch
git checkout main
git pull origin main

# 4. Create feature branch
git checkout -b feature/short-description
```

### During Development

```bash
# Watch mode - auto-recompiles on save
flutter run -d windows --watch

# In another terminal: Watch code generation
dart run build_runner watch

# In third terminal: Run tests as you code
flutter test --watch test/features/your_feature/

# Check for warnings/errors (can run anytime)
flutter analyze

# Hot reload (Cmd+S in IDE or 'r' in terminal)
# Hot restart if state breaks ('R' in terminal)
```

### Before Committing

```bash
# Step 1: Verify no analysis issues
flutter analyze  # Must show 0 issues

# Step 2: Format code
dart format lib test

# Step 3: Run tests
flutter test     # Must show all passing

# Step 4: Check git diff
git diff lib/

# Step 5: Stage and commit
git add lib/
git commit -m "feat: describe what changed"

# Step 6: Push to branch
git push -u origin feature/short-description
```

---

## 🔧 Common Development Tasks

### Adding a New Feature

**Use the flutter-feature skill for full scaffolding:**

```bash
# This creates complete Clean Architecture structure:
# - domain/entities/, repositories/, usecases/
# - data/models/, datasources/, repositories/
# - presentation/providers/, pages/, widgets/
```

**Minimal steps:**

1. **Create feature folder structure**

```bash
mkdir -p lib/features/myfeature/{domain,data,presentation}
mkdir -p lib/features/myfeature/domain/{entities,repositories,usecases}
mkdir -p lib/features/myfeature/data/{models,datasources,repositories}
mkdir -p lib/features/myfeature/presentation/{providers,pages,widgets}
```

2. **Start with domain entity**

```dart
// lib/features/myfeature/domain/entities/myentity.dart
@immutable
class MyEntity extends Equatable {
  final int id;
  final String name;

  const MyEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
```

3. **Create Isar model with index**

```dart
// lib/features/myfeature/data/models/myentity_model.dart
@Collection()
class MyEntityModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  // Convert to entity
  MyEntity toEntity() => MyEntity(id: id.toInt(), name: name);

  // Convert from entity
  static MyEntityModel fromEntity(MyEntity entity) => MyEntityModel()
    ..id = entity.id == null ? Isar.autoIncrement : entity.id!
    ..name = entity.name;
}
```

4. **Define repository interface**

```dart
// lib/features/myfeature/domain/repositories/myentity_repository.dart
abstract class MyEntityRepository {
  Future<Result<List<MyEntity>>> getAll();
  Future<Result<MyEntity>> getById(int id);
  Future<Result<void>> add(MyEntity entity);
}
```

5. **Implement repository**

```dart
// lib/features/myfeature/data/repositories/myentity_repository_impl.dart
class MyEntityRepositoryImpl implements MyEntityRepository {
  final Isar _isar;

  @override
  Future<Result<List<MyEntity>>> getAll() async {
    try {
      final models = await _isar.myEntityModels.where().findAll();
      return Success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
```

6. **Create providers**

```dart
// lib/features/myfeature/presentation/providers/myentity_providers.dart
final myEntitiesProvider = FutureProvider<List<MyEntity>>((ref) async {
  final repository = ref.watch(myEntityRepositoryProvider);
  final result = await repository.getAll();
  return result.when(
    data: (entities) => entities,
    error: (failure) => throw failure,
  );
});
```

7. **Build UI**

```dart
// lib/features/myfeature/presentation/pages/myentity_page.dart
class MyEntityPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyEntityPage> createState() => _MyEntityPageState();
}

class _MyEntityPageState extends ConsumerState<MyEntityPage> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entities = ref.watch(myEntitiesProvider);
    return entities.when(
      data: (items) => ListView(children: items.map(...).toList()),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }
}
```

8. **Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Modifying Database Schema

```bash
# 1. Update model (@Collection class)
# lib/features/products/data/models/product_model.dart

# 2. Run code generation
dart run build_runner build --delete-conflicting-outputs

# 3. Rebuild app
flutter run

# Note: Isar handles migrations automatically for desktop
```

### Adding a New Riverpod Provider

```dart
// Simple FutureProvider (read-only data)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final result = await repo.getAll();
  return result.when(
    data: (products) => products,
    error: (failure) => throw failure,
  );
});

// StateNotifierProvider (mutable state)
final selectedProductProvider =
    StateNotifierProvider<SelectedProductNotifier, Product?>((ref) {
  return SelectedProductNotifier();
});

// Family (parameterized)
final productByIdProvider =
    FutureProvider.family<Product, int>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  final result = await repo.getById(id);
  return result.when(
    data: (product) => product,
    error: (failure) => throw failure,
  );
});

// Cache invalidation (refresh data)
ref.invalidate(productsProvider);
```

### Creating Unit Tests

```dart
// test/features/myfeature/domain/entities/myentity_test.dart

void main() {
  group('MyEntity', () {
    final testEntity = MyEntity(id: 1, name: 'Test');

    test('should have correct properties', () {
      expect(testEntity.id, 1);
      expect(testEntity.name, 'Test');
    });

    test('should implement equality correctly', () {
      final same = MyEntity(id: 1, name: 'Test');
      expect(testEntity, same);
    });

    test('copyWith should create new instance', () {
      final updated = testEntity.copyWith(name: 'Updated');
      expect(updated.name, 'Updated');
      expect(testEntity.name, 'Test');  // Original unchanged
    });
  });
}
```

---

## 🐛 Debugging Tips

### Check Code Quality

```bash
# See all analysis warnings
flutter analyze

# Format before commit
dart format lib test

# Run specific test with output
flutter test -v test/features/products/domain/entities/product_test.dart
```

### Debug in IDE

**VS Code:**

1. Set breakpoint (click line number)
2. Press F5 or Run → Start Debugging
3. Use Debug Console for expressions
4. Step over (F10), step into (F11), continue (F5)

**DevTools (browser-based):**

```bash
flutter run --devtools
# Opens at http://localhost:port/devtools
```

### Hot Reload Issues

```bash
# If hot reload fails, hot restart
# In terminal: Press 'R' instead of 'r'

# If still broken, full rebuild
# Stop app (Ctrl+C)
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Database Issues

```bash
# Clear Isar database (development only)
# This is automatic on app reinstall
flutter clean

# Check current database
# In terminal during app run: Isar Inspector will show schema

# View database content
# Open Isar Studio (when available)
```

### Memory Leaks

```bash
# Check for unreleased resources in DevTools
# Look for growing memory usage over time

# Ensure proper disposal:
@override
void dispose() {
  _controller.dispose();
  _subscription?.cancel();
  super.dispose();
}
```

---

## 📝 Code Quality Checklist

### Before Each Commit

- [ ] `flutter analyze` returns 0 issues
- [ ] `flutter test` returns all passing
- [ ] `dart format` applied to files
- [ ] Comments explain WHY, not what
- [ ] No hardcoded values (use constants)
- [ ] No `print()` statements
- [ ] Widget files < 250 lines
- [ ] Functions < 50 lines
- [ ] No magic numbers for spacing (use AppSpacing)

### File Size Limits (Enforced)

```
Maximum:
  - Widget files: 250 lines
  - Other Dart:   300 lines
  - Functions:     50 lines
  - build() methods: 30 lines

Reason: Maintainability, readability, testability
```

### Naming Convention Checklist

```dart
// ✅ Files: snake_case
product_card_widget.dart

// ✅ Classes: PascalCase
class ProductCard extends StatelessWidget {}

// ✅ Vars/Functions: camelCase
final productPrice = 100;
void addProduct() {}

// ✅ Constants: camelCase with leading underscore (private)
const _defaultPadding = 16.0;

// ✅ Booleans: is/has prefix
bool isActive;
bool hasLowStock;

// ✅ Collections: plural
List<Product> products;

// ✅ Private members: underscore prefix
final _controller = TextEditingController();
```

---

## 🔄 Git Workflow

### Creating a PR

```bash
# 1. Create feature branch
git checkout -b feature/short-name

# 2. Make changes and commit
git add lib/
git commit -m "feat: add feature description"

# 3. Keep branch updated
git pull origin main

# 4. Push branch
git push -u origin feature/short-name

# 5. Create PR in GitHub UI
# Compare feature/short-name to main
# Add description of changes
# Request reviewers
```

### Commit Message Format

```
feat: add product search functionality
^--^  ^----^
|     |
|     +-> Description (imperative, lowercase)
+-------> Type: feat, fix, docs, refactor, test, chore
```

**Types:**

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `refactor:` Code restructuring
- `test:` Test additions/changes
- `chore:` Dependencies, build config

---

## 📚 Architecture Quick Reference

### 3-Layer Clean Architecture

```
DOMAIN (Pure Dart - No Framework Dependencies)
├─ entities/         Business models (no getters, just data)
├─ repositories/     Abstract interfaces
└─ usecases/         Single responsibility operations

DATA (Framework Aware - Isar, HTTP, etc.)
├─ models/           @Collection() Isar models
├─ datasources/      Raw database queries
└─ repositories/     Concrete implementations

PRESENTATION (UI - Riverpod + Flutter)
├─ providers/        Riverpod state management
├─ pages/            Full screens (ConsumerStatefulWidget)
└─ widgets/          Reusable components (ConsumerWidget)
```

### Provider Patterns

```dart
// Read-only data (FutureProvider)
ref.watch(productsProvider)

// Mutable state (StateNotifierProvider)
ref.read(cartProvider.notifier).addItem(product)
ref.watch(cartProvider)

// Parameterized (family)
ref.watch(productByIdProvider(42))

// Invalidate cache (refresh)
ref.invalidate(productsProvider)
```

### Error Handling (Result Type)

```dart
// Success path
final result = Success<List<Product>>([...]);
result.when(
  data: (products) => print(products),
);

// Error path
final result = Error<List<Product>>(DatabaseFailure('connection'));
result.when(
  error: (failure) => print(failure.message),
);
```

---

## 🔗 Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - System design details
- [TESTING.md](TESTING.md) - Testing strategy and examples
- [README.md](../README.md) - Project overview

---

## Common Questions

**Q: Where do I add a new database model?**  
A: `lib/features/<feature>/data/models/<model>_model.dart` with `@Collection()` annotation, then run `dart run build_runner build`

**Q: How do I fetch data in a widget?**  
A: Use `ref.watch(provider)` in ConsumerWidget/ConsumerStatefulWidget build method

**Q: Can I use setState()?**  
A: No - use Riverpod providers instead for state management

**Q: How do I handle errors?**  
A: Return `Result<T>` (Success | Error) from repositories, use `.when()` to handle both cases

**Q: How do I add spacing between widgets?**  
A: Use `AppSpacing.medium` instead of hardcoded SizedBox values

**Q: How do I test async code?**  
A: Mark test method as `async` and use `await`: `test('name', () async { ... })`

---

## Summary

✅ **Setup:** 5 minutes to first run  
✅ **Workflow:** Edit → Hot reload → Test → Commit  
✅ **Testing:** `flutter test --watch` during development  
✅ **Quality:** Check before commit with `flutter analyze` + `dart format`

**Next:** See [TESTING.md](TESTING.md) for testing strategies or [DEPLOYMENT.md](DEPLOYMENT.md) for release procedures.
