# /report-bug Command

## Purpose

Report bugs discovered during feature testing with AI-assisted severity classification, guided evidence collection, and structured documentation at the feature level.

## Usage

```bash
/report-bug                                    # Interactive mode
/report-bug --title "Error message"            # Direct mode with title
/report-bug --feature "feature-name"           # Specify feature explicitly
```

### Interactive Mode

When run without parameters, guides you through:
1. Feature context detection or manual selection
2. Auto-increment bug ID generation
3. Bug details questionnaire
4. Evidence collection checklist
5. AI severity classification with confirmation
6. Bug folder creation and report generation

### Direct Mode

When parameters are provided:
- `--title "Bug title"` (recommended)
- `--feature "feature-name"` (optional, auto-detected from directory)
- `--severity S1|S2|S3|S4` (optional, will classify if not provided)

## Smart Features

### Feature-Level Bug Organization
- Auto-detects feature context from current working directory
- Creates bugs at feature level: `qa-agent-os/features/[feature-name]/bugs/`
- Auto-increments bug IDs per feature (BUG-001, BUG-002, etc.)
- Creates bug folder with organized subfolders for evidence

### Auto-Increment Bug IDs
- Scans existing bugs in feature
- Generates next sequential ID automatically
- Validates ID uniqueness before creating folder
- Zero-padded format (BUG-001, BUG-002, BUG-003)

### AI-Assisted Severity Classification
- Analyzes bug description, evidence, and impact
- Applies severity rules (S1-S4) automatically
- Provides justification for suggested severity
- Allows user confirmation or override

### Guided Evidence Collection
- Supports multiple evidence types
- Organizes materials into semantic subfolders:
  - screenshots/ (PNG, JPG, GIF)
  - logs/ (TXT, LOG)
  - videos/ (MP4, MOV, WebM)
  - artifacts/ (HAR, JSON, SQL)
- Validates file existence and readability

### Structured Bug Reports
- Follows `bug-report.md` template
- Includes metadata, reproduction steps, evidence
- Tracks AI suggestion vs user decision
- Ready for revision tracking with /revise-bug

## Execution Phases

This is an orchestrated command with 5 phases (0-4):

{{PHASE 0: @qa-agent-os/commands/report-bug/0-detect-context.md}}

{{PHASE 1: @qa-agent-os/commands/report-bug/1-collect-details.md}}

{{PHASE 2: @qa-agent-os/commands/report-bug/2-collect-evidence.md}}

{{PHASE 3: @qa-agent-os/commands/report-bug/3-classify-severity.md}}

{{PHASE 4: @qa-agent-os/commands/report-bug/4-generate-report.md}}

## Output Structure

Bug reports are saved to feature-level structure:
```
qa-agent-os/features/[feature-name]/bugs/BUG-XXX-[short-title]/
├── bug-report.md
├── screenshots/
├── logs/
├── videos/
└── artifacts/
```

### Bug Report Contents

The generated bug report includes:

1. **Metadata** - Bug ID, feature, ticket, timestamps, version, status
2. **Bug Details** - Title, summary, environment, component
3. **Reproduction** - Preconditions, steps, expected/actual results
4. **Classification** - Severity, priority, AI justification
5. **Evidence** - Organized attachments (screenshots, logs, videos, artifacts)
6. **Analysis** - Root cause hypothesis, affected areas
7. **Status Workflow** - Current status, history, valid transitions
8. **Ownership** - Reporter, assignee, QA verifier
9. **Developer Notes** - Reserved for fix information
10. **Revision Log** - Version history and changes

## Workflow Examples

### Example 1: Interactive Bug Report from Feature Directory

```
cd qa-agent-os/features/payment-gateway/

/report-bug

[Phase 0: Context Detection]
Found feature context: payment-gateway
Feature Path: /Users/you/projects/qa-agent-os/qa-agent-os/features/payment-gateway
Feature Status: Valid

[Phase 1: Collect Details]
Determining next bug ID...
Existing bugs in feature:
  BUG-001-login-form-validation-error
  BUG-002-payment-processing-timeout

Next available bug ID: BUG-003

Bug Title: Checkout - Submit button returns 500 error
Bug Summary: When users click Submit on checkout form...
Environment: Chrome 121, Staging, v2.5.1
Related Ticket: TICKET-456

[Phase 2: Collect Evidence]
Evidence types: [1] Screenshot [2] Log [3] Video [4] Artifact [5] Done
Screenshot: ./screenshots/checkout-error.png
Logs: /var/logs/checkout-2025-12-08.log
Done with evidence

[Phase 3: Classify Severity]
Suggested: S2 - Major (Feature broken, workaround difficult)
Accept? [y] y

[Phase 4: Generate Report]
Creating bug folder: BUG-003-checkout-submit-button-500-error
Generating bug-report.md...
✓ Bug folder created at qa-agent-os/features/payment-gateway/bugs/BUG-003-checkout-submit-button-500-error/
✓ All subfolders created (screenshots/, logs/, videos/, artifacts/)
✓ bug-report.md generated with metadata pre-populated

Bug reported successfully!
ID: BUG-003
Path: qa-agent-os/features/payment-gateway/bugs/BUG-003-checkout-submit-button-500-error/

Next Steps:
  - Review bug-report.md and complete any additional details
  - Add more evidence with /revise-bug
  - Update status as investigation progresses
```

### Example 2: Direct Mode from Feature Directory

```
cd qa-agent-os/features/payment-gateway/

/report-bug --title "Currency conversion calculation incorrect"

[Phase 0: Context Detection]
Found feature context: payment-gateway

[Phase 1: Collect Details]
Auto-detected bug ID: BUG-004
Auto-generated folder name: bug-004-currency-conversion-calculation-incorrect

[Quick interactive prompts for missing details...]

[Phase 4: Generate Report]
✓ Bug created: BUG-004-currency-conversion-calculation-incorrect/

Next Steps:
  - Add evidence with /revise-bug
  - Update status as investigation progresses
```

## Severity Classification

The command uses these severity levels:

| Level | Name | Criteria |
|-------|------|----------|
| S1 | Critical | Data loss, security, crash, payment broken, no workaround |
| S2 | Major | Feature broken, wrong calculations, difficult workaround |
| S3 | Minor | UI issues, incorrect messages, easy workaround |
| S4 | Trivial | Cosmetic, typos, minimal impact |

See `@qa-agent-os/standards/bugs/bug-reporting.md` for detailed severity rules.

## Related Commands

- `/revise-bug` - Update existing bug reports with new evidence or status changes
- `/plan-ticket` - Create ticket structure for testing (bugs tracked at feature level)
- `/generate-testcases` - Generate test cases for ticket testing
- `/start-feature` - Create feature structure

## Standards Applied

Bug reports follow these standards:
- `@qa-agent-os/standards/bugs/bug-reporting.md` - Report structure, fields, severity rules
- `@qa-agent-os/standards/global/bugs.md` - Bug lifecycle and conventions
- `@qa-agent-os/templates/bug-report.md` - Template with field guidance
- `@qa-agent-os/templates/bug-folder-structure-guide.md` - Organization patterns

## Error Handling

The command provides helpful error messages:

**Feature context not found:**
```
ERROR: Could not detect feature context from current directory.

Please run this command from a feature directory:
  cd qa-agent-os/features/[feature-name]/

Or specify feature explicitly:
  /report-bug --feature payment-gateway
```

**Permission issues:**
```
ERROR: Feature directory not writable: /path/to/features/payment-gateway

Please check directory permissions and try again.
```

**Bug ID collision:**
```
WARNING: Bug ID BUG-003 already exists!

Using next available ID: BUG-004
```

---

*Report bugs efficiently with feature-level organization. Use `/revise-bug` to update reports as issues progress through the lifecycle.*
