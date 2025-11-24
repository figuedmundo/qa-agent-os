# QA Standard - Severity Rules

This standard defines severity classification criteria for bug reports. AI agents should use the decision checklist to suggest severity, with human confirmation or override.

---

## Severity Levels

### S1 - Critical

**Impact:** Complete system failure or major business-critical functionality broken with no workaround.

**Criteria Checklist:**
- [ ] Data loss or corruption occurs
- [ ] Security vulnerability exposed (authentication bypass, data leak, injection)
- [ ] System crash or complete unavailability
- [ ] Payment processing broken (transactions fail, incorrect charges)
- [ ] No workaround exists
- [ ] Regulatory or compliance breach
- [ ] Requires immediate incident response

**Examples:**
| Scenario | Why S1 |
|----------|--------|
| User passwords stored in plain text in logs | Security vulnerability - data exposure |
| Clicking "Submit Order" deletes all items from database | Data loss - no recovery possible |
| Application crashes on login for all users | System unavailable - no workaround |
| Payment charged twice for single transaction | Payment broken - financial impact |
| GDPR data export returns other users' data | Compliance breach - regulatory violation |

---

### S2 - Major

**Impact:** Feature broken or returns incorrect results. Workaround exists but is difficult or significantly impacts productivity.

**Criteria Checklist:**
- [ ] Core feature functionality broken
- [ ] Wrong calculations or data transformations
- [ ] API returns incorrect data (wrong values, missing required fields)
- [ ] Workaround exists but requires significant effort
- [ ] Significant performance degradation impacting majority of users
- [ ] Monitoring alert thresholds breached
- [ ] Feature works but produces incorrect output

**Examples:**
| Scenario | Why S2 |
|----------|--------|
| Search returns wrong products (searching "laptop" shows phones) | Feature broken - incorrect results |
| Invoice total calculated incorrectly (missing tax) | Wrong calculations - financial impact |
| User profile update succeeds but changes not persisted | Core functionality broken - data not saved |
| Page load takes 30+ seconds (normally 2 seconds) | Severe performance - unusable experience |
| Export to CSV missing half the columns | Feature works but output incorrect |

---

### S3 - Minor

**Impact:** UI issues, incorrect messages, or limited functionality issues with easy workaround.

**Criteria Checklist:**
- [ ] UI misalignment or layout issues
- [ ] Incorrect or confusing messages/labels
- [ ] Non-blocking accessibility issues
- [ ] Limited user impact
- [ ] Easy workaround exists
- [ ] Feature works but with minor inconvenience
- [ ] Cosmetic issues that don't prevent task completion

**Examples:**
| Scenario | Why S3 |
|----------|--------|
| Button text truncated on mobile view | UI issue - still clickable |
| Error message says "Error 500" instead of friendly message | Incorrect message - function still works |
| Date picker shows wrong format (MM/DD vs DD/MM) | Confusing - user can still select date |
| Form tab order skips a field | Accessibility - can still fill form |
| Tooltip appears in wrong position | Minor UI - information still visible |

---

### S4 - Trivial

**Impact:** Cosmetic issues with minimal user impact. No functional effect.

**Criteria Checklist:**
- [ ] Typos or spelling errors
- [ ] Minor visual inconsistencies
- [ ] Low-impact UX issues
- [ ] Internal-only copy tweaks
- [ ] Pixel-perfect alignment issues
- [ ] No functional impact whatsoever

**Examples:**
| Scenario | Why S4 |
|----------|--------|
| "Recieve" instead of "Receive" in confirmation email | Typo - no functional impact |
| Button is 2px off-center | Cosmetic - imperceptible to most users |
| Hover color slightly different from design spec | Minor visual - doesn't affect usability |
| Internal admin label says "Usr" instead of "User" | Internal copy - doesn't affect customers |
| Footer copyright year is previous year | Low-impact - no functionality affected |

---

## AI Severity Classification Checklist

When analyzing a bug to suggest severity, evaluate in order from most severe to least:

### Step 1: Check for S1 (Critical) Indicators

```
Does the bug involve ANY of these?
  [Y] Data loss or corruption         -> S1
  [Y] Security vulnerability          -> S1
  [Y] System crash/unavailability     -> S1
  [Y] Payment/financial processing    -> S1
  [Y] No workaround possible          -> S1
  [Y] Regulatory/compliance impact    -> S1

If YES to any -> Suggest S1
If NO to all  -> Continue to Step 2
```

### Step 2: Check for S2 (Major) Indicators

```
Does the bug involve ANY of these?
  [Y] Core feature completely broken  -> S2
  [Y] Incorrect calculations/data     -> S2
  [Y] API returning wrong values      -> S2
  [Y] Difficult/time-consuming workaround -> S2
  [Y] Severe performance degradation  -> S2
  [Y] Output is incorrect (not just ugly) -> S2

If YES to any -> Suggest S2
If NO to all  -> Continue to Step 3
```

### Step 3: Check for S3 (Minor) Indicators

```
Does the bug involve ANY of these?
  [Y] UI/layout issues                -> S3
  [Y] Incorrect messages/labels       -> S3
  [Y] Easy workaround available       -> S3
  [Y] Limited user segment affected   -> S3
  [Y] Non-blocking accessibility issue -> S3

If YES to any -> Suggest S3
If NO to all  -> Suggest S4 (Trivial)
```

### Step 4: Formulate Justification

Include in AI justification:
1. Which checklist item(s) matched
2. Evidence from bug description supporting the match
3. Impact assessment (who/what is affected)
4. Workaround availability and difficulty

---

## Escalation and SLA Guidelines

| Severity | Response Time | Resolution Target | Actions Required |
|----------|---------------|-------------------|------------------|
| S1 - Critical | Immediate | Resolve/rollback before release continues | Page on-call, incident response |
| S2 - Major | Within 4 hours | Fix within current sprint | Require regression evidence before closure |
| S3 - Minor | Within 24 hours | Triage into backlog | Document rationale, revisit during hardening |
| S4 - Trivial | Within 48 hours | Backlog with low priority | May defer to future releases |

---

## Relationship to Priority

**Severity** measures **impact** - how bad is the problem?
**Priority** measures **urgency** - how soon must we fix it?

| Scenario | Severity | Priority | Rationale |
|----------|----------|----------|-----------|
| Critical bug, but feature is behind disabled flag | S1 | P3 | Severe impact, but not affecting users yet |
| Minor typo on homepage hero banner | S4 | P1 | Trivial bug, but high visibility needs quick fix |
| Major calculation error in rarely-used report | S2 | P3 | Significant impact, but limited user exposure |
| Minor UI bug blocking release certification | S3 | P1 | Minor impact, but blocking deployment |

A severe issue may have lower priority if mitigated by feature flagging, but rationale must be documented.

---

*Reference this standard when classifying bug severity. See `bug-template.md` for report format and `bug-reporting-standard.md` for workflow guidelines.*
