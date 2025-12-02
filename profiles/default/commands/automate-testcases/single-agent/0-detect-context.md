# Phase 0: Smart Detection & Context Validation

## Smart Context Detection

This phase intelligently detects the context of your automation request and validates all prerequisites before proceeding with test generation.

**I will check:**

1. **Is ticket ID provided?** - If not, prompt for selection from available tickets
2. **Does test-cases.md exist?** - Required input for automation
3. **Does automated-tests/ folder already exist?** - If yes, show regeneration options
4. **Can I load feature context?** - Load feature-knowledge.md and feature-test-strategy.md
5. **Is configuration available?** - Discover team configuration or use defaults

### Scenario 1: Ticket ID Provided

If you provided a ticket ID in the command:

```
/automate-testcases WYX-123

✓ Ticket ID: WYX-123
✓ Searching for ticket folder...
```

I'll proceed directly to validation.

### Scenario 2: No Ticket ID - Interactive Selection

If no ticket ID provided, I'll scan for available tickets:

```
Which ticket would you like to automate?

Tickets with test cases found:
  [1] WYX-123 (Feature: User Authentication)
  [2] WYX-124 (Feature: User Authentication)
  [3] WYX-125 (Feature: Dashboard)
  [4] Enter ticket ID manually
```

**Your options:**
- **Select [1-3]** - Choose a ticket with existing test cases
- **Select [4]** - Manually enter ticket ID if not listed

### Scenario 3: Existing Automation Detected

If I detect that `automated-tests/` folder already exists in the ticket directory:

```
Automated tests already exist for ticket WYX-123.

Current automation structure:
  ├── pom/ (3 page objects)
  ├── tests/ (5 test specs)
  ├── utils/ (4 utility files)
  └── fixtures/ (2 fixture files)

Options:
  [1] Regenerate - Overwrite all automated tests with fresh generation
  [2] Append - Add new tests to existing automation suite
  [3] Cancel - Exit without changes
```

**Choose based on your needs:**
- **Option 1 - Regenerate**
  - Complete fresh start
  - Overwrites all existing automation
  - Useful when: Test cases significantly changed, or patterns need updating
  - Warning: All custom modifications will be lost

- **Option 2 - Append**
  - Preserves existing tests
  - Adds new POMs and test specs for new test cases
  - Updates existing POMs with new methods if needed
  - Useful when: Adding new test cases to existing suite

- **Option 3 - Cancel**
  - No changes made
  - Exit the command

### Scenario 4: New Automation

If no existing automation found:

```
✓ No existing automation found
✓ Proceeding with fresh automation generation
```

I'll proceed directly to Phase 1.

## Validation Checks

Before proceeding, I'll validate all prerequisites:

### 1. Ticket Folder Exists

```
✓ Checking ticket folder: features/user-auth/WYX-123/
```

**If not found:**
```
❌ Ticket folder not found: features/user-auth/WYX-123/

Please run ticket planning first:
  /plan-ticket WYX-123

Then return to automate the test cases.
```

### 2. Test Cases File Exists

```
✓ Checking test-cases.md: features/user-auth/WYX-123/test-cases.md
```

**If not found:**
```
❌ test-cases.md not found for ticket WYX-123

Manual test cases are required input for automation.

Please generate test cases first:
  /generate-testcases WYX-123

Then return to automate them.
```

### 3. Test Cases File is Readable

```
✓ Validating test-cases.md format
✓ Found 8 test cases to automate
```

**If invalid format:**
```
❌ test-cases.md has invalid format

Expected structure:
  - Test case sections with TC-IDs
  - Test steps with clear actions
  - Expected results for each step

Please ensure test-cases.md follows QA Agent OS format.
See: @qa-agent-os/standards/testcases/test-cases.md
```

### 4. Feature Context Available

```
✓ Loading feature context...
✓ Feature: User Authentication
✓ feature-knowledge.md loaded (8 sections)
✓ feature-test-strategy.md loaded (10 sections)
```

**If feature not found:**
```
⚠️  Feature context not found

While not required, feature context helps generate better automation:
  - Business rules inform test logic
  - API endpoints guide integration points
  - Edge cases ensure comprehensive coverage

Consider running:
  /plan-feature "User Authentication"

Continue without feature context? [y/n]
```

### 5. Configuration Discovery

```
✓ Discovering automation configuration...
✓ Found: qa-agent-os/config/automation/playwright-config.yml
✓ Configuration validated
```

**If no team config found:**
```
⚠️  No team configuration found. Using default settings.

To customize automation behavior, create a configuration file:
  qa-agent-os/config/automation/playwright-config.yml

Template available at:
  profiles/default/templates/automation/playwright-config-template.yml

For now, automation will proceed with safe defaults:
  - Authentication: query-param with TEST_AUTH_TOKEN
  - POM Pattern: Full BasePage with utilities
  - Browser: Chromium headless
  - Selector Priority: data-testid > ID > role > class > tag
```

### 6. Environment Variables Check

```
✓ Checking required environment variables...
✓ BASE_URL: http://localhost:3000
✓ TEST_AUTH_TOKEN: ••••••••••••••••
```

**If missing:**
```
❌ Required environment variables not set:
  - BASE_URL
  - TEST_AUTH_TOKEN

Set these in your environment:

  export BASE_URL=http://localhost:3000
  export TEST_AUTH_TOKEN=your_token_here

Or create .env file:

  echo "BASE_URL=http://localhost:3000" >> .env
  echo "TEST_AUTH_TOKEN=your_token_here" >> .env

For CI/CD, configure secrets in your pipeline settings.
```

### 7. Playwright Dependencies Check

```
✓ Checking Playwright installation...
✓ @playwright/test installed (v1.40.0)
```

**If not installed:**
```
⚠️  Playwright not found

Install Playwright to proceed:

  npm install -D @playwright/test
  npx playwright install

Or with yarn:

  yarn add -D @playwright/test
  npx playwright install

Then run this command again.
```

## Special Cases

### No Features Exist Yet

```
❌ No features found in project.

Please create a feature first:
  /plan-feature [feature-name]

Then plan and generate test cases:
  /plan-ticket [ticket-id]
  /generate-testcases [ticket-id]

Then return to automate the test cases.
```

### Empty Test Cases File

```
❌ test-cases.md is empty or has no test cases

Manual test cases are required to generate automation.

Please add test cases to test-cases.md, or regenerate:
  /generate-testcases WYX-123
```

### Application Not Accessible

```
⚠️  Cannot reach application at: http://localhost:3000

Phase 1 will attempt to connect. If connection fails:
  1. Ensure application is running
  2. Check BASE_URL is correct
  3. Verify network/firewall settings
  4. Check authentication token is valid

Continue anyway? [y/n]
```

## Context Summary

After all validations pass, I'll provide a summary:

```
════════════════════════════════════════════════════════════
  Automation Context Summary
════════════════════════════════════════════════════════════

Ticket: WYX-123
Feature: User Authentication
Test Cases: 8 test cases found
Feature Knowledge: Loaded (8 sections)
Test Strategy: Loaded (10 sections)
Configuration: Team config (playwright-config.yml)
Environment: Staging (https://staging.example.com)
Authentication: Query param with TEST_AUTH_TOKEN

Automation will generate:
  ├── pom/ (estimated 3 page objects)
  ├── tests/ (8 test specs from test cases)
  ├── utils/ (5 utility files)
  ├── fixtures/ (test data file)
  └── README.md

════════════════════════════════════════════════════════════
```

## Why This Matters

This detection logic ensures:
- All prerequisites are met before starting
- Existing work is not accidentally overwritten
- Clear error messages guide you to resolve issues
- Configuration is discovered and validated
- You have full control over regeneration vs. append
- Time is not wasted on invalid setups

## Next Phase

Based on detection results:
- **New automation** → Phase 1 (Setup & Exploration)
- **Regenerate** → Phase 1 (Fresh start with overwrite)
- **Append** → Phase 1 (Incremental with merge logic)
- **Cancel** → Exit command

Let me detect your automation context now.

**Provide the ticket ID or press Enter for interactive selection:**

[Ticket ID] (e.g., WYX-123, TICKET-001, ABC-456)
