# Phase 4: Generate Test Cases (Optional)

## Flexible Test Case Generation

You now have the option to generate detailed test cases from the test plan, or stop to review the plan first.

**Your choices:**

### Option 1: Generate Test Cases Now

```
[1] Continue to Phase 4: Generate test cases now
```

I will:
1. Read your test-plan.md
2. Extract scenarios from Section 6 (Test Scenarios & Cases)
3. Extract test data from Section 7 (Test Data Requirements)
4. Extract coverage requirements from Section 5 (Test Coverage Matrix)
5. Generate detailed executable test cases in `test-cases.md`

Each test case will include:
- Test ID, Type, Priority, Requirement link
- Clear objective of what's being tested
- Preconditions needed to run the test
- Test steps in table format (Step | Action | Expected Result)
- Test data references
- Expected final result
- Checkboxes for execution results (Pass/Fail/Blocked)
- Space for notes and defect links

**Coverage includes:**
- Positive tests (happy path)
- Negative tests (error handling)
- Edge cases (boundary values)
- Dependency failure scenarios (external service errors)

**Result:**
- `features/[feature-name]/[ticket-id]/test-cases.md` created
- Ready for immediate test execution
- Test execution summary table for tracking progress

---

### Option 2: Stop & Review First

```
[2] Stop here (review test plan first, generate test cases later)
```

I will:
1. Create `features/[feature-name]/[ticket-id]/test-plan.md` only
2. NOT create test-cases.md
3. Exit the command with a helpful message

**When to choose this option:**
- You want to review the test plan with stakeholders first
- You need additional information from the Product Owner
- You want to refine test scenarios before generating cases
- You prefer to review test coverage before committing to cases

**Generating test cases later:**

When you're ready to generate test cases, run:
```bash
/generate-testcases
```

This will:
- Ask which ticket to generate cases for
- Read the existing test-plan.md
- Generate test-cases.md from it

You can do this anytime:
- Immediately after planning
- Days or weeks later
- After discussing with stakeholders
- After getting additional requirements

---

## Making Your Choice

**Test plan is now ready at:**
```
features/[feature-name]/[ticket-id]/test-plan.md
```

**Choose your option:**

```
Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first, generate test cases later)

Choose [1/2]:
```

**Why This Flexibility Matters:**

Real-world QA workflows often need time to:
- Review requirements with stakeholders
- Get clarification from developers
- Refine edge cases
- Prioritize test coverage

By allowing a stop point after the test plan, you can:
- Take time for proper review
- Gather additional information
- Refine your approach
- Generate cases when you're confident

The test plan is comprehensive and ready. Generate cases whenever you're ready.

What would you like to do?
