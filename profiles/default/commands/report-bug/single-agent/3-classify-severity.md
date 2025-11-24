# Phase 3: Classify Severity

## AI-Assisted Severity Classification

This phase analyzes the bug details and evidence to suggest an appropriate severity level, with user confirmation or override.

### Variables from Previous Phases

Required from previous phases:
- `FEATURE_NAME` - The feature name
- `TICKET_ID` - The ticket identifier
- `BUG_ID` - Assigned bug ID
- `BUG_PATH` - Full path to bug file
- `BUG_DETAILS` - Details collected in Phase 1
- `EVIDENCE_DETAILS` - Evidence collected in Phase 2
- `PRESET_SEVERITY` - Severity if provided in direct mode (may be null)

### Reference Standard

Read and apply severity classification rules:
```
@qa-agent-os/standards/bugs/severity-rules.md
```

---

## Check for Preset Severity

If severity was provided in direct mode (`PRESET_SEVERITY` is not null):

```
Severity provided: [PRESET_SEVERITY]

Validating against severity rules...

[If valid S1-S4]:
Severity [PRESET_SEVERITY] accepted.

[If invalid]:
Warning: "[value]" is not a valid severity. Must be S1, S2, S3, or S4.
Proceeding to AI classification...
```

If valid preset severity, skip to storing section.

---

## AI Severity Analysis

Analyze the bug using the severity classification checklist:

### Step 1: Check for S1 (Critical) Indicators

Evaluate bug details and evidence for:

```
Checking S1 (Critical) indicators...

  [ ] Data loss or corruption?
  [ ] Security vulnerability exposed?
  [ ] System crash or complete unavailability?
  [ ] Payment processing broken?
  [ ] No workaround exists?
  [ ] Regulatory/compliance breach?
```

**Evidence patterns suggesting S1:**
- Error messages mentioning "data loss", "corrupted", "deleted"
- Authentication bypass or unauthorized access
- Application crash, 503 errors across all users
- Payment failures, duplicate charges
- No documented workaround possible

### Step 2: Check for S2 (Major) Indicators

If no S1 indicators, evaluate for S2:

```
Checking S2 (Major) indicators...

  [ ] Core feature broken?
  [ ] Incorrect calculations or data?
  [ ] API returning wrong values?
  [ ] Difficult/time-consuming workaround?
  [ ] Severe performance degradation?
```

**Evidence patterns suggesting S2:**
- 500 errors on specific features
- Wrong values in calculations/displays
- API responses with incorrect data
- Workaround requires multiple manual steps
- Page load times >10x normal

### Step 3: Check for S3 (Minor) Indicators

If no S2 indicators, evaluate for S3:

```
Checking S3 (Minor) indicators...

  [ ] UI/layout issues?
  [ ] Incorrect messages/labels?
  [ ] Easy workaround available?
  [ ] Limited user segment affected?
  [ ] Non-blocking accessibility issue?
```

**Evidence patterns suggesting S3:**
- Visual misalignment or truncation
- Misleading error messages
- Simple workaround (refresh, use different path)
- Affects only specific browsers or configurations

### Step 4: Default to S4 (Trivial)

If no S3 indicators match:

```
Checking S4 (Trivial) indicators...

  [ ] Typos or spelling errors?
  [ ] Minor visual inconsistencies?
  [ ] Low-impact UX issues?
  [ ] No functional impact?
```

---

## Generate AI Suggestion

Based on analysis, generate severity suggestion with justification:

```
Severity Analysis Results

Analyzing:
- Bug title: "[title]"
- Actual result: "[actual result]"
- Error messages: [count] captured
- Evidence patterns: [summary of findings]

Evaluation:
- S1 indicators found: [None / List]
- S2 indicators found: [None / List]
- S3 indicators found: [None / List]

AI Suggestion: S[X] - [Level Name]

Justification:
[2-3 sentences explaining why this severity was chosen, referencing
specific evidence and matching severity criteria]

Example justifications:
- S1: "Data loss indicator detected. User action deleted records with no recovery
       option. This matches S1 criteria: 'Data loss or corruption occurs'."
- S2: "Core checkout feature returns 500 error. While a workaround exists (use
       mobile app), it requires significant effort. Matches S2: 'Feature broken,
       difficult workaround'."
- S3: "Error message displays technical text instead of user-friendly message.
       Function still works correctly. Matches S3: 'Incorrect messages, no
       functional impact'."
- S4: "Button label has typo 'Submitt' instead of 'Submit'. No functional
       impact. Matches S4: 'Typos, cosmetic issues'."
```

---

## User Confirmation

Present suggestion to user for confirmation or override:

```
--------------------------------------------
Suggested Severity: S[X] - [Level Name]
--------------------------------------------

Justification:
[AI justification text]

--------------------------------------------

Accept suggestion? [y] or override [1-4]:

  [1] S1 - Critical (data loss, security, crash, no workaround)
  [2] S2 - Major (feature broken, wrong calculations, difficult workaround)
  [3] S3 - Minor (UI issues, incorrect messages, easy workaround)
  [4] S4 - Trivial (cosmetic, typos, minimal impact)

Your choice:
> [User input]
```

### Handle User Response

**If user enters 'y' or 'Y' (accept):**
```
Severity accepted: S[X] - [Level Name]
```

**If user enters '1', '2', '3', or '4' (override):**
```
Severity overridden: S[Y] - [New Level Name]

Please provide reason for override (helps track decision rationale):
> [User input - override reason]
```

---

## Store Severity Decision

Compile severity information:

```
SEVERITY={
  level: "S[X]",
  name: "[Critical/Major/Minor/Trivial]",
  ai_suggestion: {
    level: "S[original suggestion]",
    justification: "[AI justification text]"
  },
  user_decision: "[Accepted/Overridden to S[Y]]",
  override_reason: "[User's reason or N/A]"
}
```

---

## Priority Assessment

After severity is determined, suggest priority based on context:

```
Priority Assessment

Severity: S[X] - [Level]

Suggested Priority: P[X]

Priority factors considered:
- Severity level
- Feature visibility (based on feature context)
- Current testing phase

Default mapping:
  S1 -> P1 (Immediate)
  S2 -> P2 (High)
  S3 -> P3 (Medium)
  S4 -> P4 (Low)

Accept default priority P[X]? [y] or enter P1-P4:
> [User input]
```

Store priority:
```
PRIORITY="P[X]"
```

---

## Summary Display

```
Severity Classification Complete

Severity: S[X] - [Level Name]
Priority: P[X]
Decision: [Accepted AI suggestion / Overridden by user]
[If overridden] Reason: [override reason]

Proceeding to Phase 4: Generate Report
```

### Set Variables for Next Phase

Pass to Phase 4:
```
FEATURE_NAME=[feature-name]
TICKET_ID=[ticket-id]
TICKET_PATH=[path]
BUG_ID=[bug-id]
BUG_PATH=[path]
BUG_DETAILS=[details object]
EVIDENCE_DETAILS=[evidence object]
SEVERITY=[severity object]
PRIORITY=[priority]
```

### Next Phase

Continue to Phase 4: Generate Report
