# Integration Standards: Playwright Automation into QA Agent OS

## Overview
This document defines how the new `/automate-testcases` command integrates with existing QA Agent OS workflows, standards, and tooling.

## Integration Architecture

### Position in QA Workflow

```
/plan-feature
    ↓
feature-knowledge.md + feature-test-strategy.md
    ↓
/plan-ticket
    ↓
test-plan.md + test-cases.md
    ↓
/automate-testcases ← NEW COMMAND
    ↓
automated-tests/ (POM + test scripts)
    ↓
CI/CD Pipeline (automated execution)
```

The `/automate-testcases` command takes manual test cases and converts them into executable Playwright scripts.

## Input/Output Contracts

### Input
- **Source:** Test cases from `test-cases.md` in ticket folder
- **Format:** Structured markdown with test case sections
- **Required Fields:** Test title, preconditions, steps, expected results
- **Optional Fields:** Test data, fixture references, priority

### Output
- **Location:** `features/[feature-name]/[ticket-id]/automated-tests/`
- **Files:**
  - `pom/` - Page Object Model classes
  - `tests/` - Test specification files
  - `utils/` - Helper functions
  - `fixtures/` - Test data and config
  - `README.md` - Automation guide
  - `page-structure.json` (optional) - DOM documentation

### Output Format Guarantees
- All generated code is valid TypeScript
- All tests are executable with `npx playwright test`
- All selectors are verified against live DOM
- All imports reference correct file paths
- All async operations properly awaited

## File System Integration

### Ticket Folder Structure After Automation

```
features/[feature-name]/[ticket-id]/
├── documentation/           # Existing: raw documents
├── feature-knowledge.md     # Existing: feature-level knowledge
├── test-plan.md            # Existing: ticket-level test plan
├── test-cases.md           # Existing: manual test cases
└── automated-tests/        # NEW: automation artifacts
    ├── pom/
    │   ├── BasePage.ts
    │   └── [PageName]Page.ts
    ├── tests/
    │   └── [feature-area].spec.ts
    ├── utils/
    │   ├── auth-helper.ts
    │   ├── wait-helpers.ts
    │   └── assertion-helpers.ts
    ├── fixtures/
    │   ├── test-data.ts
    │   ├── config.ts
    │   └── selectors.ts
    ├── page-structure.json
    └── README.md
```

## Standards Compliance Integration

### Standards Files Referenced

The command respects existing standards in `qa-agent-os/standards/`:

**Global Standards:**
- `global/coding-style.md` - TypeScript code style
- `global/conventions.md` - Naming, file organization
- `global/commenting.md` - Code documentation
- `global/error-handling.md` - Exception handling patterns
- `global/validation.md` - Input validation patterns
- `global/tech-stack.md` - Technology choices

**Testing Standards:**
- `testing/test-writing.md` - Test structure and patterns
- `testing/api-testing.md` - API testing approaches (if applicable)

**Frontend Standards:**
- `frontend/components.md` - Component interaction patterns
- `frontend/css.md` - Styling context for selector strategies
- `frontend/responsive.md` - Testing across breakpoints
- `frontend/accessibility.md` - ARIA and accessibility testing

### Standards Application in Code Generation

1. **Naming Conventions**
   - POM classes: PascalCase + "Page" suffix
   - Methods: camelCase, action-verb prefixed
   - Test files: kebab-case.spec.ts
   - Variables: camelCase, descriptive names

2. **Selector Strategies**
   - Follow priority order from `frontend/components.md`
   - ID > data-testid > role > class > tag
   - Comments explain complex selector logic

3. **Error Handling**
   - Follow `global/error-handling.md` patterns
   - No bare try/catch blocks
   - Meaningful error messages
   - Graceful failure handling

4. **Test Structure**
   - Follow `testing/test-writing.md` patterns
   - AAA Pattern: Arrange, Act, Assert
   - beforeEach/afterEach for setup/teardown
   - Descriptive test titles

5. **Validation**
   - Follow `global/validation.md` patterns
   - Validate inputs before use
   - Check element existence before interaction
   - Verify state transitions

## Command Integration Points

### `/automate-testcases` Phase Breakdown

**Phase 0: Detection & Validation**
- Detect if ticket already has automated tests
- If exists, offer: [1] Regenerate [2] Append [3] Cancel
- Load test-cases.md for processing

**Phase 1: Setup & Exploration**
- Initialize Playwright session with auth token
- Navigate to application URL
- Explore DOM structure
- Capture page elements and selectors
- Optional: Save to page-structure.json

**Phase 2: POM Generation**
- Generate BasePage class with common utilities
- Generate POM class for each page/component
- Apply selector strategy from standards
- Include action and getter methods

**Phase 3: Test Generation**
- Generate test spec files
- Map each test case from test-cases.md to test block
- Apply AAA pattern
- Include proper setup/teardown

**Phase 4: Utilities & Documentation**
- Generate utility helpers (auth, wait, assertions)
- Create fixtures (test data, config)
- Generate README.md with usage instructions
- Optional: Update feature knowledge with automation info

## CI/CD Integration Points

### Where Tests Run

Generated tests are designed to run in:
- **Local development:** `npx playwright test --ui`
- **CI pipeline:** `npm run test:playwright`
- **Selective execution:** `npx playwright test tests/login.spec.ts`
- **Headless mode:** Default for CI (configured in playwright.config.ts)

### Test Artifacts Generated

After test execution:
- **HTML Report:** `playwright-report/index.html`
- **JSON Report:** `test-results/results.json`
- **Screenshots:** `test-results/[test-name]-[browser]` (on failure)
- **Videos:** `test-results/[test-name]-[browser].webm` (on failure)

### Integration with Existing CI/CD

Generated tests should:
- Use same playwright.config.ts as existing tests
- Run in same environment as manual testing
- Generate reports in consistent location
- Follow same naming conventions as existing tests
- Integrate with existing test reporting tools

## Documentation Integration

### README Files Generated

Each `automated-tests/` folder includes `README.md` with:
- How to run tests locally
- How to run specific test files
- How to view reports
- How to add new tests
- Selector strategy explanation
- Common troubleshooting

### Cross-Document References

Generated code references:
- **Feature Knowledge:** `../../feature-knowledge.md` for business rules
- **Test Plan:** `../test-plan.md` for requirements
- **Standards:** Absolute paths to qa-agent-os/standards/
- **Documentation:** Internal paths to fixture/util files

### Traceability

Each generated test includes:
- Link back to test case from test-cases.md
- Link to feature-knowledge.md for business context
- Link to feature-test-strategy.md for testing approach
- Comments explaining complex scenarios

## Product Integration

### Feature-Knowledge Updates

The command offers to append automation information to feature-knowledge.md:
- Automation availability status
- Known selector strategies used
- Special handling required (modals, loading states, etc.)
- Links to automated test files

### Test-Plan Updates

Generated tests are cross-referenced in test-plan.md:
- Indication that tests are automated
- Link to automated test file and test case
- Execution environment requirements
- Dependencies or special setup

## Standards Enforcement

### Code Quality Checks

Generated code must pass:
- TypeScript strict mode compilation
- Playwright test validation
- Path resolution checks
- Selector syntax validation
- Async/await pattern validation

### Automated Verification

Before output, verify:
- [ ] All selectors work against live DOM
- [ ] All imports have valid paths
- [ ] All async operations are properly awaited
- [ ] All required utilities are included
- [ ] Test titles match test cases
- [ ] Error messages are meaningful
- [ ] Code follows style standards

## Extensibility Points

### Plugins & Customization

The system is designed to allow:
- Custom fixture loaders in `fixtures/`
- Project-specific helpers in `utils/`
- Extended POM base classes in `pom/BasePage.ts`
- Custom reporters via playwright.config.ts
- Environment-specific configurations in `fixtures/config.ts`

### Future Integration Plans

Potential future integrations:
- Test reporting dashboard
- Cross-feature test coordination
- Regression suite automation
- Performance testing integration
- Visual regression testing

## FILL IN THIS SECTION WITH

The spec writer should document:

1. **Specific Integration Points**
   - How `/automate-testcases` fits in your QA workflow
   - Where tests will be executed (local, CI, cloud)
   - How reports will be aggregated/shared

2. **Standards Customizations**
   - Any project-specific additions to standard selectors
   - Special wait conditions for this application
   - Custom assertion patterns
   - Environment-specific configurations

3. **CI/CD Pipeline Configuration**
   - Where to place playwright.config.ts
   - Test execution commands in CI
   - Report storage and aggregation
   - Failure notification strategy

4. **Quality Gates**
   - Test execution before merge
   - Coverage thresholds
   - Performance benchmarks
   - Flakiness detection

5. **Team Communication**
   - How to notify team of automation status
   - Where to document known issues
   - How to handle test maintenance
   - Feedback loops for test improvements
