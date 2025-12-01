# Test Plan Standard

This standard defines test plan document structure, field definitions, and best practices. It replaces test-plan-template.md by combining structure with standards.

---

## Document Structure

### Header Metadata

```markdown
# Test Plan: [TICKET_ID]

**Feature:** [FEATURE_NAME]
**Ticket ID:** [TICKET_ID]
**Created:** [DATE]
**Version:** 1.0
```

### Section 1: References

**Feature Documentation:**
- Feature Knowledge: `../feature-knowledge.md`
- Feature Test Strategy: `../feature-test-strategy.md`

**Ticket Documentation:**
- Ticket Source: `documentation/[filename]`
- Technical Specs: `documentation/[filename]`
- Mockups/Visuals: `documentation/visuals/`

### Section 2: Ticket Overview

**Executive Summary:** 2-3 sentence summary of test plan status, coverage achieved, readiness

**Ticket Summary:** Brief description of what ticket accomplishes

**Acceptance Criteria:** Numbered list from ticket

### Section 3: Test Scope

**In Scope:** What will be tested for this ticket

**Out of Scope:** What won't be tested, dependencies tested separately

**Dependencies:**
- Internal: Required features/data from this system
- External: Required services/APIs/data sources

### Section 4: Testable Requirements

Table format:
| Req ID | Requirement Summary | Input Conditions | Expected Output | Priority |
|--------|---------------------|------------------|-----------------|----------|
| RQ-01 | [Description] | [Input] | [Expected] | High/Medium/Low |

**Rules:**
- Each requirement must be testable (observable outcome)
- Include input conditions and expected output
- Priority based on business criticality

### Section 5: Test Coverage Matrix

**Coverage Summary:**
- Total Requirements: [N]
- Requirements with Test Cases: [N] ([%]%)
- Total Test Cases: [N]
  - Functional: [N] ([%]%)
  - Edge Cases: [N] ([%]%)
  - Negative: [N] ([%]%)
- Automation Potential: [N]/[total] ([%]%)

**Traceability Table:**
| Requirement ID | Test Case IDs | Coverage Type | Status |
|----------------|---------------|---------------|--------|
| RQ-01 | TC-01, TC-02, TC-03 | Positive, Negative, Edge | Planned |

**Coverage Goals:**
- All requirements must have ≥1 test case
- All requirements must have positive/edge tests where applicable
- All dependency failures tested

### Section 6: Test Scenarios & Cases

**Scenario Format:**
```markdown
### Scenario N: [Scenario Name]

**Objective:** What we're validating

#### TC-XX: [Test Case Title]
- **Type:** Functional - Positive/Negative/Edge
- **Priority:** High/Medium/Low
- **Preconditions:** Setup required
- **Test Steps:**
  1. [Step with specific data]
  2. [Step]
- **Expected Result:** What should happen
- **Test Data:** Reference to Section 7
```

**Test Case Types:**
- **Positive (Happy Path):** Valid inputs, expected workflow
- **Negative (Error Handling):** Invalid inputs, error conditions
- **Edge Cases:** Boundary values, extreme conditions
- **Dependency Failures:** External service errors, timeouts

### Section 7: Test Data Requirements

Table format:
| Data ID | Data Type | Sample Value | Purpose | Test Cases |
|---------|-----------|--------------|---------|------------|
| D-01 | Valid User | user@example.com | Positive path | TC-01 |
| D-02 | Invalid Input | [malformed data] | Negative test | TC-02 |
| D-03 | Boundary Value | [min/max] | Edge case | TC-03 |

**Rules:**
- Reference test data by ID in test cases
- Redact sensitive data, use placeholders
- Include data setup requirements

### Section 8: Environment Setup

**Test Environment:**
- URL: https://[environment].example.com
- Credentials: [Reference to secure storage]

**Configuration:**
- Feature Flags: [Flags needed]
- Test Accounts: [Specific accounts/roles]
- Dependencies: [Mock services, test databases]

### Section 9: Execution Timeline

Table with status tracking:
| Phase | Start Date | End Date | Status | Owner |
|-------|-----------|----------|--------|-------|
| Test Plan Review | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Case Generation | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Environment Setup | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Execution | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Bug Reporting & Triage | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Regression Testing | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |
| Test Summary & Sign-off | [DATE] | [DATE] | ⏳ Not Started | [OWNER] |

**Status Icons:**
- ✅ Complete
- 🔄 In Progress
- ⏳ Not Started
- ⚠️ Blocked

### Section 10: Entry & Exit Criteria

**Entry Criteria (When testing can start):**
- [ ] Ticket deployed to test environment
- [ ] Test data available and verified
- [ ] Dependencies verified working
- [ ] Test plan reviewed and approved

**Exit Criteria (When testing is complete):**
- [ ] All test cases executed
- [ ] No open Critical/High bugs
- [ ] Acceptance criteria met
- [ ] Regression tests passed

### Section 11: Revisions

**Version 1.0 - [DATE]**
- Initial test plan created
- Sections: 12
- Requirements: [N]
- Test scenarios: [N]

**Versioning:**
- Increment major (X.0) for structural changes, new requirements
- Increment minor (X.Y) for scenario updates, data changes

### Section 12: Gap Detection Log

**Date:** [DATE]

**Gaps Found:** Yes/No

**Feature Knowledge Status:** Updated / No updates required

**Analysis:**
[Summary of gap detection. If no gaps: "Ticket requirements compared against feature-knowledge.md. No new business rules, APIs, or edge cases requiring addition to feature knowledge. All ticket-specific details captured in this test plan."]

**New Information Identified:**
- [None OR list of gaps]

**Feature Knowledge Updates:**
- [None OR sections updated in feature-knowledge.md]

**Traceability:**
- [References to feature-knowledge.md sections appended]

---

## Best Practices

### Writing Testable Requirements
- Use measurable, observable outcomes
- Avoid vague terms ("should work well")
- Include specific values, thresholds, timeframes
- Reference business rules from feature-knowledge.md

### Test Coverage Strategy
- **Positive tests:** Verify requirement works as specified
- **Negative tests:** Verify error handling for invalid inputs
- **Edge cases:** Test boundaries (min/max, empty, null, large datasets)
- **Dependency failures:** Test graceful degradation when external services fail

### Test Data Management
- Reuse common test data sets across test cases
- Document data dependencies (test order requirements)
- Include data cleanup steps if tests modify state
- Separate sensitive data (passwords, tokens) with placeholders

### Scenario Organization
- Group related test cases under scenarios
- Order scenarios by user flow (onboarding → usage → edge cases)
- Include both happy path and error paths in each scenario

### Gap Detection Guidelines
- Compare ticket requirements against feature-knowledge.md
- Identify: new business rules, new APIs, new edge cases, new user flows
- Prompt to update feature knowledge if gaps found
- Document traceability (which ticket added what information)

---

## Field Definitions

### Requirement Priority Levels
- **High:** Business critical, affects core functionality
- **Medium:** Important but not critical, has workaround
- **Low:** Nice to have, minor enhancement

### Test Case Priority Levels
- **High:** Critical functionality, must pass for release
- **Medium:** Important functionality, should pass
- **Low:** Edge cases, can defer if needed

### Test Status Values
- **Planned:** Test case defined, not yet executed
- **In Progress:** Currently being executed
- **Passed:** Test executed successfully
- **Failed:** Test failed, bug reported
- **Blocked:** Cannot execute due to blocker
- **Skipped:** Intentionally not executed

---

*This standard replaces test-plan-template.md. All test plan structure, field definitions, and best practices in one place.*
