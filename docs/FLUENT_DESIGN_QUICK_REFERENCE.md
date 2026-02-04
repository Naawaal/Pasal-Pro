# 🎨 Fluent Design System Quick Reference

**Phase 2 Complete** ✅ | Ready for production screens

---

## 🚀 Quick Start

### Import the Utilities

```dart
import 'package:pasal_pro/core/constants/fluent_app_icons.dart';
import 'package:pasal_pro/core/theme/fluent_design.dart';
```

### Use Fluent Icons (60+ business icons)

```dart
Icon(FluentAppIcons.store)        // Shop
Icon(FluentAppIcons.product)      // Package
Icon(FluentAppIcons.payment)      // Credit card
Icon(FluentAppIcons.trendingUp)   // Profit
Icon(FluentAppIcons.customerAdd)  // New customer
```

### Apply Fluent Shadows

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [FluentDesign.shadowSmall],  // Resting
  ),
)

// On hover:
Container(
  decoration: BoxDecoration(
    boxShadow: [FluentDesign.shadowMedium],  // Elevated
  ),
)
```

### Use Fluent Corner Radius

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: FluentDesign.cornerMedium,  // 8px - standard
  ),
)
```

---

## 📦 Complete Icon Library (60+)

### Navigation Icons

```
FluentAppIcons.menu              FluentAppIcons.close
FluentAppIcons.back              FluentAppIcons.forward
FluentAppIcons.settings          FluentAppIcons.help
FluentAppIcons.moreVertical      FluentAppIcons.moreHorizontal
```

### Search & Filter

```
FluentAppIcons.search            FluentAppIcons.filter
```

### CRUD Actions

```
FluentAppIcons.add               FluentAppIcons.edit
FluentAppIcons.delete            FluentAppIcons.check
FluentAppIcons.cancel            FluentAppIcons.save
```

### Business - Shop & Inventory

```
FluentAppIcons.store             FluentAppIcons.product
FluentAppIcons.productAdd        FluentAppIcons.productRemove
FluentAppIcons.productSearch     FluentAppIcons.inventory
FluentAppIcons.warehouse         FluentAppIcons.lowStock
FluentAppIcons.inStock           FluentAppIcons.outOfStock
FluentAppIcons.barcode           FluentAppIcons.carton
```

### Sales & Transactions

```
FluentAppIcons.shoppingCart      FluentAppIcons.shoppingBag
FluentAppIcons.receipt           FluentAppIcons.payment
FluentAppIcons.cash              FluentAppIcons.wallet
FluentAppIcons.refund
```

### Financial & Reporting

```
FluentAppIcons.rupee             FluentAppIcons.chartBar
FluentAppIcons.chartPie          FluentAppIcons.trendingUp
FluentAppIcons.trendingDown      FluentAppIcons.analytics
```

### Customers & People

```
FluentAppIcons.person            FluentAppIcons.personAdd
FluentAppIcons.people            FluentAppIcons.customer
FluentAppIcons.customerCheck     FluentAppIcons.contact
FluentAppIcons.phone             FluentAppIcons.email
```

### Cheques & Payments

```
FluentAppIcons.cheque            FluentAppIcons.chequeAdd
FluentAppIcons.pending           FluentAppIcons.approve
FluentAppIcons.reject
```

### Ledger & Accounting

```
FluentAppIcons.ledger            FluentAppIcons.credit
FluentAppIcons.debt              FluentAppIcons.paymentDue
FluentAppIcons.balance
```

### Date & Time

```
FluentAppIcons.calendar          FluentAppIcons.clock
FluentAppIcons.today
```

### Status & Alerts

```
FluentAppIcons.success           FluentAppIcons.error
FluentAppIcons.warning           FluentAppIcons.info
```

### Data Management

```
FluentAppIcons.database          FluentAppIcons.cloud
FluentAppIcons.backup            FluentAppIcons.restore
FluentAppIcons.sync              FluentAppIcons.copy
```

### Visibility & Privacy

```
FluentAppIcons.eye               FluentAppIcons.eyeOff
FluentAppIcons.lock              FluentAppIcons.unlock
```

### Dashboard & Analytics

```
FluentAppIcons.dashboard         FluentAppIcons.activity
FluentAppIcons.trending
```

### Miscellaneous

```
FluentAppIcons.download          FluentAppIcons.upload
FluentAppIcons.print             FluentAppIcons.star
FluentAppIcons.heart             FluentAppIcons.document
FluentAppIcons.folder
```

---

## 🎨 Shadow System (Elevation Levels)

### Resting State (Default)

```dart
FluentDesign.shadowSmall
// 4px blur, 2px Y offset, 8% alpha
// Used for: Cards, buttons (resting)
```

### Hover State (Interactive)

```dart
FluentDesign.shadowMedium
// 8px blur, 4px Y offset, 12% alpha
// Used for: Hovered buttons, lifted cards
```

### Pressed/Active State

```dart
FluentDesign.shadowLarge
// 16px blur, 8px Y offset, 16% alpha
// Used for: Dialogs, modals, popovers
```

### Modal/Critical Overlay

```dart
FluentDesign.shadowExtraLarge
// 24px blur, 12px Y offset, 20% alpha
// Used for: Full-screen dialogs, dropdowns
```

---

## 🔲 Corner Radius System

### Small (4px)

```dart
FluentDesign.cornerSmall
// Used for: Text inputs, small buttons, badges
```

### Medium (8px) - STANDARD

```dart
FluentDesign.cornerMedium
// Used for: Cards, containers, chips (default)
```

### Large (12px)

```dart
FluentDesign.cornerLarge
// Used for: Dialogs, modals, large cards
```

### Extra Large (16px)

```dart
FluentDesign.cornerExtraLarge
// Used for: Hero containers, branded sections
```

---

## ⏱️ Animation Durations (Fluent Spec)

### Fast (50ms)

```dart
FluentDesign.durationFast
// Used for: Micro-interactions, hover states
```

### Normal (200ms) - STANDARD

```dart
FluentDesign.durationNormal
// Used for: Common transitions, color changes
```

### Slow (300ms)

```dart
FluentDesign.durationSlow
// Used for: Page transitions, modals
```

### Extra Slow (500ms)

```dart
FluentDesign.durationExtraSlow
// Used for: Cinematic effects, intro animations
```

---

## 🎬 Common Animation Pattern

```dart
class MyFluentWidget extends StatefulWidget {
  @override
  State<MyFluentWidget> createState() => _MyFluentWidgetState();
}

class _MyFluentWidgetState extends State<MyFluentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: FluentDesign.durationNormal,  // 200ms
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _onHoverExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          // Smooth shadow transition
          final activeShadow = _isHovered
              ? FluentDesign.shadowMedium
              : FluentDesign.shadowSmall;

          return Container(
            decoration: BoxDecoration(
              borderRadius: FluentDesign.cornerMedium,
              boxShadow: [activeShadow],
            ),
            child: child,
          );
        },
      ),
    );
  }
}
```

---

## 🌈 Color Elevation Helpers

### Elevate (Lighten/Darken 5%)

```dart
FluentDesign.elevateColor(baseColor, intensity: 0.05)
// Used for: Hover states, interactive elements
// Makes color appear lifted/lighter
```

### Press (Darken/Lighten 10%)

```dart
FluentDesign.pressColor(baseColor, intensity: 0.1)
// Used for: Pressed/active states
// Makes color appear deeper/darker
```

---

## 🖇️ Button Decoration Patterns

### Resting Button

```dart
Container(
  decoration: FluentDesign.buttonDecorationResting(
    backgroundColor: theme.colorScheme.primary,
  ),
  child: Text('Click me'),
)
```

### Hovered Button

```dart
Container(
  decoration: FluentDesign.buttonDecorationHovered(
    backgroundColor: theme.colorScheme.primary,
  ),
  child: Text('Click me'),
)
```

### Pressed Button

```dart
Container(
  decoration: FluentDesign.buttonDecorationPressed(
    backgroundColor: theme.colorScheme.primary,
  ),
  child: Text('Click me'),
)
```

---

## 🃏 Card Decoration Patterns

### Standard Card

```dart
Container(
  decoration: FluentDesign.cardDecoration(
    backgroundColor: theme.colorScheme.surface,
    context: context,
  ),
  child: content,
)
```

### Interactive Card (Hover)

```dart
Container(
  decoration: FluentDesign.cardDecorationHovered(
    backgroundColor: theme.colorScheme.surface,
    context: context,
  ),
  child: content,
)
```

---

## 📊 Pre-Built Components

### ProductListItemFluent

```dart
ProductListItemFluent(
  product: product,
  onEdit: () {},
  onAdjustStock: () {},
  onToggleActive: () {},
)
// Fluent-enhanced product card with animations
```

### MetricCardFluent

```dart
MetricCardFluent(
  title: 'Today Sales',
  value: '₹ 45,230',
  change: '+12.5%',
  isPositive: true,
  icon: Icons.trending_up,
)
// Fluent-enhanced dashboard metric
```

---

## ✅ Best Practices

### DO ✅

- Use `FluentDesign.cornerMedium` for consistency
- Use `FluentDesign.durationNormal` for standard animations
- Use `FluentAppIcons.*` for business context icons
- Apply shadows only when depth is needed
- Combine with `AppResponsive` for responsive padding

### DON'T ❌

- Don't mix shadow sizes (stick to one level)
- Don't animate shadow on every interaction (use sparingly)
- Don't hardcode corner radius (use Fluent constants)
- Don't use all 4 shadow levels (usually 2 is enough)
- Don't apply 0.05 intensity everywhere (vary 0.04-0.08)

---

## 🔗 Related Files

- `lib/core/constants/fluent_app_icons.dart` - Icon definitions
- `lib/core/theme/fluent_design.dart` - Design tokens
- `lib/features/products/presentation/widgets/product_list_item_fluent.dart` - Component example
- `lib/features/dashboard/presentation/widgets/metric_card_fluent.dart` - Component example

---

## 📈 Migration Path

**Phase 2:** Fluent utilities created ✅  
**Phase 3:** Mix design tokens  
**Phase 4:** ShadCN forms  
**Phase 5:** Screen migration (20+ screens)  
**Phase 6:** Performance optimization  
**Phase 7:** Testing & QA

---

**Last Updated:** Phase 2 Complete ✅
