# Configuration Discovery Design

## Overview

This document defines how the `/automate-testcases` command discovers and reads team-specific configuration at runtime, allowing teams to customize automation behavior without modifying QA Agent OS code.

---

## Design Principles

1. **Convention over Configuration**: Default behavior works out-of-the-box
2. **Graceful Degradation**: Falls back to templates if team config missing
3. **Clear Error Messages**: Guide teams to create required configs
4. **Non-Invasive**: Team configs stay in their project, not in QA Agent OS
5. **Flexible**: Support multiple configuration formats and locations

---

## Configuration Discovery Flow

```
┌─────────────────────────────────────────────────────────────┐
│  /automate-testcases command executed                       │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Phase 0: Configuration Discovery                           │
├─────────────────────────────────────────────────────────────┤
│  1. Detect project root (git root or cwd)                   │
│  2. Check for team config locations (in priority order)     │
│  3. Validate discovered configs                             │
│  4. Merge with defaults from templates                      │
│  5. Prompt for missing critical values (if interactive)     │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Proceed with automation using discovered configuration     │
└─────────────────────────────────────────────────────────────┘
```

---

## Configuration File Locations

### Priority Order (First Found Wins)

The command searches for configuration in this order:

```
1. Project-specific config (highest priority)
   qa-agent-os/config/automation/playwright-config.yml

2. Feature-specific config (if working in feature context)
   features/[feature-name]/automation-config.yml

3. Environment-specific config
   qa-agent-os/config/automation/playwright-config.[ENV].yml
   (e.g., playwright-config.staging.yml)

4. User home directory config (user preferences)
   ~/.qa-agent-os/automation-config.yml

5. QA Agent OS templates (fallback defaults)
   profiles/default/templates/automation/playwright-config-template.yml
```

### Rationale for Priority

- **Project-specific**: Team's authoritative configuration
- **Feature-specific**: Allows per-feature customization (rare but supported)
- **Environment-specific**: Different settings for dev/staging/prod
- **User home**: Developer's local preferences
- **Templates**: Safe defaults when no team config exists

---

## Configuration File Format

### Option 1: YAML (Recommended)

**Pros:**
- Human-readable and writable
- Supports comments for documentation
- Standard format for config files
- Easy to diff in git

**Example:**
```yaml
# qa-agent-os/config/automation/playwright-config.yml

# Project information
project:
  name: "My Application"
  description: "E-commerce platform"

# Authentication configuration
authentication:
  method: "query-param"  # Options: query-param, cookie, header, custom
  token_env_var: "TEST_AUTH_TOKEN"
  token_param_name: "auth_token"  # For query-param method
  # For custom method:
  # custom_script: "./utils/custom-auth.ts"

# Page Object Model patterns
pom:
  base_page_pattern: "full"  # Options: minimal, full, custom
  selector_priority: ["data-testid", "id", "role", "class", "tag"]
  group_selectors: true
  include_assertion_helpers: false

# Test output structure
output:
  organization_pattern: "feature-based"  # Options: feature-based, page-based, hybrid
  directory_structure: "flat"  # Options: flat, nested
  naming_convention: "kebab-case"  # Options: kebab-case, snake_case

# Browser configuration
browsers:
  default: "chromium"
  enabled: ["chromium"]  # Options: chromium, firefox, webkit
  viewport:
    width: 1280
    height: 720
  headless: true

# Test execution
execution:
  timeout: 30000  # milliseconds
  retry_count: 0
  parallel: true
  workers: 4

# Optional features
optional:
  generate_page_structure_json: false
  element_threshold_for_json: 10  # Generate JSON if page has 10+ interactive elements
  visual_regression: false
  api_testing: false

# Reporting
reporting:
  formats: ["html", "json"]
  output_dir: "playwright-report"
  open_on_failure: true

# Environment variables required
required_env_vars:
  - BASE_URL
  - TEST_AUTH_TOKEN

# Optional environment variables with defaults
optional_env_vars:
  API_URL: "http://localhost:3001/api"
  TEST_ENV: "local"
```

### Option 2: JSON

**Pros:**
- Strictly structured
- Easy to parse programmatically
- Standard in JavaScript ecosystem

**Cons:**
- No comments (less self-documenting)
- More verbose with quotes

**Example:**
```json
{
  "project": {
    "name": "My Application",
    "description": "E-commerce platform"
  },
  "authentication": {
    "method": "query-param",
    "token_env_var": "TEST_AUTH_TOKEN"
  },
  "pom": {
    "base_page_pattern": "full",
    "selector_priority": ["data-testid", "id", "role", "class", "tag"]
  }
}
```

### Option 3: TypeScript Module

**Pros:**
- Type-safe with TypeScript interfaces
- Can include logic/functions
- IDE autocomplete support

**Cons:**
- Requires compilation
- More complex for non-developers

**Example:**
```typescript
// qa-agent-os/config/automation/playwright-config.ts

import { AutomationConfig } from '@qa-agent-os/types';

export const config: AutomationConfig = {
  project: {
    name: 'My Application',
    description: 'E-commerce platform'
  },
  authentication: {
    method: 'query-param',
    tokenEnvVar: 'TEST_AUTH_TOKEN'
  },
  pom: {
    basePagePattern: 'full',
    selectorPriority: ['data-testid', 'id', 'role', 'class', 'tag']
  }
};
```

**Recommended Format: YAML** for balance of readability and structure.

---

## Configuration Schema

### TypeScript Interface (for validation)

```typescript
/**
 * Automation Configuration Schema
 *
 * This interface defines the structure of team configuration files
 */
export interface AutomationConfig {
  // Project metadata
  project: {
    name: string;
    description?: string;
    repository?: string;
  };

  // Authentication configuration
  authentication: {
    method: 'query-param' | 'cookie' | 'header' | 'custom';
    token_env_var: string;
    token_param_name?: string;  // For query-param
    cookie_name?: string;       // For cookie
    header_name?: string;       // For header
    custom_script?: string;     // Path to custom auth script
  };

  // Page Object Model settings
  pom: {
    base_page_pattern: 'minimal' | 'full' | 'custom';
    custom_base_page_path?: string;  // If custom pattern
    selector_priority: SelectorType[];
    group_selectors: boolean;
    include_assertion_helpers: boolean;
  };

  // Test output organization
  output: {
    organization_pattern: 'feature-based' | 'page-based' | 'hybrid';
    directory_structure: 'flat' | 'nested';
    naming_convention: 'kebab-case' | 'snake_case' | 'camelCase';
  };

  // Browser settings
  browsers: {
    default: 'chromium' | 'firefox' | 'webkit';
    enabled: BrowserType[];
    viewport: {
      width: number;
      height: number;
    };
    headless: boolean;
  };

  // Execution settings
  execution: {
    timeout: number;
    retry_count: number;
    parallel: boolean;
    workers: number;
  };

  // Optional features
  optional?: {
    generate_page_structure_json?: boolean;
    element_threshold_for_json?: number;
    visual_regression?: boolean;
    api_testing?: boolean;
  };

  // Reporting configuration
  reporting: {
    formats: ReporterType[];
    output_dir: string;
    open_on_failure: boolean;
  };

  // Environment variables
  required_env_vars: string[];
  optional_env_vars?: Record<string, string>;  // Name → default value
}

type SelectorType = 'data-testid' | 'id' | 'role' | 'aria-label' | 'class' | 'tag';
type BrowserType = 'chromium' | 'firefox' | 'webkit';
type ReporterType = 'html' | 'json' | 'junit' | 'allure';
```

---

## Configuration Discovery Algorithm

### Pseudocode

```typescript
async function discoverConfiguration(): Promise<AutomationConfig> {
  // 1. Determine project root
  const projectRoot = await detectProjectRoot();

  // 2. Search for configuration files in priority order
  const configPath = await findConfigFile([
    join(projectRoot, 'qa-agent-os/config/automation/playwright-config.yml'),
    join(projectRoot, 'features', currentFeature, 'automation-config.yml'),
    join(projectRoot, `qa-agent-os/config/automation/playwright-config.${process.env.TEST_ENV}.yml`),
    join(os.homedir(), '.qa-agent-os/automation-config.yml'),
    join(qaAgentOSRoot, 'profiles/default/templates/automation/playwright-config-template.yml')
  ]);

  // 3. Load configuration file
  let config: AutomationConfig;
  if (configPath) {
    config = await loadConfigFile(configPath);
    log(`Loaded configuration from: ${configPath}`);
  } else {
    // No config found, use defaults
    config = getDefaultConfig();
    log('No configuration found, using defaults');
  }

  // 4. Validate configuration
  const validation = validateConfig(config);
  if (!validation.valid) {
    throw new Error(`Invalid configuration: ${validation.errors.join(', ')}`);
  }

  // 5. Merge with defaults for missing optional values
  config = mergeWithDefaults(config);

  // 6. Check required environment variables
  const missingEnvVars = checkRequiredEnvVars(config.required_env_vars);
  if (missingEnvVars.length > 0) {
    if (isInteractiveMode()) {
      // Prompt user to provide missing values
      await promptForEnvVars(missingEnvVars);
    } else {
      throw new Error(`Missing required environment variables: ${missingEnvVars.join(', ')}`);
    }
  }

  return config;
}
```

### Implementation Functions

```typescript
/**
 * Detect project root directory
 */
async function detectProjectRoot(): Promise<string> {
  // Try git root first
  try {
    const gitRoot = await exec('git rev-parse --show-toplevel');
    return gitRoot.trim();
  } catch {
    // Fall back to current working directory
    return process.cwd();
  }
}

/**
 * Find first existing config file from list
 */
async function findConfigFile(paths: string[]): Promise<string | null> {
  for (const path of paths) {
    if (await fileExists(path)) {
      return path;
    }
  }
  return null;
}

/**
 * Load and parse configuration file
 */
async function loadConfigFile(path: string): Promise<AutomationConfig> {
  const ext = extname(path);

  switch (ext) {
    case '.yml':
    case '.yaml':
      const yamlContent = await readFile(path, 'utf-8');
      return yaml.parse(yamlContent);

    case '.json':
      const jsonContent = await readFile(path, 'utf-8');
      return JSON.parse(jsonContent);

    case '.ts':
    case '.js':
      // Dynamic import for TypeScript/JavaScript configs
      const module = await import(path);
      return module.config || module.default;

    default:
      throw new Error(`Unsupported config file format: ${ext}`);
  }
}

/**
 * Validate configuration against schema
 */
function validateConfig(config: AutomationConfig): { valid: boolean; errors: string[] } {
  const errors: string[] = [];

  // Required fields
  if (!config.project?.name) {
    errors.push('project.name is required');
  }

  if (!config.authentication?.method) {
    errors.push('authentication.method is required');
  }

  if (!config.authentication?.token_env_var) {
    errors.push('authentication.token_env_var is required');
  }

  // Method-specific validation
  if (config.authentication.method === 'query-param' && !config.authentication.token_param_name) {
    errors.push('authentication.token_param_name required for query-param method');
  }

  if (config.authentication.method === 'custom' && !config.authentication.custom_script) {
    errors.push('authentication.custom_script required for custom method');
  }

  // Browser validation
  if (!['chromium', 'firefox', 'webkit'].includes(config.browsers?.default)) {
    errors.push('browsers.default must be chromium, firefox, or webkit');
  }

  // Positive numbers
  if (config.execution?.timeout && config.execution.timeout <= 0) {
    errors.push('execution.timeout must be positive');
  }

  return {
    valid: errors.length === 0,
    errors
  };
}

/**
 * Merge config with defaults for optional values
 */
function mergeWithDefaults(config: AutomationConfig): AutomationConfig {
  const defaults = getDefaultConfig();

  return {
    ...defaults,
    ...config,
    optional: {
      ...defaults.optional,
      ...config.optional
    },
    execution: {
      ...defaults.execution,
      ...config.execution
    },
    browsers: {
      ...defaults.browsers,
      ...config.browsers,
      viewport: {
        ...defaults.browsers.viewport,
        ...config.browsers?.viewport
      }
    }
  };
}

/**
 * Check for missing required environment variables
 */
function checkRequiredEnvVars(requiredVars: string[]): string[] {
  return requiredVars.filter(varName => !process.env[varName]);
}
```

---

## Fallback Strategy

### When No Team Config Exists

```typescript
function getDefaultConfig(): AutomationConfig {
  return {
    project: {
      name: 'Unnamed Project',
      description: 'Project description not provided'
    },
    authentication: {
      method: 'query-param',
      token_env_var: 'TEST_AUTH_TOKEN',
      token_param_name: 'auth_token'
    },
    pom: {
      base_page_pattern: 'full',
      selector_priority: ['data-testid', 'id', 'role', 'class', 'tag'],
      group_selectors: true,
      include_assertion_helpers: false
    },
    output: {
      organization_pattern: 'feature-based',
      directory_structure: 'flat',
      naming_convention: 'kebab-case'
    },
    browsers: {
      default: 'chromium',
      enabled: ['chromium'],
      viewport: { width: 1280, height: 720 },
      headless: true
    },
    execution: {
      timeout: 30000,
      retry_count: 0,
      parallel: true,
      workers: 4
    },
    optional: {
      generate_page_structure_json: false,
      element_threshold_for_json: 10
    },
    reporting: {
      formats: ['html', 'json'],
      output_dir: 'playwright-report',
      open_on_failure: true
    },
    required_env_vars: ['BASE_URL', 'TEST_AUTH_TOKEN'],
    optional_env_vars: {
      'API_URL': 'http://localhost:3001/api',
      'TEST_ENV': 'local'
    }
  };
}
```

### User Guidance When Using Defaults

```
⚠️  No team configuration found. Using default settings.

To customize automation behavior, create a configuration file:

  qa-agent-os/config/automation/playwright-config.yml

Template available at:

  profiles/default/templates/automation/playwright-config-template.yml

Copy the template and customize for your project:

  cp profiles/default/templates/automation/playwright-config-template.yml \\
     qa-agent-os/config/automation/playwright-config.yml

For now, automation will proceed with safe defaults.
```

---

## Configuration Validation Error Messages

### Example Error Messages

```
❌ Configuration validation failed:

  - project.name is required
  - authentication.token_env_var is required
  - browsers.default must be one of: chromium, firefox, webkit

Fix these errors in: qa-agent-os/config/automation/playwright-config.yml

See template for examples: profiles/default/templates/automation/playwright-config-template.yml
```

### Missing Environment Variables

```
❌ Required environment variables not set:

  - BASE_URL
  - TEST_AUTH_TOKEN

Set these in your environment or .env file:

  export BASE_URL=http://localhost:3000
  export TEST_AUTH_TOKEN=your_token_here

Or create .env file:

  echo "BASE_URL=http://localhost:3000" >> .env
  echo "TEST_AUTH_TOKEN=your_token_here" >> .env

For CI/CD, configure secrets in your pipeline settings.
```

---

## Caching Strategy

### Cache Configuration for Session

```typescript
// Cache parsed config for duration of command execution
let cachedConfig: AutomationConfig | null = null;

export async function getConfig(): Promise<AutomationConfig> {
  if (!cachedConfig) {
    cachedConfig = await discoverConfiguration();
  }
  return cachedConfig;
}

// Invalidate cache if needed (e.g., after prompting user for values)
export function invalidateConfigCache(): void {
  cachedConfig = null;
}
```

### No Long-Term Caching

- Don't cache config across command executions
- Always re-discover to pick up changes
- Fresh discovery ensures teams can update config without issues

---

## Environment-Specific Configurations

### Support Multiple Environments

```bash
# Different configs for different environments
qa-agent-os/config/automation/
├── playwright-config.yml              # Base/default config
├── playwright-config.local.yml        # Local development
├── playwright-config.staging.yml      # Staging environment
├── playwright-config.production.yml   # Production (read-only tests)
```

### Selection Logic

```typescript
function getEnvironmentConfigPath(baseDir: string): string {
  const env = process.env.TEST_ENV || 'local';

  const envSpecificPath = join(baseDir, `playwright-config.${env}.yml`);
  if (fileExists(envSpecificPath)) {
    return envSpecificPath;
  }

  // Fall back to base config
  return join(baseDir, 'playwright-config.yml');
}
```

---

## Design Decisions Summary

1. **Format: YAML** - Best balance of readability and structure
2. **Location: qa-agent-os/config/automation/** - Clear, consistent location
3. **Priority: Project > Feature > Environment > User > Template** - Logical precedence
4. **Validation: Schema-based** - TypeScript interface defines structure
5. **Fallback: Safe defaults** - Works without team config, guides to create one
6. **Environment Support: Multiple configs** - Separate configs per environment
7. **Caching: Session-only** - No persistent cache, always fresh

---

## Implementation Checklist

- [ ] Define TypeScript interface for AutomationConfig
- [ ] Create YAML schema/validator
- [ ] Implement config discovery algorithm
- [ ] Create default config generator
- [ ] Write helpful error messages
- [ ] Support YAML, JSON, and TypeScript config formats
- [ ] Implement environment-specific config selection
- [ ] Add config validation with clear error messages
- [ ] Test fallback to defaults
- [ ] Document config schema in template file

---

## Teams Will Use This By:

1. **Copy template to their project:**
   ```bash
   cp profiles/default/templates/automation/playwright-config-template.yml \\
      qa-agent-os/config/automation/playwright-config.yml
   ```

2. **Customize values for their project:**
   - Set authentication method
   - Choose POM patterns
   - Configure browsers
   - Define output structure

3. **Commit config to their repo:**
   - Team configuration becomes part of project
   - Shared across all team members
   - Versioned with application code

4. **Run automation:**
   ```bash
   /automate-testcases TICKET-123
   ```
   - Command discovers their config automatically
   - Uses team's customizations
   - No code changes to QA Agent OS needed
