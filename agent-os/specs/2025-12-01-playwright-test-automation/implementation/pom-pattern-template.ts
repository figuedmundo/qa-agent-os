/**
 * Page Object Model (POM) Pattern Template
 *
 * This file serves as a TEMPLATE showing the expected structure for POM classes
 * to be generated during test automation.
 *
 * IMPORTANT: This is a TEMPLATE file for multi-team use
 * - Different teams will have different BasePage implementations
 * - This file remains as an instructional placeholder in QA Agent OS
 * - Teams should customize this for their specific project needs
 *
 * ============================================================================
 * KEY PRINCIPLES:
 * ============================================================================
 * - One POM class per page/component
 * - Selectors defined as private constants in SELECTORS object
 * - Actions as public methods representing user interactions
 * - Getters as public methods for data retrieval
 * - Assertions handled separately or in dedicated assertion methods
 * - No test logic in POM classes - only page interactions
 *
 * ============================================================================
 * STANDARD POM CLASS STRUCTURE:
 * ============================================================================
 *
 * 1. Imports (Playwright Page object, BasePage if used)
 * 2. Class definition extending BasePage (optional but recommended)
 * 3. SELECTORS object with private readonly constants
 * 4. Public locators for test assertions
 * 5. Constructor accepting Page object
 * 6. Navigation methods
 * 7. Public action methods (click, fill, select, etc.)
 * 8. Public getter methods for data retrieval
 * 9. Optional: assertion helper methods
 * 10. Private helper methods for complex interactions
 *
 * ============================================================================
 * EXAMPLE 1: BASIC LOGIN PAGE (Simple Pattern)
 * ============================================================================
 */

import { Page, Locator } from '@playwright/test';

/**
 * Example 1: Simple LoginPage without BasePage
 *
 * Use this pattern for:
 * - Simple projects without shared utilities
 * - Quick prototyping
 * - Teams that prefer explicit code over inheritance
 */
export class LoginPageExample {
  private readonly page: Page;

  // TODO: Teams should customize selectors based on their application's DOM structure
  // Selector priority: data-testid > ID > role > class > tag
  private readonly SELECTORS = {
    // Group related selectors for better organization
    form: {
      usernameInput: '[data-testid="username-input"]',  // Preferred: data-testid
      passwordInput: '#password',                        // Alternative: ID
      submitButton: 'button[type="submit"]',             // Last resort: tag + attribute
      rememberMeCheckbox: '[data-testid="remember-me"]'
    },
    messages: {
      errorMessage: '.error-message',                    // Class selector
      successMessage: '[role="alert"]'                   // ARIA role
    },
    links: {
      forgotPasswordLink: 'a[href="/forgot-password"]',
      signUpLink: '[data-testid="signup-link"]'
    }
  };

  // Public locators - exposed for test assertions
  // TODO: Teams decide which locators to expose publicly based on what needs to be asserted in tests
  readonly errorMessage: Locator;
  readonly submitButton: Locator;

  constructor(page: Page) {
    this.page = page;

    // Initialize public locators in constructor
    this.errorMessage = page.locator(this.SELECTORS.messages.errorMessage);
    this.submitButton = page.locator(this.SELECTORS.form.submitButton);
  }

  // Navigation methods
  async navigate(): Promise<void> {
    await this.page.goto('/login');
    await this.page.waitForLoadState('networkidle');
  }

  // Action methods - represent user interactions
  // TODO: Teams should create methods that match their application's user workflows
  async login(username: string, password: string): Promise<void> {
    await this.page.locator(this.SELECTORS.form.usernameInput).fill(username);
    await this.page.locator(this.SELECTORS.form.passwordInput).fill(password);
    await this.page.locator(this.SELECTORS.form.submitButton).click();
  }

  async loginWithRememberMe(username: string, password: string): Promise<void> {
    await this.page.locator(this.SELECTORS.form.usernameInput).fill(username);
    await this.page.locator(this.SELECTORS.form.passwordInput).fill(password);
    await this.page.locator(this.SELECTORS.form.rememberMeCheckbox).check();
    await this.page.locator(this.SELECTORS.form.submitButton).click();
  }

  async clickForgotPassword(): Promise<void> {
    await this.page.locator(this.SELECTORS.links.forgotPasswordLink).click();
  }

  // Getter methods - retrieve page state/data
  async getErrorMessage(): Promise<string> {
    return await this.errorMessage.textContent() || '';
  }

  async isLoginButtonEnabled(): Promise<boolean> {
    return await this.submitButton.isEnabled();
  }

  // Optional: assertion helper methods for common checks
  async waitForErrorMessage(): Promise<void> {
    await this.errorMessage.waitFor({ state: 'visible' });
  }
}

/**
 * ============================================================================
 * EXAMPLE 2: PAGE WITH BASEPAGE (Recommended Pattern)
 * ============================================================================
 *
 * Use this pattern for:
 * - Projects with multiple pages sharing common utilities
 * - Teams wanting to reduce code duplication
 * - Scalable test automation frameworks
 *
 * TODO: Teams should create their own BasePage class with project-specific utilities
 */

/**
 * BasePage Pattern Option 1: Minimal BasePage
 *
 * This provides basic shared functionality
 */
export abstract class BasePageMinimal {
  protected readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // Common navigation
  protected async navigateTo(url: string): Promise<void> {
    await this.page.goto(url);
    await this.page.waitForLoadState('networkidle');
  }

  // Common wait helpers
  protected async waitForElement(selector: string): Promise<void> {
    await this.page.waitForSelector(selector, { state: 'visible' });
  }
}

/**
 * BasePage Pattern Option 2: Feature-Rich BasePage
 *
 * This provides comprehensive shared utilities
 * TODO: Teams should customize with their specific helper methods
 */
export abstract class BasePageFull {
  protected readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // ===== NAVIGATION HELPERS =====
  // TODO: Customize with your authentication mechanism
  protected async navigateTo(url: string): Promise<void> {
    await this.page.goto(url);
    await this.page.waitForLoadState('networkidle');
  }

  protected async navigateWithToken(url: string, token: string): Promise<void> {
    await this.page.goto(`${url}?auth_token=${token}`);
    await this.page.waitForLoadState('networkidle');
  }

  // ===== INTERACTION HELPERS =====
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

  protected async selectDropdown(locator: Locator, value: string): Promise<void> {
    await locator.selectOption(value);
  }

  // ===== WAIT HELPERS =====
  // TODO: Add custom wait conditions specific to your application
  protected async waitForElement(selector: string, timeout = 10000): Promise<void> {
    await this.page.waitForSelector(selector, { timeout, state: 'visible' });
  }

  protected async waitForNetworkIdle(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
  }

  protected async waitForText(locator: Locator, text: string): Promise<void> {
    await locator.waitFor({ state: 'visible' });
    await this.page.waitForFunction(
      (args) => {
        const element = document.querySelector(args.selector);
        return element?.textContent?.includes(args.text);
      },
      { selector: locator, text }
    );
  }

  // ===== GETTER HELPERS =====
  protected async getText(locator: Locator): Promise<string> {
    return await locator.textContent() || '';
  }

  protected async isVisible(locator: Locator): Promise<boolean> {
    try {
      return await locator.isVisible();
    } catch {
      return false;
    }
  }

  protected async getAttributeValue(locator: Locator, attribute: string): Promise<string> {
    return await locator.getAttribute(attribute) || '';
  }

  // ===== VALIDATION HELPERS =====
  protected async expectElementVisible(locator: Locator): Promise<void> {
    await locator.waitFor({ state: 'visible' });
  }

  protected async expectElementHidden(locator: Locator): Promise<void> {
    await locator.waitFor({ state: 'hidden' });
  }

  // ===== ERROR RECOVERY HELPERS =====
  // TODO: Add project-specific error recovery patterns
  protected async retryOnStaleElement<T>(
    action: () => Promise<T>,
    maxRetries = 3
  ): Promise<T> {
    let lastError: Error | undefined;

    for (let i = 0; i < maxRetries; i++) {
      try {
        return await action();
      } catch (error) {
        lastError = error as Error;
        if (error instanceof Error && error.message.includes('stale')) {
          await this.page.waitForTimeout(500);
          continue;
        }
        throw error;
      }
    }

    throw lastError;
  }
}

/**
 * Example using BasePage: Dashboard Page
 */
export class DashboardPageExample extends BasePageFull {
  private readonly SELECTORS = {
    header: {
      userName: '[data-testid="user-name"]',
      logoutButton: '[data-testid="logout"]',
      notificationIcon: '[data-testid="notifications"]'
    },
    navigation: {
      homeLink: '[data-testid="nav-home"]',
      profileLink: '[data-testid="nav-profile"]',
      settingsLink: '[data-testid="nav-settings"]'
    },
    content: {
      welcomeMessage: '.welcome-message',
      statsWidget: '[data-testid="stats-widget"]',
      recentActivity: '[data-testid="recent-activity"]'
    }
  };

  // Public locators for assertions
  readonly welcomeMessage: Locator;
  readonly userName: Locator;

  constructor(page: Page) {
    super(page);
    this.welcomeMessage = page.locator(this.SELECTORS.content.welcomeMessage);
    this.userName = page.locator(this.SELECTORS.header.userName);
  }

  async navigate(): Promise<void> {
    await this.navigateTo('/dashboard');
  }

  async logout(): Promise<void> {
    await this.page.locator(this.SELECTORS.header.logoutButton).click();
    await this.waitForNetworkIdle();
  }

  async goToProfile(): Promise<void> {
    await this.clickAndWait(
      this.page.locator(this.SELECTORS.navigation.profileLink),
      this.SELECTORS.header.userName
    );
  }

  async getUserName(): Promise<string> {
    return await this.getText(this.userName);
  }

  async hasNotifications(): Promise<boolean> {
    const badge = this.page.locator(`${this.SELECTORS.header.notificationIcon} .badge`);
    return await this.isVisible(badge);
  }
}

/**
 * ============================================================================
 * EXAMPLE 3: COMPONENT PAGE OBJECTS
 * ============================================================================
 *
 * Use this pattern for reusable UI components that appear on multiple pages
 *
 * TODO: Teams should create component pages for:
 * - Modals/Dialogs
 * - Navigation menus
 * - Forms
 * - Tables/Data grids
 * - Autocomplete/Dropdown widgets
 */

export class ModalComponentExample {
  private readonly page: Page;

  private readonly SELECTORS = {
    container: '.modal-overlay',
    dialog: '[role="dialog"]',
    title: '.modal-title',
    closeButton: '[data-testid="modal-close"]',
    confirmButton: '[data-testid="modal-confirm"]',
    cancelButton: '[data-testid="modal-cancel"]',
    content: '.modal-content'
  };

  readonly title: Locator;
  readonly confirmButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.title = page.locator(this.SELECTORS.title);
    this.confirmButton = page.locator(this.SELECTORS.confirmButton);
  }

  async waitForModal(): Promise<void> {
    await this.page.locator(this.SELECTORS.container).waitFor({ state: 'visible' });
  }

  async close(): Promise<void> {
    await this.page.locator(this.SELECTORS.closeButton).click();
    await this.page.locator(this.SELECTORS.container).waitFor({ state: 'hidden' });
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

  async getContent(): Promise<string> {
    return await this.page.locator(this.SELECTORS.content).textContent() || '';
  }
}

/**
 * ============================================================================
 * SELECTOR STRATEGY DOCUMENTATION
 * ============================================================================
 *
 * PRIORITY ORDER (Most Stable → Least Stable):
 *
 * 1. data-testid attributes (MOST STABLE - Recommended)
 *    '[data-testid="submit-button"]'
 *    - Pros: Specifically for testing, won't change with styling
 *    - Cons: Requires adding attributes to source code
 *    - When to use: Always, if possible
 *
 * 2. ID attributes
 *    '#login-button'
 *    - Pros: Unique, fast
 *    - Cons: May change with development
 *    - When to use: When data-testid not available and ID is semantic
 *
 * 3. ARIA roles and labels
 *    'button[aria-label="Submit"]'
 *    - Pros: Accessibility-friendly, semantic
 *    - Cons: May not be unique
 *    - When to use: For accessibility compliance or when other options unavailable
 *
 * 4. CSS classes (semantic, not style-related)
 *    '.login-form-submit'
 *    - Pros: Usually available
 *    - Cons: May change with styling updates
 *    - When to use: Only if class is semantic (e.g., 'error-message' not 'red-text')
 *
 * 5. Tag + attribute combinations (LAST RESORT)
 *    'button[type="submit"]'
 *    - Pros: Always available
 *    - Cons: Least stable, may not be unique
 *    - When to use: No other option available
 *
 * COMPLEX SELECTOR EXAMPLES:
 *
 * // TODO: Add comments for complex selectors explaining why they were chosen
 *
 * // Example 1: Nested selectors when multiple similar elements exist
 * private readonly submitButtonInLoginForm =
 *   '.login-form button[type="submit"]';
 *   // Why: Multiple submit buttons on page, need to target specific form
 *
 * // Example 2: nth-child when dealing with dynamic lists
 * private readonly firstProductCard =
 *   '[data-testid="product-list"] > div:nth-child(1)';
 *   // Why: Product cards are generated dynamically, no unique identifiers
 *
 * // Example 3: Text-based selectors for specific content
 * private readonly errorMessageWithText =
 *   'text="Invalid credentials"';
 *   // Why: Multiple error messages possible, need specific one
 *
 * // Example 4: Combining role with text for accessibility
 * private readonly submitButton =
 *   'button:has-text("Submit")';
 *   // Why: Multiple buttons, text content distinguishes them
 */

/**
 * ============================================================================
 * PLACEHOLDER METHODS TEAMS COMMONLY NEED
 * ============================================================================
 *
 * TODO: Teams should implement these common method patterns as needed
 */

export class CommonMethodPatternsExample {
  private readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // ===== FORM INTERACTIONS =====

  /**
   * Fill a complete form with data object
   * TODO: Customize for your form structure
   */
  async fillForm(formData: Record<string, string>): Promise<void> {
    for (const [field, value] of Object.entries(formData)) {
      await this.page.locator(`[name="${field}"]`).fill(value);
    }
  }

  /**
   * Select from dropdown/autocomplete
   * TODO: Adapt for your dropdown implementation
   */
  async selectFromDropdown(dropdownSelector: string, optionText: string): Promise<void> {
    await this.page.locator(dropdownSelector).click();
    await this.page.locator(`text="${optionText}"`).click();
  }

  /**
   * Upload file
   * TODO: Adjust selector and path handling
   */
  async uploadFile(fileInputSelector: string, filePath: string): Promise<void> {
    await this.page.locator(fileInputSelector).setInputFiles(filePath);
  }

  // ===== TABLE/LIST INTERACTIONS =====

  /**
   * Get all items from a list
   * TODO: Customize for your list/table structure
   */
  async getListItems(listSelector: string): Promise<string[]> {
    const items = await this.page.locator(`${listSelector} li`).all();
    return Promise.all(items.map(item => item.textContent() || ''));
  }

  /**
   * Click item in table by row number
   * TODO: Adapt for your table structure
   */
  async clickTableRow(tableSelector: string, rowIndex: number): Promise<void> {
    await this.page.locator(`${tableSelector} tr:nth-child(${rowIndex})`).click();
  }

  // ===== DYNAMIC CONTENT =====

  /**
   * Wait for dynamic content to load
   * TODO: Customize loading indicators
   */
  async waitForContentLoad(contentSelector: string): Promise<void> {
    // Wait for loading spinner to disappear
    await this.page.locator('.loading-spinner').waitFor({ state: 'hidden' });
    // Wait for content to appear
    await this.page.locator(contentSelector).waitFor({ state: 'visible' });
  }

  /**
   * Handle infinite scroll
   * TODO: Adjust for your scroll implementation
   */
  async scrollToLoadMore(): Promise<void> {
    await this.page.evaluate(() => {
      window.scrollTo(0, document.body.scrollHeight);
    });
    await this.page.waitForLoadState('networkidle');
  }

  // ===== VALIDATION/ASSERTIONS =====

  /**
   * Check if validation error is displayed
   * TODO: Customize for your validation UI
   */
  async hasValidationError(fieldName: string): Promise<boolean> {
    const errorSelector = `[data-field="${fieldName}"] .error-message`;
    try {
      return await this.page.locator(errorSelector).isVisible();
    } catch {
      return false;
    }
  }

  /**
   * Get all validation errors on page
   * TODO: Adapt for your error display pattern
   */
  async getAllValidationErrors(): Promise<string[]> {
    const errors = await this.page.locator('.error-message').all();
    return Promise.all(errors.map(error => error.textContent() || ''));
  }
}

/**
 * ============================================================================
 * TEAMS SHOULD CUSTOMIZE:
 * ============================================================================
 *
 * 1. SELECTORS:
 *    - Update selector priority based on your DOM structure
 *    - Add data-testid attributes to your application if possible
 *    - Document complex selectors with comments
 *
 * 2. BASEPAGE:
 *    - Choose minimal or full BasePage based on project needs
 *    - Add project-specific utilities (auth, navigation, wait helpers)
 *    - Implement error recovery patterns for your application
 *
 * 3. COMPONENT PAGES:
 *    - Create component pages for reusable UI elements
 *    - Modal dialogs, navigation menus, forms, tables, etc.
 *
 * 4. METHOD PATTERNS:
 *    - Implement form filling, dropdown selection, file upload
 *    - Add table/list interaction methods
 *    - Create dynamic content waiting strategies
 *
 * 5. ERROR HANDLING:
 *    - Define how to handle stale elements
 *    - Implement retry logic for flaky interactions
 *    - Add custom wait conditions for your application
 *
 * ============================================================================
 * AFTER CUSTOMIZATION:
 * ============================================================================
 *
 * The /automate-testcases command will:
 * 1. Read your customized templates
 * 2. Explore the DOM of your application
 * 3. Generate POM classes following your patterns
 * 4. Use your BasePage utilities
 * 5. Apply your selector strategy
 *
 * Generated POM classes will be created in:
 * features/[feature-name]/[ticket-id]/automated-tests/pom/
 */
