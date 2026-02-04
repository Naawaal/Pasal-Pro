# Visual Quick Reference Guide

## Color Palette at a Glance

```
┌─────────────────────────────────────────────────────────────┐
│                   PRIMARY COLOR PALETTE                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Primary Blue          Success Green       Warning Orange   │
│  #3B82F6              #10B981             #F59E0B          │
│  ██████████           ██████████          ██████████       │
│  Actions, highlights   Profit, positive    Stock alerts     │
│                                                             │
│  Danger Red            Text Primary        Text Secondary   │
│  #EF4444              #1F2937             #6B7280          │
│  ██████████           ██████████          ██████████       │
│  Losses, errors       Body text           Helper text      │
│                                                             │
│  Border Gray           Light Background   White Background │
│  #E5E7EB              #F9FAFB             #FFFFFF          │
│  ██████████           ██████████          ██████████       │
│  Lines, dividers      Card background    Main canvas      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Component Library Quick Reference

### Button Styles

```
┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│  PRIMARY BLUE  │  │ Secondary Gray │  │   Text Only    │
│    (Filled)    │  │    (Outlined)  │  │   (No Fill)    │
│   Background   │  │   Border only  │  │  Text + Icon   │
│                │  │                │  │                │
│   Solid Blue   │  │ Gray border    │  │  Gray text     │
│   #3B82F6      │  │ White fill     │  │  On hover:     │
│                │  │                │  │  Underline     │
└────────────────┘  └────────────────┘  └────────────────┘

Click → Darker blue   Click → Light bg   Click → Lighter
Hover → #2563EB      Hover → Light gray  Hover → Underline
```

### Card Design

```
┌─────────────────────────────────┐
│ 1px #E5E7EB border (NO shadow)  │
│                                 │
│  Icon (32px)                   │
│  Title (12px gray)             │
│                                 │
│  Large Value (28px bold)       │
│  Meta (12px gray)              │
│                                 │
│  12px radius, 16px padding     │
└─────────────────────────────────┘

Background: White (#FFFFFF)
Hover: Slight color change on text, smooth transition 150ms
```

### Input Field

```
┌─ [Search or filter text...] ─────────┐
│  1px #D1D5DB border                  │
│  6px radius                          │
│  White background                    │
│  Focus: Border turns blue #3B82F6    │
│  Padding: 10px 12px                  │
└──────────────────────────────────────┘

Placeholder: #9CA3AF, italic
Text: #1F2937
Label (above): 12px, weight 600
```

---

## Navigation Rail Anatomy

```
WIDTH: 72px (collapsed) | 280px (expanded)

┌─────────┐
│ Rupee   │ ← F1 (Fast Sale) - DEFAULT SELECTION
│ 🔵      │    Blue icon #3B82F6, left border 3px
│ FAST   │    Label (hidden in collapsed, visible in expanded)
│  SALE  │
├─────────┤
│ Chart   │ ← F2 (Dashboard)
│ ⚫      │    Gray icon #9CA3AF
│ DASH   │
│BOARD   │
├─────────┤
│ Box     │ ← F3 (Products)
│ ⚫      │
│PRODUCT │
├─────────┤
│ Users   │ ← F4 (Customers)
│ ⚫      │
│CUSTOMER│
├─────────┤
│ Check   │ ← F5 (Cheques)
│ ⚫      │
│ CHEQUE │
├─────────┤
│ Chart2  │ ← F6 (Reports)
│ ⚫      │
│REPORTS │
├─────────┤
│ ─────── │
├─────────┤
│ Gear    │ ← Settings
│ ⚫      │
│SETTINGS│
├─────────┤
│ Help    │ ← Help
│ ⚫      │
│  HELP   │
└─────────┘

HOVER: Light gray background #F3F4F6, 150ms transition
ACTIVE: Blue icon, left blue border
```

---

## Typography Hierarchy

```
Page Title (28px, weight 700)
═══════════════════════════════════

Section Header (20px, weight 600)
─────────────────────────────────

Card Title (16px, weight 600)
  Body Large (16px, weight 400)
    Body Regular (14px, weight 400)
      Helper Text (12px, weight 400, gray)
        Label (12px, weight 600, uppercase)

PRINCIPLE: Use weight for emphasis, not just size
           Limit to 3 sizes per screen
```

---

## Spacing Rules (8px Grid)

```
4px  ██        Micro spacing (tight)
8px  ████      Compact (between small items)
12px ██████    Default (between related elements)
16px ████████  Comfortable (standard padding/margin)
24px ████████████ Spacious (between sections)
32px ████████████████ Large (major blocks)
48px ████████████████████████ Extra large (screen gaps)
```

**Apply to:**

- Padding within components: 16px
- Margin between components: 12-16px
- Section gaps: 24px
- Screen edges: 24px

---

## Fast Sale Screen Layout (3-Panel)

```
┌─────────────────────────────────────────────────────────────┐
│ AppBar: Search | Global Actions | Sync | User              │
├──────────────────────┬──────────────┬──────────────────────┤
│  PANEL A (40%)      │ PANEL B (25%)│ PANEL C (35%)         │
├──────────────────────┤              ├──────────────────────┤
│ [Search...]         │ CART ITEMS   │ TOTALS & PAYMENT     │
│                     │              │                      │
│ Recent:             │ ┌──────────┐ │ Subtotal: Rs 5000   │
│ □ Product A (100ea) │ │Product A │ │                      │
│ □ Product B (200ea) │ │Qty: 5    │ │ Profit: +Rs 1000 ✨ │
│ □ Product C (50ea)  │ │Rs 100    │ │                      │
│                     │ │+100 ✨   │ │ Total: Rs 5000       │
│ All Products:       │ └──────────┘ │                      │
│ ┌────────────────┐  │              │ Payment:             │
│ │Product A       │  │ ┌──────────┐ │ ○ Cash               │
│ │100 pcs, Rs 100 │  │ │Product B │ │ ○ Credit             │
│ └────────────────┘  │ │Qty: 2    │ │                      │
│                     │ │Rs 200    │ │ [Save & Print] ✓    │
│ ┌────────────────┐  │ │+400 ✨   │ │                      │
│ │Product B       │  │ └──────────┘ │                      │
│ │200 pcs, Rs 200 │  │              │                      │
│ └────────────────┘  │ [Clear All]  │                      │
│                     │              │                      │
└─────────────────────┴──────────────┴──────────────────────┘

WIDTHS: Panel A = 40% | Panel B = 25% | Panel C = 35%
        Minimum: 280px | 200px | 280px respectively
```

---

## Dashboard Metric Card Examples

```
TODAY'S SALES          TODAY'S PROFIT         LOW STOCK
┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐
│ 📊 (blue)        │   │ 💰 (green)       │   │ 📦 (orange)      │
│                  │   │                  │   │                  │
│ Today Sales      │   │ Today Profit     │   │ Low Stock        │
│ (12px gray)      │   │ (12px gray)      │   │ (12px gray)      │
│                  │   │                  │   │                  │
│ Rs 45,230        │   │ Rs 12,450        │   │ 5 items          │
│ (28px bold)      │   │ (28px bold)      │   │ (28px bold)      │
│                  │   │                  │   │                  │
│ ↑ 12% vs Yday    │   │ ↑ 18% vs Yday    │   │ Action needed    │
│ (12px gray)      │   │ (12px gray)      │   │ (12px gray)      │
└──────────────────┘   └──────────────────┘   └──────────────────┘

Icon: Colored (#3B82F6 blue, #10B981 green, #F59E0B orange)
Value: Bold, color-coded or primary black
Meta: Gray, smaller
```

---

## Ledger Color Coding

```
CUSTOMER A                          RED BADGE
Owes You: Rs 45,000 (RED)           Indicates customer owes you
Last: 2026-02-02
[View] [Settle] [Delete]


CUSTOMER B                          GREEN BADGE
You Owe: Rs 5,000 (GREEN)           Indicates you owe customer
Last: 2026-01-28
[View] [Settle] [Delete]


CUSTOMER C                          GRAY BADGE
Balanced (GRAY)                     Balanced (no outstanding)
Last: 2026-02-01
[View] [Delete]
```

---

## Cheque Status Icons

```
⏰ Orange  → Due within 7 days (Warning)
   Cheque number | Amount | Due date | [Mark Clear]

⚠️  Red    → Overdue (Critical)
   Cheque number | Amount | Due date | [Mark Clear]

✓  Gray    → Cleared (Done)
   Cheque number | Amount | Cleared date
```

---

## Keyboard Shortcuts (Desktop)

```
┌──────────────────────────────────────────────────────────────┐
│                    GLOBAL SHORTCUTS                          │
├──────────────────────────────────────────────────────────────┤
│ F1              Open Fast Sale (search focused)              │
│ F2              Toggle Products screen                       │
│ F3              Toggle Customers screen                      │
│ F4              Toggle Cheques screen                        │
│ F5              Refresh current screen                       │
│                                                              │
│ Ctrl+N          New item (context-dependent)                │
│ Ctrl+S          Save & Print (Fast Sale)                    │
│ Ctrl+Shift+S    Manual sync (if cloud enabled)              │
├──────────────────────────────────────────────────────────────┤
│               FAST SALE SPECIFIC SHORTCUTS                   │
├──────────────────────────────────────────────────────────────┤
│ Number keys (0-9)  → Quantity input                         │
│ Enter              → Add to cart                             │
│ Backspace          → Clear current item                      │
│ Escape             → Close detail panel                      │
├──────────────────────────────────────────────────────────────┤
│                    LIST SHORTCUTS                            │
├──────────────────────────────────────────────────────────────┤
│ Ctrl+F             → Focus search                            │
│ Escape             → Clear filters                           │
│ Delete             → Delete selected item                    │
└──────────────────────────────────────────────────────────────┘
```

---

## Animation Timings

```
Button Hover       150ms  → Smooth color change
Page Transition   300ms  → Context switch (fade/slide)
Metric Update     600ms  → Celebrate new value (spring)
Notification In   200ms  → Toast entrance (easeOut)
Card Expand       250ms  → Show details
```

All use: `flutter_animate` (not manual AnimationController)

---

## Empty State Template

```
┌──────────────────────────────────────────┐
│                                          │
│           📦 (Large icon, gray)         │
│           96px, #D1D5DB                 │
│                                          │
│        No Products Found                │
│        (18px, semibold, #1F2937)        │
│                                          │
│  Add your first item to get started    │
│  (14px, gray, centered)                │
│                                          │
│        [Create Product] +               │
│        (Primary blue button)            │
│                                          │
└──────────────────────────────────────────┘
```

---

## Summary

| Component | Style                    | Key Rule            |
| --------- | ------------------------ | ------------------- |
| Card      | 1px border, no shadow    | Flat is in          |
| Button    | 10px padding, 6px radius | Compact & clean     |
| Input     | 1px border, 10px padding | Focused blue        |
| Icon      | lucide, 24px             | Consistent          |
| Text      | Inter, 2-3 weights       | Simple hierarchy    |
| Color     | 4-5 colors max           | Intentional         |
| Spacing   | 8px grid                 | Breathe, don't cram |
| Animation | 150-300ms                | Smooth, purposeful  |

**Mantra:** Modern + Flat + Fast + Beautiful ✨
| Spacing | 8px grid | Breathe, don't cram |
| Animation | 150-300ms | Smooth, purposeful |

**Mantra:** Modern + Flat + Fast + Beautiful ✨
