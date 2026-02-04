# UI Package Integration Guide

## 📦 Integrated Packages

AppIcons.menu, AppIcons.search, AppIcons.filter (listFilter), AppIcons.settings

### 1. **Local Fonts (Noto Sans)** - App Typography

### 2. **gap** - Consistent Spacing

AppIcons.add (plus), AppIcons.edit (pencil), AppIcons.delete (trash2), AppIcons.save

---

AppIcons.store, AppIcons.rupee (indianRupee), AppIcons.cash (banknote), AppIcons.credit (creditCard)

## 🎨 Local Fonts Usage

AppIcons.pieChart (chartPie), AppIcons.barChart (chartBarBig), AppIcons.trendingUp

### Configuration

AppIcons.success (circleCheck), AppIcons.error (circleX), AppIcons.warning (triangleAlert), AppIcons.help (circleQuestionMark)
fontFamily: 'NotoSans'

````
AppIcons.user, AppIcons.users, AppIcons.package, AppIcons.warehouse
### Using Custom Fonts (if needed)
Add font files to `assets/fonts/` and register them in `pubspec.yaml` under `flutter: fonts:`.

### Available Font Weights

- `FontWeight.w300` - Light
- `FontWeight.w400` - Regular (default)
- `FontWeight.w500` - Medium
- `FontWeight.w600` - SemiBold
- `FontWeight.w700` - Bold

---

## 📏 Gap Package Usage

**Gap** replaces `SizedBox` for cleaner, more readable spacing code.

### Import

```dart
import 'package:gap/gap.dart';
```

### Standard Usage

```dart
Column(
  children: [
    Text('First item'),
    const Gap(16),  // Vertical spacing
    Text('Second item'),
    const Gap(24),  // Larger spacing
    Text('Third item'),
  ],
)

Row(
  children: [
    Icon(Icons.star),
    const Gap(8),  // Horizontal spacing in Row
    Text('Rating'),
  ],
)
```

### Centralized Spacing (Recommended)

Use [app_spacing.dart](../core/constants/app_spacing.dart) for consistency:

```dart
import 'package:pasal_pro/core/constants/app_spacing.dart';

Column(
  children: [
    Text('First'),
    AppSpacing.small,      // 12px
    Text('Second'),
    AppSpacing.medium,     // 16px
    Text('Third'),
    AppSpacing.large,      // 24px
    Text('Fourth'),
  ],
)
```

### Available Spacing Constants

```dart
// Vertical
AppSpacing.xxSmall   // 4px
AppSpacing.xSmall    // 8px
AppSpacing.small     // 12px
AppSpacing.medium    // 16px
AppSpacing.large     // 24px
AppSpacing.xLarge    // 32px
AppSpacing.xxLarge   // 48px
AppSpacing.xxxLarge  // 64px

// Horizontal (for Rows)
AppSpacing.hXSmall   // 8px
AppSpacing.hMedium   // 16px
AppSpacing.hLarge    // 24px

// Padding
AppSpacing.paddingSmall     // EdgeInsets.all(12)
AppSpacing.paddingMedium    // EdgeInsets.all(16)
AppSpacing.paddingLarge     // EdgeInsets.all(24)
```

---

## 🎯 Lucide Icons Usage

Modern, consistent icons throughout the app.

### Import (Centralized)

```dart
import 'package:pasal_pro/core/constants/app_icons.dart';
```

### Usage Examples

```dart
// Basic icon
Icon(AppIcons.store)

// With size and color
Icon(
  AppIcons.search,
  size: 24,
  color: Colors.blue,
)

// In buttons
IconButton(
  icon: Icon(AppIcons.settings),
  onPressed: () {},
)

// In leading/trailing
ListTile(
  leading: Icon(AppIcons.user),
  title: Text('Customer'),
  trailing: Icon(AppIcons.forward),
)
```

### Available Icons by Category

#### Navigation & Actions

```dart
AppIcons.menu
AppIcons.close
AppIcons.back
AppIcons.forward
AppIcons.search
AppIcons.filter
AppIcons.settings
AppIcons.more
```

#### CRUD Operations

```dart
AppIcons.add
AppIcons.edit
AppIcons.delete
AppIcons.save
AppIcons.cancel
AppIcons.check
AppIcons.checkCircle
```

#### Business - Shop & Products

```dart
AppIcons.store
AppIcons.package
AppIcons.shoppingCart
AppIcons.shoppingBag
AppIcons.tag
AppIcons.barcode
AppIcons.box
```

#### Financial

```dart
AppIcons.rupee
AppIcons.cash
AppIcons.credit
AppIcons.wallet
AppIcons.trendingUp    // Profit
AppIcons.trendingDown  // Loss
AppIcons.pieChart
AppIcons.barChart
```

#### Customers

```dart
AppIcons.user
AppIcons.users
AppIcons.userPlus
AppIcons.userCheck
```

#### Inventory & Stock

```dart
AppIcons.packageCheck   // In stock
AppIcons.packageX       // Low stock
AppIcons.packagePlus    // Add stock
AppIcons.packageMinus   // Remove stock
AppIcons.warehouse
```

#### Status & Alerts

```dart
AppIcons.success      // Green checkmark
AppIcons.error        // Red X
AppIcons.warning      // Yellow triangle
AppIcons.info         // Info circle
AppIcons.alertCircle
```

#### Data & Documents

```dart
AppIcons.database
AppIcons.cloud
AppIcons.backup
AppIcons.restore
AppIcons.sync
AppIcons.receipt
AppIcons.print
AppIcons.download
```

#### Customer Ledger (Khata)

```dart
AppIcons.khata        // Ledger book
AppIcons.ledger       // Alternative ledger
AppIcons.payment      // Payment icon
```

#### Units (Carton/Pieces)

```dart
AppIcons.carton       // Carton/box
AppIcons.pieces       // Grid for pieces
```

Full list: See [app_icons.dart](../core/constants/app_icons.dart)

---

## 🎯 Best Practices

### ✅ DO

```dart
// Use centralized spacing
AppSpacing.medium

// Use icon constants
Icon(AppIcons.store)

// Combine for clean code
Column(
  children: [
    Icon(AppIcons.user, size: 48),
    AppSpacing.medium,
    Text('Profile', style: Theme.of(context).textTheme.titleMedium),
  ],
)
```

### ❌ DON'T

```dart
// Don't use hardcoded spacing
const SizedBox(height: 16)  // Use AppSpacing.medium instead

// Don't import Lucide directly
import 'package:lucide_icons_flutter/lucide_icons.dart'
Icon(LucideIcons.store)  // Use AppIcons.store instead

// Don't use Material icons
Icon(Icons.store)  // Use AppIcons.store for consistency
```

---

## 📋 Quick Reference

### Common Patterns

#### Card with Icon Header

```dart
Card(
  child: Padding(
    padding: AppSpacing.paddingMedium,
    child: Column(
      children: [
        Row(
          children: [
            Icon(AppIcons.store, size: 20),
            AppSpacing.hXSmall,
            Text('Shop Name'),
          ],
        ),
        AppSpacing.medium,
        Text('Content here...'),
      ],
    ),
  ),
)
```

#### List Item with Icons

```dart
ListTile(
  leading: CircleAvatar(
    child: Icon(AppIcons.user),
  ),
  title: Text('Customer Name'),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSpacing.xxSmall,
      Row(
        children: [
          Icon(AppIcons.rupee, size: 14),
          AppSpacing.hXxSmall,
          Text('Rs 1,234'),
        ],
      ),
    ],
  ),
  trailing: Icon(AppIcons.forward),
)
```

#### Status Badge

```dart
Container(
  padding: AppSpacing.paddingXSmall,
  decoration: BoxDecoration(
    color: AppTheme.profitColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        AppIcons.trendingUp,
        size: 14,
        color: AppTheme.profitColor,
      ),
      AppSpacing.hXxSmall,
      Text(
        'Profit',
        style: TextStyle(color: AppTheme.profitColor),
      ),
    ],
  ),
)
```

---

## 🚀 Ready to Use!

All three packages are now integrated and ready for use throughout the app:

✅ **Local fonts (Noto Sans)** - Theme uses bundled Noto Sans
✅ **gap** - Spacing constants in `AppSpacing`
✅ **lucide_icons_flutter** - Icon constants in `AppIcons`

### Next Steps

When building new features:

1. Import `AppIcons` for icons
2. Import `AppSpacing` for spacing
3. Use theme's text styles (already using local Noto Sans)
4. Reference this guide for common patterns

---

**See [main.dart](../main.dart) for a complete working example!**
````
