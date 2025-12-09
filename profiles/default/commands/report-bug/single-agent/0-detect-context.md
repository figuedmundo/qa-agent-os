# Phase 0: Detect Feature Context for Feature-Level Bug Reporting

## Purpose

Auto-detect the feature context from the current working directory, with manual fallback if detection fails.

## Context Detection

This phase performs intelligent feature context detection:

**I will check:**

1. **Is the user running from a feature directory?** - Auto-detect feature context from working directory path
2. **Validate the feature exists** - Confirm feature directory structure is valid
3. **Prepare for feature-level bug organization** - Set up variables for feature-level bug creation

---

## Smart Feature Detection

### Detection Method

Parse the current working directory (`pwd`) to find feature context:

**Supported directories:**
- `/qa-agent-os/features/[feature-name]/` (feature root)
- `/qa-agent-os/features/[feature-name]/bugs/` (bugs directory)
- `/qa-agent-os/features/[feature-name]/bugs/BUG-00X/` (within a bug folder)
- `/qa-agent-os/features/[feature-name]/[TICKET-ID]/` (ticket directory within feature)

### Automatic Detection Success

If feature is detected automatically:

```
Found feature context: payment-gateway

Feature Path: /path/to/qa-agent-os/features/payment-gateway
Feature Status: Valid

Proceeding with feature-level bug reporting...
```

### Automatic Detection Failure

If feature is not detected from working directory:

```
WARNING: Could not detect feature context from current directory.

Please run this command from a feature directory:
  cd qa-agent-os/features/[feature-name]/

Available options:
  [1] Run /report-bug from feature directory (automatic detection)
  [2] Specify feature manually with parameter: /report-bug --feature payment-gateway

Which would you prefer?
```

### Manual Feature Selection

If detection fails or user requests manual selection, provide directory scan:

```
Scanning for available features...

Features found:
  [1] payment-gateway
  [2] user-authentication
  [3] product-catalog

Which feature has the bug? [1-3]:
```

**If user selects a feature:**
```
Selected feature: payment-gateway

Validating feature structure...
✓ Feature directory exists
✓ Feature has feature-knowledge.md
✓ Ready for bug reporting

Proceeding with feature-level bug reporting...
```

---

## Feature Validation

Once a feature is detected or selected, validate it:

**Check 1: Feature directory exists**
```bash
qa-agent-os/features/[feature-name]/
```

**Check 2: Feature has valid structure**
- Should contain: `feature-knowledge.md`, or `[TICKET-ID]/` directories
- Should be readable and writable

**If feature is invalid:**
```
ERROR: Feature structure invalid.

Expected:
  qa-agent-os/features/payment-gateway/
    ├── feature-knowledge.md
    ├── feature-test-strategy.md
    └── [TICKET-001]/
        ├── test-plan.md
        └── test-cases.md

Has this feature been set up with /plan-feature?
```

---

## Next Phase: Auto-Increment Bug ID

Once feature context is established, the next phase will:

1. Call `find_next_bug_id()` to determine next sequential bug ID
2. Collect bug title from user
3. Sanitize title for folder naming
4. Proceed with bug details collection

---

## Set Variables for Next Phase

Once feature is validated:

```
Export for next phases:
  FEATURE_NAME=[feature-name]
  FEATURE_PATH=/full/path/to/feature
  MODE=[interactive|direct]
```

### Success Message

```
✓ Feature context established: [feature-name]
✓ Bug will be saved at: qa-agent-os/features/[feature-name]/bugs/BUG-00X-[title]/

Proceeding to Phase 1: Auto-Increment and Title Collection
```

---

*Feature-level context detection enables smart bug placement without manual feature selection in most cases.*
