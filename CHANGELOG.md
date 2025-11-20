# Changelog

Get notified of major releases by subscribing here:
https://medirect.com/qa-agent-os

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
