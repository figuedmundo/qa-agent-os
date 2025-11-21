# Phase 1: Detect Ticket

## Ticket Selection Logic

This phase identifies which ticket's test plan to revise.

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

Scan `qa-agent-os/features/` for all tickets with test-plan.md and present:

```
Which ticket's test plan to revise?

Active tickets:
  [1] WYX-125 (currently testing - updated 2 hours ago)
  [2] WYX-124 (testing complete - updated 2025-11-19)
  [3] WYX-123 (testing in progress - updated 2025-11-18)

Choose [1-3]:
```

**Prioritization rules:**
- Recently updated tickets appear first
- Show last modified timestamp
- Show status hint based on recency

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

This creates the ticket structure and test plan.
```

**If test-plan.md doesn't exist:**
```
Error: test-plan.md not found for ticket [ticket-id].

A test plan is required to revise. Run:
  /plan-ticket [ticket-id]
```

### Read Current Test Plan Metadata

Extract information from test-plan.md:
- Current version (from metadata or Section 11)
- Last updated timestamp
- Number of requirements
- Number of test scenarios

Store for display:
```
Current test plan:
  Version: 1.2
  Last updated: 2025-11-19 14:23
  Requirements: 8
  Test scenarios: 15
```

### Set Variables for Next Phase

Once validated:
```
TICKET_ID=[ticket-id]
FEATURE_NAME=[feature-name]
TICKET_PATH=qa-agent-os/features/[feature-name]/[ticket-id]
TEST_PLAN_PATH=[ticket-path]/test-plan.md
CURRENT_VERSION=[version from test-plan.md]
```

### Success Confirmation

```
Selected: [ticket-id] in feature [feature-name]
Test plan found: [test-plan-path]
Current version: [version]

Proceeding to Phase 2: Prompt Update Type
```

### Next Phase

Continue to Phase 2: Prompt Update Type
