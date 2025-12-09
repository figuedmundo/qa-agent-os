# Raw Idea

**Feature Description:**
Redesign QA workflow commands to separate initialization from analysis phases:

1. **`/plan-feature` → `/start-feature`**: Split the command to only initialize feature folder structure with placeholders, allowing QA time to manually gather documentation before running a separate `/analyze-requirements` command

2. **`/plan-ticket` → `/start-ticket`**: Similarly split to only initialize ticket structure, then use `/analyze-requirements [ticket-id]` to process gathered documentation

3. **Remove automatic test case generation**: Test cases should only be generated on-demand via explicit `/generate-testcases` calls

This redesign separates the "setup structure" phase from the "analyze and generate documentation" phase, giving QAs more control over the workflow timing.

---

**Date Initiated:** 2025-12-02
