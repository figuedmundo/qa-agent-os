# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Agent OS is a spec-driven agentic development framework that transforms AI coding agents into productive developers through structured workflows. It provides standards, agents, commands, and workflows for consistent, high-quality code delivery.

## Key Commands

### Installation & Setup

```bash
# Base installation (installs to ~/agent-os)
curl -sL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash

# Project installation (run from project directory)
bash ~/agent-os/scripts/project-install.sh

# Project update (update existing installation)
bash ~/agent-os/scripts/project-update.sh

# Create a custom profile
bash ~/agent-os/scripts/create-profile.sh
```

### Installation Options

The `project-install.sh` script supports these flags:
- `--profile [name]` - Use specified profile (default: from config.yml)
- `--claude-code-commands [true/false]` - Install Claude Code commands
- `--use-claude-code-subagents [true/false]` - Enable Claude Code subagents
- `--agent-os-commands [true/false]` - Install agent-os commands folder
- `--standards-as-claude-code-skills [true/false]` - Use Skills for standards
- `--dry-run` - Preview changes without installing
- `--re-install` - Force reinstall
- `--overwrite-all` - Overwrite all files

## Architecture

### Core Components

**Profiles** (`profiles/[profile-name]/`)
- Contain customizable templates for agents, commands, workflows, and standards
- Default profile provides complete workflow templates
- Custom profiles can be created for team-specific needs

**Agents** (`profiles/[profile-name]/agents/`)
- Specialized Claude Code subagents for different phases
- Each agent has a markdown file defining its role and tools
- Key agents: `spec-writer`, `implementer`, `tasks-list-creator`, `product-planner`, `spec-shaper`, `implementation-verifier`, `spec-verifier`, `spec-initializer`

**Commands** (`profiles/[profile-name]/commands/`)
- Claude Code slash commands that orchestrate workflows
- Organized by development phase
- Support both single-agent and multi-agent modes

**Workflows** (`profiles/[profile-name]/workflows/`)
- Step-by-step process definitions
- Three categories: `planning/`, `specification/`, `implementation/`
- Referenced by agents and commands using template syntax: `{{workflows/path/file}}`

**Standards** (`profiles/[profile-name]/standards/`)
- Tech stack definitions and coding conventions
- Organized into: `global/`, `frontend/`, `backend/`, `testing/`
- Injected into commands/agents or exposed as Claude Code Skills

### Template System

Agent OS uses a powerful template system for composing prompts:

- `{{workflows/path/file}}` - Include workflow content
- `{{standards/*}}` - Include all standards files
- `{{UNLESS flag}}...{{ENDUNLESS flag}}` - Conditional content
- File references compile into full paths at installation time

### Configuration

**Base Configuration** (`~/agent-os/config.yml`)
```yaml
version: 2.1.1
base_install: true
claude_code_commands: true/false
agent_os_commands: true/false
use_claude_code_subagents: true/false
standards_as_claude_code_skills: true/false
profile: default
```

**Project Configuration** (`agent-os/config.yml` in project)
- Override base settings per-project
- Specify which profile to use
- Customize installation behavior

## Development Phases

Agent OS supports 6 distinct development phases (use all or pick what you need):

1. **plan-product** - Define product mission, roadmap, and tech stack
2. **shape-spec** - Gather requirements and shape feature specifications
3. **write-spec** - Create detailed specification documents
4. **create-tasks** - Generate task lists from specifications
5. **implement-tasks** - Single-agent implementation following tasks.md
6. **orchestrate-tasks** - Multi-agent orchestration with specialized subagents

### Typical Workflow

```
/plan-product     → agent-os/product/mission.md, roadmap.md, tech-stack.md
/shape-spec       → agent-os/specs/[spec-name]/planning/requirements.md
/write-spec       → agent-os/specs/[spec-name]/spec.md
/create-tasks     → agent-os/specs/[spec-name]/tasks.md
/implement-tasks  → Implementation + verification
```

## File Structure

### In Projects Using Agent OS

```
agent-os/
  ├── config.yml                    # Project-specific config
  ├── product/                      # Product planning docs
  │   ├── mission.md
  │   ├── roadmap.md
  │   └── tech-stack.md
  ├── specs/                        # Feature specifications
  │   └── [spec-name]/
  │       ├── planning/
  │       │   ├── requirements.md   # Requirements from shape-spec
  │       │   └── visuals/          # Screenshots/mockups
  │       ├── spec.md               # Main specification
  │       ├── tasks.md              # Implementation task list
  │       ├── orchestration.yml     # Multi-agent assignment
  │       └── verification/         # Test screenshots
  ├── standards/                    # Project standards (copied from profile)
  │   ├── global/
  │   ├── frontend/
  │   ├── backend/
  │   └── testing/
  └── commands/                     # Commands (if agent_os_commands enabled)

.claude/
  ├── commands/agent-os/            # Claude Code commands
  └── agents/agent-os/              # Claude Code subagents
```

### In Base Installation

```
~/agent-os/
  ├── config.yml                    # Base configuration
  ├── profiles/                     # Profile templates
  │   └── default/
  │       ├── agents/
  │       ├── commands/
  │       ├── workflows/
  │       └── standards/
  └── scripts/                      # Installation scripts
```

## Key Patterns

### Spec-Driven Development

1. All features start with a spec in `agent-os/specs/[spec-name]/`
2. Specs include: goal, user stories, requirements, visual design, existing code to leverage
3. Tasks are derived from specs and tracked in `tasks.md`
4. Implementation follows tasks precisely
5. Verification ensures spec requirements are met

### Standards Compliance

All generated specs, tasks, and code must align with:
- Tech stack defined in `agent-os/standards/global/tech-stack.md`
- Coding conventions in standards files
- Existing patterns in the codebase

Standards can be:
- Injected as file references in prompts (default)
- Exposed as Claude Code Skills for discoverability

### Task Organization

Tasks in `tasks.md` use this structure:
```markdown
## [Task Group Name]

- [ ] Parent task description
  - [ ] Sub-task 1
  - [ ] Sub-task 2
```

When tasks are completed, checkboxes are updated to `[x]`.

### Multi-Agent Orchestration

For complex implementations:
1. Create `orchestration.yml` mapping task groups to subagents
2. Assign relevant standards per task group
3. Delegate tasks with compiled standards references
4. Each subagent implements and checks off their tasks

## Important Notes

- Agent OS is MIT licensed - can be modified and used privately
- Version 2.1.1 introduced Skills support and removed the "roles" system
- Installation scripts use common-functions.sh for shared utilities
- Profile system allows team customization without forking
- All workflows encourage reusing existing code patterns
- Visual assets should be placed in `planning/visuals/` for reference

## Working with This Repository

When making changes to Agent OS itself:

1. **Test changes** using `--dry-run` flag before actual installation
2. **Update version** in `config.yml` when releasing
3. **Document changes** in `CHANGELOG.md`
4. **Maintain backward compatibility** in scripts and templates
5. **Test across profiles** to ensure changes work with different configurations

The scripts in `scripts/` directory are the entry points:
- `base-install.sh` - Downloads Agent OS to ~/agent-os
- `project-install.sh` - Installs into current project
- `project-update.sh` - Updates existing project installation
- `create-profile.sh` - Creates new profile from template
- `common-functions.sh` - Shared utility functions (colors, validation, etc.)
