# Phase 3: Generate Test Cases

## Execute Test Case Generation

This phase generates the test cases using the core workflow.

### Variables from Previous Phases

Set by previous phases:
- **TICKET_PATH**: `qa-agent-os/features/[feature]/[ticket-id]`
- **MODE**: [create|overwrite|append]
- **TEST_PLAN_PATH**: `[ticket-path]/test-plan.md`

### Execute Generation Workflow

{{workflows/testing/testcase-generation}}

The workflow references: `@qa-agent-os/standards/testcases/test-cases.md`

The workflow will:
- Read the test plan from `[ticket-path]/test-plan.md`
- Extract test scenarios, coverage requirements, and test data
- Generate detailed executable test cases
- Perform coverage analysis
- Provide automation recommendations
- Save to `test-cases.md` (respecting MODE)

### Completion

Once workflow completes:

```
Test cases generated successfully!

Output: qa-agent-os/features/[feature]/[ticket-id]/test-cases.md
Mode: [create|overwrite|append]

Total test cases: [N]
  - Positive tests: [N]
  - Negative tests: [N]
  - Edge cases: [N]
  - Dependency failures: [N]

NEXT STEPS:
- Review test cases for completeness
- Execute tests and track results using the execution summary table
- Report bugs using /report-bug (when available)
```
