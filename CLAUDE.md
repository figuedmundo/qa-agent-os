# CLAUDE.md

This file provides guidance to Claude Code and Gemini 3 when working with code in this repository.

## Project Overview

QA Agent OS is a distributable, spec-driven system that provides AI coding assistants with structured context to perform production-quality QA tasks. It transforms generic AI capabilities into a specialized QA assistant tailored to a specific project's needs using a 3-layer context system: **Standards** (how we test), **Product** (what we're testing and why), and **Features** (what we're testing next).

## Core Architecture

The system is built on **four main components**:

### 1. Engine (`scripts/`)
Shell scripts that read configuration and process knowledge into final outputs:
- `project-install.sh` — Main entry point; installs QA Agent OS into a target project
- `project-update.sh` — Updates existing installation
- `common-functions.sh` — Shared utilities for parsing YAML, processing Markdown, compiling commands
- `base-install.sh` — One-time installation to `~/qa-agent-os`
- `create-profile.sh` — Utility for creating custom profiles

**Key concept:** The engine is separate from content. It processes Markdown files from the knowledge core and compiles them into structured outputs for AI agents.

### 2. Configuration (`config.yml`)
Central control panel defining:
- AI agent target (Claude Code or Gemini 3)
- Single-agent vs. multi-agent setup
- Profile selection (default or custom)
- Output paths and behavior:
  - **Claude Code:** `.claude/commands/` and `.claude/agents/` for multi-agent orchestration
  - **Gemini 3:** `.gemini/commands/` with `.toml` files for custom commands

Current defaults support both Claude Code (with subagents) and Gemini 3 (with custom commands), with standards injected as file references.

### 3. Knowledge & Personality (`profiles/default/`)
The content layer containing:

**`standards/`** — QA guidelines and conventions
- `global/` — Applies to all tasks (bugs.md, testcases.md, conventions.md)
- `bugs/` — Bug reporting standards, templates, severity rules, analysis checklists
- `requirement-analysis/` — BRD analysis, acceptance criteria, priority rules, requirement checklists
- `testcases/` — Test case structure, generation standards, test case templates
- `testing/` — API testing, exploratory testing, test plan templates

**`templates/`** — Document templates for feature and ticket planning
- `feature-knowledge-template.md` — 8-section feature overview template
- `feature-test-strategy-template.md` — 10-section testing strategy template
- `test-plan-template.md` — 11-section ticket test plan template
- `test-cases-template.md` — Detailed test case execution template
- `collection-log-template.md` — Documentation gathering log
- `folder-structures/` — Directory structure templates

**`commands/`** — Discrete AI agent commands (compiled into `.claude/commands/qa-agent-os/` for Claude Code or `.gemini/commands/` with `.toml` files for Gemini 3)
- `start-feature/` — Initialize feature folder structure only
- `start-ticket/` — Initialize ticket folder structure with smart feature detection
- `gather-docs/` — Display documentation gathering guidance (user-driven, no automation)
- `analyze-requirements/` — Analyze gathered documentation and create knowledge/strategy/test plans based on context
- `generate-testcases/` — Generate or regenerate test cases from test-plan.md
- `revise-test-plan/` — Update test plans during testing with revision tracking
- `update-feature-knowledge/` — Manually update feature knowledge (rare)
- `improve-skills/` — Enhance AI agent capabilities (Claude Code Skills)
- `integrations/` — Jira and Testmo integration commands

**`agents/`** — Roles for multi-agent setups (currently not used in default single-agent config)
- product-planner.md, requirement-analyst.md, testcase-writer.md, bug-writer.md, etc.

### 4. Installation Output (End-user project)
After running `project-install.sh`, a project contains:

**For Claude Code:**
```
project/
├── .claude/
│   ├── commands/qa-agent-os/       ← Compiled Claude Code commands
│   └── agents/qa-agent-os/         ← Multi-agent orchestration
├── qa-agent-os/
│   ├── standards/                  ← Compiled standards
│   ├── templates/                  ← Document templates
│   ├── product/                    ← User-created product context
│   └── features/                   ← Feature specs (ticket-based structure)
└── src/                            ← Actual project code
```

**For Gemini 3:**
```
project/
├── .gemini/
│   └── commands/                   ← Custom command .toml files (one per QA command)
├── qa-agent-os/
│   ├── standards/                  ← Compiled standards
│   ├── templates/                  ← Document templates
│   ├── product/                    ← User-created product context
│   └── features/                   ← Feature specs (ticket-based structure)
└── src/                            ← Actual project code
```

## QA Workflow Commands

The redesigned QA workflow provides 4 modular commands that separate concerns: structure initialization, documentation gathering, and analysis.

### `/start-feature` Command
**Purpose:** Initialize feature folder structure only

**Workflow:**
1. Accept feature name as parameter or interactive prompt
2. Normalize to lowercase kebab-case format
3. Check if feature already exists (prompt for overwrite)
4. Create folder structure: `qa-agent-os/features/[feature-name]/documentation/`
5. Display success message with next steps

**Usage:** `/start-feature "Feature Name"`

**Creates:**
```
features/[feature-name]/
└── documentation/          # For BRD, API specs, mockups, technical docs
```

**Next Steps:** Run `/gather-docs` then `/analyze-requirements`

### `/start-ticket` Command
**Purpose:** Initialize ticket folder structure with smart feature detection

**Smart Features:**
- Detects existing features automatically
- If no features exist, displays error with guidance
- If single feature exists, auto-selects with confirmation
- If multiple features exist, prompts for selection

**Workflow:**
1. Accept ticket ID as parameter or interactive prompt
2. Scan for existing features in `qa-agent-os/features/`
3. Guide feature selection or creation
4. Check if ticket already exists (prompt for overwrite)
5. Create folder structure: `qa-agent-os/features/[feature-name]/[ticket-id]/documentation/`
6. Display success message with next steps

**Usage:** `/start-ticket "TICKET-123"`

**Creates:**
```
features/[feature-name]/[ticket-id]/
└── documentation/          # For ticket-specific docs, acceptance criteria, specs
```

**Next Steps:** Run `/gather-docs` then `/analyze-requirements`

### `/gather-docs` Command
**Purpose:** Display documentation gathering guidance (user-driven, no automation)

**Smart Context Detection:**
- Detects feature context from directory: `qa-agent-os/features/[feature-name]/`
- Detects ticket context from directory: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Falls back to interactive menu if context unclear

**Feature Context Guidance:**
Recommends: BRD, API specifications, UI mockups, technical architecture, database schema, feature-specific docs

**Ticket Context Guidance:**
Recommends: Ticket description, acceptance criteria, API details, screen mockups, technical notes, test data examples

**Key Feature:** No file operations performed. User manually adds documentation files to the guidance target path.

**Supports Re-execution:** Display guidance as many times as needed

**Usage:** `/gather-docs` (run from feature or ticket directory)

### `/analyze-requirements` Command
**Purpose:** Analyze gathered documentation and create knowledge/strategy/test plans based on context

**Smart Context Detection:**
- Detects feature context from directory: `qa-agent-os/features/[feature-name]/`
- Detects ticket context from directory: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Falls back to interactive menu if context unclear

**Feature Context Behavior:**
1. Validates documentation folder exists and has files
2. Checks for existing analysis documents
3. Analyzes all documentation
4. Creates `feature-knowledge.md` (8 sections: Overview, Business Rules, API Endpoints, Data Models, Edge Cases, Dependencies, Open Questions, References)
5. Creates `feature-test-strategy.md` (10 sections: Testing Approach, Tools, Environment, Test Data Strategy, Risks, Entry/Exit Criteria, Dependencies, Schedule, Resources, References)
6. Displays success message with next steps

**Re-execution:** If analysis exists, prompts with options: [1] Full re-analysis [2] Update knowledge only [3] Update strategy only [4] Cancel

**Ticket Context Behavior:**
1. Validates documentation folder exists and has files
2. Validates parent feature analysis exists
3. Checks for existing test plan
4. Analyzes all documentation
5. **Runs gap detection:** Compares ticket requirements to feature-knowledge.md
6. **ALWAYS displays explicit gap detection results when gaps found**
7. Prompts to append gaps with metadata (source ticket-id, date)
8. Creates `test-plan.md` (11 sections: Test Objective, Scope, Requirements, Test Approach, Test Environment, Test Scenarios, Test Data, Entry/Exit Criteria, Dependencies, Risks, Revision Log)
9. Offers test case generation
10. Displays success message with gap summary and next steps

**Gap Detection Visibility Requirement:**
When gaps detected:
```
GAP DETECTION RESULTS:
I found [N] gaps between ticket requirements and feature knowledge:

1. [New business rule]: [description]
2. [New API endpoint]: [description]
3. [New edge case]: [description]

Would you like me to append these gaps to feature-knowledge.md?
  [1] Yes, append all gaps
  [2] Let me review first (show detailed report)
  [3] No, skip gap updates
```

**Re-execution:** If test plan exists, prompts with options: [1] Full re-analysis [2] Append [3] Cancel

**Usage:** `/analyze-requirements` (run from feature or ticket directory)

### `/generate-testcases` Command
**Purpose:** Generate or regenerate test cases from test-plan.md (standalone, unchanged)

**Features:**
- Generate test cases if none exist
- Regenerate with smart options: [1] Overwrite [2] Append [3] Cancel
- Supports parameter `/generate-testcases [ticket-id]` or interactive selection

**When to Use:**
- After reviewing and updating test-plan.md
- After running `/revise-test-plan` updates
- Standalone from `/analyze-requirements` if you stopped for review

### `/revise-test-plan` Command
**Purpose:** Update test-plan.md during testing with change tracking

**Update Types:**
- [1] New edge case found
- [2] New test scenario needed
- [3] Existing scenario needs update
- [4] New requirement discovered
- [5] Test data needs adjustment

**Features:**
- Updates test-plan.md with revision log entries
- Increments version number
- Offers to regenerate test cases after update
- Maintains full traceability of changes

### `/update-feature-knowledge` Command
**Purpose:** Manually update feature-knowledge.md (rare - usually updated via gap detection)

**Update Types:**
- [1] Add new business rule
- [2] Add new API endpoint
- [3] Update existing information
- [4] Add edge case documentation
- [5] Add open question

## QA Workflow Patterns

### Workflow Separation: User-Driven vs AI-Driven Tasks

**User-Driven Tasks (No Automation):**
- `/start-feature` - Create structure only
- `/start-ticket` - Create structure only
- `/gather-docs` - Display guidance only (user adds files manually)

**AI-Driven Tasks (With Automation):**
- `/analyze-requirements` - Analyze documentation and create documents
- `/generate-testcases` - Generate test cases
- `/revise-test-plan` - Update plans during testing

### Feature-Level Documentation
Feature-level documents capture the "WHAT" and strategic "HOW" once:

- **feature-knowledge.md** (8 sections)
  - Consolidates business rules, APIs, edge cases from all sources
  - Referenced by all tickets in the feature
  - Updated via gap detection when tickets introduce new information

- **feature-test-strategy.md** (10 sections)
  - Defines testing approach, tools, environment, risks
  - Strategic document (not updated per-ticket)
  - Referenced in test-plan.md to avoid redundancy

### Ticket-Level Documentation
Ticket-level documents capture specific test planning:

- **test-plan.md** (11 sections)
  - Contains ticket-specific requirements, scenarios, test data
  - Inherits strategy from feature-test-strategy.md
  - Includes revision log for iterative updates during testing
  - Created by `/analyze-requirements` or updated by `/revise-test-plan`

- **test-cases.md**
  - Detailed, executable test cases
  - Generated from test-plan.md sections 6-7
  - Can be regenerated as plan evolves
  - Created by `/generate-testcases`

### Gap Detection Pattern
The intelligent requirement analysis in `/analyze-requirements` ticket context:

1. Reads ticket documentation
2. Compares to existing feature-knowledge.md
3. Identifies gaps (new rules, APIs, edge cases, data models)
4. **ALWAYS explicitly displays gap detection results when gaps found**
5. If gaps found, prompts user to append to feature-knowledge.md
6. Appends with metadata for traceability (source ticket-id, timestamp)
7. Ensures feature knowledge stays current without manual effort

## Data Flow

1. User runs `project-install.sh` → reads `config.yml`
2. Script accesses `profiles/default/` for standards, commands, templates
3. `common-functions.sh` compiles Markdown files:
   - Processes phase tags (`{{PHASE N: @qa-agent-os/...}}`)
   - Injects standards references
   - Normalizes paths
4. Output: `.claude/commands/qa-agent-os/` and `qa-agent-os/templates/`
5. AI agent uses compiled commands + product context + standards to perform tasks

## Common Development Tasks

### Adding a New Command
1. Create directory: `profiles/default/commands/[command-name]/single-agent/`
2. Create phase files (e.g., `1-step.md`, `2-step.md`) if multi-phase
3. Create orchestrator file: `[command-name].md` with phase tags: `{{PHASE 1: @qa-agent-os/commands/[command-name]/1-step.md}}`
4. Run `project-install.sh` to compile

### Adding a New Standard
1. Create file: `profiles/default/standards/[category]/[standard-name].md`
2. Run `project-install.sh` to copy into project's `qa-agent-os/standards/`
3. Reference in commands using path tags or inline content

### Adding a New Template
1. Create file: `profiles/default/templates/[template-name].md`
2. Run `project-install.sh` to copy into project's `qa-agent-os/templates/`
3. Reference in command phase files using template path or direct inclusion

### Modifying Installation Logic
Edit `scripts/project-install.sh` or `scripts/common-functions.sh`. Key functions:
- `load_configuration()` — Read config.yml
- `compile_commands()` — Process command Markdown and phase tags
- `process_phase_tags()` — Replace `{{PHASE N: @qa-agent-os/...}}` references with actual paths
- `install_templates()` — Copy templates to project

### Testing Installation Locally
```bash
# Create a test project directory
mkdir /tmp/test-project
cd /tmp/test-project
git init

# Run installation with current source
/path/to/qa-agent-os/scripts/project-install.sh --claude-code-commands true

# Verify output
ls -la .claude/commands/qa-agent-os/
ls -la qa-agent-os/templates/
ls -la qa-agent-os/standards/
```

## Key Technical Details

### AI Agent Target Support

QA Agent OS supports two primary AI agents:

**Claude Code:**
- Uses `.claude/commands/` for command definitions (Markdown)
- Uses `.claude/agents/` for multi-agent orchestration
- Supports complex, multi-step workflows with agent coordination
- Ideal for enterprise QA workflows

**Gemini 3:**
- Uses `.gemini/commands/` with `.toml` files for custom commands
- Each command is a `.toml` file with description and prompt
- Specialized personas/workflows via custom command prompts
- Leverages Gemini 3's state-of-the-art multimodal and agentic capabilities
- 1-million token context window for handling complex QA scenarios

### Phase Tags in Commands (Claude Code)
Commands use phase tags to reference sub-steps:
```markdown
# Execution Phases

Follow the numbered instruction files IN SEQUENCE:

{{PHASE 1: @qa-agent-os/commands/my-command/1-phase.md}}

{{PHASE 2: @qa-agent-os/commands/my-command/2-phase.md}}
```

The `process_phase_tags()` function replaces these with actual file paths during compilation. This allows modular command construction while maintaining clean source files.

### Custom Commands for Gemini 3
Each Gemini command is a `.toml` file that defines a specialized QA persona:
```toml
description = "Initialize feature folder structure"
prompt = """
You are a QA Architect specializing in feature planning.

Initialize a feature folder structure with:
- Feature name (normalized to lowercase kebab-case)
- Validation for existing features
- Clear guidance on next steps

Reference: @qa-agent-os/standards/features/feature-knowledge.md

Input: {{args}}
"""
```

### Standards Injection
Standards can be injected into commands two ways:
1. **File references** (default): Include path like `@qa-agent-os/standards/bugs/severity-rules.md`
2. **Direct embedding** (if skills enabled for Claude Code): Full standard content embedded in command

### YAML Configuration Parsing
`common-functions.sh` provides robust YAML parsing:
- Handles tabs and variable spacing
- Supports quoted values
- Defaults to config values if not overridden

### Template System
Templates are:
- Located in `profiles/default/templates/`
- Copied to project's `qa-agent-os/templates/` during installation
- Referenced by path in command phase files
- Can be customized by projects via `qa-agent-os/templates/` override

## Entry Points for Development

- **Modifying defaults:** Edit `config.yml`
- **Adding QA standards:** Create files in `profiles/default/standards/`
- **Creating commands:** Create files in `profiles/default/commands/`
- **Adding templates:** Create files in `profiles/default/templates/`
- **Fixing installation logic:** Edit `scripts/project-install.sh` or `scripts/common-functions.sh`
- **Creating custom profiles:** Use `scripts/create-profile.sh` or manually create `profiles/[name]/`

## Git Workflow

The project uses a feature branch approach. Key files frequently modified:
- `README.md` — User documentation
- `QA-QUICKSTART.md` — QA workflow quickstart guide
- `CHANGELOG.md` — Release notes and feature updates
- `CLAUDE.md` — This file, development guidance
- `profiles/default/` — All standard content, commands, and templates
- `scripts/` — Installation and compilation logic

Recent changes focused on implementing the QA Workflow Separation redesign with 4 modular commands that distinguish user-driven tasks from AI-driven tasks, with enhanced gap detection visibility.

## Success Metrics for QA Workflow

The modular workflow improves QA efficiency:

- **Separation of Concerns:** Structure, gathering, and analysis as separate commands
- **Planning Efficiency:** Flexible re-execution without recreating structure
- **Knowledge Currency:** Gap detection keeps feature-knowledge.md current
- **Traceability:** 100% requirement → test case mapping with gap detection metadata
- **Flexibility:** Stop/continue options, regeneration, revision tracking
- **User Experience:** Smart context detection reduces user input, helpful errors guide users
- **Explicit Gap Detection:** Users always see when gaps are detected and can make informed decisions
