# Phase 3: Analyze Requirements & Detect Gaps

## Intelligent Requirement Analysis

This phase analyzes ticket requirements against feature knowledge and creates a comprehensive test plan.

### Variables from Previous Phases

Set by previous phases:
- **TICKET_PATH**: `qa-agent-os/features/[feature]/[ticket-id]`
- **FEATURE_PATH**: `qa-agent-os/features/[feature]`
- **FEATURE_KNOWLEDGE_PATH**: `[feature-path]/feature-knowledge.md`
- **FEATURE_STRATEGY_PATH**: `[feature-path]/feature-test-strategy.md`

### Execute Requirement Analysis Workflow

{{workflows/testing/requirement-analysis}}

The workflow references: `@qa-agent-os/standards/testcases/test-plan.md`

The workflow will:
- Read ticket documentation from `[ticket-path]/documentation/`
- Read feature knowledge and test strategy
- Analyze ticket requirements (objectives, business rules, APIs, edge cases)
- Compare ticket requirements against feature knowledge
- Detect gaps (new business rules, APIs, edge cases not in feature knowledge)
- Prompt to update feature-knowledge.md if gaps found
- Create comprehensive test-plan.md with 11 sections

**Gap Detection:**

If the workflow finds new information not documented in feature-knowledge.md, it will prompt:

```
Gap Detection: I found new information not in feature-knowledge.md

New Business Rule:
- [Description]

New API Endpoint:
- POST /api/[endpoint]

Would you like me to append this to feature-knowledge.md? [y/n]
```

If you choose **yes**, the workflow updates feature knowledge with traceability metadata.

### Post-Workflow Actions

After workflow completes, prompt user:

```
Test plan created successfully!

Location: [ticket-path]/test-plan.md
Version: 1.0
Sections: 11

Feature knowledge updated: [yes/no]

Options:
  [1] Continue to Phase 4: Generate test cases now
  [2] Stop here (review test plan first, generate test cases later)

Choose [1/2]:
```

**If user chooses [1]:** Proceed to Phase 4
**If user chooses [2]:** Exit command with helpful message:

```
Ticket planning paused for review.

Created:
- Test plan: [ticket-path]/test-plan.md

When ready to generate test cases, run:
  /generate-testcases

This allows you to:
- Review the test plan with stakeholders
- Refine test scenarios
- Get additional clarification
- Generate cases when confident

Good luck with your testing!
```
