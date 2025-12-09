# /gather-docs Command

## Purpose

Display guidance prompts for documentation gathering based on your current context. This is a user-driven command that shows what documentation you should collect without performing any automation. You manually add files to the documentation folders.

## Usage

```bash
/gather-docs
```

Run this command from:
- A feature directory: `qa-agent-os/features/[feature-name]/`
- A ticket directory: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Or from anywhere (interactive selection)

## Workflow Overview

This command:

1. Detects your current context (feature or ticket)
2. Displays guidance on what documentation to gather
3. Shows the target documentation path clearly
4. Lists recommended document types with descriptions
5. Provides next steps (run `/analyze-requirements`)
6. Supports re-execution to display guidance again

## Smart Context Detection

### Feature Context
If you run `/gather-docs` from a feature directory, it will display:

```
Please gather the following documentation and place in:
qa-agent-os/features/[feature-name]/documentation/

Recommended documents:
- Business Requirements Document (BRD)
  Captures business goals, rules, requirements for the entire feature

- API specifications or endpoint documentation
  Defines API contracts, request/response formats, error handling

- UI/UX mockups or wireframes
  Shows user interface design, flows, and user interactions

- Technical architecture documents
  Describes system design, components, integrations, dependencies

- Database schema or data models
  Documents entities, relationships, constraints, and data structures

- Any feature-specific technical documentation
  Additional specs, design decisions, implementation notes

Once you've added documentation, run: /analyze-requirements
```

### Ticket Context
If you run `/gather-docs` from a ticket directory, it will display:

```
Please gather the following documentation and place in:
qa-agent-os/features/[feature-name]/[ticket-id]/documentation/

Recommended documents:
- Ticket description or user story
  Full details of what needs to be tested in this ticket

- Acceptance criteria
  Specific conditions that must be met for the feature to work

- API endpoint details specific to this ticket
  Request/response examples, parameters, edge cases relevant to this ticket

- Screen mockups or UI changes
  Visual representation of UI changes or new screens for this ticket

- Technical implementation notes
  Implementation details, algorithms, special considerations

- Any ticket-specific test data or examples
  Sample data, test scenarios, edge cases, boundary values

Once you've added documentation, run: /analyze-requirements
```

### No Context Detected
If you run `/gather-docs` from a directory where context cannot be detected:

```
I couldn't detect your context. Please select:

[1] Gather for feature
  Shows guidance for collecting feature-level documentation

[2] Gather for ticket
  Shows guidance for collecting ticket-specific documentation

[3] Cancel
  Exit without displaying guidance

Choose [1-3]:
```

If you select [1] or [2], you'll be prompted to select which feature/ticket:
```
Which feature? (Available features in qa-agent-os/features/)
[1] user-authentication
[2] payment-processing
[3] Cancel
```

## Re-execution

This command is designed to be re-executed. You can run `/gather-docs` multiple times:
- To see the guidance again
- To add more documentation later
- To confirm the documentation path

Each execution displays the same guidance without affecting existing files.

## No File Operations

This command performs NO file operations:
- Does not create files
- Does not move files
- Does not modify existing documentation
- Only displays guidance text

## Success Output

After displaying guidance:
```
Documentation gathering guidance displayed.

Target path: qa-agent-os/features/[feature-name]/documentation/
(or qa-agent-os/features/[feature-name]/[ticket-id]/documentation/ for tickets)

Once you've added your documentation files, run:
  /analyze-requirements

This will analyze your documentation and create:
- feature-knowledge.md and feature-test-strategy.md (for features)
- test-plan.md (for tickets, with gap detection)
```

## Next Steps

After gathering your documentation:

1. Place documents in the appropriate `documentation/` folder
2. Run `/analyze-requirements` to create knowledge and strategy documents
3. The analysis will read all files in the documentation folder and create comprehensive plans

## Related Commands

- `/start-feature` - Create feature folder structure
- `/start-ticket` - Create ticket folder structure
- `/analyze-requirements` - Analyze gathered documentation and create plans

---

*This command is part of the redesigned QA workflow that separates structure initialization, documentation gathering, and analysis into discrete steps.*
