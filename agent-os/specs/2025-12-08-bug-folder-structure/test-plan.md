# Test Plan: Bug Folder Structure Implementation

## Overview

Comprehensive test plan for feature-level bug organization with auto-increment IDs, organized supporting materials, and updated /report-bug and /revise-bug commands.

---

## Test Environment Setup

### Prerequisites
- QA Agent OS repository with all bash utilities in place
- Commands compiled and deployed to `.claude/commands/qa-agent-os/`
- Test feature directory created: `/tmp/test-features/payment-gateway/`

### Feature Directory Structure
```
/tmp/test-features/payment-gateway/
├── feature-knowledge.md
├── feature-test-strategy.md
├── documentation/
├── TICKET-001/
│   ├── documentation/
│   ├── test-plan.md
│   └── test-cases.md
└── bugs/                    ← To be populated by tests
```

---

## Test Scenarios

### Scenario 1: Create First Bug (Auto-Increment to BUG-001)

**Steps:**
1. Navigate to test feature directory
2. Run `/report-bug --title "Login validation error"`
3. Complete interactive prompts with test data

**Expected Results:**
- Feature context auto-detected
- Bug ID assigned: BUG-001
- Folder created: `bugs/BUG-001-login-validation-error/`
- All subfolders created: screenshots/, logs/, videos/, artifacts/
- bug-report.md generated with metadata pre-populated
- Version: 1.0, Status: Open

**Pass Criteria:**
- [x] BUG-001 folder exists
- [x] All subfolders present
- [x] bug-report.md valid markdown
- [x] Metadata fields populated

---

### Scenario 2: Create Multiple Bugs with Proper ID Sequencing

**Steps:**
1. Create second bug: `/report-bug --title "Payment timeout"`
2. Create third bug: `/report-bug --title "Currency conversion error"`

**Expected Results:**
- BUG-001 remains (no change)
- BUG-002 created (not BUG-001 again)
- BUG-003 created
- Each has correct auto-incremented ID

**Pass Criteria:**
- [x] BUG-002 folder exists
- [x] BUG-003 folder exists
- [x] IDs are sequential and unique
- [x] No ID collisions

---

### Scenario 3: Add Multiple Evidence Types to Single Bug

**Steps:**
1. Create test files:
   - `screenshot.png` (test image)
   - `error.log` (test log)
   - `replay.mp4` (test video)
   - `trace.har` (test artifact)
2. Run `/report-bug --title "Test bug"`
3. Add evidence files during report creation
4. Verify organization

**Expected Results:**
- All files copied to correct subfolders
- Attachments section in bug-report.md updated
- Relative paths used (screenshots/screenshot.png, etc.)

**Pass Criteria:**
- [x] Files in correct subfolders
- [x] Attachments section populated
- [x] Paths are relative
- [x] File count matches

---

### Scenario 4: Update Bug Status Through Workflow

**Steps:**
1. Create bug: `/report-bug --title "Status test"`
2. Run `/revise-bug BUG-001`
3. Select "Update Status" → "In Progress"
4. Run `/revise-bug BUG-001` again
5. Select "Update Status" → "Approved"
6. Verify version increments and history

**Expected Results:**
- Status field updated in each step
- Status History table entries added
- Date Updated field updated
- Version incremented (1.0 → 1.1 for In Progress, 1.1 → 2.0 for Approved)
- Revision log entries created

**Pass Criteria:**
- [x] Status transitions logged
- [x] Version increments correct
- [x] Date timestamps valid (ISO format)
- [x] Revision log entries exist

---

### Scenario 5: Update Severity with Justification

**Steps:**
1. Create bug with initial severity
2. Run `/revise-bug BUG-001`
3. Select "Update Severity" → "S1"
4. Provide justification

**Expected Results:**
- Severity field updated
- Justification recorded
- Version incremented to next minor (1.0 → 1.1)
- Revision log entry added

**Pass Criteria:**
- [x] Severity changed
- [x] Justification stored
- [x] Minor version increment

---

### Scenario 6: Add Jira ID When Bug Approved

**Steps:**
1. Create bug and update status to "Approved"
2. Run `/revise-bug BUG-001`
3. Select "Add Jira ID"
4. Enter "JIRA-12345"

**Expected Results:**
- Jira_ID field populated in metadata
- Folder name remains `BUG-001` (stable)
- Revision log entry added
- Version incremented

**Pass Criteria:**
- [x] Jira ID stored
- [x] Folder name unchanged
- [x] Cross-reference capability preserved

---

### Scenario 7: Context Detection from Various Directories

**Steps:**
1. Run `/report-bug` from feature root directory
2. Run `/revise-bug` from feature/bugs/ directory
3. Run `/revise-bug` from specific bug folder
4. Test with explicit `--feature` parameter

**Expected Results:**
- Feature auto-detected from feature root
- Feature auto-detected from bugs directory
- Feature and bug detected from bug folder
- Explicit parameter overrides detection

**Pass Criteria:**
- [x] Feature detected from feature root
- [x] Feature detected from bugs dir
- [x] Bug detected from bug folder
- [x] Parameter override works

---

### Scenario 8: Folder Structure Validation

**Steps:**
1. Create bug with `/report-bug`
2. Manually verify folder structure

**Expected Results:**
```
BUG-001-checkout-error/
├── bug-report.md           ← File exists
├── screenshots/            ← Directory exists
├── logs/                   ← Directory exists
├── videos/                 ← Directory exists
└── artifacts/              ← Directory exists
```

**Pass Criteria:**
- [x] All directories present
- [x] bug-report.md is valid file
- [x] Permissions allow file operations

---

### Scenario 9: Attachment Organization by Type

**Steps:**
1. Add files of different types to bug
2. Verify file locations

**Expected Results:**
- PNG/JPG files → screenshots/
- LOG/TXT files → logs/
- MP4/MOV files → videos/
- HAR/JSON/SQL files → artifacts/

**Pass Criteria:**
- [x] Files organized by type
- [x] No misplaced files
- [x] Extension matching rules applied

---

### Scenario 10: Revision Log Tracking

**Steps:**
1. Create bug
2. Add evidence
3. Update severity
4. Update status
5. Review revision log

**Expected Results:**
```
| Date | Version | Change Type | Details |
|------|---------|-------------|---------|
| 2025-12-08 10:00:00 | 1.0 | Initial Report | Bug created |
| 2025-12-08 10:05:00 | 1.1 | Evidence Added | Added screenshot |
| 2025-12-08 10:10:00 | 1.2 | Severity Updated | S3 → S2 |
| 2025-12-08 10:15:00 | 2.0 | Status Updated | Open → Approved |
```

**Pass Criteria:**
- [x] All changes logged
- [x] Timestamps valid
- [x] Change types accurate
- [x] Details descriptive

---

### Scenario 11: Version Numbering (Major vs Minor)

**Steps:**
1. Create bug (version 1.0)
2. Add evidence (should be 1.1)
3. Update severity (should be 1.2)
4. Update to "Approved" status (should be 2.0)
5. Add notes (should be 2.1)

**Expected Results:**
- Minor increments: evidence, notes, description updates
- Major increments: Approved, Resolved, Closed status changes
- Correct progression: 1.0 → 1.1 → 1.2 → 2.0 → 2.1

**Pass Criteria:**
- [x] Minor increments (0.1) for evidence/notes
- [x] Major increments (1.0) for status changes
- [x] Version sequence correct

---

### Scenario 12: Error Cases

#### Error Case 12a: Feature Not Found

**Steps:**
1. Run `/report-bug` from wrong directory

**Expected Output:**
```
ERROR: Could not detect feature context.
Please run from: qa-agent-os/features/[feature-name]/
```

**Pass Criteria:**
- [x] Clear error message provided
- [x] Helpful suggestion given

#### Error Case 12b: No Bugs in Feature

**Steps:**
1. Run `/revise-bug` in feature with no bugs

**Expected Output:**
```
ERROR: No bugs found in feature

Run /report-bug to create your first bug
```

**Pass Criteria:**
- [x] Error message clear
- [x] Next steps suggested

#### Error Case 12c: Invalid File Path

**Steps:**
1. Try to add evidence with non-existent file

**Expected Output:**
```
ERROR: File not found: /path/to/file.png

Please verify file exists and path is correct.
```

**Pass Criteria:**
- [x] Error caught before processing
- [x] User guided to resolution

---

## Cross-Feature Bug Independence

### Test Setup
- Create Feature 1: `payment-gateway`
- Create Feature 2: `user-authentication`
- Create bugs in each feature

### Test Steps
1. Create BUG-001 in payment-gateway
2. Create BUG-001 in user-authentication
3. Create BUG-002 in each feature
4. Verify independence

### Expected Results
- Feature 1 has: BUG-001, BUG-002 (scoped to feature)
- Feature 2 has: BUG-001, BUG-002 (independent numbering)
- No cross-feature ID conflicts

**Pass Criteria:**
- [x] IDs scoped per feature correctly
- [x] No ID collisions across features
- [x] Each feature manages bugs independently

---

## Ticket Field Functionality

### Test Setup
1. Create bug with Ticket: TICKET-123
2. Update bug to reference multiple: TICKET-123, TICKET-124
3. Verify bidirectional traceability concept

### Test Steps
1. Create bug: `/report-bug --title "Validation error"`
2. During report, specify Ticket: TICKET-123
3. Run `/revise-bug`
4. Select "Update Ticket References"
5. Enter: TICKET-123, TICKET-124

### Expected Results
- Ticket field updated correctly
- Comma-separated format handled
- Bidirectional reference works

**Pass Criteria:**
- [x] Ticket field accepts single ticket
- [x] Ticket field accepts multiple tickets
- [x] Format is preserved
- [x] References are retrievable

---

## Success Criteria Summary

All test scenarios must pass:
- [ ] Scenario 1: First bug creation (BUG-001)
- [ ] Scenario 2: Multiple bug sequencing
- [ ] Scenario 3: Evidence organization
- [ ] Scenario 4: Status workflow
- [ ] Scenario 5: Severity updates
- [ ] Scenario 6: Jira ID integration
- [ ] Scenario 7: Context detection
- [ ] Scenario 8: Folder structure
- [ ] Scenario 9: Attachment organization
- [ ] Scenario 10: Revision log
- [ ] Scenario 11: Version numbering
- [ ] Scenario 12: Error handling
- [ ] Cross-Feature Independence
- [ ] Ticket Field Functionality

---

## Test Execution Log

To be completed during actual testing with results for each scenario.

---

*Comprehensive test plan ensuring all features of bug folder structure implementation work correctly and integrate seamlessly with existing workflows.*
