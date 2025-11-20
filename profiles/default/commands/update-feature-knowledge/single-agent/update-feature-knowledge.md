# /update-feature-knowledge Command

## Purpose

Manually update feature-knowledge.md document when needed outside of automatic gap detection.

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

## Update Types

1. **Add business rule** - New business logic documented
2. **Add API endpoint** - New service contract
3. **Update existing** - Change documented information
4. **Add edge case** - Special handling documented
5. **Add open question** - Question that needs answering

## How It Works

1. Select feature (or specify directly)
2. Select update type
3. Provide details
4. Feature knowledge appended with metadata
5. "Last Updated" timestamp updated

## Update Format

Each manual update appends:
```markdown
## [Section added manually on [date]]

### [Topic from your input]

[Your provided content]

**Source:** Manual update
**Added:** [timestamp]
**Reason:** [Why you provided]
```

## Smart Features

- Metadata tracking (source, timestamp, reason)
- "Last Updated" automatically refreshed
- Section headers clearly mark manual updates
- Reason tracking for audit trail
- Separate from automatic gap detection

## Why Automatic Updates Are Better

- `/plan-ticket` detects gaps automatically
- Source traceability (which ticket added what)
- Less manual effort
- Automatic updates when ticket introduces new info

Use this command sparingly - leverage automatic gap detection from `/plan-ticket` instead!

## Related Commands

- `/plan-ticket` - Automatic gap detection and updates
- `/plan-feature` - Initial feature knowledge creation

---

Let `/plan-ticket` do the work when possible!
