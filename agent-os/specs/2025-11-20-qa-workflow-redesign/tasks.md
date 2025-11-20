# Task Breakdown: QA Workflow Redesign

## Overview

**Total Estimated Tasks:** 85 tasks across 6 major task groups
**Implementation Type:** Shell script + Markdown command compilation
**Core Pattern:** Agent-OS orchestrator pattern with phase-based execution

## Task List

### Task Group 1: Infrastructure & Foundation

**Dependencies:** None
**Purpose:** Create foundational templates, folder structures, and utility functions needed by all commands

- [x] 1.0 Complete infrastructure and foundation layer
  - [ ] 1.1 Create folder structure templates
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/templates/folder-structures/` directory
    - Create `feature-structure.txt` template defining `features/[feature-name]/` hierarchy
    - Create `ticket-structure.txt` template defining `features/[feature-name]/[ticket-id]/` hierarchy
    - Include documentation/, visuals/, and all subdirectories
  - [ ] 1.2 Create feature-knowledge.md template
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/templates/feature-knowledge-template.md`
    - Include 8 sections: Feature Overview, Business Requirements, Technical Requirements, User Experience, Edge Cases & Constraints, Test Considerations, Open Questions, Document Sources
    - Add metadata placeholders: Last Updated, Status
    - Follow markdown formatting standards
    - Reference pattern from existing requirements documentation standards
  - [ ] 1.3 Create feature-test-strategy.md template
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/templates/feature-test-strategy-template.md`
    - Include 10 sections: Testing Objective, Test Approach, Test Environment & Tools, Test Data Strategy, Automation Strategy, Non-Functional Requirements, Risk Assessment, Entry & Exit Criteria, Deliverables, Roles & Responsibilities
    - Add version tracking: Version, Created, Status
    - Use table formats for coverage matrices, risk assessment
    - Align with industry standards from research findings
  - [ ] 1.4 Create test-plan.md template
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/templates/test-plan-template.md`
    - Include 11 sections: References, Ticket Overview, Test Scope, Testable Requirements, Test Coverage Matrix, Test Scenarios & Cases, Test Data Requirements, Environment Setup, Execution Timeline, Entry/Exit Criteria, Revisions
    - Add reference links to parent feature documentation
    - Include coverage matrix table format
    - Add revision log format with version tracking
  - [ ] 1.5 Create test-cases.md template
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/templates/test-cases-template.md`
    - Include test case structure: Test ID, Type, Priority, Requirement, Objective, Preconditions, Test Data, Test Steps (table format), Expected Final Result, Actual Result checkboxes, Notes, Defects
    - Add execution summary table: Not Started, Passed, Failed, Blocked
    - Add test data reference section
    - Add automation candidate identification section
  - [ ] 1.6 Create COLLECTION_LOG.md template
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/templates/collection-log-template.md`
    - Include metadata: Feature/Ticket, Date, Collected by
    - Add Documents Collected section with numbered list format
    - Include collection timestamp for each document
    - Add source attribution fields
  - [ ] 1.7 Enhance common-functions.sh utilities
    - Add `create_folder_from_template()` function to read folder structure template and create directories
    - Add `create_document_from_template()` function to populate template placeholders with actual values
    - Add `detect_existing_features()` function to scan `qa-agent-os/features/` directory
    - Add `detect_existing_tickets()` function to scan feature directories for ticket folders
    - Add `prompt_with_options()` function for numbered list selections
    - Add `confirm_action()` function for y/n confirmations
    - Ensure all functions use existing color output functions
    - Follow existing common-functions.sh patterns for YAML parsing and path handling
  - [ ] 1.8 Add path detection utilities
    - Add `detect_project_root()` function to find project root from any subdirectory
    - Add `resolve_features_path()` function to support both `qa-agent-os/features/` and `features/` formats
    - Add `validate_feature_exists()` function to check if feature directory exists
    - Add `validate_ticket_exists()` function to check if ticket directory exists
    - Use normalize_name() for all feature/ticket name standardization

**Acceptance Criteria:**
- All template files created with complete section structures
- Folder structure templates define full hierarchy
- Common-functions.sh enhanced with 10+ new utility functions
- Path detection supports multiple project structures
- All utilities follow existing color output and error handling patterns
- Templates align with standards in `agent-os/standards/` directory

---

### Task Group 2: Feature Planning Command (/plan-feature)

**Dependencies:** Task Group 1
**Purpose:** Implement orchestrated feature planning command with 4 phases

- [x] 2.0 Complete /plan-feature command implementation
  - [ ] 2.1 Create command directory structure
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/commands/plan-feature/single-agent/` directory
    - Follow established agent-os command structure pattern
  - [ ] 2.2 Create Phase 1: Initialize Feature Structure (1-init-structure.md)
    - Prompt for feature name if not provided as parameter
    - Use normalize_name() to standardize feature name
    - Check if feature already exists using validate_feature_exists()
    - If exists, prompt: "Feature [name] already exists. [1] Re-plan [2] Cancel"
    - Create feature folder structure using create_folder_from_template()
    - Create `features/[feature-name]/documentation/` directory
    - Print success message with created paths
    - Reference: Phase 1 specifications from command-specifications.md lines 30-43
  - [ ] 2.3 Create Phase 2: Gather Feature Documentation (2-gather-docs.md)
    - Print section header: "Let's gather documentation for [feature-name]"
    - Prompt 1: "Do you have a Business Requirements Document (BRD)?" - Options: [File path] [Paste content] [Skip]
    - Prompt 2: "Do you have API specifications or contracts?" - Options: [File path] [Paste content] [Skip]
    - Prompt 3: "Do you have backend calculation logic or business rules?" - Options: [File path] [Paste content] [Skip]
    - Prompt 4: "Do you have UI mockups or wireframes?" - Options: [Upload files to documentation/mockups/] [Skip]
    - Prompt 5: "Do you have any other technical documentation?" - Options: [File path] [Paste content] [Skip]
    - For file paths: copy file to `documentation/` with original filename
    - For pasted content: create markdown file with descriptive name
    - Create `documentation/COLLECTION_LOG.md` using template with metadata for each collected document
    - Warn if no documentation provided: "No documentation collected. Continue anyway? [y/n]"
    - Reference: Phase 2 specifications from command-specifications.md lines 46-92
  - [ ] 2.4 Create Phase 3: Consolidate Feature Knowledge (3-consolidate-knowledge.md)
    - Print status: "Analyzing all collected documentation..."
    - Read all files from `documentation/` directory
    - AI instruction: "Perform deep analysis to extract: core functionality, business rules and calculations, data flows, edge cases, integration points"
    - AI instruction: "Cross-reference between documents to identify gaps or ambiguities"
    - Create feature-knowledge.md using template
    - Populate all 8 sections based on analyzed documentation
    - Include document source references in Section 8
    - Add Last Updated timestamp and Active status
    - Print success message with file path
    - Reference: Phase 3 specifications from command-specifications.md lines 95-201
  - [ ] 2.5 Create Phase 4: Create Feature Test Strategy (4-create-strategy.md)
    - Print section header: "Now let's create the test strategy for [feature-name]"
    - Prompt 1: "What test levels are needed?" - Multi-select options: Unit Testing, API Testing, UI Testing, Integration Testing, End-to-End Testing
    - Prompt 2: "What test types should be covered?" - Multi-select: Functional, Performance, Security, Accessibility, Usability, Regression
    - Prompt 3: "What testing tools/frameworks will you use?" - Text input
    - Prompt 4: "What test environments are available?" - Text input
    - Prompt 5: "Are there specific performance requirements?" - Yes/No, if Yes prompt for metrics
    - Prompt 6: "Are there security/compliance requirements?" - Yes/No, if Yes prompt for requirements
    - Create feature-test-strategy.md using template
    - Populate all 10 sections based on prompts
    - Add Version 1.0, Created date, Active status
    - Print success message with summary of created documentation
    - Reference: Phase 4 specifications from command-specifications.md lines 204-381
  - [ ] 2.6 Create orchestrator file (plan-feature.md)
    - Create file at `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/commands/plan-feature/single-agent/plan-feature.md`
    - Add command description and purpose
    - Add usage instructions: `/plan-feature [feature-name]`
    - Include phase tags in sequence:
      - `@qa-agent-os/commands/plan-feature/1-init-structure.md`
      - `@qa-agent-os/commands/plan-feature/2-gather-docs.md`
      - `@qa-agent-os/commands/plan-feature/3-consolidate-knowledge.md`
      - `@qa-agent-os/commands/plan-feature/4-create-strategy.md`
    - Add success criteria summary at end
    - Follow agent-os orchestrator pattern from existing commands
  - [ ] 2.7 Test /plan-feature command workflow
    - Run command with test feature name: `test-feature-001`
    - Verify folder structure created correctly
    - Test documentation gathering with sample files
    - Verify feature-knowledge.md generated with all sections
    - Verify feature-test-strategy.md generated with all sections
    - Test re-plan scenario on existing feature
    - Test skip scenario with no documentation
    - Validate all prompts appear correctly
    - Verify success messages and file path outputs

**Acceptance Criteria:**
- 4 phase markdown files created with complete prompt sequences
- Orchestrator file created with proper phase tag references
- All prompts follow user-friendly formatting with clear options
- Documentation gathering supports file paths, pasted content, and skip options
- Feature knowledge consolidation creates comprehensive 8-section document
- Test strategy creation captures all strategic decisions in 10 sections
- Error handling for existing features and missing documentation
- Success messages guide user to created files
- Command tested end-to-end with sample feature

---

### Task Group 3: Ticket Planning Command (/plan-ticket)

**Dependencies:** Task Groups 1, 2
**Purpose:** Implement orchestrated ticket planning with smart detection, flexible execution, and gap detection

- [x] 3.0 Complete /plan-ticket command implementation
  - [ ] 3.1 Create command directory structure
    - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/commands/plan-ticket/single-agent/` directory
  - [ ] 3.2 Create Phase 0: Smart Detection & Routing (0-detect-context.md)
    - Check if ticket folder already exists using validate_ticket_exists()
    - If exists, show re-execution prompt:
      ```
      "Ticket [ticket-id] already exists in feature [feature-name]."
      Options:
        [1] Full re-plan (Phases 1-4: re-gather docs, re-analyze, regenerate)
        [2] Update test plan only (Skip to Phase 3: re-analyze requirements)
        [3] Regenerate test cases only (Skip to Phase 4: use existing test-plan.md)
        [4] Cancel
      Choose [1/2/3/4]:
      ```
    - Route execution based on selection:
      - Option 1: Run Phases 1-4 (full re-plan)
      - Option 2: Run Phase 3 only (update test-plan.md)
      - Option 3: Run Phase 4 only (regenerate test-cases.md)
      - Option 4: Exit command
    - If new ticket, continue to feature detection
    - Use detect_existing_features() to find available features
    - If multiple features exist, prompt:
      ```
      "Which feature does ticket [ticket-id] belong to?"
      Features found:
        [1] Feature-Name-1
        [2] Feature-Name-2
        [N] Create new feature
      Choose:
      ```
    - If only one feature exists, auto-select with confirmation: "Found feature: [name]. Is this correct? [y/n]"
    - If "Create new feature" selected, provide message: "Please run /plan-feature first, then return to /plan-ticket"
    - Store selected feature name for use in subsequent phases
    - Reference: Smart detection specifications from command-specifications.md lines 415-467
  - [ ] 3.3 Create Phase 1: Initialize Ticket Structure (1-init-ticket.md)
    - Use feature name from Phase 0 detection
    - Use normalize_name() for ticket ID standardization
    - Create ticket folder structure: `features/[feature-name]/[ticket-id]/`
    - Create `features/[feature-name]/[ticket-id]/documentation/` directory
    - Create `features/[feature-name]/[ticket-id]/documentation/visuals/` directory
    - Print success message with created paths
    - Reference: Phase 1 specifications from command-specifications.md lines 471-487
  - [ ] 3.4 Create Phase 2: Gather Ticket Documentation (2-gather-ticket-docs.md)
    - Print section header: "Let's gather documentation for ticket [ticket-id]"
    - Prompt 1: "Do you have the Jira ticket export or PDF?" - Options: [File path] [Paste ticket details] [Skip]
    - Prompt 2: "Do you have ticket-specific requirements or acceptance criteria?" - Options: [File path] [Paste content] [Skip]
    - Prompt 3: "Do you have technical specs for this ticket?" - Options: [File path] [Paste content] [Skip]
    - Prompt 4: "Do you have mockups or screenshots for this ticket?" - Options: [Upload to documentation/visuals/] [Skip]
    - Prompt 5: "Do you have API request/response examples?" - Options: [File path] [Paste content] [Skip]
    - Prompt 6: "Any other ticket-specific documentation?" - Options: [File path] [Paste content] [Skip]
    - For each document, store in `documentation/` with descriptive filename
    - Create `documentation/COLLECTION_LOG.md` with metadata for each collected document
    - Print summary of collected documents
    - Reference: Phase 2 specifications from command-specifications.md lines 490-523
  - [ ] 3.5 Create Phase 3: Analyze Requirements & Detect Gaps (3-analyze-requirements.md)
    - Print status: "Analyzing ticket requirements and checking feature knowledge..."
    - Read ticket documentation from `documentation/` directory
    - Read `../feature-knowledge.md` to understand feature context
    - Read `../feature-test-strategy.md` to inherit strategic approach
    - AI instruction: "Compare ticket requirements against feature-knowledge.md"
    - AI instruction: "Identify gaps: new business rules, new calculations, new API endpoints, new edge cases"
    - If gaps detected, prompt:
      ```
      "I found new information not in feature-knowledge.md:
        - [Gap description 1]
        - [Gap description 2]
      Would you like me to append this to feature-knowledge.md? [y/n]"
      ```
    - If yes, append to feature-knowledge.md with section format:
      ```markdown
      ## [Section added from ticket [ticket-id] on [date]]

      ### [Topic]
      [Content from ticket analysis]

      **Source:** Ticket [ticket-id]
      **Added:** [timestamp] during ticket requirement analysis
      ```
    - Extract testable requirements from ticket into structured table format
    - Create test-plan.md using template
    - Populate all 11 sections based on analysis
    - Section 1: Add references to feature-knowledge.md, feature-test-strategy.md, and ticket documentation
    - Section 4: Include testable requirements table with Req ID, Summary, Input, Expected Output, Priority
    - Section 5: Create coverage matrix linking requirements to test cases
    - Section 6: Generate detailed test scenarios with positive, negative, edge, and dependency failure cases
    - Section 7: Define test data requirements with data IDs and sample values
    - Section 11: Initialize revision log with Version 1.0 entry
    - Print success message with test-plan.md file path
    - Reference: Phase 3 specifications from command-specifications.md lines 526-732
  - [ ] 3.6 Create Phase 4: Generate Test Cases - Optional (4-generate-cases.md)
    - Prompt after Phase 3 completes:
      ```
      "Test plan created at: features/[feature-name]/[ticket-id]/test-plan.md

      Options:
        [1] Continue to Phase 4: Generate test cases now
        [2] Stop here (review test plan first, generate test cases later)

      Choose [1/2]:"
      ```
    - If option 1 selected:
      - Read test-plan.md Section 6 (Test Scenarios & Cases)
      - Read test-plan.md Section 7 (Test Data Requirements)
      - Read test-plan.md Section 5 (Test Coverage Matrix)
      - Generate detailed executable test cases using test-cases.md template
      - For each scenario in test-plan.md, expand into full test case with: Test ID, Type, Priority, Requirement, Objective, Preconditions, Test Data, Test Steps table (Step | Action | Expected Result), Expected Final Result, Actual Result checkboxes, Notes section, Defects section
      - Include test execution summary table at top
      - Add test data reference section at bottom
      - Print success message with total test cases generated
    - If option 2 selected:
      - Print message: "Test plan ready for review. You can generate test cases later by running: /generate-testcases"
      - Exit command gracefully
    - Reference: Phase 4 specifications from command-specifications.md lines 735-758
  - [ ] 3.7 Create orchestrator file (plan-ticket.md)
    - Create file at `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/commands/plan-ticket/single-agent/plan-ticket.md`
    - Add command description emphasizing smart detection and flexible execution
    - Add usage instructions: `/plan-ticket [ticket-id]`
    - Include phase tags in sequence:
      - `@qa-agent-os/commands/plan-ticket/0-detect-context.md`
      - `@qa-agent-os/commands/plan-ticket/1-init-ticket.md`
      - `@qa-agent-os/commands/plan-ticket/2-gather-ticket-docs.md`
      - `@qa-agent-os/commands/plan-ticket/3-analyze-requirements.md`
      - `@qa-agent-os/commands/plan-ticket/4-generate-cases.md`
    - Add explanation of routing logic for re-execution scenarios
    - Add success criteria summary
  - [ ] 3.8 Test /plan-ticket command workflows
    - Test Scenario 1: New ticket in existing feature
      - Run with sample ticket ID, select existing feature, provide sample docs, generate test cases immediately
      - Verify all folders created, test-plan.md and test-cases.md generated
    - Test Scenario 2: New ticket with gap detection
      - Run with ticket that introduces new requirements not in feature-knowledge.md
      - Verify gap detection prompt appears, test appending to feature-knowledge.md
    - Test Scenario 3: Stop after test plan
      - Run command, choose option 2 after Phase 3
      - Verify test-plan.md created but test-cases.md not generated
      - Verify helpful message about running /generate-testcases later
    - Test Scenario 4: Re-execution - Update test plan only
      - Run command on existing ticket, choose option 2 (Update test plan only)
      - Verify Phase 3 runs, test-plan.md updated, prompted for Phase 4
    - Test Scenario 5: Re-execution - Regenerate test cases only
      - Run command on existing ticket with existing test-plan.md, choose option 3
      - Verify Phase 4 runs, test-cases.md regenerated from existing plan
    - Test Scenario 6: Auto-select single feature
      - Run command when only one feature exists
      - Verify auto-selection with confirmation prompt

**Acceptance Criteria:**
- 5 phase markdown files created (including Phase 0 for smart detection)
- Orchestrator file created with routing logic explanation
- Smart detection works for existing tickets (4 options) and feature selection
- Gap detection compares ticket requirements to feature-knowledge.md and prompts for updates
- Flexible test case generation offers stop/continue options after Phase 3
- Test-plan.md generated with all 11 sections populated
- Test-cases.md generated with detailed executable test cases (if Phase 4 run)
- All re-execution scenarios tested and working
- Error handling for missing features and validation edge cases
- 6 test scenarios pass successfully

---

### Task Group 4: Supporting Commands

**Dependencies:** Task Groups 1, 2, 3
**Purpose:** Implement standalone commands for flexible test case generation, test plan revision, and feature knowledge updates

- [x] 4.0 Complete supporting commands implementation
  - [ ] 4.1 Create /generate-testcases command
    - [ ] 4.1.1 Create command directory
      - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/commands/generate-testcases/single-agent/` directory
    - [ ] 4.1.2 Create single-phase file (1-generate.md)
      - If ticket ID not provided as parameter, prompt for selection:
        ```
        "Which ticket's test cases to generate?"
        Recent tickets:
          [1] TICKET-125 (no test-cases.md yet) ← NEW
          [2] TICKET-124 (test-cases.md exists - last updated 2025-11-19)
          [3] TICKET-123 (test-cases.md exists - last updated 2025-11-18)
        Choose:
        ```
      - Use detect_existing_tickets() to find recent tickets across all features
      - Prioritize tickets without test-cases.md at top of list
      - If test-cases.md already exists, show warning:
        ```
        "Warning: test-cases.md already exists for ticket [ticket-id]
        Last updated: [timestamp]

        Options:
          [1] Overwrite (regenerate completely)
          [2] Append (add new cases, keep existing)
          [3] Cancel

        Choose [1/2/3]:"
        ```
      - Read test-plan.md to extract scenarios, test data, coverage matrix
      - Generate test-cases.md using template (same logic as plan-ticket Phase 4)
      - For each test scenario, create detailed test case with: ID, Type, Priority, Objective, Preconditions, Test Data, Steps table, Expected Result, Actual Result checkboxes
      - Include execution summary table, test data reference section, coverage notes
      - Print success message with total cases generated and file path
      - Reference: Specifications from command-specifications.md lines 774-1007
    - [ ] 4.1.3 Create orchestrator file (generate-testcases.md)
      - Create file with command description
      - Usage: `/generate-testcases` or `/generate-testcases [ticket-id]`
      - Include phase tag: `@qa-agent-os/commands/generate-testcases/1-generate.md`
      - Add notes about when to use (after test plan review, after test plan updates, standalone regeneration)
    - [ ] 4.1.4 Test /generate-testcases command
      - Test generating cases for ticket without test-cases.md
      - Test overwrite scenario on existing test-cases.md
      - Test append scenario (keeping existing cases)
      - Verify ticket selection prompt works with multiple tickets
      - Verify parameter passing works: `/generate-testcases TICKET-123`
  - [ ] 4.2 Create /revise-test-plan command
    - [ ] 4.2.1 Create command directory
      - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/commands/revise-test-plan/single-agent/` directory
    - [ ] 4.2.2 Create single-phase file (1-revise.md)
      - If ticket ID not provided, prompt for selection:
        ```
        "Which ticket's test plan to revise?"
        Active tickets:
          [1] TICKET-125 (currently testing)
          [2] TICKET-124 (testing complete)
          [3] TICKET-123 (testing in progress)
        Choose:
        ```
      - Prompt for update type:
        ```
        "What did you discover during testing?"
        Options:
          [1] New edge case found
          [2] New test scenario needed
          [3] Existing scenario needs update
          [4] New requirement discovered
          [5] Test data needs adjustment
        Choose:
        ```
      - Based on selection, prompt for specific details:
        - Option 1 (New edge case): Prompt for edge case description, expected behavior, priority
        - Option 2 (New scenario): Prompt for scenario description, test steps, expected outcome
        - Option 3 (Update existing): Show list of scenarios, prompt for updates
        - Option 4 (New requirement): Prompt for requirement details, impact analysis
        - Option 5 (Test data): Prompt for data ID, new values, reason for change
      - Update test-plan.md sections:
        - Section 4: Add new testable requirements if applicable
        - Section 5: Update coverage matrix with new test case mappings
        - Section 6: Add or update test scenarios
        - Section 7: Add or update test data
        - Section 11: Append revision entry with format:
          ```markdown
          **Version X.Y - [date] [time]**
          - [Change description]
          - [New requirement/scenario/edge case details]
          - Reason: [Why this change was needed]
          ```
      - Increment version number in revision log
      - After update, prompt:
        ```
        "Test plan updated. Would you like to regenerate test cases now? [y/n]"
        ```
      - If yes, call /generate-testcases internally with current ticket ID
      - If no, print message: "You can regenerate test cases later by running: /generate-testcases"
      - Reference: Specifications from command-specifications.md lines 1010-1107
    - [ ] 4.2.3 Create orchestrator file (revise-test-plan.md)
      - Create file with command description
      - Usage: `/revise-test-plan` or `/revise-test-plan [ticket-id]`
      - Include phase tag: `@qa-agent-os/commands/revise-test-plan/1-revise.md`
      - Add guidance on when to use (during test execution, when discovering new edge cases, when requirements change)
    - [ ] 4.2.4 Test /revise-test-plan command
      - Test each update type option (1-5)
      - Verify revision log appends correctly with version increments
      - Test regenerate prompt and internal call to /generate-testcases
      - Test ticket selection prompt with multiple active tickets
      - Verify test-plan.md sections update correctly based on change type
  - [ ] 4.3 Create /update-feature-knowledge command
    - [ ] 4.3.1 Create command directory
      - Create `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/profiles/default/commands/update-feature-knowledge/single-agent/` directory
    - [ ] 4.3.2 Create single-phase file (1-update.md)
      - If feature name not provided, prompt for selection:
        ```
        "Which feature's knowledge to update?"
        Features:
          [1] Feature-Name-1
          [2] Feature-Name-2
        Choose:
        ```
      - Prompt for update type:
        ```
        "What would you like to update?"
        Options:
          [1] Add new business rule
          [2] Add new API endpoint
          [3] Update existing information
          [4] Add edge case documentation
          [5] Add open question
        Choose:
        ```
      - Based on selection, prompt for specific details:
        - Option 1: Prompt for business rule name, description, examples, exceptions
        - Option 2: Prompt for endpoint path, method, request/response format, purpose
        - Option 3: Prompt for section to update, what to change, reason
        - Option 4: Prompt for edge case description, expected behavior, impact
        - Option 5: Prompt for question text, context, priority
      - Update feature-knowledge.md:
        - For new additions (options 1, 2, 4, 5), append new section with format:
          ```markdown
          ## [Section added manually on [date]]

          ### [Topic]
          [Content from prompts]

          **Source:** Manual update
          **Added:** [timestamp]
          **Reason:** [Reason provided by user]
          ```
        - For updates (option 3), modify existing section and add update note
        - Update "Last Updated" metadata at top of document
      - Print success message with updated section and file path
      - Reference: Specifications from command-specifications.md lines 1110-1169
    - [ ] 4.3.3 Create orchestrator file (update-feature-knowledge.md)
      - Create file with command description
      - Usage: `/update-feature-knowledge` or `/update-feature-knowledge [feature-name]`
      - Include phase tag: `@qa-agent-os/commands/update-feature-knowledge/1-update.md`
      - Add note: "This is a manual command for rare updates. Most feature knowledge updates happen automatically during ticket planning with gap detection."
    - [ ] 4.3.4 Test /update-feature-knowledge command
      - Test each update type option (1-5)
      - Verify new sections append with proper metadata format
      - Verify existing sections update correctly with update notes
      - Test feature selection prompt with multiple features
      - Verify Last Updated timestamp updates after each change

**Acceptance Criteria:**
- /generate-testcases command works standalone and as internal call
- Test case generation supports overwrite and append modes
- Ticket selection works with prioritization (no test-cases.md first)
- /revise-test-plan command updates correct test-plan.md sections based on change type
- Revision log properly tracks version numbers and timestamps
- /revise-test-plan offers regenerate option after update
- /update-feature-knowledge command allows 5 types of updates
- Feature knowledge updates include proper metadata and timestamps
- All 3 commands tested with multiple scenarios
- Error handling for missing files and invalid selections

---

### Task Group 5: Installation & Compilation

**Dependencies:** Task Groups 1, 2, 3, 4
**Purpose:** Update installation scripts to compile and install new commands into target projects

- [ ] 5.0 Complete installation and compilation updates
  - [x] 5.1 Update project-install.sh for new commands
    - Add compilation for /plan-feature command
      - Call compile_commands() for `profiles/default/commands/plan-feature/`
      - Ensure phase tag processing with process_phase_tags()
      - Output to `.claude/commands/qa-agent-os/plan-feature/`
    - Add compilation for /plan-ticket command
      - Call compile_commands() for `profiles/default/commands/plan-ticket/`
      - Ensure Phase 0 (detection) is included in compilation
      - Output to `.claude/commands/qa-agent-os/plan-ticket/`
    - Add compilation for /generate-testcases command
      - Call compile_commands() for `profiles/default/commands/generate-testcases/`
      - Output to `.claude/commands/qa-agent-os/generate-testcases/`
    - Add compilation for /revise-test-plan command
      - Call compile_commands() for `profiles/default/commands/revise-test-plan/`
      - Output to `.claude/commands/qa-agent-os/revise-test-plan/`
    - Add compilation for /update-feature-knowledge command
      - Call compile_commands() for `profiles/default/commands/update-feature-knowledge/`
      - Output to `.claude/commands/qa-agent-os/update-feature-knowledge/`
    - Verify existing commands still compile correctly (no regression)
    - Reference: Existing installation patterns from scripts/project-install.sh
  - [x] 5.2 Update template installation
    - Copy templates from `profiles/default/templates/` to project's `qa-agent-os/templates/` directory
    - Copy folder-structures/ directory
    - Copy all template markdown files (feature-knowledge-template.md, feature-test-strategy-template.md, test-plan-template.md, test-cases-template.md, collection-log-template.md)
    - Ensure templates are accessible to compiled commands
  - [ ] 5.3 Verify common-functions.sh integration
    - Ensure all new utility functions from Task 1.7 are available to compiled commands
    - Test path detection functions work in compiled command context
    - Test template functions work with installed templates
    - Verify prompt functions work correctly in Claude Code environment
  - [ ] 5.4 Test installation on clean project
    - Create test project directory: `/tmp/qa-agent-os-test-project/`
    - Run project-install.sh on test project
    - Verify .claude/commands/qa-agent-os/ contains all 5 new commands
    - Verify qa-agent-os/templates/ contains all template files
    - Verify no errors during installation
    - Verify phase tags are correctly resolved to file paths
  - [ ] 5.5 Test commands in installed project
    - Navigate to test project
    - Test /plan-feature with sample feature
    - Test /plan-ticket with sample ticket
    - Test /generate-testcases on sample ticket
    - Test /revise-test-plan on sample ticket
    - Test /update-feature-knowledge on sample feature
    - Verify all commands work as expected in installed context
    - Verify templates are used correctly
    - Verify folder structures created correctly
  - [ ] 5.6 Update config.yml if needed
    - Review existing config.yml for any necessary updates
    - Add any new configuration options for workflow commands
    - Document any new configuration settings in comments
    - No changes expected unless new configuration needs identified during implementation

**Acceptance Criteria:**
- project-install.sh successfully compiles all 5 new commands
- All phase files correctly processed with phase tag resolution
- Templates installed to qa-agent-os/templates/ directory
- Common-functions.sh utilities accessible to compiled commands
- Clean installation test passes without errors
- All 5 commands work correctly in installed project context
- Folder structures and templates used correctly by commands
- No regression in existing command compilation

---

### Task Group 6: Testing, Documentation & Integration

**Dependencies:** Task Groups 1, 2, 3, 4, 5
**Purpose:** End-to-end testing, documentation updates, and final validation

- [ ] 6.0 Complete testing, documentation, and integration
  - [ ] 6.1 End-to-end workflow testing
    - [ ] 6.1.1 Test complete feature workflow (brand new feature)
      - Run /plan-feature with new feature name
      - Provide sample documentation (BRD, API specs, mockups)
      - Verify feature-knowledge.md created with all 8 sections populated
      - Verify feature-test-strategy.md created with all 10 sections populated
      - Check documentation/ folder contains collected documents
      - Verify COLLECTION_LOG.md tracks all collected documents
    - [ ] 6.1.2 Test first ticket in new feature
      - Run /plan-ticket with new ticket ID
      - Verify feature auto-detected from previous step
      - Provide sample ticket documentation
      - Choose option 1 (generate test cases immediately)
      - Verify ticket folder structure created
      - Verify test-plan.md created with 11 sections, references to feature docs
      - Verify test-cases.md generated with detailed test cases
      - Verify gap detection does not trigger (no new information)
    - [ ] 6.1.3 Test second ticket with gap detection
      - Run /plan-ticket with second ticket ID introducing new requirements
      - Verify gap detection prompt appears with list of new information
      - Confirm update to feature-knowledge.md
      - Verify new section appended to feature-knowledge.md with proper metadata
      - Choose option 2 (stop after test plan)
      - Verify test-plan.md created but test-cases.md not generated
      - Run /generate-testcases separately
      - Verify test-cases.md generated with new requirements included
    - [ ] 6.1.4 Test iterative refinement workflow
      - Run /revise-test-plan on first ticket
      - Choose "New edge case found"
      - Provide edge case details
      - Verify test-plan.md updated with new scenario in Section 6
      - Verify revision log in Section 11 updated with version increment
      - Choose yes to regenerate test cases
      - Verify test-cases.md regenerated with new edge case test cases
    - [ ] 6.1.5 Test re-execution scenarios
      - Re-run /plan-ticket on existing ticket
      - Verify re-execution prompt appears with 4 options
      - Test option 2 (Update test plan only)
      - Verify Phase 3 runs, test-plan.md updated
      - Re-run /plan-ticket on same ticket
      - Test option 3 (Regenerate test cases only)
      - Verify Phase 4 runs, test-cases.md regenerated
    - [ ] 6.1.6 Test manual feature knowledge update
      - Run /update-feature-knowledge on test feature
      - Choose "Add new business rule"
      - Provide business rule details
      - Verify feature-knowledge.md appended with new section and metadata
  - [ ] 6.2 Edge case and error handling testing
    - Test /plan-feature on existing feature (verify re-plan prompt)
    - Test /plan-ticket when no features exist (verify helpful error message)
    - Test /plan-ticket with invalid ticket ID format (verify normalization)
    - Test /generate-testcases on ticket without test-plan.md (verify error handling)
    - Test /revise-test-plan on ticket without test-plan.md (verify error handling)
    - Test /update-feature-knowledge on non-existent feature (verify error handling)
    - Test commands with no documentation provided (verify warnings and confirmations)
    - Test path detection with different project structures (qa-agent-os/features/ vs features/)
  - [ ] 6.3 Performance and usability testing
    - Test commands with large documentation files (verify no performance issues)
    - Test prompt clarity and user-friendliness (verify all prompts are clear)
    - Test color output and formatting (verify readability)
    - Test success messages guide user to next steps
    - Test error messages are helpful and actionable
    - Verify progress indicators for long operations
  - [ ] 6.4 Update CLAUDE.md with new workflow
    - Add section: "QA Workflow Commands"
    - Document /plan-feature command with usage and purpose
    - Document /plan-ticket command with smart detection features
    - Document /generate-testcases command with flexibility options
    - Document /revise-test-plan command with iterative workflow
    - Document /update-feature-knowledge command
    - Add workflow visualization showing command sequence
    - Add examples of common workflows (new feature, second ticket, iterative testing)
    - Update "Core Architecture" section to mention new workflow commands
    - Reference: Project overview from CLAUDE.md lines 1-162
  - [ ] 6.5 Update README.md with command usage
    - Add "QA Workflow" section before or after existing command documentation
    - Add quick start guide: "Planning Your First Feature"
    - Document each command with:
      - Purpose
      - Usage syntax
      - When to use it
      - Example output
    - Add decision tree diagram: "Which Command Should I Use?"
    - Add FAQ section for common questions
    - Update feature list to include new workflow commands
    - Add link to detailed command specifications in planning/ directory
  - [ ] 6.6 Create quickstart guide for QAs
    - Create `docs/qa-workflow-quickstart.md` (if docs/ directory exists in project structure)
    - Section 1: "Your First Feature" - Step-by-step walkthrough of /plan-feature
    - Section 2: "Your First Ticket" - Step-by-step walkthrough of /plan-ticket
    - Section 3: "Iterative Testing" - Examples of /revise-test-plan and /generate-testcases
    - Section 4: "Tips and Best Practices" - When to use each command, common pitfalls
    - Include screenshots or command output examples (text format)
    - Add troubleshooting section for common issues
  - [ ] 6.7 Update CHANGELOG.md
    - Add new section for this release/version
    - List all new commands with brief descriptions
    - Highlight key features: orchestration, smart detection, gap detection, flexible execution
    - Note breaking changes if any (likely none for new features)
    - Add migration guide if needed (e.g., if old commands deprecated)
    - Credit contributors and reference issue/PR numbers if applicable
  - [ ] 6.8 Validate against success criteria
    - Review success criteria from spec.md and requirements.md
    - Verify all functional requirements met
    - Verify all user stories addressed
    - Verify workflow follows Plan-Do-Check-Act model
    - Verify documentation hierarchy is clear (feature → ticket)
    - Verify traceability maintained (requirements → strategy → plans → cases)
    - Verify QA efficiency improved (reduced command count, clear workflow)
    - Verify documentation stays current (gap detection working)
    - Verify flexibility requirements met (stop/continue options, regeneration)
  - [ ] 6.9 Create test summary report
    - Document all test scenarios executed (6.1.1 through 6.3)
    - List any issues found and resolved during testing
    - Document performance observations
    - Document usability feedback
    - List any edge cases identified for future consideration
    - Provide recommendation for release readiness

**Acceptance Criteria:**
- 6 end-to-end workflow scenarios pass successfully
- All edge cases and error scenarios handled gracefully
- Performance acceptable with large documentation files
- User experience validated (prompts clear, messages helpful, colors readable)
- CLAUDE.md updated with comprehensive workflow documentation
- README.md updated with command usage and quick start
- Quickstart guide created with step-by-step examples
- CHANGELOG.md updated with release notes
- All success criteria from spec validated and confirmed
- Test summary report documents readiness for release
- No critical bugs or usability issues remaining

---

## Execution Order

**Recommended implementation sequence:**

1. **Task Group 1: Infrastructure & Foundation** (Templates, folder structures, utility functions)
   - Critical foundation for all other tasks
   - Creates reusable components

2. **Task Group 2: Feature Planning Command** (4 phases + orchestrator)
   - Natural starting point for workflow
   - Tests template usage and utility functions
   - Provides feature context for ticket commands

3. **Task Group 3: Ticket Planning Command** (5 phases + orchestrator with smart detection)
   - Builds on feature planning
   - Most complex command with smart detection and gap detection
   - Core of the workflow redesign

4. **Task Group 4: Supporting Commands** (Standalone generation, revision, manual update)
   - Depends on ticket planning structure
   - Provides flexibility and iteration support
   - Can be implemented in parallel (4.1, 4.2, 4.3 independent)

5. **Task Group 5: Installation & Compilation** (Script updates, template installation)
   - Integrates all commands into installable package
   - Tests compilation and installation process
   - Validates commands work in installed context

6. **Task Group 6: Testing, Documentation & Integration** (E2E testing, docs, validation)
   - Final validation of complete workflow
   - Documentation for users
   - Release readiness assessment

---

## Dependencies Visualization

```
Task Group 1 (Infrastructure)
    ↓
    ├── Task Group 2 (Feature Planning)
    │       ↓
    │       └── Task Group 3 (Ticket Planning)
    │               ↓
    │               └── Task Group 4 (Supporting Commands)
    │                       ↓
    │                       └── Task Group 5 (Installation)
    │                               ↓
    │                               └── Task Group 6 (Testing & Docs)
```

---

## Key Technical Notes

### Template Usage Pattern
All commands use templates from `profiles/default/templates/`:
- feature-knowledge-template.md
- feature-test-strategy-template.md
- test-plan-template.md
- test-cases-template.md
- collection-log-template.md

Templates are copied to project during installation and populated by commands.

### Phase Tag Pattern
Orchestrator files use phase tags that are resolved during compilation:
```markdown
@qa-agent-os/commands/command-name/1-phase.md
```

This pattern is processed by `process_phase_tags()` in common-functions.sh.

### Smart Detection Pattern
/plan-ticket Phase 0 implements context-aware routing:
- Existing ticket → Show 4 re-execution options
- New ticket → Detect and select feature
- Missing feature → Guide to /plan-feature

### Gap Detection Pattern
/plan-ticket Phase 3 implements intelligent comparison:
- Read ticket requirements
- Compare to feature-knowledge.md
- Identify gaps (new rules, APIs, edge cases)
- Prompt for confirmation before updating
- Append with metadata for traceability

### Utility Functions Required
From common-functions.sh (Task 1.7):
- create_folder_from_template()
- create_document_from_template()
- detect_existing_features()
- detect_existing_tickets()
- prompt_with_options()
- confirm_action()
- detect_project_root()
- resolve_features_path()
- validate_feature_exists()
- validate_ticket_exists()

---

## Standards Compliance

All tasks must align with:
- `agent-os/standards/global/` - Coding conventions, tech stack, error handling
- `agent-os/standards/testing/` - Test writing standards
- `agent-os/standards/bugs/` - Bug reporting templates (for future bug commands)

Specific alignments:
- Markdown formatting conventions
- YAML parsing patterns
- Color output standards (RED, GREEN, YELLOW, BLUE, PURPLE)
- Error handling patterns (print_error, graceful exit)
- Path handling (absolute paths, normalize_name)

---

## Risk Mitigation

| Risk | Mitigation Strategy |
|------|---------------------|
| Template complexity | Start with simple templates, iterate based on testing feedback |
| Phase tag resolution failures | Extensive testing of compilation in Task 5.4, validation scripts |
| Gap detection false positives | Require user confirmation, provide clear gap descriptions |
| User confusion with many options | Clear prompts, helpful messages, quickstart guide |
| Performance with large files | Test with realistic file sizes in Task 6.3 |
| Installation errors | Clean installation testing in Task 5.4, error handling |

---

## Success Metrics

**Efficiency:**
- Command count reduced from 8 to 5
- Single orchestrated command replaces 4 manual commands
- Time to plan ticket reduced by ~60%

**Quality:**
- Feature knowledge stays current (gap detection)
- 100% traceability (requirements → cases)
- Comprehensive test coverage (positive, negative, edge, dependency failure)

**Usability:**
- Clear workflow (Plan → Do → Check → Act)
- Smart assistance (auto-detection, prompts)
- Flexible execution (stop/continue options)
- Helpful error messages

---

## Notes

- All file paths in tasks are absolute paths to ensure clarity
- Commands follow agent-os proven orchestrator pattern
- Templates are designed for both human readability and AI processing
- Smart detection reduces user input and prevents errors
- Gap detection keeps documentation current without manual effort
- Flexible test case generation accommodates real-world QA workflows
- Re-execution options provide efficient iteration paths
