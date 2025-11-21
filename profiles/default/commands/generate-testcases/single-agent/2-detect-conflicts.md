# Phase 2: Detect Conflicts

## Check for Existing Test Cases

This phase detects if test-cases.md already exists and prompts for conflict resolution.

### Variables from Phase 1

Required from previous phase:
- `TICKET_ID` - The ticket identifier
- `FEATURE_NAME` - The feature name
- `TICKET_PATH` - Path to ticket folder
- `TEST_CASES_PATH` - Path to test-cases.md file

### Check for Existing File

Check if file exists:
```bash
[TEST_CASES_PATH] = qa-agent-os/features/[feature-name]/[ticket-id]/test-cases.md
```

### Scenario 1: File Does NOT Exist

```
No existing test-cases.md found.
Creating new test cases file.

Mode: CREATE
```

Set variables:
- `MODE=create`
- Continue to Phase 3

### Scenario 2: File EXISTS

Read file metadata:
- Last modified timestamp
- File size
- Number of test cases (count occurrences of "## TC-")

Present conflict options:

```
Warning: test-cases.md already exists for ticket [ticket-id]

Current file:
  - Last updated: 2025-11-19 14:23
  - File size: 15.2 KB
  - Test cases: 12

Options:
  [1] Overwrite (regenerate completely - discard old cases)
  [2] Append (add new cases, keep existing ones)
  [3] Cancel (no changes)

Choose [1/2/3]:
```

### User Selection Handling

**Option 1: Overwrite**
```
Mode: OVERWRITE
Existing test cases will be replaced with newly generated cases.
```
- Set `MODE=overwrite`
- Existing file will be backed up before overwrite
- Continue to Phase 3

**Option 2: Append**
```
Mode: APPEND
New test cases will be added after existing ones.
Next test case ID will start at TC-[N+1].
```
- Set `MODE=append`
- Count existing test cases to determine starting ID
- Set `START_ID=[N+1]` where N = number of existing cases
- Continue to Phase 3

**Option 3: Cancel**
```
Operation cancelled. No changes made to test-cases.md.
```
- Exit command
- No further phases executed

### Set Variables for Next Phase

Pass to Phase 3:
```
MODE=[create|overwrite|append]
TICKET_ID=[ticket-id]
FEATURE_NAME=[feature-name]
TICKET_PATH=[path]
TEST_PLAN_PATH=[path]
TEST_CASES_PATH=[path]
START_ID=[number] (only if MODE=append)
```

### Success Confirmation

```
Conflict resolution complete.
Mode: [create|overwrite|append]

Proceeding to Phase 3: Generate Test Cases
```

### Next Phase

Continue to Phase 3: Generate Test Cases
