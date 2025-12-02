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
- `plan-product/` — Create product mission documentation (Phase 1: gather concepts, Phase 2: create mission)
- `plan-feature/` — Plan entire feature with 4 phases: init structure, gather docs, consolidate knowledge, create test strategy
- `plan-ticket/` — Plan ticket testing with 5 phases: smart detection, init ticket, gather docs, analyze requirements with gap detection, optional test case generation
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

The redesigned QA workflow provides 5 orchestrated commands that handle the complete feature and ticket planning lifecycle:

### `/plan-feature` Command
**Purpose:** Complete feature planning in one orchestrated command (4 phases)

**Workflow:**
1. **Phase 1:** Initialize feature folder structure
2. **Phase 2:** Gather documentation (BRD, API specs, mockups, technical docs)
3. **Phase 3:** Consolidate knowledge into `feature-knowledge.md` (8 sections)
4. **Phase 4:** Create `feature-test-strategy.md` (10 sections) with testing approach

**Usage:** `/plan-feature "Feature Name"`

**Creates:**
```
features/[feature-name]/
├── documentation/          # Collected raw documents
├── feature-knowledge.md    # Consolidates WHAT is being built
└── feature-test-strategy.md # Defines HOW it will be tested
```

### `/plan-ticket` Command
**Purpose:** Plan ticket testing with intelligent feature detection and gap detection (3-5 phases)

**Smart Features:**
- **Phase 0:** Smart Detection & Routing
  - Detects existing features automatically
  - If ticket exists, offers re-execution options: [1] Full re-plan [2] Update plan only [3] Regenerate cases only [4] Cancel
  - If new ticket, auto-selects feature or prompts for selection

- **Phase 1:** Initialize Ticket Structure
- **Phase 2:** Gather Ticket Documentation
- **Phase 3:** Analyze Requirements & Detect Gaps
  - Compares ticket requirements to feature-knowledge.md
  - Identifies new rules, APIs, edge cases
  - Prompts to append gaps to feature knowledge

- **Phase 4:** Generate Test Cases (Optional)
  - After Phase 3 completes, offers: [1] Generate now [2] Stop for review
  - Flexible execution: can generate later with `/generate-testcases`

**Usage:** `/plan-ticket [ticket-id]`

**Creates:**
```
features/[feature-name]/[ticket-id]/
├── documentation/          # Ticket-specific documents
├── test-plan.md           # 11 sections with requirements, coverage, scenarios
└── test-cases.md          # Detailed executable test cases (if generated)
```

### `/generate-testcases` Command
**Purpose:** Generate or regenerate test cases from test-plan.md (standalone)

**Features:**
- Generate test cases if none exist
- Regenerate with smart options: [1] Overwrite [2] Append [3] Cancel
- Supports parameter `/generate-testcases [ticket-id]` or interactive selection

**When to Use:**
- After reviewing and updating test-plan.md
- After running `/revise-test-plan` updates
- Standalone from `/plan-ticket` if you stopped at Phase 3

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
  - Created by `/plan-ticket` or updated by `/revise-test-plan`

- **test-cases.md**
  - Detailed, executable test cases
  - Generated from test-plan.md sections 6-7
  - Can be regenerated as plan evolves
  - Created by `/plan-ticket` Phase 4 or `/generate-testcases`

### Gap Detection Pattern
The smart requirement analysis in `/plan-ticket` Phase 3:

1. Reads ticket documentation
2. Compares to existing feature-knowledge.md
3. Identifies gaps (new rules, APIs, edge cases)
4. If gaps found, prompts user to append to feature-knowledge.md
5. Appends with metadata for traceability
6. Ensures feature knowledge stays current without manual effort

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
description = "Plan feature with 4-phase workflow: structure, gather docs, consolidate knowledge, create strategy"
prompt = """
You are a Senior QA Architect specializing in feature planning.

[Reference @qa-agent-os/standards/testcases/test-case-standard.md]
[Reference @qa-agent-os/templates/feature-knowledge-template.md]

Execute the following phases:
1. Initialize feature folder structure
2. Gather documentation (BRD, API specs, mockups, technical docs)
3. Consolidate knowledge into feature-knowledge.md (8 sections)
4. Create feature-test-strategy.md (10 sections) with testing approach

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

The project uses a feature branch approach. Current branch is `update-installers`. Key files frequently modified:
- `README.md` — User documentation
- `QA-QUICKSTART.md` — QA workflow quickstart guide
- `CHANGELOG.md` — Release notes and feature updates
- `CLAUDE.md` — This file, development guidance
- `profiles/default/` — All standard content, commands, and templates
- `scripts/` — Installation and compilation logic

Recent changes focused on implementing the QA Workflow Redesign with 5 orchestrated commands, smart feature detection, gap detection, and flexible test case generation.

## Success Metrics for QA Workflow

The new workflow improves QA efficiency:

- **Command reduction:** 8 commands → 5 orchestrated commands
- **Planning efficiency:** Single `/plan-ticket` replaces 4 separate commands
- **Knowledge currency:** Gap detection keeps feature-knowledge.md current
- **Traceability:** 100% requirement → test case mapping
- **Flexibility:** Stop/continue options, regeneration, revision tracking
- **Usability:** Smart detection reduces user input, helpful errors guide users
