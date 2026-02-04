# Pasal Pro: Modern Desktop UI Proposal

**Design Approach:** Modern Flat + Minimal + Beautiful (NOT Material 3 default)  
**Target Platform:** Windows/Linux/macOS with Navigation Rail  
**Research Base:** 18 modern POS apps analyzed, 2024-2025 design trends

---

## 🎨 Overall Visual Direction

### Design Philosophy

```
Modern ━━━━━━━━━ Clean ━━━━━━━━━ Minimal
  │                 │               │
  └─ Ultra-flat     └─ Purposeful   └─ High contrast
  └─ Bold colors    └─ No clutter   └─ Bold accents
  └─ Delightful     └─ Generous     └─ Keyboard-first
```

**What This Means:**

- No heavy shadows; use 1px borders for definition
- 4-5 color accents total (no rainbow)
- Every button/interaction has a purpose
- Plenty of whitespace between sections
- Keyboard shortcuts for power users (F1, F2, F3, etc.)

---

## 📐 Desktop Layout Architecture

### Main Structure

```
┌─────────────────────────────────────────────────────────────────────────┐
│ AppBar (48px)  | Search | Global Actions | Sync Status | User Menu     │
├─────┬───────────────────────────────────────────────────────────────────┤
│     │                                                                   │
│  72 │  MAIN WORKSPACE                                                 │
│  px │  (Fast Sale / Dashboard / Products / Customers / Cheques)       │
│  ━━ │                                                                   │
│     │                                                                   │
│  F1 │  ┏━━━━━━━━━━━━━━━━━━┓                                           │
│ ━━━ │  ┃ Fast Sale        ┃ ← Active screen                           │
│     │  ┗━━━━━━━━━━━━━━━━━━┛                                           │
│  F2 │                                                                   │
│ ━━━ │                                                                   │
│     │                                                                   │
│  F3 │                                                                   │
│ ━━━ │                                                                   │
│     │                                                                   │
│  F4 │                                                                   │
│ ━━━ │                                                                   │
│     │                                                                   │
│  F5 │                                                                   │
│ ━━━ │                                                                   │
│     │                                                                   │
│ ─── │                                                                   │
│ Set │                                                                   │
│ ─── │                                                                   │
│ Hlp │                                                                   │
└─────┴───────────────────────────────────────────────────────────────────┘

Rail: Fixed width 72px (icons) | Expandable to 280px (with labels)
Main: Responsive, max-width 1400px, margins 24px
AppBar: Fixed height 48px, sticky
```

### Navigation Rail Destinations

**Primary (Top Section):**

```
F1 ━━ Fast Sale    (Rupee icon)         ← Default landing
F2 ━━ Dashboard    (Chart Line icon)    ← Metrics at-a-glance
F3 ━━ Products     (Package icon)       ← Inventory CRUD
F4 ━━ Customers    (Users icon)         ← Ledger & credit
F5 ━━ Cheques      (File Check icon)    ← Cheque tracking
```

**Secondary (Bottom Section):**

```
F6 ━━ Reports      (Bar Chart icon)
─── ─────────────────────────────
Set ━ Settings     (Settings icon)
Hlp ━ Help         (Help Circle icon)
```

**Visual Style:**

- Background: White (#FFFFFF)
- Border-right: 1px #E5E7EB
- Icons: 24px, lucide_icons_flutter
- Icon inactive: Gray (#9CA3AF)
- Icon active: Vibrant Blue (#3B82F6)
- Active indicator: 3px left border (blue)
- Label: 12px, weight 600, all-caps (when expanded)
- Hover: Light gray background (#F3F4F6), 150ms transition

---

## 🎯 Screen Designs

### Screen 1: Fast Sale (Primary Money Screen)

**Goal:** Enter a sale in 2-5 seconds  
**Layout:** 3-panel optimized for desktop

```
┌─────────────────────────────────────────┬────────────┬──────────────┐
│ PANEL A: Product Search & List          │ PANEL B:   │ PANEL C:     │
│                                         │ Cart       │ Totals &     │
├─────────────────────────────────────────┤ Items      │ Payment      │
│                                         │            │              │
│ [Search Products...] 🔍                 │ ┌────────┐ │ Subtotal:    │
│                                         │ │Product │ │ Rs 5,000     │
│ Recent Products:                        │ │Qty: 5  │ │              │
│ ┌─────────────────────────────────────┐ │ │Price:  │ │ Profit:      │
│ │ Product A      100 pcs    Rs 100 ea │ │ │Rs 100  │ │ +1000 ✨     │
│ └─────────────────────────────────────┘ │ │Profit: │ │              │
│                                         │ │+100    │ │ Total:       │
│ ┌─────────────────────────────────────┐ │ └────────┘ │ Rs 5,000     │
│ │ Product B      50 pcs     Rs 200 ea │ │            │              │
│ └─────────────────────────────────────┘ │ ┌────────┐ │ Payment:     │
│                                         │ │Product │ │ ○ Cash       │
│ All Products (Search Filter/Sort):      │ │Qty: 2  │ │ ○ Credit     │
│ ┌─────────────────────────────────────┐ │ │Price:  │ │              │
│ │ Product C      200 pcs    Rs 50 ea  │ │ │Rs 200  │ │ [Save & Print]
│ └─────────────────────────────────────┘ │ │Profit: │ │              │
│                                         │ │+400    │ │              │
│ ┌─────────────────────────────────────┐ │ └────────┘ │              │
│ │ Product D      75 pcs     Rs 150 ea │ │            │              │
│ └─────────────────────────────────────┘ │ [Clear All]│              │
│                                         │            │              │
└─────────────────────────────────────────┴────────────┴──────────────┘

Interaction Flow:
1. Type in search → filtered list updates (real-time)
2. Click product → quantity input appears (inline, no modal)
3. Type quantity → profit chip updates in real-time
4. Press Enter OR click Add → item added to cart
5. Repeat steps 1-4 for each item
6. Select payment method (Cash / Credit)
7. Click "Save & Print" → transaction recorded, stock decremented
```

**Design Details:**

- Panel A width: 40% (or 280px min)
- Panel B width: 25% (or 200px min)
- Panel C width: 35% (or 280px min)
- Profit chip: Large (24px bold), green (#10B981)
- Search bar: Always focused on load
- Recent products: Sticky at top, horizontally scrollable chips
- Cart items: Editable inline (qty field)
- Keyboard shortcuts:
  - F1 → Focus search
  - Number keys → Qty input
  - Enter → Add to cart
  - Ctrl+S → Save & Print

**Color Coding:**

- Profit: Green (#10B981)
- Loss: Red (#EF4444) — if selling below cost

---

### Screen 2: Dashboard (Owner View)

**Goal:** At-a-glance business metrics  
**Layout:** Metric cards in grid

```
┌──────────────────────────────────────────────────────────────┐
│                   DASHBOARD                                 │
├──────────────────┬──────────────────┬──────────────────┐     │
│ 📊 Today Sales   │ 💰 Today Profit  │ 📦 Low Stock     │     │
│                  │                  │                  │     │
│ Rs 45,230        │ Rs 12,450        │ 5 items          │     │
│ ↑ 12% vs Yday    │ ↑ 18% vs Yday    │ Action needed    │     │
└──────────────────┴──────────────────┴──────────────────┘     │
                                                               │
├──────────────────┬──────────────────┬──────────────────┐     │
│ 💳 Cash in Hand  │ 📋 Credit Due    │ ✓ Tasks Complete │     │
│                  │                  │                  │     │
│ Rs 22,000        │ Rs 15,000        │ 3 pending        │     │
│ Based on sales   │ From customers   │ [View]           │     │
└──────────────────┴──────────────────┴──────────────────┘     │
                                                               │
├─────────────────────────────────────────────────────────┐   │
│ RECENT SALES (Last 10)                                  │   │
├─────────────────────────────────────────────────────────┤   │
│ Product A    | Qty 5   | Total Rs 500   | Profit +100   │   │
│ Product B    | Qty 2   | Total Rs 400   | Profit +200   │   │
│ Product C    | Qty 10  | Total Rs 1000  | Profit +500   │   │
└─────────────────────────────────────────────────────────┘   │
                                                               │
├──────────────────────────────────────────────────────────┐  │
│ LOW STOCK ALERTS                                         │  │
├──────────────────────────────────────────────────────────┤  │
│ ⚠️ Product X: Only 5 pcs left (threshold: 20)          │  │
│ ⚠️ Product Y: Only 2 cartons left (threshold: 5)       │  │
│ ⚠️ Product Z: Out of stock!                            │  │
└──────────────────────────────────────────────────────────┘  │
```

**Metric Card Design:**

```
┌──────────────────┐
│ 📊 Today Sales   │  ← Icon (32px, blue #3B82F6)
│                  │
│ Rs 45,230        │  ← Value (28px, bold, #1F2937)
│                  │
│ ↑ 12% vs Yday    │  ← Meta (12px, gray #6B7280)
└──────────────────┘

Card styling: Card widget, 1px border #E5E7EB, 12px radius, 16px padding
Icon color: Blue for neutral, Green for profit, Red for loss
```

**Components:**

- Top row: 3 metric cards (sales, profit, low stock)
- Second row: 3 metric cards (cash, credit, tasks)
- Recent sales: Table/list (last 10 transactions)
- Low stock alerts: List with warning icons
- All colors: Theme-driven, no hardcoded hex

---

### Screen 3: Products (Inventory CRUD)

**Goal:** Manage product catalog  
**Layout:** Search + list + detail panel

```
┌──────────────────────┬─────────────────────────────────┐
│ PRODUCT SEARCH       │ PRODUCT LIST                    │
├──────────────────────┤                                 │
│ [Search by name...]  │ ┌─────────────────────────────┐ │
│                      │ │ Product A                    │ │
│ FILTERS              │ │ Cost: Rs 50 | Sell: Rs 100   │ │
│                      │ │ Stock: 50 pcs (6 cartons)    │ │
│ ○ Low Stock          │ │ Margin: 100%                 │ │
│ ○ In Stock           │ │ [Edit] [Delete]              │ │
│ ○ Out of Stock       │ └─────────────────────────────┘ │
│                      │                                 │
│ SORT BY              │ ┌─────────────────────────────┐ │
│ ○ Name A-Z           │ │ Product B                    │ │
│ ○ Stock Low-High     │ │ Cost: Rs 100 | Sell: Rs 250  │ │
│ ○ Newest             │ │ Stock: 0 pcs (OUT OF STOCK)  │ │
│                      │ │ Margin: 150%                 │ │
│ [Add Product] +      │ │ [Edit] [Delete]              │ │
│                      │ └─────────────────────────────┘ │
│                      │                                 │
│                      │ [Load More...]                  │
└──────────────────────┴─────────────────────────────────┘

Tap product → Detail panel slides in from right (no modal)

DETAIL PANEL (when product selected):
┌────────────────────────────────────────┐
│ Product A                              │
│                                        │
│ Cost Price:      Rs 50                │
│ Selling Price:   Rs 100               │
│ Profit per unit: Rs 50 (100%)         │
│                                        │
│ Pieces per Carton: 10                 │
│ Current Stock: 50 pcs (5 cartons)     │
│                                        │
│ [Edit] [Delete] [Restock]             │
└────────────────────────────────────────┘
```

**Design:**

- Search bar: Persistent, always visible
- Filters: Collapsible bottom sheet
- Product card: 1px border, minimal layout
- Detail panel: Slide in from right (not modal)
- Stock color-coding:
  - Green: 50+ pcs
  - Orange: 10-50 pcs
  - Red: <10 pcs or out of stock

---

### Screen 4: Customers / Ledger

**Goal:** Track customer credit and balance  
**Layout:** Customer list with balance badge

```
┌─────────────────────────────────────────────────────────┐
│ CUSTOMER LEDGER                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ [Search customer name...]  [Add Customer] +            │
│                                                         │
│ ┌───────────────────────────────────────────────────┐  │
│ │ ABC Ltd              Owes You: Rs 45,000 (RED)   │  │
│ │ Last transaction: 2026-02-02                     │  │
│ │ [View Ledger] [Settle] [Delete]                 │  │
│ └───────────────────────────────────────────────────┘  │
│                                                         │
│ ┌───────────────────────────────────────────────────┐  │
│ │ XYZ Corp             You Owe: Rs 5,000 (GREEN)   │  │
│ │ Last transaction: 2026-01-28                     │  │
│ │ [View Ledger] [Settle] [Delete]                 │  │
│ └───────────────────────────────────────────────────┘  │
│                                                         │
│ ┌───────────────────────────────────────────────────┐  │
│ │ PQR Ltd              Balanced (GRAY)             │  │
│ │ Last transaction: 2026-02-01                     │  │
│ │ [View Ledger] [Delete]                          │  │
│ └───────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘

Tap customer → Detail view with transaction history

TRANSACTION HISTORY (Detail View):
┌────────────────────────────────────────────┐
│ ABC Ltd - Ledger                           │
├────────────────────────────────────────────┤
│ Current Balance: Rs 45,000 (They owe you) │
│                                            │
│ Recent Transactions:                       │
│ 2026-02-02 Sale       +Rs 5,000           │
│ 2026-01-28 Sale       +Rs 10,000          │
│ 2026-01-15 Sale       +Rs 30,000          │
│ 2026-01-10 Paid       -Rs 10,000          │
│                                            │
│ [Settle Balance] [Print Ledger]           │
└────────────────────────────────────────────┘
```

**Color Coding:**

- Red badge: Customer owes you (positive for business)
- Green badge: You owe customer (negative for business)
- Gray badge: Balanced
- Metric: Large, bold color

---

### Screen 5: Cheques

**Goal:** Track issued/received cheques with notifications  
**Layout:** List with status filters

```
┌─────────────────────────────────────────────────────┐
│ CHEQUE TRACKER                                      │
├─────────────────────────────────────────────────────┤
│ [Add Cheque] +                                      │
│                                                     │
│ Filter: ○ All ○ Due Soon ○ Overdue ○ Cleared      │
│                                                     │
│ ┌─────────────────────────────────────────────────┐ │
│ │ Due Soon (⏰ 1-7 days)                          │ │
│ ├─────────────────────────────────────────────────┤ │
│ │ ABC Ltd       | Rs 15,000 | 2026-02-10 | ⏰     │ │
│ │ [Mark Clear] [View] [Delete]                  │ │
│ │                                                 │ │
│ │ XYZ Ltd       | Rs 8,500  | 2026-02-12 | ⏰     │ │
│ │ [Mark Clear] [View] [Delete]                  │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
│ ┌─────────────────────────────────────────────────┐ │
│ │ Cleared                                         │ │
│ ├─────────────────────────────────────────────────┤ │
│ │ PQR Ltd       | Rs 22,000 | 2026-01-20 | ✓    │ │
│ │ [View] [Delete]                               │ │
│ │                                                 │ │
│ │ MNO Ltd       | Rs 12,500 | 2026-01-10 | ✓    │ │
│ │ [View] [Delete]                               │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Status Icons & Colors:**

- ⏰ Orange: Due within 7 days (warning)
- ⚠️ Red: Overdue (critical)
- ✓ Gray: Cleared

**Notifications:**

- Scheduled 1 day before due date
- Local notifications (flutter_local_notifications)
- No server required
- Tap notification → open cheque detail

---

## 🎨 Color Usage Examples

### Profit Display

```
Line Item: Product A | Qty 5 | Price Rs 100 | Total Rs 500 | Profit ✨ +100

Profit chip design:
┌─────────┐
│ +Rs 100 │  ← Green (#10B981), bold, 16px
│ +100%   │  ← Gray, smaller, context
└─────────┘
```

### Stock Alert

```
Product X: 5 pcs left

Visual indicator:
┌──────────────────────┐
│ ⚠️ Low Stock Alert   │  ← Orange (#F59E0B) background
│ Only 5 pcs | Theme   │
│ Reorder now?         │
└──────────────────────┘
```

### Error State

```
Sale failed to save!

Visual:
┌──────────────────────┐
│ ❌ Sale Failed       │  ← Red (#EF4444)
│ Please check network │
│ [Retry]              │
└──────────────────────┘
```

---

## ⌨️ Keyboard Shortcuts

**Core Shortcuts (Desktop):**

```
F1                → Open Fast Sale (search focused)
F2                → Toggle Products screen
F3                → Toggle Customers screen
F4                → Toggle Cheques screen
F5                → Refresh current screen

Ctrl+N            → New item (varies by screen)
Ctrl+S            → Save & Print (Fast Sale)
Ctrl+Shift+S      → Manual sync (if cloud enabled)

In Fast Sale:
  Number keys     → Qty input
  Enter           → Add to cart
  Backspace       → Clear cart
  Escape          → Close detail panel

In Lists:
  Ctrl+F          → Focus search
  Escape          → Clear filters
```

---

## 🎯 Design Principles for Developers

**When building widgets:**

1. **Color:** Use theme colors, not hex codes

   ```dart
   ✅ Theme.of(context).colorScheme.primary
   ❌ Color(0xFF3B82F6)
   ```

2. **Spacing:** Use AppSpacing constants

   ```dart
   ✅ const Gap(16)
   ❌ SizedBox(height: 16)
   ```

3. **Icons:** Use lucide_icons only

   ```dart
   ✅ Icon(LucideIcons.plus, size: 24)
   ❌ Icon(Icons.add)
   ```

4. **Cards:** No shadow, minimal border

   ```dart
   ✅ Card(elevation: 0, shape: RoundedRectangleBorder(...))
   ❌ Card(elevation: 4, shadowColor: Colors.black)
   ```

5. **Build methods:** Keep <30 lines
   ```dart
   ✅ Extract _buildMetricCard()
   ❌ 100-line build() method
   ```

---

## 📊 Design Tokens (Dart Constants)

```dart
// colors.dart
class AppColors {
  static const primary = Color(0xFF3B82F6);  // Vibrant Blue
  static const success = Color(0xFF10B981);  // Green
  static const warning = Color(0xFFF59E0B);  // Orange
  static const danger = Color(0xFFEF4444);   // Red
  static const bgWhite = Color(0xFFFFFFFF);
  static const bgLight = Color(0xFFF9FAFB);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  // ... etc
}

// spacing.dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}
```

---

## ✅ Implementation Roadmap

| Phase  | Feature                    | Priority |
| ------ | -------------------------- | -------- |
| **1**  | Navigation Rail + AppBar   | P0       |
| **2**  | Fast Sale Screen (3-panel) | P0       |
| **3**  | Dashboard (metric cards)   | P1       |
| **4**  | Products (search + CRUD)   | P1       |
| **5**  | Customers/Ledger           | P2       |
| **6**  | Cheques + Notifications    | P2       |
| **7**  | Reports                    | P3       |
| **8**  | Dark Mode (optional)       | P4       |
| **9**  | Keyboard Shortcuts         | P3       |
| **10** | Polish & Animations        | P4       |

---

## 🎬 Summary

This design achieves:

- ✅ **Modern:** Current 2024-2025 trends
- ✅ **Flat:** No heavy shadows, minimal borders
- ✅ **Beautiful:** Bold colors, generous spacing
- ✅ **Fast:** Optimized for <2s sale entry
- ✅ **Accessible:** WCAG AA compliant
- ✅ **Desktop:** Navigation rail, keyboard shortcuts
- ✅ **Familiar:** Patterns from industry leaders

**Ready to implement in Flutter with Riverpod!**
