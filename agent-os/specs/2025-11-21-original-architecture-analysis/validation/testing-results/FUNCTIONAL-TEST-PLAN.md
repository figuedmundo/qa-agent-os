# Functional Test Plan - QA Workflow Commands

**Test Date:** 2025-11-21
**Test Environment:** `/tmp/qa-agent-os-test-project`
**Mode:** Single-Agent (Task Group 5.1)
**Status:** READY FOR EXECUTION

## Test Objective

Verify that all 5 key commands (/plan-feature, /plan-ticket, /generate-testcases, /revise-test-plan, /update-feature-knowledge) can be executed successfully and produce the expected outputs as defined in the specification.

## Test Approach

Since these are Claude Code commands designed to be executed interactively, this functional test plan will:
1. Verify command structure and readability
2. Validate workflow logic and sequencing
3. Check output file creation patterns
4. Verify cross-command integration points
5. Document any gaps or issues found

**Note:** Actual command execution by a user would require interactive prompts and file system operations that are outside the scope of this validation phase. The focus is on command correctness and completeness.

## Test Scenarios

### Scenario 1: New Feature Planning Flow
**Commands:** `/plan-feature` → `/plan-ticket` → `/generate-testcases`

**Steps:**
1. User runs `/plan-feature "Payment Gateway"`
2. Command creates feature structure, gathers docs, creates knowledge and strategy
3. User runs `/plan-ticket PAY-123`
4. Command detects feature, initializes ticket, gathers docs, analyzes requirements
5. User runs `/generate-testcases PAY-123`
6. Command generates test cases from test plan

**Expected Outputs:**
```
features/payment-gateway/
  feature-knowledge.md (8 sections)
  feature-test-strategy.md (10 sections)
  PAY-123/
    documentation/
    test-plan.md (11 sections)
    test-cases.md (execution tracking)
```

**Validation Points:**
- Feature folder created with proper structure
- Knowledge file follows 8-section template
- Strategy file follows 10-section template
- Ticket folder created under correct feature
- Test plan has proper requirements analysis
- Test cases mapped to requirements

### Scenario 2: Existing Ticket Re-Planning
**Commands:** `/plan-ticket PAY-123` (existing ticket)

**Steps:**
1. User runs `/plan-ticket PAY-123` for an existing ticket
2. Command detects existing ticket and shows 4 options:
   - [1] Full re-plan
   - [2] Update test plan only
   - [3] Regenerate test cases only
   - [4] Cancel
3. User selects option
4. Command executes selected path

**Expected Behavior:**
- Existing ticket detected (Phase 0)
- Options presented with clear descriptions
- Selected path executed correctly
- Existing documentation preserved (if applicable)

**Validation Points:**
- Detection logic works (checks for existing folder)
- All 4 options properly implemented
- Partial re-execution works (options 2-3)
- Files preserved when appropriate

### Scenario 3: Gap Detection Flow
**Commands:** `/plan-ticket PAY-124` (new ticket with gaps)

**Steps:**
1. User runs `/plan-ticket PAY-124`
2. Ticket introduces new business rule not in feature-knowledge.md
3. Command detects gap during Phase 3
4. Command prompts: "Would you like me to append this to feature-knowledge.md? [y/n]"
5. User responds "y"
6. Command appends gap with metadata

**Expected Outputs:**
- Gap detected (comparison logic works)
- User prompted with clear gap summary
- feature-knowledge.md updated with:
  - New information appended
  - Source metadata (ticket ID, date)
  - Type label (Business Rule/API/Edge Case)

**Validation Points:**
- Gap comparison logic documented
- Prompt includes gap details
- Append logic preserves existing content
- Metadata tracking implemented

### Scenario 4: Test Case Regeneration
**Commands:** `/revise-test-plan PAY-123` → `/generate-testcases PAY-123`

**Steps:**
1. User runs `/revise-test-plan PAY-123`
2. Command updates test-plan.md with revision log
3. Command offers to regenerate test cases
4. User accepts
5. Command calls `/generate-testcases` internally

**Expected Outputs:**
- test-plan.md updated with changes
- Revision log entry added (version incremented)
- test-cases.md regenerated with new scenarios
- Old test cases backed up (if overwrite)

**Validation Points:**
- Revision tracking works
- Version increment logic
- Integration with /generate-testcases
- Backup logic for overwrite mode

### Scenario 5: Conflict Detection
**Commands:** `/generate-testcases PAY-123` (test-cases.md exists)

**Steps:**
1. User runs `/generate-testcases PAY-123`
2. Command detects existing test-cases.md (Phase 2)
3. Command shows file metadata:
   - Last updated date
   - File size
   - Number of test cases
4. Command prompts: [1] Overwrite / [2] Append / [3] Cancel
5. User selects option
6. Command executes selected mode

**Expected Behavior:**
- Existing file detected
- Metadata read correctly (date, size, count)
- All 3 options properly implemented
- Append mode increments test case IDs

**Validation Points:**
- File detection works
- Metadata parsing logic
- Overwrite creates backup
- Append preserves existing cases
- Cancel exits without changes

### Scenario 6: Manual Feature Knowledge Update
**Commands:** `/update-feature-knowledge "Payment Gateway"`

**Steps:**
1. User runs `/update-feature-knowledge "Payment Gateway"`
2. Command shows 5 update types:
   - [1] Add new business rule
   - [2] Add new API endpoint
   - [3] Update existing information
   - [4] Add edge case documentation
   - [5] Add open question
3. User selects type
4. Command prompts for details
5. Command updates feature-knowledge.md

**Expected Outputs:**
- feature-knowledge.md updated
- New content appended to appropriate section
- Metadata tracked (update date, type)

**Validation Points:**
- All 5 update types implemented
- Section mapping correct
- Manual updates properly formatted
- Metadata tracking

## Cross-Command Integration Tests

### Integration 1: Feature → Ticket Flow
**Validation:**
- /plan-feature creates feature structure
- /plan-ticket detects feature automatically
- Ticket references feature knowledge and strategy
- test-plan.md Section 1 has correct relative paths

### Integration 2: Ticket → Test Case Flow
**Validation:**
- /plan-ticket Phase 4 can call /generate-testcases
- /generate-testcases reads test-plan.md correctly
- Test cases reference test plan sections
- Coverage matrix properly mapped

### Integration 3: Gap Detection → Feature Update Flow
**Validation:**
- /plan-ticket Phase 3 detects gaps
- Gaps prompt feature knowledge update
- /update-feature-knowledge can be used manually
- Both methods append with metadata

### Integration 4: Plan Update → Regeneration Flow
**Validation:**
- /revise-test-plan updates test-plan.md
- Revision log tracks changes
- Regeneration prompt calls /generate-testcases
- Test cases reflect plan updates

## Error Handling Tests

### Error 1: Missing Prerequisites
**Test:** Run `/plan-ticket` with no features
**Expected:** Error message with guidance to run `/plan-feature` first

### Error 2: Missing Files
**Test:** Run `/generate-testcases` with no test-plan.md
**Expected:** Error message with guidance to run `/plan-ticket` first

### Error 3: Invalid Ticket ID
**Test:** Run command with non-existent ticket
**Expected:** Error message asking if user ran prerequisite command

### Error 4: Missing Documentation
**Test:** Run `/plan-ticket` Phase 2 with empty documentation folder
**Expected:** Warning message suggesting to gather documentation

## User Experience Tests

### UX 1: Interactive Selections
**Validation:**
- Numbered lists are clear
- Prioritization makes sense (new items first)
- Labels are helpful ("<- NEW", dates)
- Prompts are consistent format

### UX 2: Progress Indicators
**Validation:**
- Phase transitions clearly marked
- Success messages after each phase
- "Proceeding to Phase N" messages
- Final completion summaries

### UX 3: Help & Guidance
**Validation:**
- Related commands section at end
- Next steps guidance in completion messages
- Error messages suggest fixes
- Usage examples in command headers

## Output Validation Tests

### Output 1: File Structure
**Validation:**
- Folders created in correct locations
- File naming conventions followed
- Template structures preserved
- Documentation subfolders created

### Output 2: Content Quality
**Validation:**
- Markdown properly formatted
- Sections follow template numbering
- Cross-references use correct paths
- Metadata fields populated

### Output 3: Traceability
**Validation:**
- Source tracking in feature knowledge updates
- Revision logs in test plans
- Version numbers tracked
- Date stamps on all documents

## Test Execution Plan

### Phase 1: Structural Validation (COMPLETED)
- Verify command compilation
- Check phase structure
- Validate workflow embedding
- Confirm pattern compliance

### Phase 2: Logic Validation (NEXT)
- Verify workflow sequences
- Check conditional logic
- Validate state management
- Confirm variable passing

### Phase 3: Integration Validation
- Verify cross-command workflows
- Check file dependencies
- Validate reference paths
- Confirm template usage

### Phase 4: User Experience Validation
- Review interactive elements
- Check error messages
- Validate guidance quality
- Confirm consistency

## Success Criteria

### Command-Level Success
- [ ] Command compiles without errors
- [ ] All phases properly structured
- [ ] Workflows fully embedded
- [ ] Error handling comprehensive
- [ ] User prompts clear and helpful

### Workflow-Level Success
- [ ] Phases execute in correct sequence
- [ ] Variables passed correctly between phases
- [ ] Conditional logic works as expected
- [ ] Output files created in correct locations
- [ ] Templates properly applied

### Integration-Level Success
- [ ] Commands work together as a system
- [ ] File references resolve correctly
- [ ] Cross-command features work (gap detection, regeneration)
- [ ] Metadata tracking maintains traceability

### User Experience Success
- [ ] Prompts are clear and actionable
- [ ] Errors provide helpful guidance
- [ ] Progress is communicated clearly
- [ ] Next steps are obvious
- [ ] Related commands are discoverable

## Risk Areas

### High Risk
1. **Gap detection logic** - Complex comparison between ticket and feature knowledge
2. **Append mode** - Preserving existing test cases while adding new ones
3. **Re-execution options** - Partial re-planning without breaking existing work
4. **Variable passing** - State management across phases

### Medium Risk
1. **File path resolution** - Relative paths in references
2. **Template application** - Ensuring all sections created
3. **Metadata tracking** - Consistent format across updates
4. **Conflict resolution** - Overwrite/append decision handling

### Low Risk
1. **Basic folder creation** - Standard file system operations
2. **Documentation gathering** - Simple file copying
3. **Interactive selection** - Standard numbered list pattern
4. **Success messages** - Static text output

## Test Execution Status

| Test Scenario | Status | Notes |
|---------------|--------|-------|
| Structural Validation | COMPLETE | All commands PASS |
| Scenario 1: New Feature Flow | PENDING | Ready to validate |
| Scenario 2: Re-Planning | PENDING | Ready to validate |
| Scenario 3: Gap Detection | PENDING | Ready to validate |
| Scenario 4: Regeneration | PENDING | Ready to validate |
| Scenario 5: Conflict Detection | PENDING | Ready to validate |
| Scenario 6: Manual Update | PENDING | Ready to validate |
| Cross-Command Integration | PENDING | Ready to validate |
| Error Handling | PENDING | Ready to validate |
| User Experience | PENDING | Ready to validate |
| Output Validation | PENDING | Ready to validate |

## Next Steps

1. Complete logic validation for each command
2. Document workflow sequences and decision trees
3. Verify conditional logic in smart features
4. Create validation report with findings
5. Update tasks.md with completion status

---

**Test Plan Prepared By:** Claude Code
**Date:** 2025-11-21
