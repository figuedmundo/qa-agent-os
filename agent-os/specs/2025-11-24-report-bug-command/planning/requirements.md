# Spec Requirements: /report-bug Command

## Initial Description
Create a `/report-bug` command for QA Agent OS that allows testers to report bugs discovered during testing, leveraging the existing bug-writer agent and bug reporting standards.

## Requirements Discussion

### First Round Questions

**Q1:** Context Detection - Should `/report-bug` be context-aware and detect the current ticket/feature context?
**Answer:** CONFIRMED - `/report-bug` should be context-aware and detect the current ticket/feature context (similar to how `/plan-ticket` detects existing features).

**Q2:** Interaction Mode - Interactive questionnaire vs direct parameter input?
**Answer:** CONFIRMED - Implement both modes:
- Interactive mode: guided step-by-step prompts
- Direct mode: accept bug details as parameters

**Q3:** Bug Storage Location - Where should bug reports be stored?
**Answer:** CONFIRMED - Bugs stored within ticket context: `qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-001.md`

**Q4:** Severity Classification - How should severity be determined?
**Answer:** CONFIRMED - AI suggests severity based on rules, user confirms or overrides

**Q5:** Evidence Gathering - Should evidence collection be automated, guided, or assumed pre-gathered?
**Answer:** CONFIRMED - Guided checklist approach:
- Prompts for evidence types (screenshots, logs, API traces, errors)
- AI organizes and formats into bug report

**Q6:** Multi-Agent Mode - Use just bug-writer agent or also involve evidence-summarizer?
**Answer:** CONFIRMED - Single agent (bug-writer) with inline evidence analysis

**Q7:** Bug Updates - Should there be a `/revise-bug` command?
**Answer:** CONFIRMED - New `/revise-bug` command mirroring `/revise-test-plan` pattern with:
- Add evidence
- Update severity/priority
- Update status (including verification/closure)
- Add reproduction info
- Add developer notes
- Update affected scope
- Versioned revision entries with timestamps

**Q8:** Out of Scope items
**Answer:** CONFIRMED:
- Jira integration: OUT (separate command)
- Automated screenshot capture: OUT for now
- Automated workflows (notifications, auto-assignment): OUT

### Existing Code to Reference

**Similar Features Identified:**
- Command: `/revise-test-plan` - Path: `profiles/default/commands/revise-test-plan/`
  - Pattern for revision/update workflows
  - Version tracking and revision logs
  - Interactive update type selection

- Agent: `bug-writer` - Path: `profiles/default/agents/bug-writer.md`
  - Existing bug writing capabilities
  - Standards references

- Agent: `evidence-summarizer` - Path: `profiles/default/agents/evidence-summarizer.md`
  - Log analysis and root cause hypothesis
  - Evidence processing patterns (for inline integration)

- Standards: Bug Standards - Path: `profiles/default/standards/bugs/`
  - `bug-template.md` - Required fields and format
  - `bug-analysis.md` - Analysis and severity assessment
  - `bug-reporting.md` - Reporting guidelines

## Visual Assets

### Files Provided:
No visual assets provided.

## Requirements Summary

### Functional Requirements

**`/report-bug` Command:**
- Context-aware bug reporting (auto-detects current ticket/feature context)
- Dual mode operation:
  - Interactive mode: guided step-by-step questionnaire
  - Direct mode: accept bug details as parameters
- AI-suggested severity classification with user confirmation/override
- Guided evidence collection via checklist:
  - Screenshots/recordings
  - Console/browser logs
  - API request/response
  - Network traces
  - Error messages
  - Reproduction steps
- AI organizes and formats evidence into structured bug report
- Bug storage path: `qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-XXX.md`
- Auto-incrementing bug IDs (BUG-001, BUG-002, etc.)

**`/revise-bug` Command:**
- Mirror `/revise-test-plan` pattern
- Support both interactive and direct modes:
  - `/revise-bug` - Interactive selection
  - `/revise-bug BUG-001` - Direct revision
- Update types:
  1. Add evidence - New logs, screenshots, reproduction data
  2. Update severity/priority - Based on new information
  3. Update status - New -> In Progress -> Ready for QA -> Verified/Closed -> Re-opened
  4. Add reproduction info - More specific steps, environment details
  5. Add developer notes - Root cause, fix approach
  6. Update affected scope - Additional users/features affected
- Versioned revision entries with timestamps for full traceability
- Bug verification workflow included via "Update status" option

### Reusability Opportunities
- `/revise-test-plan` command pattern for `/revise-bug` implementation
- `bug-writer.md` agent capabilities as primary agent
- `evidence-summarizer.md` logic integrated inline for evidence analysis
- `bug-template.md` for output format
- `bug-analysis.md` for severity assessment rules
- `bug-reporting.md` for reporting guidelines

### Scope Boundaries

**In Scope:**
- `/report-bug` command (single-agent and multi-agent versions)
- `/revise-bug` command (single-agent and multi-agent versions)
- Context detection (ticket/feature awareness)
- Interactive and direct execution modes
- Guided evidence collection with checklist
- AI severity suggestion with user confirmation
- Bug file creation and storage
- Bug revision with version tracking
- Bug verification/closure as part of revise-bug
- Enhanced bug-writer agent
- Any needed standards updates

**Out of Scope:**
- Jira integration (separate `/jira-integration` command)
- Automated screenshot capture
- Cross-system workflows (notifications, auto-assignment, escalation)
- Bug analytics/dashboards
- Auto-sync with external bug tracking systems

### Technical Considerations
- Single-agent mode (bug-writer) as primary with inline evidence analysis
- Multi-agent versions for users with multi-agent config
- Follow existing command patterns (phases, orchestration)
- Leverage existing standards in `profiles/default/standards/bugs/`
- Version tracking and revision logs for bug updates
- Consistent with QA Agent OS command structure and compilation

### Deliverables
1. `/report-bug` command - single-agent version
2. `/report-bug` command - multi-agent version
3. `/revise-bug` command - single-agent version
4. `/revise-bug` command - multi-agent version
5. Enhanced `bug-writer.md` agent (if updates needed)
6. Standards updates (if needed)

---

**Status: REQUIREMENTS CONFIRMED AND FINALIZED**

*Requirements gathered: 2025-11-24*
