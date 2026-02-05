# Pasal Pro - Digital POS System for Nepali Wholesale Shops

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev)
[![Tests](https://img.shields.io/badge/Tests-83%2F83%20passing-brightgreen.svg)](#testing)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](#license)

**Pasal Pro** is a feature-complete Point of Sale (POS) system designed specifically for Nepali wholesale shops (kirana stores). It streamlines inventory management, sales transactions, customer credit tracking, and financial reporting with an offline-first architecture.

## 🎯 Key Features

### ⚡ Fast Sales Entry

- **2-second transaction completion** - Optimized for speed
- Hybrid unit support (cartons + pieces)
- Quick customer lookup and credit tracking
- One-click product search

### 📊 Real-time Dashboard

- 10+ metrics: Sales, Profit, Outstanding Credit, Low Stock Alerts
- Activity feed of last 10 transactions
- Daily/weekly/monthly analytics
- Real-time stock monitoring

### 📦 Complete Inventory Management

- Product CRUD with carton/piece pricing
- Low stock threshold alerts
- Barcode support
- Category organization

### 👥 Customer & Credit Management

- Customer ledger (Khata) with transaction history
- Credit balance tracking
- Payment recording
- Full audit trail

### 💰 Financial Tracking

- Profit margin calculations
- Cost vs. selling price management
- Cash vs. credit sales separation
- Cheque management

### 💾 Offline-First & Secure

- Local Isar database (zero cloud dependency)
- No internet required
- Automatic data backups
- Fast local queries

## 📋 Quick Start

### Prerequisites

- Flutter 3.10+
- Dart 3.0+
- Windows, Linux, or macOS (Desktop)

### Installation

```bash
# Clone the repository
git clone https://github.com/Naawaal/pasal_pro.git
cd pasal_pro

# Install dependencies
flutter pub get

# Rebuild code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run -d windows   # Windows (primary)
```

## 🏗️ Architecture

**Clean Architecture** with domain-driven design:

```
Domain Layer (Pure Dart)
    ↓ Repositories
Data Layer (Isar Database)
    ↓ Providers
Presentation Layer (Flutter UI)
```

Key Technologies:

- **State Management:** Riverpod (FutureProvider + StateNotifierProvider)
- **Database:** Isar (offline-first, fast queries)
- **UI:** Material 3 design system
- **Testing:** 83 tests passing ✅

## 🧪 Testing

```bash
# Run all tests (83 passing)
flutter test

# Watch mode
flutter test --watch

# Coverage report
flutter test --coverage
```

**Test Coverage:**

- Utilities: 100%
- Domain Logic: 100%
- Widgets: 60%+

See [docs/TESTING.md](docs/TESTING.md) for details.

## 📚 Documentation

| Document                                  | Purpose         |
| ----------------------------------------- | --------------- |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md)   | System design   |
| [TESTING.md](docs/TESTING.md)             | Testing guide   |
| [DEPLOYMENT.md](docs/DEPLOYMENT.md)       | Build & release |
| [DEVELOPMENT.md](docs/DEVELOPMENT.md)     | Dev setup       |
| [API_REFERENCE.md](docs/API_REFERENCE.md) | API docs        |

## 📊 Project Status

**Phase 7: Documentation** 🟠 In Progress

| Phase | Status         | Details              |
| ----- | -------------- | -------------------- |
| 1-5   | ✅ Complete    | Design, UI, Features |
| 6     | ✅ Complete    | 83 tests passing     |
| 7     | 🟠 In Progress | API docs, guides     |

## 🛠️ Development

### Before Starting Work

```bash
flutter pub get
flutter analyze
flutter test
```

### During Development

```bash
# Watch tests
flutter test --watch

# Watch code generation
dart run build_runner watch

# Run app
flutter run -d windows
```

### Before Committing

```bash
# Check quality
flutter analyze        # Must be 0 warnings
data format lib test   # Format code
flutter test           # Run tests
```

## 📦 Project Structure

```
lib/
├── main.dart              # Entry point
├── core/                  # Shared utilities
│   ├── database/          # Isar setup
│   ├── utils/            # Formatters, converters
│   ├── constants/         # Spacing, icons, colors
│   └── theme/            # Design tokens
└── features/             # Feature modules
    ├── products/         # Inventory
    ├── sales/           # Transactions
    ├── customers/       # Ledger
    ├── dashboard/       # Metrics
    ├── cheques/         # Payments
    └── settings/        # Config

test/
├── core/                # Utility tests
├── features/            # Feature tests
└── ...                  # 83 tests total
```

## 🎓 Code Quality Standards

**File Limits:**

- Widgets: ≤ 250 lines
- Other: ≤ 300 lines
- Functions: ≤ 50 lines

**Naming:**

- Files: `snake_case`
- Classes: `PascalCase`
- Private: `_underscore`
- Booleans: `isX` or `hasX`

## 📞 Support

- **Issues:** Check [KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md)
- **Contributing:** See [CONTRIBUTING.md](docs/CONTRIBUTING.md)
- **Questions:** Review [ARCHITECTURE.md](docs/ARCHITECTURE.md)

## 📄 License

Proprietary and confidential. All rights reserved.

---

**Last Updated:** February 5, 2026  
**Version:** 1.0.0
