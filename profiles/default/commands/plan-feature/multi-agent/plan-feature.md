# /plan-feature Command (Multi-Agent Mode)

## Purpose

Complete feature initialization and planning using specialized agents. This command orchestrates a complete feature planning workflow in 4 phases:

1. **Initialize feature folder structure** - Create the directory hierarchy
2. **Gather feature documentation** - Collect BRDs, API specs, mockups, etc.
3. **Consolidate feature knowledge** - Create the master feature-knowledge.md document
4. **Create feature test strategy** - Define HOW the feature will be tested

## Usage

```bash
/plan-feature TWRR
/plan-feature "Portfolio Analytics"
/plan-feature payment-processing
```

## Execution Flow

### PHASE 1-2: Initialize and Gather

Use the **feature-initializer** subagent to set up the feature structure and gather documentation.

Provide the feature-initializer with:
- Feature name (from command parameter)
- Any initial documentation or links provided by user

The feature-initializer will:
- Create feature folder structure at `qa-agent-os/features/[feature-name]/`
- Create documentation/ subfolder
- Create README.md with feature information
- Gather BRDs, API specifications, mockups, and technical documentation
- Organize all documentation in the documentation/ folder
- Execute workflows: `workflows/planning/initialize-feature` and `workflows/planning/gather-feature-docs`

### PHASE 3: Consolidate Feature Knowledge

Use the **requirement-analyst** subagent to consolidate all documentation into feature-knowledge.md.

Provide the requirement-analyst with:
- Feature path: `qa-agent-os/features/[feature-name]/`
- Documentation collected in Phase 2 (in documentation/ folder)

The requirement-analyst will:
- Analyze all collected documentation
- Extract business rules, APIs, edge cases, user flows, and requirements
- Create `feature-knowledge.md` with 8 comprehensive sections:
  1. Feature Overview
  2. Business Rules
  3. API Endpoints & Integration Points
  4. User Flows
  5. Edge Cases & Error Scenarios
  6. Dependencies & Constraints
  7. Open Questions
  8. Source Documents
- Execute workflow: `workflows/planning/consolidate-feature-knowledge`

### PHASE 4: Create Test Strategy

Use the **requirement-analyst** subagent to create the feature-level test strategy.

Provide the requirement-analyst with:
- Feature path: `qa-agent-os/features/[feature-name]/`
- Feature knowledge from Phase 3 (`feature-knowledge.md`)

The requirement-analyst will:
- Define comprehensive testing approach for the feature
- Document test environment, tools, and resources needed
- Identify testing risks and mitigation strategies
- Create `feature-test-strategy.md` with 10 strategic sections:
  1. Test Strategy Overview
  2. Test Levels
  3. Test Types
  4. Test Environment
  5. Test Tools
  6. Test Data Strategy
  7. Entry/Exit Criteria
  8. Risk Assessment
  9. Resource Requirements
  10. Deliverables
- Execute workflow: `workflows/planning/create-test-strategy`

### Completion

Once all agents have completed their work:

```
✓ Feature planning complete!

Created:
- Feature folder: qa-agent-os/features/[feature-name]/
- Feature knowledge: qa-agent-os/features/[feature-name]/feature-knowledge.md
- Test strategy: qa-agent-os/features/[feature-name]/feature-test-strategy.md

NEXT STEP: Run /plan-ticket [ticket-id] to plan testing for individual tickets
```

## Related Commands

- `/plan-ticket` - Plan testing for a specific ticket in this feature
- `/update-feature-knowledge` - Manually update feature knowledge (rare)
- `/revise-test-plan` - Update test plan during ticket testing

---

*This command leverages specialized agents to efficiently plan features with expert domain knowledge.*
