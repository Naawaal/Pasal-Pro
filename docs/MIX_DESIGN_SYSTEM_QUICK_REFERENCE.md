# 🎨 Mix Design Token System - Quick Reference (Phase 3)

**Status:** ✅ Complete  
**Implementation Date:** Phase 3  
**Integration Level:** Full (replaces hardcoded values across app)  
**Backward Compatibility:** 100% (optional adoption per-component)

---

## 📋 Quick Start

### Access Design Tokens

```dart
import 'package:pasal_pro/core/theme/design_system.dart';

// Colors
Color primary = DesignSystem.colorPrimary;
Color success = DesignSystem.colorSuccess;
Color error = DesignSystem.colorError;

// Spacing
double padding = DesignSystem.spacingMedium;     // 16px
double spacing = DesignSystem.spacingSmall;      // 12px

// Border radius
BorderRadius radius = DesignSystem.radiusMedium;  // 8px

// Typography
TextStyle headline = DesignSystem.typographyHeadline2;
TextStyle body = DesignSystem.typographyBodyMedium;

// Shadows
BoxShadow shadow = DesignSystem.shadowSmall;

// Durations
Duration duration = DesignSystem.durationNormal;  // 200ms
```

### Use Pre-built Styles

```dart
import 'package:pasal_pro/core/theme/design_system.dart';
import 'package:mix/mix.dart';

// Button with primary style
Box(
  style: DesignSystem.buttonPrimary,
  child: Text('Click me'),
)

// Card with default style
Box(
  style: DesignSystem.card,
  child: ProductCard(),
)

// Card with hover effect
Box(
  style: _isHovered ? DesignSystem.cardHover : DesignSystem.card,
  child: Content(),
)
```

### Extension Methods

```dart
// Build context extensions for easy access
Color primary = context.colorPrimary;
double spacing = context.spacingMedium;
BorderRadius radius = context.radiusMedium;
```

---

## 🎨 Color System

### Semantic Colors

| Token            | Value                 | Use Case                       |
| ---------------- | --------------------- | ------------------------------ |
| `colorPrimary`   | `AppColors.accent`    | Buttons, links, brand accent   |
| `colorSecondary` | `AppColors.accent`    | Alternative actions            |
| `colorSuccess`   | `AppColors.green500`  | Profits, completed, checkmarks |
| `colorError`     | `AppColors.red500`    | Losses, errors, deletions      |
| `colorWarning`   | `AppColors.orange500` | Low stock, caution, alerts     |
| `colorInfo`      | `AppColors.blue500`   | Information, neutral alerts    |

### Surface Colors

| Token               | Value                    | Use Case          |
| ------------------- | ------------------------ | ----------------- |
| `colorBackground`   | `AppColors.background`   | Page background   |
| `colorSurface`      | `AppColors.surface`      | Cards, containers |
| `colorSurfaceHover` | `AppColors.surfaceHover` | Hover state       |
| `colorBorder`       | `AppColors.border`       | Dividers, borders |

### Text Colors

| Token                | Value                     | Contrast       |
| -------------------- | ------------------------- | -------------- |
| `colorTextPrimary`   | `AppColors.textPrimary`   | Highest (95%+) |
| `colorTextSecondary` | `AppColors.textSecondary` | Medium (70%+)  |
| `colorTextTertiary`  | `AppColors.textTertiary`  | Low (50%+)     |

### State Colors

| Method                        | Purpose                            |
| ----------------------------- | ---------------------------------- |
| `getHoverColor(baseColor)`    | Lightened color for hover          |
| `getPressedColor(baseColor)`  | Darkened color for press           |
| `getDisabledColor(baseColor)` | Desaturated + opacity for disabled |

---

## 📏 Spacing System (pixels)

| Token            | Value | Use Case                        |
| ---------------- | ----- | ------------------------------- |
| `spacingXxSmall` | 4px   | Tiny gap between elements       |
| `spacingXSmall`  | 8px   | Badge padding, icon spacing     |
| `spacingSmall`   | 12px  | Default small spacing           |
| `spacingMedium`  | 16px  | Default padding, button spacing |
| `spacingLarge`   | 24px  | Section spacing, card padding   |
| `spacingXLarge`  | 32px  | Large gap between sections      |
| `spacingXxLarge` | 48px  | Extra large gaps (hero spacing) |

---

## 📐 Border Radius System

| Token          | Value | Use Case                              |
| -------------- | ----- | ------------------------------------- |
| `radiusSmall`  | 4px   | Input fields, chips, small components |
| `radiusMedium` | 8px   | Cards, buttons, modals                |
| `radiusLarge`  | 12px  | Large cards, surface elements         |
| `radiusXLarge` | 16px  | Extra large containers, hero sections |

---

## 🔤 Typography System

### Headlines

```dart
// Large headline (page titles)
Text('Dashboard', style: DesignSystem.typographyHeadline1);
// 32px, bold, -0.5 letter spacing

// Medium headline (section titles)
Text('Recent Sales', style: DesignSystem.typographyHeadline2);
// 24px, bold, -0.25 letter spacing

// Small headline (card titles)
Text('Total Profit', style: DesignSystem.typographyHeadline3);
// 18px, bold, 1.3 line height
```

### Body Text

```dart
// Body large (important content)
Text('Product details here', style: DesignSystem.typographyBodyLarge);
// 16px, regular, 1.5 line height

// Body medium (default)
Text('Description', style: DesignSystem.typographyBodyMedium);
// 14px, regular, 1.5 line height

// Body small (secondary)
Text('Metadata', style: DesignSystem.typographyBodySmall);
// 12px, regular, 1.5 line height
```

### Labels

```dart
// Label large (prominent)
Text('ACTION REQUIRED', style: DesignSystem.typographyLabelLarge);
// 14px, bold, 0.1 letter spacing

// Label medium (default)
Text('Status', style: DesignSystem.typographyLabelMedium);
// 12px, bold, 0.1 letter spacing

// Label small (compact)
Text('Detail', style: DesignSystem.typographyLabelSmall);
// 11px, bold, 0.05 letter spacing
```

---

## 🎭 Shadow/Elevation System

Integrated from Fluent Design (Phase 2):

| Token              | Use Case                       |
| ------------------ | ------------------------------ |
| `shadowSmall`      | Resting cards, default buttons |
| `shadowMedium`     | Hovered buttons, lifted cards  |
| `shadowLarge`      | Dialogs, modals                |
| `shadowExtraLarge` | Full-screen overlays           |

---

## ⏱️ Motion/Animation Durations

| Token               | Duration | Use Case                            |
| ------------------- | -------- | ----------------------------------- |
| `durationFast`      | 50ms     | Micro interactions (opacity, scale) |
| `durationNormal`    | 200ms    | Standard transitions (Fluent spec)  |
| `durationSlow`      | 300ms    | Complex animations                  |
| `durationExtraSlow` | 500ms    | Page transitions                    |

---

## 🎨 Pre-built Styles

### Button Styles

```dart
// Primary button (elevated, filled)
Box(style: DesignSystem.buttonPrimary)

// Primary button hover state
Box(style: DesignSystem.buttonPrimaryHover)

// Primary button pressed state
Box(style: DesignSystem.buttonPrimaryPressed)

// Secondary button (outline)
Box(style: DesignSystem.buttonSecondary)
```

**Example:**

```dart
MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: Box(
    style: _isHovered
        ? DesignSystem.buttonPrimaryHover
        : DesignSystem.buttonPrimary,
    child: Text('Add Product'),
  ),
)
```

### Card Styles

```dart
// Default card
Box(style: DesignSystem.card)

// Card on hover
Box(style: DesignSystem.cardHover)

// Metric card (dashboard)
Box(style: DesignSystem.metricCard)

// Product card
Box(style: DesignSystem.productListItem)

// Product card hover
Box(style: DesignSystem.productListItemHover)
```

### Input Styles

```dart
// Default input
Box(style: DesignSystem.input)

// Focused input
Box(style: DesignSystem.inputFocused)
```

### Badge Styles

```dart
// Default badge
Box(style: DesignSystem.badge)

// Success badge (green)
Box(style: DesignSystem.badgeSuccess)

// Error badge (red)
Box(style: DesignSystem.badgeError)

// Warning badge (orange)
Box(style: DesignSystem.badgeWarning)
```

### Chip & Action Styles

```dart
// Info chip (inline label)
Box(style: DesignSystem.infoChip)

// Action button (secondary action)
Box(style: DesignSystem.actionButton)

// Action button hover
Box(style: DesignSystem.actionButtonHover)

// Divider
Box(style: DesignSystem.divider)
```

---

## 🔄 Migration Path

### Step 1: Replace Hardcoded Colors

```dart
// Before
Color primary = Color(0xFF1976D2);

// After
Color primary = DesignSystem.colorPrimary;
```

### Step 2: Replace Hardcoded Spacing

```dart
// Before
Padding(padding: EdgeInsets.all(16))

// After
Padding(padding: EdgeInsets.all(DesignSystem.spacingMedium))
```

### Step 3: Replace Hardcoded Radius

```dart
// Before
BorderRadius.circular(8)

// After
DesignSystem.radiusMedium
```

### Step 4: Use Pre-built Styles

```dart
// Before: Manual decoration
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [BoxShadow(...)],
  ),
)

// After: Pre-built style
Box(style: DesignSystem.card)
```

---

## 🧩 Common Patterns

### Button with Hover Animation

```dart
class MyButton extends StatefulWidget {
  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: DesignSystem.durationNormal,
        decoration: BoxDecoration(
          color: _isHovered
              ? DesignSystem.getHoverColor(DesignSystem.colorPrimary)
              : DesignSystem.colorPrimary,
          borderRadius: DesignSystem.radiusMedium,
          boxShadow: [
            _isHovered
                ? DesignSystem.shadowMedium
                : DesignSystem.shadowSmall,
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMedium,
            vertical: DesignSystem.spacingSmall,
          ),
          child: Text('Click me'),
        ),
      ),
    );
  }
}
```

### Card with Info Chips

```dart
Box(
  style: DesignSystem.card,
  child: Column(
    children: [
      Text('Product Name', style: DesignSystem.typographyHeadline3),
      SizedBox(height: DesignSystem.spacingMedium),
      Row(
        children: [
          Box(
            style: DesignSystem.infoChip,
            child: Text('Rs. 500', style: DesignSystem.typographyLabelMedium),
          ),
          SizedBox(width: DesignSystem.spacingSmall),
          Box(
            style: DesignSystem.infoChip,
            child: Text('20 pcs', style: DesignSystem.typographyLabelMedium),
          ),
        ],
      ),
    ],
  ),
)
```

### Badge with Status

```dart
Box(
  style: _isActive
      ? DesignSystem.badgeSuccess
      : _isWarning
          ? DesignSystem.badgeWarning
          : DesignSystem.badgeError,
  child: Text(
    _isActive ? 'Active' : _isWarning ? 'Low Stock' : 'Inactive',
    style: DesignSystem.typographyLabelSmall,
  ),
)
```

---

## ✅ Best Practices

1. **Always use tokens, never hardcode values**

   ```dart
   // ✅ Good
   color: DesignSystem.colorPrimary

   // ❌ Bad
   color: Color(0xFF1976D2)
   ```

2. **Use pre-built styles for common patterns**

   ```dart
   // ✅ Good
   Box(style: DesignSystem.buttonPrimary)

   // ❌ Bad
   Container(decoration: BoxDecoration(...))
   ```

3. **Leverage state colors for interactions**

   ```dart
   // ✅ Good
   color: _isHovered
       ? DesignSystem.getHoverColor(baseColor)
       : baseColor

   // ❌ Bad
   color: _isHovered ? Color(0xFFXXXXXX) : baseColor
   ```

4. **Use extension methods for convenience**

   ```dart
   // ✅ Good
   padding: EdgeInsets.all(context.spacingMedium)

   // ✅ Also Good
   padding: EdgeInsets.all(DesignSystem.spacingMedium)
   ```

5. **Respect typography hierarchy**

   ```dart
   // Use Headline1 for page titles
   Text('Dashboard', style: DesignSystem.typographyHeadline1)

   // Use BodyMedium for content
   Text('Description', style: DesignSystem.typographyBodyMedium)

   // Use LabelSmall for metadata
   Text('Last updated', style: DesignSystem.typographyLabelSmall)
   ```

---

## 🔗 Related Files

- **Design Tokens:** [lib/core/theme/design_system.dart](../lib/core/theme/design_system.dart)
- **Mix Theme Config:** [lib/core/theme/mix_theme.dart](../lib/core/theme/mix_theme.dart)
- **Fluent Integration:** [lib/core/theme/fluent_design.dart](../lib/core/theme/fluent_design.dart)
- **App Colors:** [lib/core/constants/app_colors.dart](../lib/core/constants/app_colors.dart)

---

## 📊 Integration Timeline

| Task                                | Status             |
| ----------------------------------- | ------------------ |
| Create design_system.dart           | ✅ Complete        |
| Create mix_theme.dart               | ✅ Complete        |
| 30 pre-built styles                 | ✅ Complete        |
| Color + Typography + Spacing tokens | ✅ Complete        |
| Extension methods                   | ✅ Complete        |
| Migration guide                     | ✅ Complete        |
| Test with sample widgets            | ⏳ Next Phase (P5) |

---

**Phase 3 Status:** ✅ COMPLETE

Ready for Phase 4 (ShadCN UI Components) or gradual migration to Phase 5 (Screen Refactoring).
