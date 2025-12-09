# /revise-bug Command

## Purpose

Update existing bug reports at feature level with new evidence, status changes, severity updates, and investigation notes. Maintains version tracking and revision history.

## Usage

```bash
/revise-bug                                    # Interactive bug selection
/revise-bug BUG-001                            # Revise specific bug by ID
/revise-bug --feature payment-gateway BUG-003  # Specify feature explicitly
```

## Smart Features

### Feature-Level Bug Discovery
- Auto-detects feature context from current working directory
- Discovers all bugs in feature from bugs/ directory
- Auto-selects if only one bug exists
- Shows interactive menu if multiple bugs exist
- Supports explicit bug ID parameter for direct access

### Bug Summary Display
- Shows current bug title, status, severity
- Displays last update timestamp
- Shows related tickets and Jira ID if available
- Provides clear context before revision prompts

### Revision Type Menu
Choose from 7 revision types:
1. Add Evidence (new materials to subfolders)
2. Update Status (progress through workflow)
3. Update Severity (re-classify severity with justification)
4. Add Investigation Notes (root cause, fix strategy)
5. Update Description (reproduction steps, environment)
6. Update Ticket References (add/update related tickets)
7. Add Jira ID (when bug approved and exported to Jira)

### Intelligent Evidence Management
- Organizes files into semantic subfolders:
  - screenshots/ (PNG, JPG, GIF)
  - logs/ (TXT, LOG)
  - videos/ (MP4, MOV, WebM)
  - artifacts/ (HAR, JSON, SQL)
- Validates file existence before copying
- Updates bug-report.md Attachments section
- Maintains relative paths for portability

### Version and Revision Tracking
- Maintains semantic versioning (1.0, 1.1, 2.0, etc.)
- Major increment for status changes (Open → Approved, Resolved, Closed)
- Minor increment for evidence, notes, description updates
- Tracks every change with timestamp and type
- Maintains audit trail in revision log

## Execution Phases

This is an orchestrated command with 3 phases (0-2):

{{PHASE 0: @qa-agent-os/commands/revise-bug/0-detect-bug.md}}

{{PHASE 1: @qa-agent-os/commands/revise-bug/1-select-revision-type.md}}

{{PHASE 2: @qa-agent-os/commands/revise-bug/2-apply-revision.md}}

## Workflow Examples

### Example 1: Interactive Bug Selection and Revision

```
cd qa-agent-os/features/payment-gateway/

/revise-bug

[Phase 0: Bug Detection and Selection]
Detecting bug context...
Feature detected: payment-gateway

Bugs found in feature:
  [1] BUG-001 - Checkout validation error [Status: Open]
  [2] BUG-002 - Payment processing timeout [Status: In Progress]
  [3] BUG-003 - Currency conversion error [Status: Open]
  [0] Cancel

Select a bug to revise [0-3]: 2

Selected: BUG-002 - Payment processing timeout

Current Status: In Progress
Last Updated: 2025-12-08 14:30:00
Severity: S2
Related Ticket: TICKET-456

[Phase 1: Select Revision Type]
What would you like to update?
  [1] Add Evidence
  [2] Update Status
  [3] Update Severity
  [4] Add Investigation Notes
  [5] Update Description
  [6] Update Ticket References
  [7] Add Jira ID
  [0] Cancel

Enter selection [0-7]: 2

[Phase 2: Apply Revision]
Current Status: In Progress
Valid next status:
  [1] Open (re-open)
  [2] Approved (mark approved)
  [3] Resolved (mark resolved)
  [4] Closed (mark closed)
  [0] Cancel

Enter selection [0-4]: 3

Status will be updated: In Progress → Resolved
Date Updated: 2025-12-08 15:45:30
Version: 1.2 → 2.0 (major status change)

Updating bug-report.md...
✓ Status updated to Resolved
✓ Version incremented to 2.0
✓ Revision log entry added
✓ Date Updated field updated

Bug revision complete!
Updated: qa-agent-os/features/payment-gateway/bugs/BUG-002-payment-processing-timeout/bug-report.md

Next Steps:
  - Continue with more revisions, or
  - Run /revise-bug again to update another bug
```

### Example 2: Direct Access with Specific Bug ID

```
cd qa-agent-os/features/payment-gateway/

/revise-bug BUG-001

[Phase 0: Bug Detection]
Found bug: BUG-001 - Checkout validation error

Current Status: Open
Last Updated: 2025-12-08 10:00:00
Severity: S3
Related Ticket: TICKET-455

[Phase 1: Select Revision Type]
What would you like to update?
  [1] Add Evidence
  [2] Update Status
  ...
  [0] Cancel

Enter selection [0-7]: 1

[Phase 2: Apply Revision]
Add Evidence Type
=================
  [1] Screenshot (PNG, JPG, GIF)
  [2] Log (TXT, LOG)
  [3] Video (MP4, MOV, WebM)
  [4] Artifact (HAR, JSON, SQL)
  [5] Cancel

Enter selection [1-5]: 1

Enter file path: /Users/you/Desktop/checkout-error.png

Description: Validation error message displayed after form submission

Copying file to screenshots/...
✓ File copied: screenshots/checkout-error.png
✓ Attachments section updated
✓ Version incremented to 1.1 (minor update)
✓ Revision log entry added

Evidence added successfully!
```

## Output Structure

Revisions are applied to feature-level bugs:
```
qa-agent-os/features/[feature-name]/bugs/BUG-XXX-[short-title]/
├── bug-report.md (updated with revisions)
├── screenshots/ (new evidence added here)
├── logs/
├── videos/
└── artifacts/
```

## Status Workflow

Valid status transitions:
- **Open** → In Progress, Approved, Closed
- **In Progress** → Approved, Resolved, Closed, Open (re-open)
- **Approved** → Resolved, Closed, Open (re-open)
- **Resolved** → Closed, Open (re-open)
- **Closed** → Open (re-open)

### Major Version Increments
Status changes to: Approved, Resolved, Closed
Example: 1.2 → 2.0

### Minor Version Increments
Changes to: Evidence, Notes, Description, Severity, Ticket References
Example: 1.0 → 1.1

## Revision Log Format

Each revision adds an entry to the revision log:

```
| Date | Version | Change Type | Details |
|------|---------|-------------|---------|
| 2025-12-08 10:00:00 | 1.0 | Initial Report | Bug created, Severity: S3, Status: Open |
| 2025-12-08 14:30:00 | 1.1 | Evidence Added | Added screenshot: checkout-error.png |
| 2025-12-08 15:45:30 | 2.0 | Status Updated | Status changed to Resolved |
```

## Related Commands

- `/report-bug` - Create new bug reports at feature level
- `/plan-ticket` - Create ticket structure for testing
- `/generate-testcases` - Generate test cases for ticket testing
- `/start-feature` - Create feature structure

## Standards Applied

Bug revisions follow these standards:
- `@qa-agent-os/standards/bugs/bug-reporting.md` - Report structure, severity rules
- `@qa-agent-os/standards/global/bugs.md` - Bug lifecycle and conventions
- `@qa-agent-os/templates/bug-report.md` - Template structure

## Error Handling

The command provides helpful error messages:

**No bugs found in feature:**
```
ERROR: No bugs found in feature: payment-gateway

Run /report-bug to create your first bug:
  /report-bug --title "Bug description"
```

**Bug not found:**
```
ERROR: Bug BUG-001 not found in feature

Available bugs:
  BUG-001 - Checkout validation error
  BUG-002 - Payment processing timeout

Run /revise-bug BUG-001 to revise a specific bug
```

**Feature context not detected:**
```
ERROR: Could not detect feature context from current directory.

Please run this command from a feature directory:
  cd qa-agent-os/features/[feature-name]/

Or specify feature explicitly:
  /revise-bug --feature payment-gateway BUG-001
```

---

*Update bug reports efficiently with organized revision tracking. All changes tracked with version history and audit trail.*
