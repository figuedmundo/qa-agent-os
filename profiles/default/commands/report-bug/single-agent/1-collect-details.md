# Phase 1: Auto-Increment Bug ID and Title Collection

## Purpose

Determine the next sequential bug ID and collect the bug title to create the folder structure.

---

## Step 1: Determine Auto-Incremented Bug ID

Using the feature path detected in Phase 0, scan for existing bugs and auto-increment the ID:

```bash
# Call bug-id-utils function
find_next_bug_id "$FEATURE_PATH"
```

**Process:**
1. Scan `$FEATURE_PATH/bugs/` directory for existing `BUG-*` folders
2. Extract numeric IDs from existing folders (e.g., BUG-001, BUG-002)
3. Find the maximum ID number
4. Generate next sequential ID with zero-padding (e.g., BUG-003)

**Display assigned ID:**

```
Determining next bug ID...

Existing bugs in feature:
  BUG-001-login-form-validation-error
  BUG-002-payment-processing-timeout

Next available bug ID: BUG-003
```

**If no bugs exist yet:**

```
Determining next bug ID...

No existing bugs found in feature.

Next available bug ID: BUG-001
```

---

## Step 2: Collect Bug Title

Ask user for a short, descriptive bug title:

```
Bug Title:
  Format: [Component] - [Brief Summary]
  Example: "Checkout - Submit button returns 500 error"
  Recommended: 20-40 characters after shortening
  Max: 100 characters

Enter bug title:
```

**Validation:**
- Title is required (not empty)
- Title should be descriptive but concise
- Title will be converted to URL-friendly folder name

**Handle empty input:**

```
Title cannot be empty. Please provide a descriptive title.

Enter bug title:
```

---

## Step 3: Sanitize Title for Folder Naming

Convert user-provided title to URL-friendly format:

```bash
# Call sanitize function
sanitized_title=$(sanitize_bug_title "$user_title")
```

**Sanitization rules:**
- Convert to lowercase
- Replace spaces and special characters with hyphens
- Keep only alphanumeric characters and hyphens
- Remove consecutive hyphens
- Truncate to 40 characters (recommended max)
- Remove trailing hyphens

**Examples:**
```
User input:  "Login Form - Validation Error!"
Sanitized:   "login-form-validation-error"

User input:  "Checkout Payment Timeout @ Gateway"
Sanitized:   "checkout-payment-timeout-gateway"

User input:  "User's Email Domain.com (Critical Issue)"
Sanitized:   "users-email-domain-com-critical-issue"
```

---

## Step 4: Display Folder Name Preview

Show the user what the bug folder will be named:

```
Sanitized bug title: [sanitized-title]

Bug folder will be created at:
  qa-agent-os/features/[feature-name]/bugs/BUG-003-[sanitized-title]/

Subfolders will be created:
  ├── bug-report.md
  ├── screenshots/
  ├── logs/
  ├── videos/
  └── artifacts/

Is this folder name acceptable? [y/n]
```

**If user says no:**

```
You can:
  [1] Provide a different title and regenerate folder name
  [2] Keep current suggestion and continue
  [3] Cancel bug creation

Select [1-3]:
```

**If user selects [1]:**
```
Enter new bug title:
```
(Loop back to Step 2)

**If user selects [2] or [3]:**
```
Proceeding with folder name: BUG-003-[sanitized-title]
```

---

## Step 5: Collect Bug Details

Now collect detailed information about the bug:

### Sub-step 5.1: Summary

```
Bug Summary (2-3 sentences):
  What's broken, who's affected, impact, reproducibility?

Example: "When users submit the login form with invalid email
format, no validation error is displayed. This affects all users
attempting login with malformed email addresses. The bug is
consistently reproducible on all browsers."

Enter summary:
```

### Sub-step 5.2: Environment Details

```
Environment Information:

1. Operating System (e.g., Windows 11, macOS 14, Ubuntu 22.04):
   >

2. Browser / Device (e.g., Chrome 121, Safari 17, iPhone 15 iOS 17):
   >

3. Environment (Dev / Staging / Production):
   >

4. Build / Version (e.g., v2.5.1, commit abc123):
   >

5. Feature Flags / Config (if applicable, or enter "N/A"):
   >
```

### Sub-step 5.3: Component / Area

```
Which component or area is affected?
  Example: "User Authentication", "Payment Processing", "Search Index"

Component/Area:
```

### Sub-step 5.4: Related Ticket (Optional)

```
Which ticket(s) does this bug affect? (optional)
  Format: Single ticket (TICKET-123) or comma-separated (TICKET-123, TICKET-124)
  Leave blank if bug is not related to specific ticket(s)

Related Ticket(s):
```

**Store as:**
```
TICKET_REF=[user-input or "Not specified"]
```

---

## Step 6: Reproduction Steps

Collect detailed reproduction information:

### Sub-step 6.1: Preconditions

```
What conditions must be met before the bug can occur?
  Example: "User account exists with valid credentials, user is on login page"

Preconditions:
```

### Sub-step 6.2: Steps to Reproduce

```
Enter steps to reproduce (numbered list):
  Include specific data values and observable results

Format:
  1. [Action with specific data]
  2. [Next action]
  3. [Observable result]
  ...

Example:
  1. Navigate to /login
  2. Enter email: "invalidemail.com" (missing @)
  3. Enter password: "correctpassword"
  4. Click "Sign In" button
     -> Form should display validation error
  5. Observe that no error message appears

Enter steps:
```

### Sub-step 6.3: Expected vs Actual

```
Expected Behavior:
  What should happen per requirements?

Enter expected behavior:
```

```
Actual Behavior:
  What actually happened, including exact error messages?

Enter actual behavior:
```

### Sub-step 6.4: Reproducibility

```
How often can you reproduce this bug?

Options:
  [1] Always - Bug reproduces consistently
  [2] Intermittent - Bug reproduces sometimes

Select [1-2]:
```

**If intermittent:**
```
Approximately how often does it reproduce?
  Example: "3 out of 5 attempts", "Every 2nd refresh", "After 10 minutes"

Frequency:
```

---

## Set Variables for Next Phase

After collecting all details:

```
Export variables:
  BUG_ID=BUG-003
  SANITIZED_TITLE=[sanitized-title]
  BUG_SUMMARY=[user-provided-summary]
  BUG_ENVIRONMENT=[collected-environment]
  BUG_COMPONENT=[component-area]
  BUG_TICKET=[ticket-reference or empty]
  BUG_PRECONDITIONS=[preconditions]
  BUG_STEPS=[numbered-steps]
  BUG_EXPECTED=[expected-behavior]
  BUG_ACTUAL=[actual-behavior]
  BUG_REPRODUCIBILITY=[always|intermittent-frequency]
```

---

## Success Message

```
✓ Bug ID and title determined: BUG-003-[sanitized-title]
✓ Bug details collected:
  - Summary: [first 50 chars...]
  - Environment: [OS, Browser, Environment]
  - Steps: [number of steps collected]

Proceeding to Phase 2: Supporting Materials Collection
```

---

*Collect comprehensive bug details with user guidance to ensure quality bug reports.*
