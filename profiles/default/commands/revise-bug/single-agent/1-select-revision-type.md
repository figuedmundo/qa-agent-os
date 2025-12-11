# Phase 1: Select Revision Type

## Purpose

Present user with revision type options and collect relevant information for the selected revision type.

---

## Display Revision Menu

Show available revision types based on current bug state:

```
What would you like to update?

  [1] Add Evidence - New screenshots, logs, videos, or artifacts
  [2] Update Status - Progress through workflow (Open → In Progress → Approved → Resolved → Closed)
  [3] Update Severity - Re-classify severity with new information
  [4] Add Investigation Notes - Root cause analysis, fix strategy, or progress
  [5] Update Description - Reproduction steps, environment, or scope
  [6] Update Ticket References - Add or update related ticket IDs
  [7] Add Jira ID - Link to external Jira ticket when approved
  [0] Cancel

Select [0-7]:
```

---

## Handle Each Revision Type

Based on user selection, collect appropriate information. Store in variables for Phase 2.

### Option 1: Add Evidence

```
Evidence Type Selection:
  [1] Screenshot (PNG, JPG, GIF)
  [2] Log (TXT, LOG)
  [3] Video (MP4, MOV, WebM)
  [4] Artifact (HAR, JSON, SQL)
  [5] Done adding evidence

Select [1-5]:
```

For each evidence item, collect:
- File path (validate file exists)
- Optional description
- Store: REVISION_TYPE=evidence, EVIDENCE_DATA=[files array]

### Option 2: Update Status

```
Current Status: [CURRENT_STATUS]

Valid transitions:
  [1] In Progress (start investigation)
  [2] Approved (mark approved for fixing)
  [3] Resolved (fix applied and verified)
  [4] Closed (fix deployed to production)
  [0] Cancel

Select [0-4]:
```

Store: REVISION_TYPE=status, NEW_STATUS=[selection]

### Option 3: Update Severity

```
Current Severity: [CURRENT_SEVERITY]

Select new severity:
  [1] S1 - Critical (data loss, security, crash, no workaround)
  [2] S2 - Major (feature broken, wrong calculations, difficult workaround)
  [3] S3 - Minor (UI issues, incorrect messages, easy workaround)
  [4] S4 - Trivial (cosmetic, typos, minimal impact)
  [0] Cancel

Select [0-4]:

Reason for change (helps track decision rationale):
> [User input]
```

Store: REVISION_TYPE=severity, NEW_SEVERITY=[selection], REASON=[user input]

### Option 4: Add Investigation Notes

```
Investigation Notes
===================

Add notes about:
  [1] Root cause analysis
  [2] Fix strategy
  [3] Progress update
  [4] Other notes

Select [1-4]:

Enter your notes (press Ctrl+D or type END on new line to finish):
> [User input - multi-line]
```

Store: REVISION_TYPE=notes, NOTE_TYPE=[selection], NOTE_TEXT=[user input]

### Option 5: Update Description

```
Description Update
==================

What needs updating?
  [1] Reproduction steps
  [2] Environment details
  [3] Affected scope
  [4] All of above

Select [1-4]:
```

Prompt for new content based on selection.

Store: REVISION_TYPE=description, DESCRIPTION_SECTION=[selection], DESCRIPTION_TEXT=[user input]

### Option 6: Update Ticket References

```
Current Tickets: [CURRENT_TICKETS]

Ticket Reference Update
========================

Enter ticket ID(s):
  Format: Single (TICKET-123) or multiple (TICKET-123, TICKET-124)
  Leave blank to remove references

Tickets:
> [User input]
```

Store: REVISION_TYPE=ticket, NEW_TICKETS=[user input]

### Option 7: Add Jira ID

```
Jira Integration
================

Enter Jira issue ID (e.g., BUG-12345):
> [User input]

Optional: Add Jira link
  Format: https://jira.company.com/browse/BUG-12345

Jira Link (optional):
> [User input]
```

Store: REVISION_TYPE=jira_id, JIRA_ID=[user input], JIRA_LINK=[optional]

---

## Validation

Validate user input based on revision type:

- **Evidence**: File exists, readable, appropriate type
- **Status**: Valid transition from current status
- **Severity**: Valid S1-S4 level
- **Notes**: Non-empty text
- **Ticket**: Valid ticket format
- **Jira ID**: Valid format (optional validation)

---

## Set Variables for Phase 2

Export for revision application:

```
FEATURE_NAME=[from Phase 0]
BUG_ID=[from Phase 0]
BUG_PATH=[from Phase 0]
BUG_REPORT_PATH=[from Phase 0]
REVISION_TYPE=[selected type]
[Revision-specific data variables]
CURRENT_VERSION=[from Phase 0]
CURRENT_STATUS=[from Phase 0]
```

---

## Confirmation

Display summary before proceeding:

```
You selected: [REVISION_TYPE]
Details: [Specific change to be made]

Proceeding to apply revision...
```

---

*Guide user through selecting the type of update needed and collect required information for that update.*
