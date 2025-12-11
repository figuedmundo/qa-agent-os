# QA Agent OS

## Your system for spec-driven agentic development tailored for Quality Assurance.

QA Agent OS transforms AI coding agents from confused interns into productive QA Engineers. With structured workflows that capture your standards, your stack, and the unique details of your codebase, QA Agent OS gives your agents the feature details they need to ship quality QA processes, analyze bugs, and follow workflows on the first try—not the fifth.

It empowers your AI to understand:
*   **Standards:** *How* you test (your QA standards, conventions, and best practices).
*   **Product:** *What* you're testing and *why* (the product vision, mission, and use-cases).
*   **Features:** *What* you're testing *next* (specific features and their implementation details, broken down into tickets).

Use it with:

✅ **Gemini 3** (recommended) — State-of-the-art multimodal AI with 1M token context and advanced agentic capabilities
✅ Claude Code, Cursor, or other AI coding tools
✅ New products or established codebases
✅ Big features, small fixes, or anything in between
✅ Any language or framework

---

### AI Agent Support

QA Agent OS supports both **Gemini 3** (recommended) and **Claude Code** out of the box:

| Feature | Gemini 3 | Claude Code |
|---------|----------|-------------|
| **Command Type** | `.toml` custom commands | Markdown orchestrators |
| **Multi-Agent** | Native agentic capabilities | Multi-agent orchestration with subagents |
| **Context Window** | 1 million tokens | 200K tokens |
| **Multimodal** | Advanced (text, images, audio, video) | Text & images |
| **Setup** | `.gemini/commands/` | `.claude/commands/` + `.claude/agents/` |
| **Best For** | Complex QA workflows with large codebases | Enterprise multi-team coordination |

### Bug Management

QA Agent OS provides feature-level bug organization with auto-incremented IDs and organized supporting materials. Bugs are tracked at the feature level, enabling cross-ticket references and reducing duplication.

**Quick Reference:**

| Task | Command | Creates |
|------|---------|---------|
| Create a new bug | `/report-bug` | `features/[feature]/bugs/BUG-001-[title]/bug-report.md` |
| Update existing bug | `/revise-bug` | Revisions log with version tracking |
| View bug folder structure | See guide below | N/A |

**Folder Structure:**
```
features/[feature-name]/
├── bugs/
│   ├── BUG-001-checkout-fails/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   ├── logs/
│   │   ├── videos/
│   │   └── artifacts/
│   └── BUG-002-currency-error/
│       ├── bug-report.md
│       └── screenshots/
├── feature-knowledge.md
├── feature-test-strategy.md
└── [TICKET-001]/
    └── test-plan.md
```

**Key Features:**
- Auto-incremented bug IDs per feature (BUG-001, BUG-002, etc.)
- Semantic evidence organization (screenshots/, logs/, videos/, artifacts/)
- Cross-ticket references via Ticket field
- Full revision history with version tracking
- Optional Jira ID integration

For comprehensive guidance, see: **[Bug Folder Structure User Guide](agent-os/specifications/bug-folder-structure-user-guide.md)**

### Documentation & Installation

- **[QA-QUICKSTART.md](QA-QUICKSTART.md)** - Get started with the 5-command QA workflow
- **[CLAUDE.md](CLAUDE.md)** - Complete architecture and development guide (supports both Gemini 3 and Claude Code)
- **[CHANGELOG.md](CHANGELOG.md)** - Release notes and feature updates

---

# Project Vision: QA Agent OS

This section covers

*   The 3-Layer Context System (Standards, Product, Features).
*   How to install QA Agent OS (Base Installation & Project Installation).
*   Detailed example of the generated project structure and daily usage.


This document outlines the core vision, architecture, and workflow for the QA Agent OS project. It serves as a foundational reference to ensure development aligns with the project's primary goals.

## 1. High-Level Goal

The `qa-agent-os` is a distributable, spec-driven system designed to provide AI coding assistants with the structured context they need to perform production-quality Quality Assurance tasks. It transforms an AI's generic capabilities into a specialized, expert QA assistant tailored to a specific project's needs.

### Latest Update: Dual AI Agent Support (v0.6.0+ - Dec 2025)

QA Agent OS now supports both **Gemini 3** (primary) and **Claude Code** with full architectural alignment:

- **Workflow-Centric Design:** All implementation logic is in reusable workflows, not duplicated in commands
- **Gemini 3 Native:** Optimized for Google's state-of-the-art 1M token context window and agentic capabilities
- **Claude Code Support:** Full multi-agent orchestration with subagents for enterprise QA teams
- **Zero Logic Duplication:** Workflows are referenced by multiple commands/agents using `{{workflows/...}}` tags
- **Token-Efficient:** AI agents receive focused context without unnecessary duplication
- **Consistent Standards:** Standards are injected consistently across all commands and agents

This dual-agent architecture enables:
- Leverage Gemini 3's superior context window for complex QA scenarios
- Optional Claude Code deployment for enterprise multi-agent coordination
- Seamless agent switching without code changes
- Easy maintenance: update logic in one place, all agents reflect changes
- Better scalability for future QA workflow additions and integrations

## 2. Core Methodology: The 3-Layer Context System

The project is a direct implementation of the **Agent OS** methodology, which is built on a 3-layer context system. This system ensures the AI has a deep understanding of the project's standards, goals, and immediate tasks.

### Layer 1: Standards - *How* We Build

-   **Purpose:** To define the fundamental rules and quality guidelines for all QA work. This includes test case formats, bug reporting standards, severity rules, and analysis checklists.
-   **Source:** This content is created and maintained within the `qa-agent-os` source repository, specifically in the `profiles/default/standards/` directory.
-   **Implementation:** During the `project-install` step, these standards are compiled and copied into the end-user's project (`qa-agent-os/standards/`), providing the AI with its foundational knowledge.

### Layer 2: Product - *What* We're Building and *Why*

-   **Purpose:** To give the AI a high-level understanding of the specific project or team's mission, scope, and long-term vision. This prevents the AI from working in a vacuum and ensures its output aligns with business goals.
-   **Source:** This context is generated by the end-user (a QA engineer) within their own project by running the `/plan-product` command.
-   **Implementation:** The output of this command is stored within the user's project directory (e.g., `~/company-project/qa-agent-os/product/mission.md`), creating a persistent "brain" for the AI regarding that specific product area.

### Layer 3: Features - *What* We're Building *Next*

-   **Purpose:** To provide the AI with the detailed, granular specifications for the immediate task at hand. We refer to this layer as `features`.
-   **Source:** This is generated by the QA engineer as they work on features and tickets, using `/init-feature` for the structure and `/create-ticket` (which embeds `/analise-requirements` and `/generate-testcases`) for each ticket.
-   **Implementation:** This follows the **Product -> Feature -> Ticket** hierarchy. The agent, guided by the user, creates a structured set of directories and files within the main context folder (e.g., `~/company-project/qa-agent-os/features/<feature-name>/<ticket-id>/`) via the init + ticket commands to manage the specific requirements and generated test cases for each piece of work.

## 3. The End-User Workflow

The entire system is designed around a clear, three-step workflow for the end-user (a QA engineer).

**Step 1: Base Installation**
The user performs a one-time installation of the core `qa-agent-os` system onto their local machine, which places the master scripts and profiles in their home directory (e.g., `~/qa-agent-os`).

```bash
# User runs the installation command
curl -sSL https://raw.githubusercontent.com/figuedmundo/qa-agent-os/main/scripts/base-install.sh | bash
```

> QA Agent OS installs into `~/qa-agent-os` and happily coexists with the developer-focused `agent-os` that installs into `~/agent-os`. Keep both if you split time between QA and dev work; each product ships its own scripts and commands.

**Step 2: Project Installation**
For every company project they work on, the user navigates into that project's directory and runs the `project-install.sh` script.

```bash
cd ~/company-project-A/
~/qa-agent-os/scripts/project-install.sh
```
This compiles the **Standards** into a project-specific `qa-agent-os/` folder and creates the LLM-specific command directory, e.g.`.claude/`.

**Step 3: Day-to-Day Usage**
The user works within their project directory using their preferred AI tool (e.g., a Claude-enabled editor or CLI). The tool uses the context from both the `.claude/` and `qa-agent-os/` folders to understand its commands and the project's context.

-   They run `/plan-product` to define the **Product** context (mission/spec).
-   They run `/init-feature` to stand up the dated feature folders tied to that mission.
-   They run `/create-ticket` (which walks through `/analise-requirements` + `/generate-testcases`) for each ticket assigned under that feature.
-   Before executing any testing workflow (requirements analysis, test planning, test case generation, bug tracking), they call the `compile-testing-standards` workflow so the tool references the exact `@qa-agent-os/standards/...` files that apply to the task, especially when `standards_as_claude_code_skills` is `false`.

## 4. Example Directory Structure (User's Project)

After installation and some use, a QA engineer's project directory will look like this:

**For Gemini 3 (Recommended):**
```
~/company-project-A/
├── .gemini/
│   └── commands/
│       ├── qa-agent-os/
│       │   ├── plan-product.toml
│       │   ├── plan-feature.toml
│       │   ├── plan-ticket.toml
│       │   ├── generate-testcases.toml
│       │   ├── revise-test-plan.toml
│       │   └── update-feature-knowledge.toml
│       └── ...
│
├── qa-agent-os/
```

**For Claude Code:**
```
~/company-project-A/
├── .claude/
│   ├── agents/
│   │   ├── qa-agent-os/
│   │   │   ├── product-planner.md
│   │   │   ├── requirement-analyst.md
│   │   │   ├── feature-initializer.md
│   │   │   └── testcase-writer.md
│   │   └── ...
│   └── commands/
│       ├── qa-agent-os/
│       │   ├── plan-product.md           <-- Multi-agent orchestrator
│       │   ├── plan-feature.md           <-- Multi-agent orchestrator
│       │   ├── plan-ticket.md            <-- Multi-agent orchestrator
│       │   ├── generate-testcases.md     <-- Multi-agent orchestrator
│       │   ├── revise-test-plan.md       <-- Multi-agent orchestrator
│       │   └── update-feature-knowledge.md
│       └── ...
│
├── qa-agent-os/
│   ├── product/
│   │   └── mission.md                    <-- Generated by /plan-product
│   ├── standards/
│   │   ├── global/
│   │   │   ├── conventions.md
│   │   │   ├── testcases.md
│   │   │   └── bugs.md
│   │   ├── bugs/
│   │   │   ├── bug-reporting-standard.md
│   │   │   ├── bug-template.md
│   │   │   └── severity-rules.md
│   │   ├── requirement-analysis/
│   │   │   └── requirement-analysis-checklist.md
│   │   ├── testcases/
│   │   │   └── test-case-standard.md
│   │   └── testing/
│   │       └── test-plan-template.md
│   ├── templates/
│   │   ├── feature-knowledge-template.md
│   │   ├── feature-test-strategy-template.md
│   │   ├── test-plan-template.md
│   │   ├── test-cases-template.md
│   │   └── collection-log-template.md
│   ├── workflows/                        <-- NEW: Reusable workflow logic
│   │   ├── planning/
│   │   │   ├── gather-feature-docs.md
│   │   │   ├── consolidate-feature-knowledge.md
│   │   │   ├── create-test-strategy.md
│   │   │   └── update-feature-knowledge.md
│   │   └── testing/
│   │       ├── testcase-generation.md
│   │       ├── requirement-analysis.md
│   │       ├── initialize-feature.md
│   │       ├── initialize-ticket.md
│   │       ├── gather-ticket-docs.md
│   │       └── revise-test-plan.md
│   └── features/
│       └── 2025-11-17-feature-name/
│           ├── documentation/
│           │   ├── BRD.md
│           │   ├── API-spec.md
│           │   └── mockups/
│           ├── feature-knowledge.md      <-- Generated by /plan-feature (Phase 3)
│           ├── feature-test-strategy.md  <-- Generated by /plan-feature (Phase 4)
│           └── ticket-123/
│               ├── documentation/
│               │   ├── acceptance-criteria.md
│               │   └── technical-details.md
│               ├── test-plan.md          <-- Generated by /plan-ticket (Phase 3)
│               └── test-cases.md         <-- Generated by /generate-testcases
│
└── src/
    └── ... (The actual source code of the company's project)
```


### Follow updates & releases

Read the [changelog](CHANGELOG.md)
