# Spec Requirements: Workflow Command Separation

## Initial Description

The current QA Agent OS workflow combines structure initialization, documentation gathering, and analysis into monolithic commands (`/plan-feature` and `/plan-ticket`). This redesign separates concerns into discrete, reusable commands following the principle: "separate the phases that need to be done by the user from the phases that can be automated."

**New Command Structure:**
- `/start-feature` - Initialize feature folder structure only
- `/start-ticket` - Initialize ticket folder structure only
- `/gather-docs` - Prompt user to gather documentation (no automation)
- `/analyze-requirements` - Analyze gathered docs and create knowledge/strategy/test plans

**Key Goals:**
1. Separate user-driven tasks (structure, gathering) from AI-driven tasks (analysis)
2. Make commands reusable and context-aware
3. Maintain smart detection and gap detection capabilities
4. Remove deprecated monolithic commands

## Requirements Discussion

### First Round Questions

**Q1:** For `/start-feature` and `/start-ticket`, should they create any placeholder content (e.g., empty markdown files with headers) or just the folder structure?
**Answer:** `/start-feature` should just create the folder structure with no files until `/analyze-requirements` runs - YES

**Q2:** Should `/start-ticket` create empty `test-plan.md` and `test-cases.md` files, or keep them completely empty until later commands generate them?
**Answer:** Keep them completely empty (no placeholder files)

**Q3:** For `/analyze-requirements`, how should it detect whether it's analyzing a feature or ticket? Options: (a) Smart detection based on current directory, (b) Require explicit parameter like `/analyze-requirements feature` or `/analyze-requirements ticket`, (c) Both - smart detection with fallback prompt.
**Answer:** User requests suggestions from us

**Q4:** When re-executing `/analyze-requirements` on existing feature/ticket, what should the behavior be? Should it: (a) Always overwrite, (b) Prompt with options like `/plan-ticket` does, (c) Create versioned copies?
**Answer:** Smart re-execution - `/analyze-requirements` should have similar detection and options

**Q5:** For gap detection in `/analyze-requirements`, when analyzing a ticket and finding gaps in feature-knowledge.md, should the prompt to append gaps happen: (a) Immediately in `/analyze-requirements`, (b) As a separate follow-up step?
**Answer:** Stay in `/analyze-requirements` when run in ticket context - YES. **User emphasizes: "always let me know that something was detected in the gap detection"**

**Q6:** Should `/gather-docs` include helpful prompts about what documentation to look for (BRD references, API specs, mockups, etc.) or just create the documentation/ folder and wait?
**Answer:** Include prompts to help users understand what documentation to gather

**Q7:** For backward compatibility, should we: (a) Keep `/plan-feature` and `/plan-ticket` as legacy aliases that internally call the new command sequence, (b) Remove them entirely and require users to update their workflows?
**Answer:** Remove `/plan-feature` and `/plan-ticket` entirely and require users to update their workflows - YES

**Q8:** Should `/generate-testcases` remain as-is (standalone command that works with existing test-plan.md), or does it need modifications for this new workflow?
**Answer:** `/generate-testcases` remains unchanged - YES

**Q9:** When `/analyze-requirements` runs at the feature level, should it create both `feature-knowledge.md` AND `feature-test-strategy.md`, or just `feature-knowledge.md` (with test strategy being ticket-specific)?
**Answer:** Create both `feature-knowledge.md` AND `feature-test-strategy.md` - User says "I think that is how is working now, it can continue, or please advice"

**Q10:** If a user runs `/analyze-requirements` but the documentation/ folder is empty or has insufficient documentation, should the command: (a) Fail with helpful error message, (b) Prompt them to gather documentation interactively, (c) Proceed with limited analysis and flag missing info?
**Answer:** Prompt them to gather documentation interactively - YES

### Existing Code to Reference

**Similar Features Identified:**
- Current `/plan-feature` command: `profiles/default/commands/plan-feature/`
  - Phase 1 (structure initialization) → becomes `/start-feature`
  - Phase 2 (documentation gathering) → becomes `/gather-docs`
  - Phases 3-4 (consolidation and strategy) → becomes `/analyze-requirements` for feature context

- Current `/plan-ticket` command: `profiles/default/commands/plan-ticket/`
  - Phase 0 (smart detection) → kept in `/start-ticket` and `/analyze-requirements`
  - Phase 1 (structure initialization) → becomes `/start-ticket`
  - Phase 2 (documentation gathering) → becomes `/gather-docs`
  - Phase 3 (requirements analysis + gap detection) → becomes `/analyze-requirements` for ticket context
  - Phase 4 (test case generation) → remains as `/generate-testcases`

- Gap detection logic: `profiles/default/commands/plan-ticket/single-agent/3-analyze-requirements.md`
  - To be preserved in new `/analyze-requirements` command with explicit visibility requirement

- Smart detection and re-execution: `profiles/default/commands/plan-ticket/single-agent/0-smart-detection.md`
  - To be adapted for both `/start-ticket` and `/analyze-requirements`

### Follow-up Questions

**Follow-up 1:** For Question 3 (Context Detection), what approach do you recommend for `/analyze-requirements` to detect feature vs ticket context?

**Recommendation Provided:**
**Smart Directory Detection with Interactive Fallback**

Strategy:
1. Check current working directory for context markers:
   - If in `qa-agent-os/features/[feature-name]/[ticket-id]/` → Ticket context
   - If in `qa-agent-os/features/[feature-name]/` → Feature context
   - If elsewhere → Interactive prompt

2. Interactive Prompt (when context unclear):
   ```
   I couldn't detect your context. Please select:
   [1] Analyze feature: [list available features from qa-agent-os/features/]
   [2] Analyze ticket: [prompt for ticket-id, then show features]
   [3] Cancel
   ```

3. Validation:
   - Verify folders exist before proceeding
   - Show clear error if documentation/ folder is empty
   - Suggest running `/start-feature` or `/start-ticket` if structure missing

Benefits:
- Zero friction when run from correct directory (most common case)
- Helpful guidance when context is ambiguous
- Prevents errors from wrong context assumptions

**Follow-up 2:** For Question 9 (Feature-Level Analysis), should `/analyze-requirements` create both documents or just feature-knowledge.md?

**Recommendation Provided:**
**Continue Creating Both Documents**

The current approach of creating both `feature-knowledge.md` AND `feature-test-strategy.md` at the feature level is correct and should continue:

Rationale:
- `feature-knowledge.md` = "WHAT is being built" (business rules, APIs, edge cases, data models)
- `feature-test-strategy.md` = "HOW we'll test it" (approach, tools, environment, risks, dependencies)

These serve different purposes and are referenced differently:
- `feature-knowledge.md` → Referenced by `/analyze-requirements` for gap detection and ticket test planning
- `feature-test-strategy.md` → Referenced by ticket test-plan.md to inherit strategic context

This separation maintains clean concerns and prevents mixing strategic testing decisions with functional requirements.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
No visual assets provided.

## Requirements Summary

### Functional Requirements

#### Command 1: `/start-feature`
**Purpose:** Initialize feature folder structure only (no content generation)

**Input:**
- Feature name (parameter or interactive prompt)

**Behavior:**
1. Create folder structure:
   ```
   qa-agent-os/features/[feature-name]/
   └── documentation/
   ```
2. No files created, no placeholder content
3. Output success message with next steps: "Feature structure created. Run `/gather-docs` to add documentation, then `/analyze-requirements` to create feature-knowledge.md and feature-test-strategy.md"

**Validation:**
- Check if feature already exists
- If exists, prompt: "[1] Overwrite [2] Cancel"

---

#### Command 2: `/start-ticket`
**Purpose:** Initialize ticket folder structure only (no content generation)

**Input:**
- Ticket ID (parameter or interactive prompt)

**Smart Detection:**
1. Check for existing features in `qa-agent-os/features/`
2. If multiple features exist, prompt user to select parent feature
3. If ticket already exists in selected feature, prompt:
   ```
   Ticket [ticket-id] already exists in feature [feature-name].
   [1] Overwrite structure
   [2] Cancel
   ```

**Behavior:**
1. Create folder structure:
   ```
   qa-agent-os/features/[feature-name]/[ticket-id]/
   └── documentation/
   ```
2. No files created (test-plan.md and test-cases.md will be created later by `/analyze-requirements` and `/generate-testcases`)
3. Output success message with next steps: "Ticket structure created. Run `/gather-docs` to add ticket documentation, then `/analyze-requirements` to create test-plan.md"

---

#### Command 3: `/gather-docs`
**Purpose:** Prompt user to gather documentation (user-driven, no automation)

**Smart Context Detection:**
1. Check current working directory:
   - If in `qa-agent-os/features/[feature-name]/[ticket-id]/` → Ticket context
   - If in `qa-agent-os/features/[feature-name]/` → Feature context
   - If elsewhere → Prompt user to select context

**Behavior:**
1. Identify context (feature or ticket)
2. Display helpful prompts based on context:

   **For Feature Context:**
   ```
   Please gather the following documentation and place in:
   qa-agent-os/features/[feature-name]/documentation/

   Recommended documents:
   - Business Requirements Document (BRD)
   - API specifications or endpoint documentation
   - UI/UX mockups or wireframes
   - Technical architecture documents
   - Database schema or data models
   - Any feature-specific technical documentation

   Once you've added documentation, run: /analyze-requirements
   ```

   **For Ticket Context:**
   ```
   Please gather the following documentation and place in:
   qa-agent-os/features/[feature-name]/[ticket-id]/documentation/

   Recommended documents:
   - Ticket description or user story
   - Acceptance criteria
   - API endpoint details specific to this ticket
   - Screen mockups or UI changes
   - Technical implementation notes
   - Any ticket-specific test data or examples

   Once you've added documentation, run: /analyze-requirements
   ```

3. Wait for user to add documentation (no automation)
4. Output completion message with next command suggestion

---

#### Command 4: `/analyze-requirements`
**Purpose:** Analyze gathered documentation and create knowledge/strategy/test plans based on context

**Context Detection Strategy (Recommended):**
Smart Directory Detection with Interactive Fallback:

1. Check current working directory for context markers:
   - If in `qa-agent-os/features/[feature-name]/[ticket-id]/` → Ticket context
   - If in `qa-agent-os/features/[feature-name]/` → Feature context
   - If elsewhere → Interactive prompt

2. Interactive Prompt (when context unclear):
   ```
   I couldn't detect your context. Please select:
   [1] Analyze feature: [list available features from qa-agent-os/features/]
   [2] Analyze ticket: [prompt for ticket-id, then show features]
   [3] Cancel
   ```

3. Validation:
   - Verify folders exist before proceeding
   - Show clear error if documentation/ folder is empty
   - Suggest running `/start-feature` or `/start-ticket` if structure missing

**Feature Context Behavior:**
1. Check if documentation/ folder has files
2. If empty or insufficient, prompt user to gather documentation interactively (point them to `/gather-docs` guidance)
3. Analyze all documentation in `qa-agent-os/features/[feature-name]/documentation/`
4. Create `feature-knowledge.md` (8 sections: Overview, Business Rules, API Endpoints, Data Models, Edge Cases, Dependencies, Open Questions, References)
5. Create `feature-test-strategy.md` (10 sections: Testing Approach, Tools, Environment, Test Data Strategy, Risks, Entry/Exit Criteria, Dependencies, Schedule, Resources, References)
6. Output success message with next steps

**Re-execution Detection (Feature Context):**
If `feature-knowledge.md` and `feature-test-strategy.md` already exist, prompt:
```
Feature analysis already exists for [feature-name].
[1] Full re-analysis (overwrite both documents)
[2] Update feature-knowledge.md only
[3] Update feature-test-strategy.md only
[4] Cancel
```

**Ticket Context Behavior:**
1. Check if documentation/ folder has files
2. If empty or insufficient, prompt user to gather documentation interactively
3. Analyze all documentation in `qa-agent-os/features/[feature-name]/[ticket-id]/documentation/`
4. Read existing `feature-knowledge.md` from parent feature
5. **Gap Detection with Explicit Visibility:**
   - Compare ticket requirements to feature-knowledge.md
   - Identify new business rules, API endpoints, edge cases, data models not in feature knowledge
   - **ALWAYS explicitly inform user when gaps are detected:**
     ```
     GAP DETECTION RESULTS:
     I found [N] gaps between ticket requirements and feature knowledge:

     1. [New business rule]: [description]
     2. [New API endpoint]: [description]
     3. [New edge case]: [description]

     Would you like me to append these gaps to feature-knowledge.md?
     [1] Yes, append all gaps
     [2] Let me review first (show detailed gap report)
     [3] No, skip gap updates
     ```
   - If user selects [1], append gaps to feature-knowledge.md with metadata (source: ticket-id, date added)
   - If user selects [2], show detailed gap report and re-prompt
6. Create `test-plan.md` (11 sections with requirement traceability, test scenarios, test data)
7. Offer test case generation:
   ```
   Test plan created successfully.
   [1] Generate test cases now (/generate-testcases)
   [2] Stop for review (you can run /generate-testcases later)
   ```

**Re-execution Detection (Ticket Context):**
If `test-plan.md` already exists, prompt:
```
Test plan already exists for [ticket-id].
[1] Full re-analysis (overwrite test-plan.md)
[2] Append to existing test-plan.md
[3] Cancel
```

**Empty Documentation Handling:**
If documentation/ folder is empty or has no readable files:
```
No documentation found in [path]/documentation/

Please gather documentation before running analysis. You can:
1. Manually add files to the documentation/ folder
2. Run /gather-docs for guidance on what to gather

Would you like to see the documentation gathering guidance now?
[1] Yes, show guidance
[2] No, I'll add documentation manually
```

---

#### Command 5: `/generate-testcases`
**Purpose:** Generate or regenerate test cases from test-plan.md (unchanged from current implementation)

**Input:**
- Ticket ID (parameter or interactive prompt)

**Behavior:**
1. Detect ticket context
2. Read test-plan.md sections 6-7 (test scenarios and test data)
3. Generate detailed executable test cases
4. If test-cases.md exists, prompt:
   ```
   Test cases already exist for [ticket-id].
   [1] Overwrite
   [2] Append
   [3] Cancel
   ```
5. Create or update test-cases.md

---

### Reusability Opportunities

**Components to Reuse:**
- Smart detection logic from current `/plan-ticket` Phase 0
- Gap detection logic from current `/plan-ticket` Phase 3
- Directory structure initialization from current `/plan-feature` Phase 1 and `/plan-ticket` Phase 1
- Documentation analysis and consolidation from current `/plan-feature` Phases 3-4
- Test plan generation from current `/plan-ticket` Phase 3

**Backend Patterns to Follow:**
- Context detection pattern (checking cwd for feature/ticket markers)
- Re-execution prompts with numbered options
- Gap detection with user confirmation before updates
- Validation of folder existence before operations

---

### Scope Boundaries

**In Scope:**
- Create 4 new commands: `/start-feature`, `/start-ticket`, `/gather-docs`, `/analyze-requirements`
- Implement smart context detection for `/gather-docs` and `/analyze-requirements`
- Implement re-execution detection for `/analyze-requirements` (similar to current `/plan-ticket`)
- Preserve gap detection with **explicit visibility requirement** (always inform user when gaps detected)
- Remove deprecated `/plan-feature` and `/plan-ticket` commands entirely
- Keep `/generate-testcases` unchanged
- Interactive prompts for documentation gathering guidance
- Empty documentation folder handling with helpful guidance

**Out of Scope:**
- Modifications to `/generate-testcases` command
- Modifications to `/revise-test-plan` command
- Modifications to `/update-feature-knowledge` command
- Automated documentation gathering (remains user-driven)
- Integration commands (Jira, Testmo)
- Multi-agent orchestration changes

---

### Technical Considerations

**Context Detection:**
- Use `pwd` or similar to check current working directory
- Parse path to identify feature-name and ticket-id segments
- Fallback to interactive prompts if path parsing fails
- Validate detected context before proceeding

**Gap Detection Visibility:**
- **Critical requirement:** Always explicitly show user when gaps are detected
- Display count of gaps and brief description
- Provide clear options for how to handle gaps
- Include metadata when appending gaps (source ticket, date)

**Re-execution Logic:**
- Check for existence of target files before analysis
- Provide meaningful options based on context (feature vs ticket)
- Preserve existing content if user cancels

**Documentation Validation:**
- Check if documentation/ folder exists
- Check if folder contains readable files
- Provide helpful error messages with next steps if empty
- Interactive prompt to show gathering guidance

**Migration Strategy:**
- Remove `/plan-feature` command orchestrator and phases
- Remove `/plan-ticket` command orchestrator and phases
- Preserve shared standards and templates
- Update CHANGELOG.md with breaking change notice
- Update QA-QUICKSTART.md with new workflow
- Update README.md with new command reference

**Backward Compatibility:**
- **Breaking change:** No aliases or legacy command support
- Users must update their workflows to use new commands
- Folder structure remains unchanged (qa-agent-os/features/[feature-name]/[ticket-id]/)
- Existing feature-knowledge.md, feature-test-strategy.md, test-plan.md, test-cases.md formats remain unchanged

**Standards References:**
All commands should reference existing standards:
- `@qa-agent-os/standards/bugs/`
- `@qa-agent-os/standards/requirement-analysis/`
- `@qa-agent-os/standards/testcases/`
- `@qa-agent-os/standards/testing/`

**Template References:**
- `/start-feature` and `/start-ticket`: No templates (structure only)
- `/gather-docs`: No templates (prompts only)
- `/analyze-requirements`:
  - Feature context: `@qa-agent-os/templates/feature-knowledge-template.md`, `@qa-agent-os/templates/feature-test-strategy-template.md`
  - Ticket context: `@qa-agent-os/templates/test-plan-template.md`

---

### Command Comparison Matrix

| Command | Context | Input | Output | Re-execution | Automation |
|---------|---------|-------|--------|--------------|------------|
| `/start-feature` | Feature | Feature name | Folder structure | Prompt on exists | None |
| `/start-ticket` | Ticket | Ticket ID + feature selection | Folder structure | Prompt on exists | None |
| `/gather-docs` | Both | Auto-detect or prompt | Guidance prompts | N/A | None |
| `/analyze-requirements` | Both | Auto-detect or prompt | feature-knowledge.md + feature-test-strategy.md (feature) OR test-plan.md (ticket) | Smart prompts with options | Full |
| `/generate-testcases` | Ticket | Ticket ID | test-cases.md | Prompt with overwrite/append | Full |

---

### Workflow Examples

**Example 1: New Feature with Ticket**
```bash
# User commands:
/start-feature "User Authentication"
/gather-docs
# [User adds BRD, API specs, mockups to documentation/]
/analyze-requirements
# [Creates feature-knowledge.md and feature-test-strategy.md]

/start-ticket "AUTH-123"
/gather-docs
# [User adds ticket description, acceptance criteria to documentation/]
/analyze-requirements
# [Gap detection runs, prompts to append to feature-knowledge.md]
# [Creates test-plan.md, offers test case generation]
/generate-testcases "AUTH-123"
# [Creates test-cases.md]
```

**Example 2: Re-analyzing Ticket After Updates**
```bash
# User adds new documentation to ticket's documentation/ folder
cd qa-agent-os/features/user-authentication/AUTH-123/
/analyze-requirements
# [Detects existing test-plan.md]
# [Prompts: [1] Full re-analysis [2] Append [3] Cancel]
# [User selects option, gap detection runs again]
```

**Example 3: Running from Arbitrary Directory**
```bash
cd src/components/
/analyze-requirements
# [Cannot detect context from current directory]
# [Prompts: [1] Analyze feature [2] Analyze ticket [3] Cancel]
# [Shows available features, user selects]
# [Proceeds with analysis]
```
