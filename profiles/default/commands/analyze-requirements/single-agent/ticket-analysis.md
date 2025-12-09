# Phase 2: Ticket Context Analysis with Gap Detection

## Analyze Ticket Documentation and Create Test Plan with Gap Detection

This phase analyzes gathered ticket documentation, detects gaps against feature knowledge, and creates comprehensive ticket test plans.

### Context Detection and Setup

First, detect if we're in ticket context:

```
Check current working directory path:
- If path matches: qa-agent-os/features/[feature-name]/[ticket-id]/
  → Ticket context detected

Otherwise:
- Present interactive selection menu
- Let user select feature first
- Let user enter or select ticket-id
- Validate selected ticket folder exists
```

### Documentation Folder Validation

Check if ticket documentation folder exists and contains files:

```
Validate: qa-agent-os/features/[feature-name]/[ticket-id]/documentation/
- Does folder exist?
- Does it contain readable files?

If empty or insufficient:
  Display prompt:
  "No documentation found in [path]/documentation/

  Please gather documentation before running analysis. You can:

  [1] Show gathering guidance
      Display /gather-docs ticket context guidance

  [2] Cancel, I'll add documentation manually
      Exit without proceeding"
```

If user selects [1], display gathering guidance and exit for them to add files.
If user selects [2], exit gracefully.

### Parent Feature Knowledge Validation

Validate that parent feature has been analyzed:

```
Check for:
- qa-agent-os/features/[feature-name]/feature-knowledge.md
- qa-agent-os/features/[feature-name]/feature-test-strategy.md

If either missing:
  Display error:
  "Error: Parent feature analysis not found.

  Ticket location: qa-agent-os/features/[feature-name]/[ticket-id]
  Feature location: qa-agent-os/features/[feature-name]

  Missing files:
    - feature-knowledge.md
    - feature-test-strategy.md

  Please run /analyze-requirements at feature level first:
    cd qa-agent-os/features/[feature-name]/
    /analyze-requirements

  Then return to plan the ticket."

  Exit without proceeding.
```

### Re-execution Detection

Check if test plan already exists:

```
Check for:
- qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md

If exists:
  Present re-execution options:
  "Test plan already exists for [ticket-id].

  Existing file:
    - test-plan.md (Version X.X)

  Options:
    [1] Full re-analysis (overwrite test-plan.md)
    [2] Append to existing test-plan.md
    [3] Cancel

  Choose [1-3]:"

Handle each option:
- [1] Proceed with full analysis (regenerate test-plan.md)
- [2] Proceed with analysis (append new sections to existing)
- [3] Exit without changes
```

### Ticket Documentation Analysis

Read and analyze all documents in `qa-agent-os/features/[feature-name]/[ticket-id]/documentation/`:

```
For each document, extract:
- Ticket objectives and goals
- Acceptance criteria and requirements
- Specific API details relevant to this ticket
- UI/UX changes and user workflows
- Technical implementation notes
- Test data and examples
- Edge cases specific to this ticket
```

You will:
1. Read all files in the ticket documentation folder
2. Extract ticket-specific requirements and criteria
3. Identify test scenarios and user workflows
4. Note any new information not in feature knowledge
5. Catalog test data requirements

### Gap Detection Algorithm

Compare ticket requirements against `feature-knowledge.md` sections:

**Compare Business Rules:**
- Identify new validation rules
- Identify new business logic
- Identify new constraints
- Classification: [New business rule]

**Compare API Endpoints:**
- Identify new methods/paths
- Identify new request/response formats
- Identify new error scenarios
- Classification: [New API endpoint]

**Compare Edge Cases:**
- Identify new error scenarios
- Identify new boundary conditions
- Identify new special cases
- Classification: [New edge case]

**Compare Data Models:**
- Identify new entities or fields
- Identify new relationships
- Identify schema changes
- Classification: [New data model]

**Result:** Catalog all gaps with:
- Type classification (business rule, API, edge case, data model)
- Description of the gap
- Where it was found in ticket documentation
- Impact on testing strategy

Reference pattern: `profiles/default/commands/plan-ticket/single-agent/3-analyze-requirements.md`

### Gap Detection Visibility (CRITICAL REQUIREMENT)

**ALWAYS display explicit gap detection results when gaps are found.**

When gaps detected:
```
GAP DETECTION RESULTS:
I found [N] gaps between ticket requirements and feature knowledge:

[List each gap with type prefix and description]
1. [New business rule]: [description]
2. [New API endpoint]: [description]
3. [New edge case]: [description]
4. [New data model]: [description]

Would you like me to append these gaps to feature-knowledge.md?
  [1] Yes, append all gaps (with source tracking)
  [2] Let me review first (show detailed gap report)
  [3] No, skip gap updates

Choose [1-3]:
```

**Ensure output is:**
- Prominent and unmissable
- Includes count of gaps
- Lists each gap with type prefix
- Shows brief description for each gap
- Provides clear numbered options

If no gaps detected:
```
Analysis complete - No new information detected.

Your ticket requirements are fully covered by existing feature-knowledge.md.

Proceeding to generate test-plan.md...
```

### Gap Handling Options

**Option [1]: Append All Gaps**
```
Appending gaps to feature-knowledge.md...

Processing [N] gaps with metadata:
- Source: [ticket-id]
- Date: [timestamp in ISO 8601 format]

Adding to appropriate sections:
- Business Rules: [count] new rules
- API Endpoints: [count] new endpoints
- Edge Cases: [count] new cases
- Data Models: [count] new models

feature-knowledge.md updated successfully.
```

Verify successful append and continue to test plan generation.

**Option [2]: Review Detailed Gap Report**
```
DETAILED GAP REPORT:

Gap 1: [Description]
  Type: [New business rule]
  Source: Ticket documentation: [document name]
  Impact: Affects [sections]
  Recommendation: Should be added to feature-knowledge.md Section [X]

Gap 2: [Description]
  Type: [New API endpoint]
  Source: Ticket documentation: [document name]
  Impact: Affects [sections]
  Recommendation: Should be added to feature-knowledge.md Section [X]

[... more gaps ...]

After review, re-prompt gap handling:
"Would you like me to append these gaps to feature-knowledge.md?
  [1] Yes, append all gaps
  [2] No, skip gap updates
  [3] Cancel"
```

**Option [3]: Skip Gap Updates**
```
Skipping gap updates.

Note: Gaps were identified but feature-knowledge.md will not be updated.
You can review the identified gaps in this test plan and update
feature-knowledge.md manually later if needed.

Proceeding to generate test-plan.md...
```

### Generate test-plan.md

Create comprehensive test plan document with 11 sections:

**Section 1: Test Objective**
- Ticket goals and purpose
- What is being tested
- Why it matters
- Testing scope for this ticket

**Section 2: Scope**
- In-scope items for this ticket
- Out-of-scope items
- Dependencies on other tickets
- Assumptions

**Section 3: Requirements**
- Ticket-specific requirements
- Acceptance criteria
- Business rules from feature-knowledge.md
- Requirement traceability references

**Section 4: Test Approach**
- Inherited from feature-test-strategy.md Section 1
- Testing methodologies
- Test types and levels
- Quality gates

**Section 5: Test Environment**
- Inherited from feature-test-strategy.md Section 3
- Environment specifications
- Configuration requirements
- Setup procedures

**Section 6: Test Scenarios**
- Functional test scenarios
- User workflows and journeys
- Happy path testing
- Alternative paths
- Error paths and exception handling

**Section 7: Test Data**
- Test data requirements for this ticket
- Sample data sets
- Edge case data
- Boundary value data
- Data cleanup procedures

**Section 8: Entry/Exit Criteria**
- Ticket-level entry criteria (when to start testing)
- Ticket-level exit criteria (when testing is complete)
- Definition of done
- Sign-off requirements

**Section 9: Dependencies**
- Blocking tickets or features
- Prerequisite work
- External system dependencies
- Environmental dependencies

**Section 10: Risks**
- Ticket-specific testing risks
- Mitigation strategies
- Risk assessment (high/medium/low)
- Contingency plans

**Section 11: Revision Log**
- Version history with dates
- Change tracking for iterative updates
- Format for `/revise-test-plan` updates

Reference template: `@qa-agent-os/templates/test-plan-template.md`

Output location: `qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md`

### Test Case Generation Offer

After successful test-plan.md creation:

```
Test plan created successfully!

Location: qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md
Sections: 11
Requirement traceability: Complete
[Gap detection results summary if gaps were appended]

Options:
  [1] Generate test cases now (/generate-testcases)
  [2] Stop for review (you can run /generate-testcases later)

Choose [1-2]:
```

Handle each option:
- [1] Offer to run `/generate-testcases [ticket-id]`
- [2] Exit with guidance message

Exit message if [2]:
```
Ticket planning paused for review.

Created:
- Test plan: qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md

When ready to generate test cases, run:
  /generate-testcases

This allows you to:
- Review the test plan with stakeholders
- Refine test scenarios if needed
- Get additional clarification
- Generate cases when confident

Good luck with your testing!
```

### Success Output

Display comprehensive success message:

```
Ticket analysis complete!

Created:
- test-plan.md (11 sections)
  Location: qa-agent-os/features/[feature-name]/[ticket-id]/test-plan.md

Analysis details:
- Acceptance criteria extracted: [count]
- Test scenarios identified: [count]
- Test data requirements: [count]
- Risks identified: [count]

[If gaps were appended:]
Gap detection results:
- Gaps identified: [count]
- Gaps appended to feature-knowledge.md: [count]
- Feature knowledge updated: [timestamp]

Next steps:
1. Review test plan for accuracy
2. Share with stakeholders if needed
3. Generate test cases: /generate-testcases
4. Execute testing: Follow test-plan.md guidance

Ticket path: qa-agent-os/features/[feature-name]/[ticket-id]/
Feature path: qa-agent-os/features/[feature-name]/
```

### Key Implementation Notes

- Gap detection must ALWAYS show explicit results when gaps are found
- Gap appending must include source ticket-id and timestamp
- Parent feature analysis must exist before ticket analysis proceeds
- Test plan generation should offer test case generation immediately after
- All documents should be properly formatted with clear section numbering
- Success messages should include summary of what was created and discovered
