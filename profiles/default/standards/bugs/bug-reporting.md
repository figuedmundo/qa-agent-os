# Bug Reporting Quick Reference

Use this abbreviated checklist when raising a defect, then verify it meets the full requirements in `bugs/bug-reporting-standard.md`.

## 1. Capture Context
- Title in `[Component] <Issue>` format
- Tracker ID, build/version, environment, feature flags
- Severity + priority rationale

## 2. Document Reproduction
1. Preconditions
2. Numbered steps (include data used)
3. Expected vs. actual results
4. Reproducibility rate (Always / Intermittent with % or counts)

## 3. Attach Evidence
- Logs and console output wrapped in code blocks
- Screenshot/video with annotations
- Observability IDs (request ID, trace ID, metric snapshot)
- Link to `/artifacts/YYYY-MM-DD/bug-<id>` folder

## 4. Triage Handoff
- Add root-cause hypothesis or suspected area
- Tag owners, components, and related requirements/tests
- Update status as soon as triage decisions are made
