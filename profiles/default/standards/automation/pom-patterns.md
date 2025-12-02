# Page Object Model (POM) Construction Standards

This standard defines how to construct and organize Page Object Model classes for Playwright test automation in QA Agent OS.

---

## Core Principles

1. **Encapsulation**: Hide implementation details, expose behavioral methods
2. **Single Responsibility**: Each page object represents one page or component
3. **Selector Centralization**: All selectors defined in one place per page
4. **Reusability**: Common patterns extracted to Base Page
5. **Maintainability**: Clear naming, logical organization, comprehensive comments

---

## POM Class Structure

### Standard Template

```typescript
import { Page, Locator } from '@playwright/test';
import { BasePage } from './BasePage';

export class [PageName]Page extends BasePage {
  // 1. SELECTORS: Define all element selectors
  private readonly SELECTORS = {
    // Group related selectors
    form: {
      usernameInput: '[data-testid="username-input"]',
      passwordInput: '[data-testid="password-input"]',
      submitButton: '[data-testid="login-button"]'
    },
    messages: {
      errorMessage: '.error-message',
      successMessage: '.success-message'
    },
    navigation: {
      logo: '.app-logo',
      menuButton: '[data-testid="menu"]'
    }
  };

  // 2. LOCATORS: Public locators for assertions in tests
  readonly usernameInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  // 3. CONSTRUCTOR: Initialize page and locators
  constructor(page: Page) {
    super(page);
    this.usernameInput = page.locator(this.SELECTORS.form.usernameInput);
    this.passwordInput = page.locator(this.SELECTORS.form.passwordInput);
    this.submitButton = page.locator(this.SELECTORS.form.submitButton);
    this.errorMessage = page.locator(this.SELECTORS.messages.errorMessage);
  }

  // 4. NAVIGATION: Methods to navigate to this page
  async navigate(): Promise<void> {
    await this.page.goto('/login');
    await this.waitForPageLoad();
  }

  // 5. ACTIONS: Methods representing user actions
  async login(username: string, password: string): Promise<void> {
    await this.fillInput(this.usernameInput, username);
    await this.fillInput(this.passwordInput, password);
    await this.submitButton.click();
  }

  async clearForm(): Promise<void> {
    await this.usernameInput.clear();
    await this.passwordInput.clear();
  }

  // 6. GETTERS: Methods to retrieve page state/data
  async getErrorMessage(): Promise<string> {
    return await this.errorMessage.textContent() || '';
  }

  async isLoginButtonEnabled(): Promise<boolean> {
    return await this.submitButton.isEnabled();
  }

  // 7. WAIT CONDITIONS: Custom wait methods for this page
  async waitForErrorMessage(): Promise<void> {
    await this.errorMessage.waitFor({ state: 'visible' });
  }

  private async waitForPageLoad(): Promise<void> {
    await this.page.waitForSelector(this.SELECTORS.form.usernameInput);
  }
}
```

---

## Selector Strategy

### Priority Order

Use selectors in this priority (most stable to least stable):

1. **data-testid attributes** (most stable)
   ```typescript
   '[data-testid="submit-button"]'
   ```

2. **ID attributes**
   ```typescript
   '#login-button'
   ```

3. **ARIA roles and labels**
   ```typescript
   'button[aria-label="Submit"]'
   ```

4. **CSS classes** (semantic, not style-related)
   ```typescript
   '.login-form-submit'
   ```

5. **Tag + attribute combinations** (last resort)
   ```typescript
   'button[type="submit"]'
   ```

### Selector Organization

Group selectors logically in the SELECTORS object:

```typescript
private readonly SELECTORS = {
  // Form elements
  form: {
    nameInput: '[data-testid="name"]',
    emailInput: '[data-testid="email"]',
    submitButton: '[data-testid="submit"]'
  },

  // Validation messages
  validation: {
    nameError: '.name-error',
    emailError: '.email-error',
    successMessage: '.success'
  },

  // Navigation elements
  navigation: {
    homeLink: '[data-testid="nav-home"]',
    profileLink: '[data-testid="nav-profile"]'
  }
};
```

---

## BasePage Class

### Purpose

BasePage provides common functionality shared across all page objects:

```typescript
import { Page, Locator } from '@playwright/test';

export abstract class BasePage {
  protected readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // Common navigation helpers
  protected async navigateTo(url: string): Promise<void> {
    await this.page.goto(url);
  }

  protected async navigateWithToken(url: string, token: string): Promise<void> {
    await this.page.goto(`${url}?auth_token=${token}`);
  }

  // Common interaction helpers
  protected async fillInput(locator: Locator, value: string): Promise<void> {
    await locator.clear();
    await locator.fill(value);
  }

  protected async clickAndWait(locator: Locator, waitForSelector?: string): Promise<void> {
    await locator.click();
    if (waitForSelector) {
      await this.page.waitForSelector(waitForSelector);
    }
  }

  // Common wait helpers
  protected async waitForElement(selector: string, timeout = 10000): Promise<void> {
    await this.page.waitForSelector(selector, { timeout });
  }

  protected async waitForNetworkIdle(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
  }

  // Common getter helpers
  protected async getText(locator: Locator): Promise<string> {
    return await locator.textContent() || '';
  }

  protected async isVisible(locator: Locator): Promise<boolean> {
    return await locator.isVisible();
  }

  // Common validation helpers
  protected async expectElementVisible(locator: Locator): Promise<void> {
    await locator.waitFor({ state: 'visible' });
  }

  protected async expectElementHidden(locator: Locator): Promise<void> {
    await locator.waitFor({ state: 'hidden' });
  }
}
```

**Teams should customize BasePage** with their project-specific utilities and patterns.

---

## Method Naming Conventions

### Action Methods (User Interactions)

Use action verbs in imperative mood:

```typescript
// ✅ Good
async login(username: string, password: string): Promise<void>
async fillContactForm(data: ContactFormData): Promise<void>
async selectOption(value: string): Promise<void>
async toggleNotifications(): Promise<void>

// ❌ Bad
async doLogin(...) // Redundant "do"
async clickSubmit() // Too implementation-specific
async userLogin(...) // Awkward naming
```

### Getter Methods (Data Retrieval)

Use get prefix or is/has for booleans:

```typescript
// ✅ Good
async getErrorMessage(): Promise<string>
async getUserName(): Promise<string>
async isLoginButtonEnabled(): Promise<boolean>
async hasNotifications(): Promise<boolean>

// ❌ Bad
async errorMessage() // Unclear if action or getter
async checkLoginButton() // Ambiguous
```

### Wait Methods

Use wait prefix:

```typescript
// ✅ Good
async waitForDashboard(): Promise<void>
async waitForSuccessMessage(): Promise<void>

// ❌ Bad
async dashboard() // Not clear it's a wait
async ensureLoaded() // Vague
```

---

## Locator Visibility

### Public vs Private Locators

**Public locators** (for test assertions):

```typescript
export class LoginPage extends BasePage {
  // Public: Used in test assertions
  readonly errorMessage: Locator;
  readonly submitButton: Locator;

  constructor(page: Page) {
    super(page);
    this.errorMessage = page.locator(this.SELECTORS.messages.errorMessage);
    this.submitButton = page.locator(this.SELECTORS.form.submitButton);
  }
}

// Usage in tests:
await expect(loginPage.errorMessage).toBeVisible();
```

**Private locators** (internal only):

```typescript
export class LoginPage extends BasePage {
  // Private: Used only within page object methods
  private readonly usernameInput: Locator;

  constructor(page: Page) {
    super(page);
    this.usernameInput = page.locator(this.SELECTORS.form.usernameInput);
  }

  async login(username: string, password: string): Promise<void> {
    // Internal use only
    await this.usernameInput.fill(username);
  }
}

// Tests use methods, not private locators:
await loginPage.login('user@example.com', 'password');
```

---

## Component Pages

### When to Create Component Pages

Create separate component page objects for:
- Reusable UI components (modals, dropdowns, navigation)
- Complex widgets appearing on multiple pages
- Dynamic content sections

### Component Example

```typescript
// components/ModalComponent.ts
export class ModalComponent extends BasePage {
  private readonly SELECTORS = {
    modal: '.modal-container',
    title: '.modal-title',
    closeButton: '[data-testid="modal-close"]',
    confirmButton: '[data-testid="modal-confirm"]',
    cancelButton: '[data-testid="modal-cancel"]'
  };

  readonly modalContainer: Locator;
  readonly title: Locator;

  constructor(page: Page) {
    super(page);
    this.modalContainer = page.locator(this.SELECTORS.modal);
    this.title = page.locator(this.SELECTORS.title);
  }

  async close(): Promise<void> {
    await this.page.locator(this.SELECTORS.closeButton).click();
  }

  async confirm(): Promise<void> {
    await this.page.locator(this.SELECTORS.confirmButton).click();
  }

  async cancel(): Promise<void> {
    await this.page.locator(this.SELECTORS.cancelButton).click();
  }

  async getTitle(): Promise<string> {
    return await this.title.textContent() || '';
  }

  async waitForModal(): Promise<void> {
    await this.modalContainer.waitFor({ state: 'visible' });
  }
}
```

**Usage in page objects:**

```typescript
export class DashboardPage extends BasePage {
  readonly deleteModal: ModalComponent;

  constructor(page: Page) {
    super(page);
    this.deleteModal = new ModalComponent(page);
  }

  async deleteItem(): Promise<void> {
    await this.page.click('[data-testid="delete-button"]');
    await this.deleteModal.waitForModal();
    await this.deleteModal.confirm();
  }
}
```

---

## Error Handling in POMs

### Expected Errors

Handle expected errors gracefully:

```typescript
export class LoginPage extends BasePage {
  async login(username: string, password: string): Promise<void> {
    await this.usernameInput.fill(username);
    await this.passwordInput.fill(password);
    await this.submitButton.click();

    // Don't handle errors here - let tests verify outcomes
  }

  async getErrorMessage(): Promise<string | null> {
    try {
      return await this.errorMessage.textContent();
    } catch {
      return null; // Error message not present
    }
  }
}
```

### Unexpected Errors

Let unexpected errors bubble up to tests:

```typescript
// ❌ Bad: Hiding errors
async login(username: string, password: string): Promise<void> {
  try {
    await this.usernameInput.fill(username);
    await this.submitButton.click();
  } catch (error) {
    console.log('Login failed'); // Silently swallow error
  }
}

// ✅ Good: Let errors surface
async login(username: string, password: string): Promise<void> {
  await this.usernameInput.fill(username);
  await this.submitButton.click();
  // If this fails, the test should fail
}
```

---

## File Organization

### Directory Structure

```
automated-tests/
├── pom/
│   ├── BasePage.ts              # Base class for all pages
│   ├── LoginPage.ts              # Login page object
│   ├── DashboardPage.ts          # Dashboard page object
│   ├── ProfilePage.ts            # Profile page object
│   └── components/               # Reusable components
│       ├── ModalComponent.ts
│       ├── NavigationComponent.ts
│       └── TableComponent.ts
├── tests/
│   └── [test files referencing POMs]
└── fixtures/
    └── [test data and fixtures]
```

### File Naming

- One page object per file
- File name matches class name: `LoginPage.ts` for `class LoginPage`
- Component files in `components/` subdirectory

---

## Documentation Requirements

### Class-Level Comments

```typescript
/**
 * LoginPage - Represents the application login page
 *
 * URL: /login
 * Purpose: Handles user authentication
 *
 * Common actions:
 * - login(username, password): Authenticates user
 * - resetPassword(): Initiates password reset flow
 *
 * Source: feature-knowledge.md > User Authentication
 * Generated: 2025-12-01
 */
export class LoginPage extends BasePage {
  // Implementation
}
```

### Method Comments

```typescript
/**
 * Logs in a user with the provided credentials
 *
 * @param username - User's email address
 * @param password - User's password
 * @throws Will fail if form submission encounters an error
 */
async login(username: string, password: string): Promise<void> {
  await this.usernameInput.fill(username);
  await this.passwordInput.fill(password);
  await this.submitButton.click();
}
```

---

## Standards Compliance Checklist

Before committing POM classes, verify:

- [ ] Class extends BasePage
- [ ] All selectors defined in SELECTORS object
- [ ] Selector priority order followed (data-testid > ID > role > class)
- [ ] Public locators for test assertions, private for internal use
- [ ] Method names follow conventions (action verbs, get/is/has prefixes)
- [ ] No hardcoded URLs or test data in POMs
- [ ] Class and method documentation complete
- [ ] Component pages created for reusable UI elements
- [ ] Error handling follows standards (don't hide errors)
- [ ] File naming matches class name

---

## Examples

### Complete Example: Search Page

```typescript
import { Page, Locator } from '@playwright/test';
import { BasePage } from './BasePage';

/**
 * SearchPage - Represents the product search page
 *
 * URL: /search
 * Purpose: Product search and filtering functionality
 */
export class SearchPage extends BasePage {
  private readonly SELECTORS = {
    search: {
      input: '[data-testid="search-input"]',
      button: '[data-testid="search-button"]',
      clearButton: '[data-testid="clear-search"]'
    },
    results: {
      container: '.search-results',
      item: '.search-result-item',
      count: '.result-count',
      noResults: '.no-results-message'
    },
    filters: {
      category: '[data-testid="filter-category"]',
      priceMin: '[data-testid="filter-price-min"]',
      priceMax: '[data-testid="filter-price-max"]',
      applyFilters: '[data-testid="apply-filters"]'
    }
  };

  // Public locators for assertions
  readonly searchInput: Locator;
  readonly searchButton: Locator;
  readonly resultsContainer: Locator;
  readonly resultCount: Locator;
  readonly noResultsMessage: Locator;

  constructor(page: Page) {
    super(page);
    this.searchInput = page.locator(this.SELECTORS.search.input);
    this.searchButton = page.locator(this.SELECTORS.search.button);
    this.resultsContainer = page.locator(this.SELECTORS.results.container);
    this.resultCount = page.locator(this.SELECTORS.results.count);
    this.noResultsMessage = page.locator(this.SELECTORS.results.noResults);
  }

  async navigate(): Promise<void> {
    await this.page.goto('/search');
    await this.waitForPageLoad();
  }

  /**
   * Performs a search with the given query
   */
  async search(query: string): Promise<void> {
    await this.fillInput(this.searchInput, query);
    await this.searchButton.click();
    await this.waitForResults();
  }

  /**
   * Clears the current search
   */
  async clearSearch(): Promise<void> {
    await this.page.locator(this.SELECTORS.search.clearButton).click();
  }

  /**
   * Applies price range filter
   */
  async filterByPrice(min: number, max: number): Promise<void> {
    await this.page.locator(this.SELECTORS.filters.priceMin).fill(min.toString());
    await this.page.locator(this.SELECTORS.filters.priceMax).fill(max.toString());
    await this.page.locator(this.SELECTORS.filters.applyFilters).click();
    await this.waitForResults();
  }

  /**
   * Gets the number of search results
   */
  async getResultCount(): Promise<number> {
    const text = await this.resultCount.textContent() || '0';
    return parseInt(text.match(/\d+/)?.[0] || '0');
  }

  /**
   * Checks if no results message is displayed
   */
  async hasNoResults(): Promise<boolean> {
    return await this.noResultsMessage.isVisible();
  }

  private async waitForPageLoad(): Promise<void> {
    await this.page.waitForSelector(this.SELECTORS.search.input);
  }

  private async waitForResults(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
  }
}
```

---

## References

**Related Standards:**
- `@qa-agent-os/standards/automation/playwright.md` - Test script standards
- `@qa-agent-os/standards/automation/test-data-management.md` - Test data handling
- `@qa-agent-os/standards/global/coding-style.md` - General coding conventions

**Playwright Resources:**
- Page Object Model: https://playwright.dev/docs/pom
- Locators: https://playwright.dev/docs/locators
- Best Practices: https://playwright.dev/docs/best-practices

---

*This standard ensures all generated POM classes are consistent, maintainable, and follow industry best practices.*
