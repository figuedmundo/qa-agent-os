# /plan-ticket Command (Multi-Agent Mode)

## Purpose

Plan comprehensive test coverage for a specific ticket using specialized agents. This command includes intelligent feature detection, gap detection, and flexible test case generation.

## Usage

```bash
/plan-ticket WYX-123
/plan-ticket "TICKET-001"
/plan-ticket ticket-abc-456
```

## Execution Flow

### PHASE 0: Smart Detection

This phase handles intelligent context detection and routing. This orchestration logic remains in the main command:

#### Step 1: Detect Existing Ticket

Check if `qa-agent-os/features/[feature-name]/[ticket-id]/` already exists.

**If ticket exists**, present re-execution options:

```
Ticket [ticket-id] already exists in feature [feature-name].

Options:
  [1] Full re-plan (Phases 1-4: re-gather docs, re-analyze, regenerate cases)
  [2] Update test plan only (Skip to Phase 3: re-analyze requirements)
  [3] Regenerate test cases only (Skip to Phase 4: use existing test-plan.md)
  [4] Cancel
```

**User choice determines routing:**
- Option [1] - Proceed to Phase 1 (full re-plan)
- Option [2] - Skip to Phase 3 (re-analyze only)
- Option [3] - Skip to Phase 4 (regenerate cases only)
- Option [4] - Exit command

#### Step 2: Feature Selection (New Tickets Only)

If this is a new ticket, detect available features:

```bash
# Scan for existing features
FEATURES=$(find qa-agent-os/features/ -maxdepth 1 -type d)
```

**Present feature selection:**

```
Which feature does ticket [ticket-id] belong to?

Features found:
  [1] Feature-Name-1
  [2] Feature-Name-2
  [3] Create new feature
```

**Handle selection:**
- If user selects existing feature → Set FEATURE_PATH and proceed to Phase 1
- If user selects "Create new feature" → Guide to run `/plan-feature` first, then exit
- If only ONE feature exists → Auto-select and confirm with user
- If NO features exist → Display message and exit:
  ```
  No features found. Please create a feature first:
    /plan-feature [feature-name]
  Then return to plan the ticket.
  ```

### PHASE 1-2: Initialize and Gather

Use the **feature-initializer** subagent to set up the ticket structure and gather documentation.

Provide the feature-initializer with:
- Feature path: `qa-agent-os/features/[feature-name]/` (from Phase 0)
- Ticket ID: [ticket-id]
- Any provided documentation or links from user

The feature-initializer will:
- Create ticket directory structure: `[feature-path]/[ticket-id]/`
- Create documentation/ subfolder
- Create README.md with ticket information
- Gather ticket-specific documentation (requirements, designs, API specs, mockups)
- Organize all documentation in the ticket's documentation/ folder
- Execute workflows: `workflows/testing/initialize-ticket` and `workflows/testing/gather-ticket-docs`

### PHASE 3: Analyze Requirements & Detect Gaps

Use the **requirement-analyst** subagent to analyze requirements and create the test plan.

Provide the requirement-analyst with:
- Ticket path: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Feature knowledge path: `qa-agent-os/features/[feature-name]/feature-knowledge.md`
- Feature test strategy path: `qa-agent-os/features/[feature-name]/feature-test-strategy.md`
- Documentation from Phase 2 (in ticket's documentation/ folder)

The requirement-analyst will:
- Read and analyze all ticket documentation
- Read feature-knowledge.md and feature-test-strategy.md
- Compare ticket requirements against existing feature knowledge
- Perform gap detection: identify new business rules, APIs, edge cases, or requirements
- If gaps found: Prompt user to update feature-knowledge.md with new information
- If user approves: Append gaps to feature-knowledge.md with metadata (source: ticket-id, date)
- Create comprehensive test-plan.md with 11 sections:
  1. Ticket Overview
  2. Requirements Traceability
  3. Test Scope
  4. Testable Requirements
  5. Test Coverage Matrix
  6. Test Scenarios & Cases
  7. Test Data Requirements
  8. Dependencies & Assumptions
  9. Risks & Mitigation
  10. References
  11. Revision Log
- Initialize revision log with Version 1.0
- Execute workflow: `workflows/testing/requirement-analysis`

After requirement-analyst completes, prompt user:

```
Test plan created successfully!

Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first, generate test cases later)

Choose [1/2]:
```

Store user's choice for Phase 4 routing.

### PHASE 4: Generate Test Cases (Optional)

If user chose option [1] from Phase 3 prompt:

Use the **testcase-writer** subagent to generate detailed test cases.

Provide the testcase-writer with:
- Ticket path: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Test plan path: `[ticket-path]/test-plan.md`
- Generation mode: create (new test cases)
- Visual assets: `[ticket-path]/documentation/` (if any mockups or screenshots exist)

The testcase-writer will:
- Read test-plan.md to extract scenarios and coverage requirements
- Extract test coverage matrix (Section 5)
- Extract test scenarios (Section 6)
- Extract test data requirements (Section 7)
- Generate detailed executable test cases with structure:
  - Test case ID (e.g., WYX-123-TC-001)
  - Test case type (Functional, Negative, Edge, API, Integration)
  - Priority (High, Medium, Low)
  - Objective
  - Preconditions
  - Test steps (table format with Action and Expected Result)
  - Test data references
  - Expected final result
  - Execution tracking checkboxes (Pass/Fail/Blocked)
  - Notes section for defects and observations
- Perform coverage analysis to verify all requirements have test cases
- Add automation recommendations for each test case
- Save to `[ticket-path]/test-cases.md`
- Execute workflow: `workflows/testing/testcase-generation`

If user chose option [2] from Phase 3 prompt:

Skip Phase 4 and display completion message without test cases.

### Completion

Once all phases complete:

```
✓ Ticket planning complete!

Created:
- Ticket folder: qa-agent-os/features/[feature-name]/[ticket-id]/
- Test plan: qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md
- Test cases: qa-agent-os/features/[feature-name]/[ticket-id]/test-cases.md (if Phase 4 executed)
- Feature knowledge updated: [yes/no] (if gaps detected)

NEXT STEPS:
- Review test-plan.md for accuracy
- If test cases not generated yet: Run /generate-testcases [ticket-id]
- During testing: Use /revise-test-plan to update the plan
```

## Smart Features

This multi-agent command includes:

1. **Smart Feature Detection** - Automatically discovers and selects features
2. **Existing Ticket Detection** - Offers efficient re-execution options
3. **Intelligent Gap Detection** - Keeps feature knowledge current automatically
4. **Flexible Test Case Generation** - Generate now or later, user's choice

## Related Commands

- `/plan-feature` - Plan an entire feature (do this first if feature doesn't exist)
- `/generate-testcases` - Generate or regenerate test cases anytime
- `/revise-test-plan` - Update test plan during testing
- `/update-feature-knowledge` - Manually update feature knowledge

---

*This command leverages specialized agents (feature-initializer, requirement-analyst, testcase-writer) to efficiently plan tickets with expert domain knowledge.*
