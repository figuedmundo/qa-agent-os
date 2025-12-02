# Test Generation Workflow

This workflow details the process of converting manual test cases from test-cases.md into executable Playwright test scripts following AAA pattern, using Page Object Model methods exclusively, with proper test data management and complete traceability.

## Core Responsibilities

1. **Test Case Parsing**: Read and understand manual test cases
2. **Test Organization**: Group test cases into logical test suites
3. **Test Spec Generation**: Create one spec file per test scenario group
4. **AAA Pattern Enforcement**: Ensure Arrange-Act-Assert structure
5. **POM Method Usage**: Use only POM methods, no raw Playwright
6. **Test Data Integration**: Reference fixture data, no hardcoded values
7. **Traceability Linking**: Connect tests to source test cases and requirements
8. **Standards Compliance**: Enforce coding standards and best practices

---

## Input from Previous Phases

### POM Generation Completion

The workflow receives completed Page Object Models:

```
automated-tests/pom/
├── BasePage.ts                    # Base class with shared utilities
├── [PageName]Page.ts              # One POM per page/component
└── components/
    └── [ComponentName].ts         # Reusable component POMs
```

**All POMs are:**
- ✓ Verified against live DOM
- ✓ Following standards compliance
- ✓ Ready for use in test scripts

### Test Cases to Automate

**Input: test-cases.md**
- Location: `[ticket-path]/test-cases.md`
- Contains: Manual test cases with steps and expected results
- Structure: Test ID, title, preconditions, steps, expected results, test data

---

## Step 1: Parse Test Cases

### Read and Analyze test-cases.md

```
✓ Reading: features/[feature-name]/[ticket-id]/test-cases.md
✓ Parsing test case structure...
```

### Extract Test Case Information

For each test case, capture:

**1. Test Identification**
```
- Test Case ID: WYX-123-TC-01
- Test Case Title: User can login with valid credentials
- Category/Feature: Login Functionality
```

**2. Test Steps**
```
Step 1: Navigate to login page
Step 2: Enter username
Step 3: Enter password
Step 4: Click submit button
```

**3. Expected Results**
```
Result 1: Login page displays
Result 2: Form fields are visible and enabled
Result 3: Page transitions to dashboard
Result 4: User name displayed in welcome message
```

**4. Test Data Requirements**
```
- validUser.email
- validUser.password
- validUser.name
```

**5. Preconditions**
```
- Valid user account exists
- Application is accessible
```

### Example Parsing Output

```
✓ Found 8 test cases to automate:

  WYX-123-TC-01: User can login with valid credentials
    - Category: Login Functionality
    - Steps: 4
    - Data entities: validUser
    - Prerequisites: Valid account exists

  WYX-123-TC-02: Login fails with invalid password
    - Category: Login Functionality
    - Steps: 4
    - Data entities: validUser (with wrong password)
    - Prerequisites: Valid account exists

  WYX-123-TC-03: Login fails with non-existent user
    - Category: Login Functionality
    - Steps: 4
    - Data entities: invalidUser
    - Prerequisites: None

  ... (5 more test cases)
```

---

## Step 2: Organize Test Cases by Scenario

### Group Related Test Cases

Analyze test cases to create logical groupings for test suites:

```
✓ Organizing test cases by scenario...

Login Functionality (5 test cases):
  ├── TC-01: Valid credentials
  ├── TC-02: Invalid password
  ├── TC-03: Non-existent user
  ├── TC-04: Empty field validation
  └── TC-05: Remember me functionality

Session Management (3 test cases):
  ├── TC-06: User remains logged in
  ├── TC-07: Logout clears session
  └── TC-08: Session expires after timeout
```

**Grouping logic:**
- Tests for same feature/page group together
- Related functionality grouped into suites
- Each group becomes a test.describe() block
- Group name becomes test suite description

### Map to Test Spec Files

```
✓ Determining test file structure...

Test specs to generate:
  - login-functionality.spec.ts (5 test cases)
  - session-management.spec.ts (3 test cases)

Organization pattern: Scenario-based (from config)
```

**File naming:**
- Convention: `[scenario-or-page]-[purpose].spec.ts`
- Examples: `login-functionality.spec.ts`, `user-profile.spec.ts`
- All lowercase, kebab-case

### Identify Required POMs

For each test spec file, determine which POMs are needed:

```
login-functionality.spec.ts requires:
  - LoginPage (user interactions)
  - DashboardPage (post-login verification)

session-management.spec.ts requires:
  - LoginPage (authentication)
  - DashboardPage (session verification)
  - ProfilePage (additional session testing)
```

---

## Step 3: Generate Test Spec Files

### Test Spec Structure

Each generated test spec file follows this structure:

```typescript
/**
 * File-level documentation
 * - Test suite name
 * - Source documents
 * - Generation metadata
 */

// 1. Imports (Playwright, POMs, fixtures)
import { test, expect } from '@playwright/test';
import { [POM] } from '../pom/[POM]';
import { [fixture] } from '../fixtures/test-data';

// 2. Test suite (describe block)
test.describe('[Test Suite Name]', () => {

  // 3. Setup (beforeEach)
  test.beforeEach(async ({ page }) => {
    // Initialize page objects
    // Navigate to starting page
  });

  // 4. Test cases
  test('[TC-ID]: [Test Case Title]', async ({ page }) => {
    // ARRANGE
    // ACT
    // ASSERT
  });

  // 5. Teardown (afterEach - if needed)
  test.afterEach(async ({ page }) => {
    // Cleanup
  });
});
```

### Example: Complete Test Spec File

```typescript
/**
 * Test Suite: Login Functionality
 *
 * Source: features/user-auth/WYX-123/test-cases.md
 * Feature Knowledge: features/user-auth/feature-knowledge.md
 * Test Plan: features/user-auth/WYX-123/test-plan.md
 *
 * Generated: 2025-12-02 by /automate-testcases
 * Standards: @qa-agent-os/standards/automation/playwright.md
 */

import { test, expect } from '@playwright/test';
import { LoginPage } from '../pom/LoginPage';
import { DashboardPage } from '../pom/DashboardPage';
import { validUser, invalidUser } from '../fixtures/test-data';

test.describe('Login Functionality', () => {
  let loginPage: LoginPage;
  let dashboardPage: DashboardPage;

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page);
    dashboardPage = new DashboardPage(page);
    await loginPage.navigate();
  });

  /**
   * WYX-123-TC-01: User can login with valid credentials
   *
   * Source: test-cases.md > TC-01
   * Requirement: REQ-AUTH-01 (feature-knowledge.md)
   */
  test('WYX-123-TC-01: User can login with valid credentials', async ({ page }) => {
    // ARRANGE: Prepare test data
    const username = validUser.email;
    const password = validUser.password;

    // ACT: Perform login
    await loginPage.login(username, password);

    // ASSERT: Verify successful login
    await expect(dashboardPage.welcomeMessage).toBeVisible();
    await expect(dashboardPage.welcomeMessage).toContainText(validUser.name);
    await expect(page).toHaveURL(/\/dashboard/);
  });

  /**
   * WYX-123-TC-02: Login fails with invalid password
   *
   * Source: test-cases.md > TC-02
   * Requirement: REQ-AUTH-02 (feature-knowledge.md)
   */
  test('WYX-123-TC-02: Login fails with invalid password', async ({ page }) => {
    // ARRANGE: Prepare test data with invalid password
    const username = validUser.email;
    const password = 'WrongPassword123';

    // ACT: Attempt login with invalid password
    await loginPage.login(username, password);

    // ASSERT: Verify error message
    await loginPage.waitForErrorMessage();
    await expect(loginPage.errorMessage).toBeVisible();
    await expect(loginPage.errorMessage).toHaveText('Invalid credentials');

    // ASSERT: User remains on login page
    await expect(page).toHaveURL(/\/login/);
  });

  /**
   * WYX-123-TC-03: Login fails with non-existent user
   *
   * Source: test-cases.md > TC-03
   * Requirement: REQ-AUTH-02 (feature-knowledge.md)
   */
  test('WYX-123-TC-03: Login fails with non-existent user', async ({ page }) => {
    // ARRANGE: Prepare test data with non-existent user
    const username = invalidUser.email;
    const password = invalidUser.password;

    // ACT: Attempt login with non-existent user
    await loginPage.login(username, password);

    // ASSERT: Verify error message
    await loginPage.waitForErrorMessage();
    await expect(loginPage.errorMessage).toBeVisible();
    await expect(loginPage.errorMessage).toHaveText('User not found');

    // ASSERT: User remains on login page
    await expect(page).toHaveURL(/\/login/);
  });

  // ... Additional test cases
});
```

---

## Step 4: Implement AAA Pattern

### Arrange (Setup/Preconditions)

**Purpose:** Set up everything needed for the test

**Responsibilities:**
- Initialize test data
- Create page object instances
- Set up preconditions
- Load fixtures

**Example:**
```typescript
test('WYX-123-TC-01: User can login with valid credentials', async ({ page }) => {
  // ARRANGE: Prepare test data
  const username = validUser.email;
  const password = validUser.password;

  // Page objects already initialized in beforeEach
  // Pre-navigation completed in beforeEach
```

**Guidelines:**
- Use fixtures for test data (no hardcoding)
- Initialize all needed objects
- Keep setup focused and minimal
- Don't perform actions in ARRANGE

### Act (Perform the Action)

**Purpose:** Execute the exact action being tested

**Responsibilities:**
- Perform single user action
- Use POM methods exclusively
- Do not assert during ACT
- Keep focused on one action

**Example:**
```typescript
  // ACT: Perform login
  await loginPage.login(username, password);
```

**Guidelines:**
- Use exactly one user-facing action
- Call POM methods (never raw Playwright)
- Do not add waits or assertions here
- Code should be simple and clear

### Assert (Verify Results)

**Purpose:** Verify expected outcomes

**Responsibilities:**
- Use Playwright expect() assertions
- Verify all relevant outcomes
- Use specific, meaningful assertions
- Link to requirements if applicable

**Example:**
```typescript
  // ASSERT: Verify successful login
  await expect(dashboardPage.welcomeMessage).toBeVisible();
  await expect(dashboardPage.welcomeMessage).toContainText(validUser.name);
  await expect(page).toHaveURL(/\/dashboard/);
});
```

**Guidelines:**
- Use Playwright's expect() for all assertions
- Multiple assertions per test are OK (for related checks)
- Assertions should be specific and meaningful
- Verify complete expected behavior

### AAA Pattern Validation

```
✓ Validating AAA pattern in all tests...

test 'TC-01' {
  ✓ ARRANGE section: Initializes data
  ✓ ACT section: Performs login
  ✓ ASSERT section: Verifies dashboard
  ✓ Pattern correct
}

test 'TC-02' {
  ✓ ARRANGE section: Initializes data
  ✓ ACT section: Attempts login with invalid password
  ✓ ASSERT section: Verifies error state
  ✓ Pattern correct
}

✓ All tests follow AAA pattern
```

---

## Step 5: Enforce POM Method Usage

### Requirement: No Raw Playwright

All page interactions must use POM methods. No direct selectors in tests.

```
✓ Validating POM method usage...
✓ Scanning for raw Playwright selectors...
✓ No direct page.locator() calls found
✓ All interactions use POM methods
```

### Enforcement Rules

**What NOT to do in tests:**
```typescript
// ❌ BAD: Raw selector in test
await page.locator('[data-testid="username"]').fill(username);

// ❌ BAD: Direct button click
await page.locator('button[type="submit"]').click();

// ❌ BAD: Direct assertion on selector
await expect(page.locator('.error')).toBeVisible();
```

**What to do instead:**
```typescript
// ✅ GOOD: Use POM method
await loginPage.login(username, password);

// ✅ GOOD: Use POM locator for assertion
await expect(loginPage.errorMessage).toBeVisible();

// ✅ GOOD: Use POM getter method
const message = await loginPage.getErrorMessage();
```

### Benefits of POM Method Usage

1. **Maintainability**: Change selector in one place (POM)
2. **Readability**: Test reads like business process
3. **Consistency**: All tests use same interaction methods
4. **Reusability**: Methods used across multiple tests
5. **Standards Compliance**: Enforced by QA Agent OS

---

## Step 6: Reference Test Data from Fixtures

### Extract Test Data from Test Cases

Analyze test cases to identify all test data entities:

```
✓ Analyzing test cases for test data...

Identified data entities:
  - validUser (email, password, name)
  - invalidUser (email, password)
  - emptyFields (empty strings)
  - expiredSession (timestamp)
```

### Create fixtures/test-data.ts

All test data lives in one location:

```typescript
// fixtures/test-data.ts

export const validUser = {
  email: 'test.user@example.com',
  password: 'SecurePass123!',
  name: 'Test User'
};

export const invalidUser = {
  email: 'nonexistent@example.com',
  password: 'WrongPassword123'
};

export const testData = {
  // Additional test data as needed
};
```

### No Hardcoded Values in Tests

```
✓ Validating test data usage...
✓ No hardcoded test values found
✓ All test data from fixtures
✓ Test data management: Correct
```

**All tests use fixtures:**
```typescript
import { validUser, invalidUser } from '../fixtures/test-data';

test('TC-01: Login with valid credentials', async ({ page }) => {
  // ARRANGE: Use fixture data
  const username = validUser.email;       // ✅ From fixture
  const password = validUser.password;    // ✅ From fixture

  // ACT
  await loginPage.login(username, password);

  // ASSERT
  await expect(dashboardPage.welcomeMessage).toContainText(validUser.name);
});
```

### Benefits of Fixture-Based Data

1. **Centralization**: All test data in one place
2. **Maintainability**: Change data once, affects all tests
3. **Reusability**: Share data across test files
4. **Consistency**: All tests use same test data
5. **Environment Awareness**: Easy to vary by environment

---

## Step 7: Add Setup and Teardown Hooks

### beforeEach Hook (Setup)

Runs before each test in the suite:

```typescript
test.beforeEach(async ({ page }) => {
  // Initialize page objects
  loginPage = new LoginPage(page);
  dashboardPage = new DashboardPage(page);

  // Common navigation
  await loginPage.navigate();

  // Common setup (if needed)
  await page.evaluate(() => localStorage.clear());
});
```

**Setup responsibilities:**
- Initialize page objects used in suite
- Navigate to starting page
- Clear cookies/storage (if needed)
- Set up authentication state
- Do NOT use in tests individually

### afterEach Hook (Teardown)

Runs after each test in the suite (optional):

```typescript
test.afterEach(async ({ page }) => {
  // Cleanup test data
  await page.evaluate(() => localStorage.clear());
  await page.evaluate(() => sessionStorage.clear());

  // Reset application state if needed
  // await cleanupDatabaseRecords();
});
```

**Teardown responsibilities:**
- Clean up test-created data
- Reset application state
- Clear temporary storage
- Close resources

**When to use:**
- If tests modify application state
- If test data must be cleaned up
- If resources need explicit closing

---

## Step 8: Create Traceability Links

### Test-to-Requirement Linking

Every test includes documentation linking to source materials:

```typescript
/**
 * WYX-123-TC-01: User can login with valid credentials
 *
 * Source: test-cases.md > TC-01
 * Requirement: REQ-AUTH-01 (feature-knowledge.md)
 * Feature: User Authentication (feature-knowledge.md)
 */
test('WYX-123-TC-01: User can login with valid credentials', async ({ page }) => {
  // Test implementation
});
```

**Traceability Information:**
- Test case ID and description
- Link to manual test case in test-cases.md
- Link to requirement in feature-knowledge.md
- Feature/area being tested

### File-Level Documentation

Every test spec file includes header documentation:

```typescript
/**
 * Test Suite: Login Functionality
 *
 * Source: features/user-auth/WYX-123/test-cases.md
 * Feature Knowledge: features/user-auth/feature-knowledge.md
 * Test Plan: features/user-auth/WYX-123/test-plan.md
 *
 * Generated: 2025-12-02 by /automate-testcases
 * Standards: @qa-agent-os/standards/automation/playwright.md
 */
```

**File documentation includes:**
- Suite name and purpose
- Links to source documents
- Generation timestamp
- Standards applied

### Traceability Chain

Complete chain from test to requirement:

```
Test Script
  ↓ (links to)
Manual Test Case (test-cases.md)
  ↓ (derives from)
Test Case (test-plan.md)
  ↓ (verifies)
Requirement (feature-knowledge.md)
  ↓ (implements)
Business Rule
```

---

## Step 9: Validate Generated Tests

### TypeScript Compilation Check

```
✓ Checking TypeScript syntax...
✓ All imports resolved
✓ All type definitions correct
✓ No compilation errors
```

**If TypeScript errors found:**
```
❌ TypeScript compilation errors:

  login-functionality.spec.ts:45:12 - error TS2345
  Argument of type 'string | null' is not assignable to 'string'

Action taken:
  ✓ Fixed with null coalescing
  ✓ Re-validated
  ✓ Errors resolved
```

### Import Path Validation

```
✓ Validating import paths...
✓ POM imports: ../pom/[POM] ✓ Correct
✓ Fixture imports: ../fixtures/test-data ✓ Correct
✓ Playwright imports: @playwright/test ✓ Correct
✓ All import paths valid
```

### Standards Compliance Verification

```
✓ Verifying standards compliance...

Checking: AAA pattern
  ✓ All tests have ARRANGE section
  ✓ All tests have ACT section
  ✓ All tests have ASSERT section
  ✓ AAA pattern: Correct

Checking: POM method usage
  ✓ No raw Playwright selectors
  ✓ All interactions use POM methods
  ✓ All assertions use public POM locators
  ✓ POM usage: Correct

Checking: Test data usage
  ✓ No hardcoded values found
  ✓ All test data from fixtures
  ✓ Test data management: Correct

Checking: Naming conventions
  ✓ All tests include TC-ID
  ✓ Test names are descriptive
  ✓ File names follow pattern
  ✓ Naming conventions: Correct

Checking: Documentation
  ✓ File-level documentation complete
  ✓ Test-level documentation complete
  ✓ Traceability links present
  ✓ Documentation: Complete

Checking: Error handling
  ✓ No try-catch swallowing errors
  ✓ Errors allowed to surface
  ✓ Error handling: Correct

✓ All standards checks passed: 100%
```

**Standards enforced:**
- `@qa-agent-os/standards/automation/playwright.md` - Test structure
- `@qa-agent-os/standards/testing/test-writing.md` - Test best practices
- `@qa-agent-os/standards/global/coding-style.md` - Code conventions

---

## Step 10: Test Generation Summary

### Generation Report

```
════════════════════════════════════════════════════════════
  Test Script Generation Summary
════════════════════════════════════════════════════════════

Generated Test Specs: 2

login-functionality.spec.ts
  ├── Test suite: Login Functionality
  ├── Test cases: 5 (TC-01 to TC-05)
  ├── POMs used: LoginPage, DashboardPage
  ├── Setup: beforeEach with page object initialization
  ├── Teardown: No cleanup required
  ├── AAA pattern: Enforced in all tests ✓
  ├── POM methods only: Verified ✓
  ├── Test data: From fixtures ✓
  ├── Traceability: Complete ✓
  ├── TypeScript: Valid ✓
  └── Standards: 100% compliant ✓

session-management.spec.ts
  ├── Test suite: Session Management
  ├── Test cases: 3 (TC-06 to TC-08)
  ├── POMs used: LoginPage, DashboardPage, ProfilePage
  ├── Setup: beforeEach with authentication
  ├── Teardown: afterEach with cleanup
  ├── AAA pattern: Enforced in all tests ✓
  ├── POM methods only: Verified ✓
  ├── Test data: From fixtures ✓
  ├── Traceability: Complete ✓
  ├── TypeScript: Valid ✓
  └── Standards: 100% compliant ✓

Overall Results:
  ├── Total test cases automated: 8/8 (100%)
  ├── Total test specs generated: 2
  ├── Standards compliance: 100% ✓
  ├── Traceability: Complete ✓
  ├── Test data management: Fixtures only ✓
  ├── All imports: Valid ✓
  ├── All compilation: Successful ✓
  └── Ready for execution: Yes ✓

Files saved to: automated-tests/tests/

════════════════════════════════════════════════════════════
```

---

## Error Handling and Recovery

### Test Case Mapping Ambiguity

**Issue:** Test case requires page not yet automated

```
⚠️  Test case TC-03 requires page not in POMs: PasswordResetPage

Action taken:
  ✓ Added TODO comment in test
  ✓ Test marked with .skip()
  ✓ Documented in README
  ✓ Can be enabled after POM created
```

**Example:**
```typescript
test.skip('WYX-123-TC-03: User can reset password', async ({ page }) => {
  // TODO: PasswordResetPage POM needs to be created
  // Enable this test after POM is available
});
```

### Complex Multi-Step Test Case

**Issue:** Test case has many steps

```
⚠️  Test case TC-07 has complex multi-step interaction

Action taken:
  ✓ Generated comprehensive test
  ✓ Added comments explaining each step
  ✓ Maintained AAA pattern (grouped actions in ACT)
  ✓ All assertions in ASSERT section
```

**Example:**
```typescript
test('WYX-123-TC-07: Complete workflow test', async ({ page }) => {
  // ARRANGE
  const userData = validUser;

  // ACT: Multi-step workflow
  // Step 1: Login
  await loginPage.login(userData.email, userData.password);

  // Step 2: Navigate to profile
  await dashboardPage.goToProfile();

  // Step 3: Update information
  await profilePage.updateUserInfo({ name: 'New Name' });

  // ASSERT: Verify all changes
  await expect(profilePage.nameField).toHaveValue('New Name');
  await expect(page.locator('.success-message')).toBeVisible();
});
```

### Missing Test Data

**Issue:** Test requires data not defined in fixtures

```
⚠️  Test case TC-04 requires test data not defined: adminUser

Action taken:
  ✓ Added TODO to fixtures/test-data.ts
  ✓ Test marked with .skip()
  ✓ Documented in README.md
  ✓ Can be enabled after data provided

Fixture TODO:
  // TODO: Add adminUser test data
  // export const adminUser = { ... };
```

### Conditional Page Elements

**Issue:** Test element visibility depends on state

```
⚠️  Element only visible after specific action on TC-05

Action taken:
  ✓ Used POM wait method: waitForElement()
  ✓ Used Playwright's auto-waiting
  ✓ Added explicit assertion before use
  ✓ Handled in POM (not in test)
```

---

## Quality Metrics

### Test Coverage

```
✓ Test case coverage analysis...

Test cases in test-cases.md: 8
Test cases automated: 8
Coverage: 100% ✓

Notes:
  - 0 test cases marked .skip()
  - 0 test cases marked .only()
  - All tests independently executable
```

### Standards Compliance

```
✓ Standards compliance metrics...

Metrics:
  ├── AAA pattern: 100% (8/8)
  ├── POM usage: 100% (no raw selectors)
  ├── Fixture data: 100% (no hardcoding)
  ├── Traceability: 100% (all tests linked)
  ├── Documentation: 100% (all files documented)
  ├── TypeScript: 100% (no errors)
  └── Naming conventions: 100% (all follow patterns)

Overall: 100% Compliant ✓
```

### Test Quality

```
✓ Test quality assessment...

Attributes:
  ├── Readability: Excellent (clear AAA structure)
  ├── Maintainability: Excellent (POM usage)
  ├── Consistency: Excellent (standards enforced)
  ├── Reusability: Excellent (POM methods)
  ├── Independence: Excellent (no state dependencies)
  └── Reliability: Excellent (proper waits, no manual timeouts)

Ready for: Production use ✓
```

---

## Integration with Next Phase

### Output for Phase 4: Utilities & Documentation

Generated test specs are complete and ready. Phase 4 will:

1. **Create test-data.ts** - Organize fixture data
2. **Generate auth-helper.ts** - Authentication utilities
3. **Generate wait-helpers.ts** - Custom wait conditions
4. **Generate assertion-helpers.ts** - Common assertions
5. **Create config.ts** - Environment configuration
6. **Generate README.md** - Usage instructions

**Test scripts are ready to:**
- Execute with `npx playwright test`
- Run specific tests with `--grep`
- Debug with `--ui` mode
- Generate reports and artifacts

---

## Standards Reference

**Test Writing Standards:**
- `@qa-agent-os/standards/automation/playwright.md` - Test script structure
- `@qa-agent-os/standards/testing/test-writing.md` - General test best practices
- `@qa-agent-os/standards/global/coding-style.md` - TypeScript conventions
- `@qa-agent-os/standards/global/commenting.md` - Documentation standards

**POM Standards:**
- `@qa-agent-os/standards/automation/pom-patterns.md` - POM construction
- `@qa-agent-os/standards/automation/test-data-management.md` - Data management

**Playwright Resources:**
- Official Docs: https://playwright.dev/
- Best Practices: https://playwright.dev/docs/best-practices
- API Reference: https://playwright.dev/docs/api/class-test

---

*This workflow ensures high-quality, maintainable test scripts that follow QA Agent OS standards and are ready for continuous execution.*
