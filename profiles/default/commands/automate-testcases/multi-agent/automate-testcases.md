# /automate-testcases Command (Multi-Agent Mode)

## Purpose

Convert manual test cases into executable Playwright test scripts using specialized test automation agent. This command uses Page Object Model pattern, live DOM exploration, and comprehensive utilities generation.

## Usage

```bash
/automate-testcases WYX-123
/automate-testcases "TICKET-001"
/automate-testcases ticket-abc-456
```

## Execution Flow

### PHASE 0: Smart Detection & Context Validation

This phase handles intelligent context detection and routing. This orchestration logic remains in the main command:

#### Step 1: Detect Ticket ID

If no ticket ID provided in command arguments, scan for available tickets with test cases:

```bash
# Find tickets with test-cases.md
find qa-agent-os/features/ -name "test-cases.md" -type f
```

**Present ticket selection:**

```
Which ticket would you like to automate?

Tickets with test cases found:
  [1] WYX-123 (Feature: User Authentication)
  [2] WYX-124 (Feature: User Authentication)
  [3] WYX-125 (Feature: Dashboard)
  [4] Enter ticket ID manually
```

**Handle selection:**
- If user selects [1-3] → Set TICKET_ID from selection
- If user selects [4] → Prompt for manual ticket ID entry
- If only ONE ticket exists → Auto-select and confirm with user
- If NO tickets exist → Display message and exit:
  ```
  No tickets with test cases found.

  Please run ticket planning first:
    /plan-ticket [ticket-id]
    /generate-testcases [ticket-id]

  Then return to automate the test cases.
  ```

#### Step 2: Validate Ticket Prerequisites

Check required files and folders exist:

```bash
# Check ticket folder exists
if [ ! -d "qa-agent-os/features/[feature-name]/[ticket-id]/" ]; then
  echo "Error: Ticket folder not found"
  echo "Please run: /plan-ticket [ticket-id]"
  exit 1
fi

# Check test-cases.md exists
if [ ! -f "qa-agent-os/features/[feature-name]/[ticket-id]/test-cases.md" ]; then
  echo "Error: test-cases.md not found"
  echo "Please run: /generate-testcases [ticket-id]"
  exit 1
fi
```

**If validation fails:**
- Provide clear error message
- Guide user to resolve issue
- Exit command

#### Step 3: Detect Existing Automation

Check if `automated-tests/` folder already exists in ticket directory.

**If automated-tests/ exists**, present re-execution options:

```
Automated tests already exist for ticket [ticket-id].

Current automation structure:
  ├── pom/ (X page objects)
  ├── tests/ (Y test specs)
  ├── utils/ (Z utility files)
  └── fixtures/ (N fixture files)

Options:
  [1] Regenerate - Overwrite all automated tests with fresh generation
  [2] Append - Add new tests to existing automation suite
  [3] Cancel - Exit without changes
```

**User choice determines routing:**
- Option [1] - Set MODE=regenerate, proceed to Phase 1 (full automation)
- Option [2] - Set MODE=append, proceed to Phase 1 (incremental automation)
- Option [3] - Exit command

**If automated-tests/ does not exist:**
- Set MODE=new
- Proceed to Phase 1 (full automation)

#### Step 4: Load Feature Context

Load feature-level context for informed automation:

```bash
# Load feature knowledge
FEATURE_KNOWLEDGE=$(cat qa-agent-os/features/[feature-name]/feature-knowledge.md)

# Load feature test strategy
FEATURE_STRATEGY=$(cat qa-agent-os/features/[feature-name]/feature-test-strategy.md)
```

**If feature context not found:**
```
⚠️  Feature context not found

While not required, feature context helps generate better automation:
  - Business rules inform test logic
  - API endpoints guide integration points
  - Edge cases ensure comprehensive coverage

Consider running:
  /plan-feature [feature-name]

Continue without feature context? [y/n]
```

#### Step 5: Discover Configuration

Check for team-specific configuration:

```bash
# Check for team config
if [ -f "qa-agent-os/config/automation/playwright-config.yml" ]; then
  CONFIG_SOURCE="team-specific"
else
  CONFIG_SOURCE="defaults"
fi
```

#### Step 6: Verify Environment

Check required environment variables and dependencies:

```bash
# Check environment variables
if [ -z "$BASE_URL" ] || [ -z "$TEST_AUTH_TOKEN" ]; then
  echo "Error: Required environment variables not set"
  echo "Please set: BASE_URL, TEST_AUTH_TOKEN"
  exit 1
fi

# Check Playwright installation
if ! npm list @playwright/test &>/dev/null; then
  echo "Warning: Playwright not installed"
  echo "Install with: npm install -D @playwright/test"
  exit 1
fi
```

#### Step 7: Context Summary

Display summary of automation context:

```
════════════════════════════════════════════════════════════
  Automation Context Summary
════════════════════════════════════════════════════════════

Ticket: [ticket-id]
Feature: [feature-name]
Test Cases: X test cases found
Feature Knowledge: Loaded (8 sections) / Not found
Test Strategy: Loaded (10 sections) / Not found
Configuration: Team config / Defaults
Environment: [BASE_URL]
Authentication: [Method] with TEST_AUTH_TOKEN
Mode: New / Regenerate / Append

Automation will generate:
  ├── pom/ (estimated X page objects)
  ├── tests/ (X test specs from test cases)
  ├── utils/ (5 utility files)
  ├── fixtures/ (test data file)
  └── README.md

════════════════════════════════════════════════════════════

Proceeding to automation...
```

### PHASE 1-4: Test Automation Workflow

Use the **test-automator** subagent to execute the complete automation workflow.

Provide the test-automator with:
- Ticket path: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Feature knowledge path: `qa-agent-os/features/[feature-name]/feature-knowledge.md` (if exists)
- Feature strategy path: `qa-agent-os/features/[feature-name]/feature-test-strategy.md` (if exists)
- Test cases: `qa-agent-os/features/[feature-name]/[ticket-id]/test-cases.md`
- Mode: new / regenerate / append (from Phase 0)
- Configuration source: team-specific / defaults (from Phase 0)
- Environment variables: BASE_URL, TEST_AUTH_TOKEN

The test-automator will execute all automation phases:

**Phase 1: Browser Setup & DOM Exploration**
- Initialize Playwright session with authentication
- Navigate to application pages
- Use Playwright MCP tools to explore DOM
- Capture selectors with priority strategy
- Verify selector uniqueness and stability
- Group elements by component
- Generate optional page-structure.json

**Phase 2: POM Generation**
- Generate BasePage with utilities
- Create page object classes for each page
- Apply selector grouping
- Implement action and getter methods
- Verify selectors against live DOM
- Extract reusable components
- Validate TypeScript compilation

**Phase 3: Test Script Generation**
- Parse test-cases.md
- Map test cases to test specs
- Apply AAA pattern
- Use POM methods exclusively
- Reference fixtures for test data
- Include traceability links
- Validate TypeScript compilation

**Phase 4: Utilities & Documentation**
- Generate auth-helper.ts
- Generate wait-helpers.ts
- Generate assertion-helpers.ts
- Create test-data.ts from test cases
- Create config.ts
- Generate comprehensive README.md
- Validate all utilities

### Completion Summary

After test-automator completes, display summary:

```
════════════════════════════════════════════════════════════
  Automation Complete: [ticket-id]
════════════════════════════════════════════════════════════

Generated Files:
  - Page Objects: X (BasePage + N pages)
  - Test Specs: Y (Z test cases automated)
  - Utilities: N helper files
  - Documentation: README.md with usage instructions

Test Cases Automated: Z/Z (100%)
Standards Compliance: 100%
Selector Quality: Excellent (N% stable selectors)

Next Steps:
  1. Review generated code in automated-tests/
  2. Run tests: npx playwright test
  3. Debug with: npx playwright test --ui

Location: qa-agent-os/features/[feature-name]/[ticket-id]/automated-tests/
════════════════════════════════════════════════════════════
```

## Workflow Scenarios

### Scenario 1: First-Time Automation

```
/automate-testcases WYX-123
  ├─ Phase 0: Validates ticket, detects no existing automation
  │           Shows context summary
  ├─ Phases 1-4: test-automator executes complete workflow
  │              • Browser setup & DOM exploration
  │              • POM generation with verified selectors
  │              • Test script generation with AAA pattern
  │              • Utilities and documentation
  └─ Creates: Complete automation suite in automated-tests/
```

### Scenario 2: Regeneration

```
/automate-testcases WYX-123
  ├─ Phase 0: Detects existing automation
  │           User selects "[1] Regenerate"
  ├─ Phases 1-4: test-automator regenerates everything
  │              Overwrites all files with fresh generation
  └─ Creates: Fresh automation suite (existing work replaced)
```

### Scenario 3: Append New Tests

```
/automate-testcases WYX-124
  ├─ Phase 0: Detects existing automation
  │           User selects "[2] Append"
  ├─ Phases 1-4: test-automator adds new tests
  │              • Explores new pages only
  │              • Updates or creates POMs
  │              • Generates new test specs only
  │              • Updates utilities if needed
  └─ Creates: Extended automation (preserves existing tests)
```

## Prerequisites

Before running this command:

1. **Test cases must exist** - Run `/plan-ticket` and `/generate-testcases` first
2. **Feature context required** - Run `/plan-feature` if feature doesn't exist
3. **Playwright installed** - Install with `npm install -D @playwright/test`
4. **Environment configured** - Set BASE_URL and TEST_AUTH_TOKEN environment variables
5. **Application accessible** - Test environment must be running and accessible

## Configuration

This command uses runtime configuration discovery:

1. **Team configuration** (if exists): `qa-agent-os/config/automation/playwright-config.yml`
2. **Fallback to templates**: Uses safe defaults from QA Agent OS templates
3. **Authentication setup**: References auth-token-config.md for token mechanism
4. **POM patterns**: References pom-pattern-template.ts for class structure
5. **Standards compliance**: Follows `@qa-agent-os/standards/automation/` conventions

See `qa-agent-os/config/automation/` for configuration options.

## Standards Referenced

This command enforces:
- `@qa-agent-os/standards/automation/playwright.md` - Test script structure
- `@qa-agent-os/standards/automation/pom-patterns.md` - POM construction
- `@qa-agent-os/standards/automation/test-data-management.md` - Test data handling
- `@qa-agent-os/standards/global/coding-style.md` - TypeScript conventions
- `@qa-agent-os/standards/global/error-handling.md` - Error handling patterns
- `@qa-agent-os/standards/testing/test-writing.md` - Test writing best practices
- `@qa-agent-os/standards/frontend/components.md` - Selector priority rules

## Related Commands

- `/plan-ticket` - Plan test coverage for ticket (run this first)
- `/generate-testcases` - Generate manual test cases (required input)
- `/plan-feature` - Plan entire feature (creates feature context)
- `/revise-test-plan` - Update test plan during testing

---

*This command automates the conversion of manual test cases to executable Playwright tests using the test-automator subagent, maintaining standards compliance and traceability throughout the process.*
