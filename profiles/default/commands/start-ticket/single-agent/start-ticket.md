# /start-ticket Command

## Purpose

Initialize a ticket folder structure with smart feature detection. This command creates the directory hierarchy for a specific ticket within an existing feature, without creating any test plan or test case files.

## Usage

```bash
/start-ticket "TEST-123"
/start-ticket TEST-123
/start-ticket
```

If no ticket ID is provided, you'll be prompted interactively.

## Workflow Overview

This command performs several tasks:

1. Get the ticket ID from you (if not provided)
2. Scan for existing features in `qa-agent-os/features/`
3. Guide you to select or create a feature if needed
4. Check if ticket already exists in the selected feature
5. Create the ticket folder structure: `qa-agent-os/features/[feature-name]/[ticket-id]/documentation/`
6. Display success message with next steps

## Smart Feature Detection

### Scenario 1: No Features Exist
```
Error: No features found in qa-agent-os/features/

Please create a feature first:
  /start-feature [feature-name]

Then return to plan the ticket.
```

### Scenario 2: Single Feature Exists
```
Found 1 feature: user-authentication

Is this the correct feature for ticket TEST-123? [y/n]
```
- Answer yes to proceed with this feature
- Answer no to view all features or exit

### Scenario 3: Multiple Features Exist
```
Which feature does ticket TEST-123 belong to?

Features found:
  [1] user-authentication
  [2] payment-processing
  [3] Create new feature

Choose [1-3]:
```
- Select the feature number to proceed
- Select "Create new feature" to run `/start-feature` first

## Ticket Existence Handling

If the ticket folder already exists:
```
Ticket TEST-123 already exists in feature user-authentication.

Options:
  [1] Overwrite structure (delete and recreate)
  [2] Cancel (keep existing)

Choose [1/2]:
```

## Success Output

When complete, you'll see:
```
Ticket structure created successfully!

Feature: user-authentication
Ticket: TEST-123
Location: qa-agent-os/features/user-authentication/TEST-123/

Structure created:
  features/user-authentication/TEST-123/
    documentation/    (for ticket-specific docs, acceptance criteria, technical specs)

FEATURE_PATH=qa-agent-os/features/user-authentication
TICKET_PATH=qa-agent-os/features/user-authentication/TEST-123

Next steps:
1. Gather documentation: Run /gather-docs
2. Analyze documentation: Run /analyze-requirements
```

## Next Steps

After `/start-ticket` completes:

1. Run `/gather-docs` to see guidance on what ticket-specific documentation to collect
2. Manually place your documentation files in the ticket's `documentation/` folder
3. Run `/analyze-requirements` to create `test-plan.md` with gap detection

## Related Commands

- `/gather-docs` - Display guidance for documentation gathering (user-driven)
- `/analyze-requirements` - Analyze gathered docs and create test plan with gap detection
- `/start-feature` - Create feature structure (if needed)
- `/generate-testcases` - Generate test cases from test-plan.md

---

*This command is part of the redesigned QA workflow that separates structure initialization from documentation gathering and analysis.*
