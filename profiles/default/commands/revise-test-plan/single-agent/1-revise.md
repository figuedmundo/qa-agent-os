# Revise Test Plan

## Update Test Plan During Testing

This command helps you update test plans when you discover new scenarios, edge cases, or requirements during testing.

## Use Cases

- **New edge case found** - Discovered boundary condition not in original plan
- **New test scenario needed** - Found interaction pattern that needs testing
- **Requirement changed** - Development team updated requirement
- **New test data needed** - Realized special data setup is required
- **Existing scenario update** - Need to refine test approach

## Workflow

### Step 1: Select Ticket

If not specified, I'll ask which ticket:
```
Which ticket's test plan to revise?

Active tickets:
  [1] WYX-125 (currently testing)
  [2] WYX-124 (testing complete)
  [3] WYX-123 (testing in progress)

Choose:
```

### Step 2: Select Change Type

```
What did you discover during testing?

Options:
  [1] New edge case found
  [2] New test scenario needed
  [3] Existing scenario needs update
  [4] New requirement discovered
  [5] Test data needs adjustment

Choose:
```

### Step 3: Provide Details

Based on your selection, I'll ask specific questions:

- **Option 1** - Describe edge case, expected behavior, priority
- **Option 2** - Describe new scenario, test steps, expected outcome
- **Option 3** - Which scenario, what needs changing
- **Option 4** - Requirement details, impact
- **Option 5** - Data ID, new values, reason

### Step 4: Update Test Plan

I'll update `test-plan.md`:
- Section 4: Add testable requirements if needed
- Section 5: Update coverage matrix
- Section 6: Add/update test scenarios
- Section 7: Add/update test data
- Section 11: Append revision entry with:
  - Version number increment
  - Timestamp
  - Change description
  - Reason for change

Example revision entry:
```markdown
**Version 1.1 - 2025-11-20 14:35**
- Added edge case: TWRR calculation with zero-value portfolio
- New requirement: RQ-06
- New test scenario: TC-15
- Reason: Discovered during manual testing of TC-03
```

### Step 5: Regenerate Test Cases (Optional)

After updating test plan:
```
Test plan updated. Would you like to regenerate test cases now? [y/n]
```

- **Yes** - Calls `/generate-testcases` internally
- **No** - Test plan saved, regenerate later when ready

## Key Features

- **Version tracking** - Revision log shows what changed and when
- **Traceability** - Links changes to discoveries and reasons
- **Flexible** - Update only what changed, rest stays the same
- **Integration** - Can trigger case regeneration automatically

## Output

Updated: `features/[feature-name]/[ticket-id]/test-plan.md`

With:
- Updated sections based on discovery type
- New revision log entry
- Ready for case regeneration if chosen

## Next Steps

After updating:
- Review updated test-plan.md
- If generating cases: `/generate-testcases` called automatically
- Continue testing with new insights
- Can revise again if more discoveries

Ready to update your test plan?
