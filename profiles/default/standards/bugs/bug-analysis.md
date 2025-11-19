# QA Standard – Bug Analysis

This standard guides the agent in analyzing a reported bug to determine its validity, scope, and root cause before attempting a fix.

## Analysis Steps

1.  **Reproduce the Issue**
    *   Can you reproduce it with the provided steps?
    *   If not, what variations did you try?
    *   Capture reproducibility rate and supporting evidence.

2.  **Isolate the Cause**
    *   Which component is likely responsible?
    *   Is it a frontend, backend, or data issue?
    *   Are there relevant logs or error messages?
    *   Identify feature flags, configs, or recent deployments that may contribute.

3.  **Determine Scope**
    *   Does this affect all users or specific segments?
    *   Is it a regression? (Did it work before?)
    *   What releases/environments/builds are impacted?

4.  **Severity Assessment**
    *   **Critical**: Blocker, data loss, security vulnerability.
    *   **High**: Major functionality broken, no workaround.
    *   **Medium**: Functionality broken but workaround exists.
    *   **Low**: Cosmetic or minor annoyance.
    *   Recommend priority based on business deadlines or regulatory impact.

## Output Format

When analyzing a bug, produce a summary in this format:

```markdown
### Bug Analysis: [Bug Title]

**Reproduction Status**: [Reproduced / Not Reproduced]
**Root Cause Hypothesis**: [Brief explanation]
**Affected Components**: [List of files/modules]
**Severity**: [Critical/High/Medium/Low]
**Priority Recommendation**: [P1–P4 + rationale]
**Proposed Fix Strategy**: [High-level approach]
**Observability Links**: [Logs/Traces/Dashboards]
```
