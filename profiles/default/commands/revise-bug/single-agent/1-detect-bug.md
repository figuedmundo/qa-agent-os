# Phase 1: Detect Bug

## Bug Selection Logic

This phase identifies which bug report to revise.

### Check for Direct Parameter

**If bug ID provided as parameter:**
```
Using provided bug ID: [bug-id]
```
- Set `BUG_ID=[bug-id]`
- Skip to location search

**If NO parameter provided:**
- Show interactive selection

### Interactive Selection

Scan `qa-agent-os/features/*/*/bugs/BUG-*.md` for all existing bug reports and present:

```
Which bug to revise?

Recent bugs:
  [1] BUG-003 - [Checkout] Submit fails with 500 (WYX-123) - Updated 2h ago
  [2] BUG-002 - [Login] Session timeout incorrect (WYX-122) - Updated 1d ago
  [3] BUG-001 - [Cart] Item count mismatch (WYX-121) - Updated 3d ago

Select [1-N]:
```

**Prioritization rules:**
- Recently modified bugs appear first
- Show last modified timestamp
- Include feature/ticket context in display
- Extract bug title from report for display

**User input:**
- Accepts number selection (e.g., "1")
- Sets `BUG_ID` from selected bug

### Locate Bug File

Search for the bug file in the features directory structure:

**Search pattern:**
```bash
qa-agent-os/features/*/*/bugs/[BUG_ID].md
```

**Extract context from path:**
- FEATURE_NAME from first wildcard match
- TICKET_ID from second wildcard match

Example path: `qa-agent-os/features/checkout-flow/WYX-123/bugs/BUG-001.md`
- FEATURE_NAME = checkout-flow
- TICKET_ID = WYX-123
- BUG_ID = BUG-001

### Validation

**Check 1: Bug file exists**

If bug file not found:
```
Error: Bug [bug-id] not found.

No bug report found with ID [bug-id].

Available bugs:
  - BUG-001 (checkout-flow/WYX-123)
  - BUG-002 (checkout-flow/WYX-124)

Use /revise-bug without parameters to select from list.
```

**Check 2: Bug file is valid**

Read file and verify it contains expected structure:
- Metadata section exists
- Bug Details section exists
- Revision Log section exists

### Read Current Bug Metadata

Extract information from bug report:
- Current version (from Metadata section)
- Current status (from Status Workflow section)
- Severity level
- Last updated timestamp
- Bug title

Display current state:
```
Current bug report:
  Bug ID: BUG-001
  Title: [Checkout] Submit fails with 500
  Feature: checkout-flow
  Ticket: WYX-123
  Version: 1.2
  Status: In Progress
  Severity: S2 - Major
  Last updated: 2025-11-19 14:23
```

### Set Variables for Next Phase

Once validated:
```
BUG_ID=[bug-id]
BUG_PATH=qa-agent-os/features/[feature-name]/[ticket-id]/bugs/[bug-id].md
FEATURE_NAME=[feature-name]
TICKET_ID=[ticket-id]
CURRENT_VERSION=[version from bug report]
CURRENT_STATUS=[status from bug report]
CURRENT_SEVERITY=[severity from bug report]
BUG_TITLE=[title from bug report]
```

### Success Confirmation

```
Selected: [bug-id] - [bug-title]
Context: [feature-name] / [ticket-id]
Current version: [version]
Current status: [status]

Proceeding to Phase 2: Prompt Update Type
```

### Next Phase

Continue to Phase 2: Prompt Update Type
