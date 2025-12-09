# /start-feature Command

## Purpose

Initialize a feature folder structure only. This command creates the directory hierarchy needed for feature planning without creating any content files. Use this as the first step of the feature planning workflow.

## Usage

```bash
/start-feature "User Authentication"
/start-feature user-authentication
/start-feature
```

If no feature name is provided, you'll be prompted interactively.

## Workflow Overview

This command performs a single task:
- Creates the feature folder structure: `qa-agent-os/features/[feature-name]/documentation/`
- No placeholder files or content generated
- Simple and fast structure initialization
- Ready for documentation gathering with `/gather-docs`

## Execution

I will:

1. Get the feature name from you (if not provided as a parameter)
2. Normalize it to lowercase kebab-case format
3. Check if the feature folder already exists
4. If it exists, ask whether to overwrite or cancel
5. Create the folder structure: `qa-agent-os/features/[feature-name]/documentation/`
6. Display success message with next steps

## Feature Name Normalization

Feature names are normalized to lowercase kebab-case:
- "User Authentication" → "user-authentication"
- "TWRR Analysis" → "twrr-analysis"
- "Payment_Processing" → "payment-processing"
- Special characters are removed or converted to hyphens

## Success Output

When complete, you'll see:
```
Feature structure created successfully!

Feature: [User-provided Feature Name]
Location: qa-agent-os/features/[feature-name]/

Structure created:
  features/[feature-name]/
    documentation/    (for BRD, API specs, mockups, technical docs)

FEATURE_PATH=qa-agent-os/features/[feature-name]

Next steps:
1. Gather documentation: Run /gather-docs
2. Analyze documentation: Run /analyze-requirements
```

## Next Steps

After `/start-feature` completes:

1. Run `/gather-docs` to see guidance on what documentation to collect
2. Manually place your documentation files in the `documentation/` folder
3. Run `/analyze-requirements` to create `feature-knowledge.md` and `feature-test-strategy.md`

## Related Commands

- `/gather-docs` - Display guidance for documentation gathering (user-driven)
- `/analyze-requirements` - Analyze gathered docs and create feature knowledge and strategy
- `/start-ticket` - Create ticket structure for this feature

---

*This command is part of the redesigned QA workflow that separates structure initialization from documentation gathering and analysis.*
