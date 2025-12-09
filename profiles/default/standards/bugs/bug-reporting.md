# Bug Reporting Standard

This standard defines bug report structure, severity classification, analysis methodology, and workflow. It replaces: bug-report-template.md, bug-template.md, severity-rules.md, bug-reporting-standard.md, and bug-analysis.md.

---

## Feature-Level Organization

Bugs are organized at the **feature level** rather than the ticket level, enabling tracking of bugs that affect multiple tickets or the feature as a whole.

### Folder Structure

```
qa-agent-os/features/[feature-name]/bugs/
├── BUG-001-[short-title]/
│   ├── bug-report.md
│   ├── screenshots/
│   ├── logs/
│   ├── videos/
│   └── artifacts/
├── BUG-002-[short-title]/
│   ├── bug-report.md
│   ├── screenshots/
│   ├── logs/
│   ├── videos/
│   └── artifacts/
└── BUG-003-[short-title]/
    ├── bug-report.md
    ├── screenshots/
    ├── logs/
    ├── videos/
    └── artifacts/
```

### Benefits of Feature-Level Organization

- **Multi-Ticket Bugs**: Track bugs affecting multiple tickets without duplication
- **Organized Evidence**: Semantic subfolders (screenshots/, logs/, videos/, artifacts/) make evidence discovery quick
- **Stable References**: BUG-001 remains constant; Jira ID stored separately as metadata
- **Feature Clarity**: All bugs visible at feature level alongside testing and feature knowledge
- **Better Investigation**: Structured evidence organization reduces time to root cause

---

## Bug ID Format

### Auto-Incremented Sequential IDs

Bug IDs are auto-incremented per feature using zero-padded 3-digit format:

- **Format:** `BUG-XXX` (where XXX is zero-padded to 3 digits)
- **Examples:** BUG-001, BUG-002, BUG-042, BUG-999
- **Scope:** Feature-level (each feature has its own BUG-001, BUG-002, etc.)
- **Stability:** IDs are permanent and never change after folder creation
- **Auto-Increment:** System automatically generates next ID based on highest existing number

### Folder Naming Convention

Bug folder names combine the auto-incremented ID with a short title:

- **Format:** `BUG-00X-[short-title]`
- **Short Title:** Derived from bug summary, URL-friendly (lowercase, hyphens, alphanumeric only)
- **Length:** 20-40 characters recommended for short-title
- **Examples:**
  - `BUG-001-login-form-validation-error`
  - `BUG-002-checkout-payment-timeout`
  - `BUG-003-currency-conversion-error`

---

## Supporting Materials Organization

Supporting materials are organized into semantic subfolders within each bug folder for easy discovery and categorization.

### Subfolder Types and Content

**screenshots/** - Visual evidence (PNG, JPG, GIF)
- Screenshots showing visual representation of bug
- Annotated screenshots highlighting the issue
- Multiple angles or states of UI
- Examples: `form-validation-message.png`, `error-state-highlighted.png`

**logs/** - Text diagnostic output (TXT, LOG)
- Browser console output
- Server/backend error logs
- Application logs
- Database logs
- Stack traces
- Examples: `browser-console-2025-12-08.log`, `backend-error-trace.txt`

**videos/** - Screen recordings (MP4, MOV, WebM, AVI)
- Screen recordings demonstrating repro steps
- Video showing bug behavior in action
- Slow-motion recordings for timing-sensitive bugs
- Examples: `checkout-flow-repro.mp4`, `login-timeout-recording.webm`

**artifacts/** - Complex files and data (HAR, JSON, SQL, XML, CSV, configs)
- Network traces (HAR files)
- Request/response payloads (JSON)
- Database queries and dumps (SQL)
- Configuration exports
- Export from browser dev tools
- Examples: `network-trace-failed-request.har`, `request-payload.json`, `database-transaction-log.sql`

### File Organization Best Practices

- Use descriptive filenames with timestamps when relevant
- Include timestamps in filename for logs: `error-2025-12-08-14-30.log`
- Keep filenames URL-friendly (no special characters)
- Group related files in same subfolder
- Subfolders can remain empty if no materials of that type

---

## Document Structure

### Metadata

| Field | Value | Rules |
|-------|-------|-------|
| Bug ID | BUG-XXX | Auto-increment per feature |
| Feature | [name] | Parent feature name |
| Ticket | [id] | Ticket(s) this bug affects (comma-separated if multiple) |
| Jira_ID | [id] | External Jira ticket ID (optional, filled when approved) |
| Created | [timestamp] | Date/time in ISO format (YYYY-MM-DD HH:MM:SS) |
| Updated | [timestamp] | Last update timestamp |
| Version | 1.0 | Increment with revisions (major for status changes, minor for updates) |
| Status | Open | See workflow below |

### Bug Details

**Title:** `[Component] - [Brief Summary]`
- Max 100 chars, include component, be specific

**Summary:** 2-3 sentence executive overview
- What's broken, who's affected, impact, reproducibility

**Environment:**
- OS, Browser/Device, Environment (Dev/Staging/Prod)
- Build/Version, Feature Flags

**Component/Area:** Module or service impacted

### Reproduction

**Preconditions:** State required before bug occurs

**Steps to Reproduce:** Numbered steps with specific data
```
1. Navigate to /page
2. Enter value: [specific value]
3. Click button
   -> Observe intermediate response
4. See error
```

**Expected Result:** What should happen per requirements

**Actual Result:** What happened, exact error messages

**Reproducibility:** Always / Intermittent (X/Y attempts, conditions)

### Classification

**Severity:** S1-Critical / S2-Major / S3-Minor / S4-Trivial
**Priority:** P1 / P2 / P3 / P4
**Justification:** Why this level was assigned

**AI Suggestion (if using /report-bug):**
- AI Suggested Severity, Justification
- User Decision (Accepted/Overridden), Override Reason

### Evidence

- **Attachments:** List of supporting materials with descriptions
  - Format: `- [subfolder]/[filename] - [description]`
  - Example: `- screenshots/form-validation-message.png - Validation error displayed to user`
  - Example: `- logs/browser-console-2025-12-08.log - JavaScript error context`
  - Example: `- videos/checkout-flow-repro.mp4 - Complete repro steps recorded`
  - Example: `- artifacts/network-trace-failed-request.har - Network trace showing failed payment request`

### Analysis

**Root Cause Hypothesis:** Suspected component/function/condition

**Affected Areas:** Other features/users/systems impacted

**Related Items:**
| Type | ID | Description |
|------|----|----|
| Requirement | REQ-XX | Related requirement |
| Test Case | TC-XX | Test that found bug |
| Related Bug | BUG-XX | Similar bugs |

### Status Workflow

**Current Status:** [from metadata]

**Status History:**
| Status | Date | Updated By | Notes |
|--------|------|------------|-------|
| Open | [date] | [reporter] | Initial report |

**Valid Statuses:** Open → In Progress → Approved → Resolved → Closed (or Re-opened)

### Ownership

| Role | Assignee |
|------|----------|
| Reporter | [name] |
| Assignee | [dev] |
| QA Verifier | [qa] |

### Developer Notes

Reserved for root cause analysis, fix approach, implementation notes

### Revision Log

Tracks all changes to the bug report with version increments:

| Date | Version | Change Type | Details |
|------|---------|-------------|---------|
| 2025-12-08 10:00:00 | 1.0 | Initial Report | Bug created, Severity: S2, Status: Open |
| 2025-12-08 14:30:00 | 1.1 | Evidence Added | Added network trace and error logs |
| 2025-12-09 09:00:00 | 2.0 | Status Updated | Status changed to Approved, Jira ID: BUG-12345 |

**Version Numbering Rules:**
- Increment major (X.0) for: Status changes to Approved/Resolved/Closed, or major severity changes
- Increment minor (X.Y) for: Evidence additions, notes, description updates, severity clarifications

### References

- Feature Knowledge: `../feature-knowledge.md`
- Feature Test Strategy: `../feature-test-strategy.md`
- Test Plan: `../[ticket-id]/test-plan.md`
- Test Cases: `../[ticket-id]/test-cases.md`

---

## Severity Classification

### S1 - Critical
**Impact:** System failure, no workaround

**Criteria:**
- Data loss/corruption
- Security vulnerability
- System crash/unavailability
- Payment broken
- No workaround
- Regulatory breach

**Examples:** Passwords in logs, app crashes for all users, double-charging payments

### S2 - Major
**Impact:** Feature broken, difficult workaround

**Criteria:**
- Core functionality broken
- Wrong calculations/data
- API returns incorrect data
- Significant performance degradation
- Feature works but incorrect output

**Examples:** Search returns wrong results, calculations missing tax, 30s page load

### S3 - Minor
**Impact:** UI issues, easy workaround

**Criteria:**
- UI misalignment
- Incorrect messages/labels
- Non-blocking accessibility
- Limited impact, easy workaround

**Examples:** Truncated button text, wrong date format, tooltip mispositioned

### S4 - Trivial
**Impact:** Cosmetic, no functional effect

**Criteria:**
- Typos
- Minor visual inconsistencies
- Pixel alignment
- No functional impact

**Examples:** Spelling errors, 2px off-center, wrong hover color

## AI Classification Checklist

**Step 1:** Check S1 indicators (data loss, security, crash, payment, no workaround, compliance) → If YES: S1

**Step 2:** Check S2 indicators (feature broken, wrong data, severe performance) → If YES: S2

**Step 3:** Check S3 indicators (UI issues, incorrect labels, easy workaround) → If YES: S3

**Step 4:** Default to S4

**Justification must include:**
1. Which checklist item matched
2. Evidence from bug description
3. Impact assessment
4. Workaround availability

## Bug Analysis Method

**Step 1: Reproduce**
- Can you reproduce with provided steps?
- Variations tried?
- Reproducibility rate?

**Step 2: Isolate Cause**
- Which component responsible?
- Frontend/backend/data issue?
- Relevant logs/errors?
- Feature flags, configs, deployments?

**Step 3: Determine Scope**
- All users or segments?
- Regression?
- Impacted releases/environments?

**Step 4: Assess Severity**
- Apply classification rules
- Recommend priority
- Document justification

**Analysis Output:**
```
### Bug Analysis: [Title]
**Reproduction Status:** Reproduced / Not Reproduced
**Root Cause Hypothesis:** [Brief explanation]
**Affected Components:** [files/modules]
**Severity:** S1/S2/S3/S4
**Priority Recommendation:** P1-P4 + rationale
**Proposed Fix:** [approach]
**Observability:** [links]
```

## Evidence Guidelines

**UI Issues:** Annotated screenshots/recordings, full browser context

**API Issues:** Request/response payloads, timestamps, request IDs, HAR files

**Backend Issues:** Log entries with correlation IDs, stack traces

**Performance Issues:** Timing measurements, before/after metrics, profiler output

**Always:** Redact PII/secrets, store in semantic subfolders (screenshots/, logs/, videos/, artifacts/), reference by path

## Severity vs Priority

**Severity = Impact** (how bad)
**Priority = Urgency** (how soon)

Examples:
- Critical behind flag: S1/P3 (severe but not affecting users)
- Typo on homepage: S4/P1 (trivial but high visibility)
- Major in rare report: S2/P3 (significant but limited exposure)

## SLA Guidelines

| Severity | Response | Resolution | Actions |
|----------|----------|------------|---------|
| S1 | Immediate | Before release | Page on-call, incident response |
| S2 | 4 hours | Current sprint | Regression evidence required |
| S3 | 24 hours | Backlog | Document rationale |
| S4 | 48 hours | Low priority | May defer |

---

*Single source of truth for bug reporting - structure, rules, analysis, workflow in one place. Feature-level organization enables tracking bugs that span multiple tickets while maintaining organized evidence collection.*
