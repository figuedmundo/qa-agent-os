# Interactive Prompt System Design

## Overview

This document defines how the `/automate-testcases` command prompts teams for missing configuration values interactively, enabling a smooth setup experience while supporting non-interactive CI/CD execution.

---

## Design Principles

1. **Smart Prompting**: Only ask for what's truly needed
2. **Helpful Defaults**: Suggest sensible values based on context
3. **Save for Reuse**: Store prompted values for future runs
4. **CI/CD Safe**: Fail gracefully in non-interactive mode
5. **User-Friendly**: Clear questions, helpful hints, validation feedback

---

## Interactive vs Non-Interactive Mode Detection

### Detection Logic

```typescript
/**
 * Determine if running in interactive mode
 */
function isInteractiveMode(): boolean {
  // Check for CI environment
  if (process.env.CI === 'true') {
    return false;
  }

  // Check if stdin is a TTY (terminal)
  if (!process.stdin.isTTY) {
    return false;
  }

  // Check for explicit non-interactive flag
  if (process.env.NON_INTERACTIVE === 'true') {
    return false;
  }

  return true;
}
```

### Behavior by Mode

**Interactive Mode (Local Development):**
- Prompt user for missing values
- Provide helpful suggestions
- Validate input immediately
- Offer to save values

**Non-Interactive Mode (CI/CD):**
- Fail fast with clear error messages
- List all missing values
- Provide exact commands to fix
- Never hang waiting for input

---

## Prompt Decision Tree

### What to Prompt For

```
┌──────────────────────────────────────────────┐
│  Configuration Value Missing?                │
└───────────────┬──────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────┐
│  Is value CRITICAL for automation?           │
│  (e.g., auth token, base URL)                │
└───────────┬─────────────────┬────────────────┘
            │ Yes             │ No
            ▼                 ▼
┌───────────────────┐   ┌─────────────────────┐
│  Prompt in        │   │  Use default value  │
│  interactive mode │   │  (no prompt needed) │
│                   │   │                     │
│  Error in         │   │  Log info message   │
│  CI/CD mode       │   │                     │
└───────────────────┘   └─────────────────────┘
```

### Critical vs Optional Values

**Critical (Must Prompt/Error):**
- Authentication token or credentials
- Base URL (application under test)
- Custom POM base class (if pattern is 'custom')

**Optional (Use Defaults):**
- Browser choice (default: chromium)
- Timeout values (use standard defaults)
- Number of workers (auto-detect CPU count)
- Viewport size (use common 1280x720)

---

## Prompt Types and Examples

### 1. Simple Text Input

**Use for:** Strings, URLs, file paths

```typescript
const baseUrl = await prompt({
  type: 'input',
  name: 'baseUrl',
  message: 'What is the base URL of your application?',
  default: 'http://localhost:3000',
  validate: (input) => {
    try {
      new URL(input);
      return true;
    } catch {
      return 'Please enter a valid URL';
    }
  }
});
```

**Example Interaction:**
```
? What is the base URL of your application? (http://localhost:3000)
> http://localhost:3000

✓ Base URL set to: http://localhost:3000
```

### 2. Choice Selection

**Use for:** Fixed set of options

```typescript
const authMethod = await prompt({
  type: 'list',
  name: 'authMethod',
  message: 'How should tests authenticate with your application?',
  choices: [
    {
      name: 'Query parameter (e.g., ?auth_token=xyz)',
      value: 'query-param'
    },
    {
      name: 'Cookie-based authentication',
      value: 'cookie'
    },
    {
      name: 'HTTP header (e.g., Authorization: Bearer token)',
      value: 'header'
    },
    {
      name: 'Custom authentication script',
      value: 'custom'
    }
  ],
  default: 'query-param'
});
```

**Example Interaction:**
```
? How should tests authenticate with your application?
❯ Query parameter (e.g., ?auth_token=xyz)
  Cookie-based authentication
  HTTP header (e.g., Authorization: Bearer token)
  Custom authentication script

✓ Authentication method: query-param
```

### 3. Multi-Select

**Use for:** Multiple options from a list

```typescript
const browsers = await prompt({
  type: 'checkbox',
  name: 'browsers',
  message: 'Which browsers should tests run against?',
  choices: [
    { name: 'Chromium (Chrome, Edge)', value: 'chromium', checked: true },
    { name: 'Firefox', value: 'firefox', checked: false },
    { name: 'WebKit (Safari)', value: 'webkit', checked: false }
  ],
  validate: (answer) => {
    if (answer.length === 0) {
      return 'You must choose at least one browser';
    }
    return true;
  }
});
```

**Example Interaction:**
```
? Which browsers should tests run against? (Press <space> to select, <a> to toggle all)
◉ Chromium (Chrome, Edge)
◯ Firefox
◯ WebKit (Safari)

✓ Browsers selected: chromium
```

### 4. Confirmation

**Use for:** Yes/No questions

```typescript
const saveConfig = await prompt({
  type: 'confirm',
  name: 'saveConfig',
  message: 'Save these settings for future test runs?',
  default: true
});
```

**Example Interaction:**
```
? Save these settings for future test runs? (Y/n)
> y

✓ Settings will be saved
```

### 5. Number Input

**Use for:** Numeric values with validation

```typescript
const timeout = await prompt({
  type: 'number',
  name: 'timeout',
  message: 'Test timeout in seconds?',
  default: 30,
  validate: (input) => {
    if (input <= 0) {
      return 'Timeout must be greater than 0';
    }
    if (input > 300) {
      return 'Timeout seems too high (max: 300 seconds)';
    }
    return true;
  }
});
```

**Example Interaction:**
```
? Test timeout in seconds? (30)
> 30

✓ Timeout set to: 30 seconds
```

### 6. Password/Secret Input

**Use for:** Sensitive values (masked)

```typescript
const authToken = await prompt({
  type: 'password',
  name: 'authToken',
  message: 'Enter your test authentication token:',
  mask: '*',
  validate: (input) => {
    if (input.length === 0) {
      return 'Token cannot be empty';
    }
    if (input.length < 10) {
      return 'Token seems too short, please verify';
    }
    return true;
  }
});
```

**Example Interaction:**
```
? Enter your test authentication token:
> ******************

✓ Token saved (will be stored in .env.local)
```

---

## Complete Prompt Flow Example

### Initial Setup Scenario

```typescript
async function promptForMissingConfig(
  config: Partial<AutomationConfig>
): Promise<AutomationConfig> {

  console.log('\n🎯 QA Agent OS - Test Automation Setup\n');

  console.log('Some configuration values are missing. Let\'s set them up.\n');

  // 1. Project information
  if (!config.project?.name) {
    const projectName = await prompt({
      type: 'input',
      name: 'projectName',
      message: 'Project name:',
      default: path.basename(process.cwd())
    });
    config.project = { ...config.project, name: projectName };
  }

  // 2. Base URL
  if (!process.env.BASE_URL) {
    const baseUrl = await prompt({
      type: 'input',
      name: 'baseUrl',
      message: 'Application URL:',
      default: 'http://localhost:3000',
      validate: validateUrl
    });
    process.env.BASE_URL = baseUrl;
  }

  // 3. Authentication method
  if (!config.authentication?.method) {
    const authMethod = await prompt({
      type: 'list',
      name: 'authMethod',
      message: 'Authentication method:',
      choices: [
        { name: 'Query parameter (?auth_token=...)', value: 'query-param' },
        { name: 'Cookie-based', value: 'cookie' },
        { name: 'HTTP header', value: 'header' },
        { name: 'Custom script', value: 'custom' }
      ]
    });

    config.authentication = {
      ...config.authentication,
      method: authMethod
    };

    // Follow-up questions based on method
    if (authMethod === 'query-param') {
      const paramName = await prompt({
        type: 'input',
        name: 'paramName',
        message: 'Query parameter name:',
        default: 'auth_token'
      });
      config.authentication.token_param_name = paramName;
    }
    // ... other method-specific prompts
  }

  // 4. Authentication token
  if (!process.env.TEST_AUTH_TOKEN) {
    console.log('\n⚠️  Authentication token not found in environment');

    const tokenChoice = await prompt({
      type: 'list',
      name: 'tokenChoice',
      message: 'How would you like to provide the auth token?',
      choices: [
        { name: 'Enter token now (will be saved to .env.local)', value: 'enter' },
        { name: 'I will set it in .env file manually', value: 'manual' },
        { name: 'Skip for now (tests may fail)', value: 'skip' }
      ]
    });

    if (tokenChoice === 'enter') {
      const token = await prompt({
        type: 'password',
        name: 'token',
        message: 'Enter auth token:',
        mask: '*'
      });

      // Save to .env.local
      await appendToEnvFile('.env.local', 'TEST_AUTH_TOKEN', token);
      process.env.TEST_AUTH_TOKEN = token;

      console.log('✓ Token saved to .env.local');
    } else if (tokenChoice === 'manual') {
      console.log('\nℹ️  Add this line to your .env file:');
      console.log('   TEST_AUTH_TOKEN=your_token_here\n');
    }
  }

  // 5. POM pattern preference
  if (!config.pom?.base_page_pattern) {
    const pomPattern = await prompt({
      type: 'list',
      name: 'pomPattern',
      message: 'Page Object Model pattern:',
      choices: [
        {
          name: 'Full (comprehensive utilities, recommended)',
          value: 'full'
        },
        {
          name: 'Minimal (basic helpers only)',
          value: 'minimal'
        },
        {
          name: 'Custom (I have my own BasePage)',
          value: 'custom'
        }
      ],
      default: 'full'
    });

    config.pom = {
      ...config.pom,
      base_page_pattern: pomPattern
    };

    if (pomPattern === 'custom') {
      const customPath = await prompt({
        type: 'input',
        name: 'customPath',
        message: 'Path to your custom BasePage class:',
        default: './utils/BasePage.ts',
        validate: (path) => {
          if (!path.endsWith('.ts')) {
            return 'Path must be a TypeScript file (.ts)';
          }
          return true;
        }
      });
      config.pom.custom_base_page_path = customPath;
    }
  }

  // 6. Browser selection
  if (!config.browsers?.enabled) {
    const browsers = await prompt({
      type: 'checkbox',
      name: 'browsers',
      message: 'Select browsers to test:',
      choices: [
        { name: 'Chromium', value: 'chromium', checked: true },
        { name: 'Firefox', value: 'firefox' },
        { name: 'WebKit (Safari)', value: 'webkit' }
      ]
    });

    config.browsers = {
      ...config.browsers,
      enabled: browsers,
      default: browsers[0] || 'chromium'
    };
  }

  // 7. Offer to save configuration
  console.log('\n📋 Configuration Summary:');
  console.log(`  Project: ${config.project.name}`);
  console.log(`  URL: ${process.env.BASE_URL}`);
  console.log(`  Auth: ${config.authentication.method}`);
  console.log(`  POM: ${config.pom.base_page_pattern}`);
  console.log(`  Browsers: ${config.browsers.enabled.join(', ')}`);

  const saveConfig = await prompt({
    type: 'confirm',
    name: 'saveConfig',
    message: '\nSave this configuration?',
    default: true
  });

  if (saveConfig) {
    await saveConfigToFile(config);
    console.log('✓ Configuration saved to: qa-agent-os/config/automation/playwright-config.yml');
  }

  return config as AutomationConfig;
}
```

**Example Full Interaction:**
```
🎯 QA Agent OS - Test Automation Setup

Some configuration values are missing. Let's set them up.

? Project name: (qa-agent-os) my-ecommerce-app
✓ Project name: my-ecommerce-app

? Application URL: (http://localhost:3000) http://localhost:3000
✓ Application URL: http://localhost:3000

? Authentication method:
❯ Query parameter (?auth_token=...)
  Cookie-based
  HTTP header
  Custom script
✓ Authentication method: query-param

? Query parameter name: (auth_token) auth_token
✓ Query parameter name: auth_token

⚠️  Authentication token not found in environment

? How would you like to provide the auth token?
❯ Enter token now (will be saved to .env.local)
  I will set it in .env file manually
  Skip for now (tests may fail)

? Enter auth token: ******************
✓ Token saved to .env.local

? Page Object Model pattern:
❯ Full (comprehensive utilities, recommended)
  Minimal (basic helpers only)
  Custom (I have my own BasePage)
✓ POM pattern: full

? Select browsers to test: (Press <space> to select)
◉ Chromium
◯ Firefox
◯ WebKit (Safari)
✓ Browsers: chromium

📋 Configuration Summary:
  Project: my-ecommerce-app
  URL: http://localhost:3000
  Auth: query-param
  POM: full
  Browsers: chromium

? Save this configuration? (Y/n) y
✓ Configuration saved to: qa-agent-os/config/automation/playwright-config.yml

✓ Setup complete! Running automation...
```

---

## Saving Prompted Values

### Save to Configuration File

```typescript
async function saveConfigToFile(config: AutomationConfig): Promise<void> {
  const configDir = 'qa-agent-os/config/automation';
  const configPath = path.join(configDir, 'playwright-config.yml');

  // Ensure directory exists
  await fs.mkdir(configDir, { recursive: true });

  // Convert to YAML
  const yamlContent = yaml.stringify(config, {
    indent: 2,
    lineWidth: 0 // No line wrapping
  });

  // Add helpful header comment
  const header = `# Playwright Test Automation Configuration
# Generated by QA Agent OS on ${new Date().toISOString()}
#
# This file customizes how test automation works for your project.
# See template for all options: profiles/default/templates/automation/playwright-config-template.yml

`;

  await fs.writeFile(configPath, header + yamlContent);
}
```

### Save Secrets to .env.local

```typescript
async function appendToEnvFile(
  filename: string,
  key: string,
  value: string
): Promise<void> {
  const envPath = path.join(process.cwd(), filename);

  // Read existing content
  let content = '';
  try {
    content = await fs.readFile(envPath, 'utf-8');
  } catch {
    // File doesn't exist, will be created
  }

  // Check if key already exists
  const keyRegex = new RegExp(`^${key}=.*$`, 'm');
  if (keyRegex.test(content)) {
    // Update existing value
    content = content.replace(keyRegex, `${key}=${value}`);
  } else {
    // Append new value
    if (content && !content.endsWith('\n')) {
      content += '\n';
    }
    content += `${key}=${value}\n`;
  }

  await fs.writeFile(envPath, content);

  // Ensure .env.local is in .gitignore
  await ensureInGitignore('.env.local');
}

async function ensureInGitignore(pattern: string): Promise<void> {
  const gitignorePath = path.join(process.cwd(), '.gitignore');

  let content = '';
  try {
    content = await fs.readFile(gitignorePath, 'utf-8');
  } catch {
    // .gitignore doesn't exist
  }

  if (!content.includes(pattern)) {
    if (content && !content.endsWith('\n')) {
      content += '\n';
    }
    content += `# Environment files with secrets\n${pattern}\n`;
    await fs.writeFile(gitignorePath, content);
  }
}
```

---

## CI/CD Mode Error Messages

### Clear, Actionable Errors

```typescript
function failInCIMode(missingValues: string[]): never {
  console.error('\n❌ Missing required configuration values\n');

  console.error('Cannot prompt for input in CI/CD mode (non-interactive).\n');

  console.error('Missing values:');
  missingValues.forEach(value => {
    console.error(`  - ${value}`);
  });

  console.error('\nTo fix this, do ONE of the following:\n');

  console.error('Option 1: Set environment variables');
  console.error('  Add to your CI/CD pipeline configuration:');
  missingValues.forEach(value => {
    if (value.includes('URL')) {
      console.error(`    ${value}=https://your-app-url.com`);
    } else if (value.includes('TOKEN')) {
      console.error(`    ${value}=\${{ secrets.${value} }}`);
    }
  });

  console.error('\nOption 2: Create configuration file');
  console.error('  1. Copy template:');
  console.error('     cp profiles/default/templates/automation/playwright-config-template.yml \\');
  console.error('        qa-agent-os/config/automation/playwright-config.yml');
  console.error('  2. Fill in values');
  console.error('  3. Commit to repository');

  console.error('\nOption 3: Run setup interactively once');
  console.error('  Run this command locally (not in CI):');
  console.error('    /automate-testcases TICKET-123');
  console.error('  Answer prompts, then commit generated config.\n');

  process.exit(1);
}
```

**Example Error Output:**
```
❌ Missing required configuration values

Cannot prompt for input in CI/CD mode (non-interactive).

Missing values:
  - BASE_URL
  - TEST_AUTH_TOKEN

To fix this, do ONE of the following:

Option 1: Set environment variables
  Add to your CI/CD pipeline configuration:
    BASE_URL=https://your-app-url.com
    TEST_AUTH_TOKEN=${{ secrets.TEST_AUTH_TOKEN }}

Option 2: Create configuration file
  1. Copy template:
     cp profiles/default/templates/automation/playwright-config-template.yml \
        qa-agent-os/config/automation/playwright-config.yml
  2. Fill in values
  3. Commit to repository

Option 3: Run setup interactively once
  Run this command locally (not in CI):
    /automate-testcases TICKET-123
  Answer prompts, then commit generated config.
```

---

## Validation and Error Recovery

### Input Validation

```typescript
const validators = {
  url: (input: string): boolean | string => {
    try {
      new URL(input);
      return true;
    } catch {
      return 'Please enter a valid URL (e.g., http://localhost:3000)';
    }
  },

  nonEmpty: (input: string): boolean | string => {
    if (input.trim().length === 0) {
      return 'This value cannot be empty';
    }
    return true;
  },

  filePath: (input: string): boolean | string => {
    if (!input.startsWith('./') && !input.startsWith('../') && !path.isAbsolute(input)) {
      return 'Path must be relative (./file.ts) or absolute (/path/to/file.ts)';
    }
    return true;
  },

  positiveNumber: (input: number): boolean | string => {
    if (input <= 0) {
      return 'Value must be greater than 0';
    }
    return true;
  },

  portNumber: (input: number): boolean | string => {
    if (input < 1 || input > 65535) {
      return 'Port must be between 1 and 65535';
    }
    return true;
  }
};
```

### Error Recovery

```
? Application URL: invalid-url
✖ Please enter a valid URL (e.g., http://localhost:3000)

? Application URL: http://localhost:3000
✓ Application URL: http://localhost:3000
```

---

## Design Decisions Summary

1. **Mode Detection**: Auto-detect interactive vs CI/CD mode
2. **Prompt Library**: Use battle-tested library (inquirer.js or prompts)
3. **Smart Prompting**: Only ask for critical missing values
4. **Validation**: Immediate feedback on invalid input
5. **Persistence**: Save to config file and .env.local
6. **CI/CD Safety**: Fail fast with helpful error messages
7. **User Experience**: Clear questions, helpful defaults, summary before save

---

## Implementation Checklist

- [ ] Implement mode detection (interactive vs CI/CD)
- [ ] Choose and integrate prompt library (inquirer.js recommended)
- [ ] Create prompt definitions for all config values
- [ ] Implement validation functions
- [ ] Build complete prompt flow
- [ ] Implement config file saving (YAML format)
- [ ] Implement .env.local updating
- [ ] Ensure .gitignore is updated
- [ ] Create helpful CI/CD error messages
- [ ] Test both interactive and non-interactive modes
- [ ] Handle keyboard interrupts gracefully (Ctrl+C)

---

## Teams Will Experience This As:

**First Time (No Config):**
```bash
/automate-testcases TICKET-123

🎯 Setting up test automation...
[Interactive prompts guide through setup]
✓ Configuration saved
✓ Starting automation...
```

**Subsequent Runs (Config Exists):**
```bash
/automate-testcases TICKET-456

✓ Configuration loaded
✓ Starting automation...
[No prompts, uses saved config]
```

**CI/CD (Missing Config):**
```bash
/automate-testcases TICKET-789

❌ Missing configuration
[Clear error with exact fix commands]
```
