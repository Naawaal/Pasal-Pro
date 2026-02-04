---
name: flutter-refactor
description: Systematically refactors Flutter codebases to meet quality standards, fix anti-patterns, and modernize architecture. Use when asked to "refactor code", "clean up codebase", "improve code quality", or "fix technical debt". Works in coordination with flutter-guideline for standards and flutter-feature for architecture patterns.
---

# 🔧 Flutter Codebase Refactoring Skill

Systematically refactors Flutter code to **production-grade standards** while preserving functionality.

---

## 🎯 When to Use

Invoke when user requests:

- **"Refactor this code"**
- **"Clean up the codebase"**
- **"Improve code quality"**
- **"Fix technical debt"**
- **"Modernize this Flutter code"**
- **"Apply clean architecture"**
- **"Fix SOLID violations"**

---

## 🔗 Skill Coordination

This skill **works in coordination** with:

### 1. flutter-guideline

**Purpose:** Provides quality standards and rules
**Integration:**

- Check file size limits (300 lines max)
- Validate naming conventions
- Enforce SOLID principles
- Verify performance patterns (const, ListView.builder)

**When to reference:**

```
BEFORE refactoring → Check flutter-guideline for standards
DURING refactoring → Apply flutter-guideline rules
AFTER refactoring → Validate against flutter-guideline checklist
```

### 2. flutter-feature

**Purpose:** Provides Clean Architecture patterns
**Integration:**

- Apply proper layer separation (Domain, Data, Presentation)
- Use repository pattern
- Implement use cases
- Structure state management (BLoC/Riverpod)

**When to reference:**

```
IF refactoring involves business logic → Use flutter-feature patterns
IF adding new features during refactor → Follow flutter-feature structure
IF restructuring to Clean Architecture → Apply flutter-feature templates
```

---

## 📋 Refactoring Process (6-Phase Approach)

### Phase 0: Analysis & Assessment

**Step 1: Codebase Audit**

```yaml
Scan for violations:
  File Size Issues:
    - Files >300 lines
    - Functions >50 lines
    - Build methods >30 lines

  SOLID Violations:
    - God classes (multiple responsibilities)
    - Tight coupling (concrete dependencies)
    - Fat interfaces

  Anti-Patterns:
    - Magic numbers/strings
    - Primitive obsession
    - Code duplication (DRY violations)

  Performance Issues:
    - Missing const
    - ListView instead of ListView.builder
    - Unnecessary rebuilds

  Architecture Issues:
    - Business logic in UI
    - No layer separation
    - Mixed concerns
```

**Step 2: Generate Refactoring Report**

```markdown
# Refactoring Assessment Report

## Critical Issues (Fix Immediately)

- [ ] `user_service.dart` - 850 lines (VIOLATES 300-line limit)
- [ ] `product_page.dart` - God class with 15 responsibilities
- [ ] `auth_service.dart` - Concrete database dependency (DIP violation)

## High Priority (Fix This Sprint)

- [ ] 12 files missing const constructors
- [ ] 8 widgets using ListView instead of ListView.builder
- [ ] Business logic in 6 presentation files

## Medium Priority (Fix Next Sprint)

- [ ] Magic numbers in 15 files
- [ ] Inconsistent naming (snake_case violations)
- [ ] Missing documentation on 20 public APIs

## Low Priority (Technical Debt)

- [ ] Outdated dependencies
- [ ] Missing unit tests for 30% of features
- [ ] No integration tests

**Estimated Effort:** 3-5 days
**Risk Level:** Medium (requires testing)
```

---

### Phase 1: File Size Refactoring

**Goal:** Break down large files to <300 lines

**Strategy:**

```yaml
For Files >300 Lines: 1. Identify logical sections
  2. Extract to separate files
  3. Maintain single responsibility
  4. Update imports

Extraction Patterns:
  - Widgets → widgets/ folder
  - Models → models/ folder
  - Services → services/ folder
  - Utils → utils/ folder
```

**Example:**

```dart
// BEFORE: user_service.dart (850 lines)
class UserService {
  // Authentication (200 lines)
  Future<User> login() { }
  Future<void> logout() { }

  // Profile Management (300 lines)
  Future<void> updateProfile() { }
  Future<void> uploadAvatar() { }

  // Settings (200 lines)
  Future<void> updateSettings() { }

  // Notifications (150 lines)
  Future<void> sendNotification() { }
}

// AFTER: Split into focused services
// lib/features/auth/
//   ├── services/
//   │   ├── auth_service.dart (180 lines)
//   │   ├── profile_service.dart (220 lines)
//   │   ├── settings_service.dart (150 lines)
//   │   └── notification_service.dart (120 lines)

// auth_service.dart - Single Responsibility ✅
class AuthService {
  Future<User> login(String email, String password) { }
  Future<void> logout() { }
  Future<void> refreshToken() { }
}
```

**Reference flutter-guideline:**

```
✅ Each file <300 lines
✅ Single Responsibility Principle applied
✅ Clear naming conventions
```

---

### Phase 2: SOLID Principles Application

**Goal:** Fix SOLID violations using flutter-guideline standards

#### 2.1 Single Responsibility Violations

```dart
// ❌ BEFORE: Multiple responsibilities
class ProductManager {
  void addProduct(Product p) { }
  void saveToDatabase(Product p) { }
  void sendToAPI(Product p) { }
  bool validateProduct(Product p) { }
}

// ✅ AFTER: Separated responsibilities
// Domain layer
class Product {
  final String id;
  final String name;
  // ... entity only
}

// Use cases
class AddProduct {
  final ProductRepository repository;
  Future<Either<Failure, Product>> call(Product product) { }
}

// Repository (follows flutter-feature pattern)
abstract class ProductRepository {
  Future<Either<Failure, void>> save(Product product);
}

// Validator
class ProductValidator {
  bool validate(Product product) { }
}
```

**Reference:**

- flutter-guideline: SOLID Principles section
- flutter-feature: Repository pattern implementation

#### 2.2 Dependency Inversion Violations

```dart
// ❌ BEFORE: Tight coupling
class OrderService {
  final DriftDatabase database; // Concrete dependency

  Future<List<Order>> getOrders() {
    return database.select(database.orders).get();
  }
}

// ✅ AFTER: Abstraction (flutter-feature pattern)
// Domain layer (flutter-feature: domain/repositories/)
abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders();
}

// Service depends on abstraction
class OrderService {
  final OrderRepository repository; // Abstract dependency

  Future<Either<Failure, List<Order>>> getOrders() {
    return repository.getOrders();
  }
}

// Data layer (flutter-feature: data/repositories/)
class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;
  final OrderRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    // Implementation with offline-first pattern
  }
}
```

**Reference:**

- flutter-guideline: Dependency Inversion Principle
- flutter-feature: Clean Architecture structure

---

### Phase 3: Architecture Modernization

**Goal:** Apply Clean Architecture (flutter-feature patterns)

**Strategy: Incremental Migration**

```yaml
Step 1: Identify Feature Boundaries
  - User Management
  - Product Catalog
  - Shopping Cart
  - Orders

Step 2: Create Clean Architecture Structure
  lib/features/[feature]/
  ├── data/
  ├── domain/
  └── presentation/

Step 3: Move Code Layer by Layer
  1. Extract entities (Domain)
  2. Define repository interfaces (Domain)
  3. Implement repositories (Data)
  4. Create use cases (Domain)
  5. Refactor UI (Presentation)
```

**Example Migration:**

```dart
// BEFORE: Messy structure
lib/
  ├── screens/
  │   └── product_list_screen.dart  // UI + Logic + Data
  ├── models/
  │   └── product.dart
  └── services/
      └── product_service.dart

// AFTER: Clean Architecture (flutter-feature structure)
lib/features/product/
  ├── domain/
  │   ├── entities/
  │   │   └── product.dart           // Pure business object
  │   ├── repositories/
  │   │   └── product_repository.dart // Interface
  │   └── usecases/
  │       ├── get_products.dart
  │       └── create_product.dart
  ├── data/
  │   ├── models/
  │   │   └── product_model.dart     // JSON serialization
  │   ├── datasources/
  │   │   ├── product_local_datasource.dart
  │   │   └── product_remote_datasource.dart
  │   └── repositories/
  │       └── product_repository_impl.dart
  └── presentation/
      ├── bloc/
      │   ├── product_bloc.dart
      │   ├── product_event.dart
      │   └── product_state.dart
      ├── pages/
      │   └── product_list_page.dart  // UI only
      └── widgets/
          └── product_card.dart
```

**Reference flutter-feature for:**

- Folder structure
- Entity vs Model patterns
- Repository implementation
- BLoC/State management setup

---

### Phase 4: Code Quality Improvements

**Goal:** Fix anti-patterns and apply flutter-guideline standards

#### 4.1 Extract Constants

```dart
// ❌ BEFORE: Magic numbers
Widget build(BuildContext context) {
  return Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      'Hello',
      style: TextStyle(fontSize: 16),
    ),
  );
}

// ✅ AFTER: Named constants (flutter-guideline compliant)
class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
}

Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(AppSpacing.medium),
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppBorderRadius.small),
    ),
    child: Text(
      'Hello',
      style: Theme.of(context).textTheme.bodyLarge, // Use theme
    ),
  );
}
```

#### 4.2 Apply Const Optimization

```dart
// ❌ BEFORE: Missing const
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Title'),
      SizedBox(height: 16),
      Icon(Icons.home),
    ],
  );
}

// ✅ AFTER: Const everywhere (flutter-guideline performance)
Widget build(BuildContext context) {
  return Column(
    children: const [
      Text('Title'),
      SizedBox(height: 16),
      Icon(Icons.home),
    ],
  );
}
```

#### 4.3 Fix ListView Performance

```dart
// ❌ BEFORE: Bad performance
ListView(
  children: products.map((p) => ProductCard(product: p)).toList(),
)

// ✅ AFTER: Lazy loading (flutter-guideline compliant)
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)
```

**Reference flutter-guideline:**

- Performance Guidelines section
- Common Anti-Patterns section

---

### Phase 5: Widget Extraction & Composition

**Goal:** Break down complex widgets to <30 line build methods

**Strategy:**

```yaml
Extraction Rules (flutter-guideline):
  - Build method >30 lines → Extract
  - Repeated UI patterns → Reusable widget
  - Complex logic → Separate widget with state
  - Used in multiple places → widgets/ folder

Widget Types:
  - Private widgets: _ProductListItem (same file)
  - Reusable widgets: ProductCard (widgets/ folder)
  - Feature widgets: ProductDetailCard (feature/widgets/)
```

**Example:**

```dart
// ❌ BEFORE: 80-line build method
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Products'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _showSearch(),
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(value: 'sort', child: Text('Sort')),
            PopupMenuItem(value: 'filter', child: Text('Filter')),
          ],
        ),
      ],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No products yet'),
                    SizedBox(height: 8),
                    Text('Add your first product to get started'),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(/* ... */),
                      title: Text(product.name),
                      subtitle: Column(/* ... */),
                      trailing: IconButton(/* ... */),
                    ),
                  );
                },
              ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _addProduct(),
      child: Icon(Icons.add),
    ),
  );
}

// ✅ AFTER: Clean 25-line build (flutter-guideline compliant)
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    floatingActionButton: _buildFAB(),
  );
}

AppBar _buildAppBar() {
  return AppBar(
    title: const Text('Products'),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _showSearch,
      ),
      _buildMenuButton(),
    ],
  );
}

Widget _buildBody() {
  if (isLoading) return const Center(child: CircularProgressIndicator());
  if (products.isEmpty) return _buildEmptyState();
  return _buildProductList();
}

Widget _buildEmptyState() {
  return Center(
    child: EmptyStateWidget(
      icon: Icons.inbox,
      title: 'No products yet',
      message: 'Add your first product to get started',
    ),
  );
}

Widget _buildProductList() {
  return ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) => ProductListItem(
      product: products[index],
      onTap: () => _onProductTap(products[index]),
      onDelete: () => _onProductDelete(products[index]),
    ),
  );
}

Widget _buildFAB() {
  return FloatingActionButton(
    onPressed: _addProduct,
    child: const Icon(Icons.add),
  );
}

Widget _buildMenuButton() {
  return PopupMenuButton(
    itemBuilder: (context) => const [
      PopupMenuItem(value: 'sort', child: Text('Sort')),
      PopupMenuItem(value: 'filter', child: Text('Filter')),
    ],
    onSelected: _handleMenuAction,
  );
}
```

**Extracted Reusable Widgets:**

```dart
// lib/features/product/presentation/widgets/product_list_item.dart
class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _buildAvatar(),
        title: Text(product.name),
        subtitle: _buildSubtitle(context),
        trailing: _buildDeleteButton(),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAvatar() { /* ... */ }
  Widget _buildSubtitle(BuildContext context) { /* ... */ }
  Widget _buildDeleteButton() { /* ... */ }
}

// lib/core/widgets/empty_state_widget.dart (reusable across features)
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
```

**Reference flutter-guideline:**

- Widget Extraction section
- Build method size limits

---

### Phase 6: Testing & Validation

**Goal:** Ensure refactored code works correctly

**Testing Checklist:**

```yaml
Unit Tests:
  - [ ] All business logic covered (domain layer)
  - [ ] Repository implementations tested
  - [ ] Use cases tested with mock dependencies
  - [ ] Edge cases handled

Widget Tests:
  - [ ] Critical user flows work
  - [ ] State transitions correct
  - [ ] Error states display properly

Integration Tests:
  - [ ] Feature works end-to-end
  - [ ] Data flows correctly through layers

Manual Testing:
  - [ ] UI looks correct
  - [ ] No regressions
  - [ ] Performance improved
```

**Example Test Structure:**

```dart
// test/features/product/domain/usecases/get_products_test.dart
void main() {
  group('GetProducts', () {
    late GetProducts useCase;
    late MockProductRepository mockRepository;

    setUp(() {
      mockRepository = MockProductRepository();
      useCase = GetProducts(mockRepository);
    });

    test('should return products from repository', () async {
      // Arrange
      final products = [Product(id: '1', name: 'Test')];
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Right(products));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, equals(Right(products)));
      verify(() => mockRepository.getProducts()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
```

**Reference flutter-guideline:**

- Testing Guidelines section
- AAA Pattern (Arrange, Act, Assert)

---

## 🔄 Refactoring Workflow (Step-by-Step)

### Workflow for Complete Codebase Refactor

```markdown
1. **Analysis Phase** (1 day)
   - Run codebase audit
   - Generate refactoring report
   - Prioritize violations
   - Estimate effort

2. **Quick Wins** (1-2 days)
   - Add missing const
   - Fix ListView → ListView.builder
   - Extract magic numbers
   - Apply consistent naming

3. **SOLID Fixes** (2-3 days)
   - Break down god classes
   - Apply dependency inversion
   - Separate responsibilities
   - Create abstractions

4. **Architecture Migration** (3-5 days)
   - Set up Clean Architecture structure
   - Migrate feature by feature
   - Apply flutter-feature patterns
   - Move business logic to domain

5. **Widget Refactoring** (2-3 days)
   - Extract large build methods
   - Create reusable widgets
   - Apply composition patterns
   - Optimize performance

6. **Testing & Validation** (2-3 days)
   - Write unit tests
   - Add widget tests
   - Manual QA
   - Performance testing

**Total Estimated Time:** 11-17 days (2-3 weeks)
```

---

## ✅ Refactoring Checklist

Use this checklist to validate refactoring completion:

```yaml
File Size (flutter-guideline):
  - [ ] No file >300 lines
  - [ ] No function >50 lines
  - [ ] Build methods <30 lines

SOLID Principles (flutter-guideline):
  - [ ] Single Responsibility applied
  - [ ] Dependencies use abstractions
  - [ ] No fat interfaces
  - [ ] Open/Closed principle followed

Architecture (flutter-feature):
  - [ ] Clean Architecture structure
  - [ ] Layer separation (Domain/Data/Presentation)
  - [ ] Repository pattern implemented
  - [ ] Use cases for business logic

Code Quality (flutter-guideline):
  - [ ] Const used everywhere possible
  - [ ] ListView.builder for lists
  - [ ] No magic numbers/strings
  - [ ] Consistent naming conventions
  - [ ] Proper class member order

Performance:
  - [ ] No unnecessary rebuilds
  - [ ] Images cached
  - [ ] Lazy loading implemented
  - [ ] Build methods optimized

Testing:
  - [ ] Unit tests for domain layer
  - [ ] Widget tests for UI
  - [ ] All tests passing
  - [ ] No regressions

Documentation:
  - [ ] Public APIs documented
  - [ ] Complex logic explained
  - [ ] Migration guide written
```

---

## 🎯 Skill Coordination Examples

### Example 1: Refactoring with All Skills

**User Request:** "Refactor the product management feature"

**Response Process:**

```markdown
Step 1: Analyze Against flutter-guideline
✅ Check file sizes
✅ Identify SOLID violations
✅ Find anti-patterns

Step 2: Apply flutter-feature Structure
✅ Create Clean Architecture folders
✅ Separate layers (Domain/Data/Presentation)
✅ Implement repository pattern

Step 3: Refactor Using flutter-refactor Process
✅ Break down large files (Phase 1)
✅ Fix SOLID violations (Phase 2)
✅ Migrate to Clean Architecture (Phase 3)
✅ Extract widgets (Phase 5)

Step 4: Validate Against flutter-guideline
✅ Run checklist
✅ Verify all standards met
✅ Ensure tests pass
```

### Example 2: Quick Refactor (Anti-Patterns Only)

**User Request:** "Quick cleanup of this file"

**Response Process:**

```markdown
Step 1: Check flutter-guideline Standards

- File size: OK (180 lines)
- Missing const: 8 locations
- Magic numbers: 5 locations
- ListView issue: 1 location

Step 2: Apply Quick Fixes
✅ Add const to all widgets
✅ Extract magic numbers to constants
✅ Change ListView to ListView.builder

Step 3: Validate
✅ Verify flutter-guideline checklist
✅ No architecture changes needed
```

---

## 🚀 Best Practices

### 1. Incremental Refactoring

```yaml
DO:
  - Refactor one feature at a time
  - Test after each change
  - Commit frequently
  - Keep app running during refactor

DON'T:
  - Refactor entire codebase at once
  - Change architecture + fix bugs simultaneously
  - Skip testing
  - Break functionality
```

### 2. Backward Compatibility

```yaml
Strategy:
  - Keep old code working during migration
  - Use feature flags if needed
  - Deprecate gradually
  - Update consumers incrementally

Example: // Old (deprecated but working)
  @deprecated
  class OldProductService { }

  // New (recommended)
  class ProductRepository implements IProductRepository { }
```

### 3. Communication

```yaml
Always Document:
  - What was changed
  - Why it was changed
  - How to use new code
  - Migration path for team

Create:
  - Refactoring report (before)
  - Migration guide (during)
  - Validation report (after)
```

---

## 📚 Quick Reference

### When to Use Each Skill

| Scenario                      | Primary Skill     | Supporting Skills                  |
| ----------------------------- | ----------------- | ---------------------------------- |
| Check code quality            | flutter-guideline | -                                  |
| Fix file size violations      | flutter-refactor  | flutter-guideline                  |
| Apply SOLID principles        | flutter-refactor  | flutter-guideline                  |
| Migrate to Clean Architecture | flutter-refactor  | flutter-feature, flutter-guideline |
| Create new feature            | flutter-feature   | flutter-guideline                  |
| Extract widgets               | flutter-refactor  | flutter-guideline                  |
| Performance optimization      | flutter-refactor  | flutter-guideline                  |

### Refactoring Priority Matrix

```yaml
High Priority (Do First):
  - SOLID violations
  - Files >300 lines
  - Business logic in UI
  - Security issues

Medium Priority:
  - Missing const
  - ListView performance
  - Magic numbers
  - Widget extraction

Low Priority (Technical Debt):
  - Naming inconsistencies
  - Documentation
  - Minor duplications
```

---

## 💡 Summary

This refactoring skill provides:

1. **Systematic Approach** - 6-phase process for complete refactoring
2. **Skill Coordination** - Works with flutter-guideline and flutter-feature
3. **Quality Standards** - Enforces production-grade code
4. **Practical Examples** - Before/after code samples
5. **Validation Checklists** - Ensures refactoring completeness

**Philosophy:** Refactor incrementally, test continuously, validate rigorously.

**Remember:** Always reference flutter-guideline for standards and flutter-feature for architecture patterns!

## 💡 Summary

This refactoring skill provides:

1. **Systematic Approach** - 6-phase process for complete refactoring
2. **Skill Coordination** - Works with flutter-guideline and flutter-feature
3. **Quality Standards** - Enforces production-grade code
4. **Practical Examples** - Before/after code samples
5. **Validation Checklists** - Ensures refactoring completeness

**Philosophy:** Refactor incrementally, test continuously, validate rigorously.

**Remember:** Always reference flutter-guideline for standards and flutter-feature for architecture patterns!
