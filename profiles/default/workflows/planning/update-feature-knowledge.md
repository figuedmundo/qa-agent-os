# Update Feature Knowledge Workflow

This workflow handles manual updates to feature-knowledge.md when needed outside of automatic gap detection during ticket planning.

## Core Responsibilities

1. **Validate Update Type**: Ensure the update is appropriate for manual entry
2. **Gather Update Details**: Collect information about what needs to be added or changed
3. **Update Document**: Append or modify feature-knowledge.md with proper metadata tracking
4. **Maintain Traceability**: Track who made the update, when, and why

**Note:** The placeholder `[feature-path]` refers to the full path like `qa-agent-os/features/feature-name`. The placeholder `[update-type]` refers to the type of update being made. The placeholder `[update-details]` contains the actual update information.

---

## Workflow

### Step 0: Understand When to Use This Workflow

This workflow is for RARE manual updates. Most feature knowledge updates happen automatically during `/plan-ticket` Phase 3 gap detection.

Use this workflow only when:
- Strategic decision requires documentation
- Requirements gathering meeting discovered new information
- Business rule clarification needed outside ticket context
- Architecture decision impacts understanding
- Open question finally answered

If the update is related to a specific ticket, use gap detection in `/plan-ticket` instead.

### Step 1: Read Current Feature Knowledge

Read `[feature-path]/feature-knowledge.md` to understand current state and identify which section needs updating.

### Step 2: Process Update Based on Type

Based on `[update-type]`, handle the update appropriately:

#### Type 1: Add New Business Rule

From `[update-details]`, extract:
- Rule name and description
- Conditions and triggers
- Exceptions or edge cases
- Example of application
- Who validated it

Append to Section 2 (Business Requirements):
```markdown
### [Rule Name] (Added [YYYY-MM-DD])

**Description:** [Rule description]

**Conditions:**
- [Condition 1]
- [Condition 2]

**Exceptions:**
- [Exception 1]
- [Exception 2]

**Example:** [Example of rule application]

**Source:** Manual update
**Added:** [YYYY-MM-DD HH:MM]
**Validated By:** [Person or team]
**Reason:** [Why this rule was added]
```

#### Type 2: Add New API Endpoint

From `[update-details]`, extract:
- Endpoint path and HTTP method
- Request format
- Response format
- Purpose and use cases
- Integration points

Append to Section 3 (Technical Requirements):
```markdown
### [Method] /api/endpoint/path (Added [YYYY-MM-DD])

**Purpose:** [What this endpoint does]

**Request Format:**
```json
[Request structure]
```

**Response Format:**
```json
[Response structure]
```

**Use Cases:**
- [Use case 1]
- [Use case 2]

**Integration Points:**
- [Integration 1]

**Source:** Manual update
**Added:** [YYYY-MM-DD HH:MM]
**Reason:** [Why this endpoint was added]
```

#### Type 3: Update Existing Information

From `[update-details]`, extract:
- Which section to update (1-8)
- What's changing
- Why the change is needed

Locate the existing content in the specified section and update it:
- Add a note indicating when it was updated
- Preserve original information if it's still relevant
- Add metadata about the update

Example:
```markdown
[Original content]

**Updated [YYYY-MM-DD]:** [Description of what changed]
**Reason:** [Why the change was made]
**Source:** Manual update
```

#### Type 4: Add Edge Case Documentation

From `[update-details]`, extract:
- Edge case description
- Expected behavior
- Impact on testing
- Priority level (High/Medium/Low)

Append to Section 5 (Edge Cases & Constraints):
```markdown
### [Edge Case Name] (Added [YYYY-MM-DD])

**Description:** [Detailed description of the edge case]

**Expected Behavior:** [How the system should handle this case]

**Test Impact:** [What testers need to know]

**Priority:** [High/Medium/Low]

**Source:** Manual update
**Added:** [YYYY-MM-DD HH:MM]
**Reason:** [Why this edge case is important]
```

#### Type 5: Add Open Question

From `[update-details]`, extract:
- Question text
- Context and background
- Impact on testing or development
- Who to ask for clarification
- Priority (High/Medium/Low)

Append to Section 7 (Open Questions):
```markdown
### [Question Number]: [Question Text]

**Context:** [Background information]

**Impact:** [How this affects testing/development]

**Who to Ask:** [Stakeholder name or role]

**Priority:** [High/Medium/Low]

**Added:** [YYYY-MM-DD HH:MM]
**Source:** Manual update
**Reason:** [Why this question is important]
```

### Step 3: Update Last Modified Metadata

At the top of feature-knowledge.md, update:
```markdown
**Last Updated:** [YYYY-MM-DD HH:MM]
```

### Step 4: Verify Document Structure

Ensure:
- All 8 sections are still present and properly formatted
- New content follows markdown formatting standards
- Metadata is included for traceability
- Document is still readable and well-organized

### Step 5: Completion

Display summary:
```
Feature knowledge updated!

Updated: [feature-path]/feature-knowledge.md

Changes made:
- [Update type]: [Brief description]
- Section updated: [Section number and name]
- Source: Manual update
- Timestamp: [YYYY-MM-DD HH:MM]

Note: This update was made manually. Ticket-based updates happen automatically via gap detection during /plan-ticket execution.
```

---

## Important Notes

### Why Manual Updates Are Rare

1. **Automatic Gap Detection** - Most updates happen during `/plan-ticket` Phase 3
2. **Source Traceability** - Automatic updates track which ticket introduced the information
3. **Manual Updates Less Traceable** - Use sparingly for strategic decisions only

### Best Practices

- Let `/plan-ticket` gap detection handle most updates
- Use manual updates for high-level strategic decisions
- Always document the reason for the update
- Include who validated the information
- Update test strategy if the change is significant

### When NOT to Use This Workflow

- Don't use for ticket-specific requirements - use `/plan-ticket` gap detection instead
- Don't use for test plan updates - use `/revise-test-plan` instead
- Don't use for test strategy changes - edit feature-test-strategy.md directly
