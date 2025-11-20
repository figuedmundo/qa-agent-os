# /revise-test-plan Command

## Purpose

Update test plans during testing when new scenarios, edge cases, or requirements are discovered.

## Usage

```bash
/revise-test-plan              # Interactive - select ticket
/revise-test-plan WYX-123      # Direct - revise specific ticket
```

## When to Use

- **During test execution** - Found edge case not in plan
- **After requirement change** - Development team updated requirement
- **New test scenario** - Discovered interaction pattern needed
- **Test data adjustment** - Need special test data setup
- **Existing scenario update** - Need to refine approach

## Revision Types

### 1. New Edge Case
- Boundary value discovered
- Special condition handling
- Extreme value behavior

### 2. New Test Scenario
- User flow not covered
- Integration pattern
- Interaction sequence

### 3. Existing Scenario Update
- Test approach refinement
- Changed expected behavior
- Additional test steps

### 4. New Requirement
- Business rule change
- New API endpoint
- Technical requirement

### 5. Test Data Adjustment
- Special data setup needed
- Boundary data values
- Data dependency

## How It Works

1. Select ticket (if not specified)
2. Select change type
3. Provide details
4. Test plan updated with:
   - New/updated sections
   - Version increment
   - Timestamp and reason
   - Revision log entry
5. Optional: Regenerate test cases immediately

## Revision Log

Each update creates revision entry:
```markdown
**Version X.Y - [date] [time]**
- Change description
- Impact on test coverage
- Reason: Why this change was needed
```

Tracks evolution of test plan throughout execution.

## Smart Features

- **Version tracking** - Automatic version increments
- **Timestamped** - Always know when changes made
- **Reasoned** - Explains why changes occurred
- **Integrated** - Can regenerate cases automatically
- **Modular** - Update only affected sections

## Related Commands

- `/plan-ticket` - Creates initial test plan
- `/generate-testcases` - Generate or regenerate test cases
- `/plan-feature` - Feature context

---

Perfect for iterative testing and real-world QA workflows!
