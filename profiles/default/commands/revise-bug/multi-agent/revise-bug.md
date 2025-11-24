# /revise-bug Command (Multi-Agent Mode)

## Purpose

Update bug reports during the bug lifecycle using specialized agents. Add evidence, change status, update severity, or add developer notes with full version tracking.

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

## Execution Flow

### PHASE 1: Detect Bug

This phase handles bug identification. Orchestration logic remains in the main command:

#### If Bug ID Provided as Parameter

```bash
# User ran: /revise-bug BUG-001
BUG_ID="BUG-001"
```

Locate the bug file:

```bash
# Find the bug file across all features and tickets
BUG_FILE=$(find qa-agent-os/features/ -name "${BUG_ID}.md" -type f)
```

**If found** -> Extract context:
- Parse feature name from path
- Parse ticket ID from path
- Set `BUG_PATH`, `FEATURE_NAME`, `TICKET_ID`

**If not found** -> Error and exit:

```
Error: Bug [BUG-ID] not found.

Verify the bug ID is correct, or use /revise-bug without parameters to see available bugs.
```

Skip to Phase 2.

#### If No Parameter Provided (Interactive Mode)

Scan for all bugs across features and tickets:

```bash
# Find all bug files
BUG_FILES=$(find qa-agent-os/features/ -path "*/bugs/BUG-*.md" -type f)

# Sort by most recently modified
# Extract bug ID, title, ticket, and modification time
```

Present selection to user:

```
Which bug to revise?

Recent bugs:
  [1] BUG-003 - [Checkout] Submit fails with 500 (PAY-456) - Updated 2h ago
  [2] BUG-002 - [Login] Session timeout incorrect (AUTH-789) - Updated 1d ago
  [3] BUG-001 - [Cart] Item count mismatch (CART-123) - Updated 3d ago

Select [1-N]:
```

User selects bug. Set variables:
- `BUG_ID` - Selected bug ID
- `BUG_PATH` - Full path to bug file
- `FEATURE_NAME` - Feature name from path
- `TICKET_ID` - Ticket ID from path

#### Validate and Load Bug

Read current bug report to extract:
- `CURRENT_VERSION` - Current version number
- `CURRENT_STATUS` - Current bug status
- `CURRENT_SEVERITY` - Current severity level

```
Selected: BUG-003 - [Checkout] Submit fails with 500

Current Status: In Progress
Current Version: 1.2
Current Severity: S2 - Major
```

Proceed to Phase 2.

### PHASE 2: Prompt Update Type

This phase gathers update details from user. Orchestration logic remains in the main command:

#### Present Update Type Options

```
What type of update are you making?

Update Types:
  [1] Add evidence - New logs, screenshots, reproduction data
  [2] Update severity/priority - Based on new information
  [3] Update status - New > In Progress > Ready for QA > Verified/Closed > Re-opened
  [4] Add reproduction info - More specific steps, environment details
  [5] Add developer notes - Root cause, fix approach
  [6] Update affected scope - Additional users/features affected

Select [1-6]:
```

Store selection as `UPDATE_TYPE`:
- Option [1] -> `UPDATE_TYPE="evidence"`
- Option [2] -> `UPDATE_TYPE="severity"`
- Option [3] -> `UPDATE_TYPE="status"`
- Option [4] -> `UPDATE_TYPE="reproduction"`
- Option [5] -> `UPDATE_TYPE="notes"`
- Option [6] -> `UPDATE_TYPE="scope"`

#### Gather Update Details Based on Type

**[1] Add Evidence:**

```
Select evidence types to add (comma-separated):
  [1] Screenshots/recordings
  [2] Console/browser logs
  [3] API request/response
  [4] Network traces
  [5] Error messages
  [6] Other

Your selection: > 2,5

[2] Console/browser logs:
> [Paste new logs or file path]

[5] Error messages:
> [Paste additional error text]
```

**[2] Update Severity/Priority:**

```
Current severity: S2 - Major
Current priority: P2

New severity [1-4]:
  [1] S1 - Critical
  [2] S2 - Major
  [3] S3 - Minor
  [4] S4 - Trivial

Select: > 1

New priority [1-4]:
  [1] P1 - Immediate
  [2] P2 - High
  [3] P3 - Medium
  [4] P4 - Low

Select: > 1

Justification for change:
> Further investigation revealed data corruption risk, escalating severity
```

**[3] Update Status:**

```
Current status: In Progress

Status options:
  [1] New (reset)
  [2] In Progress
  [3] Ready for QA
  [4] Verified
  [5] Closed
  [6] Re-opened

Select new status [1-6]: > 4

Verification method/notes:
> Tested fix in staging environment, confirmed checkout now succeeds
```

**[4] Add Reproduction Info:**

```
What reproduction information to add?

  [1] Additional steps
  [2] Environment details
  [3] Reproducibility update
  [4] Precondition update

Select: > 1

Additional steps:
> Step 4: Bug only occurs when cart has more than 10 items
```

**[5] Add Developer Notes:**

```
Developer notes type:
  [1] Root cause analysis
  [2] Fix approach
  [3] Code references
  [4] General notes

Select: > 1

Root cause analysis:
> Issue traced to null pointer in PaymentService.processOrder() when cart exceeds array bounds
```

**[6] Update Affected Scope:**

```
Scope update type:
  [1] Additional affected users
  [2] Additional affected features
  [3] Additional affected systems
  [4] Business impact update

Select: > 2

Additional affected features:
> Also affects guest checkout flow and mobile checkout
```

Store in `UPDATE_DETAILS` variable.

Proceed to Phase 3.

### PHASE 3: Apply Update

Use the **bug-writer** subagent to update the bug report.

Provide the bug-writer with:
- Bug path: `BUG_PATH`
- Bug ID: `BUG_ID`
- Update type: `UPDATE_TYPE` (evidence|severity|status|reproduction|notes|scope)
- Update details: `UPDATE_DETAILS`
- Current timestamp: `[TIMESTAMP]`
- Current version: `CURRENT_VERSION`

The bug-writer will:
- Read current bug report from `BUG_PATH`
- Parse current version number from Revision Log
- Apply the update to the appropriate section:
  - **evidence**: Add to Evidence section under appropriate subsection
  - **severity**: Update Classification > Severity & Priority table
  - **status**: Update Status Workflow > Current Status and Status History
  - **reproduction**: Update Reproduction section
  - **notes**: Add to Developer Notes section
  - **scope**: Update Analysis > Affected Areas section
- Increment version number:
  - Minor increment (X.Y) for: evidence, reproduction, notes, scope
  - Major increment (X.0) for: status (Verified, Closed, Re-opened), severity
- Add revision log entry with format:
  ```markdown
  **Version X.Y - [DATE] [TIME]**
  - Change: [Description of what changed]
  - Type: [Update type]
  - Previous: [Previous value if applicable]
  - New: [New value]
  - Reason: [Why this update was made]
  ```
- Execute workflow: `workflows/bugs/revise-bug-report`
- Save updated bug report

### Completion

Once all phases complete:

```
Bug revised successfully!

Updated: qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-003.md

Summary:
- Version: 1.2 -> 2.0
- Change: Status changed from In Progress to Verified
- Type: status

NEXT STEPS:
- Review updated bug report
- Use /revise-bug BUG-003 for additional updates
- If bug is fixed and verified, consider closing
```

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

## Version Tracking

Version format: X.Y

- **Minor increment (Y)** - Most updates (evidence, notes, minor status changes)
- **Major increment (X)** - Significant changes (Closed, Verified, Re-opened, severity)

Examples:
- 1.0 -> 1.1 (added evidence)
- 1.1 -> 1.2 (updated reproduction info)
- 1.2 -> 2.0 (status changed to Verified)
- 2.0 -> 3.0 (bug re-opened)

## Status Workflow

```
New --> In Progress --> Ready for QA --> Verified --> Closed
  ^                                                     |
  |                                                     |
  +----------------------- Re-opened <------------------+
```

## Smart Features

This multi-agent command includes:

1. **Auto-Discovery** - Finds all bugs across features and tickets
2. **Sorted by Recency** - Recently updated bugs appear first
3. **Version Tracking** - Automatic version increments
4. **Timestamped** - Always know when changes were made
5. **Reasoned** - Explains why changes occurred in revision log
6. **Agent Expertise** - Bug-writer agent ensures professional updates

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

*This command leverages the bug-writer agent to efficiently manage bugs through their complete lifecycle with full traceability and version tracking.*
