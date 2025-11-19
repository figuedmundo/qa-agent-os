# Test Planning Workflow

This workflow bridges the gap between requirement analysis and test case generation. It guides the agent through designing a risk-based test strategy, leveraging the restored `refs/qa_test_design_template.md`, and producing a reusable `test-plan.md` artifact for each ticket.

## Core Responsibilities

1. **Ingest Requirements**: Read the finalized `requirements.md` created by the requirement analyst.
2. **Design the Test Strategy**: Use the `qa_test_design_template.md` to define scope, coverage approach, and prioritization across functional and non-functional dimensions.
3. **Produce Planning Artifacts**: Save a complete test plan (including test matrix, data needs, and non-functional coverage) to the ticket’s planning folder so downstream agents can trace decisions.

`[ticket-path]` refers to the root directory of the ticket (e.g., `qa-agent-os/features/2025-11-19-feature-name/TICKET-123`).

---

## Workflow

### Step 0: Confirm Inputs

1. Ensure `requirements.md` exists at `[ticket-path]/planning/requirements.md`.
2. Load the senior QA framework template at `refs/qa_test_design_template.md`.
3. If either file is missing, stop and request it from the user before proceeding.

```bash
REQUIREMENTS_FILE="[ticket-path]/planning/requirements.md"
TEMPLATE_FILE="refs/qa_test_design_template.md"

ls "$REQUIREMENTS_FILE" "$TEMPLATE_FILE"
```

### Step 1: Extract Granular Requirements

1. Read the requirements file in full.
2. Following Section 3 of the template, decompose the feature into atomic, testable requirements.
3. Capture each requirement with an ID, summary, inputs, and expected outputs. These become the backbone of the coverage matrix.

```bash
cat "$REQUIREMENTS_FILE"
```

### Step 2: Define Test Strategy & Scope

Using Sections 4–9 of the template:

1. Determine in-scope vs. out-of-scope functionality.
2. Select applicable test levels (unit, integration, API, UI, etc.).
3. Enumerate coverage across functional, boundary, negative, dependency-failure, security, performance, usability, and accessibility types.
4. Assign risk-based priorities (impact × probability) that will later map to test case priority.

### Step 3: Build Test Coverage Matrix & Data Plan

1. Map each requirement ID to the test types that will validate it (Section 7).
2. Define the specific positive, negative, boundary, dependency-failure, and behavioral scenarios needed per requirement (Section 5).
3. Document concrete test data sets (Section 6), including boundary values, invalid payloads, and security payloads.

### Step 4: Capture Non-Functional & Automation Considerations

1. Propose measurable performance, security, usability, and compatibility tests (Section 8).
2. If relevant, outline automation tooling, selectors strategy, and environment setup (Section 10).
3. Note environment URLs, browser/device targets, and dependencies (Section 2).

### Step 5: Produce the Test Plan Artifact

1. Create `[ticket-path]/planning/test-plan.md`.
2. Populate it with all sections from the template (1–15) adapted to the ticket’s context. Do not omit the CSV/Testmo instructions (Section 15); copy them verbatim as required.
3. At the end of the document, include the deliverable checklist from Section 16 and mark only the artifacts actually produced during this workflow.

```bash
OUTPUT_FILE="[ticket-path]/planning/test-plan.md"

# Use the Write tool to create/update the file with the compiled plan.
```

### Step 6: Signal Downstream Consumers

1. Summarize key planning decisions (risk hot spots, priority areas, missing inputs) in your agent response.
2. Remind the next agent (testcase-writer) to read both `requirements.md` and `test-plan.md` before generating test cases.

---

## Deliverables

- `[ticket-path]/planning/test-plan.md` — Complete test design document derived from the template.
- Coverage matrix mapping requirement IDs → planned test cases.
- Documented test data sets and non-functional strategies for reuse during test execution.

