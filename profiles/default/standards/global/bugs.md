## Bug Management Conventions

Use these conventions for every defect, regardless of component or origin.

### Lifecycle
1. **Report**: File using `bugs/bug-reporting-standard.md`.
2. **Triage**: Confirm reproducibility, severity, and priority; record decision owner.
3. **Fix & Verify**: Link commits, test evidence, and retest notes.
4. **Close**: Ensure regression tests run and no duplicate issues remain open.

### Required Metadata
- Unique ID (JIRA, Linear, etc.) and repository commit/build hash.
- Affected environment(s) and feature flags.
- Severity per `bugs/severity-rules.md` and priority per `requirement-analysis/priority-rules.md`.
- Observability references: log IDs, trace IDs, screenshot/video links.

### Triage Rules
- Prefer *severity* based on user impact; adjust *priority* based on timelines or regulatory commitments.
- Capture root-cause hypothesis and blast radius; tie to requirement/test IDs to maintain traceability.
- Update status within 1 business day whenever new info arrives.

### Metrics & Quality Gates
- Track defect escape rate (prod vs. pre-prod), mean time to detect (MTTD), and mean time to resolve (MTTR).
- Do not close Critical/High bugs without regression evidence attached.
- Periodically review duplicates to refine test coverage or monitoring gaps.