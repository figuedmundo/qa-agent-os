# Configuration Validation Design

## Overview

This document defines how the `/automate-testcases` command validates team-specific configurations before using them, ensuring early error detection with helpful guidance for fixing issues.

---

## Design Principles

1. **Fail Fast**: Validate before starting automation
2. **Clear Errors**: Specific messages about what's wrong
3. **Actionable Guidance**: Tell users exactly how to fix issues
4. **Comprehensive**: Check structure, types, values, and dependencies
5. **Helpful Warnings**: Warn about suboptimal but valid configs

---

## Validation Layers

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 1: Structural Validation                             │
│  - File exists and is readable                              │
│  - Valid YAML/JSON/TS syntax                                │
│  - Required top-level keys present                          │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Layer 2: Type Validation                                   │
│  - Correct data types (string, number, boolean, array)      │
│  - Enum values match allowed options                        │
│  - Array elements have correct types                        │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Layer 3: Value Validation                                  │
│  - URLs are valid                                           │
│  - Numbers are in acceptable ranges                         │
│  - File paths exist (if referenced)                         │
│  - Regex patterns are valid                                 │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Layer 4: Dependency Validation                             │
│  - Method-specific fields present                           │
│  - Conditional requirements met                             │
│  - Environment variables exist                              │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Layer 5: Best Practice Warnings                            │
│  - Recommend improvements                                   │
│  - Warn about potential issues                              │
│  - Suggest optimizations                                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Validation Result Structure

### ValidationResult Interface

```typescript
interface ValidationResult {
  // Overall validation status
  valid: boolean;

  // Errors that must be fixed (block execution)
  errors: ValidationError[];

  // Warnings that should be addressed (allow execution)
  warnings: ValidationWarning[];

  // Informational messages
  info: ValidationInfo[];
}

interface ValidationError {
  field: string;           // e.g., "authentication.method"
  message: string;         // Human-readable error
  expected: string;        // What was expected
  actual: any;             // What was found
  fix: string;             // How to fix it
  code: string;            // Error code for programmatic handling
}

interface ValidationWarning {
  field: string;
  message: string;
  recommendation: string;
  severity: 'low' | 'medium' | 'high';
}

interface ValidationInfo {
  message: string;
  category: 'performance' | 'security' | 'compatibility' | 'general';
}
```

---

## Layer 1: Structural Validation

### Required Fields

```typescript
const REQUIRED_FIELDS = {
  'project.name': 'string',
  'authentication.method': 'string',
  'authentication.token_env_var': 'string',
  'pom.base_page_pattern': 'string',
  'pom.selector_priority': 'array',
  'browsers.default': 'string',
  'browsers.enabled': 'array',
  'execution.timeout': 'number',
  'required_env_vars': 'array'
};

function validateStructure(config: any): ValidationError[] {
  const errors: ValidationError[] = [];

  for (const [field, expectedType] of Object.entries(REQUIRED_FIELDS)) {
    const value = getNestedValue(config, field);

    if (value === undefined) {
      errors.push({
        field,
        message: `Missing required field: ${field}`,
        expected: `Field of type ${expectedType}`,
        actual: undefined,
        fix: `Add ${field} to your configuration file`,
        code: 'MISSING_REQUIRED_FIELD'
      });
    } else if (typeof value !== expectedType && !Array.isArray(value)) {
      errors.push({
        field,
        message: `Invalid type for ${field}`,
        expected: expectedType,
        actual: typeof value,
        fix: `Change ${field} to ${expectedType} type`,
        code: 'INVALID_TYPE'
      });
    }
  }

  return errors;
}

function getNestedValue(obj: any, path: string): any {
  return path.split('.').reduce((current, key) => current?.[key], obj);
}
```

---

## Layer 2: Type Validation

### Enum Validation

```typescript
const ALLOWED_VALUES = {
  'authentication.method': ['query-param', 'cookie', 'header', 'custom'],
  'pom.base_page_pattern': ['minimal', 'full', 'custom'],
  'pom.selector_priority': ['data-testid', 'id', 'role', 'aria-label', 'class', 'tag'],
  'output.organization_pattern': ['feature-based', 'page-based', 'hybrid'],
  'output.naming_convention': ['kebab-case', 'snake_case', 'camelCase'],
  'browsers.default': ['chromium', 'firefox', 'webkit']
};

function validateEnums(config: AutomationConfig): ValidationError[] {
  const errors: ValidationError[] = [];

  // Validate authentication method
  if (!ALLOWED_VALUES['authentication.method'].includes(config.authentication.method)) {
    errors.push({
      field: 'authentication.method',
      message: 'Invalid authentication method',
      expected: ALLOWED_VALUES['authentication.method'].join(' | '),
      actual: config.authentication.method,
      fix: `Use one of: ${ALLOWED_VALUES['authentication.method'].join(', ')}`,
      code: 'INVALID_ENUM_VALUE'
    });
  }

  // Validate selector priority (all elements must be valid)
  const invalidSelectors = config.pom.selector_priority.filter(
    sel => !ALLOWED_VALUES['pom.selector_priority'].includes(sel)
  );

  if (invalidSelectors.length > 0) {
    errors.push({
      field: 'pom.selector_priority',
      message: 'Invalid selector types in priority list',
      expected: ALLOWED_VALUES['pom.selector_priority'].join(', '),
      actual: invalidSelectors.join(', '),
      fix: `Remove invalid selectors: ${invalidSelectors.join(', ')}`,
      code: 'INVALID_SELECTOR_TYPE'
    });
  }

  // Validate browser default is in enabled list
  if (!config.browsers.enabled.includes(config.browsers.default)) {
    errors.push({
      field: 'browsers.default',
      message: 'Default browser not in enabled browsers list',
      expected: `One of: ${config.browsers.enabled.join(', ')}`,
      actual: config.browsers.default,
      fix: `Either add ${config.browsers.default} to browsers.enabled or change default`,
      code: 'BROWSER_MISMATCH'
    });
  }

  return errors;
}
```

---

## Layer 3: Value Validation

### Range and Format Validation

```typescript
function validateValues(config: AutomationConfig): ValidationError[] {
  const errors: ValidationError[] = [];

  // Timeout must be positive
  if (config.execution.timeout <= 0) {
    errors.push({
      field: 'execution.timeout',
      message: 'Timeout must be greater than 0',
      expected: 'Positive number (e.g., 30000)',
      actual: config.execution.timeout,
      fix: 'Set timeout to a positive number in milliseconds',
      code: 'INVALID_TIMEOUT'
    });
  }

  // Timeout should be reasonable (warn if > 5 minutes)
  if (config.execution.timeout > 300000) {
    warnings.push({
      field: 'execution.timeout',
      message: 'Timeout is very high (> 5 minutes)',
      recommendation: 'Consider reducing timeout to avoid long-running tests',
      severity: 'medium'
    });
  }

  // Workers must be positive
  if (config.execution.workers <= 0) {
    errors.push({
      field: 'execution.workers',
      message: 'Number of workers must be greater than 0',
      expected: 'Positive integer (e.g., 4)',
      actual: config.execution.workers,
      fix: 'Set workers to 1 or more',
      code: 'INVALID_WORKERS'
    });
  }

  // Viewport dimensions must be positive
  if (config.browsers.viewport.width <= 0 || config.browsers.viewport.height <= 0) {
    errors.push({
      field: 'browsers.viewport',
      message: 'Viewport dimensions must be positive',
      expected: 'width > 0 and height > 0',
      actual: `${config.browsers.viewport.width}x${config.browsers.viewport.height}`,
      fix: 'Set viewport to valid dimensions (e.g., 1280x720)',
      code: 'INVALID_VIEWPORT'
    });
  }

  // Retry count should be reasonable
  if (config.execution.retry_count > 5) {
    warnings.push({
      field: 'execution.retry_count',
      message: 'High retry count (> 5)',
      recommendation: 'High retries may hide flaky tests. Consider fixing test stability instead.',
      severity: 'medium'
    });
  }

  return errors;
}
```

---

## Layer 4: Dependency Validation

### Method-Specific Requirements

```typescript
function validateDependencies(config: AutomationConfig): ValidationError[] {
  const errors: ValidationError[] = [];

  // Authentication method-specific validation
  switch (config.authentication.method) {
    case 'query-param':
      if (!config.authentication.token_param_name) {
        errors.push({
          field: 'authentication.token_param_name',
          message: 'token_param_name required for query-param authentication',
          expected: 'String (e.g., "auth_token")',
          actual: undefined,
          fix: 'Add authentication.token_param_name to config',
          code: 'MISSING_METHOD_FIELD'
        });
      }
      break;

    case 'cookie':
      if (!config.authentication.cookie_name) {
        errors.push({
          field: 'authentication.cookie_name',
          message: 'cookie_name required for cookie authentication',
          expected: 'String (e.g., "session_token")',
          actual: undefined,
          fix: 'Add authentication.cookie_name to config',
          code: 'MISSING_METHOD_FIELD'
        });
      }
      break;

    case 'header':
      if (!config.authentication.header_name) {
        errors.push({
          field: 'authentication.header_name',
          message: 'header_name required for header authentication',
          expected: 'String (e.g., "Authorization")',
          actual: undefined,
          fix: 'Add authentication.header_name to config',
          code: 'MISSING_METHOD_FIELD'
        });
      }
      break;

    case 'custom':
      if (!config.authentication.custom_script) {
        errors.push({
          field: 'authentication.custom_script',
          message: 'custom_script required for custom authentication',
          expected: 'Path to custom auth script',
          actual: undefined,
          fix: 'Add authentication.custom_script to config',
          code: 'MISSING_METHOD_FIELD'
        });
      } else {
        // Validate custom script file exists
        if (!fs.existsSync(config.authentication.custom_script)) {
          errors.push({
            field: 'authentication.custom_script',
            message: 'Custom auth script file not found',
            expected: 'Existing file path',
            actual: config.authentication.custom_script,
            fix: `Create the file or update path: ${config.authentication.custom_script}`,
            code: 'FILE_NOT_FOUND'
          });
        }
      }
      break;
  }

  // POM pattern-specific validation
  if (config.pom.base_page_pattern === 'custom') {
    if (!config.pom.custom_base_page_path) {
      errors.push({
        field: 'pom.custom_base_page_path',
        message: 'custom_base_page_path required for custom POM pattern',
        expected: 'Path to custom BasePage class',
        actual: undefined,
        fix: 'Add pom.custom_base_page_path to config',
        code: 'MISSING_PATTERN_FIELD'
      });
    }
  }

  return errors;
}
```

### Environment Variable Validation

```typescript
function validateEnvironmentVariables(config: AutomationConfig): ValidationError[] {
  const errors: ValidationError[] = [];
  const warnings: ValidationWarning[] = [];

  // Check required environment variables
  const missingVars = config.required_env_vars.filter(
    varName => !process.env[varName]
  );

  if (missingVars.length > 0) {
    errors.push({
      field: 'required_env_vars',
      message: 'Required environment variables not set',
      expected: config.required_env_vars.join(', '),
      actual: `Missing: ${missingVars.join(', ')}`,
      fix: `Set environment variables: ${missingVars.map(v => `export ${v}=value`).join('; ')}`,
      code: 'MISSING_ENV_VARS'
    });
  }

  // Validate BASE_URL if present
  if (process.env.BASE_URL) {
    try {
      new URL(process.env.BASE_URL);
    } catch {
      errors.push({
        field: 'BASE_URL',
        message: 'BASE_URL is not a valid URL',
        expected: 'Valid URL (e.g., http://localhost:3000)',
        actual: process.env.BASE_URL,
        fix: 'Set BASE_URL to a valid URL in your .env file',
        code: 'INVALID_URL'
      });
    }
  }

  // Validate auth token is set
  if (process.env[config.authentication.token_env_var]) {
    const tokenValue = process.env[config.authentication.token_env_var];

    // Warn if token seems too short
    if (tokenValue.length < 10) {
      warnings.push({
        field: config.authentication.token_env_var,
        message: 'Authentication token seems very short',
        recommendation: 'Verify token is correct. Short tokens may be invalid.',
        severity: 'high'
      });
    }

    // Warn if token is a placeholder
    if (tokenValue.includes('placeholder') || tokenValue.includes('your_token')) {
      warnings.push({
        field: config.authentication.token_env_var,
        message: 'Authentication token appears to be a placeholder',
        recommendation: 'Replace with actual authentication token',
        severity: 'high'
      });
    }
  }

  return errors;
}
```

---

## Layer 5: Best Practice Warnings

### Performance Warnings

```typescript
function generateBestPracticeWarnings(config: AutomationConfig): ValidationWarning[] {
  const warnings: ValidationWarning[] = [];

  // Parallel execution disabled
  if (!config.execution.parallel) {
    warnings.push({
      field: 'execution.parallel',
      message: 'Parallel execution is disabled',
      recommendation: 'Enable parallel execution for faster test runs',
      severity: 'low'
    });
  }

  // Too many browsers
  if (config.browsers.enabled.length > 2) {
    warnings.push({
      field: 'browsers.enabled',
      message: 'Testing on many browsers increases execution time',
      recommendation: 'Consider testing on primary browser(s) only in development',
      severity: 'low'
    });
  }

  // Headless mode disabled in CI
  if (process.env.CI && !config.browsers.headless) {
    warnings.push({
      field: 'browsers.headless',
      message: 'Headed mode enabled in CI environment',
      recommendation: 'Use headless mode in CI for better performance',
      severity: 'medium'
    });
  }

  // No retries in CI
  if (process.env.CI && config.execution.retry_count === 0) {
    warnings.push({
      field: 'execution.retry_count',
      message: 'No retries configured for CI',
      recommendation: 'Consider adding 1-2 retries in CI to handle flakiness',
      severity: 'low'
    });
  }

  return warnings;
}
```

### Security Warnings

```typescript
function generateSecurityWarnings(config: AutomationConfig): ValidationWarning[] {
  const warnings: ValidationWarning[] = [];

  // Token in config file (should be in env)
  if ((config as any).authentication.token_value) {
    warnings.push({
      field: 'authentication.token_value',
      message: 'Authentication token hardcoded in config file',
      recommendation: 'Move token to environment variable for security',
      severity: 'high'
    });
  }

  // Base URL is localhost in prod-like env
  if (process.env.BASE_URL?.includes('localhost') &&
      ['staging', 'production'].includes(process.env.TEST_ENV || '')) {
    warnings.push({
      field: 'BASE_URL',
      message: 'BASE_URL points to localhost in non-local environment',
      recommendation: 'Verify BASE_URL is correct for this environment',
      severity: 'high'
    });
  }

  return warnings;
}
```

---

## Complete Validation Function

```typescript
/**
 * Validate automation configuration
 *
 * Returns validation result with errors, warnings, and info
 */
export function validateConfiguration(
  config: AutomationConfig
): ValidationResult {

  const errors: ValidationError[] = [];
  const warnings: ValidationWarning[] = [];
  const info: ValidationInfo[] = [];

  // Layer 1: Structural validation
  errors.push(...validateStructure(config));

  // Layer 2: Type validation
  errors.push(...validateEnums(config));

  // Layer 3: Value validation
  errors.push(...validateValues(config));

  // Layer 4: Dependency validation
  errors.push(...validateDependencies(config));
  errors.push(...validateEnvironmentVariables(config));

  // Layer 5: Best practice warnings
  warnings.push(...generateBestPracticeWarnings(config));
  warnings.push(...generateSecurityWarnings(config));

  // Informational messages
  if (config.optional?.generate_page_structure_json) {
    info.push({
      message: 'page-structure.json will be generated for complex pages',
      category: 'general'
    });
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings,
    info
  };
}
```

---

## Pre-Flight Checks

### Additional Runtime Checks

```typescript
/**
 * Pre-flight checks before starting automation
 *
 * These check runtime conditions, not just config
 */
export async function runPreFlightChecks(): Promise<ValidationResult> {
  const errors: ValidationError[] = [];
  const warnings: ValidationWarning[] = [];

  // Check Playwright is installed
  try {
    await exec('npx playwright --version');
  } catch {
    errors.push({
      field: 'playwright',
      message: 'Playwright not installed',
      expected: '@playwright/test package',
      actual: 'Not found',
      fix: 'Run: npm install -D @playwright/test && npx playwright install',
      code: 'PLAYWRIGHT_NOT_INSTALLED'
    });
  }

  // Check application is reachable (if BASE_URL set)
  if (process.env.BASE_URL) {
    try {
      const response = await fetch(process.env.BASE_URL, {
        method: 'HEAD',
        timeout: 5000
      });

      if (!response.ok) {
        warnings.push({
          field: 'BASE_URL',
          message: `Application returned ${response.status} status`,
          recommendation: 'Verify application is running correctly',
          severity: 'high'
        });
      }
    } catch (error) {
      warnings.push({
        field: 'BASE_URL',
        message: 'Could not reach application',
        recommendation: 'Ensure application is running before tests',
        severity: 'high'
      });
    }
  }

  // Check disk space for test artifacts
  const diskSpace = await checkDiskSpace();
  if (diskSpace < 1000) { // Less than 1GB
    warnings.push({
      field: 'disk_space',
      message: 'Low disk space available',
      recommendation: 'Test videos/screenshots may fail. Free up disk space.',
      severity: 'medium'
    });
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings,
    info: []
  };
}
```

---

## Error Message Formatting

### User-Friendly Output

```typescript
function formatValidationResult(result: ValidationResult): void {
  if (result.valid && result.warnings.length === 0) {
    console.log('✓ Configuration validation passed\n');
    return;
  }

  // Display errors
  if (result.errors.length > 0) {
    console.error('\n❌ Configuration validation failed\n');

    result.errors.forEach((error, index) => {
      console.error(`Error ${index + 1}: ${error.field}`);
      console.error(`  ${error.message}`);
      console.error(`  Expected: ${error.expected}`);
      console.error(`  Actual: ${JSON.stringify(error.actual)}`);
      console.error(`  Fix: ${error.fix}\n`);
    });

    console.error('Fix these errors before running automation.\n');
    process.exit(1);
  }

  // Display warnings
  if (result.warnings.length > 0) {
    console.warn('\n⚠️  Configuration warnings\n');

    result.warnings.forEach((warning, index) => {
      const icon = warning.severity === 'high' ? '⚠️' : 'ℹ️';
      console.warn(`${icon} ${warning.field}`);
      console.warn(`  ${warning.message}`);
      console.warn(`  Recommendation: ${warning.recommendation}\n`);
    });

    console.warn('Warnings do not block execution but should be addressed.\n');
  }

  // Display info
  if (result.info.length > 0) {
    result.info.forEach(info => {
      console.log(`ℹ️  ${info.message}`);
    });
    console.log();
  }
}
```

**Example Output:**
```
❌ Configuration validation failed

Error 1: authentication.method
  Invalid authentication method
  Expected: query-param | cookie | header | custom
  Actual: "token-based"
  Fix: Use one of: query-param, cookie, header, custom

Error 2: pom.selector_priority
  Invalid selector types in priority list
  Expected: data-testid, id, role, aria-label, class, tag
  Actual: "xpath"
  Fix: Remove invalid selectors: xpath

Error 3: required_env_vars
  Required environment variables not set
  Expected: BASE_URL, TEST_AUTH_TOKEN
  Actual: Missing: BASE_URL, TEST_AUTH_TOKEN
  Fix: Set environment variables: export BASE_URL=value; export TEST_AUTH_TOKEN=value

Fix these errors before running automation.
```

---

## Validation Summary Report

### Generate Validation Report

```typescript
function generateValidationReport(result: ValidationResult): string {
  const lines: string[] = [];

  lines.push('='.repeat(60));
  lines.push('Configuration Validation Report');
  lines.push('='.repeat(60));

  lines.push(`\nStatus: ${result.valid ? '✓ PASS' : '❌ FAIL'}`);
  lines.push(`Errors: ${result.errors.length}`);
  lines.push(`Warnings: ${result.warnings.length}`);
  lines.push(`Info: ${result.info.length}\n`);

  if (result.errors.length > 0) {
    lines.push('ERRORS:');
    lines.push('-'.repeat(60));
    result.errors.forEach((error, i) => {
      lines.push(`${i + 1}. [${error.code}] ${error.field}`);
      lines.push(`   ${error.message}`);
      lines.push(`   Fix: ${error.fix}\n`);
    });
  }

  if (result.warnings.length > 0) {
    lines.push('WARNINGS:');
    lines.push('-'.repeat(60));
    result.warnings.forEach((warning, i) => {
      lines.push(`${i + 1}. [${warning.severity.toUpperCase()}] ${warning.field}`);
      lines.push(`   ${warning.message}`);
      lines.push(`   Recommendation: ${warning.recommendation}\n`);
    });
  }

  lines.push('='.repeat(60));

  return lines.join('\n');
}

// Save report to file
async function saveValidationReport(
  result: ValidationResult,
  outputPath: string
): Promise<void> {
  const report = generateValidationReport(result);
  await fs.writeFile(outputPath, report);
  console.log(`Validation report saved to: ${outputPath}`);
}
```

---

## Design Decisions Summary

1. **Multi-Layer Validation**: Structure → Type → Value → Dependency → Best Practices
2. **Rich Error Information**: Field, message, expected, actual, fix, code
3. **Severity Levels**: Errors (block), Warnings (allow), Info (notify)
4. **Clear Guidance**: Every error includes how to fix it
5. **Pre-Flight Checks**: Runtime validation beyond config
6. **User-Friendly Output**: Formatted, colored, organized
7. **Report Generation**: Detailed validation reports for auditing

---

## Implementation Checklist

- [ ] Define ValidationResult, ValidationError, ValidationWarning interfaces
- [ ] Implement structural validation (required fields, types)
- [ ] Implement enum/value validation
- [ ] Implement dependency validation (method-specific fields)
- [ ] Implement environment variable checking
- [ ] Add best practice warnings
- [ ] Add security warnings
- [ ] Implement pre-flight checks
- [ ] Create user-friendly error formatting
- [ ] Generate validation reports
- [ ] Test with various invalid configurations
- [ ] Ensure error messages are actionable

---

## Teams Will Experience This As:

**Valid Configuration:**
```bash
/automate-testcases TICKET-123

✓ Configuration validation passed
✓ Pre-flight checks passed
✓ Starting automation...
```

**Invalid Configuration:**
```bash
/automate-testcases TICKET-123

❌ Configuration validation failed

Error 1: authentication.method
  Invalid authentication method
  Expected: query-param | cookie | header | custom
  Actual: "token-based"
  Fix: Use one of: query-param, cookie, header, custom

Fix these errors in: qa-agent-os/config/automation/playwright-config.yml
```

**Configuration with Warnings:**
```bash
/automate-testcases TICKET-123

✓ Configuration validation passed

⚠️  Configuration warnings

⚠️ execution.retry_count
  No retries configured for CI
  Recommendation: Consider adding 1-2 retries in CI to handle flakiness

Warnings do not block execution but should be addressed.

✓ Starting automation...
```
