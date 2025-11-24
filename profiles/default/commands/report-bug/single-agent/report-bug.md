# /report-bug Command

## Purpose

Report bugs discovered during testing with AI-assisted severity classification, guided evidence collection, and structured documentation.

## Usage

```bash
/report-bug                                    # Interactive mode
/report-bug --title "Error message" --severity S2   # Direct mode
```

### Interactive Mode

When run without parameters, guides you through:
1. Feature and ticket selection
2. Bug details questionnaire
3. Evidence collection checklist
4. AI severity classification with confirmation

### Direct Mode

When parameters are provided:
- `--title "Bug title"` (required)
- `--severity S1|S2|S3|S4` (optional, will classify if not provided)
- `--steps "1. Step one\n2. Step two"` (optional)
- `--expected "Expected result"` (optional)
- `--actual "Actual result"` (optional)
- `--environment "Chrome 120, Staging"` (optional)
- `--component "Login Module"` (optional)

## Smart Features

### Context-Aware Bug Reporting
- Auto-detects available features in your project
- Auto-detects tickets within selected feature
- Creates bugs folder automatically if needed
- Auto-increments bug IDs (BUG-001, BUG-002, etc.)

### AI-Assisted Severity Classification
- Analyzes bug description, evidence, and impact
- Applies severity rules (S1-S4) automatically
- Provides justification for suggested severity
- Allows user confirmation or override

### Guided Evidence Collection
- Checklist of evidence types to attach
- File path validation for screenshots and logs
- AI log analysis to extract key errors
- Automatic root cause hypothesis generation

### Structured Bug Reports
- Follows `bug-report-template.md` format
- Includes metadata, reproduction steps, evidence
- Tracks AI suggestion vs user decision
- Ready for revision tracking

## Execution Phases

This is an orchestrated command with 5 phases (0-4):

{{PHASE 0: @qa-agent-os/commands/report-bug/0-detect-context.md}}

{{PHASE 1: @qa-agent-os/commands/report-bug/1-collect-details.md}}

{{PHASE 2: @qa-agent-os/commands/report-bug/2-collect-evidence.md}}

{{PHASE 3: @qa-agent-os/commands/report-bug/3-classify-severity.md}}

{{PHASE 4: @qa-agent-os/commands/report-bug/4-generate-report.md}}

## Output Structure

Bug reports are saved to:
```
qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-XXX.md
```

### Bug Report Contents

The generated bug report includes:

1. **Metadata** - Bug ID, feature, ticket, timestamps, version, status
2. **Bug Details** - Title, environment, component
3. **Reproduction** - Preconditions, steps, expected/actual results
4. **Classification** - Severity, priority, AI justification
5. **Evidence** - Screenshots, logs, API data, error messages
6. **Analysis** - Root cause hypothesis, affected areas
7. **Status Workflow** - Current status, history
8. **Ownership** - Reporter, assignee, verifier
9. **Developer Notes** - Reserved for fix information
10. **Revision Log** - Version history and changes

## Workflow Examples

### Example 1: Interactive Bug Report

```
/report-bug

[Phase 0: Context Detection]
Found feature: Payment-Gateway. Is this correct? [y/n] y
Found ticket: PAY-456. Is this correct? [y/n] y
Bug ID assigned: BUG-001

[Phase 1: Collect Details]
Bug Title: Checkout - Submit fails with 500 error
Environment: Chrome 120, Staging, v2.5.1
Steps: 1. Go to /checkout  2. Click Submit  3. Observe 500 error
Expected: Order confirmed
Actual: 500 Internal Server Error displayed

[Phase 2: Collect Evidence]
Evidence types: 1,2,5 (Screenshots, Logs, Error messages)
Screenshot: ./screenshots/checkout-error.png
Logs: [Pasted console output]
Error: "500 Internal Server Error: Cannot read property 'id' of null"

[Phase 3: Classify Severity]
Suggested: S2 - Major (Feature broken, workaround difficult)
Accept? [y] y

[Phase 4: Generate Report]
Bug reported successfully!
Created: qa-agent-os/features/payment-gateway/PAY-456/bugs/BUG-001.md
```

### Example 2: Direct Mode Bug Report

```
/report-bug --title "Login - Session timeout incorrect" --severity S3

[Phase 0: Context Detection]
Found feature: User-Authentication
Ticket: AUTH-789
Bug ID assigned: BUG-003

[Phase 1: Validate Parameters]
Title: "Login - Session timeout incorrect"
Severity: S3 (provided)

[Quick prompts for missing details...]

[Phase 4: Generate Report]
Bug reported successfully!
Created: qa-agent-os/features/user-authentication/AUTH-789/bugs/BUG-003.md
```

## Severity Classification

The command uses these severity levels:

| Level | Name | Criteria |
|-------|------|----------|
| S1 | Critical | Data loss, security, crash, payment broken, no workaround |
| S2 | Major | Feature broken, wrong calculations, difficult workaround |
| S3 | Minor | UI issues, incorrect messages, easy workaround |
| S4 | Trivial | Cosmetic, typos, minimal impact |

## Related Commands

- `/revise-bug` - Update existing bug reports with new evidence or status changes
- `/plan-ticket` - Create ticket structure before reporting bugs
- `/plan-feature` - Create feature structure for new features
- `/generate-testcases` - Generate test cases from test plans

## Standards Applied

Bug reports follow these standards:
- `@qa-agent-os/standards/bugs/severity-rules.md` - Severity classification criteria
- `@qa-agent-os/standards/bugs/bug-template.md` - Report structure and fields
- `@qa-agent-os/standards/bugs/bug-reporting-standard.md` - Workflow guidelines
- `@qa-agent-os/standards/bugs/bug-analysis.md` - Analysis methodology

---

*Report bugs efficiently with AI assistance. Use `/revise-bug` to update reports as issues progress through the lifecycle.*
