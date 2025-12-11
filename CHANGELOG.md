# Changelog

Get notified of major releases by subscribing here:
https://medirect.com/qa-agent-os

## [0.8.0] - 2025-12-10

### Feature-Level Bug Organization - Auto-Incremented Bug IDs and Organized Evidence

This release reorganizes bug management from ticket-level to feature-level with stable auto-incremented bug IDs, organized supporting materials, and enhanced /report-bug and /revise-bug commands.

#### Key Features

**Feature-Level Bug Storage:**
- Bugs now organized at feature level instead of ticket level
- Directory structure: `qa-agent-os/features/[feature-name]/bugs/BUG-XXX-[title]/`
- Auto-incremented bug IDs per feature (BUG-001, BUG-002, etc.)
- Stable folder names for consistent cross-referencing

**Organized Supporting Materials:**
- Evidence organized into semantic subfolders: `screenshots/`, `logs/`, `videos/`, `artifacts/`
- Automatic evidence categorization during bug creation
- Clear separation of concerns for multiple types of evidence

**Updated Commands:**

1. **`/report-bug` - Enhanced for Feature-Level Bugs**
   - Auto-detects feature context from working directory
   - Auto-generates sequential bug IDs per feature
   - Collects bug details: title, description, environment, severity
   - Organizes evidence by type into subfolders
   - Generates comprehensive `bug-report.md` with attachments section
   - Supports optional Ticket field for cross-referencing related tickets
   - Optional Jira ID field for tracking in external systems

2. **`/revise-bug` - New Command for Updating Bugs**
   - Discovers all bugs in feature
   - Interactive selection menu with bug summaries
   - Seven revision types: add/update evidence, change severity, change status, add/update notes, update ticket reference, update Jira ID
   - Maintains full revision log with version tracking
   - Metadata tracking for traceability (date, change type, description)
   - Supports evidence organization for newly added materials

**Integration with Existing Workflow:**
- Feature-level bugs complement ticket-level testing
- Bugs can reference multiple tickets via Ticket field
- Bidirectional traceability: bugs to tickets and back
- No disruption to existing ticket-level test plans and test cases
- Works seamlessly with /start-feature and /plan-ticket commands

**Bug Report Template (bug-report.md):**
```markdown
# Bug Report: BUG-XXX - [Title]

## Status
- Current: [OPEN|IN_REVIEW|VERIFIED|RESOLVED|CLOSED]
- Last Updated: [date]

## Bug Details
- ID: BUG-XXX
- Title: [Title]
- Severity: [CRITICAL|HIGH|MEDIUM|LOW]
- Description: [Full description of the bug]
- Environment: [Where bug occurred]
- Ticket: [Optional ticket reference, can be comma-separated for multiple tickets]
- Jira_ID: [Optional Jira ticket ID]

## Evidence
[Organized supporting materials with semantic subfolders]

## Revision Log
[Version history with change tracking]
```

#### Architecture

**Folder Structure Example:**
```
features/payment-gateway/
├── bugs/
│   ├── BUG-001-checkout-submit-fails/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   │   ├── error-screen.png
│   │   │   └── form-state.png
│   │   ├── logs/
│   │   │   └── transaction.log
│   │   ├── videos/
│   │   └── artifacts/
│   │       └── network-trace.har
│   └── BUG-002-currency-calculation-error/
│       ├── bug-report.md
│       ├── screenshots/
│       └── logs/
├── feature-knowledge.md
├── feature-test-strategy.md
└── [TICKET-001]/
    ├── test-plan.md
    └── test-cases.md
```

#### Breaking Changes

**No Breaking Changes:** This release is forward-looking. Existing ticket-level bugs and test plans remain fully functional. New bug organization is optional and recommended for projects starting new features or reorganizing existing structures.

#### Implementation Details

**Commands Modified:**
- `profiles/default/commands/report-bug/` - Enhanced with feature-level context detection
- `profiles/default/commands/revise-bug/` - New command for bug revision management

**Bash Utilities Created:**
- `scripts/bug-id-utils.sh` - Auto-increment logic and ID validation
- `scripts/bug-folder-utils.sh` - Folder structure creation and management
- `scripts/bug-discovery.sh` - Bug discovery and selection
- `scripts/bug-revisions.sh` - Revision type handlers and log management
- `scripts/bug-report-generator.sh` - Report generation from workflow
- `scripts/context-detection.sh` - Feature/bug context detection

**Standards Updated:**
- `profiles/default/standards/bugs/bug-reporting.md` - Updated for feature-level organization
- `profiles/default/templates/bug-report.md` - New template for bug reports

**Documentation Created:**
- `/agent-os/specifications/bug-folder-structure-user-guide.md` - Comprehensive user guide

#### Testing

**Comprehensive Testing Completed:**
- Auto-increment logic validation with edge cases
- Folder structure creation and organization
- Context detection from various directories
- Feature-level bug independence (no cross-feature collisions)
- Ticket field cross-referencing (single and multiple tickets)
- Bidirectional traceability between bugs and tickets
- Evidence organization and attachment handling
- Revision log tracking and version management

#### Migration Guide

**For Existing Projects:**
1. Continue using ticket-level bugs if preferred
2. New projects recommended to use feature-level organization
3. Transition gradually: use feature-level bugs for new features, keep existing ticket-level bugs for established features
4. Run `/report-bug` from feature directory to use new auto-increment system

**For New Projects:**
1. Use `/start-feature` to create feature structure
2. Use `/report-bug` from feature directory to track bugs at feature level
3. Use `/revise-bug` to manage bug lifecycle
4. Reference tickets in Ticket field when bugs affect specific tickets

#### Benefits

✅ **Better Organization:** Feature-level bugs reduce duplication
✅ **Stable References:** Auto-incremented IDs enable consistent cross-referencing
✅ **Clear Evidence:** Organized materials with semantic subfolders
✅ **Full Traceability:** Revision logs track all changes with timestamps
✅ **Flexible Scope:** Single bugs can reference multiple tickets
✅ **Seamless Integration:** Works alongside existing ticket-level testing
✅ **Forward-Looking:** No migration required for existing structures

#### Related Specification

- Spec: `agent-os/specs/2025-12-08-bug-folder-structure/`
- Tasks: `agent-os/specs/2025-12-08-bug-folder-structure/tasks.md`
- User Guide: `/agent-os/specifications/bug-folder-structure-user-guide.md`

---

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

