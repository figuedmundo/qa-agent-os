# Phase 0: Detect Context

## Smart Context Detection

This phase intelligently detects the ticket context for bug reporting and sets up the bug file location.

**I will check:**

1. **Which feature does this bug belong to?** - Detect and select from available features
2. **Which ticket does this bug belong to?** - Detect and select from tickets within the feature
3. **What is the next bug ID?** - Auto-increment from existing bugs

### Feature Selection

Scan `qa-agent-os/features/` for available features:

**If multiple features exist:**
```
Which feature does this bug belong to?

Features found:
  [1] Feature-Name-1
  [2] Feature-Name-2
  [3] Feature-Name-3

Select [1-N]:
```

**If only ONE feature exists:**
```
Found feature: [Feature Name]. Is this correct? [y/n]
```

**If NO features exist:**
```
No features found. Please create a feature first:
  /plan-feature [feature-name]
Then run /plan-ticket to create a ticket structure.
```

### Ticket Selection

Once feature is selected, scan `qa-agent-os/features/[feature-name]/` for tickets:

**If multiple tickets exist:**
```
Which ticket does this bug belong to?

Tickets in [Feature Name]:
  [1] WYX-125 (updated 2 hours ago)
  [2] WYX-124 (updated 1 day ago)
  [3] WYX-123 (updated 3 days ago)

Select [1-N]:
```

**If only ONE ticket exists:**
```
Found ticket: [Ticket ID]. Is this correct? [y/n]
```

**If NO tickets exist:**
```
No tickets found in feature [Feature Name]. Please create a ticket first:
  /plan-ticket [ticket-id]
Then return to report the bug.
```

### Ticket Validation

Verify ticket structure exists:

**Check: Ticket folder exists**
```bash
qa-agent-os/features/[feature-name]/[ticket-id]/
```

**If ticket folder doesn't exist:**
```
Error: Ticket [ticket-id] not found.

Have you run /plan-ticket yet?
  /plan-ticket [ticket-id]

This creates the ticket structure needed for bug reporting.
```

### Bug Folder Setup

Create bugs subfolder if it doesn't exist:
```bash
qa-agent-os/features/[feature-name]/[ticket-id]/bugs/
```

### Auto-Increment Bug ID

Scan existing bugs in the ticket folder to determine next ID:

```bash
# Scan for existing BUG-*.md files
qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-*.md
```

**ID Assignment Logic:**
- If no bugs exist: `BUG-001`
- If BUG-001, BUG-002 exist: `BUG-003`
- Always zero-padded to 3 digits (001, 002, ..., 999)

Display assigned ID:
```
Bug ID assigned: BUG-[XXX]

Bug will be saved to:
  qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-[XXX].md
```

### Mode Detection

Check if direct mode parameters were provided:

**Direct Mode Indicators:**
- `--title "Bug title"` parameter present
- `--severity S1|S2|S3|S4` parameter present (optional)
- Other parameters like `--steps`, `--expected`, `--actual`

**If direct mode:**
```
Direct mode detected. Validating parameters...

Required: --title
Optional: --severity, --steps, --expected, --actual, --environment

Provided parameters:
  --title: [value]
  --severity: [value or "not provided - will classify"]
```

**If interactive mode (no parameters):**
```
Interactive mode. I'll guide you through bug reporting step by step.
```

### Set Variables for Next Phase

Once context is established:
```
FEATURE_NAME=[feature-name]
TICKET_ID=[ticket-id]
TICKET_PATH=qa-agent-os/features/[feature-name]/[ticket-id]
BUG_ID=BUG-[XXX]
BUG_PATH=[TICKET_PATH]/bugs/BUG-[XXX].md
BUGS_FOLDER=[TICKET_PATH]/bugs
MODE=[interactive|direct]
```

### Success Confirmation

```
Context established:
  Feature: [FEATURE_NAME]
  Ticket: [TICKET_ID]
  Bug ID: [BUG_ID]
  Mode: [MODE]

Proceeding to Phase 1: Collect Details
```

### Next Phase

Continue to Phase 1: Collect Details
