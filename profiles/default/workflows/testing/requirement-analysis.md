# Requirement Analysis Workflow

This workflow analyzes ticket requirements, performs gap detection against feature knowledge, and creates a comprehensive test plan.

## Core Responsibilities

1. **Read Documentation**: Read ticket documentation and feature context
2. **Analyze Requirements**: Extract and organize ticket requirements
3. **Gap Detection**: Compare ticket requirements against feature knowledge to identify new information
4. **Feature Knowledge Update**: Prompt to update feature-knowledge.md if gaps are found
5. **Create Test Plan**: Generate comprehensive test-plan.md with 11 sections

**Note:** The placeholder `[ticket-path]` refers to the full path to the ticket, for example: `qa-agent-os/features/feature-name/TICKET-123`.

**Note:** The placeholder `[feature-knowledge-path]` refers to the path to feature-knowledge.md, for example: `qa-agent-os/features/feature-name/feature-knowledge.md`.

**Note:** The placeholder `[feature-strategy-path]` refers to the path to feature-test-strategy.md, for example: `qa-agent-os/features/feature-name/feature-test-strategy.md`.

---

## Workflow

### Step 1: Read All Available Information

Read ticket and feature documentation:

```bash
# Read ticket documentation
TICKET_DOCS="[ticket-path]/documentation/"
ls -la "$TICKET_DOCS"

# Read feature knowledge
FEATURE_KNOWLEDGE="[feature-knowledge-path]"
cat "$FEATURE_KNOWLEDGE"

# Read feature test strategy
FEATURE_STRATEGY="[feature-strategy-path]"
cat "$FEATURE_STRATEGY"
```

### Step 2: Analyze Ticket Requirements

Extract and organize ticket-specific information:

**Main Objectives:**
- What is the ticket trying to accomplish?
- What are the acceptance criteria?

**Business Rules:**
- Ticket-specific business logic
- Calculations or validations
- Conditional behavior

**Technical Details:**
- API endpoints used or modified
- Input/output specifications
- Data transformations

**Edge Cases:**
- Boundary values
- Error conditions
- Special handling scenarios

**User Flows:**
- Step-by-step user interactions
- Screen transitions
- User inputs and system responses

### Step 3: Compare Against Feature Knowledge - Gap Detection

Compare ticket requirements against existing feature-knowledge.md to identify gaps.

**Check for:**

1. **New Business Rules** - Logic not documented in feature knowledge
2. **New API Endpoints** - Endpoints not in Section 4 of feature-knowledge.md
3. **New Calculations** - Technical requirements not documented
4. **New Edge Cases** - Scenarios not covered in Section 6 of feature-knowledge.md
5. **New User Flows** - Interactions not in Section 3 of feature-knowledge.md

**For each gap found:**
- Document the gap type
- Note the specific new information
- Reference the source (ticket documentation)

### Step 4: Prompt for Feature Knowledge Update

**If gaps are found:**

Prompt the user with a clear summary of what's new:

```
Gap Detection: I found new information not in feature-knowledge.md

New Business Rule:
- [Description of new business logic]
- Source: [ticket documentation reference]

New API Endpoint:
- POST /api/[endpoint]
- [Description of endpoint purpose]
- Source: [ticket documentation reference]

New Edge Case:
- [Description of edge case]
- Source: [ticket documentation reference]

Would you like me to append this to feature-knowledge.md? [y/n]
```

**If user chooses YES:**

1. Read current feature-knowledge.md
2. Append new information to appropriate sections:
   ```markdown
   ## [Section updated from ticket [ticket-id] on [date]]

   ### [Topic Name]
   [Content from ticket]

   **Source:** Ticket [ticket-id]
   **Added:** [date] during ticket requirement analysis
   **Type:** [Business Rule|API Endpoint|Edge Case|User Flow|Calculation]
   ```
3. Save updated feature-knowledge.md
4. Confirm update to user

**If user chooses NO:**
- Continue without updating feature knowledge
- Note in test plan that ticket has additional requirements

### Step 5: Create Test Plan

Create comprehensive test-plan.md at `[ticket-path]/test-plan.md` following the structure defined in:

**Standard:** `@qa-agent-os/standards/testcases/test-plan.md`

The standard defines all 12 sections, field definitions, and best practices. Generate the test plan by:
1. Reading the standard to understand required structure
2. Filling each section based on requirement analysis
3. Following field definitions and formatting rules from the standard

### Step 6: Initialize Revision Log

The test plan is created with Version 1.0 and initial revision entry. This enables tracking of all future updates via `/revise-test-plan` command.

**Revision log format:**
```markdown
### Version [X.Y] - [Date]
- **Updated by:** [Person or command]
- **Changes:** [Description of what changed]
- **Sections affected:** [Which sections were modified]
```

### Step 7: Completion

**IMPORTANT - File Output Instructions:**

DO NOT create additional summary files like:
- README.md
- TEST_PLAN_SUMMARY.md
- COLLECTION_LOG.md
- or any other meta-documentation files

ALL summary information is already included in test-plan.md. Creating additional files creates unnecessary noise.

Output confirmation message to the user (do not write this to a file):
```
Test plan created successfully!

Location: [ticket-path]/test-plan.md
Version: 1.0
Sections: 12 (including Gap Detection Log)

Feature knowledge updated: [yes/no]

Gap Detection: [summary of gaps found, or "No feature-level gaps detected"]

Coverage Summary:
- Total requirements: [N]
- Total test cases: [N] (from scenarios in Section 6)
- Automation potential: [estimated percentage]

NEXT STEPS:
The test plan is ready for review. When ready to generate detailed test cases, continue to Phase 4 or run /generate-testcases later.
```
