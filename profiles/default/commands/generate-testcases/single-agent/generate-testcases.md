# /generate-testcases Command

## Purpose

Generate or regenerate detailed test cases from a test plan. Can be called standalone or as part of `/plan-ticket` Phase 4.

## Usage

```bash
/generate-testcases              # Interactive - select which ticket
/generate-testcases WYX-123      # Direct - generate for specific ticket
```

## When to Use

- **After test plan review** - Review test-plan.md and want cases
- **After test plan updates** - Ran `/revise-test-plan` and want regenerated cases
- **During test planning** - As optional Phase 4 of `/plan-ticket`
- **Standalone** - Generate or regenerate cases independently
- **With append mode** - Add new test cases without discarding existing

## Execution Phases

This is an orchestrated command with 3 phases:

{{PHASE 1: @qa-agent-os/commands/generate-testcases/1-select-ticket.md}}

{{PHASE 2: @qa-agent-os/commands/generate-testcases/2-detect-conflicts.md}}

{{PHASE 3: @qa-agent-os/commands/generate-testcases/3-generate-cases.md}}

## Quick Workflow

### Scenario 1: Simple Generation
```
/generate-testcases
  → Lists recent tickets
  → Select ticket
  → Generates test-cases.md
  → Done!
```

### Scenario 2: Direct with Ticket ID
```
/generate-testcases WYX-123
  → Generates test-cases.md immediately
```

### Scenario 3: After Plan Update
```
/revise-test-plan WYX-123
  → Test plan updated
  → Prompts to regenerate cases
  → Calls /generate-testcases internally
```

## How It Works

1. Identify the ticket (specified or selected)
2. Read the test plan
3. Extract scenarios, test data, coverage matrix
4. Check for conflicts (Overwrite/Append/Cancel if exists)
5. Generate detailed executable test cases

## Test Case Structure

Each test case includes:
- Test ID, Type, Priority
- Objective and Preconditions
- Test Data references
- Test Steps (table format)
- Expected Results
- Execution checkboxes
- Space for notes and defects

## Output

```
features/[feature-name]/[ticket-id]/test-cases.md
```

Includes:
- Test execution summary table
- Detailed test case specifications
- Test data reference section
- Coverage analysis
- Automation recommendations

## Smart Features

- Ticket prioritization (new tickets first)
- Conflict handling (Overwrite/Append/Cancel)
- Coverage tracking
- Automation hints
- Data traceability

## Related Commands

- `/plan-ticket` - Creates test plans
- `/revise-test-plan` - Updates plans and regenerates cases
- `/plan-feature` - Creates feature context

---

Ready for test execution!
