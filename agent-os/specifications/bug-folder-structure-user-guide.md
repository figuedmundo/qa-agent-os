# Bug Folder Structure User Guide

A comprehensive guide for QA engineers on using feature-level bug organization in QA Agent OS.

## Overview

QA Agent OS organizes bugs at the **feature level** instead of the ticket level, providing a cleaner structure that enables cross-ticket bug tracking and organized supporting materials (evidence).

**Key Benefits:**
- One bug location for issues affecting multiple tickets
- Auto-incremented bug IDs for easy reference
- Organized evidence with semantic subfolders
- Full version history and revision tracking
- Cross-ticket references and bidirectional traceability

## Folder Structure

### Feature-Level Organization

Bugs are stored at the feature level, making them accessible to all related tickets:

```
qa-agent-os/features/[feature-name]/
├── bugs/
│   ├── BUG-001-checkout-fails/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   │   ├── form-state.png
│   │   │   └── error-message.png
│   │   ├── logs/
│   │   │   ├── console.log
│   │   │   └── server.log
│   │   ├── videos/
│   │   │   └── checkout-flow.mp4
│   │   └── artifacts/
│   │       └── network-trace.har
│   ├── BUG-002-currency-calculation/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   └── logs/
│   └── BUG-003-timeout-error/
│       ├── bug-report.md
│       └── screenshots/
├── feature-knowledge.md
├── feature-test-strategy.md
├── TICKET-001/
│   ├── test-plan.md
│   └── test-cases.md
└── TICKET-002/
    ├── test-plan.md
    └── test-cases.md
```

### Naming Conventions

**Bug Folder Names:**
- Format: `BUG-XXX-[kebab-case-title]`
- Example: `BUG-001-login-button-unresponsive`
- ID Range: Auto-incremented per feature starting at 001
- Title: Sanitized from bug report title

**Feature Folder Names:**
- Format: `[feature-name]` (lowercase, kebab-case)
- Example: `user-authentication`, `payment-gateway`

**Ticket Folder Names:**
- Format: `[TICKET-ID]` (uppercase with number)
- Example: `AUTH-125`, `PAY-456`

## Bug ID Format

### Auto-Increment Logic

Bug IDs are automatically generated based on existing bugs in the feature:

1. **First Bug in Feature:** `BUG-001`
2. **Second Bug:** `BUG-002`
3. **Third Bug:** `BUG-003` (and so on)

### Per-Feature Scoping

IDs are scoped to each feature independently:
- Feature A bugs: BUG-001, BUG-002, BUG-003
- Feature B bugs: BUG-001, BUG-002 (independent numbering)
- No cross-feature collisions

### Stable Folder Names

Once a bug is created with ID `BUG-001`, the folder name remains stable:
- Can reference it consistently across documentation
- Safe to link to from tickets and other bugs
- ID never changes, even if earlier bugs are deleted

## Using /report-bug Command

### Quick Start

```bash
# Navigate to feature directory
cd qa-agent-os/features/payment-gateway/

# Run report-bug command
/report-bug

# Answer prompts:
# 1. Title: "Checkout submit button fails"
# 2. Description: "The submit button doesn't respond to clicks"
# 3. Environment: "Chrome 120, Windows 11"
# 4. Severity: "HIGH"
# 5. Evidence: Select and add evidence files (screenshots, logs, etc.)
```

### Command Workflow

1. **Feature Context Detection**
   - Auto-detects feature from current directory
   - Validates feature exists
   - Scans for existing bugs to determine next ID

2. **Generate Bug ID**
   - Looks for highest existing BUG-XXX folder
   - Increments by 1 for next bug ID
   - Creates folder: `bugs/BUG-XXX-[sanitized-title]/`

3. **Collect Bug Details**
   - Title (required): Brief description of bug
   - Description (required): Detailed problem description
   - Environment (required): Where bug occurs (browser, OS, etc.)
   - Severity (required): CRITICAL, HIGH, MEDIUM, LOW
   - Ticket (optional): Related ticket IDs (comma-separated)
   - Jira ID (optional): External tracking ID

4. **Organize Evidence**
   - Screenshots: User interface state, error messages
   - Logs: Console, server, network logs
   - Videos: Reproduction steps, behavior recording
   - Artifacts: Network traces, database exports, config files

5. **Generate Bug Report**
   - Creates `bug-report.md` with all information
   - Sets initial status: OPEN
   - Creates semantic subfolders for evidence
   - Organizes files by type

### Example Bug Report

```markdown
# Bug Report: BUG-001 - Checkout Submit Button Fails

## Status
- Current: OPEN
- Last Updated: 2025-12-10

## Bug Details
- ID: BUG-001
- Title: Checkout submit button fails
- Severity: HIGH
- Description: When clicking the "Complete Purchase" button on the checkout page, nothing happens. The button appears to be disabled or not responding to clicks.
- Environment: Chrome 120, Windows 11, Latest app version
- Ticket: PAY-456
- Jira_ID: JIRA-1234

## Evidence

### Screenshots
- form-state.png - Checkout form before clicking submit
- error-state.png - Form after failed submission attempt
- button-inspect.png - Browser inspector showing button element

### Logs
- console.log - Browser console output during reproduction
- network.log - Network requests during issue
- server.log - Backend logs from same timestamp

### Videos
- checkout-flow.mp4 - Video showing reproduction steps

### Artifacts
- network-trace.har - Full network trace
- page-source.html - Page HTML at time of issue

## Revision Log

| Version | Date | Change | Type |
|---------|------|--------|------|
| 1.0 | 2025-12-10 | Initial report | CREATED |
```

## Using /revise-bug Command

### Quick Start

```bash
# Navigate to feature directory
cd qa-agent-os/features/payment-gateway/

# Run revise-bug command
/revise-bug

# Select bug from interactive menu:
# [1] BUG-001 - Checkout submit button fails (OPEN)
# [2] BUG-002 - Currency calculation error (IN_REVIEW)

# Choose revision type:
# [1] Add/update evidence
# [2] Change severity
# [3] Change status
# [4] Add/update notes
# [5] Update ticket reference
# [6] Update Jira ID
# [7] View revision history
```

### Revision Types

#### 1. Add/Update Evidence
Add new screenshots, logs, videos, or artifacts to an existing bug:

**Process:**
1. Select evidence type: screenshots, logs, videos, artifacts
2. Provide evidence files
3. Add description of evidence
4. Files automatically organized into semantic subfolders
5. Revision log updated with timestamp

**Example:** After finding the root cause, add server logs showing error

#### 2. Change Severity
Update bug severity as new information emerges:

**Severity Levels:**
- CRITICAL: Blocks critical functionality, affects production
- HIGH: Major functionality broken, significant user impact
- MEDIUM: Feature partially broken, workaround exists
- LOW: Minor issue, cosmetic or edge case

**Example:** Initially reported as HIGH, investigation shows it's CRITICAL

#### 3. Change Status
Track bug lifecycle through workflow:

**Status Progression:**
- OPEN: Initial state, needs investigation
- IN_REVIEW: Being analyzed and reproduced
- VERIFIED: Confirmed, assigned to engineering
- RESOLVED: Fixed in code, awaiting deployment
- CLOSED: Deployed and verified in production

**Example:** After developer marks as fixed, change status to RESOLVED

#### 4. Add/Update Notes
Update bug description or environment details:

**Descriptions:**
- Additional reproduction steps discovered
- Root cause analysis
- Workarounds identified
- Environment clarifications

**Example:** Add detailed root cause: "Issue is in payment gateway timeout handling"

#### 5. Update Ticket Reference
Add or change the Ticket field to reference related tickets:

**Usage:**
- Link to ticket that reported the bug
- Reference multiple tickets if bug affects them
- Update if initial ticket was wrong

**Format:** Comma-separated ticket IDs
**Example:** `PAY-456, PAY-457` (two payment tickets)

#### 6. Update Jira ID
Add or change external issue tracking ID:

**Usage:**
- Track bug in external systems
- Link to Jira, Azure DevOps, or other tools
- Update if initial ID was wrong

**Example:** Update from `JIRA-1234` to `JIRA-1234,JIRA-5678`

#### 7. View Revision History
Display full history of changes:

Shows all revisions with:
- Version number
- Date/timestamp
- Change description
- Change type
- Metadata

## Supporting Materials Organization

### Evidence Types and Subfolders

#### Screenshots/ Subfolder
For visual evidence of the bug:
- Error messages displayed to user
- Form state before/after bug occurs
- Button/UI element states
- Browser/application windows
- File formats: PNG, JPG, GIF

**Example Files:**
```
screenshots/
├── form-state-before.png
├── error-dialog.png
├── button-disabled.png
└── full-page.png
```

#### Logs/ Subfolder
For system and application logs:
- Browser console logs (JavaScript errors)
- Server application logs
- API request/response logs
- Network traffic logs
- System event logs
- File formats: TXT, LOG, JSON

**Example Files:**
```
logs/
├── console.log
├── server-app.log
├── api-calls.log
└── network-trace.txt
```

#### Videos/ Subfolder
For video evidence:
- Screen recording of bug reproduction
- User interaction flow
- Error behavior demonstration
- Performance issues visualization
- File formats: MP4, MOV, AVI, WebM

**Example Files:**
```
videos/
├── bug-reproduction.mp4
├── full-flow.mp4
└── slow-response.webm
```

#### Artifacts/ Subfolder
For miscellaneous supporting materials:
- Network traffic dumps (HAR files)
- Database exports/queries
- Configuration files
- Memory dumps
- Other technical artifacts
- File formats: HAR, SQL, JSON, XML, dumps, etc.

**Example Files:**
```
artifacts/
├── network-trace.har
├── database-query.sql
├── config-snapshot.json
└── memory-dump.bin
```

### Best Practices

**Do's:**
- Use clear, descriptive filenames
- Include relevant context in filenames (e.g., `login-form-error.png`, not `screenshot1.png`)
- Use semantic subfolder organization
- Keep file sizes reasonable (compress images/videos)
- Add descriptions when evidence isn't self-explanatory

**Don'ts:**
- Don't use timestamps or random IDs in filenames
- Don't mix different evidence types in one folder
- Don't upload unrelated files
- Don't upload extremely large files without compression
- Don't store sensitive data (passwords, API keys) in evidence

## Ticket Field Usage

### Purpose

The optional Ticket field enables cross-ticket references:
- Link bugs to related tickets
- Show which tickets are affected
- Maintain bidirectional traceability
- Enable cross-feature impact analysis

### Single Ticket Reference

Use when bug affects one ticket:

```markdown
# Bug Report: BUG-001 - Login Timeout

## Bug Details
- Ticket: AUTH-125
```

### Multiple Ticket References

Use comma-separated format when bug affects multiple tickets:

```markdown
# Bug Report: BUG-002 - Currency Conversion Error

## Bug Details
- Ticket: PAY-456, PAY-457, PAY-458
```

### Bidirectional Linking

**In Bug Report:** Reference ticket(s) in Ticket field
**In Test Cases:** Reference bug(s) in Defects field

```markdown
# Test Case 1: TC-001 - Process International Payment

- **Defects:** BUG-002 (Currency conversion fails)
```

### No Ticket Required

Bugs don't require ticket references:
- General bugs not tied to specific ticket
- Cross-cutting issues
- Environment/infrastructure bugs

```markdown
# Bug Report: BUG-003 - Database Connection Pool

## Bug Details
- Ticket: (none - infrastructure bug)
```

## Jira Integration

### Optional Jira_ID Field

Link QA Agent OS bugs to external issue tracking:

```markdown
# Bug Report: BUG-001 - Checkout Submit Fails

## Bug Details
- Jira_ID: JIRA-1234
```

### Workflow Integration

1. **Create Bug in QA Agent OS**
   - Use `/report-bug` command
   - Set severity and details
   - Generate initial report

2. **Create Jira Issue (Manual)**
   - Create corresponding Jira issue
   - Copy details from bug-report.md
   - Get Jira issue ID (e.g., JIRA-1234)

3. **Update Bug Report**
   - Use `/revise-bug` command
   - Choose: Update Jira ID
   - Enter Jira issue ID

4. **Link Both Ways**
   - Jira issue → links to QA Agent OS repo
   - Bug report → includes Jira ID
   - Bidirectional reference

### No External Tool Required

Jira integration is optional:
- Use QA Agent OS standalone
- Or integrate with Jira for external tracking
- Your choice based on team workflow

## Status Workflow

### Bug Lifecycle

```
OPEN
  ↓ (Being investigated)
IN_REVIEW
  ↓ (Reproduced and confirmed)
VERIFIED
  ↓ (Assigned to engineering)
RESOLVED
  ↓ (Fixed and deployed)
CLOSED
```

### Status Definitions

**OPEN (Initial)**
- Bug just reported
- Awaiting initial investigation
- QA engineer reviewing evidence

**IN_REVIEW**
- Being actively investigated
- Reproducing the issue
- Collecting additional evidence
- Analysis in progress

**VERIFIED**
- Bug confirmed and reproduced
- Root cause identified
- Assigned to engineering team
- Awaiting fix

**RESOLVED**
- Engineering fix deployed
- Change merged to main
- Waiting for validation testing

**CLOSED**
- Fix verified in production
- No further action needed
- Bug resolved and validated

### Example Workflow

```bash
# Initial report
/report-bug
# → Creates BUG-001, Status: OPEN

# Update after investigation
/revise-bug
# → Choose: Change status
# → New status: IN_REVIEW

# After reproducing
/revise-bug
# → Choose: Change status
# → New status: VERIFIED
# → Add: Ticket reference (e.g., DEV-123)

# After fix deployed
/revise-bug
# → Choose: Change status
# → New status: RESOLVED

# After validation
/revise-bug
# → Choose: Change status
# → New status: CLOSED
```

## Example Workflow

### Scenario: Testing Payment Feature

#### Step 1: Report Bug During Testing

```bash
cd qa-agent-os/features/payment-gateway/
/report-bug
```

**Inputs:**
```
Title: Checkout submit button fails
Description: When attempting to complete a purchase, the submit button does not respond. Button appears disabled but is not grayed out.
Environment: Chrome 120, Windows 11, production environment
Severity: HIGH
Ticket: PAY-456 (Optional: Add ticket reference)
```

**Output:**
```
Created: bugs/BUG-001-checkout-submit-button-fails/
Files:
  - bug-report.md (Status: OPEN)
  - screenshots/ (for evidence)
  - logs/ (for evidence)
  - videos/ (for evidence)
  - artifacts/ (for evidence)
```

#### Step 2: Add Evidence

```bash
cd qa-agent-os/features/payment-gateway/bugs/BUG-001-checkout-submit-button-fails/
/revise-bug
```

**Select:** BUG-001
**Choose:** [1] Add/update evidence

**Add:**
- screenshot: form-state.png
- screenshot: error-dialog.png
- log file: console.log (JavaScript errors)

**Files organized:**
```
screenshots/
├── form-state.png
└── error-dialog.png
logs/
└── console.log
```

#### Step 3: Update Status After Investigation

```bash
/revise-bug
```

**Select:** BUG-001
**Choose:** [3] Change status

**Update:** OPEN → IN_REVIEW (under investigation)

#### Step 4: Add Root Cause Notes

```bash
/revise-bug
```

**Select:** BUG-001
**Choose:** [4] Add/update notes

**Add:** "Root cause: Payment gateway timeout when processing international transactions. Button does not properly handle timeout error."

#### Step 5: Mark as Verified

```bash
/revise-bug
```

**Select:** BUG-001
**Choose:** [3] Change status

**Update:** IN_REVIEW → VERIFIED (ready for engineering)

#### Step 6: Final Close

After engineer fixes and deploys:

```bash
/revise-bug
```

**Select:** BUG-001
**Choose:** [3] Change status

**Update:** VERIFIED → RESOLVED → CLOSED

### Final Bug Report

```markdown
# Bug Report: BUG-001 - Checkout Submit Button Fails

## Status
- Current: CLOSED
- Last Updated: 2025-12-10

## Bug Details
- ID: BUG-001
- Title: Checkout submit button fails
- Severity: HIGH
- Description: When attempting to complete a purchase, the submit button does not respond. Button appears disabled but is not grayed out.
- Environment: Chrome 120, Windows 11, production environment
- Ticket: PAY-456
- Jira_ID: JIRA-1234

## Evidence

### Screenshots
- form-state.png - Checkout form showing button state
- error-dialog.png - Error shown when clicked

### Logs
- console.log - JavaScript errors in console

## Revision Log

| Version | Date | Change | Type |
|---------|------|--------|------|
| 1.0 | 2025-12-10 | Initial report | CREATED |
| 1.1 | 2025-12-10 | Added evidence | EVIDENCE |
| 1.2 | 2025-12-10 | Changed status to IN_REVIEW | STATUS |
| 1.3 | 2025-12-10 | Root cause identified | NOTES |
| 1.4 | 2025-12-10 | Changed status to VERIFIED | STATUS |
| 1.5 | 2025-12-11 | Changed status to RESOLVED | STATUS |
| 1.6 | 2025-12-11 | Changed status to CLOSED | STATUS |
```

## Troubleshooting

### "Bug folder not found"

**Cause:** You're not in a feature directory or feature doesn't exist

**Solution:**
1. Navigate to feature directory: `cd qa-agent-os/features/[feature-name]/`
2. Verify feature exists: `ls qa-agent-os/features/`
3. Create feature if needed: `/start-feature`

### "Cannot determine next bug ID"

**Cause:** Corrupted bug folders or invalid naming

**Solution:**
1. Check bug folder names: `ls bugs/`
2. Folders should be named: `BUG-001-title`, `BUG-002-title`
3. Rename or delete invalid folders
4. Try command again

### "Ticket reference not updating"

**Cause:** Formatting issue or ambiguous selection

**Solution:**
1. Use comma-separated format: `PAY-456, PAY-457`
2. No spaces around commas
3. Use uppercase ticket IDs
4. Try command again

### "Evidence not organizing properly"

**Cause:** File type not recognized or extension incorrect

**Solution:**
1. Check file extensions match type (e.g., .png for images)
2. Supported: PNG, JPG, GIF (screenshots), LOG, TXT, JSON (logs), MP4, MOV, AVI (videos)
3. Move files manually if needed
4. Organize into correct subfolder

### "Bug-report.md missing or corrupted"

**Cause:** File was deleted or corrupted during process

**Solution:**
1. Regenerate bug report: `/revise-bug` → View all fields
2. Or manually restore from backup if available
3. Critical data in revision log still present
4. Recreate if necessary

## Best Practices

### 1. Report Bugs Promptly
- Create bug as soon as discovered
- Include initial observations
- Add evidence immediately while fresh

### 2. Use Clear Titles
- Describe the problem, not the impact
- Good: "Login button unresponsive"
- Bad: "System doesn't work"

### 3. Set Appropriate Severity
- CRITICAL: User can't complete main task
- HIGH: Major feature broken
- MEDIUM: Feature partially broken
- LOW: Minor issue, edge case

### 4. Reference Tickets
- Link bugs to affected tickets
- Helps engineers understand scope
- Enables traceability

### 5. Organize Evidence
- Screenshot: Show exact state
- Log: Include relevant errors only
- Video: Show reproduction steps
- Be concise but complete

### 6. Update Status Regularly
- Move through workflow as investigation progresses
- Keep team informed
- Helps engineering prioritize

### 7. Document Root Cause
- Add notes when root cause identified
- Helps prevent future occurrences
- Valuable for knowledge base

## Summary

Feature-level bug organization provides:
- Clear folder structure at `features/[feature]/bugs/`
- Auto-incremented bug IDs (BUG-001, BUG-002, etc.)
- Organized evidence (screenshots/, logs/, videos/, artifacts/)
- Cross-ticket references via Ticket field
- Full revision history and version tracking
- Integration with external tools (Jira) optional
- Simple commands: `/report-bug` and `/revise-bug`

This guide covered everything needed to use the feature effectively. Happy bug hunting!

For detailed technical architecture, see: `integration-guide.md`
For command reference, see: `QA-QUICKSTART.md`
For standards, see: `qa-agent-os/standards/bugs/bug-reporting.md`
