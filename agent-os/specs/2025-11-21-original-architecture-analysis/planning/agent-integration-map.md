# Agent Integration Map

## Purpose

This document maps refactored QA command phases to specialized agents, showing how multi-agent variants should delegate work and which agents need updates.

## Agent Inventory

### Current Agents in profiles/default/agents/

1. **product-planner.md**
   - Role: Product planning specialist
   - Tools: Write, Read, Bash, WebFetch
   - References: workflows/planning/gather-product-info, workflows/planning/create-product-mission
   - Status: ✅ Active (used by /plan-product multi-agent)

2. **requirement-analyst.md**
   - Role: QA requirement analyst
   - Tools: Write, Bash
   - References: standards/requirement-analysis/*
   - Status: ⚠️ Needs Update (doesn't reference workflow)

3. **testcase-writer.md**
   - Role: Test case generator
   - Tools: Write, Bash
   - References: standards/testcases/*, standards/testing/*
   - Status: ⚠️ Needs Update (references old workflow pattern)

4. **bug-writer.md**
   - Role: Bug report creator
   - Tools: Write, Read, Bash
   - References: standards/bugs/*
   - Status: ⚠️ On Hold (no corresponding command yet, roadmap shows /report-bug in Phase 2)

5. **feature-initializer.md**
   - Role: Feature structure creator
   - Tools: Write, Bash
   - References: workflows/testing/initialize-feature
   - Status: ⚠️ Needs Update (workflow needs alignment with /plan-feature)

6. **evidence-summarizer.md**
   - Role: Test evidence organizer
   - Tools: Read, Bash
   - Status: ⚠️ On Hold (no corresponding workflow or command)

7. **integration-actions.md**
   - Role: External tool integration handler
   - Tools: Write, Read, Bash, WebFetch
   - Status: ⚠️ On Hold (integrations in Phase 3 of roadmap)

---

## Command → Agent Mapping

### /plan-product Command

**Single-Agent Phases:**
1. Phase 1: Gather product concept → workflows/planning/gather-product-info
2. Phase 2: Create mission.md → workflows/planning/create-product-mission

**Multi-Agent Delegation:**
```
Phase 1-2: Use product-planner agent
├─ Agent executes: workflows/planning/gather-product-info
└─ Agent executes: workflows/planning/create-product-mission
```

**Status:** ✅ Correctly Implemented
- Multi-agent variant exists
- Agent properly references workflows
- Follows original pattern

---

### /plan-feature Command

**Current State:**
- Only single-agent variant exists
- 4 phases: init-structure, gather-docs, consolidate-knowledge, create-strategy
- Phases contain full implementation logic

**Agent Mapping (Proposed):**

| Phase | Current Logic | Should Delegate To | Workflow Reference |
|-------|--------------|-------------------|-------------------|
| Phase 1: Initialize | Create feature folder structure | feature-initializer | workflows/planning/initialize-feature |
| Phase 2: Gather Docs | Collect BRDs, specs, mockups | feature-initializer | workflows/planning/gather-feature-docs |
| Phase 3: Consolidate Knowledge | Create feature-knowledge.md | requirement-analyst | workflows/planning/consolidate-feature-knowledge |
| Phase 4: Create Strategy | Create feature-test-strategy.md | requirement-analyst | workflows/planning/create-test-strategy |

**Multi-Agent Variant Structure (Proposed):**

```markdown
# /plan-feature Command (Multi-Agent Mode)

## Execution Flow

### PHASE 1-2: Initialize and Gather

Use the **feature-initializer** subagent to set up the feature structure and gather documentation.

Provide the feature-initializer with:
- Feature name
- Any initial documentation provided by user

The feature-initializer will:
- Create feature folder structure
- Create documentation/ folder
- Gather BRDs, API specs, mockups, technical docs
- Create README.md

### PHASE 3: Consolidate Feature Knowledge

Use the **requirement-analyst** subagent to consolidate all documentation into feature-knowledge.md.

Provide the requirement-analyst with:
- Feature path
- Documentation collected in Phase 2

The requirement-analyst will:
- Analyze all documentation
- Extract business rules, APIs, edge cases, user flows
- Create feature-knowledge.md (8 sections)

### PHASE 4: Create Test Strategy

Use the **requirement-analyst** subagent to create the feature-level test strategy.

Provide the requirement-analyst with:
- Feature path
- Feature knowledge from Phase 3

The requirement-analyst will:
- Define testing approach
- Document test environment, tools, risks
- Create feature-test-strategy.md (10 sections)

### Completion
[Success message]
```

**Workflows Needed:**
1. workflows/planning/initialize-feature.md (update existing)
2. workflows/planning/gather-feature-docs.md (new)
3. workflows/planning/consolidate-feature-knowledge.md (new)
4. workflows/planning/create-test-strategy.md (new)

**Agent Updates Needed:**
1. feature-initializer.md - Add gather-feature-docs workflow reference
2. requirement-analyst.md - Add consolidate-feature-knowledge and create-test-strategy workflow references

---

### /plan-ticket Command

**Current State:**
- Only single-agent variant exists
- 5 phases (0-4): detect-context, init-ticket, gather-docs, analyze-requirements, generate-cases
- Phases contain full implementation logic

**Agent Mapping (Proposed):**

| Phase | Current Logic | Should Delegate To | Workflow Reference |
|-------|--------------|-------------------|-------------------|
| Phase 0: Detect Context | Smart feature detection, ticket detection | N/A (orchestration logic) | N/A |
| Phase 1: Initialize | Create ticket folder structure | feature-initializer | workflows/testing/initialize-ticket |
| Phase 2: Gather Docs | Collect ticket documentation | feature-initializer | workflows/testing/gather-ticket-docs |
| Phase 3: Analyze Requirements | Gap detection, create test-plan.md | requirement-analyst | workflows/testing/requirement-analysis |
| Phase 4: Generate Cases | Create test-cases.md | testcase-writer | workflows/testing/testcase-generation |

**Multi-Agent Variant Structure (Proposed):**

```markdown
# /plan-ticket Command (Multi-Agent Mode)

## Execution Flow

### PHASE 0: Smart Detection

[Keep this in orchestrator - it's command-specific UI logic]
- Detect existing features
- Auto-select or prompt user
- Detect existing ticket
- Offer re-execution options

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
- Test plan: [path]
- Test cases: [path] (if generated)
- Feature knowledge updated: [yes/no]
```
```

**Workflows Needed:**
1. workflows/testing/initialize-ticket.md (new)
2. workflows/testing/gather-ticket-docs.md (new)
3. workflows/testing/requirement-analysis.md (update existing - add gap detection)
4. workflows/testing/testcase-generation.md (update existing)

**Agent Updates Needed:**
1. feature-initializer.md - Add initialize-ticket and gather-ticket-docs workflows
2. requirement-analyst.md - Ensure references updated requirement-analysis workflow
3. testcase-writer.md - Ensure references updated testcase-generation workflow

---

### /generate-testcases Command

**Current State:**
- Has both single-agent and multi-agent variants
- Single-agent is documentation-only (no phase files)
- Multi-agent delegates to testcase-writer but may be outdated

**Agent Mapping (Proposed):**

| Phase | Current Logic | Should Delegate To | Workflow Reference |
|-------|--------------|-------------------|-------------------|
| Phase 1: Select Ticket | Interactive ticket selection | N/A (orchestration logic) | N/A |
| Phase 2: Detect Conflicts | Check existing test-cases.md | N/A (orchestration logic) | N/A |
| Phase 3: Generate Cases | Create test-cases.md | testcase-writer | workflows/testing/testcase-generation |

**Multi-Agent Variant Structure (Proposed):**

```markdown
# /generate-testcases Command (Multi-Agent Mode)

## Execution Flow

### PHASE 1: Select Ticket

[Keep in orchestrator - command-specific UI]

If ticket ID provided: Use it
Else: Show numbered list and prompt user

### PHASE 2: Detect Conflicts

[Keep in orchestrator - command-specific UI]

Check if test-cases.md exists
If exists: Prompt [1] Overwrite [2] Append [3] Cancel
Store user's choice as MODE

### PHASE 3: Generate Test Cases

Use the **testcase-writer** subagent to generate comprehensive test cases.

Provide the testcase-writer with:
- Ticket path
- Test plan path
- Generation mode: [create|overwrite|append]
- Visual assets (if any)

The testcase-writer will:
- Read test plan
- Extract scenarios and coverage requirements
- Generate detailed executable test cases
- Save to test-cases.md (respecting MODE)
- Follow all testing standards

### Completion
```
✓ Test cases generated successfully!

Output: [path]
```
```

**Workflows Needed:**
1. workflows/testing/testcase-generation.md (update existing)

**Agent Updates Needed:**
1. testcase-writer.md - Ensure references updated testcase-generation workflow

---

### /revise-test-plan Command

**Current State:**
- Only single-agent variant exists
- Phases handle: detect ticket, prompt for update type, apply update, increment version

**Agent Mapping (Proposed):**

| Phase | Current Logic | Should Delegate To | Workflow Reference |
|-------|--------------|-------------------|-------------------|
| Phase 1: Detect Ticket | Find and select ticket | N/A (orchestration logic) | N/A |
| Phase 2: Prompt Update Type | Ask user what to update | N/A (orchestration logic) | N/A |
| Phase 3: Apply Update | Update test-plan.md | requirement-analyst | workflows/testing/revise-test-plan |
| Phase 4: Optional Regenerate | Offer to regenerate cases | testcase-writer (if yes) | workflows/testing/testcase-generation |

**Multi-Agent Variant Structure (Proposed):**

```markdown
# /revise-test-plan Command (Multi-Agent Mode)

## Execution Flow

### PHASE 1-2: Detect and Prompt

[Keep in orchestrator - command-specific UI]

Select ticket
Prompt for update type:
[1] New edge case found
[2] New test scenario needed
[3] Existing scenario needs update
[4] New requirement discovered
[5] Test data needs adjustment

### PHASE 3: Apply Update

Use the **requirement-analyst** subagent to update the test plan.

Provide the requirement-analyst with:
- Ticket path
- Test plan path
- Update type
- Update details from user

The requirement-analyst will:
- Read current test plan
- Apply the update to appropriate section
- Add revision log entry
- Increment version number
- Save updated test-plan.md

### PHASE 4: Optional Regeneration

After update completes, prompt:
```
Test plan updated successfully!

Would you like to regenerate test cases now? [y/n]
```

If yes:

Use the **testcase-writer** subagent to regenerate test cases.

[Same as /generate-testcases Phase 3]

### Completion
[Success message]
```

**Workflows Needed:**
1. workflows/testing/revise-test-plan.md (new)
2. workflows/testing/testcase-generation.md (reuse existing)

**Agent Updates Needed:**
1. requirement-analyst.md - Add revise-test-plan workflow reference
2. testcase-writer.md - Already has testcase-generation workflow

---

### /update-feature-knowledge Command

**Current State:**
- Only single-agent variant exists
- Rare command for manual feature knowledge updates

**Agent Mapping (Proposed):**

| Phase | Current Logic | Should Delegate To | Workflow Reference |
|-------|--------------|-------------------|-------------------|
| Phase 1: Detect Feature | Find and select feature | N/A (orchestration logic) | N/A |
| Phase 2: Prompt Update Type | Ask user what to add | N/A (orchestration logic) | N/A |
| Phase 3: Apply Update | Update feature-knowledge.md | requirement-analyst | workflows/planning/update-feature-knowledge |

**Multi-Agent Variant Structure (Proposed):**

```markdown
# /update-feature-knowledge Command (Multi-Agent Mode)

## Execution Flow

### PHASE 1-2: Detect and Prompt

[Keep in orchestrator - command-specific UI]

Select feature
Prompt for update type:
[1] Add new business rule
[2] Add new API endpoint
[3] Update existing information
[4] Add edge case documentation
[5] Add open question

### PHASE 3: Apply Update

Use the **requirement-analyst** subagent to update the feature knowledge.

Provide the requirement-analyst with:
- Feature path
- Feature knowledge path
- Update type
- Update details from user

The requirement-analyst will:
- Read current feature knowledge
- Apply the update to appropriate section
- Add metadata (source: manual update, date)
- Save updated feature-knowledge.md

### Completion
[Success message]
```

**Workflows Needed:**
1. workflows/planning/update-feature-knowledge.md (new)

**Agent Updates Needed:**
1. requirement-analyst.md - Add update-feature-knowledge workflow reference

---

## Agent Update Requirements

### 1. feature-initializer.md

**Current References:**
- workflows/testing/initialize-feature

**Required Updates:**
Add references to new workflows:
```markdown
## Workflow

### Feature Initialization
{{workflows/planning/initialize-feature}}

### Feature Documentation Gathering
{{workflows/planning/gather-feature-docs}}

### Ticket Initialization
{{workflows/testing/initialize-ticket}}

### Ticket Documentation Gathering
{{workflows/testing/gather-ticket-docs}}
```

**Why:**
This agent is responsible for all initialization tasks (features and tickets), so it needs references to all initialization workflows.

---

### 2. requirement-analyst.md

**Current References:**
- standards/requirement-analysis/* (direct standards, no workflow)

**Required Updates:**
Add workflow references:
```markdown
## Workflow

### Feature Knowledge Consolidation
{{workflows/planning/consolidate-feature-knowledge}}

### Feature Test Strategy Creation
{{workflows/planning/create-test-strategy}}

### Ticket Requirement Analysis
{{workflows/testing/requirement-analysis}}

### Test Plan Revision
{{workflows/testing/revise-test-plan}}

### Feature Knowledge Updates
{{workflows/planning/update-feature-knowledge}}
```

**Why:**
This agent handles all requirement analysis, knowledge consolidation, and test planning tasks. It needs references to all related workflows.

---

### 3. testcase-writer.md

**Current References:**
- standards/testcases/*
- standards/testing/*
- Mentions reading requirements.md and test-plan.md

**Required Updates:**
Add clear workflow reference:
```markdown
## Workflow

### Test Case Generation
{{workflows/testing/testcase-generation}}

This workflow handles:
- Reading test plans
- Extracting scenarios and coverage requirements
- Generating detailed executable test cases
- Saving to test-cases.md with proper structure
```

**Current Issues:**
```markdown
# Current content (lines 28-33):
- Read both `requirements.md` and `test-plan.md` before writing...
```

This is outdated - requirements.md is from old pattern, test-plan.md is current.

**Why:**
This agent generates test cases, so it must reference the testcase-generation workflow as its single source of truth.

---

### 4. bug-writer.md

**Status:** On Hold

**Current References:**
- standards/bugs/*

**Future Updates (When /report-bug is implemented):**
```markdown
## Workflow

### Bug Report Creation
{{workflows/bug-tracking/bug-reporting}}
```

**Why:**
When bug reporting command is implemented (Phase 2 of roadmap), this agent will need to reference the bug-reporting workflow.

---

### 5. product-planner.md

**Status:** ✅ Already Correct

**Current References:**
- workflows/planning/gather-product-info
- workflows/planning/create-product-mission

**No updates needed** - This agent already follows the correct pattern.

---

### 6. evidence-summarizer.md

**Status:** On Hold

**Current Content:**
Very brief agent definition with no workflow references.

**Assessment:**
This appears to be a placeholder for future functionality. No updates needed until corresponding command/workflow is defined.

---

### 7. integration-actions.md

**Status:** On Hold

**Current Content:**
Brief agent for external tool integrations.

**Assessment:**
This is for Phase 3 integrations (Jira, Testmo). No updates needed until integration workflows are defined.

---

## Workflow Creation Checklist

Based on the agent mapping, these workflows need to be created or updated:

### Workflows to Create (New)

1. **workflows/planning/gather-feature-docs.md**
   - Purpose: Gather BRDs, API specs, mockups for a feature
   - Used by: feature-initializer agent in /plan-feature Phase 2

2. **workflows/planning/consolidate-feature-knowledge.md**
   - Purpose: Create feature-knowledge.md from collected docs
   - Used by: requirement-analyst agent in /plan-feature Phase 3

3. **workflows/planning/create-test-strategy.md**
   - Purpose: Create feature-test-strategy.md
   - Used by: requirement-analyst agent in /plan-feature Phase 4

4. **workflows/planning/update-feature-knowledge.md**
   - Purpose: Update feature-knowledge.md with new information
   - Used by: requirement-analyst agent in /update-feature-knowledge Phase 3

5. **workflows/testing/initialize-ticket.md**
   - Purpose: Create ticket folder structure
   - Used by: feature-initializer agent in /plan-ticket Phase 1

6. **workflows/testing/gather-ticket-docs.md**
   - Purpose: Gather ticket-specific documentation
   - Used by: feature-initializer agent in /plan-ticket Phase 2

7. **workflows/testing/revise-test-plan.md**
   - Purpose: Update test-plan.md with revisions
   - Used by: requirement-analyst agent in /revise-test-plan Phase 3

### Workflows to Update (Existing)

1. **workflows/testing/initialize-feature.md**
   - Current: Old pattern
   - Update: Align with /plan-feature Phase 1 logic

2. **workflows/testing/requirement-analysis.md**
   - Current: Creates requirements.md
   - Update: Add gap detection, create test-plan.md instead
   - Update: Include revision log initialization

3. **workflows/testing/testcase-generation.md**
   - Current: Basic structure, reads requirements.md
   - Update: Smart conflict handling, read test-plan.md
   - Update: New test case structure with execution tracking
   - Update: Coverage analysis and automation recommendations

4. **workflows/planning/gather-product-info.md**
   - Status: ✅ Already correct (used by /plan-product)
   - Verification: Ensure it's complete

5. **workflows/planning/create-product-mission.md**
   - Status: ✅ Already correct (used by /plan-product)
   - Verification: Ensure it's complete

### Workflows to Investigate

1. **workflows/testing/test-planning.md**
   - Status: Appears unused
   - Action: Verify if distinct from requirement-analysis or obsolete

2. **workflows/testing/create-ticket.md**
   - Status: For old /create-ticket command
   - Action: Deprecate or update to match /plan-ticket

---

## Multi-Agent Variant Summary

Commands requiring multi-agent variants (currently missing):

1. ✅ **/plan-product** - Already has multi-agent variant
2. ❌ **/plan-feature** - Needs multi-agent variant (delegates to feature-initializer, requirement-analyst)
3. ❌ **/plan-ticket** - Needs multi-agent variant (delegates to feature-initializer, requirement-analyst, testcase-writer)
4. ⚠️ **/generate-testcases** - Has multi-agent variant but needs verification/update
5. ❌ **/revise-test-plan** - Needs multi-agent variant (delegates to requirement-analyst, testcase-writer)
6. ❌ **/update-feature-knowledge** - Needs multi-agent variant (delegates to requirement-analyst)

---

## Implementation Priority

### Priority 1: Critical Path (Core QA Workflow)

1. Create/update workflows for test case generation
   - Update workflows/testing/testcase-generation.md
   - Ensure it's the single source of truth

2. Update testcase-writer agent
   - Reference updated testcase-generation workflow
   - Fix outdated requirements.md reference

3. Create multi-agent variant for /generate-testcases
   - Verify it delegates correctly to testcase-writer

### Priority 2: Main Planning Commands

1. Create/update workflows for requirement analysis
   - Update workflows/testing/requirement-analysis.md with gap detection
   - Create workflows/testing/initialize-ticket.md
   - Create workflows/testing/gather-ticket-docs.md

2. Update requirement-analyst agent
   - Add all requirement analysis workflow references

3. Create multi-agent variant for /plan-ticket
   - Delegate to feature-initializer and requirement-analyst

### Priority 3: Feature Planning

1. Create workflows for feature planning
   - Update workflows/planning/initialize-feature.md
   - Create workflows/planning/gather-feature-docs.md
   - Create workflows/planning/consolidate-feature-knowledge.md
   - Create workflows/planning/create-test-strategy.md

2. Update feature-initializer and requirement-analyst agents
   - Add feature planning workflow references

3. Create multi-agent variant for /plan-feature
   - Delegate to feature-initializer and requirement-analyst

### Priority 4: Maintenance Commands

1. Create workflow for test plan revision
   - Create workflows/testing/revise-test-plan.md

2. Create workflow for feature knowledge updates
   - Create workflows/planning/update-feature-knowledge.md

3. Create multi-agent variants for /revise-test-plan and /update-feature-knowledge

---

## Conclusion

The agent integration map reveals:

1. **Missing multi-agent variants** - Most refactored commands only have single-agent variants
2. **Outdated agent references** - Agents don't reference updated workflows
3. **Workflow gaps** - Many needed workflows don't exist yet
4. **Pattern inconsistency** - Refactored commands don't follow original delegation pattern

By creating the missing workflows, updating agents, and creating multi-agent variants, qa-agent-os will:
- Support both single-agent and multi-agent modes
- Follow the original architectural pattern
- Achieve logic reusability across commands and agents
- Enable specialized agent expertise in multi-agent mode
