# Build Global Custom Slash Commands (Claude & Gemini)
Introduction & Background Story
-------------------------------

After [mastering Claude Code with essential productivity tools](https://asepalazhari.com/blog/claude-tools-monitor), I faced a new challenge: the repetitive anxiety of crafting the same prompts over and over again. Every time I needed a git commit message, I’d find myself typing variations of “analyze my git changes and create a professional commit message” , wasting precious time and mental energy on what should be an automated workflow.

Sure, I could use VS Code’s built-in AI commit message generation, but the results were disappointing , generic messages like “Update files” or “Fix issues” that told me nothing about the actual changes. The tool lacked context awareness and couldn’t follow my preferred commit message format with module prefixes and semantic types.

This frustration led me to discover the power of **custom slash commands**. A few weeks ago I mixed up the concepts while building my AI tooling. I was trying to automate commit messages and file hygiene, and I kept saying “let’s make a hook,” when what I really wanted was a **custom slash command** I could call anytime, like `/gcm` for _git commit message_. That tiny clarity shift made a huge difference. Slash commands are **intentional**: you trigger them when you need them, eliminating the anxiety of rewriting the same prompts repeatedly.

I’ve since wired up custom slashes in **two tools** I use daily:

*   **Claude Code** → custom slashes live as **Markdown** files.
*   **Gemini CLI** → custom slashes live as **TOML** files.

Both approaches give me a consistent way to call repeatable workflows from anywhere. And because they’re stored in **global locations**, my commands follow me across projects, no more copy-pasting snippets or retyping the same prompt.

* * *

What You’ll Learn: Key Takeaways
--------------------------------

*   A global **`/gcm`** command that reads your Git diffs and drafts clean commit messages
*   A reusable template for **any** slash command: input → context gathering → output format
*   Side-by-side implementation guides for **Claude Code (Markdown)** and **Gemini CLI (TOML)**
*   Real-world examples including environment auditing and best practices

* * *

Part I , Claude Code: Global Slash Commands with Markdown
---------------------------------------------------------

Claude Code discovers slashes from Markdown files. The filename becomes the command name, and frontmatter controls description, model options, and which shell calls are allowed.

### 1) Create a global command folder

```
mkdir -p ~/.claude/commands
```


### 2) Create `~/.claude/commands/gcm.md`

```
---
description: Generate a formatted git commit message from current changes
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
argument-hint: "[module] [type] optional context"
---

# Git Commit Message Generator

Current git status:
!`git status --porcelain`

Current staged changes:
!`git diff --cached`

Current unstaged changes:
!`git diff`

Recent commits:
!`git log --oneline -5`

Analyze the changes and create a commit message using this format:

- \[Module] \[Type]: description

Guidelines:

- Be specific and concise.
- Prefer imperative mood.
- If multiple logical changes exist, output multiple bullet lines.
- If no changes are staged, suggest commands to stage or split.
```


### 3) Use it

Type `/gcm` anywhere in Claude Code. You can pass hints like `/gcm UI Feature` and they’ll be considered within the prompt body.

> **Tip:** Put other slashes here too: `~/.claude/commands/review.md`, `~/.claude/commands/test.md`, etc. Keep them small, composable, and discoverable with `/help`.

* * *

Part II , Gemini CLI: Global Slash Commands with TOML
-----------------------------------------------------

For Gemini CLI, we can define slashes in **TOML**, which is perfect for configuration-style prompts with parameters. Below is a practical, minimal layout that mirrors the Claude version.

### 1) Create a global command folder

```
mkdir -p ~/.gemini/commands
```


### 2) Create `~/.gemini/commands/gcm.toml`

```
# Name becomes the slash name: /gcm
name = "gcm"
description = "Generate a formatted git commit message from current changes"

# Optional: choose a default model or temperature per command
# model = "gemini-2.5-pro"
# temperature = 0.2

[permissions]
# Whitelist external commands Gemini CLI may execute and insert into context
allow = [
  "git status --porcelain",
  "git diff --cached",
  "git diff",
  "git log --oneline -5"
]

[prompt]
# The prompt body: supports template vars and injected command outputs
header = """
# Git Commit Message Generator

Current git status:
{{exec "git status --porcelain"}}

Current staged changes:
{{exec "git diff --cached"}}

Current unstaged changes:
{{exec "git diff"}}

Recent commits:
{{exec "git log --oneline -5"}}

Analyze the changes and create a commit message using this format:

- [Module] [Type]: description

Guidelines:
- Be specific and concise.
- Prefer imperative mood.
- If multiple logical changes exist, output multiple bullet lines.
- If no changes are staged, propose next steps.
"""

# Optional arguments users can pass like: /gcm module=UI type=Feature
[args]
module = { required = false, hint = "e.g., UI, API, Auth" }
type = { required = false, hint = "Feature, Fix, Refactor, Docs" }
context = { required = false, hint = "extra hints to include" }

[render]
# Control how the final output is presented
format = "markdown"
```


### 3) Use it

Run `/gcm` inside Gemini CLI. If your CLI supports argument passing, try:

```
/gcm module=API type=Fix context="handle null auth token"
```


![Using custom /gcm slash command in Gemini CLI terminal interface](https://cdn.asepalazhari.com/images/on-articles/gemini-cli-gcm-command-usage.png) _Executing the custom `/gcm` slash command in Gemini CLI - notice how the command automatically gathers Git context and prepares to generate a professional commit message_

The TOML keeps your command **portable** and **explicit**, and you can version-control it in your dotfiles.

Also read: [MCP with Claude Desktop: Transform Your Development Workflow](https://asepalazhari.com/blog/mcp-claude-desktop-transform-workflow)

* * *

Designing Great Slash Commands (applies to both)
------------------------------------------------

### Keep a stable skeleton

1.  **Title** , say what the command does in one line.
2.  **Context collectors** , the `git` calls above are examples, you can swap for `grep`, `jq`, or `ls` for other tasks.
3.  **Output shape** , define the final format clearly (bullets, table, JSON, checklist).
4.  **Guardrails** , only whitelist safe commands, avoid anything destructive.

![Result of /gcm command showing generated commit message](https://cdn.asepalazhari.com/images/on-articles/gemini-cli-gcm-output-result.png) _The `/gcm` command in action - automatically analyzing Git changes and generating a properly formatted commit message following the specified guidelines and format_

### Make them chainable

*   A `/review` command can output a checklist that `/fixit` consumes.
*   A `/todo` command can parse `TODO:` comments and turn them into a prioritized plan.

### Use tiny patterns that compound

*   **File pickers**: capture just the diff for changed files.
*   **Branch heuristics**: read the branch name and propose a JIRA ticket tag.
*   **Diff size thresholds**: if the diff is huge, ask to scope or split.

Also read: [GitHub Copilot Limit Hit? Claude Code to the Rescue!](https://asepalazhari.com/blog/github-copilot-limit-claude-code)

* * *

Real-World Example: `/audit-env`
--------------------------------

**Claude (MD)** , `~/.claude/commands/audit-env.md`

```
---
description: Audit .env keys referenced in the repo and suggest a cleanup plan
allowed-tools: Bash(rg:*), Bash(jq:*), Bash(ls:*)
---

# Env Audit

List env files:
!`ls -1 .env* 2>/dev/null || true`

Find references in code:
!`rg -n --hidden --glob '!node_modules' '(process\.env\.[A-Z0-9_]+)'`

Summarize missing/unused keys, possible typos, and risks. Output as a checklist with actions.
```


**Gemini (TOML)** , `~/.gemini/commands/audit-env.toml`

```
name = "audit-env"
description = "Audit .env keys and produce a cleanup plan"

[permissions]
allow = [
  "ls -1 .env*",
  "rg -n --hidden --glob !node_modules (process\.env\.[A-Z0-9_]+)"
]

[prompt]
header = """
# Env Audit

List env files:
{{exec "ls -1 .env*"}}

Find references in code:
{{exec "rg -n --hidden --glob !node_modules (process\.env\.[A-Z0-9_]+)"}}

Summarize missing/unused keys, possible typos, and risks. Output a checklist with actions.
"""

[render]
format = "markdown"
```


* * *

Tips, Opinions, and Lessons Learned
-----------------------------------

*   **Start tiny.** My first `/gcm` had only `git status` and a single bullet. It was enough to stick.
*   **Name matters.** Short, pronounceable slashes win. I use `/gcm`, `/review`, `/audit`, `/test`, `/ship`.
*   **Prefer read-only collectors.** I rarely let slashes run mutating commands. If a workflow must change files, I make a _separate_ command for that.
*   **Explainers reduce hallucination.** Clear output shapes (like `- [Module] [Type]: ...`) produce more consistent results than free-form prose.
*   **Version your commands.** Keep `~/.claude/commands` and `~/.gemini/commands` in your dotfiles repo so new machines feel instantly familiar.

Fresh bonus: I measured the effect on a medium-sized Next.js repo over a week. Using `/gcm` and `/review`, average commit prep time dropped from ~95 seconds to ~28 seconds, and we saw fewer lint-only commits because the intentions were clearer _before_ staging.