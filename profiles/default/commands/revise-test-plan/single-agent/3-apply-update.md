# Phase 3: Apply Update

## Execute Test Plan Revision

This phase applies the update to test-plan.md using the core workflow.

### Variables from Previous Phases

Set by previous phases:
- **TICKET_PATH**: `qa-agent-os/features/[feature]/[ticket-id]`
- **TEST_PLAN_PATH**: `[ticket-path]/test-plan.md`
- **CURRENT_VERSION**: Current version number
- **UPDATE_TYPE**: Type of update to apply
- **UPDATE_DETAILS**: Details collected from user

### Execute Revision Workflow

{{workflows/testing/revise-test-plan}}

The workflow will:
- Read the current test-plan.md
- Determine next version number
- Apply updates to appropriate sections based on UPDATE_TYPE
- Add revision log entry with timestamp and reason
- Update version metadata
- Verify test plan structure integrity
- Save updated test-plan.md

### Completion

Once workflow completes:

```
Test plan revised successfully!

Updated: qa-agent-os/features/[feature]/[ticket-id]/test-plan.md

Version: [previous-version] → [next-version]

Changes made:
- [Change type]: [Brief description]
- Section(s) updated: [List of sections]
- Revision log entry added

Reason: [Why the update was made]

NEXT STEPS:
Would you like to regenerate test cases to reflect these updates? [y/n]
```

### Post-Revision Options

Prompt user:
```
Regenerate test cases now? [y/n]
```

**If user chooses 'y' (yes):**
```
Calling /generate-testcases to regenerate test cases...

(Internally triggers /generate-testcases [ticket-id] with overwrite mode)
```

**If user chooses 'n' (no):**
```
Test plan updated. You can regenerate test cases later with:
  /generate-testcases [ticket-id]

Continue testing with updated plan!
```

### Success Summary

Display final summary:
```
Revision complete!

Files updated:
  - test-plan.md (version [new-version])
  - test-cases.md (if regenerated)

You can:
  - Continue testing with updated plan
  - Run /revise-test-plan again if more changes needed
  - Review test-plan.md Section 11 for revision history
```

### Next Steps

Command completes. User can:
- Continue testing
- Run `/revise-test-plan` again for additional updates
- Run `/generate-testcases` manually if they declined regeneration
