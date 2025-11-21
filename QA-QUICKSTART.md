# QA Workflow Quickstart Guide

This guide shows you how to use the new QA Agent OS workflow commands to efficiently plan features and tickets for comprehensive testing.

## The 5 Commands Overview

QA Agent OS now provides 5 orchestrated commands that cover the complete QA planning workflow:

1. **`/plan-feature`** - Plan an entire feature at once (4 phases)
2. **`/plan-ticket`** - Plan ticket testing with smart feature detection (3-4 phases)
3. **`/generate-testcases`** - Generate or regenerate test cases from a test plan
4. **`/revise-test-plan`** - Update test plans during testing with gap detection
5. **`/update-feature-knowledge`** - Manually update feature knowledge (rare)

## Typical Workflow

### Step 1: Plan Your Feature

Start with `/plan-feature` to establish what you're testing:

```bash
/plan-feature "User Authentication"
```

This command:
1. Creates the feature folder structure
2. Gathers documentation (BRD, API specs, mockups, etc.)
3. Consolidates knowledge into `feature-knowledge.md`
4. Creates a test strategy in `feature-test-strategy.md`

**Files Created:**
```
features/user-authentication/
├── documentation/
│   ├── brd.md (or your uploaded documents)
│   ├── api-specs.md
│   ├── mockups/ (folder for screenshots)
│   └── COLLECTION_LOG.md (what was gathered)
├── feature-knowledge.md (8 sections: overview, requirements, tech, UX, edge cases, etc.)
└── feature-test-strategy.md (10 sections: testing approach, tools, environment, risks, etc.)
```

### Step 2: Plan Your First Ticket

Create a test plan for a specific ticket:

```bash
/plan-ticket AUTH-125
```

This command:
1. Detects your feature automatically (or lets you choose if multiple exist)
2. Gathers ticket-specific documentation
3. Analyzes requirements and checks for gaps in feature knowledge
4. Creates `test-plan.md` with testable requirements
5. Optionally generates detailed test cases

**Files Created:**
```
features/user-authentication/AUTH-125/
├── documentation/
│   ├── ticket-details.md
│   ├── acceptance-criteria.md
│   └── visuals/
│       └── mockups and screenshots
├── test-plan.md (11 sections: overview, scope, requirements, coverage matrix, scenarios, data, timeline, etc.)
└── test-cases.md (if generated) - detailed executable test cases
```

### Step 3: Generate Test Cases (if needed)

If you chose to stop after test-plan in Step 2, generate cases later:

```bash
/generate-testcases AUTH-125
```

Or let it prompt for selection if you run it without parameters:

```bash
/generate-testcases
```

**Options when test-cases.md already exists:**
- Overwrite: Regenerate completely
- Append: Add new cases, keep existing
- Cancel: Don't change anything

### Step 4: Refine During Testing

As you execute tests and discover new edge cases or requirements:

```bash
/revise-test-plan AUTH-125
```

Choose what you discovered:
- New edge case found
- New test scenario needed
- Existing scenario needs update
- New requirement discovered
- Test data needs adjustment

The command updates test-plan.md with a revision log entry and offers to regenerate test cases.

### Step 5: Plan Additional Tickets

For the second ticket in your feature:

```bash
/plan-ticket AUTH-126
```

The command will:
1. Auto-detect the "user-authentication" feature
2. Analyze requirements against existing feature-knowledge.md
3. Detect any gaps (new flows, new rules, new API endpoints)
4. Ask if you want to append new information to feature-knowledge.md
5. Generate test-plan.md for the new ticket

This ensures your feature knowledge stays current!

## Folder Structure Example

After planning a feature with 2 tickets, you'll have:

```
features/
└── user-authentication/
    ├── documentation/
    │   ├── brd-v2.md
    │   ├── api-specifications.md
    │   ├── mockups/
    │   │   ├── login-screen.png
    │   │   └── register-screen.png
    │   └── COLLECTION_LOG.md
    ├── feature-knowledge.md
    ├── feature-test-strategy.md
    ├── AUTH-125/
    │   ├── documentation/
    │   │   ├── jira-export.md
    │   │   └── visuals/
    │   │       └── updated-mockups.png
    │   ├── test-plan.md (v1.0)
    │   └── test-cases.md
    └── AUTH-126/
        ├── documentation/
        │   ├── acceptance-criteria.md
        │   └── visuals/
        ├── test-plan.md (v1.0)
        └── test-cases.md
```

## Command Details

### /plan-feature [feature-name]

**Purpose:** Complete feature planning in one command

**Usage:**
```bash
/plan-feature "Payment Processing"
/plan-feature payment-processing
/plan-feature TWRR  # Initialism OK
```

**Phases:**
1. Initialize folder structure
2. Gather documentation (BRD, API specs, mockups, technical docs)
3. Consolidate knowledge into feature-knowledge.md
4. Create feature-test-strategy.md with testing approach

**Creates:**
- Feature folder structure
- documentation/ subdirectory
- feature-knowledge.md (consolidates WHAT is being built)
- feature-test-strategy.md (defines HOW feature will be tested)

### /plan-ticket [ticket-id]

**Purpose:** Plan a ticket with intelligent feature detection and gap detection

**Usage:**
```bash
/plan-ticket AUTH-125
/plan-ticket "AUTH-125"
/plan-ticket  # Prompts for selection if ambiguous
```

**Smart Detection:**
- If ticket already exists, offers 4 options:
  - [1] Full re-plan (gather docs again, re-analyze, regenerate cases)
  - [2] Update test plan only (re-analyze requirements)
  - [3] Regenerate test cases only (use existing test-plan.md)
  - [4] Cancel

**Gap Detection:**
- Compares ticket requirements to feature-knowledge.md
- Identifies new business rules, APIs, edge cases
- Prompts to append gaps to feature knowledge

**Flexible Execution:**
- After test-plan.md created, choose:
  - [1] Generate test cases now
  - [2] Stop here (review plan first, generate later)

**Creates:**
- Ticket folder structure
- documentation/ with visuals/ subdirectory
- test-plan.md (consolidates requirements for THIS ticket)
- test-cases.md (if option 1 selected)

### /generate-testcases [ticket-id]

**Purpose:** Generate or regenerate test cases from a test-plan.md

**Usage:**
```bash
/generate-testcases AUTH-125
/generate-testcases  # Prompts for selection
```

**Options for existing test-cases.md:**
- [1] Overwrite (regenerate completely)
- [2] Append (add new cases, keep existing ones)
- [3] Cancel

**When to Use:**
- After reviewing and updating test-plan.md
- To regenerate with updated test data
- Standalone if you stopped after /plan-ticket Phase 3

### /revise-test-plan [ticket-id]

**Purpose:** Update test-plan.md during testing when discovering new information

**Usage:**
```bash
/revise-test-plan AUTH-125
/revise-test-plan  # Prompts for selection
```

**Update Types:**
- [1] New edge case found - Add new scenario for unexpected input
- [2] New test scenario needed - Add new valid flow
- [3] Existing scenario needs update - Modify a current scenario
- [4] New requirement discovered - Add requirement not in original ticket
- [5] Test data needs adjustment - Update test data values

**Updates:**
- Appends revision log entry with version increment
- Updates test-plan.md sections based on change type
- Offers to regenerate test-cases.md with new scenarios

### /update-feature-knowledge [feature-name]

**Purpose:** Manually update feature-knowledge.md (rare - usually updated automatically via gap detection)

**Usage:**
```bash
/update-feature-knowledge "User Authentication"
/update-feature-knowledge  # Prompts for selection
```

**Update Types:**
- [1] Add new business rule
- [2] Add new API endpoint
- [3] Update existing information
- [4] Add edge case documentation
- [5] Add open question

## Common Scenarios

### Scenario 1: Brand New Feature

```bash
# Step 1: Create the feature
/plan-feature "OAuth 2.0 Integration"

# Step 2: Gather all documentation (your input during command)
# Step 3: System creates feature-knowledge.md and feature-test-strategy.md

# Step 4: Plan first ticket
/plan-ticket OAUTH-100

# Step 5: System detects feature, gathers docs, creates test-plan.md
# Step 6: Choose to generate test-cases.md now or later
```

### Scenario 2: Discovered New Edge Case During Testing

```bash
# You're testing AUTH-125 and find a bug
# You realize this is a new edge case, not in test-plan.md

/revise-test-plan AUTH-125
# Choose: [1] New edge case found
# Describe the edge case
# Answer: Do you want to regenerate test cases? [y]
# Now test-cases.md includes tests for this edge case
```

### Scenario 3: Second Ticket Reveals New API Endpoint

```bash
# First ticket: AUTH-125 - Basic login
/plan-ticket AUTH-125
# System creates test-plan.md with /auth/login endpoint

# Second ticket: AUTH-126 - Social login
/plan-ticket AUTH-126
# System detects new /auth/social-login endpoint not in feature-knowledge.md
# System asks: "I found new information not in feature-knowledge.md:
#             - New API endpoint: /auth/social-login
#             Would you like me to append this? [y/n]"
# Answer: [y]
# System updates feature-knowledge.md with new API section
```

### Scenario 4: Need to Review Plan Before Generating Cases

```bash
# Create ticket planning
/plan-ticket AUTH-125
# After Phase 3, system asks:
# "Test plan created. Continue to Phase 4? [1] Yes [2] No"
# Answer: [2] No

# Later, after reviewing test-plan.md
/generate-testcases AUTH-125
# System generates test-cases.md
```

## Expected Outputs

### feature-knowledge.md Structure (8 sections)

```markdown
# Feature Knowledge: [Feature Name]

## 1. Feature Overview
[What is this feature? Business context and goals]

## 2. Business Requirements
[Specific business rules, calculations, workflows]

## 3. Technical Requirements
[API contracts, data structures, integrations]

## 4. User Experience
[UI flows, states, user interactions]

## 5. Edge Cases & Constraints
[Boundary conditions, error states, limitations]

## 6. Test Considerations
[Special testing needs, performance requirements]

## 7. Open Questions
[Ambiguities, decisions needed]

## 8. Document Sources
[References to collected documentation]
```

### feature-test-strategy.md Structure (10 sections)

```markdown
# Test Strategy: [Feature Name]

## Testing Objective
[High-level testing goals]

## Test Approach
[Levels, types, coverage strategy]

## Test Environment & Tools
[Where and with what we test]

## Test Data Strategy
[Data requirements and generation]

## Automation Strategy
[What to automate, what to keep manual]

## Non-Functional Requirements
[Performance, security, accessibility, etc.]

## Risk Assessment
[Key risks and mitigation]

## Entry & Exit Criteria
[When to start/stop testing]

## Deliverables
[What test artifacts will be created]

## Roles & Responsibilities
[Who does what]
```

### test-plan.md Structure (11 sections)

```markdown
# Test Plan: [Ticket ID] - [Ticket Title]

## 1. References
[Links to feature-knowledge.md, feature-test-strategy.md, requirements]

## 2. Ticket Overview
[What this ticket is testing]

## 3. Test Scope
[What's in scope, what's out]

## 4. Testable Requirements
[Requirements table with ID, summary, inputs, expected outputs]

## 5. Test Coverage Matrix
[Matrix showing requirements → test cases mapping]

## 6. Test Scenarios & Cases
[Positive, negative, edge, and dependency failure cases]

## 7. Test Data Requirements
[Data IDs and sample values needed]

## 8. Environment Setup
[Configuration needed for testing]

## 9. Execution Timeline
[When this will be tested]

## 10. Entry/Exit Criteria
[When ready to start, when ready to finish]

## 11. Revisions
[Version log with changes over time]
```

### test-cases.md Structure

```markdown
# Test Cases: [Ticket ID]

## Test Execution Summary
[Table: Not Started | Passed | Failed | Blocked | Total]

---

## Test Case 1: [TC-001]
- **Type:** Functional
- **Priority:** High
- **Requirement:** [Requirement ID]
- **Objective:** [What we're testing]
- **Preconditions:** [Initial state]
- **Test Data:** [Data to use]
- **Test Steps:** [Step | Action | Expected Result]
- **Expected Final Result:** [Expected outcome]
- **Actual Result:** [To fill during execution]
- **Notes:** [Optional notes]
- **Defects:** [Any bugs found]

[Repeat for each test case...]

## Test Data Reference
[Data IDs and their values]

## Automation Candidates
[Which tests are good for automation]
```

## Tips & Best Practices

1. **Start with /plan-feature** - Get the feature context right before planning tickets
2. **Save your test-plan.md before generating cases** - Review it first
3. **Use /revise-test-plan during execution** - Don't wait until the end to discover gaps
4. **Keep documentation updated** - Gap detection helps feature-knowledge.md stay current
5. **Reuse test data** - Define data in test-plan.md section 7, reference in test-cases.md
6. **Link to requirements** - Use requirement IDs consistently across plan and cases

## Troubleshooting

### "No features found" when running /plan-ticket

**Solution:** Run `/plan-feature` first to create a feature structure

### "Feature [name] already exists. Re-plan?" prompt on /plan-feature

**Solution:** Choose [1] to re-plan (gather new docs, update knowledge) or [2] to cancel

### Test cases don't match my updated test plan

**Solution:** Run `/generate-testcases` again to regenerate from updated plan

### Missing important information in feature-knowledge.md

**Solution:** Run `/update-feature-knowledge` or create a new ticket with `/plan-ticket` and let gap detection update it

### Want to restart planning a ticket

**Solution:** Run `/plan-ticket` on the same ticket ID and choose option [1] Full re-plan

## Next Steps

1. Read the detailed command specifications in `agent-os/specs/2025-11-20-qa-workflow-redesign/spec.md`
2. Review the command source files in `profiles/default/commands/plan-feature/`, `plan-ticket/`, etc.
3. Check out the templates in `qa-agent-os/templates/` for formatting and structure
4. Review existing features in `qa-agent-os/features/` to see examples

## Getting Help

- Read this quickstart for typical workflows
- Check the command help within each command for detailed options
- Review spec.md for comprehensive specifications
- Look at templates to understand expected document structure
