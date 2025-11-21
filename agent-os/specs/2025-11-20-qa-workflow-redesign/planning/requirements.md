# Spec Requirements: QA Workflow Redesign

## Initial Description

The user wants to fix and restructure the qa-agent-os project to better align with actual QA workflows. The project currently has commands that don't follow the natural QA process flow.

**Current workflow:** plan-product (works) → init-feature → analyze-requirements → generate-testcases

**Problem:** The commands between init-feature and generate-testcases need restructuring to match real QA workflow (Plan-Do-Check-Act)

**Goal:** Create a coherent command structure that mirrors how QAs actually work with features and tickets

## Requirements Discussion

### Analysis of Agent-OS Pattern: Why `/gather-feature-docs` Command is Needed

After analyzing the agent-os reference project at `/refs/agent-os/`, I can explain why a `/gather-feature-docs` command is valuable based on the established pattern:

**The Agent-OS Pattern:**
Agent-OS uses a **two-phase information gathering approach** visible in workflows like `plan-product`:

1. **Phase 1: gather-product-info.md** - Collects raw information from user
2. **Phase 2: create-product-mission.md** - Consolidates that information into structured documentation

This pattern separates:
- **Collection** (gathering scattered information)
- **Consolidation** (creating coherent documentation)

**Why This Applies to QA Workflow:**

In real QA work, feature documentation comes from multiple sources:
- Product Owner (BRD, user stories)
- Backend team (API specs, calculation logic)
- Frontend team (mockups, interaction patterns)
- Business analysts (business rules, edge cases)

**Without `/gather-feature-docs`:**
- QA manually copies files into `features/[feature-name]/documentation/`
- Risk of missing critical documents
- No structured collection process
- QA has to remember to gather from all sources

**With `/gather-feature-docs`:**
- Command prompts QA for documentation from each stakeholder
- Systematically checks: "Do you have BRD? API specs? Mockups? Business rules?"
- Stores raw documents in organized structure
- Creates audit trail of what was collected and when
- Ensures nothing is missed before consolidation phase

**Automatic Execution After `/init-feature`:**
This makes sense because:
1. `/init-feature` creates the folder structure
2. `/gather-feature-docs` immediately prompts to populate `documentation/` folder
3. QA doesn't forget to collect documents before starting analysis
4. Follows agent-os pattern: initialize → gather → consolidate

**Analogy to Agent-OS:**
- `/plan-product` = `/init-feature` (creates structure)
- `gather-product-info` = `/gather-feature-docs` (collects raw data)
- `create-product-mission` = `/consolidate-feature-knowledge` (creates master doc)

### Expert Recommendation: Question 4 - Feature Knowledge Updates

**Question:** When a new ticket is added to an existing feature that already has `feature-knowledge.md`, what should happen?

**Options:**
- **Option A:** `/init-ticket` checks if new ticket introduces requirements not in feature-knowledge.md and prompts to update
- **Option B:** Require manual execution of `/consolidate-feature-knowledge` again
- **Option C:** `/analyze-ticket-requirements` automatically appends to feature-knowledge.md if gaps detected

**RECOMMENDATION: Option C with safeguards**

**Rationale:**

1. **Efficiency:** QAs shouldn't have to manually re-run consolidation for every ticket
   - Ticket-level analysis is the natural point to detect gaps
   - QA is already reviewing requirements at this stage
   - Automatic detection reduces cognitive load

2. **Accuracy:** `/analyze-ticket-requirements` has full context
   - Already reading ticket documentation
   - Already comparing against feature-knowledge.md for test planning
   - Best positioned to identify gaps in feature documentation

3. **Workflow Integration:**
   ```
   /init-ticket [creates ticket folder]
     ↓
   /analyze-ticket-requirements [reads ticket + feature-knowledge.md]
     ↓
   [Detects: "This ticket mentions new calculation logic not in feature-knowledge.md"]
     ↓
   [Prompts: "I found new requirements. Should I append to feature-knowledge.md?"]
     ↓
   [If yes: Appends section with timestamp and ticket reference]
     ↓
   [Creates test-plan.md]
   ```

4. **Safety Through Prompting:**
   - Don't silently auto-append (could introduce errors)
   - Prompt QA: "I found new business rule X in ticket-123. Add to feature-knowledge.md?"
   - QA confirms before update
   - Maintains human oversight

5. **Traceability:**
   - Each appended section notes: "Added from [ticket-id] on [date]"
   - Clear audit trail of knowledge evolution
   - Easy to trace which ticket introduced which requirement

**Implementation Pattern:**
```markdown
## [Section added from TICKET-123 on 2025-11-20]

### New Business Rule: Late Payment Penalties
[Content from ticket-123's specific requirements]

**Source:** TICKET-123
**Added:** 2025-11-20 during ticket requirement analysis
```

**Why Not Option A or B:**

- **Option A (init-ticket checks):** Too early - ticket folder just created, no analysis yet
- **Option B (manual re-run):** Inefficient, QAs will forget, leads to stale feature-knowledge.md

### Expert Recommendation: Question 5 - Test Strategy Evolution

**Question:** When should `feature-test-strategy.md` be updated? Should there be a `/revise-feature-strategy` command or manual edits?

**RECOMMENDATION: Manual edits only, NO `/revise-feature-strategy` command**

**Rationale:**

1. **Strategy Updates Are Infrequent:**
   - Test strategy defines the overall approach once
   - Most tickets won't change the fundamental testing philosophy
   - Updates happen only when:
     - New test types needed (e.g., first time needing performance testing)
     - New tools/environments introduced
     - Significant risks discovered
   - These are **strategic decisions** requiring human judgment

2. **Strategic vs Tactical:**
   - **Strategy** = High-level decisions (manual, thoughtful)
   - **Tactical** = Execution details (can be automated)
   - Feature test strategy falls into strategic category
   - Shouldn't be automated - requires QA lead/architect review

3. **Prevents Automation Drift:**
   - Automated strategy updates could lead to:
     - Inconsistent approaches across tickets
     - Unintentional strategy changes
     - Loss of coherent testing philosophy
   - Manual edits ensure intentional, reviewed changes

4. **Simple File Edit is Sufficient:**
   - Feature-test-strategy.md is a markdown file
   - QA can directly edit when needed
   - Version control (git) tracks changes
   - No need for command overhead

5. **Revision History Through Git:**
   ```bash
   # QA can always check strategy evolution
   git log features/payment-processing/feature-test-strategy.md

   # See what changed and why
   git diff [commit] features/payment-processing/feature-test-strategy.md
   ```

6. **When Manual Updates Occur:**
   - **Scenario 1:** Ticket-3 introduces performance requirements
     - QA manually edits feature-test-strategy.md
     - Adds "Performance Testing" section
     - Commits with message: "Add performance testing to strategy for TICKET-3 requirements"

   - **Scenario 2:** New security audit requirement
     - QA manually adds security testing approach
     - All future tickets inherit this updated strategy

**Comparison to `/revise-test-plan` (ticket-level):**
- **Ticket test plans** change frequently during testing (discoveries, edge cases)
- That's why `/revise-test-plan` command makes sense
- **Feature strategies** are stable - manual edits appropriate

**Alternative Approach (NOT recommended):**
If you still want a command, make it a **review helper** not an auto-updater:
```
/review-feature-strategy
  → Reads all ticket test-plans
  → Identifies patterns: "3 tickets needed API testing"
  → Suggests: "Consider adding API testing to feature strategy?"
  → QA decides and manually edits
```
This is over-engineering for limited value.

### Final Answers to Follow-Up Questions

**1. Command Triggering & Automation:**
- `/gather-feature-docs` runs **AUTOMATICALLY** after `/init-feature`
- `feature-test-strategy.md` creation should be **SEPARATE** from `/init-feature` (manual command)
- Mixed approach: Some automatic (gather-docs after init), most manual

**2. Ticket Lifecycle & Quality Gates:**
- **NO** `/close-ticket` or `/verify-ticket-complete` command for now
- Keep workflow focused on test planning and execution
- Quality gates can be added in future iteration

**3. Jira Integration:**
- **NOT NOW** - focus on core QA workflow first
- Jira integration commands remain separate
- Can be integrated in future version once core workflow is solid

**4. Feature Knowledge Updates:**
- **Option C** (with safeguards): `/analyze-ticket-requirements` detects gaps and prompts to append to feature-knowledge.md
- Requires user confirmation before updating
- Adds traceability metadata (source ticket, date)

**5. Test Strategy Evolution:**
- **Manual edits** to feature-test-strategy.md
- **NO** `/revise-feature-strategy` command
- Strategy updates are infrequent strategic decisions requiring human judgment
- Git provides version history and change tracking

**6. Template Selection:**
- **Hybrid template** combining best of both existing templates
- Feature-test-strategy.md: Streamlined 10-section strategic template
- [ticket-id]/test-plan.md: Comprehensive 10-section tactical template

**7. Testmo/CSV Export:**
- **Defer to later** - focus on core workflow first
- Keep test case generation simple initially
- Export commands can be added once core workflow is proven

**8. Visual Assets:**
- None available (this is a bash/CLI project)

## Existing Code to Reference

No similar existing features identified for reference within QA Agent OS project structure.

However, patterns to follow from **agent-os reference project** (`/refs/agent-os/`):
- **Workflow pattern:** `profiles/default/workflows/planning/` - gather → consolidate pattern
- **Command structure:** `profiles/default/commands/shape-spec/` - multi-phase commands
- **Documentation hierarchy:** spec initialization → research → write pattern

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
N/A - This is a CLI/workflow redesign for a bash-based project.

## Requirements Summary

### Functional Requirements

**Feature-Level Documentation:**
1. Create `features/[feature-name]/` structure
2. Create `features/[feature-name]/documentation/` for raw docs
3. Create `features/[feature-name]/feature-knowledge.md` (consolidated requirements)
4. Create `features/[feature-name]/feature-test-strategy.md` (strategic test approach)
5. Support automatic document gathering after initialization

**Ticket-Level Documentation:**
1. Create `features/[feature-name]/[ticket-id]/` structure
2. Create `features/[feature-name]/[ticket-id]/documentation/` for ticket-specific docs
3. Create `features/[feature-name]/[ticket-id]/test-plan.md` (tactical test plan)
4. Create `features/[feature-name]/[ticket-id]/test-cases.md` (generated test cases)
5. Support iterative test plan revision during testing

**Knowledge Management:**
1. Detect gaps in feature-knowledge.md during ticket analysis
2. Prompt QA to update feature-knowledge.md with new requirements
3. Maintain traceability (which ticket introduced which requirement)
4. Manual updates to feature-test-strategy.md (no automated revision)

**Command Workflow (UPDATED):**

**FEATURE-LEVEL WORKFLOW:**
1. `/plan-feature [feature-name]` → **ORCHESTRATOR COMMAND** that runs phases automatically:
   - Phase 1: Initialize feature folder structure
   - Phase 2: Gather feature documentation (prompts QA for docs)
   - Phase 3: Consolidate feature knowledge (creates feature-knowledge.md)
   - Phase 4: Create feature test strategy (creates feature-test-strategy.md)

**TICKET-LEVEL WORKFLOW:**
2. `/plan-ticket [ticket-id]` → **ORCHESTRATOR COMMAND** with flexible execution:
   - Phase 1: Initialize ticket folder structure
   - Phase 2: Gather ticket documentation (prompts QA for ticket-specific docs)
   - Phase 3: Analyze ticket requirements (creates test-plan.md, detects feature-knowledge gaps)
   - Phase 4: Generate test cases (creates test-cases.md) **← OPTIONAL PHASE**

   **After Phase 3 (test-plan.md created), AI prompts:**
   ```
   "Test plan created. Options:
   [1] Continue to Phase 4: Generate test cases now
   [2] Stop here (review test plan first, generate test cases later)

   Choose [1/2]:"
   ```

**TEST CASE GENERATION (Flexible):**
3. `/generate-testcases` → **STANDALONE COMMAND** to generate or regenerate test cases
   - Can be called after reviewing/revising test-plan.md
   - Can be called to regenerate after test plan updates
   - Reads current test-plan.md and creates/updates test-cases.md

**ITERATIVE REFINEMENT:**
4. `/revise-test-plan` → Updates test-plan.md based on testing discoveries (manual, repeatable)
5. `/update-feature-knowledge` → Manual command to update feature-knowledge.md when needed

**RATIONALE FOR CHANGES:**

**Why `/plan-feature` instead of separate commands:**
- Follows agent-os pattern (single orchestrator with phases)
- QA runs ONE command instead of four separate commands
- Phases execute automatically in sequence
- Matches natural workflow: "I'm planning this feature"
- Reduces cognitive load and command memorization

**Why `/plan-ticket` instead of separate commands:**
- Same orchestrator pattern as `/plan-feature`
- Natural continuation: after planning feature, you plan tickets
- Automatic flow: init → gather → analyze → generate
- QA doesn't forget any steps

**Why `/generate-testcases` is separate AND optional in orchestration:**
- QA often needs time to review test-plan.md before generating cases
- Test plan may need additional information from PO/Dev before case generation
- QA may want to manually refine test plan first
- Allows regeneration after test plan updates without re-running full ticket analysis
- Flexibility: Can generate immediately (option 1) or later (option 2 + manual command)

**Why keep `/revise-test-plan` separate:**
- Iterative process happens DURING testing (not during planning)
- May be called multiple times
- Different mental context (execution vs planning)
- After revision, QA can call `/generate-testcases` to regenerate cases

**Command Comparison:**

OLD (8 manual commands):
```
/init-feature [feature-name]
/gather-feature-docs
/consolidate-feature-knowledge
/create-feature-test-strategy
/init-ticket [ticket-id]
/analyze-ticket-requirements
/revise-test-plan
/generate-testcases
```

NEW (5 commands, 2 orchestrated with flexibility):
```
/plan-feature [feature-name]     ← Runs 4 phases automatically
/plan-ticket [ticket-id]         ← Runs 3-4 phases (prompts after Phase 3)
/generate-testcases              ← Generate/regenerate test cases anytime
/revise-test-plan                ← Manual iteration during testing
/update-feature-knowledge        ← Manual updates (rare)
```

**ANSWERED QUESTIONS:**

**Q1: Orchestrated approach?**
✅ YES - Use orchestrated commands (`/plan-feature`, `/plan-ticket`)

**Q2: How does `/plan-ticket` know which feature?**
✅ **AI auto-detects** by prompting: "Which feature does ticket [ticket-id] belong to?"
- Shows list of existing features in `qa-agent-os/features/`
- QA selects from list or types new feature name
- If only one feature exists, auto-selects it

**Q3: Re-execution approach?**
✅ **SMART DETECTION** - When `/plan-ticket` is called on existing ticket:
```
AI detects: "Ticket WYX-123 already exists."

Options:
[1] Full re-plan (Phases 1-4: re-gather docs, re-analyze, regenerate)
[2] Update test plan only (Skip to Phase 3: re-analyze requirements)
[3] Regenerate test cases only (Skip to Phase 4: use existing test-plan.md)
[4] Cancel

Choose [1/2/3/4]:
```

**Why this is better than separate commands:**
- Single command does everything (`/plan-ticket`)
- AI intelligently detects context (new vs existing ticket)
- QA chooses level of re-work needed
- No need to remember multiple command names

**ADDITIONAL HELPFUL COMMANDS (Optional):**

5. `/report-bug` → Quick bug documentation following bug standards (can be called anytime during testing)
6. `/export-to-testmo` → Export test-cases.md to Testmo CSV format (deferred to later)

**COMPLETE QA WORKFLOW VISUALIZATION:**

```
┌─────────────────────────────────────────────────────────────────┐
│                    PHASE 1: PRODUCT PLANNING                    │
│                  (One-time, at project start)                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                    /plan-product
                              │
                    Creates: product/mission.md
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   PHASE 2: FEATURE PLANNING                     │
│           (Once per Epic/Feature assigned to QA)                │
└─────────────────────────────────────────────────────────────────┘
                              │
                    /plan-feature [feature-name]
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
    Phase 1: Init folders          Phase 2: Gather docs
    features/[feature-name]/       Prompts: BRD? API specs?
              │                               │
              ▼                               ▼
    Phase 3: Consolidate          Phase 4: Create strategy
    feature-knowledge.md          feature-test-strategy.md
              │
              └───────────────┬───────────────┘
                              ▼
                    FEATURE READY FOR TICKETS
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PHASE 3: TICKET PLANNING                     │
│              (For each ticket in the feature)                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                    /plan-ticket [ticket-id]
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
    Phase 1: Init ticket folder    Phase 2: Gather ticket docs
    features/[feature]/[ticket]/   Prompts: Jira PDF? Specs?
              │                               │
              ▼                               ▼
    Phase 3: Analyze requirements  Phase 4: Generate test cases
    Creates: test-plan.md          Creates: test-cases.md
    Checks: feature-knowledge gaps
              │
              └───────────────┬───────────────┘
                              ▼
                    TICKET READY FOR TESTING
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PHASE 4: TEST EXECUTION                      │
│                    (Iterative process)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                    Execute test-cases.md
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
    Found new edge case?           Found a bug?
    /revise-test-plan              /report-bug
    Updates: test-plan.md          Creates: bug report
              │                               │
              ▼                               ▼
    Re-run:                        Log in Jira
    /plan-ticket [ticket-id]       Continue testing
    (Phase 4 only - regenerate cases)
                              │
                              └───────────────┬───────────────┘
                                              ▼
                                    ALL TESTS PASS
                                              │
                                              ▼
                                    TICKET COMPLETE
                                              │
                                              ▼
                              ┌───────────────────────────┐
                              │  Next ticket in feature?  │
                              │  YES → /plan-ticket       │
                              │  NO  → Feature complete   │
                              └───────────────────────────┘
```

**WORKFLOW DECISION TREE:**

```
START: QA receives assignment
│
├─ Is this a NEW FEATURE?
│  └─ YES → /plan-feature [feature-name]
│     │
│     └─ After completion → /plan-ticket [first-ticket-id]
│
├─ Is this ANOTHER TICKET in EXISTING FEATURE?
│  └─ YES → /plan-ticket [ticket-id]
│     │
│     └─ AI detects gaps in feature-knowledge.md
│         └─ Prompts: "Add new calculation logic to feature-knowledge.md? [y/n]"
│
├─ DURING TESTING: Found edge case not in test plan?
│  └─ /revise-test-plan
│     └─ Adds new scenarios
│     └─ Re-run: /plan-ticket [ticket-id] (Phase 4 only)
│         └─ Regenerates test-cases.md with new scenarios
│
├─ DURING TESTING: Found a bug?
│  └─ /report-bug
│     └─ Guided bug documentation
│     └─ Continue testing
│
└─ END: All tickets in feature complete
   └─ Feature tested and closed
```

**KEY COMMAND TRIGGERS:**

| Trigger | Command | Phases/Behavior | Auto/Manual |
|---------|---------|-----------------|-------------|
| New feature assigned | `/plan-feature` | 4 phases auto | Manual trigger |
| First/new ticket in feature | `/plan-ticket` | 3-4 phases (prompts after Phase 3) | Manual trigger |
| Auto-detect feature | AI prompts within `/plan-ticket` | Shows feature list, QA selects | Auto-detect + manual confirm |
| Stop after test plan (need review) | Choose option 2 in `/plan-ticket` | Stops after Phase 3 | Manual choice |
| Generate test cases (first time) | Choose option 1 in `/plan-ticket` OR `/generate-testcases` | Phase 4 or standalone | Manual choice |
| Regenerate test cases | `/generate-testcases` | Reads test-plan.md, regenerates | Manual trigger |
| Found edge case during testing | `/revise-test-plan` | Updates test-plan.md, optional regenerate | Manual |
| Re-analyze existing ticket | `/plan-ticket [existing-ticket]` | Smart detection with 4 options | Manual trigger + context detection |
| Found a bug | `/report-bug` | Guided prompts | Manual |
| Feature knowledge gap detected | AI prompts within Phase 3 | Append to feature-knowledge.md | Auto-detect + manual confirm |
| Strategy needs update | Direct edit | None (edit markdown) | Manual |

**PHASE EXECUTION EXAMPLES:**

**Example 1: Brand New Feature**
```bash
# QA receives Epic: "TWRR Portfolio Calculation"
$ /plan-feature TWRR

  → Phase 1: Creating features/TWRR/...
  → Phase 2: Gathering documentation
    Prompt: "Do you have BRD for TWRR? [path or paste]"
    QA: [pastes content]
    Prompt: "Do you have API specs?"
    QA: /docs/twrr-api.yaml
    ... [continues for all doc types]
  → Phase 3: Consolidating knowledge
    Creates: features/TWRR/feature-knowledge.md
  → Phase 4: Creating test strategy
    Prompt: "What test levels are needed? [API/UI/E2E]"
    QA: API, UI
    Creates: features/TWRR/feature-test-strategy.md

# Now ready for first ticket
$ /plan-ticket WYX-123

  → Phase 1: Creating features/TWRR/WYX-123/...
  → Phase 2: Gathering ticket docs
  → Phase 3: Analyzing requirements
    Reading: features/TWRR/feature-knowledge.md
    Comparing: WYX-123 requirements
    AI: "I found new business rule: TWRR calculation for partial periods. Add to feature-knowledge.md? [y/n]"
    QA: y
    Creates: features/TWRR/WYX-123/test-plan.md
  → Phase 4: Generating test cases
    Creates: features/TWRR/WYX-123/test-cases.md
```

**Example 2: Second Ticket in Existing Feature**
```bash
# QA receives second ticket for same feature
$ /plan-ticket WYX-124

  → Phase 1: Detecting existing feature TWRR ✓
    Creating: features/TWRR/WYX-124/...
  → Phase 2: Gathering ticket docs
  → Phase 3: Analyzing requirements
    Reading: features/TWRR/feature-knowledge.md (already exists)
    Reading: features/TWRR/feature-test-strategy.md (already exists)
    Inheriting: Test approach from feature strategy
    No gaps detected in feature-knowledge.md ✓
    Creates: features/TWRR/WYX-124/test-plan.md
  → Phase 4: Generating test cases
    Creates: features/TWRR/WYX-124/test-cases.md
```

**Example 3: Stopping After Test Plan (Need to Review First)**
```bash
# QA wants to create test plan but review it before generating cases
$ /plan-ticket WYX-125

  Prompt: "Which feature does WYX-125 belong to?"
  Features found:
    [1] TWRR
    [2] Create new feature
  QA: 1

  → Phase 1: Creating features/TWRR/WYX-125/...
  → Phase 2: Gathering ticket docs
  → Phase 3: Analyzing requirements
    Creates: features/TWRR/WYX-125/test-plan.md

  Prompt: "Test plan created. Options:
    [1] Continue to Phase 4: Generate test cases now
    [2] Stop here (review test plan first, generate test cases later)
    Choose [1/2]:"
  QA: 2

  ✓ Test plan ready for review at: features/TWRR/WYX-125/test-plan.md
  Run /generate-testcases when ready.

# Later, after reviewing and getting more info from PO...
$ /generate-testcases

  Prompt: "Which ticket's test cases to generate?"
  Recent tickets:
    [1] WYX-125 (no test-cases.md yet)
    [2] WYX-124 (has test-cases.md)
    [3] WYX-123 (has test-cases.md)
  QA: 1

  → Reading: features/TWRR/WYX-125/test-plan.md
  → Generating test cases...
  ✓ Created: features/TWRR/WYX-125/test-cases.md (23 test cases)
```

**Example 4: Iterative Refinement and Regeneration**
```bash
# During testing WYX-123, QA discovers edge case
$ /revise-test-plan

  Prompt: "Which ticket's test plan to revise?"
  QA: WYX-123

  Prompt: "What did you discover?"
  QA: "TWRR calculation fails when portfolio has zero value on first day"

  Updates: features/TWRR/WYX-123/test-plan.md
    Section: Revisions
    Added: "2025-11-20: Added edge case for zero-value portfolio start"
    Section: Test Scenarios
    Added: New test scenario TC-15

  Prompt: "Regenerate test cases now? [y/n]"
  QA: y

  → Reading: features/TWRR/WYX-123/test-plan.md (includes new TC-15)
  ✓ Updated: features/TWRR/WYX-123/test-cases.md (now 24 test cases)

# Alternative: QA says 'n' and regenerates later
$ /generate-testcases

  [prompts for ticket selection]
  QA: WYX-123

  Warning: "test-cases.md already exists. Overwrite? [y/n]"
  QA: y

  ✓ Regenerated: features/TWRR/WYX-123/test-cases.md (24 test cases)
```

**Example 5: Re-running Ticket Planning (Smart Detection)**
```bash
# QA wants to re-analyze WYX-123 after getting new requirements
$ /plan-ticket WYX-123

  AI detects: "Ticket WYX-123 already exists."

  Options:
    [1] Full re-plan (Phases 1-4: re-gather docs, re-analyze, regenerate)
    [2] Update test plan only (Skip to Phase 3: re-analyze requirements)
    [3] Regenerate test cases only (Skip to Phase 4: use existing test-plan.md)
    [4] Cancel

  Choose [1/2/3/4]:
  QA: 2

  → Phase 3: Re-analyzing requirements
    Reading: features/TWRR/WYX-123/documentation/*
    Reading: features/TWRR/feature-knowledge.md
    Comparing with existing test-plan.md
    AI: "I found 3 new requirements not in current test-plan.md"
    Updates: features/TWRR/WYX-123/test-plan.md
      Added: 3 new testable requirements
      Updated: Test coverage matrix

  Prompt: "Test plan updated. Continue to Phase 4? [1] Yes [2] No"
  QA: 1

  → Phase 4: Regenerating test cases
  ✓ Updated: features/TWRR/WYX-123/test-cases.md (27 test cases)
```

### Reusability Opportunities

**From agent-os reference project:**
- **Gather → Consolidate pattern:** Use same two-phase approach from `plan-product` workflow
- **Phase orchestration:** Multi-phase commands with sequential execution
- **File structure initialization:** Pattern from `initialize-spec.md`
- **Research workflow:** Question → answer → document pattern from `research-spec.md`

**Within QA Agent OS standards:**
- **Test plan templates:** Adapt existing `test-plan-template.md` and `qa_test_design_template.md`
- **Bug reporting standards:** Reference from `standards/bugs/`
- **Requirement analysis standards:** Reference from `standards/requirement-analysis/`

### Scope Boundaries

**In Scope:**
- Redesigned QA workflow commands (init-feature through generate-testcases)
- Feature-level and ticket-level folder structures
- Automatic documentation gathering
- Feature knowledge gap detection and updates
- Test strategy creation (manual) and test plan creation/revision (command-based)
- Hybrid template creation combining best of both existing templates
- Command orchestration (automatic gather-docs after init-feature)

**Out of Scope:**
- Jira integration (deferred)
- Testmo/CSV export (deferred)
- `/close-ticket` or `/verify-ticket-complete` quality gate commands (deferred)
- Test execution tracking and results management (future phase)
- Automated test strategy revision (explicitly rejected - manual edits only)
- Visual/mockup management commands (not applicable for bash project)

### Technical Considerations

**Folder Structure:**
```
qa-agent-os/
  features/
    [feature-name]/
      documentation/              ← Raw docs from stakeholders
        brd-from-po.pdf
        api-specs.md
        calculations.md
        mockups/
          screen1.png
      feature-knowledge.md        ← Consolidated master doc (WHAT we're building)
      feature-test-strategy.md    ← Strategic test approach (HOW we test feature)
      [ticket-id-1]/
        documentation/            ← Ticket-specific docs
          ticket-from-jira.pdf
          ticket-info.md
          visuals/
            lofi-mockup.png
        test-plan.md              ← Tactical test plan for this ticket
        test-cases.md             ← Generated test cases
      [ticket-id-2]/
        documentation/
        test-plan.md
        test-cases.md
```

**Command Integration Points:**
- `/init-feature` → Automatically triggers `/gather-feature-docs`
- `/gather-feature-docs` → Prompts for documents, stores in `documentation/`
- `/consolidate-feature-knowledge` → Reads `documentation/*`, creates `feature-knowledge.md`
- `/create-feature-test-strategy` → Creates `feature-test-strategy.md` using hybrid template
- `/analyze-ticket-requirements` → Reads feature-knowledge.md, compares to ticket, prompts for updates if gaps detected
- `/revise-test-plan` → Updates test-plan.md, preserves revision history

**Template Specifications:**

**feature-test-strategy.md (10 sections - Strategic):**
1. Testing Objective (goal, scope, out-of-scope)
2. Test Approach (levels, types coverage)
3. Test Environment & Tools (environments, browsers, tools, frameworks)
4. Test Data Strategy (sources, refresh, boundary values)
5. Automation Strategy (scope, frameworks, CI/CD, selectors)
6. Non-Functional Requirements (performance, security, accessibility)
7. Risk Assessment (risks, impact, mitigation)
8. Entry & Exit Criteria (feature-level gates)
9. Deliverables (per-ticket plans, cases, reports)
10. Roles & Responsibilities (team structure)

**[ticket-id]/test-plan.md (10 sections - Tactical):**
1. Reference (links to feature-test-strategy.md, feature-knowledge.md, ticket docs)
2. Ticket Overview (ID, summary, acceptance criteria)
3. Test Scope (in-scope, out-of-scope, dependencies)
4. Testable Requirements (granular requirement breakdown with inputs/outputs)
5. Test Coverage Matrix (requirement → test case traceability)
6. Test Scenarios & Cases (detailed test cases with steps)
7. Test Data Requirements (specific data sets for this ticket)
8. Environment Setup (URLs, accounts, feature flags)
9. Execution Timeline (dates, resources, milestones)
10. Entry/Exit Criteria (ticket-level gates)
11. Revisions (change log for iterative updates)

**Standards Compliance:**
- Follow existing QA Agent OS bug reporting standards (`standards/bugs/`)
- Use requirement analysis patterns (`standards/requirement-analysis/`)
- Align with test case generation standards (`standards/testcases/`)
- Reference test plan templates (`standards/testing/test-plan-template.md`)

**Git Workflow:**
- Feature-test-strategy.md updates tracked through git commits
- Test-plan.md revisions documented in "Revisions" section + git history
- Feature-knowledge.md appends include source ticket and timestamp

**User Prompts:**
- `/gather-feature-docs`: "Do you have [BRD/API specs/mockups/business rules]? Provide file path or paste content."
- `/analyze-ticket-requirements` gap detection: "I found new requirement: [description]. Add to feature-knowledge.md? [y/n]"
- `/create-feature-test-strategy`: Template-guided prompts for each section

### Key Design Decisions

**1. Why Automatic `/gather-feature-docs` After `/init-feature`:**
- Follows agent-os pattern (initialize → gather → consolidate)
- Ensures systematic document collection before analysis
- Prevents QAs from skipping documentation phase
- Creates structured collection process

**2. Why Option C for Feature Knowledge Updates:**
- Most efficient: detects gaps during natural workflow point
- QA has full context during ticket requirement analysis
- Prompt-based safeguard prevents silent auto-updates
- Maintains traceability through source ticket metadata

**3. Why Manual Edits for Feature Test Strategy:**
- Strategy updates are infrequent strategic decisions
- Requires human judgment and QA lead review
- Git provides sufficient version tracking
- Prevents automation drift and inconsistency
- Strategy is stable, unlike tactical plans

**4. Why Hybrid Template Approach:**
- Feature-test-strategy: Streamlined 10 sections (strategic focus)
- Ticket test-plan: Comprehensive 10 sections (tactical details)
- Balances thoroughness with usability
- Aligns with industry standard separation of strategy vs plan

**5. Why Defer Jira/Testmo Integration:**
- Core workflow must be solid before integration
- Integration adds complexity that could obscure workflow issues
- Easier to test and refine standalone workflow first
- Can add integration cleanly once workflow is proven

**6. Why No Ticket Closure Commands:**
- Keeps initial scope focused on planning and test generation
- Quality gates and completion verification are separate concerns
- Can be added in future iteration once core workflow validated
- Reduces initial implementation complexity

### Success Criteria

**Workflow succeeds if:**
1. QA can initialize a feature and automatically gather documentation
2. Feature knowledge is consolidated without manual file manipulation
3. Feature test strategy provides reusable strategic framework
4. Ticket analysis detects knowledge gaps and prompts for updates
5. Test plans reference feature strategy (avoiding redundancy)
6. Test plan revision is seamless during iterative testing
7. Test cases generate from comprehensive test plans
8. Commands follow natural QA workflow (Plan-Do-Check-Act)
9. Documentation hierarchy is clear (feature → ticket)
10. Traceability is maintained (requirements → strategy → plans → cases)

**User experience goals:**
- QA spends less time on file management, more on analysis
- Clear command sequence matches mental model of QA work
- Documentation doesn't become stale (gap detection prevents this)
- No redundant information across feature/ticket levels
- Test plans are comprehensive yet focused on ticket scope
