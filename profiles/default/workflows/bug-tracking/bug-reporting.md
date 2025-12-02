# Bug Reporting Workflow

This workflow guides bug report creation using the unified bug reporting standard.

## Input
- Bug context (feature, ticket, environment)
- Evidence collected by user

## Output
- Complete bug report at: `qa-agent-os/features/[feature]/[ticket]/bugs/BUG-XXX.md`

## Workflow Steps

### Step 1: Read Bug Reporting Standard

Read the comprehensive bug reporting standard for document structure, field definitions, severity rules, and analysis methodology:

**Standard:** `@qa-agent-os/standards/bugs/bug-reporting.md`

This standard contains:
- Complete document structure (all sections and fields)
- Severity classification rules (S1-S4 with criteria and examples)
- AI classification checklist (step-by-step severity determination)
- Bug analysis methodology (reproduction, isolation, scope, assessment)
- Evidence collection guidelines
- Status workflow and SLA guidelines

### Step 2: Collect Bug Information

Follow the document structure from the standard to collect:

**Bug Details:**
- Title (format: `[Component] - [Brief Summary]`)
- Summary (2-3 sentence executive overview)
- Environment (OS, browser, environment, build, feature flags)
- Component/Area

**Reproduction:**
- Preconditions
- Steps to reproduce (numbered, with specific data)
- Expected result
- Actual result
- Reproducibility (Always/Intermittent with attempts)

**Evidence** (prompt user for):
- Screenshots/recordings (required for UI issues)
- Console/browser logs (with timestamps, correlation IDs)
- API request/response (for backend issues)
- Network traces (request IDs, HAR files)
- Error messages (exact messages)
- Additional evidence

### Step 3: Classify Severity

Apply severity classification rules from the standard using AI classification checklist:

**Step 3.1: Check for S1 (Critical) Indicators**
Does the bug involve:
- Data loss/corruption?
- Security vulnerability?
- System crash/unavailability?
- Payment/financial processing broken?
- No workaround possible?
- Regulatory/compliance impact?

If YES to any → Suggest S1

**Step 3.2: Check for S2 (Major) Indicators**
Does the bug involve:
- Core feature completely broken?
- Incorrect calculations/data?
- API returning wrong values?
- Difficult/time-consuming workaround?
- Severe performance degradation?

If YES to any → Suggest S2

**Step 3.3: Check for S3 (Minor) Indicators**
Does the bug involve:
- UI/layout issues?
- Incorrect messages/labels?
- Easy workaround available?
- Limited user segment affected?

If YES to any → Suggest S3

**Step 3.4: Default to S4 (Trivial)**
If none of the above → S4

**Step 3.5: Formulate AI Justification**
Include in justification:
1. Which checklist item(s) matched
2. Evidence from bug description supporting the match
3. Impact assessment (who/what is affected)
4. Workaround availability and difficulty

**Step 3.6: Present to User with Override Option**
```
AI Severity Suggestion: [S1/S2/S3/S4]

Justification:
[AI reasoning based on checklist]

Do you accept this severity, or would you like to override it?
  [1] Accept AI suggestion
  [2] Override to different severity

If override, please provide reason:
```

Record user decision and override reason (if any) for tracking.

### Step 4: Perform Bug Analysis

Apply bug analysis methodology from the standard:

**Reproduction Analysis:**
- Can you reproduce with provided steps?
- Variations tried?
- Reproducibility rate captured?

**Cause Isolation:**
- Which component likely responsible?
- Frontend/backend/data issue?
- Relevant logs/errors identified?
- Feature flags, configs, recent deployments contributing?

**Scope Determination:**
- All users or specific segments affected?
- Is it a regression?
- Impacted releases/environments/builds?

**Analysis Output:**
- Root cause hypothesis
- Affected areas (features/users/systems)
- Related items (requirements, test cases, similar bugs)

### Step 5: Generate Bug Report

Create bug report document following the structure from the standard:

**File Path:** `[ticket-path]/bugs/BUG-[auto-increment].md`

**Auto-increment Logic:**
```bash
# Find existing bugs in ticket folder
EXISTING_BUGS=$(ls [ticket-path]/bugs/BUG-*.md 2>/dev/null | wc -l)
NEW_BUG_ID=$(printf "BUG-%03d" $((EXISTING_BUGS + 1)))
```

**Document Content:**
Apply all sections from bug-reporting.md standard:
1. Metadata (Bug ID, Feature, Ticket, Created, Version, Status)
2. Bug Details (Title, Summary, Environment, Component)
3. Reproduction (Preconditions, Steps, Expected, Actual, Reproducibility)
4. Classification (Severity, Priority, Justification, AI Suggestion tracking)
5. Evidence (all collected evidence with proper formatting)
6. Analysis (Root cause hypothesis, Affected areas, Related items)
7. Status Workflow (Current status, Status history table)
8. Ownership (Reporter, Assignee, QA Verifier)
9. Developer Notes (reserved section)
10. Revision Log (Version 1.0 entry)
11. References (Feature knowledge, test plan, test cases)

**Evidence Storage:**
Store evidence files in: `[ticket-path]/bugs/evidence/BUG-XXX-[description].[ext]`

### Step 6: Completion

Output confirmation message:

```
Bug report created successfully!

Bug ID: BUG-XXX
Severity: [S1/S2/S3/S4] ([AI Suggested/User Overridden])
Priority: [P1/P2/P3/P4]
Status: New

Location: [ticket-path]/bugs/BUG-XXX.md
Evidence: [N] files stored in [ticket-path]/bugs/evidence/

NEXT STEPS:
- Developer: Investigate root cause using evidence and analysis
- QA: Update status as bug progresses through workflow
- Use /revise-bug BUG-XXX to update this report

Workflow: New → In Progress → Ready for QA → Verified → Closed
```

---

## Standard Reference

All document structure, field definitions, severity rules, and analysis methodology are defined in:

**Standard:** `@qa-agent-os/standards/bugs/bug-reporting.md`

This workflow implements the standard without duplicating its content.

---

*This workflow replaces template-based bug report generation with standard-based generation, eliminating duplication.*
