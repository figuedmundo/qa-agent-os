# Test Plan: [TICKET_ID]

**Feature:** [FEATURE_NAME]
**Ticket ID:** [TICKET_ID]
**Created:** [DATE]
**Version:** 1.0

---

## 1. References

### Feature Documentation

- **Feature Knowledge:** `../feature-knowledge.md`
- **Feature Test Strategy:** `../feature-test-strategy.md`

### Ticket Documentation

- **Ticket Source:** `documentation/[source-document-filename]`
- **Technical Specs:** `documentation/[specs-filename]`
- **Mockups/Visuals:** `documentation/visuals/`

---

## 2. Ticket Overview

### Executive Summary

[2-3 sentence summary of test plan status, coverage achieved, and readiness]

### Ticket Summary

[Brief description of what this ticket aims to accomplish - the main goal]

### Acceptance Criteria

1. [Acceptance criterion 1]
2. [Acceptance criterion 2]
3. [Acceptance criterion 3]

---

## 3. Test Scope

### In Scope

- [What will be tested for this ticket]
- [Specific features or functionality covered]

### Out of Scope

- [What won't be tested for this ticket]
- [Dependencies or related features tested separately]

### Dependencies

- **Internal:** [Required features/data from this system]
- **External:** [Required services/APIs/data sources]

---

## 4. Testable Requirements

**Requirements extracted from ticket and analyzed for testability:**

| Req ID | Requirement Summary | Input Conditions | Expected Output | Priority |
|--------|---------------------|------------------|-----------------|----------|
| RQ-01 | [Requirement] | [Input] | [Expected] | High |
| RQ-02 | [Requirement] | [Input] | [Expected] | High |
| RQ-03 | [Requirement] | [Input] | [Expected] | Medium |

---

## 5. Test Coverage Matrix

### Coverage Summary

- **Total Requirements:** [N]
- **Requirements with Test Cases:** [N] ([percentage]%)
- **Total Test Cases:** [N]
  - Functional: [N] ([percentage]%)
  - Edge Cases: [N] ([percentage]%)
  - Negative: [N] ([percentage]%)
- **Automation Potential:** [N]/[total] ([percentage]%)

### Traceability: Requirements → Test Cases

| Requirement ID | Test Case IDs | Coverage Type | Status |
|----------------|---------------|---------------|--------|
| RQ-01 | TC-01, TC-02, TC-03 | Positive, Negative, Edge | Planned |
| RQ-02 | TC-04, TC-05 | Positive, Negative | Planned |

**Coverage Goals:**
- All requirements must have at least 1 test case: [status]
- All requirements must have positive/edge tests where applicable: [status]
- All dependency failures tested: [status]

---

## 6. Test Scenarios & Cases

### Scenario 1: [Scenario Name]

**Objective:** [What we're validating with this scenario]

#### TC-01: [Test Case Title]

- **Type:** Functional - Positive
- **Priority:** High
- **Preconditions:** [Setup required to run this test]
- **Test Steps:**
  1. [Step 1 - user action]
  2. [Step 2 - user action]
  3. [Step 3 - user action]
- **Expected Result:** [What should happen when test succeeds]
- **Test Data:** [Reference to data in Section 7]

#### TC-02: [Test Case Title - Negative]

- **Type:** Functional - Negative
- **Priority:** High
- **Preconditions:** [Setup required]
- **Test Steps:**
  1. [Step 1 - use invalid/unexpected input]
  2. [Step 2 - user action]
- **Expected Result:** [Error handling or graceful degradation]

#### TC-03: [Test Case Title - Edge Case]

- **Type:** Functional - Edge
- **Priority:** Medium
- **Preconditions:** [Setup required]
- **Test Steps:**
  1. [Step 1 - use boundary value]
  2. [Step 2 - user action]
- **Expected Result:** [Boundary behavior expected]

### Scenario 2: [Another Scenario Name]

#### TC-04: [Test Case Title]

- **Type:** [Type]
- **Priority:** [Priority]
- **Preconditions:** [Setup]
- **Test Steps:**
  1. [Step]
  2. [Step]
- **Expected Result:** [Expected result]

---

## 7. Test Data Requirements

| Data ID | Data Type | Sample Value | Purpose | Test Cases |
|---------|-----------|--------------|---------|------------|
| D-01 | Valid User | user@example.com | Positive path | TC-01 |
| D-02 | Invalid Input | [malformed data] | Negative test | TC-02 |
| D-03 | Boundary Value | [min/max value] | Edge case | TC-03 |

---

## 8. Environment Setup

### Test Environment

- **URL:** https://[environment].example.com
- **Credentials:** [Reference to secure storage or description]

### Configuration

- **Feature Flags:** [Any flags needed for this ticket]
- **Test Accounts:** [Specific accounts or roles required]

---

## 9. Execution Timeline

| Phase | Start Date | End Date | Status | Owner |
|-------|-----------|----------|--------|-------|
| Test Plan Review | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Case Generation | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Environment Setup | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Execution | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Bug Reporting & Triage | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Regression Testing | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Summary & Sign-off | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |

**Status Icons:**
- ✅ Complete
- 🔄 In Progress
- ⏳ Not Started
- ⚠️ Blocked

---

## 10. Entry & Exit Criteria

### Entry Criteria

- [ ] Ticket deployed to test environment
- [ ] Test data available and verified
- [ ] Dependencies verified working
- [ ] Test plan reviewed and approved

### Exit Criteria

- [ ] All test cases executed
- [ ] No open Critical/High bugs
- [ ] Acceptance criteria met
- [ ] Regression tests passed

---

## 11. Revisions

### Change Log

**Version 1.0 - [DATE]**
- Initial test plan created
- Sections: 12
- Requirements: [N]
- Test scenarios: [N]

---

## 12. Gap Detection Log

### Gap Analysis

**Date:** [DATE]

**Gaps Found:** [Yes/No]

**Feature Knowledge Status:** [Updated / No updates required]

**Analysis:**

[Summary of gap detection analysis. If no gaps: "Ticket requirements were compared against feature-knowledge.md. No new business rules, APIs, or edge cases requiring addition to feature knowledge were found. All ticket-specific details are captured in this test plan."

If gaps found: "The following new information was identified during requirement analysis:"]

**New Information Identified:**
- [None / List of gaps found]

**Feature Knowledge Updates:**
- [None / List of sections updated in feature-knowledge.md]

**Traceability:**
- [If updated: References to feature-knowledge.md sections that were appended]

---

*For strategic test approach, see the parent feature-test-strategy.md. For implementation details of what is being built, see feature-knowledge.md*
