# Task Breakdown: /report-bug and /revise-bug Commands

## Overview
Total Tasks: 32 tasks across 5 task groups

## Summary

This task breakdown covers the implementation of two new QA Agent OS commands:
- `/report-bug` - Context-aware bug reporting with AI-assisted severity classification
- `/revise-bug` - Bug revision and lifecycle management with version tracking

Both commands require single-agent and multi-agent versions, following existing patterns from `/revise-test-plan` and `/plan-ticket`.

---

## Task List

### Standards Layer

#### Task Group 1: Standards and Template Updates
**Dependencies:** None

This group ensures all bug reporting standards are complete and creates the bug report output template.

- [x] 1.0 Complete standards layer
  - [x] 1.1 Review existing bug standards for completeness
    - Read `profiles/default/standards/bugs/bug-template.md`
    - Read `profiles/default/standards/bugs/severity-rules.md`
    - Read `profiles/default/standards/bugs/bug-reporting-standard.md`
    - Read `profiles/default/standards/bugs/bug-analysis.md`
    - Identify any gaps needed for command implementation
  - [x] 1.2 Create bug report output template
    - Create `profiles/default/templates/bug-report-template.md`
    - Include metadata header section (creation timestamp, source ticket, feature name, bug ID)
    - Include all required fields from bug-template.md
    - Add AI suggestion tracking section (suggested severity, user decision, justification)
    - Add revision log section (matching test-plan.md pattern)
    - Add status workflow section (New > In Progress > Ready for QA > Verified/Closed > Re-opened)
  - [x] 1.3 Update severity-rules.md if needed
    - Ensure S1-S4 criteria are clear for AI classification
    - Add examples for each severity level
    - Add decision tree or checklist format for AI to reference
  - [x] 1.4 Verify standards integration
    - Ensure templates reference correct standards paths
    - Verify all field names are consistent across standards and templates

**Acceptance Criteria:**
- Bug report template exists with all required sections
- Severity rules are clear and AI-parseable
- All standards reference each other correctly
- Template includes revision log structure

---

### Single-Agent Commands

#### Task Group 2: /report-bug Single-Agent Command
**Dependencies:** Task Group 1

This group implements the complete `/report-bug` command for single-agent mode with 5 phases.

- [x] 2.0 Complete /report-bug single-agent command
  - [x] 2.1 Create command directory structure
    - Create `profiles/default/commands/report-bug/single-agent/`
    - Plan 5 phase files: detect-context, collect-details, collect-evidence, classify-severity, generate-report
  - [x] 2.2 Create Phase 0: 0-detect-context.md
    - Implement context detection (reuse pattern from `/plan-ticket` Phase 0)
    - Auto-detect current feature from `qa-agent-os/features/` directory
    - If multiple features exist, show numbered list for selection
    - If only one feature exists, auto-select with confirmation
    - Auto-detect current ticket within selected feature
    - Validate ticket folder exists
    - Create bugs/ subfolder if it doesn't exist: `qa-agent-os/features/[feature]/[ticket]/bugs/`
    - Auto-increment bug ID by scanning existing BUG-XXX.md files
    - Set variables: FEATURE_NAME, TICKET_ID, TICKET_PATH, BUG_ID, BUG_PATH
    - Handle direct mode: `/report-bug --title "Error" --severity S2`
    - Handle interactive mode: no parameters provided
  - [x] 2.3 Create Phase 1: 1-collect-details.md
    - Detect mode (interactive vs direct) from parameters
    - **Interactive Mode:** Present guided questionnaire
      - Prompt for bug title
      - Prompt for environment (OS, Browser, Dev/Staging/Prod)
      - Prompt for build/version
      - Prompt for steps to reproduce (required, multiline)
      - Prompt for expected result
      - Prompt for actual result
      - Prompt for reproducibility (Always, Intermittent with rate)
    - **Direct Mode:** Parse parameters
      - Validate required fields: title, steps-to-reproduce
      - Extract optional fields from parameters
    - Store collected details in BUG_DETAILS variable
  - [x] 2.4 Create Phase 2: 2-collect-evidence.md
    - Present evidence collection checklist:
      ```
      Evidence types to attach:
        [1] Screenshots/recordings (file path)
        [2] Console/browser logs (file path or paste)
        [3] API request/response (file path or paste)
        [4] Network traces (file path)
        [5] Error messages (paste text)
        [6] Other evidence

      Select types to add (comma-separated, e.g., 1,2,5):
      ```
    - For each selected type, prompt for content
    - Validate file paths exist (warn if not found)
    - Store evidence in EVIDENCE_DETAILS variable
    - Parse and summarize evidence (filter log noise, extract key errors)
  - [x] 2.5 Create Phase 3: 3-classify-severity.md
    - Read severity-rules.md standard
    - Analyze bug description, evidence, and impact
    - Apply severity classification criteria (S1-S4)
    - Generate AI severity suggestion with justification
    - Present to user with accept/override options
    - Store both AI suggestion and user decision
  - [x] 2.6 Create Phase 4: 4-generate-report.md
    - Read bug-report-template.md
    - Compile all collected information
    - Generate root cause hypothesis
    - Set initial status to "New"
    - Write bug report to correct path
    - Display completion summary with next steps
  - [x] 2.7 Create orchestrator: report-bug.md
    - Add command purpose and usage documentation
    - Add usage examples for both interactive and direct modes
    - Include phase tags referencing all 5 phases
    - Add related commands section

**Acceptance Criteria:**
- All 5 phase files created and properly structured
- Orchestrator file references all phases correctly
- Interactive mode guides user through complete workflow
- Direct mode accepts and validates parameters
- AI severity suggestion is generated with justification
- Bug reports are saved to correct location with auto-incremented IDs

---

#### Task Group 3: /revise-bug Single-Agent Command
**Dependencies:** Task Group 1, Task Group 2

This group implements the complete `/revise-bug` command for single-agent mode with 3 phases.

- [x] 3.0 Complete /revise-bug single-agent command
  - [x] 3.1 Create command directory structure
    - Create `profiles/default/commands/revise-bug/single-agent/`
    - Plan 3 phase files: detect-bug, prompt-update-type, apply-update
  - [x] 3.2 Create Phase 1: 1-detect-bug.md
    - Reuse pattern from `/revise-test-plan` Phase 1
    - **If bug ID provided as parameter:**
      - Set BUG_ID from parameter
      - Locate bug file in features/[feature]/[ticket]/bugs/
    - **If NO parameter provided (interactive):**
      - Scan all `qa-agent-os/features/*/*/bugs/BUG-*.md` files
      - Present selection list sorted by most recently modified:
        ```
        Which bug to revise?

        Recent bugs:
          [1] BUG-003 - [Checkout] Submit fails with 500 (WYX-123) - Updated 2h ago
          [2] BUG-002 - [Login] Session timeout incorrect (WYX-122) - Updated 1d ago
          [3] BUG-001 - [Cart] Item count mismatch (WYX-121) - Updated 3d ago

        Select [1-N]:
        ```
    - Validate bug file exists
    - Read current bug metadata (version, status, last updated)
    - Set variables: BUG_ID, BUG_PATH, FEATURE_NAME, TICKET_ID, CURRENT_VERSION, CURRENT_STATUS
  - [x] 3.3 Create Phase 2: 2-prompt-update-type.md
    - Present update type options (6 types per spec):
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
    - For each update type, collect specific details:
      - **[1] Add evidence:** Reuse evidence collection checklist from report-bug
      - **[2] Update severity/priority:** Present current values, prompt for new values with justification
      - **[3] Update status:** Present status workflow, prompt for new status
        ```
        Current status: In Progress

        Status options:
          [1] New (reset)
          [2] In Progress
          [3] Ready for QA
          [4] Verified
          [5] Closed
          [6] Re-opened

        Select new status [1-6]:
        ```
      - **[4] Add reproduction info:** Prompt for additional steps, environment details
      - **[5] Add developer notes:** Prompt for root cause explanation, fix approach
      - **[6] Update affected scope:** Prompt for additional affected users/features
    - Store UPDATE_TYPE and UPDATE_DETAILS variables
  - [x] 3.4 Create Phase 3: 3-apply-update.md
    - Read current bug report
    - Determine next version number (X.Y format, increment minor for updates)
    - Apply update to appropriate section based on UPDATE_TYPE:
      - add_evidence: Update Evidence section
      - update_severity: Update Severity & Priority fields
      - update_status: Update Status field
      - add_reproduction: Update Steps to Reproduce section
      - add_developer_notes: Update Root Cause Hypothesis section
      - update_scope: Update Affected Areas section
    - Add revision log entry with format:
      ```
      **Version X.Y - [date] [time]**
      - Change: [update description]
      - Type: [update type]
      - Previous value: [if applicable]
      - New value: [updated value]
      - Reason: [why this update was made]
      ```
    - Save updated bug report
    - Display completion summary:
      ```
      Bug revised successfully!

      Updated: qa-agent-os/features/[feature]/[ticket]/bugs/BUG-001.md

      Version: 1.0 -> 1.1
      Change: [update type description]

      NEXT STEPS:
      - Review updated bug report
      - Use /revise-bug BUG-001 for additional updates
      ```
  - [x] 3.5 Create orchestrator: revise-bug.md
    - Add command purpose and usage documentation
    - Add usage examples:
      ```
      /revise-bug              # Interactive - select bug
      /revise-bug BUG-001      # Direct - revise specific bug
      ```
    - Include phase tags:
      ```
      {{PHASE 1: @qa-agent-os/commands/revise-bug/1-detect-bug.md}}
      {{PHASE 2: @qa-agent-os/commands/revise-bug/2-prompt-update-type.md}}
      {{PHASE 3: @qa-agent-os/commands/revise-bug/3-apply-update.md}}
      ```
    - Add revision types reference section
    - Add related commands section

**Acceptance Criteria:**
- All 3 phase files created and properly structured
- Orchestrator file references all phases correctly
- Interactive mode discovers and lists existing bugs
- Direct mode accepts bug ID as parameter
- All 6 update types implemented with appropriate prompts
- Revision log entries follow consistent format
- Version tracking increments correctly

---

### Multi-Agent Commands

#### Task Group 4: Multi-Agent Versions
**Dependencies:** Task Group 2, Task Group 3

This group creates multi-agent versions of both commands, delegating to bug-writer agent.

- [x] 4.0 Complete multi-agent command versions
  - [x] 4.1 Update bug-writer agent for command integration
    - Read current `profiles/default/agents/bug-writer.md`
    - Update agent to accept structured input from command phases:
      - Bug details (title, environment, steps, expected, actual)
      - Evidence collection (organized by type)
      - AI severity suggestion with justification
      - User severity decision
    - Add support for revision operations:
      - Read existing bug report
      - Apply specific update type
      - Maintain revision log
    - Update outputs section to specify exact file structure
    - Ensure agent references all bug standards:
      - `standards/bugs/bug-template.md`
      - `standards/bugs/severity-rules.md`
      - `standards/bugs/bug-reporting-standard.md`
      - `standards/bugs/bug-analysis.md`
  - [x] 4.2 Create /report-bug multi-agent version
    - Create `profiles/default/commands/report-bug/multi-agent/report-bug.md`
    - Implement PHASE 0 (context detection) - same logic as single-agent, remains in orchestrator
    - Implement PHASE 1-2 (collect details and evidence) - orchestration logic, prompts remain in main command
    - Implement PHASE 3 (severity classification) - delegate to bug-writer agent for analysis
    - Implement PHASE 4 (generate report) - delegate to bug-writer agent for final output
    - Pass to bug-writer agent:
      - Ticket path, bug path, bug ID
      - Collected bug details
      - Evidence details (organized)
      - Severity decision and justification
    - Bug-writer agent outputs: `[ticket-path]/bugs/BUG-XXX.md`
  - [x] 4.3 Create /revise-bug multi-agent version
    - Create `profiles/default/commands/revise-bug/multi-agent/revise-bug.md`
    - Implement PHASE 1 (detect bug) - same logic as single-agent, remains in orchestrator
    - Implement PHASE 2 (prompt update type) - orchestration logic, prompts remain in main command
    - Implement PHASE 3 (apply update) - delegate to bug-writer agent
    - Pass to bug-writer agent:
      - Bug path
      - Update type
      - Update details
      - Current timestamp
    - Bug-writer agent performs:
      - Read current bug report
      - Apply update
      - Add revision log entry
      - Save updated file
  - [x] 4.4 Verify agent delegation patterns
    - Compare to existing multi-agent commands (plan-ticket, revise-test-plan)
    - Ensure consistent handoff format to subagents
    - Verify subagent execution workflows are referenced correctly

**Acceptance Criteria:**
- Bug-writer agent updated with clear input/output specifications
- Multi-agent report-bug command delegates to bug-writer for report generation
- Multi-agent revise-bug command delegates to bug-writer for updates
- Both versions produce identical output format as single-agent versions
- Agent delegation follows existing patterns

---

### Verification Layer

#### Task Group 5: Integration and Testing
**Dependencies:** Task Groups 1-4

This group verifies the complete implementation through installation testing and manual validation.

- [x] 5.0 Complete integration and verification
  - [x] 5.1 Verify installation compilation
    - Run `scripts/project-install.sh` on a test project
    - Verify commands are compiled to `.claude/commands/qa-agent-os/`:
      - `report-bug.md` (single-agent or multi-agent based on config)
      - `revise-bug.md` (single-agent or multi-agent based on config)
    - Verify phase tags are resolved correctly
    - Verify standards references are included
    - Verify templates are copied to `qa-agent-os/templates/`
  - [x] 5.2 Manual testing: /report-bug interactive mode
    - Create test feature and ticket structure
    - Run `/report-bug` without parameters
    - Verify feature detection and selection works
    - Verify ticket detection works
    - Walk through interactive questionnaire
    - Verify evidence collection checklist
    - Verify AI severity suggestion is generated
    - Verify bug report is created at correct path
    - Verify bug ID auto-increment (create second bug, verify BUG-002)
  - [x] 5.3 Manual testing: /report-bug direct mode
    - Run `/report-bug --title "Test Error" --severity S3`
    - Verify required field validation
    - Verify bug report is created with provided parameters
  - [x] 5.4 Manual testing: /revise-bug interactive mode
    - Run `/revise-bug` without parameters
    - Verify bug discovery and selection list
    - Test each update type (1-6):
      - Add evidence
      - Update severity/priority
      - Update status
      - Add reproduction info
      - Add developer notes
      - Update affected scope
    - Verify revision log entries are added correctly
    - Verify version increment works
  - [x] 5.5 Manual testing: /revise-bug direct mode
    - Run `/revise-bug BUG-001`
    - Verify direct bug selection works
    - Verify update workflow proceeds correctly
  - [x] 5.6 Verify multi-agent mode (if applicable)
    - Update config.yml to enable multi-agent
    - Re-run installation
    - Verify multi-agent versions are compiled
    - Test bug-writer agent delegation
  - [x] 5.7 Documentation verification
    - Verify command orchestrator files include clear usage examples
    - Verify related commands sections are accurate
    - Verify all phase files have clear instructions

**Acceptance Criteria:**
- Both commands compile and install correctly
- Interactive and direct modes work for both commands
- Bug reports are created at correct paths with proper structure
- Revisions are tracked with version increments and log entries
- All 6 revise-bug update types function correctly
- Multi-agent versions delegate correctly to bug-writer agent

---

## Execution Order

Recommended implementation sequence:

1. **Task Group 1: Standards and Template Updates** (Foundation) - COMPLETED
   - Creates the bug report template that all commands will use
   - Ensures standards are complete and AI-parseable

2. **Task Group 2: /report-bug Single-Agent Command** (Core functionality) - COMPLETED
   - Implements the primary bug reporting workflow
   - Establishes patterns for context detection and evidence collection

3. **Task Group 3: /revise-bug Single-Agent Command** (Core functionality) - COMPLETED
   - Implements bug lifecycle management
   - Reuses patterns from report-bug and revise-test-plan

4. **Task Group 4: Multi-Agent Versions** (Enhancement) - COMPLETED
   - Adapts single-agent commands for multi-agent mode
   - Updates bug-writer agent for command integration

5. **Task Group 5: Integration and Testing** (Verification) - COMPLETED
   - Validates complete implementation
   - Tests all modes and update types
   - Documentation verified

---

## File Deliverables

### New Files to Create

```
profiles/default/
  templates/
    bug-report-template.md                    # Task 1.2 - COMPLETED

  commands/
    report-bug/
      single-agent/
        0-detect-context.md                   # Task 2.2 - COMPLETED
        1-collect-details.md                  # Task 2.3 - COMPLETED
        2-collect-evidence.md                 # Task 2.4 - COMPLETED
        3-classify-severity.md                # Task 2.5 - COMPLETED
        4-generate-report.md                  # Task 2.6 - COMPLETED
        report-bug.md                         # Task 2.7 - COMPLETED
      multi-agent/
        report-bug.md                         # Task 4.2 - COMPLETED

    revise-bug/
      single-agent/
        1-detect-bug.md                       # Task 3.2 - COMPLETED
        2-prompt-update-type.md               # Task 3.3 - COMPLETED
        3-apply-update.md                     # Task 3.4 - COMPLETED
        revise-bug.md                         # Task 3.5 - COMPLETED
      multi-agent/
        revise-bug.md                         # Task 4.3 - COMPLETED
```

### Files to Update

```
profiles/default/
  agents/
    bug-writer.md                             # Task 4.1 - COMPLETED

  standards/bugs/
    severity-rules.md                         # Task 1.3 - COMPLETED
    bug-template.md                           # Task 1.4 - COMPLETED (updated for consistency)
```

---

## Patterns to Follow

### Context Detection Pattern
Reference: `profiles/default/commands/plan-ticket/single-agent/0-detect-context.md`

### Revision Workflow Pattern
Reference: `profiles/default/commands/revise-test-plan/single-agent/`

### Multi-Agent Command Pattern
Reference: `profiles/default/commands/plan-ticket/multi-agent/plan-ticket.md`

### Phase Tag Format
```markdown
{{PHASE N: @qa-agent-os/commands/[command-name]/N-phase-name.md}}
```

### Revision Log Entry Format
```markdown
**Version X.Y - [date] [time]**
- Change: [description]
- Type: [update type]
- Reason: [why]
```

---

*Task breakdown created: 2025-11-24*
*Task Group 1 completed: 2025-11-24*
*Task Group 2 completed: 2025-11-24*
*Task Group 3 completed: 2025-11-24*
*Task Group 4 completed: 2025-11-24*
*Task Group 5 completed: 2025-11-24*
