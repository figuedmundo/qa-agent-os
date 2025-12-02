# Playwright Test Automation Standards

This standard defines how to write, structure, and maintain Playwright automated test scripts in QA Agent OS.

---

## Core Principles

1. **AAA Pattern Enforcement**: All tests must follow Arrange-Act-Assert structure
2. **Traceability**: Tests must link back to manual test cases and requirements
3. **Maintainability**: Tests should be readable, modular, and reusable
4. **Independence**: Tests must run independently without order dependencies
5. **Standards Compliance**: All generated code follows QA Agent OS coding standards

---

## Test Script Structure

### File Organization

```typescript
// File: tests/[feature-name]/[test-scenario].spec.ts

import { test, expect } from '@playwright/test';
import { LoginPage } from '../../pom/LoginPage';
import { DashboardPage } from '../../pom/DashboardPage';

test.describe('[Feature Name] - [Test Scenario]', () => {
  // Test suite for related test cases
});
```

### AAA Pattern (Arrange-Act-Assert)

Every test must follow this structure:

```typescript
test('[TC-ID]: [Test Case Description]', async ({ page }) => {
  // ARRANGE: Set up test preconditions
  const loginPage = new LoginPage(page);
  const dashboardPage = new DashboardPage(page);
  const testData = {
    username: 'test.user@example.com',
    password: 'SecurePass123'
  };

  // ACT: Perform the action being tested
  await loginPage.navigate();
  await loginPage.login(testData.username, testData.password);

  // ASSERT: Verify expected outcomes
  await expect(dashboardPage.welcomeMessage).toBeVisible();
  await expect(dashboardPage.welcomeMessage).toHaveText('Welcome, Test User');
});
```

---

## Test Naming Conventions

### Test Suite Names

```typescript
test.describe('[Feature Name] - [Scenario Category]', () => {
  // Examples:
  // 'User Authentication - Login Flow'
  // 'Product Catalog - Search Functionality'
  // 'Shopping Cart - Add to Cart'
});
```

### Test Case Names

Format: `[TC-ID]: [Clear description of what is being tested]`

```typescript
// Good examples:
test('TC-001: User can login with valid credentials', async ({ page }) => {});
test('TC-002: Login fails with invalid password', async ({ page }) => {});
test('TC-003: Password field shows error for empty input', async ({ page }) => {});

// Bad examples:
test('login test', async ({ page }) => {}); // No TC-ID, vague
test('test user authentication', async ({ page }) => {}); // No TC-ID, not specific
```

**TC-ID Format:** `[TICKET-ID]-TC-[NUMBER]` (e.g., `WYX-123-TC-01`)

---

## Setup and Teardown Patterns

### beforeEach Hook

Use for common setup across all tests in a suite:

```typescript
test.describe('User Dashboard Tests', () => {
  test.beforeEach(async ({ page }) => {
    // Navigate to authenticated state
    const loginPage = new LoginPage(page);
    await loginPage.navigateWithToken(process.env.TEST_AUTH_TOKEN);
  });

  test('TC-001: Dashboard shows user profile', async ({ page }) => {
    // Test implementation
  });
});
```

### afterEach Hook

Use for cleanup operations:

```typescript
test.describe('Data Modification Tests', () => {
  test.afterEach(async ({ page }) => {
    // Clean up test data
    await page.evaluate(() => localStorage.clear());
  });
});
```

---

## Fixture Usage Guidelines

### Built-in Fixtures

```typescript
// Use Playwright's built-in fixtures
test('TC-001: Test with browser context', async ({ page, context, browser }) => {
  // page: Current page
  // context: Browser context (cookies, storage, etc.)
  // browser: Browser instance
});
```

### Custom Fixtures

Define reusable test setup in `fixtures/` directory:

```typescript
// fixtures/authenticated-user.ts
import { test as base } from '@playwright/test';

export const test = base.extend({
  authenticatedPage: async ({ page }, use) => {
    // Setup: Navigate to authenticated state
    await page.goto(`${process.env.BASE_URL}?auth_token=${process.env.TEST_AUTH_TOKEN}`);
    await use(page);
    // Teardown: (if needed)
  }
});
```

**Usage:**

```typescript
import { test } from '../fixtures/authenticated-user';

test('TC-001: Authenticated user sees dashboard', async ({ authenticatedPage }) => {
  // Test with pre-authenticated page
});
```

---

## Error Handling in Tests

### Expected Errors

Test error scenarios explicitly:

```typescript
test('TC-002: Login shows error for invalid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);

  await loginPage.navigate();
  await loginPage.login('invalid@example.com', 'wrongpassword');

  // Assert error is shown
  await expect(loginPage.errorMessage).toBeVisible();
  await expect(loginPage.errorMessage).toHaveText('Invalid credentials');
});
```

### Unexpected Errors

Let tests fail naturally - don't catch unexpected errors:

```typescript
// ❌ Bad: Hiding unexpected errors
test('TC-001: User login', async ({ page }) => {
  try {
    await loginPage.login(username, password);
  } catch (error) {
    console.log('Login failed');
  }
});

// ✅ Good: Let errors surface
test('TC-001: User login', async ({ page }) => {
  await loginPage.login(username, password);
  // If this fails, test should fail
});
```

---

## Traceability Requirements

### Linking to Manual Test Cases

Every automated test must reference its source manual test case:

```typescript
test('TC-001: User can login with valid credentials', async ({ page }) => {
  // Source: test-cases.md > TC-001
  // Requirement: REQ-AUTH-01
  // Feature: User Authentication

  // Test implementation
});
```

### Documentation Comments

Include these in all test files:

```typescript
/**
 * Test Suite: User Authentication - Login Flow
 *
 * Source: qa-agent-os/features/user-auth/TICKET-123/test-cases.md
 * Feature Knowledge: qa-agent-os/features/user-auth/feature-knowledge.md
 * Test Plan: qa-agent-os/features/user-auth/TICKET-123/test-plan.md
 *
 * Generated: [Date]
 * Last Updated: [Date]
 */
```

---

## Assertions Best Practices

### Use Specific Assertions

```typescript
// ✅ Good: Specific assertions
await expect(page.locator('.error-message')).toBeVisible();
await expect(page.locator('.error-message')).toHaveText('Invalid input');
await expect(page).toHaveURL(/dashboard/);

// ❌ Bad: Generic assertions
await expect(page.locator('.error-message')).toBeTruthy();
```

### Multiple Assertions

Group related assertions:

```typescript
test('TC-001: Form validation shows all errors', async ({ page }) => {
  await formPage.submitEmptyForm();

  // Group related assertions
  await expect(formPage.nameError).toBeVisible();
  await expect(formPage.nameError).toHaveText('Name is required');

  await expect(formPage.emailError).toBeVisible();
  await expect(formPage.emailError).toHaveText('Email is required');
});
```

---

## Test Data Management

### No Hardcoded Values

```typescript
// ❌ Bad: Hardcoded test data
test('TC-001: User login', async ({ page }) => {
  await loginPage.login('john@example.com', 'password123');
});

// ✅ Good: Test data from fixtures
import { validUser } from '../fixtures/test-data';

test('TC-001: User login', async ({ page }) => {
  await loginPage.login(validUser.email, validUser.password);
});
```

### Environment-Specific Data

Use environment variables for environment-specific values:

```typescript
const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
const authToken = process.env.TEST_AUTH_TOKEN;
```

---

## Wait Strategies

### Use Playwright Auto-Waiting

Playwright automatically waits for elements - avoid manual waits:

```typescript
// ✅ Good: Rely on auto-waiting
await page.click('button');
await expect(page.locator('.success-message')).toBeVisible();

// ❌ Bad: Manual waits
await page.waitForTimeout(3000);
await page.click('button');
```

### Custom Wait Conditions

When necessary, use explicit waits:

```typescript
// Wait for specific condition
await page.waitForFunction(() => {
  return document.querySelectorAll('.item').length > 5;
});

// Wait for network idle
await page.waitForLoadState('networkidle');
```

---

## Test Independence

### Each Test is Isolated

```typescript
test.describe('Product Tests', () => {
  test('TC-001: Add product to cart', async ({ page }) => {
    // Complete test - setup to assertion
    await page.goto('/products');
    await page.click('[data-testid="add-to-cart"]');
    await expect(page.locator('.cart-count')).toHaveText('1');
  });

  test('TC-002: Remove product from cart', async ({ page }) => {
    // Independent test - does NOT depend on TC-001
    await page.goto('/cart');
    await page.click('[data-testid="add-sample-item"]');
    await page.click('[data-testid="remove-item"]');
    await expect(page.locator('.cart-count')).toHaveText('0');
  });
});
```

---

## Debugging and Troubleshooting

### Screenshots on Failure

Playwright automatically captures screenshots on failure. Add custom ones when needed:

```typescript
test('TC-001: Complex interaction', async ({ page }) => {
  await page.goto('/dashboard');

  // Capture screenshot at specific point
  await page.screenshot({ path: 'screenshots/before-action.png' });

  await complexAction();

  await page.screenshot({ path: 'screenshots/after-action.png' });
});
```

### Console Logs

Use page.on('console') to capture application logs:

```typescript
test('TC-001: Check for console errors', async ({ page }) => {
  const errors: string[] = [];

  page.on('console', msg => {
    if (msg.type() === 'error') {
      errors.push(msg.text());
    }
  });

  await page.goto('/dashboard');

  expect(errors.length).toBe(0);
});
```

---

## Standards Compliance Checklist

Before committing automated tests, verify:

- [ ] All tests follow AAA pattern (Arrange-Act-Assert)
- [ ] Test names include TC-ID and clear description
- [ ] Tests are independent and can run in any order
- [ ] No hardcoded test data - all data in fixtures
- [ ] Traceability comments link to source test cases
- [ ] POM methods are used (no direct selectors in tests)
- [ ] Assertions are specific and meaningful
- [ ] Error scenarios are tested explicitly
- [ ] No manual waits (except where justified)
- [ ] Tests pass reliably (no flakiness)

---

## References

**Related Standards:**
- `@qa-agent-os/standards/automation/pom-patterns.md` - Page Object Model construction
- `@qa-agent-os/standards/automation/test-data-management.md` - Test data handling
- `@qa-agent-os/standards/global/coding-style.md` - General coding conventions
- `@qa-agent-os/standards/testcases/test-cases.md` - Manual test case structure

**Playwright Documentation:**
- Official Docs: https://playwright.dev/
- Best Practices: https://playwright.dev/docs/best-practices
- API Reference: https://playwright.dev/docs/api/class-test

---

*This standard ensures all generated Playwright tests are consistent, maintainable, and aligned with QA Agent OS quality principles.*
