# Update Feature Knowledge

## Manually Update Feature Knowledge Document

This command is for rare manual updates to feature-knowledge.md when needed outside of the automatic gap detection during ticket planning.

## When to Use (Rare Situations)

Most feature knowledge updates happen automatically during `/plan-ticket` Phase 3 gap detection. Use this command only when:

- Strategic decision requires documentation
- Requirements gathering meeting discovered new information
- Business rule clarification needed
- Architecture decision impacts understanding
- Open question finally answered

## Workflow

### Step 1: Select Feature

If not specified, I'll ask which feature:
```
Which feature's knowledge to update?

Features:
  [1] Feature-Name-1
  [2] Feature-Name-2

Choose:
```

### Step 2: Select Update Type

```
What would you like to update?

Options:
  [1] Add new business rule
  [2] Add new API endpoint
  [3] Update existing information
  [4] Add edge case documentation
  [5] Add open question

Choose:
```

### Step 3: Provide Details

Based on selection:

**[1] New Business Rule**
- Rule name and description
- Example of application
- Any exceptions
- Who validated it

**[2] New API Endpoint**
- Endpoint path and method
- Request/response format
- Purpose and use cases
- Integration points

**[3] Update Existing**
- Which section to update
- What's changing
- Why the change

**[4] Edge Case**
- Case description
- Expected behavior
- Impact on testing
- Priority level

**[5] Open Question**
- Question text
- Context and impact
- Who to ask
- Priority

### Step 4: Update Document

I'll append to `feature-knowledge.md`:
```markdown
## [Section added manually on [date]]

### [Topic]

[Your content]

**Source:** Manual update
**Added:** [date] [time]
**Reason:** [Reason you provided]
```

## Important Notes

**Why This Command is Rare:**

1. **Automatic Gap Detection** - `/plan-ticket` detects most new knowledge automatically
2. **Source Traceability** - Automatic updates track which ticket introduced info
3. **Manual Updates** - Less traceable, so use sparingly
4. **Strategy vs Knowledge** - For test strategy changes, edit feature-test-strategy.md manually

**Best Practice:**

- Let `/plan-ticket` gap detection handle most updates
- Use this for high-level strategic decisions
- Document the reason clearly
- Include who validated the information

## Output

Updated: `features/[feature-name]/feature-knowledge.md`

With:
- New section with manual update marker
- Content from your input
- Timestamp and reason
- Updated "Last Updated" metadata

## Related Commands

- `/plan-ticket` - Automatic gap detection and updates
- `/plan-feature` - Creates feature knowledge initially
- `/revise-test-plan` - Updates test plan, not feature knowledge

---

Use sparingly - most updates happen automatically!
