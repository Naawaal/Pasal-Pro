---
name: design-intelligence
description: Discovers, analyzes, and curates UI/UX design inspiration from apps in your product's niche. Provides structured design references, pattern analysis, and saves findings to assets/design-research/ for future reference.
version: 2.0
---

# 🎨 Design Intelligence: Automated UI/UX Research Engine

Your **design research assistant** that discovers, analyzes, and organizes UI/UX inspiration from top apps in your category.

---

## 🎯 When to Use

Invoke when you need:

- **"Find UI inspiration for [app type]"**
- **"Analyze design patterns in [category] apps"**
- **"What UI trends are common in [niche]?"**
- **"Compare [feature] designs across competitors"**
- **"Research color palettes for [industry]"**

---

## 📋 Core Capabilities

### 1. Discovery & Collection

- Searches: Dribbble, Behance, Mobbin, UI Sources, Awwwards, Land-book
- Filters: Platform (iOS/Android/Web), Screen type, Industry
- Extracts: Screenshots, color palettes, typography, patterns

### 2. Pattern Analysis

- Identifies common UI patterns and their frequency
- Extracts color schemes and typography trends
- Analyzes interaction patterns and user flows
- Benchmarks against competitors

### 3. Organized Storage

**All findings saved to:** `assets/design-research/[project-name]/`

```
assets/design-research/
└── wholesale-shop-app/
    ├── README.md                    # Research summary
    ├── screenshots/
    │   ├── dashboard/
    │   ├── product-list/
    │   └── forms/
    ├── color-palettes.json          # Extracted colors
    ├── pattern-analysis.md          # Common patterns
    ├── competitor-comparison.md     # Competitive analysis
    └── design-references.json       # Structured data
```

---

## 🔍 Research Process

### Phase 1: Niche Identification

**Step 1: Define Context**

```yaml
Product: Wholesale Management App
Target Users: Small business owners
Key Features: Inventory, Sales, Credit tracking
Platform: Mobile (iOS + Android)
```

**Step 2: Source Selection**

| Source         | Best For             | Search Strategy        |
| -------------- | -------------------- | ---------------------- |
| **Mobbin**     | Mobile screens       | Category + screen type |
| **Dribbble**   | Concept designs      | Tags + color           |
| **Behance**    | Case studies         | Project search         |
| **UI Sources** | Real production apps | App category browse    |
| **Awwwards**   | Web apps             | Industry filter        |

**Search Queries Example:**

- Mobbin: "inventory management", "POS", "wholesale"
- Dribbble: "business dashboard", "sales tracker"
- Behance: "B2B platform", "retail app"

---

### Phase 2: Design Collection

**For each design discovered, extract:**

```json
{
  "id": "design_001",
  "source": "Mobbin",
  "app_name": "Stocky - Inventory Manager",
  "url": "https://mobbin.com/apps/stocky-ios",
  "platform": "iOS",
  "screen_type": "Dashboard",
  "style": "Modern, Clean, Material 3",
  "color_palette": {
    "primary": "#2563EB",
    "secondary": "#10B981",
    "background": "#F9FAFB",
    "accent": "#F59E0B"
  },
  "typography": {
    "font_family": "Inter",
    "heading_weight": "600-700",
    "body_weight": "400"
  },
  "key_patterns": [
    "Card-based layout",
    "Color-coded metrics",
    "Bottom navigation",
    "FAB for quick actions"
  ],
  "screenshot_path": "assets/design-research/wholesale-shop/screenshots/dashboard/stocky_dashboard.png"
}
```

---

### Phase 3: Pattern Analysis

**Common Patterns Matrix:**

| Pattern                  | Frequency | Best Practice                             |
| ------------------------ | --------- | ----------------------------------------- |
| **Bottom Navigation**    | 85%       | 3-5 items, icons + labels                 |
| **Card-based Dashboard** | 90%       | Group metrics, color-code status          |
| **FAB for Quick Add**    | 70%       | Primary action, labeled                   |
| **Color-coded Status**   | 95%       | Red (low), Green (good), Yellow (warning) |

**Trend Analysis:**

- Dark mode support: 75%
- Micro-animations: 85%
- Glassmorphism: 30% (growing)
- 3D illustrations: 40% (onboarding)

---

### Phase 4: Organized Output

**Generated Files:**

**1. README.md** - Research Summary

```markdown
# UI/UX Research: Wholesale Management Apps

**Date:** 2025-01-25
**Apps Analyzed:** 24
**Key Findings:** Card-based dashboards dominant, profit visibility critical

## Quick Recommendations

- Use bottom navigation (4 tabs max)
- Card layout for metrics
- Color-code stock levels (Red <10, Yellow <50, Green ≥50)
- FAB for "Quick Sale"

[Full analysis in pattern-analysis.md]
```

**2. pattern-analysis.md** - Detailed Patterns

```markdown
# Pattern Analysis

## Most Common Patterns

### 1. Bottom Navigation (85%)

- **Usage:** Primary navigation
- **Items:** 3-5 tabs
- **Examples:** Stocky, Inventory Manager Pro
- **Recommendation:** Use for main sections

### 2. Card-based Metrics (90%)

- **Purpose:** Display KPIs
- **Layout:** 2-column grid mobile, 3-4 tablet
- **Color coding:** Status-based
- **Examples:** [See screenshots/dashboard/]

[Detailed analysis continues...]
```

**3. color-palettes.json** - Color Data

```json
{
  "research_date": "2025-01-25",
  "palettes": [
    {
      "app": "Stocky",
      "primary": "#2563EB",
      "secondary": "#10B981",
      "background": "#F9FAFB",
      "usage": "Professional, trustworthy"
    }
  ],
  "trends": {
    "primary_colors": {
      "blue": 45,
      "purple": 25,
      "green": 20
    }
  }
}
```

**4. design-references.json** - Structured Database

```json
{
  "metadata": {
    "product_category": "Wholesale Management",
    "research_date": "2025-01-25",
    "total_designs": 24
  },
  "designs": [
    {
      "id": "design_001",
      "app_name": "Stocky",
      "url": "https://...",
      "screenshot": "screenshots/dashboard/stocky.png",
      "patterns": ["bottom-nav", "cards", "fab"],
      "colors": {...},
      "rating": 9.2
    }
  ]
}
```

---

## 📊 Output Formats

### Format 1: Quick Reference Table

```markdown
# Design Collection

| App           | Platform | Screen    | Style      | Primary Color    | Key Patterns      | Screenshot                                 |
| ------------- | -------- | --------- | ---------- | ---------------- | ----------------- | ------------------------------------------ |
| Stocky        | iOS      | Dashboard | Modern     | Blue (#2563EB)   | Cards, Bottom Nav | [View](screenshots/dashboard/stocky.png)   |
| Inventory Pro | Android  | List      | Material 3 | Indigo (#6366F1) | Search, Filters   | [View](screenshots/list/inventory-pro.png) |
```

### Format 2: Competitive Analysis

```markdown
## Feature Comparison: Quick Sale

| App                 | Taps Required | Time | Offline | Screenshot                                      |
| ------------------- | ------------- | ---- | ------- | ----------------------------------------------- |
| Your App (Proposed) | 2             | 5s   | ✅ Yes  | [Design](screenshots/proposals/quick-sale.png)  |
| Stocky              | 2             | 5s   | ✅ Yes  | [View](screenshots/competitors/stocky-sale.png) |
| QuickBooks          | 5             | 15s  | ❌ No   | [View](screenshots/competitors/qb-sale.png)     |

**Competitive Advantage:** Match best-in-class speed, add offline support
```

### Format 3: Visual Mood Board (HTML)

When requested, generates interactive HTML:

```html
<!-- Saved to: assets/design-research/[project]/mood-board.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>Wholesale App - Design Inspiration</title>
    <style>
      /* Grid layout, filterable by screen type, platform */
    </style>
  </head>
  <body>
    <div class="filters">
      <button data-filter="dashboard">Dashboard</button>
      <button data-filter="list">Product List</button>
      <button data-filter="forms">Forms</button>
    </div>

    <div class="grid">
      <!-- Cards with screenshots, metadata, expandable details -->
    </div>
  </body>
</html>
```

---

## 🎯 Screen-Type Analysis

### Dashboard Screens

**Common Elements:**

- Summary metrics (2-4 cards top)
- Primary action (FAB or CTA)
- Recent activity list
- Navigation (bottom tabs)

**Best Practices:**

- Key metrics above fold
- Color-code status
- Limit to 3-4 metrics
- Quick actions for frequent tasks

**Examples Saved To:** `screenshots/dashboard/`

---

### List/Catalog Screens

**Common Elements:**

- Persistent search bar
- Filter/sort options
- Pull-to-refresh
- Swipe actions

**Best Practices:**

- Search always visible
- Filters in bottom sheet
- Empty states with guidance
- Bulk selection mode

**Examples Saved To:** `screenshots/list/`

---

### Form Screens

**Common Elements:**

- Outlined text fields
- Inline validation
- Auto-save drafts
- Sticky submit button

**Best Practices:**

- Autofocus first field
- Show validation inline
- Disable submit until valid
- Appropriate keyboards

**Examples Saved To:** `screenshots/forms/`

---

## 🛠️ Advanced Features

### 1. Color Palette Extraction

Automatically extracts and saves color schemes:

```json
{
  "app": "Stocky",
  "palette": {
    "primary": {
      "hex": "#2563EB",
      "rgb": "37, 99, 235",
      "usage": "Actions, emphasis"
    },
    "success": {
      "hex": "#10B981",
      "rgb": "16, 185, 129",
      "usage": "Positive metrics, success states"
    }
  },
  "accessibility": {
    "contrast_ratio": 4.8,
    "wcag_aa": true
  }
}
```

**Saves to:** `color-palettes.json`

---

### 2. Interaction Patterns

Documents specific interactions with examples:

```markdown
## Interaction: Swipe to Delete

**Frequency:** 14/24 apps (58%)

**Implementations:**

1. **Left swipe** (iOS standard)
   - Actions: Edit (blue), Delete (red)
   - Example: Stocky - [Screenshot](screenshots/interactions/stocky-swipe.png)
2. **Right swipe** (quick delete)
   - Single action
   - Example: Gmail

**Recommendation:** Left swipe with action menu
**Screenshot:** [View proposal](screenshots/proposals/swipe-interaction.png)
```

**Saves to:** `pattern-analysis.md`

---

### 3. Accessibility Audit

```markdown
## Accessibility Analysis

| Criterion      | % Compliant | Common Issues         | Best Examples      |
| -------------- | ----------- | --------------------- | ------------------ |
| Color Contrast | 65%         | Light on light        | Stocky, QuickBooks |
| Touch Targets  | 80%         | Small buttons (<44px) | Notion, Slack      |
| Text Scaling   | 40%         | Fixed sizes           | iOS native apps    |

**Recommendations:**

- Ensure 4.5:1 contrast
- Min 44x44pt targets
- Support dynamic type

**Examples:** [See screenshots/accessibility/]
```

---

## 📁 File Organization Strategy

### Recommended Structure

```
assets/design-research/
└── [project-name]/
    ├── README.md                          # Quick summary
    ├── pattern-analysis.md                # Detailed patterns
    ├── competitor-comparison.md           # Competitive analysis
    ├── color-palettes.json               # Color data
    ├── design-references.json            # Full structured data
    ├── mood-board.html                   # Interactive viewer
    │
    ├── screenshots/
    │   ├── dashboard/
    │   │   ├── stocky-dashboard.png
    │   │   ├── inventory-pro-dashboard.png
    │   │   └── notes.md                  # Screen-specific notes
    │   │
    │   ├── list/
    │   │   ├── stocky-products.png
    │   │   └── notes.md
    │   │
    │   ├── forms/
    │   │   ├── stocky-add-product.png
    │   │   └── notes.md
    │   │
    │   ├── interactions/
    │   │   ├── swipe-actions.gif
    │   │   └── notes.md
    │   │
    │   ├── onboarding/
    │   ├── settings/
    │   └── empty-states/
    │
    ├── proposals/
    │   ├── our-dashboard-v1.png          # Your design concepts
    │   ├── quick-sale-flow.png
    │   └── notes.md
    │
    └── archives/
        └── [old-research-date]/           # Previous research sessions
```

---

## 🎯 Usage Examples

### Example 1: Initial Research

**User:**

> "Find UI inspiration for a wholesale management app"

**Response:**

I'll research UI/UX from wholesale, inventory, and business management apps.

**Phase 1: Discovery**
Searching: Mobbin (inventory apps), Dribbble (business dashboards), Behance (B2B platforms)

**Phase 2: Collection** (Found 24 designs)

- Dashboard screens: 8
- Product lists: 6
- Forms: 5
- Reports: 3
- Settings: 2

**Phase 3: Analysis**
Top patterns identified:

- 90% use card-based dashboards
- 85% have bottom navigation
- 70% use FAB for quick actions
- Color trend: Blue primary (45%)

**Phase 4: Storage**
Saving to: `assets/design-research/wholesale-shop-app/`

Files created:

- ✅ README.md (summary)
- ✅ pattern-analysis.md (detailed patterns)
- ✅ color-palettes.json (24 color schemes)
- ✅ design-references.json (full database)
- ✅ screenshots/ (24 images organized by type)

**Key Recommendations:**

1. Use card layout for metrics
2. Bottom nav with 4 tabs
3. FAB for "Quick Sale"
4. Blue primary color (#2563EB)
5. Color-code stock levels

[View full analysis: assets/design-research/wholesale-shop-app/README.md]

---

### Example 2: Specific Feature Research

**User:**

> "How do top apps handle product search and filters?"

**Response:**

Analyzing search/filter patterns from 18 inventory apps...

**Pattern Analysis:**

| App           | Search Type    | Filter Approach | Sort Options | Screenshot                                 |
| ------------- | -------------- | --------------- | ------------ | ------------------------------------------ |
| Stocky        | Persistent bar | Bottom sheet    | 6 options    | [View](screenshots/list/stocky-search.png) |
| Inventory Pro | Collapsible    | Inline chips    | 8 options    | [View](screenshots/list/invpro-search.png) |

**Common Patterns (80%+ adoption):**

- Persistent search bar at top
- Filters in bottom sheet/sidebar
- Active filter count badge
- Recent searches saved

**Recommendation:**

```
Search: Always visible at top
Filters: Bottom sheet with 5-7 common filters
Sort: Dropdown in app bar
Features: Save searches, clear all filters
```

**Saved to:**

- `pattern-analysis.md` (updated with search patterns)
- `screenshots/list/` (8 new examples)
- `design-references.json` (search pattern metadata)

---

### Example 3: Competitive Benchmarking

**User:**

> "Compare our quick sale flow against competitors"

**Response:**

Analyzing quick sale implementations...

**Competitive Analysis:**

| Feature             | Your App | Stocky | QuickBooks | Inventory Pro |
| ------------------- | -------- | ------ | ---------- | ------------- |
| **Taps to Sale**    | 2        | 2      | 5          | 4             |
| **Time**            | ~5s      | ~5s    | ~15s       | ~10s          |
| **Offline**         | ✅       | ✅     | ❌         | ⚠️ Limited    |
| **Barcode Scan**    | ✅       | ✅     | ❌         | ✅            |
| **Recent Products** | ✅       | ✅     | ❌         | ❌            |

**Competitive Advantages:**

- ✅ Match best-in-class speed (2 taps, 5s)
- ✅ Full offline support (only you + Stocky)
- ✅ Recent products shortcut (you + Stocky)

**Areas to Improve:**

- Consider adding voice input (none have this)
- Add quantity presets (+1, +5, +10) for speed

**Screenshots saved:**

- `screenshots/competitors/stocky-quick-sale.png`
- `screenshots/competitors/qb-quick-sale.png`
- `screenshots/proposals/our-quick-sale-v1.png`

**Analysis saved:** `competitor-comparison.md`

---

## ⚙️ Configuration

### Research Preferences

```yaml
# .github/skills/design-intelligence/config.json
{
  "save_location": "assets/design-research/",
  "screenshot_format": "png",
  "max_designs_per_category": 30,
  "auto_organize_by_screen_type": true,
  "extract_colors": true,
  "extract_typography": true,
  "generate_mood_board": true,
  "platforms": ["iOS", "Android", "Web"],
  "sources":
    {
      "mobbin": true,
      "dribbble": true,
      "behance": true,
      "ui_sources": true,
      "awwwards": true,
    },
}
```

---

## ✅ Quality Standards

### Every Research Session Includes:

- [ ] Minimum 15-20 designs analyzed
- [ ] Organized by screen type
- [ ] Color palettes extracted
- [ ] Pattern frequency calculated
- [ ] Competitive benchmarking
- [ ] Actionable recommendations
- [ ] All files saved to assets/design-research/
- [ ] Screenshots properly named and organized
- [ ] Structured JSON for programmatic access
- [ ] Human-readable markdown summaries

---

## 🔗 Integration with Other Skills

### With app-architect:

> "Before finalizing architecture, review design patterns in assets/design-research/ to ensure UI aligns with technical approach."

### With flutter-ui:

> "When implementing screens, reference screenshots in assets/design-research/[project]/screenshots/ for visual guidance."

### With product-manager:

> "Use competitor-comparison.md to inform feature prioritization and differentiation strategy."

---

## 📚 Asset Management Tips

### Organizing Screenshots

**Naming Convention:**

```
[app-name]-[screen-type]-[variant].png

Examples:
- stocky-dashboard-main.png
- stocky-dashboard-dark-mode.png
- inventory-pro-product-list-grid.png
- inventory-pro-product-list-table.png
```

### Version Control

**Research Sessions:**

```
assets/design-research/
└── wholesale-app/
    ├── [current research - latest]/
    └── archives/
        ├── 2025-01-15/  # Previous research
        └── 2024-12-20/  # Initial research
```

### Gitignore Recommendations

```gitignore
# Keep research structure but ignore large files if needed
# assets/design-research/**/screenshots/*.png  # Uncomment if repo size is concern

# Keep these files (they're small and valuable):
!assets/design-research/**/*.md
!assets/design-research/**/*.json
!assets/design-research/**/*.html
```

---

## 🎓 Best Practices

1. **Research Early** - Before designing screens
2. **Update Regularly** - Quarterly trend checks
3. **Share with Team** - Make assets accessible
4. **Link to Designs** - Reference in Figma/design files
5. **Document Decisions** - Why you chose pattern X over Y
6. **Archive Old Research** - Keep history for context
7. **Cross-Reference** - Link patterns to implementations

---

## 🚀 Advanced Workflows

### Workflow 1: New Feature Research

```
1. User: "Research checkout flow patterns"
2. Skill: Searches 15-20 e-commerce apps
3. Saves: screenshots/checkout/ + analysis
4. Provides: Best practice recommendations
5. Team: Reviews assets, decides on approach
6. Implementation: References saved examples
```

### Workflow 2: Competitive Monitoring

```
1. Quarterly: Re-research top competitors
2. Compare: New version vs saved screenshots
3. Document: New features/patterns in competitor-comparison.md
4. Action: Update backlog with competitive features
```

### Workflow 3: Design System Creation

```
1. Research: UI patterns across category
2. Extract: Common components, colors, typography
3. Document: In design-system/ folder
4. Implement: Flutter widgets based on research
5. Reference: Link components to inspiration sources
```

---

## 📊 Summary

This skill provides **comprehensive UI/UX research** with:

1. **Automated Discovery** - Finds relevant designs across sources
2. **Pattern Analysis** - Identifies trends and best practices
3. **Organized Storage** - Saves all findings to `assets/design-research/`
4. **Structured Data** - JSON + Markdown for easy access
5. **Visual References** - Screenshots organized by type
6. **Actionable Insights** - Clear recommendations
7. **Team Collaboration** - Shareable research artifacts

**Result:** A living design library that accelerates decisions and ensures you're building on proven patterns.

---

## 🎯 Quick Commands

- **"/research [app type]"** - Full research session
- **"/analyze [feature]"** - Feature-specific analysis
- **"/compare [competitors]"** - Competitive benchmarking
- **"/extract colors from [app]"** - Color palette extraction
- **"/trends [industry]"** - Industry trend analysis
- **"/save inspiration [url]"** - Save single reference

### Workflow 3: Design System Creation

```
1. Research: UI patterns across category
2. Extract: Common components, colors, typography
3. Document: In design-system/ folder
4. Implement: Flutter widgets based on research
5. Reference: Link components to inspiration sources
```

---

## 📊 Summary

This skill provides **comprehensive UI/UX research** with:

1. **Automated Discovery** - Finds relevant designs across sources
2. **Pattern Analysis** - Identifies trends and best practices
3. **Organized Storage** - Saves all findings to `assets/design-research/`
4. **Structured Data** - JSON + Markdown for easy access
5. **Visual References** - Screenshots organized by type
6. **Actionable Insights** - Clear recommendations
7. **Team Collaboration** - Shareable research artifacts

**Result:** A living design library that accelerates decisions and ensures you're building on proven patterns.

---

## 🎯 Quick Commands

- **"/research [app type]"** - Full research session
- **"/analyze [feature]"** - Feature-specific analysis
- **"/compare [competitors]"** - Competitive benchmarking
- **"/extract colors from [app]"** - Color palette extraction
- **"/trends [industry]"** - Industry trend analysis
- **"/save inspiration [url]"** - Save single reference
