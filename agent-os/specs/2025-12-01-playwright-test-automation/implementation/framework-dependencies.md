# Playwright Framework Configuration Guide

## Overview

This document serves as a **CONFIGURATION GUIDE** for Playwright test automation setup. This is a TEMPLATE for multi-team use - different teams will have different configurations based on their infrastructure and requirements.

**IMPORTANT:** This file remains as an instructional template in QA Agent OS. Teams should customize configurations for their specific environments and needs.

---

## Core Framework Dependencies

### Required Packages

```json
{
  "devDependencies": {
    "@playwright/test": "^1.40.0",
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0"
  }
}
```

**Installation:**
```bash
npm install -D @playwright/test typescript @types/node

# Install browser binaries
npx playwright install
```

### Optional Packages (Teams Choose Based on Needs)

```json
{
  "devDependencies": {
    // Test data management
    "@faker-js/faker": "^8.0.0",           // Generate realistic test data

    // API testing
    "axios": "^1.6.0",                     // HTTP requests for setup/teardown

    // Environment management
    "dotenv": "^16.0.0",                   // Load .env files

    // Additional assertions
    "expect-playwright": "^0.8.0",         // Extended assertions

    // Visual testing (optional)
    "@playwright/experimental-ct-react": "^1.40.0",  // Component testing

    // Reporting
    "allure-playwright": "^2.15.0",        // Allure reports
    "playwright-html-reporter": "^1.0.0"   // Custom HTML reports
  }
}
```

**TODO: Teams should choose optional packages based on their testing needs**

---

## Playwright Configuration (`playwright.config.ts`)

### Example Configuration with Placeholders

```typescript
import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';

// Load environment variables
dotenv.config();

/**
 * Playwright Test Configuration
 *
 * TODO: Teams should customize this configuration for their project
 *
 * See https://playwright.dev/docs/test-configuration
 */
export default defineConfig({
  // ============================================
  // TEST DIRECTORY CONFIGURATION
  // ============================================

  /**
   * Directory containing test files
   * TODO: Update based on your organization pattern
   */
  testDir: './tests',

  // Alternative patterns for different organization structures:
  // testDir: './features/**/automated-tests/tests',  // Feature-based
  // testDir: './automated-tests/tests',              // Centralized
  // testDir: './e2e/tests',                          // Monorepo

  /**
   * Pattern to match test files
   * TODO: Customize if you use different naming conventions
   */
  testMatch: '**/*.spec.ts',

  // ============================================
  // EXECUTION SETTINGS
  // ============================================

  /**
   * Maximum time one test can run for
   * TODO: Adjust based on your test complexity
   */
  timeout: 30 * 1000, // 30 seconds

  /**
   * Test execution settings
   */
  fullyParallel: true,  // Run tests in parallel

  /**
   * Fail the build on CI if you accidentally left test.only in the source code
   */
  forbidOnly: !!process.env.CI,

  /**
   * Retry on CI only
   * TODO: Adjust retry strategy based on test stability
   */
  retries: process.env.CI ? 2 : 0,

  /**
   * Number of parallel workers
   * TODO: Adjust based on CI/local resources
   */
  workers: process.env.CI ? 4 : undefined, // undefined = all CPU cores

  // ============================================
  // REPORTER CONFIGURATION
  // ============================================

  /**
   * Reporter to use
   * TODO: Choose reporters that fit your workflow
   */
  reporter: [
    ['html', {
      outputFolder: 'playwright-report',
      open: process.env.CI ? 'never' : 'on-failure'
    }],
    ['json', {
      outputFile: 'test-results/results.json'
    }],
    ['junit', {
      outputFile: 'test-results/junit.xml'
    }],
    // On CI, use github reporter
    process.env.CI ? ['github'] : ['list']
  ],

  // Alternative reporter options:
  // reporter: 'dot',                      // Minimal output
  // reporter: 'line',                     // One line per test
  // reporter: [['allure-playwright']],    // Allure integration

  // ============================================
  // GLOBAL SETUP/TEARDOWN
  // ============================================

  /**
   * Run global setup before all tests
   * TODO: Implement if you need global test data setup
   */
  // globalSetup: require.resolve('./global-setup'),

  /**
   * Run global teardown after all tests
   * TODO: Implement if you need global cleanup
   */
  // globalTeardown: require.resolve('./global-teardown'),

  // ============================================
  // SHARED SETTINGS FOR ALL PROJECTS
  // ============================================

  use: {
    /**
     * Base URL to use in actions like `await page.goto('/')`
     * TODO: Set your application URL or use environment variable
     */
    baseURL: process.env.BASE_URL || 'http://localhost:3000',

    /**
     * Maximum time each action (click, fill, etc.) can take
     * TODO: Adjust based on application responsiveness
     */
    actionTimeout: 10 * 1000, // 10 seconds

    /**
     * Maximum time for navigation
     * TODO: Adjust based on page load times
     */
    navigationTimeout: 30 * 1000, // 30 seconds

    /**
     * Collect trace when retrying the failed test
     * Options: 'off' | 'on' | 'retain-on-failure' | 'on-first-retry'
     * TODO: Choose trace strategy (impacts performance)
     */
    trace: process.env.CI ? 'retain-on-failure' : 'on-first-retry',

    /**
     * Capture screenshot after each test failure
     * Options: 'off' | 'on' | 'only-on-failure'
     * TODO: Balance between debugging help and storage cost
     */
    screenshot: 'only-on-failure',

    /**
     * Record video only when retrying a test for the first time
     * Options: 'off' | 'on' | 'retain-on-failure' | 'on-first-retry'
     * TODO: Video recording can be slow, use sparingly
     */
    video: process.env.CI ? 'retain-on-failure' : 'off',

    /**
     * Viewport size for tests
     * TODO: Set to match your target devices
     */
    viewport: { width: 1280, height: 720 },

    /**
     * Ignore HTTPS errors
     * TODO: Set to true only for non-production environments
     */
    ignoreHTTPSErrors: process.env.IGNORE_HTTPS_ERRORS === 'true',

    /**
     * Accept downloads during test
     * TODO: Enable if testing file downloads
     */
    // acceptDownloads: true,

    /**
     * Artifacts folder
     */
    outputDir: 'test-results/',

    /**
     * Slow down Playwright operations (in ms)
     * TODO: Use for debugging flaky tests
     */
    // launchOptions: {
    //   slowMo: 100
    // },

    /**
     * Extra HTTP headers
     * TODO: Add custom headers if needed
     */
    // extraHTTPHeaders: {
    //   'X-Custom-Header': 'value',
    // },
  },

  // ============================================
  // BROWSER PROJECTS
  // ============================================

  /**
   * Configure projects for major browsers
   * TODO: Choose which browsers to test against
   */
  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        // Chromium-specific settings
        // TODO: Add browser-specific configurations
      },
    },

    // Uncomment to enable Firefox testing
    // {
    //   name: 'firefox',
    //   use: {
    //     ...devices['Desktop Firefox'],
    //     // Firefox-specific settings
    //   },
    // },

    // Uncomment to enable WebKit testing
    // {
    //   name: 'webkit',
    //   use: {
    //     ...devices['Desktop Safari'],
    //     // WebKit-specific settings
    //   },
    // },

    // Mobile viewports
    // {
    //   name: 'Mobile Chrome',
    //   use: { ...devices['Pixel 5'] },
    // },
    // {
    //   name: 'Mobile Safari',
    //   use: { ...devices['iPhone 12'] },
    // },

    // Branded browsers
    // {
    //   name: 'Microsoft Edge',
    //   use: {
    //     ...devices['Desktop Edge'],
    //     channel: 'msedge'
    //   },
    // },
    // {
    //   name: 'Google Chrome',
    //   use: {
    //     ...devices['Desktop Chrome'],
    //     channel: 'chrome'
    //   },
    // },
  ],

  // ============================================
  // WEB SERVER CONFIGURATION
  // ============================================

  /**
   * Run your local dev server before starting the tests
   * TODO: Configure if tests need to start the application
   */
  // webServer: {
  //   command: 'npm run dev',
  //   url: 'http://localhost:3000',
  //   reuseExistingServer: !process.env.CI,
  //   timeout: 120 * 1000, // 2 minutes
  // },
});
```

---

## Environment Variable Templates

### .env.template (Check into git)

```bash
# ============================================
# APPLICATION URLS
# ============================================

# Base URL for the application under test
# TODO: Update with your application URL
BASE_URL=http://localhost:3000

# API URL if different from base URL
# TODO: Update if your API is on a different domain
API_URL=http://localhost:3001/api

# ============================================
# AUTHENTICATION
# ============================================

# Authentication token for bypassing login
# TODO: Teams implement their auth token mechanism
TEST_AUTH_TOKEN=placeholder_token_here

# Admin credentials (if needed)
# TODO: Use secure secret management in CI
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=placeholder_password

# ============================================
# TEST CONFIGURATION
# ============================================

# Test environment (local, staging, production)
TEST_ENV=local

# Timeouts (in milliseconds)
TEST_TIMEOUT=30000
ACTION_TIMEOUT=10000
NAVIGATION_TIMEOUT=30000

# Browser settings
HEADLESS=true
SLOW_MO=0

# ============================================
# BROWSER CONFIGURATION
# ============================================

# Ignore HTTPS errors (for dev/staging only)
IGNORE_HTTPS_ERRORS=false

# Browser to use (chromium, firefox, webkit)
BROWSER=chromium

# ============================================
# CI/CD SETTINGS
# ============================================

# CI environment flag
CI=false

# Number of parallel workers
WORKERS=4

# Retry strategy
RETRIES=0

# ============================================
# REPORTING
# ============================================

# Report output directory
REPORT_DIR=playwright-report

# Open report after test run (never, always, on-failure)
OPEN_REPORT=on-failure

# ============================================
# OPTIONAL INTEGRATIONS
# ============================================

# Database connection (if needed for test data)
# DATABASE_URL=postgresql://user:pass@localhost:5432/testdb

# Third-party API keys (if needed)
# EXTERNAL_API_KEY=placeholder_api_key

# Monitoring/analytics (if needed)
# SENTRY_DSN=
# ANALYTICS_KEY=
```

### .env.local (Add to .gitignore - actual values)

```bash
# DO NOT COMMIT THIS FILE
# Copy from .env.template and fill in actual values

BASE_URL=http://localhost:3000
API_URL=http://localhost:3001/api
TEST_AUTH_TOKEN=actual_token_here
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=actual_password_here
```

### .gitignore entries

```gitignore
# Environment files with secrets
.env
.env.local
.env.*.local

# Test artifacts
test-results/
playwright-report/
playwright/.cache/

# Videos and screenshots
**/test-results/**/videos/
**/test-results/**/screenshots/
**/test-results/**/traces/
```

---

## Browser Configuration Examples

### Desktop Browsers

```typescript
// Chromium (Chrome, Edge)
{
  name: 'chromium',
  use: {
    ...devices['Desktop Chrome'],
    viewport: { width: 1920, height: 1080 },
    launchOptions: {
      args: [
        '--disable-web-security',  // TODO: Use only for testing
        '--disable-features=IsolateOrigins,site-per-process',
      ],
    },
  },
}

// Firefox
{
  name: 'firefox',
  use: {
    ...devices['Desktop Firefox'],
    viewport: { width: 1920, height: 1080 },
    launchOptions: {
      firefoxUserPrefs: {
        // TODO: Add Firefox-specific preferences
        'media.navigator.streams.fake': true,
      },
    },
  },
}

// WebKit (Safari)
{
  name: 'webkit',
  use: {
    ...devices['Desktop Safari'],
    viewport: { width: 1920, height: 1080 },
  },
}
```

### Mobile Browsers

```typescript
// iPhone
{
  name: 'iPhone 12',
  use: {
    ...devices['iPhone 12'],
    // Override default settings
    locale: 'en-US',
    timezoneId: 'America/New_York',
    geolocation: { longitude: -73.935242, latitude: 40.730610 },
    permissions: ['geolocation'],
  },
}

// Android
{
  name: 'Pixel 5',
  use: {
    ...devices['Pixel 5'],
    hasTouch: true,
    isMobile: true,
  },
}

// Tablet
{
  name: 'iPad Pro',
  use: {
    ...devices['iPad Pro'],
  },
}
```

---

## Reporter Configuration Options

### Built-in Reporters

```typescript
// HTML Reporter (recommended for local development)
reporter: [
  ['html', {
    outputFolder: 'playwright-report',
    open: 'never', // 'always' | 'never' | 'on-failure'
  }]
]

// JSON Reporter (for programmatic analysis)
reporter: [
  ['json', {
    outputFile: 'results.json'
  }]
]

// JUnit Reporter (for CI integration)
reporter: [
  ['junit', {
    outputFile: 'junit.xml'
  }]
]

// List Reporter (default console output)
reporter: 'list'

// Dot Reporter (minimal output)
reporter: 'dot'

// Line Reporter (one line per test)
reporter: 'line'

// GitHub Actions Reporter
reporter: process.env.CI ? 'github' : 'list'
```

### Multiple Reporters

```typescript
reporter: [
  ['html', { outputFolder: 'playwright-report' }],
  ['json', { outputFile: 'test-results/results.json' }],
  ['junit', { outputFile: 'test-results/junit.xml' }],
  process.env.CI ? ['github'] : ['list'],
],
```

### Custom Reporter (Optional)

```typescript
// custom-reporter.ts
import { Reporter, TestCase, TestResult } from '@playwright/test/reporter';

class CustomReporter implements Reporter {
  onBegin(config, suite) {
    console.log(`Starting test run with ${suite.allTests().length} tests`);
  }

  onTestEnd(test: TestCase, result: TestResult) {
    console.log(`Finished ${test.title}: ${result.status}`);
  }

  onEnd(result) {
    console.log(`Finished test run: ${result.status}`);
  }
}

export default CustomReporter;

// In playwright.config.ts
reporter: [['./custom-reporter.ts']]
```

**TODO: Teams can create custom reporters for specific integrations**

---

## CI/CD Configuration Templates

### GitHub Actions

```yaml
# .github/workflows/playwright.yml
name: Playwright Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - uses: actions/setup-node@v3
      with:
        node-version: 18

    - name: Install dependencies
      run: npm ci

    - name: Install Playwright Browsers
      run: npx playwright install --with-deps

    - name: Run Playwright tests
      env:
        BASE_URL: ${{ secrets.BASE_URL }}
        TEST_AUTH_TOKEN: ${{ secrets.TEST_AUTH_TOKEN }}
        CI: true
      run: npx playwright test

    - uses: actions/upload-artifact@v3
      if: always()
      with:
        name: playwright-report
        path: playwright-report/
        retention-days: 30

    - uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results
        path: test-results/
        retention-days: 30
```

### GitLab CI

```yaml
# .gitlab-ci.yml
playwright-tests:
  image: mcr.microsoft.com/playwright:v1.40.0-focal

  stage: test

  variables:
    BASE_URL: ${BASE_URL}
    TEST_AUTH_TOKEN: ${TEST_AUTH_TOKEN}
    CI: "true"

  before_script:
    - npm ci

  script:
    - npx playwright test

  artifacts:
    when: always
    paths:
      - playwright-report/
      - test-results/
    expire_in: 30 days

  only:
    - main
    - develop
    - merge_requests
```

### Jenkins

```groovy
// Jenkinsfile
pipeline {
  agent {
    docker {
      image 'mcr.microsoft.com/playwright:v1.40.0-focal'
    }
  }

  environment {
    BASE_URL = credentials('base-url')
    TEST_AUTH_TOKEN = credentials('test-auth-token')
    CI = 'true'
  }

  stages {
    stage('Install Dependencies') {
      steps {
        sh 'npm ci'
      }
    }

    stage('Run Tests') {
      steps {
        sh 'npx playwright test'
      }
    }
  }

  post {
    always {
      publishHTML([
        reportDir: 'playwright-report',
        reportFiles: 'index.html',
        reportName: 'Playwright Test Report'
      ])

      junit 'test-results/junit.xml'
    }
  }
}
```

**TODO: Teams should adapt CI/CD templates to their platform**

---

## Plugin and Extension Options

### Visual Regression Testing

```bash
npm install -D @playwright/test-plugin-visual

# In playwright.config.ts
import { visualTest } from '@playwright/test-plugin-visual';

export default defineConfig({
  use: {
    screenshot: 'on',
  },

  // Add visual testing capabilities
  // TODO: Configure visual regression tolerance
  expect: {
    toMatchSnapshot: {
      threshold: 0.2,  // 20% difference tolerance
    },
  },
});
```

### API Testing Integration

```typescript
// In test file
import { test, expect } from '@playwright/test';

test('API and UI consistency', async ({ page, request }) => {
  // API call
  const response = await request.get('/api/users');
  const apiData = await response.json();

  // UI verification
  await page.goto('/users');
  const uiData = await page.locator('.user-list').textContent();

  expect(uiData).toContain(apiData[0].name);
});
```

### Database Integration

```typescript
// utils/db-helpers.ts
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export async function setupTestData() {
  // TODO: Implement test data setup
  await pool.query('INSERT INTO users ...');
}

export async function cleanupTestData() {
  // TODO: Implement cleanup
  await pool.query('DELETE FROM users WHERE test_user = true');
}
```

**TODO: Teams choose plugins based on testing requirements**

---

## Authentication Configuration Patterns

### Query Parameter Token

```typescript
// utils/auth-helper.ts
export async function navigateWithAuth(page: Page, path: string) {
  const token = process.env.TEST_AUTH_TOKEN;
  await page.goto(`${process.env.BASE_URL}${path}?auth_token=${token}`);
}
```

### Cookie-Based Auth

```typescript
export async function setAuthCookie(page: Page) {
  await page.context().addCookies([{
    name: 'auth_token',
    value: process.env.TEST_AUTH_TOKEN,
    domain: 'example.com',
    path: '/',
  }]);
}
```

### Header-Based Auth

```typescript
export default defineConfig({
  use: {
    extraHTTPHeaders: {
      'Authorization': `Bearer ${process.env.TEST_AUTH_TOKEN}`,
    },
  },
});
```

**TODO: Teams implement authentication matching their application**

---

## Teams Should Customize:

1. **Dependencies:**
   - Choose optional packages for your testing needs
   - Document why each dependency is included
   - Keep dependencies minimal and updated

2. **Configuration:**
   - Set appropriate timeouts for your application
   - Choose browsers based on target audience
   - Configure reporters for your workflow

3. **Environment Variables:**
   - Define all environment-specific values
   - Use secret management in CI/CD
   - Never commit secrets to git

4. **CI/CD Integration:**
   - Adapt templates to your CI/CD platform
   - Configure artifact retention
   - Set up proper secret management

5. **Browser Strategy:**
   - Test on browsers your users use
   - Balance coverage vs execution time
   - Consider mobile/tablet testing

6. **Reporting:**
   - Choose reporters for stakeholders
   - Integrate with existing tools
   - Archive reports appropriately

---

## After Customization:

The `/automate-testcases` command will:
1. Read your playwright.config.ts settings
2. Apply your browser configurations
3. Use your environment variables
4. Generate tests compatible with your setup
5. Follow your authentication patterns

All generated tests will work with your customized configuration.
