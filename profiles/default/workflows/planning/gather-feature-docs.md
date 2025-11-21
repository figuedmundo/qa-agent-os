# Gather Feature Documentation Workflow

This workflow collects all available documentation for a feature from stakeholders, including BRDs, API specifications, mockups, business rules, and technical documentation.

## Core Responsibilities

1. **Prompt for Documentation**: Guide users through providing different types of feature documentation
2. **Store Documentation**: Save all collected documents with descriptive filenames
3. **Create Audit Trail**: Generate collection log with metadata tracking what was gathered and when

**Note:** The placeholder `[feature-path]` refers to the full path like `qa-agent-os/features/feature-name`.

---

## Workflow

### Step 1: Prepare Documentation Folder

Ensure the documentation folder exists:

```bash
mkdir -p [feature-path]/documentation
```

### Step 2: Prompt for Business Requirements Document

Ask user:
```
Do you have a Business Requirements Document or similar BRD?

Options:
  [File path] - Paste the path to your BRD file
  [Paste content] - Paste the BRD content directly
  [Skip] - You don't have a BRD

Your choice:
```

If provided:
- Store file path or content at `[feature-path]/documentation/brd.md`
- Record in collection log

### Step 3: Prompt for API Specifications

Ask user:
```
Do you have API specifications or technical contracts?

Options:
  [File path] - Paste the path to API spec files (YAML, JSON, etc.)
  [Paste content] - Paste API specification details
  [Skip] - You don't have API specs

Your choice:
```

If provided:
- Store at `[feature-path]/documentation/api-specs.md` (or preserve original format like .yaml, .json)
- Record in collection log

### Step 4: Prompt for Business Rules & Calculations

Ask user:
```
Do you have documentation on business rules, calculations, or formulas?

Options:
  [File path] - Paste the path to business rules documentation
  [Paste content] - Paste the business rules content
  [Skip] - You don't have this documentation

Your choice:
```

If provided:
- Store at `[feature-path]/documentation/business-rules.md`
- Record in collection log

### Step 5: Prompt for UI Mockups & Wireframes

Ask user:
```
Do you have UI mockups, wireframes, or design files?

Options:
  [File paths] - List file paths to mockup images (comma-separated)
  [Skip] - You don't have mockups

Your choice:
```

If provided:
- Copy image files to `[feature-path]/documentation/mockups/`
- Or record file paths in collection log
- Record in collection log

### Step 6: Prompt for Other Technical Documentation

Ask user:
```
Do you have any other relevant technical documentation?

Options:
  [File path] - Paste the path
  [Paste content] - Paste the content
  [Skip] - No other documentation

Your choice:
```

If provided:
- Store at `[feature-path]/documentation/technical-docs.md`
- Record in collection log

### Step 7: Create Collection Log

Create `[feature-path]/documentation/COLLECTION_LOG.md` with structure:

```markdown
# Feature Documentation Collection Log

## Collection Metadata

- **Feature:** [feature-name]
- **Collection Date:** [YYYY-MM-DD HH:MM]
- **Collected By:** [user or automated]

---

## Documents Collected

### 1. Business Requirements Document
- **File:** brd.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** Business requirements and feature scope

### 2. API Specifications
- **File:** api-specs.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** API endpoints, request/response contracts

### 3. Business Rules & Calculations
- **File:** business-rules.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** Business logic, formulas, calculation rules

### 4. UI Mockups & Wireframes
- **Files:** mockups/ directory
- **Source:** [file paths or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** UI designs, wireframes, visual assets

### 5. Other Technical Documentation
- **File:** technical-docs.md
- **Source:** [file path or "pasted content" or "skipped"]
- **Date Collected:** [YYYY-MM-DD HH:MM]
- **Description:** Additional technical specifications

---

## Notes

[Any additional notes about the documentation collection process]
```

### Step 8: Completion

Display summary:
```
Documentation collection complete!

Collected documents saved in: [feature-path]/documentation/
Collection log created: [feature-path]/documentation/COLLECTION_LOG.md

Next: This documentation will be analyzed and consolidated into feature-knowledge.md
```
