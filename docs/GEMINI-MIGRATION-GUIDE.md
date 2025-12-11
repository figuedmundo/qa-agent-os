# QA Agent OS Migration Guide: From Claude Code to Gemini 3

**Version:** 1.0
**Last Updated:** December 10, 2025
**Target:** Gemini 2.5 Pro/Flash and Gemini 3

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Understanding the Current Architecture](#understanding-the-current-architecture)
3. [Understanding Gemini 3 Architecture](#understanding-gemini-3-architecture)
4. [Key Differences and Constraints](#key-differences-and-constraints)
5. [Migration Strategy](#migration-strategy)
6. [Detailed Implementation Guide](#detailed-implementation-guide)
7. [Command Migration Examples](#command-migration-examples)
8. [Workflow Orchestration Patterns](#workflow-orchestration-patterns)
9. [Best Practices](#best-practices)
10. [Testing and Validation](#testing-and-validation)
11. [Troubleshooting](#troubleshooting)

---

## Executive Summary

### What This Guide Covers

This document provides a comprehensive migration path from the current **QA Agent OS architecture** designed for Claude Code (commands → agents → workflows with multi-agent orchestration) to a **Gemini 3-compatible architecture** (commands → workflows using single-agent patterns).

### Key Changes

| Aspect | Claude Code (Current) | Gemini 3 (Target) |
|--------|----------------------|-------------------|
| **Command Format** | Markdown (.md) with phase tags | TOML (.toml) with structured prompts |
| **Agent Model** | Multi-agent with `.claude/agents/` | Single-agent with embedded workflow logic |
| **Workflow Orchestration** | Phase-based delegation across agents | Sequential prompt chaining within commands |
| **Standards Injection** | File references or embedding | File references via `@{path}` syntax |
| **Context Window** | ~200K tokens (Sonnet 4.5) | 1M+ tokens (Gemini 2.5/3) |
| **Tool Use** | Claude-specific tool calling | Native function calling with thought summaries |

### Migration Timeline

- **Phase 1:** Convert command structure (1-2 weeks)
- **Phase 2:** Refactor workflows for single-agent (2-3 weeks)
- **Phase 3:** Test and validate (1 week)
- **Phase 4:** Documentation and rollout (1 week)

---

## Understanding the Current Architecture

### Current Claude Code Architecture

```
qa-agent-os/
├── profiles/default/
│   ├── commands/                    # User-facing command definitions
│   │   ├── start-feature/
│   │   │   ├── single-agent/
│   │   │   │   └── 1-initialize.md  # Phase 1 logic
│   │   │   └── start-feature.md     # Orchestrator with phase tags
│   │   ├── analyze-requirements/
│   │   │   ├── single-agent/
│   │   │   │   ├── 1-detect-context.md
│   │   │   │   ├── 2-analyze-feature.md
│   │   │   │   └── 3-analyze-ticket.md
│   │   │   └── analyze-requirements.md  # Orchestrator
│   │   └── ...
│   ├── workflows/                   # Reusable workflow definitions
│   │   ├── automation/              # Test automation workflows
│   │   │   ├── dom-exploration.md
│   │   │   ├── playwright-automation.md
│   │   │   ├── pom-generation.md
│   │   │   └── test-generation.md
│   │   ├── bug-tracking/            # Bug management workflows
│   │   │   └── bug-reporting.md
│   │   ├── planning/                # Planning workflows
│   │   │   ├── consolidate-feature-knowledge.md
│   │   │   ├── create-test-strategy.md
│   │   │   ├── gather-feature-docs.md
│   │   │   └── update-feature-knowledge.md
│   │   └── testing/                 # Testing workflows
│   │       ├── initialize-feature.md
│   │       ├── initialize-ticket.md
│   │       ├── requirement-analysis.md
│   │       ├── test-planning.md
│   │       └── testcase-generation.md
│   ├── agents/                      # Multi-agent personas (unused in single-agent mode)
│   │   ├── requirement-analyst.md
│   │   ├── testcase-writer.md
│   │   └── ...
│   ├── standards/                   # QA standards and conventions
│   │   ├── global/
│   │   ├── bugs/
│   │   ├── testcases/
│   │   └── ...
│   └── templates/                   # Document templates
│       ├── feature-knowledge-template.md
│       ├── test-plan-template.md
│       └── ...
└── scripts/
    ├── project-install.sh           # Installation engine
    ├── common-functions.sh          # Phase tag processing
    └── ...
```

### Architecture Layers: Commands → Workflows → Agents

The current architecture has **three logical layers**:

1. **Commands** (User-facing entry points)
   - What users invoke: `/start-feature`, `/analyze-requirements`, `/report-bug`
   - Orchestrate workflows and coordinate phases
   - Reference workflow definitions via phase tags

2. **Workflows** (Reusable process definitions)
   - Detailed step-by-step procedures: `initialize-feature.md`, `bug-reporting.md`
   - Category-organized: automation, bug-tracking, planning, testing
   - Referenced by multiple commands for DRY (Don't Repeat Yourself)
   - Define the "how" of each process

3. **Agents** (Multi-agent personas)
   - Specialist roles: requirement-analyst, testcase-writer, bug-reporter
   - Only used in multi-agent mode (currently unused in default single-agent config)
   - Would handle specific phases if multi-agent enabled

**Example Flow:**
```
User runs: /report-bug
   ↓
Command: profiles/default/commands/report-bug/report-bug.md
   ↓ (references)
Workflow: profiles/default/workflows/bug-tracking/bug-reporting.md
   ↓ (uses)
Standards: @qa-agent-os/standards/bugs/bug-reporting.md
   ↓ (optionally delegates to, if multi-agent enabled)
Agent: bug-reporter.md
```

### How Phase Tags Work (Claude Code)

Commands use phase tags to reference modular sub-steps:

```markdown
# /start-feature Command

Follow the numbered instruction files IN SEQUENCE:

{{PHASE 1: @qa-agent-os/commands/start-feature/1-initialize.md}}

{{PHASE 2: @qa-agent-os/commands/start-feature/2-validate.md}}
```

During compilation, `process_phase_tags()` replaces these with actual file paths:

```markdown
# /start-feature Command

Follow the numbered instruction files IN SEQUENCE:

## Phase 1: Initialize Feature Structure
[Full content of 1-initialize.md inserted here]

## Phase 2: Validate and Confirm
[Full content of 2-validate.md inserted here]
```

This approach allows:
- **Modularity:** Phases stored as separate files
- **Reusability:** Same phase used across multiple commands
- **Multi-agent orchestration:** Each phase can delegate to different agents

---

## Understanding Gemini 3 Architecture

### Gemini CLI Command Structure

Gemini CLI uses **TOML files** for custom commands, with a fundamentally different approach:

```toml
# ~/.gemini/commands/start-feature.toml

description = "Initialize feature folder structure"

# Optional: specify model per command
model = "gemini-2.5-pro"
temperature = 0.2

[permissions]
# Whitelist shell commands allowed for context gathering
allow = [
  "ls -la qa-agent-os/features/",
  "find qa-agent-os/features/ -type d -name 'documentation'",
]

[prompt]
# The main prompt body (multi-line string)
header = """
You are a QA Architect specializing in feature planning.

## Context
Current features in project:
{{exec "ls -d qa-agent-os/features/*/ 2>/dev/null | xargs -n 1 basename"}}

## Task
Initialize a new feature folder structure with the following requirements:

1. Accept feature name from {{args}} or prompt user
2. Normalize to lowercase kebab-case format
3. Check if feature already exists (list detected above)
4. Create folder structure: qa-agent-os/features/[feature-name]/documentation/
5. Display success message with next steps

## Standards Reference
Review feature organization standards:
@qa-agent-os/standards/features/folder-structures/feature-structure.md

## Output Format
Provide clear, step-by-step confirmation of actions taken.
"""

# Optional: arguments users can pass like /start-feature name="User Auth"
[args]
feature_name = { required = false, hint = "Feature name (will be normalized)" }

[render]
format = "markdown"
```

### Key Gemini CLI Concepts

#### 1. **TOML Structure**

Every command is a single `.toml` file with these sections:

- `description` — Shown in `/help` menu
- `model` (optional) — Override default model for this command
- `temperature` (optional) — Control randomness (0.0-2.0)
- `[permissions]` — Whitelist shell commands for security
- `[prompt]` — The actual prompt sent to Gemini
- `[args]` — Define optional/required parameters
- `[render]` — Output formatting (markdown, json, plain)

#### 2. **Dynamic Context Injection**

Gemini CLI provides powerful syntax for gathering context:

```toml
[prompt]
header = """
# File content injection
@{path/to/file.md}

# Directory listing (all files recursively, respecting .gitignore)
@{src/}

# Shell command execution
{{exec "git status --porcelain"}}

# User-provided arguments
User input: {{args}}
"""
```

#### 3. **Command Namespacing**

File paths create command hierarchy:

```
.gemini/commands/
├── start-feature.toml           → /start-feature
├── analyze-requirements.toml    → /analyze-requirements
└── qa/
    ├── report-bug.toml          → /qa:report-bug
    └── revise-bug.toml          → /qa:revise-bug
```

#### 4. **Global vs Project Commands**

- **Global:** `~/.gemini/commands/` — Available everywhere
- **Project:** `<project>/.gemini/commands/` — Project-specific, version-controlled

---

## Key Differences and Constraints

### 1. Architecture Layers

**Claude Code: Three-Layer Architecture**
```
Commands (user entry points)
   ↓
Workflows (reusable process definitions)
   ↓
Agents (specialist personas for multi-agent mode)
```

**Gemini 3: Two-Layer Architecture**
```
Commands (user entry points with embedded workflows)
   ↓
Standards (referenced documents)
```

**Key Difference:** Gemini doesn't have native workflow or agent layers. These must be:
- **Workflows:** Either embedded in commands or referenced as external markdown files
- **Agents:** Simulated through persona prompting within commands

### 2. Single-Agent Architecture

**Claude Code:**
- Multi-agent orchestration via `.claude/agents/`
- Phases can delegate to specialized agents (e.g., "requirement-analyst", "testcase-writer")
- Agent coordination managed by Claude Code runtime
- Workflows can invoke different agents for different steps

**Gemini 3:**
- Single-agent model (no delegation framework)
- All workflow logic embedded in command prompt or referenced as files
- Agent-like behavior achieved through:
  - **Persona prompting** — Simulate specialist roles in prompt header
  - **Sequential reasoning** — Explicit step-by-step workflow instructions
  - **Thought summaries** — Gemini's native reasoning transparency

**Migration Impact:**
- Phase-based workflows must be consolidated into single, comprehensive prompts
- Multi-agent delegation converted to sequential steps with role descriptions
- Workflow files become reusable markdown libraries referenced by commands

### 3. Workflow Orchestration

**Claude Code:**
```markdown
{{PHASE 1: @qa-agent-os/commands/analyze-requirements/1-detect-context.md}}
↓
{{PHASE 2: @qa-agent-os/commands/analyze-requirements/2-analyze-feature.md}}
↓
{{PHASE 3: @qa-agent-os/commands/analyze-requirements/3-analyze-ticket.md}}
```

**Gemini 3:**
```toml
[prompt]
header = """
## Workflow: Requirement Analysis
Execute the following workflow IN SEQUENCE:

### Step 1: Context Detection
- Scan current directory for qa-agent-os/features/ structure
- Determine if running from feature or ticket context
- Load relevant documentation

### Step 2: Feature Analysis (if feature context)
- Read all files in documentation/ folder
- Create feature-knowledge.md (8 sections)
- Create feature-test-strategy.md (10 sections)

### Step 3: Ticket Analysis (if ticket context)
- Read ticket documentation
- Run gap detection against feature-knowledge.md
- Create test-plan.md (11 sections)
- Offer test case generation

## Standards
@qa-agent-os/standards/requirement-analysis/brd-analysis.md
@qa-agent-os/standards/testcases/test-plan-structure.md
"""
```

**Key Pattern:** Replace phase delegation with explicit sequential instructions.

### 4. Context Window Advantages

Gemini 3's 1M+ token context window enables:

- **Massive documentation ingestion** — Entire feature docs in single prompt
- **Full standards embedding** — No need for summarization
- **Rich examples** — Include complete template examples
- **Multi-file analysis** — Process multiple test plans simultaneously

**Migration Opportunity:** Simplify commands by embedding full context instead of piecemeal loading.

### 5. Tool Use and Function Calling

**Claude Code:**
- Uses Claude-specific tool definitions
- Limited shell command execution
- File operations through Claude tools

**Gemini 3:**
- Native function calling with thought summaries
- Direct shell command execution via `{{exec "..."}}`
- File reading via `@{path}` syntax
- More permissive shell access (requires explicit whitelisting)

**Security Note:** Always whitelist specific commands in `[permissions]` section.

---

## Migration Strategy

### Overview

The migration follows a **4-phase approach**:

1. **Command Structure Conversion** — Markdown → TOML
2. **Workflow Consolidation** — Multi-phase → Single-prompt
3. **Standards Integration** — Embedding vs references
4. **Testing and Validation** — Ensure functional equivalence

### Phase 1: Command Structure Conversion

**Goal:** Convert each `.md` command to `.toml` format.

**Process:**

1. Identify all commands in `profiles/default/commands/`
2. For each command:
   - Extract command name (e.g., `start-feature.md` → `start-feature.toml`)
   - Analyze phase structure (if multi-phase)
   - Identify required permissions (shell commands, file access)
   - Map arguments and parameters
3. Create corresponding `.toml` file in `.gemini/commands/`

**Example Mapping:**

```
Claude Code:
profiles/default/commands/start-feature/
├── single-agent/
│   └── 1-initialize.md
└── start-feature.md

Gemini 3:
.gemini/commands/
└── start-feature.toml (consolidated)
```

### Phase 2: Workflow Consolidation

**Goal:** Combine multi-phase logic into single, coherent prompts.

**Strategies:**

#### A. Linear Workflows → Sequential Instructions

For commands with clear sequential phases:

```toml
[prompt]
header = """
Execute this workflow IN ORDER:

## Step 1: [Phase 1 purpose]
[Instructions from phase 1]

## Step 2: [Phase 2 purpose]
[Instructions from phase 2]

## Step 3: [Phase 3 purpose]
[Instructions from phase 3]
"""
```

#### B. Branching Workflows → Conditional Logic

For commands with context-dependent paths:

```toml
[prompt]
header = """
## Context Detection
Analyze current directory structure to determine context.

## Conditional Execution

### IF feature context detected:
  1. [Feature-specific steps]
  2. [...]

### ELSE IF ticket context detected:
  1. [Ticket-specific steps]
  2. [...]

### ELSE:
  - Display error with guidance
"""
```

#### C. Complex Workflows → Explicit State Management

For commands requiring intermediate results:

```toml
[prompt]
header = """
## Workflow State Tracking

### Phase 1: Data Collection
Collect the following information and store in memory:
- Feature name
- Existing features list
- Documentation file count

### Phase 2: Validation
Using collected data from Phase 1:
- Validate feature name format
- Check for duplicates

### Phase 3: Execution
Using validated data:
- Create folder structure
- Display confirmation
"""
```

### Phase 2.5: Workflow Consolidation Strategies

**Goal:** Migrate reusable workflow definitions to Gemini-compatible patterns.

Since Gemini doesn't have a native workflow layer like Claude Code, you have **three migration strategies**:

#### Strategy A: Embed Workflows Directly in Commands (Recommended for Simple Workflows)

For workflows used by only one command, embed the workflow logic directly:

```toml
# .gemini/commands/start-feature.toml

[prompt]
header = """
# Feature Initializer

## Workflow (embedded from workflows/testing/initialize-feature.md)

### Step 1: Normalize Feature Name
- Convert to lowercase
- Replace spaces with hyphens
- Remove special characters
Example: "User Authentication" → "user-authentication"

### Step 2: Create Directory Structure
Create: qa-agent-os/features/[normalized-name]/documentation/

### Step 3: Generate README
[README template content]

### Step 4: Confirm Success
Display: "Feature initialized. Next: /gather-docs"
"""
```

**Pros:** Simple, self-contained
**Cons:** Duplication if workflow used by multiple commands

#### Strategy B: Create Shared Workflow Library (Recommended for Reusable Workflows)

For workflows referenced by multiple commands, create a shared library:

**Directory Structure:**
```
.gemini/
├── commands/
│   ├── start-feature.toml
│   └── report-bug.toml
└── workflows/                      # Shared workflow definitions
    ├── initialize-feature.md       # Workflow as markdown for reference
    ├── bug-reporting.md
    └── test-planning.md
```

**In Commands, Reference via File Injection:**
```toml
# .gemini/commands/start-feature.toml

[prompt]
header = """
# Feature Initializer

## Workflow
Execute the following workflow from shared library:

@{.gemini/workflows/initialize-feature.md}

## User Input
{{args}}
"""
```

**Pros:** DRY principle maintained, easy to update workflows
**Cons:** Requires workflow files to exist, slightly more complex setup

#### Strategy C: Create Workflow TOML Fragments (Advanced)

For highly reusable workflow sections, create TOML fragments that can be included:

**Not Natively Supported by Gemini CLI** - Would require custom preprocessing script.

**Alternative: Use Comments for Documentation**
```toml
# This command implements workflow: workflows/testing/initialize-feature.md
# Last synced: 2025-12-10
# Workflow steps embedded below:

[prompt]
header = """
# Step 1: Normalize (from workflow)
[...]

# Step 2: Create Structure (from workflow)
[...]
"""
```

**Recommendation Table:**

| Workflow Characteristic | Recommended Strategy |
|------------------------|---------------------|
| Used by single command only | **Strategy A** (Embed) |
| Used by 2-3 commands | **Strategy B** (Shared Library) |
| Used by 4+ commands | **Strategy B** (Shared Library) |
| Frequently updated | **Strategy B** (Shared Library) |
| Simple, rarely changes | **Strategy A** (Embed) |

### Phase 3: Standards Integration

**Goal:** Ensure standards are accessible within Gemini commands.

**Options:**

#### Option A: File References (Recommended)

Use Gemini's `@{path}` syntax to inject standard content:

```toml
[prompt]
header = """
## Standards

### Bug Reporting Standards
@qa-agent-os/standards/bugs/bug-reporting.md

### Test Case Standards
@qa-agent-os/standards/testcases/test-case-structure.md

## Task
[Command-specific instructions]
"""
```

**Pros:**
- Keeps commands clean and maintainable
- Standards can be updated independently
- Reduces command file size

**Cons:**
- Requires standards files to exist in project
- Slightly slower (file read at runtime)

#### Option B: Embedded Standards (For Critical Commands)

Directly embed key standards in command:

```toml
[prompt]
header = """
## Bug Severity Definitions (Embedded)

CRITICAL: System crash, data loss, security breach
HIGH: Major feature broken, no workaround
MEDIUM: Feature impaired, workaround available
LOW: Minor issue, cosmetic

## Task
[Command instructions using above standards]
"""
```

**Pros:**
- Faster execution (no file reads)
- Self-contained commands
- Works even if standards files missing

**Cons:**
- Duplication across commands
- Harder to maintain consistency
- Larger command files

**Recommendation:** Use **Option A** (file references) for most commands, **Option B** only for frequently used commands where performance is critical.

### Phase 4: Testing and Validation

**Goal:** Ensure migrated commands work equivalently to Claude Code versions.

**Test Plan:**

1. **Unit Testing** — Test each command individually
2. **Integration Testing** — Test command sequences (e.g., start-feature → gather-docs → analyze-requirements)
3. **Regression Testing** — Compare outputs between Claude Code and Gemini versions
4. **Performance Testing** — Measure command execution time and token usage

---

## Detailed Implementation Guide

### Step-by-Step Migration Process

#### Step 1: Set Up Gemini Command Structure

Create the base directory structure:

```bash
cd /path/to/project

# Create Gemini commands directory
mkdir -p .gemini/commands

# Optionally create namespaced subdirectories
mkdir -p .gemini/commands/qa
mkdir -p .gemini/commands/test
```

#### Step 2: Configure `config.yml` for Gemini

Update your `config.yml` to target Gemini:

```yaml
# AI Agent Target
ai_agent: gemini  # Changed from 'claude-code'

# Agent Mode
agent_mode: single-agent  # Gemini is single-agent only

# Profile
profile: default

# Output Paths
output:
  commands: .gemini/commands
  standards: qa-agent-os/standards
  templates: qa-agent-os/templates

# Gemini-specific settings
gemini:
  default_model: gemini-2.5-pro
  temperature: 0.2
  use_thought_summaries: true
```

#### Step 3: Create Command Conversion Template

Use this template for converting each command:

```toml
# .gemini/commands/[command-name].toml

description = "[One-line description from original .md file]"

# Optional: override default model
# model = "gemini-2.5-flash"  # Use for faster, less complex commands
# model = "gemini-2.5-pro"    # Use for complex analysis

# Optional: adjust creativity
# temperature = 0.0  # Deterministic output
# temperature = 0.2  # Slightly creative (good for QA tasks)
# temperature = 1.0  # More creative (good for brainstorming)

[permissions]
# List all shell commands this command needs to execute
allow = [
  # Examples:
  # "ls -la qa-agent-os/features/",
  # "git status --porcelain",
  # "find qa-agent-os/features/ -name '*.md'",
]

[prompt]
header = """
# [Command Name]

## Role
You are a [Specialist Role] in the QA Agent OS system.

## Context
[Gather necessary context using:]
- {{exec "shell-command"}} for dynamic data
- @{path/to/file} for file content
- @{directory/} for directory listings

## Workflow
Execute the following steps IN SEQUENCE:

### Step 1: [Phase 1 Name]
[Detailed instructions from original phase 1]

### Step 2: [Phase 2 Name]
[Detailed instructions from original phase 2]

### Step 3: [Phase 3 Name]
[Detailed instructions from original phase 3]

## Standards Reference
[Include relevant standards:]
@qa-agent-os/standards/[category]/[standard-name].md

## Output Format
[Specify expected output format]

## User Input
{{args}}
"""

[args]
# Define parameters if command accepts arguments
# param_name = { required = false, hint = "Description" }

[render]
format = "markdown"
```

#### Step 4: Migrate Each Command

For each command in `profiles/default/commands/`, follow these steps:

##### Example: Migrating `/start-feature`

**Original Claude Code Command:**

`profiles/default/commands/start-feature/start-feature.md`:
```markdown
# /start-feature Command

{{PHASE 1: @qa-agent-os/commands/start-feature/1-initialize.md}}
```

`profiles/default/commands/start-feature/single-agent/1-initialize.md`:
```markdown
# Initialize Feature Structure

1. Accept feature name as parameter or prompt user
2. Normalize to lowercase kebab-case
3. Check if feature exists
4. Create: qa-agent-os/features/[feature-name]/documentation/
5. Display success message
```

**Migrated Gemini Command:**

`.gemini/commands/start-feature.toml`:
```toml
description = "Initialize feature folder structure"

model = "gemini-2.5-flash"  # Simple task, use faster model
temperature = 0.0            # Deterministic output

[permissions]
allow = [
  "ls -d qa-agent-os/features/*/",
  "mkdir -p qa-agent-os/features/*/documentation",
]

[prompt]
header = """
# Feature Structure Initializer

## Role
You are a QA Architect specializing in feature planning and organization.

## Context: Existing Features
{{exec "ls -d qa-agent-os/features/*/ 2>/dev/null | sed 's|qa-agent-os/features/||g' | sed 's|/||g'"}}

## Task
Initialize a new feature folder structure following these steps:

### Step 1: Get Feature Name
- If {{args}} is provided, use it as feature name
- If {{args}} is empty, prompt user: "Enter feature name:"
- Feature name example: "User Authentication" or "Payment Gateway"

### Step 2: Normalize Feature Name
- Convert to lowercase
- Replace spaces with hyphens
- Remove special characters (keep only a-z, 0-9, -)
- Example: "User Authentication" → "user-authentication"

### Step 3: Validate
- Check against existing features list above
- If feature exists, ask: "Feature already exists. Overwrite? [y/N]"
- If no, abort with message
- If yes or new feature, proceed

### Step 4: Create Structure
Create the following folder:
```
qa-agent-os/features/[normalized-feature-name]/documentation/
```

### Step 5: Confirm Success
Display message:
```
✓ Feature '[feature-name]' initialized successfully

Structure created:
  qa-agent-os/features/[feature-name]/
  └── documentation/

Next steps:
  1. Run /gather-docs to see documentation gathering guidance
  2. Add documentation files to the documentation/ folder
  3. Run /analyze-requirements when ready to analyze
```

## Standards Reference
@qa-agent-os/standards/features/folder-structures/feature-structure.md

## Important Rules
- ALWAYS normalize feature names to kebab-case
- NEVER overwrite existing features without confirmation
- ALWAYS show clear next steps

## User Input
{{args}}
"""

[args]
feature_name = { required = false, hint = "Feature name (e.g., 'User Authentication')" }

[render]
format = "markdown"
```

##### Example: Migrating `/analyze-requirements`

**Original Claude Code Command (Multi-Phase):**

`profiles/default/commands/analyze-requirements/analyze-requirements.md`:
```markdown
{{PHASE 1: @qa-agent-os/commands/analyze-requirements/1-detect-context.md}}
{{PHASE 2: @qa-agent-os/commands/analyze-requirements/2-analyze-feature.md}}
{{PHASE 3: @qa-agent-os/commands/analyze-requirements/3-analyze-ticket.md}}
```

**Migrated Gemini Command (Consolidated):**

`.gemini/commands/analyze-requirements.toml`:
```toml
description = "Analyze gathered documentation and create knowledge/strategy/test plans"

model = "gemini-2.5-pro"  # Complex analysis requires Pro model
temperature = 0.2

[permissions]
allow = [
  "pwd",
  "ls -la qa-agent-os/features/*/documentation/",
  "find qa-agent-os/features/ -name 'feature-knowledge.md'",
  "find qa-agent-os/features/ -name 'test-plan.md'",
]

[prompt]
header = """
# Requirement Analyzer

## Role
You are a Senior QA Requirements Analyst specializing in BRD analysis, test strategy development, and comprehensive test planning.

## Workflow: Execute ALL Steps in Sequence

### Step 1: Context Detection

#### 1A. Determine Current Context
Detect context based on current directory structure:

```bash
Current directory: {{exec "pwd"}}
```

**Context Rules:**
- **Feature context:** Path matches `qa-agent-os/features/[feature-name]/` (no ticket subdirectory)
- **Ticket context:** Path matches `qa-agent-os/features/[feature-name]/[TICKET-ID]/`
- **Unclear:** Neither pattern matches

If unclear, present interactive menu:
```
Unable to auto-detect context. Please select:
  [1] Feature-level analysis
  [2] Ticket-level analysis
  [3] Cancel
```

#### 1B. Validate Documentation Exists
Based on detected context:
- Feature: Check `qa-agent-os/features/[feature-name]/documentation/`
- Ticket: Check `qa-agent-os/features/[feature-name]/[TICKET-ID]/documentation/`

List found documentation files:
```bash
{{exec "find [context-path]/documentation/ -type f 2>/dev/null"}}
```

If empty, display error:
```
ERROR: No documentation found in [path]/documentation/

Please run /gather-docs first to see what documentation to add.
```

### Step 2: Feature-Level Analysis (Execute if Feature Context)

#### 2A. Check for Existing Analysis
Look for existing documents:
- `feature-knowledge.md`
- `feature-test-strategy.md`

If found, prompt user:
```
Existing analysis documents found. Select action:
  [1] Full re-analysis (overwrites existing documents)
  [2] Update feature-knowledge.md only
  [3] Update feature-test-strategy.md only
  [4] Cancel
```

#### 2B. Read All Documentation
Ingest all files from documentation folder:

```
@{qa-agent-os/features/[feature-name]/documentation/}
```

#### 2C. Create feature-knowledge.md
Generate comprehensive feature knowledge document with 8 sections:

**Template Reference:**
@qa-agent-os/templates/feature-knowledge-template.md

**Standards Reference:**
@qa-agent-os/standards/requirement-analysis/brd-analysis.md

**Required Sections:**
1. **Feature Overview** — Purpose, goals, scope
2. **Business Rules** — All validation rules, constraints
3. **API Endpoints** — All endpoints with methods, params, responses
4. **Data Models** — Database schemas, field definitions
5. **Edge Cases** — Boundary conditions, error scenarios
6. **Dependencies** — External systems, integrations
7. **Open Questions** — Unresolved ambiguities
8. **References** — Source documents

**Output:** Write to `qa-agent-os/features/[feature-name]/feature-knowledge.md`

#### 2D. Create feature-test-strategy.md
Generate strategic testing approach with 10 sections:

**Template Reference:**
@qa-agent-os/templates/feature-test-strategy-template.md

**Required Sections:**
1. **Testing Approach** — Overall strategy
2. **Tools and Frameworks** — Testing stack
3. **Test Environment** — Environment setup
4. **Test Data Strategy** — Data management approach
5. **Risks and Mitigations** — Testing risks
6. **Entry/Exit Criteria** — When to start/stop testing
7. **Test Dependencies** — Prerequisites
8. **Testing Schedule** — High-level timeline
9. **Resource Requirements** — Team, tools, time
10. **References** — Linked documents

**Output:** Write to `qa-agent-os/features/[feature-name]/feature-test-strategy.md`

#### 2E. Display Success Message
```
✓ Feature analysis completed successfully

Documents created:
  - feature-knowledge.md (8 sections)
  - feature-test-strategy.md (10 sections)

Next steps:
  1. Review generated documents for accuracy
  2. Run /start-ticket [TICKET-ID] to begin ticket-level planning
```

### Step 3: Ticket-Level Analysis (Execute if Ticket Context)

#### 3A. Validate Parent Feature Analysis
Check for parent feature documents:

```bash
{{exec "ls qa-agent-os/features/[feature-name]/feature-knowledge.md 2>/dev/null"}}
{{exec "ls qa-agent-os/features/[feature-name]/feature-test-strategy.md 2>/dev/null"}}
```

If missing, display error:
```
ERROR: Parent feature analysis not found

You must run /analyze-requirements at feature level first:
  1. cd qa-agent-os/features/[feature-name]/
  2. /analyze-requirements
```

#### 3B. Check for Existing Test Plan
Look for: `test-plan.md`

If found, prompt user:
```
Existing test plan found. Select action:
  [1] Full re-analysis (overwrites test plan)
  [2] Append new scenarios (preserves existing, adds new)
  [3] Cancel
```

#### 3C. Read All Ticket Documentation
Ingest ticket-specific documentation:

```
@{qa-agent-os/features/[feature-name]/[TICKET-ID]/documentation/}
```

#### 3D. Run Gap Detection
**CRITICAL:** Always run gap detection and display results explicitly.

**Process:**
1. Load parent feature knowledge:
   ```
   @{qa-agent-os/features/[feature-name]/feature-knowledge.md}
   ```

2. Compare ticket documentation against feature knowledge

3. Identify gaps in these categories:
   - New business rules not in feature-knowledge.md
   - New API endpoints not documented
   - New edge cases discovered
   - New data model fields
   - New dependencies

4. **Display gap detection results:**

```
GAP DETECTION RESULTS:
I found [N] gaps between ticket requirements and feature knowledge:

1. [Category]: [Description]
   Source: [Ticket doc reference]

2. [Category]: [Description]
   Source: [Ticket doc reference]

[etc.]

Would you like me to append these gaps to feature-knowledge.md?
  [1] Yes, append all gaps with metadata
  [2] Show detailed gap report first
  [3] No, skip gap updates
```

#### 3E. Append Gaps to Feature Knowledge (If User Selects Yes)
For each gap:

1. Identify appropriate section in feature-knowledge.md
2. Append gap with metadata:

```markdown
### [Gap Title]
[Gap description]

**Source:** Ticket [TICKET-ID] (detected [YYYY-MM-DD])
```

3. Confirm update:
```
✓ Updated feature-knowledge.md with [N] gaps
```

#### 3F. Create test-plan.md
Generate ticket-specific test plan with 11 sections:

**Template Reference:**
@qa-agent-os/templates/test-plan-template.md

**Standards Reference:**
@qa-agent-os/standards/testcases/test-plan-structure.md

**Required Sections:**
1. **Test Objective** — What we're testing and why
2. **Scope** — In-scope and out-of-scope
3. **Requirements Traceability** — Map ticket requirements to test scenarios
4. **Test Approach** — Inherit from feature-test-strategy.md
5. **Test Environment** — Specific environment needs
6. **Test Scenarios** — High-level scenarios (used for test case generation)
7. **Test Data** — Specific data needed for this ticket
8. **Entry/Exit Criteria** — Ticket-specific criteria
9. **Dependencies** — Prerequisites for testing
10. **Risks and Mitigations** — Ticket-specific risks
11. **Revision Log** — Version tracking

**Output:** Write to `qa-agent-os/features/[feature-name]/[TICKET-ID]/test-plan.md`

#### 3G. Offer Test Case Generation
After creating test-plan.md, prompt:

```
Test plan created successfully.

Would you like to generate test cases now?
  [1] Yes, generate test-cases.md from test plan
  [2] No, I'll review test plan first

(You can always run /generate-testcases later)
```

If user selects Yes, proceed to generate test cases.

#### 3H. Display Success Message
```
✓ Ticket analysis completed successfully

[If gaps found:]
Gap detection: [N] gaps found and appended to feature-knowledge.md

Documents created:
  - test-plan.md (11 sections)
  [- test-cases.md (if generated)]

Next steps:
  1. Review test-plan.md for accuracy
  2. Run /generate-testcases if not generated
  3. Run /revise-test-plan during testing to update
```

## Standards
@qa-agent-os/standards/requirement-analysis/brd-analysis.md
@qa-agent-os/standards/requirement-analysis/acceptance-criteria.md
@qa-agent-os/standards/testcases/test-plan-structure.md
@qa-agent-os/standards/features/folder-structures/

## Critical Rules
- ALWAYS explicitly display gap detection results when gaps found
- NEVER skip gap detection in ticket context
- ALWAYS append gaps with metadata (source ticket-id, date)
- ALWAYS offer test case generation after test plan creation
- NEVER overwrite existing documents without user confirmation

## User Input
{{args}}
"""

[render]
format = "markdown"
```

#### Step 5: Update Installation Script

Modify `scripts/project-install.sh` to support Gemini:

```bash
#!/bin/bash

# Load configuration
source "$(dirname "$0")/common-functions.sh"
load_configuration

# Determine AI agent
AI_AGENT=$(get_config "ai_agent" "claude-code")

if [ "$AI_AGENT" == "gemini" ]; then
    echo "Installing QA Agent OS for Gemini CLI..."

    # Create Gemini command directory
    mkdir -p .gemini/commands

    # Convert and install commands
    compile_gemini_commands

    # Install standards and templates (same for both)
    install_standards
    install_templates

    echo "✓ Installation complete for Gemini CLI"
    echo ""
    echo "Commands installed to: .gemini/commands/"
    echo "Run 'gemini' and type /help to see available commands"

elif [ "$AI_AGENT" == "claude-code" ]; then
    echo "Installing QA Agent OS for Claude Code..."
    # Existing Claude Code installation logic
    compile_claude_commands
    install_standards
    install_templates
    echo "✓ Installation complete for Claude Code"
else
    echo "ERROR: Unknown AI agent '$AI_AGENT' in config.yml"
    exit 1
fi
```

Create new function in `scripts/common-functions.sh`:

```bash
# Compile Gemini TOML commands from profile
compile_gemini_commands() {
    local profile_commands="$PROFILE_DIR/commands"
    local output_dir=".gemini/commands"

    echo "Compiling Gemini commands from profile..."

    # Iterate through all command directories
    find "$profile_commands" -name "*.toml" | while read -r toml_file; do
        local cmd_name=$(basename "$toml_file")
        local output_file="$output_dir/$cmd_name"

        echo "  - Processing $cmd_name..."

        # Copy TOML file to output directory
        cp "$toml_file" "$output_file"

        # Process path references (e.g., @qa-agent-os/standards/...)
        # Replace with actual paths relative to project root
        sed -i.bak 's|@qa-agent-os/|qa-agent-os/|g' "$output_file"
        rm "$output_file.bak"
    done

    echo "✓ Gemini commands compiled to $output_dir"
}
```

---

## Command Migration Examples

### Example 1: Simple Command (start-feature)

See detailed example in Step 4 above.

**Complexity:** Low
**Migration Time:** ~30 minutes
**Key Changes:**
- Single phase → Single TOML prompt
- Shell commands for context gathering
- User prompts embedded in workflow

---

### Example 2: Complex Command (analyze-requirements)

See detailed example in Step 4 above.

**Complexity:** High
**Migration Time:** ~2-3 hours
**Key Changes:**
- Multi-phase → Sequential workflow steps
- Conditional branching for feature vs ticket context
- Gap detection logic embedded in prompt
- Multiple template and standard references

---

### Example 3: Bug Reporting Command (report-bug)

**Original Claude Code (Simplified):**

```markdown
# /report-bug

{{PHASE 1: detect-feature-context.md}}
{{PHASE 2: generate-bug-id.md}}
{{PHASE 3: collect-bug-details.md}}
{{PHASE 4: create-bug-report.md}}
```

**Migrated Gemini:**

`.gemini/commands/qa/report-bug.toml`:

```toml
description = "Create feature-level bug with auto-incremented ID and organized evidence"

model = "gemini-2.5-pro"
temperature = 0.1

[permissions]
allow = [
  "pwd",
  "find qa-agent-os/features/*/bugs/ -name 'BUG-*' -type d",
  "mkdir -p qa-agent-os/features/*/bugs/BUG-*/",
]

[prompt]
header = """
# Bug Reporter

## Role
You are a QA Bug Analyst specializing in comprehensive bug documentation and evidence organization.

## Workflow

### Step 1: Detect Feature Context
Analyze current directory:
```bash
{{exec "pwd"}}
```

**Context Detection Rules:**
- If path contains `qa-agent-os/features/[feature-name]/`, extract feature name
- If unclear, list available features and prompt user:

```bash
Available features:
{{exec "ls -d qa-agent-os/features/*/ 2>/dev/null | xargs -n 1 basename"}}

Select feature for bug report:
```

### Step 2: Generate Next Bug ID
Scan for existing bugs in feature:

```bash
{{exec "find qa-agent-os/features/[feature-name]/bugs/ -maxdepth 1 -name 'BUG-*' -type d 2>/dev/null | sort"}}
```

**ID Generation Logic:**
- If no bugs exist, start with BUG-001
- If bugs exist, find highest number and increment
- Example: BUG-003 exists → Next is BUG-004

### Step 3: Collect Bug Details
Gather information from user (use {{args}} if provided):

**Required Fields:**
1. **Title** — Brief, descriptive title
   - Example: "Login fails with special characters in password"
   - Auto-generated folder: BUG-XXX-[title-kebab-case]

2. **Description** — Detailed bug description
   - Steps to reproduce
   - Expected vs actual behavior
   - Impact on functionality

3. **Severity** — Use standard definitions:
   ```
   @qa-agent-os/standards/bugs/severity-rules.md
   ```
   Prompt: Select severity: [1] CRITICAL [2] HIGH [3] MEDIUM [4] LOW

4. **Environment** — Where bug occurs
   - Browser/device
   - OS version
   - App version
   - Test environment

5. **Evidence** — Categorize by type:
   - Screenshots (.png, .jpg)
   - Logs (.log, .txt)
   - Videos (.mp4, .mov)
   - Other artifacts

6. **Ticket Reference** (Optional) — Related ticket IDs
   - Example: "TICKET-123, TICKET-124"
   - Leave empty if not ticket-specific

7. **Jira ID** (Optional) — External tracking
   - Example: "PROJ-456"

### Step 4: Create Bug Report Structure
Create the following folder structure:

```
qa-agent-os/features/[feature-name]/bugs/BUG-XXX-[title]/
├── bug-report.md
├── screenshots/
├── logs/
├── videos/
└── artifacts/
```

### Step 5: Generate bug-report.md
Use this template structure:

**Template Reference:**
@qa-agent-os/standards/bugs/bug-reporting.md

**Content:**
```markdown
# Bug Report: BUG-XXX - [Title]

## Status
OPEN

## Bug Details

**Bug ID:** BUG-XXX
**Title:** [Title]
**Severity:** [CRITICAL|HIGH|MEDIUM|LOW]
**Reported:** [YYYY-MM-DD]
**Ticket:** [TICKET-ID or "N/A"]
**Jira ID:** [JIRA-ID or "N/A"]

## Description
[Detailed description with steps to reproduce]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
[Environment details]

## Evidence

### Screenshots
[List files in screenshots/ folder or "None"]

### Logs
[List files in logs/ folder or "None"]

### Videos
[List files in videos/ folder or "None"]

### Additional Artifacts
[List files in artifacts/ folder or "None"]

## Revision Log

### Version 1.0 (Initial Report)
- **Date:** [YYYY-MM-DD]
- **Type:** Initial bug report
- **Description:** Bug reported and documented
```

### Step 6: Display Success Message
```
✓ Bug BUG-XXX created successfully

Structure created:
  qa-agent-os/features/[feature-name]/bugs/BUG-XXX-[title]/
  ├── bug-report.md
  ├── screenshots/
  ├── logs/
  ├── videos/
  └── artifacts/

Next steps:
  1. Add evidence files to appropriate subfolders
  2. Run /revise-bug to update severity, status, or add more evidence
  3. Reference this bug in test-cases.md Defects field
```

## Standards
@qa-agent-os/standards/bugs/bug-reporting.md
@qa-agent-os/standards/bugs/severity-rules.md

## Critical Rules
- ALWAYS auto-increment bug IDs (never reuse)
- ALWAYS organize evidence into semantic subfolders
- ALWAYS include revision log in bug-report.md
- NEVER overwrite existing bugs without explicit user confirmation

## User Input
{{args}}
"""

[args]
bug_details = { required = false, hint = "Bug title or full details" }

[render]
format = "markdown"
```

---

### Example 4: Migrating Reusable Workflows

**Original Claude Code Workflow:**

`profiles/default/workflows/bug-tracking/bug-reporting.md`:

```markdown
# Bug Reporting Workflow

## Workflow Steps

### Step 1: Read Bug Reporting Standard
Read: @qa-agent-os/standards/bugs/bug-reporting.md

### Step 2: Collect Bug Information
- Title, Summary, Environment, Component
- Reproduction steps
- Evidence (screenshots, logs, etc.)

### Step 3: Classify Severity
Apply AI classification checklist:
- Check S1 (Critical) indicators
- Check S2 (Major) indicators
- Check S3 (Minor) indicators
- Default to S4 (Trivial)

### Step 4: Perform Bug Analysis
- Reproduction analysis
- Cause isolation
- Scope determination

### Step 5: Generate Bug Report
Create: [ticket-path]/bugs/BUG-[auto-increment].md

### Step 6: Completion
Display confirmation message
```

**This workflow is referenced by `/report-bug` command:**

`profiles/default/commands/report-bug/report-bug.md`:
```markdown
# /report-bug Command

{{PHASE 1: @qa-agent-os/workflows/bug-tracking/bug-reporting.md}}
```

**Gemini Migration - Strategy B (Shared Workflow Library):**

**Step 1: Create Workflow Library**

`.gemini/workflows/bug-reporting.md`:
```markdown
# Bug Reporting Workflow

Execute the following steps IN SEQUENCE:

## Step 1: Read Bug Reporting Standard
Reference standard for structure, severity rules, and analysis methodology:
@qa-agent-os/standards/bugs/bug-reporting.md

## Step 2: Collect Bug Information

Gather from user or {{args}}:

**Bug Details:**
- Title (format: `[Component] - [Brief Summary]`)
- Summary (2-3 sentence executive overview)
- Environment (OS, browser, version, feature flags)
- Component/Area

**Reproduction:**
- Preconditions
- Steps to reproduce (numbered, specific)
- Expected result vs Actual result
- Reproducibility (Always/Intermittent)

**Evidence:**
- Screenshots/recordings (for UI issues)
- Console/browser logs
- API request/response traces
- Error messages

## Step 3: Classify Severity Using AI Checklist

**S1 (Critical) Indicators:**
- Data loss/corruption?
- Security vulnerability?
- System crash/unavailability?
- Payment processing broken?
If YES → Suggest S1

**S2 (Major) Indicators:**
- Core feature completely broken?
- Incorrect calculations/data?
If YES → Suggest S2

**S3 (Minor) Indicators:**
- UI/layout issues?
- Easy workaround available?
If YES → Suggest S3

**S4 (Trivial):** Default if none above match

**Present to User:**
```
AI Severity Suggestion: [S1/S2/S3/S4]

Justification: [reasoning based on checklist]

Accept or override?
  [1] Accept
  [2] Override to different severity
```

## Step 4: Perform Bug Analysis

**Reproduction Analysis:**
- Can you reproduce with provided steps?
- Reproducibility rate?

**Cause Isolation:**
- Which component responsible?
- Frontend/backend/data issue?

**Scope Determination:**
- All users or specific segments?
- Regression or new issue?

**Output:**
- Root cause hypothesis
- Affected areas
- Related items

## Step 5: Generate Bug Report

**Auto-increment Bug ID:**
```bash
EXISTING_BUGS=$(find [feature-path]/bugs/ -name 'BUG-*.md' | wc -l)
NEW_BUG_ID=$(printf "BUG-%03d" $((EXISTING_BUGS + 1)))
```

**Create Structure:**
```
[feature-path]/bugs/BUG-XXX-[title-kebab]/
├── bug-report.md
├── screenshots/
├── logs/
├── videos/
└── artifacts/
```

**Document Content:**
Apply all sections from bug-reporting.md standard:
1. Metadata
2. Bug Details
3. Reproduction
4. Classification
5. Evidence
6. Analysis
7. Status Workflow
8. Ownership
9. Developer Notes
10. Revision Log
11. References

## Step 6: Display Confirmation

```
Bug report created successfully!

Bug ID: BUG-XXX
Severity: [S1/S2/S3/S4] ([AI Suggested/User Overridden])
Location: [path]/bugs/BUG-XXX-[title]/bug-report.md

NEXT STEPS:
- Developer: Investigate using evidence and analysis
- QA: Update status as bug progresses
- Use /revise-bug BUG-XXX to update

Workflow: New → In Progress → Ready for QA → Verified → Closed
```
```

**Step 2: Reference Workflow in Command**

`.gemini/commands/report-bug.toml`:
```toml
description = "Create feature-level bug with auto-incremented ID and organized evidence"

model = "gemini-2.5-pro"
temperature = 0.1

[permissions]
allow = [
  "pwd",
  "find qa-agent-os/features/*/bugs/ -name 'BUG-*.md'",
  "mkdir -p qa-agent-os/features/*/bugs/BUG-*/",
  "wc -l",
]

[prompt]
header = """
# Bug Reporter

## Role
You are a QA Bug Analyst specializing in comprehensive bug documentation.

## Execute Workflow
Follow this workflow from shared library:

@{.gemini/workflows/bug-reporting.md}

## Standards
@qa-agent-os/standards/bugs/bug-reporting.md
@qa-agent-os/standards/bugs/severity-rules.md

## User Input
{{args}}
"""

[args]
bug_details = { required = false, hint = "Bug title or full details" }

[render]
format = "markdown"
```

**Benefits of This Approach:**

1. **DRY Principle:** Workflow defined once, used by multiple commands
2. **Easy Updates:** Change workflow file, all commands get update
3. **Clear Separation:** Command = entry point, Workflow = process, Standard = rules
4. **Maintainable:** Each layer has single responsibility
5. **Traceable:** Comments show which workflow is implemented

**When to Use:**
- Workflows used by 2+ commands
- Complex, multi-step processes
- Workflows updated frequently
- Team collaboration (different people maintain commands vs workflows)

---

## Workflow Orchestration Patterns

### Pattern 1: Sequential Workflow

**Use Case:** Linear, step-by-step processes (e.g., start-feature, gather-docs)

**Implementation:**

```toml
[prompt]
header = """
Execute steps in strict sequence:

## Step 1: [First Action]
[Instructions]

## Step 2: [Second Action]
(Depends on Step 1 results)
[Instructions]

## Step 3: [Final Action]
(Depends on Step 2 results)
[Instructions]
"""
```

**Gemini Behavior:** Gemini 2.5/3 excels at following sequential instructions with thought summaries tracking progress.

---

### Pattern 2: Conditional Branching

**Use Case:** Context-dependent workflows (e.g., analyze-requirements with feature vs ticket paths)

**Implementation:**

```toml
[prompt]
header = """
## Context Detection
[Gather context data]

## Conditional Execution

### IF condition A:
  Execute workflow A:
  1. [Step A1]
  2. [Step A2]

### ELSE IF condition B:
  Execute workflow B:
  1. [Step B1]
  2. [Step B2]

### ELSE:
  Display error and guidance
"""
```

**Gemini Behavior:** Use explicit IF/ELSE blocks with clear conditions. Gemini will evaluate and follow the appropriate branch.

---

### Pattern 3: Interactive Decision Points

**Use Case:** User choices during workflow (e.g., "Overwrite existing file? [y/N]")

**Implementation:**

```toml
[prompt]
header = """
## Step 1: Check for Existing Resource
[Check logic]

## Step 2: User Decision (if exists)
If resource exists, prompt user:
```
Resource already exists. Choose action:
  [1] Overwrite (destructive)
  [2] Append/Update (safe)
  [3] Cancel
```

Wait for user response and store choice.

## Step 3: Execute Based on Choice
- If choice == 1: [Overwrite logic]
- If choice == 2: [Update logic]
- If choice == 3: Abort with message
"""
```

**Gemini Behavior:** Gemini will pause and present choices to user, then continue based on response.

---

### Pattern 4: Multi-File Analysis

**Use Case:** Processing multiple files (e.g., analyzing all documentation in a folder)

**Implementation:**

```toml
[prompt]
header = """
## Step 1: Discover Files
List all files to process:
@{qa-agent-os/features/[feature]/documentation/}

## Step 2: Process Each File
For each file discovered:
1. Read content
2. Extract key information
3. Store in memory for synthesis

## Step 3: Synthesize Results
Combine information from all files into unified document.
"""
```

**Gemini Advantage:** 1M+ context window can process entire documentation folders in single prompt.

---

### Pattern 5: Iterative Refinement

**Use Case:** Commands that update existing documents (e.g., revise-test-plan, revise-bug)

**Implementation:**

```toml
[prompt]
header = """
## Step 1: Load Existing Document
Read current state:
@{path/to/existing-document.md}

## Step 2: Identify Update Target
Ask user what to update:
```
Select update type:
  [1] Update section A
  [2] Update section B
  [3] Append new section
```

## Step 3: Collect Update Data
Based on selection, gather new information from user.

## Step 4: Apply Update
- Preserve existing content
- Insert/update only affected sections
- Increment version number in revision log

## Step 5: Write Updated Document
Overwrite with updated content, preserving structure.
"""
```

**Gemini Behavior:** Gemini can accurately identify sections and perform surgical updates while preserving surrounding content.

---

### Pattern 6: Chained Commands (Advanced)

**Use Case:** Multiple commands in sequence (e.g., start-feature → gather-docs → analyze-requirements)

**Current Limitation:** Gemini CLI doesn't natively support command chaining like Unix pipes.

**Workarounds:**

#### Option A: Embedded Sub-Workflows

Create a "meta-command" that executes multiple logical steps:

```toml
# .gemini/commands/full-feature-setup.toml

description = "Complete feature setup: initialize, gather guidance, and analyze"

[prompt]
header = """
# Full Feature Setup Workflow

This command executes a complete feature setup workflow.

## Phase 1: Initialize Feature Structure
[Embed start-feature logic here]

## Phase 2: Display Documentation Guidance
[Embed gather-docs logic here]

## Phase 3: Wait for User Confirmation
Prompt: "Have you added documentation files? [y/N]"

## Phase 4: Analyze Requirements (if user confirms)
[Embed analyze-requirements logic here]
"""
```

**Pros:** Single command for common workflows
**Cons:** Harder to maintain, less modular

#### Option B: User-Driven Chaining (Recommended)

Document recommended command sequences in output:

```toml
[prompt]
header = """
[Command logic]

## Success Message
✓ Feature initialized successfully

**Recommended next steps:**
  1. /gather-docs (displays documentation guidance)
  2. [Add documentation files manually]
  3. /analyze-requirements (analyzes and creates plans)
"""
```

**Pros:** Maintains modularity, user control
**Cons:** Requires user to run multiple commands

#### Option C: Shell Script Wrapper (Advanced)

Create shell scripts that call multiple Gemini commands:

```bash
#!/bin/bash
# full-feature-setup.sh

echo "Starting full feature setup..."

# Step 1: Initialize
gemini /start-feature "$1"

# Step 2: Gather docs guidance
gemini /gather-docs

# Step 3: Wait for user
read -p "Have you added documentation? (y/N): " confirm

if [ "$confirm" == "y" ]; then
    # Step 4: Analyze
    gemini /analyze-requirements
else
    echo "Run /analyze-requirements when ready."
fi
```

**Pros:** True automation, can include custom logic
**Cons:** Requires shell scripting, less portable

---

## Best Practices

### 1. Command Design

#### Keep Commands Focused
Each command should have a single, clear purpose:

✅ **Good:**
- `/start-feature` — Only initializes structure
- `/analyze-requirements` — Only analyzes and creates documents
- `/generate-testcases` — Only generates test cases

❌ **Bad:**
- `/do-everything` — Initializes, analyzes, generates, and reports bugs

#### Use Clear, Explicit Instructions
Gemini performs best with explicit, step-by-step instructions:

✅ **Good:**
```toml
## Step 1: Normalize Feature Name
1. Convert to lowercase
2. Replace spaces with hyphens
3. Remove special characters (keep only a-z, 0-9, -)
Example: "User Authentication" → "user-authentication"
```

❌ **Bad:**
```toml
## Step 1: Normalize the feature name somehow
```

#### Leverage Gemini's Strengths
- **Large context window:** Embed full templates and standards
- **Multimodal capabilities:** Process images, diagrams, screenshots in documentation
- **Native function calling:** Use `{{exec}}` for dynamic context gathering
- **Thought summaries:** Enable for debugging complex workflows

### 2. Standards Integration

#### File References for Maintainability
Use `@{path}` syntax to inject standards:

```toml
[prompt]
header = """
## Bug Severity Standards
@qa-agent-os/standards/bugs/severity-rules.md

[Rest of prompt]
"""
```

**Benefits:**
- Standards can be updated independently
- Keeps commands clean and readable
- Reduces duplication

#### Embed Critical Standards for Performance
For frequently used, small standards, embed directly:

```toml
[prompt]
header = """
## Kebab-Case Normalization Rules (Embedded)
1. Convert to lowercase
2. Replace spaces/underscores with hyphens
3. Remove special characters except hyphens
4. No consecutive hyphens
5. No leading/trailing hyphens

Example: "User Authentication Module" → "user-authentication-module"

[Rest of prompt]
"""
```

**Use for:**
- Formatting rules
- Short validation rules
- Frequently accessed standards

### 3. Error Handling

#### Validate Inputs Early
```toml
[prompt]
header = """
## Step 1: Validate User Input
- If {{args}} is empty, prompt user
- If {{args}} contains invalid characters, reject with message
- Only proceed if validation passes

[Rest of workflow]
"""
```

#### Provide Helpful Error Messages
```toml
ERROR: Feature name cannot be empty

Usage: /start-feature "Feature Name"
Example: /start-feature "User Authentication"

Or run /start-feature without arguments for interactive mode.
```

#### Graceful Degradation
```toml
## Step 2: Load Feature Knowledge (Optional)
Try to load existing feature-knowledge.md:
@{qa-agent-os/features/[feature]/feature-knowledge.md}

If not found:
  - Display: "Note: No existing feature knowledge found. Starting fresh."
  - Continue workflow without error
```

### 4. User Experience

#### Show Progress for Long Workflows
```toml
[prompt]
header = """
## Progress Indicators
At the start of each major step, display:
```
[Step X/Y] [Step Name]...
```

Example:
```
[Step 1/5] Detecting context...
✓ Context: Feature-level analysis

[Step 2/5] Reading documentation...
✓ Found 3 documents

[Step 3/5] Analyzing requirements...
[...]
```
"""
```

#### Provide Clear Next Steps
Always end with actionable next steps:

```toml
✓ Command completed successfully

Next steps:
  1. Review generated file: [path]
  2. Run /next-command to continue workflow
  3. Or manually edit [path] before proceeding
```

#### Confirm Destructive Actions
```toml
## Step 3: Overwrite Confirmation
If file exists and user chose overwrite:
  Display: "⚠️  WARNING: This will permanently delete existing content."
  Prompt: "Type 'yes' to confirm: "

  Only proceed if user types exactly "yes" (case-sensitive)
```

### 5. Testing and Validation

#### Test Each Command Individually
Create test scenarios for each command:

```bash
# Test /start-feature
gemini /start-feature "Test Feature"
# Expected: Creates qa-agent-os/features/test-feature/documentation/

# Test duplicate detection
gemini /start-feature "Test Feature"
# Expected: Warns about existing feature, prompts for overwrite
```

#### Test Error Conditions
```bash
# Test empty input
gemini /start-feature ""
# Expected: Prompts user for feature name

# Test invalid characters
gemini /start-feature "Feature@#$%Name"
# Expected: Rejects with helpful error message
```

#### Compare Output with Claude Code Version
Run both versions on same input and compare:

```bash
# Claude Code
claude /start-feature "User Auth"

# Gemini
gemini /start-feature "User Auth"

# Compare outputs
diff -r .claude/output/ .gemini/output/
```

### 6. Performance Optimization

#### Choose the Right Model
```toml
# Simple, deterministic tasks → Gemini 2.5 Flash
model = "gemini-2.5-flash"
temperature = 0.0

# Complex analysis, reasoning → Gemini 2.5 Pro
model = "gemini-2.5-pro"
temperature = 0.2
```

**Model Selection Guide:**
- **Flash:** Structure initialization, file operations, simple validation
- **Pro:** Requirement analysis, gap detection, test planning, bug analysis

#### Minimize Shell Command Calls
Cache results instead of repeated calls:

❌ **Bad:**
```toml
[prompt]
header = """
Step 1: {{exec "ls qa-agent-os/features/"}}
Step 2: {{exec "ls qa-agent-os/features/"}}
Step 3: {{exec "ls qa-agent-os/features/"}}
"""
```

✅ **Good:**
```toml
[prompt]
header = """
## Context (loaded once)
Existing features:
{{exec "ls qa-agent-os/features/"}}

## Workflow
Step 1: Use feature list loaded above
Step 2: Use feature list loaded above
Step 3: Use feature list loaded above
"""
```

#### Use Thought Summaries for Debugging Only
Enable thought summaries when developing/debugging commands:

```toml
# config.yml
gemini:
  use_thought_summaries: true  # Development
  # use_thought_summaries: false  # Production (faster)
```

---

## Testing and Validation

### Test Plan for Migration

#### Phase 1: Unit Testing (Per-Command)

Create test cases for each migrated command:

**Test Template:**
```
Command: /[command-name]
Input: [test input]
Expected Output: [expected result]
Actual Output: [actual result]
Status: PASS/FAIL
Notes: [any observations]
```

**Example Test Cases:**

##### /start-feature

| Test Case | Input | Expected Output | Status |
|-----------|-------|-----------------|--------|
| Valid new feature | "User Authentication" | Creates `qa-agent-os/features/user-authentication/documentation/` | PASS |
| Duplicate feature | "User Authentication" (run twice) | Warns and prompts for overwrite | PASS |
| Empty input | "" (empty) | Prompts user for feature name | PASS |
| Special characters | "User@Auth#123" | Normalizes to "user-auth-123" | PASS |

##### /analyze-requirements

| Test Case | Context | Expected Output | Status |
|-----------|---------|-----------------|--------|
| Feature context, no docs | Feature dir, empty docs folder | Error: "No documentation found" | PASS |
| Feature context, new analysis | Feature dir, 3 docs | Creates feature-knowledge.md + feature-test-strategy.md | PASS |
| Feature context, existing analysis | Feature dir, existing docs | Prompts: Re-analyze or Update? | PASS |
| Ticket context, no parent feature | Ticket dir, no parent feature-knowledge.md | Error: "Parent feature analysis not found" | PASS |
| Ticket context, gap detection | Ticket dir, 1 new rule | Displays gap, prompts to append | PASS |

##### /report-bug

| Test Case | Input | Expected Output | Status |
|-----------|-------|-----------------|--------|
| First bug in feature | Title: "Login fails" | Creates BUG-001-login-fails/ with structure | PASS |
| Second bug in feature | Title: "Password reset broken" | Creates BUG-002-password-reset-broken/ | PASS |
| Bug with all evidence types | + screenshots, logs, videos | Creates all subfolders with evidence | PASS |

#### Phase 2: Integration Testing (Command Sequences)

Test realistic workflows:

**Workflow 1: New Feature from Scratch**
```bash
# Step 1: Initialize feature
gemini /start-feature "Payment Gateway"
# Expected: qa-agent-os/features/payment-gateway/documentation/ created

# Step 2: Gather docs guidance
cd qa-agent-os/features/payment-gateway/
gemini /gather-docs
# Expected: Displays feature-level guidance

# Step 3: Manually add docs
cp ~/brd.pdf documentation/
cp ~/api-spec.yaml documentation/

# Step 4: Analyze requirements
gemini /analyze-requirements
# Expected: feature-knowledge.md + feature-test-strategy.md created

# Step 5: Start ticket
gemini /start-ticket "PAY-101"
# Expected: Auto-detects "payment-gateway", creates PAY-101/ folder

# Step 6: Add ticket docs
cd PAY-101/
cp ~/acceptance-criteria.md documentation/

# Step 7: Analyze ticket
gemini /analyze-requirements
# Expected: Gap detection runs, test-plan.md created, offers test case generation
```

**Validation:**
- All files created in correct locations
- Gap detection identifies new requirements
- Prompts appear at correct stages
- Next steps clearly displayed

**Workflow 2: Bug Reporting**
```bash
# Step 1: Report bug
cd qa-agent-os/features/payment-gateway/
gemini /report-bug "Stripe webhook fails with 500 error"
# Expected: BUG-001-stripe-webhook-fails-with-500-error/ created

# Step 2: Add evidence
cp ~/screenshot.png bugs/BUG-001-stripe-webhook-fails-with-500-error/screenshots/
cp ~/error.log bugs/BUG-001-stripe-webhook-fails-with-500-error/logs/

# Step 3: Revise bug (change severity)
gemini /revise-bug
# Expected: Lists BUG-001, prompts for revision type, updates bug-report.md
```

#### Phase 3: Regression Testing (Claude Code vs Gemini)

Compare outputs for identical inputs:

```bash
# Create test project
mkdir /tmp/qa-test-project
cd /tmp/qa-test-project

# Test with Claude Code
git checkout claude-code-branch
project-install.sh --claude-code-commands true
claude /start-feature "Test Feature"
# Save output: claude-output/

# Test with Gemini
git checkout gemini-branch
project-install.sh --gemini true
gemini /start-feature "Test Feature"
# Save output: gemini-output/

# Compare
diff -r claude-output/ gemini-output/
# Validate: Structure identical, content equivalent
```

#### Phase 4: Performance Testing

Measure command execution time and token usage:

```bash
# Benchmark script
#!/bin/bash

commands=(
  "/start-feature 'Test Feature'"
  "/gather-docs"
  "/analyze-requirements"
  "/generate-testcases"
  "/report-bug 'Test Bug'"
)

for cmd in "${commands[@]}"; do
  echo "Testing: $cmd"

  start_time=$(date +%s)
  gemini "$cmd"
  end_time=$(date +%s)

  duration=$((end_time - start_time))
  echo "Duration: ${duration}s"
  echo "---"
done
```

**Expected Performance:**
- Simple commands (start-feature, gather-docs): < 5 seconds
- Complex analysis (analyze-requirements): 10-30 seconds
- Test case generation: 15-45 seconds

**Token Usage:**
- Monitor via Gemini CLI `/stats` command
- Compare to Claude Code token usage
- Ensure within expected ranges for 1M context window

---

## Troubleshooting

### Common Migration Issues

#### Issue 1: "Command not found" Error

**Symptom:**
```
Error: Unknown command '/start-feature'
```

**Causes:**
- TOML file not in correct location
- Filename doesn't match command name
- Permissions issue

**Solutions:**
```bash
# Check file location
ls -la .gemini/commands/start-feature.toml

# Verify file permissions
chmod 644 .gemini/commands/start-feature.toml

# Restart Gemini CLI to reload commands
# (Exit and restart)
```

#### Issue 2: File References Not Working

**Symptom:**
```
Error: Cannot read file at @qa-agent-os/standards/bugs/severity-rules.md
```

**Causes:**
- File path incorrect
- File doesn't exist in project
- Path not normalized during compilation

**Solutions:**
```bash
# Verify file exists
ls qa-agent-os/standards/bugs/severity-rules.md

# Check path format in TOML
# Should be relative to project root:
@qa-agent-os/standards/bugs/severity-rules.md

# NOT absolute paths:
@/Users/[...]/qa-agent-os/standards/bugs/severity-rules.md
```

#### Issue 3: Shell Commands Failing

**Symptom:**
```
Error: Shell command not permitted: ls -la qa-agent-os/features/
```

**Causes:**
- Command not whitelisted in `[permissions]` section
- Syntax error in command

**Solutions:**
```toml
# Add to [permissions] section
[permissions]
allow = [
  "ls -la qa-agent-os/features/",  # Exact match required
]

# Or use wildcards (if supported)
allow = [
  "ls -la qa-agent-os/features/*",
]
```

#### Issue 4: Multi-Line Prompts Not Rendering

**Symptom:**
Prompt appears on single line, ignoring line breaks.

**Causes:**
- TOML multi-line string syntax incorrect

**Solutions:**
```toml
# Use triple-quotes for multi-line strings
[prompt]
header = """
Line 1
Line 2
Line 3
"""

# NOT single quotes
header = "Line 1\nLine 2\nLine 3"  # Will show literal \n
```

#### Issue 5: Context Window Exceeded

**Symptom:**
```
Error: Input too long (exceeded 1M token limit)
```

**Causes:**
- Too many files injected via `@{directory/}`
- Extremely large documentation files

**Solutions:**
```toml
# Use selective file injection instead of entire directories
# Instead of:
@{qa-agent-os/features/my-feature/documentation/}

# Use specific files:
@{qa-agent-os/features/my-feature/documentation/brd.md}
@{qa-agent-os/features/my-feature/documentation/api-spec.yaml}

# Or filter files
{{exec "find qa-agent-os/features/my-feature/documentation/ -name '*.md' -exec cat {} \;"}}
```

#### Issue 6: Gemini Ignoring Workflow Steps

**Symptom:**
Gemini skips steps or executes out of order.

**Causes:**
- Instructions not explicit enough
- Conditional logic unclear

**Solutions:**
```toml
# Use numbered steps and explicit sequencing
[prompt]
header = """
IMPORTANT: Execute steps in strict sequence. Do not skip steps.

## Step 1: [Action]
[Clear instructions]

DO NOT PROCEED TO STEP 2 UNTIL STEP 1 IS COMPLETE.

## Step 2: [Action]
(This step depends on Step 1 results)
[Clear instructions]

DO NOT PROCEED TO STEP 3 UNTIL STEP 2 IS COMPLETE.

## Step 3: [Action]
[Clear instructions]
"""
```

#### Issue 7: Thought Summaries Confusing Output

**Symptom:**
Gemini displays reasoning process mixed with actual output.

**Causes:**
- Thought summaries enabled (development mode)

**Solutions:**
```yaml
# Disable in config.yml for production
gemini:
  use_thought_summaries: false

# Or keep enabled and parse output
# Thought summaries appear in separate sections
```

---

## Advanced Topics

### Custom Namespacing Strategy

For large QA Agent OS installations, use namespaces to organize commands:

```
.gemini/commands/
├── feature/
│   ├── start.toml           → /feature:start
│   ├── analyze.toml         → /feature:analyze
│   └── knowledge.toml       → /feature:knowledge
├── ticket/
│   ├── start.toml           → /ticket:start
│   ├── plan.toml            → /ticket:plan
│   └── testcases.toml       → /ticket:testcases
├── bug/
│   ├── report.toml          → /bug:report
│   └── revise.toml          → /bug:revise
└── docs/
    └── gather.toml          → /docs:gather
```

**Benefits:**
- Clear command organization
- Avoids naming conflicts
- Easier to discover related commands

**Configuration:**
```toml
# .gemini/commands/feature/start.toml
description = "Initialize feature folder structure"
# Becomes: /feature:start
```

### Integration with CI/CD

Gemini CLI supports headless mode for automation:

```bash
# Example: Automated test case generation in CI
#!/bin/bash

# Install dependencies
npm install -g @google-cloud/gemini-cli

# Authenticate (use service account)
export GEMINI_API_KEY="${CI_GEMINI_API_KEY}"

# Run test case generation
gemini --headless --output-format json /generate-testcases "TICKET-123" > output.json

# Parse results
test_cases=$(jq '.test_cases' output.json)

# Post to Jira/Testmo
curl -X POST "${TESTMO_API}" -d "${test_cases}"
```

### Extending with MCP (Model Context Protocol)

Gemini CLI supports MCP servers for advanced integrations:

```bash
# Configure MCP server in .gemini/settings.json
{
  "mcp": {
    "servers": {
      "jira": {
        "command": "node",
        "args": ["./mcp-servers/jira-server.js"],
        "env": {
          "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
        }
      }
    }
  }
}
```

**Use in commands:**
```toml
[prompt]
header = """
## Jira Integration
Fetch ticket details from Jira:
{{mcp jira get-ticket TICKET-123}}

Use fetched details to populate test plan.
"""
```

---

## Conclusion

This migration guide provides a comprehensive path from Claude Code's multi-agent architecture to Gemini 3's powerful single-agent model with large context windows and native agentic capabilities.

**Key Takeaways:**

1. **Structural Change:** Markdown + phase tags → TOML + sequential prompts
2. **Workflow Consolidation:** Multi-agent delegation → Single-agent orchestration
3. **Context Leverage:** Use Gemini's 1M+ context to embed full standards and templates
4. **Explicit Instructions:** Clear, step-by-step workflows perform best
5. **Testing Essential:** Validate each command individually and in workflows

**Next Steps:**

1. Start with simple commands (start-feature, gather-docs)
2. Migrate complex commands one at a time
3. Test thoroughly at each stage
4. Document Gemini-specific patterns and optimizations
5. Roll out incrementally to users

---

## Sources

This guide was informed by the following official documentation and resources:

### Gemini CLI Documentation
- [Custom Commands | Gemini CLI](https://geminicli.com/docs/cli/custom-commands/)
- [CLI Commands | Gemini CLI](https://geminicli.com/docs/cli/commands/)
- [Gemini CLI GitHub Repository](https://github.com/google-gemini/gemini-cli)
- [Gemini CLI: Custom slash commands | Google Cloud Blog](https://cloud.google.com/blog/topics/developers-practitioners/gemini-cli-custom-slash-commands)
- [Gemini CLI Tutorial Series — Part 7: Custom slash commands | Medium](https://medium.com/google-cloud/gemini-cli-tutorial-series-part-7-custom-slash-commands-64c06195294b)

### Gemini Models and Capabilities
- [Expanding Gemini 2.5 Flash and Pro capabilities | Google Cloud Blog](https://cloud.google.com/blog/products/ai-machine-learning/expanding-gemini-2-5-flash-and-pro-capabilities)
- [Gemini 2.5: Pushing the Frontier with Advanced Reasoning, Multimodality, Long Context, and Next Generation Agentic Capabilities | arXiv](https://arxiv.org/html/2507.06261v1)
- [Building AI Agents with Google Gemini 3 and Open Source Frameworks - Google Developers Blog](https://developers.googleblog.com/building-ai-agents-with-google-gemini-3-and-open-source-frameworks/)
- [Gemini 3 for developers: New reasoning, agentic capabilities](https://blog.google/technology/developers/gemini-3-developers/)

### Workflow Orchestration
- [Implement prompt chaining / pipelining for multi-step tasks · Issue #5022 · google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli/issues/5022)
- [Add workflow-based development functionality to Gemini CLI · Issue #13333 · google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli/issues/13333)
- [Google announces Gemini CLI: your open-source AI agent](https://blog.google/technology/developers/introducing-gemini-cli-open-source-ai-agent/)

---

**Document Version:** 1.0
**Last Updated:** December 10, 2025
**Maintained By:** QA Agent OS Core Team
