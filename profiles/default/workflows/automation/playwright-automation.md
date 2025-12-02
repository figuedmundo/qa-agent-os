# Playwright Test Automation Workflow

This workflow orchestrates the complete process of converting manual test cases into executable Playwright test scripts with Page Object Model pattern, DOM exploration, and comprehensive utilities.

## Core Responsibilities

1. **Context Detection**: Validate environment and detect existing automation
2. **Browser Setup**: Initialize Playwright with authentication
3. **DOM Exploration**: Explore application DOM and capture selectors
4. **POM Generation**: Create Page Object Model classes from explored elements
5. **Test Generation**: Map manual test cases to automated test scripts
6. **Utilities Generation**: Create helper functions and configuration files
7. **Documentation**: Generate README and usage instructions

**Note:** The placeholder `[ticket-path]` refers to the full path to the ticket, for example: `qa-agent-os/features/feature-name/TICKET-123`.

**Note:** The placeholder `[feature-knowledge-path]` refers to the path to feature-knowledge.md, for example: `qa-agent-os/features/feature-name/feature-knowledge.md`.

**Note:** The placeholder `[feature-strategy-path]` refers to the path to feature-test-strategy.md, for example: `qa-agent-os/features/feature-name/feature-test-strategy.md`.

---

## Integration with QA Workflow

### Positioning in QA Agent OS Workflow

The automation workflow integrates seamlessly after test case planning:

**QA Workflow Sequence:**
1. `/plan-feature` - Create feature knowledge and test strategy
2. `/plan-ticket` - Create test plan for specific ticket
3. `/generate-testcases` - Generate manual test cases
4. **`/automate-testcases`** - Convert test cases to automated scripts (this workflow)
5. Run automated tests and iterate

### Prerequisites

Before running `/automate-testcases`, ensure:
- Feature knowledge exists (`feature-knowledge.md`)
- Test strategy exists (`feature-test-strategy.md`)
- Test cases exist (`test-cases.md`)
- Playwright is installed and configured
- Authentication mechanism is configured

---

## Overall Automation Process

### High-Level Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  Phase 0: Detection & Validation                 │
│  • Validate ticket and test cases exist                         │
│  • Check for existing automated-tests folder                    │
│  • Load configuration (team-specific or defaults)               │
│  • Verify environment variables (BASE_URL, TEST_AUTH_TOKEN)     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              Phase 1: Browser Setup & DOM Exploration            │
│  • Initialize Playwright session with authentication            │
│  • Navigate to application with auth token                      │
│  • Execute DOM exploration workflow (see dom-exploration.md)    │
│  • Capture all interactive elements and selectors               │
│  • Optional: Generate page-structure.json for complex pages     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Phase 2: POM Generation                        │
│  • Generate BasePage class with common utilities                │
│  • Create one POM class per page/component                      │
│  • Execute POM generation workflow (see pom-generation.md)      │
│  • Apply selector priority strategy                             │
│  • Verify selectors against live DOM                            │
│  • Enforce POM pattern standards                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Phase 3: Test Script Generation                 │
│  • Parse test-cases.md for test scenarios                       │
│  • Execute test generation workflow (see test-generation.md)    │
│  • Map each test case to test spec                              │
│  • Apply AAA pattern (Arrange-Act-Assert)                       │
│  • Use POM methods exclusively (no raw Playwright)              │
│  • Reference fixtures for test data                             │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│               Phase 4: Utilities & Documentation                 │
│  • Generate auth-helper.ts from auth configuration              │
│  • Generate wait-helpers.ts with custom wait conditions         │
│  • Generate assertion-helpers.ts with common patterns           │
│  • Create test-data.ts from test cases                          │
│  • Create config.ts with environment settings                   │
│  • Generate README.md with usage instructions                   │
│  • Include troubleshooting guide                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## Input Sources

### Primary Inputs

**1. test-cases.md**
- Location: `[ticket-path]/test-cases.md`
- Purpose: Source of manual test cases to automate
- Content: Test case ID, steps, expected results, test data
- Usage: Parsed to generate test scripts and extract test data

**2. feature-knowledge.md**
- Location: `[feature-knowledge-path]`
- Purpose: Business rules, APIs, edge cases context
- Content: 8 sections including requirements, business rules, APIs
- Usage: Referenced for test context and traceability

**3. feature-test-strategy.md**
- Location: `[feature-strategy-path]`
- Purpose: Testing approach, tools, environment setup
- Content: 10 sections including test strategy, risks, tools
- Usage: Referenced for testing approach and quality gates

### Configuration Sources

**4. Team-Specific Configuration**
- Location: `qa-agent-os/config/automation/` (if exists)
- Purpose: Team's Playwright configuration and patterns
- Content: Auth config, POM patterns, framework dependencies
- Usage: Overrides defaults for team-specific needs

**5. Environment Variables**
- `BASE_URL`: Application base URL
- `TEST_AUTH_TOKEN`: Authentication token for test user
- `BROWSER`: Browser to use (chromium, firefox, webkit)
- `HEADLESS`: Run tests in headless mode (true/false)

### Reference Templates

**6. POM Pattern Template**
- Location: `pom-pattern-template.ts` (in implementation/)
- Purpose: Reference structure for Page Object Model classes
- Usage: Template for generating POM classes

**7. Test Output Structure**
- Location: `test-output-structure.md` (in implementation/)
- Purpose: Directory organization and file naming patterns
- Usage: Determines file structure for generated automation

---

## Output Artifacts

### Generated Directory Structure

```
[ticket-path]/automated-tests/
├── pom/                           # Page Object Model classes
│   ├── BasePage.ts                # Base class with common utilities
│   ├── LoginPage.ts               # Login page object
│   ├── DashboardPage.ts           # Dashboard page object
│   └── components/                # Reusable component pages
│       └── ModalComponent.ts
├── tests/                         # Test script files
│   ├── login-functionality.spec.ts
│   └── session-management.spec.ts
├── fixtures/                      # Test data and fixtures
│   └── test-data.ts               # Test data from test cases
├── utils/                         # Helper utilities
│   ├── auth-helper.ts             # Authentication utilities
│   ├── wait-helpers.ts            # Custom wait conditions
│   └── assertion-helpers.ts       # Common assertion patterns
├── page-structure.json            # Optional: DOM structure documentation
└── README.md                      # Usage instructions and troubleshooting
```

### Key Outputs

**1. Page Object Models (pom/)**
- One POM class per page/component
- BasePage with shared functionality
- Selectors grouped in SELECTORS object
- Action methods for user interactions
- Getter methods for data retrieval
- Wait condition methods

**2. Test Scripts (tests/)**
- One spec file per test scenario group
- AAA pattern enforced (Arrange-Act-Assert)
- POM methods used exclusively
- Test data from fixtures
- Traceability links to test cases

**3. Test Data (fixtures/)**
- Test data extracted from test cases
- Environment-specific configuration
- Custom Playwright fixtures (if needed)

**4. Utilities (utils/)**
- Authentication helper functions
- Custom wait conditions
- Common assertion patterns
- Browser helper functions

**5. Documentation**
- README.md with usage instructions
- Troubleshooting guide
- Optional page-structure.json for complex pages

---

## Quality Gates and Verification

### Phase 0 Quality Gates

**Validation Checks:**
- test-cases.md exists and is readable
- feature-knowledge.md exists
- feature-test-strategy.md exists
- Configuration is valid (team config or defaults)
- Environment variables are set
- Playwright is installed

**If validation fails:**
- Provide clear error message
- Guide user to fix the issue
- Stop execution until fixed

### Phase 1 Quality Gates

**DOM Exploration Verification:**
- Browser launched successfully
- Authentication successful
- All pages in test cases accessible
- Interactive elements captured
- Selectors verified for uniqueness
- Selector quality meets threshold (80% stable selectors)

**Quality Metrics:**
- Selector priority distribution (data-testid > ID > role > class > tag)
- Element coverage (all test case steps covered)
- Selector stability verified

### Phase 2 Quality Gates

**POM Generation Verification:**
- All POMs extend BasePage
- Selectors in SELECTORS object
- Selector priority order followed
- Public locators for assertions
- Method naming conventions followed
- No hardcoded URLs or test data
- TypeScript compilation successful
- All selectors verified against live DOM

**Standards Compliance:**
- `@qa-agent-os/standards/automation/pom-patterns.md`
- `@qa-agent-os/standards/global/coding-style.md`

### Phase 3 Quality Gates

**Test Script Verification:**
- All test cases mapped to test specs
- AAA pattern enforced in all tests
- POM methods used (no raw Playwright selectors)
- Test data from fixtures (no hardcoded values)
- Traceability links complete
- Test names include TC-ID
- TypeScript compilation successful
- Import paths valid

**Standards Compliance:**
- `@qa-agent-os/standards/automation/playwright.md`
- `@qa-agent-os/standards/testing/test-writing.md`

### Phase 4 Quality Gates

**Utilities and Documentation:**
- All utility files generated
- README includes troubleshooting
- Configuration is environment-aware
- Test data properly structured
- No TypeScript errors
- All imports resolved

---

## Error Handling and Recovery

### Common Errors

**1. Authentication Failure**
```
Error: Authentication verification failed
Solution:
  - Verify TEST_AUTH_TOKEN is valid
  - Check authentication method in config
  - Ensure application is accessible at BASE_URL
```

**2. Page Not Accessible**
```
Error: Failed to load page during exploration
Solution:
  - Verify page URL in test cases
  - Check if page requires additional navigation steps
  - Ensure user has permissions for page
```

**3. Selector Not Unique**
```
Warning: Selector not unique: button[type="submit"]
Action: Refined with text selector: button:has-text("Sign In")
```

**4. Test Case Mapping Ambiguity**
```
Warning: Test case requires page not in POMs: PasswordResetPage
Action: Added TODO comment, test marked as skip() until POM created
```

### Recovery Strategies

**Browser Crash:**
- Restart browser session
- Re-authenticate
- Resume exploration from last successful page

**Selector Verification Failure:**
- Use fallback selector strategy
- Add comment explaining selector choice
- Continue with warning

**Missing Test Data:**
- Add TODO to fixtures/test-data.ts
- Mark test as skip() until data provided
- Document in README.md

---

## Workflow Execution Example

### Step-by-Step Execution

**User runs:**
```bash
/automate-testcases WYX-123
```

**Phase 0: Detection & Validation**
```
✓ Ticket found: features/user-auth/WYX-123
✓ test-cases.md exists (8 test cases)
✓ feature-knowledge.md loaded
✓ feature-test-strategy.md loaded
✓ Configuration loaded (team config)
✓ Environment variables verified
✓ Playwright installed: v1.40.0
```

**Phase 1: Browser Setup & DOM Exploration**
```
✓ Launching Playwright browser (chromium, headless)
✓ Authenticating with token
✓ Navigating to application
✓ Authentication successful
✓ Exploring Login Page (6 elements)
✓ Exploring Dashboard Page (15 elements)
✓ Exploring Profile Page (8 elements)
✓ All selectors verified
✓ Selector quality: Excellent (80% stable)
```

**Phase 2: POM Generation**
```
✓ Generating BasePage.ts
✓ Generating LoginPage.ts (6 elements, 5 action methods)
✓ Generating DashboardPage.ts (15 elements, 8 action methods)
✓ Generating ProfilePage.ts (8 elements, 6 action methods)
✓ All POMs verified against live DOM
✓ Standards compliance: 100%
✓ TypeScript compilation: Success
```

**Phase 3: Test Script Generation**
```
✓ Parsing test-cases.md (8 test cases)
✓ Generating login-functionality.spec.ts (5 test cases)
✓ Generating session-management.spec.ts (3 test cases)
✓ AAA pattern enforced in all tests
✓ POM methods used exclusively
✓ Test data from fixtures
✓ Traceability links complete
✓ TypeScript compilation: Success
```

**Phase 4: Utilities & Documentation**
```
✓ Generating auth-helper.ts
✓ Generating wait-helpers.ts
✓ Generating assertion-helpers.ts
✓ Creating test-data.ts
✓ Creating config.ts
✓ Generating README.md with troubleshooting
✓ All utilities validated
```

**Completion Summary:**
```
════════════════════════════════════════════════════════════
  Automation Complete: WYX-123
════════════════════════════════════════════════════════════

Generated Files:
  - Page Objects: 4 (BasePage + 3 pages)
  - Test Specs: 2 (8 test cases automated)
  - Utilities: 3 helper files
  - Documentation: README.md with usage instructions

Test Cases Automated: 8/8 (100%)
Standards Compliance: 100%
Selector Quality: Excellent (80% stable selectors)

Next Steps:
  1. Review generated code in automated-tests/
  2. Run tests: npx playwright test
  3. Debug with: npx playwright test --ui

Location: features/user-auth/WYX-123/automated-tests/
════════════════════════════════════════════════════════════
```

---

## Workflow Sub-Processes

This main workflow coordinates four specialized sub-workflows:

1. **DOM Exploration Workflow** (`dom-exploration.md`)
   - Details live DOM exploration process
   - Selector capture and verification
   - MCP tools usage
   - page-structure.json generation

2. **POM Generation Workflow** (`pom-generation.md`)
   - BasePage class generation
   - Per-page POM class structure
   - Selector organization
   - Method generation logic

3. **Test Generation Workflow** (`test-generation.md`)
   - Test case parsing
   - AAA pattern application
   - Fixture data usage
   - Traceability linking

4. **Utilities Generation** (documented in Phase 4 command file)
   - Authentication helpers
   - Wait helpers
   - Assertion helpers
   - Configuration files

---

## Standards Reference

**Automation Standards:**
- `@qa-agent-os/standards/automation/playwright.md` - Test script standards
- `@qa-agent-os/standards/automation/pom-patterns.md` - POM construction standards
- `@qa-agent-os/standards/automation/test-data-management.md` - Test data handling

**Global Standards:**
- `@qa-agent-os/standards/global/coding-style.md` - TypeScript conventions
- `@qa-agent-os/standards/global/error-handling.md` - Error handling patterns
- `@qa-agent-os/standards/global/commenting.md` - Documentation requirements

**Testing Standards:**
- `@qa-agent-os/standards/testing/test-writing.md` - General test best practices
- `@qa-agent-os/standards/frontend/components.md` - Component interaction patterns

---

## Maintenance and Iteration

### Regeneration Support

The workflow supports regeneration options:

**If automated-tests/ already exists:**
```
Existing automation detected for WYX-123

Options:
  [1] Regenerate all - Delete and recreate all automation files
  [2] Append new tests - Add tests for new test cases only
  [3] Cancel - Keep existing automation

Your choice:
```

**Option 1: Regenerate All**
- Deletes existing automated-tests/ folder
- Runs complete automation workflow
- Use when: Major changes to test cases or POMs needed

**Option 2: Append New Tests**
- Keeps existing POMs and tests
- Adds automation only for new test cases
- Use when: Adding test cases to existing automation

**Option 3: Cancel**
- No changes made
- User can manually edit existing automation

### Updating Automation After Changes

**When test cases change:**
1. Update test-cases.md manually
2. Run `/automate-testcases [ticket-id]` with regenerate option
3. Review changes in automated-tests/

**When feature knowledge changes:**
1. Gap detection in `/plan-ticket` updates feature-knowledge.md
2. Automation references updated knowledge automatically
3. Traceability links remain valid

---

## Success Criteria

The automation workflow is successful when:

1. All test cases from test-cases.md are automated
2. All generated code compiles without errors
3. All imports are valid
4. Standards compliance is 100%
5. Selector quality meets threshold (80% stable)
6. Tests are ready to run with `npx playwright test`
7. README provides clear usage instructions
8. Traceability links are complete

---

*This workflow ensures consistent, high-quality test automation that follows QA Agent OS standards and integrates seamlessly with the existing QA workflow.*
