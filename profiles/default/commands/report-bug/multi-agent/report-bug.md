# /report-bug Command (Multi-Agent Mode)

## Purpose

Report bugs discovered during testing with AI-assisted severity classification, guided evidence collection, and structured documentation using specialized agents.

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

## Execution Flow

### PHASE 0: Context Detection

This phase handles context detection and routing. Orchestration logic remains in the main command:

#### Step 1: Detect Feature

Check for existing features in `qa-agent-os/features/` directory.

```bash
# Scan for existing features
FEATURES=$(find qa-agent-os/features/ -maxdepth 1 -type d)
```

**If multiple features found**, present selection:

```
Which feature are you reporting a bug for?

Features found:
  [1] Feature-Name-1
  [2] Feature-Name-2

Select [1-N]:
```

**If only ONE feature exists** -> Auto-select and confirm with user:

```
Found feature: [feature-name]. Is this correct? [y/n]
```

**If NO features exist** -> Display error and exit:

```
Error: No features found. Please create a feature first:
  /plan-feature [feature-name]
Then return to report the bug.
```

#### Step 2: Detect Ticket

Within the selected feature, scan for existing tickets.

```bash
# Find ticket directories within feature
TICKETS=$(find qa-agent-os/features/[feature-name]/ -maxdepth 1 -type d -name "[A-Z]*-*")
```

**If multiple tickets found**, present selection:

```
Which ticket does this bug relate to?

Tickets found:
  [1] WYX-123
  [2] WYX-124

Select [1-N]:
```

**If only ONE ticket exists** -> Auto-select and confirm with user.

**If NO tickets exist** -> Display error and exit:

```
Error: No tickets found for feature [feature-name].
Please create a ticket first:
  /plan-ticket [ticket-id]
Then return to report the bug.
```

#### Step 3: Initialize Bug Context

```bash
# Create bugs directory if it doesn't exist
mkdir -p qa-agent-os/features/[feature-name]/[ticket-id]/bugs/

# Determine next bug ID by scanning existing BUG-*.md files
EXISTING_BUGS=$(ls qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-*.md 2>/dev/null | wc -l)
NEXT_BUG_NUM=$((EXISTING_BUGS + 1))
BUG_ID=$(printf "BUG-%03d" $NEXT_BUG_NUM)
```

Set variables for next phases:
- `FEATURE_NAME` - Selected feature name
- `TICKET_ID` - Selected ticket ID
- `TICKET_PATH` - Full path: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- `BUG_ID` - Auto-generated bug ID (BUG-001, BUG-002, etc.)
- `BUG_PATH` - Full path: `[ticket-path]/bugs/[bug-id].md`

### PHASE 1: Collect Bug Details

This phase collects bug information. Orchestration logic remains in the main command:

#### Detect Mode

Check if parameters were provided with the command.

**If Direct Mode** (parameters provided):

Parse and validate parameters:
- Extract `--title`, `--severity`, `--steps`, `--expected`, `--actual`, `--environment`, `--component`
- Validate required field: `--title`
- Prompt for any missing critical details

**If Interactive Mode** (no parameters):

Present guided questionnaire:

```
=== Bug Details ===

Bug Title (format: [Component] - Brief description):
> [Checkout] - Submit fails with 500 error

Environment:
  Operating System:
  > macOS 14.1
  Browser/Device:
  > Chrome 120
  Environment (Dev/Staging/Prod):
  > Staging
  Build/Version:
  > v2.5.1 (commit abc123)
  Feature Flags:
  > payments_v2=ON

Component/Area affected:
> Payment Processing

Preconditions (state before bug):
> User logged in, items in cart

Steps to Reproduce:
  Step 1: > Navigate to /checkout
  Step 2: > Enter valid payment details
  Step 3: > Click "Submit Order"
  (Enter blank line when done)

Expected Result:
> Order confirmation page displays

Actual Result:
> 500 Internal Server Error appears

Reproducibility:
  Rate (Always/Intermittent): > Always
  Attempts: > 5 out of 5
```

Store collected details in `BUG_DETAILS` variable.

### PHASE 2: Collect Evidence

This phase collects supporting evidence. Orchestration logic remains in the main command:

```
=== Evidence Collection ===

Select evidence types to attach (comma-separated):
  [1] Screenshots/recordings (file path)
  [2] Console/browser logs (file path or paste)
  [3] API request/response (file path or paste)
  [4] Network traces (file path or HAR)
  [5] Error messages (paste text)
  [6] Other evidence

Your selection (e.g., 1,2,5): > 1,2,5
```

**For each selected evidence type**, prompt for content:

```
[1] Screenshots/recordings:
> ./screenshots/checkout-error.png

[2] Console/browser logs:
> [Paste logs or provide file path]

[5] Error messages:
> "500 Internal Server Error: Cannot read property 'id' of null"
```

Store evidence in `EVIDENCE_DETAILS` variable (organized by type).

Validate file paths exist, warn if not found.

### PHASE 3: Severity Classification

Use the **bug-writer** subagent to analyze evidence and suggest severity.

Provide the bug-writer with:
- Bug details from Phase 1
- Evidence collected from Phase 2
- Severity rules reference: `@qa-agent-os/standards/bugs/severity-rules.md`
- Task: Analyze bug and suggest severity classification

The bug-writer will:
- Analyze bug description, evidence, and impact
- Apply severity classification criteria (S1-S4) using the decision checklist
- Generate severity suggestion with justification

Present to user for confirmation:

```
=== Severity Classification ===

AI Analysis:
Based on the evidence provided, this appears to be a [S2 - Major] severity issue.

Justification:
- Core feature completely broken (checkout cannot complete)
- Workaround exists but is difficult (manual order processing)
- No data loss or security impact identified
- Affects all users attempting checkout

Suggested: S2 - Major

Accept suggestion? [y] or override [1-4]:
  [1] S1 - Critical
  [2] S2 - Major
  [3] S3 - Minor
  [4] S4 - Trivial

Your choice: > y
```

Store both AI suggestion and user decision:
- `AI_SUGGESTED_SEVERITY` - AI's recommendation
- `AI_JUSTIFICATION` - Reasoning provided
- `USER_SEVERITY` - Final user decision
- `OVERRIDE_REASON` - If user overrode, why (or N/A)

### PHASE 4: Generate Bug Report

Use the **bug-writer** subagent to generate the complete bug report.

Provide the bug-writer with:
- Feature name: `FEATURE_NAME`
- Ticket ID: `TICKET_ID`
- Bug ID: `BUG_ID`
- Bug path: `BUG_PATH`
- Bug details: `BUG_DETAILS`
- Evidence: `EVIDENCE_DETAILS`
- Severity decision:
  - AI suggested: `AI_SUGGESTED_SEVERITY`
  - AI justification: `AI_JUSTIFICATION`
  - User decision: `USER_SEVERITY`
  - Override reason: `OVERRIDE_REASON`
- Current timestamp: `[TIMESTAMP]`
- Template path: `@qa-agent-os/templates/bug-report-template.md`

The bug-writer will:
- Read bug-report-template.md
- Populate all sections with collected information
- Analyze evidence to infer root cause hypothesis
- Format evidence into structured sections
- Initialize version at 1.0 with revision log
- Set initial status to "New"
- Execute workflow: `workflows/bugs/create-bug-report`
- Save to `[ticket-path]/bugs/BUG-XXX.md`

### Completion

Once all phases complete:

```
Bug reported successfully!

Created: qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-001.md

Summary:
- Bug ID: BUG-001
- Title: [Checkout] - Submit fails with 500 error
- Severity: S2 - Major
- Status: New

NEXT STEPS:
- Review the bug report for accuracy
- Use /revise-bug BUG-001 to add evidence or update status
- Share bug report with development team
```

## Smart Features

This multi-agent command includes:

1. **Context-Aware Reporting** - Auto-detects feature and ticket context
2. **Auto-Incrementing IDs** - BUG-001, BUG-002, etc.
3. **AI Severity Classification** - Evidence-based severity suggestions
4. **Guided Evidence Collection** - Checklist ensures comprehensive reports
5. **Agent Expertise** - Bug-writer agent applies professional QA standards

## Related Commands

- `/revise-bug` - Update existing bug reports
- `/plan-ticket` - Create ticket structure before reporting bugs
- `/plan-feature` - Create feature structure for new features

## Standards Applied

Bug reports follow these standards:
- `@qa-agent-os/standards/bugs/severity-rules.md` - Severity classification criteria
- `@qa-agent-os/standards/bugs/bug-template.md` - Report structure and fields
- `@qa-agent-os/standards/bugs/bug-reporting-standard.md` - Workflow guidelines
- `@qa-agent-os/standards/bugs/bug-analysis.md` - Analysis methodology

---

*This command leverages the bug-writer agent to create professional, well-documented bug reports with AI-assisted severity classification.*
