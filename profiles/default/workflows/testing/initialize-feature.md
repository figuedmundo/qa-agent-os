# Feature Initialization Workflow

This workflow creates the complete directory structure for a new feature.

## Core Responsibilities

1. **Normalize Feature Name**: Convert feature name to proper directory format (lowercase, hyphens)
2. **Create Feature Directory**: Create main feature folder with standardized naming
3. **Create Documentation Folder**: Create folder for feature-level documents (BRD, API specs, mockups)
4. **Generate README**: Create README.md with feature information
5. **Return Paths**: Output created paths for subsequent phases

**Note:** The placeholder `[feature-name]` refers to the user-provided feature name, for example: "TWRR" or "Portfolio Analytics".

---

## Workflow

### Step 1: Normalize Feature Name

Take the user-provided feature name and convert it to a directory-safe format:

```bash
# Get user-provided feature name
USER_FEATURE_NAME="[feature-name]"

# Normalize to lowercase, kebab-case (hyphens for spaces)
NORMALIZED_NAME=$(echo "$USER_FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[ _]/-/g' | sed 's/[^a-z0-9-]//g')

# Result: "TWRR" becomes "twrr", "Portfolio Analytics" becomes "portfolio-analytics"
```

### Step 2: Create Feature Directory Structure

Create the feature folder with normalized name:

```bash
# Define the full feature path
FEATURE_PATH="qa-agent-os/features/$NORMALIZED_NAME"

# Create feature directory
mkdir -p "$FEATURE_PATH"

# Create documentation subdirectory
mkdir -p "$FEATURE_PATH/documentation"

echo "Created feature directory: $FEATURE_PATH"
echo "Created documentation directory: $FEATURE_PATH/documentation"
```

**Directory structure created:**
```
qa-agent-os/features/[normalized-name]/
  documentation/
```

### Step 3: Generate Feature README

Create a README.md file in the feature directory with basic information:

```markdown
# Feature: [User-provided Feature Name]

**Created:** [Date]
**Directory:** qa-agent-os/features/[normalized-name]

---

## Overview

This folder contains all testing documentation and artifacts for the **[Feature Name]** feature.

## Directory Structure

```
features/[normalized-name]/
├── documentation/          # Raw source documents (BRD, API specs, mockups)
├── feature-knowledge.md    # Consolidated feature knowledge (8 sections)
├── feature-test-strategy.md # Testing strategy (10 sections)
└── [ticket-id]/           # Individual ticket test plans and cases
    ├── documentation/      # Ticket-specific documents
    ├── test-plan.md       # Test plan (11 sections)
    └── test-cases.md      # Executable test cases
```

## Documentation Files

### feature-knowledge.md
Consolidates all feature information into 8 sections:
1. Feature Overview
2. Business Context & Goals
3. User Flows & Interactions
4. API Specifications
5. Business Rules & Logic
6. Edge Cases & Constraints
7. Dependencies & Integrations
8. Open Questions

### feature-test-strategy.md
Defines the testing approach in 10 sections:
1. Testing Objectives
2. Scope & Coverage
3. Testing Types & Techniques
4. Test Environment Strategy
5. Test Data Strategy
6. Tools & Frameworks
7. Entry & Exit Criteria
8. Risk Assessment
9. Resource Planning
10. Deliverables

## Tickets

Each ticket has its own subdirectory containing:
- **test-plan.md** - Comprehensive test plan (11 sections)
- **test-cases.md** - Detailed executable test cases
- **documentation/** - Ticket-specific source documents

## Commands

**Plan this feature:**
```bash
/plan-feature "[Feature Name]"
```

**Plan a ticket in this feature:**
```bash
/plan-ticket [TICKET-ID]
```

**Generate test cases:**
```bash
/generate-testcases [TICKET-ID]
```

**Update feature knowledge:**
```bash
/update-feature-knowledge
```

---

**Last Updated:** [Date]
```

Save this README.md to `[feature-path]/README.md`.

### Step 4: Output Confirmation

Return clear confirmation message with created paths:

```
Feature folder initialized successfully!

Feature: [User-provided Feature Name]
Location: qa-agent-os/features/[normalized-name]

Structure created:
  features/[normalized-name]/
    documentation/    (for BRD, API specs, mockups)
    README.md         (feature overview)

Next steps:
- Phase 2 will gather feature documentation
- Phase 3 will create feature-knowledge.md
- Phase 4 will create feature-test-strategy.md

FEATURE_PATH=qa-agent-os/features/[normalized-name]
```

### Step 5: Pass Context to Next Phase

Export the feature path variable for subsequent phases:

```bash
# Make feature path available to next phases
export FEATURE_PATH="qa-agent-os/features/$NORMALIZED_NAME"
echo "FEATURE_PATH=$FEATURE_PATH"
```
