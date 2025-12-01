# Bug Reporting Standard

This standard defines bug report structure, severity classification, analysis methodology, and workflow. It replaces: bug-report-template.md, bug-template.md, severity-rules.md, bug-reporting-standard.md, and bug-analysis.md.

---

## Document Structure

### Metadata

| Field | Value | Rules |
|-------|-------|-------|
| Bug ID | BUG-XXX | Auto-increment |
| Feature | [name] | Parent feature |
| Ticket | [id] | Ticket being tested |
| Created | [timestamp] | Date/time |
| Version | 1.0 | Increment with revisions |
| Status | New | See workflow below |

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

- Screenshots/Recordings: paths with descriptions
- Console/Browser Logs: code blocks with timestamps, correlation IDs
- API Request/Response: JSON format
- Network Traces: request IDs, HAR files
- Error Messages: exact messages
- Additional: database queries, configs, monitoring links

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
| New | [date] | [reporter] | Initial report |

**Valid Statuses:** New → In Progress → Ready for QA → Verified → Closed (or Re-opened)

### Ownership

| Role | Assignee |
|------|----------|
| Reporter | [name] |
| Assignee | [dev] |
| QA Verifier | [qa] |

### Developer Notes

Reserved for root cause analysis, fix approach, implementation notes

### Revision Log

**Version 1.0 - [date]:** Initial report, Severity: [X], Status: New

*Increment major (X.0) for severity/status changes, minor (X.Y) for additions*

### References

- Feature Knowledge: `../feature-knowledge.md`
- Test Plan: `../test-plan.md`
- Test Cases: `../test-cases.md`

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

**Always:** Redact PII/secrets, store in `bugs/evidence/`, reference by filename

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

*Single source of truth for bug reporting - structure, rules, analysis, workflow in one place.*
