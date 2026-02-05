# Daily Sales UI/UX Research (Internal Update)

**Date:** 2026-02-05  
**Scope:** Daily Sales (2-panel: Entry Form + Daily Log)  
**Source:** Internal UI audit + existing Pasal Pro design system (Mix tokens, AppResponsive)

## Key Findings

- **Task priority:** Fast entry + instant daily visibility. Users return to this screen frequently; minimize cognitive load.
- **Hierarchy:** Profit and total sales must remain visible without scrolling on desktop.
- **Clarity over density:** Column labels, aligned numeric values, and stable rows improve scanning speed.
- **Consistent tokens:** Use Mix tokens for all backgrounds, borders, and text to preserve theme consistency.

## Recommended Layout

### Desktop (≥ 1366px)

- **Split layout:** 40% Entry Form | 60% Daily Log.
- **Entry Form:** Title, helper hint, form fields, profit box, primary CTA.
- **Daily Log:** Summary cards → Table header → Entries → Totals.

### Tablet & Mobile

- **Stacked layout:** Entry Form above Daily Log.
- **Condensed table:** Hide time column, keep Product + Qty + Total + Profit.

## Component Patterns

### Entry Form

- **Title + Helper:** “Sale Entry” + short instruction.
- **Primary fields:** Product, Customer (optional), Quantity, Price.
- **Profit box:** Highlighted success color, visible only when form is valid.
- **CTA:** Full-width `FilledButton` with clear label.

### Daily Log

- **Summary cards:** Entries, Sales Count, Sales Total, Profit.
- **Table:** Subtle header background, aligned numbers, right-justified currency.
- **Totals section:** “Total Sales” + “Total Profit” boxed highlight.

## States

- **Loading:** Shimmer list with tokenized base/highlight colors.
- **Empty:** Centered message, neutral text color.
- **Error:** Surface-alt container with retry guidance.

## Interaction Guidance

- **Refresh:** Small icon button in header.
- **Keyboard flow:** After submitting, focus product search.
- **Validation:** Prevent invalid entries; show profit only when valid.

## Token Usage

- **Backgrounds:** `PasalColorToken.surface`, `surfaceAlt`, `background`.
- **Borders:** `PasalColorToken.border`.
- **Status:** `PasalColorToken.success` for profit emphasis.
- **Text:** `textPrimary`, `textSecondary`.

## Responsive Rules

- **Summary cards:** 1 column (mobile), 2 columns (tablet), 3 columns (desktop+).
- **Columns:** Hide time on stacked layout.
- **Spacing:** 16–24px vertical rhythm; use `SalesSpacing`.

- **Summary cards:** 1 column (mobile), 2 columns (tablet), 3 columns (desktop+).
- **Columns:** Hide time on stacked layout.
- **Spacing:** 16–24px vertical rhythm; use `SalesSpacing`.
