# /revise-test-plan Command (Multi-Agent Mode)

## Purpose

Update test plans during testing when new scenarios, edge cases, or requirements are discovered using specialized agents.

## Usage

```bash
/revise-test-plan              # Interactive - select ticket
/revise-test-plan WYX-123      # Direct - revise specific ticket
```

## When to Use

- **During test execution** - Found edge case not in plan
- **After requirement change** - Development team updated requirement
- **New test scenario** - Discovered interaction pattern needed
- **Test data adjustment** - Need special test data setup
- **Existing scenario update** - Need to refine approach

## Execution Flow

### PHASE 1: Detect Ticket

This phase handles ticket identification. Orchestration logic remains in the main command:

#### If Ticket ID Provided as Parameter

```bash
# User ran: /revise-test-plan WYX-123
TICKET_ID="WYX-123"
```

Skip to Phase 2.

#### If No Parameter Provided (Interactive Mode)

Scan for tickets with test plans and present selection:

```bash
# Find all ticket folders with test-plan.md
TICKETS_WITH_PLANS=$(find qa-agent-os/features/ -name "test-plan.md" -exec dirname {} \;)

# Sort by most recently modified
# Display numbered list
```

Present to user:

```
Tickets with test plans:
  [1] WYX-123 - Last modified: 2025-11-20
  [2] WYX-122 - Last modified: 2025-11-19
  [3] WYX-121 - Last modified: 2025-11-18

Select ticket [1-3]:
```

User selects ticket, set TICKET_ID for next phase.

#### Validate Test Plan Exists

Verify the selected ticket has a test plan:

```bash
FEATURE_PATH=$(dirname $(find qa-agent-os/features/ -type d -name "$TICKET_ID"))
TICKET_PATH="$FEATURE_PATH/$TICKET_ID"
TEST_PLAN="$TICKET_PATH/test-plan.md"
```

If test plan doesn't exist:

```
Error: No test plan found for [ticket-id]

Run /plan-ticket [ticket-id] first to create the test plan.
```

Exit command.

Proceed to Phase 2.

### PHASE 2: Prompt Update Type

This phase gathers update details from user. Orchestration logic remains in the main command:

#### Present Update Type Options

Prompt user to select update type:

```
What type of update are you making to the test plan?

Update Types:
  [1] New edge case found
  [2] New test scenario needed
  [3] Existing scenario needs update
  [4] New requirement discovered
  [5] Test data needs adjustment

Select [1-5]:
```

Store user's selection as UPDATE_TYPE:
- Option [1] → UPDATE_TYPE="new_edge_case"
- Option [2] → UPDATE_TYPE="new_scenario"
- Option [3] → UPDATE_TYPE="update_scenario"
- Option [4] → UPDATE_TYPE="new_requirement"
- Option [5] → UPDATE_TYPE="test_data"

#### Gather Update Details

Prompt user for update details:

```
Describe the update:

[User provides detailed description]
```

Store user's description as UPDATE_DETAILS.

Proceed to Phase 3.

### PHASE 3: Apply Update

Use the **requirement-analyst** subagent to update the test plan.

Provide the requirement-analyst with:
- Ticket path: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Test plan path: `[ticket-path]/test-plan.md`
- Update type: [new_edge_case|new_scenario|update_scenario|new_requirement|test_data]
- Update details: [user's description from Phase 2]
- Current date and time: [timestamp]

The requirement-analyst will:
- Read current test-plan.md to understand existing structure
- Read current revision log (Section 11) to get current version
- Apply the update to the appropriate section(s):
  - new_edge_case → Update Section 6 (Test Scenarios) with edge case
  - new_scenario → Add to Section 6 (Test Scenarios & Cases)
  - update_scenario → Modify existing scenario in Section 6
  - new_requirement → Update Section 4 (Testable Requirements) and Section 5 (Coverage Matrix)
  - test_data → Update Section 7 (Test Data Requirements)
- Increment version number (e.g., 1.0 → 1.1 for minor, 1.0 → 2.0 for major)
- Add revision log entry to Section 11 with format:
  ```markdown
  **Version X.Y - [date] [time]**
  - Change: [update description]
  - Type: [update type]
  - Impact: [impact on test coverage]
  - Reason: [why this change was needed]
  ```
- Save updated test-plan.md with all changes
- Execute workflow: `workflows/testing/revise-test-plan`

### PHASE 4: Optional Regeneration

After requirement-analyst completes, prompt user:

```
Test plan updated successfully!

New version: [X.Y]
Updated sections: [list of sections modified]

Would you like to regenerate test cases now? [y/n]
```

Store user's choice:
- If "y" → Proceed to regenerate test cases
- If "n" → Skip to completion

#### If User Chose to Regenerate

Use the **testcase-writer** subagent to regenerate test cases.

Provide the testcase-writer with:
- Ticket path: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Test plan path: `[ticket-path]/test-plan.md` (updated version)
- Generation mode: overwrite (replace existing test cases with updated version)
- Visual assets: `[ticket-path]/documentation/` (if any)

The testcase-writer will:
- Read updated test-plan.md
- Regenerate all test cases based on updated scenarios and requirements
- Save to `[ticket-path]/test-cases.md`
- Execute workflow: `workflows/testing/testcase-generation`

### Completion

Once all phases complete:

If test cases regenerated:
```
✓ Test plan revised successfully!

Updated:
- Test plan: qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md
  - New version: [X.Y]
  - Updated sections: [list]
- Test cases: qa-agent-os/features/[feature-name]/[ticket-id]/test-cases.md (regenerated)

NEXT STEPS:
- Review updated test plan and test cases
- Continue test execution with new coverage
```

If test cases not regenerated:
```
✓ Test plan revised successfully!

Updated:
- Test plan: qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md
  - New version: [X.Y]
  - Updated sections: [list]

NEXT STEPS:
- Review updated test plan
- Run /generate-testcases [ticket-id] to regenerate test cases when ready
```

## Revision Types

### 1. New Edge Case
- Boundary value discovered
- Special condition handling
- Extreme value behavior

### 2. New Test Scenario
- User flow not covered
- Integration pattern
- Interaction sequence

### 3. Existing Scenario Update
- Test approach refinement
- Changed expected behavior
- Additional test steps

### 4. New Requirement
- Business rule change
- New API endpoint
- Technical requirement

### 5. Test Data Adjustment
- Special data setup needed
- Boundary data values
- Data dependency

## Smart Features

This multi-agent command includes:

1. **Version Tracking** - Automatic version increments with each revision
2. **Timestamped Updates** - Always know when changes were made
3. **Reasoned Changes** - Explains why changes occurred in revision log
4. **Integrated Regeneration** - Can regenerate test cases automatically
5. **Modular Updates** - Update only affected sections

## Related Commands

- `/plan-ticket` - Creates initial test plan
- `/generate-testcases` - Generate or regenerate test cases
- `/plan-feature` - Feature context

---

*This command leverages the requirement-analyst agent (and optionally testcase-writer) to efficiently revise test plans with expert domain knowledge and proper version tracking.*
