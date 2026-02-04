# 📱 Quick Reference: Responsive Design in Pasal Pro

**Phase 1 Complete** ✅ | Responsive system ready for Phase 2+ feature integration

---

## 🎯 Common Usage Patterns

### Pattern 1: Responsive Padding

```dart
// Simple responsive padding that adapts to screen size
Padding(
  padding: AppSpacing.responsivePadding(context),
  child: MyWidget(),
)

// Breakdown:
// - Small (≤1024px): 8px padding
// - Medium (1024-1366px): 12px padding
// - Large (1366-1920px): 16px padding (DEFAULT)
// - XLarge (≥1920px): 20px padding
```

### Pattern 2: Responsive Gap in Column/Row

```dart
// Vertical spacing that scales
Column(
  children: [
    FirstWidget(),
    AppSpacing.responsiveGap(context),  // 12-24px gap
    SecondWidget(),
    AppSpacing.responsiveGap(context),
    ThirdWidget(),
  ],
)
```

### Pattern 3: Custom Responsive Value

```dart
// Get any responsive value (number, color, widget, etc.)
final gridColumns = AppResponsive.getValue<int>(
  context,
  small: 2,      // 2 columns on small screens
  medium: 3,     // 3 columns on medium
  large: 4,      // 4 columns on large (1920px)
  xLarge: 6,     // 6 columns on 4K
);

// Use in GridView
GridView(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: gridColumns,
  ),
  children: products,
)
```

### Pattern 4: Conditional Layout by Breakpoint

```dart
// Show different layouts based on screen size
if (AppResponsive.isLarge(context)) {
  // Large screen: show 2 columns
  return Row(
    children: [LeftPanel(), RightPanel()],
  );
} else if (AppResponsive.isMedium(context)) {
  // Medium screen: show stacked
  return Column(
    children: [TopPanel(), BottomPanel()],
  );
} else {
  // Small screen: minimize
  return CompactView();
}
```

### Pattern 5: Responsive Typography

```dart
// Heading that scales based on viewport
Text(
  'Product List',
  style: TextStyle(
    fontSize: AppResponsive.getResponsiveHeadingFontSize(context),  // 24-36px
    fontWeight: FontWeight.bold,
  ),
)

// Body text
Text(
  'Product description',
  style: TextStyle(
    fontSize: AppResponsive.getResponsiveBodyFontSize(context),  // 14-16px
  ),
)
```

### Pattern 6: Responsive Card Padding

```dart
// Card with responsive internal spacing
Card(
  child: Padding(
    padding: AppSpacing.responsivePadding(context),
    child: Column(
      children: [
        Text('Title'),
        AppSpacing.responsiveGap(context),
        Text('Description'),
      ],
    ),
  ),
)
```

### Pattern 7: Max Width Container (Prevent text from stretching)

```dart
// Keep content readable on ultra-wide screens
SizedBox(
  width: AppResponsive.getResponsiveMaxContentWidth(context),  // Max 1600px
  child: Text('Very long text stays readable'),
)
```

### Pattern 8: Responsive Grid Item Size

```dart
// Product grid that adapts to screen
GridView.builder(
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: AppResponsive.getResponsiveGridItemWidth(context),  // 150-240px
    childAspectRatio: 1,
  ),
  itemBuilder: (context, index) => ProductCard(products[index]),
  itemCount: products.length,
)
```

---

## 🔍 Breakpoint Decision Matrix

| Use Case            | Check                                      | Code                  |
| ------------------- | ------------------------------------------ | --------------------- |
| Large screen only   | `AppResponsive.isLarge(context)`           | Show 2-column layout  |
| Small screen only   | `AppResponsive.isSmall(context)`           | Show compact view     |
| Any desktop (1366+) | `!AppResponsive.isSmall(context)`          | Show expanded toolbar |
| 4K monitor check    | `AppResponsive.is4K(context)`              | Premium high-res UI   |
| Get name for log    | `AppResponsive.getBreakpointName(context)` | Debug responsive      |

---

## 📦 Available Methods Reference

### Detection

```dart
AppResponsive.isSmall(context)        // ≤1024px
AppResponsive.isMedium(context)       // 1024-1366px
AppResponsive.isLarge(context)        // 1366-1920px (PRIMARY)
AppResponsive.isXLarge(context)       // ≥1920px
AppResponsive.is4K(context)           // ≥2560px
```

### Generic Getter

```dart
AppResponsive.getValue<T>(
  context,
  small: valueA,
  medium: valueB,
  large: valueC,
  xLarge: valueD,
)
```

### Typography

```dart
AppResponsive.getResponsiveBodyFontSize(context)      // 14-16px
AppResponsive.getResponsiveHeadingFontSize(context)   // 24-36px
```

### Layout

```dart
AppResponsive.getResponsiveContentPadding(context)        // 16-32px
AppResponsive.getResponsiveSpaceBetweenSections(context)  // 24-48px
AppResponsive.getResponsiveCornerRadius(context)          // 8-16px
AppResponsive.getResponsiveMaxContentWidth(context)       // 600-1600px
```

### Grids

```dart
AppResponsive.getResponsiveColumnCount(context)      // 2-6 columns
AppResponsive.getResponsiveGridItemWidth(context)    // 150-240px
```

### Spacing

```dart
AppSpacing.responsivePadding(context)                 // All sides
AppSpacing.responsiveSymmetricPadding(context)        // H or V
AppSpacing.responsiveGap(context)                     // Use in Column/Row
```

### Debug

```dart
AppResponsive.getBreakpointName(context)             // 'mobile'/'tablet'/'desktop'/'tv'
AppResponsive.debugPrintScreenInfo(context)          // Prints "📱 Screen: 1920×1080px | Breakpoint: desktop"
```

---

## 🎨 Responsive Value Presets

### Padding Values

```
Small:   8px  (safe minimum)
Medium:  12px
Large:   16px (default, 24" monitor)
XLarge:  20px (4K monitors)
```

### Gap Values

```
Small:   12px
Medium:  16px
Large:   20px (default)
XLarge:  24px
```

### Font Sizes

Body: 14→14→15→16px  
Heading: 24→28→32→36px

### Grid Columns

Small: 2 | Medium: 3 | Large: 4 | XLarge: 6

### Corner Radius

Small: 8px | Medium: 12px | Large: 12px | XLarge: 16px

---

## ⚠️ Common Mistakes

❌ **Don't:**

```dart
// Hardcoding values
Padding(
  padding: EdgeInsets.all(16),  // Doesn't respond to screen size!
)

// Using breakpoints you haven't checked exist
if (AppResponsive.isHuge(context)) { }  // This method doesn't exist!

// Getting value with named parameter named 'context'
AppResponsive.getValue(
  small: 10,          // ❌ Missing context parameter!
  medium: 15,
)
```

✅ **Do:**

```dart
// Use responsive helpers
Padding(
  padding: AppSpacing.responsivePadding(context),  // Scales!
)

// Check only existing breakpoints
if (AppResponsive.isLarge(context)) { }

// Always provide context parameter
AppResponsive.getValue<int>(
  context: context,   // ✅ Explicit
  small: 10,
  medium: 15,
  large: 20,
  xLarge: 25,
)
```

---

## 🚀 Example: Complete Responsive Widget

```dart
class ResponsiveProductList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return products.when(
      data: (items) {
        final gridColumns = AppResponsive.getValue<int>(
          context,
          small: 1,
          medium: 2,
          large: 3,
          xLarge: 4,
        );

        return Padding(
          padding: AppSpacing.responsivePadding(context),
          child: Column(
            children: [
              Text(
                'Products',
                style: TextStyle(
                  fontSize: AppResponsive.getResponsiveHeadingFontSize(context),
                ),
              ),
              AppSpacing.responsiveGap(context),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridColumns,
                ),
                itemBuilder: (context, index) => ProductCard(items[index]),
                itemCount: items.length,
              ),
            ],
          ),
        );
      },
      error: (error, _) => Text('Error: $error'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
```

---

## 📊 Test Your Implementation

### Manual Testing Checklist

- [ ] Open app at 1024px width (Small) - verify compact layout
- [ ] Resize to 1366px (Medium) - verify spacing increases
- [ ] Resize to 1920px (Large) - verify default layout (PRIMARY)
- [ ] Resize to 2560px (XLarge) - verify premium spacing
- [ ] Text remains readable at all sizes
- [ ] No overflow errors during resize
- [ ] Animations remain smooth

### Debug Output

```dart
// Add to your build method temporarily:
AppResponsive.debugPrintScreenInfo(context);

// Output:
// 📱 Screen: 1920×1080px | Breakpoint: desktop
```

---

## 🔗 When to Start Using (Phase 2+)

**Now (Phase 1):** Foundation complete ✅
**Phase 2:** Start using in ProductCard, Dashboard widgets  
**Phase 3+:** Apply to all 20+ screens

**Import in any widget:**

```dart
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
```

---

**Last Updated:** Phase 1 Complete ✅  
**Next:** Phase 2 - Fluent UI integration (2-3 days)
