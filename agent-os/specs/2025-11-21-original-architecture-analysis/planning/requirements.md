# Spec Requirements: Original Architecture Analysis

## Initial Description

We need to understand the original agent-os architecture design that we may have missed during the QA workflow redesign. Specifically:

1. Commands have both single-agent/ and multi-agent/ folders - why?
2. Commands reference workflows like {{workflows/testing/testcase-generation}} - what's the relationship?
3. There are workflows in profiles/default/workflows/ that seem outdated or unused after refactor
4. There are agents in profiles/default/agents/ that aren't analyzed during the refactor

The recent refactor (specs/2025-11-20-qa-workflow-redesign/) may have missed important architectural patterns. We need to analyze the original design intent and ensure everything makes sense together.

## Requirements Discussion

### First Round Questions

**Q1: Multi-Agent Capabilities**
Need to support BOTH single-agent and multi-agent modes?

**Answer:** YES - Need to support BOTH single-agent and multi-agent modes

**Q2: Workflow References**
Self-contained phase files work for QA flow, but NOW need to support workflows as reusable components that multiple commands can reference?

**Answer:** YES - Self-contained phase files work for QA flow, but NOW need to support workflows as reusable components that multiple commands can reference

**Q3: Agent Roles**
Use agents/subagents as specialists to get work done?

**Answer:** YES - Use agents/subagents as specialists to get work done

**Q4: Multi-Agent Command Variants**
Create multi-agent variants following the original agent-os pattern?

**Answer:** YES - Create multi-agent variants following the original agent-os pattern

**Q5: Workflow Audit & Key Insight**
Audit workflows. IMPORTANT CLARIFICATION: If `/generate-testcases` command functionality is the same as the workflow, the logic should be IN THE WORKFLOW. This way:
- Other commands can reference the workflow (e.g., `{{workflows/testing/testcase-generation}}`)
- More token-efficient for AI
- Reusable across commands

Need to verify: Does this understanding align with the original agent-os pattern?

**Answer:** YES - Audit workflows. **IMPORTANT CLARIFICATION:** If `/generate-testcases` command functionality is the same as the workflow, the logic should be IN THE WORKFLOW. This way:
- Other commands can reference the workflow (e.g., `{{workflows/testing/testcase-generation}}`)
- More token-efficient for AI
- Reusable across commands

Need to verify: Does this understanding align with the original agent-os pattern?

**Q6: Config Flag Strategy**
Create multi-agent command variants following agent-os pattern. This makes qa-agent-os compatible with:
- AI CLIs with subagentic properties (Claude Code, OpenCode)
- Single-agent CLIs (Gemini CLI)
- Allows teams to use their preference

**Answer:** YES - Create multi-agent command variants following agent-os pattern. This makes qa-agent-os compatible with:
- AI CLIs with subagentic properties (Claude Code, OpenCode)
- Single-agent CLIs (Gemini CLI)
- Allows teams to use their preference

**Q7: Standards Injection**
Agents and commands share the same standards injection approach. Allows teams to implement their own standards, and AI follows team standards?

**Answer:** YES - Agents and commands share the same standards injection approach. Allows teams to implement their own standards, and AI follows team standards.

**Q8: Exclusions**
What should be avoided?

**Answer:**
- Avoid proposing new features
- Avoid extensive documentation
- Avoid new tooling (unless a new method is truly needed)

### Existing Code to Reference

**Similar Features Identified:**
- Feature: Original agent-os project
- Approach: Reuse same patterns and methods as much as possible
- Difference: This is a QA tool, but architectural patterns should match

**User Clarification:**
Reference the original agent-os project and reuse the same patterns and methods as much as possible. The difference is this is a QA tool, but architectural patterns should match.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - No visual files found in planning/visuals/ directory

## Requirements Summary

### Functional Requirements

Based on the user's answers and the original agent-os architecture analysis, here are the key functional requirements:

#### 1. Single-Agent vs Multi-Agent Command Variants

**Requirement:** Create both single-agent and multi-agent variants for all QA commands

**Original Pattern Observed:**
- Commands have TWO folders: `single-agent/` and `multi-agent/`
- `single-agent/`: Contains self-contained phase files with full implementation logic
- `multi-agent/`: Contains orchestrator logic that delegates to specialized subagents

**Examples Found:**
- `/plan-product` has both variants
- `/generate-testcases` has both variants
- `/analise-requirements` has both variants

**Single-Agent Pattern:**
```
commands/plan-product/single-agent/
  ├── plan-product.md          # Orchestrator with phase tags
  ├── 1-product-concept.md     # Full logic for gathering product info
  └── 2-create-mission.md      # Full logic for creating mission.md
```

**Multi-Agent Pattern:**
```
commands/plan-product/multi-agent/
  └── plan-product.md           # Delegates to product-planner subagent
```

The multi-agent variant is simpler - it delegates to specialized agents who contain the workflow logic.

#### 2. Workflow System as Reusable Components

**Requirement:** Extract reusable logic into workflows that can be referenced by multiple commands AND agents

**Original Pattern Observed:**
- Workflows exist in `profiles/default/workflows/` organized by category
- Workflows are referenced using tags: `{{workflows/testing/testcase-generation}}`
- Both COMMANDS and AGENTS can reference workflows
- Workflows contain procedural logic for specific tasks

**Current Workflow Categories:**
```
workflows/
  ├── bug-tracking/
  │   └── bug-reporting.md
  ├── planning/
  │   ├── gather-product-info.md
  │   └── create-product-mission.md
  └── testing/
      ├── compile-testing-standards.md
      ├── create-ticket.md
      ├── initialize-feature.md
      ├── requirement-analysis.md
      ├── test-planning.md
      └── testcase-generation.md
```

**Key Insight from User:**
If `/generate-testcases` command functionality is the same as the workflow, the logic should be IN THE WORKFLOW. This way:
- Other commands can reference the workflow (e.g., `{{workflows/testing/testcase-generation}}`)
- More token-efficient for AI (don't repeat logic)
- Reusable across commands

#### 3. Agent Roles as Specialists

**Requirement:** Use specialized agents (subagents) to perform specific QA tasks in multi-agent mode

**Original Pattern Observed:**
- Agents defined in `profiles/default/agents/` with YAML frontmatter + role description
- Each agent has a specialized role (product-planner, requirement-analyst, testcase-writer, bug-writer)
- Agents reference workflows using `{{workflows/...}}` tags
- Agents include standards references (unless standards_as_claude_code_skills is true)

**Agents Identified:**
```
agents/
  ├── bug-writer.md
  ├── evidence-summarizer.md
  ├── feature-initializer.md
  ├── integration-actions.md
  ├── product-planner.md
  ├── requirement-analyst.md
  └── testcase-writer.md
```

**Agent Structure Example (product-planner.md):**
```markdown
---
name: product-planner
description: Use proactively to create product documentation including mission
tools: Write, Read, Bash, WebFetch
color: cyan
model: inherit
---

# Role Description
[Specialized role responsibilities]

## Workflow
{{workflows/planning/gather-product-info}}
{{workflows/planning/create-product-mission}}

{{UNLESS standards_as_claude_code_skills}}
## Standards Reference
{{standards/global/*}}
{{ENDUNLESS standards_as_claude_code_skills}}
```

#### 4. Configuration-Driven Architecture

**Requirement:** Support both single-agent and multi-agent modes via config.yml

**Pattern:**
- config.yml controls which command variant gets compiled
- If `claude_code_subagents: true` → compile multi-agent variants
- If `claude_code_subagents: false` → compile single-agent variants
- This allows compatibility with:
  - AI CLIs with subagentic properties (Claude Code, OpenCode)
  - Single-agent CLIs (Gemini CLI)

#### 5. Standards Injection Consistency

**Requirement:** Both agents and commands use the same standards injection approach

**Pattern:**
- Standards can be injected as file references OR embedded content
- Controlled by `standards_as_claude_code_skills` flag in config.yml
- If false: Include `{{standards/category/*}}` references
- If true: Standards are available as Claude Code Skills (omit references)
- Both agents and commands honor this setting

### Reusability Opportunities

Based on the original agent-os architecture, here are key reusability opportunities:

#### 1. Workflows Should Contain Core Logic

**Current State:**
- Refactored QA commands (`/plan-ticket`, `/generate-testcases`) contain full logic in phase files
- Old workflows exist but may be outdated or unused

**Opportunity:**
- Extract core logic from refactored command phases into workflows
- Commands become thinner - they orchestrate by referencing workflows
- Workflows become the single source of truth for procedural logic

**Example:**
Instead of `/generate-testcases` phase file containing all logic:
```markdown
# 4-generate-cases.md (current)
[Full implementation logic for test case generation]
```

Extract to workflow:
```markdown
# 4-generate-cases.md (improved)
{{workflows/testing/testcase-generation}}
```

And update the workflow:
```markdown
# workflows/testing/testcase-generation.md
[Full implementation logic - single source of truth]
```

#### 2. Multi-Agent Variants Can Reuse Agents

**Current State:**
- Some commands have multi-agent variants
- Some refactored commands (plan-ticket, plan-feature) only have single-agent variants

**Opportunity:**
- Create multi-agent variants for all refactored QA commands
- Delegate to specialized agents (requirement-analyst, testcase-writer, etc.)
- Agents reference workflows, so logic is centralized

#### 3. Agent Definitions Can Reference Workflows

**Pattern Observed:**
- `product-planner` agent references `{{workflows/planning/gather-product-info}}`
- `product-planner` agent references `{{workflows/planning/create-product-mission}}`

**Opportunity:**
- Update QA agents to reference QA workflows
- `requirement-analyst` should reference `{{workflows/testing/requirement-analysis}}`
- `testcase-writer` should reference `{{workflows/testing/testcase-generation}}`

### Scope Boundaries

**In Scope:**
1. Document the original agent-os architecture patterns
2. Identify discrepancies between original design and refactored QA commands
3. Classify existing workflows as [Reusable], [Outdated], or [Needs Update]
4. Map refactored QA command phases to specialized agents
5. Provide architectural recommendations for aligning with original patterns
6. Define how multi-agent variants should be structured

**Out of Scope:**
- Proposing new features beyond architectural alignment
- Creating extensive new documentation
- Building new tooling (use existing compilation patterns)
- Implementing the refactoring (this is analysis only)

### Technical Considerations

#### 1. Phase Tag Processing

**Pattern:**
The compilation script `common-functions.sh` processes phase tags in two modes:
- No mode: Return content unchanged (file path references remain as-is)
- `embed` mode: Replace tags with actual file content

**Phase Tag Format:**
```markdown
{{PHASE 1: @qa-agent-os/commands/command-name/1-step.md}}
```

During compilation, this can be:
1. Left as-is (path reference for AI to follow)
2. Embedded with H1 header (inline content)

#### 2. Workflow Tag Processing

**Pattern:**
Workflow references use a similar tag format:
```markdown
{{workflows/testing/testcase-generation}}
```

These are processed during compilation and can be:
1. Replaced with file path reference
2. Embedded with workflow content

#### 3. Standards Reference Pattern

**Pattern:**
```markdown
{{UNLESS standards_as_claude_code_skills}}
## Standards Reference
{{standards/testcases/*}}
{{standards/testing/*}}
{{ENDUNLESS standards_as_claude_code_skills}}
```

This conditional block is included in both commands and agents, ensuring consistent standards injection based on config.

#### 4. Agent Frontmatter

**Pattern:**
```yaml
---
name: agent-name
description: Brief description
tools: Write, Read, Bash, WebFetch
color: cyan
model: inherit
---
```

This YAML frontmatter is parsed by Claude Code to define the subagent properties.

#### 5. Directory Structure Consistency

**Original Pattern:**
```
profiles/default/
  ├── commands/
  │   └── [command-name]/
  │       ├── single-agent/
  │       │   ├── [command-name].md    # Orchestrator
  │       │   ├── 1-step.md            # Phase 1 logic
  │       │   └── 2-step.md            # Phase 2 logic
  │       └── multi-agent/
  │           └── [command-name].md     # Delegates to agents
  ├── agents/
  │   └── [agent-name].md               # Agent with workflows
  └── workflows/
      └── [category]/
          └── [workflow-name].md        # Reusable logic
```

**Key Observation:**
- Single-agent commands contain self-contained phase files
- Multi-agent commands delegate to agents
- Agents reference workflows for actual implementation
- Workflows are the single source of truth for procedural logic

#### 6. Compilation Logic

**Pattern:**
Based on config.yml settings:
- `claude_code_subagents: true` → Compile multi-agent variant from `commands/[name]/multi-agent/`
- `claude_code_subagents: false` → Compile single-agent variant from `commands/[name]/single-agent/`
- Agents are compiled to `.claude/agents/qa-agent-os/` (if subagents enabled)
- Commands are compiled to `.claude/commands/qa-agent-os/`

This ensures the correct command variant is available based on the AI CLI's capabilities.
