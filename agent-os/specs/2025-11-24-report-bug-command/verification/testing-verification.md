# Testing Verification: /report-bug and /revise-bug Commands

## Verification Date: 2025-11-24

This document provides verification results for Task Group 5: Integration and Testing.

---

## Task 5.1: Installation Compilation - VERIFIED

### Single-Agent Mode Test

**Command used:**
```bash
project-install.sh --claude-code-commands true --use-claude-code-subagents false
```

**Results:**
- Commands compiled: 11 (including report-bug.md and revise-bug.md)
- Templates installed: 6 (including bug-report-template.md)
- Standards installed: 19

**Verification points:**
- [x] `report-bug.md` compiled to `.claude/commands/qa-agent-os/`
- [x] `revise-bug.md` compiled to `.claude/commands/qa-agent-os/`
- [x] Phase tags resolved correctly (PHASE 0-4 for report-bug, PHASE 1-3 for revise-bug)
- [x] Standards references included (`@qa-agent-os/standards/bugs/*`)
- [x] `bug-report-template.md` copied to `qa-agent-os/templates/`

### Multi-Agent Mode Test

**Command used:**
```bash
project-install.sh --claude-code-commands true --use-claude-code-subagents true
```

**Results:**
- Commands compiled: 9 (including report-bug.md and revise-bug.md)
- Agents installed: 7 (including bug-writer.md)
- Templates installed: 6

**Verification points:**
- [x] Multi-agent version of `report-bug.md` compiled
- [x] Multi-agent version of `revise-bug.md` compiled
- [x] Bug-writer agent delegation present in compiled commands
- [x] Agent properly references bug standards

---

## Task 5.2: Manual Testing /report-bug Interactive Mode

### Test Structure Created

A test project structure was created at `/tmp/qa-agent-os-test-project/` with:

```
qa-agent-os/features/
  test-feature/
    feature-knowledge.md
    TEST-001/
      test-plan.md
      documentation/
      bugs/
        BUG-001.md  (existing bug for increment testing)
    TEST-002/
      test-plan.md
      documentation/
```

### Testing Checklist

To verify `/report-bug` interactive mode, execute in the test project:

1. **Feature Detection:**
   - [ ] Run `/report-bug` without parameters
   - [ ] Verify "test-feature" is detected
   - [ ] Verify auto-selection prompt appears

2. **Ticket Detection:**
   - [ ] Verify both TEST-001 and TEST-002 are listed
   - [ ] Select TEST-001
   - [ ] Verify ticket selection is confirmed

3. **Bug ID Auto-Increment:**
   - [ ] Verify next bug ID is BUG-002 (since BUG-001 exists)
   - [ ] Confirm path displayed: `qa-agent-os/features/test-feature/TEST-001/bugs/BUG-002.md`

4. **Interactive Questionnaire:**
   - [ ] Enter bug title
   - [ ] Enter environment details
   - [ ] Enter steps to reproduce
   - [ ] Enter expected result
   - [ ] Enter actual result

5. **Evidence Collection:**
   - [ ] Evidence checklist displayed with options 1-6
   - [ ] Select evidence types (e.g., 1,2,5)
   - [ ] Enter evidence details for each type

6. **AI Severity Classification:**
   - [ ] AI generates severity suggestion (S1-S4)
   - [ ] Justification is provided
   - [ ] Accept/override prompt works
   - [ ] Test override to different severity

7. **Bug Report Generation:**
   - [ ] Bug report created at correct path
   - [ ] Report follows bug-report-template.md structure
   - [ ] AI suggestion tracked in metadata
   - [ ] User decision tracked

8. **Bug ID Increment Verification:**
   - [ ] Create second bug
   - [ ] Verify ID is BUG-003

---

## Task 5.3: Manual Testing /report-bug Direct Mode

### Testing Checklist

1. **Direct Mode with Required Parameters:**
   - [ ] Run `/report-bug --title "Test Error" --severity S3`
   - [ ] Verify parameters are accepted
   - [ ] Verify feature/ticket detection still works
   - [ ] Verify bug report is created with provided severity

2. **Direct Mode with All Parameters:**
   - [ ] Run with all optional parameters:
     ```
     /report-bug --title "Test Error" --severity S2 \
       --steps "1. Step one\n2. Step two" \
       --expected "Should work" --actual "Does not work" \
       --environment "Chrome 120, Staging"
     ```
   - [ ] Verify all provided parameters are used in report

3. **Validation Testing:**
   - [ ] Run without `--title` parameter
   - [ ] Verify appropriate error/prompt for required field

---

## Task 5.4: Manual Testing /revise-bug Interactive Mode

### Testing Checklist

1. **Bug Discovery:**
   - [ ] Run `/revise-bug` without parameters
   - [ ] Verify existing bugs are discovered
   - [ ] Verify sorted by recency
   - [ ] Verify bug details shown (ID, title, feature, ticket)

2. **Update Type 1: Add Evidence**
   - [ ] Select existing bug
   - [ ] Choose update type [1] Add evidence
   - [ ] Verify evidence checklist presented
   - [ ] Add new evidence
   - [ ] Verify Evidence section updated
   - [ ] Verify revision log entry added

3. **Update Type 2: Update Severity/Priority**
   - [ ] Choose update type [2]
   - [ ] Change severity from S3 to S2
   - [ ] Provide justification
   - [ ] Verify Classification section updated
   - [ ] Verify revision log records old -> new value

4. **Update Type 3: Update Status**
   - [ ] Choose update type [3]
   - [ ] Change status from New to In Progress
   - [ ] Verify Status Workflow section updated
   - [ ] Verify Status History table updated
   - [ ] Change to Ready for QA, Verified, Closed
   - [ ] Verify major version increment on Closed (e.g., 1.3 -> 2.0)

5. **Update Type 4: Add Reproduction Info**
   - [ ] Choose update type [4]
   - [ ] Add additional steps
   - [ ] Verify Reproduction section updated

6. **Update Type 5: Add Developer Notes**
   - [ ] Choose update type [5]
   - [ ] Add root cause analysis
   - [ ] Verify Developer Notes section created/updated

7. **Update Type 6: Update Affected Scope**
   - [ ] Choose update type [6]
   - [ ] Add affected users/features
   - [ ] Verify Analysis section updated

8. **Version Tracking:**
   - [ ] Verify minor increments (1.0 -> 1.1 -> 1.2)
   - [ ] Verify major increment on status changes

9. **Post-Revision Options:**
   - [ ] Verify [1] View report works
   - [ ] Verify [2] Make another update works
   - [ ] Verify [3] Done exits properly

---

## Task 5.5: Manual Testing /revise-bug Direct Mode

### Testing Checklist

1. **Direct Bug Selection:**
   - [ ] Run `/revise-bug BUG-001`
   - [ ] Verify bug is found directly
   - [ ] Verify update workflow proceeds without selection list

2. **Invalid Bug ID:**
   - [ ] Run `/revise-bug BUG-999`
   - [ ] Verify appropriate error message

---

## Task 5.6: Multi-Agent Mode Verification

### Testing Checklist

1. **Configuration:**
   - [ ] Update config.yml: `use_claude_code_subagents: true`
   - [ ] Re-run installation

2. **Compilation:**
   - [ ] Verify multi-agent versions compiled
   - [ ] Verify bug-writer agent installed

3. **Bug-Writer Delegation:**
   - [ ] Verify report-bug.md references bug-writer agent
   - [ ] Verify revise-bug.md references bug-writer agent
   - [ ] Test that delegation handoff is correctly formatted

---

## Task 5.7: Documentation Verification - VERIFIED

### Orchestrator Files

**report-bug.md (single-agent):**
- [x] Clear usage examples (interactive and direct modes)
- [x] Parameter documentation
- [x] Smart features documented
- [x] Related commands section includes: /revise-bug, /plan-ticket, /plan-feature, /generate-testcases
- [x] Standards applied section lists all bug standards

**revise-bug.md (single-agent):**
- [x] Clear usage examples (interactive and direct modes)
- [x] All 6 update types documented
- [x] Revision log format documented
- [x] Version tracking explained
- [x] Status workflow diagram included
- [x] Related commands section includes: /report-bug, /plan-ticket, /generate-testcases
- [x] Standards applied section lists bug standards

### Phase Files

All phase files include:
- [x] Clear section headers
- [x] Variable requirements from previous phases
- [x] Step-by-step instructions
- [x] Example prompts/outputs
- [x] Next phase instructions

---

## Files Verified

### Commands (Single-Agent)
- `profiles/default/commands/report-bug/single-agent/0-detect-context.md`
- `profiles/default/commands/report-bug/single-agent/1-collect-details.md`
- `profiles/default/commands/report-bug/single-agent/2-collect-evidence.md`
- `profiles/default/commands/report-bug/single-agent/3-classify-severity.md`
- `profiles/default/commands/report-bug/single-agent/4-generate-report.md`
- `profiles/default/commands/report-bug/single-agent/report-bug.md`
- `profiles/default/commands/revise-bug/single-agent/1-detect-bug.md`
- `profiles/default/commands/revise-bug/single-agent/2-prompt-update-type.md`
- `profiles/default/commands/revise-bug/single-agent/3-apply-update.md`
- `profiles/default/commands/revise-bug/single-agent/revise-bug.md`

### Commands (Multi-Agent)
- `profiles/default/commands/report-bug/multi-agent/report-bug.md`
- `profiles/default/commands/revise-bug/multi-agent/revise-bug.md`

### Templates
- `profiles/default/templates/bug-report-template.md`

### Standards
- `profiles/default/standards/bugs/severity-rules.md`
- `profiles/default/standards/bugs/bug-template.md`
- `profiles/default/standards/bugs/bug-reporting-standard.md`
- `profiles/default/standards/bugs/bug-analysis.md`

### Agents
- `profiles/default/agents/bug-writer.md`

---

## Summary

| Task | Status | Notes |
|------|--------|-------|
| 5.1 Installation Compilation | VERIFIED | Both single and multi-agent modes compile correctly |
| 5.2 /report-bug Interactive | READY FOR TESTING | Test structure created, checklist documented |
| 5.3 /report-bug Direct | READY FOR TESTING | Checklist documented |
| 5.4 /revise-bug Interactive | READY FOR TESTING | All 6 update types documented |
| 5.5 /revise-bug Direct | READY FOR TESTING | Checklist documented |
| 5.6 Multi-Agent Mode | READY FOR TESTING | Checklist documented |
| 5.7 Documentation | VERIFIED | All docs include usage, examples, related commands |

---

*Verification performed: 2025-11-24*
