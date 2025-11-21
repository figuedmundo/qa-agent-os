# /generate-testcases Command (Multi-Agent Mode)

## Purpose

Generate or regenerate detailed test cases from a test plan using the testcase-writer agent. This command provides flexible test case generation with smart conflict detection.

## Usage

```bash
/generate-testcases              # Interactive - select which ticket
/generate-testcases WYX-123      # Direct - generate for specific ticket
```

## Execution Flow

### PHASE 1: Select Ticket

This phase handles ticket identification. Orchestration logic remains in the main command:

#### If Ticket ID Provided as Parameter

```bash
# User ran: /generate-testcases WYX-123
TICKET_ID="WYX-123"
```

Skip to Phase 2.

#### If No Parameter Provided (Interactive Mode)

Scan for recent tickets and present selection:

```bash
# Find all ticket folders
TICKETS=$(find qa-agent-os/features/ -mindepth 2 -maxdepth 2 -type d)

# Sort by most recently modified
# Display numbered list
```

Present to user:

```
Recent tickets:
  [1] WYX-123 - Last modified: 2025-11-20
  [2] WYX-122 - Last modified: 2025-11-19
  [3] WYX-121 - Last modified: 2025-11-18

Select ticket [1-3]:
```

User selects ticket, set TICKET_ID for next phase.

#### Validate Ticket and Test Plan

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

### PHASE 2: Detect Conflicts

This phase checks for existing test cases and handles conflicts. Orchestration logic remains in the main command:

#### Check for Existing Test Cases

```bash
TEST_CASES_FILE="$TICKET_PATH/test-cases.md"

if [ -f "$TEST_CASES_FILE" ]; then
    CONFLICT=true
else
    CONFLICT=false
fi
```

#### Handle Conflict (If Exists)

If CONFLICT is true, prompt user:

```
Test cases already exist for [ticket-id].

Choose an option:
  [1] Overwrite - Replace existing test cases completely
  [2] Append - Add new test cases to existing ones
  [3] Cancel - Stop without making changes

Select [1-3]:
```

Store user's choice as MODE:
- Option [1] → MODE="overwrite"
- Option [2] → MODE="append"
- Option [3] → Exit command

#### No Conflict

If CONFLICT is false:
- Set MODE="create"

Proceed to Phase 3.

### PHASE 3: Generate Test Cases

Use the **testcase-writer** subagent to generate comprehensive test cases.

Provide the testcase-writer with:
- Ticket path: `[ticket-path]` (e.g., `qa-agent-os/features/feature-name/TICKET-123`)
- Test plan path: `[ticket-path]/test-plan.md`
- Generation mode: [create|overwrite|append] (from Phase 2)
- Visual assets: `[ticket-path]/documentation/` (if any mockups or screenshots exist)

The testcase-writer will:
- Read test-plan.md to extract test scenarios and coverage requirements
- Extract from test plan:
  - Section 5: Test Coverage Matrix (requirement → test case mapping)
  - Section 6: Test Scenarios & Cases (positive, negative, edge cases)
  - Section 7: Test Data Requirements
  - Section 4: Testable Requirements (detailed requirements breakdown)
- Generate detailed executable test cases with structure:
  - Test case ID: [TICKET-ID]-TC-[NUMBER]
  - Test case type: [Functional|Negative|Edge|API|Integration]
  - Priority: [High|Medium|Low] based on requirement priority
  - Clear objective
  - Preconditions
  - Detailed steps in table format:
    | Step | Action | Expected Result |
  - Test data references (from Section 7)
  - Expected final result
  - Execution tracking checkboxes:
    - [ ] Pass
    - [ ] Fail
    - [ ] Blocked
  - Space for notes and defect links
- Perform coverage analysis:
  - Compare generated test cases against coverage matrix
  - Verify all requirements have at least one test case
  - Verify positive, negative, and edge cases are covered
  - Flag any coverage gaps
- Add automation recommendations:
  - API tests: High automation priority
  - Repetitive functional tests: Medium automation priority
  - Exploratory tests: Low automation priority
- Save to `[ticket-path]/test-cases.md` with complete structure:
  - Test Execution Summary table
  - Detailed Test Cases section
  - Test Data Reference
  - Coverage Analysis
  - Automation Recommendations
- Respect MODE variable:
  - create: Write new file
  - overwrite: Replace existing file completely
  - append: Add new test cases to existing file (update summary table)
- Execute workflow: `workflows/testing/testcase-generation`

### Completion

Once testcase-writer completes:

```
✓ Test cases generated successfully!

Output: qa-agent-os/features/[feature-name]/[ticket-id]/test-cases.md

NEXT STEPS:
- Review test cases for completeness
- Execute tests and track results using the checkboxes
- Update test cases as needed during testing
- Report bugs using /report-bug (when available)
```

## Smart Features

This multi-agent command includes:

1. **Smart Ticket Selection** - Interactive mode for easy selection or direct parameter
2. **Conflict Detection** - Offers overwrite/append/cancel options when test cases exist
3. **Flexible Generation Modes** - Create new, overwrite, or append to existing test cases
4. **Coverage Analysis** - Verifies all requirements are covered by test cases
5. **Automation Recommendations** - Identifies which tests are good automation candidates

## Related Commands

- `/plan-ticket` - Plan testing for a ticket (creates test-plan.md)
- `/revise-test-plan` - Update test plan during testing
- `/update-feature-knowledge` - Manually update feature knowledge

---

*This command leverages the testcase-writer agent to efficiently generate comprehensive test cases with expert domain knowledge.*
