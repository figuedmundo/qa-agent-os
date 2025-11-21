# Phase 0: Smart Detection & Feature Selection

## Smart Context Detection

This phase intelligently detects the context of your ticket and guides you through the appropriate workflow.

**I will check:**

1. **Does the ticket already exist?** - If yes, show re-execution options
2. **Which feature does this ticket belong to?** - If new ticket, detect and select the feature

### Scenario 1: Existing Ticket

If I detect that `features/[feature-name]/[ticket-id]/` already exists, I'll present options:

```
Ticket [ticket-id] already exists in feature [feature-name].

Options:
  [1] Full re-plan (Phases 1-4: re-gather docs, re-analyze, regenerate cases)
  [2] Update test plan only (Skip to Phase 3: re-analyze requirements)
  [3] Regenerate test cases only (Skip to Phase 4: use existing test-plan.md)
  [4] Cancel
```

**Choose based on your needs:**
- **Option 1** - Start fresh: re-gather all documentation, re-analyze, recreate everything
- **Option 2** - Refresh the test plan: Keep existing docs, re-analyze requirements, get updated test scenarios
- **Option 3** - New test cases: Keep test plan, just regenerate the test case details
- **Option 4** - Exit without changes

### Scenario 2: New Ticket - Feature Selection

If this is a new ticket, I'll detect available features and ask:

```
Which feature does ticket [ticket-id] belong to?

Features found:
  [1] Feature-Name-1
  [2] Feature-Name-2
  [3] Create new feature
```

**Your options:**
- **Select [1] or [2]** - Choose an existing feature (its knowledge and strategy will apply)
- **Select [Create new]** - If the feature doesn't exist yet
  - I'll guide you to run `/plan-feature` first
  - Then return here to `/plan-ticket`
- If only ONE feature exists, I'll auto-detect it and ask for confirmation:
  ```
  Found feature: [Feature Name]. Is this correct? [y/n]
  ```

### Special Cases

**No features exist yet:**
```
No features found. Please create a feature first:
  /plan-feature [feature-name]
Then return to plan the ticket.
```

**Multiple features with same name variations:**
I'll normalize names to avoid duplicates. Select the one that matches your ticket's feature.

**Why This Matters:**

This detection logic ensures:
- You don't re-gather documentation unnecessarily
- Existing feature knowledge is reused automatically
- Re-execution is efficient (you choose the right path)
- Feature selection is smart and guided
- The workflow prevents errors and wasted effort

**Next Phase:**

Based on detection results, I'll route you to:
- **Phase 1** (new ticket) - Initialize structure
- **Phase 3** (update test plan only) - Re-analyze requirements
- **Phase 4** (regenerate cases only) - Regenerate from existing plan

Let me detect your ticket context now. Provide the ticket ID:

[Ticket ID] (e.g., WYX-123, TICKET-001, ABC-456)
