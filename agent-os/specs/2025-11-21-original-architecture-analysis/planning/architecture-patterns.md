# Original Agent-OS Architecture Patterns

## Purpose

This document defines the architectural patterns from the original agent-os design and shows how they should be applied to qa-agent-os.

## Core Architectural Principles

### Principle 1: Separation of Concerns

**Pattern:**
The architecture separates concerns into distinct layers:

1. **Commands** - Orchestration layer (user-facing entry points)
2. **Workflows** - Procedural logic layer (reusable implementation)
3. **Agents** - Specialist roles layer (multi-agent mode delegation)
4. **Standards** - Knowledge layer (rules and conventions)

**Data Flow:**
```
User → Command → Workflow → Standards
                  ↓
                Agent → Workflow → Standards
                  (multi-agent mode)
```

---

### Principle 2: Single Source of Truth

**Pattern:**
Implementation logic exists in ONE place: workflows.

**Correct Pattern:**
```
Workflow: workflows/testing/testcase-generation.md
├─ Contains: Full test case generation logic
│
Referenced by:
├─ Command: commands/generate-testcases/single-agent/generate-testcases.md
│   └─ Uses: {{workflows/testing/testcase-generation}}
│
├─ Command: commands/plan-ticket/single-agent/4-generate-cases.md
│   └─ Uses: {{workflows/testing/testcase-generation}}
│
└─ Agent: agents/testcase-writer.md
    └─ Uses: {{workflows/testing/testcase-generation}}
```

**Anti-Pattern (What to Avoid):**
```
❌ Logic duplicated in multiple phase files
❌ Command contains full implementation
❌ Workflow exists but is unused
❌ Multiple versions of the same logic
```

---

### Principle 3: Dual-Mode Support

**Pattern:**
Every command must support BOTH single-agent and multi-agent execution modes.

**Directory Structure:**
```
commands/[command-name]/
├── single-agent/
│   ├── [command-name].md     # Orchestrator with phase tags
│   ├── 1-phase.md            # Phase 1: May contain logic OR reference workflow
│   ├── 2-phase.md            # Phase 2: May contain logic OR reference workflow
│   └── N-phase.md            # Phase N: May contain logic OR reference workflow
│
└── multi-agent/
    └── [command-name].md     # Orchestrator that delegates to agents
```

**Compilation:**
- Config `claude_code_subagents: true` → Compile multi-agent variant
- Config `claude_code_subagents: false` → Compile single-agent variant

---

## Detailed Pattern Definitions

### Pattern A: Command Orchestration

**Definition:**
Commands are the user-facing entry points. They orchestrate the execution of phases but DO NOT contain core implementation logic.

**Single-Agent Command Structure:**

```markdown
# /command-name Command

## Purpose
[What this command does]

## Usage
/command-name [parameters]

## Execution Phases

This command executes the following phases in sequence:

{{PHASE 1: @qa-agent-os/commands/command-name/1-phase.md}}

{{PHASE 2: @qa-agent-os/commands/command-name/2-phase.md}}

{{PHASE N: @qa-agent-os/commands/command-name/N-phase.md}}
```

**Phase File Structure (Two Options):**

**Option A: Orchestration Only (Preferred)**
```markdown
# Phase N: [Phase Name]

## What This Phase Does
[Brief description]

## Execution

{{workflows/category/workflow-name}}

## Next Steps
[What happens after this phase]
```

**Option B: Orchestration + Custom Logic (When Needed)**
```markdown
# Phase N: [Phase Name]

## Step 1: Custom Pre-Processing
[Command-specific logic that can't be in workflow]

## Step 2: Execute Core Workflow
{{workflows/category/workflow-name}}

## Step 3: Custom Post-Processing
[Command-specific logic after workflow]
```

**Key Points:**
- Phases can be purely orchestration (reference workflows)
- Phases can include command-specific logic AROUND workflow calls
- Phases should NOT duplicate logic that belongs in workflows

---

**Multi-Agent Command Structure:**

```markdown
# /command-name Command (Multi-Agent Mode)

## Purpose
[What this command does]

This command delegates work to specialized agents for efficient execution.

## Execution Flow

### PHASE 1: [Phase Name]

Use the **[agent-name]** subagent to [what the agent does].

Provide the agent with:
- [Input 1]
- [Input 2]
- [Input N]

The agent will:
- [Responsibility 1]
- [Responsibility 2]
- [Responsibility N]

### PHASE 2: [Phase Name]

Use the **[agent-name]** subagent to [what the agent does].

[Similar structure as Phase 1]

### Final Step

Once all agents have completed their work:
```
[Success message]
```
```

**Key Points:**
- Multi-agent commands are SIMPLER than single-agent
- They delegate to specialized agents
- They don't contain implementation logic
- They provide context and coordinate agents

---

### Pattern B: Workflow Implementation

**Definition:**
Workflows contain the actual procedural logic for specific tasks. They are designed to be reusable across multiple commands and agents.

**Workflow Structure:**

```markdown
# [Workflow Name] Workflow

This workflow [describes what the workflow does].

## Core Responsibilities

1. **[Responsibility 1]**: [Description]
2. **[Responsibility 2]**: [Description]
3. **[Responsibility N]**: [Description]

**Note:** The placeholder `[variable-name]` in this workflow refers to [explanation].

---

## Workflow

### Step 0: [Optional Preparation Step]

[Preparation logic - e.g., compile standards, validate inputs]

{{workflows/utility/some-utility-workflow}}

### Step 1: [First Main Step]

[Implementation logic for step 1]

**Action:**
```bash
# Example bash command
ls -la [path-variable]
```

### Step 2: [Second Main Step]

[Implementation logic for step 2]

**Process:**
- [Sub-step A]
- [Sub-step B]
- [Sub-step C]

### Step 3: [Third Main Step]

[Implementation logic for step 3]

**Output:**
Create file at `[output-path]` with structure:
```markdown
[File structure template]
```

### Step N: [Final Step]

[Completion logic]
```

**Key Characteristics:**
- Self-contained procedural logic
- Uses placeholders for variable inputs
- Includes bash commands, file operations, decision logic
- Can reference OTHER workflows for utility functions
- Does NOT include orchestration (that's in commands)

---

### Pattern C: Agent Specialization

**Definition:**
Agents are specialized roles that execute specific types of work in multi-agent mode. They reference workflows for their implementation.

**Agent Structure:**

```markdown
---
name: agent-name
description: Brief description of agent's role and purpose
tools: Write, Read, Bash, WebFetch
color: cyan
model: inherit
---

# [Agent Display Name]

You are a [role description]. Your goal is to [agent's goal].

## Responsibilities

1. **[Responsibility 1]**: [Description]
2. **[Responsibility 2]**: [Description]
3. **[Responsibility N]**: [Description]

## Inputs
- [Input 1]: [Where it comes from]
- [Input 2]: [Where it comes from]

## Outputs
- **[Output 1]**: [What it creates]
- **[Output 2]**: [What it creates]

## Instructions
- [Specific instruction 1]
- [Specific instruction 2]
- [Specific instruction N]

## Workflow

### Step 1: [Phase Name]

{{workflows/category/workflow-name}}

### Step 2: [Phase Name]

{{workflows/category/another-workflow}}

### Step N: Final Validation

[Agent-specific finalization logic]

{{UNLESS standards_as_claude_code_skills}}
## Standards Reference

Ensure compliance with all applicable standards:

{{standards/category/*}}
{{ENDUNLESS standards_as_claude_code_skills}}
```

**Key Characteristics:**
- YAML frontmatter defines agent properties for Claude Code
- Role-based description (product-planner, requirement-analyst, testcase-writer)
- References workflows for implementation
- Includes standards references (conditional on config)
- Specialized for a specific domain

---

### Pattern D: Standards Integration

**Definition:**
Standards are injected into both commands and agents to ensure AI follows team conventions.

**Conditional Block Pattern:**

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
- If `standards_as_claude_code_skills: false` in config.yml:
  - Block is INCLUDED in compiled output
  - Tags like `{{standards/testcases/*}}` are replaced with file paths
  - AI reads standards from file references

- If `standards_as_claude_code_skills: true` in config.yml:
  - Block is REMOVED from compiled output
  - Standards are available as Claude Code Skills
  - AI accesses standards from Skills context (not file references)

**Where to Include:**
- In agents (so agents honor standards)
- In command phase files (if they contain implementation)
- NOT needed in pure orchestration phases (workflow handles it)

---

## Applied Patterns: QA Commands Example

### Example: /generate-testcases Command

This example shows how the patterns should be applied to the refactored `/generate-testcases` command.

#### Current State (Incorrect Pattern)

**Problem:**
- Command only has single-agent variant (missing multi-agent)
- Phase file contains full implementation logic (should reference workflow)
- Workflow exists but is outdated (not referenced)

**Current Structure:**
```
commands/generate-testcases/
├── single-agent/
│   └── generate-testcases.md  # Contains documentation only, no phase files
└── multi-agent/
    └── generate-testcases.md  # Exists but outdated
```

---

#### Correct Pattern (How It Should Be)

**Directory Structure:**
```
commands/generate-testcases/
├── single-agent/
│   ├── generate-testcases.md          # Orchestrator
│   ├── 1-select-ticket.md             # Phase 1: Ticket selection logic
│   ├── 2-detect-conflicts.md          # Phase 2: Conflict detection
│   └── 3-generate-cases.md            # Phase 3: References workflow
│
└── multi-agent/
    └── generate-testcases.md          # Delegates to testcase-writer agent
```

---

**Single-Agent Orchestrator:**

```markdown
# /generate-testcases Command

## Purpose

Generate or regenerate detailed test cases from a test plan.

## Usage

```bash
/generate-testcases              # Interactive - select which ticket
/generate-testcases WYX-123      # Direct - generate for specific ticket
```

## Execution Phases

This command executes the following phases:

{{PHASE 1: @qa-agent-os/commands/generate-testcases/1-select-ticket.md}}

{{PHASE 2: @qa-agent-os/commands/generate-testcases/2-detect-conflicts.md}}

{{PHASE 3: @qa-agent-os/commands/generate-testcases/3-generate-cases.md}}
```

---

**Phase 1: Ticket Selection (Command-Specific Logic)**

```markdown
# Phase 1: Select Ticket

## Smart Ticket Selection

This phase handles ticket identification based on how the command was called.

### Step 1: Check Command Parameters

If ticket ID was provided as parameter:
```bash
# User ran: /generate-testcases WYX-123
TICKET_ID="WYX-123"
```
Skip to Phase 2.

### Step 2: Interactive Selection (No Parameter Provided)

If no parameter was provided, list recent tickets:

1. Scan `qa-agent-os/features/` for ticket folders
2. Sort by most recently modified
3. Display numbered list:
```
Recent tickets:
[1] WYX-123 - Last modified: 2025-11-20
[2] WYX-122 - Last modified: 2025-11-19
[3] WYX-121 - Last modified: 2025-11-18

Select ticket [1-3]:
```

4. User selects ticket
5. Set TICKET_ID for next phase

### Step 3: Validate Ticket Exists

Verify the selected ticket has a test plan:
```bash
TEST_PLAN="qa-agent-os/features/[feature]/[ticket-id]/test-plan.md"
```

If test plan doesn't exist:
```
Error: No test plan found for [ticket-id]
Run /plan-ticket [ticket-id] first to create the test plan.
```

Proceed to Phase 2.
```

**Note:** This phase contains COMMAND-SPECIFIC logic (UI interaction) that can't be in a workflow.

---

**Phase 2: Detect Conflicts (Command-Specific Logic)**

```markdown
# Phase 2: Detect Conflicts

## Check for Existing Test Cases

This phase checks if test-cases.md already exists and prompts the user.

### Step 1: Check for Existing File

```bash
TEST_CASES_FILE="qa-agent-os/features/[feature]/[ticket-id]/test-cases.md"

if [ -f "$TEST_CASES_FILE" ]; then
    echo "Test cases already exist for this ticket."
    CONFLICT=true
else
    CONFLICT=false
fi
```

### Step 2: Prompt User (If Conflict)

If CONFLICT is true:
```
Test cases already exist for [ticket-id].

Choose an option:
[1] Overwrite - Replace existing test cases completely
[2] Append - Add new test cases to existing ones
[3] Cancel - Stop without making changes

Select [1-3]:
```

Store user's choice as CONFLICT_RESOLUTION:
- "overwrite"
- "append"
- "cancel"

If user chose "cancel", exit command.

### Step 3: Set Generation Mode

Based on CONFLICT_RESOLUTION:
- "overwrite" → MODE="overwrite"
- "append" → MODE="append"
- No conflict → MODE="create"

Pass MODE to Phase 3.

Proceed to Phase 3.
```

**Note:** This phase contains COMMAND-SPECIFIC logic (conflict resolution UI) that can't be in a workflow.

---

**Phase 3: Generate Cases (References Workflow)**

```markdown
# Phase 3: Generate Test Cases

## Execute Test Case Generation

This phase generates the test cases using the core workflow.

### Step 1: Prepare Context

Set workflow variables:
- TICKET_PATH: `qa-agent-os/features/[feature]/[ticket-id]`
- MODE: [create|overwrite|append]
- TEST_PLAN_PATH: `[ticket-path]/test-plan.md`
- OUTPUT_PATH: `[ticket-path]/test-cases.md`

### Step 2: Execute Generation Workflow

{{workflows/testing/testcase-generation}}

The workflow will:
- Read the test plan
- Extract test scenarios and coverage requirements
- Generate detailed test cases
- Save to test-cases.md (respecting MODE)

### Step 3: Completion

Once workflow completes:
```
✓ Test cases generated successfully!

Output: qa-agent-os/features/[feature]/[ticket-id]/test-cases.md

NEXT STEPS:
- Review test cases for completeness
- Execute tests and track results
- Report bugs using /report-bug (when available)
```
```

**Note:** This phase REFERENCES the workflow instead of containing generation logic.

---

**Multi-Agent Orchestrator:**

```markdown
# /generate-testcases Command (Multi-Agent Mode)

## Purpose

Generate or regenerate detailed test cases from a test plan using the testcase-writer agent.

## Usage

```bash
/generate-testcases              # Interactive
/generate-testcases WYX-123      # Direct
```

## Execution Flow

### PHASE 1: Identify Ticket

[Same smart selection logic as single-agent Phase 1]

### PHASE 2: Check for Conflicts

[Same conflict detection logic as single-agent Phase 2]

### PHASE 3: Generate Test Cases

Use the **testcase-writer** subagent to generate comprehensive test cases.

Provide the testcase-writer with:
- Ticket path: `qa-agent-os/features/[feature]/[ticket-id]`
- Test plan: `[ticket-path]/test-plan.md`
- Generation mode: [create|overwrite|append]
- Any visual assets in `[ticket-path]/documentation/`

The testcase-writer will:
- Read and analyze the test plan
- Extract test scenarios and coverage matrix
- Generate detailed executable test cases
- Save to `[ticket-path]/test-cases.md`
- Follow all applicable testing standards

Once the testcase-writer completes:
```
✓ Test cases generated successfully!

Output: qa-agent-os/features/[feature]/[ticket-id]/test-cases.md
```
```

**Note:** Multi-agent version delegates Phase 3 to the agent instead of calling workflow directly.

---

**Updated Workflow:**

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
- Section 5: Test Coverage Matrix (requirement → test case mapping)
- Section 6: Test Scenarios & Cases (positive, negative, edge cases)
- Section 7: Test Data Requirements
- Section 4: Testable Requirements (detailed requirements breakdown)

### Step 2: Generate Test Cases

Based on test plan content, generate test cases with this structure:

**For each test scenario:**
1. Create test case ID: [TICKET-ID]-TC-[NUMBER]
2. Define test case type: [Functional|Negative|Edge|API|Integration]
3. Set priority: [High|Medium|Low] based on requirement priority
4. Write clear objective
5. Define preconditions
6. Create detailed steps in table format:
   | Step | Action | Expected Result |
7. Reference test data from Section 7
8. Define expected final result
9. Include execution tracking:
   - [ ] Pass
   - [ ] Fail
   - [ ] Blocked
10. Add space for notes and defect links

### Step 3: Coverage Analysis

Compare generated test cases against coverage matrix:
- Verify all requirements have at least one test case
- Verify positive, negative, and edge cases are covered
- Flag any coverage gaps

### Step 4: Automation Recommendations

For each test case, analyze automation potential:
- API tests: High automation priority
- Repetitive functional tests: Medium automation priority
- Exploratory tests: Low automation priority

### Step 5: Save Test Cases

Save to `[ticket-path]/test-cases.md` with structure:

```markdown
# Test Cases: [Ticket ID]

## Test Execution Summary

| Test ID | Type | Priority | Status | Executed By | Date | Defects |
|---------|------|----------|--------|-------------|------|---------|
| [ID] | [Type] | [Priority] | [ ] | | | |

## Detailed Test Cases

[Generated test cases]

## Test Data Reference

[Test data from test plan Section 7]

## Coverage Analysis

[Coverage report]

## Automation Recommendations

[Automation priorities]
```

Respect MODE variable:
- create: Write new file
- overwrite: Replace existing file
- append: Add new test cases to existing file (update summary table)
```

**Note:** This workflow is now the SINGLE SOURCE OF TRUTH for test case generation logic. Both commands and agents reference it.

---

### Example: /plan-ticket Command

This shows how the more complex `/plan-ticket` command should follow the patterns.

#### Current State (Partially Correct)

**What's Right:**
- Has orchestrator with phase tags
- Has detailed phase files
- Includes smart detection and gap detection logic

**What's Wrong:**
- Only has single-agent variant (missing multi-agent)
- Phase files contain full implementation (should reference workflows where applicable)
- Doesn't reuse existing workflows

---

#### Correct Pattern

**Directory Structure:**
```
commands/plan-ticket/
├── single-agent/
│   ├── plan-ticket.md                    # Orchestrator
│   ├── 0-detect-context.md              # Phase 0: Command-specific detection
│   ├── 1-init-ticket.md                 # Phase 1: References workflow
│   ├── 2-gather-ticket-docs.md          # Phase 2: Command-specific gathering
│   ├── 3-analyze-requirements.md        # Phase 3: References workflow
│   └── 4-generate-cases.md              # Phase 4: References workflow
│
└── multi-agent/
    └── plan-ticket.md                    # Delegates to agents
```

**Phase 1: Initialize Ticket (Should Reference Workflow)**

**Current (Incorrect):**
```markdown
# Phase 1: Initialize Ticket

[Full implementation logic for creating folders and files]
```

**Correct:**
```markdown
# Phase 1: Initialize Ticket

## Setup Ticket Structure

This phase creates the ticket directory structure.

### Variables Set from Phase 0
- FEATURE_PATH: `qa-agent-os/features/[feature-name]`
- TICKET_ID: [ticket-id]

### Create Ticket Structure

{{workflows/testing/initialize-ticket}}

The workflow will create:
- Ticket folder: `[feature-path]/[ticket-id]/`
- Documentation folder: `[feature-path]/[ticket-id]/documentation/`
- README.md with ticket information

Proceed to Phase 2.
```

**Note:** Create a new workflow `workflows/testing/initialize-ticket.md` with the folder creation logic.

---

**Phase 3: Analyze Requirements (Should Reference Workflow)**

**Current (Partially Correct):**
Phase file contains full gap detection and test plan creation logic (116 lines).

**Correct:**
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

### Post-Workflow Actions

After workflow completes, prompt user:
```
Test plan created successfully!

Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first, generate test cases later)

Choose [1/2]:
```

If user chooses [1], proceed to Phase 4.
If user chooses [2], exit command with helpful message.
```

**Note:** The workflow contains the core logic. The phase file handles the user prompt (command-specific orchestration).

---

**Multi-Agent Variant:**

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

[Same detection logic as single-agent]

### PHASE 1-2: Initialize and Gather

Use the **feature-initializer** subagent to set up the ticket structure and gather documentation.

Provide the feature-initializer with:
- Feature path
- Ticket ID
- Any provided documentation

The feature-initializer will:
- Create ticket directory structure
- Gather ticket documentation
- Create README.md

### PHASE 3: Analyze Requirements

Use the **requirement-analyst** subagent to analyze requirements and create the test plan.

Provide the requirement-analyst with:
- Ticket path
- Feature knowledge path
- Feature test strategy path

The requirement-analyst will:
- Analyze ticket requirements
- Perform gap detection against feature knowledge
- Prompt to update feature knowledge if needed
- Create comprehensive test-plan.md

Once requirement-analyst completes, prompt:
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
- Test plan
- Generation mode (create)

The testcase-writer will:
- Read test plan
- Generate executable test cases
- Save to test-cases.md

### Completion

```
✓ Ticket planning complete!

Created:
- Test plan: qa-agent-os/features/[feature]/[ticket-id]/test-plan.md
- Test cases: qa-agent-os/features/[feature]/[ticket-id]/test-cases.md
```
```

**Note:** Multi-agent version delegates to three agents: feature-initializer, requirement-analyst, and testcase-writer.

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Logic Duplication

**Problem:**
Same logic exists in multiple places (command phases, workflows, agents).

**Example:**
```
❌ commands/generate-testcases/single-agent/generate-testcases.md
   Contains: Full test case generation logic (500 lines)

❌ commands/plan-ticket/single-agent/4-generate-cases.md
   Contains: Full test case generation logic (500 lines - duplicated!)

❌ workflows/testing/testcase-generation.md
   Contains: Outdated test case generation logic (ignored)
```

**Solution:**
Update workflow with latest logic, have both commands reference it:
```
✓ workflows/testing/testcase-generation.md
  Contains: Latest test case generation logic (single source of truth)

✓ commands/generate-testcases/single-agent/3-generate-cases.md
  References: {{workflows/testing/testcase-generation}}

✓ commands/plan-ticket/single-agent/4-generate-cases.md
  References: {{workflows/testing/testcase-generation}}
```

---

### Anti-Pattern 2: Missing Multi-Agent Variants

**Problem:**
Commands only have single-agent variants, can't leverage specialized agents.

**Example:**
```
❌ commands/plan-ticket/
   └── single-agent/
       └── ...

Missing: multi-agent variant!
```

**Solution:**
Create both variants:
```
✓ commands/plan-ticket/
   ├── single-agent/
   │   └── ... (references workflows)
   └── multi-agent/
       └── plan-ticket.md (delegates to agents)
```

---

### Anti-Pattern 3: Workflows Not Referenced

**Problem:**
Workflows exist but commands don't use them.

**Example:**
```
❌ workflows/testing/requirement-analysis.md exists
❌ commands/plan-ticket/single-agent/3-analyze-requirements.md
   Contains full logic, doesn't reference workflow
```

**Solution:**
Update command to reference workflow:
```
✓ commands/plan-ticket/single-agent/3-analyze-requirements.md
  References: {{workflows/testing/requirement-analysis}}
```

---

### Anti-Pattern 4: Inconsistent Standards Injection

**Problem:**
Some components include standards, others don't.

**Solution:**
Include standards block consistently:
- In ALL agents
- In command phases that contain implementation logic
- NOT in pure orchestration phases (workflow handles it)

---

## Pattern Compliance Checklist

Use this checklist to verify a command follows the correct patterns:

### Command Structure
- [ ] Command has BOTH single-agent/ and multi-agent/ variants
- [ ] Single-agent has orchestrator with phase tags
- [ ] Single-agent phases reference workflows where appropriate
- [ ] Multi-agent delegates to specialized agents
- [ ] Orchestrators include clear usage documentation

### Workflow Integration
- [ ] Core logic exists in workflows (not duplicated in phases)
- [ ] Workflows are properly structured with clear steps
- [ ] Workflows use placeholder variables consistently
- [ ] Workflows are referenced using correct tag format

### Agent Integration
- [ ] Agents have proper YAML frontmatter
- [ ] Agents reference workflows for implementation
- [ ] Agents include standards block (conditional)
- [ ] Agents have clear role descriptions

### Standards Compliance
- [ ] Standards block uses {{UNLESS standards_as_claude_code_skills}} pattern
- [ ] Standards references use correct path format
- [ ] Standards are included in agents and implementation phases

### Compilation Readiness
- [ ] All phase tag paths are correct
- [ ] All workflow references are correct
- [ ] All standards references are correct
- [ ] Directory structure matches expected pattern

---

## Conclusion

The original agent-os architecture provides a clear, consistent pattern for building AI-assisted workflows:

1. **Commands orchestrate** - They coordinate execution but delegate implementation
2. **Workflows implement** - They contain the procedural logic as single source of truth
3. **Agents specialize** - They reference workflows and provide expert domain knowledge
4. **Standards guide** - They ensure AI follows team conventions consistently

Following these patterns results in:
- No logic duplication
- Maximum reusability
- Token efficiency
- Easy maintenance
- Consistent architecture
- Support for both single-agent and multi-agent modes

The refactored QA commands should be updated to follow these patterns for architectural consistency.
