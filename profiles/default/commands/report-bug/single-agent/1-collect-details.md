# Phase 1: Collect Details

## Bug Details Collection

This phase collects all required bug information, adapting to interactive or direct mode.

### Variables from Phase 0

Required from previous phase:
- `FEATURE_NAME` - The feature name
- `TICKET_ID` - The ticket identifier
- `TICKET_PATH` - Path to ticket folder
- `BUG_ID` - Assigned bug ID (e.g., BUG-001)
- `BUG_PATH` - Full path to bug file
- `MODE` - interactive or direct

---

## Interactive Mode

If `MODE=interactive`, present guided questionnaire:

### Step 1: Bug Title

```
Bug Title:
  Format: [COMPONENT] - [Brief Summary]
  Example: "Checkout - Submit button returns 500 error"

Enter bug title:
> [User input]
```

**Validation:**
- Title is required
- Should be descriptive but concise (under 100 characters recommended)

### Step 2: Environment

```
Environment Details:

1. Operating System (e.g., Windows 11, macOS 14, Ubuntu 22.04):
   > [User input]

2. Browser / Device (e.g., Chrome 120, Safari 17, iPhone 15):
   > [User input]

3. Environment (Dev / Staging / Production):
   > [User input]

4. Build / Version (e.g., v2.5.1, commit abc123):
   > [User input]

5. Feature Flags / Config (if applicable, or enter "N/A"):
   > [User input]
```

### Step 3: Component / Area

```
Which component or area is affected?
  Example: "Login Module", "Payment API", "User Dashboard"

Enter component:
> [User input]
```

### Step 4: Preconditions

```
Preconditions (state required before reproduction):
  Example: "User must be logged in with a valid account"

Enter preconditions (or "None" if not applicable):
> [User input]
```

### Step 5: Steps to Reproduce (Required)

```
Steps to Reproduce:

Enter each step on a new line. Include specific data values.
Type "DONE" on a new line when finished.

Example:
  1. Navigate to /checkout page
  2. Add item "Product ABC" to cart
  3. Click "Submit Order" button
  4. Observe error

Enter steps:
> [User input - multiline until "DONE"]
```

**Validation:**
- At least one step is required
- Steps should be specific and actionable

### Step 6: Expected Result

```
Expected Result:
  What should have happened according to requirements?

Enter expected result:
> [User input]
```

### Step 7: Actual Result

```
Actual Result:
  What actually happened? Include exact error messages if any.

Enter actual result:
> [User input]
```

### Step 8: Reproducibility

```
Reproducibility:

1. How often does this occur?
   [1] Always (100%)
   [2] Frequently (>50%)
   [3] Sometimes (10-50%)
   [4] Rarely (<10%)
   [5] Once (unable to reproduce again)

Select [1-5]:
> [User input]

2. Attempts made (e.g., "5 out of 5"):
   > [User input]

3. Any variations or conditions affecting reproducibility:
   > [User input or "None"]
```

---

## Direct Mode

If `MODE=direct`, parse and validate parameters:

### Required Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `--title` | Bug title (required) | `--title "Checkout fails"` |

### Optional Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `--severity` | Pre-set severity | `--severity S2` |
| `--steps` | Steps to reproduce | `--steps "1. Go to /login\n2. Click submit"` |
| `--expected` | Expected result | `--expected "Login succeeds"` |
| `--actual` | Actual result | `--actual "500 error shown"` |
| `--environment` | Environment string | `--environment "Chrome 120, Staging"` |
| `--component` | Component/area | `--component "Login Module"` |
| `--reproducibility` | Rate | `--reproducibility "Always"` |

### Parameter Validation

```
Validating parameters...

Required fields:
  [OK] --title: "[title value]"

Optional fields:
  [OK] --severity: S2 (provided)
  [MISSING] --steps: Will prompt during evidence collection
  [OK] --expected: "[value]"
  [OK] --actual: "[value]"
  [MISSING] --environment: Will prompt for details
```

**If required fields missing:**
```
Error: Missing required parameter --title

Usage:
  /report-bug --title "Bug title" [--severity S1-S4] [--steps "..."]

Or run without parameters for interactive mode:
  /report-bug
```

### Fill Missing Optional Fields

For any missing optional fields in direct mode, prompt minimally:

```
Some optional details not provided. Quick prompts:

Environment (or press Enter to skip):
> [User input]

Steps to reproduce (one per line, DONE to finish):
> [User input]
```

---

## Store Collected Details

Compile all information into BUG_DETAILS variable:

```
BUG_DETAILS={
  title: "[Bug Title]",
  component: "[Component/Area]",
  environment: {
    os: "[Operating System]",
    browser: "[Browser/Device]",
    env_type: "[Dev/Staging/Production]",
    build: "[Build/Version]",
    feature_flags: "[Flags or N/A]"
  },
  preconditions: "[Preconditions]",
  steps: [
    "[Step 1]",
    "[Step 2]",
    "[Step 3]"
  ],
  expected_result: "[Expected Result]",
  actual_result: "[Actual Result]",
  reproducibility: {
    rate: "[Always/Frequently/Sometimes/Rarely/Once]",
    attempts: "[X out of Y]",
    notes: "[Variations or None]"
  }
}
```

### Summary Display

```
Bug details collected:

Title: [title]
Component: [component]
Environment: [env_type] - [browser] on [os]
Build: [build]
Steps: [count] steps captured
Reproducibility: [rate]

Proceeding to Phase 2: Collect Evidence
```

### Set Variables for Next Phase

Pass to Phase 2:
```
FEATURE_NAME=[feature-name]
TICKET_ID=[ticket-id]
TICKET_PATH=[path]
BUG_ID=[bug-id]
BUG_PATH=[path]
MODE=[mode]
BUG_DETAILS=[details object]
PRESET_SEVERITY=[severity if provided in direct mode, else null]
```

### Next Phase

Continue to Phase 2: Collect Evidence
