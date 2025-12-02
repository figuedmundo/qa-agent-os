# Authentication Token Configuration Template

**Purpose:** This template guides teams in configuring authentication for Playwright test automation.

**Instructions:** Copy this file to your project's `qa-agent-os/config/automation/auth-token-config.md` and fill in your project-specific details.

---

## Overview

This configuration defines how the `/automate-testcases` command will handle authentication when exploring your application and generating automated tests.

---

## Authentication Method

**Select your authentication approach** (choose one and fill in the corresponding section):

- [ ] **Option 1: JWT Token in Query Parameter** (recommended for SPAs)
- [ ] **Option 2: Session Cookie**
- [ ] **Option 3: API Key Header**
- [ ] **Option 4: OAuth/SSO Flow**
- [ ] **Option 5: Custom Authentication**

---

## Option 1: JWT Token in Query Parameter

### Configuration

```yaml
authentication:
  method: "query_parameter"
  parameter_name: "auth_token"  # TODO: Update with your parameter name
  token_type: "JWT"
```

### Token Generation

**How to generate auth token for testing:**

```typescript
// TODO: Provide your token generation code/endpoint

// Example:
// POST /api/auth/test-token
// Body: { userId: "test-user-id", expiresIn: "24h" }
// Returns: { token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." }
```

**Token generation helper location:**
```
TODO: Specify path to token generation utility
Example: src/utils/test-auth.ts
```

### Token Structure

```json
{
  "token": "TODO: Provide example token",
  "payload": {
    "userId": "TODO: user ID",
    "email": "TODO: user email",
    "role": "TODO: user role",
    "exp": "TODO: expiration timestamp"
  }
}
```

### Usage Pattern

```typescript
// TODO: Confirm this pattern or provide your specific implementation
const authToken = await generateTestToken();
await page.goto(`${baseUrl}?auth_token=${authToken}`);
```

### Token Validation

**How the application validates the token:**
```
TODO: Describe validation process
Example:
- Token verified with JWT secret
- User session created from token payload
- Token expiration checked
```

### Token Refresh/Expiration

**Token lifetime:** TODO: Specify (e.g., "24 hours", "1 hour")

**Refresh mechanism:**
```
TODO: Describe how to refresh tokens if needed
Example: Call /api/auth/refresh with current token
```

**Handling expiration in tests:**
```
TODO: Specify strategy
Example:
- Generate fresh token before each test
- Use beforeEach hook to refresh token
- Set long expiration for test tokens (24h)
```

---

## Option 2: Session Cookie

### Configuration

```yaml
authentication:
  method: "session_cookie"
  cookie_name: "TODO: Your session cookie name"  # e.g., "connect.sid"
  domain: "TODO: Cookie domain"  # e.g., ".example.com"
```

### Session Creation

**How to create test session:**

```typescript
// TODO: Provide session creation code

// Example:
// 1. POST /api/auth/login with credentials
// 2. Extract session cookie from response
// 3. Inject cookie into browser context
```

### Cookie Structure

```javascript
{
  name: "TODO: cookie name",
  value: "TODO: example cookie value",
  domain: "TODO: cookie domain",
  path: "/",
  httpOnly: true,
  secure: true,
  sameSite: "Lax"
}
```

### Usage Pattern

```typescript
// TODO: Confirm or update this pattern
const session = await createTestSession(user);
await context.addCookies([{
  name: 'session_id',
  value: session.sessionId,
  domain: '.example.com',
  path: '/'
}]);
await page.goto(baseUrl);
```

---

## Option 3: API Key Header

### Configuration

```yaml
authentication:
  method: "api_key"
  header_name: "TODO: Header name"  # e.g., "X-API-Key" or "Authorization"
  header_format: "TODO: Format"  # e.g., "Bearer {key}" or just "{key}"
```

### API Key Management

**How to generate API key:**
```
TODO: Describe API key generation
Example:
- Admin panel: Settings > API Keys > Generate
- API endpoint: POST /api/keys with admin credentials
- Pre-generated keys stored in environment variables
```

**API key structure:**
```
TODO: Provide example
Example: sk_test_4eC39HqLyjWDarjtT1zdp7dc
```

### Usage Pattern

```typescript
// TODO: Provide your implementation
const apiKey = process.env.TEST_API_KEY;
await page.setExtraHTTPHeaders({
  'X-API-Key': apiKey
});
await page.goto(baseUrl);
```

---

## Option 4: OAuth/SSO Flow

### Configuration

```yaml
authentication:
  method: "oauth"
  provider: "TODO: OAuth provider"  # e.g., "google", "github", "okta"
  bypass_enabled: true  # Use test bypass instead of actual OAuth flow
```

### Test Bypass Mechanism

**Instead of full OAuth flow, use test bypass:**

```typescript
// TODO: Describe your OAuth bypass mechanism
// Example:
// - Special test endpoint: GET /auth/test-login?test_token=xyz
// - Backdoor URL: /auth/bypass?user_id=test-user
// - Special OAuth callback with test parameters
```

**Bypass configuration:**
```
TODO: Provide bypass details
Example:
- Endpoint: POST /api/auth/test-callback
- Parameters: { userId: "test-user", provider: "google" }
- Returns session/token for authenticated state
```

---

## Option 5: Custom Authentication

### Configuration

```yaml
authentication:
  method: "custom"
  description: "TODO: Brief description of your custom auth"
```

### Custom Implementation

**Describe your authentication flow:**

```
TODO: Provide step-by-step authentication process

Example:
1. Navigate to /login
2. Submit credentials via API
3. Receive custom authentication header
4. Inject header into all subsequent requests
5. Navigate to protected pages
```

**Code implementation:**

```typescript
// TODO: Provide your custom authentication code

export async function authenticateCustom(page: Page): Promise<void> {
  // Step 1: Get auth credentials
  const credentials = {
    // TODO: Your credentials structure
  };

  // Step 2: Perform authentication
  // TODO: Your authentication logic

  // Step 3: Inject auth state
  // TODO: Set cookies/headers/localStorage

  // Step 4: Navigate to application
  await page.goto(process.env.BASE_URL);
}
```

---

## Environment Variables

**Required environment variables for authentication:**

```bash
# TODO: List all required environment variables

# Examples:
TEST_AUTH_TOKEN=         # Pre-generated auth token (if using query param method)
TEST_API_KEY=            # API key for header-based auth
TEST_USERNAME=           # Username for login-based auth
TEST_PASSWORD=           # Password for login-based auth
BASE_URL=                # Application base URL
AUTH_ENDPOINT=           # Authentication endpoint URL

# Optional:
TOKEN_REFRESH_ENDPOINT=  # Token refresh endpoint
SESSION_DURATION=        # Session duration in milliseconds
```

**Environment file example (`.env.local`):**

```bash
# TODO: Provide example values (use dummy/placeholder data)

# Example:
# TEST_AUTH_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test.token
# BASE_URL=http://localhost:3000
# AUTH_ENDPOINT=http://localhost:3000/api/auth
```

---

## Authentication Helper Utilities

### Location

```
TODO: Specify where auth helpers are located in your project

Example:
- src/test-utils/auth-helper.ts
- tests/utils/authentication.ts
- lib/test-auth.js
```

### Key Functions

```typescript
// TODO: List your authentication utility functions

// Examples:
export async function generateTestToken(): Promise<string> {
  // TODO: Implementation
}

export async function authenticateUser(page: Page, user: UserData): Promise<void> {
  // TODO: Implementation
}

export async function refreshAuthToken(currentToken: string): Promise<string> {
  // TODO: Implementation
}

export async function clearAuthentication(page: Page): Promise<void> {
  // TODO: Implementation
}
```

---

## Testing Strategy

### Pre-Authentication for Tests

**Approach:** (Select one)

- [ ] **Generate fresh auth token before each test suite**
- [ ] **Generate fresh auth token before each test**
- [ ] **Use long-lived token for entire test run**
- [ ] **Create session once, reuse across tests**

**Implementation:**

```typescript
// TODO: Provide your implementation

// Example: beforeEach hook
test.beforeEach(async ({ page }) => {
  const authToken = await generateTestToken();
  await page.goto(`${process.env.BASE_URL}?auth_token=${authToken}`);
});
```

### Handling Auth Failures

**What to do when authentication fails during test execution:**

```typescript
// TODO: Define error handling strategy

// Example:
// - Retry authentication once
// - Fail test immediately with clear error
// - Log authentication response for debugging
// - Take screenshot of auth failure
```

---

## Security Considerations

### Token/Secret Storage

- [ ] **Auth tokens stored in environment variables**
- [ ] **Tokens never committed to git**
- [ ] **Secrets managed via CI/CD platform**
- [ ] **Local `.env` files in `.gitignore`**

### Token Permissions

**Test tokens should have:**

```
TODO: Specify test token permissions

Example:
- Read-only access to test data
- Limited to test environment
- Cannot modify production data
- Expires after 24 hours
```

### Cleanup

**After test execution:**

```
TODO: Specify cleanup process

Example:
- Revoke test tokens
- Clear test sessions
- Delete test users created during auth
```

---

## Troubleshooting

### Common Issues

**1. Authentication fails in automated tests**

```
TODO: Provide debugging steps

Example:
- Verify auth token is valid and not expired
- Check BASE_URL matches application URL
- Confirm auth parameter name is correct
- Check browser console for auth errors
```

**2. Token expires during test execution**

```
TODO: Provide solution

Example:
- Increase token expiration for test tokens
- Implement token refresh in beforeEach hook
- Use long-lived tokens for test environment
```

**3. CORS issues with authentication endpoint**

```
TODO: Provide solution

Example:
- Configure CORS to allow test domain
- Use same domain for auth and application
- Add auth bypass endpoint that doesn't require CORS
```

---

## Validation

### Testing Your Configuration

**Verify authentication works:**

```typescript
// TODO: Provide validation script

// Example:
import { test } from '@playwright/test';

test('Verify authentication configuration', async ({ page }) => {
  // Test auth token generation
  const token = await generateTestToken();
  console.log('Generated token:', token ? 'Success' : 'Failed');

  // Test page navigation with auth
  await page.goto(`${process.env.BASE_URL}?auth_token=${token}`);

  // Verify authenticated state
  const isAuthenticated = await page.locator('[data-testid="user-menu"]').isVisible();
  console.log('Authentication successful:', isAuthenticated);
});
```

---

## References

**Related Documentation:**

```
TODO: Link to your project's authentication documentation

Examples:
- Authentication API docs: docs/api/authentication.md
- Security guidelines: docs/security.md
- Environment setup guide: docs/setup.md
```

---

## Completion Checklist

Before using this configuration, verify:

- [ ] Authentication method selected and configured
- [ ] Token/session generation process documented
- [ ] Environment variables defined
- [ ] Helper utilities located and documented
- [ ] Testing strategy defined
- [ ] Security considerations addressed
- [ ] Troubleshooting steps provided
- [ ] Configuration tested and validated

---

**Last Updated:** TODO: Add date when you complete this configuration
**Team Contact:** TODO: Add team/person responsible for auth configuration
