# Phase 1: Browser Setup & DOM Exploration

## Purpose

Initialize Playwright browser session with authentication, navigate to the application, and explore the DOM to capture all interactive elements and their selectors for POM generation.

## Prerequisites

Phase 0 has validated:
- ✓ Test cases exist and are readable
- ✓ Configuration discovered (team config or defaults)
- ✓ Environment variables set (BASE_URL, TEST_AUTH_TOKEN)
- ✓ Playwright installed and ready

## Step 1: Initialize Playwright Session

### Load Configuration

```
✓ Loading automation configuration...
✓ Browser: chromium (headless: true)
✓ Viewport: 1280x720
✓ Timeout: 30000ms
```

I'll use the configuration discovered in Phase 0 to set up the browser with appropriate settings.

### Start Browser

```
✓ Launching Playwright browser...
✓ Creating browser context with viewport settings
✓ Opening new page
```

I'll initialize Playwright with:
- Browser type from config (chromium, firefox, or webkit)
- Headless mode setting
- Viewport dimensions
- Timeout configurations

## Step 2: Authentication Setup

### Reference Authentication Configuration

I'll read the authentication method from your configuration or use the default query parameter approach.

**From config or defaults:**
```yaml
authentication:
  method: "query-param"
  token_env_var: "TEST_AUTH_TOKEN"
  token_param_name: "auth_token"
```

### Inject Authentication Token

```
✓ Authentication method: query-param
✓ Token parameter: auth_token
✓ Retrieving token from: TEST_AUTH_TOKEN
✓ Preparing authenticated URL
```

I'll construct the URL with authentication:
```
Base URL: http://localhost:3000
Auth token: •••••••••••••• (from TEST_AUTH_TOKEN)
Final URL: http://localhost:3000?auth_token=••••••••••••••
```

**Alternative authentication methods (if configured):**

- **Cookie-based:**
  ```
  ✓ Setting authentication cookie: session_token
  ✓ Cookie value: •••••••••••••• (from TEST_AUTH_TOKEN)
  ✓ Navigating to: http://localhost:3000
  ```

- **Header-based:**
  ```
  ✓ Setting authentication header: Authorization
  ✓ Header value: Bearer •••••••••••••• (from TEST_AUTH_TOKEN)
  ✓ Navigating to: http://localhost:3000
  ```

- **Custom script:**
  ```
  ✓ Loading custom auth script: ./utils/custom-auth.ts
  ✓ Executing custom authentication logic
  ✓ Authentication completed
  ```

### Navigate to Application

```
✓ Navigating to authenticated application...
✓ Waiting for page load...
✓ Page loaded successfully
```

I'll navigate to the application with authentication and wait for the page to be fully loaded.

### Verify Authentication

```
✓ Verifying authentication status...
✓ Checking for auth indicators (logged-in state)
✓ Authentication successful
```

**If authentication fails:**
```
❌ Authentication verification failed

Possible issues:
  - Token is expired or invalid
  - Authentication method misconfigured
  - Application requires different auth mechanism
  - Network/connectivity issues

Check:
  1. TEST_AUTH_TOKEN is valid and current
  2. Authentication method in config matches application
  3. Application is accessible at BASE_URL

Fix the issue and run the command again.
```

## Step 3: DOM Exploration Strategy

### Hybrid Exploration Approach

I'll use a hybrid approach: direct DOM exploration to code generation, with optional documentation for complex applications.

**Exploration goals:**
1. Identify all interactive elements (buttons, inputs, links, etc.)
2. Capture best available selector for each element
3. Group elements by page/component
4. Verify selector uniqueness and stability
5. Document complex selector reasoning

### Use Playwright MCP Tools

```
✓ Initializing Playwright MCP tools
✓ Inspector available
✓ Inspector-with-highlight available
```

I'll use Playwright MCP tools to:
- Inspect DOM structure
- Highlight elements during exploration
- Capture element properties
- Test selector stability

### Parse Test Cases for Pages

```
✓ Parsing test-cases.md...
✓ Identified pages from test scenarios:
  - Login Page
  - Dashboard Page
  - Profile Page
✓ Exploration plan: 3 pages to explore
```

I'll analyze test cases to determine which pages and components need exploration.

## Step 4: Page-by-Page Exploration

### For Each Page in Test Scenarios

I'll navigate to each page mentioned in test cases and explore its DOM:

#### Example: Login Page

```
✓ Navigating to: /login
✓ Waiting for page to load
✓ Scanning for interactive elements...

Found elements:
  1. Username input
     - Selector: [data-testid="username-input"] (priority: data-testid)
     - Type: input[type="text"]
     - Label: "Username"
     - Unique: Yes

  2. Password input
     - Selector: #password (priority: id)
     - Type: input[type="password"]
     - Label: "Password"
     - Unique: Yes

  3. Remember me checkbox
     - Selector: [data-testid="remember-me"] (priority: data-testid)
     - Type: input[type="checkbox"]
     - Label: "Remember me"
     - Unique: Yes

  4. Submit button
     - Selector: button[type="submit"] (priority: tag+attribute)
     - Type: button
     - Text: "Sign In"
     - Unique: No (using text: button:has-text("Sign In"))

  5. Forgot password link
     - Selector: a[href="/forgot-password"] (priority: tag+attribute)
     - Type: link
     - Text: "Forgot password?"
     - Unique: Yes

  6. Error message container
     - Selector: .error-message (priority: class)
     - Type: div
     - Initially hidden: Yes
     - Unique: Yes

✓ Login Page: 6 interactive elements captured
```

### Apply Selector Priority Strategy

For each element, I'll choose selectors following this priority:

**1. data-testid (most stable)**
```typescript
'[data-testid="username-input"]'
```
- Preferred selector if available
- Specifically for testing, won't change with styling

**2. ID attribute**
```typescript
'#password'
```
- Unique identifier
- Fast and reliable if ID is semantic

**3. ARIA roles and labels**
```typescript
'button[aria-label="Submit"]'
```
- Accessibility-friendly
- Semantic meaning

**4. CSS classes (semantic only)**
```typescript
'.error-message'
```
- Only if class is semantic, not style-related
- Useful for message/notification elements

**5. Tag + attribute (last resort)**
```typescript
'button[type="submit"]'
```
- Always available but least stable
- Combined with :has-text() for uniqueness when needed

### Verify Selector Uniqueness

```
✓ Verifying all selectors are unique...
✓ Testing selector stability (wait and requery)...
✓ All selectors verified
```

I'll test each selector to ensure:
- It matches exactly one element (or intended multiple)
- It remains stable after page interactions
- It works reliably with Playwright's auto-waiting

**If selector not unique:**
```
⚠️  Selector not unique: button[type="submit"]
✓ Refining with text selector: button:has-text("Sign In")
✓ Verified unique after refinement
```

I'll document why complex selectors were chosen:
```typescript
// Complex selector: Multiple submit buttons on page, text distinguishes them
submitButton: 'button:has-text("Sign In")'
```

## Step 5: Group Elements by Component

### Organize Elements Logically

```
✓ Grouping Login Page elements:
  - Form elements: username, password, rememberMe, submit
  - Messages: errorMessage, successMessage
  - Links: forgotPassword, signUp
```

This grouping will become the SELECTORS object structure in the POM:
```typescript
private readonly SELECTORS = {
  form: {
    usernameInput: '[data-testid="username-input"]',
    passwordInput: '#password',
    rememberMeCheckbox: '[data-testid="remember-me"]',
    submitButton: 'button:has-text("Sign In")'
  },
  messages: {
    errorMessage: '.error-message',
    successMessage: '.success-message'
  },
  links: {
    forgotPassword: 'a[href="/forgot-password"]',
    signUp: '[data-testid="signup-link"]'
  }
};
```

## Step 6: Optional Page Structure Documentation

### Decide if JSON Documentation Needed

```
✓ Analyzing page complexity...
✓ Login Page: 6 interactive elements
✓ Threshold: 10 elements (from config)
✓ Complexity: Low - JSON documentation not needed
```

**For complex pages (10+ elements):**
```
✓ Dashboard Page: 15 interactive elements
✓ Exceeds threshold - Generating page-structure.json
```

### Generate page-structure.json (if needed)

```json
{
  "page": "Dashboard",
  "url": "/dashboard",
  "explored_at": "2025-12-02T10:30:00Z",
  "elements": [
    {
      "name": "userNameDisplay",
      "selector": "[data-testid='user-name']",
      "type": "span",
      "purpose": "Display logged-in user's name",
      "selector_priority": "data-testid",
      "selector_reasoning": "Preferred data-testid available"
    },
    {
      "name": "logoutButton",
      "selector": "[data-testid='logout']",
      "type": "button",
      "purpose": "Log out current user",
      "selector_priority": "data-testid",
      "selector_reasoning": "Preferred data-testid available"
    }
    // ... more elements
  ],
  "components": {
    "header": ["userNameDisplay", "logoutButton", "notificationIcon"],
    "navigation": ["homeLink", "profileLink", "settingsLink"],
    "content": ["welcomeMessage", "statsWidget", "recentActivity"]
  }
}
```

This JSON serves as:
- Reference documentation for complex pages
- Debugging aid when selectors need updating
- Onboarding documentation for new team members

## Step 7: Exploration Summary

```
════════════════════════════════════════════════════════════
  DOM Exploration Summary
════════════════════════════════════════════════════════════

Pages explored: 3
Total elements captured: 18

Login Page:
  ├── 6 interactive elements
  ├── Selector quality: 4 data-testid, 1 id, 1 tag+text
  └── All selectors verified

Dashboard Page:
  ├── 15 interactive elements
  ├── Selector quality: 10 data-testid, 3 id, 2 class
  ├── All selectors verified
  └── page-structure.json generated

Profile Page:
  ├── 8 interactive elements
  ├── Selector quality: 6 data-testid, 2 role
  └── All selectors verified

Selector Priority Distribution:
  - data-testid: 20 (67%) ✓ Excellent
  - id: 4 (13%) ✓ Good
  - role: 2 (7%) ✓ Good
  - class: 2 (7%) ⚠️ Acceptable
  - tag+text: 1 (3%) ⚠️ Acceptable

Overall Quality: Excellent (80% stable selectors)

════════════════════════════════════════════════════════════
```

## Step 8: Save Exploration Data

```
✓ Saving exploration data for POM generation...
✓ Element map stored in memory
✓ Selector groupings prepared
✓ Optional page-structure.json saved to automated-tests/
```

I'll store all captured data for use in Phase 2 (POM Generation).

## Error Handling

### Page Not Loading

```
❌ Failed to load page: /dashboard

Possible issues:
  - Page requires additional navigation steps
  - Page URL incorrect in test cases
  - Page requires specific user permissions
  - Network timeout

I'll continue with other pages. You can manually verify this page later.
```

### Element Not Found

```
⚠️  Expected element not found: submit button on /login

This may indicate:
  - Element has conditional visibility
  - Selector priority not available
  - Page structure changed

I'll use fallback selector strategy for this element.
```

### Browser Crash

```
❌ Browser session crashed during exploration

Attempting recovery:
  ✓ Restarting browser
  ✓ Re-authenticating
  ✓ Resuming exploration from last successful page
```

## Next Phase

With DOM exploration complete, I'll proceed to Phase 2: POM Generation.

**Captured data ready for:**
- BasePage class generation with utilities
- Individual page object classes with verified selectors
- Grouped SELECTORS objects for each page
- Action and getter methods based on element types
