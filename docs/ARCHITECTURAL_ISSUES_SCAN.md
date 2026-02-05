# 🔍 Architectural Issues Scan - Design System Non-Compliance

**Scan Date:** February 5, 2026  
**Scope:** All main feature pages + core widgets  
**Issue Type:** Inconsistent Mix design token usage patterns  
**Status:** Identifying best practices for token usage

---

## 📋 Architecture Clarification

**Correct Approach:**

```dart
// ✅ CORRECT: Use Mix design tokens in UI code
color: PasalColorToken.background.token.resolve(context),
color: PasalColorToken.textSecondary.token.resolve(context),
color: PasalColorToken.primary.token.resolve(context),
```

**Incorrect Approach:**

```dart
// ❌ WRONG: Direct hardcoded AppColors in UI (bypasses design system)
color: AppColors.background,
color: AppColors.textSecondary,
color: AppColors.primaryBlue,
```

**Design System Flow:**

```
Mix Design Tokens (UI)
  ↓ resolve via .token.resolve(context)
Mix Theme Definition (mix_theme.dart)
  ↓ maps to
AppColors Constants (actual color values)
```

The Mix design system allows for:

- Theme switching (light/dark via mix_theme.dart)
- Centralized semantic colors (all colors controlled in one place)
- Responsive design token resolution

---

## 🔴 HIGH PRIORITY - Token Usage Patterns

### Pattern Issues Found

**Issue 1: Inconsistent Color Token Resolution**

Some pages resolve tokens in `didChangeDependencies()`:

```dart
// ✅ Products Page pattern (stores in late fields)
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _textPrimary = PasalColorToken.textPrimary.token.resolve(context);
  _textSecondary = PasalColorToken.textSecondary.token.resolve(context);
}
```

Others resolve inline in build:

```dart
// ✅ Customers Page pattern (direct resolution)
color: PasalColorToken.primary.token.resolve(context),
```

**Best Practice:** Both approaches are valid, but code should be consistent within a page/feature.

---

### Pattern Issues by Page

| Page        | File                    | Pattern Issue                                     | Priority  |
| ----------- | ----------------------- | ------------------------------------------------- | --------- |
| Daily Sales | `fast_sale_page.dart`   | ✅ CLEAN - Inline token resolution                | ✅ DONE   |
| Products    | `products_page.dart`    | Late field resolution (works but stores in build) | 🟠 REVIEW |
| Customers   | `customers_page.dart`   | Mix of inline + late fields                       | 🟠 REVIEW |
| Settings    | `settings_page.dart`    | Some inline, some not resolved at all             | 🟠 REVIEW |
| Sales Form  | `sales_entry_form.dart` | ✅ Uses didChangeDepend for color resolution      | ✅ CLEAN  |
| Sales Log   | `daily_sales_log.dart`  | ✅ Uses inline resolution throughout              | ✅ CLEAN  |

---

## ✅ Already Compliant (Using Mix Design System Correctly)

### Daily Sales Page ✅ COMPLETE

**Files:**

- `lib/features/sales/presentation/pages/fast_sale_page.dart`
- `lib/features/sales/presentation/widgets/sales_entry_form.dart`
- `lib/features/sales/presentation/widgets/daily_sales_log.dart`

**Pattern:**

```dart
// Directly resolve tokens in build/didChangeDependencies
color: PasalColorToken.background.token.resolve(context),
color: PasalColorToken.surface.token.resolve(context),
color: PasalColorToken.textSecondary.token.resolve(context),
```

**Benefits:**

- All colors automatically update with theme changes
- Respects user's light/dark mode preference
- No hardcoded values

**Quality Results:**

- ✅ Analysis: 0 issues
- ✅ Tests: 83/83 passing

---

## 🔍 Secondary Issues (Not Blocking)

### 1. Inconsistent Spacing Patterns

Some pages use:

- `const SizedBox(width: 16)` - Magic numbers
- `AppSpacing.medium` - From centralized constants
- `SalesSpacing.formSectionGap` - Feature-specific constants

**Recommendation:** Should use `AppSpacing` or feature-specific constants consistently.

### 2. Late Color Field Pattern (Products Page)

**Current Pattern:**

```dart
class _ProductsPageState extends ConsumerState<ProductsPage> {
  // Mix design token colors (set in build)
  late Color _bgColor;
  late Color _surfaceColor;
  late Color _primaryColor;

  @override
  Widget build(BuildContext context) {
    _bgColor = PasalColorToken.background.token.resolve(context);
    _surfaceColor = PasalColorToken.surface.token.resolve(context);
    // ... more setup
  }
}
```

**Issues:**

- Late fields are resolved every build (could use `didChangeDependencies`)
- Variables are stored in state (could use local variables)
- Not necessarily wrong, but less efficient pattern

**Better Pattern:**

```dart
// Option 1: Direct inline (like Daily Sales)
color: PasalColorToken.background.token.resolve(context),

// Option 2: didChangeDependencies + late (like Sales Form)
late Color _bgColor;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _bgColor = PasalColorToken.background.token.resolve(context);
}
```

---

## 📋 Pages Status Summary

| Page        | Status          | Design System | Token Usage           | Notes                  |
| ----------- | --------------- | ------------- | --------------------- | ---------------------- |
| Daily Sales | ✅ COMPLIANT    | Mix           | Inline                | Clean implementation   |
| Sales Form  | ✅ COMPLIANT    | Mix           | didChangeDependencies | Proper pattern         |
| Sales Log   | ✅ COMPLIANT    | Mix           | Inline                | Fully consistent       |
| Products    | 🟠 NEEDS REVIEW | Mix           | Late fields in build  | Works but not optimal  |
| Customers   | 🟠 NEEDS REVIEW | Mix           | Mixed patterns        | Should standardize     |
| Settings    | 🟠 NEEDS REVIEW | Mix           | Partial usage         | Some hardcoded spacing |
| Cheques     | ❓ TBD          | ?             | ?                     | Not yet scanned        |
| Dashboard   | ✅ Likely OK    | Mix           | ?                     | Phase 7 might be good  |

---

## 🎯 Recommended Actions

### Priority 1: Standardize Token Resolution Pattern

Choose one approach and apply consistently across codebase:

**Option A: Inline Resolution (Simplest)**

```dart
@override
Widget build(BuildContext context) {
  return Container(
    color: PasalColorToken.background.token.resolve(context),
    // ... more widgets
  );
}
```

**Option B: didChangeDependencies + Late Fields**

```dart
late Color _backgroundColor;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _backgroundColor = PasalColorToken.background.token.resolve(context);
}

@override
Widget build(BuildContext context) {
  return Container(
    color: _backgroundColor,
    // ... more widgets
  );
}
```

### Priority 2: Consolidate Spacing Constants

- [ ] Review all `const SizedBox/EdgeInsets` usage
- [ ] Replace with `AppSpacing` or `SalesSpacing` constants
- [ ] Option: Create feature-specific spacing in each feature if needed

### Priority 3: Document Pattern in Code Standard

Add to DEVELOPMENT.md:

```markdown
## Design Token Usage

Always use Mix design tokens via context resolution.
Choose one pattern and stick with it across your page:

### Pattern A: Inline (Preferred for simple pages)

\`\`\`dart
color: PasalColorToken.primary.token.resolve(context)
\`\`\`

### Pattern B: didChangeDependencies (For complex pages with many tokens)

Resolve once in didChangeDependencies and store in late fields.
\`\`\`
```

---

## ❌ What NOT To Do

```dart
// ❌ DON'T: Hardcode AppColors in UI code
color: AppColors.background

// ❌ DON'T: Use hardcoded Material colors
color: Colors.grey[100]

// ❌ DON'T: Use hardcoded icons
icon: Icons.home

// ❌ DON'T: Use hardcoded spacing
SizedBox(width: 16)
```

---

## 📚 Reference Files

- **Mix Theme Definition:** `lib/core/theme/mix_theme.dart` - Maps tokens to AppColors
- **Design Tokens:** `lib/core/theme/mix_tokens.dart` - Token definitions
- **Color Constants:** `lib/core/constants/app_colors.dart` - Actual color values
- **Spacing Constants:** `lib/core/constants/app_spacing.dart` - Spacing values
- **Reference Implementation:** `lib/features/sales/` (Daily Sales feature)

---

## ✨ Benefits of Proper Token Usage

1. **Theme Switching:** Change light/dark colors in one place (mix_theme.dart)
2. **Consistency:** All pages use same semantic colors
3. **Accessibility:** Can ensure contrast ratios in theme definition
4. **Maintainability:** No scattered hardcoded values
5. **Type Safety:** Tokens provide IDE autocomplete

---

## 🔗 Related Decisions

- **Decision:** Keep Mix design system as single source of truth
- **Rationale:** Provides theme switching capability + semantic colors
- **Alternative Considered:** Direct AppColors usage (rejected - bypasses theming)

**Last Updated:** February 5, 2026 | **Status:** Revised - Focus on pattern consistency, not replacement

---

## 🔴 HIGH PRIORITY - Immediate Fixes Needed

### 1. Products Page

**File:** `lib/features/products/presentation/pages/products_page.dart`  
**Lines:** 25-55 (color token resolution in late fields)

**Issues:**

- Lines 25-35: Storing colors in late variables from Mix tokens:
  ```dart
  late Color _bgColor;
  late Color _surfaceColor;
  late Color _primaryColor;
  late Color _borderColor;
  late Color _textPrimary;
  late Color _textSecondary;
  late Color _errorColor;
  ```
- Lines 47-54: Resolving Mix tokens in build():
  ```dart
  _bgColor = PasalColorToken.background.token.resolve(context);
  _surfaceColor = PasalColorToken.surface.token.resolve(context);
  // ... 6 more line resolutions
  ```
- Used throughout build as `_bgColor`, `_surfaceColor`, etc.

**Solution:**

1. Remove all late color fields
2. Replace `PasalColorToken.*` imports with `AppColors`
3. Use `AppColors.*` directly in widgets (no late field resolution needed)
4. Same approach as Daily Sales page fix

**Expected Changes:**

- ~40 lines edited (remove late fields + update uses)
- 2 file imports changed
- Result: Zero Mix token usage, pure AppColors

---

### 2. Customers Page

**File:** `lib/features/customers/presentation/pages/customers_page.dart`  
**Lines:** Multiple locations with purple background issue

**Issues:**

- **Purple Background Bug:** Line 38 uses `PasalColorToken.surfaceAlt` same as Daily Sales had
  ```dart
  color: PasalColorToken.surfaceAlt.token.resolve(context),
  ```
- **Hardcoded Material Icons:** Line ~220+
  ```dart
  icon: Icons.people_outline,  // ❌ Should be AppIcons.users or similar
  ```
- **Hardcoded Spacing:** Multiple instances
  ```dart
  const EdgeInsets.all(20)  // Line 220
  const SizedBox(height: 16)  // Multiple
  ```
- **Mix Token Colors:** Throughout
  ```dart
  color: PasalColorToken.primary.token.resolve(context)
  color: PasalColorToken.textPrimary.token.resolve(context)
  ```

**Solution:**

1. Replace `PasalColorToken.surfaceAlt` → `AppColors.background` (fix purple)
2. Replace all `Icons.*` → `AppIcons.*`
3. Replace `const EdgeInsets` → `AppSpacing` or responsive equivalents
4. Replace all Mix token usage with AppColors

**Expected Changes:**

- ~60 lines edited
- 2 file imports changed
- Result: White/neutral background, all design system constants

**High Impact:** This page had same purple background issue as Daily Sales - user-facing bug

---

## 🟠 MEDIUM PRIORITY

### 3. Settings Page

**File:** `lib/features/settings/presentation/pages/settings_page.dart`  
**Lines:** Multiple (100+ hardcoded icons scattered)

**Issues:**

- **Hardcoded Material Icons:** ~20+ instances
  ```dart
  icon: Icons.business_outlined,      // Line 35
  icon: Icons.store_outlined,         // Line 38
  icon: Icons.location_on_outlined,   // Line 48
  icon: Icons.phone_outlined,         // Line 58
  icon: Icons.receipt_outlined,       // Line 68
  icon: Icons.settings_outlined,      // Line 84
  icon: Icons.palette_outlined,       // Line 87
  icon: Icons.language_outlined,      // Line 97
  icon: Icons.currency_rupee,         // Line 109
  icon: Icons.notifications_outlined, // Line 114
  icon: Icons.insert_chart_outlined,  // Line 127
  icon: Icons.cloud_outlined,         // Line 145
  icon: Icons.sync_outlined,          // Line 148
  icon: Icons.backup_outlined,        // Line 161
  icon: Icons.restore_outlined,       // Line 169
  icon: Icons.download_outlined,      // Line 175
  icon: Icons.info_outlined,          // Line 189
  icon: Icons.description_outlined,   // Line 194
  icon: Icons.privacy_tip_outlined,   // Line 199
  icon: Icons.help_outline,           // Line 204
  ```
- **Mix Token Colors:** ~10+ instances
  ```dart
  color: PasalColorToken.primary.token.resolve(context)        // Lines 370, 385, 587, 594, 666, 682, 698
  color: PasalColorToken.textPrimary.token.resolve(context)    // Line 608
  color: PasalColorToken.textSecondary.token.resolve(context)  // Line 616
  ```
- **Hardcoded Spacing:**
  ```dart
  const SizedBox(height: 16)  // Lines 80, 141, 182
  const EdgeInsets.all(12)    // Line 585
  const SizedBox(width: 16)   // Line 598
  const SizedBox(height: 2)   // Line 611
  ```
- **Mix Token Background:** Line 19
  ```dart
  final bgColor = PasalColorToken.background.token.resolve(context);
  ```

**Solution:**

1. Remove background token resolution, use `AppColors.background` directly
2. Map Material Icons → AppIcons (many 1:1 mappings exist)
3. Replace Mix tokens with AppColors
4. Replace hardcoded spacing with AppSpacing

**Mapping Guide:**

```
Icons.business_outlined      → AppIcons.store
Icons.store_outlined         → AppIcons.store
Icons.location_on_outlined   → AppIcons.mapPin (if available) or custom
Icons.phone_outlined         → AppIcons.phone
Icons.receipt_outlined       → AppIcons.receipt
Icons.settings_outlined      → AppIcons.settings
Icons.palette_outlined       → AppIcons.palette
Icons.language_outlined      → AppIcons.globeAlt (if available)
Icons.currency_rupee         → AppIcons.rupee
Icons.notifications_outlined → AppIcons.bell (if available) or notification
Icons.insert_chart_outlined  → AppIcons.barChart or analytics
Icons.cloud_outlined         → AppIcons.cloud
Icons.sync_outlined          → AppIcons.sync
Icons.backup_outlined        → AppIcons.backup
Icons.restore_outlined       → AppIcons.restore
Icons.download_outlined      → AppIcons.download
Icons.info_outlined          → AppIcons.info
Icons.description_outlined   → AppIcons.fileText or document
Icons.privacy_tip_outlined   → AppIcons.shield
Icons.help_outline           → AppIcons.help
```

**Expected Changes:**

- ~100 lines with icon replacements
- ~10 Mix token replacements
- ~5 spacing replacements
- Result: All centralized, future theme changes affect entire page

---

### 4. Product Form Page

**File:** `lib/features/products/presentation/pages/product_form_page.dart`  
**Lines:** 77-94

**Issues:**

- **Mix Token Colors:** Lines 77-78
  ```dart
  final bgColor = PasalColorToken.background.token.resolve(context);
  final surfaceColor = PasalColorToken.surface.token.resolve(context);
  ```
- **Hardcoded Material Icon:** Line 86
  ```dart
  icon: const Icon(Icons.close),  // Should use AppIcons.close
  ```
- **Mix Token in Widget:** Line 94
  ```dart
  color: PasalColorToken.textPrimary.token.resolve(context),
  ```

**Solution:**

1. Replace token resolution with direct `AppColors.*` usage
2. Replace `Icons.close` → `AppIcons.close`
3. Similar to Products page approach

**Expected Changes:**

- ~20 lines edited
- Result: No Mix token usage in form

---

## 🟡 LOW PRIORITY - Scan Required

These pages may have similar issues but require detailed inspection:

### 5. **Cheques Page**

**File:** `lib/features/cheques/presentation/pages/cheques_page.dart`  
**Status:** Not yet scanned  
**Action:** Run grep scan for Mix tokens and hardcoded values

### 6. **Dashboard Page**

**File:** `lib/features/dashboard/presentation/pages/dashboard_page.dart`  
**Status:** Not yet scanned (Phase 7 recently completed)  
**Action:** Already uses AppColors in some places - full scan needed

### 7. **Core Widgets**

**File:** `lib/core/widgets/app_navigation_rail.dart`  
**Line:** 45+  
**Issue:** Uses Mix tokens for color resolution  
**Impact:** Navigation rail affects all pages

---

## ✅ Already Fixed

### Daily Sales Page ✅ COMPLETE

**File:** `lib/features/sales/presentation/pages/fast_sale_page.dart`  
**Changes Applied:**

- ✅ Removed `PasalColorToken.surfaceAlt` (purple background bug fixed)
- ✅ Replaced 9 hardcoded `Colors.grey` with `AppColors` equivalents
- ✅ Replaced `Icons.point_of_sale` with `AppIcons.shoppingCart`
- ✅ Replaced all hardcoded spacing with `AppSpacing` constants
- ✅ Removed Mix token imports

**Widget Files Also Fixed:**

- ✅ `sales_entry_form.dart` - Removed Mix tokens, uses AppColors
- ✅ `daily_sales_log.dart` - Replaced all `Colors.grey` with `AppColors`

**Quality Results:**

- ✅ Analysis: 0 issues
- ✅ Tests: 83/83 passing

---

## 📊 Issue Statistics

| Category                       | Count | Severity                      |
| ------------------------------ | ----- | ----------------------------- |
| Mix Token usages               | 25+   | High (blocks design changes)  |
| Hardcoded Material Icons       | 30+   | High (breaks consistency)     |
| Hardcoded Colors (grey values) | 15+   | High (blocks theme switching) |
| Hardcoded EdgeInsets/SizedBox  | 40+   | Medium (maintainability)      |
| Pages affected                 | 6-7   | -                             |

---

## 🛠️ Remediation Plan

### Phase 1: High Priority (Days 1-2)

1. **Products Page** (~40 min)
   - Remove late color fields
   - Replace Mix tokens with AppColors
   - Update imports

2. **Customers Page** (~45 min)
   - Fix purple background bug (same root cause as Daily Sales)
   - Replace all Mix tokens
   - Replace Material Icons with AppIcons
   - Fix hardcoded spacing

### Phase 2: Medium Priority (Day 2-3)

3. **Settings Page** (~90 min)
   - Replace 20+ hardcoded Material Icons
   - Remove Mix token usage
   - Fix spacing

4. **Product Form Page** (~30 min)
   - Simple token replacements
   - Icon mapping

### Phase 3: Low Priority (Day 3+)

5. **Cheques Page** - Scan + fix
6. **Dashboard Page** - Verify (may already be compliant)
7. **Core Widgets** - Navigation rail Update

---

## ✨ Benefits of Remediation

### For Users

- **Customers Page:** Purple background will be fixed (visual bug)
- Consistent styling across all pages
- Easy theme/color scheme changes in future

### For Developers

- Single source of truth for colors/icons/spacing
- No more "where is this color defined?" searches
- Less merge conflicts when updating design system
- Easier to add dark mode

### For Codebase

- 0 hardcoded values (architectural standard enforced)
- All tests still pass (no behavior changes)
- Code review checklist item: "No hardcoded colors/icons/spacing"

---

## 📝 Architectural Standard (Enforced)

All Flutter pages MUST follow this pattern:

❌ **Don't:**

```dart
color: PasalColorToken.surface.token.resolve(context)
icon: Icons.point_of_sale
padding: const EdgeInsets.all(16)
color: Colors.grey[100]
```

✅ **Do:**

```dart
color: AppColors.surface
icon: AppIcons.shoppingCart
padding: EdgeInsets.all(AppSpacing.medium)
color: AppColors.gray100
```

---

## 📚 Reference

- [AppColors](../../lib/core/constants/app_colors.dart) - 50+ color constants
- [AppIcons](../../lib/core/constants/app_icons.dart) - 65+ icon definitions
- [AppSpacing](../../lib/core/constants/app_spacing.dart) - 7 standardized spacing values
- [Daily Sales Fix](fast_sale_page.dart) - Reference implementation ✅

---

## 🔗 Related Issues

- **Yellow Card:** Mix tokens causing confusion (page background colors inconsistent)
- **Tech Debt:** Late color fields pattern in Products/Settings pages (anti-pattern)
- **Future:** Consider removing Mix token system entirely if not used in Material widgets

**Last Updated:** February 5, 2026  
**Status:** Scan & High Priority fixes in progress
padding: EdgeInsets.all(AppSpacing.medium)
color: AppColors.gray100

```

---

## 📚 Reference

- [AppColors](../../lib/core/constants/app_colors.dart) - 50+ color constants
- [AppIcons](../../lib/core/constants/app_icons.dart) - 65+ icon definitions
- [AppSpacing](../../lib/core/constants/app_spacing.dart) - 7 standardized spacing values
- [Daily Sales Fix](fast_sale_page.dart) - Reference implementation ✅

---

## 🔗 Related Issues

- **Yellow Card:** Mix tokens causing confusion (page background colors inconsistent)
- **Tech Debt:** Late color fields pattern in Products/Settings pages (anti-pattern)
- **Future:** Consider removing Mix token system entirely if not used in Material widgets

**Last Updated:** February 5, 2026
**Status:** Scan & High Priority fixes in progress
```
