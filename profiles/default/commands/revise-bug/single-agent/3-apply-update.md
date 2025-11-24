# Phase 3: Apply Update

## Execute Bug Report Revision

This phase applies the update to the bug report and manages version tracking.

### Variables from Previous Phases

Set by previous phases:
- **BUG_ID**: Bug identifier
- **BUG_PATH**: Full path to bug file
- **FEATURE_NAME**: Feature name
- **TICKET_ID**: Ticket identifier
- **CURRENT_VERSION**: Current version number
- **CURRENT_STATUS**: Current bug status
- **BUG_TITLE**: Bug title
- **UPDATE_TYPE**: Type of update to apply
- **UPDATE_DETAILS**: Details collected from user

---

## Version Increment

Determine next version number using X.Y format:
- X = Major version (increments on significant changes like status closure)
- Y = Minor version (increments on most updates)

**Version increment rules:**
- `add_evidence` -> increment minor (1.0 -> 1.1)
- `update_severity` -> increment minor (1.1 -> 1.2)
- `update_status` to Closed/Verified -> increment major (1.2 -> 2.0)
- `update_status` to Re-opened -> increment major (2.0 -> 3.0)
- `update_status` other -> increment minor
- `add_reproduction` -> increment minor
- `add_developer_notes` -> increment minor
- `update_scope` -> increment minor

Calculate:
```
NEXT_VERSION=[calculated version]
```

---

## Apply Update Based on Type

### Update Type: add_evidence

**Section to update:** Evidence

Read current Evidence section and append new evidence:

**Screenshots / Recordings:**
- Append new file paths to existing list

**Console / Browser Logs:**
- Add new log section with header: `### Additional Logs - [timestamp]`
- Include analyzed summary if logs were parsed

**API Request / Response:**
- Add new API section with header: `### Additional API Data - [timestamp]`

**Network Traces:**
- Append new traces to existing list

**Error Messages:**
- Append new error messages to existing list

**Additional Evidence:**
- Add to "Additional Evidence" subsection

---

### Update Type: update_severity

**Sections to update:** Classification > Severity & Priority

Update the severity and priority table:

```markdown
### Severity & Priority

| Property | Value |
|----------|-------|
| **Severity** | [NEW_SEVERITY] |
| **Priority** | [NEW_PRIORITY] |
| **Justification** | [USER_JUSTIFICATION] |
```

**Previous values preserved in revision log.**

---

### Update Type: update_status

**Sections to update:** Status Workflow

Update current status:
```markdown
**Current Status:** [NEW_STATUS]
```

Add new row to Status History table:
```markdown
| [NEW_STATUS] | [TIMESTAMP] | [UPDATER] | [NOTES] |
```

**Additional updates based on status:**

**If "In Progress":**
- Update Ownership > Assignee

**If "Ready for QA":**
- Add note to Status History with fix description
- Update build/version in Environment if provided

**If "Verified":**
- Update Ownership > QA Verifier
- Add verification notes to Status History

**If "Closed":**
- Add closure reason to Status History
- If "Duplicate", add reference to duplicate bug

**If "Re-opened":**
- Add re-open reason to Status History
- Update Environment with new build/version where issue returned

---

### Update Type: add_reproduction

**Sections to update:** Reproduction

**If additional steps:**
- Append to "Steps to Reproduce" with header: `### Additional Steps (Added [date])`

**If environment details:**
- Update Environment table with new values
- Add notes for new environment conditions

**If reproducibility update:**
- Update Reproducibility table with new values

**If additional preconditions:**
- Append to Preconditions section

---

### Update Type: add_developer_notes

**Sections to update:** Developer Notes, Analysis

**If root cause analysis:**
- Update "Root Cause Hypothesis" section with confirmed analysis
- Add header: `### Confirmed Root Cause (Added [date])`

**If fix approach:**
- Add to Developer Notes section: `### Fix Approach`

**If code references:**
- Add to Developer Notes section: `### Code References`

**If related code changes:**
- Add to Developer Notes section: `### Related Changes`

**If general notes:**
- Append to Developer Notes section

---

### Update Type: update_scope

**Sections to update:** Analysis > Affected Areas

**If affected users:**
- Add subsection: `### Affected Users`

**If affected features:**
- Add subsection: `### Affected Features`

**If affected systems:**
- Add subsection: `### Affected Systems`

**If business impact:**
- Add subsection: `### Business Impact`

---

## Add Revision Log Entry

Append to "Revision Log > Change History" section:

```markdown
**Version [NEXT_VERSION] - [DATE] [TIME]**
- Change: [UPDATE_TYPE_DESCRIPTION]
- Type: [UPDATE_TYPE]
- Previous value: [PREVIOUS_VALUE if applicable]
- New value: [NEW_VALUE]
- Reason: [USER_PROVIDED_REASON]
```

**Update type descriptions:**
- `add_evidence` -> "Added new evidence ([types added])"
- `update_severity` -> "Updated severity from [old] to [new]"
- `update_status` -> "Status changed from [old] to [new]"
- `add_reproduction` -> "Added reproduction information ([types added])"
- `add_developer_notes` -> "Added developer notes ([types added])"
- `update_scope` -> "Updated affected scope ([types added])"

---

## Update Metadata

Update the Metadata section:
- **Version**: [NEXT_VERSION]

Update timestamps where applicable based on modification.

---

## Save Updated Bug Report

Write the modified content back to BUG_PATH.

Verify file was saved correctly.

---

## Completion Summary

Display completion message:

```
Bug revised successfully!

Updated: [BUG_PATH]

Version: [CURRENT_VERSION] -> [NEXT_VERSION]
Change: [UPDATE_TYPE_DESCRIPTION]

Changes made:
- [Section 1] updated
- [Section 2] updated
- Revision log entry added

NEXT STEPS:
- Review updated bug report
- Use /revise-bug [BUG_ID] for additional updates
```

---

## Post-Revision Options

Prompt user:
```
Would you like to:
  [1] View the updated bug report
  [2] Make another update to this bug
  [3] Done

Select [1-3]:
```

**If user chooses [1]:**
Display the updated bug report content.

**If user chooses [2]:**
Return to Phase 2 (Prompt Update Type) with same bug context.

**If user chooses [3]:**
```
Bug update complete!

You can update this bug again later with:
  /revise-bug [BUG_ID]

Or report a new bug with:
  /report-bug
```

---

## Success Summary

Display final summary:

```
Revision complete!

Bug: [BUG_ID] - [BUG_TITLE]
Location: [BUG_PATH]
New version: [NEXT_VERSION]

You can:
  - Continue testing
  - Run /revise-bug [BUG_ID] for more updates
  - Run /report-bug to report a new bug
```

### Command Complete

Bug revision workflow is complete.
