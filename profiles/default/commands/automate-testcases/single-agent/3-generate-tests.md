# Phase 3: Test Script Generation

## Purpose

Generate executable Playwright test scripts from test-cases.md, mapping each manual test case to automated test specs following AAA pattern, using POM methods exclusively, with proper fixtures and traceability.

## Prerequisites

Phase 2 has completed:
- ✓ BasePage class generated with utilities
- ✓ Page Object Model classes created for all pages
- ✓ All selectors verified against live DOM
- ✓ Component page objects created (if applicable)

## Step 1: Parse Test Cases

### Read test-cases.md

```
✓ Reading: features/user-auth/WYX-123/test-cases.md
✓ Parsing test case structure...
```

### Extract Test Case Information

For each test case, I'll extract:
- Test case ID (e.g., WYX-123-TC-01)
- Test case title/description
- Test steps with actions
- Expected results for each step
- Test data requirements
- Prerequisites/setup needs

```
✓ Found 8 test cases to automate:

  TC-01: User can login with valid credentials
    - Steps: 3
    - Data: username, password
    - Prerequisites: User account exists

  TC-02: Login fails with invalid password
    - Steps: 3
    - Data: username, invalid_password
    - Prerequisites: User account exists

  TC-03: Login fails with non-existent user
    - Steps: 3
    - Data: invalid_username, password
    - Prerequisites: None

  ... (5 more test cases)
```

### Group Test Cases by Feature/Scenario

```
✓ Organizing test cases by scenario...

Login Functionality (5 test cases):
  - TC-01: Valid credentials
  - TC-02: Invalid password
  - TC-03: Non-existent user
  - TC-04: Empty fields validation
  - TC-05: Remember me functionality

Session Management (3 test cases):
  - TC-06: User remains logged in
  - TC-07: Logout clears session
  - TC-08: Session expires after timeout
```

This grouping will become test suites (describe blocks).

## Step 2: Map Test Cases to Test Specs

### Determine Test File Structure

```
✓ Determining test file organization...
✓ Pattern: One spec file per scenario (from config)

Test specs to generate:
  - login-functionality.spec.ts (5 test cases)
  - session-management.spec.ts (3 test cases)
```

**Naming convention from config:**
- Feature-based: `[feature-name].spec.ts`
- Page-based: `[page-name].spec.ts`
- Hybrid: `[page-name]-[scenario].spec.ts`

### Identify Required POMs

```
✓ Analyzing test steps to identify required page objects...

login-functionality.spec.ts requires:
  - LoginPage
  - DashboardPage

session-management.spec.ts requires:
  - LoginPage
  - DashboardPage
  - ProfilePage
```

I'll ensure all necessary imports are included in each spec file.

## Step 3: Generate Test Spec Files

### For Each Test Scenario Group

I'll generate one test spec file per scenario with proper structure.

#### Example: login-functionality.spec.ts

```
✓ Generating login-functionality.spec.ts...
✓ Adding imports (Playwright, POMs, fixtures)
✓ Creating describe block
✓ Adding beforeEach setup
✓ Mapping TC-01 to TC-05 as test blocks
✓ Enforcing AAA pattern in each test
✓ Using POM methods (no raw Playwright)
✓ Adding traceability comments
✓ File saved: automated-tests/tests/login-functionality.spec.ts
```

**Generated login-functionality.spec.ts:**

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

  // Setup: Run before each test
  test.beforeEach(async ({ page }) => {
    // ARRANGE: Initialize page objects
    loginPage = new LoginPage(page);
    dashboardPage = new DashboardPage(page);

    // Navigate to login page
    await loginPage.navigate();
  });

  /**
   * TC-01: User can login with valid credentials
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
   * TC-02: Login fails with invalid password
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

    // ASSERT: Verify error message displayed
    await loginPage.waitForErrorMessage();
    await expect(loginPage.errorMessage).toBeVisible();
    await expect(loginPage.errorMessage).toHaveText('Invalid credentials');

    // ASSERT: User remains on login page
    await expect(page).toHaveURL(/\/login/);
  });

  /**
   * TC-03: Login fails with non-existent user
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

    // ASSERT: Verify error message displayed
    await loginPage.waitForErrorMessage();
    await expect(loginPage.errorMessage).toBeVisible();
    await expect(loginPage.errorMessage).toHaveText('User not found');

    // ASSERT: User remains on login page
    await expect(page).toHaveURL(/\/login/);
  });

  /**
   * TC-04: Login form validates empty fields
   *
   * Source: test-cases.md > TC-04
   * Requirement: REQ-AUTH-03 (feature-knowledge.md)
   */
  test('WYX-123-TC-04: Login form validates empty fields', async ({ page }) => {
    // ARRANGE: No test data (testing empty fields)

    // ACT: Attempt to submit empty form
    await loginPage.submitButton.click();

    // ASSERT: Verify validation errors shown
    await expect(loginPage.errorMessage).toBeVisible();
    await expect(loginPage.errorMessage).toHaveText('Username and password are required');

    // ASSERT: Submit button disabled
    const isEnabled = await loginPage.isLoginButtonEnabled();
    expect(isEnabled).toBe(false);
  });

  /**
   * TC-05: Remember me checkbox persists session
   *
   * Source: test-cases.md > TC-05
   * Requirement: REQ-AUTH-04 (feature-knowledge.md)
   */
  test('WYX-123-TC-05: Remember me checkbox persists session', async ({ page, context }) => {
    // ARRANGE: Prepare test data
    const username = validUser.email;
    const password = validUser.password;

    // ACT: Login with remember me checked
    await loginPage.loginWithRememberMe(username, password);

    // ASSERT: Verify successful login
    await expect(dashboardPage.welcomeMessage).toBeVisible();

    // ACT: Close and reopen browser (simulate new session)
    await page.close();
    const newPage = await context.newPage();
    const newDashboard = new DashboardPage(newPage);

    // ACT: Navigate to application
    await newPage.goto(process.env.BASE_URL || 'http://localhost:3000');

    // ASSERT: User still logged in (session persisted)
    await expect(newDashboard.welcomeMessage).toBeVisible();
  });
});
```

### AAA Pattern Enforcement

Every test follows the AAA structure:

**ARRANGE (Setup):**
```typescript
// ARRANGE: Prepare test data
const username = validUser.email;
const password = validUser.password;
```
- Initialize test data
- Set up preconditions
- Prepare fixtures

**ACT (Execute):**
```typescript
// ACT: Perform login
await loginPage.login(username, password);
```
- Execute the action being tested
- Single, clear action per test
- Use POM methods exclusively

**ASSERT (Verify):**
```typescript
// ASSERT: Verify successful login
await expect(dashboardPage.welcomeMessage).toBeVisible();
await expect(dashboardPage.welcomeMessage).toContainText(validUser.name);
```
- Verify expected outcomes
- Multiple assertions allowed to verify complete behavior
- Use Playwright's expect assertions

### POM Method Usage Enforcement

```
✓ Validating POM method usage...
✓ No raw Playwright selectors found in tests
✓ All page interactions use POM methods
✓ All assertions use POM locators
```

**Enforced rules:**
- ❌ No direct `page.locator()` in tests
- ❌ No hardcoded selectors
- ✅ All interactions via POM methods
- ✅ Assertions use public POM locators

**Example of enforcement:**

```typescript
// ❌ BAD: Raw Playwright in test
await page.locator('[data-testid="username"]').fill(username);
await page.locator('button[type="submit"]').click();

// ✅ GOOD: POM method usage
await loginPage.login(username, password);
```

## Step 4: Add Setup and Teardown

### beforeEach Hook

```typescript
test.beforeEach(async ({ page }) => {
  // Initialize page objects
  loginPage = new LoginPage(page);
  dashboardPage = new DashboardPage(page);

  // Common setup (e.g., navigate to starting page)
  await loginPage.navigate();
});
```

**Setup responsibilities:**
- Initialize all page objects used in suite
- Navigate to starting page
- Set up authentication (if needed)
- Clear cookies/storage (if needed)

### afterEach Hook (if needed)

```typescript
test.afterEach(async ({ page }) => {
  // Cleanup operations
  await page.evaluate(() => localStorage.clear());
  await page.evaluate(() => sessionStorage.clear());
});
```

**Teardown responsibilities:**
- Clear test data
- Reset application state
- Clean up resources

## Step 5: Reference Test Data from Fixtures

### Extract Test Data

```
✓ Analyzing test cases for test data...
✓ Identified data entities:
  - validUser (email, password, name)
  - invalidUser (email, password)
  - emptyFields (empty strings)
```

### No Hardcoded Values in Tests

```
✓ Validating test data usage...
✓ No hardcoded values found
✓ All test data from fixtures
```

**All test data comes from fixtures:**

```typescript
import { validUser, invalidUser } from '../fixtures/test-data';

// In tests:
const username = validUser.email;  // ✅ From fixture
const password = validUser.password;  // ✅ From fixture
```

**Not hardcoded in tests:**
```typescript
// ❌ BAD
const username = 'test@example.com';
const password = 'password123';
```

## Step 6: Add Traceability Links

### Link to Source Documents

Every test includes traceability comments:

```typescript
/**
 * TC-01: User can login with valid credentials
 *
 * Source: test-cases.md > TC-01
 * Requirement: REQ-AUTH-01 (feature-knowledge.md)
 */
```

**Traceability chain:**
- Test spec → Test case → Requirement → Feature knowledge
- Enables impact analysis when requirements change
- Maintains audit trail for compliance

### File-Level Documentation

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

## Step 7: Test Generation Summary

```
════════════════════════════════════════════════════════════
  Test Script Generation Summary
════════════════════════════════════════════════════════════

Generated Test Specs: 2

login-functionality.spec.ts
  ├── Test suite: Login Functionality
  ├── Test cases: 5 (TC-01 to TC-05)
  ├── POMs used: LoginPage, DashboardPage
  ├── Setup: beforeEach with page objects
  ├── AAA pattern: Enforced in all tests ✓
  ├── POM methods only: Verified ✓
  ├── Test data: From fixtures ✓
  ├── Traceability: Complete ✓

session-management.spec.ts
  ├── Test suite: Session Management
  ├── Test cases: 3 (TC-06 to TC-08)
  ├── POMs used: LoginPage, DashboardPage, ProfilePage
  ├── Setup: beforeEach with authentication
  ├── Teardown: afterEach cleanup
  ├── AAA pattern: Enforced in all tests ✓
  ├── POM methods only: Verified ✓
  ├── Test data: From fixtures ✓
  ├── Traceability: Complete ✓

Total Test Cases Automated: 8
Standards Compliance: 100% ✓
Traceability: Complete ✓
Test Data Management: Fixtures only ✓

Files saved to: automated-tests/tests/

════════════════════════════════════════════════════════════
```

## Step 8: Validate Generated Tests

### TypeScript Compilation Check

```
✓ Checking TypeScript syntax...
✓ All imports resolved
✓ All type definitions correct
✓ No compilation errors
```

### Import Path Validation

```
✓ Validating import paths...
✓ POM imports: Correct relative paths
✓ Fixture imports: Correct relative paths
✓ Playwright imports: Valid
```

### Standards Compliance Check

```
✓ Verifying standards compliance...
✓ All tests follow AAA pattern
✓ Test names include TC-ID
✓ No hardcoded test data
✓ Traceability comments present
✓ POM methods used exclusively
✓ Assertions are specific
✓ All standards checks passed
```

**Standards enforced:**
- `@qa-agent-os/standards/automation/playwright.md` - Test structure
- `@qa-agent-os/standards/testing/test-writing.md` - Test best practices
- `@qa-agent-os/standards/global/coding-style.md` - Code conventions

## Error Handling

### Test Case Mapping Ambiguity

```
⚠️  Test case TC-03 requires page not in POMs: PasswordResetPage

Action taken:
  ✓ Added TODO comment in test
  ✓ Test will skip until POM created
  ✓ Noted in generation summary
```

### Complex Test Step

```
⚠️  Test case TC-07 has complex multi-step interaction

Action taken:
  ✓ Generated comprehensive test with multiple ACT sections
  ✓ Added comments explaining each step
  ✓ Maintained AAA pattern with grouped actions
```

### Missing Test Data

```
⚠️  Test case TC-04 requires test data not defined: adminUser

Action taken:
  ✓ Added TODO to fixtures/test-data.ts
  ✓ Test marked as .skip() until data provided
  ✓ Documented in README.md
```

## Next Phase

With test script generation complete, I'll proceed to Phase 4: Utilities & Documentation.

**Generated test specs ready for:**
- Execution with `npx playwright test`
- Integration with CI/CD pipelines
- Debugging with Playwright Inspector
- Reporting and artifact generation
