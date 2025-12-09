# Requirements: Streamline Ticket Planning Outputs

**Spec:** streamline-ticket-planning-outputs
**Date:** 2025-12-01
**Status:** Requirements Gathering Complete

---

## Problem Statement

The current `/plan-ticket` and `/generate-testcases` commands create **7-8 files per ticket**, resulting in excessive noise and redundant information:

### Current File Structure (Per Ticket)

```
qa-agent-os/features/[feature]/[ticket-id]/
├── bugs/                              ✅ KEEP - Bug reports
├── documentation/                     ✅ KEEP - Raw source documents
│   ├── COLLECTION_LOG.md             ❌ REMOVE - Process tracking, not needed long-term
│   ├── jira-ticket.pdf               ✅ KEEP
│   ├── test-design.md                ✅ KEEP
│   └── visuals/                      ✅ KEEP
├── README.md                          ❌ REMOVE - Duplicates test-plan.md sections
├── TEST_PLAN_SUMMARY.md              ❌ REMOVE - Duplicates test-plan.md content
├── TESTCASE_GENERATION_SUMMARY.md    ❌ REMOVE - Duplicates test-cases.md content
├── test-plan.md                       ✅ KEEP - Single source of truth
└── test-cases.md                      ✅ KEEP - Executable test cases
```

### Desired File Structure (Per Ticket)

```
qa-agent-os/features/[feature]/[ticket-id]/
├── bugs/                              ✅ Bug reports (if bugs found)
├── documentation/                     ✅ Raw source documents only
│   ├── jira-ticket.pdf
│   ├── test-design.md
│   └── visuals/
├── test-plan.md                       ✅ Single source of truth (enhanced)
└── test-cases.md                      ✅ Executable test cases (enhanced)
```

**Goal:** Reduce from **7-8 files** to **2-4 files** (test-plan.md, test-cases.md, documentation/, optional bugs/)

---

## Investigation Findings

### Where Are Summary Files Created?

**Analysis of QA Agent OS codebase:**

1. ✅ **test-plan.md** - Created by workflow: `workflows/testing/requirement-analysis.md`
2. ✅ **test-cases.md** - Created by workflow: `workflows/testing/testcase-generation.md`
3. ✅ **README.md** - Created by phase: `commands/plan-ticket/single-agent/1-initialize-ticket.md`
4. ✅ **COLLECTION_LOG.md** - Created by phase: `commands/plan-ticket/single-agent/2-gather-ticket-docs.md`
5. ❓ **TEST_PLAN_SUMMARY.md** - NOT found in workflow files
6. ❓ **TESTCASE_GENERATION_SUMMARY.md** - NOT found in workflow files

**Root Cause:**

TEST_PLAN_SUMMARY.md and TESTCASE_GENERATION_SUMMARY.md are **NOT explicitly instructed** by any workflow file. These are being created by **Claude proactively during command execution** as "completion reports" to communicate what was accomplished.

This is Claude's helpful behavior (communicating results), but it's creating unwanted file artifacts.

---

## User Decisions

Based on user clarifications:

| Question | Decision |
|----------|----------|
| How to consolidate summary info? | **Enhance test-plan.md** with new sections for gap detection, coverage metrics, status tracking |
| COLLECTION_LOG.md lifecycle? | **Delete** - Not needed after test-plan.md is created |
| Migration for existing tickets? | **No migration** - Only apply changes to new tickets going forward |
| Where to preserve metadata? | **test-plan.md** - Add version tracking, generation log, gap detection sections |

---

## Redundant Content Analysis

### README.md Content → Where to Move

**Current README.md contains:**
- Ticket overview (Summary, type, priority, dates)
- Structure documentation (folder tree)
- Feature context links
- Planning status checkboxes
- Key requirements excerpt
- Documentation inventory
- Testing artifacts status
- Next steps
- Related tickets
- Test coverage summary

**Consolidation Strategy:**
- ✅ Ticket overview → Already in test-plan.md Section 2 (Ticket Overview)
- ✅ Feature context → Already in test-plan.md Section 1 (References)
- ✅ Planning status → Enhance test-plan.md Section 9 (Execution Timeline) with status column
- ✅ Requirements → Already in test-plan.md Section 4 (Testable Requirements)
- ✅ Coverage summary → Already in test-plan.md Section 5 (Test Coverage Matrix)
- ❌ Structure documentation → Not needed (users know folder structure)
- ❌ Next steps → Not needed (already in test-plan.md Section 10: Entry/Exit Criteria)

**Result:** README.md is **100% redundant** - Delete entirely

---

### TEST_PLAN_SUMMARY.md Content → Where to Move

**Current TEST_PLAN_SUMMARY.md contains:**
- Executive summary
- Gap detection results and recommendations
- Test coverage summary (requirements count, test case breakdown)
- Risk identification and mitigation strategies
- Entry/exit criteria status
- Key milestones and timelines
- Readiness assessment
- Documentation quality assessment
- Next steps

**Consolidation Strategy:**
- ✅ Gap detection → **NEW Section 12** in test-plan.md: "Gap Detection Log"
- ✅ Test coverage summary → Enhance test-plan.md Section 5 (Test Coverage Matrix) with summary stats
- ✅ Risk identification → Already in test-plan.md (embedded in requirements and test scenarios)
- ✅ Entry/exit criteria status → Enhance test-plan.md Section 10 with status checkboxes
- ✅ Readiness assessment → Enhance test-plan.md Section 9 with status tracking
- ✅ Executive summary → Add to test-plan.md header after version info
- ❌ Documentation quality assessment → Not needed (internal process metric)
- ❌ Next steps → Already in test-plan.md

**Result:** TEST_PLAN_SUMMARY.md content **mostly redundant**, unique info moved to enhanced test-plan.md

---

### TESTCASE_GENERATION_SUMMARY.md Content → Where to Move

**Current TESTCASE_GENERATION_SUMMARY.md contains:**
- Test case generation summary (total, functional, edge, negative counts)
- Priority distribution (Critical 18%, High 36%, Medium 36%, Low 10%)
- Automation status (64% automated, 36% manual with technologies)
- Key changes implemented (e.g., "All timeframe implementation" with 3 new test cases)
- Requirements coverage (100% with detailed breakdown)
- Test data coverage (which data sets used in which tests)
- Test execution timeline (5-day schedule)
- Automation implementation plan (3 phases over 3 weeks)
- Critical testing areas identification
- Test case IDs & requirements mapping table
- Coverage verification checklist
- New test cases added log
- Quality metrics
- Known dependencies
- Risk assessment
- Sign-off requirements

**Consolidation Strategy:**
- ✅ Generation summary → **NEW Section** in test-cases.md: "Test Cases Overview" (at top)
- ✅ Priority/automation distribution → Add to test-cases.md overview section
- ✅ Key changes implemented → **NEW Section** in test-cases.md: "Generation History" with version tracking
- ✅ Requirements coverage → Add to test-cases.md "Coverage Analysis" section
- ✅ Test data coverage → Already in test-cases.md (enhance if needed)
- ✅ Execution timeline → Add to test-cases.md "Recommended Execution Schedule" section
- ✅ Automation plan → Already in test-cases.md "Automation Recommendations" (expand)
- ✅ Critical testing areas → Add to test-cases.md overview section
- ✅ Test case IDs mapping → Already in test-cases.md coverage section
- ❌ Coverage verification checklist → Internal process metric, not needed
- ✅ New test cases log → Add to test-cases.md generation history section
- ❌ Quality metrics → Internal process metric, not needed
- ❌ Known dependencies → Already in test-plan.md Section 8 (Environment Setup)
- ❌ Risk assessment → Already in test-plan.md
- ❌ Sign-off requirements → Already in test-plan.md Section 10 (Exit Criteria)

**Result:** TESTCASE_GENERATION_SUMMARY.md content **mostly redundant**, unique info moved to enhanced test-cases.md

---

### COLLECTION_LOG.md Content → Decision

**Current COLLECTION_LOG.md contains:**
- Documentation collection timestamp
- List of documents collected
- Document sources (file paths or pasted content)
- Collection metadata

**Decision:** **DELETE entirely** - This is process tracking that's not needed after test-plan.md is created. The list of collected documents is already in test-plan.md Section 1 (References).

---

## Enhanced Template Structure

### Enhanced test-plan.md Structure

**Current Sections (11):**
1. References
2. Ticket Overview
3. Test Scope
4. Testable Requirements
5. Test Coverage Matrix
6. Test Scenarios & Cases
7. Test Data Requirements
8. Environment Setup
9. Execution Timeline
10. Entry & Exit Criteria
11. Revisions

**Proposed Enhancements:**

#### Section 2: Ticket Overview - Add Executive Summary
```markdown
## 2. Ticket Overview

**Executive Summary:**
Brief 2-3 sentence summary of test plan status, coverage achieved, and readiness.

**Summary:**
[Existing content]
```

#### Section 5: Test Coverage Matrix - Add Summary Stats
```markdown
## 5. Test Coverage Matrix

**Coverage Summary:**
- Total requirements: 22
- Requirements with test cases: 22 (100%)
- Total test cases: 28
  - Functional: 17 (61%)
  - Edge cases: 8 (28%)
  - Negative: 3 (11%)
- Automation potential: 26/28 (93%)

[Existing coverage matrix table]
```

#### Section 9: Execution Timeline - Add Status Tracking
```markdown
## 9. Execution Timeline

| Phase | Start Date | End Date | Status | Owner |
|---|---|---|---|---|
| **Test Plan Review** | 2025-11-25 | 2025-11-26 | ✅ Complete | QA Lead |
| **Test Environment Setup** | 2025-11-27 | 2025-11-28 | 🔄 In Progress | DevOps |
| **Test Execution** | 2025-11-29 | 2025-12-03 | ⏳ Not Started | QA Engineers |
```

#### Section 10: Entry & Exit Criteria - Add Status Checkboxes
```markdown
## 10. Entry & Exit Criteria

### Entry Criteria (When testing can start)

**Code Readiness:**
- [x] Feature code complete and deployed to staging
- [x] Unit tests passing
- [ ] Code review completed and approved

**Environment Readiness:**
- [ ] Staging environment accessible
- [ ] Test accounts created
- [ ] API mocks configured
```

#### NEW Section 12: Gap Detection Log
```markdown
## 12. Gap Detection Log

**Gap Analysis Date:** 2025-11-25 16:30

**Gaps Found:** None

**Feature Knowledge Status:** No updates required

**Analysis:**
Ticket DW-6194 requirements were compared against feature-knowledge.md. No new business rules, APIs, or edge cases requiring addition to feature knowledge were found. All ticket-specific details are captured in this test plan.

---

### Previous Gap Detections

*(If gaps were found and feature-knowledge.md was updated, log them here)*

**Date:** [Date]
**Gaps Appended to Feature Knowledge:**
- New Business Rule: [Description]
- New API Endpoint: POST /api/[endpoint]
- New Edge Case: [Description]

**Traceability:** Updated in feature-knowledge.md Section [N]
```

---

### Enhanced test-cases.md Structure

**Current Sections:**
- Header (metadata)
- Test Execution Summary (table)
- Detailed Test Cases
- Coverage Analysis
- Automation Recommendations

**Proposed Enhancements:**

#### NEW Section: Test Cases Overview (at top, before execution summary)
```markdown
# Test Cases: DW-6194 - QA TWRR Chart

**Generated:** 2025-11-25
**Version:** 1.0
**Source:** test-plan.md (v1.1)
**Feature:** Time-Weighted Rate of Return (TWRR) Chart

---

## Test Cases Overview

**Total Test Cases:** 28

**By Type:**
- Functional Tests: 17 (61%)
- Edge Case Tests: 8 (28%)
- Negative Tests: 3 (11%)

**By Priority:**
- Critical: 5 (18%)
- High: 10 (36%)
- Medium: 10 (36%)
- Low: 3 (10%)

**By Automation Status:**
- Automated: 18 (64%) - Playwright, WireMock, Python Scripts
- Manual: 10 (36%) - Visual validation, Date-dependent

**Coverage:**
- Requirements covered: 22/22 (100%)
- Positive test coverage: 20/22 (91%)
- Edge case coverage: 18/22 (82%)
- Negative test coverage: 3/3 (100%)

**Critical Testing Areas:**
1. 1-year granularity transition (TC-207)
2. "All" timeframe completeness (TC-208)
3. Data accuracy validation with 516 data points (TC-017)
4. Cash flow calculation impact (TC-014)

---
```

#### NEW Section: Generation History (after Automation Recommendations)
```markdown
## Generation History

### Version 1.0 - 2025-11-25

**Initial Generation**

**Changes:**
- Generated 28 test cases from test-plan.md v1.1
- Test cases created: TC-001 to TC-303 (excluding TC-009)

**Key Features Implemented:**
- "All" timeframe tests (TC-207, TC-208, TC-209)
- Conditional data granularity testing
- 1-year boundary transition validation
- Complete removal of navigation arrows tests

**Source:** test-plan.md Sections 4-7 (Requirements, Coverage, Scenarios, Test Data)

---

### Version 1.1 - [Future Date]

*(Example of regeneration tracking)*

**Regeneration After Test Plan Update**

**Changes:**
- Added 5 new test cases for [new feature]
- Updated TC-015 with additional validation steps
- Removed deprecated TC-XXX

**Reason:** Test plan updated to v1.2 with new requirements

**Source:** test-plan.md v1.2

---
```

#### Enhanced Section: Recommended Execution Schedule
```markdown
## Recommended Execution Schedule

**Total Estimated Duration:** 20 hours (5 days)

**Day 1: High-Priority Functional Tests (4 hours)**
- TC-001, TC-002, TC-005, TC-006
- TC-010, TC-011, TC-012
- TC-208 (New "All" timeframe)
- Priority: Critical for basic functionality

**Day 2: Medium-Priority Functional Tests (6 hours)**
- TC-003, TC-004, TC-007, TC-008
- TC-013, TC-014, TC-015, TC-016, TC-017
- Priority: Data validation critical

**Day 3: Edge Cases (5 hours)**
- TC-201, TC-202, TC-203, TC-204, TC-205, TC-206
- TC-207 (1-year granularity boundary)
- TC-209 (New portfolios with "All")
- Priority: Boundary condition testing

**Day 4: Negative & Error Handling (2 hours)**
- TC-301, TC-302, TC-303
- Priority: Robustness testing

**Day 5: Regression & Sign-Off (3 hours)**
- Retest any failed tests
- Cross-browser validation
- Final sign-off
```

---

## Implementation Strategy

### Files to Modify

#### 1. Remove README.md Generation
**File:** `profiles/default/commands/plan-ticket/single-agent/1-initialize-ticket.md`

**Change:** Remove instructions to create README.md

**Before:**
```markdown
Create README.md with ticket overview, structure, status...
```

**After:**
```markdown
*(Remove README.md creation entirely)*
```

---

#### 2. Remove COLLECTION_LOG.md Generation
**File:** `profiles/default/commands/plan-ticket/single-agent/2-gather-ticket-docs.md`

**Change:** Remove instructions to create COLLECTION_LOG.md

**Alternative:** If process tracking is valuable, make it temporary:
- Create COLLECTION_LOG.md in Phase 2
- Delete it automatically in Phase 3 after test-plan.md is created

---

#### 3. Prevent Claude from Creating Summary Files

**Challenge:** TEST_PLAN_SUMMARY.md and TESTCASE_GENERATION_SUMMARY.md are created by Claude proactively, not by explicit workflow instructions.

**Solution Options:**

**Option A: Add Explicit Instructions to Workflows**
- Add to `workflows/testing/requirement-analysis.md` and `workflows/testing/testcase-generation.md`:

```markdown
## IMPORTANT: Output Format

**DO NOT create separate summary files** like TEST_PLAN_SUMMARY.md or TESTCASE_GENERATION_SUMMARY.md.

Instead:
1. Create test-plan.md with all necessary information
2. Provide a concise completion message to the user
3. Do not write summary information to additional files

**Completion Message Format:**
```
Test plan created successfully!

Location: qa-agent-os/features/[feature]/[ticket-id]/test-plan.md
Version: 1.0
Sections: 12 (including Gap Detection Log)

Coverage Summary:
- Total requirements: 22
- Total test cases: 28
- Automation potential: 93%

Gap Detection: No feature-level gaps found

NEXT STEPS:
[1] Continue to Phase 4: Generate test cases now
[2] Stop here (review test plan first, generate test cases later)
```
```

**Option B: Add Negative Instructions to Phase Files**
- Add to Phase 3 completion instructions:

```markdown
### Post-Workflow Actions

After workflow completes, provide the user with a summary message.

**IMPORTANT:**
- DO NOT create README.md
- DO NOT create TEST_PLAN_SUMMARY.md
- DO NOT create any additional summary files
- All summary information is already in test-plan.md

Prompt user:
```
Test plan created successfully!
[completion message]
```
```

---

#### 4. Enhance test-plan-template.md
**File:** `profiles/default/templates/test-plan-template.md`

**Changes:**
- Add Executive Summary to Section 2 header
- Add Coverage Summary stats to Section 5 header
- Add Status column to Section 9 (Execution Timeline)
- Add status checkboxes to Section 10 (Entry/Exit Criteria)
- Add NEW Section 12: Gap Detection Log

---

#### 5. Enhance test-cases-template.md
**File:** `profiles/default/templates/test-cases-template.md`

**Changes:**
- Add Test Cases Overview section at top
- Add Generation History section after Automation Recommendations
- Enhance Recommended Execution Schedule section

---

#### 6. Update Workflow Instructions
**File:** `profiles/default/workflows/testing/requirement-analysis.md`

**Changes:**
- Add Section 12 (Gap Detection Log) to test plan creation instructions
- Add explicit instruction to NOT create TEST_PLAN_SUMMARY.md
- Update completion message format

**File:** `profiles/default/workflows/testing/testcase-generation.md`

**Changes:**
- Add Test Cases Overview section to test-cases.md creation instructions
- Add Generation History section
- Add explicit instruction to NOT create TESTCASE_GENERATION_SUMMARY.md
- Update completion message format

---

## Success Criteria

### User Experience Goals

✅ **File Reduction:** 7-8 files → 2-4 files per ticket
✅ **No Information Loss:** All valuable summary info preserved in enhanced templates
✅ **Clear Single Source of Truth:** test-plan.md and test-cases.md contain everything
✅ **Better Organization:** Gap detection, coverage stats, and status tracking integrated into core documents
✅ **No Migration Needed:** Changes apply only to new tickets going forward
✅ **Process Improvement:** Claude understands to NOT create extra summary files

### Technical Goals

✅ **Template Enhancements:** test-plan-template.md and test-cases-template.md updated with new sections
✅ **Workflow Updates:** requirement-analysis.md and testcase-generation.md include explicit anti-summary instructions
✅ **Phase File Updates:** 1-initialize-ticket.md and 2-gather-ticket-docs.md remove README.md and COLLECTION_LOG.md creation
✅ **Backward Compatibility:** Existing tickets with old structure remain unchanged

---

## Out of Scope

❌ **Migration utility** for existing tickets
❌ **Changes to feature-level planning** commands (/plan-feature, /plan-product)
❌ **Bug reporting workflow** (/report-bug, /revise-bug)
❌ **Test plan revision workflow** (/revise-test-plan) - Will naturally benefit from enhanced templates

---

## Next Steps

1. ✅ Requirements documented (this file)
2. ⏳ Design implementation approach
3. ⏳ Update templates (test-plan-template.md, test-cases-template.md)
4. ⏳ Update workflows (requirement-analysis.md, testcase-generation.md)
5. ⏳ Update phase files (1-initialize-ticket.md, 2-gather-ticket-docs.md)
6. ⏳ Test with new ticket to verify no summary files created
7. ⏳ Document changes in CHANGELOG.md
8. ⏳ Update QA-QUICKSTART.md and README.md with new file structure

---

**Requirements Status:** ✅ Complete
**Ready for:** Implementation Design
