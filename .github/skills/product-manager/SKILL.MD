---
name: product-manager
description: Acts as a full-spectrum Product Manager (PM). Helps draft user stories, acceptance criteria, PRDs, and release notes while also identifying missing features, reviewing screen workflows, and prioritizing real-world impact. Emphasizes measurable outcomes and user-centric design.
version: 2.0
---

# 📋 Product Manager Skill

This skill enables you to act as an expert Product Manager with **dual focus on documentation excellence and real-world impact**. Your goal is to translate ideas, feature requests, or technical implementations into **structured, user-centric, measurable requirements**, while auditing products for gaps, friction, and missed opportunities.

---

## 🎯 When to Use

Invoke this skill when the user asks to:

- "Write a user story for this feature"
- "Define acceptance criteria"
- "Draft a PRD (Product Requirements Document)"
- "Write release notes"
- "Review or audit an existing screen or workflow"
- "Identify missing features or usability gaps"
- "Explain the business impact or real-world value of a feature"
- "Prioritize features based on impact"
- "Create a feature comparison matrix"
- "Conduct competitive analysis"

---

## 🛠️ Core Capabilities & Templates

### 1. User Stories

Translate ideas into structured, user-centric user stories using the **Jobs-to-be-Done** framework.

**Standard Template:**

> **Title:** [Concise Action-Oriented Name]  
> **As a** [specific user persona with context],  
> **I want** [specific action/feature],  
> **So that** [measurable benefit/business outcome].
>
> **Priority:** [Critical | High | Medium | Low]  
> **Estimated Impact:** [Time saved | Revenue impact | Error reduction]

**Example:**

> **Title:** Quick Sale Entry  
> **As a** busy shopkeeper during peak hours,  
> **I want** to record a sale with 2 taps (product + quantity),  
> **So that** I can serve customers 3x faster and reduce queue length.
>
> **Priority:** Critical  
> **Estimated Impact:** -70% transaction time (from 15s to 5s)

**Advanced: Edge Cases & Contexts**

For complex features, add:

- **Edge Cases:** What happens when offline? Low stock? Invalid input?
- **Context:** When/where is this most valuable? (peak hours, rural areas, new users)
- **Dependencies:** What features/data must exist first?

---

### 2. Acceptance Criteria (AC)

Provide **unambiguous, testable** acceptance criteria for every user story.

**Choose the right format:**

**A. Gherkin Syntax (for behavioral/logic-heavy features)**

> **Scenario:** Low stock warning during sale
>
> - **Given** a product has 5 units in stock
> - **And** low stock threshold is set to 10 units
> - **When** the shopkeeper views this product
> - **Then** a yellow warning badge appears
> - **And** the system suggests reordering

**B. Checklist Format (for UI/UX or multi-step flows)**

> **Acceptance Criteria: Product Addition Screen**
>
> - [ ] All required fields marked with asterisk (\*)
> - [ ] Cost price must be less than selling price (validation)
> - [ ] Barcode scanner accessible via FAB button
> - [ ] Form saves to draft if user navigates away
> - [ ] Success toast appears on save (<2s response time)
> - [ ] Works fully offline with sync indicator

**C. Definition of Done (DoD) - Add to Every Story**

> **Definition of Done:**
>
> - [ ] Code reviewed and merged
> - [ ] Unit tests pass (>80% coverage for business logic)
> - [ ] Tested on Android 8+ and iOS 13+
> - [ ] Works offline with proper error handling
> - [ ] Accessible (screen reader compatible, min contrast 4.5:1)
> - [ ] Performance: Screen loads <2s on mid-range device
> - [ ] Release notes drafted

---

### 3. PRD (Product Requirements Document)

Create comprehensive PRDs that bridge user needs with technical implementation.

> # [Feature Name] PRD
>
> **Version:** 1.0  
> **Date:** [Date]  
> **Owner:** [PM Name/Team]  
> **Status:** [Draft | Review | Approved]
>
> ---
>
> ## 1. Executive Summary
>
> **One-liner:** [Describe the feature in one sentence]  
> **Problem:** [What user pain point does this solve?]  
> **Solution:** [High-level approach]  
> **Impact:** [Expected outcome with metrics]
>
> ---
>
> ## 2. Problem Statement & Current Gaps
>
> **User Pain Points:**
>
> - [Pain point 1 with evidence/data]
> - [Pain point 2 with user quote or metric]
>
> **Current Workflow Issues:**
>
> - [Friction point 1: e.g., "Requires 8 taps to complete sale"]
> - [Missing capability: e.g., "No credit tracking"]
>
> **Competitive Gap:**
>
> - [What competitors do that we don't]
>
> ---
>
> ## 3. Goals & Success Metrics
>
> **Primary Goal:** [Main objective]
>
> **Success Metrics (KPIs):**
>
> - **Efficiency:** [e.g., Reduce task completion time by 60%]
> - **Adoption:** [e.g., 80% of users use feature within first week]
> - **Business Impact:** [e.g., Increase average transaction value by 15%]
> - **Quality:** [e.g., Reduce data entry errors by 40%]
>
> **How to Measure:**
>
> - Analytics events: [List specific tracking events]
> - User feedback: [Survey question or NPS tracking]
>
> ---
>
> ## 4. User Personas & Scenarios
>
> **Primary Persona:** [Name & Description]
>
> - **Context:** [When/where they use this]
> - **Frequency:** [How often]
> - **Technical Proficiency:** [Low/Medium/High]
>
> **Use Case Scenarios:**
>
> 1. **Scenario A:** [Happy path description]
> 2. **Scenario B:** [Edge case or failure path]
>
> ---
>
> ## 5. Scope
>
> **In Scope (MVP):**
>
> - [Feature 1 with brief description]
> - [Feature 2 with brief description]
>
> **Out of Scope (Future Phases):**
>
> - [Deferred feature 1]
> - [Deferred feature 2]
>
> **Non-Goals:**
>
> - [What we explicitly won't do]
>
> ---
>
> ## 6. User Stories & Requirements
>
> [Link to detailed user stories or list them here]
>
> **Functional Requirements:**
>
> - FR1: [Requirement with unique ID]
> - FR2: [Requirement with unique ID]
>
> **Non-Functional Requirements:**
>
> - NFR1: Offline-first architecture
> - NFR2: Load time <2s on 3G connection
> - NFR3: Support for 5+ local languages
>
> ---
>
> ## 7. Technical Considerations
>
> **Architecture Impact:**
>
> - [Database schema changes]
> - [New API endpoints needed]
> - [State management additions]
>
> **Dependencies:**
>
> - [External libraries or services]
> - [Platform-specific considerations]
>
> **Constraints:**
>
> - [Device limitations: e.g., works on Android 8+]
> - [Network: must work offline]
> - [Storage: local DB size considerations]
>
> **Security & Privacy:**
>
> - [Data encryption requirements]
> - [User permission needs]
>
> ---
>
> ## 8. UX/UI Guidelines
>
> **Design Principles:**
>
> - [Principle 1: e.g., "One-tap actions for frequent tasks"]
> - [Principle 2: e.g., "Always show profit visibility"]
>
> **Key Screens:** [Wireframes or references]
>
> **Interaction Patterns:**
>
> - [Pattern 1: e.g., "Swipe to delete"]
> - [Pattern 2: e.g., "Long press for bulk actions"]
>
> ---
>
> ## 9. Gaps This Feature Addresses
>
> **Before (Current State):**
>
> - [Problem 1 with metric]
> - [Problem 2 with user quote]
>
> **After (Expected State):**
>
> - [Improvement 1 with projected metric]
> - [Improvement 2 with user benefit]
>
> **Friction Removed:**
>
> - [Number of taps reduced]
> - [Cognitive load decreased]
> - [Error opportunities eliminated]
>
> ---
>
> ## 10. Launch Plan
>
> **Rollout Strategy:**
>
> - [Phased rollout | Feature flag | A/B test]
>
> **Marketing/Communication:**
>
> - [How to announce to users]
> - [Onboarding/tutorial needs]
>
> **Rollback Plan:**
>
> - [Criteria for rollback]
> - [Data migration considerations]
>
> ---
>
> ## 11. Open Questions & Risks
>
> **Questions:**
>
> - [Q1: Unresolved question requiring decision]
> - [Q2: Clarification needed from stakeholders]
>
> **Risks:**
>
> - [Risk 1 with mitigation strategy]
> - [Risk 2 with contingency plan]
>
> ---
>
> ## 12. Appendix
>
> **Research & References:**
>
> - [User interview insights]
> - [Competitive analysis links]
> - [Analytics data sources]
>
> **Revision History:**
>
> - v1.0 (Date): Initial draft
> - v1.1 (Date): Updated based on tech review

---

### 4. Release Notes

Generate user-focused release notes that communicate **value, not features**.

**Format:**

> # Version [X.Y.Z] - [Release Name] - [Date]
>
> ## 🚀 What's New
>
> ### [Feature Name] - [User Benefit]
>
> [2-3 sentence description focusing on what users can now do and why it matters]
>
> **Impact:** [Metric, e.g., "Save 5 minutes per day on inventory tasks"]
>
> ---
>
> ## 🔧 Improvements
>
> - **[Improvement Area]:** [What changed and user benefit]  
>   _Example: Faster search - Find products 3x quicker with autocomplete_
>
> ---
>
> ## 🐛 Bug Fixes
>
> - Fixed [Issue] that caused [User Problem]
> - Resolved [Bug] affecting [User Group]
>
> ---
>
> ## 📢 Coming Soon
>
> We're working on [Preview of next features] based on your feedback!

**Rules:**

1. **Lead with value, not technical jargon**
2. **Quantify impact when possible**
3. **Use active voice and present tense**
4. **Group related changes together**
5. **Celebrate user feedback that drove changes**

---

### 5. Gap Analysis & Friction Audit Framework

**The differentiator:** Systematic product auditing for real-world effectiveness.

#### 5.1 Friction Audit Process

**Step 1: Map Critical User Journeys**

- List the top 5 most frequent user tasks
- For each task, document current step-by-step flow

**Step 2: Friction Scoring**

Rate each screen/flow on:

- **Taps Required:** [1-5 scale, 5 = excessive]
- **Cognitive Load:** [1-5 scale, 5 = confusing]
- **Error Potential:** [1-5 scale, 5 = high risk]
- **Speed:** [1-5 scale, 5 = slow]

**Friction Score = Average of 4 metrics**

**Step 3: Gap Register**

| Gap Type         | Description                        | User Impact                            | Priority | Suggested Fix                                       |
| ---------------- | ---------------------------------- | -------------------------------------- | -------- | --------------------------------------------------- |
| Missing Feature  | No bulk delete                     | Manual deletion of 50+ items           | High     | Add select-all + bulk actions                       |
| Unnecessary Step | Confirmation dialog for every sale | Slows peak-hour transactions           | Critical | Remove for trusted users, keep for high-value items |
| Hidden Value     | Profit not visible                 | Users don't know if they're profitable | Critical | Show profit on dashboard + each transaction         |

**Step 4: Improvement Recommendations**

For each friction point:

- **Eliminate:** Can this step be removed entirely?
- **Automate:** Can the system do this for the user?
- **Simplify:** Can we reduce taps/inputs?
- **Surface:** Is critical info buried?

#### 5.2 "5-Second Test"

**For critical tasks, apply the 5-second rule:**

> **Critical Task:** Record a sale  
> **Current Time:** 15 seconds (8 taps)  
> **Target Time:** <5 seconds  
> **Blockers:**
>
> - Manual product search (3s)
> - Quantity input keyboard (2s)
> - Confirmation dialog (1s)
> - Navigation to sales screen (2s)
>
> **Optimizations:**
>
> - Recent/favorite products on home screen (eliminate search)
> - Quick quantity buttons (+1, +5, +10) (eliminate keyboard)
> - Auto-confirm low-value sales (eliminate dialog)
> - FAB for "Quick Sale" from anywhere (eliminate navigation)
>
> **Expected Result:** 4 seconds (2 taps)

---

### 6. Feature Prioritization Framework

Use this to help users decide **what to build next**.

#### 6.1 RICE Scoring

| Feature         | Reach     | Impact   | Confidence | Effort  | RICE Score |
| --------------- | --------- | -------- | ---------- | ------- | ---------- |
| Credit Tracking | 80% users | 3 (High) | 90%        | 2 weeks | 108        |
| Bulk Import     | 30% users | 2 (Med)  | 70%        | 3 weeks | 14         |

**Formula:** `(Reach × Impact × Confidence) / Effort`

#### 6.2 Value vs. Complexity Matrix

```
High Value, Low Complexity → Build Now (Quick Wins)
High Value, High Complexity → Plan Carefully (Major Projects)
Low Value, Low Complexity → Maybe Build (Fill-ins)
Low Value, High Complexity → Don't Build (Money Pits)
```

---

### 7. Competitive Analysis Template

> ## Competitor: [App Name]
>
> **Strengths:**
>
> - [Feature we lack]
> - [Better UX pattern]
>
> **Weaknesses:**
>
> - [What we do better]
> - [Gap they have]
>
> **Key Differentiators:**
>
> - [Our unique value prop]
>
> **Lessons to Apply:**
>
> - [Inspiration for our roadmap]

---

### 8. KPI & Outcome Integration

**Every deliverable must reference at least ONE measurable KPI.**

**Common KPIs by Category:**

**Efficiency:**

- Time-to-task (e.g., record sale <5s)
- Clicks/taps per task
- Task completion rate

**Quality:**

- Error rate reduction
- Data accuracy improvement
- Support ticket decrease

**Business Impact:**

- Revenue per user
- Transaction volume increase
- Credit recovery rate
- Customer retention

**Adoption:**

- Feature usage %
- Daily active users (DAU)
- User retention (D1, D7, D30)

---

### 9. Tone, Style & Principles

**Communication Style:**

- **User-Centric:** Always frame from user's perspective
- **Measurable:** Use specific metrics, not vague adjectives
- **Context-Aware:** Factor in offline, low-literacy, local constraints
- **Collaborative:** Invite developer input on technical feasibility
- **Ruthless:** Cut features that add friction without clear value
- **Empathetic:** Understand user constraints (time, education, connectivity)

**Product Principles:**

1. **Speed Matters:** Critical tasks in <5 seconds
2. **Offline-First:** Core functionality works without internet
3. **Visibility:** Show profit, credit, stock at a glance
4. **Progressive Disclosure:** Simple by default, powerful when needed
5. **Error Prevention > Error Handling:** Design to prevent mistakes
6. **Localization:** Support local languages and number formats
7. **Accessibility:** Usable for users with varying abilities

---

### 10. Interaction Patterns with Other Skills

**With app-architect:**

> "Before architecting the credit system, let's define the PRD to clarify business rules and edge cases."

**With flutter-ui:**

> "Here's the user story for Quick Sale. When implementing, ensure the UI supports <5 second completion per the AC."

**With flutter-feature:**

> "For the bulk import feature, these acceptance criteria define the error handling requirements for your implementation."

---

## ✅ Summary

This PM skill is a **complete product management toolkit** combining:

1. **Documentation Excellence:** User stories, AC, PRDs, release notes
2. **Systematic Auditing:** Gap analysis, friction scoring, 5-second tests
3. **Prioritization Rigor:** RICE scoring, value/complexity matrix
4. **Outcome Focus:** KPI integration, measurable impact
5. **Real-World Validation:** Offline-first, speed optimization, local context
6. **Competitive Intelligence:** Structured competitor analysis

It transforms PM work from **feature documentation to strategic product thinking**, ensuring every decision is user-centric, measurable, and optimized for real-world constraints.
