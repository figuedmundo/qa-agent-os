# Requirement Analysis Workflow

This workflow analyzes ticket requirements, performs gap detection against feature knowledge, and creates a comprehensive test plan.

## Core Responsibilities

1. **Read Documentation**: Read ticket documentation and feature context
2. **Analyze Requirements**: Extract and organize ticket requirements
3. **Gap Detection**: Compare ticket requirements against feature knowledge to identify new information
4. **Feature Knowledge Update**: Prompt to update feature-knowledge.md if gaps are found
5. **Create Test Plan**: Generate comprehensive test-plan.md with 11 sections

**Note:** The placeholder `[ticket-path]` refers to the full path to the ticket, for example: `qa-agent-os/features/feature-name/TICKET-123`.

**Note:** The placeholder `[feature-knowledge-path]` refers to the path to feature-knowledge.md, for example: `qa-agent-os/features/feature-name/feature-knowledge.md`.

**Note:** The placeholder `[feature-strategy-path]` refers to the path to feature-test-strategy.md, for example: `qa-agent-os/features/feature-name/feature-test-strategy.md`.

---

## Workflow

### Step 1: Read All Available Information

Read ticket and feature documentation:

```bash
# Read ticket documentation
TICKET_DOCS="[ticket-path]/documentation/"
ls -la "$TICKET_DOCS"

# Read feature knowledge
FEATURE_KNOWLEDGE="[feature-knowledge-path]"
cat "$FEATURE_KNOWLEDGE"

# Read feature test strategy
FEATURE_STRATEGY="[feature-strategy-path]"
cat "$FEATURE_STRATEGY"
```

### Step 2: Analyze Ticket Requirements

Extract and organize ticket-specific information:

**Main Objectives:**
- What is the ticket trying to accomplish?
- What are the acceptance criteria?

**Business Rules:**
- Ticket-specific business logic
- Calculations or validations
- Conditional behavior

**Technical Details:**
- API endpoints used or modified
- Input/output specifications
- Data transformations

**Edge Cases:**
- Boundary values
- Error conditions
- Special handling scenarios

**User Flows:**
- Step-by-step user interactions
- Screen transitions
- User inputs and system responses

### Step 3: Compare Against Feature Knowledge - Gap Detection

Compare ticket requirements against existing feature-knowledge.md to identify gaps.

**Check for:**

1. **New Business Rules** - Logic not documented in feature knowledge
2. **New API Endpoints** - Endpoints not in Section 4 of feature-knowledge.md
3. **New Calculations** - Technical requirements not documented
4. **New Edge Cases** - Scenarios not covered in Section 6 of feature-knowledge.md
5. **New User Flows** - Interactions not in Section 3 of feature-knowledge.md

**For each gap found:**
- Document the gap type
- Note the specific new information
- Reference the source (ticket documentation)

### Step 4: Prompt for Feature Knowledge Update

**If gaps are found:**

Prompt the user with a clear summary of what's new:

```
Gap Detection: I found new information not in feature-knowledge.md

New Business Rule:
- [Description of new business logic]
- Source: [ticket documentation reference]

New API Endpoint:
- POST /api/[endpoint]
- [Description of endpoint purpose]
- Source: [ticket documentation reference]

New Edge Case:
- [Description of edge case]
- Source: [ticket documentation reference]

Would you like me to append this to feature-knowledge.md? [y/n]
```

**If user chooses YES:**

1. Read current feature-knowledge.md
2. Append new information to appropriate sections:
   ```markdown
   ## [Section updated from ticket [ticket-id] on [date]]

   ### [Topic Name]
   [Content from ticket]

   **Source:** Ticket [ticket-id]
   **Added:** [date] during ticket requirement analysis
   **Type:** [Business Rule|API Endpoint|Edge Case|User Flow|Calculation]
   ```
3. Save updated feature-knowledge.md
4. Confirm update to user

**If user chooses NO:**
- Continue without updating feature knowledge
- Note in test plan that ticket has additional requirements

### Step 5: Create Test Plan

Create comprehensive test-plan.md at `[ticket-path]/test-plan.md` with 11 sections:

```markdown
# Test Plan: [Ticket ID]

**Created:** [Date]
**Version:** 1.0
**QA Analyst:** [Auto-detected or TBD]

---

## 1. References

**Feature Documentation:**
- Feature Knowledge: `[relative-path-to-feature-knowledge.md]`
- Feature Test Strategy: `[relative-path-to-feature-test-strategy.md]`

**Ticket Documentation:**
- Ticket folder: `[ticket-path]/documentation/`
- [List all documents found in ticket documentation folder]

**Related Tickets:**
- [List related tickets if mentioned in documentation]

---

## 2. Ticket Overview

**Summary:**
[Brief description of what this ticket accomplishes]

**Acceptance Criteria:**
- [AC 1]
- [AC 2]
- [AC N]

**Out of Scope:**
- [What will NOT be tested in this ticket]

---

## 3. Test Scope

**In Scope:**
- [What will be tested]
- [Features covered]
- [User flows tested]

**Out of Scope:**
- [What will NOT be tested]
- [Deferred to other tickets]
- [Known limitations]

**Testing Types:**
- [ ] Functional Testing
- [ ] API Testing
- [ ] UI Testing
- [ ] Integration Testing
- [ ] Performance Testing (if applicable)
- [ ] Security Testing (if applicable)

---

## 4. Testable Requirements

Break down requirements into testable items:

### REQ-01: [Requirement Name]
**Description:** [Detailed description]
**Priority:** [High|Medium|Low]
**Input:** [What goes in]
**Expected Output:** [What comes out]
**Business Rules:** [Applicable rules from feature knowledge]

### REQ-02: [Requirement Name]
[Continue for all requirements]

---

## 5. Test Coverage Matrix

| Requirement ID | Positive Tests | Negative Tests | Edge Cases | Dependency Failures |
|----------------|---------------|----------------|------------|---------------------|
| REQ-01         | TC-01         | TC-02          | TC-03      | TC-04              |
| REQ-02         | TC-05         | TC-06          | TC-07      | -                  |

**Coverage Goals:**
- All requirements must have at least 1 positive test
- All requirements must have at least 1 negative test
- All edge cases identified must have test coverage
- All dependency failures must be tested

---

## 6. Test Scenarios & Cases

### Positive Tests (Happy Path)
**TC-01: [Scenario Name]**
- **Objective:** [What are we testing]
- **Preconditions:** [Setup needed]
- **Test Data:** [Data reference from Section 7]
- **Expected Result:** [What should happen]

### Negative Tests (Error Handling)
**TC-02: [Scenario Name]**
[Similar structure as positive tests]

### Edge Cases (Boundary Values)
**TC-03: [Scenario Name]**
[Similar structure]

### Dependency Failure Tests
**TC-04: [Scenario Name]**
- **Objective:** Test behavior when [external service] fails
- **Simulated Failure:** [What dependency will fail]
- **Expected Result:** [Graceful degradation or error message]

---

## 7. Test Data Requirements

| Data Set ID | Description | Values | Usage |
|-------------|-------------|--------|-------|
| TD-01       | [Data description] | [Sample values] | Used in TC-01, TC-02 |
| TD-02       | [Data description] | [Sample values] | Used in TC-03 |

**Special Data Needs:**
- [Any specific test accounts needed]
- [Any mock data to be created]
- [Any production-like data required]

---

## 8. Environment Setup

**Test Environment URLs:**
- Dev: [URL if applicable]
- Staging: [URL if applicable]
- UAT: [URL if applicable]

**Test Accounts:**
- [Account types needed]
- [Permissions required]

**Configuration:**
- [Any feature flags to enable]
- [Any environment variables]

**Dependencies:**
- [External services needed]
- [Mock services to configure]

---

## 9. Execution Timeline

| Phase | Start Date | End Date | Status |
|-------|-----------|----------|--------|
| Test Plan Review | [Date] | [Date] | [ ] Not Started |
| Test Case Generation | [Date] | [Date] | [ ] Not Started |
| Test Execution | [Date] | [Date] | [ ] Not Started |
| Bug Reporting | [Date] | [Date] | [ ] Not Started |
| Regression Testing | [Date] | [Date] | [ ] Not Started |

---

## 10. Entry & Exit Criteria

**Entry Criteria (When testing can start):**
- [ ] Development complete
- [ ] Build deployed to test environment
- [ ] Test data prepared
- [ ] Test environment accessible
- [ ] All blocking defects resolved

**Exit Criteria (When testing is complete):**
- [ ] All test cases executed
- [ ] All high priority defects resolved
- [ ] All medium priority defects triaged
- [ ] Test execution report created
- [ ] Sign-off obtained from stakeholders

---

## 11. Revisions

### Version 1.0 - [Date]
- **Created by:** [Auto-detected or TBD]
- **Changes:** Initial test plan creation
- **Sections affected:** All

---

**Note:** This test plan inherits the overall testing strategy from feature-test-strategy.md. Refer to that document for tools, environments, and high-level approach.
```

### Step 6: Initialize Revision Log

The test plan is created with Version 1.0 and initial revision entry. This enables tracking of all future updates via `/revise-test-plan` command.

**Revision log format:**
```markdown
### Version [X.Y] - [Date]
- **Updated by:** [Person or command]
- **Changes:** [Description of what changed]
- **Sections affected:** [Which sections were modified]
```

### Step 7: Completion

Output confirmation message:
```
Test plan created successfully!

Location: [ticket-path]/test-plan.md
Version: 1.0
Sections: 11

Feature knowledge updated: [yes/no]
```
