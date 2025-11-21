# Command Specifications: QA Workflow Redesign

This document provides detailed specifications for each command in the redesigned QA workflow.

## Command Overview

| Command | Purpose | Orchestrated | Phases |
|---------|---------|--------------|--------|
| `/plan-feature` | Initialize and plan entire feature | Yes | 4 |
| `/plan-ticket` | Initialize and plan ticket testing | Yes | 3-4 (flexible) |
| `/generate-testcases` | Generate or regenerate test cases | No | Standalone |
| `/revise-test-plan` | Update test plan during testing | No | Standalone |
| `/update-feature-knowledge` | Manually update feature knowledge | No | Standalone |

---

## 1. `/plan-feature [feature-name]`

### Purpose
Complete feature initialization and planning. Creates feature structure, gathers documentation, consolidates knowledge, and creates test strategy.

### Usage
```bash
/plan-feature TWRR
/plan-feature "Portfolio Analytics"
```

### Phases

#### Phase 1: Initialize Feature Structure
**What it does:**
- Creates `features/[feature-name]/` directory
- Creates `features/[feature-name]/documentation/` subdirectory
- Initializes folder structure

**Output:**
```
features/
  [feature-name]/
    documentation/
```

**User interaction:** None (automatic)

---

#### Phase 2: Gather Feature Documentation
**What it does:**
- Prompts QA for documentation from all stakeholders
- Stores documents in `documentation/` folder
- Creates audit trail of collected documents

**Prompts:**
```
"Let's gather documentation for [feature-name]."

1. "Do you have a Business Requirements Document (BRD)?"
   Options: [File path] [Paste content] [Skip]

2. "Do you have API specifications or contracts?"
   Options: [File path] [Paste content] [Skip]

3. "Do you have backend calculation logic or business rules?"
   Options: [File path] [Paste content] [Skip]

4. "Do you have UI mockups or wireframes?"
   Options: [Upload files to documentation/mockups/] [Skip]

5. "Do you have any other technical documentation?"
   Options: [File path] [Paste content] [Skip]
```

**Output:**
- Files stored in `documentation/`
- `documentation/COLLECTION_LOG.md` created with metadata:
  ```markdown
  # Documentation Collection Log

  **Feature:** [feature-name]
  **Date:** 2025-11-20
  **Collected by:** QA Agent OS

  ## Documents Collected

  1. **BRD** - brd-from-po.pdf (collected: 2025-11-20 10:23)
  2. **API Specs** - api-endpoints.yaml (collected: 2025-11-20 10:24)
  3. **Business Rules** - [pasted content] → business-rules.md
  4. **Mockups** - 3 files in documentation/mockups/
  ```

**User interaction:** Multiple prompts with file uploads or content pasting

---

#### Phase 3: Consolidate Feature Knowledge
**What it does:**
- Reads ALL documents from `documentation/`
- Performs deep analysis to extract:
  - Core functionality and purpose
  - Business rules and calculations
  - Data flows and dependencies
  - Edge cases and constraints
  - Integration points
- Creates comprehensive `feature-knowledge.md`

**Analysis Process:**
1. Read each document thoroughly
2. Extract testable facts and requirements
3. Organize by logical sections
4. Cross-reference between documents
5. Identify gaps or ambiguities

**Output:** `features/[feature-name]/feature-knowledge.md`

**Template Structure:**
```markdown
# Feature Knowledge: [Feature Name]

**Last Updated:** 2025-11-20
**Status:** Active

## 1. Feature Overview

### Purpose
[High-level description of what this feature does and why it exists]

### Scope
**In Scope:**
- [List of included functionality]

**Out of Scope:**
- [Explicitly excluded items]

## 2. Business Requirements

### Core Functionality
[Detailed description of main features]

### Business Rules
1. **[Rule Name]:** [Description]
   - **Example:** [Concrete example]
   - **Exception:** [Any exceptions to the rule]

### Calculations & Formulas
[If applicable - mathematical formulas, calculation logic]

## 3. Technical Requirements

### API Endpoints
[List of relevant endpoints with request/response formats]

### Data Model
[Entities, relationships, data types]

### Dependencies
- **Internal:** [Other features/modules this depends on]
- **External:** [Third-party services, APIs]

## 4. User Experience

### User Flows
[Key user journeys through the feature]

### UI Components
[Screens, forms, interactions]

## 5. Edge Cases & Constraints

### Known Edge Cases
1. [Description of edge case and expected behavior]

### Business Constraints
1. [Regulatory, business, or technical constraints]

## 6. Test Considerations

### Critical Paths
[Most important scenarios to test]

### Risk Areas
[High-risk functionality requiring extra attention]

### Data Requirements
[Special test data needed]

## 7. Open Questions

[List of ambiguities or missing information]

## 8. Document Sources

**Generated from:**
- BRD: `documentation/brd-from-po.pdf`
- API Specs: `documentation/api-endpoints.yaml`
- Business Rules: `documentation/business-rules.md`

**Last Consolidation:** 2025-11-20
```

**User interaction:** None (automatic analysis)

---

#### Phase 4: Create Feature Test Strategy
**What it does:**
- Creates high-level strategic test approach
- Defines test levels, types, tools, environments
- Sets non-functional requirements
- Establishes risk assessment

**Prompts:**
```
"Now let's create the test strategy for [feature-name]."

1. "What test levels are needed for this feature?"
   Options (multi-select):
   [ ] Unit Testing
   [ ] API Testing
   [ ] UI Testing
   [ ] Integration Testing
   [ ] End-to-End Testing

2. "What test types should be covered?"
   Options (multi-select):
   [ ] Functional
   [ ] Performance
   [ ] Security
   [ ] Accessibility
   [ ] Usability
   [ ] Regression

3. "What testing tools/frameworks will you use?"
   [Text input - e.g., "Postman, Playwright, K6"]

4. "What test environments are available?"
   [Text input - e.g., "Dev, Staging, Production"]

5. "Are there specific performance requirements?"
   [Yes/No]
   If Yes: [Prompt for specific metrics]

6. "Are there security/compliance requirements?"
   [Yes/No]
   If Yes: [Prompt for requirements]
```

**Output:** `features/[feature-name]/feature-test-strategy.md`

**Template Structure:**
```markdown
# Feature Test Strategy: [Feature Name]

**Version:** 1.0
**Created:** 2025-11-20
**Status:** Active

## 1. Testing Objective

### Goal
[What this testing aims to achieve]

### Scope
**In Scope:**
- [Test levels and types included]

**Out of Scope:**
- [What won't be tested at feature level]

## 2. Test Approach

### Test Levels
- **API Testing:** [Approach, tools, coverage]
- **UI Testing:** [Approach, tools, coverage]
- **Integration Testing:** [Approach, tools, coverage]

### Test Types Coverage
| Type | Approach | Priority |
|------|----------|----------|
| Functional | [Approach] | High |
| Performance | [Approach] | Medium |
| Security | [Approach] | High |

## 3. Test Environment & Tools

### Environments
| Environment | URL/Access | Purpose |
|-------------|------------|---------|
| Dev | [URL] | Development testing |
| Staging | [URL] | Pre-production validation |

### Tools & Frameworks
- **API Testing:** Postman, Newman
- **UI Testing:** Playwright
- **Performance:** K6
- **CI/CD:** GitHub Actions

## 4. Test Data Strategy

### Data Sources
[Where test data comes from]

### Data Refresh
[How often test data is refreshed]

### Boundary Values
[Key boundary conditions to test]

## 5. Automation Strategy

### Automation Scope
- **Candidates for Automation:** [Scenarios suitable for automation]
- **Manual Only:** [Scenarios requiring manual testing]

### Automation Framework
[Framework choice and approach]

### CI/CD Integration
[How automated tests integrate with pipeline]

### Selector Strategy
[For UI tests - data-testid, CSS selectors, etc.]

## 6. Non-Functional Requirements

### Performance
- **Target:** [Specific, measurable targets]
- **Example:** "API response < 800ms for 95th percentile"

### Security
- **Requirements:** [Security testing requirements]
- **Example:** "Test authorization on all endpoints"

### Accessibility
- **Standard:** WCAG 2.1 AA
- **Tools:** Axe, Pa11y

### Compatibility
- **Browsers:** Chrome 108+, Firefox 107+, Safari 16+
- **Devices:** Desktop, Tablet, Mobile

## 7. Risk Assessment

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| [Risk description] | High/Med/Low | High/Med/Low | [How to mitigate] |

## 8. Entry & Exit Criteria

### Entry Criteria (Feature-Level)
- [ ] Feature development complete
- [ ] Feature deployed to test environment
- [ ] Test data available

### Exit Criteria (Feature-Level)
- [ ] All high-priority tickets tested
- [ ] No open Critical/High bugs
- [ ] Performance targets met
- [ ] Security review complete

## 9. Deliverables

### Per Ticket
- Test plan (test-plan.md)
- Test cases (test-cases.md)
- Test results
- Bug reports

### Feature-Level
- Consolidated test summary
- Performance test results
- Security test results

## 10. Roles & Responsibilities

| Role | Responsibility |
|------|----------------|
| QA Lead | Strategy approval, risk assessment |
| QA Engineer | Test execution, bug reporting |
| Developer | Bug fixes, test environment support |
```

**User interaction:** Multiple prompts for strategic decisions

---

### Success Criteria
- Feature folder structure created
- All relevant documentation collected
- Comprehensive feature-knowledge.md created
- Strategic feature-test-strategy.md created
- QA ready to start ticket planning

### Error Handling
- If feature already exists: Prompt "Feature [name] already exists. [1] Re-plan [2] Cancel"
- If no documentation provided: Warn "No documentation collected. Continue anyway? [y/n]"

---

## 2. `/plan-ticket [ticket-id]`

### Purpose
Initialize and plan testing for a specific ticket. Creates ticket structure, gathers docs, analyzes requirements, creates test plan, optionally generates test cases.

### Usage
```bash
/plan-ticket WYX-123
/plan-ticket "WYX-123"
```

### Smart Detection
- If ticket folder already exists → Show re-execution options
- If multiple features exist → Prompt for feature selection
- If only one feature exists → Auto-select it

---

### Initial Detection: Feature Selection

**When:** First run or new ticket
**Prompt:**
```
"Which feature does ticket [ticket-id] belong to?"

Features found:
  [1] TWRR
  [2] Portfolio-Analytics
  [3] Create new feature

Choose [1/2/3]:
```

**If only one feature:** Auto-select with confirmation
```
"Found feature: TWRR. Is this correct? [y/n]"
```

**If "Create new feature" selected:**
```
"Enter new feature name:"
[Redirects to /plan-feature internally, then returns to /plan-ticket]
```

---

### Initial Detection: Existing Ticket Check

**When:** Ticket folder already exists
**Prompt:**
```
"Ticket [ticket-id] already exists in feature [feature-name]."

Options:
  [1] Full re-plan (Phases 1-4: re-gather docs, re-analyze, regenerate)
  [2] Update test plan only (Skip to Phase 3: re-analyze requirements)
  [3] Regenerate test cases only (Skip to Phase 4: use existing test-plan.md)
  [4] Cancel

Choose [1/2/3/4]:
```

**Behavior based on choice:**
- **1:** Run all 4 phases (full re-plan)
- **2:** Run Phase 3 only (re-analyze and update test-plan.md)
- **3:** Run Phase 4 only (regenerate test-cases.md from existing test-plan.md)
- **4:** Exit command

---

### Phases (New Ticket)

#### Phase 1: Initialize Ticket Structure
**What it does:**
- Creates `features/[feature-name]/[ticket-id]/` directory
- Creates `features/[feature-name]/[ticket-id]/documentation/` subdirectory
- Creates `features/[feature-name]/[ticket-id]/documentation/visuals/` subdirectory

**Output:**
```
features/
  [feature-name]/
    [ticket-id]/
      documentation/
        visuals/
```

**User interaction:** None (automatic)

---

#### Phase 2: Gather Ticket Documentation
**What it does:**
- Prompts QA for ticket-specific documentation
- Stores in ticket's `documentation/` folder

**Prompts:**
```
"Let's gather documentation for ticket [ticket-id]."

1. "Do you have the Jira ticket export or PDF?"
   Options: [File path] [Paste ticket details] [Skip]

2. "Do you have ticket-specific requirements or acceptance criteria?"
   Options: [File path] [Paste content] [Skip]

3. "Do you have technical specs for this ticket?"
   Options: [File path] [Paste content] [Skip]

4. "Do you have mockups or screenshots for this ticket?"
   Options: [Upload to documentation/visuals/] [Skip]

5. "Do you have API request/response examples?"
   Options: [File path] [Paste content] [Skip]

6. "Any other ticket-specific documentation?"
   Options: [File path] [Paste content] [Skip]
```

**Output:**
- Files stored in `documentation/`
- `documentation/COLLECTION_LOG.md` created

**User interaction:** Multiple prompts

---

#### Phase 3: Analyze Ticket Requirements
**What it does:**
- Reads ticket documentation
- Reads `feature-knowledge.md`
- Reads `feature-test-strategy.md`
- Compares ticket requirements against feature knowledge
- **Detects gaps** in feature knowledge
- Creates comprehensive `test-plan.md`

**Analysis Process:**
1. **Read ticket documentation** thoroughly
2. **Read feature-knowledge.md** to understand context
3. **Compare:** Identify if ticket introduces NEW information not in feature-knowledge.md
4. **Gap detection:**
   - New business rules?
   - New calculations?
   - New API endpoints?
   - New edge cases?
5. **If gaps found:** Prompt QA to update feature-knowledge.md
6. **Extract testable requirements** from ticket
7. **Create test coverage matrix**
8. **Generate test plan**

**Gap Detection Prompt:**
```
"I found new information not in feature-knowledge.md:

  - New business rule: TWRR calculation for partial periods
  - New API endpoint: POST /api/twrr/calculate-partial
  - New edge case: Handle portfolios with zero starting value

Would you like me to append this to feature-knowledge.md? [y/n]"
```

**If yes:**
```
Appending to features/[feature-name]/feature-knowledge.md...

## [Section added from ticket [ticket-id] on 2025-11-20]

### Partial Period Calculations
[Content from ticket analysis]

**Source:** Ticket [ticket-id]
**Added:** 2025-11-20 during ticket requirement analysis
```

**Output:** `features/[feature-name]/[ticket-id]/test-plan.md`

**Template Structure:**
```markdown
# Test Plan: [Ticket-ID]

**Feature:** [Feature Name]
**Ticket ID:** [ticket-id]
**Created:** 2025-11-20
**Version:** 1.0

## 1. References

### Feature Documentation
- **Feature Knowledge:** `../feature-knowledge.md`
- **Feature Test Strategy:** `../feature-test-strategy.md`

### Ticket Documentation
- **Ticket Source:** `documentation/ticket-from-jira.pdf`
- **Technical Specs:** `documentation/technical-specs.md`
- **Mockups:** `documentation/visuals/`

## 2. Ticket Overview

### Ticket Summary
[Brief description of what this ticket aims to accomplish]

### Acceptance Criteria
1. [Criterion 1]
2. [Criterion 2]
3. [Criterion 3]

## 3. Test Scope

### In Scope
- [What will be tested for this ticket]

### Out of Scope
- [What won't be tested for this ticket]

### Dependencies
- **Internal:** [Required features/data]
- **External:** [Required services/APIs]

## 4. Testable Requirements

**Requirements extracted from ticket and analyzed for testability:**

| Req ID | Requirement Summary | Input Conditions | Expected Output | Priority |
|--------|---------------------|------------------|-----------------|----------|
| RQ-01 | [Requirement] | [Input] | [Expected] | High |
| RQ-02 | [Requirement] | [Input] | [Expected] | High |

## 5. Test Coverage Matrix

**Traceability: Requirements → Test Cases**

| Requirement ID | Test Case IDs | Coverage Type | Status |
|----------------|---------------|---------------|--------|
| RQ-01 | TC-01, TC-02, TC-03 | Positive, Negative, Edge | Planned |
| RQ-02 | TC-04, TC-05 | Positive, Negative | Planned |

## 6. Test Scenarios & Cases

### Scenario 1: [Scenario Name]

**Objective:** [What we're validating]

#### TC-01: [Test Case Title]
- **Type:** Functional - Positive
- **Priority:** High
- **Preconditions:** [Setup required]
- **Test Steps:**
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
- **Expected Result:** [What should happen]
- **Test Data:** [Reference to data in Section 7]

#### TC-02: [Test Case Title - Negative]
- **Type:** Functional - Negative
- **Priority:** High
- **Preconditions:** [Setup required]
- **Test Steps:**
  1. [Step 1 - use invalid input]
  2. [Step 2]
- **Expected Result:** [Error handling behavior]

#### TC-03: [Test Case Title - Edge Case]
- **Type:** Functional - Edge
- **Priority:** Medium
- **Preconditions:** [Setup required]
- **Test Steps:**
  1. [Step 1 - boundary value]
  2. [Step 2]
- **Expected Result:** [Boundary behavior]

### Scenario 2: Dependency Failure Testing

#### TC-04: API Returns 500 Error
- **Type:** Dependency Failure
- **Priority:** High
- **Preconditions:** Mock API to return 500
- **Test Steps:**
  1. [Trigger action that calls API]
  2. [Observe system behavior]
- **Expected Result:** User-friendly error message, no crash

## 7. Test Data Requirements

| Data ID | Data Type | Sample Value | Purpose | Test Cases |
|---------|-----------|--------------|---------|------------|
| D-01 | Valid User | user@example.com | Positive path | TC-01 |
| D-02 | Invalid Input | [malformed data] | Negative test | TC-02 |
| D-03 | Boundary Value | [min/max value] | Edge case | TC-03 |

## 8. Environment Setup

### Test Environment
- **URL:** https://dev.example.com
- **Credentials:** [Reference to secure storage]

### Configuration
- **Feature Flags:** [Any flags needed]
- **Test Accounts:** [Specific accounts required]

## 9. Execution Timeline

| Milestone | Date | Status |
|-----------|------|--------|
| Test plan review | 2025-11-21 | Pending |
| Test case generation | 2025-11-21 | Pending |
| Test execution | 2025-11-22 | Pending |

## 10. Entry & Exit Criteria

### Entry Criteria
- [ ] Ticket deployed to test environment
- [ ] Test data available
- [ ] Dependencies verified working

### Exit Criteria
- [ ] All test cases executed
- [ ] No open Critical/High bugs
- [ ] Acceptance criteria met
- [ ] Regression tests passed

## 11. Revisions

### Change Log

**Version 1.0 - 2025-11-20**
- Initial test plan created
```

**User interaction:**
- Gap detection prompts (if new info found)
- Confirmation prompts

---

#### Phase 4: Generate Test Cases (OPTIONAL)

**When:** After Phase 3 completes
**Prompt:**
```
"Test plan created at: features/[feature-name]/[ticket-id]/test-plan.md

Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first, generate test cases later)

Choose [1/2]:"
```

**If option 1 selected:**
- Proceeds to generate test-cases.md (see `/generate-testcases` specification)

**If option 2 selected:**
```
✓ Test plan ready for review at: features/[feature-name]/[ticket-id]/test-plan.md

You can generate test cases later by running:
  /generate-testcases
```

---

### Success Criteria
- Ticket folder structure created
- Documentation gathered and organized
- Test plan created with comprehensive coverage
- Feature knowledge updated if gaps detected
- Test cases generated (if option 1 chosen)

### Error Handling
- If feature doesn't exist: Create it or prompt to select different feature
- If no test plan scenarios: Warn and ask to add more detail

---

## 3. `/generate-testcases`

### Purpose
Generate or regenerate test cases from test plan. Can be called standalone or as part of `/plan-ticket` Phase 4.

### Usage
```bash
/generate-testcases
/generate-testcases WYX-123  # Optional: specify ticket
```

### Behavior

**If no ticket specified:**
```
"Which ticket's test cases to generate?"

Recent tickets:
  [1] WYX-125 (no test-cases.md yet) ← NEW
  [2] WYX-124 (test-cases.md exists - last updated 2025-11-19)
  [3] WYX-123 (test-cases.md exists - last updated 2025-11-18)

Choose [1/2/3]:
```

**If test-cases.md already exists:**
```
"Warning: test-cases.md already exists for ticket [ticket-id]
Last updated: 2025-11-19 14:23

Options:
  [1] Overwrite (regenerate completely)
  [2] Append (add new cases, keep existing)
  [3] Cancel

Choose [1/2/3]:"
```

### Generation Process

1. **Read test-plan.md**
   - Extract all test scenarios from Section 6
   - Extract test data from Section 7
   - Extract coverage matrix from Section 5

2. **Generate detailed test cases**
   - Expand each scenario into executable test cases
   - Include positive, negative, edge, and dependency failure cases
   - Add detailed steps, expected results, test data

3. **Create test-cases.md**

### Output Template

```markdown
# Test Cases: [Ticket-ID]

**Feature:** [Feature Name]
**Ticket:** [ticket-id]
**Generated:** 2025-11-20
**Total Cases:** 23

**Source:** Generated from `test-plan.md` version 1.0

---

## Test Execution Summary

| Status | Count |
|--------|-------|
| Not Started | 23 |
| Passed | 0 |
| Failed | 0 |
| Blocked | 0 |

---

## TC-01: [Test Case Title from Plan]

**Test ID:** TC-01
**Type:** Functional - Positive
**Priority:** High
**Requirement:** RQ-01

### Objective
[What this test validates]

### Preconditions
- [Setup step 1]
- [Setup step 2]

### Test Data
- **Data ID:** D-01
- **User:** user@example.com
- **Password:** [from secure vault]

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to login page | Login form displayed |
| 2 | Enter valid credentials (D-01) | Fields accept input |
| 3 | Click "Login" button | User redirected to dashboard |

### Expected Final Result
✓ User successfully logged in and viewing dashboard

### Actual Result
[ ] Pass  [ ] Fail  [ ] Blocked

**Notes:**
_[Space for tester notes]_

**Defects:**
_[Link to bugs if any]_

---

## TC-02: [Negative Test Case Title]

**Test ID:** TC-02
**Type:** Functional - Negative
**Priority:** High
**Requirement:** RQ-02

### Objective
Verify system rejects invalid credentials

### Preconditions
- User account exists

### Test Data
- **Data ID:** D-02
- **User:** user@example.com
- **Password:** wrong_password

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to login page | Login form displayed |
| 2 | Enter invalid password (D-02) | Fields accept input |
| 3 | Click "Login" button | Error message displayed |

### Expected Final Result
✓ Error message: "Invalid credentials"
✓ User remains on login page
✓ No system crash

### Actual Result
[ ] Pass  [ ] Fail  [ ] Blocked

---

## TC-03: [Edge Case Title]

**Test ID:** TC-03
**Type:** Functional - Edge Case
**Priority:** Medium
**Requirement:** RQ-01

### Objective
Test boundary condition: minimum valid input

[... similar structure ...]

---

## TC-04: [Dependency Failure Case]

**Test ID:** TC-04
**Type:** Dependency Failure
**Priority:** High
**Requirement:** RQ-01

### Objective
Verify graceful handling when authentication API returns 500 error

### Preconditions
- Mock authentication API to return 500 error

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Configure API mock to return 500 | Mock configured |
| 2 | Navigate to login page | Login form displayed |
| 3 | Enter valid credentials | Fields accept input |
| 4 | Click "Login" button | System handles error gracefully |

### Expected Final Result
✓ User-friendly error message displayed
✓ Message: "Something went wrong. Please try again later."
✓ No stack trace visible
✓ Application does not crash

---

[... continues for all 23 test cases ...]

---

## Test Data Reference

| Data ID | Description | Value |
|---------|-------------|-------|
| D-01 | Valid user credentials | user@example.com / [vault] |
| D-02 | Invalid password | user@example.com / wrong_password |
| D-03 | Boundary value test | [specific boundary data] |

---

## Notes

**Coverage:**
- Functional: 15 cases
- Negative: 4 cases
- Edge Cases: 2 cases
- Dependency Failure: 2 cases

**Automation Candidates:**
- TC-01, TC-02 (login flows)
- TC-04 (API failure handling)

**Manual Only:**
- TC-15 (visual validation)
```

### Success Criteria
- All scenarios from test-plan.md converted to executable test cases
- Each case has clear steps and expected results
- Test data referenced correctly
- Ready for execution

---

## 4. `/revise-test-plan`

### Purpose
Update test plan during testing when new scenarios, edge cases, or requirements are discovered.

### Usage
```bash
/revise-test-plan
/revise-test-plan WYX-123  # Optional: specify ticket
```

### Behavior

**If no ticket specified:**
```
"Which ticket's test plan to revise?"

Active tickets:
  [1] WYX-125 (currently testing)
  [2] WYX-124 (testing complete)
  [3] WYX-123 (testing in progress)

Choose:
```

**Main prompt:**
```
"What did you discover during testing?"

Options:
  [1] New edge case found
  [2] New test scenario needed
  [3] Existing scenario needs update
  [4] New requirement discovered
  [5] Test data needs adjustment

Choose:
```

### Update Process

**For each update type, prompt for details:**

#### Option 1: New Edge Case
```
"Describe the edge case:"
[QA input]

"What is the expected behavior?"
[QA input]

"Priority? [High/Medium/Low]"
[QA input]
```

**Updates test-plan.md:**
- Adds new requirement to Section 4
- Adds new test case to Section 6
- Updates coverage matrix in Section 5
- Adds entry to Revisions section (Section 11)

#### Revision Log Entry
```markdown
## 11. Revisions

### Change Log

**Version 1.1 - 2025-11-20 14:35**
- Added edge case: TWRR calculation fails when portfolio has zero starting value
- New requirement: RQ-06
- New test case: TC-15 (test zero-value portfolio handling)
- Reason: Discovered during test execution of TC-03

**Version 1.0 - 2025-11-20**
- Initial test plan created
```

### Regenerate Prompt

After updating test-plan.md:
```
"Test plan updated. Would you like to regenerate test cases now? [y/n]"
```

**If yes:** Calls `/generate-testcases` internally
**If no:**
```
✓ Test plan updated at: features/[feature-name]/[ticket-id]/test-plan.md

You can regenerate test cases later by running:
  /generate-testcases
```

### Success Criteria
- Test plan updated with new information
- Revision logged with timestamp and reason
- Test cases regenerated if requested

---

## 5. `/update-feature-knowledge`

### Purpose
Manually update feature-knowledge.md when needed (rare operation).

### Usage
```bash
/update-feature-knowledge
/update-feature-knowledge TWRR  # Optional: specify feature
```

### Behavior

**If no feature specified:**
```
"Which feature's knowledge to update?"

Features:
  [1] TWRR
  [2] Portfolio-Analytics

Choose:
```

**Main prompt:**
```
"What would you like to update?"

Options:
  [1] Add new business rule
  [2] Add new API endpoint
  [3] Update existing information
  [4] Add edge case documentation
  [5] Add open question

Choose:
```

### Update Process

Prompts for details based on selection, then appends to or updates feature-knowledge.md with proper metadata.

**Example append:**
```markdown
## [Section added manually on 2025-11-20]

### New Business Rule: Late Payment Penalties

[Content from QA input]

**Source:** Manual update
**Added:** 2025-11-20
**Reason:** Discovered during requirement review meeting
```

### Success Criteria
- Feature knowledge updated
- Metadata added for traceability
- QA notified of update location

---

## Command Interaction Patterns

### Pattern 1: Full Feature + Ticket Flow
```
/plan-feature TWRR
  → [4 phases run]
  → feature-knowledge.md created
  → feature-test-strategy.md created

/plan-ticket WYX-123
  → [Auto-detects feature: TWRR]
  → [Phases 1-3 run]
  → [Prompt: Generate test cases?]
  → [QA chooses: 2 - Stop and review]

[QA reviews test-plan.md, gets more info from PO]

/generate-testcases
  → [Prompts for ticket: WYX-123]
  → test-cases.md created

[QA executes tests, finds edge case]

/revise-test-plan
  → [Prompts for ticket: WYX-123]
  → [Prompts for discovery type]
  → test-plan.md updated
  → [Prompt: Regenerate test cases?]
  → [QA chooses: y]
  → test-cases.md regenerated
```

### Pattern 2: Quick Ticket Test Case Generation
```
/plan-ticket WYX-124
  → [Auto-detects feature: TWRR]
  → [Phases 1-3 run]
  → [Prompt: Generate test cases?]
  → [QA chooses: 1 - Generate now]
  → [Phase 4 runs]
  → test-cases.md created immediately
```

### Pattern 3: Re-analyze Existing Ticket
```
/plan-ticket WYX-123
  → [Detects: Ticket exists]
  → [Prompt: 4 options]
  → [QA chooses: 2 - Update test plan only]
  → [Phase 3 runs]
  → [Detects: 3 new requirements]
  → test-plan.md updated
  → [Prompt: Continue to Phase 4?]
  → [QA chooses: 1 - Yes]
  → test-cases.md regenerated
```

---

## Implementation Notes

### File References
- All commands should use relative paths within the qa-agent-os structure
- Commands should detect the current project root
- Support both `qa-agent-os/features/` and `features/` path formats

### Standards Integration
- All commands should reference existing standards from `qa-agent-os/standards/`
- Bug reporting should follow `standards/bugs/` templates
- Test case format should follow `standards/testcases/` conventions

### Error Handling
- Graceful handling of missing files
- Clear error messages for QA
- Suggestions for recovery (e.g., "Feature not found. Run /plan-feature first.")

### User Experience
- Progress indicators for long operations
- Clear prompts with default options
- Confirmation before destructive operations (overwrite, delete)
- Helpful messages pointing to created files

---

## Testing the Commands

### Test Scenario 1: New Feature
1. Run `/plan-feature TestFeature`
2. Verify folder structure created
3. Verify feature-knowledge.md and feature-test-strategy.md created
4. Check content quality

### Test Scenario 2: New Ticket (Full Flow)
1. Run `/plan-ticket TEST-001`
2. Select feature
3. Provide documentation
4. Choose option 1 (generate test cases)
5. Verify test-plan.md and test-cases.md created

### Test Scenario 3: Revision Flow
1. Run `/revise-test-plan`
2. Select ticket
3. Add edge case
4. Choose to regenerate
5. Verify test-plan.md updated with revision log
6. Verify test-cases.md regenerated

---

## Next Steps

These command specifications should be used as the foundation for implementing:
1. Individual phase markdown files for each command
2. Orchestrator markdown files that call the phases
3. Installation scripts to compile commands into `.claude/commands/`
4. Testing and validation of each workflow pattern
