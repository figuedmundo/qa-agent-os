# Generate Test Cases

## Create or Regenerate Detailed Test Cases

This command generates detailed, executable test cases from a test plan.

**Use this command when:**
- You stopped after test-plan.md and now want to generate cases
- You reviewed the test plan and want test cases created
- You revised the test plan and need to regenerate cases
- You're ready to execute tests

**What I do:**

1. **Identify the ticket** - Ask which ticket if not specified
2. **Read the test plan** - Extract scenarios, test data, coverage matrix
3. **Check for conflicts** - If test-cases.md exists, ask how to handle it
4. **Generate test cases** - Create detailed test case specifications
5. **Confirm completion** - Show you what was created

## Ticket Selection

If you don't specify a ticket, I'll show available tickets:

```
Which ticket's test cases to generate?

Recent tickets:
  [1] WYX-125 (no test-cases.md yet) ← NEW
  [2] WYX-124 (test-cases.md exists - last updated 2025-11-19)
  [3] WYX-123 (test-cases.md exists - last updated 2025-11-18)

Choose:
```

I'll prioritize tickets without test-cases.md at the top, so you can see what's new.

## Handling Existing Test Cases

If test-cases.md already exists for your ticket:

```
Warning: test-cases.md already exists for ticket [ticket-id]
Last updated: 2025-11-19 14:23

Options:
  [1] Overwrite (regenerate completely - discard old cases)
  [2] Append (add new cases, keep existing ones)
  [3] Cancel (no changes)

Choose [1/2/3]:
```

**Choose wisely:**
- **[1] Overwrite** - If you revised the test plan and want fresh cases
- **[2] Append** - If you added new scenarios but want to keep old cases
- **[3] Cancel** - Exit without making changes

## Test Case Generation

I will:
1. Read `test-plan.md` Section 6 (Test Scenarios & Cases)
2. Extract test data requirements from Section 7
3. Extract coverage matrix from Section 5
4. For each scenario, generate:
   - Detailed test case with ID (TC-01, TC-02, etc.)
   - Type (Functional - Positive/Negative/Edge, Dependency Failure)
   - Priority (High/Medium/Low)
   - Objective (what's being tested)
   - Preconditions (what must be set up)
   - Test steps table (Step | Action | Expected Result)
   - Test data references
   - Expected final result
   - Execution checkboxes (Pass/Fail/Blocked)
   - Space for notes and defect links

## Test Execution Summary

The generated test-cases.md will include:
- Test execution summary table (Not Started | Passed | Failed | Blocked)
- Test data reference section
- Coverage notes showing:
  - How many positive, negative, edge, and dependency failure cases
  - Which cases are candidates for automation
  - Which require manual execution

## Output

Created: `features/[feature-name]/[ticket-id]/test-cases.md`

Ready for test execution!

---

## Quick Reference

**Usage:**
```bash
/generate-testcases              # Interactive - asks which ticket
/generate-testcases WYX-123      # Direct - generates for WYX-123
```

**When to use:**
- After reviewing test-plan.md
- After revising test-plan.md
- When starting test execution
- To regenerate cases with updated requirements

**Related commands:**
- `/plan-ticket` - Create test plan (usually includes this step)
- `/revise-test-plan` - Update test plan, then regenerate cases
- `/update-feature-knowledge` - Update feature knowledge

Generating test cases now...
