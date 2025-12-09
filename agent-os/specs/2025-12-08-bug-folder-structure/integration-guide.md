# Integration Guide: Feature-Level Bug Organization

## Overview

This guide explains how feature-level bug organization integrates with the existing QA Agent OS workflow, including ticket-level testing, feature planning, and command interactions.

## Architecture Overview

The QA Agent OS workflow now includes two distinct but complementary structures:

### Feature-Level Structure
```
qa-agent-os/features/[feature-name]/
├── bugs/                          ← Feature-level bugs (this spec)
│   ├── BUG-001-[title]/
│   ├── BUG-002-[title]/
│   └── BUG-003-[title]/
├── feature-knowledge.md           ← Feature overview and business rules
├── feature-test-strategy.md       ← Feature-level testing approach
└── [TICKET-001]/                  ← Ticket-level testing
    └── test-plan.md
    └── test-cases.md
```

### Key Distinction
- **Bugs**: Feature-level (affect feature holistically, may span multiple tickets)
- **Tests**: Ticket-level (test specific functionality per ticket)

## Workflow Integration

### Typical QA Workflow

```
1. Feature Planning
   ↓
2. Create Tickets
   ↓
3. Start Ticket Testing  (/plan-ticket creates TICKET-N directory)
   ↓
4. Execute Test Plan
   ↓
5. Discover Bugs      ← NEW: Create feature-level bugs
   ├─→ /report-bug   (creates BUG-001 at feature level)
   └─→ /revise-bug   (updates BUG-001 with evidence)
   ↓
6. Report Results
```

### Before (Old Workflow)
Bugs were created at ticket level:
```
qa-agent-os/features/[feature]/[TICKET-001]/bugs/BUG-1.md
qa-agent-os/features/[feature]/[TICKET-002]/bugs/BUG-1.md ← Duplication!
```

### After (New Workflow)
Bugs are created at feature level:
```
qa-agent-os/features/[feature]/bugs/BUG-001-title/bug-report.md
  Ticket: TICKET-001, TICKET-002  ← Cross-ticket reference
```

## Command Interactions

### /start-feature
Creates feature directory structure.

**Related to bugs:** Feature created first, then bugs tracked at this level.

```
/start-feature "Payment Gateway"
→ Creates: qa-agent-os/features/payment-gateway/
→ Bugs will be created here: payment-gateway/bugs/
```

### /plan-ticket
Creates ticket directory for test planning within feature.

**Related to bugs:** Bugs are at feature level, tests at ticket level.

```
/plan-ticket --feature payment-gateway "PAY-456"
→ Creates: payment-gateway/PAY-456/test-plan.md
→ Bugs referenced via: BUG-001 [Ticket: PAY-456]
```

### /report-bug (NEW/UPDATED)
Creates bug at feature level with auto-detection.

**Runs from:** Feature directory or feature/bugs/

**Creates:** `features/[feature]/bugs/BUG-XXX-[title]/bug-report.md`

**Example:**
```
cd qa-agent-os/features/payment-gateway/
/report-bug --title "Checkout submit fails"
→ Creates: bugs/BUG-001-checkout-submit-fails/bug-report.md
→ Includes Ticket field: TICKET-456
```

### /revise-bug (NEW/UPDATED)
Updates feature-level bug with evidence and status.

**Runs from:** Feature directory or feature/bugs/

**Updates:** `features/[feature]/bugs/BUG-XXX/bug-report.md`

**Example:**
```
cd qa-agent-os/features/payment-gateway/
/revise-bug BUG-001 → Add Evidence → screenshots/error.png
→ Updates: bugs/BUG-001-checkout-submit-fails/bug-report.md
→ Copies: screenshots/error.png to correct subfolder
```

### /generate-testcases
Generates test cases from test-plan (unchanged).

**Related to bugs:** Test cases test feature behavior; bugs document issues found during testing.

## Cross-References Between Bugs and Tests

### From Test Plan to Bug
When executing test-plan.md and discovering a bug:

```markdown
## Test Scenario 1.2: Checkout Form Submission

**Steps:**
1. Fill checkout form with valid data
2. Click Submit button

**Expected:** Order confirmation displayed

**Actual:** 500 error displayed

**Bug Created:** BUG-001-checkout-submit-fails
**Ticket:** TICKET-456
```

### From Bug Report to Related Tests
In bug-report.md, track which tests exercise this bug:

```markdown
## Related Items

| Type | ID | Description |
|------|----|----|
| Test Case | TC-1.2 | Checkout form submission |
| Ticket | TICKET-456 | Payment Gateway - Phase 1 |
| Feature | Payment Gateway | Feature-level testing |
```

## Bidirectional Traceability

### Requirement → Test Case → Bug
```
REQ-PAY-001: Submit button must validate form
    ↓
TC-1.2: Test checkout form validation
    ↓
BUG-001: Validation error not displayed (TICKET-456)
```

### Bug → Ticket → Feature
```
BUG-001 (Checkout validation error)
  ├─ Ticket: TICKET-456
  ├─ Feature: Payment Gateway
  └─ Status: Open → In Progress → Resolved
```

## Status Lifecycle Alignment

### Bug Lifecycle
```
Open → In Progress → Approved → Resolved → Closed
```

### Test Lifecycle
```
Not Tested → Running → Passed/Failed → Verified
```

**Alignment:**
- Bug Open ≈ Test Failed (issue found)
- Bug In Progress ≈ Developer fixing
- Bug Approved ≈ Ready for QA verification
- Bug Resolved ≈ Test Passed after fix
- Bug Closed ≈ Verified fixed

## Backward Compatibility

### Existing Ticket-Level Bugs
Ticket-level bugs created before this spec remain unchanged:
```
qa-agent-os/features/[feature]/[TICKET-001]/bugs/bug-001.md
```

These are NOT migrated to feature level. They coexist with feature-level bugs.

### Forward-Looking Approach
All NEW bugs created with `/report-bug` go to feature level:
```
qa-agent-os/features/[feature]/bugs/BUG-001/bug-report.md
```

### Migration Strategy (Future)
If migrating existing bugs is needed later:
1. Create migration script to move ticket-level bugs to feature-level
2. Update references in test plans
3. Consolidate related bugs from multiple tickets into single feature-level bug
4. Requires manual review due to context-dependent decisions

## Configuration

### config.yml Considerations
No changes required to config.yml for bug functionality.

Bugs follow established patterns:
- Template location: `profiles/default/templates/bug-report.md`
- Standards location: `profiles/default/standards/bugs/`
- Commands location: `profiles/default/commands/report-bug/` and `revise-bug/`

### Installation
Run `project-install.sh` to deploy updated commands:
```bash
./scripts/project-install.sh --claude-code-commands true
```

This compiles:
- `/report-bug` command (5 phases) to `.claude/commands/qa-agent-os/`
- `/revise-bug` command (3 phases) to `.claude/commands/qa-agent-os/`
- Templates to `.qa-agent-os/templates/`
- Standards to `.qa-agent-os/standards/`

## Best Practices

### Bug Creation
1. Run `/report-bug` from feature directory for auto-detection
2. Provide clear, descriptive bug title (20-40 chars recommended)
3. Include reproduction steps and expected vs actual behavior
4. Provide related ticket ID(s) for cross-reference
5. Add initial evidence (screenshots, logs) when available

### Bug Revision
1. Use `/revise-bug` to add evidence progressively
2. Update status as bug moves through lifecycle
3. Document investigation findings in notes
4. Update severity only when new information changes assessment
5. Add Jira ID when bug approved and exported

### Bug Organization
1. Keep related bugs together at feature level
2. Use semantic evidence subfolders consistently
3. Maintain accurate Ticket field for cross-references
4. Archive or close resolved bugs promptly
5. Regular review of open bugs for stale investigation

### Testing Against Bugs
1. During test execution, reference related bug if issue found
2. Link test case to bug in bug-report.md "Related Items"
3. Re-test fixed bugs after developer fix deployed
4. Add verification notes to bug-report.md when fixed

## Troubleshooting

### Common Issues

**Issue: Feature context not detected**
```
Solution: Run from feature directory
  cd qa-agent-os/features/[feature-name]/
  /report-bug
```

**Issue: Bug ID conflicts**
```
Solution: Auto-increment prevents conflicts
  System scans existing bugs
  Automatically uses next available ID
```

**Issue: Evidence file not found**
```
Solution: Provide correct file path
  Use absolute or relative path
  Verify file exists before referencing
```

**Issue: Bug-report.md not updating**
```
Solution: Ensure bug folder exists
  /revise-bug looks for existing bug-report.md
  Use /report-bug first to create bug
```

## Summary

Feature-level bug organization integrates seamlessly with existing ticket-level testing:

- Bugs track cross-ticket issues at feature scope
- Tests track functionality at ticket scope
- Cross-references enable traceability
- Commands auto-detect context for ease of use
- Backward compatibility maintained with existing ticket-level bugs
- Forward-looking approach enables future improvements

---

*For detailed information, see:*
- *Spec: `/agent-os/specs/2025-12-08-bug-folder-structure/spec.md`*
- *Standards: `/qa-agent-os/standards/bugs/bug-reporting.md`*
- *Templates: `/qa-agent-os/templates/bug-report.md`*
