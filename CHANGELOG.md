# Changelog

Get notified of major releases by subscribing here:
https://medirect.com/qa-agent-os

## [0.7.0] - 2025-12-08

### QA Workflow Command Separation - Modular Command Architecture

This release separates monolithic workflow commands into discrete, reusable commands that distinguish user-driven tasks from AI-driven tasks, enabling flexible re-execution and better workflow control while maintaining smart detection and gap detection capabilities.

#### Breaking Changes

**Deprecated Commands Removed:**
- ❌ `/plan-feature` - Monolithic feature planning command (removed)
- ❌ `/plan-ticket` - Monolithic ticket planning command (removed)

**Migration Required:** All users must update their workflows to use the new 4-command structure.

#### New Commands

**1. `/start-feature` - Initialize Feature Structure Only**
- Creates: `qa-agent-os/features/[feature-name]/documentation/`
- No files created (structure only)
- Output: Success message with next steps
- Replaces: Phase 1 of old `/plan-feature`

**2. `/start-ticket` - Initialize Ticket Structure with Smart Feature Detection**
- Creates: `qa-agent-os/features/[feature-name]/[ticket-id]/documentation/`
- Smart Feature Detection: Auto-select single feature, prompt for multiple, error if none exist
- No files created (structure only)
- Output: Success message with next steps
- Replaces: Phases 0-1 of old `/plan-ticket`

**3. `/gather-docs` - Display Documentation Gathering Guidance (User-Driven)**
- Context Detection: Automatically detect feature or ticket context from directory path
- Feature Context: Displays guidance for: BRD, API specs, UI mockups, technical architecture, database schema, feature-specific docs
- Ticket Context: Displays guidance for: ticket description, acceptance criteria, API details, screen mockups, technical notes, test data examples
- No File Operations: Guidance only, user manually adds documentation files
- Support Re-execution: Can display guidance multiple times
- Replaces: Phase 2 of old `/plan-feature` and Phase 2 of old `/plan-ticket`

**4. `/analyze-requirements` - Analyze Gathered Documentation and Create Plans**
- Context Detection: Automatically detect feature or ticket context from directory path
- Feature Context: Analyzes documentation and creates:
  - `feature-knowledge.md` (8 sections: Overview, Business Rules, API Endpoints, Data Models, Edge Cases, Dependencies, Open Questions, References)
  - `feature-test-strategy.md` (10 sections: Testing Approach, Tools, Environment, Test Data Strategy, Risks, Entry/Exit Criteria, Dependencies, Schedule, Resources, References)
- Ticket Context: Analyzes documentation and creates:
  - `test-plan.md` (11 sections with requirement traceability and test scenarios)
  - Includes Gap Detection with explicit visibility requirement
- Smart Re-execution: Detects existing documents and prompts for re-analysis options
- Replaces: Phases 3-4 of old `/plan-feature` and Phase 3 of old `/plan-ticket`

#### Gap Detection Visibility Enhancement

**Critical Requirement - ALWAYS Display Explicit Results:**

When gaps are detected between ticket requirements and feature knowledge:

```
GAP DETECTION RESULTS:
I found [N] gaps between ticket requirements and feature knowledge:

1. [New business rule]: [description]
2. [New API endpoint]: [description]
3. [New edge case]: [description]
4. [New data model]: [description]

Would you like me to append these gaps to feature-knowledge.md?
  [1] Yes, append all gaps (with source tracking)
  [2] Let me review first (show detailed gap report)
  [3] No, skip gap updates
```

**Gap Appending:** Gaps are appended with metadata for traceability:
- Source: [ticket-id]
- Date: [timestamp in ISO 8601 format]

#### Workflow Comparison

**Old Workflow (Monolithic):**
```bash
/plan-feature "User Authentication"
  # [All phases in one command: structure, gather, analyze, create strategy]
  # [Creates feature-knowledge.md and feature-test-strategy.md]

/plan-ticket "AUTH-123"
  # [All phases in one command: structure, gather, analyze, create plan]
  # [Creates test-plan.md and test-cases.md]
```

**New Workflow (Modular):**
```bash
# Feature Planning (3 commands)
/start-feature "User Authentication"
  # [Creates folder structure]

/gather-docs
  # [Display guidance - user adds documentation files]

/analyze-requirements
  # [Analyzes documentation, creates feature-knowledge.md and feature-test-strategy.md]

# Ticket Planning (3 commands)
/start-ticket "AUTH-123"
  # [Creates folder structure with smart feature detection]

/gather-docs
  # [Display guidance - user adds documentation files]

/analyze-requirements
  # [Analyzes documentation with gap detection, creates test-plan.md]
  # [Optionally generates test cases with /generate-testcases]
```

#### Architecture Benefits

✅ **Separation of Concerns:** Structure creation, gathering, and analysis as separate commands
✅ **Flexible Re-execution:** Users can update documentation and re-run analysis without recreating structure
✅ **User-Driven Gathering:** `/gather-docs` guidance-only approach reduces automation complexity
✅ **Explicit Gap Detection:** Users always see when gaps are detected and can make informed decisions
✅ **Better Context Detection:** All commands support smart directory detection with helpful fallback prompts
✅ **Cleaner Workflow:** Each command has a single, focused responsibility

#### Command Execution Flow

```
Feature Setup:
  /start-feature → /gather-docs → /analyze-requirements
                                    ↓
                          (Create feature knowledge & strategy)

Ticket Setup:
  /start-ticket → /gather-docs → /analyze-requirements
                                    ↓
                          (Gap Detection if applicable)
                          (Create test plan)
                          (Optional: /generate-testcases)
```

#### Documentation Updates

All user-facing documentation updated to reflect new workflow:
- ✅ README.md - Command reference and workflow overview
- ✅ QA-QUICKSTART.md - Complete workflow examples using new 4-command structure
- ✅ CLAUDE.md - Development guidance with new command descriptions
- ✅ Workflow examples showing context detection and gap detection visibility

#### Migration Guide

**From Old Workflow to New Workflow:**

| Task | Old Command | New Workflow |
|------|------------|--------------|
| Create feature structure | `/plan-feature` Phase 1 | `/start-feature` |
| Create ticket structure | `/plan-ticket` Phase 0-1 | `/start-ticket` |
| Display documentation guidance | Embedded in phases | `/gather-docs` |
| Analyze feature docs | `/plan-feature` Phases 3-4 | `/analyze-requirements` (feature context) |
| Analyze ticket docs | `/plan-ticket` Phase 3 | `/analyze-requirements` (ticket context) |
| Generate test cases | `/plan-ticket` Phase 4 / `/generate-testcases` | `/generate-testcases` (unchanged) |

**User Action:**
1. Update any scripts or workflows that use `/plan-feature` or `/plan-ticket`
2. Replace with new 4-command structure: `/start-feature`, `/gather-docs`, `/analyze-requirements`, `/generate-testcases`
3. Workflows remain the same; just split into more granular commands

#### Implementation Details

**Commands Created:**
- `profiles/default/commands/start-feature/single-agent/start-feature.md`
- `profiles/default/commands/start-ticket/single-agent/start-ticket.md`
- `profiles/default/commands/gather-docs/single-agent/gather-docs.md`
- `profiles/default/commands/analyze-requirements/single-agent/analyze-requirements.md`
  - With phase files: `feature-analysis.md` and `ticket-analysis.md`

**Commands Removed:**
- `profiles/default/commands/plan-feature/` (entire directory)
- `profiles/default/commands/plan-ticket/` (entire directory)

#### Technical Details

- Spec: `agent-os/specs/2025-12-02-workflow-command-separation/`
- Commands created: 4 new commands (with phase files)
- Commands removed: 2 monolithic commands
- Gap detection visibility: Enhanced with explicit messaging
- Context detection: Smart directory parsing with interactive fallback
- Re-execution: Smart file detection with numbered options

#### Testing

All 8 task groups implemented and verified:
- Task Group 1: `/start-feature` command ✅
- Task Group 2: `/start-ticket` command ✅
- Task Group 3: `/gather-docs` command ✅
- Task Group 4: `/analyze-requirements` feature context ✅
- Task Group 5: `/analyze-requirements` ticket context with gap detection ✅
- Task Group 6: Migration and cleanup (deprecated commands removed) ✅
- Task Group 7: Documentation updates ✅
- Task Group 8: End-to-end workflow testing ✅

---

## [0.6.0] - 2025-12-01

### Template Elimination - Standards as Single Source of Truth

This release eliminates template duplication by consolidating all templates into comprehensive standards, achieving significant token/context savings while improving maintainability.

#### Architecture Change

**Before:**
```
Commands → Phase Files → Templates → Standards (duplicated)
                    ↓
              Workflows (unused/incomplete)
```

**After:**
```
Commands → Phase Files → Workflows → Standards (single source of truth)
```

**Unified Architecture:**
- Single-Agent Mode: Commands → Phase Files → Workflows → Standards
- Multi-Agent Mode: Commands → Subagents → Workflows → Standards
- Both modes converge at Workflows → Standards (shared, no duplication)

#### Files Eliminated

**Templates Folder Deleted:**
- ❌ bug-report-template.md (214 lines)
- ❌ test-plan-template.md (253 lines)
- ❌ test-cases-template.md (323 lines)
- ❌ feature-knowledge-template.md (129 lines)
- ❌ feature-test-strategy-template.md (191 lines)
- **Total:** ~1,110 lines eliminated

**Duplicate Standards Deleted:**
- ❌ standards/bugs/bug-template.md (130 lines)
- ❌ standards/bugs/severity-rules.md (189 lines)
- ❌ standards/bugs/bug-reporting-standard.md (55 lines)
- ❌ standards/bugs/bug-analysis.md (44 lines)
- ❌ standards/testcases/test-case-standard.md (64 lines)
- ❌ standards/testcases/test-case-structure.md (38 lines)
- **Total:** ~520 lines eliminated

**Grand Total Eliminated:** ~1,630 lines of duplicate content

#### Unified Standards Created

**Bug Reporting Standard:**
- File: `standards/bugs/bug-reporting.md` (255 lines)
- Consolidates: 6 files (657 lines) → 61% reduction
- Contains: Structure + severity rules + analysis + workflow + examples

**Test Plan Standard:**
- File: `standards/testcases/test-plan.md` (254 lines)
- Replaces: test-plan-template.md + scattered standards
- Contains: Structure + field definitions + best practices + gap detection

**Test Cases Standard:**
- File: `standards/testcases/test-cases.md` (445 lines)
- Consolidates: 3 files (425 lines)
- Contains: Structure + guidelines + types + automation + best practices

**Feature Standards:**
- Folder: `standards/features/`
- Files: feature-knowledge.md (129 lines), feature-test-strategy.md (191 lines)
- Moved from templates/ to standards/

#### Workflows Completed

**Bug Reporting Workflow:**
- File: `workflows/bug-tracking/bug-reporting.md`
- Status: Replaced incomplete stub with comprehensive 6-step workflow
- References: bug-reporting.md standard as single source of truth

**Updated Workflows:**
- requirement-analysis.md → References test-plan.md standard
- testcase-generation.md → References test-cases.md standard

#### Command Phase Files Updated

**Reduced Inline Duplication:**
- `/report-bug` Phase 4: 390 lines → ~40 lines (90% reduction)
- `/plan-ticket` Phase 3: Updated to reference workflows
- `/generate-testcases` Phase 3: Updated to reference workflows

#### Benefits

✅ **Token Efficiency:** ~1,630 lines eliminated (~40-50% reduction in QA documentation)
✅ **Single Source of Truth:** No duplication between templates and standards
✅ **Single Maintenance Point:** Add field once in standard, done
✅ **Clearer Architecture:** Commands → Workflows → Standards (simple flow)
✅ **No Information Loss:** All content preserved in unified standards
✅ **Workflow Integration:** Workflows now complete and integrated into command flow

#### Migration

No migration required. Changes apply to new documents generated after this release. Existing generated documents remain unchanged.

#### Breaking Changes

**For Custom Commands:**
- If you reference `@qa-agent-os/templates/*`, update to `@qa-agent-os/standards/*`
- Template paths no longer valid

**For Custom Workflows:**
- Update template references to standard references
- Example: `templates/bug-report-template.md` → `standards/bugs/bug-reporting.md`

#### Technical Details

- Spec: `agent-os/specs/2025-12-01-eliminate-template-duplication/`
- Files created: 5 unified standards
- Files deleted: 12 templates + 6 duplicate standards
- Workflows completed: 3
- Command phase files updated: 3

---

## [0.5.0] - 2025-12-01

### Streamlined Ticket Planning Outputs - File Noise Reduction

This release significantly reduces file clutter in ticket planning by eliminating redundant summary files while preserving all valuable information in enhanced core documents.

#### Changes

**Files Eliminated (Per Ticket):**
- ❌ **README.md** - Removed (duplicated test-plan.md content)
- ❌ **TEST_PLAN_SUMMARY.md** - Prevented (Claude-generated summary, now in test-plan.md)
- ❌ **TESTCASE_GENERATION_SUMMARY.md** - Prevented (Claude-generated summary, now in test-cases.md)
- ❌ **COLLECTION_LOG.md** - Removed (temporary process tracking, info moved to test-plan.md Section 1)

**Result:** File count reduced from **7-8 files** to **2-4 files** per ticket (test-plan.md, test-cases.md, documentation/, optional bugs/)

#### Enhanced Templates

**test-plan-template.md Enhancements:**
- Added Executive Summary to Section 2 (Ticket Overview)
- Added Coverage Summary stats to Section 5 (Test Coverage Matrix)
- Enhanced Section 9 (Execution Timeline) with status tracking and owner columns
- Added status icons: ✅ Complete, 🔄 In Progress, ⏳ Not Started, ⚠️ Blocked
- **NEW Section 12: Gap Detection Log** - Tracks gap analysis, feature knowledge updates, and traceability
- Updated from 11 sections to 12 sections
