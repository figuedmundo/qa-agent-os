# Phase 2: Prompt Update Type

## Select Revision Type

This phase prompts the user to identify what type of update is needed.

### Variables from Phase 1

Required from previous phase:
- `TICKET_ID` - The ticket identifier
- `FEATURE_NAME` - The feature name
- `TICKET_PATH` - Path to ticket folder
- `TEST_PLAN_PATH` - Path to test-plan.md
- `CURRENT_VERSION` - Current test plan version

### Present Update Options

```
What did you discover during testing?

Update Types:
  [1] New edge case found
  [2] New test scenario needed
  [3] Existing scenario needs update
  [4] New requirement discovered
  [5] Test data needs adjustment

Choose [1-5]:
```

### Collect Update Details Based on Selection

#### Option 1: New Edge Case Found

Prompt for:
```
Edge Case Details:

1. Edge case description:
   > [User input]

2. Expected behavior (how should system handle this?):
   > [User input]

3. Priority (High/Medium/Low):
   > [User input]

4. Discovered during which test?:
   > [User input - e.g., "TC-03"]
```

Store as:
```
UPDATE_TYPE=edge_case
UPDATE_DETAILS={
  description: [description],
  expected_behavior: [behavior],
  priority: [priority],
  discovered_during: [test]
}
```

#### Option 2: New Test Scenario Needed

Prompt for:
```
New Test Scenario Details:

1. Scenario name:
   > [User input]

2. Which requirement does this cover? (RQ-XX):
   > [User input]

3. Test type (Functional/Negative/Edge/API/Integration):
   > [User input]

4. Priority (High/Medium/Low):
   > [User input]

5. Objective (what does this test?):
   > [User input]

6. Test steps (one per line):
   > [User input - multiline]

7. Expected result:
   > [User input]
```

Store as:
```
UPDATE_TYPE=new_scenario
UPDATE_DETAILS={
  name: [name],
  requirement: [RQ-XX],
  type: [type],
  priority: [priority],
  objective: [objective],
  steps: [steps array],
  expected_result: [result]
}
```

#### Option 3: Existing Scenario Needs Update

Prompt for:
```
Scenario Update Details:

1. Which scenario to update? (TC-XX):
   > [User input]

2. What needs to change?:
   > [User input - multiline]

3. Why is this change needed?:
   > [User input]
```

Store as:
```
UPDATE_TYPE=update_scenario
UPDATE_DETAILS={
  scenario_id: [TC-XX],
  changes: [changes description],
  reason: [reason]
}
```

#### Option 4: New Requirement Discovered

Prompt for:
```
New Requirement Details:

1. Requirement name:
   > [User input]

2. Description:
   > [User input - multiline]

3. Acceptance criteria (one per line):
   > [User input - multiline]

4. Priority (High/Medium/Low):
   > [User input]

5. Impact on existing test coverage:
   > [User input]
```

Store as:
```
UPDATE_TYPE=new_requirement
UPDATE_DETAILS={
  name: [name],
  description: [description],
  acceptance_criteria: [criteria array],
  priority: [priority],
  impact: [impact]
}
```

#### Option 5: Test Data Needs Adjustment

Prompt for:
```
Test Data Adjustment Details:

1. Test data set name or ID:
   > [User input]

2. What needs to change?:
   > [User input - multiline]

3. New or updated values:
   > [User input - structured data]

4. Reason for adjustment:
   > [User input]
```

Store as:
```
UPDATE_TYPE=test_data
UPDATE_DETAILS={
  data_id: [data ID],
  changes: [changes description],
  new_values: [values],
  reason: [reason]
}
```

### Set Variables for Next Phase

Pass to Phase 3:
```
TICKET_ID=[ticket-id]
FEATURE_NAME=[feature-name]
TICKET_PATH=[path]
TEST_PLAN_PATH=[path]
CURRENT_VERSION=[version]
UPDATE_TYPE=[edge_case|new_scenario|update_scenario|new_requirement|test_data]
UPDATE_DETAILS=[details object]
```

### Success Confirmation

```
Update type selected: [UPDATE_TYPE]
Details collected.

Proceeding to Phase 3: Apply Update
```

### Next Phase

Continue to Phase 3: Apply Update
