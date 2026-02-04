# Pasal Pro - Product Requirements Document

**Version:** 1.0  
**Date:** February 4, 2026  
**Owner:** Development Team  
**Status:** Approved

---

## 1. Executive Summary

**One-liner:** Desktop-first POS and digital Khata system designed for Nepali wholesale shops with 2-click sale entry and real-time profit tracking.

**Problem:** Traditional paper-based Khata (ledger) systems in Nepali shops lead to:

- Data loss (torn pages, ink fading)
- Calculation errors in credit tracking
- No visibility into actual profit margins
- Slow transaction processing during peak hours
- Difficulty managing hybrid unit systems (cartons vs pieces)

**Solution:** A Flutter desktop app with offline-first architecture that enables sub-2-second sale entries, automatic profit calculations, hybrid unit conversions, and nightly cloud backups.

**Impact:**

- 85% reduction in transaction time (15s → 2s)
- Zero data loss with automated backups
- Real-time profit visibility
- 40% reduction in credit tracking errors

---

## 2. Problem Statement & Current Gaps

**User Pain Points:**

- Shop owners spend 15+ seconds per sale manually calculating prices and recording in paper Khata
- Credit customers often dispute balances due to unclear records
- No visibility into which products are actually profitable
- Staff cannot quickly check stock levels during sales
- Month-end profit calculation takes hours of manual arithmetic

**Current Workflow Issues:**

- 8+ taps/clicks required to complete a sale in existing POS systems
- Carton-to-piece conversion done manually, causing errors
- No integration between inventory and credit ledger
- Internet dependency prevents usage during power cuts (common in Nepal)

**Competitive Gap:**

- Most POS systems designed for retail, not wholesale hybrid units
- No Nepali-first localization in existing solutions
- Expensive subscription models unsuitable for small shops

---

## 3. Goals & Success Metrics

**Primary Goal:** Enable shop owners to complete sales 70% faster while maintaining accurate profit and credit records.

**Success Metrics (6 months post-launch):**

| Metric                      | Target                   |
| --------------------------- | ------------------------ |
| Average sale entry time     | ≤ 2 seconds              |
| Crash-free sessions         | ≥ 99.9%                  |
| Data loss incidents         | 0 (with auto-backup)     |
| User adoption (pilot shops) | ≥ 80% daily active usage |
| Credit dispute reduction    | ≥ 60%                    |

**How to Measure:**

- Analytics events: `sale_completed`, `backup_success`, `app_crash`
- User feedback: Weekly surveys with pilot shop owners
- Performance: DevTools timeline monitoring

---

## 4. User Personas & Scenarios

### Primary Persona: The Busy Shopkeeper (Malik)

- **Age:** 35-55
- **Technical Proficiency:** Low-Medium
- **Context:** Serves 20-50 customers during peak hours (morning, evening)
- **Frequency:** 50-200 transactions/day
- **Pain Points:** Slow billing, mental math fatigue, credit tracking errors

### Secondary Persona: Shop Staff (Karmachari)

- **Age:** 18-30
- **Technical Proficiency:** Medium
- **Context:** Handles routine sales under owner supervision
- **Frequency:** 30-100 transactions/day
- **Pain Points:** Fear of making mistakes, unclear product pricing

### Use Case Scenarios:

#### Scenario A: Peak Hour Sale (Happy Path)

1. Customer asks for "2 cartons Wai Wai"
2. Staff types "wai" → product appears
3. Staff enters "2" → system converts to 24 pieces
4. Customer pays cash → Staff clicks "Save" → Receipt prints
5. **Time:** < 2 seconds

#### Scenario B: Credit Sale with Low Stock

1. Regular customer wants 5 cartons on credit
2. System shows warning: "Only 3 cartons in stock"
3. Staff adjusts quantity → Credit toggle ON
4. Customer name auto-suggests (previous credit customer)
5. System updates customer balance → Receipt prints
6. **Edge case handled:** Low stock alert visible before sale completion

---

## 5. Scope

### In Scope (MVP - 6 months):

#### Phase 1 (Sprint 0-2): Core Data & Product Management

- ✅ Isar database setup (Product, Customer, Transaction models)
- ✅ Product CRUD operations
- ✅ Hybrid unit conversion (cartons ↔ pieces)
- ✅ Profit margin calculations

#### Phase 2 (Sprint 3-4): Fast-Sale Entry

- Fast-sale screen with product search
- Numeric keypad for quantity entry
- Cash/Credit toggle
- Automatic profit calculation
- Bluetooth thermal receipt printing

#### Phase 3 (Sprint 5-6): Customer Ledger (Khata)

- Customer management
- Credit balance tracking
- Balance settlement flow
- Payment history

#### Phase 4 (Sprint 7-8): Dashboard & Analytics

- Malik Mode (owner dashboard)
- Daily profit summary
- Low-stock alerts
- Expected cash vs actual cash

#### Phase 5 (Sprint 9-11): Polish & Release

- Nepali localization (primary UI language)
- Google Drive nightly backup
- Desktop installers (.deb, .msi)
- Onboarding wizard

### Out of Scope (Future Phases):

- Multi-shop sync (Phase 2)
- Barcode scanner integration (Phase 2)
- Advanced analytics/charts (Phase 2)
- Mobile app version (Phase 3)
- Tax/VAT calculations (Phase 3)
- AI pricing suggestions (Phase 4)

### Non-Goals:

- Web-based administration panel
- Multi-user access control (single shop, single device)
- Integration with accounting software
- E-commerce integration

---

## 6. User Stories & Requirements

### Epic 1: Product Management

**Story 1.1:** Quick Product Addition

> **As a** shop owner,  
> **I want** to add products with carton/piece pricing,  
> **So that** I can quickly set up my inventory without manual conversion.
>
> **Priority:** Critical  
> **Acceptance Criteria:**
>
> - [ ] Form accepts: name, cost price/piece, selling price/piece, pieces per carton
> - [ ] System auto-calculates carton prices
> - [ ] Validation: selling price must exceed cost price
> - [ ] Product name indexed for fast search
> - [ ] Save completes in < 500ms

**Story 1.2:** Low Stock Alerts

> **As a** shop owner,  
> **I want** to see which products are running low,  
> **So that** I can reorder before running out.
>
> **Priority:** High  
> **Acceptance Criteria:**
>
> - [ ] Configurable low-stock threshold per product
> - [ ] Visual indicator (yellow badge) on product list
> - [ ] Dashboard shows count of low-stock items
> - [ ] Alert appears before completing sale if stock insufficient

### Epic 2: Fast Sale Entry

**Story 2.1:** Sub-2-Second Sale Recording

> **As a** shop staff member during peak hours,  
> **I want** to record a sale with 2 clicks (product + quantity),  
> **So that** I can serve customers 70% faster.
>
> **Priority:** Critical  
> **Estimated Impact:** -85% transaction time (15s → 2s)
>
> **Acceptance Criteria:**
>
> - [ ] Search bar with auto-suggest (≤ 3 characters)
> - [ ] Large numeric keypad for quantity (min 48dp tap targets)
> - [ ] Automatic unit conversion (cartons ↔ pieces)
> - [ ] Profit displayed before saving
> - [ ] Cash/Credit toggle accessible in 1 tap
> - [ ] Receipt prints within 2s of save
> - [ ] Entire flow completes in ≤ 2 seconds

**Story 2.2:** Hybrid Unit Flexibility

> **As a** shop staff,  
> **I want** to enter quantity in cartons OR pieces,  
> **So that** I can handle both bulk and loose sales without calculation.
>
> **Priority:** Critical  
> **Acceptance Criteria:**
>
> - [ ] Toggle button: Cartons ↔ Pieces
> - [ ] System converts and displays both units
> - [ ] Price calculation accurate to 2 decimal places
> - [ ] Edge case: partial cartons (e.g., 2.5) supported

### Epic 3: Customer Credit Management

**Story 3.1:** Credit Balance Tracking

> **As a** shop owner,  
> **I want** to automatically track each customer's credit balance,  
> **So that** I reduce disputes and improve cash flow.
>
> **Priority:** High  
> **Acceptance Criteria:**
>
> - [ ] Customer balance updates atomically with sale
> - [ ] Visual indicator: Green (paid), Red (balance owed)
> - [ ] Balance history viewable per customer
> - [ ] Search customers by name or phone

**Story 3.2:** Balance Settlement

> **As a** shop owner,  
> **I want** to record partial or full payments,  
> **So that** customer balances stay accurate.
>
> **Priority:** High  
> **Acceptance Criteria:**
>
> - [ ] "Settle Balance" button on customer card
> - [ ] Amount input with validation (≤ current balance)
> - [ ] Receipt generated for payment
> - [ ] Transaction history updated

### Epic 4: Owner Dashboard (Malik Mode)

**Story 4.1:** Daily Profit Visibility

> **As a** shop owner,  
> **I want** to see today's net profit in real-time,  
> **So that** I can make pricing decisions immediately.
>
> **Priority:** High  
> **Acceptance Criteria:**
>
> - [ ] Dashboard shows: Total sales, Total profit, Profit %
> - [ ] Updates in real-time after each transaction
> - [ ] Comparison: Today vs Yesterday
> - [ ] Visual: Green (profit up), Red (profit down)

**Story 4.2:** Cash Flow Tracking

> **As a** shop owner,  
> **I want** to know expected cash vs actual cash,  
> **So that** I can detect discrepancies quickly.
>
> **Priority:** Medium  
> **Acceptance Criteria:**
>
> - [ ] Expected cash = Sales - Credit sales
> - [ ] Manual "Actual Cash" entry at day end
> - [ ] Difference displayed with color code
> - [ ] Expense tracking (optional quick-entry)

### Epic 5: Data Backup & Recovery

**Story 5.1:** Nightly Automated Backup

> **As a** shop owner,  
> **I want** my data backed up automatically every night,  
> **So that** I never lose records even if the device fails.
>
> **Priority:** Critical  
> **Acceptance Criteria:**
>
> - [ ] Google Drive OAuth setup in settings
> - [ ] Nightly backup at 2:00 AM (configurable)
> - [ ] Encrypted JSON export
> - [ ] Status indicator: Last backup time, Success/Fail
> - [ ] Manual backup button

**Story 5.2:** Easy Data Restore

> **As a** shop owner,  
> **I want** to restore my data from backup,  
> **So that** I can recover from device failure quickly.
>
> **Priority:** High  
> **Acceptance Criteria:**
>
> - [ ] "Restore from Backup" in settings
> - [ ] Lists available backups with dates
> - [ ] Confirmation dialog (warns about overwriting)
> - [ ] Progress indicator during restore

---

## 7. Technical Requirements

### 7.1 Performance

- Sale entry: ≤ 2 seconds end-to-end
- UI response time: ≤ 50ms (Material 3 standard)
- Database queries: ≤ 100ms for product search
- App launch: ≤ 3 seconds (cold start)

### 7.2 Reliability

- Crash-free rate: ≥ 99.9%
- Data consistency: 100% (ACID transactions with Isar)
- Backup success rate: ≥ 99%
- Works fully offline (network not required for operations)

### 7.3 Compatibility

- Windows 10/11 (primary)
- Linux (Ubuntu 20.04+, Debian 11+)
- macOS 11+ (secondary)
- Minimum RAM: 4GB
- Minimum Storage: 500MB

### 7.4 Security

- Local database encryption (optional, Phase 2)
- Backup encryption: AES-256
- No user authentication in MVP (single device, single shop)
- OAuth2 for Google Drive (secure token storage)

### 7.5 Localization

- Primary language: Nepali
- Secondary language: English
- Currency: Nepali Rupees (Rs)
- Date format: YYYY-MM-DD (ISO), Display: MMM d, yyyy

---

## 8. Acceptance Criteria (Definition of Done)

For each feature to be considered complete:

- [ ] Code reviewed and approved
- [ ] Unit tests written (≥ 80% coverage for business logic)
- [ ] Integration test passes for critical flows
- [ ] Tested on Windows (primary target)
- [ ] Tested with actual Bluetooth printer
- [ ] Offline mode validated
- [ ] Performance benchmarks met (< 2s sale entry)
- [ ] Accessibility: Keyboard navigation, contrast ≥ 4.5:1
- [ ] Documentation updated (user guide)
- [ ] Follows flutter-guideline standards (file size, SOLID)

---

## 9. Risks & Mitigation

| Risk                              | Impact   | Probability | Mitigation                                                                |
| --------------------------------- | -------- | ----------- | ------------------------------------------------------------------------- |
| Sale latency > 2s                 | High     | Medium      | Profile with DevTools, optimize Isar queries, lazy load non-critical data |
| Bluetooth printer incompatibility | High     | Medium      | Test with 5+ common printer models, provide PDF fallback                  |
| Data loss on device failure       | Critical | Low         | Daily automated backups, manual export button, test restore flow          |
| Nepali font rendering issues      | Medium   | Low         | Use Noto Sans (Google Fonts), test on all platforms                       |
| Staff resistance to change        | High     | Medium      | Simple onboarding wizard, Nepali UI, pilot program with feedback          |

---

## 10. Release Plan

### Alpha Release (Sprint 6): Internal Testing

- Core features: Product management, Fast sale, Basic printing
- Audience: Development team
- Success: Complete 10 mock sales in < 2s each

### Beta Release (Sprint 10): Pilot Program

- Features: All MVP features complete
- Audience: 3-5 pilot shops in Kathmandu
- Duration: 4 weeks
- Success: ≥ 4/5 satisfaction, < 5 critical bugs

### V1.0 Release (Sprint 11): Public Launch

- Features: Polished MVP with localization and backup
- Distribution: .deb/.msi installers
- Marketing: Facebook groups, local shop associations
- Success: 100 active shops in 3 months

---

## 11. Future Enhancements (Post-MVP)

### Phase 2 (Q3 2026):

- Barcode scanner support (USB/Bluetooth)
- CSV import/export (bulk product addition)
- Advanced analytics with charts
- Multi-shop data sync via Drive

### Phase 3 (Q4 2026):

- Mobile companion app (Android/iOS) for owner
- Tax/VAT calculations
- Employee time tracking
- Supplier management

### Phase 4 (2027):

- AI-suggested pricing based on competition
- Demand forecasting for inventory
- WhatsApp integration for credit reminders
- Voice-based entry (Nepali speech recognition)

---

## 12. Appendix

### A. Glossary

- **Malik:** Shop owner (Nepali)
- **Karmachari:** Shop employee/staff (Nepali)
- **Khata:** Traditional credit ledger book (Nepali)
- **Udharo:** Credit/debt (Nepali)
- **Bikri:** Sale (Nepali)
- **Kharich:** Expense (Nepali)

### B. References

- [Flutter Material 3 Guidelines](https://m3.material.io/)
- [Isar Database Documentation](https://isar.dev/)
- [Nepali Shop POS Research](assets/design-research/)

---

**Document Owner:** Development Team  
**Last Updated:** February 4, 2026  
**Next Review:** End of Sprint 5

### Phase 2 (Q3 2026)

- Barcode scanner support (USB/Bluetooth)
- CSV import/export (bulk product addition)
- Advanced analytics with charts
- Multi-shop data sync via Drive

### Phase 3 (Q4 2026)

- Mobile companion app (Android/iOS) for owner
- Tax/VAT calculations
- Employee time tracking
- Supplier management

### Phase 4 (2027)

- AI-suggested pricing based on competition
- Demand forecasting for inventory
- WhatsApp integration for credit reminders
- Voice-based entry (Nepali speech recognition)

---

## 12. Appendix

### A. Glossary

- **Malik:** Shop owner (Nepali)
- **Karmachari:** Shop employee/staff (Nepali)
- **Khata:** Traditional credit ledger book (Nepali)
- **Udharo:** Credit/debt (Nepali)
- **Bikri:** Sale (Nepali)
- **Kharich:** Expense (Nepali)

### B. References

- [Flutter Material 3 Guidelines](https://m3.material.io/)
- [Isar Database Documentation](https://isar.dev/)
- [Nepali Shop POS Research](assets/design-research/)

---

**Document Owner:** Development Team  
**Last Updated:** February 4, 2026  
**Next Review:** End of Sprint 5
