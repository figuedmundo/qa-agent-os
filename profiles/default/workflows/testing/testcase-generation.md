# Test Case Generation Workflow

This workflow generates comprehensive test cases from a test plan.

## Core Responsibilities

1. **Read Test Plan**: Extract scenarios, coverage requirements, and test data from test-plan.md
2. **Generate Test Cases**: Create detailed executable test cases with proper structure and execution tracking
3. **Coverage Analysis**: Ensure all requirements are covered by test cases
4. **Automation Recommendations**: Identify automation opportunities for each test case
5. **Save Output**: Write test-cases.md with proper structure based on generation mode

**Note:** The placeholder `[ticket-path]` in this workflow refers to the full path to the ticket, for example: `qa-agent-os/features/feature-name/TICKET-123`.

**Note:** The placeholder `[mode]` refers to the generation mode: `create`, `overwrite`, or `append`.

---

## Workflow

### Step 0: Compile Applicable Standards

{{workflows/testing/compile-testing-standards}}

### Step 1: Read Test Plan

Read the test plan to extract requirements:

```bash
TEST_PLAN="[ticket-path]/test-plan.md"
```

Extract from test plan:
- **Section 5: Test Coverage Matrix** - Requirement to test case mapping
- **Section 6: Test Scenarios & Cases** - Positive, negative, edge cases, dependency failures
- **Section 7: Test Data Requirements** - Data needed for testing
- **Section 4: Testable Requirements** - Detailed requirements breakdown

### Step 2: Generate Test Cases

Based on test plan content, generate test cases with this structure:

**For each test scenario:**

1. **Create test case ID**: `[TICKET-ID]-TC-[NUMBER]` (e.g., WYX-123-TC-01)
2. **Define test case type**:
   - Functional - Positive (happy path)
   - Functional - Negative (error handling)
   - Functional - Edge Case (boundary values)
   - Dependency Failure (external service errors)
3. **Set priority**: [High|Medium|Low] based on requirement priority from test plan
4. **Write clear objective**: What is being tested and why
5. **Define preconditions**: Setup required before test execution
6. **Create detailed steps in table format**:
   ```markdown
   | Step | Action | Expected Result |
   |------|--------|-----------------|
   | 1    | [Action description] | [Expected outcome] |
   | 2    | [Action description] | [Expected outcome] |
   ```
7. **Reference test data**: Link to specific test data from Section 7 of test plan
8. **Define expected final result**: Overall outcome after all steps
9. **Include execution tracking**:
   ```markdown
   **Execution Result:**
   - [ ] Pass
   - [ ] Fail
   - [ ] Blocked

   **Executed By:** _______________
   **Execution Date:** _______________
   **Notes:**

   **Defects:**
   - Link defects here if test fails
   ```

### Step 3: Coverage Analysis

Compare generated test cases against coverage matrix from test plan Section 5:

1. Verify all requirements have at least one test case
2. Verify positive, negative, and edge cases are covered per requirement
3. Flag any coverage gaps in the coverage section
4. Create coverage summary:
   ```markdown
   ## Coverage Analysis

   - Total requirements: [N]
   - Requirements with test cases: [N] ([percentage]%)
   - Positive test cases: [N]
   - Negative test cases: [N]
   - Edge case test cases: [N]
   - Dependency failure test cases: [N]

   **Coverage Gaps:**
   - [List any requirements without test cases]
   ```

### Step 4: Automation Recommendations

For each test case, analyze automation potential:

**High automation priority:**
- API tests (can be automated with REST clients)
- Repetitive functional tests with clear inputs/outputs
- Tests with large data sets

**Medium automation priority:**
- UI tests with stable selectors
- Tests requiring multiple data variations
- Integration tests with external dependencies

**Low automation priority:**
- Exploratory tests requiring human judgment
- Tests requiring visual verification
- One-time tests or rarely executed tests

Create automation summary:
```markdown
## Automation Recommendations

**High Priority Candidates:**
- [Test ID]: [Reason - e.g., API test, repetitive, stable]

**Medium Priority Candidates:**
- [Test ID]: [Reason - e.g., UI test, data-driven]

**Manual Execution Required:**
- [Test ID]: [Reason - e.g., exploratory, visual]
```

### Step 5: Save Test Cases

Save to `[ticket-path]/test-cases.md` with structure:

```markdown
# Test Cases: [Ticket ID]

**Generated:** [Date]
**Source:** test-plan.md
**Total Test Cases:** [N]

---

## Test Execution Summary

| Test ID | Type | Priority | Status | Executed By | Date | Defects |
|---------|------|----------|--------|-------------|------|---------|
| [ID]-TC-01 | [Type] | [Priority] | [ ] Not Started | | | |
| [ID]-TC-02 | [Type] | [Priority] | [ ] Not Started | | | |

**Legend:**
- [ ] Not Started
- [x] Passed
- [!] Failed
- [B] Blocked

---

## Detailed Test Cases

[Generated test cases with full structure]

---

## Test Data Reference

[Test data from test plan Section 7]

---

## Coverage Analysis

[Coverage summary from Step 3]

---

## Automation Recommendations

[Automation priorities from Step 4]
```

**Respect MODE variable:**
- **create**: Write new file (error if file exists)
- **overwrite**: Replace existing file completely
- **append**: Add new test cases to existing file (update summary table, append to detailed section)

If mode is **append**:
1. Read existing test-cases.md
2. Parse existing test case IDs
3. Generate new test cases starting from next ID number
4. Append new cases to detailed section
5. Update test execution summary table with new rows
6. Preserve existing test results and notes

### Step 6: Completion

Output confirmation message with file path and test case count.
