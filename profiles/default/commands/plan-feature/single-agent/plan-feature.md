# /plan-feature Command

## Purpose

Complete feature initialization and planning in one orchestrated command. This command runs 4 phases automatically to help you plan an entire feature:

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

## Workflow Overview

This command orchestrates a complete feature planning workflow:

- **Phase 1** creates the folder structure (`features/[feature-name]/documentation/`)
- **Phase 2** prompts you to gather all stakeholder documentation
- **Phase 3** analyzes those documents and creates `feature-knowledge.md` (8 sections consolidating WHAT is being built)
- **Phase 4** creates `feature-test-strategy.md` (10 sections defining HOW the feature will be tested)

After completion, you'll have:
- A complete feature folder structure
- A master feature knowledge document with all requirements and business rules
- A strategic test approach for the feature
- Ready to start planning individual tickets with `/plan-ticket`

## Execution Phases

Follow the numbered instruction files IN SEQUENCE:

{{PHASE 1: @qa-agent-os/commands/plan-feature/1-init-structure.md}}

{{PHASE 2: @qa-agent-os/commands/plan-feature/2-gather-docs.md}}

{{PHASE 3: @qa-agent-os/commands/plan-feature/3-consolidate-knowledge.md}}

{{PHASE 4: @qa-agent-os/commands/plan-feature/4-create-strategy.md}}

## Success Criteria

When /plan-feature completes successfully, you will have:

- ✓ Feature folder structure created: `features/[feature-name]/documentation/`
- ✓ All relevant documentation collected and organized
- ✓ Feature knowledge document created: `features/[feature-name]/feature-knowledge.md`
  - Contains 8 sections with comprehensive feature requirements
  - References all source documents
  - Includes metadata (Last Updated, Active status)
- ✓ Test strategy document created: `features/[feature-name]/feature-test-strategy.md`
  - Contains 10 sections with strategic testing decisions
  - Includes risk assessment, entry/exit criteria
  - Documents test levels, types, tools, environments
- ✓ Ready to begin ticket planning with `/plan-ticket`

## Next Steps

After /plan-feature completes:

1. Review the created documents for accuracy
2. For each ticket in the feature, run: `/plan-ticket [ticket-id]`
3. The ticket planner will automatically detect your feature
4. Ticket-level test plans will reference the feature-level strategy

## Command Flow

```
/plan-feature [feature-name]
  ├─ Phase 1: Initialize structure
  ├─ Phase 2: Gather documentation
  ├─ Phase 3: Consolidate knowledge
  ├─ Phase 4: Create test strategy
  └─ Complete! Ready for tickets
```

## Related Commands

- `/plan-ticket` - Plan testing for a specific ticket in this feature
- `/update-feature-knowledge` - Manually update feature knowledge (rare)
- `/revise-test-plan` - Update test plan during ticket testing

---

*This command follows the agent-os proven pattern of gathering information first, then consolidating into structured documentation.*
