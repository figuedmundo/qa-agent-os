# Phase 2: Prompt Update Type

## Select Update Type

This phase prompts the user to identify what type of update is needed for feature knowledge.

### Variables from Phase 1

Required from previous phase:
- `FEATURE_NAME` - The feature identifier
- `FEATURE_PATH` - Path to feature folder
- `FEATURE_KNOWLEDGE_PATH` - Path to feature-knowledge.md

### Present Update Options

```
What would you like to update?

Update Types:
  [1] Add new business rule
  [2] Add new API endpoint
  [3] Update existing information
  [4] Add edge case documentation
  [5] Add open question

Choose [1-5]:
```

### Collect Update Details Based on Selection

#### Option 1: Add New Business Rule

Prompt for:
```
New Business Rule Details:

1. Rule name:
   > [User input]

2. Rule description:
   > [User input - multiline]

3. Conditions/triggers for this rule:
   > [User input - multiline]

4. Exceptions (if any):
   > [User input - multiline]

5. Example of rule application:
   > [User input]

6. Who validated this rule?:
   > [User input - e.g., "Product Owner", "Stakeholder name"]

7. Reason for adding this rule:
   > [User input]
```

Store as:
```
UPDATE_TYPE=business_rule
UPDATE_DETAILS={
  name: [name],
  description: [description],
  conditions: [conditions],
  exceptions: [exceptions],
  example: [example],
  validated_by: [validator],
  reason: [reason]
}
```

#### Option 2: Add New API Endpoint

Prompt for:
```
New API Endpoint Details:

1. HTTP method and path (e.g., "GET /api/users/profile"):
   > [User input]

2. Purpose (what does this endpoint do?):
   > [User input]

3. Request format (JSON structure):
   > [User input - multiline]

4. Response format (JSON structure):
   > [User input - multiline]

5. Use cases:
   > [User input - multiline]

6. Integration points (what calls this?):
   > [User input]

7. Reason for documenting this endpoint:
   > [User input]
```

Store as:
```
UPDATE_TYPE=api_endpoint
UPDATE_DETAILS={
  method_path: [method and path],
  purpose: [purpose],
  request_format: [request],
  response_format: [response],
  use_cases: [use cases array],
  integration_points: [integrations],
  reason: [reason]
}
```

#### Option 3: Update Existing Information

Prompt for:
```
Update Existing Information:

1. Which section to update (1-8)?:
   > [User input - section number]

2. What specific content needs updating?:
   > [User input - description]

3. New or corrected information:
   > [User input - multiline]

4. Why is this update needed?:
   > [User input]
```

Store as:
```
UPDATE_TYPE=update_existing
UPDATE_DETAILS={
  section_number: [section],
  content_description: [description],
  new_information: [new info],
  reason: [reason]
}
```

#### Option 4: Add Edge Case Documentation

Prompt for:
```
Edge Case Documentation Details:

1. Edge case name:
   > [User input]

2. Description (what is this edge case?):
   > [User input - multiline]

3. Expected behavior (how should system handle this?):
   > [User input - multiline]

4. Test impact (what testers need to know):
   > [User input]

5. Priority (High/Medium/Low):
   > [User input]

6. Reason for documenting this edge case:
   > [User input]
```

Store as:
```
UPDATE_TYPE=edge_case
UPDATE_DETAILS={
  name: [name],
  description: [description],
  expected_behavior: [behavior],
  test_impact: [impact],
  priority: [priority],
  reason: [reason]
}
```

#### Option 5: Add Open Question

Prompt for:
```
Open Question Details:

1. Question text:
   > [User input]

2. Context/background:
   > [User input - multiline]

3. Impact on testing or development:
   > [User input]

4. Who should answer this question?:
   > [User input - e.g., "Product Owner", "Tech Lead"]

5. Priority (High/Medium/Low):
   > [User input]

6. Why is this question important?:
   > [User input]
```

Store as:
```
UPDATE_TYPE=open_question
UPDATE_DETAILS={
  question: [question text],
  context: [context],
  impact: [impact],
  who_to_ask: [stakeholder],
  priority: [priority],
  reason: [reason]
}
```

### Set Variables for Next Phase

Pass to Phase 3:
```
FEATURE_NAME=[feature-name]
FEATURE_PATH=[path]
FEATURE_KNOWLEDGE_PATH=[path]
UPDATE_TYPE=[business_rule|api_endpoint|update_existing|edge_case|open_question]
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
