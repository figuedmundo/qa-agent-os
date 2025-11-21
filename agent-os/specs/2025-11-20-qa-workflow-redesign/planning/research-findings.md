# Research Findings: QA Workflow Redesign

## Research Summary

This document consolidates research on industry-standard test planning practices and provides expert recommendations for restructuring the QA Agent OS workflow to align with professional QA standards.

---

## Industry Standards Research

### Existing QA Agent OS Standards Analysis

QA Agent OS currently has comprehensive test planning standards across multiple files:

**1. Test Plan Template** (`standards/testing/test-plan-template.md`)
- **8-section structure** covering:
  1. Introduction (Objective, Scope, References)
  2. Test Strategy (Levels, Types, Approach, Tools, Test Data Strategy)
  3. Environment (URLs, Browsers/Devices, Infrastructure, Monitoring)
  4. Schedule & Resources (Timeline, Roles, Capacity, Dependencies/Risks)
  5. Deliverables (Test cases, automation, bugs, data, reports)
  6. Exit Criteria (Severity thresholds, coverage %, automation status)
  7. Metrics & Reporting (Burndown, defect rates, compliance scorecards)
  8. Sign-off (Stakeholders, conditions, risks)

**2. QA Test Design Template** (`.vibe/refs/qa_test_design_template.md`)
- **16-section senior QA framework** covering:
  1. Testing Objective
  2. Context & Source Material
  3. Requirement Analysis (granular testable requirements)
  4. Test Strategy (scope, levels, coverage types)
  5. Test Case Generation Rules (positive, edge, negative, dependency failure, behavioral)
  6. Test Data Definition
  7. Test Coverage Matrix (requirement → test case traceability)
  8. Non-Functional Tests (performance, security, usability, compatibility)
  9. Risk-Based Prioritization
  10. Automation Context
  11. Document Generation
  12. AI Instruction Set
  13. QA Quality Standards
  14. Output Example
  15. Test Case Export Format (CSV & Testmo integration)
  16. Deliverable Tracking & Export Instructions

### Key Distinctions in Industry Practice

**Test Strategy vs Test Plan:**

1. **Test Strategy** (Feature-level, strategic)
   - High-level approach for an entire feature/epic
   - Defines overall test philosophy and methodology
   - Sets testing types to apply (functional, API, performance, security)
   - Establishes automation strategy
   - Documents tool selection and environment setup
   - **Reusable** across all tickets within the feature
   - **Created once** at feature initialization
   - **Updated** when new tickets reveal gaps or new testing dimensions

2. **Test Plan** (Ticket-level, tactical)
   - Specific test approach for a single ticket/story
   - Details concrete test scenarios and cases
   - Maps requirements to test coverage
   - Defines test data sets
   - Includes execution timeline and resources
   - **Inherits** strategy from feature-level
   - **Created per ticket**
   - **Refined iteratively** as testing progresses

### Standard QA Workflow Hierarchy

Professional QA teams typically follow this documentation hierarchy:

```
Feature (Epic) Level:
├── Feature Requirements Document (consolidated knowledge)
├── Feature Test Strategy (high-level approach)
└── Tickets/Stories
    ├── Ticket-1
    │   ├── Ticket Requirements (specific to this story)
    │   ├── Test Plan (detailed scenarios/cases)
    │   └── Test Cases (executable tests)
    └── Ticket-2
        ├── Ticket Requirements
        ├── Test Plan
        └── Test Cases
```

**Key Principle:** Strategy is defined once at feature level, plans are created per ticket and inherit/reference the strategy.

---

## Expert Recommendation: Feature-Level Documentation

### Recommendation for Question 1

**Answer: Option B** — Feature level should have BOTH:
- `feature-knowledge.md` (consolidated requirements/specs)
- `feature-test-strategy.md` (high-level test approach)

### Rationale

1. **Alignment with Industry Standards**
   - Professional QA teams separate strategic (feature) from tactical (ticket) planning
   - Test strategy provides a reusable framework that ticket-level plans inherit from
   - Reduces redundancy by documenting common approaches once

2. **Inheritance Model Benefits**
   - Tickets can reference feature strategy instead of repeating it
   - New tickets automatically align with established testing philosophy
   - Changes to strategy propagate to all tickets in the feature

3. **Practical Workflow Efficiency**
   - QA engineer defines testing approach once at feature level
   - Ticket-level plans focus only on ticket-specific scenarios
   - Reduces cognitive load: "What's our overall approach?" vs "What specific tests for this ticket?"

4. **Traceability and Consistency**
   - Clear separation between "what we're building" (knowledge) and "how we're testing it" (strategy)
   - Feature strategy ensures consistent test coverage across all tickets
   - Easier to audit: "Did we test performance?" → Check feature strategy

### Proposed Feature-Level Structure

```
features/
  [feature-name]/
    documentation/              ← Raw docs from PO, devs, BE team
      calculations.md
      api-endpoints.md
      business-rules.md
    feature-knowledge.md        ← Consolidated master document (WHAT)
    feature-test-strategy.md    ← High-level test approach (HOW)
    [ticket-id-1]/
      documentation/            ← Ticket-specific raw data
        ticket-from-jira.pdf
        ticket-info.md
        visuals/
          mockup_1.png
      test-plan.md              ← Ticket test plan (inherits from feature strategy)
      test-cases.md             ← Generated test cases
    [ticket-id-2]/
      ...
```

### What Goes in Each Document

**feature-knowledge.md:**
- Feature overview and business context
- Consolidated business rules and calculations
- API endpoints and data models
- Dependencies and integrations
- User flows and acceptance criteria
- **Purpose:** Single source of truth for WHAT we're building

**feature-test-strategy.md:**
- Test levels to apply (unit, integration, API, UI, E2E)
- Test types coverage (functional, regression, performance, security, accessibility)
- Automation approach and tools
- Test environment setup
- Test data strategy
- Non-functional test requirements (performance targets, security checks)
- Risks and mitigation approaches
- **Purpose:** Strategic framework for HOW we're testing this feature

**[ticket-id]/test-plan.md:**
- Reference to feature-test-strategy.md
- Ticket-specific test scope
- Granular testable requirements for this ticket
- Test coverage matrix (requirement → test case mapping)
- Specific test scenarios and cases
- Test data sets for this ticket
- Entry/exit criteria
- **Purpose:** Tactical plan for testing THIS specific ticket

---

## Recommended Template: feature-test-strategy.md

Based on QA Agent OS's existing test plan template, here's a streamlined feature-level strategy template:

```markdown
# Feature Test Strategy: [Feature Name]

## 1. Testing Objective
- **Goal:** [What this feature testing aims to validate]
- **Scope:** In-scope features/modules and dependencies
- **Out of Scope:** What's explicitly excluded from testing

## 2. Test Approach

### Test Levels
- [ ] Unit Testing
- [ ] Integration Testing
- [ ] API Testing
- [ ] UI/E2E Testing
- [ ] Regression Testing
- [ ] Performance Testing

### Test Types Coverage
- **Functional:** [Approach for happy path scenarios]
- **Edge/Boundary:** [How we'll test limits and boundaries]
- **Negative/Error:** [Invalid input and error handling approach]
- **Dependency Failure:** [How we test when APIs/services fail]
- **Security:** [Security testing approach]
- **Performance:** [Performance testing approach and targets]
- **Usability/Accessibility:** [WCAG compliance, responsive design]
- **Cross-browser/Device:** [Browser/device matrix]

## 3. Test Environment & Tools

### Environment
- **Test Environments:** [Dev, Staging, Pre-prod URLs]
- **Browsers/Devices:** [Chrome, Firefox, Safari, iOS, Android]
- **Infrastructure:** [Feature flags, third-party services, mocks/stubs]

### Tools & Frameworks
- **Manual Testing:** [Tools for manual test execution]
- **API Testing:** [Postman, k6, etc.]
- **UI Automation:** [Playwright, Cypress, etc.]
- **Test Management:** [Testmo, Jira, etc.]
- **Monitoring:** [Observability tools, log sources]

## 4. Test Data Strategy
- **Data Sources:** [Production-like vs synthetic]
- **Data Refresh:** [How often test data is reset]
- **Boundary Values:** [Key boundary scenarios]
- **Security Payloads:** [SQL injection, XSS test data]

## 5. Automation Strategy
- **Automation Scope:** [What will be automated vs manual]
- **Frameworks:** [Specific tools and versions]
- **CI/CD Integration:** [Pipeline hooks, smoke suite]
- **Selectors Strategy:** [data-testid preferred, stable DOM attributes]

## 6. Non-Functional Requirements

### Performance Targets
- [Specific, measurable performance goals]
- Example: "API response time < 800ms"
- Example: "Page load < 3 seconds on broadband"

### Security Requirements
- [Authentication/authorization testing]
- [Common vulnerability checks]
- [Data privacy compliance]

### Accessibility Requirements
- [WCAG 2.1 AA compliance]
- [Screen reader testing]
- [Keyboard navigation]

## 7. Risk Assessment

| Risk Area | Impact | Probability | Mitigation |
|-----------|--------|-------------|------------|
| [Risk 1]  | High   | Medium      | [Strategy] |
| [Risk 2]  | Medium | High        | [Strategy] |

## 8. Entry & Exit Criteria

### Entry Criteria
- [ ] Feature requirements documented in feature-knowledge.md
- [ ] Test environments available and stable
- [ ] Test data available
- [ ] Test tools configured

### Exit Criteria
- [ ] No open Critical/High severity defects (or approved waivers)
- [ ] ≥ 95% of High priority test cases executed
- [ ] All planned automation smoke suites passing
- [ ] Performance/Security benchmarks met or waivers approved

## 9. Deliverables
- Test plans per ticket (referencing this strategy)
- Test cases (manual and automated)
- Bug reports following QA Agent OS standards
- Test execution reports
- Test data packages

## 10. Roles & Responsibilities
- **QA Lead:** [Responsibilities]
- **QA Engineer:** [Responsibilities]
- **Automation Engineer:** [Responsibilities]
- **Developers:** [Responsibilities]
```

---

## Recommended Template: [ticket-id]/test-plan.md

Ticket-level plans should be more detailed and tactical:

```markdown
# Test Plan: [Ticket ID] - [Ticket Title]

## Reference
**Feature Test Strategy:** `../feature-test-strategy.md`
**Feature Knowledge:** `../feature-knowledge.md`
**Ticket Documentation:** `documentation/ticket-info.md`

## 1. Ticket Overview
- **Ticket ID:** [e.g., JIRA-123]
- **Summary:** [Brief description]
- **Acceptance Criteria:** [From ticket]

## 2. Test Scope
**In Scope for this ticket:**
- [Specific functionality to test]

**Out of Scope for this ticket:**
- [What's not being tested in this ticket]

**Dependencies:**
- [Related tickets, APIs, services]

## 3. Testable Requirements

| Req ID | Requirement Summary | Input Conditions | Expected Output |
|--------|---------------------|------------------|-----------------|
| RQ-01  | [Description]       | [Inputs]         | [Outputs]       |
| RQ-02  | [Description]       | [Inputs]         | [Outputs]       |

## 4. Test Coverage Matrix

| Requirement ID | Test Case IDs | Coverage Type | Priority |
|----------------|---------------|---------------|----------|
| RQ-01          | TC-01, TC-02  | Positive, Negative | High |
| RQ-02          | TC-03, TC-04  | Edge, Failure      | Medium |

## 5. Test Scenarios & Cases

| Test ID | Title | Preconditions | Steps | Expected Result | Test Type | Priority |
|---------|-------|---------------|-------|-----------------|-----------|----------|
| TC-01   | [Title] | [Setup] | [Steps] | [Expected] | Functional | High |
| TC-02   | [Title] | [Setup] | [Steps] | [Expected] | Negative | High |

## 6. Test Data Requirements

| Data ID | Data Type | Sample Value | Purpose |
|---------|-----------|--------------|---------|
| D-01    | Valid User | user@example.com | Positive path |
| D-02    | Invalid Data | [value] | Negative test |

## 7. Environment Setup
- **URL:** [Specific environment URL]
- **Test Accounts:** [Accounts needed]
- **Feature Flags:** [Any flags to enable/disable]

## 8. Execution Timeline
- **Start Date:** [Date]
- **End Date:** [Date]
- **Resources:** [Who is testing]

## 9. Entry/Exit Criteria

### Entry
- [ ] Ticket deployed to test environment
- [ ] Test data available
- [ ] No blocking defects

### Exit
- [ ] All High priority test cases executed
- [ ] No open Critical/High defects
- [ ] Test evidence documented

## 10. Revisions

| Date | Change | Reason |
|------|--------|--------|
| [Date] | [What changed] | [Why it changed] |
```

---

## Command Flow Analysis

Based on user's confirmed sequence:

1. `/init-feature` → Creates feature folder, feature-knowledge.md, feature-test-strategy.md
2. `/gather-feature-docs` → Collects documentation from PO/devs into feature/documentation/
3. `/consolidate-feature-knowledge` → Analyzes docs, creates/updates feature-knowledge.md
4. `/init-ticket` → Creates ticket folder under feature, ticket documentation structure
5. `/analyze-ticket-requirements` → Analyzes ticket, creates test-plan.md referencing feature strategy
6. `/revise-sqa-plan` (optional, repeatable) → Updates test-plan.md as new discoveries emerge
7. `/generate-testcases` → Generates test-cases.md from test-plan.md

**This flow aligns perfectly with industry standards** and the feature → ticket hierarchy.

---

## Follow-Up Questions for User

While the research provides strong recommendations, these questions need answers to finalize the specification:

### 1. Command Triggering & Automation
- Does `/gather-feature-docs` run **automatically** after `/init-feature`, or is it **manual**?
- Should there be a `/create-feature-test-strategy` command separate from `/init-feature`, or should strategy creation be part of initialization?
- Do you envision any commands running in **sequence automatically** (like a workflow), or should each command be manually triggered?

### 2. Ticket Lifecycle & Quality Gates
- Should there be a `/close-ticket` or `/verify-ticket-complete` command that:
  - Verifies all test cases from test-plan.md have been executed?
  - Checks that no open Critical/High bugs exist?
  - Confirms exit criteria are met?
  - Optionally updates Jira ticket status?
- What should happen if a QA tries to close a ticket with incomplete testing?

### 3. Jira Integration in New Workflow
- You have existing `/jira-integration` commands. How do they fit into this redesigned workflow?
- Should `/init-ticket` optionally **pull ticket data from Jira** automatically?
- Should `/analyze-ticket-requirements` be able to **read Jira ticket fields** (description, acceptance criteria, attachments)?
- Should test execution results be **pushed back to Jira** at any point?

### 4. Feature Knowledge Updates
- When a new ticket is added to an existing feature that already has `feature-knowledge.md`, should:
  - **Option A:** `/init-ticket` check if new ticket introduces requirements not in feature-knowledge.md and prompt to update?
  - **Option B:** Require manual execution of `/consolidate-feature-knowledge` again?
  - **Option C:** `/analyze-ticket-requirements` automatically append to feature-knowledge.md if gaps detected?

### 5. Test Strategy Evolution
- When should `feature-test-strategy.md` be updated?
  - When new test types are needed (e.g., first ticket needs performance testing)?
  - When new tools/environments are added?
  - When risks change?
- Should there be a `/revise-feature-strategy` command, or should updates be manual edits?

### 6. Template Preferences
- Should we use the **simpler 8-section template** from `test-plan-template.md` for ticket-level plans?
- Or the **comprehensive 16-section framework** from `qa_test_design_template.md`?
- Or create a **hybrid** that takes the best of both?

### 7. Standards Alignment
- The user said "do NOT use the 12-section template" for SQA plans. Can you clarify:
  - Was this referring to a specific template you had in mind?
  - Should we base ticket test plans on the existing QA Agent OS standards (test-plan-template.md and qa_test_design_template.md)?

### 8. Testmo/CSV Export
- Should test case generation (`/generate-testcases`) automatically create:
  - CSV export for Testmo?
  - JSON export for API import?
- Or should there be a separate `/export-testcases` command?

---

## Summary of Research-Based Recommendations

1. **Feature-level should include both `feature-knowledge.md` AND `feature-test-strategy.md`** to align with industry standards
2. **Use hierarchical strategy → plan model:** Feature strategy is strategic/reusable, ticket plans are tactical/specific
3. **Leverage existing QA Agent OS templates:** Both test-plan-template.md and qa_test_design_template.md are excellent and align with industry standards
4. **Recommended command sequence is sound:** init-feature → gather-docs → consolidate → init-ticket → analyze → revise → generate
5. **Need clarity on:** Command automation, quality gates, Jira integration, knowledge updates, and template preferences

---

## Next Steps

Once the follow-up questions are answered, we can:
1. Finalize the exact structure of `feature-test-strategy.md` and `[ticket-id]/test-plan.md`
2. Define command specifications for each step in the workflow
3. Map integration points with Jira and Testmo
4. Create comprehensive requirements documentation
5. Begin implementation planning
