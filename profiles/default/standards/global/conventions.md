## General QA Conventions

These conventions apply to every QA activity, regardless of artifact or phase. They align with current industry references such as ISTQB v4.0, ISO/IEC/IEEE 29119, and the World Quality Report 2024.

### Quality Principles
- **Shift-left mindset**: involve QA when requirements are drafted so risks are surfaced before implementation.
- **Whole-team quality**: engineers, PMs, and QA agents co-own quality outcomes; surface blockers immediately.
- **Risk-based focus**: size effort based on business impact, user reach, complexity, and failure cost.
- **Traceability**: link each requirement → test case → execution result → defect for auditability.

### Work Practices
- **Single source of truth**: reference the dated spec folder and the applicable standards in this directory; avoid ad-hoc docs.
- **Version control**: store all QA deliverables in git with meaningful commits and changelog notes.
- **Evidence-first**: every claim (pass, fail, assumption) must cite artifacts following `global/evidence-template.md`.
- **Data hygiene**: redact PII/credentials in screenshots, logs, and shared links.

### Collaboration & Communication
- **Clarify early**: log open questions during requirement analysis and keep owners assigned until closure.
- **Document decisions**: capture rationale in spec/test artefacts, not DMs.
- **Consistent terminology**:
  - *Severity* describes impact (see `bugs/severity-rules.md`).
  - *Priority* describes urgency (see `requirement-analysis/priority-rules.md`).
  - *Status* tracks workflow state (New, Triaged, In Progress, Blocked, Closed).

### Tooling Expectations
- Use agreed automation frameworks (e.g., Playwright, Postman, Testmo) and note tool versions in plans.
- For observability, record log/trace IDs in bug reports to enable root-cause analysis.
- When automation is unavailable, justify manual coverage and outline automation debt.