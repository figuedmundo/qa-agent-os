# Phase 1: Initialize Feature Structure

## Initialize the Feature Folder

This phase creates the complete directory structure for your feature.

### Get Feature Name

If not already provided, ask the user:

```
What is the name of the feature you want to plan?

Please provide the feature name (e.g., "TWRR", "Portfolio Analytics", "Payment Processing"):
```

Once you have the feature name, proceed to initialization.

### Execute Feature Initialization Workflow

{{workflows/testing/initialize-feature}}

The workflow will:
- Normalize the feature name (lowercase, hyphens, remove special characters)
- Create the feature directory: `qa-agent-os/features/[normalized-name]`
- Create the documentation subdirectory: `qa-agent-os/features/[normalized-name]/documentation`
- Generate README.md with feature information and directory structure guide
- Return the feature path for subsequent phases

### Result

```
Feature folder initialized successfully!

Feature: [User-provided Feature Name]
Location: qa-agent-os/features/[normalized-name]

Structure created:
  features/[normalized-name]/
    documentation/    (for BRD, API specs, mockups)
    README.md         (feature overview)

FEATURE_PATH=qa-agent-os/features/[normalized-name]
```

### Key Points

- Feature names are normalized to lowercase kebab-case
- The `documentation/` folder will store raw source documents
- README.md provides an overview of the feature structure
- The FEATURE_PATH variable is passed to subsequent phases

### Next Steps

Phase 2 will gather all feature documentation (BRD, API specs, mockups) and store them in the documentation/ folder.

Proceed to Phase 2.
