# Initialize Ticket Workflow

This workflow creates the folder structure for a new ticket within a feature.

## Core Responsibilities

1. **Create Ticket Folder**: Set up the ticket directory within the feature
2. **Create Documentation Folder**: Prepare location for ticket-specific documents
3. **Create README**: Generate initial ticket information file

**Note:** The placeholder `[feature-path]` refers to the full path like `qa-agent-os/features/feature-name`. The placeholder `[ticket-id]` refers to the ticket identifier (e.g., WYX-123).

---

## Workflow

### Step 1: Normalize Ticket ID

Normalize the ticket ID for use in folder names:
- Convert to lowercase
- Preserve hyphens
- Remove special characters except hyphens

Example: `WYX-123` becomes `wyx-123`

Store as `[normalized-ticket-id]`.

### Step 2: Create Ticket Root Folder

Create the ticket directory:

```bash
mkdir -p [feature-path]/[normalized-ticket-id]
```

This creates: `qa-agent-os/features/feature-name/wyx-123/`

### Step 3: Create Documentation Folder

Create the documentation subfolder:

```bash
mkdir -p [feature-path]/[normalized-ticket-id]/documentation
```

This creates: `qa-agent-os/features/feature-name/wyx-123/documentation/`

### Step 4: Create Visuals Subfolder

Create the visuals subfolder for mockups and screenshots:

```bash
mkdir -p [feature-path]/[normalized-ticket-id]/documentation/visuals
```

This creates: `qa-agent-os/features/feature-name/wyx-123/documentation/visuals/`

### Step 5: Create Ticket README

Create `[feature-path]/[normalized-ticket-id]/README.md` with structure:

```markdown
# Ticket: [ticket-id]

**Feature:** [feature-name]
**Status:** Planning
**Created:** [YYYY-MM-DD HH:MM]

---

## Overview

This directory contains all QA planning and testing artifacts for ticket [ticket-id].

## Structure

```
[normalized-ticket-id]/
├── README.md                  # This file
├── documentation/             # Ticket-specific documentation
│   └── visuals/              # Mockups, screenshots, UI designs
├── test-plan.md              # Comprehensive test plan (created in Phase 3)
└── test-cases.md             # Detailed executable test cases (created in Phase 4)
```

## Feature Context

This ticket is part of the **[feature-name]** feature.

**Feature Knowledge:** ../feature-knowledge.md
**Feature Test Strategy:** ../feature-test-strategy.md

## Planning Status

- [ ] Phase 1: Ticket structure initialized
- [ ] Phase 2: Documentation gathered
- [ ] Phase 3: Requirements analyzed, test plan created
- [ ] Phase 4: Test cases generated

## Documentation

Ticket-specific documentation is stored in the `documentation/` folder:
- Jira ticket export or details
- Ticket-specific requirements and acceptance criteria
- Technical specifications
- API request/response examples
- Mockups or screenshots (in visuals/ subfolder)

## Testing Artifacts

### Test Plan
- **File:** test-plan.md
- **Sections:** 11 sections including requirements, coverage, scenarios, test data
- **Status:** Not created yet

### Test Cases
- **File:** test-cases.md
- **Structure:** Detailed executable test cases with execution tracking
- **Status:** Not created yet

## Next Steps

1. Gather ticket-specific documentation (Phase 2)
2. Analyze requirements and detect gaps (Phase 3)
3. Create comprehensive test plan (Phase 3)
4. Generate detailed test cases (Phase 4)

---

**Note:** This ticket references feature-level knowledge and strategy to avoid redundancy.
```

### Step 6: Completion

Display summary:
```
Ticket structure initialized!

Created:
- Ticket folder: [feature-path]/[normalized-ticket-id]/
- Documentation folder: [feature-path]/[normalized-ticket-id]/documentation/
- Visuals folder: [feature-path]/[normalized-ticket-id]/documentation/visuals/
- README: [feature-path]/[normalized-ticket-id]/README.md

Next: Gather ticket-specific documentation (Phase 2)
```

---

## Folder Structure Created

```
features/[feature-name]/[normalized-ticket-id]/
├── README.md                      # Ticket overview and planning status
└── documentation/
    └── visuals/                   # For mockups and screenshots
```

**Note:** The test-plan.md and test-cases.md files are created in later phases (Phase 3 and Phase 4).
