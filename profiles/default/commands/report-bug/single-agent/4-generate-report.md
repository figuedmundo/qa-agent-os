# Phase 4: Generate Bug Report

## Execute Bug Reporting Workflow

{{workflows/bug-tracking/bug-reporting}}

The workflow will:
1. Read the bug reporting standard (`@qa-agent-os/standards/bugs/bug-reporting.md`)
2. Collect all required information following standard structure
3. Classify severity using standard rules and AI checklist
4. Perform bug analysis using standard methodology
5. Generate bug report following standard document structure
6. Store evidence in bugs/evidence/ folder

**Standard Reference:** `@qa-agent-os/standards/bugs/bug-reporting.md`

All document structure, field definitions, severity rules, and analysis methodology are in the standard. This workflow implements the standard without duplication.

---

**Post-Workflow Actions:**

After workflow completes, provide completion message to user (do NOT write to file):

```
Bug report created successfully!

Bug ID: BUG-XXX
Severity: [S1/S2/S3/S4]
Location: [ticket-path]/bugs/BUG-XXX.md

NEXT STEPS:
- Review bug report for completeness
- Update status as bug progresses: New → In Progress → Ready for QA → Verified → Closed
- Use /revise-bug BUG-XXX to update this report
```
