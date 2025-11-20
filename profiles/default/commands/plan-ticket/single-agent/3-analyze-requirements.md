# Phase 3: Analyze Requirements & Detect Gaps

## Intelligent Gap Detection & Test Plan Creation

I will now analyze the ticket requirements against the feature knowledge to detect any gaps and create a comprehensive test plan.

**What I'm doing:**

### Step 1: Read All Available Information

- Ticket documentation from `documentation/` directory
- Feature knowledge from `../feature-knowledge.md`
- Feature test strategy from `../feature-test-strategy.md`

### Step 2: Analyze Ticket Requirements

Extract and organize:
- Main objectives and acceptance criteria
- Business rules specific to this ticket
- API endpoints or technical details
- Input/output specifications
- Edge cases or special handling

### Step 3: Compare Against Feature Knowledge

Check if ticket introduces:
- **New business rules** not in feature-knowledge.md
- **New API endpoints** not documented before
- **New calculations** or technical requirements
- **New edge cases** or constraints
- **New user flows** or interactions

### Step 4: Gap Detection & Feature Knowledge Update

**If I find gaps, I'll prompt you:**

```
I found new information not in feature-knowledge.md:

- New business rule: [Description]
- New API endpoint: POST /api/[endpoint]
- New edge case: [Description]

Would you like me to append this to feature-knowledge.md? [y/n]
```

**If you choose YES:**
- I'll append a new section to feature-knowledge.md with format:
  ```markdown
  ## [Section added from ticket [ticket-id] on [date]]

  ### [Topic]
  [Content from your ticket]

  **Source:** Ticket [ticket-id]
  **Added:** [date] during ticket requirement analysis
  ```
- This maintains traceability - you can always see which ticket introduced which requirement

**If you choose NO:**
- Feature knowledge remains unchanged
- Test plan will focus only on what's in this ticket

### Step 5: Create Test Plan

I'll create `features/[feature-name]/[ticket-id]/test-plan.md` with:

1. **References** - Links to feature docs and ticket sources
2. **Ticket Overview** - Summary and acceptance criteria
3. **Test Scope** - What will/won't be tested
4. **Testable Requirements** - Detailed breakdown with inputs/outputs
5. **Test Coverage Matrix** - Requirement → Test Case traceability
6. **Test Scenarios & Cases** - Positive, negative, edge cases
7. **Test Data Requirements** - Data needed for testing
8. **Environment Setup** - URLs, accounts, configuration
9. **Execution Timeline** - Dates and milestones
10. **Entry/Exit Criteria** - When testing can start/end
11. **Revisions** - Change log (Version 1.0 entry created)

**Key Points:**

- Test plan inherits strategy from `feature-test-strategy.md`
- Test plan focuses on this ticket's specific requirements
- All referenced documents are linked for easy access
- Revision log tracks changes for future updates

**Next Phase:**

After test plan is created, you'll be offered:
```
Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first, generate test cases later)
```

Choose based on your needs:
- **Option 1** - Generate detailed test cases immediately
- **Option 2** - Review and refine test plan, generate cases later with `/generate-testcases`

Analyzing requirements now...
