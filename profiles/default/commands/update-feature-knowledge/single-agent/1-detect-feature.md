# Phase 1: Detect Feature

## Feature Selection Logic

This phase identifies which feature's knowledge to update.

### Check for Direct Parameter

**If feature name provided as parameter:**
```
Using provided feature: [feature-name]
```
- Set `FEATURE_NAME=[feature-name]`
- Skip to validation

**If NO parameter provided:**
- Show interactive selection

### Interactive Selection

Scan `qa-agent-os/features/` for all features and present:

```
Which feature's knowledge to update?

Features:
  [1] Feature-Name-1
  [2] Feature-Name-2
  [3] Feature-Name-3

Choose [1-3]:
```

**User input:**
- Accepts number selection (e.g., "1")
- Sets `FEATURE_NAME` from selected feature

### Validation

Verify feature structure exists:

**Check 1: Feature folder exists**
```bash
qa-agent-os/features/[feature-name]/
```

**Check 2: feature-knowledge.md exists**
```bash
qa-agent-os/features/[feature-name]/feature-knowledge.md
```

**If folder doesn't exist:**
```
Error: Feature [feature-name] not found.

Have you run /plan-feature yet?
  /plan-feature [feature-name]

This creates the feature structure and knowledge document.
```

**If feature-knowledge.md doesn't exist:**
```
Error: feature-knowledge.md not found for feature [feature-name].

The feature knowledge document is required. Run:
  /plan-feature [feature-name]
```

### Read Current Feature Knowledge Metadata

Extract information from feature-knowledge.md:
- Last updated timestamp
- Which sections exist
- Number of business rules
- Number of APIs documented
- Number of open questions

Store for display:
```
Current feature knowledge:
  Last updated: 2025-11-19 14:23
  Business rules: 5
  API endpoints: 3
  Open questions: 2
```

### Important Note About Manual Updates

Display reminder:
```
NOTE: Most feature knowledge updates happen automatically via /plan-ticket gap detection.

Use this command only for:
  - Strategic decisions requiring documentation
  - Requirements gathering meeting outcomes
  - Business rule clarifications outside ticket context
  - Architecture decisions
  - Answering open questions

If your update is related to a specific ticket, use /plan-ticket gap detection instead.
```

### Set Variables for Next Phase

Once validated:
```
FEATURE_NAME=[feature-name]
FEATURE_PATH=qa-agent-os/features/[feature-name]
FEATURE_KNOWLEDGE_PATH=[feature-path]/feature-knowledge.md
```

### Success Confirmation

```
Selected: [feature-name]
Feature knowledge found: [feature-knowledge-path]
Last updated: [timestamp]

Proceeding to Phase 2: Prompt Update Type
```

### Next Phase

Continue to Phase 2: Prompt Update Type
