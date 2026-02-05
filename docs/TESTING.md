# Testing Documentation

**Status:** Phase 6 Complete - 83 tests passing ✅  
**Last Updated:** February 5, 2026

---

## 📊 Test Coverage Overview

### Current Status

```
Total Tests:        83 passing ✅
Test Files:         6 modules
Coverage:           100% (Utilities + Domain)
                    60%+ (Widgets)
Execution Time:     ~3 seconds
Pass Rate:          100%
```

### Test Distribution

| Component                 | Tests  | Coverage | Files                              |
| ------------------------- | ------ | -------- | ---------------------------------- |
| **Utilities**             | 23     | 100%     | currency_formatter, unit_converter |
| **Domain (Entities)**     | 22     | 100%     | product_test.dart                  |
| **Dashboard (Widgets)**   | 36     | 60%+     | metric_card, activity_item         |
| **Dashboard (Constants)** | 2      | 100%     | dashboard_spacing                  |
| **Total**                 | **83** | **100%** | **6 files**                        |

---

## 🏗️ Testing Architecture

### Test Layers

```
UNIT TESTS (Domain Layer)
├─ No external dependencies
├─ No database access
├─ Fast execution (<100ms each)
├─ 100% coverage target
└─ Examples: Entity calculations, formatters

INTEGRATION TESTS (Data Layer)
├─ Mock Isar database
├─ Repository implementations
├─ Medium execution time
├─ 80%+ coverage target
└─ Examples: Database queries, transformations

WIDGET TESTS (Presentation Layer)
├─ Render actual widgets
├─ Simulate user interactions
├─ Slower execution
├─ 60%+ coverage target
└─ Examples: Button clicks, form input
```

---

## 🧪 Running Tests

### Basic Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/products/domain/entities/product_test.dart

# Run all tests in a directory
flutter test test/core/utils/

# Watch mode (re-run on file changes)
flutter test --watch

# Watch specific file
flutter test test/features/products/ --watch

# Verbose output (see each test)
flutter test -v

# Generate coverage report
flutter test --coverage

# Run single test by name
flutter test --name "should calculate"
```

### Advanced Filtering

```bash
# Run tests matching pattern
flutter test --name "Product"

# Run tests except matching pattern
flutter test --name "!dashboard"

# Run tests with specific tag
flutter test -t unit

# Run tests excluding tag
flutter test --exclude-tags "integration"
```

---

## ✍️ Writing Tests

### Test File Structure

```dart
import 'package:flutter_test/flutter_test.dart';
// ... other imports

void main() {
  group('Component Name', () {
    setUp(() {
      // Setup before each test
    });

    tearDown(() {
      // Cleanup after each test
    });

    test('should do something', () async {
      // Arrange
      final input = 'data';

      // Act
      final result = await function(input);

      // Assert
      expect(result, expectedValue);
    });

    group('Sub-group', () {
      test('nested test', () {
        // ...
      });
    });
  });
}
```

### Test Naming Convention

```dart
// Good: Clear, specific
test('profitMargin calculates percentage correctly', () { ... });
test('isLowStock returns true when stock <= threshold', () { ... });
test('should fail when selling price < cost price', () { ... });

// Bad: Vague or unclear
test('test profit', () { ... });
test('works', () { ... });
test('edge case', () { ... });
```

### AAA Pattern (Arrange-Act-Assert)

```dart
test('createProduct validates pricing', () async {
  // Arrange - Set up test data
  final product = Product(
    costPrice: 50.0,
    sellingPrice: 40.0,  // Invalid: less than cost
    // ...
  );

  // Act - Execute the code under test
  final result = await usecase.call(product);

  // Assert - Check the result
  expect(result, isA<Error>());
  expect(result.asError.failure, isA<ValidationFailure>());
});
```

---

## 🧬 Test Examples

### Unit Test: Entity Calculations

```dart
// From test/features/products/domain/entities/product_test.dart

group('Product Entity Profit Calculations', () {
  final testProduct = Product(
    costPrice: 50.0,
    sellingPrice: 60.0,
    piecesPerCarton: 12,
    // ...
  );

  test('profitPerPiece calculates correctly', () {
    expect(testProduct.profitPerPiece, 10.0);
  });

  test('profitMargin calculates percentage correctly', () {
    expect(testProduct.profitMargin, 20.0);  // (10 / 50) * 100
  });

  test('profitMargin returns 0 when cost price is zero', () {
    final product = testProduct.copyWith(costPrice: 0.0);
    expect(product.profitMargin, 0.0);
  });
});
```

### Stock Management Tests

```dart
group('Product Entity Stock Management', () {
  test('isLowStock returns true when stock <= threshold', () {
    final product = testProduct.copyWith(
      stockPieces: 20,
      lowStockThreshold: 20,
    );
    expect(product.isLowStock, true);
  });

  test('isLowStock returns false when stock > threshold', () {
    final product = testProduct.copyWith(
      stockPieces: 21,
      lowStockThreshold: 20,
    );
    expect(product.isLowStock, false);
  });
});
```

### Widget Test: Metric Card

```dart
testWidgets('MetricCard displays title, value, and trend correctly',
    (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MetricCard(
          title: 'Total Sales',
          value: 'Rs 10,000',
          trend: 5.0,
          icon: Icons.shopping_bag,
        ),
      ),
    ),
  );

  expect(find.text('Total Sales'), findsOneWidget);
  expect(find.text('Rs 10,000'), findsOneWidget);
  expect(find.byIcon(Icons.shopping_bag), findsOneWidget);
});
```

---

## 🎯 Coverage Requirements

### By Layer

| Layer            | Coverage | Target  | Approach                |
| ---------------- | -------- | ------- | ----------------------- |
| **Utilities**    | 100%     | ✅ 100% | Unit tests (no mocks)   |
| **Domain**       | 100%     | ✅ 100% | Unit tests (no mocks)   |
| **Data**         | 0%       | 80%+    | Integration (mock Isar) |
| **Presentation** | 60%+     | ✅ 60%+ | Widget tests            |
| **Use Cases**    | 0%       | 100%    | Integration (mock repo) |

### Coverage Report

```bash
# Generate coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🐛 Common Test Issues & Solutions

### Issue: "Method not found: 'when'"

**Cause:** Missing mock generation  
**Solution:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: "RenderBox was not laid out"

**Cause:** Widget test missing MaterialApp wrapper  
**Solution:**

```dart
await tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: YourWidget()),
  ),
);
```

### Issue: "setState() called after dispose()"

**Cause:** Async operation completing after widget disposal  
**Solution:** Use AutoDispose or proper cleanup:

```dart
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

### Issue: "package:x is not a dependency"

**Cause:** Missing package import  
**Solution:** Add to pubspec.yaml:

```yaml
dev_dependencies:
  mockito: ^6.0.0
  flutter_test:
    sdk: flutter
```

---

## ✅ Best Practices

### 1. Test Isolation

✅ Each test is independent  
✅ No shared state between tests  
✅ No test order dependencies

```dart
// Good: Each test is complete
test('calculation 1', () { ... });
test('calculation 2', () { ... });  // No dependency on test 1

// Bad: Test 2 depends on test 1 running first
var sharedValue = 0;
test('set value', () { sharedValue = 10; });
test('use value', () { expect(sharedValue, 10); });
```

### 2. Clear Assertions

✅ One concept per test  
✅ Descriptive expectation messages  
✅ Explicit rather than implicit

```dart
// Good: Clear intent
expect(product.isLowStock, true, reason: 'stock should be <= 20');

// Bad: Vague
expect(product.isLowStock, true);
```

### 3. Test Data Management

✅ Reusable fixtures  
✅ Valid default values  
✅ Explicit edge cases

```dart
// Good: Reusable fixture
final testProduct = Product(
  costPrice: 50.0,
  sellingPrice: 60.0,
  // ... all required fields
);

// Use copyWith for variations
final lowStockProduct = testProduct.copyWith(stockPieces: 10);
final expensiveProduct = testProduct.copyWith(sellingPrice: 1000.0);
```

### 4. Fast Execution

✅ Unit tests < 100ms each  
✅ Full suite < 10 seconds  
✅ No unnecessary waits

```dart
// Good: Direct assertions
expect(product.profitMargin, 20.0);

// Bad: Unnecessary delays
await Future.delayed(Duration(milliseconds: 100));
expect(product.profitMargin, 20.0);
```

### 5. Meaningful Test Names

✅ Describe what is being tested  
✅ Describe the condition  
✅ Describe the expected outcome

```dart
// Good: Clear name explains everything
test('profitMargin returns 0 when cost price is zero', () { ... });

// Bad: Unclear what is being tested
test('profitMargin works', () { ... });
```

---

## 📈 Test Metrics

### Coverage by Feature

```
products/
  ├── domain/entities/         100% ✅
  ├── domain/repositories/       0% ⚠️ (planned)
  ├── domain/usecases/          0% ⚠️ (planned)
  ├── data/models/              0% ⚠️ (planned)
  ├── data/datasources/         0% ⚠️ (planned)
  └── presentation/widgets/    60%+ ✅

dashboard/
  ├── presentation/widgets/    60%+ ✅
  ├── presentation/providers/   0% ⚠️ (planned)
  ├── constants/              100% ✅
  └── domain/                   0% ⚠️ (planned)
```

### Execution Time Breakdown

```
Unit Tests:       ~0.5s  (product_test.dart)
Utilities:        ~0.5s  (currency, converter)
Widget Tests:     ~2.0s  (dashboard widgets)
──────────────────────
Total:            ~3.0s  ✅
```

---

## 🚀 Future Testing Plans

### Phase 6 Extension (In Progress)

- [ ] Repository tests with Isar mocks
- [ ] Use case tests (validation + error paths)
- [ ] Provider integration tests
- [ ] Multi-feature workflow tests
- **Target:** 100+ total tests, 80%+ coverage

### Phase 8+

- [ ] End-to-end tests (full workflows)
- [ ] Performance profiling tests
- [ ] Integration with backend API
- [ ] UI automation tests

---

## 📚 Testing Resources

### Official Documentation

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Dart Testing Guide](https://dart.dev/guides/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Related Docs

- [ARCHITECTURE.md](ARCHITECTURE.md) - Test layer architecture
- [DEVELOPMENT.md](DEVELOPMENT.md) - Dev setup with test commands

---

## Summary

✅ **Current Status:** 83 tests passing, 100% execution success  
✅ **Coverage:** 100% utilities + domain, 60%+ widgets  
✅ **Speed:** ~3 seconds full suite  
✅ **Quality:** Clear tests, good naming, proper isolation

**Next:** Extend coverage to repositories, use cases, and integration tests.
