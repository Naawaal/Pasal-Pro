# Contributing to Pasal Pro

**Status:** Phase 7 - Documentation  
**Last Updated:** February 5, 2026

## 🎯 Welcome Contributors!

Thank you for your interest in Pasal Pro. This document guides you through the contribution process.

**Project Goal:** Build the fastest POS system for Nepali wholesale shops with offline-first design and <2-second sale entry.

---

## 🚀 Getting Started

### 1. Fork & Clone

```bash
# Fork on GitHub (via web UI)
# Clone your fork
git clone https://github.com/YOUR_USERNAME/pasal-pro.git
cd pasal-pro

# Add upstream remote
git remote add upstream https://github.com/YourOrg/pasal-pro.git
```

### 2. Set Up Development Environment

```bash
# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Verify setup
flutter analyze          # Should be 0 issues
flutter test             # Should be 83+ tests passing
flutter run -d windows   # Should launch app
```

### 3. Create Feature Branch

```bash
# Update from main
git fetch upstream
git checkout main
git rebase upstream/main

# Create feature branch
git checkout -b feature/short-description
# Example: feature/add-customer-search
```

---

## 📋 Before You Code

### 1. Check Open Issues

Visit [GitHub Issues](https://github.com/YourOrg/pasal-pro/issues) to:

- See what's already in progress
- Check for duplicates before opening new issue
- Ask in issue before starting work

### 2. Discuss Major Changes

For significant features:

- Open an issue describing the feature
- Wait for maintainer feedback
- Discuss approach before implementation

### 3. Read Architecture Docs

Ensure you understand:

- [ARCHITECTURE.md](ARCHITECTURE.md) - System design
- [DEVELOPMENT.md](DEVELOPMENT.md) - Dev workflow
- Clean Architecture pattern (Domain → Data → Presentation)

---

## 💻 Code Standards

### File Size Limits (REQUIRED)

```
Violations will be rejected in PR:
- Widget files:    MAX 250 lines
- Other Dart:      MAX 300 lines
- Functions:       MAX 50 lines
- build() methods: MAX 30 lines

Reason: Maintainability, readability, testability
```

### Naming Conventions

```dart
// ✅ Files: snake_case
product_card_widget.dart

// ✅ Classes: PascalCase
class ProductCard extends StatelessWidget {}

// ✅ Variables/Functions: camelCase
final productPrice = 100;
void addProduct() {}

// ✅ Constants: camelCase with underscore (private)
const _defaultPadding = 16.0;

// ✅ Booleans: is/has prefix
bool isActive;
bool hasLowStock;

// ✅ Collections: plural
List<Product> products;

// ✅ Private members: underscore prefix
final _controller = TextEditingController();
```

### Code Organization

Every class must follow this order:

```dart
class MyWidget extends StatelessWidget {
  // 1. Static constants
  static const double _iconSize = 24;

  // 2. Instance variables (public first, then private)
  final String title;
  final _controller = TextEditingController();

  // 3. Constructor
  const MyWidget({super.key, required this.title});

  // 4. Lifecycle methods (initState, dispose)

  // 5. Public methods

  // 6. Private methods

  // 7. Build/UI methods
  @override
  Widget build(BuildContext context) { }

  Widget _buildCard() { }  // Private build helpers
}
```

### Comments & Documentation

```dart
// ✅ Explain WHY, not what
// Query products sorted by low stock first to alert shop owners early
final lowStockProducts = products.where((p) => p.stock < p.threshold).toList();

// ❌ Redundant comments
// Get products where stock is less than threshold
final lowStockProducts = products.where((p) => p.stock < p.threshold).toList();

// ✅ Document non-obvious business logic
/// Cost = wholesale price + 15% margin to match competitor pricing
double calculateCost(double wholesalePrice) => wholesalePrice * 1.15;

// ✅ Flag performance-critical sections
// PERFORMANCE: This query runs on every sale - keep indexed
final products = isar.products.where().nameContains(query).findAll();
```

### Quality Checklist

Before submitting PR, ensure:

- [ ] `flutter analyze` returns 0 issues
- [ ] `flutter test` passes 100%
- [ ] `dart format` applied
- [ ] No hardcoded colors/spacing (use AppColors, AppSpacing)
- [ ] No `print()` statements
- [ ] No `setState()` in feature code
- [ ] Files < size limits
- [ ] Comments explain WHY, not what
- [ ] Tests added for new features
- [ ] No unused imports

---

## 🧪 Testing Requirements

### Test Coverage by Layer

```
Your Contribution Must Include:
- Unit Tests (Domain logic):      100% coverage
- Widget Tests (UI features):     60%+ coverage
- Comments/Documentation:         All public APIs

Existing Coverage:
- Core Utilities:     100% (23 tests)
- Product Domain:     100% (22 tests)
- Dashboard Widgets:  60%+ (36 tests)
- Total Tests:        83 passing
```

### Writing Tests

```dart
// Location: test/features/myfeature/...
// Mirror structure of lib/features/myfeature/

void main() {
  group('MyComponent', () {
    // Setup
    setUp(() {
      // Initialize fixtures
    });

    // Test cases
    test('should do X when Y', () {
      // Arrange
      final input = 'data';

      // Act
      final result = myFunction(input);

      // Assert
      expect(result, expectedValue);
    });

    // Nested groups
    group('Edge Cases', () {
      test('should handle empty input', () {
        expect(myFunction(''), null);
      });
    });
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/myfeature/...

# Watch mode
flutter test --watch

# With coverage
flutter test --coverage
```

---

## 🔄 Clean Architecture Requirements

All new features MUST follow 3-layer architecture.

### Layer Responsibilities

```
DOMAIN (Pure Dart - No Framework Dependencies)
├─ entities/         Business models
├─ repositories/     Abstract interfaces
└─ usecases/         Business operations

DATA (Framework Aware - Isar, HTTP)
├─ models/           @Collection() Isar models
├─ datasources/      Database queries
└─ repositories/     Controller implementations

PRESENTATION (UI - Riverpod + Flutter)
├─ providers/        State management
├─ pages/            Full screens
└─ widgets/          Reusable components
```

### Example Feature Structure

```
lib/features/myfeature/
├── domain/
│   ├── entities/
│   │   └── myentity.dart
│   ├── repositories/
│   │   └── myrepository.dart
│   └── usecases/
│       └── get_myentity.dart
├── data/
│   ├── models/
│   │   └── myentity_model.dart
│   ├── datasources/
│   │   └── myentity_local_datasource.dart
│   └── repositories/
│       └── myrepository_impl.dart
└── presentation/
    ├── providers/
    │   └── myentity_providers.dart
    ├── pages/
    │   └── myentity_page.dart
    └── widgets/
        └── myentity_card_widget.dart
```

---

## 🔀 Pull Request Process

### Step 1: Prepare Commits

```bash
# Check what changed
git diff lib/

# Stage changes
git add lib/

# Commit with clear message
git commit -m "feat: add customer search by phone

- Add search input field to customer page
- Implement phone number filtering in repository
- Add 4 test cases for search functionality
- Update customer_page.dart for responsiveness"
```

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Type:**

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `refactor:` Code restructuring
- `test:` Test additions
- `chore:` Dependencies, build config

**Subject:**

- Imperative mood ("add feature", not "added feature")
- Lowercase
- Max 50 characters
- No period

**Body:**

- Explain what and why (not how)
- Max 72 characters per line
- Optional but recommended

**Example:**

```
feat: add product search with phone number validation

Implement search functionality allowing customers to be found by phone.
This reduces entry time for repeat customers from 30s to 5s.

- Add search_query provider for reactive updates
- Implement phoneStartsWith() query in datasource
- Add 5 test cases for edge cases
- Add validation for phone number format (10 digits Nepal format)
```

### Step 2: Quality Checks

```bash
# Final checks before push
flutter analyze          # 0 issues required
flutter test             # 100% pass rate required
dart format lib test     # Apply formatting

# Check git status
git status

# View your changes
git diff
```

### Step 3: Push & Create PR

```bash
# Push to your fork
git push -u origin feature/short-description

# Create PR via GitHub UI:
# 1. Browse to: https://github.com/YOUR_USERNAME/pasal-pro
# 2. Click "Compare & pull request"
# 3. Write PR description (see template below)
# 4. Request reviewers
# 5. Enable "Allow edits from maintainers"
```

### Step 4: PR Description Template

```markdown
## Description

Brief description of what this PR does. One paragraph.

## Type of Change

- [ ] New feature
- [ ] Bug fix
- [ ] Documentation
- [ ] Performance improvement
- [ ] Code refactoring

## Related Issue

Closes #Issue_Number

## Changes Made

- Feature 1
- Feature 2
- Bug fix 1

## Testing

- [ ] Added unit tests
- [ ] Added widget tests
- [ ] All tests pass (83+ passing)
- [ ] No regressions

## Screenshots (if UI change)

[Include before/after screenshots]

## Checklist

- [ ] Code follows quality standards
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No unused imports
- [ ] Tested locally
```

### Step 5: Code Review

**During Review, You May Be Asked To:**

- Fix code style issues
- Add more tests
- Improve comments
- Refactor large functions
- Update documentation

**Changes:**

```bash
# Make requested changes
git add lib/
git commit -m "refactor: improve search performance per review"

# Push changes (PR auto-updates)
git push origin feature/short-description
```

### Step 6: Merge & Celebrate!

Once approved:

- GitHub automatically merges when all checks pass
- Your code now in main branch! 🎉

---

## 🐛 Bug Reports

### Creating an Issue

If you find a bug, open an issue with:

```markdown
## Bug Description

Clear description of the problem.

## Steps to Reproduce

1. Open the app
2. Navigate to Products
3. Search for "rice"
4. See crash with message: ...

## Expected Behavior

Should display search results, not crash.

## Actual Behavior

App crashes with exception (see logs below).

## Screenshots

[Include screenshots if relevant]

## Logs

[Include error messages from console]

## Environment

- Flutter: 3.10.0
- Dart: 3.0.0
- OS: Windows 11
- App Version: 1.0.0
```

---

## 📚 Feature Requests

### Proposing New Features

```markdown
## Feature Description

Clear description of the feature.

## Use Case

Who needs this? Why?
Example: "Shop owners need to track cheque payments so they can..."

## Acceptance Criteria

- [ ] Cheque can be added with date and amount
- [ ] Cheque status tracked (pending/cleared/bounced)
- [ ] Dashboard shows pending cheques

## Implementation Approach

Suggested approach (optional):

- Create ChequeModel, ChequeEntity
- Add to dashboard metrics
- Create cheque_page.dart
```

---

## ✍️ Documentation Contributions

### Adding/Updating Docs

1. Follow **Markdown** format in `docs/` folder
2. Use clear headings (H1-H4)
3. Include code examples
4. Link to related docs
5. Update table of contents

---

## 🚫 What We DON'T Accept

- [ ] Changes that break backward compatibility without discussion
- [ ] Code without tests
- [ ] Hardcoded values (colors, spacing, etc.)
- [ ] `setState()` usage in feature code
- [ ] Files exceeding size limits
- [ ] Functionality requiring paid services
- [ ] Incomplete/untested features in main branch

---

## 🎓 Learning Resources

- [ARCHITECTURE.md](ARCHITECTURE.md) - System design
- [DEVELOPMENT.md](DEVELOPMENT.md) - Dev setup & workflow
- [TESTING.md](TESTING.md) - Testing strategies
- [API_REFERENCE.md](API_REFERENCE.md) - Public API docs
- [Flutter Docs](https://flutter.dev)
- [Riverpod Docs](https://riverpod.dev)
- [Isar Docs](https://isar.dev)

---

## 💬 Communication Channels

- **Issues:** GitHub Issues (bug reports, features)
- **Discussions:** GitHub Discussions (questions, ideas)
- **Email:** [maintainer contact]

---

## 🙏 Code of Conduct

We follow the [Contributor Covenant](https://www.contributor-covenant.org/).

**TL;DR:**

- Be respectful and inclusive
- No harassment or discrimination
- Constructive feedback only
- Report violations to maintainers

---

## 📊 Contribution Stats

We track and celebrate all contributions!

- **Contributors:** [15+ developers]
- **PRs Merged:** [50+]
- **Issues Resolved:** [100+]
- **Test Coverage:** 83 tests, 100% domain layer

---

## 🎁 Recognition

All contributors listed in:

- [CONTRIBUTORS.md](../CONTRIBUTORS.md) (auto-generated)
- GitHub: Appears in insights/contributors
- Release notes: Mentioned in version releases

---

## Summary

✅ **Quick Contribution Checklist:**

1. Fork & clone repo
2. Create feature branch: `git checkout -b feature/name`
3. Code following standards
4. Add tests (100% domain, 60%+ UI)
5. Run: `flutter analyze` (0 issues) + `flutter test` (all pass)
6. Commit: `git commit -m "feat: description"`
7. Push: `git push -u origin feature/name`
8. Create PR with description
9. Respond to review feedback
10. Celebrate when merged! 🎉

**Questions?**
Open a GitHub Discussion or email maintainers.

**Thank you for contributing to Pasal Pro!** ❤️
