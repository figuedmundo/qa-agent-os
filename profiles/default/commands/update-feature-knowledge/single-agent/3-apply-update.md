# Phase 3: Apply Update

## Execute Feature Knowledge Update

This phase applies the update to feature-knowledge.md using the core workflow.

### Variables from Previous Phases

Set by previous phases:
- **FEATURE_NAME**: Feature identifier
- **FEATURE_PATH**: `qa-agent-os/features/[feature-name]`
- **FEATURE_KNOWLEDGE_PATH**: `[feature-path]/feature-knowledge.md`
- **UPDATE_TYPE**: Type of update to apply
- **UPDATE_DETAILS**: Details collected from user

### Execute Update Workflow

{{workflows/planning/update-feature-knowledge}}

The workflow will:
- Read the current feature-knowledge.md
- Apply updates to appropriate sections based on UPDATE_TYPE
- Add metadata tracking (source, timestamp, reason)
- Update "Last Updated" timestamp
- Verify document structure integrity
- Save updated feature-knowledge.md

### Completion

Once workflow completes:

```
Feature knowledge updated successfully!

Updated: qa-agent-os/features/[feature-name]/feature-knowledge.md

Changes made:
- [Update type]: [Brief description]
- Section updated: [Section number and name]
- Source: Manual update
- Timestamp: [YYYY-MM-DD HH:MM]

Reason: [Why the update was made]
```

### Important Note

Display reminder:
```
NOTE: This update was made manually.

Most feature knowledge updates happen automatically via /plan-ticket gap detection:
  - Better source traceability (which ticket introduced what)
  - Automatic detection of new information
  - Less manual effort

Use manual updates sparingly for strategic decisions and high-level information.
```

### Success Summary

Display final summary:
```
Update complete!

Files updated:
  - feature-knowledge.md (Section [X])

You can:
  - Continue planning tickets with updated feature knowledge
  - Review feature-knowledge.md to see the changes
  - Run /update-feature-knowledge again if more updates needed

Next ticket planning will reference this updated knowledge automatically.
```

### Next Steps

Command completes. User can:
- Continue with `/plan-ticket` for ticket planning
- Run `/update-feature-knowledge` again for additional updates
- Review the updated feature-knowledge.md
