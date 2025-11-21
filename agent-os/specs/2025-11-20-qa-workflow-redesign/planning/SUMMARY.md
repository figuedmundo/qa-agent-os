# QA Workflow Redesign - Spec Shaping Summary

**Spec Folder:** `agent-os/specs/2025-11-20-qa-workflow-redesign/`
**Date:** 2025-11-20
**Status:** ✅ Requirements Complete - Ready for Specification

---

## Overview

This spec addresses a complete redesign of the QA Agent OS workflow to align with real-world QA processes. The current command structure doesn't follow the natural QA workflow (Plan-Do-Check-Act), leading to inefficiencies and confusion.

### Problem Statement

**Current Issues:**
- Commands don't match QA mental model
- Too many manual commands to remember (8 separate commands)
- No clear workflow from feature planning → ticket testing → test execution
- Test case generation inflexible (can't review test plan before generating)
- No feature knowledge gap detection
- Unclear when to use which command

**Impact:**
- QAs skip important steps
- Documentation becomes stale
- Redundant information across feature/ticket levels
- Poor workflow efficiency

---

## Solution Overview

### Redesigned Workflow (5 Commands)

```
/plan-feature [feature-name]     ← Orchestrates 4 phases automatically
/plan-ticket [ticket-id]         ← Orchestrates 3-4 phases with flexibility
/generate-testcases              ← Standalone generation/regeneration
/revise-test-plan                ← Iterative updates during testing
/update-feature-knowledge        ← Manual knowledge updates (rare)
```

### Key Innovations

**1. Orchestrated Commands**
- Single command runs multiple phases automatically
- Follows agent-os proven pattern (`/plan-product`)
- Reduces cognitive load (QA runs ONE command, not four)

**2. Smart Feature Detection**
- AI auto-detects which feature a ticket belongs to
- Shows list of existing features
- Auto-selects if only one feature exists

**3. Flexible Test Case Generation**
- Can generate immediately (orchestrated)
- Can stop after test plan to review (manual later)
- Can regenerate anytime after updates
- Standalone command for maximum flexibility

**4. Intelligent Gap Detection**
- AI detects when ticket introduces new information
- Prompts QA to update feature-knowledge.md
- Maintains traceability (source ticket + timestamp)

**5. Smart Re-execution**
- Detects when ticket already exists
- Offers 4 options: full re-plan, update plan, regenerate cases, cancel
- Single command handles all scenarios

---

## Workflow Phases

### Phase 1: Product Planning (One-time)
```
/plan-product
  → Creates: product/mission.md
```
**Status:** ✅ Already working - no changes needed

---

### Phase 2: Feature Planning (Once per epic/feature)
```
/plan-feature [feature-name]
  → Phase 1: Initialize feature structure
  → Phase 2: Gather feature documentation
  → Phase 3: Consolidate feature knowledge
  → Phase 4: Create feature test strategy
```

**Creates:**
- `features/[feature-name]/documentation/` - Raw docs from stakeholders
- `features/[feature-name]/feature-knowledge.md` - Consolidated master doc (WHAT)
- `features/[feature-name]/feature-test-strategy.md` - Strategic approach (HOW)

**Key Features:**
- Systematic documentation gathering (BRD, API specs, mockups, business rules)
- Comprehensive knowledge consolidation
- Strategic test approach (levels, types, tools, environments)

---

### Phase 3: Ticket Planning (Per ticket)
```
/plan-ticket [ticket-id]
  → AI detects feature (prompts if multiple)
  → Phase 1: Initialize ticket structure
  → Phase 2: Gather ticket documentation
  → Phase 3: Analyze requirements + detect feature gaps
  → Phase 4: Generate test cases (OPTIONAL - QA chooses)
```

**Creates:**
- `features/[feature]/[ticket]/documentation/` - Ticket-specific docs
- `features/[feature]/[ticket]/test-plan.md` - Tactical test plan
- `features/[feature]/[ticket]/test-cases.md` - Executable test cases (if Phase 4 run)

**Key Features:**
- Auto-detects which feature ticket belongs to
- Detects gaps in feature-knowledge.md → prompts to update
- Flexible: Stop after test plan OR generate cases immediately
- Smart re-execution: Detects existing tickets, offers targeted options

---

### Phase 4: Test Execution (Iterative)
```
During testing:
  /revise-test-plan         ← Add edge cases, new scenarios
  /generate-testcases       ← Regenerate cases after updates
  /report-bug               ← Document bugs (optional future command)
```

**Updates:**
- `test-plan.md` - Add scenarios, update requirements
- `test-cases.md` - Regenerate with new scenarios

**Key Features:**
- Iterative refinement during testing
- Revision history tracked in test plan
- Optional automatic regeneration after revision

---

## Documentation Structure

### Feature Level (Strategic)

```
features/[feature-name]/
  documentation/              ← Raw source documents
    brd-from-po.pdf
    api-specs.yaml
    business-rules.md
    mockups/
  feature-knowledge.md        ← Consolidated WHAT (testable facts)
  feature-test-strategy.md    ← Strategic HOW (approach, tools, levels)
```

**feature-knowledge.md:**
- Feature overview and scope
- Business requirements and rules
- Technical requirements
- API endpoints, data model
- Edge cases and constraints
- Test considerations

**feature-test-strategy.md (10 sections):**
1. Testing Objective
2. Test Approach (levels, types)
3. Test Environment & Tools
4. Test Data Strategy
5. Automation Strategy
6. Non-Functional Requirements
7. Risk Assessment
8. Entry & Exit Criteria
9. Deliverables
10. Roles & Responsibilities

---

### Ticket Level (Tactical)

```
features/[feature-name]/[ticket-id]/
  documentation/              ← Ticket-specific docs
    ticket-from-jira.pdf
    ticket-info.md
    visuals/
      mockup.png
  test-plan.md                ← Tactical test plan for this ticket
  test-cases.md               ← Executable test cases
```

**test-plan.md (11 sections):**
1. References (links to feature docs)
2. Ticket Overview
3. Test Scope
4. Testable Requirements
5. Test Coverage Matrix
6. Test Scenarios & Cases
7. Test Data Requirements
8. Environment Setup
9. Execution Timeline
10. Entry/Exit Criteria
11. Revisions (change log)

**test-cases.md:**
- Detailed executable test cases
- Steps, expected results, test data
- Execution tracking (Pass/Fail/Blocked)
- Notes and defect links

---

## Key Design Decisions

### 1. Why Orchestrated Commands?

**Decision:** Use `/plan-feature` and `/plan-ticket` orchestrator commands instead of 8 separate manual commands

**Rationale:**
- Follows proven agent-os pattern
- QA runs ONE command instead of four
- Reduces cognitive load
- Prevents skipping important steps
- Matches natural workflow: "I'm planning this feature"

**Alternative Rejected:** Separate commands for init/gather/consolidate/create
- Too many commands to remember
- Easy to skip steps
- Doesn't match mental model

---

### 2. Why Optional Test Case Generation?

**Decision:** Prompt after Phase 3 to either generate cases immediately or stop for review

**Rationale:**
- QA often needs time to review test plan
- May need additional info from PO/Dev
- May want to manually refine test plan first
- Flexibility = critical for real-world workflow

**Alternative Rejected:** Always auto-generate test cases
- Too rigid
- Doesn't account for iterative nature of QA work

---

### 3. Why Auto-Detect Feature?

**Decision:** AI prompts "Which feature does this ticket belong to?" with list

**Rationale:**
- Reduces typing
- Prevents typos in feature names
- Shows available features (helpful)
- Auto-selects if only one option

**Alternative Rejected:** Require `/plan-ticket [feature] [ticket]`
- More typing
- Easy to mistype feature name
- Less user-friendly

---

### 4. Why Smart Re-execution?

**Decision:** When `/plan-ticket` detects existing ticket, show 4 targeted options

**Rationale:**
- Single command handles all scenarios
- QA chooses level of re-work needed
- Context-aware
- Efficient

**Alternative Rejected:** Separate commands like `/re-plan-ticket`, `/update-test-plan`, `/regenerate-cases`
- Too many commands
- Harder to remember
- Less intuitive

---

### 5. Why Feature Knowledge Gap Detection?

**Decision:** During Phase 3 (analyze requirements), AI compares ticket to feature-knowledge.md and prompts to update if gaps found

**Rationale:**
- Prevents feature knowledge from becoming stale
- Natural workflow point (QA already analyzing requirements)
- Maintains traceability (source ticket + timestamp)
- Requires confirmation (not silent updates)

**Alternative Rejected:**
- Manual `/update-feature-knowledge` only: QAs will forget, documentation becomes stale
- Auto-update without prompting: Too risky, could introduce errors

---

### 6. Why Separate `/generate-testcases`?

**Decision:** Both integrated in orchestration AND available as standalone command

**Rationale:**
- Maximum flexibility
- Can generate during orchestration (immediate)
- Can generate later after review (manual)
- Can regenerate after test plan updates
- One command, multiple use cases

**Alternative Rejected:** Only orchestrated generation
- Too inflexible
- Doesn't handle regeneration scenarios

---

## Success Criteria

### Workflow Success
- [x] QA can initialize feature and automatically gather documentation
- [x] Feature knowledge consolidated without manual file manipulation
- [x] Feature test strategy provides reusable framework
- [x] Ticket analysis detects knowledge gaps and prompts updates
- [x] Test plans reference feature strategy (avoid redundancy)
- [x] Test plan revision seamless during iterative testing
- [x] Test cases generate from comprehensive plans
- [x] Commands follow natural QA workflow
- [x] Documentation hierarchy clear (feature → ticket)
- [x] Traceability maintained (requirements → strategy → plans → cases)

### User Experience Goals
- [x] QA spends less time on file management, more on analysis
- [x] Clear command sequence matches mental model
- [x] Documentation doesn't become stale (gap detection)
- [x] No redundant information across levels
- [x] Test plans comprehensive yet focused
- [x] Flexible workflow accommodates real-world scenarios

---

## What's In Scope

**✅ In Scope:**
- Complete command workflow redesign (5 commands)
- Feature-level and ticket-level folder structures
- Automatic documentation gathering
- Feature knowledge gap detection with prompted updates
- Test strategy creation (strategic, feature-level)
- Test plan creation/revision (tactical, ticket-level)
- Flexible test case generation (orchestrated + standalone)
- Hybrid template creation (strategic + tactical)
- Command orchestration with smart detection
- Iterative refinement workflow

**❌ Out of Scope (Deferred):**
- Jira integration commands
- Testmo/CSV export
- `/close-ticket` or quality gate commands
- Test execution tracking/results management
- Automated test strategy revision
- Visual/mockup management commands

---

## Documentation Deliverables

### Completed Documents

1. **`requirements.md`** ✅
   - Complete requirements specification
   - Workflow visualizations and decision trees
   - Command sequence and triggers
   - 5 detailed real-world examples
   - Design decisions and rationale
   - Folder structure specifications
   - Template structures (10-11 sections each)

2. **`command-specifications.md`** ✅
   - Detailed spec for all 5 commands
   - Phase-by-phase breakdown
   - User interaction patterns
   - Prompts and responses
   - Template structures
   - Error handling
   - Success criteria
   - 3 test scenarios

3. **`research-findings.md`** ✅
   - Industry standard research
   - Agent-OS pattern analysis
   - Test plan template comparison
   - Expert recommendations with rationale

4. **`raw-idea.md`** ✅
   - Original problem description
   - Core issues to address

5. **`SUMMARY.md`** ✅ (this document)
   - Executive summary
   - Key innovations
   - Design decisions
   - Success criteria

---

## Next Steps

### 1. Write Formal Specification

Run `/write-spec` to create:
- Complete technical specification
- Implementation plan
- Phase markdown files for each command
- Installation script updates
- Testing procedures

### 2. Implementation Order

**Phase 1: Core Infrastructure**
1. Update folder structure templates
2. Create template files (feature-knowledge.md, feature-test-strategy.md, test-plan.md, test-cases.md)
3. Update `common-functions.sh` for new commands

**Phase 2: Feature Planning**
1. Implement `/plan-feature` orchestrator
2. Create 4 phase files for feature planning
3. Test feature planning workflow

**Phase 3: Ticket Planning**
1. Implement `/plan-ticket` orchestrator with smart detection
2. Create 4 phase files for ticket planning
3. Implement gap detection logic
4. Test ticket planning workflow

**Phase 4: Flexible Generation & Refinement**
1. Implement `/generate-testcases` standalone
2. Implement `/revise-test-plan`
3. Implement `/update-feature-knowledge`
4. Test iterative workflows

**Phase 5: Integration & Testing**
1. End-to-end testing of complete workflow
2. Test all interaction patterns
3. Validate against success criteria
4. User acceptance testing

### 3. Documentation Updates

- Update `CLAUDE.md` with new workflow
- Update `README.md` with command usage
- Create quickstart guide for QAs
- Update existing commands in `profiles/default/commands/`

---

## Questions Answered During Spec Shaping

### Q1: Should feature level have test strategy or just knowledge doc?
**Answer:** BOTH - `feature-knowledge.md` (WHAT) + `feature-test-strategy.md` (HOW)
**Rationale:** Industry standard separation, inheritance model, efficiency

### Q2: How should commands be structured?
**Answer:** Orchestrated commands (`/plan-feature`, `/plan-ticket`) with automatic phases
**Rationale:** Follows agent-os pattern, reduces cognitive load, prevents skipped steps

### Q3: Should test case generation be automatic or manual?
**Answer:** FLEXIBLE - Prompt after test plan creation, plus standalone `/generate-testcases`
**Rationale:** Real-world QA needs review time, flexibility critical

### Q4: How should feature knowledge updates work?
**Answer:** Auto-detect gaps during ticket analysis, prompt for confirmation, append with metadata
**Rationale:** Efficient, maintains accuracy, requires human oversight

### Q5: How to handle re-execution of existing tickets?
**Answer:** Smart detection with 4 options (full re-plan, update plan, regenerate cases, cancel)
**Rationale:** Single command, context-aware, QA chooses re-work level

### Q6: How should feature detection work?
**Answer:** AI prompts with list of existing features, auto-selects if only one
**Rationale:** Reduces typing, prevents errors, user-friendly

### Q7: What template structure to use?
**Answer:** Hybrid - 10-section strategic (feature), 11-section tactical (ticket)
**Rationale:** Industry alignment, comprehensive yet focused

---

## Key Metrics for Success

### Efficiency Metrics
- **Before:** 8 manual commands to plan one ticket
- **After:** 2 commands (plan-feature once, plan-ticket per ticket)
- **Improvement:** 75% reduction in command executions

### Quality Metrics
- Feature knowledge stays up-to-date (gap detection)
- Test coverage traceable (requirements → cases)
- No redundant documentation (inheritance model)
- Comprehensive test plans (hybrid templates)

### User Experience Metrics
- Clear workflow (Plan → Do → Check → Act)
- Flexible execution (stop/continue options)
- Smart assistance (auto-detection, prompts)
- Reduced errors (orchestration, validation)

---

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Commands too complex | High | Clear prompts, helpful messages, examples |
| QA skips documentation gathering | Medium | Automatic prompts, no skip without confirmation |
| Feature knowledge drift | Medium | Gap detection, prompted updates |
| Test case regeneration overwrites manual edits | High | Warn before overwrite, offer append option |
| Learning curve for new workflow | Medium | Comprehensive docs, quickstart guide, examples |

---

## Conclusion

This spec addresses all core issues with the current QA Agent OS workflow by:

1. **Aligning with real QA processes** - Commands match QA mental model
2. **Reducing complexity** - 5 commands instead of 8, with orchestration
3. **Increasing flexibility** - Multiple paths to achieve goals
4. **Maintaining quality** - Gap detection, traceability, comprehensive templates
5. **Improving efficiency** - Smart detection, automatic prompts, reusable strategies

**Status:** ✅ Ready for formal specification and implementation

**Next Command:** `/write-spec` to create detailed technical specification
