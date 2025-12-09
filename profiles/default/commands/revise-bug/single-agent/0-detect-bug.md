# Phase 0: Detect Bug Context for Feature-Level Bug Revision

## Purpose

Detect feature and bug context from the current working directory, discover available bugs, and display bug summary before revision options.

## Context Detection

This phase performs intelligent bug and feature context detection:

**I will check:**

1. **Is the user running from a feature directory?** - Auto-detect feature context
2. **If bug ID provided?** - Use it directly
3. **If not, what bugs exist?** - Discover available bugs in feature
4. **Which bug to revise?** - Display interactive menu if multiple
5. **Display bug summary** - Show current status, severity, metadata

---

## Step 1: Detect Feature Context

Parse the current working directory to find feature context:

**Supported directories:**
- `/qa-agent-os/features/[feature-name]/` (feature root)
- `/qa-agent-os/features/[feature-name]/bugs/` (bugs directory)
- `/qa-agent-os/features/[feature-name]/bugs/BUG-00X/` (within a bug folder)
- `/qa-agent-os/features/[feature-name]/[TICKET-ID]/` (ticket directory within feature)

**If feature detected successfully:**

```
Detected feature context: payment-gateway

Feature Path: /path/to/qa-agent-os/features/payment-gateway
Feature Status: Valid

Proceeding with bug revision...
```

**If feature not detected:**

```
WARNING: Could not detect feature context from current directory.

Please run this command from a feature directory:
  cd qa-agent-os/features/[feature-name]/

Available options:
  [1] Run /revise-bug from feature directory (automatic detection)
  [2] Specify feature manually with parameter: /revise-bug --feature payment-gateway BUG-001

Which would you prefer?
```

---

## Step 2: Handle Bug ID Parameter

**If bug ID provided as parameter:**

```
Using provided bug ID: BUG-003
Feature: payment-gateway

Looking up bug: BUG-003...
✓ Bug found: BUG-003-checkout-payment-timeout

Proceeding to revision options...
```

**If bug ID NOT provided:**

```
Bug ID not provided. Discovering available bugs in feature...
```

---

## Step 3: Discover Available Bugs

Scan feature's bugs directory for all existing bugs:

```
Bugs found in feature:
  [1] BUG-001 - Checkout validation error [Status: Open]
  [2] BUG-002 - Payment processing timeout [Status: In Progress]
  [3] BUG-003 - Currency conversion error [Status: Open]
```

**If only one bug exists:**

```
Only one bug found in feature. Auto-selecting...

Selected: BUG-001 - Checkout validation error
```

**If multiple bugs exist:**

```
Select a bug to revise:

  [1] BUG-001 - Checkout validation error [Status: Open]
  [2] BUG-002 - Payment processing timeout [Status: In Progress]
  [3] BUG-003 - Currency conversion error [Status: Open]
  [0] Cancel

Enter selection [0-3]:
```

**If no bugs found:**

```
ERROR: No bugs found in feature: payment-gateway

Run /report-bug to create your first bug:
  /report-bug --title "Bug description"
```

---

## Step 4: Load and Display Bug Summary

Once bug is selected, read bug-report.md and display summary:

```
Bug Summary
===========

ID: BUG-002
Title: Payment processing timeout
Status: In Progress
Severity: S2 - Major
Last Updated: 2025-12-08 14:30:00
Related Tickets: TICKET-456
Jira ID: [None]

Current Summary:
When users attempt checkout with large orders, payment processing
hangs for 60+ seconds before timing out. Affects ~15% of transactions
in staging.

Proceeding to revision options...
```

---

## Set Variables for Next Phase

Once bug is detected and loaded:

```
Export for next phases:
  FEATURE_NAME=payment-gateway
  FEATURE_PATH=/full/path/to/feature
  BUG_ID=BUG-002
  BUG_PATH=/full/path/to/bug/folder
  BUG_REPORT_PATH=/full/path/to/bug/folder/bug-report.md
```

### Success Message

```
✓ Bug context established: BUG-002
✓ Feature: payment-gateway
✓ Path: qa-agent-os/features/payment-gateway/bugs/BUG-002-payment-processing-timeout/

Proceeding to Phase 1: Revision Type Selection
```

---

*Feature and bug-level context detection enables smart bug revision without manual feature or bug ID selection in most cases.*
