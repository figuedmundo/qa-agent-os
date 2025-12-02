# Test Cases Standard

This standard defines test case document structure, field definitions, generation guidelines, and best practices. It replaces test-cases-template.md, test-case-standard.md, and test-case-structure.md.

---

## Document Structure

### Header Metadata

```markdown
# Test Cases: [TICKET_ID]

**Feature:** [FEATURE_NAME]
**Ticket:** [TICKET_ID]
**Generated:** [DATE]
**Version:** 1.0
**Source:** test-plan.md (v[VERSION])
```

### Test Cases Overview

**Total Test Cases:** [NUMBER]

**By Type:**
- Functional Tests: [N] ([%]%)
- Edge Case Tests: [N] ([%]%)
- Negative Tests: [N] ([%]%)

**By Priority:**
- Critical: [N] ([%]%)
- High: [N] ([%]%)
- Medium: [N] ([%]%)
- Low: [N] ([%]%)

**By Automation Status:**
- Automated: [N] ([%]%) - [Technologies]
- Manual: [N] ([%]%) - [Reasons]

**Coverage:**
- Requirements covered: [N]/[total] ([%]%)
- Positive test coverage: [N]/[total] ([%]%)
- Edge case coverage: [N]/[total] ([%]%)
- Negative test coverage: [N]/[total] ([%]%)

**Critical Testing Areas:**
1. [Area 1] (Test IDs: TC-XXX, TC-XXX)
2. [Area 2] (Test IDs: TC-XXX)

### Test Execution Summary

| Status | Count |
|--------|-------|
| Not Started | [COUNT] |
| Passed | 0 |
| Failed | 0 |
| Blocked | 0 |

---

## Individual Test Case Structure

### Required Fields

| Field | Description | Example |
|-------|-------------|---------|
| **Test ID** | Unique identifier | TC-01, TC-LOGIN-001 |
| **Title** | Descriptive name | `[Module] - [Action] - [Expected Outcome]` |
| **Type** | Test category | Functional - Positive/Negative/Edge, API, Security |
| **Priority** | Criticality | Critical, High, Medium, Low |
| **Requirement** | Links to requirements | RQ-01, REQ-CART-12 |
| **Objective** | What this validates | Clear statement of intent |
| **Preconditions** | Setup required | State before test execution |
| **Test Data** | Specific inputs | Data ID, values, accounts, configs |
| **Test Steps** | Actions to perform | Numbered, actionable steps |
| **Expected Result** | Observable outcome | Measurable, specific result |
| **Actual Result** | Execution tracking | Pass/Fail/Blocked checkboxes |
| **Notes** | Observations | Space for tester notes |
| **Defects** | Bug links | Links to bug reports if found |

### Test Case Template

```markdown
## TC-XX: [Test Case Title]

**Test ID:** TC-XX
**Type:** [Functional - Positive/Negative/Edge | API | Security | Performance]
**Priority:** [Critical/High/Medium/Low]
**Requirement:** RQ-XX

### Objective

[What this test validates - specific aspect of functionality]

### Preconditions

- [Setup step 1 - what must be in place]
- [Setup step 2]

### Test Data

- **Data ID:** D-XX
- **Input Value:** [specific value]
- **Account:** [account if needed]
- **Config:** [feature flags, settings]

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | [User action with specific data] | [What should happen] |
| 2 | [User action] | [What should happen] |
| 3 | [Final action] | [Final expected state] |

### Expected Final Result

✓ [Overall expected outcome]
✓ [Additional verification if needed]

### Actual Result

[ ] Pass
[ ] Fail
[ ] Blocked

**Notes:**
_[Tester observations]_

**Defects:**
_[Bug report links]_

**Execution Date:** _[Date when executed]_
**Executed By:** _[Tester name]_
```

---

## Test Case Types

### Functional - Positive (Happy Path)
**Purpose:** Verify feature works with valid inputs and standard workflow

**Example:**
```markdown
TC-01: Login - Valid Credentials - Success

**Objective:** Verify user can login with valid username and password

**Steps:**
1. Navigate to /login
2. Enter username: valid_user@example.com
3. Enter password: Valid123!
4. Click "Login" button

**Expected:** User redirected to dashboard within 2 seconds, welcome message displayed
```

### Functional - Negative (Error Handling)
**Purpose:** Verify system handles invalid inputs gracefully

**Example:**
```markdown
TC-02: Login - Invalid Password - Show Error

**Objective:** Verify error message when password is incorrect

**Steps:**
1. Navigate to /login
2. Enter username: valid_user@example.com
3. Enter password: WrongPassword
4. Click "Login" button

**Expected:** 
✓ Error message "Invalid credentials" displayed
✓ User remains on login page
✓ No system crash
```

### Functional - Edge Case (Boundary Values)
**Purpose:** Test extreme values, boundaries, special conditions

**Example:**
```markdown
TC-03: Search - Maximum Length Query - Handle Gracefully

**Objective:** Verify search handles maximum allowed query length

**Test Data:** Query of 500 characters (system max)

**Steps:**
1. Enter 500-character search query
2. Click "Search"

**Expected:** Results returned OR error message "Query too long" if validation fails
```

### Dependency Failure
**Purpose:** Test graceful degradation when external services fail

**Example:**
```markdown
TC-04: Checkout - Payment Gateway Timeout - Show User-Friendly Error

**Objective:** Verify handling when payment service times out

**Preconditions:** Mock payment service configured to timeout after 30s

**Steps:**
1. Complete checkout flow
2. Submit payment
3. Wait for timeout

**Expected:**
✓ User-friendly message "Payment processing delayed. Please try again."
✓ No stack trace shown to user
✓ Order saved in pending state
```

---

## Writing Guidelines

### Atomic Steps
Each step is a single user or system action. Avoid compound steps.

**Good:** 
```
1. Click "Add to Cart" button
2. Observe cart icon badge
```

**Bad:**
```
1. Click "Add to Cart" and verify cart updates
```

### Clear Expectations
Include timings, exact messages, state changes

**Good:**
```
Expected: Cart icon badge updates from 0 to 1 within 1 second; 
toast "Item added" appears for 3 seconds
```

**Bad:**
```
Expected: Cart updates
```

### Test Independence
Each test should be self-contained with explicit setup

**Good:**
```
Preconditions:
- User logged in with account user@example.com
- Cart is empty
- Product SKU-123 exists in inventory
```

**Bad:**
```
Preconditions:
- Run TC-01 first
```

### Data Privacy
Use anonymized data or placeholders; reference fixtures

**Good:**
```
Test Data: Email: user{random}@example.com, Card: 4111-****-****-1111 (test card)
```

**Bad:**
```
Test Data: Email: john.doe@company.com, Card: 4111-1111-1111-1111
```

---

## Coverage Checklist

Ensure test suites address:

- [ ] **Happy Path:** Standard success flow with valid inputs
- [ ] **Negative Path:** Invalid inputs, error states, validation failures
- [ ] **Boundary Values:** Min/max limits, empty states, null values, special characters
- [ ] **Security:** Auth bypass, injection (SQL, XSS), authorization, data exposure
- [ ] **Permissions:** Role-based access, unauthorized actions
- [ ] **Accessibility:** Keyboard navigation, screen reader compatibility, WCAG compliance
- [ ] **Localization:** Languages, time zones, currency, date formats
- [ ] **Performance:** Latency thresholds, load handling, response times
- [ ] **Resiliency:** Timeouts, retries, offline mode, network failures
- [ ] **Observability:** Logs/metrics emitted as expected

---

## Automation Recommendations

### High Priority Automation Candidates

**Criteria:**
- API tests (fast, stable)
- Repetitive tests (executed frequently)
- Regression tests (stable functionality)
- Data validation tests (deterministic)

**Example:**
```markdown
TC-05: API - Create User - Return 201
- **Automation:** Playwright API testing
- **Priority:** High - Fast, stable, executed every build
```

### Manual Only Tests

**Criteria:**
- Visual validation (design, layout)
- Exploratory testing
- Date-dependent scenarios
- One-time tests

**Example:**
```markdown
TC-15: UI - Homepage Hero Banner - Visual Verification
- **Automation:** Manual only - Requires visual design verification
```

**Automation Technologies:**
- Playwright: UI/E2E tests
- WireMock: API mocking
- Python/Jest: Unit/integration tests
- Postman/Newman: API testing

---

## Recommended Execution Schedule

**Total Estimated Duration:** [N] hours ([N] days)

**Day 1: High-Priority Functional Tests**
- TC-XXX, TC-XXX (Critical path tests)
- Priority: Core functionality
- Focus: Smoke tests

**Day 2: Medium-Priority Functional Tests**
- TC-XXX, TC-XXX
- Priority: Data validation
- Focus: Detailed functional validation

**Day 3: Edge Cases**
- TC-XXX, TC-XXX
- Priority: Boundary testing
- Focus: Edge cases and limits

**Day 4: Negative & Error Handling**
- TC-XXX, TC-XXX
- Priority: Robustness
- Focus: Error scenarios

**Day 5: Regression & Sign-Off**
- Retest failed tests
- Cross-browser/device validation
- Final sign-off

---

## Generation History

### Version 1.0 - [DATE]

**Initial Generation**

**Changes:**
- Generated [N] test cases from test-plan.md v[VERSION]
- Test cases created: TC-001 to TC-XXX

**Source:** test-plan.md Sections 4-7 (Requirements, Coverage, Scenarios, Test Data)

**Coverage Achieved:**
- [N]/[N] requirements covered ([%]%)
- [N] positive tests
- [N] negative tests
- [N] edge case tests

**Versioning:**
- Major (X.0): Structural changes, new requirements
- Minor (X.Y): New test cases added, updates to existing

---

## Test Data Reference

| Data ID | Description | Value | Source |
|---------|-------------|-------|--------|
| D-01 | Valid user | user@example.com / [password ref] | Test fixtures |
| D-02 | Invalid password | wrong_password | Test fixtures |
| D-03 | Boundary value | [min/max value] | Test fixtures |

**Data Management:**
- Store test data in fixtures or external files
- Reference by ID in test cases
- Include data cleanup steps if tests modify state
- Document data dependencies

---

## Coverage Analysis

### Test Case Distribution

| Type | Count | Percentage |
|------|-------|------------|
| Functional - Positive | [N] | [%] |
| Functional - Negative | [N] | [%] |
| Edge Cases | [N] | [%] |
| Dependency Failure | [N] | [%] |

### Requirements Coverage

| Requirement ID | Test Case IDs | Coverage Status |
|----------------|---------------|-----------------|
| RQ-01 | TC-01, TC-02 | ✅ Covered |
| RQ-02 | TC-03, TC-04 | ✅ Covered |

---

## Best Practices Summary

1. **Atomic Steps:** One action per step
2. **Clear Expectations:** Specific, measurable outcomes
3. **Test Independence:** Self-contained with explicit setup
4. **Data Privacy:** Anonymized data, use placeholders
5. **Coverage:** Address happy path, negative, edge, security, accessibility
6. **Automation:** Prioritize API, repetitive, regression tests
7. **Observability:** Include log/metric verification where applicable
8. **Maintenance:** Update test cases when requirements change
9. **Traceability:** Link test cases to requirements
10. **Execution Tracking:** Record actual results, notes, defects

---

*This standard replaces test-cases-template.md, test-case-standard.md, and test-case-structure.md. All test case structure, guidelines, and best practices in one place.*
