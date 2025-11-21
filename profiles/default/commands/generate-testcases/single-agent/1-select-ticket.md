# Phase 1: Select Ticket

## Ticket Selection Logic

This phase identifies which ticket's test cases to generate.

### Check for Direct Parameter

**If ticket ID provided as parameter:**
```
Using provided ticket ID: [ticket-id]
```
- Set `TICKET_ID=[ticket-id]`
- Skip to validation

**If NO parameter provided:**
- Show interactive selection

### Interactive Selection

Scan `qa-agent-os/features/` for all tickets and present:

```
Which ticket's test cases to generate?

Recent tickets:
  [1] WYX-125 (no test-cases.md yet) <- NEW
  [2] WYX-124 (test-cases.md exists - last updated 2025-11-19)
  [3] WYX-123 (test-cases.md exists - last updated 2025-11-18)

Choose [1-3]:
```

**Prioritization rules:**
- Tickets WITHOUT test-cases.md appear first with "<- NEW" label
- Tickets WITH test-cases.md show last modified date
- Newest tickets first within each group

**User input:**
- Accepts number selection (e.g., "1")
- Sets `TICKET_ID` from selected ticket

### Validation

Verify ticket structure exists:

**Check 1: Ticket folder exists**
```bash
qa-agent-os/features/[feature-name]/[ticket-id]/
```

**Check 2: test-plan.md exists**
```bash
qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md
```

**If folder doesn't exist:**
```
Error: Ticket [ticket-id] not found.

Have you run /plan-ticket yet?
  /plan-ticket [ticket-id]

This creates the ticket structure and test plan needed for test case generation.
```

**If test-plan.md doesn't exist:**
```
Error: test-plan.md not found for ticket [ticket-id].

The test plan is required to generate test cases.
Run /plan-ticket to create it:
  /plan-ticket [ticket-id]
```

### Set Variables for Next Phase

Once validated:
```
TICKET_ID=[ticket-id]
FEATURE_NAME=[feature-name]
TICKET_PATH=qa-agent-os/features/[feature-name]/[ticket-id]
TEST_PLAN_PATH=[ticket-path]/test-plan.md
TEST_CASES_PATH=[ticket-path]/test-cases.md
```

### Success Confirmation

```
Selected: [ticket-id] in feature [feature-name]
Test plan found: [test-plan-path]

Proceeding to Phase 2: Conflict Detection
```

### Next Phase

Continue to Phase 2: Detect Conflicts
