# Bug Report: {{BUG_ID}}

## Metadata

| Field | Value |
|-------|-------|
| Bug ID | {{BUG_ID}} |
| Feature | {{FEATURE_NAME}} |
| Ticket | [TICKET_ID or comma-separated list] |
| Jira_ID | [Optional - populated when approved] |
| Created | {{DATE_CREATED}} |
| Updated | {{DATE_UPDATED}} |
| Version | {{VERSION}} |
| Status | {{STATUS}} |

<!--
METADATA FIELD GUIDE:
- Bug ID: Auto-generated, unique per feature (BUG-001, BUG-002, etc.)
- Feature: Name of the feature this bug affects
- Ticket: The ticket ID(s) being tested when bug was discovered (e.g., TICKET-123 or TICKET-123, TICKET-124)
- Jira_ID: External Jira issue ID (leave empty until bug is approved and exported to Jira)
- Created: Date/time bug was first reported (ISO format: YYYY-MM-DD HH:MM:SS)
- Updated: Date/time of last change to this bug report
- Version: Semantic versioning (1.0 initial, increment minor for updates, major for status changes)
- Status: One of: Open, In Progress, Approved, Resolved, Closed
-->

---

## Bug Details

### Title

[Component] - [Brief Summary]

<!-- Example: "Login Form - Validation error message not displayed" -->

### Summary

[2-3 sentence executive overview: What's broken, who's affected, impact, reproducibility]

<!-- Example: "When users submit the login form with invalid email format, no validation error is displayed. This affects all users attempting login with malformed email addresses. The form submits silently without feedback, causing user confusion. Bug is consistently reproducible on all browsers." -->

### Environment

- OS: [e.g., Windows 10, macOS 14.2, Ubuntu 22.04]
- Browser/Device: [e.g., Chrome 121, Safari 17, Mobile iOS 17.3]
- Environment: [Dev / Staging / Production]
- Build/Version: [e.g., v2.5.1-beta]
- Feature Flags: [Any relevant flags enabled/disabled]

### Component/Area

[Module or service impacted - e.g., "User Authentication", "Payment Processing", "Search Index"]

---

## Reproduction

### Preconditions

[State required before bug can occur]

<!-- Example: "User account exists with valid credentials, user is on login page" -->

### Steps to Reproduce

1. [Specific action with data if applicable]
2. [Next action]
3. [Observable intermediate result]
4. [Final action that triggers bug]

<!-- Example:
1. Navigate to /login
2. Enter email: "invalidemail.com" (missing @)
3. Enter password: "correctpassword"
4. Click "Sign In" button
   -> Form should display validation error
5. Observe that no error message appears
-->

### Expected Result

[What should happen per requirements]

<!-- Example: "A red validation error message should appear below the email field stating 'Please enter a valid email address'" -->

### Actual Result

[What actually happened, including exact error messages]

<!-- Example: "No error message is displayed. The form submits silently and the page reloads with the same login form, with no indication of why login failed." -->

### Reproducibility

[Always / Intermittent - include frequency if intermittent]

<!-- Example: "Always - reproduced on 10/10 attempts across Chrome, Firefox, and Safari" -->

---

## Classification

### Severity

[S1-Critical / S2-Major / S3-Minor / S4-Trivial]

<!-- See bug-reporting standard for detailed criteria:
S1 - Critical: Data loss, security, crash, payment broken, no workaround
S2 - Major: Feature broken, wrong data, difficult workaround
S3 - Minor: UI issues, incorrect labels, easy workaround
S4 - Trivial: Cosmetic, typos, minimal impact
-->

### Priority

[P1 / P2 / P3 / P4]

### Justification

[Why this severity/priority was assigned, include evidence from bug details]

<!-- Example: "S2 - Major because core login functionality is broken (form won't provide validation feedback), difficult workaround requires checking browser console errors, impacts all users with email validation issues" -->

### AI Suggestion (if using /report-bug)

- **AI Suggested Severity:** [S1/S2/S3/S4]
- **AI Justification:** [Brief explanation]
- **User Decision:** [Accepted / Overridden]
- **Override Reason:** [If overridden, explain why]

---

## Evidence

### Attachments

- [subfolder]/[filename] - [Description]

<!-- Examples:
- screenshots/login-form-no-error.png - Login form after submission with no error message
- screenshots/email-field-focused.png - Close-up of email field with invalid format
- logs/browser-console-2025-12-08-10-30.log - Browser console errors during submission
- videos/login-repro-steps.mp4 - Screen recording showing complete reproduction steps
- artifacts/network-trace-login-request.har - Network trace showing API request/response
- artifacts/form-submission-payload.json - Request payload sent during form submission
-->

### Screenshots

[Provide paths or descriptions of visual evidence]

### Logs and Traces

[Provide browser console logs, server logs, network traces, etc.]

### Additional Evidence

[Database queries, API responses, performance metrics, etc.]

---

## Analysis

### Root Cause Hypothesis

[Suspected component/function/condition causing the bug]

<!-- Example: "Client-side form validation logic is not properly checking email format before submission. Validation may be missing or commented out in the LoginForm component." -->

### Affected Areas

[Other features/users/systems impacted by this bug]

<!-- Example: "Any feature that accepts email input may have the same validation issue. Users attempting signup will experience same problem." -->

### Related Items

| Type | ID | Description |
|------|----|----|
| Requirement | [REQ-XX] | [Related requirement] |
| Test Case | [TC-XX] | [Test that found this bug] |
| Related Bug | [BUG-XX] | [Similar or related bugs] |

---

## Status Workflow

### Current Status

[Open / In Progress / Approved / Resolved / Closed]

### Status History

| Status | Date | Updated By | Notes |
|--------|------|------------|-------|
| Open | {{DATE_CREATED}} | [Reporter] | Initial report |

<!-- Valid Status Transitions: Open → In Progress → Approved → Resolved → Closed
Can return to Open or In Progress if issue re-opens -->

---

## Ownership

| Role | Assignee |
|------|----------|
| Reporter | [Name] |
| Assignee | [Developer assigned to fix] |
| QA Verifier | [QA responsible for verification] |

---

## Developer Notes

[Reserved for root cause analysis, fix approach, implementation notes]

<!-- Developers can add notes here during investigation and fix implementation -->

---

## Revision Log

Tracks all changes to this bug report with version increments.

| Date | Version | Change Type | Details |
|------|---------|-------------|---------|
| {{DATE_CREATED}} | {{VERSION}} | Initial Report | Bug created, Severity: [S1/S2/S3/S4], Status: Open |

<!-- Version Numbering Rules:
- Increment major (X.0) for: Status changes to Approved/Resolved/Closed
- Increment minor (X.Y) for: Evidence additions, notes, description updates, severity clarifications

Change Type Examples:
- Initial Report: Bug first created
- Evidence Added: New screenshots, logs, or artifacts added
- Details Updated: Description, steps, or environment clarified
- Status Updated: Status changed
- Severity Changed: Severity re-assessed
- Investigation Notes: Root cause analysis added
-->

---

## References

- Feature Knowledge: `../feature-knowledge.md`
- Feature Test Strategy: `../feature-test-strategy.md`
- Related Ticket Test Plan: `../[TICKET_ID]/test-plan.md`
- Related Test Cases: `../[TICKET_ID]/test-cases.md`

---

*This bug report follows the Bug Reporting Standard. See `qa-agent-os/standards/bugs/bug-reporting.md` for detailed guidelines.*
