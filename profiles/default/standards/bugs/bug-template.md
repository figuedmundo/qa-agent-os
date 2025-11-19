# QA Standard – Bug Report Template

Use this structure when drafting a bug before copying it into the tracker.

## Required Fields
- **ID**: Tracker ID + related Requirement/Test Case IDs
- **Title**: `[Component] - Summary of the issue`
- **Build / Version**: Commit hash or app version
- **Environment**: OS, Browser/Device, Env (Dev/Staging/Prod)
- **Feature Flags / Config**: Toggle values, experiments
- **Component / Area**: Module or service impacted
- **Severity & Priority**: Reference `severity-rules.md` and `priority-rules.md`
- **Status**: New / Triaged / In Progress / Blocked / Ready for QA / Closed
- **Preconditions**
- **Steps to Reproduce** (include data values)
- **Expected Result**
- **Actual Result**
- **Reproducibility**: Always, Intermittent (e.g., 2/5 attempts)
- **Evidence**: Follow `global/evidence-template.md`
- **Root Cause Hypothesis / Notes** (optional but encouraged)
- **Assignee / Owners**

## Steps Format
Numbered list where each step captures:
- **User/system action**
- **Observed reaction** (if intermediate)

## Evidence Rules
- Attach annotated screenshots or recordings for UI issues.
- Include log/trace IDs, API payloads, and timestamps for backend/API issues.
- Redact sensitive data before sharing.