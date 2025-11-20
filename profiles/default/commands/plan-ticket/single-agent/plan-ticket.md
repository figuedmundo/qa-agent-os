# /plan-ticket Command

## Purpose

Plan comprehensive test coverage for a specific ticket with intelligent feature detection, gap detection, and flexible test case generation.

## Usage

```bash
/plan-ticket WYX-123
/plan-ticket "TICKET-001"
/plan-ticket ticket-abc-456
```

## Smart Features

This command includes intelligent features that make planning easier:

### 1. Smart Feature Detection
- Automatically discovers existing features in your project
- Shows a numbered list if multiple features exist
- Auto-selects if only one feature exists
- Offers to create a new feature if needed

### 2. Existing Ticket Detection
- Detects if you're re-planning an existing ticket
- Offers 4 re-execution options:
  - Full re-plan (refresh everything)
  - Update test plan only (analyze requirements again)
  - Regenerate test cases only (from existing plan)
  - Cancel (no changes)

### 3. Intelligent Gap Detection
- Compares ticket requirements against feature-knowledge.md
- Identifies new business rules, APIs, edge cases
- Prompts to update feature knowledge with new information
- Maintains traceability (which ticket added what requirement)

### 4. Flexible Test Case Generation
- Offers to generate test cases immediately after test plan
- Or stop for review and generate later with `/generate-testcases`
- Accommodates real-world QA workflows

## Execution Phases

This is an orchestrated command with 5 phases (0-4):

{{PHASE 0: @qa-agent-os/commands/plan-ticket/0-detect-context.md}}

{{PHASE 1: @qa-agent-os/commands/plan-ticket/1-init-ticket.md}}

{{PHASE 2: @qa-agent-os/commands/plan-ticket/2-gather-ticket-docs.md}}

{{PHASE 3: @qa-agent-os/commands/plan-ticket/3-analyze-requirements.md}}

{{PHASE 4: @qa-agent-os/commands/plan-ticket/4-generate-cases.md}}

## Workflow Scenarios

### Scenario 1: New Ticket in Existing Feature

```
/plan-ticket WYX-123
  ├─ Phase 0: Auto-selects feature "TWRR"
  ├─ Phases 1-2: Create folders and gather docs
  ├─ Phase 3: Analyzes requirements
  │           Detects no new info → feature knowledge unchanged
  ├─ Phase 4: Prompts for test case generation
  └─ Creates: test-plan.md and optionally test-cases.md
```

### Scenario 2: Second Ticket with Gap Detection

```
/plan-ticket WYX-124
  ├─ Phase 0: Auto-selects feature "TWRR"
  ├─ Phases 1-2: Create folders and gather docs
  ├─ Phase 3: Analyzes requirements
  │           Detects new calculation logic not in feature knowledge
  │           Prompts: "Update feature-knowledge.md?"
  │           User confirms → Appends new section with source and date
  ├─ Phase 4: Prompts for test case generation
  │           User chooses "2 - Stop and review first"
  └─ Creates: test-plan.md only (not test-cases.md yet)
```

### Scenario 3: Re-planning Existing Ticket

```
/plan-ticket WYX-123
  ├─ Phase 0: Detects existing ticket
  │           Offers: [1] Full re-plan [2] Update test plan [3] Regenerate cases [4] Cancel
  │           User chooses "2 - Update test plan only"
  ├─ Phase 3: Re-analyzes requirements
  │           Updates test-plan.md with new scenarios
  │           Increments version in revision log
  └─ Prompts: Continue to Phase 4? User says yes
              Regenerates test-cases.md
```

## Success Criteria

When /plan-ticket completes successfully, you will have:

**For New Tickets:**
- ✓ Ticket folder created: `features/[feature-name]/[ticket-id]/`
- ✓ Documentation gathered and organized
- ✓ Test plan created: `test-plan.md` (11 sections with requirements analysis)
  - References feature-knowledge.md and feature-test-strategy.md
  - Includes testable requirements breakdown
  - Test coverage matrix showing requirement-to-case mapping
  - Test scenarios with positive, negative, edge cases
- ✓ Optional test cases created: `test-cases.md` (if Phase 4 option 1 chosen)
  - Detailed executable test cases
  - Clear steps and expected results
  - Test data references
  - Execution tracking checkboxes
- ✓ Feature knowledge updated if gaps detected
  - New section with metadata and source reference

**For Re-execution:**
- ✓ Appropriate phase(s) re-run based on your selection
- ✓ Documents updated with proper revision tracking
- ✓ No unnecessary work - you control the scope

## Next Steps

After /plan-ticket completes:

1. **Review test plan** - Examine what was created
2. **If test cases not generated yet** - Run `/generate-testcases` when ready
3. **If test plan needs updates** - Run `/revise-test-plan` during execution
4. **If feature knowledge needs updates** - Run `/update-feature-knowledge` (rare)

## Related Commands

- `/plan-feature` - Plan an entire feature (do this first if feature doesn't exist)
- `/generate-testcases` - Generate or regenerate test cases anytime
- `/revise-test-plan` - Update test plan during testing
- `/update-feature-knowledge` - Manually update feature knowledge

---

*This command handles the complete ticket planning workflow with smart detection to make your QA work more efficient.*
