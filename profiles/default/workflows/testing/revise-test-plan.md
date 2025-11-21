# Revise Test Plan Workflow

This workflow updates test-plan.md when new information is discovered during testing, including new edge cases, scenarios, requirements, or test data adjustments.

## Core Responsibilities

1. **Identify Update Type**: Determine what type of change is needed
2. **Apply Updates**: Modify appropriate sections of test-plan.md
3. **Track Revisions**: Add revision log entry with version increment
4. **Maintain Traceability**: Document why the change was made

**Note:** The placeholder `[ticket-path]` refers to the full path like `qa-agent-os/features/feature-name/ticket-id`. The placeholder `[update-type]` refers to the type of update being made. The placeholder `[update-details]` contains the actual update information.

---

## Workflow

### Step 1: Read Current Test Plan

Read `[ticket-path]/test-plan.md` to understand:
- Current version number (from Section 11: Revision History)
- Existing requirements (Section 4)
- Current coverage matrix (Section 5)
- Existing test scenarios (Section 6)
- Current test data (Section 7)

### Step 2: Determine Current Version

Extract current version from Section 11 (Revision History):
- Look for the latest version entry (e.g., "Version 1.2")
- Parse version number (major.minor)
- Calculate next version: increment minor version (1.2 → 1.3)

Store as `[next-version]`.

### Step 3: Process Update Based on Type

Based on `[update-type]`, update the appropriate sections:

#### Type 1: New Edge Case Found

From `[update-details]`, extract:
- Edge case description
- Expected behavior
- Priority (High/Medium/Low)
- When discovered (during which test)

**Update Section 4 (Testable Requirements):**
Add new requirement:
```markdown
#### RQ-[Next Number]: [Edge Case Name]

**Description:** [Edge case description]

**Expected Behavior:** [How system should handle this case]

**Priority:** [High/Medium/Low]

**Source:** Discovered during testing
**Discovery Date:** [YYYY-MM-DD]
**Discovery Context:** [Which test case revealed this]
```

**Update Section 5 (Test Coverage Matrix):**
Add row to coverage table:
```
| RQ-[Number] | [Edge Case Name] | [Priority] | [ ] | TC-[Number] |
```

**Update Section 6 (Test Scenarios & Cases):**
Add new test scenario:
```markdown
#### TC-[Next Number]: [Edge Case Test Scenario]

**Type:** Edge Case Test
**Priority:** [High/Medium/Low]
**Requirement:** RQ-[Number]

**Objective:** [Test this edge case]

**Steps:**
1. [Setup edge case condition]
2. [Execute action]
3. [Verify expected behavior]

**Expected Result:** [Expected behavior from edge case]
```

#### Type 2: New Test Scenario Needed

From `[update-details]`, extract:
- Scenario description
- Test steps
- Expected outcome
- Which requirement this covers
- Priority

**Update Section 5 (Test Coverage Matrix):**
Update existing requirement row to add new test case ID

**Update Section 6 (Test Scenarios & Cases):**
Add new test scenario:
```markdown
#### TC-[Next Number]: [Scenario Name]

**Type:** [Functional|Negative|Edge|API|Integration]
**Priority:** [High/Medium/Low]
**Requirement:** RQ-[Number]

**Objective:** [What this scenario tests]

**Preconditions:**
- [Precondition 1]
- [Precondition 2]

**Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Result:** [Expected outcome]
```

#### Type 3: Existing Scenario Needs Update

From `[update-details]`, extract:
- Which scenario to update (TC-number)
- What needs changing
- Why the change is needed

**Update Section 6 (Test Scenarios & Cases):**
Locate the existing scenario and update it:
- Modify steps, expected results, or preconditions
- Add note about the update

Example:
```markdown
#### TC-05: [Scenario Name]

[Updated content]

**Updated [YYYY-MM-DD]:** [Description of what changed]
**Reason:** [Why the change was needed]
```

#### Type 4: New Requirement Discovered

From `[update-details]`, extract:
- Requirement description
- Business rule or acceptance criterion
- Priority
- Impact on existing tests

**Update Section 4 (Testable Requirements):**
Add new requirement:
```markdown
#### RQ-[Next Number]: [Requirement Name]

**Description:** [Requirement details]

**Acceptance Criteria:**
- [Criterion 1]
- [Criterion 2]

**Priority:** [High/Medium/Low]

**Source:** Discovered during testing
**Discovery Date:** [YYYY-MM-DD]
**Impact:** [Impact on existing test coverage]
```

**Update Section 5 (Test Coverage Matrix):**
Add row for new requirement:
```
| RQ-[Number] | [Requirement Name] | [Priority] | [ ] | To be created |
```

**Note:** New test scenarios for this requirement should be added separately (Type 2 update).

#### Type 5: Test Data Needs Adjustment

From `[update-details]`, extract:
- Test data ID or description
- New values or modifications
- Reason for adjustment

**Update Section 7 (Test Data Requirements):**
Locate existing test data and update, or add new test data:
```markdown
### [Test Data Set Name]

**Purpose:** [What this data tests]

**Data:**
```json
[Updated test data structure]
```

**Updated [YYYY-MM-DD]:** [Description of changes]
**Reason:** [Why test data needed adjustment]
```

### Step 4: Add Revision Log Entry

**Update Section 11 (Revision History):**
Append new revision entry at the top of the history:

```markdown
### Version [next-version] - [YYYY-MM-DD HH:MM]

**Changes:**
- [Change 1 description]
- [Change 2 description]

**Reason:** [Why these changes were made]

**Discovered During:** [Which test execution or testing phase]

**Updated By:** [User or team name]

---
```

### Step 5: Update Version Metadata

At the top of test-plan.md, update:
```markdown
**Version:** [next-version]
**Last Updated:** [YYYY-MM-DD HH:MM]
```

### Step 6: Verify Test Plan Structure

Ensure:
- All 11 sections are still present
- Section numbering is correct
- Coverage matrix is updated if requirements changed
- Test scenarios reference correct requirement IDs
- Revision history is in reverse chronological order (newest first)
- Version numbers are incremented correctly

### Step 7: Completion

Display summary:
```
Test plan revised successfully!

Updated: [ticket-path]/test-plan.md

Version: [previous-version] → [next-version]

Changes made:
- [Change type]: [Brief description]
- Section(s) updated: [List of sections]
- Revision log entry added

Reason: [Why the update was made]

Next Steps:
Would you like to regenerate test cases to reflect these updates? [y/n]
```

If user answers yes, prepare to trigger test case regeneration (handled by command orchestration, not this workflow).

---

## Revision History Format

Each revision entry should follow this format:

```markdown
### Version X.Y - YYYY-MM-DD HH:MM

**Changes:**
- Added edge case: [Edge case name]
- New requirement: RQ-XX
- New test scenario: TC-XX
- Updated test scenario TC-YY: [What changed]
- Adjusted test data: [What changed]

**Reason:** [Why these changes were made]

**Discovered During:** [Context of discovery - e.g., "Manual testing of TC-03", "Integration testing phase", "Stakeholder feedback"]

**Updated By:** [Person or team]

---
```

## Version Numbering

- **Major version (X.0)**: Complete test plan rewrite or major restructuring
- **Minor version (X.Y)**: Incremental updates during testing (most common)
  - New edge cases discovered: +0.1
  - New scenarios added: +0.1
  - Requirement changes: +0.1
  - Test data adjustments: +0.1

Example progression: 1.0 → 1.1 → 1.2 → 1.3

## Important Notes

### When to Use This Workflow

Use during testing when you discover:
- Edge cases not covered in original plan
- Missing test scenarios
- Changed requirements
- Needed test data adjustments
- Errors or gaps in existing scenarios

### Traceability

Every revision should include:
- What changed (specific sections and items)
- Why it changed (reason, discovery context)
- When it changed (timestamp)
- Who made the change (user or team)

This creates a complete audit trail of test plan evolution.
