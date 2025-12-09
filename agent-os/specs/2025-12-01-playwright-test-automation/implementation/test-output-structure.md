# Test Output Structure Reference Guide

## Overview

This document serves as a **REFERENCE GUIDE** for organizing Playwright test automation files. This is a TEMPLATE for multi-team use - different teams will organize tests differently based on their project structure.

**IMPORTANT:** This file remains as an instructional template in QA Agent OS. Teams should choose the organization pattern that best fits their project needs.

---

## Organization Pattern Options

Different teams have different needs. Choose the pattern that works best for your project:

### Pattern 1: Organized by Feature (Recommended for Most Teams)

**When to use:**
- Feature-based development workflow
- Tests map to specific features/tickets
- Multiple teams working on different features
- Clear feature boundaries in your application

**Structure:**
```
features/[feature-name]/[ticket-id]/
├── documentation/
│   └── (existing test case documentation)
├── test-plan.md
├── test-cases.md
├── automated-tests/                 # All automation artifacts for this ticket
│   ├── pom/                         # Page Object Models
│   │   ├── BasePage.ts              # Shared base functionality
│   │   ├── LoginPage.ts
│   │   ├── DashboardPage.ts
│   │   └── components/              # Reusable component pages
│   │       ├── ModalComponent.ts
│   │       └── NavigationComponent.ts
│   ├── tests/                       # Test scripts
│   │   ├── login.spec.ts
│   │   ├── dashboard.spec.ts
│   │   └── navigation.spec.ts
│   ├── fixtures/                    # Test data and configuration
│   │   ├── test-data.ts
│   │   ├── config.ts
│   │   └── custom-fixtures.ts
│   ├── utils/                       # Helper functions
│   │   ├── auth-helper.ts
│   │   ├── wait-helpers.ts
│   │   └── assertion-helpers.ts
│   ├── page-structure.json          # OPTIONAL: DOM structure documentation
│   └── README.md                    # Test suite documentation
```

**Pros:**
- Clear ownership per feature team
- Easy to find tests related to a feature
- Follows QA Agent OS workflow structure
- Test data isolated per feature

**Cons:**
- May have duplicate POMs across features
- Requires coordination for shared pages

---

### Pattern 2: Organized by Page/Component (Recommended for Shared Pages)

**When to use:**
- Many features test the same pages
- Shared component library
- Want to avoid duplicate POMs
- Centralized test data management

**Structure:**
```
automated-tests/                     # Centralized test automation
├── pom/                             # All page objects (shared)
│   ├── BasePage.ts
│   ├── auth/
│   │   ├── LoginPage.ts
│   │   └── RegisterPage.ts
│   ├── dashboard/
│   │   ├── DashboardPage.ts
│   │   └── UserProfilePage.ts
│   └── components/
│       ├── ModalComponent.ts
│       └── TableComponent.ts
├── tests/                           # Tests organized by feature
│   ├── auth/
│   │   ├── login.spec.ts
│   │   └── registration.spec.ts
│   ├── dashboard/
│   │   └── user-profile.spec.ts
│   └── shopping/
│       ├── cart.spec.ts
│       └── checkout.spec.ts
├── fixtures/                        # Shared test data
│   ├── test-data/
│   │   ├── users.ts
│   │   ├── products.ts
│   │   └── common.ts
│   └── custom-fixtures.ts
├── utils/                           # Shared utilities
│   ├── auth-helper.ts
│   ├── api-helpers.ts
│   └── wait-helpers.ts
├── config/
│   └── playwright.config.ts
└── README.md
```

**Pros:**
- No duplicate POMs
- Shared utilities centralized
- Easy to update page objects
- Single source of truth

**Cons:**
- Requires team coordination
- Changes affect multiple features
- Less feature isolation

---

### Pattern 3: Hybrid Pattern (Flexible Approach)

**When to use:**
- Mix of shared and feature-specific pages
- Some features have unique components
- Want balance between sharing and isolation

**Structure:**
```
qa-agent-os/
├── automated-tests/                 # Shared/common automation
│   ├── pom/                         # Shared page objects only
│   │   ├── BasePage.ts
│   │   ├── LoginPage.ts             # Used by many features
│   │   ├── NavigationComponent.ts   # Common to all pages
│   │   └── HeaderComponent.ts
│   ├── fixtures/                    # Shared test data
│   │   └── common-data.ts
│   └── utils/                       # Shared utilities
│       ├── auth-helper.ts
│       └── api-helpers.ts
└── features/
    └── [feature-name]/
        └── [ticket-id]/
            ├── automated-tests/     # Feature-specific automation
            │   ├── pom/             # Feature-specific pages only
            │   │   ├── CheckoutPage.ts
            │   │   └── PaymentPage.ts
            │   ├── tests/
            │   │   └── checkout.spec.ts
            │   ├── fixtures/
            │   │   └── checkout-data.ts
            │   └── README.md
            └── test-cases.md
```

**Pros:**
- Best of both worlds
- Shared pages centralized
- Feature-specific pages isolated
- Flexible and scalable

**Cons:**
- More complex structure
- Need clear guidelines on what to share
- Import paths can be longer

---

## Directory Purposes

### pom/ - Page Object Models

**Contains:** Classes representing pages and reusable components

**Organization options:**
```
# Option A: Flat structure (small projects)
pom/
├── BasePage.ts
├── LoginPage.ts
├── DashboardPage.ts
└── CheckoutPage.ts

# Option B: Grouped by area (medium projects)
pom/
├── BasePage.ts
├── auth/
│   ├── LoginPage.ts
│   └── RegisterPage.ts
├── shopping/
│   ├── ProductPage.ts
│   └── CartPage.ts
└── components/
    ├── ModalComponent.ts
    └── NavigationComponent.ts

# Option C: By feature module (large projects)
pom/
├── core/
│   ├── BasePage.ts
│   └── AppLayoutPage.ts
├── user-management/
│   └── UserProfilePage.ts
└── e-commerce/
    ├── ProductCatalogPage.ts
    └── CheckoutPage.ts
```

**TODO: Teams should choose structure based on project size**

---

### tests/ - Test Scripts

**Contains:** Playwright test spec files

**Naming conventions:**
```typescript
// Pattern: [feature-area].spec.ts or [page-name].spec.ts

// Option 1: By page
login.spec.ts
dashboard.spec.ts
checkout.spec.ts

// Option 2: By feature
user-authentication.spec.ts
product-search.spec.ts
order-management.spec.ts

// Option 3: By test scenario
happy-path-checkout.spec.ts
error-handling-login.spec.ts
edge-cases-search.spec.ts
```

**File organization:**
```
# Option A: Flat structure
tests/
├── login.spec.ts
├── dashboard.spec.ts
└── checkout.spec.ts

# Option B: Grouped by feature
tests/
├── auth/
│   ├── login.spec.ts
│   └── password-reset.spec.ts
├── shopping/
│   ├── product-search.spec.ts
│   ├── add-to-cart.spec.ts
│   └── checkout.spec.ts
└── admin/
    └── user-management.spec.ts

# Option C: By test type
tests/
├── smoke/
│   └── critical-path.spec.ts
├── regression/
│   ├── login.spec.ts
│   └── checkout.spec.ts
└── e2e/
    └── complete-purchase-flow.spec.ts
```

**TODO: Teams should align with their test execution strategy**

---

### fixtures/ - Test Data and Configuration

**Contains:** Test data, custom fixtures, configuration

**Organization:**
```
fixtures/
├── test-data/                       # Test data organized by entity
│   ├── users.ts                     # User test data
│   ├── products.ts                  # Product test data
│   ├── orders.ts                    # Order test data
│   └── common.ts                    # Shared test data
├── custom-fixtures.ts               # Playwright custom fixtures
├── config.ts                        # Environment configuration
└── helpers.ts                       # Data generation helpers
```

**Example content:**
```typescript
// fixtures/test-data/users.ts
export const validUser = {
  email: 'test@example.com',
  password: 'SecurePass123!',
  firstName: 'Test',
  lastName: 'User'
};

// fixtures/custom-fixtures.ts
import { test as base } from '@playwright/test';

export const test = base.extend({
  authenticatedUser: async ({ page }, use) => {
    // Custom fixture logic
    await use(page);
  }
});

// fixtures/config.ts
export const config = {
  baseUrl: process.env.BASE_URL || 'http://localhost:3000',
  apiUrl: process.env.API_URL || 'http://localhost:3001',
  timeout: parseInt(process.env.TEST_TIMEOUT || '30000')
};
```

---

### utils/ - Helper Functions

**Contains:** Reusable utility functions

**Common utilities:**
```
utils/
├── auth-helper.ts                   # Authentication utilities
├── wait-helpers.ts                  # Custom wait conditions
├── assertion-helpers.ts             # Common assertion patterns
├── api-helpers.ts                   # API interaction utilities
├── data-generators.ts               # Test data generators
└── browser-helpers.ts               # Browser-specific utilities
```

**Example content:**
```typescript
// utils/auth-helper.ts
export async function generateAuthToken(): Promise<string> {
  // TODO: Teams implement their auth token generation
  return 'token';
}

export async function loginWithToken(page: Page, token: string): Promise<void> {
  await page.goto(`${config.baseUrl}?auth_token=${token}`);
}

// utils/wait-helpers.ts
export async function waitForSpinnerToDisappear(page: Page): Promise<void> {
  await page.locator('.loading-spinner').waitFor({ state: 'hidden' });
}
```

---

## File Naming Conventions

### Test Files

**Format:** `[descriptive-name].spec.ts`

**Examples:**
```typescript
// Good examples:
login.spec.ts                        // Clear, describes what's tested
user-registration.spec.ts            // Descriptive
shopping-cart-checkout.spec.ts       // Feature flow
product-search-filters.spec.ts       // Specific functionality

// Avoid:
test1.spec.ts                        // Not descriptive
loginTest.spec.ts                    // Redundant "Test"
Login.spec.ts                        // Use kebab-case, not PascalCase
```

**TODO: Teams should establish naming conventions aligned with their workflow**

---

### POM Files

**Format:** `[PageName]Page.ts` or `[ComponentName]Component.ts`

**Examples:**
```typescript
// Page objects:
LoginPage.ts                         // Standard page
DashboardPage.ts                     // Standard page
UserProfilePage.ts                   // Standard page

// Component objects:
ModalComponent.ts                    // Reusable component
NavigationComponent.ts               // Reusable component
TableComponent.ts                    // Reusable component

// Avoid:
loginPage.ts                         // Use PascalCase
LoginPageObject.ts                   // Redundant "Object"
login.ts                             // Not clear it's a page object
```

---

### Utility Files

**Format:** `[purpose]-[type].ts`

**Examples:**
```typescript
// Good examples:
auth-helper.ts                       // Clear purpose
wait-helpers.ts                      // Plural for multiple functions
api-helpers.ts                       // Grouped utilities
data-generators.ts                   // Descriptive function

// Avoid:
utils.ts                             // Too generic
helper.ts                            // What kind of helper?
functions.ts                         // Not descriptive
```

---

## Test Execution Commands

### Running Tests

**Teams should document their test execution commands:**

```bash
# Run all tests
npx playwright test

# Run specific test file
npx playwright test tests/login.spec.ts

# Run tests in specific directory
npx playwright test tests/auth/

# Run tests with specific tag
npx playwright test --grep @smoke

# Run tests in headed mode (see browser)
npx playwright test --headed

# Run tests in specific browser
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit

# Run tests with trace for debugging
npx playwright test --trace on

# Run tests in UI mode for debugging
npx playwright test --ui

# Run specific test by name
npx playwright test --grep "should login with valid credentials"
```

### Test Execution Patterns

**Option 1: Feature-based execution**
```bash
# Run all tests for a feature
npx playwright test features/user-auth/*/automated-tests/tests/

# Run tests for specific ticket
npx playwright test features/user-auth/TICKET-123/automated-tests/tests/
```

**Option 2: Test type-based execution**
```bash
# Run smoke tests
npx playwright test --grep @smoke

# Run regression tests
npx playwright test tests/regression/

# Run E2E tests
npx playwright test tests/e2e/
```

**Option 3: CI/CD execution**
```bash
# Run in CI with specific settings
npx playwright test --reporter=html,json --workers=4
```

**TODO: Teams should define their test execution strategy**

---

## Monorepo vs Standalone Structures

### Standalone Test Project

**When to use:**
- Tests are separate from application code
- Dedicated QA team structure
- Tests run independently

**Structure:**
```
qa-automation/                       # Standalone test repository
├── automated-tests/
│   ├── pom/
│   ├── tests/
│   ├── fixtures/
│   └── utils/
├── playwright.config.ts
├── package.json
└── README.md
```

---

### Monorepo with Application

**When to use:**
- Tests live with application code
- Integrated dev/test workflow
- Shared dependencies

**Structure:**
```
my-app/                              # Application repository
├── src/                             # Application source code
│   ├── components/
│   └── pages/
├── tests/                           # Test code
│   ├── unit/                        # Unit tests
│   └── e2e/                         # E2E tests (Playwright)
│       ├── pom/
│       ├── tests/
│       ├── fixtures/
│       └── utils/
├── playwright.config.ts
└── package.json
```

---

### Multi-Package Monorepo

**When to use:**
- Multiple applications/packages
- Shared test utilities
- Enterprise-scale projects

**Structure:**
```
workspace/
├── packages/
│   ├── app-frontend/
│   │   ├── src/
│   │   └── tests/e2e/
│   ├── app-backend/
│   │   └── tests/integration/
│   └── shared-test-utils/           # Shared test utilities
│       ├── pom/
│       │   └── BasePage.ts
│       ├── fixtures/
│       └── utils/
├── playwright.config.ts             # Shared config
└── package.json
```

**TODO: Teams should choose structure based on project organization**

---

## Test Suite Documentation (README.md)

Every automated-tests folder should include a README.md:

**Minimum sections:**
```markdown
# [Feature Name] Test Automation

## Overview
Brief description of what this test suite covers

## Running Tests
How to execute these tests locally and in CI

## Test Structure
Explanation of file organization

## Adding New Tests
Guidelines for adding tests to this suite

## Troubleshooting
Common issues and solutions

## Maintenance
Who maintains this and how to report issues
```

**Full README template available in:** `templates/automation/readme-template.md`

---

## Common Directory Structures by Project Type

### Small Project (< 10 pages)
```
automated-tests/
├── pom/
│   ├── BasePage.ts
│   └── [3-10 page objects]
├── tests/
│   └── [5-15 test files]
├── fixtures/
│   └── test-data.ts
├── utils/
│   └── auth-helper.ts
└── README.md
```

---

### Medium Project (10-50 pages)
```
automated-tests/
├── pom/
│   ├── BasePage.ts
│   ├── auth/
│   ├── dashboard/
│   ├── products/
│   └── components/
├── tests/
│   ├── auth/
│   ├── dashboard/
│   └── products/
├── fixtures/
│   ├── test-data/
│   └── custom-fixtures.ts
├── utils/
│   ├── auth-helper.ts
│   ├── wait-helpers.ts
│   └── api-helpers.ts
└── README.md
```

---

### Large Project (50+ pages)
```
automated-tests/
├── pom/
│   ├── core/
│   │   ├── BasePage.ts
│   │   └── AppLayoutPage.ts
│   ├── modules/
│   │   ├── user-management/
│   │   ├── reporting/
│   │   ├── settings/
│   │   └── analytics/
│   └── components/
│       ├── navigation/
│       ├── forms/
│       └── modals/
├── tests/
│   ├── smoke/
│   ├── regression/
│   ├── modules/
│   │   ├── user-management/
│   │   ├── reporting/
│   │   └── settings/
│   └── e2e/
├── fixtures/
│   ├── test-data/
│   │   ├── users/
│   │   ├── products/
│   │   └── reports/
│   ├── factories/
│   └── custom-fixtures.ts
├── utils/
│   ├── auth/
│   ├── api/
│   ├── database/
│   └── helpers/
├── config/
│   ├── playwright.config.ts
│   ├── environments.ts
│   └── constants.ts
└── README.md
```

---

## Configuration File Locations

### playwright.config.ts

**Option 1: Project root (standalone)**
```
qa-automation/
├── playwright.config.ts             # Root level
└── automated-tests/
    └── tests/
```

**Option 2: Test directory (monorepo)**
```
my-app/
├── src/
└── tests/
    ├── playwright.config.ts         # In test directory
    └── e2e/
        └── tests/
```

**Option 3: Per-feature (feature-based)**
```
features/
└── user-auth/
    └── TICKET-123/
        └── automated-tests/
            ├── playwright.config.ts # Feature-specific config
            └── tests/
```

**TODO: Teams should choose based on configuration needs**

---

## Teams Should Customize:

1. **Organization Pattern:**
   - Choose: Feature-based, Page-based, or Hybrid
   - Document rationale in README

2. **File Naming:**
   - Establish conventions for test files
   - Define POM naming patterns
   - Create utility file standards

3. **Directory Structure:**
   - Decide on flat vs nested structure
   - Define grouping strategy (by feature, by page, by type)
   - Document with examples

4. **Test Execution:**
   - Define standard commands
   - Create npm scripts for common operations
   - Document CI/CD integration

5. **Scaling Strategy:**
   - Plan for growth (10 pages → 100 pages → 1000 pages)
   - Define when to split/reorganize
   - Maintain flexibility

---

## After Customization:

The `/automate-testcases` command will:
1. Read your chosen organization pattern
2. Generate files following your structure
3. Apply your naming conventions
4. Create appropriate directory hierarchy
5. Include proper imports based on your paths

Generated automated tests will be created according to your defined structure.
