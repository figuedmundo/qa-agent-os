# /automate-testcases Command

## Purpose

Convert manual test cases into executable Playwright test scripts with Page Object Model pattern, bridging the gap between QA test planning and test automation while handling application authentication and DOM exploration seamlessly.

## Usage

```bash
/automate-testcases WYX-123
/automate-testcases "TICKET-001"
/automate-testcases ticket-abc-456
```

## Smart Features

This command includes intelligent features that make automation easier:

### 1. Smart Context Detection
- Automatically discovers existing automation in ticket folder
- Shows regeneration options if automation exists
- Validates test-cases.md presence and readability
- Loads feature context for informed automation

### 2. Existing Automation Detection
- Detects if you're re-automating an existing ticket
- Offers 3 re-execution options:
  - Regenerate (overwrite all automated tests)
  - Append (add new tests to existing suite)
  - Cancel (no changes)

### 3. Hybrid DOM Exploration
- Uses Playwright MCP tools to explore live application DOM
- Captures selector strategy priority: ID > data-testid > role > class > tag
- Verifies all selectors against live DOM before code generation
- Optional page-structure.json for complex applications (10+ elements)

### 4. Standards-Compliant Generation
- Follows POM patterns from automation standards
- Applies AAA pattern (Arrange-Act-Assert) to all tests
- Uses team-specific configuration from runtime discovery
- Includes comprehensive utilities and documentation

## Execution Phases

This is an orchestrated command with 5 phases (0-4):

{{PHASE 0: @qa-agent-os/commands/automate-testcases/0-detect-context.md}}

{{PHASE 1: @qa-agent-os/commands/automate-testcases/1-setup-exploration.md}}

{{PHASE 2: @qa-agent-os/commands/automate-testcases/2-generate-pom.md}}

{{PHASE 3: @qa-agent-os/commands/automate-testcases/3-generate-tests.md}}

{{PHASE 4: @qa-agent-os/commands/automate-testcases/4-utilities-docs.md}}

## Workflow Scenarios

### Scenario 1: First-Time Automation for Ticket

```
/automate-testcases WYX-123
  ├─ Phase 0: Detects test-cases.md exists
  │           No automated-tests/ folder found → New automation
  │           Loads feature-knowledge.md and feature-test-strategy.md
  ├─ Phase 1: Initialize Playwright with auth token
  │           Navigate to application and explore DOM
  │           Capture selectors for all interactive elements
  ├─ Phase 2: Generate BasePage with common utilities
  │           Generate LoginPage, DashboardPage POMs
  │           Verify all selectors against live DOM
  ├─ Phase 3: Parse test-cases.md for test scenarios
  │           Generate login.spec.ts with AAA pattern
  │           Map test cases to POM methods (no raw Playwright)
  ├─ Phase 4: Generate auth-helper.ts, wait-helpers.ts
  │           Create test-data.ts from test case data
  │           Generate README.md with usage instructions
  └─ Creates: automated-tests/ with complete test suite
```

### Scenario 2: Regeneration with Existing Automation

```
/automate-testcases WYX-123
  ├─ Phase 0: Detects automated-tests/ exists
  │           Offers: [1] Regenerate [2] Append [3] Cancel
  │           User chooses "1 - Regenerate"
  ├─ Phases 1-4: Full regeneration process
  │              Overwrites existing automated-tests/
  │              Updates all POMs and test specs
  │              Refreshes utilities and documentation
  └─ Creates: Fresh automation with latest patterns
```

### Scenario 3: Append New Tests to Existing Suite

```
/automate-testcases WYX-124
  ├─ Phase 0: Detects automated-tests/ exists
  │           User chooses "2 - Append"
  ├─ Phase 1: Initialize browser, explore new page sections
  │           Identify new elements not in existing POMs
  ├─ Phase 2: Update existing POMs with new methods
  │           Or create new POM for new page/component
  ├─ Phase 3: Generate new test specs only
  │           Append to existing test suite
  ├─ Phase 4: Update utilities if needed
  │           Update README with new test information
  └─ Creates: Extended automation preserving existing tests
```

## Success Criteria

When /automate-testcases completes successfully, you will have:

**For New Automation:**
- ✓ Automated tests folder created: `features/[feature-name]/[ticket-id]/automated-tests/`
- ✓ Directory structure with pom/, tests/, utils/, fixtures/ subdirectories
- ✓ POM classes generated:
  - BasePage with shared utilities
  - One POM per page/component with verified selectors
  - SELECTORS object grouping, action/getter methods
- ✓ Test scripts generated:
  - One spec file per test scenario
  - AAA pattern enforcement
  - POM method usage (no raw Playwright)
  - Setup/teardown with beforeEach/afterEach
  - Traceability links to test-cases.md
- ✓ Utility files:
  - auth-helper.ts for token-based authentication
  - wait-helpers.ts with custom wait conditions
  - assertion-helpers.ts with common patterns
  - test-data.ts with fixture data
  - config.ts with environment settings
- ✓ Documentation:
  - README.md with usage, troubleshooting, selector strategy
  - Optional page-structure.json with DOM reference
- ✓ All files are valid TypeScript with correct imports

**For Regeneration/Append:**
- ✓ Existing automation updated appropriately
- ✓ No unnecessary overwriting (if append chosen)
- ✓ All tests remain executable after changes

## Next Steps

After /automate-testcases completes:

1. **Review generated tests** - Examine POMs, test specs, utilities
2. **Run tests locally** - Execute with `npm test` or `npx playwright test`
3. **Verify selectors** - Check that all selectors work against live application
4. **Customize utilities** - Adjust auth-helper.ts or wait conditions if needed
5. **Run in CI/CD** - Integrate with your pipeline for continuous testing

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
5. **Standards compliance**: Follows @qa-agent-os/standards/automation/ conventions

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

*This command automates the conversion of manual test cases to executable Playwright tests, maintaining standards compliance and traceability throughout the process.*
