# Workflow Audit Report

## Purpose

This document audits all existing workflows in `profiles/default/workflows/` and compares them with the refactored QA commands to identify:
1. Which workflows are still being used
2. Which workflows are outdated
3. Which workflows need updates to align with refactored commands
4. Which refactored command logic should be extracted into workflows

## Existing Workflows Inventory

### Bug Tracking Workflows

#### 1. `bug-tracking/bug-reporting.md`

**Status:** [Needs Verification]

**Current References:**
- Not found in refactored commands
- Not found in agents

**Assessment:**
This workflow appears unused in the current command structure. Need to verify if:
- A `/report-bug` command exists or is planned
- Bug reporting is handled elsewhere
- This workflow should be updated for the current architecture

**Recommendation:** HOLD - Verify if bug reporting command exists in roadmap (Phase 2 in product roadmap shows "Bug Reporting Command" as planned)

---

### Planning Workflows

#### 2. `planning/gather-product-info.md`

**Status:** [Reusable]

**Current References:**
- Referenced in `commands/plan-product/single-agent/1-product-concept.md`
- Referenced in `agents/product-planner.md`

**Usage Pattern:**
```markdown
# In command phase file:
{{workflows/planning/gather-product-info}}

# In agent file:
{{workflows/planning/gather-product-info}}
```

**Assessment:**
This workflow is ACTIVELY USED by both the `/plan-product` command and the `product-planner` agent. It represents the original pattern correctly:
- Workflow contains the procedural logic
- Command phase references the workflow
- Agent references the workflow
- Single source of truth

**Recommendation:** KEEP - This is a good example of the intended pattern

---

#### 3. `planning/create-product-mission.md`

**Status:** [Reusable]

**Current References:**
- Referenced in `commands/plan-product/single-agent/2-create-mission.md`
- Referenced in `agents/product-planner.md`

**Usage Pattern:**
```markdown
# In command phase file:
{{workflows/planning/create-product-mission}}

# In agent file:
{{workflows/planning/create-product-mission}}
```

**Assessment:**
This workflow is ACTIVELY USED. Same pattern as gather-product-info - demonstrating correct workflow reuse.

**Recommendation:** KEEP - Good example of intended pattern

---

### Testing Workflows

#### 4. `testing/compile-testing-standards.md`

**Status:** [Reusable - Needs Update]

**Current References:**
- Referenced in `workflows/testing/testcase-generation.md` (Step 0)

**Purpose:**
Gathers applicable standards before test case generation (when standards_as_claude_code_skills is false)

**Assessment:**
This workflow serves a utility function - it compiles the list of standards that must be honored during test case generation. It's referenced by the testcase-generation workflow but may need updating if new standards categories are added.

**Recommendation:** UPDATE - Verify it includes all current standards categories

---

#### 5. `testing/create-ticket.md`

**Status:** [Outdated]

**Current References:**
- Referenced in `commands/create-ticket/single-agent/create-ticket.md`

**Issue:**
The refactored QA workflow replaced the old ticket workflow with:
- `/plan-ticket` - New comprehensive command with 5 phases
- Old `/create-ticket` command appears to be legacy

**Conflict:**
```
Old pattern:
/create-ticket → workflows/testing/create-ticket.md

New pattern:
/plan-ticket → Self-contained phases (0-detect-context.md through 4-generate-cases.md)
```

**Assessment:**
This workflow is for the OLD ticket creation pattern. The refactored `/plan-ticket` command uses self-contained phase files instead of referencing this workflow. This represents a DEVIATION from the original pattern.

**Recommendation:** UPDATE OR REPLACE
- Option A: Update this workflow to match `/plan-ticket` logic and have `/plan-ticket` phases reference it
- Option B: Deprecate this workflow and the old `/create-ticket` command entirely

---

#### 6. `testing/initialize-feature.md`

**Status:** [Needs Update]

**Current References:**
- Referenced in `commands/analise-requirements/single-agent/1-initialize-feature.md`
- Referenced in `commands/init-feature/single-agent/init-feature.md`
- Referenced in `agents/feature-initializer.md`

**Issue:**
The refactored QA workflow uses:
- `/plan-feature` - New comprehensive feature planning command
- Old `/init-feature` and `/analise-requirements` commands appear to be legacy

**Assessment:**
This workflow is referenced by OLD commands that were replaced during the refactor. The new `/plan-feature` command has its own phase files:
- `1-init-structure.md`
- `2-gather-docs.md`
- `3-consolidate-knowledge.md`
- `4-create-strategy.md`

**Recommendation:** UPDATE OR REPLACE
- Update this workflow to match `/plan-feature` Phase 1 logic
- Have `/plan-feature/single-agent/1-init-structure.md` reference this workflow
- Update `feature-initializer` agent to reference updated workflow

---

#### 7. `testing/requirement-analysis.md`

**Status:** [Needs Update]

**Current References:**
- Referenced in `commands/analise-requirements/single-agent/2-requirement-analysis.md`
- Referenced in `commands/create-ticket/single-agent/1-requirements.md`

**Issue:**
The refactored QA workflow replaced requirement analysis with:
- `/plan-ticket` Phase 3: `3-analyze-requirements.md` - Includes gap detection
- Old `/analise-requirements` and `/create-ticket` commands appear to be legacy

**Assessment:**
This workflow represents the OLD requirement analysis pattern. The new `/plan-ticket` command has enhanced requirement analysis with:
- Smart gap detection
- Feature knowledge updating
- More sophisticated requirement breakdown

**Comparison:**
```
Old workflow pattern:
- Step 1: Understand product context
- Step 2: Analyze initial requirements
- Step 3: Generate questions
- Step 4: Process answers & visuals
- Step 5: Save requirements.md

New /plan-ticket Phase 3:
- Step 1: Read all available information
- Step 2: Analyze ticket requirements
- Step 3: Compare against feature knowledge (NEW)
- Step 4: Gap detection & feature knowledge update (NEW)
- Step 5: Create test-plan.md (CHANGED from requirements.md)
```

**Recommendation:** MAJOR UPDATE REQUIRED
- Update workflow to include gap detection logic
- Update workflow to create test-plan.md instead of requirements.md
- Have `/plan-ticket/single-agent/3-analyze-requirements.md` reference this workflow
- Update `requirement-analyst` agent to reference updated workflow

---

#### 8. `testing/test-planning.md`

**Status:** [Needs Verification]

**Current References:**
- NOT FOUND in current commands or agents

**Assessment:**
This workflow appears UNUSED. Need to verify:
- Is test planning handled by `/plan-ticket` Phase 3 directly?
- Should this workflow be referenced?
- Is this a separate concept from requirement analysis?

**Recommendation:** INVESTIGATE - Determine if this is a duplicate concept or distinct workflow

---

#### 9. `testing/testcase-generation.md`

**Status:** [Needs Update]

**Current References:**
- Referenced in `commands/analise-requirements/single-agent/3-generate-testcases.md`
- Referenced in `commands/create-ticket/single-agent/2-testcases.md`

**Issue:**
The refactored QA workflow has:
- `/generate-testcases` command - Standalone command with full logic
- `/plan-ticket` Phase 4: `4-generate-cases.md` - Contains full generation logic

**Current Workflow Content:**
```markdown
Step 0: Compile testing standards
Step 1: Ingest requirements from requirements.md
Step 2: Generate test cases
Step 3: Save to artifacts/testcases.md
```

**New Pattern:**
```markdown
/plan-ticket Phase 4:
- Offers choice to generate or stop
- Reads test-plan.md (not requirements.md)
- Generates to test-cases.md (not artifacts/testcases.md)
- Includes conflict detection (overwrite/append/cancel)

/generate-testcases command:
- Standalone command
- Smart ticket selection
- Reads test-plan.md
- Generates detailed test cases with full structure
```

**Key Issue:**
The refactored commands contain FULL LOGIC in phase files instead of referencing this workflow. This is a DEVIATION from the original pattern where commands should reference workflows.

**Recommendation:** CRITICAL UPDATE REQUIRED
This is the KEY INSIGHT from the user's clarification:

> If `/generate-testcases` command functionality is the same as the workflow, the logic should be IN THE WORKFLOW.

**Action Items:**
1. UPDATE `workflows/testing/testcase-generation.md` to include:
   - Smart conflict detection logic
   - Test-plan.md reading (not requirements.md)
   - New test case structure with execution tracking
   - Coverage analysis
   - Automation recommendations

2. REFACTOR `/generate-testcases/single-agent/generate-testcases.md` to:
   - Reference `{{workflows/testing/testcase-generation}}`
   - Add orchestration logic (ticket selection, user prompts)
   - Remove duplicated generation logic

3. REFACTOR `/plan-ticket/single-agent/4-generate-cases.md` to:
   - Reference `{{workflows/testing/testcase-generation}}`
   - Keep phase-specific logic (choice prompts)
   - Remove duplicated generation logic

This will achieve:
- Single source of truth for test case generation
- Reusability across commands
- Token efficiency for AI
- Easier maintenance

---

## Summary by Category

### Reusable (Already Following Pattern)
1. `planning/gather-product-info.md` - Used by /plan-product and product-planner agent
2. `planning/create-product-mission.md` - Used by /plan-product and product-planner agent
3. `testing/compile-testing-standards.md` - Utility workflow (needs verification)

**Count:** 3 workflows

---

### Needs Update (Exists but Needs Alignment)
1. `testing/initialize-feature.md` - Update to match /plan-feature Phase 1
2. `testing/requirement-analysis.md` - Major update for gap detection and test-plan.md
3. `testing/testcase-generation.md` - CRITICAL update to become single source of truth
4. `testing/create-ticket.md` - Update to match /plan-ticket or deprecate

**Count:** 4 workflows

---

### Needs Verification (Unclear Status)
1. `bug-tracking/bug-reporting.md` - Verify if used by planned /report-bug command
2. `testing/test-planning.md` - Verify if distinct from requirement-analysis

**Count:** 2 workflows

---

## Critical Findings

### Finding 1: Pattern Deviation in Refactored Commands

**Issue:**
The refactored QA commands (`/plan-ticket`, `/generate-testcases`, `/plan-feature`) contain FULL LOGIC in their phase files instead of referencing workflows. This deviates from the original pattern where:
- Commands orchestrate by referencing workflows
- Workflows contain the procedural logic
- Multiple commands can reference the same workflow

**Evidence:**
- `/plan-ticket/single-agent/3-analyze-requirements.md` contains full analysis logic (116 lines)
- `/plan-ticket/single-agent/4-generate-cases.md` contains full generation logic (116 lines)
- `/generate-testcases/single-agent/generate-testcases.md` is only documentation, no phase files reference workflows

**Impact:**
- Logic duplication (test case generation logic in multiple places)
- Reduced reusability (can't reference the workflow from other commands)
- Higher token usage (AI processes duplicate logic)
- Harder maintenance (must update logic in multiple places)

---

### Finding 2: Workflow-Command Misalignment

**Issue:**
Existing workflows don't match the new command structure:
- `workflows/testing/requirement-analysis.md` creates `requirements.md`
- `/plan-ticket` Phase 3 creates `test-plan.md` (different output)
- Workflows reference old directory structure (`artifacts/` instead of direct ticket folder)
- Workflows don't include new features (gap detection, revision tracking)

**Impact:**
- Can't simply reference existing workflows
- Must either update workflows OR keep duplicating logic

---

### Finding 3: Missing Multi-Agent Variants

**Issue:**
Refactored commands are missing multi-agent variants:
- `/plan-ticket` - Only has single-agent variant
- `/plan-feature` - Only has single-agent variant
- `/generate-testcases` - Has multi-agent variant but it's outdated
- `/revise-test-plan` - Only has single-agent variant
- `/update-feature-knowledge` - Only has single-agent variant

**Evidence:**
```bash
# Commands with BOTH variants (original pattern):
commands/plan-product/single-agent/
commands/plan-product/multi-agent/
commands/analise-requirements/single-agent/
commands/analise-requirements/multi-agent/

# Commands with ONLY single-agent (refactored):
commands/plan-ticket/single-agent/           # Missing multi-agent/
commands/plan-feature/single-agent/          # Missing multi-agent/
commands/revise-test-plan/single-agent/      # Missing multi-agent/
commands/update-feature-knowledge/single-agent/ # Missing multi-agent/
```

**Impact:**
- Cannot use refactored commands in multi-agent mode
- Config flag `claude_code_subagents: true` won't benefit from specialized agents
- Inconsistent with original architecture

---

## Recommendations

### Priority 1: Extract Logic to Workflows (CRITICAL)

**Action:**
Update workflows to be the single source of truth and have command phases reference them.

**Specific Updates:**

1. **Update `workflows/testing/testcase-generation.md`**
   - Include smart conflict detection
   - Read from test-plan.md (not requirements.md)
   - New test case structure
   - Coverage analysis logic
   - Automation recommendations

2. **Update `workflows/testing/requirement-analysis.md`**
   - Add gap detection logic
   - Add feature knowledge comparison
   - Add feature knowledge update procedure
   - Create test-plan.md (not requirements.md)
   - Include revision tracking

3. **Update `workflows/testing/initialize-feature.md`**
   - Match `/plan-feature` Phase 1 logic
   - Create new folder structure
   - Include README.md generation

**Then:**
- Refactor command phase files to reference workflows using `{{workflows/...}}` tags
- Remove duplicated logic from phase files
- Keep phase-specific orchestration (prompts, choices, flow control)

---

### Priority 2: Create Multi-Agent Variants (HIGH)

**Action:**
Create multi-agent variants for all refactored commands following the original pattern.

**Structure:**
```
commands/plan-ticket/
  ├── single-agent/
  │   ├── plan-ticket.md
  │   ├── 0-detect-context.md
  │   ├── 1-init-ticket.md
  │   ├── 2-gather-ticket-docs.md
  │   ├── 3-analyze-requirements.md → {{workflows/testing/requirement-analysis}}
  │   └── 4-generate-cases.md → {{workflows/testing/testcase-generation}}
  └── multi-agent/
      └── plan-ticket.md → Delegates to requirement-analyst and testcase-writer agents
```

**Multi-Agent Logic:**
```markdown
# commands/plan-ticket/multi-agent/plan-ticket.md

## Ticket Planning Process (Multi-Agent)

### PHASE 0: Smart Detection
[Orchestration logic]

### PHASE 1-2: Initialize Ticket
Use the **feature-initializer** subagent...

### PHASE 3: Analyze Requirements
Use the **requirement-analyst** subagent...
The requirement-analyst will:
- Run gap detection
- Create test-plan.md

### PHASE 4: Generate Test Cases
Use the **testcase-writer** subagent...
The testcase-writer will:
- Read test-plan.md
- Generate test-cases.md
```

---

### Priority 3: Verify and Clean Unused Workflows (MEDIUM)

**Action:**
1. Verify status of `bug-tracking/bug-reporting.md` (roadmap shows it's planned)
2. Verify status of `testing/test-planning.md` (may be duplicate concept)
3. Deprecate old commands (`/create-ticket`, `/analise-requirements`, `/init-feature`)
4. Archive outdated workflows if commands are deprecated

---

### Priority 4: Update Agents to Reference Updated Workflows (MEDIUM)

**Action:**
Update agent definitions to reference the updated workflows:

```markdown
# agents/requirement-analyst.md

## Workflow
{{workflows/testing/requirement-analysis}}

# agents/testcase-writer.md

## Workflow
{{workflows/testing/testcase-generation}}

# agents/feature-initializer.md

## Workflow
{{workflows/testing/initialize-feature}}
```

This ensures agents use the same logic as commands (single source of truth).

---

## Conclusion

The workflow audit reveals a CRITICAL architectural deviation in the refactored QA commands:
- Original pattern: Commands reference workflows (logic in workflows)
- Refactored pattern: Commands contain full logic (workflows ignored)

This deviation causes:
- Logic duplication
- Reduced reusability
- Higher maintenance burden
- Inconsistent architecture

**Primary Recommendation:**
Refactor the QA commands to follow the original pattern by extracting logic into workflows and having both commands and agents reference those workflows. This achieves the user's goal of token efficiency, reusability, and architectural consistency.
