# Phase 4: Generate Report

## Bug Report Generation

This phase compiles all collected information and generates the final bug report file.

### Variables from Previous Phases

Required from previous phases:
- `FEATURE_NAME` - The feature name
- `TICKET_ID` - The ticket identifier
- `TICKET_PATH` - Path to ticket folder
- `BUG_ID` - Assigned bug ID (e.g., BUG-001)
- `BUG_PATH` - Full path to bug file
- `BUG_DETAILS` - Details collected in Phase 1
- `EVIDENCE_DETAILS` - Evidence collected in Phase 2
- `SEVERITY` - Severity classification from Phase 3
- `PRIORITY` - Priority from Phase 3

### Reference Template

Read bug report template:
```
@qa-agent-os/templates/bug-report-template.md
```

---

## Compile Bug Report

Generate the bug report by filling in the template with collected data:

### Metadata Section

```markdown
## Metadata

| Field | Value |
|-------|-------|
| **Bug ID** | [BUG_ID] |
| **Feature** | [FEATURE_NAME] |
| **Ticket** | [TICKET_ID] |
| **Created** | [Current timestamp: YYYY-MM-DD HH:MM] |
| **Version** | 1.0 |
| **Status** | New |
```

### Bug Details Section

```markdown
## Bug Details

### Title

[BUG_DETAILS.title]

### Environment

| Property | Value |
|----------|-------|
| **Operating System** | [BUG_DETAILS.environment.os] |
| **Browser / Device** | [BUG_DETAILS.environment.browser] |
| **Environment** | [BUG_DETAILS.environment.env_type] |
| **Build / Version** | [BUG_DETAILS.environment.build] |
| **Feature Flags / Config** | [BUG_DETAILS.environment.feature_flags] |

### Component / Area

[BUG_DETAILS.component]
```

### Reproduction Section

```markdown
## Reproduction

### Preconditions

[BUG_DETAILS.preconditions]

### Steps to Reproduce

[For each step in BUG_DETAILS.steps:]
1. [Step 1]
2. [Step 2]
3. [Step 3]
...

### Expected Result

[BUG_DETAILS.expected_result]

### Actual Result

[BUG_DETAILS.actual_result]

### Reproducibility

| Property | Value |
|----------|-------|
| **Rate** | [BUG_DETAILS.reproducibility.rate] |
| **Attempts** | [BUG_DETAILS.reproducibility.attempts] |
| **Notes** | [BUG_DETAILS.reproducibility.notes] |
```

### Classification Section

```markdown
## Classification

### Severity & Priority

| Property | Value |
|----------|-------|
| **Severity** | [SEVERITY.level] - [SEVERITY.name] |
| **Priority** | [PRIORITY] |
| **Justification** | [SEVERITY.ai_suggestion.justification] |

### AI Severity Suggestion

| Property | Value |
|----------|-------|
| **Suggested Severity** | [SEVERITY.ai_suggestion.level] |
| **AI Justification** | [SEVERITY.ai_suggestion.justification] |
| **User Decision** | [SEVERITY.user_decision] |
| **Override Reason** | [SEVERITY.override_reason or "N/A"] |
```

### Evidence Section

```markdown
## Evidence

### Screenshots / Recordings

[If EVIDENCE_DETAILS.screenshots exists:]
[For each screenshot:]
- [Description]: `[path]`

[If no screenshots:]
No screenshots attached.

### Console / Browser Logs

[If EVIDENCE_DETAILS.console_logs exists:]
```
[EVIDENCE_DETAILS.console_logs.analyzed.summary]

Key errors:
[For each error in analyzed.errors:]
- [error]
```

[If no logs:]
No console logs attached.

### API Request / Response

[If EVIDENCE_DETAILS.api_data exists:]
```json
{
  "request": {
    "method": "[method]",
    "url": "[url]",
    "body": [body]
  },
  "response": {
    "status": "[status]",
    "body": [body]
  }
}
```

[If no API data:]
No API data captured.

### Network Traces

[If EVIDENCE_DETAILS.network_traces exists:]
- File: [file_path]
- Request IDs: [request_ids]
- Correlation IDs: [correlation_ids]
- Notes: [notes]

[If no traces:]
No network traces attached.

### Error Messages

[If EVIDENCE_DETAILS.error_messages exists:]
```
[For each message:]
[message]
```

[If no error messages:]
No error messages captured.

### Additional Evidence

[If EVIDENCE_DETAILS.other exists:]
[description]
- File: [file_path]
- Content: [content]

[If no other evidence:]
No additional evidence.
```

### Analysis Section

```markdown
## Analysis

### Root Cause Hypothesis

[EVIDENCE_DETAILS.analysis.root_cause_hypothesis]

[If no hypothesis generated:]
Root cause hypothesis pending investigation.

### Affected Areas

[Based on BUG_DETAILS.component and FEATURE_NAME:]
- Primary: [component]
- Feature: [FEATURE_NAME]
- Potential impact: [AI assessment based on severity]

### Related Items

| Type | ID | Description |
|------|----|----|
| Ticket | [TICKET_ID] | Source ticket |
| Feature | [FEATURE_NAME] | Parent feature |
| Test Case | [TC-ID if identified] | Discovered during test |
```

### Status Workflow Section

```markdown
## Status Workflow

**Current Status:** New

**Status History:**

| Status | Date | Updated By | Notes |
|--------|------|------------|-------|
| New | [Creation timestamp] | [Reporter] | Initial report |

**Status Options:** New > In Progress > Ready for QA > Verified > Closed | Re-opened
```

### Ownership Section

```markdown
## Ownership

| Role | Assignee |
|------|----------|
| **Reporter** | [Current user or "QA Tester"] |
| **Assignee** | Unassigned |
| **QA Verifier** | Unassigned |
```

### Developer Notes Section

```markdown
## Developer Notes

*Reserved for developer root cause analysis, fix approach, or implementation notes.*
```

### Revision Log Section

```markdown
## Revision Log

### Change History

**Version 1.0 - [Creation timestamp]**
- Initial bug report created
- Severity: [SEVERITY.level] - [SEVERITY.name]
- Status: New
```

### References Section

```markdown
## References

### Standards Applied

- Severity Rules: `@qa-agent-os/standards/bugs/severity-rules.md`
- Bug Template: `@qa-agent-os/standards/bugs/bug-template.md`
- Bug Reporting Standard: `@qa-agent-os/standards/bugs/bug-reporting-standard.md`

### Source Context

- Feature Knowledge: `../../feature-knowledge.md`
- Test Plan: `../test-plan.md`
- Test Cases: `../test-cases.md`

---

*Bug report generated using QA Agent OS. Use `/revise-bug [BUG_ID]` to update this report.*
```

---

## Write Bug Report File

Save the compiled report to the designated path:

```
Writing bug report to:
  [BUG_PATH]

Ensuring bugs folder exists:
  [TICKET_PATH]/bugs/
```

Create the file with all sections populated.

---

## Completion Summary

Display completion message:

```
============================================
Bug reported successfully!
============================================

Created: [BUG_PATH]

Summary:
  Bug ID:     [BUG_ID]
  Title:      [BUG_DETAILS.title]
  Severity:   [SEVERITY.level] - [SEVERITY.name]
  Priority:   [PRIORITY]
  Status:     New
  Feature:    [FEATURE_NAME]
  Ticket:     [TICKET_ID]

Evidence attached:
  - Screenshots: [count or "None"]
  - Logs: [analyzed or "None"]
  - API data: [captured or "None"]
  - Error messages: [count or "None"]

Root cause hypothesis:
  [Brief hypothesis or "Pending investigation"]

============================================
NEXT STEPS
============================================

1. Review the bug report for accuracy:
   Open: [BUG_PATH]

2. Add more evidence or update details:
   /revise-bug [BUG_ID]

3. Report another bug in this ticket:
   /report-bug

4. View all bugs for this ticket:
   Check: [TICKET_PATH]/bugs/

============================================
```

---

## Command Complete

The `/report-bug` command is now complete. The bug report has been created at:

```
[TICKET_PATH]/bugs/[BUG_ID].md
```

User can now:
- Review and edit the bug report
- Run `/revise-bug [BUG_ID]` to update the report
- Run `/report-bug` again to report another bug
- Continue testing and use bug ID for reference
