# /revise-bug Command

## Purpose

Update bug reports during the bug lifecycle - add evidence, change status, update severity, or add developer notes with full version tracking.

## Usage

```bash
/revise-bug              # Interactive - select bug from list
/revise-bug BUG-001      # Direct - revise specific bug
```

## When to Use

- **Adding evidence** - Found additional logs, screenshots, or reproduction data
- **Updating severity** - New information changes the bug's impact assessment
- **Changing status** - Bug moving through workflow (New > In Progress > Verified > Closed)
- **Adding reproduction info** - Discovered more specific steps or environment details
- **Adding developer notes** - Recording root cause analysis or fix approach
- **Updating scope** - Found additional affected users, features, or systems

## Execution Phases

This is an orchestrated command with 3 phases:

{{PHASE 1: @qa-agent-os/commands/revise-bug/1-detect-bug.md}}

{{PHASE 2: @qa-agent-os/commands/revise-bug/2-prompt-update-type.md}}

{{PHASE 3: @qa-agent-os/commands/revise-bug/3-apply-update.md}}

## Revision Types

### 1. Add Evidence
- New screenshots or recordings
- Additional console/browser logs
- API request/response captures
- Network traces
- Error messages

### 2. Update Severity/Priority
- Severity change (S1-S4)
- Priority change (P1-P4)
- Requires justification

### 3. Update Status
- New (reset)
- In Progress (assigned to developer)
- Ready for QA (fix deployed)
- Verified (fix confirmed)
- Closed (resolved or won't fix)
- Re-opened (regression found)

### 4. Add Reproduction Info
- More specific steps
- Additional environment details
- Reproducibility rate update
- Additional preconditions

### 5. Add Developer Notes
- Root cause analysis
- Fix approach
- Code references
- Related code changes

### 6. Update Affected Scope
- Additional affected users
- Additional affected features
- Additional affected systems
- Business impact update

## How It Works

1. Select bug (if not specified)
2. Select update type
3. Provide details specific to update type
4. Bug report updated with:
   - Modified sections
   - Version increment
   - Timestamp and reason
   - Revision log entry
5. Optional: View report or make additional updates

## Revision Log

Each update creates a revision entry:

```markdown
**Version X.Y - [date] [time]**
- Change: [update description]
- Type: [update type]
- Previous value: [if applicable]
- New value: [updated value]
- Reason: [why this update was made]
```

Full history is preserved for traceability and audit.

## Version Tracking

Version format: X.Y
- **Minor increment (Y)** - Most updates (evidence, notes, minor status changes)
- **Major increment (X)** - Significant changes (Closed, Verified, Re-opened)

Examples:
- 1.0 -> 1.1 (added evidence)
- 1.1 -> 1.2 (updated severity)
- 1.2 -> 2.0 (status changed to Closed)
- 2.0 -> 3.0 (bug re-opened)

## Status Workflow

```
New --> In Progress --> Ready for QA --> Verified --> Closed
  ^                                                     |
  |                                                     |
  +----------------------- Re-opened <------------------+
```

## Smart Features

- **Auto-discovery** - Finds all bugs across features and tickets
- **Sorted by recency** - Recently updated bugs appear first
- **Version tracking** - Automatic version increments
- **Timestamped** - Always know when changes were made
- **Reasoned** - Explains why changes occurred
- **Flexible** - Make multiple updates in sequence

## Examples

### Interactive Mode
```
> /revise-bug

Which bug to revise?

Recent bugs:
  [1] BUG-003 - [Checkout] Submit fails with 500 (WYX-123) - Updated 2h ago
  [2] BUG-002 - [Login] Session timeout incorrect (WYX-122) - Updated 1d ago

Select [1-2]:
> 1

What type of update are you making?
  [1] Add evidence
  [2] Update severity/priority
  [3] Update status
  ...

Select [1-6]:
> 3

Current status: In Progress

Status options:
  [1] New (reset)
  [2] In Progress
  [3] Ready for QA
  ...

Select new status [1-6]:
> 4

Verification method:
> Tested fix in staging, confirmed checkout now succeeds

Bug revised successfully!
Version: 1.2 -> 2.0
Change: Status changed from In Progress to Verified
```

### Direct Mode
```
> /revise-bug BUG-001

Using provided bug ID: BUG-001
...
```

## Related Commands

- `/report-bug` - Create a new bug report
- `/plan-ticket` - Plan ticket testing
- `/generate-testcases` - Generate test cases

## Standards Applied

This command follows:
- `@qa-agent-os/standards/bugs/severity-rules.md`
- `@qa-agent-os/standards/bugs/bug-reporting-standard.md`
- `@qa-agent-os/standards/bugs/bug-template.md`

---

Perfect for managing bugs through their complete lifecycle with full traceability!
