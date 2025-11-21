# Specification: QA Agent OS Architecture Alignment

## Goal

Align the refactored QA Agent OS commands with the original agent-os architecture patterns to achieve workflow-centric design, logic reusability, dual-mode support (single-agent and multi-agent), and token efficiency for AI execution.

## User Stories

- As a QA team using single-agent AI CLIs (Gemini), I want all commands to work efficiently without requiring subagentic capabilities
- As a QA team using multi-agent AI CLIs (Claude Code, OpenCode), I want commands to leverage specialized agents for expert domain knowledge and efficient delegation
- As a maintainer, I want implementation logic to exist in one place (workflows) so updates are easy and consistent across all commands

## Specific Requirements

### Requirement 1: Extract Logic to Workflows

**Current Problem:** Refactored commands contain full implementation logic in phase files, duplicating code and preventing reusability

**Solution:**
- Extract all procedural implementation logic from command phase files into workflows
- Command phase files should reference workflows using `{{workflows/category/workflow-name}}` tags
- Workflows become the single source of truth for all implementation logic
- Multiple commands can reference the same workflow to avoid duplication

**Example Transformation:**

Before (Incorrect):
```
commands/plan-ticket/single-agent/3-analyze-requirements.md
  Contains: 116 lines of gap detection, requirement analysis, test plan creation logic
```

After (Correct):
```
commands/plan-ticket/single-agent/3-analyze-requirements.md
  Contains: Orchestration logic + {{workflows/testing/requirement-analysis}} reference

workflows/testing/requirement-analysis.md
  Contains: All procedural implementation logic (single source of truth)
```

**Success Criteria:**
- No implementation logic duplicated across phase files
- All core logic exists in workflows
- Commands reference workflows using correct tag format
- Agents also reference the same workflows

---

### Requirement 2: Create Multi-Agent Command Variants

**Current Problem:** Five refactored commands only have single-agent variants, preventing specialized agent usage

**Solution:**
- Create multi-agent variants for all commands following original pattern
- Multi-agent variants delegate phases to specialized agents (requirement-analyst, testcase-writer, feature-initializer)
- Compilation script uses config flag to determine which variant to install
- Both variants share the same workflows (ensuring consistency)

**Commands Requiring Multi-Agent Variants:**
1. /plan-feature - Delegates to feature-initializer, requirement-analyst
2. /plan-ticket - Delegates to feature-initializer, requirement-analyst, testcase-writer
3. /generate-testcases - Update existing variant to match new workflow structure
4. /revise-test-plan - Delegates to requirement-analyst, optionally testcase-writer
5. /update-feature-knowledge - Delegates to requirement-analyst

**Directory Structure Pattern:**
```
commands/[command-name]/
├── single-agent/
│   ├── [command-name].md     # Orchestrator with phase tags
│   └── N-phase.md            # Phases reference workflows
└── multi-agent/
    └── [command-name].md     # Delegates to specialized agents
```

**Multi-Agent Delegation Pattern:**
```markdown
### PHASE N: [Phase Name]

Use the **[agent-name]** subagent to [task description].

Provide the agent with:
- [Input 1]
- [Input 2]

The agent will:
- [Responsibility 1]
- [Responsibility 2]
```

---

### Requirement 3: Update Existing Workflows

**Workflows Requiring Updates:**

**workflows/testing/testcase-generation.md**
- Current: Basic structure, reads requirements.md (old pattern)
- Update: Smart conflict detection (overwrite/append/create modes), read test-plan.md, new test case structure with execution tracking, coverage analysis, automation recommendations
- Used by: /generate-testcases Phase 3, /plan-ticket Phase 4, testcase-writer agent

**workflows/testing/requirement-analysis.md**
- Current: Creates requirements.md (old pattern)
- Update: Add gap detection logic, compare against feature-knowledge.md, prompt to update feature knowledge, create test-plan.md instead, include revision log initialization
- Used by: /plan-ticket Phase 3, requirement-analyst agent

**workflows/testing/initialize-feature.md**
- Current: Old folder structure pattern
- Update: Match /plan-feature Phase 1 logic, create new feature folder structure, include README.md generation, align with current directory conventions
- Used by: /plan-feature Phase 1, feature-initializer agent

---

### Requirement 4: Create New Workflows

**New workflows needed to support refactored commands:**

**Feature Planning Workflows:**
1. workflows/planning/gather-feature-docs.md - Gather BRDs, API specs, mockups for a feature
2. workflows/planning/consolidate-feature-knowledge.md - Create feature-knowledge.md from collected docs (8 sections)
3. workflows/planning/create-test-strategy.md - Create feature-test-strategy.md (10 sections)
4. workflows/planning/update-feature-knowledge.md - Update feature-knowledge.md with new information

**Ticket Planning Workflows:**
5. workflows/testing/initialize-ticket.md - Create ticket folder structure
6. workflows/testing/gather-ticket-docs.md - Gather ticket-specific documentation
7. workflows/testing/revise-test-plan.md - Update test-plan.md with revisions and version increments

**Workflow Structure Pattern:**
```markdown
# [Workflow Name] Workflow

This workflow [describes purpose].

## Core Responsibilities

1. **[Responsibility 1]**: [Description]
2. **[Responsibility 2]**: [Description]

**Note:** The placeholder `[variable-name]` refers to [explanation].

---

## Workflow

### Step 0: [Optional Preparation]
[Preparation logic]

### Step 1: [First Main Step]
[Implementation logic]

### Step N: [Final Step]
[Completion logic]
```

---

### Requirement 5: Update Agent Definitions

**Agents Requiring Updates:**

**agents/testcase-writer.md**
- Current: References outdated patterns (requirements.md)
- Update: Reference updated testcase-generation workflow, remove outdated file references
- Workflow references: workflows/testing/testcase-generation

**agents/requirement-analyst.md**
- Current: References standards directly, no workflow references
- Update: Add all requirement analysis workflow references
- Workflow references: workflows/testing/requirement-analysis, workflows/planning/consolidate-feature-knowledge, workflows/planning/create-test-strategy, workflows/testing/revise-test-plan, workflows/planning/update-feature-knowledge

**agents/feature-initializer.md**
- Current: Only references initialize-feature workflow
- Update: Add ticket initialization and documentation gathering workflows
- Workflow references: workflows/planning/initialize-feature, workflows/planning/gather-feature-docs, workflows/testing/initialize-ticket, workflows/testing/gather-ticket-docs

**Agent Structure Pattern:**
```markdown
---
name: agent-name
description: Brief role description
tools: Write, Read, Bash, WebFetch
color: cyan
model: inherit
---

# [Agent Display Name]

You are a [role description]. Your goal is to [agent's goal].

## Responsibilities

1. **[Responsibility 1]**: [Description]
2. **[Responsibility 2]**: [Description]

## Workflow

### Step 1: [Phase Name]

{{workflows/category/workflow-name}}

### Step 2: [Phase Name]

{{workflows/category/another-workflow}}

{{UNLESS standards_as_claude_code_skills}}
## Standards Reference

Ensure compliance with all applicable standards:

{{standards/category/*}}
{{ENDUNLESS standards_as_claude_code_skills}}
```

---

### Requirement 6: Command Phase Orchestration

**Pattern for Phase Files:**

**Option A: Pure Workflow Reference (Preferred)**
```markdown
# Phase N: [Phase Name]

## What This Phase Does
[Brief description]

## Execution

{{workflows/category/workflow-name}}

The workflow will:
- [What workflow does 1]
- [What workflow does 2]

## Next Steps
[What happens after this phase]
```

**Option B: Orchestration + Workflow (When Needed)**
```markdown
# Phase N: [Phase Name]

## Step 1: Pre-Processing
[Command-specific logic that can't be in workflow]

## Step 2: Execute Core Workflow
{{workflows/category/workflow-name}}

## Step 3: Post-Processing
[Command-specific logic after workflow]
```

**When to Use Option A vs B:**
- Use Option A when phase is purely workflow execution
- Use Option B when command needs custom UI prompts, choice handling, or context-specific logic before/after workflow
- Never duplicate workflow logic in phase files

---

### Requirement 7: Standards Injection Consistency

**Pattern:**
- Both agents and command phase files must include standards references
- Use conditional block to respect config flag
- Standards block appears at end of file

**Conditional Standards Block:**
```markdown
{{UNLESS standards_as_claude_code_skills}}
## Standards Reference

Ensure compliance with the following standards:

{{standards/global/*}}
{{standards/testcases/*}}
{{standards/testing/*}}
{{ENDUNLESS standards_as_claude_code_skills}}
```

**Compilation Behavior:**
- If config `standards_as_claude_code_skills: false` - Block included, tags replaced with file paths
- If config `standards_as_claude_code_skills: true` - Block removed, standards available as Skills

**Where to Include:**
- In all agent definitions
- In command phase files that contain implementation logic
- Not needed in pure orchestration phases (workflow handles it)

---

### Requirement 8: Configuration-Driven Compilation

**Pattern:**
- config.yml controls which command variant gets compiled
- Installation script reads flag and selects appropriate variant

**Config Flag:**
```yaml
claude_code_subagents: true   # Compile multi-agent variants
claude_code_subagents: false  # Compile single-agent variants
```

**Compilation Logic:**
```bash
if [ "$SUBAGENTS_ENABLED" = "true" ]; then
    VARIANT="multi-agent"
    # Compile agents to .claude/agents/qa-agent-os/
else
    VARIANT="single-agent"
fi

# Compile from commands/[name]/$VARIANT/
```

**Result:**
- Users with subagentic CLIs (Claude Code, OpenCode) get multi-agent variants
- Users with single-agent CLIs (Gemini) get single-agent variants
- Both use the same workflows (consistency guaranteed)

---

### Requirement 9: Workflow Reference Tag Format

**Tag Format:**
```markdown
{{workflows/category/workflow-name}}
```

**Processing During Compilation:**
- Tags can be left as-is (file path references for AI)
- Or embedded with content (inline injection)
- Script's `process_phase_tags()` handles replacement

**Examples:**
- `{{workflows/testing/testcase-generation}}` - References test case generation workflow
- `{{workflows/planning/gather-product-info}}` - References product info gathering workflow
- `{{workflows/testing/requirement-analysis}}` - References requirement analysis workflow

**Usage:**
- In command phase files to reference implementation
- In agent definitions to reference core logic
- Can reference utility workflows from other workflows

---

### Requirement 10: Phase-to-Agent Mapping

**Mapping for /plan-ticket Multi-Agent Variant:**

| Phase | Orchestration Logic | Agent | Workflow |
|-------|-------------------|-------|----------|
| Phase 0: Detect Context | Smart feature detection, ticket detection | None (orchestrator logic) | N/A |
| Phase 1: Initialize Ticket | Create ticket structure | feature-initializer | workflows/testing/initialize-ticket |
| Phase 2: Gather Documentation | Collect ticket docs | feature-initializer | workflows/testing/gather-ticket-docs |
| Phase 3: Analyze Requirements | Gap detection, test plan creation | requirement-analyst | workflows/testing/requirement-analysis |
| Phase 4: Generate Test Cases | Create test-cases.md | testcase-writer | workflows/testing/testcase-generation |

**Mapping for /plan-feature Multi-Agent Variant:**

| Phase | Orchestration Logic | Agent | Workflow |
|-------|-------------------|-------|----------|
| Phase 1: Initialize Structure | Create feature folders | feature-initializer | workflows/planning/initialize-feature |
| Phase 2: Gather Documentation | Collect BRDs, specs, mockups | feature-initializer | workflows/planning/gather-feature-docs |
| Phase 3: Consolidate Knowledge | Create feature-knowledge.md | requirement-analyst | workflows/planning/consolidate-feature-knowledge |
| Phase 4: Create Test Strategy | Create feature-test-strategy.md | requirement-analyst | workflows/planning/create-test-strategy |

**Mapping for /generate-testcases Multi-Agent Variant:**

| Phase | Orchestration Logic | Agent | Workflow |
|-------|-------------------|-------|----------|
| Phase 1: Select Ticket | Interactive selection | None (orchestrator logic) | N/A |
| Phase 2: Detect Conflicts | Check existing files, prompt user | None (orchestrator logic) | N/A |
| Phase 3: Generate Cases | Create test-cases.md | testcase-writer | workflows/testing/testcase-generation |

---

## Examples

### Example 1: Workflow Extraction

**Before (Logic Embedded in Phase File):**

File: `commands/generate-testcases/single-agent/generate-testcases.md`
```markdown
# Generate Test Cases

## Step 1: Read Test Plan
[50 lines of logic for reading test-plan.md]

## Step 2: Extract Scenarios
[60 lines of logic for parsing scenarios]

## Step 3: Generate Cases
[100 lines of logic for case generation]

## Step 4: Save Output
[30 lines of logic for file writing]
```

**After (References Workflow):**

File: `commands/generate-testcases/single-agent/3-generate-cases.md`
```markdown
# Phase 3: Generate Test Cases

## Execute Test Case Generation

This phase generates the test cases using the core workflow.

### Variables from Previous Phases
- TICKET_PATH: `qa-agent-os/features/[feature]/[ticket-id]`
- MODE: [create|overwrite|append]
- TEST_PLAN_PATH: `[ticket-path]/test-plan.md`

### Execute Generation Workflow

{{workflows/testing/testcase-generation}}

The workflow will:
- Read the test plan
- Extract test scenarios and coverage requirements
- Generate detailed test cases
- Save to test-cases.md (respecting MODE)

### Completion

Once workflow completes:
```
✓ Test cases generated successfully!

Output: qa-agent-os/features/[feature]/[ticket-id]/test-cases.md
```
```

File: `workflows/testing/testcase-generation.md`
```markdown
# Test Case Generation Workflow

This workflow generates comprehensive test cases from a test plan.

## Core Responsibilities

1. **Read Test Plan**: Extract scenarios, coverage requirements, test data
2. **Generate Test Cases**: Create detailed executable test cases
3. **Save Output**: Write test-cases.md with proper structure

**Note:** The placeholder `[ticket-path]` refers to the full path like `qa-agent-os/features/feature-name/TICKET-123`.

---

## Workflow

### Step 0: Compile Applicable Standards

{{workflows/testing/compile-testing-standards}}

### Step 1: Read Test Plan

Read the test plan to extract requirements:

```bash
TEST_PLAN="[ticket-path]/test-plan.md"
```

Extract from test plan:
- Section 5: Test Coverage Matrix
- Section 6: Test Scenarios & Cases
- Section 7: Test Data Requirements
- Section 4: Testable Requirements

### Step 2: Generate Test Cases

Based on test plan content, generate test cases with this structure:

For each test scenario:
1. Create test case ID: [TICKET-ID]-TC-[NUMBER]
2. Define test case type: [Functional|Negative|Edge|API|Integration]
3. Set priority based on requirement priority
4. Write clear objective
5. Define preconditions
6. Create detailed steps in table format
7. Reference test data
8. Define expected result
9. Include execution tracking checkboxes
10. Add space for notes

### Step 3: Coverage Analysis

Compare generated test cases against coverage matrix to verify all requirements have test cases.

### Step 4: Automation Recommendations

Analyze each test case for automation potential (API tests = high, exploratory = low).

### Step 5: Save Test Cases

Save to `[ticket-path]/test-cases.md` with full structure.

Respect MODE variable:
- create: Write new file
- overwrite: Replace existing
- append: Add to existing
```

**Benefits:**
- Single source of truth (update workflow once, all commands benefit)
- Agent can also reference the same workflow
- Reduced duplication (240 lines → 40 orchestration + 200 workflow)
- Token efficiency for AI

---

### Example 2: Single-Agent vs Multi-Agent Variants

**Single-Agent Variant:**

File: `commands/plan-ticket/single-agent/plan-ticket.md`
```markdown
# /plan-ticket Command

## Purpose
Plan comprehensive test coverage for a specific ticket.

## Usage
```bash
/plan-ticket WYX-123
```

## Execution Phases

This command executes the following phases in sequence:

{{PHASE 0: @qa-agent-os/commands/plan-ticket/0-detect-context.md}}

{{PHASE 1: @qa-agent-os/commands/plan-ticket/1-init-ticket.md}}

{{PHASE 2: @qa-agent-os/commands/plan-ticket/2-gather-ticket-docs.md}}

{{PHASE 3: @qa-agent-os/commands/plan-ticket/3-analyze-requirements.md}}

{{PHASE 4: @qa-agent-os/commands/plan-ticket/4-generate-cases.md}}
```

File: `commands/plan-ticket/single-agent/3-analyze-requirements.md`
```markdown
# Phase 3: Analyze Requirements & Detect Gaps

## Intelligent Requirement Analysis

This phase analyzes ticket requirements and creates the test plan.

### Variables from Previous Phases
- TICKET_PATH: `qa-agent-os/features/[feature]/[ticket-id]`
- FEATURE_KNOWLEDGE_PATH: `qa-agent-os/features/[feature]/feature-knowledge.md`
- FEATURE_STRATEGY_PATH: `qa-agent-os/features/[feature]/feature-test-strategy.md`

### Execute Requirement Analysis

{{workflows/testing/requirement-analysis}}

The workflow will:
- Read ticket documentation
- Read feature knowledge and strategy
- Compare ticket requirements against feature knowledge
- Detect gaps (new rules, APIs, edge cases)
- Prompt to update feature knowledge if gaps found
- Create comprehensive test-plan.md

### Post-Workflow Prompt

After workflow completes, prompt user:
```
Test plan created successfully!

Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first, generate later)

Choose [1/2]:
```

If [1], proceed to Phase 4.
If [2], exit with helpful message.
```

**Multi-Agent Variant:**

File: `commands/plan-ticket/multi-agent/plan-ticket.md`
```markdown
# /plan-ticket Command (Multi-Agent Mode)

## Purpose
Plan comprehensive test coverage for a specific ticket using specialized agents.

## Usage
```bash
/plan-ticket WYX-123
```

## Execution Flow

### PHASE 0: Smart Detection

[Same smart detection logic as single-agent - orchestrator handles this]

Detect existing features automatically.
If ticket exists, offer re-execution options.
If new ticket, auto-select feature or prompt.

### PHASE 1-2: Initialize and Gather

Use the **feature-initializer** subagent to set up the ticket structure and gather documentation.

Provide the feature-initializer with:
- Feature path (from Phase 0)
- Ticket ID
- Any provided documentation

The feature-initializer will:
- Create ticket directory structure
- Create documentation/ folder
- Gather ticket-specific docs
- Create README.md

### PHASE 3: Analyze Requirements & Detect Gaps

Use the **requirement-analyst** subagent to analyze requirements and create the test plan.

Provide the requirement-analyst with:
- Ticket path
- Feature knowledge path
- Feature test strategy path
- Documentation from Phase 2

The requirement-analyst will:
- Read and analyze ticket documentation
- Read feature knowledge and strategy
- Compare ticket requirements against feature knowledge
- Detect gaps (new rules, APIs, edge cases)
- Prompt to update feature knowledge if gaps found
- Create comprehensive test-plan.md (11 sections)

After requirement-analyst completes, prompt user:
```
Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first)

Choose [1/2]:
```

### PHASE 4: Generate Test Cases (Optional)

If user chose option [1]:

Use the **testcase-writer** subagent to generate detailed test cases.

Provide the testcase-writer with:
- Ticket path
- Test plan path
- Generation mode: create
- Visual assets (if any)

The testcase-writer will:
- Read test plan
- Extract scenarios and coverage requirements
- Generate detailed executable test cases
- Save to test-cases.md
- Follow all testing standards

### Completion

```
✓ Ticket planning complete!

Created:
- Test plan: qa-agent-os/features/[feature]/[ticket-id]/test-plan.md
- Test cases: qa-agent-os/features/[feature]/[ticket-id]/test-cases.md
- Feature knowledge updated: [yes/no]
```
```

**Key Differences:**
- Single-agent: Executes workflows directly via phase files
- Multi-agent: Delegates to specialized agents who execute workflows
- Both reference the SAME workflows (consistency guaranteed)
- Multi-agent is simpler - no implementation details, just delegation
- Config flag controls which variant gets compiled

---

### Example 3: Agent Workflow References

**Before (Agent Without Workflow References):**

File: `agents/testcase-writer.md`
```markdown
---
name: testcase-writer
description: Generates comprehensive test cases
tools: Write, Bash
---

You are a test case generator.

## Responsibilities
- Read requirements.md and test-plan.md
- Generate test cases
- Save to test-cases.md

{{UNLESS standards_as_claude_code_skills}}
## Standards Reference
{{standards/testcases/*}}
{{standards/testing/*}}
{{ENDUNLESS standards_as_claude_code_skills}}
```

**After (Agent References Workflow):**

File: `agents/testcase-writer.md`
```markdown
---
name: testcase-writer
description: Generates comprehensive test cases from test plans
tools: Write, Bash
color: green
model: inherit
---

# Test Case Writer

You are a test case generation specialist. Your goal is to create comprehensive, executable test cases from test plans.

## Core Responsibilities

1. **Read Test Plans**: Extract scenarios, coverage requirements, test data
2. **Generate Test Cases**: Create detailed executable test cases with proper structure
3. **Coverage Analysis**: Ensure all requirements are covered by test cases
4. **Automation Recommendations**: Identify automation opportunities

## Inputs
- Test plan: `[ticket-path]/test-plan.md`
- Generation mode: create|overwrite|append
- Visual assets: `[ticket-path]/documentation/` (optional)

## Outputs
- **test-cases.md**: Comprehensive test cases with execution tracking

## Workflow

### Test Case Generation

{{workflows/testing/testcase-generation}}

This workflow handles:
- Reading test plans
- Extracting scenarios and coverage requirements
- Generating detailed executable test cases
- Saving to test-cases.md with proper structure
- Coverage analysis
- Automation recommendations

{{UNLESS standards_as_claude_code_skills}}
## Standards Reference

Ensure compliance with all applicable standards:

{{standards/testcases/*}}
{{standards/testing/*}}
{{ENDUNLESS standards_as_claude_code_skills}}
```

**Benefits:**
- Agent now references workflow as single source of truth
- Clear responsibilities and workflow integration
- Same logic as commands (consistency)
- Multi-agent mode delegates to this agent

---

## Validation Criteria

### Pattern Compliance Checklist

**Command Structure:**
- [ ] Command has BOTH single-agent/ and multi-agent/ variants
- [ ] Single-agent has orchestrator with phase tags
- [ ] Single-agent phases reference workflows where appropriate
- [ ] Multi-agent delegates to specialized agents
- [ ] Orchestrators include clear usage documentation

**Workflow Integration:**
- [ ] Core logic exists in workflows (not duplicated in phases)
- [ ] Workflows are properly structured with clear steps
- [ ] Workflows use placeholder variables consistently
- [ ] Workflows are referenced using correct tag format `{{workflows/...}}`

**Agent Integration:**
- [ ] Agents have proper YAML frontmatter
- [ ] Agents reference workflows for implementation
- [ ] Agents include standards block (conditional on config)
- [ ] Agents have clear role descriptions

**Standards Compliance:**
- [ ] Standards block uses `{{UNLESS standards_as_claude_code_skills}}` pattern
- [ ] Standards references use correct path format
- [ ] Standards are included in agents and implementation phases

**Compilation Readiness:**
- [ ] All phase tag paths are correct
- [ ] All workflow references are correct
- [ ] All standards references are correct
- [ ] Directory structure matches expected pattern

### Testing Both Modes

**Single-Agent Mode Testing:**
1. Set config `claude_code_subagents: false`
2. Run installation script
3. Verify commands compiled from single-agent/ variants
4. Execute commands and verify workflows are followed
5. Verify output files are created correctly

**Multi-Agent Mode Testing:**
1. Set config `claude_code_subagents: true`
2. Run installation script
3. Verify commands compiled from multi-agent/ variants
4. Verify agents compiled to .claude/agents/qa-agent-os/
5. Execute commands and verify agents are invoked
6. Verify agents execute workflows correctly
7. Verify output files match single-agent mode

### Workflow Reusability Verification

**Test Workflow Reuse:**
1. Verify workflows/testing/testcase-generation.md is referenced by:
   - commands/generate-testcases/.../3-generate-cases.md
   - commands/plan-ticket/.../4-generate-cases.md
   - agents/testcase-writer.md
2. Verify workflows/testing/requirement-analysis.md is referenced by:
   - commands/plan-ticket/.../3-analyze-requirements.md
   - agents/requirement-analyst.md
3. Verify no logic duplication exists across references

**Test Cross-Command Consistency:**
1. Execute /plan-ticket with test case generation
2. Execute /generate-testcases on same ticket
3. Verify both commands produce identical test case structure
4. Verify both use same workflow logic

### Architecture Alignment Verification

**Compare with Original Pattern:**
1. Review /plan-product command (correct example)
2. Verify new commands follow same pattern:
   - Orchestration in commands
   - Implementation in workflows
   - Agents reference workflows
   - Standards injected consistently
3. Verify no anti-patterns exist:
   - No logic duplication
   - No missing multi-agent variants
   - No workflows ignored
   - No inconsistent standards injection

## Out of Scope

- Creating new features beyond architectural alignment
- Extensive documentation updates (CLAUDE.md, README.md updates are separate tasks)
- Building new tooling or compilation methods (use existing script patterns)
- Implementing bug reporting workflow (on roadmap for Phase 2)
- Creating integration workflows for Jira/Testmo (on roadmap for Phase 3)
- Modifying existing templates (feature-knowledge-template.md, test-plan-template.md, etc.)
- Changing command user interfaces or prompts (maintain current UX)
- Optimizing performance or adding new command parameters
- Refactoring compilation scripts beyond what's needed for pattern support
- Adding new agents beyond the existing 7 defined agents
