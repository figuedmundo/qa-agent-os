# /update-feature-knowledge Command (Multi-Agent Mode)

## Purpose

Manually update feature-knowledge.md document when needed outside of automatic gap detection using specialized agents.

## Usage

```bash
/update-feature-knowledge              # Interactive - select feature
/update-feature-knowledge TWRR         # Direct - update specific feature
```

## When to Use

**Note:** Most updates happen automatically via `/plan-ticket` gap detection.

Use this command only for:
- Strategic business rule clarifications
- Architecture decisions
- Requirements gathering outcomes
- Answers to open questions
- Policy or compliance updates

## Execution Flow

### PHASE 1: Detect Feature

This phase handles feature identification. Orchestration logic remains in the main command:

#### If Feature Name Provided as Parameter

```bash
# User ran: /update-feature-knowledge TWRR
FEATURE_NAME="TWRR"
```

Skip to Phase 2.

#### If No Parameter Provided (Interactive Mode)

Scan for features with feature-knowledge.md and present selection:

```bash
# Find all feature folders with feature-knowledge.md
FEATURES=$(find qa-agent-os/features/ -maxdepth 2 -name "feature-knowledge.md" -exec dirname {} \;)

# Display numbered list
```

Present to user:

```
Features with knowledge documents:
  [1] TWRR - Last modified: 2025-11-20
  [2] Portfolio-Analytics - Last modified: 2025-11-19
  [3] Payment-Processing - Last modified: 2025-11-18

Select feature [1-3]:
```

User selects feature, set FEATURE_NAME for next phase.

#### Validate Feature Knowledge Exists

Verify the selected feature has a knowledge document:

```bash
FEATURE_PATH="qa-agent-os/features/$FEATURE_NAME"
FEATURE_KNOWLEDGE="$FEATURE_PATH/feature-knowledge.md"
```

If feature knowledge doesn't exist:

```
Error: No feature knowledge found for [feature-name]

Run /plan-feature [feature-name] first to create the feature.
```

Exit command.

Proceed to Phase 2.

### PHASE 2: Prompt Update Type

This phase gathers update details from user. Orchestration logic remains in the main command:

#### Present Update Type Options

Prompt user to select update type:

```
What type of update are you making to feature knowledge?

Update Types:
  [1] Add new business rule
  [2] Add new API endpoint
  [3] Update existing information
  [4] Add edge case documentation
  [5] Add open question

Select [1-5]:
```

Store user's selection as UPDATE_TYPE:
- Option [1] → UPDATE_TYPE="business_rule"
- Option [2] → UPDATE_TYPE="api_endpoint"
- Option [3] → UPDATE_TYPE="update_existing"
- Option [4] → UPDATE_TYPE="edge_case"
- Option [5] → UPDATE_TYPE="open_question"

#### Gather Update Details

Prompt user for update details:

```
Provide the update details:

Topic: [User provides brief topic/title]

Content: [User provides detailed content]

Reason: [User provides reason for manual update]
```

Store user's input:
- TOPIC: [topic/title]
- CONTENT: [detailed content]
- REASON: [reason for update]

Proceed to Phase 3.

### PHASE 3: Apply Update

Use the **requirement-analyst** subagent to update the feature knowledge.

Provide the requirement-analyst with:
- Feature path: `qa-agent-os/features/[feature-name]/`
- Feature knowledge path: `[feature-path]/feature-knowledge.md`
- Update type: [business_rule|api_endpoint|update_existing|edge_case|open_question]
- Topic: [from Phase 2]
- Content: [from Phase 2]
- Reason: [from Phase 2]
- Current date and time: [timestamp]

The requirement-analyst will:
- Read current feature-knowledge.md to understand existing structure
- Determine appropriate section for update based on UPDATE_TYPE:
  - business_rule → Section 2 (Business Rules)
  - api_endpoint → Section 3 (API Endpoints & Integration Points)
  - update_existing → Modify relevant section (user specifies which)
  - edge_case → Section 5 (Edge Cases & Error Scenarios)
  - open_question → Section 7 (Open Questions)
- If adding new content (not updating existing):
  - Append to appropriate section with format:
    ```markdown
    ### [TOPIC] (Added manually on [date])

    [CONTENT]

    **Source:** Manual update
    **Added:** [timestamp]
    **Reason:** [REASON]
    ```
- If updating existing content:
  - Locate existing content
  - Update with tracked change note:
    ```markdown
    (Updated on [date]: [what changed])
    ```
- Update metadata section:
  - Update "Last Updated" timestamp
  - Increment version if needed
  - Note manual update in metadata
- Save updated feature-knowledge.md
- Execute workflow: `workflows/planning/update-feature-knowledge`

### Completion

Once requirement-analyst completes:

```
✓ Feature knowledge updated successfully!

Updated:
- Feature knowledge: qa-agent-os/features/[feature-name]/feature-knowledge.md
  - Section updated: [section name]
  - Update type: [type]
  - Last Updated: [new timestamp]

NEXT STEPS:
- Review updated feature knowledge for accuracy
- Future tickets will reference this updated knowledge
- Gap detection will use this as baseline
```

## Update Types

1. **Add business rule** - New business logic documented
2. **Add API endpoint** - New service contract
3. **Update existing** - Change documented information
4. **Add edge case** - Special handling documented
5. **Add open question** - Question that needs answering

## Update Format

Each manual update is clearly marked with metadata:
```markdown
### [Topic from your input] (Added manually on [date])

[Your provided content]

**Source:** Manual update
**Added:** [timestamp]
**Reason:** [Why you provided]
```

## Smart Features

This multi-agent command includes:

1. **Metadata Tracking** - Source, timestamp, and reason tracked for audit trail
2. **Automatic Timestamp** - "Last Updated" automatically refreshed
3. **Clear Marking** - Section headers clearly mark manual updates
4. **Reason Tracking** - Always know why manual updates were made
5. **Separation** - Separate from automatic gap detection updates

## Why Automatic Updates Are Better

- `/plan-ticket` detects gaps automatically during ticket planning
- Source traceability (which ticket added what requirement)
- Less manual effort required
- Automatic updates when ticket introduces new information

**Use this command sparingly** - leverage automatic gap detection from `/plan-ticket` instead!

## Related Commands

- `/plan-ticket` - Automatic gap detection and updates
- `/plan-feature` - Initial feature knowledge creation

---

*This command leverages the requirement-analyst agent to efficiently update feature knowledge with proper metadata tracking and version control. Let `/plan-ticket` do the work when possible!*
