# DOM Exploration Workflow

This workflow details the process of exploring the application's DOM using Playwright MCP tools to capture interactive elements and their selectors for Page Object Model generation.

## Core Responsibilities

1. **Page Identification**: Parse test cases to identify pages to explore
2. **Live DOM Inspection**: Use Playwright MCP tools to inspect page structure
3. **Selector Capture**: Capture selectors following priority strategy
4. **Selector Verification**: Verify selector uniqueness and stability
5. **Element Grouping**: Organize elements by component/functionality
6. **Optional Documentation**: Generate page-structure.json for complex pages

---

## Exploration Strategy

### Hybrid Approach

The workflow uses a **hybrid approach**: direct DOM exploration feeds into code generation, with optional intermediate documentation for complex applications.

**Why this approach:**
- **Single Source of Truth**: LLM explores live DOM and generates code in one pass
- **AI Reasoning Clarity**: Direct DOM to code allows Claude to see exact selectors in context
- **Debugging Speed**: Quick correlation between test code and explored DOM
- **Faster Iteration**: No intermediate documentation to maintain
- **Real-time Feedback**: Selectors verified against live DOM during exploration

**When to generate page-structure.json:**
- Application has 10+ interactive elements per page
- Multiple nested dialogs, modals, or state-dependent layouts
- Team needs to reference page structure outside of code generation
- Debugging test failures requires understanding original DOM structure

---

## Step 1: Parse Test Cases for Pages

### Identify Pages to Explore

Read test-cases.md to determine which pages need exploration:

```
Input: [ticket-path]/test-cases.md

For each test case:
  - Extract page names from test steps
  - Extract URLs from navigation steps
  - Identify unique pages across all test cases

Output: List of pages to explore
```

**Example:**
```
✓ Parsing test-cases.md...
✓ Identified pages from test scenarios:
  - Login Page (/login)
  - Dashboard Page (/dashboard)
  - Profile Page (/profile)
✓ Exploration plan: 3 pages to explore
```

---

## Step 2: Use Playwright MCP Tools

### Initialize MCP Tools

Playwright MCP provides inspection tools for DOM exploration:

**Available MCP Tools:**
1. **Inspector**: View page structure and element properties
2. **Inspector-with-highlight**: Highlight elements during exploration
3. **DOM Query**: Query DOM for specific elements
4. **Element Properties**: Get detailed element information

**Initialization:**
```
✓ Initializing Playwright MCP tools
✓ Inspector available
✓ Inspector-with-highlight available
✓ DOM query tools ready
```

### MCP Tools Usage Pattern

**For each page:**
```typescript
// 1. Navigate to page
await page.goto(pageUrl);
await page.waitForLoadState('networkidle');

// 2. Use Inspector to view page structure
// MCP Inspector shows:
// - Full DOM tree
// - Element hierarchy
// - Element attributes
// - Computed styles

// 3. Use Inspector-with-highlight to identify interactive elements
// MCP highlights elements as you inspect:
// - Buttons
// - Input fields
// - Links
// - Dropdowns
// - Checkboxes/radios
// - Interactive containers

// 4. Query specific elements
const interactiveElements = await page.locator('button, input, select, a, [role="button"]');

// 5. Capture element properties
for (const element of interactiveElements) {
  // Get selector, type, label, attributes
}
```

---

## Step 3: Selector Priority Strategy

### Priority Order (Most Stable to Least Stable)

Follow this strict priority order when capturing selectors:

**1. data-testid (Priority: HIGHEST)**
```typescript
'[data-testid="submit-button"]'
```
- **Why:** Specifically for testing, won't change with styling
- **Stability:** Excellent (if developers maintain them)
- **Speed:** Fast selector performance
- **Use when:** data-testid attribute is present

**2. ID attribute (Priority: HIGH)**
```typescript
'#login-button'
```
- **Why:** Unique identifier, semantic
- **Stability:** Good (if ID is semantic, not auto-generated)
- **Speed:** Fastest selector performance
- **Use when:** ID is present and semantic (e.g., `#submit` not `#btn_12345`)

**3. ARIA roles and labels (Priority: MEDIUM-HIGH)**
```typescript
'button[aria-label="Submit"]'
'input[role="textbox"][aria-label="Username"]'
```
- **Why:** Accessibility-friendly, semantic meaning
- **Stability:** Good (accessibility attributes are maintained)
- **Use when:** ARIA attributes are present and descriptive

**4. CSS classes (Priority: MEDIUM - USE WITH CAUTION)**
```typescript
'.error-message'
'.login-form-submit'
```
- **Why:** Available on most elements
- **Stability:** Medium (depends on if class is semantic vs style-related)
- **Use when:** Class is semantic (e.g., `.error-message` not `.btn-primary`)
- **Avoid:** Style-related classes (`.text-red-500`, `.flex`, `.mt-4`)

**5. Tag + attribute combinations (Priority: LOW - LAST RESORT)**
```typescript
'button[type="submit"]'
'input[type="email"]'
'a[href="/forgot-password"]'
```
- **Why:** Always available but not unique
- **Stability:** Low (multiple elements may match)
- **Use when:** No better selector available
- **Enhance with:** `:has-text()` or position-based selectors for uniqueness

### Selector Enhancement for Uniqueness

**If selector is not unique, enhance it:**

```typescript
// Problem: Multiple submit buttons
'button[type="submit"]' // Matches 3 elements

// Solution 1: Add text selector
'button:has-text("Sign In")' // Unique

// Solution 2: Add parent context
'.login-form button[type="submit"]' // Unique within login form

// Solution 3: Use nth-child (least preferred)
'button[type="submit"]:nth-of-type(1)' // Fragile, avoid if possible
```

**Document reasoning for complex selectors:**
```typescript
// Complex selector: Multiple submit buttons on page, text distinguishes them
submitButton: 'button:has-text("Sign In")'
```

---

## Step 4: Capture Elements by Page

### For Each Page: Systematic Element Capture

**Navigate to page:**
```
✓ Navigating to: /login
✓ Waiting for page to load
✓ Scanning for interactive elements...
```

**Identify interactive element types:**
- Input fields (text, email, password, number, etc.)
- Buttons (submit, cancel, action buttons)
- Links (navigation, external links)
- Checkboxes and radio buttons
- Dropdowns (select elements)
- Textareas
- Interactive divs with click handlers
- Modal dialogs
- Navigation menus
- Forms

**Capture element information:**
```
For each interactive element:
  1. Best available selector (following priority)
  2. Element type (input, button, link, etc.)
  3. Element purpose (from label, placeholder, or context)
  4. Visibility state (always visible, conditional, hidden initially)
  5. Parent component (for grouping)
```

**Example capture:**
```
Found elements on Login Page:

  1. Username input
     - Selector: [data-testid="username-input"] (priority: data-testid)
     - Type: input[type="text"]
     - Label: "Username"
     - Purpose: User input for username/email
     - Unique: Yes

  2. Password input
     - Selector: #password (priority: id)
     - Type: input[type="password"]
     - Label: "Password"
     - Purpose: User input for password
     - Unique: Yes

  3. Remember me checkbox
     - Selector: [data-testid="remember-me"] (priority: data-testid)
     - Type: input[type="checkbox"]
     - Label: "Remember me"
     - Purpose: Toggle persistent session
     - Unique: Yes

  4. Submit button
     - Selector: button[type="submit"] (priority: tag+attribute)
     - Type: button
     - Text: "Sign In"
     - Purpose: Submit login form
     - Unique: No (using text: button:has-text("Sign In"))
     - Reasoning: Multiple submit buttons, text distinguishes them

  5. Forgot password link
     - Selector: a[href="/forgot-password"] (priority: tag+attribute)
     - Type: link
     - Text: "Forgot password?"
     - Purpose: Navigate to password reset
     - Unique: Yes

  6. Error message container
     - Selector: .error-message (priority: class)
     - Type: div
     - Purpose: Display validation errors
     - Initially hidden: Yes
     - Unique: Yes
     - Note: Semantic class, acceptable

✓ Login Page: 6 interactive elements captured
```

---

## Step 5: Verify Selectors Against Live DOM

### Uniqueness Verification

For each captured selector, verify it matches exactly one element (or intended multiple):

```
✓ Verifying all selectors are unique...
✓ Testing: [data-testid="username-input"] → Found 1 element ✓
✓ Testing: #password → Found 1 element ✓
✓ Testing: button:has-text("Sign In") → Found 1 element ✓
✓ All selectors verified unique
```

**If selector not unique:**
```
⚠️  Selector not unique: button[type="submit"]
    Matched: 3 elements

Attempting refinement:
  Option 1: Add text selector → button:has-text("Sign In")
    ✓ Testing refined selector → Found 1 element ✓
    ✓ Using: button:has-text("Sign In")

  Document reasoning:
    // Complex selector: Multiple submit buttons on page, text distinguishes them
    submitButton: 'button:has-text("Sign In")'
```

### Stability Verification

Test that selectors remain stable after page interactions:

```
✓ Testing selector stability...
✓ Querying selector after page load: Success
✓ Interacting with other elements
✓ Re-querying selector: Still found ✓
✓ Selector is stable
```

**Stability checks:**
- Selector works immediately after page load
- Selector works after waiting for network idle
- Selector works after interacting with other elements
- Selector works with Playwright's auto-waiting

---

## Step 6: Group Elements by Component

### Logical Grouping

Organize captured elements into logical groups for the SELECTORS object:

**Common groupings:**
- **form**: Form input elements (inputs, checkboxes, submit buttons)
- **messages**: Notification/validation messages
- **navigation**: Navigation links, menu items
- **actions**: Action buttons (not in forms)
- **content**: Content display elements
- **modals**: Modal dialog elements

**Example grouping for Login Page:**
```
✓ Grouping Login Page elements:

form (5 elements):
  - usernameInput
  - passwordInput
  - rememberMeCheckbox
  - submitButton
  - clearButton

messages (2 elements):
  - errorMessage
  - successMessage

links (2 elements):
  - forgotPassword
  - signUp
```

**This grouping becomes the SELECTORS object structure:**
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

---

## Step 7: Optional Page Structure Documentation

### Decide if JSON Documentation is Needed

**Complexity threshold:**
```
✓ Analyzing page complexity...
✓ Login Page: 6 interactive elements
✓ Threshold: 10 elements (from config)
✓ Complexity: Low - JSON documentation not needed

✓ Dashboard Page: 15 interactive elements
✓ Exceeds threshold - Generating page-structure.json
```

### Generate page-structure.json (if needed)

**Format:**
```json
{
  "page": "Dashboard",
  "url": "/dashboard",
  "explored_at": "2025-12-02T10:30:00Z",
  "element_count": 15,
  "selector_quality": {
    "data_testid": 10,
    "id": 3,
    "role": 0,
    "class": 2,
    "tag_attribute": 0
  },
  "elements": [
    {
      "name": "userNameDisplay",
      "selector": "[data-testid='user-name']",
      "type": "span",
      "purpose": "Display logged-in user's name",
      "selector_priority": "data-testid",
      "selector_reasoning": "Preferred data-testid available",
      "group": "header"
    },
    {
      "name": "logoutButton",
      "selector": "[data-testid='logout']",
      "type": "button",
      "purpose": "Log out current user",
      "selector_priority": "data-testid",
      "selector_reasoning": "Preferred data-testid available",
      "group": "header"
    },
    {
      "name": "searchInput",
      "selector": "#search",
      "type": "input[type='search']",
      "purpose": "Search dashboard content",
      "selector_priority": "id",
      "selector_reasoning": "Semantic ID available",
      "group": "navigation"
    }
  ],
  "component_groups": {
    "header": ["userNameDisplay", "logoutButton", "notificationIcon"],
    "navigation": ["searchInput", "homeLink", "profileLink", "settingsLink"],
    "content": ["welcomeMessage", "statsWidget", "recentActivity"]
  },
  "notes": "Complex page with multiple sections and interactions"
}
```

**Purpose of page-structure.json:**
- Reference documentation for complex pages
- Debugging aid when selectors need updating
- Onboarding documentation for new team members
- Audit trail of DOM structure at time of automation

---

## Step 8: Exploration Summary

### Generate Exploration Report

**Summary format:**
```
════════════════════════════════════════════════════════════
  DOM Exploration Summary
════════════════════════════════════════════════════════════

Pages explored: 3
Total elements captured: 29

Login Page:
  ├── 6 interactive elements
  ├── Selector quality: 4 data-testid, 1 id, 1 tag+text
  ├── Groups: form (4), messages (2), links (2)
  └── All selectors verified ✓

Dashboard Page:
  ├── 15 interactive elements
  ├── Selector quality: 10 data-testid, 3 id, 2 class
  ├── Groups: header (3), navigation (4), content (8)
  ├── All selectors verified ✓
  └── page-structure.json generated

Profile Page:
  ├── 8 interactive elements
  ├── Selector quality: 6 data-testid, 2 role
  ├── Groups: form (5), actions (3)
  └── All selectors verified ✓

Selector Priority Distribution:
  - data-testid: 20 (69%) ✓ Excellent
  - id: 4 (14%) ✓ Good
  - role: 2 (7%) ✓ Good
  - class: 2 (7%) ⚠️ Acceptable
  - tag+text: 1 (3%) ⚠️ Acceptable

Overall Quality: Excellent (83% stable selectors)

Threshold met: Yes (target: 80%)
Ready for POM generation: Yes

════════════════════════════════════════════════════════════
```

---

## Error Handling

### Common Issues and Solutions

**1. Page Not Loading**
```
❌ Failed to load page: /dashboard

Possible issues:
  - Page requires additional navigation steps
  - Page URL incorrect in test cases
  - Page requires specific user permissions
  - Network timeout

Action:
  - Skip page and continue with others
  - Document skipped page in summary
  - User can manually verify page later
```

**2. Element Not Found**
```
⚠️  Expected element not found: submit button on /login

This may indicate:
  - Element has conditional visibility
  - Selector priority not available
  - Page structure changed
  - Element is in a different state

Action:
  - Use fallback selector strategy
  - Document reasoning in comments
  - Mark for manual verification
```

**3. Selector Not Unique**
```
⚠️  Selector not unique: button.primary (matched 5 elements)

Attempting refinement:
  ✓ Option 1: Add text → button.primary:has-text("Submit") (unique)
  ✓ Using refined selector
  ✓ Documented reasoning in code
```

**4. Browser Crash**
```
❌ Browser session crashed during exploration

Attempting recovery:
  ✓ Restarting browser
  ✓ Re-authenticating
  ✓ Resuming exploration from: Profile Page
  ✓ Recovery successful
```

---

## Quality Metrics

### Selector Quality Thresholds

**Target distribution:**
- data-testid + id: 60%+ (excellent)
- role: 10%+ (good)
- class (semantic): <20% (acceptable)
- tag+attribute: <10% (last resort)

**Overall quality rating:**
- Excellent: 80%+ stable selectors (data-testid, id, role)
- Good: 60-79% stable selectors
- Acceptable: 50-59% stable selectors
- Poor: <50% stable selectors (requires attention)

**If quality is poor:**
```
⚠️  Selector quality below threshold: 45% stable selectors

Recommendations:
  1. Work with developers to add data-testid attributes
  2. Use ARIA labels for better selectors
  3. Consider semantic class names
  4. Document fragile selectors for future maintenance

Proceed anyway? [Y/n]
```

---

## Integration with POM Generation

### Output Data Structure

The exploration workflow stores captured data in memory for POM generation:

```typescript
interface ExplorationResult {
  pages: Array<{
    name: string;
    url: string;
    elements: Array<{
      name: string;
      selector: string;
      type: string;
      purpose: string;
      priority: string;
      group: string;
      reasoning?: string;
    }>;
    groups: Record<string, string[]>;
  }>;
  quality: {
    totalElements: number;
    selectorDistribution: Record<string, number>;
    qualityRating: string;
  };
}
```

**This data is passed directly to POM Generation workflow:**
- No intermediate file needed (unless page-structure.json generated)
- Data remains in context for immediate use
- Ensures synchronization between exploration and generation

---

## Standards Compliance

**Referenced Standards:**
- `@qa-agent-os/standards/automation/pom-patterns.md` - Selector priority strategy
- `@qa-agent-os/standards/frontend/components.md` - Component interaction patterns
- `@qa-agent-os/standards/global/error-handling.md` - Error handling patterns

**Playwright Resources:**
- Locators: https://playwright.dev/docs/locators
- Best Practices: https://playwright.dev/docs/best-practices

---

*This workflow ensures comprehensive DOM exploration with high-quality, stable selectors that will generate maintainable Page Object Model classes.*
