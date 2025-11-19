# QA Standard – Severity Rules

## S1 – Critical
- Data loss
- Security vulnerability
- System crash
- Payment broken
- No workaround
- Regulatory/compliance breach
- Requires immediate incident response

## S2 – Major
- Feature broken
- Wrong calculations
- API returns incorrect data
- Workaround exists but difficult
- Significant performance degradation impacting majority of users
- Monitoring alert thresholds breached

## S3 – Minor
- UI issues
- Incorrect messages
- Layout misalignment
- Limited user impact, easy workaround
- Non-blocking accessibility issues

## S4 – Trivial
- Cosmetic
- Typos
- Low-impact UX issues
- Internal-only copy tweaks

### Escalation & SLA
- **Critical**: page on-call, resolve or rollback before release continues.
- **Major**: fix within current sprint; require regression evidence before closure.
- **Minor/Trivial**: triage into backlog with rationale; revisit during hardening.

### Relationship to Priority
- Severity captures *impact*; priority captures *urgency*. A severe issue may have lower priority if mitigated by feature flagging, but rationale must be documented.
