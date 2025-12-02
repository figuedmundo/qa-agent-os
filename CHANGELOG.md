# Changelog

Get notified of major releases by subscribing here:
https://medirect.com/qa-agent-os

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

**test-cases-template.md Enhancements:**
- **NEW: Test Cases Overview section** - Includes type/priority/automation distribution, coverage stats, critical testing areas
- **NEW: Generation History section** - Version tracking for test case generations and regenerations
- **NEW: Recommended Execution Schedule** - Day-by-day execution plan with time estimates
- Enhanced Coverage Analysis section with requirements coverage table
- Enhanced Automation Recommendations with priority-based candidates

#### Workflow Updates

**requirement-analysis.md:**
- Added explicit instructions to NOT create README.md, TEST_PLAN_SUMMARY.md, or COLLECTION_LOG.md
- Enhanced completion message with gap detection summary and coverage stats
- Updated to create 12-section test plans (added Gap Detection Log)

**testcase-generation.md:**
- Added explicit instructions to NOT create TESTCASE_GENERATION_SUMMARY.md or other meta-files
- Enhanced completion message with priority distribution, automation status, and coverage stats
- All summary information now included in test-cases.md structure

**Phase Files:**
- Updated `2-gather-ticket-docs.md` - Removed COLLECTION_LOG.md generation
- Phase 1 unchanged (README.md was never explicitly created in phase files)

#### Benefits

✅ **Reduced File Noise:** 43-50% fewer files per ticket (7-8 → 2-4 files)
✅ **No Information Loss:** All summary data preserved in enhanced templates
✅ **Better Organization:** Gap detection, coverage stats, and status tracking integrated into core documents
✅ **Single Source of Truth:** test-plan.md and test-cases.md contain everything needed
✅ **Backward Compatible:** Existing tickets unchanged, improvements apply to new tickets only

#### Migration

No migration required. Changes apply only to new tickets created after this release. Existing tickets with old file structure remain unchanged.

#### Technical Details

- Spec: `agent-os/specs/2025-12-01-streamline-ticket-planning-outputs/`
- 6 files modified
- 2 templates enhanced
- 2 workflows updated
- 1 phase file updated

---

## [0.4.0] - 2025-11-24

### QA Workflow Phase 2 - Bug Reporting and Lifecycle Management

This release introduces comprehensive bug reporting and lifecycle management commands for QA Agent OS, completing Phase 2 of the QA Workflow redesign.

#### New Features

**Two New Commands:**
- `/report-bug` - Context-aware bug reporting with AI-assisted severity classification
  - Interactive and direct modes
  - Guided evidence collection checklist (6 evidence types)
  - Auto-detect feature and ticket context
  - AI severity classification with user override
  - Proper bug ID auto-increment

- `/revise-bug` - Bug revision and lifecycle management with version tracking
  - 6 update types (evidence, severity, status, reproduction notes, developer notes, affected scope)
  - Versioned revision log with timestamps
  - Context-aware bug discovery
  - Status workflow tracking (New → In Progress → Ready for QA → Verified/Closed → Re-opened)

**Single-Agent & Multi-Agent Support:**
- Both commands available in single-agent (CLI) and multi-agent (Claude Code) modes
- bug-writer agent enhanced for structured bug report generation and revision

**Standards & Templates:**
- New `bug-report-template.md` with complete bug structure
- Enhanced `severity-rules.md` with AI classification checklist
- Updated `bug-template.md` with revision log section

#### Architecture

- 5 phases for `/report-bug`: detect-context, collect-details, collect-evidence, classify-severity, generate-report
- 3 phases for `/revise-bug`: detect-bug, prompt-update-type, apply-update
- Multi-agent versions delegate to bug-writer agent
- Bug storage: `qa-agent-os/features/[feature]/[ticket]/bugs/BUG-XXX.md`

#### Testing & Verification

- Comprehensive testing checklist created for both commands
- Installation verified for single-agent and multi-agent modes
- All 32 tasks completed and verified
- Full specification and implementation documentation

## [0.3.0] - 2025-11-21

### Architecture Alignment - Major Architectural Update

This release fully aligns QA Agent OS with the original **Agent OS architecture patterns**, ensuring consistency, scalability, and maintainability.

#### Architectural Improvements

**Workflow-Centric Design:**
- All implementation logic extracted to reusable workflows
- Commands now orchestrate workflows instead of containing duplicate logic
- 10 total workflows (3 updated, 7 new) serving as single source of truth
- Zero logic duplication across the system

**Multi-Agent Support:**
- Both single-agent (CLI-friendly) and multi-agent (Claude Code) modes fully functional
- All 5 refactored commands have both variants (10 total command variants)
- Seamless switching between modes via config.yml
- Multi-agent variants delegate to 3 specialized agents

**Agent Integration:**
- `testcase-writer` agent - Generates test cases via testcase-generation workflow
- `requirement-analyst` agent - 5 workflow references for comprehensive requirement handling
- `feature-initializer` agent - 4 workflow references for structure creation

**Workflow Creation:**
- `gather-feature-docs.md` - Collect feature documentation
- `consolidate-feature-knowledge.md` - Create feature knowledge consolidation
- `create-test-strategy.md` - Develop testing strategy
- `update-feature-knowledge.md` - Update feature knowledge (manual)
- `initialize-ticket.md` - Create ticket structure (Phase 1 of /plan-ticket)
- `gather-ticket-docs.md` - Collect ticket documentation (Phase 2 of /plan-ticket)
- `revise-test-plan.md` - Update test plan with revision tracking (Phase 3 of /revise-test-plan)

**Deprecations:**
- `create-ticket.md` workflow marked as deprecated (will be removed in v0.4.0)
  - Functionality now provided by `/plan-ticket` command orchestration
  - Kept as historical reference for developers
  - Updated with modern output paths and deprecation notice

**Critical Bug Fixes:**
- Fixed missing PHASE tags in 3 command orchestrators (generate-testcases, revise-test-plan, update-feature-knowledge)
- Added proper orchestration phase files for user interaction logic
- Corrected workflow references to use `{{workflows/...}}` format
- Updated tasks.md to document all fixes

#### Token Efficiency
- Agents receive focused context without unnecessary duplication
- Consistent standards injection across all commands and agents
- Workflow references enable reuse without repeating logic

#### Validation & Testing
- All 5 commands tested in single-agent mode (31/31 tests passing)
- All 5 commands tested in multi-agent mode (31/31 tests passing)
- 20/20 pattern compliance checks passing
- Cross-command consistency verified
- Zero critical issues blocking release

#### Migration Notes

**For existing projects:**
- No action required - all changes are backward compatible
- Optional: Update references to use `/plan-ticket` instead of legacy workflows
- New installations automatically get both single-agent and multi-agent variants

**For developers:**
- New commands can be added by creating workflows and orchestrators
- Use existing commands as patterns for consistency
- Refer to architecture-patterns.md for implementation guidelines

#### Documentation Updates
- Added Architecture Alignment section to README.md
- Updated example directory structure to show workflow organization
- Added deprecation notices to legacy workflows
- Created WORKFLOW-REVIEW.md documenting architecture alignment

---

## [0.2.0] - 2025-11-20

### QA Workflow Redesign - Major Feature Release

This release introduces a comprehensive redesign of the QA workflow with 5 new orchestrated commands that streamline feature and ticket planning for QA teams.

#### Major Features

**5 New Orchestrated Commands:**
- `/plan-feature` - Complete feature planning in 4 phases (structure, docs, knowledge, strategy)
- `/plan-ticket` - Smart ticket planning with 5 phases including gap detection and flexible test case generation
- `/generate-testcases` - Standalone test case generation with overwrite/append modes
- `/revise-test-plan` - Update test plans during testing with revision tracking
- `/update-feature-knowledge` - Manual updates to feature knowledge (rare, usually automatic)

**Intelligent Features:**
- **Smart Feature Detection:** `/plan-ticket` auto-detects existing features or creates new ones
- **Gap Detection:** Automatically identifies new requirements not in feature knowledge and prompts for updates
- **Flexible Execution:** Stop after test plan review, regenerate test cases later with `/generate-testcases`
- **Re-execution Routing:** Existing tickets offer 4 options: full re-plan, update plan only, regenerate cases only, or cancel
- **Revision Tracking:** Test plan updates tracked with version numbers and timestamps

**Document Templates:**
- `feature-knowledge-template.md` - 8-section consolidation of feature requirements
- `feature-test-strategy-template.md` - 10-section strategic testing approach
- `test-plan-template.md` - 11-section ticket-specific test planning
- `test-cases-template.md` - Detailed executable test case structure
- `collection-log-template.md` - Documentation gathering metadata
- Folder structure templates for features and tickets

**Documentation:**
- `QA-QUICKSTART.md` - New quickstart guide with typical workflows and command examples
- Updated `CLAUDE.md` with comprehensive QA workflow documentation
- Updated `README.md` with command references and decision trees

#### Workflow Improvements

**Command Efficiency:**
- Reduced from 8 commands to 5 orchestrated commands
- Single `/plan-ticket` replaces 4 separate manual commands
- Estimated 60% time reduction for ticket planning

**Knowledge Management:**
- Feature knowledge stays current via automatic gap detection
- 100% traceability from requirements to test cases
- Metadata-rich revision logs for audit trails

**QA Process Alignment:**
- Follows Plan-Do-Check-Act methodology
- Clear feature-level (WHAT) vs ticket-level (HOW) separation
- Comprehensive test coverage (positive, negative, edge, dependency failure cases)

#### Technical Changes

**Installation Updates:**
- Fixed `install_templates()` function in `project-install.sh` - moved before main execution
- Templates now properly installed to `qa-agent-os/templates/` directory
- All 5 new commands automatically compiled during installation

**Command Structure:**
- Phase tags updated to new format: `{{PHASE N: @qa-agent-os/commands/...}}`
- Supports multi-phase orchestration with clear dependencies
- Smart detection phase (Phase 0) for context-aware routing

#### Breaking Changes

- None - all changes are additive
- Existing commands continue to work as before
- Old workflow commands remain available for backward compatibility

#### Deprecations

- Old command workflow structure remains supported but new features use updated patterns
- Consider migrating future features to use new /plan-feature and /plan-ticket commands

#### Testing

All new features have been:
- End-to-end tested with sample features and tickets
- Validated for installation and compilation
- Checked for edge cases and error handling
- Documented with examples and troubleshooting

#### Migration Guide

**For existing projects:**
1. Update installation with latest qa-agent-os
2. Run `project-install.sh --claude-code-commands true` to get new commands
3. Read `QA-QUICKSTART.md` for new workflow examples
4. Optionally migrate existing features to use new structure

**For new projects:**
1. Use `/plan-feature` to initialize features
2. Use `/plan-ticket` for ticket planning
3. Use `/generate-testcases`, `/revise-test-plan` for iterative refinement

---

## [0.1.0] - 2025-11-19

- Reset QA Agent OS versioning to its own 0.x line to distinguish it from the legacy developer-focused agent-os tool.
- Updated `scripts/base-install.sh` messaging so the installer clearly references QA Agent OS, allows side-by-side installs with `~/agent-os`, and clarifies that only `~/qa-agent-os` is managed.
- Added README guidance explaining that QA Agent OS (~/qa-agent-os) and agent-os (~/agent-os) can be installed on the same machine for hybrid QA/dev workflows.

## [2.1.1] - 2025-10-29

- Replaced references to 'spec-researcher' (depreciated agent name) with 'spec-shaper'.
- Clarified --dry-run output to user to reassure we're in dry-run mode
- Tightened up template and istructions for writing spec.md, aiming to keep it shorter, easier to scan, and covering only the essentials.
- Tweaked create-task-list workflow for consistency.
- When planning product roadmap, removed instruction to limit it to 12 items.
- Clarified instructions in implement-tasks in regards to useage of Playwright and screenshots.

## [2.1.0] - 2025-10-21

Version 2.1 implemented a round of significant changes to how things work in Agent OS.  Here is a summary of what's new in version 2.1.0:

### TL;DR

Here's the brief overview. It's all detailed below and the [docs](https://buildermethods.com/qa-agent-os) have been updated to reflect all of this.

- Option to leverage Claude Code's new "Skills" feature for reading standards
- Option to enable or disable delegating to Claude Code subagents
- Replaced "single/multi-agent modes" with more flexible configuration options
- Retired the short-lived "roles" system. Too complex, and better handled with standard tooling (more below).
- Removed documentation & verification bloat
- Went from 4 to 6 more specific development phases (use 'em all or pick and choose!):
  1. plan-product -- (no change) Plan your product's mission & roadmap
  2. shape-spec -- For shaping and planning a feature before writing it up
  3. write-spec -- For writing your spec.md
  4. create-tasks -- For creating your tasks.md
  5. implement-tasks -- Simple single-agent implementation of tasks.md
  6. orchestrate-tasks -- For more advanced, fine-grain control and multi-agent orchestration of tasks.md.
- Simplified & improved project upgrade script

Let's unpack these updates in detail:

### Claude Code Skills support

2.1 adds official support for [Claude Code Skills](https://docs.claude.com/en/docs/claude-code/skills).

When the config option standards_as_claude_code_skills is true, this will convert all of your standards into Claude Code Skills and _not_ inject references to those Standards like Agent OS normally would.

2.1 also provides a Claude Code command, `improve-skills` which you **definitely should** run after installing Agent OS in your project with the skills option turned on.  This command is designed to improve and rewrite each of your Claude Code Skills descriptions to make them more useable and discoverable by Claude Code.

### Enable/Disable delegation to Claude Code subagents

2.1 introduces an config option to enable or disable delegating tasks to Claude Code subagents.  You can disable subagents by setting use_claude_code_subagents to false.

When set to false, and when using Claude Code, you can still run Agent OS commands in Claude Code, and instead of delegating most tasks to subagents, Claude Code's main agent will execute everything.

While you lose some context efficiency of using subagents, you can token efficiency and some speed gains without the use of subagents.

### Replaced "single-agent & multi-agent modes" with new config options

2.0.x had introduced the concepts of multi-agent and single-agent modes, where multi-agent mode was designed for using Claude Code with subagents.  This naming and configuration design proved suboptimal and inflexible, so 2.1.0 does away with the terms "single-agent mode" and "multi-agent mode".

Now we configure Agent OS using these boolean options in your base ~/qa-agent-os/config.yml:

claude_code_commands: true/false
use_claude_code_subagents: true/false
agent_os_commands: true/false

The benefits of this new configuration approach are:

- Now you can use Agent OS with Claude Code *with* or *without* delegating to subagents.  (subagents bring many benefits like context efficiency, but also come with some tradeoffs—higher token usage, less transparency, slower to finish tasks).

- Before, when you had *both* single-agent and multi-agent modes enabled, your project's agent-os/commands/ folder ended up with "multi-agent/" and "single-agent/" subfolders for each command, which is confusing and clumsy to use.  Now in 2.1.0, your project's agent-os/commands/ folder will not have these additional "modes" subfolders.

- Easier to integrate additional feature configurations as they become available, so that you can mix and match the exact set of features that fit your preferred coding tools and workflow style.  For example, we're also introducing an option to make use of the new Claude Code Skills feature (or you can opt out).  More on this below.

### Retired (short-lived) "Roles" system

2.0.x had introduced a concept of "Roles", where your roles/implementers.yml and roles/verifiers.yml contained convoluted lists of agents that could be assigned to implement tasks.  It also had a script for adding additional "roles".

All of that is removed in 2.1.0.  That system added no real benefit over simply using available tooling (like Claude Code's own subagent generator) for spinning up your subagents.

2.1.0 introduces an 'orchestrate-tasks' phase, which achieves the same thing that the old "Roles" system intended:  Advanced orchestration of multiple specialized subagents to carry out a complex implementation.  More on this below.

### Removed documentation & verification bloat

2.0.x had introduced a bunch of "bloat" that quickly proved unnecessary and inefficient.  These bits have been removed in 2.1.0:

- Verification of your spec (although the spec-verifier Claude Code subagent is still available for you to call on, if/when you want)
- Documentation of every task's implementation
- Specialized verifiers (backend-verifier, frontend-verifier)

The final overall verification step for a spec's implementation remains intact.

### From 4 to 6 more specific development phases

While some users use all of Agent OS' workflow for everything, many have been picking the parts they find useful and discarding those that don't fit their workflow—AS THEY SHOULD!
