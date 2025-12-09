# Bug Folder Structure Guide

This guide explains the feature-level bug organization structure used in QA Agent OS for organizing bugs, evidence, and supporting materials.

---

## Folder Hierarchy

All bugs are organized at the **feature level** under the `bugs/` directory:

```
qa-agent-os/features/[feature-name]/
├── bugs/
│   ├── BUG-001-[short-title]/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   ├── logs/
│   │   ├── videos/
│   │   └── artifacts/
│   │
│   ├── BUG-002-[short-title]/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   ├── logs/
│   │   ├── videos/
│   │   └── artifacts/
│   │
│   └── BUG-003-[short-title]/
│       ├── bug-report.md
│       ├── screenshots/
│       ├── logs/
│       ├── videos/
│       └── artifacts/
│
├── documentation/
├── feature-knowledge.md
├── feature-test-strategy.md
│
├── [TICKET-001]/
├── [TICKET-002]/
└── [TICKET-003]/
```

---

## Folder Naming Rules

### Bug Folder Name Format

Bug folders follow the pattern: `BUG-00X-[short-title]`

**Components:**
- **BUG-00X**: Auto-incremented bug ID (zero-padded to 3 digits)
- **[short-title]**: URL-friendly description of the bug

**Naming Rules:**
- All lowercase letters
- Hyphens (-) used as word separators
- Alphanumeric characters only (a-z, 0-9)
- No special characters, spaces, or underscores
- 20-40 characters recommended for short-title

### Example Folder Names

**Good Examples:**
- `BUG-001-login-form-validation-error` (clear and concise)
- `BUG-002-checkout-payment-timeout` (specific issue)
- `BUG-003-currency-conversion-calculation-wrong` (descriptive)
- `BUG-042-export-function-produces-corrupt-file` (action + outcome)

**Poor Examples:**
- `BUG_001_login_form_validation_error` (underscores instead of hyphens)
- `BUG-001 Login Form Validation Error` (spaces, capital letters)
- `BUG-001-ThisIsAVeryLongTitleThatDescribesSomethingAboutABugThatIsHardToRemember` (too long)
- `BUG-001-bug` (not descriptive enough)

### Automatic Folder Creation

When you run `/report-bug` from a feature directory:

1. System detects the feature context
2. System scans existing bugs to determine next ID
3. You provide the bug title or summary
4. System automatically converts title to URL-friendly format
5. System creates the folder with correct naming

**Example:**
```bash
/report-bug
# Prompt: Enter bug title: "Login form shows no validation error"
# System creates: BUG-001-login-form-shows-no-validation-error/
```

---

## File Organization

### bug-report.md (Required)

Every bug folder **must** contain a `bug-report.md` file with:

- Complete bug metadata (ID, feature, ticket, dates, version, status)
- Bug details (title, summary, environment)
- Reproduction steps and results
- Severity and priority classification
- Evidence references and attachments
- Analysis and root cause hypothesis
- Status workflow and revision log

**Template Location:** `qa-agent-os/templates/bug-report.md`

**Created by:** `/report-bug` command automatically

### Supporting Material Subfolders

Four semantic subfolders organize different types of evidence:

#### **screenshots/** - Visual Evidence

**File Types:** PNG, JPG, GIF

**Content:**
- Screenshots of the bug in action
- Visual representations of the issue
- Annotated screenshots highlighting the problem
- Multiple states or angles of the UI

**Naming Examples:**
- `form-validation-message.png`
- `error-state-highlighted.png`
- `checkout-confirmation-missing.png`
- `alignment-issue-2025-12-08.png`

**When to Use:**
- UI layout issues
- Visual rendering problems
- Form validation or error messages
- Visual inconsistencies
- Before/after comparisons

#### **logs/** - Diagnostic Output

**File Types:** TXT, LOG

**Content:**
- Browser console output
- Application error logs
- Server/backend logs
- Database logs
- Stack traces
- API error responses
- System logs

**Naming Examples:**
- `browser-console-2025-12-08-14-30.log`
- `error-trace.txt`
- `server-error-500.log`
- `backend-payment-service-error.log`
- `database-query-log.txt`

**When to Use:**
- Error messages and stack traces
- API failures and responses
- Application-level errors
- Debug information
- Performance metrics

#### **videos/** - Screen Recordings

**File Types:** MP4, MOV, WebM, AVI

**Content:**
- Screen recordings showing bug reproduction
- Video demonstrating the issue in action
- Slow-motion recordings for timing-sensitive bugs
- User interaction flows showing the bug

**Naming Examples:**
- `checkout-flow-repro.mp4`
- `login-timeout-recording.webm`
- `form-submission-failure.mp4`
- `payment-processing-hang-slow-motion.mov`

**When to Use:**
- Complex reproduction steps
- Timing or race condition bugs
- User interaction sequence issues
- Visual behavior that's hard to capture in screenshots
- Animation or transition problems

#### **artifacts/** - Complex Files and Data

**File Types:** HAR, JSON, SQL, XML, CSV, DUMP, CONFIG, TXT

**Content:**
- Network traces (HAR files)
- Request/response payloads
- Database dumps and queries
- Configuration exports
- Browser DevTools exports
- Environment snapshots
- Performance profiles

**Naming Examples:**
- `network-trace-failed-request.har`
- `payment-api-request-payload.json`
- `database-transaction-log.sql`
- `user-config-export.json`
- `performance-profile-2025-12-08.txt`
- `devtools-network-export.har`

**When to Use:**
- Network analysis and API debugging
- Database or backend data issues
- Performance profiling data
- Configuration or environment problems
- Complex data structures and relationships

---

## File Organization Best Practices

### Naming Conventions

**For all files in supporting material folders:**

- Use descriptive names that explain the file's purpose
- Include timestamps for logs (format: `YYYY-MM-DD-HH-MM`)
- Use hyphens as separators, not underscores
- Keep names concise but clear
- Lowercase for filenames (optional for consistency)

**Examples:**
- Good: `browser-console-2025-12-08-14-30.log`
- Poor: `console.log` (too generic)
- Poor: `browser_console_2025-12-08-14-30.log` (uses underscores)
- Good: `form-validation-error.png`
- Poor: `screenshot.png` (not descriptive)

### Organization within Subfolders

**Group related files:**
- If multiple screenshots show same issue, name them sequentially
  - `validation-error-1.png`, `validation-error-2.png`
- If logs from different sources, include source in name
  - `browser-console.log`, `server-error.log`, `database.log`
- If multiple videos of same repro, include run number
  - `repro-run-1.mp4`, `repro-run-2.mp4`

**Organize by date if many files:**
- Old logs can be archived with date in name
- Recent items easier to find with clear timestamps

### Empty Subfolders

- Subfolders are created automatically even if you don't use them
- It's OK to have empty `screenshots/`, `logs/`, `videos/`, or `artifacts/` folders
- No need to delete empty subfolders
- Provides ready-to-use structure when evidence is added later

---

## Example Folder Structure

Here's a complete example of a feature with multiple bugs and supporting materials:

```
qa-agent-os/features/payment-gateway/
├── bugs/
│   ├── BUG-001-checkout-validation-error/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   │   ├── form-validation-message.png
│   │   │   ├── error-state-highlighted.png
│   │   │   └── browser-validation-notification.png
│   │   ├── logs/
│   │   │   ├── browser-console-2025-12-08-10-30.log
│   │   │   └── backend-validation-error.txt
│   │   ├── videos/
│   │   │   └── checkout-flow-validation-repro.mp4
│   │   └── artifacts/
│   │       ├── network-trace-failed-validation.har
│   │       └── form-submission-payload.json
│   │
│   ├── BUG-002-payment-processing-timeout/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   │   └── loading-spinner-60-seconds.png
│   │   ├── logs/
│   │   │   ├── payment-service-timeout-2025-12-08-14-30.log
│   │   │   └── browser-console-payment-error.log
│   │   ├── videos/
│   │   │   ├── payment-processing-hang.mp4
│   │   │   └── timeout-after-60-seconds.webm
│   │   └── artifacts/
│   │       ├── payment-gateway-response-timeout.json
│   │       └── network-trace-payment-request.har
│   │
│   └── BUG-003-currency-conversion-error/
│       ├── bug-report.md
│       ├── screenshots/
│       │   ├── price-displayed-wrong-currency.png
│       │   └── cart-total-calculation-wrong.png
│       ├── logs/
│       │   ├── currency-service-response.log
│       │   └── conversion-rate-api-error.txt
│       ├── videos/ (empty - not needed for this bug)
│       └── artifacts/
│           ├── exchange-rate-config-export.json
│           ├── currency-conversion-query.sql
│           └── payment-calculation-payload.json
│
├── documentation/
├── feature-knowledge.md
├── feature-test-strategy.md
│
├── TICKET-001/
├── TICKET-002/
└── TICKET-003/
```

---

## Creating Bugs Manually

While `/report-bug` command creates folders automatically, you can also create manually:

### Using Command Line

```bash
# Navigate to feature directory
cd qa-agent-os/features/my-feature/

# Create bug folder with all subfolders
mkdir -p bugs/BUG-001-my-bug-title/{screenshots,logs,videos,artifacts}

# Create bug report file (copy from template)
cp ../../../templates/bug-report.md bugs/BUG-001-my-bug-title/bug-report.md

# Edit the bug report
nano bugs/BUG-001-my-bug-title/bug-report.md
```

### Using File Manager

1. Navigate to `qa-agent-os/features/[feature-name]/bugs/`
2. Create new folder: `BUG-001-[short-title]`
3. Inside that folder, create 4 subfolders:
   - `screenshots`
   - `logs`
   - `videos`
   - `artifacts`
4. Copy `bug-report.md` template into the bug folder
5. Edit the template with bug details

---

## Ticket Field Usage

The `Ticket` field in bug-report.md links the bug to specific tickets being tested:

**Single Ticket:**
```
Ticket: TICKET-123
```

**Multiple Tickets:**
```
Ticket: TICKET-123, TICKET-124, TICKET-125
```

This enables bidirectional traceability:
- From bug: "Which tickets does this bug affect?"
- From ticket: "Are there any feature-level bugs affecting this ticket?"

---

## Adding Evidence After Bug Creation

Once a bug folder exists, you can add evidence in two ways:

### Using /revise-bug Command

```bash
/revise-bug BUG-001
# Select: "Add Evidence"
# Choose material type: Screenshot, Log, Video, or Artifact
# Provide file path
# System copies file to correct subfolder
# bug-report.md is updated automatically
```

### Manual File Management

1. Add file to appropriate subfolder
2. Update bug-report.md Attachments section
3. Include descriptive information about the file

**Attachment Format in bug-report.md:**
```markdown
- [subfolder]/[filename] - [Description]
- screenshots/validation-error.png - Form validation error displayed to user
- logs/browser-console-2025-12-08.log - JavaScript error context
```

---

## Cross-Feature Considerations

Each feature maintains its own bug numbering:

```
qa-agent-os/features/payment-gateway/bugs/
├── BUG-001-...
├── BUG-002-...
└── BUG-003-...

qa-agent-os/features/user-authentication/bugs/
├── BUG-001-... (independent from payment gateway)
├── BUG-002-...
└── BUG-003-...
```

- **BUG IDs are scoped per feature** (not global)
- Each feature starts with BUG-001
- No cross-feature indexing required
- Each feature manages its own bugs independently

---

## Version Control

### Git Integration

Bug folders are compatible with git version control:

```bash
# Add specific bug to git
git add qa-agent-os/features/payment-gateway/bugs/BUG-001-*/

# Commit bug report and evidence
git commit -m "Add BUG-001: Checkout validation error"

# View bug history
git log qa-agent-os/features/payment-gateway/bugs/
```

### Gitkeep Files

Empty subfolders can be tracked with `.gitkeep`:

```bash
# If using git to track folder structure
touch qa-agent-os/features/payment-gateway/bugs/BUG-001-example/screenshots/.gitkeep
```

---

## Troubleshooting

### Common Issues

**Issue:** Folder name has spaces or special characters
- **Solution:** Run `/report-bug` which sanitizes names automatically, or rename using hyphens

**Issue:** Unsure where to put a file
- **Solution:** If file type isn't obvious, put in `artifacts/` as catch-all category

**Issue:** Too many files in one subfolder
- **Solution:** Create subdirectories with dates if needed (e.g., `logs/2025-12-08/`)

**Issue:** Evidence files are large
- **Solution:** Consider compressing or archiving old evidence; focus on recent findings

---

## References

- **Bug Reporting Standard:** `qa-agent-os/standards/bugs/bug-reporting.md`
- **Bug Report Template:** `qa-agent-os/templates/bug-report.md`
- **Feature Knowledge:** `qa-agent-os/features/[feature-name]/feature-knowledge.md`
- **/report-bug Command:** Create new bugs with auto-detection and organization
- **/revise-bug Command:** Update existing bugs with new evidence and status changes

---

*Feature-level bug organization provides scalable, organized evidence collection while maintaining stable bug identifiers for reliable references and future Jira integration.*
