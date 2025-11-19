#### Compile Testing Standards

Use this workflow at the start of any testing-related command (requirement analysis, test planning, test case generation, bug work) whenever you must provide explicit `@qa-agent-os/...` file references. It replaces the legacy `orchestration.yml` logic with the profile-aware standards that live in `profiles/default/standards`.

> Skip this workflow only when `standards_as_claude_code_skills` is `true` in `config.yml`, because Claude Code will already ingest the standards as skills.

---

### Step 1: Determine Task Group
Identify which workflow you are about to run so you can pull the right folders:

| Task Type | Primary Standards Folders |
| --- | --- |
| Requirement Analysis / Acceptance Criteria | `global/`, `requirement-analysis/`, `bugs/severity-rules.md` |
| Test Planning | `global/`, `requirement-analysis/`, `testcases/`, `testing/`, `bugs/` (severity/evidence) |
| Test Case Generation | `global/`, `testcases/`, `testing/` (API/exploratory), `bugs/severity-rules.md` |
| Bug Workflows | `global/`, `bugs/`, `testing/test-plan-template.md` (for exit criteria) |

Always include `global/` because it contains cross-cutting conventions and the evidence template moved here.

### Step 2: Build the File List
1. `cd profiles/default/standards`.
2. Gather the relevant `.md` files from the folders identified in Step 1.
   - Use `find <folder> -name '*.md' | sort` to capture all files when `*` applies.
   - When only a single file is needed (e.g., `bugs/severity-rules.md`), reference it explicitly.
3. Deduplicate and keep the list sorted for readability.

```bash
cd profiles/default/standards
find global requirement-analysis -name '*.md' | sort -u
```

### Step 3: Format Output
Transform each relative path into an `@qa-agent-os/standards/...` reference (omit the `profiles/default/` prefix so it matches the rest of our workflows).

Example transformation:

```
global/conventions.md            -> @qa-agent-os/standards/global/conventions.md
testcases/test-case-standard.md  -> @qa-agent-os/standards/testcases/test-case-standard.md
```

### Step 4: Share With the Next Workflow
Paste the compiled list (one reference per line) into your response or into the calling workflow so downstream agents know exactly which standards to follow. A typical list for test planning looks like:

```
@qa-agent-os/standards/global/conventions.md
@qa-agent-os/standards/global/evidence-template.md
@qa-agent-os/standards/global/testcases.md
@qa-agent-os/standards/requirement-analysis/requirement-analysis-checklist.md
@qa-agent-os/standards/testcases/test-case-standard.md
@qa-agent-os/standards/testcases/test-generation.md
@qa-agent-os/standards/testing/test-plan-template.md
@qa-agent-os/standards/testing/api-testing.md
@qa-agent-os/standards/bugs/severity-rules.md
```

Re-run this workflow whenever new standards are added or when switching to a different testing task group so the reference list stays accurate.