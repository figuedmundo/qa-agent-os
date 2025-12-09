# Specification: QA Workflow Command Separation

## Goal

Separate the monolithic QA workflow commands into discrete, reusable commands that distinguish user-driven tasks from AI-driven tasks, enabling flexible re-execution and better workflow control while maintaining smart detection and gap detection capabilities.

## User Stories

- As a QA engineer, I want to initialize feature and ticket structures separately from analysis so that I can control when documentation gathering and analysis occur
- As a QA engineer, I want explicit visibility when gap detection finds new information so that I can make informed decisions about updating feature knowledge
- As a QA engineer, I want context-aware commands that automatically detect whether I'm working on features or tickets so that I don't have to manually specify context every time

## Specific Requirements

### Command 1: /start-feature

- Accept feature name as parameter or interactive prompt if not provided
- Normalize feature name to lowercase kebab-case format
- Create folder structure: `qa-agent-os/features/[feature-name]/documentation/`
- Do not create any placeholder files or content (structure only)
- Check if feature already exists before creating
- If feature exists, prompt with options: [1] Overwrite [2] Cancel
- Output success message with next steps guidance pointing to `/gather-docs` and `/analyze-requirements`
- Set FEATURE_PATH variable for potential use by subsequent commands

### Command 2: /start-ticket

- Accept ticket ID as parameter or interactive prompt if not provided
- Implement smart feature detection to list available features from `qa-agent-os/features/`
- If multiple features exist, prompt user to select parent feature
- If single feature exists, auto-select with confirmation prompt
- If no features exist, display error and suggest running `/plan-feature` first
- Check if ticket already exists in selected feature
- If ticket exists, prompt with options: [1] Overwrite structure [2] Cancel
- Create folder structure: `qa-agent-os/features/[feature-name]/[ticket-id]/documentation/`
- Do not create test-plan.md or test-cases.md placeholder files
- Output success message with next steps guidance pointing to `/gather-docs` and `/analyze-requirements`

### Command 3: /gather-docs

- Implement smart context detection by analyzing current working directory path
- Detect ticket context if path matches `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Detect feature context if path matches `qa-agent-os/features/[feature-name]/`
- If context cannot be detected from path, present interactive selection menu
- For feature context, display guidance prompts listing: BRD, API specs, UI mockups, technical architecture, database schema, feature-specific docs
- For ticket context, display guidance prompts listing: ticket description, acceptance criteria, API endpoint details, screen mockups, technical notes, test data examples
- Include target documentation path in all guidance output
- Provide clear next-step instruction to run `/analyze-requirements` after documentation is added
- Do not perform any file operations (guidance only, user-driven)
- Support re-execution to display guidance again if needed

### Command 4: /analyze-requirements (Feature Context)

- Implement smart directory detection by checking current working directory for feature-level path
- Validate that documentation folder exists and contains readable files
- If documentation folder empty, prompt interactively: [1] Show gathering guidance [2] I'll add manually
- Read and analyze all documents in `qa-agent-os/features/[feature-name]/documentation/`
- Check for existing feature-knowledge.md and feature-test-strategy.md before analysis
- If both files exist, prompt re-execution options: [1] Full re-analysis (overwrite both) [2] Update knowledge only [3] Update strategy only [4] Cancel
- Generate feature-knowledge.md with 8 sections: Overview, Business Rules, API Endpoints, Data Models, Edge Cases, Dependencies, Open Questions, References
- Generate feature-test-strategy.md with 10 sections: Testing Approach, Tools, Environment, Test Data Strategy, Risks, Entry/Exit Criteria, Dependencies, Schedule, Resources, References
- Reference templates from `@qa-agent-os/templates/feature-knowledge-template.md` and `@qa-agent-os/templates/feature-test-strategy-template.md`
- Output success message with created file paths and next steps

### Command 4: /analyze-requirements (Ticket Context)

- Implement smart directory detection by checking current working directory for ticket-level path
- Validate that ticket documentation folder exists and contains readable files
- If ticket documentation folder empty, prompt interactively to show guidance or add manually
- Read parent feature-knowledge.md and feature-test-strategy.md for context
- If parent feature documents don't exist, error and suggest running `/analyze-requirements` at feature level first
- Analyze all documents in `qa-agent-os/features/[feature-name]/[ticket-id]/documentation/`
- Implement gap detection algorithm comparing ticket requirements against feature-knowledge.md
- Identify gaps in: business rules, API endpoints, edge cases, data models not documented in feature knowledge
- When gaps detected, ALWAYS display explicit gap detection summary with count and descriptions
- Prompt user with gap handling options: [1] Append all gaps [2] Review detailed report first [3] Skip gap updates
- If user selects append, update feature-knowledge.md with metadata (source: ticket-id, date added)
- Check for existing test-plan.md before generating
- If test-plan.md exists, prompt: [1] Full re-analysis (overwrite) [2] Append to existing [3] Cancel
- Generate test-plan.md with 11 sections including requirement traceability and test scenarios
- Reference template from `@qa-agent-os/templates/test-plan-template.md`
- After test-plan.md creation, offer test case generation: [1] Generate now [2] Stop for review

### Context Detection Algorithm (Shared)

- Parse current working directory path to identify context markers
- Match pattern `qa-agent-os/features/[feature-name]/[ticket-id]/` for ticket context
- Match pattern `qa-agent-os/features/[feature-name]/` for feature context
- If no pattern match, present interactive fallback menu
- Interactive menu options: [1] Analyze feature (list available features) [2] Analyze ticket (prompt for ticket-id) [3] Cancel
- Validate that selected feature or ticket folders exist before proceeding
- Display clear error messages if structure missing with suggestion to run `/start-feature` or `/start-ticket`

### Gap Detection Visibility Requirements

- Always display a "GAP DETECTION RESULTS" header when gaps are found
- Include count of gaps detected (e.g., "I found 5 gaps...")
- List each gap with type prefix: [New business rule], [New API endpoint], [New edge case], [New data model]
- Show brief description for each gap in the summary
- Provide numbered options for user response with clear action descriptions
- If user requests detailed review, show full gap analysis with specific sections affected
- Log gap detection results even if user chooses to skip updates
- Include source traceability when appending gaps (ticket ID and timestamp)

### Migration Strategy

- Remove `/plan-feature` command directory entirely from `profiles/default/commands/`
- Remove `/plan-ticket` command directory entirely from `profiles/default/commands/`
- Do not create legacy aliases or backward compatibility wrappers
- Reuse existing phase file logic from removed commands as implementation reference
- Phase 1 of old `/plan-feature` becomes implementation basis for `/start-feature`
- Phase 2 of old `/plan-feature` becomes implementation basis for `/gather-docs` feature guidance
- Phases 3-4 of old `/plan-feature` become implementation basis for `/analyze-requirements` feature context
- Phase 0 of old `/plan-ticket` becomes implementation basis for smart detection in `/start-ticket` and context detection in `/analyze-requirements`
- Phase 1 of old `/plan-ticket` becomes implementation basis for `/start-ticket`
- Phase 2 of old `/plan-ticket` becomes implementation basis for `/gather-docs` ticket guidance
- Phase 3 of old `/plan-ticket` becomes implementation basis for `/analyze-requirements` ticket context and gap detection

### Documentation Updates Required

- Update CHANGELOG.md with breaking change notice explaining command removal and new workflow
- Update QA-QUICKSTART.md with complete workflow examples using new 4-command structure
- Update README.md command reference section replacing old commands with new command specifications
- Update command descriptions to emphasize separation of structure, gathering, and analysis phases
- Provide migration examples showing old workflow vs new workflow side-by-side

## Visual Design

No visual assets provided in planning/visuals/ folder.

## Existing Code to Leverage

### Smart Detection from /plan-ticket Phase 0

- Reuse logic for detecting existing ticket folders
- Reuse feature listing and selection prompts
- Reuse re-execution option menu structure with numbered choices
- Adapt detection to work in both `/start-ticket` and `/analyze-requirements` contexts
- Reference file: `profiles/default/commands/plan-ticket/single-agent/0-detect-context.md`

### Structure Initialization from /plan-feature Phase 1

- Reuse feature name normalization logic (lowercase, kebab-case)
- Reuse folder creation pattern for documentation subdirectory
- Reuse success message format with FEATURE_PATH output
- Adapt to not create README.md or any placeholder files
- Reference file: `profiles/default/commands/plan-feature/single-agent/1-init-structure.md`

### Documentation Gathering Prompts from /plan-feature Phase 2

- Reuse interactive prompt structure for document types
- Reuse BRD, API specs, mockups, technical docs prompt categories
- Adapt to output guidance instead of actually collecting files
- Add ticket-specific prompts for acceptance criteria, technical specs, API examples
- Reference file: `profiles/default/commands/plan-feature/single-agent/2-gather-docs.md`

### Gap Detection Logic from /plan-ticket Phase 3

- Reuse requirement analysis workflow pattern
- Reuse gap detection comparison algorithm between ticket and feature knowledge
- Enhance with explicit visibility requirement (always inform user)
- Reuse prompt structure for appending gaps to feature-knowledge.md
- Reuse metadata addition pattern (source, date) when updating feature knowledge
- Reference file: `profiles/default/commands/plan-ticket/single-agent/3-analyze-requirements.md`

### Re-execution Pattern from Existing Commands

- Reuse numbered option menu pattern from smart detection
- Reuse validation checks for existing files before operations
- Reuse cancellation handling and exit message patterns
- Apply consistently across `/start-feature`, `/start-ticket`, and `/analyze-requirements`

## Out of Scope

- Modifications to `/generate-testcases` command implementation or behavior
- Modifications to `/revise-test-plan` command implementation or behavior
- Modifications to `/update-feature-knowledge` command implementation or behavior
- Automated documentation gathering capabilities (commands remain user-driven for gathering phase)
- Changes to integration commands for Jira or Testmo
- Modifications to multi-agent orchestration files or agent role definitions
- Changes to existing standards files or standard content
- Changes to template file content or template structure
- Modifications to folder structure conventions (qa-agent-os/features/ hierarchy remains unchanged)
- Changes to document formats (feature-knowledge.md, feature-test-strategy.md, test-plan.md, test-cases.md formats unchanged)
- Implementation of legacy command aliases or backward compatibility wrappers
