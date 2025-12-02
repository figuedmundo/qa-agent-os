# Test Data Management Standards

This standard defines how to create, organize, and manage test data for Playwright automated tests in QA Agent OS.

---

## Core Principles

1. **No Hardcoded Values**: All test data stored in separate files
2. **Data Isolation**: Each test uses independent data to prevent interference
3. **Environment-Specific**: Test data adapts to different environments
4. **Reusability**: Common data sets shared across tests
5. **Security**: Sensitive data properly managed and never committed

---

## Test Data Organization

### Directory Structure

```
automated-tests/
├── fixtures/
│   ├── test-data/
│   │   ├── users.ts              # User test data
│   │   ├── products.ts           # Product test data
│   │   ├── orders.ts             # Order test data
│   │   └── common.ts             # Common/shared test data
│   ├── auth-helpers.ts           # Authentication utilities
│   └── custom-fixtures.ts        # Custom Playwright fixtures
├── pom/
│   └── [page objects]
└── tests/
    └── [test files]
```

---

## Test Data Files

### Format and Structure

```typescript
// fixtures/test-data/users.ts

export interface UserData {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  role?: string;
}

// Valid user data
export const validUser: UserData = {
  email: 'test.user@example.com',
  password: 'SecurePass123!',
  firstName: 'Test',
  lastName: 'User',
  role: 'customer'
};

export const adminUser: UserData = {
  email: 'admin.user@example.com',
  password: 'AdminPass456!',
  firstName: 'Admin',
  lastName: 'User',
  role: 'admin'
};

// Invalid user data (for negative tests)
export const invalidUserData = {
  emptyEmail: {
    email: '',
    password: 'ValidPass123!',
    firstName: 'Test',
    lastName: 'User'
  },
  invalidEmail: {
    email: 'not-an-email',
    password: 'ValidPass123!',
    firstName: 'Test',
    lastName: 'User'
  },
  shortPassword: {
    email: 'test@example.com',
    password: '123',
    firstName: 'Test',
    lastName: 'User'
  }
};

// Data generators for unique values
export function generateUniqueUser(): UserData {
  const timestamp = Date.now();
  return {
    email: `test.${timestamp}@example.com`,
    password: 'TestPass123!',
    firstName: 'Test',
    lastName: `User${timestamp}`,
    role: 'customer'
  };
}
```

### Usage in Tests

```typescript
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pom/LoginPage';
import { validUser, invalidUserData } from '../fixtures/test-data/users';

test('TC-001: Login with valid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);

  await loginPage.navigate();
  await loginPage.login(validUser.email, validUser.password);

  await expect(page).toHaveURL(/dashboard/);
});

test('TC-002: Login fails with empty email', async ({ page }) => {
  const loginPage = new LoginPage(page);

  await loginPage.navigate();
  await loginPage.login(invalidUserData.emptyEmail.email, invalidUserData.emptyEmail.password);

  await expect(loginPage.errorMessage).toBeVisible();
});
```

---

## Data Isolation Strategies

### Strategy 1: Unique Data Per Test

Generate unique data for each test run:

```typescript
// fixtures/test-data/users.ts
export function generateUser(overrides?: Partial<UserData>): UserData {
  const timestamp = Date.now();
  const randomId = Math.random().toString(36).substring(7);

  return {
    email: `user.${timestamp}.${randomId}@example.com`,
    password: 'DefaultPass123!',
    firstName: `First${randomId}`,
    lastName: `Last${randomId}`,
    ...overrides // Allow overriding specific fields
  };
}

// Usage:
test('TC-001: User registration', async ({ page }) => {
  const newUser = generateUser({
    firstName: 'John',
    lastName: 'Doe'
  });

  await registrationPage.register(newUser);
});
```

### Strategy 2: Test-Scoped Data

Use `test.beforeEach` to set up fresh data:

```typescript
test.describe('Shopping Cart Tests', () => {
  let testProduct: ProductData;

  test.beforeEach(async ({ page }) => {
    // Generate unique product for this test
    testProduct = generateProduct();

    // Set up test data via API or UI
    await setupProduct(page, testProduct);
  });

  test('TC-001: Add product to cart', async ({ page }) => {
    // Use testProduct which is unique to this test run
    await productPage.addToCart(testProduct.id);
  });

  test.afterEach(async ({ page }) => {
    // Clean up test data
    await cleanupProduct(testProduct.id);
  });
});
```

### Strategy 3: Fixture-Based Isolation

Use Playwright custom fixtures:

```typescript
// fixtures/custom-fixtures.ts
import { test as base } from '@playwright/test';
import { generateUser, UserData } from './test-data/users';

type CustomFixtures = {
  uniqueUser: UserData;
  authenticatedUser: UserData;
};

export const test = base.extend<CustomFixtures>({
  // Provides a unique user for each test
  uniqueUser: async ({}, use) => {
    const user = generateUser();
    await use(user);
    // Cleanup if needed
  },

  // Provides an authenticated user session
  authenticatedUser: async ({ page }, use) => {
    const user = generateUser();

    // Register and login user
    await registerUser(page, user);
    await loginUser(page, user);

    await use(user);

    // Cleanup
    await deleteUser(user.email);
  }
});

// Usage:
test('TC-001: User can view profile', async ({ page, authenticatedUser }) => {
  // Test starts with authenticated user
  await profilePage.navigate();
  await expect(profilePage.userName).toHaveText(`${authenticatedUser.firstName} ${authenticatedUser.lastName}`);
});
```

---

## Environment-Specific Data

### Configuration Files

Create environment-specific configuration:

```typescript
// fixtures/test-data/config.ts

export interface Environment {
  baseUrl: string;
  apiUrl: string;
  authToken?: string;
}

const environments: Record<string, Environment> = {
  local: {
    baseUrl: 'http://localhost:3000',
    apiUrl: 'http://localhost:3001/api',
    authToken: process.env.LOCAL_AUTH_TOKEN
  },
  staging: {
    baseUrl: 'https://staging.example.com',
    apiUrl: 'https://api-staging.example.com',
    authToken: process.env.STAGING_AUTH_TOKEN
  },
  production: {
    baseUrl: 'https://example.com',
    apiUrl: 'https://api.example.com',
    authToken: process.env.PROD_AUTH_TOKEN
  }
};

export function getEnvironment(): Environment {
  const env = process.env.TEST_ENV || 'local';
  return environments[env] || environments.local;
}

export const currentEnv = getEnvironment();
```

### Usage with Environment Variables

```typescript
import { currentEnv } from '../fixtures/test-data/config';

test('TC-001: Login redirects to dashboard', async ({ page }) => {
  // Use environment-specific URL
  await page.goto(`${currentEnv.baseUrl}/login`);

  await loginPage.login(validUser.email, validUser.password);

  // Verify redirect to correct environment
  await expect(page).toHaveURL(`${currentEnv.baseUrl}/dashboard`);
});
```

---

## Sensitive Data Management

### Environment Variables

**Never commit sensitive data**. Use environment variables:

```typescript
// fixtures/test-data/secrets.ts

export const secrets = {
  adminPassword: process.env.ADMIN_PASSWORD || '',
  apiKey: process.env.API_KEY || '',
  authToken: process.env.AUTH_TOKEN || '',
  databaseUrl: process.env.DATABASE_URL || ''
};

// Validate required secrets
export function validateSecrets(): void {
  const required = ['ADMIN_PASSWORD', 'API_KEY', 'AUTH_TOKEN'];
  const missing = required.filter(key => !process.env[key]);

  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }
}
```

### .env Files (Local Development Only)

```bash
# .env.local (NEVER commit to git)
ADMIN_PASSWORD=SuperSecretPassword123!
API_KEY=sk_test_1234567890abcdef
AUTH_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
DATABASE_URL=postgresql://user:pass@localhost:5432/testdb
TEST_ENV=local
```

Add to `.gitignore`:

```gitignore
# Environment files
.env
.env.local
.env.*.local
```

### CI/CD Secrets

Store secrets in CI/CD platform (GitHub Actions, GitLab CI, etc.):

```yaml
# .github/workflows/tests.yml
name: E2E Tests
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        env:
          ADMIN_PASSWORD: ${{ secrets.ADMIN_PASSWORD }}
          API_KEY: ${{ secrets.API_KEY }}
          AUTH_TOKEN: ${{ secrets.AUTH_TOKEN }}
        run: npm test
```

---

## Test Data Helpers

### Data Factories

Create factory functions for complex data:

```typescript
// fixtures/test-data/factories.ts

export function createOrder(overrides?: Partial<OrderData>): OrderData {
  return {
    orderId: `ORD-${Date.now()}`,
    customerId: `CUST-${Math.random().toString(36).substring(7)}`,
    items: [
      { productId: 'PROD-001', quantity: 1, price: 19.99 },
      { productId: 'PROD-002', quantity: 2, price: 29.99 }
    ],
    total: 79.97,
    status: 'pending',
    createdAt: new Date().toISOString(),
    ...overrides
  };
}

export function createProduct(overrides?: Partial<ProductData>): ProductData {
  const randomId = Math.random().toString(36).substring(7);

  return {
    id: `PROD-${randomId}`,
    name: `Test Product ${randomId}`,
    description: 'This is a test product',
    price: Math.floor(Math.random() * 100) + 10,
    category: 'Electronics',
    inStock: true,
    ...overrides
  };
}
```

### Data Builders

Use builder pattern for complex objects:

```typescript
// fixtures/test-data/builders.ts

export class UserBuilder {
  private data: Partial<UserData> = {};

  withEmail(email: string): this {
    this.data.email = email;
    return this;
  }

  withPassword(password: string): this {
    this.data.password = password;
    return this;
  }

  withName(firstName: string, lastName: string): this {
    this.data.firstName = firstName;
    this.data.lastName = lastName;
    return this;
  }

  withRole(role: string): this {
    this.data.role = role;
    return this;
  }

  build(): UserData {
    return {
      email: this.data.email || `user.${Date.now()}@example.com`,
      password: this.data.password || 'DefaultPass123!',
      firstName: this.data.firstName || 'Test',
      lastName: this.data.lastName || 'User',
      role: this.data.role || 'customer'
    };
  }
}

// Usage:
const user = new UserBuilder()
  .withEmail('admin@example.com')
  .withPassword('AdminPass123!')
  .withRole('admin')
  .build();
```

---

## API-Based Test Data Setup

### Setup Data via API

Prefer API setup for faster test execution:

```typescript
// fixtures/api-helpers.ts

export async function createUserViaAPI(userData: UserData): Promise<string> {
  const response = await fetch(`${currentEnv.apiUrl}/users`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${secrets.apiKey}`
    },
    body: JSON.stringify(userData)
  });

  const data = await response.json();
  return data.userId;
}

export async function deleteUserViaAPI(userId: string): Promise<void> {
  await fetch(`${currentEnv.apiUrl}/users/${userId}`, {
    method: 'DELETE',
    headers: {
      'Authorization': `Bearer ${secrets.apiKey}`
    }
  });
}

// Usage in tests:
test('TC-001: User can update profile', async ({ page }) => {
  // ARRANGE: Create user via API (faster than UI)
  const user = generateUser();
  const userId = await createUserViaAPI(user);

  // Login via UI
  await loginPage.navigate();
  await loginPage.login(user.email, user.password);

  // ACT: Update profile
  await profilePage.updateName('New', 'Name');

  // ASSERT
  await expect(profilePage.successMessage).toBeVisible();

  // CLEANUP
  await deleteUserViaAPI(userId);
});
```

---

## Test Data Versioning

### Keep Test Data in Sync with Schema

```typescript
// fixtures/test-data/schema-version.ts

export const SCHEMA_VERSION = '2.1.0';

export interface UserDataV1 {
  email: string;
  password: string;
}

export interface UserDataV2 extends UserDataV1 {
  firstName: string;
  lastName: string;
}

export interface UserDataV2_1 extends UserDataV2 {
  role: string; // New field in v2.1
}

// Use current version
export type UserData = UserDataV2_1;

// Migration helper
export function migrateUserData(data: any): UserData {
  if (!data.role) {
    data.role = 'customer'; // Default for older data
  }
  return data as UserData;
}
```

---

## Common Test Data Patterns

### 1. Boundary Values

```typescript
export const boundaryValues = {
  stringLimits: {
    empty: '',
    maxLength: 'a'.repeat(255),
    overMaxLength: 'a'.repeat(256)
  },
  numbers: {
    zero: 0,
    negative: -1,
    maxInt: 2147483647,
    minInt: -2147483648
  },
  dates: {
    past: '1900-01-01',
    today: new Date().toISOString().split('T')[0],
    future: '2100-12-31'
  }
};
```

### 2. Edge Cases

```typescript
export const edgeCaseData = {
  specialCharacters: {
    email: 'user+test@example.com',
    name: "O'Brien-Smith",
    address: '123 Main St., Apt. #4B'
  },
  unicode: {
    name: 'José García',
    text: '你好世界' // Chinese characters
  },
  whitespace: {
    leadingSpace: ' user@example.com',
    trailingSpace: 'user@example.com ',
    multipleSpaces: 'Test  User'
  }
};
```

### 3. State-Dependent Data

```typescript
export const orderStates = {
  pending: createOrder({ status: 'pending' }),
  processing: createOrder({ status: 'processing' }),
  shipped: createOrder({ status: 'shipped', trackingNumber: 'TRK123456' }),
  delivered: createOrder({ status: 'delivered', deliveredAt: new Date().toISOString() }),
  cancelled: createOrder({ status: 'cancelled', cancelReason: 'Customer request' })
};
```

---

## Standards Compliance Checklist

Before committing test data, verify:

- [ ] No hardcoded test data in test files
- [ ] All test data in `fixtures/test-data/` directory
- [ ] TypeScript interfaces defined for all data structures
- [ ] Data generators create unique values per test
- [ ] Environment-specific data uses environment variables
- [ ] Sensitive data stored in environment variables, not in code
- [ ] `.env` files added to `.gitignore`
- [ ] API helpers created for data setup/teardown
- [ ] Test data isolation strategy implemented
- [ ] Data cleanup happens in `afterEach` or fixtures

---

## References

**Related Standards:**
- `@qa-agent-os/standards/automation/playwright.md` - Test script standards
- `@qa-agent-os/standards/automation/pom-patterns.md` - POM construction
- `@qa-agent-os/standards/global/security.md` - Security practices

**Playwright Resources:**
- Fixtures: https://playwright.dev/docs/test-fixtures
- Test Data: https://playwright.dev/docs/test-parameterize
- API Testing: https://playwright.dev/docs/api-testing

---

*This standard ensures all test data is properly managed, isolated, and secure across all automated tests.*
