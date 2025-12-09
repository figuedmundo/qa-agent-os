# /analyze-requirements Command

## Purpose

Analyze gathered documentation and create knowledge/strategy/test plans based on context. This command intelligently detects whether you're working on a feature or ticket and generates the appropriate documents with AI-powered analysis.

## Usage

```bash
/analyze-requirements
```

Run this command from:
- A feature directory: `qa-agent-os/features/[feature-name]/`
- A ticket directory: `qa-agent-os/features/[feature-name]/[ticket-id]/`
- Or from anywhere (interactive selection)

## Workflow Overview

This command performs different analysis based on your context:

### Feature Context
When run in a feature directory, it:
1. Validates that documentation has been gathered
2. Checks for existing analysis documents
3. Analyzes all documentation in `qa-agent-os/features/[feature-name]/documentation/`
4. Extracts business rules, APIs, data models, edge cases, dependencies
5. Generates `feature-knowledge.md` (8 sections)
6. Generates `feature-test-strategy.md` (10 sections)
7. Displays success message with next steps

### Ticket Context
When run in a ticket directory, it:
1. Validates that documentation has been gathered
2. Validates that parent feature analysis exists
3. Checks for existing test plan
4. Analyzes ticket-specific documentation
5. Compares against `feature-knowledge.md` to detect gaps
6. **ALWAYS displays gap detection results when gaps found**
7. Prompts to append gaps to feature knowledge
8. Generates `test-plan.md` (11 sections)
9. Offers test case generation
10. Displays success message with next steps

## Smart Context Detection

### Feature Context Behavior
```
Context detected: Feature
Location: qa-agent-os/features/user-authentication

Validating documentation...
✓ Documentation folder found
✓ Contains readable files (5 documents)

Checking for existing analysis...
[No existing analysis]

Analyzing documentation...
- Extracting business rules
- Identifying API endpoints
- Cataloging data models
- Documenting edge cases
- Noting dependencies

Generating feature-knowledge.md (8 sections):
  1. Overview
  2. Business Rules
  3. API Endpoints
  4. Data Models
  5. Edge Cases
  6. Dependencies
  7. Open Questions
  8. References

Generating feature-test-strategy.md (10 sections):
  1. Testing Approach
  2. Tools
  3. Environment
  4. Test Data Strategy
  5. Risks
  6. Entry/Exit Criteria
  7. Dependencies
  8. Schedule
  9. Resources
  10. References

Success! Feature analysis complete.
Location: qa-agent-os/features/user-authentication/

Next steps:
1. Review the generated documents
2. Run /start-ticket to begin ticket planning
3. Each ticket will inherit the feature strategy
```

### Ticket Context Behavior with Gap Detection
```
Context detected: Ticket
Location: qa-agent-os/features/user-authentication/AUTH-123

Validating documentation...
✓ Documentation folder found
✓ Contains readable files (3 documents)

Validating parent feature analysis...
✓ feature-knowledge.md found
✓ feature-test-strategy.md found

Analyzing ticket documentation...
- Extracting ticket objectives
- Identifying acceptance criteria
- Cataloging test scenarios
- Extracting test data

Comparing against feature knowledge...

GAP DETECTION RESULTS:
I found 3 gaps between ticket requirements and feature knowledge:

1. [New business rule]: MFA support for social login providers
2. [New API endpoint]: POST /api/auth/mfa/verify - Two-factor authentication verification
3. [New edge case]: Token expiration during multi-step authentication flow

Would you like me to append these gaps to feature-knowledge.md?
  [1] Yes, append all gaps (with source tracking)
  [2] Let me review first (show detailed gap report)
  [3] No, skip gap updates

Choose [1-3]:
```

### No Context Detected
```
I couldn't detect your context. Please select:

[1] Analyze feature
  Analyze feature-level documentation and create knowledge/strategy

[2] Analyze ticket
  Analyze ticket-level documentation with gap detection

[3] Cancel
  Exit without analysis

Choose [1-3]:
```

## Feature Context: Documentation Validation

If documentation folder is empty:
```
No documentation found in qa-agent-os/features/user-authentication/documentation/

Please gather documentation before running analysis. You can:

[1] Show gathering guidance
  Run /gather-docs to see what documentation to collect

[2] Cancel, I'll add documentation manually
  Exit and add files yourself

Choose [1-2]:
```

If you select [1], the guidance from `/gather-docs` will be displayed.

## Feature Context: Re-execution Detection

If `feature-knowledge.md` and/or `feature-test-strategy.md` already exist:
```
Feature analysis already exists for user-authentication.

Existing files:
  - feature-knowledge.md (Version 1.0)
  - feature-test-strategy.md (Version 1.0)

Options:
  [1] Full re-analysis (overwrite both documents)
  [2] Update feature-knowledge.md only
  [3] Update feature-test-strategy.md only
  [4] Cancel

Choose [1-4]:
```

## Ticket Context: Parent Feature Validation

If parent feature analysis doesn't exist:
```
Error: Parent feature analysis not found.

Ticket location: qa-agent-os/features/user-authentication/AUTH-123
Feature location: qa-agent-os/features/user-authentication

Missing files:
  - feature-knowledge.md
  - feature-test-strategy.md

Please run /analyze-requirements at feature level first:
  cd qa-agent-os/features/user-authentication/
  /analyze-requirements

Then return to plan the ticket.
```

## Ticket Context: Documentation Validation

If documentation folder is empty:
```
No documentation found in qa-agent-os/features/user-authentication/AUTH-123/documentation/

Please gather documentation before running analysis. You can:

[1] Show gathering guidance
  Run /gather-docs to see what ticket documentation to collect

[2] Cancel, I'll add documentation manually
  Exit and add files yourself

Choose [1-2]:
```

## Ticket Context: Gap Detection Visibility

**CRITICAL REQUIREMENT**: When gaps are detected, ALWAYS display explicit results:

```
GAP DETECTION RESULTS:
I found 4 gaps between ticket requirements and feature knowledge:

1. [New business rule]: Session timeout configuration per user role
2. [New API endpoint]: GET /api/auth/sessions - List active user sessions
3. [New edge case]: Concurrent login limit enforcement across devices
4. [New data model]: Session metadata storage for audit tracking

Would you like me to append these gaps to feature-knowledge.md?
  [1] Yes, append all gaps (with source tracking)
  [2] Let me review first (show detailed gap report)
  [3] No, skip gap updates

Choose [1-3]:
```

If no gaps detected:
```
Analysis complete - No new information detected.

Your ticket requirements are fully covered by existing feature-knowledge.md.

Generating test-plan.md...
```

## Ticket Context: Gap Appending

When gaps are appended to `feature-knowledge.md`:
```
Appending gaps to feature-knowledge.md...

Added 3 gaps with metadata:
- Source: AUTH-123
- Date: 2024-12-08T15:30:00Z

Updated sections:
- Business Rules (1 new rule)
- API Endpoints (1 new endpoint)
- Edge Cases (1 new case)

feature-knowledge.md updated successfully.
```

## Ticket Context: Re-execution Detection

If `test-plan.md` already exists:
```
Test plan already exists for AUTH-123.

Existing file:
  - test-plan.md (Version 1.0)

Options:
  [1] Full re-analysis (overwrite test-plan.md)
  [2] Append to existing test-plan.md
  [3] Cancel

Choose [1-3]:
```

## Ticket Context: Test Case Generation Offer

After successful test-plan.md creation:
```
Test plan created successfully!

Location: qa-agent-os/features/user-authentication/AUTH-123/test-plan.md
Sections: 11
Requirement traceability: Complete
Gap detection: 3 gaps appended to feature-knowledge.md

Options:
  [1] Generate test cases now (/generate-testcases)
  [2] Stop for review (you can run /generate-testcases later)

Choose [1-2]:
```

If user selects [1], offer to run `/generate-testcases`.
If user selects [2], exit with guidance to run it later.

## Execution Phases

This command routes to context-specific analysis:

{{PHASE 1: @qa-agent-os/commands/analyze-requirements/single-agent/feature-analysis.md}}

{{PHASE 2: @qa-agent-os/commands/analyze-requirements/single-agent/ticket-analysis.md}}

## Success Criteria

### Feature Context Success
- ✓ feature-knowledge.md created with 8 sections properly populated
- ✓ feature-test-strategy.md created with 10 sections properly populated
- ✓ Both documents reference appropriate templates
- ✓ Success message includes file paths and next steps

### Ticket Context Success
- ✓ Gap detection runs and displays results when gaps found
- ✓ **Gap detection ALWAYS visible and unmissable**
- ✓ Gap handling prompt provides clear numbered options
- ✓ Gaps appended with proper metadata (source ticket-id and timestamp)
- ✓ test-plan.md created with 11 sections properly populated
- ✓ Test case generation offer presented
- ✓ Success message includes gap summary and next steps

## Related Commands

- `/start-feature` - Create feature folder structure
- `/start-ticket` - Create ticket folder structure
- `/gather-docs` - Display guidance for documentation gathering
- `/generate-testcases` - Generate test cases from test-plan.md
- `/revise-test-plan` - Update test plan during testing

---

*This command is part of the redesigned QA workflow that separates structure initialization, documentation gathering, and analysis into discrete steps. Gap detection is a critical feature that ensures feature knowledge stays current with ticket-specific discoveries.*
