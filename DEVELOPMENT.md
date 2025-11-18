# QA Agent OS Development Guide

## Repository Strategy

This repository is a **fork of Agent OS** that extends it with QA-specific profiles while maintaining the ability to receive upstream updates.

### Repository Structure

```
This Repo (qa-agent-os)
├── profiles/
│   ├── default/          # FROM UPSTREAM - DO NOT MODIFY
│   │   ├── agents/       # Original Agent OS agents
│   │   ├── commands/     # Original Agent OS commands
│   │   ├── workflows/    # Original Agent OS workflows
│   │   └── standards/    # Original Agent OS standards
│   └── qa-agent-os/      # YOUR WORK - QA-specific profile
│       ├── agents/       # QA agents (requirement-analyst, etc.)
│       ├── commands/     # QA commands (/analyze-requirements, etc.)
│       ├── workflows/    # QA workflows
│       └── standards/    # QA standards
├── scripts/              # FROM UPSTREAM - May need minor modifications
│   ├── base-install.sh
│   ├── project-install.sh
│   ├── project-update.sh
│   └── common-functions.sh
├── config.yml            # FROM UPSTREAM - Modify to add qa-agent-os profile
├── examples/             # YOUR WORK - QA examples
├── docs/                 # YOUR WORK - QA documentation
└── agent-os/             # YOUR WORK - Product planning for QA Agent OS
```

## Git Workflow

### Initial Setup

```bash
# Check your current remotes
git remote -v

# Should show:
# origin: your fork (e.g., your-gitlab/qa-agent-os)
# If you don't have upstream yet, add it:
git remote add upstream https://github.com/buildermethods/agent-os.git

# Verify
git remote -v
# origin    https://your-gitlab.com/your-username/qa-agent-os.git (fetch)
# origin    https://your-gitlab.com/your-username/qa-agent-os.git (push)
# upstream  https://github.com/buildermethods/agent-os.git (fetch)
# upstream  https://github.com/buildermethods/agent-os.git (push)
```

### Daily Development Workflow

```bash
# Work on QA Agent OS features
# 1. Create/modify files in profiles/qa-agent-os/
# 2. Add QA-specific examples, docs
# 3. Update agent-os/product/ planning docs

# Commit your QA-specific work
git add profiles/qa-agent-os/
git add examples/
git add docs/
git add agent-os/
git commit -m "Add requirement analyst agent and workflow"
git push origin main
```

### Pulling Updates from Agent OS

When the original Agent OS project releases updates:

```bash
# Fetch latest from upstream
git fetch upstream

# Review what changed
git log HEAD..upstream/main --oneline

# Merge upstream changes
git merge upstream/main

# This will update:
# - profiles/default/ (Agent OS improvements)
# - scripts/ (installation script fixes)
# - Root config.yml (new features)

# Your profiles/qa-agent-os/ stays intact!

# Resolve conflicts if any (likely in config.yml)
# Then push to your fork
git push origin main
```

### Handling Conflicts

If `config.yml` has conflicts (likely):

```yaml
# Original Agent OS config.yml
version: 2.1.1
profile: default  # <- They use default

# Your QA Agent OS config.yml
version: 2.1.1
profile: qa-agent-os  # <- You use qa-agent-os

# Resolution: Keep both profiles supported
version: 2.1.1
profile: default  # Default for Agent OS users
# OR profile: qa-agent-os  # For QA Agent OS users
```

## What to Modify vs. Keep Unchanged

### ✅ Modify/Create Freely:
- `profiles/qa-agent-os/` - All your QA agents, commands, workflows, standards
- `examples/` - QA-specific examples
- `docs/` - QA-specific documentation
- `agent-os/` - QA Agent OS product planning
- `README.md` - Update to describe QA Agent OS (but mention Agent OS origin)
- `config.yml` - Add qa-agent-os profile option

### ⚠️ Modify Carefully:
- `scripts/` - May need minor changes to support qa-agent-os profile
  - If you modify, keep backward compatibility with default profile
  - Document changes for when you pull upstream updates
  - Consider: Can you extend rather than modify?

### 🚫 Don't Modify:
- `profiles/default/` - Keep pristine for upstream updates
- `.github/` workflows (if any) - Unless you need QA-specific CI/CD

## Installation Scripts Strategy

The existing scripts should work with minimal changes:

```bash
# scripts/base-install.sh
# Minor change: Support installing QA Agent OS profile

# scripts/project-install.sh
# Already supports profiles via config.yml
# Should work with profiles/qa-agent-os/ automatically!

# Test by:
# 1. Update config.yml: profile: qa-agent-os
# 2. Run: bash scripts/project-install.sh
# 3. Should install from profiles/qa-agent-os/
```

## Sharing with Coworkers

Your coworkers can use QA Agent OS by:

```bash
# Clone your fork
git clone https://your-gitlab.com/your-username/qa-agent-os.git
cd qa-agent-os

# Install base (to ~/qa-agent-os/)
bash scripts/base-install.sh

# In their project directory
cd ~/their-project
bash ~/qa-agent-os/scripts/project-install.sh --profile qa-agent-os

# Now they have QA Agent OS installed in .claude/
```

## Updating config.yml for QA Agent OS

Update the root `config.yml` to support both profiles:

```yaml
version: 2.1.1
base_install: true
claude_code_commands: true
agent_os_commands: false
use_claude_code_subagents: true
standards_as_claude_code_skills: false

# Default profile (from upstream Agent OS)
profile: default

# QA Agent OS users should change to:
# profile: qa-agent-os

# Profile-specific configuration
profiles:
  default:
    # Original Agent OS profile configuration
    agents:
      - spec-writer
      - implementer
      - spec-initializer
      # ... etc

  qa-agent-os:
    # QA Agent OS profile configuration
    agents:
      - requirement-analyst
      - test-case-generator
      - bug-writer
    commands:
      - analyze-requirements
      - generate-tests
      - create-bug
    workflows:
      - requirements-analysis
      - test-generation
      - bug-reporting
    standards:
      - testing/requirement-analysis-format
```

## Benefits of This Approach

✅ **Stay Updated:** Pull Agent OS improvements automatically
✅ **Extend, Don't Fork:** Add QA profile without breaking Agent OS
✅ **Share Easily:** Coworkers clone your fork and get both
✅ **Contribute Back:** If you improve scripts, submit PR to upstream
✅ **Flexible:** Users can choose `default` or `qa-agent-os` profile

## Testing Your Setup

```bash
# 1. Verify profile structure exists
ls profiles/default/      # Should have Agent OS files
ls profiles/qa-agent-os/  # Should have your QA files (or will soon)

# 2. Check scripts are present
ls scripts/base-install.sh
ls scripts/project-install.sh

# 3. Test installation (dry run)
bash scripts/project-install.sh --profile qa-agent-os --dry-run

# 4. Verify no conflicts with upstream
git fetch upstream
git diff upstream/main profiles/default/
# Should show no differences (you haven't modified it)

git diff upstream/main profiles/qa-agent-os/
# Shows your QA additions (expected)
```

## Summary

**Your workflow:**
1. Work in `profiles/qa-agent-os/` - your QA extensions
2. Keep `profiles/default/` pristine - for upstream updates
3. Commit and push your QA work to origin
4. Pull upstream updates when available
5. Share your fork with coworkers
6. Everyone benefits from both Agent OS updates AND your QA extensions!

This is the best of both worlds! 🎉
