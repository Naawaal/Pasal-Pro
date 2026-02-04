# 🎯 Pasal Pro - Next Steps Guide

**Last Updated:** February 4, 2026  
**Current Phase:** Phase 0 Complete ✅  
**Next Phase:** Phase 1 - Product Management

---

## 🚀 Quick Start for Development

### Running the App

```bash
# Ensure dependencies are installed
flutter pub get

# Run on Windows (primary platform)
flutter run -d windows

# Run on Linux
flutter run -d linux

# Run on macOS
flutter run -d macos
```

### After Making Model Changes

```bash
# Regenerate Isar schemas
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes
dart run build_runner watch
```

### Before Committing

```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Format code
dart format lib test
```

---

## 📋 Phase 1: Product Management Implementation

### 🎯 Goal
Build the product catalog system with CRUD operations, search, and stock management.

### 📝 User Stories to Implement

#### Story 1.1: Quick Product Addition ⭐ Critical
```
As a shop owner,
I want to add products with carton/piece pricing,
So that I can quickly set up my inventory.

Acceptance Criteria:
- [ ] Form has: name, cost/piece, selling/piece, pieces per carton
- [ ] Auto-calculates carton prices
- [ ] Validation: selling > cost price
- [ ] Save completes in < 500ms
- [ ] Product name indexed for search
```

#### Story 1.2: Low Stock Alerts ⭐ High
```
As a shop owner,
I want to see which products are running low,
So that I can reorder before running out.

Acceptance Criteria:
- [ ] Configurable threshold per product
- [ ] Yellow badge on product card
- [ ] Dashboard widget shows count
- [ ] Alert before completing sale if insufficient stock
```

---

## 🏗️ Implementation Plan

### Step 1: Domain Layer (Use `flutter-feature` skill)

Create domain entities and use cases:

```
lib/features/products/
├── domain/
│   ├── entities/
│   │   └── product.dart              # Domain entity (business logic)
│   ├── repositories/
│   │   └── product_repository.dart   # Abstract repository interface
│   └── usecases/
│       ├── add_product.dart          # Use case: Add product
│       ├── get_products.dart         # Use case: Get all products
│       ├── update_product.dart       # Use case: Update product
│       ├── delete_product.dart       # Use case: Delete product
│       ├── search_products.dart      # Use case: Search products
│       └── get_low_stock_products.dart # Use case: Low stock alert
```

**Command to generate:**
```
I need to create the Product feature using Clean Architecture with the following use cases:
- Add product (with validation: selling price > cost price)
- Get all products
- Update product
- Delete product (soft delete with isActive flag)
- Search products by name
- Get low stock products (where stock <= threshold)

Use the existing ProductModel from data/models/product_model.dart
```

### Step 2: Data Layer

Implement repository that uses Isar:

```dart
// lib/features/products/data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  final Isar _isar;
  
  // Implement methods using Isar queries
  // Example: query with .filter(), .sortBy(), .where()
}
```

### Step 3: Presentation Layer (Use `flutter-ui` skill)

Before building UI, research POS interfaces:

**Use `design-intelligence` skill:**
```
Research POS and inventory management apps for design patterns.
Focus on:
- Product list/grid layouts
- Quick-add product forms
- Stock indicators
- Search/filter UI
- Low-stock alerts
```

Then build UI components:

```
lib/features/products/presentation/
├── providers/
│   ├── products_provider.dart        # Riverpod provider for products list
│   └── product_form_provider.dart    # Provider for add/edit form state
├── pages/
│   ├── products_page.dart            # Main products list screen
│   └── product_form_page.dart        # Add/Edit product screen
└── widgets/
    ├── product_card.dart             # Product list item
    ├── product_search_bar.dart       # Search widget
    ├── low_stock_badge.dart          # Warning badge
    └── stock_level_indicator.dart    # Visual stock level
```

---

## 🎨 UI Design Requirements

### Products List Screen

**Layout:**
```
┌─────────────────────────────────────┐
│  [🔍 Search products...]      [+ Add]│
├─────────────────────────────────────┤
│  ┌────────────────────────┐         │
│  │ Wai Wai Noodles    Rs120│  ⚠️ Low │
│  │ 10 pcs | 1 carton      │         │
│  │ Profit: Rs20 (20%)     │         │
│  └────────────────────────┘         │
│  ┌────────────────────────┐         │
│  │ Coca Cola 500ml    Rs45 │         │
│  │ 240 pcs | 20 cartons   │         │
│  │ Profit: Rs10 (28%)     │         │
│  └────────────────────────┘         │
└─────────────────────────────────────┘
```

**Features:**
- Floating Action Button: "+ Add Product"
- Search bar (auto-filter as you type)
- Product cards show:
  - Name & selling price (prominent)
  - Stock (pieces + cartons)
  - Profit margin (color-coded)
  - Low stock badge (yellow)
- Tap card → Edit product
- Long press → Delete confirmation

### Add/Edit Product Form

**Layout:**
```
┌─────────────────────────────────────┐
│  ← Back          [Add Product]      │
├─────────────────────────────────────┤
│  Product Name *                     │
│  ┌─────────────────────────────────┐│
│  │ [Enter product name]            ││
│  └─────────────────────────────────┘│
│                                     │
│  Cost Price (per piece) *          │
│  ┌─────────────────────────────────┐│
│  │ Rs [100.00]                     ││
│  └─────────────────────────────────┘│
│                                     │
│  Selling Price (per piece) *       │
│  ┌─────────────────────────────────┐│
│  │ Rs [120.00]                     ││
│  └─────────────────────────────────┘│
│  💰 Profit: Rs 20 (20% margin)      │
│                                     │
│  Pieces per Carton                 │
│  ┌─────────────────────────────────┐│
│  │ [12]                            ││
│  └─────────────────────────────────┘│
│  📦 Carton price: Rs 1,440          │
│                                     │
│  Current Stock (pieces)            │
│  ┌─────────────────────────────────┐│
│  │ [100]   (8 cartons + 4 pieces) ││
│  └─────────────────────────────────┘│
│                                     │
│  Low Stock Threshold               │
│  ┌─────────────────────────────────┐│
│  │ [10]                            ││
│  └─────────────────────────────────┘│
│                                     │
│  [Cancel]           [Save Product] │
└─────────────────────────────────────┘
```

**Validation Rules:**
- Name: Required, max 100 chars
- Cost price: Required, > 0
- Selling price: Required, must be > cost price
- Pieces per carton: Required, > 0
- Stock: Optional, defaults to 0
- Threshold: Optional, defaults to 10

**Live Calculations:**
- Profit per piece = Selling - Cost
- Profit margin % = (Profit / Cost) × 100
- Carton prices = Price × Pieces per carton
- Stock in cartons = Stock ÷ Pieces per carton

---

## 🧪 Testing Checklist

### Unit Tests (Domain Layer)

```dart
// test/features/products/domain/usecases/add_product_test.dart
test('should add product when validation passes');
test('should fail when selling price <= cost price');
test('should fail when name is empty');
```

### Widget Tests (Presentation Layer)

```dart
// test/features/products/presentation/widgets/product_card_test.dart
test('should display product name and price');
test('should show low stock badge when stock <= threshold');
test('should display profit with correct color');
```

### Integration Tests

```dart
// integration_test/product_flow_test.dart
test('complete product CRUD flow');
test('search products by name');
test('low stock alert workflow');
```

---

## 📊 Performance Targets

| Operation | Target | Validation Method |
|-----------|--------|-------------------|
| Load 100 products | < 100ms | DevTools Timeline |
| Search/filter | < 50ms | DevTools Timeline |
| Add product | < 500ms | Stopwatch in test |
| Database query | < 50ms | Isar Performance Metrics |

---

## 🎯 Definition of Done (Phase 1)

Before moving to Phase 2, ensure:

- [ ] All 6 use cases implemented and tested
- [ ] Repository with Isar integration working
- [ ] Products list UI complete with search
- [ ] Add/Edit product form with validation
- [ ] Low stock alerts functional
- [ ] Unit tests: ≥ 80% coverage for domain layer
- [ ] Widget tests: All major components tested
- [ ] Integration test: Full CRUD flow passes
- [ ] Performance targets met (< 100ms load)
- [ ] Code reviewed against `flutter-guideline`
- [ ] No analysis warnings (`flutter analyze` clean)
- [ ] Documentation updated (README, inline comments)

---

## 🔄 Typical Development Workflow

### For Each Feature:

1. **Plan** (Use `product-manager` skill)
   - Define user story
   - Write acceptance criteria
   - Identify edge cases

2. **Research** (Use `design-intelligence` skill)
   - Find UI/UX inspiration
   - Document design patterns
   - Create rough sketches

3. **Implement Domain Logic** (Use `flutter-feature` skill)
   - Write entity classes
   - Create use cases
   - Define repository interface
   - Write unit tests

4. **Implement Data Layer**
   - Create repository implementation
   - Write Isar queries
   - Test database operations

5. **Build UI** (Use `flutter-ui` skill)
   - Create Riverpod providers
   - Build page layouts
   - Create reusable widgets
   - Write widget tests

6. **Integrate & Test**
   - Connect UI to domain logic
   - Run integration tests
   - Profile performance
   - Fix issues

7. **Review & Refine** (Use `flutter-guideline` skill)
   - Check file sizes (< 300 lines)
   - Validate naming conventions
   - Ensure SOLID principles
   - Run `flutter analyze`

8. **Document**
   - Update README if needed
   - Add inline comments
   - Update PRD if scope changed

---

## 🛠️ Useful Commands

### Code Generation
```bash
# Watch for changes (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# One-time generation
dart run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# All tests
flutter test

# Specific file
flutter test test/features/products/domain/usecases/add_product_test.dart

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Performance Profiling
```bash
# Run with DevTools
flutter run --profile -d windows
# Open DevTools in browser when prompted
```

### Database Inspection
```bash
# Isar Inspector runs automatically when app is running in debug mode
# Open: http://localhost:8080
```

---

## 🤝 Getting Help

### When Stuck on Architecture:
```
Use flutter-feature skill to generate Clean Architecture boilerplate
Example: "Create the Product feature with these use cases: [list]"
```

### When Stuck on UI:
```
Use design-intelligence skill to research patterns
Example: "Find product management UI patterns for POS apps"

Then use flutter-ui skill to implement
Example: "Build a product card widget with stock indicator"
```

### When Stuck on Business Logic:
```
Use product-manager skill to clarify requirements
Example: "What should happen when user tries to sell more than stock?"
```

---

## 🎉 You're Ready!

Phase 0 is complete. The foundation is solid. Time to build features!

**Next command to run:**
```
"Let's implement Phase 1: Product Management. Start with the domain layer using Clean Architecture."
```

---

**Happy Coding! 🚀**
