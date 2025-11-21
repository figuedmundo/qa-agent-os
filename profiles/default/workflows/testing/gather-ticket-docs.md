# Gather Ticket Documentation Workflow

This workflow collects all ticket-specific documentation from stakeholders, including Jira exports, acceptance criteria, technical specifications, mockups, and API examples.

## Core Responsibilities

1. **Prompt for Documentation**: Guide users through providing different types of ticket documentation
2. **Store Documentation**: Save all collected documents with descriptive filenames
3. **Create Collection Log**: Generate audit trail tracking what was gathered and when

**Note:** The placeholder `[ticket-path]` refers to the full path like `qa-agent-os/features/feature-name/ticket-id`.

---

## Workflow

### Step 1: Prepare Documentation Folder

Ensure the documentation folder exists:

```bash
mkdir -p [ticket-path]/documentation
mkdir -p [ticket-path]/documentation/visuals
```

### Step 2: Prompt for Jira Ticket Export

Ask user:
```
Do you have the Jira ticket export or PDF copy?

Options:
  [File path] - Paste the path to the Jira export file
  [Paste content] - Paste ticket details (ID, title, description, acceptance criteria)
  [Skip] - You'll enter details manually during analysis

Your choice:
```

If provided:
- Store file path or content at `[ticket-path]/documentation/jira-ticket.md`
- Record in collection log

### Step 3: Prompt for Requirements & Acceptance Criteria

Ask user:
```
Do you have ticket-specific requirements or acceptance criteria?

Options:
  [File path] - Path to requirements document
  [Paste content] - Paste acceptance criteria directly
  [Skip] - Enter criteria during analysis phase

Your choice:
```

If provided:
- Store at `[ticket-path]/documentation/acceptance-criteria.md`
- Record in collection log

### Step 4: Prompt for Technical Specifications

Ask user:
```
Do you have technical specifications for this ticket?

Options:
  [File path] - Path to technical spec document
  [Paste content] - Paste specifications
  [Skip] - None available

Your choice:
```

If provided:
- Store at `[ticket-path]/documentation/technical-specs.md`
- Record in collection log

### Step 5: Prompt for Mockups & Screenshots

Ask user:
```
Do you have UI mockups or screenshots for this ticket?

Options:
  [File paths] - List file paths to mockup/screenshot files (comma-separated)
  [Skip] - No visual assets

Your choice:
```

If provided:
- Copy image files to `[ticket-path]/documentation/visuals/`
- Or record file paths in collection log
- Record in collection log

### Step 6: Prompt for API Examples

Ask user:
```
Do you have API request/response examples?

Options:
  [File path] - Path to API documentation file
  [Paste content] - Paste API examples (JSON, YAML, curl commands, etc.)
  [Skip] - No API examples

Your choice:
```

If provided:
- Store at `[ticket-path]/documentation/api-examples.md`
- Record in collection log

### Step 7: Prompt for Other Documentation

Ask user:
```
Do you have any other ticket-specific documentation?

Examples:
- Test data examples
- Database schema changes
- Configuration changes
- Error message examples

Options:
  [File path] - Path to other documentation
  [Paste content] - Paste other content
  [Skip] - Nothing else

Your choice:
```

If provided:
- Store at `[ticket-path]/documentation/other-docs.md`
- Record in collection log

### Step 8: Create Collection Log

Create `[ticket-path]/documentation/COLLECTION_LOG.md` with structure:

```markdown
# Ticket Documentation Collection Log

## Collection Metadata

- **Ticket ID:** [ticket-id]
- **Feature:** [feature-name]
- **Collection Date:** [YYYY-MM-DD HH:MM]
- **Collected By:** [user or automated]

---

## Documents Collected

### 1. Jira Ticket Export
- **File:** jira-ticket.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** Jira ticket details including title, description, acceptance criteria

### 2. Requirements & Acceptance Criteria
- **File:** acceptance-criteria.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** Ticket-specific requirements and acceptance criteria

### 3. Technical Specifications
- **File:** technical-specs.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** Technical implementation details and specifications

### 4. UI Mockups & Screenshots
- **Files:** visuals/ directory
- **Source:** [file paths or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** UI mockups, wireframes, screenshots for this ticket

### 5. API Examples
- **File:** api-examples.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** API request/response examples, curl commands

### 6. Other Documentation
- **File:** other-docs.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** Additional ticket-specific documentation

---

## Notes

[Any additional notes about the documentation collection process]

---

## Context

This ticket is part of the **[feature-name]** feature.

**Feature Knowledge:** ../../feature-knowledge.md
**Feature Test Strategy:** ../../feature-test-strategy.md
```

### Step 9: Completion

Display summary:
```
Ticket documentation collection complete!

Collected documents saved in: [ticket-path]/documentation/
Collection log created: [ticket-path]/documentation/COLLECTION_LOG.md

Documents collected:
[List of documents that were provided, not skipped]

Next: This documentation will be analyzed to create the test plan (Phase 3)

Context available:
- Feature Knowledge: [feature-path]/feature-knowledge.md
- Feature Test Strategy: [feature-path]/feature-test-strategy.md
```

---

## Document Storage Structure

```
[ticket-path]/documentation/
├── COLLECTION_LOG.md              # Audit trail of collection
├── jira-ticket.md                 # Jira ticket export (if provided)
├── acceptance-criteria.md         # Requirements & AC (if provided)
├── technical-specs.md             # Technical specifications (if provided)
├── api-examples.md                # API examples (if provided)
├── other-docs.md                  # Other documentation (if provided)
└── visuals/                       # UI mockups and screenshots
    ├── mockup-1.png
    └── screenshot-1.png
```

**Note:** Not all files may exist - only those provided by the user are created. The collection log tracks what was provided and what was skipped.
