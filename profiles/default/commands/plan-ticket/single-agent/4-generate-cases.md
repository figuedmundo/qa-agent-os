# Phase 4: Generate Test Cases (Optional)

## Flexible Test Case Generation

You now have the option to generate detailed test cases from the test plan, or stop to review the plan first.

### Variables from Previous Phases

Set by previous phases:
- **TICKET_PATH**: `qa-agent-os/features/[feature]/[ticket-id]`
- **TEST_PLAN_PATH**: `[ticket-path]/test-plan.md`
- **MODE**: `create` (always create for new test cases in this phase)

### Execute Test Case Generation Workflow

{{workflows/testing/testcase-generation}}

The workflow will:
- Read your test-plan.md from `[test-plan-path]`
- Extract scenarios from Section 6 (Test Scenarios & Cases)
- Extract test data from Section 7 (Test Data Requirements)
- Extract coverage requirements from Section 5 (Test Coverage Matrix)
- Generate detailed executable test cases in `test-cases.md`

### Test Case Structure

Each test case will include:
- Test ID, Type, Priority, Requirement link
- Clear objective of what's being tested
- Preconditions needed to run the test
- Test steps in table format (Step | Action | Expected Result)
- Test data references
- Expected final result
- Checkboxes for execution results (Pass/Fail/Blocked)
- Space for notes and defect links

### Coverage

The workflow generates:
- **Positive tests** (happy path)
- **Negative tests** (error handling)
- **Edge cases** (boundary values)
- **Dependency failure scenarios** (external service errors)

### Result

```
Test cases generated successfully!

Output: features/[feature-name]/[ticket-id]/test-cases.md

Total test cases: [N]
  - Positive tests: [N]
  - Negative tests: [N]
  - Edge cases: [N]
  - Dependency failures: [N]

Ready for immediate test execution!
```

The test-cases.md includes:
- Test execution summary table for tracking progress
- Detailed test case specifications
- Test data reference section
- Coverage analysis
- Automation recommendations

---

## Completion

```
Ticket planning complete!

Created:
- Test plan: features/[feature-name]/[ticket-id]/test-plan.md
- Test cases: features/[feature-name]/[ticket-id]/test-cases.md

Feature knowledge updated: [yes/no]

NEXT STEPS:
- Review test cases for completeness
- Execute tests and track results
- Report bugs using /report-bug (when available)

Good luck with your testing!
```
