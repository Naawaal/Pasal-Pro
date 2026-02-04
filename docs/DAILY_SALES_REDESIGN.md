# Daily Sales Recording Screen Redesign

**Date:** February 4, 2026  
**Status:** ✅ Redesigned and Implemented

## Objective Changed

The Fast Sale section has been **redesigned from a POS billing system to a Daily Sales Recording screen**.

### What Changed

**Old Purpose:** Fast transaction entry with POS billing, payment method selection, invoice/receipt generation
**New Purpose:** Simple daily sales logging for profit tracking - no billing, no invoices, no printing

## Functional Architecture

### Screen Layout: 2-Column Form

```
┌─────────────────────────────────────────────────────────────────┐
│ DAILY SALES                                                     │
│ Record sales and track profit                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SALES ENTRY FORM (40%)  │  DAILY SALES LOG (60%)             │
│                           │                                    │
│  Product:                │  TODAY'S SALES          [0 entries] │
│  [Search/Create]         │  ┌──────────────────────────────┐  │
│                          │  │ Product  │ Qty │ Price │ Profit  │
│  Quantity (units):       │  ├──────────────────────────────┤  │
│  [    ]                  │  │ [empty state]                 │  │
│                          │  └──────────────────────────────┘  │
│  Selling Price:          │                                    │
│  Rs [        ]           │  Total Sales: Rs 0.00             │
│                          │  Total Profit: Rs 0.00 ✓          │
│  Profit (auto):          │                                    │
│  Rs [0.00]               │                                    │
│                          │                                    │
│  [+ ADD SALE]            │                                    │
│                          │                                    │
└─────────────────────────────────────────────────────────────────┘
```

### Key Features

#### 1. Sales Entry Form (Left Panel - 40%)

- **Product Input**
  - Searchable field with autocomplete
  - Auto-fetch cost price from existing products
  - Allow inline creation for new products
- **Quantity Input**
  - Single units only (no carton conversion)
  - Required field
- **Selling Price Input**
  - Editable per sale (variable pricing support)
  - Default pulls from product if exists
- **Auto-Calculated Profit Display**
  - Shows immediately when all fields filled
  - Formula: `(Selling Price - Cost Price) × Quantity`
  - Green highlight to emphasize profit
  - No manual calculation needed

- **Submit Button**
  - "ADD SALE" button adds entry to daily log
  - Form clears after submission
  - Focus returns to product field

#### 2. Daily Sales Log (Right Panel - 60%)

- **Entry List (Table Format)**
  - Column headers: Product | Qty | Price | Profit | [Remove]
  - One row per sale entry
  - Remove button for correcting mistakes
  - Sortable/scrollable if many entries

- **Totals Section (Always Visible)**
  - Total Sales Amount: Sum of (Selling Price × Quantity)
  - **Total Profit: Sum of all profit values** ← MANDATORY
  - Green highlight for profit emphasis
  - Entry count badge at top

### Design Principles

✅ **No billing or receipt generation**

- Removed: Payment method selection (Cash/Credit)
- Removed: SAVE & PRINT button with invoice generation
- Purpose is tracking, not customer documentation

✅ **Minimal input fields**

- Only 3 required inputs: Product, Quantity, Price
- Auto-calculation eliminates manual math

✅ **Fast entry (<5 seconds per sale)**

- Keyboard-first design
- Tab/Enter navigation between fields
- Auto-focus product field after each entry

✅ **Offline-first**

- All entries saved to Isar database
- Works without internet
- Sync capability for later

✅ **Profit-centric**

- Large green profit display
- Immediately visible calculation
- Daily total profit always visible

## File Structure

```
lib/features/sales/
├── domain/
│   └── entities/
│       ├── sale.dart          (Sale entity with items list)
│       └── sale_item.dart     (SaleItem entity with profit calc)
│
├── data/
│   ├── models/
│   │   ├── sale_model.dart    (Isar schema - TODO)
│   │   └── sale_item_model.dart (Isar schema - TODO)
│   │
│   ├── datasources/
│   │   └── sale_local_datasource.dart (TODO)
│   │
│   └── repositories/
│       └── sale_repository_impl.dart (TODO)
│
└── presentation/
    ├── providers/
    │   └── fast_sale_providers.dart (Riverpod state management)
    │
    ├── pages/
    │   └── fast_sale_page.dart (DailySalesPage - main screen)
    │
    └── widgets/
        ├── sales_entry_form.dart (Form widget - IMPLEMENTED ✓)
        ├── daily_sales_log.dart (Log display - IMPLEMENTED ✓)
        ├── search_panel.dart (OLD - can be removed)
        ├── cart_panel.dart (OLD - can be removed)
        ├── quantity_input.dart (OLD - can be removed)
        ├── totals_panel.dart (OLD - can be removed)
        └── [other old widgets]
```

## Current Implementation Status

### ✅ Completed

- [x] Page structure redesigned (DailySalesPage)
- [x] Sales entry form widget (SalesEntryForm)
- [x] Daily sales log widget (DailySalesLog)
- [x] Navigation updated (FAST SALE → DAILY SALES)
- [x] 2-column layout with proper sizing (40/60 split)
- [x] Entry form UI complete with all fields
- [x] Profit display box (auto-calculated, green highlight)
- [x] Daily log table structure
- [x] Totals display section
- [x] App builds successfully

### ⏳ TODO - Core Functionality

1. **Product Search & Creation**
   - Implement autocomplete in product field
   - Auto-fetch cost price from product database
   - Allow inline product creation with cost price

2. **Profit Calculation & Display**
   - Connect to product cost price
   - Calculate profit on form input change
   - Display real-time in green box
   - Update daily total profit when entry added

3. **Entry Submission**
   - Validate inputs (required fields)
   - Add to sales list
   - Update daily totals
   - Clear form for next entry
   - Save to Isar database

4. **Database Integration**
   - Create Isar models (SaleModel, SaleItemModel)
   - Implement repository pattern
   - Persist entries to daily log
   - Query today's sales on app load

5. **Edit/Remove Entries**
   - Implement remove button in log
   - Update totals when entry removed
   - Optional: Edit existing entries

6. **Keyboard Shortcuts**
   - Tab: Next field
   - Enter: Submit entry
   - Escape: Clear form
   - F1: Focus product field (global)

## State Management (Riverpod)

Current providers in `fast_sale_providers.dart`:

- `currentSaleProvider` - StateNotifierProvider managing cart (needs redesign for daily log)
- `filteredProductsProvider` - FutureProvider for product search
- `recentProductsProvider` - StateNotifierProvider for quick access

**Next Step:** Redesign providers to support:

- `dailySalesProvider` - Today's sales entries list
- `salesTotalProvider` - Derived provider for totals
- `productSearchProvider` - For autocomplete

## Testing Checklist

- [ ] Form renders with all 3 input fields
- [ ] Profit calculates when fields filled
- [ ] Add button submits entry to log
- [ ] Log updates with new entries
- [ ] Total sales amount calculated correctly
- [ ] Total profit calculated and displayed
- [ ] Form clears after submission
- [ ] Focus returns to product field
- [ ] Product search autocompletes
- [ ] New products can be created inline
- [ ] Entries persist after app restart
- [ ] Remove button deletes entries
- [ ] All totals update correctly

## Migration Notes

### Old Widgets to Deprecate

- `SearchPanel` - Replaced by simple product search in form
- `CartPanel` - Replaced by daily sales log
- `QuantityInput` - Merged into entry form
- `TotalsPanel` - Replaced by log totals section
- `ProductSearchItem` - Functionality moved to autocomplete
- `CartItem` - Functionality moved to log entry row

### Keep for Now

- `SalesEntryForm` - New widget, keep
- `DailySalesLog` - New widget, keep
- Riverpod providers - Update as needed

## Next Phase

After Daily Sales Recording is fully functional:

1. Dashboard screen showing today's total profit
2. Sales history/reports
3. Product performance analysis
4. CSV export for accounting
5. End-of-day reconciliation screen
