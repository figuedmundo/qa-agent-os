# Specification: Report Bug and Revise Bug Commands

## Goal
Create context-aware `/report-bug` and `/revise-bug` commands that allow QA testers to report and manage bugs discovered during testing, with AI-assisted severity classification, guided evidence collection, and full revision tracking.

## User Stories
- As a QA tester, I want to report bugs with guided evidence collection so that my bug reports are complete, actionable, and follow organizational standards
- As a QA tester, I want to update existing bug reports with new evidence, status changes, or verification results so that bug lifecycle is tracked with full traceability

## Specific Requirements

**Context-Aware Bug Reporting**
- Auto-detect current ticket/feature context from `qa-agent-os/features/` directory structure
- If multiple features exist, show numbered list for selection (same pattern as `/plan-ticket`)
- If only one feature exists, auto-select with confirmation
- Auto-detect current ticket within selected feature
- Store bugs at: `qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-XXX.md`
- Auto-increment bug IDs (BUG-001, BUG-002, etc.) by scanning existing bugs in ticket folder

**Dual Mode Operation**
- Interactive mode: guided step-by-step questionnaire prompting for each bug field
- Direct mode: accept bug details as command parameters (e.g., `/report-bug --title "Error" --severity S2`)
- Default to interactive mode when no parameters provided
- Direct mode validates required fields before proceeding

**AI-Assisted Severity Classification**
- AI analyzes bug description, evidence, and impact to suggest severity per `severity-rules.md`
- Present suggestion with justification: "Suggested: S2 - Major (feature broken, workaround difficult)"
- User confirms with [y] or overrides with selection [1-4] for S1-S4
- Store both AI suggestion and final user decision in bug report metadata

**Guided Evidence Collection Checklist**
- Present checklist of evidence types to collect:
  - [1] Screenshots/recordings
  - [2] Console/browser logs
  - [3] API request/response
  - [4] Network traces
  - [5] Error messages
  - [6] Reproduction steps (always required)
- For each selected evidence type, prompt for file path or text input
- AI organizes and formats evidence into structured sections per `bug-template.md`

**Bug Report Structure**
- Follow `bug-template.md` required fields: ID, Title, Build/Version, Environment, Severity, Priority, Status, Preconditions, Steps to Reproduce, Expected Result, Actual Result, Reproducibility, Evidence, Root Cause Hypothesis
- Include metadata header with creation timestamp, source ticket, feature name
- AI infers root cause hypothesis from evidence when possible
- Initial status always "New"

**`/revise-bug` Command**
- Support both interactive (`/revise-bug`) and direct (`/revise-bug BUG-001`) modes
- Detect existing bugs in current ticket context and present selection list
- Update types mirroring `/revise-test-plan` pattern:
  - [1] Add evidence - New logs, screenshots, reproduction data
  - [2] Update severity/priority - Based on new information
  - [3] Update status - New > In Progress > Ready for QA > Verified/Closed > Re-opened
  - [4] Add reproduction info - More specific steps, environment details
  - [5] Add developer notes - Root cause, fix approach
  - [6] Update affected scope - Additional users/features affected
- Prompt for specific details based on update type selection

**Revision Tracking**
- Maintain revision log section in bug report (same pattern as test-plan.md)
- Each revision entry includes: version increment, timestamp, change type, description, reason
- Format: `**Version X.Y - [date] [time]** - [change description] - Reason: [why]`
- Preserve full history for traceability and audit

**Single-Agent and Multi-Agent Versions**
- Single-agent version: Uses inline evidence analysis (evidence-summarizer logic embedded)
- Multi-agent version: Delegates to `bug-writer` agent for report generation
- Both versions follow same command structure and output format
- Config determines which version is compiled during installation

## Visual Design

No visual assets provided.

## Existing Code to Leverage

**`/revise-test-plan` command pattern**
- 3-phase structure: detect ticket, prompt update type, apply update
- Interactive selection with numbered options for update types
- Revision log entry format and version tracking
- Post-update prompt for regeneration (adapt to "view bug" or "edit more")

**`/plan-ticket` command Phase 0 (detect-context.md)**
- Smart feature detection and selection logic
- Existing ticket detection with re-execution options pattern
- Validation checks for folder and file existence
- Variable passing between phases

**`bug-writer.md` agent**
- Existing responsibilities: analyze evidence, infer root cause, write report
- Standards references pattern with conditional inclusion
- Enhance to accept structured input from command phases

**`evidence-summarizer.md` agent logic**
- Log analysis and root cause hypothesis patterns
- Evidence filtering (ignore noise, focus on ERROR/FATAL)
- Integrate inline for single-agent version

**Bug standards in `profiles/default/standards/bugs/`**
- `bug-template.md` - Required fields and format structure
- `severity-rules.md` - S1-S4 classification criteria
- `bug-reporting-standard.md` - Workflow and evidence rules
- `bug-analysis.md` - Analysis steps and output format

## Out of Scope
- Jira integration (separate `/jira-integration` command exists)
- Automated screenshot capture from system
- Cross-system workflows (notifications, auto-assignment, escalation)
- Bug analytics or dashboards
- Auto-sync with external bug tracking systems (Jira, Azure DevOps, etc.)
- Automated test failure to bug conversion
- Bug deduplication detection
- Bug report templates per project (use default standards only)
- Batch bug operations (report multiple bugs at once)
- Bug report export to PDF or other formats
