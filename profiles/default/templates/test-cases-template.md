# Test Cases: [TICKET_ID]

**Feature:** [FEATURE_NAME]
**Ticket:** [TICKET_ID]
**Generated:** [DATE]
**Total Cases:** [NUMBER]

**Source:** Generated from `test-plan.md`

---

## Test Execution Summary

| Status | Count |
|--------|-------|
| Not Started | [COUNT] |
| Passed | 0 |
| Failed | 0 |
| Blocked | 0 |

---

## TC-01: [Test Case Title]

**Test ID:** TC-01
**Type:** Functional - Positive
**Priority:** High
**Requirement:** RQ-01

### Objective

[What this test validates - the specific aspect of functionality being tested]

### Preconditions

- [Setup step 1 - what must be in place before running test]
- [Setup step 2]

### Test Data

- **Data ID:** D-01
- **Input Value:** [value]
- **Account:** [account if needed]

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | [User action or system state change] | [What should happen] |
| 2 | [User action] | [What should happen] |
| 3 | [Final action] | [Final expected state] |

### Expected Final Result

✓ [Overall expected outcome - what the test proves when passed]

### Actual Result

[ ] Pass
[ ] Fail
[ ] Blocked

**Notes:**
_[Space for tester notes and observations]_

**Defects:**
_[Link to bug reports if any found]_

---

## TC-02: [Test Case Title - Negative]

**Test ID:** TC-02
**Type:** Functional - Negative
**Priority:** High
**Requirement:** RQ-01

### Objective

[Verify system handles invalid input or error conditions gracefully]

### Preconditions

- [Setup required]

### Test Data

- **Data ID:** D-02
- **Invalid Input:** [Invalid/malformed data]

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | [Attempt action with invalid input] | [Form accepts invalid data or shows validation error] |
| 2 | [Observe system response] | [Error message or prevention displayed] |

### Expected Final Result

✓ System rejects invalid input gracefully
✓ User-friendly error message displayed
✓ No system crash or unexpected behavior

### Actual Result

[ ] Pass
[ ] Fail
[ ] Blocked

---

## TC-03: [Test Case Title - Edge Case]

**Test ID:** TC-03
**Type:** Functional - Edge Case
**Priority:** Medium
**Requirement:** RQ-02

### Objective

[Verify correct handling of boundary conditions or extreme values]

### Preconditions

- [Setup required]

### Test Data

- **Data ID:** D-03
- **Boundary Value:** [Min/max/edge value]

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | [Use boundary value] | [System processes without error] |
| 2 | [Verify result] | [Correct boundary behavior observed] |

### Expected Final Result

✓ Boundary value handled correctly
✓ No errors or unexpected behavior

### Actual Result

[ ] Pass
[ ] Fail
[ ] Blocked

---

## TC-04: [Test Case Title - Dependency Failure]

**Test ID:** TC-04
**Type:** Dependency Failure
**Priority:** High
**Requirement:** RQ-01

### Objective

[Verify graceful handling when external dependency returns error]

### Preconditions

- [Mock external service to return error]
- [System configured for failure scenario]

### Test Steps

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | [Configure mock to return 500 error] | [Mock configured] |
| 2 | [Trigger action that depends on external service] | [System attempts to call external service] |
| 3 | [Observe error handling] | [System handles error gracefully] |

### Expected Final Result

✓ User-friendly error message displayed
✓ Message: "[User-friendly error text]"
✓ No stack trace visible to user
✓ Application remains stable and responsive

### Actual Result

[ ] Pass
[ ] Fail
[ ] Blocked

---

## Test Data Reference

| Data ID | Description | Value | Source |
|---------|-------------|-------|--------|
| D-01 | Valid user credentials | [email/username] / [vault ref] | Test fixtures |
| D-02 | Invalid password | [email] / wrong_password | Test fixtures |
| D-03 | Boundary value | [specific value] | Test fixtures |

---

## Coverage Notes

**Test Case Distribution:**

| Type | Count |
|------|-------|
| Functional - Positive | [COUNT] |
| Functional - Negative | [COUNT] |
| Edge Cases | [COUNT] |
| Dependency Failure | [COUNT] |

**Automation Candidates:**
- [Test cases suitable for automation]

**Manual Only:**
- [Test cases requiring manual execution]

---

*Generated from test plan. For detailed test approach and strategy, see feature-test-strategy.md*
