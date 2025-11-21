# Create Ticket Workflow (DEPRECATED)

⚠️ **This workflow is deprecated as of v0.2.0 (Nov 2025) and will be removed in v0.4.0.**

The functionality described here is now provided by the `/plan-ticket` command, which intelligently orchestrates ticket planning across 5 phases:
- **Phase 1:** Initialize ticket structure (initialize-ticket workflow)
- **Phase 2:** Gather ticket documentation (gather-ticket-docs workflow)
- **Phase 3:** Analyze requirements & detect gaps (requirement-analysis workflow)
- **Phase 4:** Generate test cases (testcase-generation workflow)

**👉 Recommended:** Use `/plan-ticket [ticket-id]` instead of this workflow directly.

For developers maintaining this codebase: This workflow is kept for reference only. Consider it a historical document showing the pre-refactor pattern. It will be removed after all internal references are migrated.

---

## Legacy Documentation

Use this workflow whenever a new ticket is assigned under an existing feature. It ensures the agent leverages the product mission, captures clarified requirements, and produces an executable test suite. The steps mirror running `/analise-requirements` followed by `/generate-testcases`.

## Step 0: Confirm Context
1. Load `qa-agent-os/product/mission.md` and note the **Team Ownership** table so you know which squad owns the surface.
2. Identify the feature folder created via `/init-feature` (e.g., `qa-agent-os/features/2025-11-19-twrr/`).
3. Capture the ticket identifier and ensure the ticket subfolder exists (`qa-agent-os/features/<feature>/<ticket-id>/`).

## Step 1: Requirement Analysis (`/analise-requirements`)

Run the requirement analysis workflow to capture clarified requirements, BRD links, visual assets, and risks.

{{workflows/testing/requirement-analysis}}

**Modern Deliverable:** `[ticket]/test-plan.md` (11 sections including requirements, coverage, scenarios, test data)

*Legacy path (outdated):* `[ticket]/planning/requirements.md`

## Step 2: Test Case Generation (`/generate-testcases`)

Using the freshly saved requirements, produce the test suite for this ticket.

{{workflows/testing/testcase-generation}}

**Modern Deliverable:** `[ticket]/test-cases.md` (detailed executable test cases with execution tracking)

*Legacy path (outdated):* `[ticket]/artifacts/testcases.md`

## Step 3: Confirm Handover
- Announce where requirements + test cases live.
- Note any open questions or dependencies back to the owning team (per the mission's team map).
- If more tickets remain under the same feature, repeat this workflow.


