# QA Standard - Bug Report Template

Use this structure when drafting a bug report. All fields marked with * are required.

---

## Required Fields

| Field | Description | Reference |
|-------|-------------|-----------|
| **ID*** | Bug tracker ID (e.g., BUG-001) + related Requirement/Test Case IDs | - |
| **Title*** | `[Component] - Summary of the issue` | - |
| **Build / Version*** | Commit hash, app version, or API tag | - |
| **Environment*** | OS, Browser/Device, Environment (Dev/Staging/Prod) | - |
| **Feature Flags / Config** | Toggle values, experiments, or N/A | - |
| **Component / Area*** | Module, service, or feature area impacted | - |
| **Severity*** | Impact classification (S1-S4) | `bugs/severity-rules.md` |
| **Priority*** | Urgency classification (P1-P4) | `requirement-analysis/priority-rules.md` |
| **Status*** | Current bug status | See Status Workflow below |
| **Preconditions*** | State required before reproduction | - |
| **Steps to Reproduce*** | Numbered steps with data values | See Steps Format below |
| **Expected Result*** | What should have happened | - |
| **Actual Result*** | What actually happened with error messages | - |
| **Reproducibility*** | Always or Intermittent (e.g., 2/5 attempts) | - |
| **Evidence*** | Screenshots, logs, API traces | `global/evidence-template.md` |
| **Root Cause Hypothesis** | Optional but encouraged analysis | `bugs/bug-analysis.md` |
| **Assignee / Owners** | Developer and QA assignments | - |

---

## AI Severity Suggestion (for /report-bug command)

When using AI-assisted bug reporting, include these tracking fields:

| Field | Description |
|-------|-------------|
| **AI Suggested Severity** | The severity level suggested by AI analysis |
| **AI Justification** | Reasoning for the AI suggestion based on severity-rules.md |
| **User Decision** | Accepted or Overridden to [level] |
| **Override Reason** | If user overrode AI suggestion, document why |

This enables tracking of AI classification accuracy and human judgment patterns.

---

## Status Workflow

**Valid Status Values:**

| Status | Description |
|--------|-------------|
| **New** | Bug newly reported, awaiting triage |
| **In Progress** | Developer actively working on fix |
| **Ready for QA** | Fix complete, awaiting QA verification |
| **Verified** | QA confirmed fix resolves the issue |
| **Closed** | Bug resolved and verified |
| **Re-opened** | Previously closed bug has recurred |

**Workflow Transitions:**

```
New -> In Progress -> Ready for QA -> Verified -> Closed
                                         |
                                         v
                                     Re-opened -> In Progress
```

---

## Steps Format

Numbered list where each step captures:
- **User/system action** - What the user does or system performs
- **Input data** - Specific values used (redacted if sensitive)
- **Observed reaction** - Intermediate system responses if relevant

**Example:**
```
1. Navigate to /checkout
2. Enter card number: 4111-1111-1111-1111
3. Enter expiration: 12/25
4. Click "Submit Order"
   -> Loading spinner appears for 5 seconds
5. Observe error message on screen
```

---

## Evidence Rules

- **UI Issues:** Attach annotated screenshots or screen recordings
- **API Issues:** Include request/response payloads with timestamps
- **Backend Issues:** Include relevant log entries with correlation IDs
- **Performance Issues:** Include timing measurements and thresholds
- **Always:** Redact PII, secrets, or customer identifiers before sharing

Evidence should be stored in `[ticket-path]/bugs/evidence/` and referenced by filename.

---

## Revision Log (for /revise-bug command)

When bugs are updated via `/revise-bug`, include revision entries:

```markdown
**Version X.Y - [DATE] [TIME]**
- Change: [Description of what changed]
- Type: [Update type: evidence, severity, status, reproduction, notes, scope]
- Previous: [Previous value if applicable]
- New: [New value]
- Reason: [Why this update was made]
```

Version numbering:
- Major version (X.0) for significant changes (severity, status)
- Minor version (X.Y) for additions (evidence, notes)

---

## Related Standards

- **Severity Classification:** `bugs/severity-rules.md`
- **Priority Classification:** `requirement-analysis/priority-rules.md`
- **Bug Analysis:** `bugs/bug-analysis.md`
- **Bug Workflow:** `bugs/bug-reporting-standard.md`
- **Evidence Guidelines:** `global/evidence-template.md`

---

*Use bug-report-template.md as the output format when creating bug reports. This standard defines the fields; the template defines the structure.*
