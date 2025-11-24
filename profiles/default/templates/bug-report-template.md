# Bug Report: [BUG_ID]

---

## Metadata

| Field | Value |
|-------|-------|
| **Bug ID** | [BUG_ID] |
| **Feature** | [FEATURE_NAME] |
| **Ticket** | [TICKET_ID] |
| **Created** | [CREATION_TIMESTAMP] |
| **Version** | 1.0 |
| **Status** | New |

---

## Bug Details

### Title

[COMPONENT] - [Brief Summary of the Issue]

### Environment

| Property | Value |
|----------|-------|
| **Operating System** | [OS and version] |
| **Browser / Device** | [Browser name and version or device] |
| **Environment** | [Dev / Staging / Production] |
| **Build / Version** | [App version, commit hash, or API tag] |
| **Feature Flags / Config** | [Enabled toggles, experiments, or N/A] |

### Component / Area

[Module, service, or feature area impacted]

---

## Reproduction

### Preconditions

[State or setup required before reproduction - user logged in, specific data present, etc.]

### Steps to Reproduce

1. [Step 1 - User action with specific data values]
2. [Step 2 - User action or system response]
3. [Step 3 - Action that triggers the bug]

### Expected Result

[What should have happened according to requirements]

### Actual Result

[What actually happened, including exact error messages or incorrect behavior]

### Reproducibility

| Property | Value |
|----------|-------|
| **Rate** | [Always / Intermittent] |
| **Attempts** | [X out of Y attempts] |
| **Notes** | [Any variations or conditions affecting reproducibility] |

---

## Classification

### Severity & Priority

| Property | Value |
|----------|-------|
| **Severity** | [S1-Critical / S2-Major / S3-Minor / S4-Trivial] |
| **Priority** | [P1 / P2 / P3 / P4] |
| **Justification** | [Why this severity/priority was assigned] |

### AI Severity Suggestion

| Property | Value |
|----------|-------|
| **Suggested Severity** | [AI-suggested severity level] |
| **AI Justification** | [Reasoning provided by AI analysis] |
| **User Decision** | [Accepted / Overridden to [level]] |
| **Override Reason** | [If overridden, why - or N/A] |

---

## Evidence

### Screenshots / Recordings

[File paths or links to visual evidence]

- [Screenshot description]: `[path/to/screenshot]`

### Console / Browser Logs

```
[Relevant log entries - ERROR, FATAL, exceptions]
```

### API Request / Response

```json
{
  "request": {
    "method": "[HTTP method]",
    "url": "[endpoint]",
    "body": {}
  },
  "response": {
    "status": "[status code]",
    "body": {}
  }
}
```

### Network Traces

[Request IDs, correlation IDs, or HAR file references]

### Error Messages

```
[Exact error messages displayed to user or in logs]
```

### Additional Evidence

[Any other supporting evidence]

---

## Analysis

### Root Cause Hypothesis

[Inferred root cause based on evidence analysis - component, function, or condition suspected]

### Affected Areas

[Other features, users, or systems potentially impacted by this bug]

### Related Items

| Type | ID | Description |
|------|----|----|
| Requirement | [REQ-ID] | [Related requirement if applicable] |
| Test Case | [TC-ID] | [Test case that found this bug if applicable] |
| Related Bug | [BUG-ID] | [Related or duplicate bugs if any] |

---

## Status Workflow

**Current Status:** New

**Status History:**

| Status | Date | Updated By | Notes |
|--------|------|------------|-------|
| New | [CREATION_TIMESTAMP] | [Creator] | Initial report |

**Status Options:** New > In Progress > Ready for QA > Verified > Closed | Re-opened

---

## Ownership

| Role | Assignee |
|------|----------|
| **Reporter** | [Reporter name or ID] |
| **Assignee** | [Unassigned] |
| **QA Verifier** | [Unassigned] |

---

## Developer Notes

[Reserved for developer root cause analysis, fix approach, or implementation notes]

---

## Revision Log

### Change History

**Version 1.0 - [CREATION_TIMESTAMP]**
- Initial bug report created
- Severity: [SEVERITY]
- Status: New

---

## References

### Standards Applied

- Severity Rules: `@qa-agent-os/standards/bugs/severity-rules.md`
- Bug Template: `@qa-agent-os/standards/bugs/bug-template.md`
- Bug Reporting Standard: `@qa-agent-os/standards/bugs/bug-reporting-standard.md`

### Source Context

- Feature Knowledge: `../feature-knowledge.md`
- Test Plan: `../test-plan.md`
- Test Cases: `../test-cases.md`

---

*Bug report generated using QA Agent OS. Use `/revise-bug [BUG_ID]` to update this report.*
