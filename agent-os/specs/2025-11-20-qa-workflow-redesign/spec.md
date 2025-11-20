# Specification: QA Workflow Redesign

## Goal

Redesign the QA Agent OS command workflow to align with real-world QA processes by implementing an orchestrated command structure that reduces complexity, improves efficiency, and ensures comprehensive test planning through smart detection and flexible execution.

## User Stories

- As a QA engineer, I want to plan an entire feature with one command so that I don't have to remember multiple command sequences and can focus on testing strategy rather than file management
- As a QA engineer, I want to plan ticket testing with intelligent gap detection so that feature knowledge stays current and I don't miss important requirements
- As a QA engineer, I want flexible test case generation so that I can review test plans before generating cases and regenerate after iterative refinements

## Specific Requirements

### Orchestrated Command Structure

- Implement `/plan-feature` orchestrator command that runs 4 phases automatically: initialize structure, gather documentation, consolidate knowledge, create test strategy
- Implement `/plan-ticket` orchestrator command that runs 3-4 phases with flexible execution: initialize ticket, gather docs, analyze requirements, optionally generate test cases
- Follow agent-os proven pattern with phase tags like `{{PHASE 1: @qa-agent-os/commands/command-name/1-phase.md}}`
- Each orchestrator command reads from sequentially numbered phase files (1-phase.md, 2-phase.md, etc.)
- Use common-functions.sh utilities for YAML parsing, output formatting, and file operations
- Leverage existing color output functions (RED, GREEN, YELLOW, BLUE, PURPLE) for consistent user experience
- Commands must detect project root and support both `qa-agent-os/features/` and `features/` path formats

### Smart Feature Detection

- AI prompts "Which feature does ticket [ticket-id] belong to?" when `/plan-ticket` is executed
- Display numbered list of existing features found in `qa-agent-os/features/` directory
- Include "[N+1] Create new feature" option in the list
- Auto-select feature if only one exists and prompt for confirmation: "Found feature: [name]. Is this correct? [y/n]"
- If "Create new feature" selected, redirect to `/plan-feature` internally, then return to `/plan-ticket`
- Use normalize_name() function from common-functions.sh to standardize feature names (lowercase, hyphens, no special characters)

### Intelligent Gap Detection

- During Phase 3 of `/plan-ticket`, AI reads existing `feature-knowledge.md`
- Compare ticket requirements against feature knowledge to identify: new business rules, new calculations, new API endpoints, new edge cases
- If gaps detected, prompt: "I found new information not in feature-knowledge.md: [list]. Would you like me to append this to feature-knowledge.md? [y/n]"
- If yes, append section with metadata: "## [Section added from ticket [ticket-id] on [date]]", include source ticket reference and timestamp
- Maintain traceability through git version control
- Require user confirmation before any updates (no silent modifications)

### Smart Re-execution Detection

- When `/plan-ticket` detects existing ticket folder, display 4 options: [1] Full re-plan (Phases 1-4), [2] Update test plan only (Phase 3), [3] Regenerate test cases only (Phase 4), [4] Cancel
- Option 1 re-runs all phases including re-gathering documentation
- Option 2 skips to Phase 3, re-analyzes requirements, updates test-plan.md
- Option 3 skips to Phase 4, uses existing test-plan.md to regenerate test-cases.md
- Single command handles all re-execution scenarios without separate commands

### Flexible Test Case Generation

- After Phase 3 completes in `/plan-ticket`, prompt: "Test plan created. Options: [1] Continue to Phase 4: Generate test cases now [2] Stop here (review test plan first, generate test cases later)"
- Option 1 proceeds automatically to Phase 4
- Option 2 exits with message: "Run /generate-testcases when ready"
- Implement standalone `/generate-testcases` command that can generate or regenerate test cases anytime
- If test-cases.md exists, warn and offer options: [1] Overwrite (regenerate completely) [2] Append (add new cases, keep existing) [3] Cancel
- Support ticket specification as parameter or prompt for selection from recent tickets

### Feature-Level Documentation Structure

- Create `features/[feature-name]/documentation/` for raw source documents from stakeholders
- Create `features/[feature-name]/feature-knowledge.md` with 8 sections: Feature Overview, Business Requirements, Technical Requirements, User Experience, Edge Cases & Constraints, Test Considerations, Open Questions, Document Sources
- Create `features/[feature-name]/feature-test-strategy.md` with 10 sections: Testing Objective, Test Approach, Test Environment & Tools, Test Data Strategy, Automation Strategy, Non-Functional Requirements, Risk Assessment, Entry & Exit Criteria, Deliverables, Roles & Responsibilities
- feature-knowledge.md consolidates WHAT is being built from all documentation sources
- feature-test-strategy.md defines HOW feature will be tested strategically

### Ticket-Level Documentation Structure

- Create `features/[feature-name]/[ticket-id]/documentation/` for ticket-specific documents
- Create `features/[feature-name]/[ticket-id]/documentation/visuals/` for mockups and screenshots
- Create `features/[feature-name]/[ticket-id]/test-plan.md` with 11 sections: References, Ticket Overview, Test Scope, Testable Requirements, Test Coverage Matrix, Test Scenarios & Cases, Test Data Requirements, Environment Setup, Execution Timeline, Entry/Exit Criteria, Revisions
- Create `features/[feature-name]/[ticket-id]/test-cases.md` with detailed executable test cases including steps, expected results, test data, execution tracking
- test-plan.md references feature-test-strategy.md to inherit strategic approach and avoid redundancy

### Systematic Documentation Gathering

- Phase 2 of `/plan-feature` prompts for: BRD, API specifications, calculation logic, UI mockups, other technical documentation
- Phase 2 of `/plan-ticket` prompts for: Jira ticket export, acceptance criteria, technical specs, mockups/screenshots, API examples, other ticket-specific docs
- Each prompt offers options: [File path] [Paste content] [Skip]
- Store collected documents with clear naming in respective documentation/ folders
- Create COLLECTION_LOG.md with metadata: what was collected, when, from which source

### Test Plan Revision Workflow

- Implement `/revise-test-plan` command for iterative updates during testing
- Prompt for which ticket to revise if not specified as parameter
- Offer update type options: [1] New edge case found [2] New test scenario needed [3] Existing scenario needs update [4] New requirement discovered [5] Test data needs adjustment
- Collect details based on selection type through guided prompts
- Update test-plan.md sections (4, 5, 6) and append revision entry to Section 11 with timestamp, change description, reason
- After update, prompt: "Test plan updated. Would you like to regenerate test cases now? [y/n]"
- If yes, call `/generate-testcases` internally

### Manual Feature Knowledge Updates

- Implement `/update-feature-knowledge` command for rare manual updates
- Prompt for feature selection if not specified
- Offer update options: [1] Add new business rule [2] Add new API endpoint [3] Update existing information [4] Add edge case documentation [5] Add open question
- Collect details and update feature-knowledge.md with proper metadata section
- Include: Manual update marker, timestamp, reason for update

### Template Structures and Standards Alignment

- All templates must follow markdown format with clear section headers
- Use table format for coverage matrices, test data definitions, requirement tracking
- Include revision tracking in test plans with version numbers and change logs
- Follow existing QA Agent OS standards from agent-os/standards/ directory
- Bug reports must follow standards/bugs/ templates when implemented
- Test case format must align with standards/testcases/ conventions
- Use consistent terminology across all templates (Requirements → Test Cases → Results)

## Existing Code to Leverage

### Agent-OS Orchestrator Pattern

- Orchestrator pattern from `/plan-product` command shows proven two-phase information gathering: collect raw data first, then consolidate into structured documentation
- Phase execution with tags like `{{PHASE 1: @qa-agent-os/commands/plan-product/1-product-concept.md}}` enables modular command construction
- Sequential numbered phase files (1-phase.md, 2-phase.md) make workflow clear and maintainable
- This pattern should be replicated for `/plan-feature` and `/plan-ticket` orchestrators
- Process_phase_tags() function from common-functions.sh handles tag replacement during compilation

### Common Functions Utilities

- normalize_name() function standardizes feature/ticket names (lowercase, hyphens, remove special characters)
- Color output functions (print_success, print_error, print_warning, print_status) provide consistent user feedback
- get_yaml_value() function parses configuration from config.yml robustly
- These utilities should be leveraged throughout all new commands for consistency

### Existing Command Structure

- Commands organized under profiles/default/commands/[command-name]/single-agent/ directory
- Each command has orchestrator .md file that references phase files
- Installation scripts compile commands from profiles/ into .claude/commands/ directory
- New commands must follow this established structure for proper installation

### Standards Integration Points

- Standards directory provides templates and guidelines that must be referenced in generated documentation
- Bug reporting follows standards/bugs/ templates for severity, analysis, reproduction
- Test writing follows standards/testing/ conventions for structure and coverage
- All generated documentation must align with these established standards

### Installation and Compilation

- project-install.sh script installs QA Agent OS into target project and compiles commands
- common-functions.sh provides compilation utilities like compile_commands() and process_phase_tags()
- Commands are compiled from source files into executable commands during installation
- New workflow commands must integrate with existing installation infrastructure

## Out of Scope

- Jira integration commands and automatic ticket data pulling from Jira API
- Testmo integration and CSV export functionality for test cases
- `/close-ticket` or `/verify-ticket-complete` quality gate commands
- Test execution tracking, results management, and automated reporting
- Automated test strategy revision commands (feature-test-strategy.md edited manually only)
- Visual/mockup management, annotation, or comparison commands
- Test automation framework code generation or script creation
- Bug reporting commands beyond basic documentation structure
- Performance testing execution or load testing automation
- Security scanning integration or vulnerability assessment automation
