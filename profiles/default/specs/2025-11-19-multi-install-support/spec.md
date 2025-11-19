# Spec: Multi-Install Support for QA Agent OS

## Goal
Let QA engineers install `QA Agent OS` alongside the legacy developer-focused `agent-os` without conflicts, ensure the installer messaging refers to the QA product, and reset the QA product versioning to start at `0.1.0`.

## Background & Context
- The dev-oriented `agent-os` already lives at `~/agent-os` with its own installer, commands, and version history.
- QA Agent OS should install to `~/qa-agent-os` and ships workflows, standards, and commands tailored for QA engineers.
- Running `curl -sSL https://raw.githubusercontent.com/figuedmundo/qa-agent-os/main/scripts/base-install.sh | bash` currently prints the legacy “Agent OS Base Installation” header, detects an “existing installation” at version `2.1.1`, and offers only update options. This is confusing when the user expects a fresh QA-focused product with different commands and versioning.
- We need to make it explicit that both products can coexist, and ensure QA Agent OS advertises its own identity and semantic version line starting at `0.1.0`.

## Functional Requirements
1. **Product Identity**
   - Update all user-facing strings in `scripts/base-install.sh` (and other touched scripts) to say “QA Agent OS” instead of “Agent OS”.
   - Spinner/status lines like “Installing Agent OS files…” must be renamed to “Installing QA Agent OS files…”.
   - Success messages and next steps must reference QA Agent OS and QA workflows.

2. **Parallel Install Awareness**
   - Base installer should only consider `~/qa-agent-os` when checking for an existing QA installation. Presence of `~/agent-os` (dev tool) must not trigger the existing-installation flow.
   - Document (README + installer output) that QA Agent OS can coexist with `agent-os` and lives in its own folder.
   - If `~/qa-agent-os` already contains files from a previous QA build, keep the prompt flow, but distinguish the product by name so users understand which install is being updated.

3. **Version Reset**
   - Update `config.yml` default `version` to `0.1.0`.
   - Ensure `get_latest_version()` and installer messaging report the new semantic version.
   - Any CHANGELOG or README references to the old 2.x line must be updated to reflect the new version stream (at minimum, mention that QA Agent OS starts at 0.1.0).

4. **Detection Logic**
   - Detection remains based on the presence of `~/qa-agent-os/config.yml`. No attempt is needed to migrate from `~/agent-os`.
   - If `~/qa-agent-os` is missing, perform a fresh QA install regardless of whatever is inside `~/agent-os`.
   - Optional: add a quick check that warns if the user mistakenly runs the QA installer from an `agent-os` checkout (e.g., repo name mismatch), but *do not* block installation.

5. **Documentation Updates**
   - README’s installation instructions must clarify the distinction between `agent-os` and `QA Agent OS`, showing separate install commands and target directories.
   - Mention that a single engineer can keep both toolchains locally for dev vs QA roles.

## Non-Goals
- No changes to `~/agent-os` scripts, installers, or versioning.
- No automated migration of data between `agent-os` and `qa-agent-os`.
- No restructuring of profiles or workflows beyond the naming/version updates needed for clarity.

## Testing & Validation
- Fresh install on a machine that already has `~/agent-os` but no `~/qa-agent-os` should:
  1. Print “QA Agent OS Base Installation”.
  2. Complete without referencing the dev tool.
  3. Leave `config.yml` at version `0.1.0`.
- Re-run installer when `~/qa-agent-os` exists to confirm the existing-installation prompt explicitly references QA Agent OS and the new version numbers.
- README section renders updated instructions and clearly differentiates the two products.

## Open Questions
- Do we need a migration script for users who previously cloned QA Agent OS when it still shared the 2.x version line? (Assumed out of scope for now; require manual cleanup if needed.)


