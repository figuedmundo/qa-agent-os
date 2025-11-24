# Phase 2: Prompt Update Type

## Select Revision Type

This phase prompts the user to identify what type of update is needed for the bug report.

### Variables from Phase 1

Required from previous phase:
- `BUG_ID` - The bug identifier
- `BUG_PATH` - Full path to bug file
- `FEATURE_NAME` - The feature name
- `TICKET_ID` - The ticket identifier
- `CURRENT_VERSION` - Current bug report version
- `CURRENT_STATUS` - Current bug status
- `CURRENT_SEVERITY` - Current severity level
- `BUG_TITLE` - Bug title

### Present Update Options

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

---

## Collect Update Details Based on Selection

### Option 1: Add Evidence

Reuse evidence collection checklist pattern from /report-bug Phase 2.

```
Add Evidence

Which types of evidence do you have?
Select all that apply (comma-separated, e.g., 1,2,5):

  [1] Screenshots / Recordings (file path)
  [2] Console / Browser logs (file path or paste)
  [3] API request / response (file path or paste)
  [4] Network traces (file path or HAR reference)
  [5] Error messages (paste text)
  [6] Other evidence

Select types:
> [User input]
```

For each selected evidence type, collect using same prompts as /report-bug Phase 2:

#### Type 1: Screenshots / Recordings
```
Screenshots / Recordings:

Enter file path(s), one per line. Type "DONE" when finished.
  Example: ./screenshots/additional-error.png

> [User input - file path]
> DONE
```

#### Type 2: Console / Browser Logs
```
Console / Browser Logs:

Option A: Provide file path
Option B: Paste log content directly

Choose [A/B]:
> [User input]
```

#### Type 3: API Request / Response
```
API Request / Response:

Option A: Provide file path (JSON, HAR, or text)
Option B: Paste request/response directly

Choose [A/B]:
> [User input]
```

#### Type 4: Network Traces
```
Network Traces:

Enter file path to HAR file, request IDs, or correlation IDs:
> [User input]
```

#### Type 5: Error Messages
```
Error Messages:

Paste the exact error message(s). Type "END" on new line when done:
> [User input - multiline until "END"]
```

#### Type 6: Other Evidence
```
Other Evidence:

Describe the additional evidence:
> [User input]

File path (if applicable, or "None"):
> [User input]
```

Store as:
```
UPDATE_TYPE=add_evidence
UPDATE_DETAILS={
  evidence: {
    screenshots: [...],
    console_logs: {...},
    api_data: {...},
    network_traces: {...},
    error_messages: [...],
    other: {...}
  },
  reason: "[User-provided reason for adding evidence]"
}
```

---

### Option 2: Update Severity/Priority

Display current values and prompt for changes:

```
Update Severity/Priority

Current values:
  Severity: [CURRENT_SEVERITY]
  Priority: [current priority from report]

Severity options:
  [1] S1 - Critical (system down, data loss, no workaround)
  [2] S2 - Major (feature broken, workaround difficult)
  [3] S3 - Minor (feature impaired, workaround exists)
  [4] S4 - Trivial (cosmetic, minimal impact)

Select new severity [1-4]:
> [User input]
```

```
Priority options:
  [1] P1 - Fix immediately
  [2] P2 - Fix in current sprint
  [3] P3 - Fix in next sprint
  [4] P4 - Fix when convenient

Select new priority [1-4]:
> [User input]
```

```
Justification for change:
> [User input - required]
```

Store as:
```
UPDATE_TYPE=update_severity
UPDATE_DETAILS={
  previous_severity: "[CURRENT_SEVERITY]",
  new_severity: "[selected severity]",
  previous_priority: "[current priority]",
  new_priority: "[selected priority]",
  justification: "[user justification]"
}
```

---

### Option 3: Update Status

Display current status and valid transitions:

```
Update Status

Current status: [CURRENT_STATUS]

Status options:
  [1] New (reset)
  [2] In Progress
  [3] Ready for QA
  [4] Verified
  [5] Closed
  [6] Re-opened

Select new status [1-6]:
> [User input]
```

Based on selection, prompt for additional details:

**If "In Progress" selected:**
```
Assigned to (developer name or ID):
> [User input]
```

**If "Ready for QA" selected:**
```
Fix description (what was changed):
> [User input]

Build/version with fix:
> [User input]
```

**If "Verified" selected:**
```
Verification method:
> [User input - how was the fix verified]

Verified in build/version:
> [User input]
```

**If "Closed" selected:**
```
Closure reason:
  [1] Fixed
  [2] Won't fix
  [3] Duplicate (provide duplicate bug ID)
  [4] Cannot reproduce
  [5] By design

Select [1-5]:
> [User input]
```

**If "Re-opened" selected:**
```
Re-open reason:
> [User input - why is the bug being re-opened]

Build/version where issue returned:
> [User input]
```

Store as:
```
UPDATE_TYPE=update_status
UPDATE_DETAILS={
  previous_status: "[CURRENT_STATUS]",
  new_status: "[selected status]",
  additional_details: {
    // Varies based on status selected
  },
  notes: "[User notes]"
}
```

---

### Option 4: Add Reproduction Info

Prompt for additional reproduction details:

```
Add Reproduction Info

What additional information do you have?

  [1] More specific steps
  [2] Additional environment details
  [3] Reproducibility update
  [4] Additional preconditions

Select [1-4] (can select multiple, comma-separated):
> [User input]
```

**If "More specific steps" selected:**
```
Additional or refined reproduction steps:
(These will be appended to existing steps)

> [User input - multiline]
```

**If "Additional environment details" selected:**
```
Additional environment details:
  Browser/Device:
  > [User input]

  Network conditions:
  > [User input]

  Data state:
  > [User input]

  Other:
  > [User input]
```

**If "Reproducibility update" selected:**
```
Updated reproducibility:

Rate (Always / Intermittent):
> [User input]

New attempts (X out of Y):
> [User input]

Conditions affecting reproducibility:
> [User input]
```

**If "Additional preconditions" selected:**
```
Additional preconditions discovered:
> [User input - multiline]
```

Store as:
```
UPDATE_TYPE=add_reproduction
UPDATE_DETAILS={
  additional_steps: "[steps if provided]",
  environment_details: {...},
  reproducibility: {...},
  preconditions: "[preconditions if provided]",
  reason: "[why this info was added]"
}
```

---

### Option 5: Add Developer Notes

Prompt for developer analysis:

```
Add Developer Notes

What developer information to add?

  [1] Root cause analysis
  [2] Fix approach
  [3] Code references
  [4] Related code changes
  [5] General notes

Select [1-5] (can select multiple, comma-separated):
> [User input]
```

**If "Root cause analysis" selected:**
```
Root cause analysis:
(What was found to be the actual cause of the bug)

> [User input - multiline]
```

**If "Fix approach" selected:**
```
Fix approach:
(How the bug will be or was fixed)

> [User input - multiline]
```

**If "Code references" selected:**
```
Code references:
(Files, functions, or components involved)

> [User input - multiline, e.g., "src/checkout/handler.js:145"]
```

**If "Related code changes" selected:**
```
Related code changes:
(Commit hashes, PRs, or branch names)

> [User input]
```

**If "General notes" selected:**
```
Developer notes:
> [User input - multiline]
```

Store as:
```
UPDATE_TYPE=add_developer_notes
UPDATE_DETAILS={
  root_cause: "[analysis if provided]",
  fix_approach: "[approach if provided]",
  code_references: "[references if provided]",
  code_changes: "[changes if provided]",
  general_notes: "[notes if provided]"
}
```

---

### Option 6: Update Affected Scope

Prompt for scope expansion:

```
Update Affected Scope

What additional scope information to add?

  [1] Additional affected users
  [2] Additional affected features
  [3] Additional affected systems
  [4] Business impact update

Select [1-4] (can select multiple, comma-separated):
> [User input]
```

**If "Additional affected users" selected:**
```
Additional affected users:
(User types, roles, or segments impacted)

> [User input - multiline]
```

**If "Additional affected features" selected:**
```
Additional affected features:
(Other features or flows impacted by this bug)

> [User input - multiline]
```

**If "Additional affected systems" selected:**
```
Additional affected systems:
(Other systems, services, or integrations impacted)

> [User input - multiline]
```

**If "Business impact update" selected:**
```
Updated business impact:
(Revenue, user experience, compliance implications)

> [User input - multiline]
```

Store as:
```
UPDATE_TYPE=update_scope
UPDATE_DETAILS={
  affected_users: "[users if provided]",
  affected_features: "[features if provided]",
  affected_systems: "[systems if provided]",
  business_impact: "[impact if provided]",
  reason: "[why scope was updated]"
}
```

---

## Set Variables for Next Phase

Pass to Phase 3:
```
BUG_ID=[bug-id]
BUG_PATH=[path]
FEATURE_NAME=[feature-name]
TICKET_ID=[ticket-id]
CURRENT_VERSION=[version]
CURRENT_STATUS=[status]
BUG_TITLE=[title]
UPDATE_TYPE=[add_evidence|update_severity|update_status|add_reproduction|add_developer_notes|update_scope]
UPDATE_DETAILS=[details object]
```

### Success Confirmation

```
Update type selected: [UPDATE_TYPE]
Details collected.

Proceeding to Phase 3: Apply Update
```

### Next Phase

Continue to Phase 3: Apply Update
