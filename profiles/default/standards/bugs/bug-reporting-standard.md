# Bug Reporting Standard

High-quality bug reports reduce back-and-forth and speed up fixes. Use this canonical structure for all defects.

## 1. Required Fields

| Field | Description |
| :--- | :--- |
| **ID** | Tracker ID (`BUG-123`) and related requirement/test IDs |
| **Title** | `[Component] Short Description of the Issue` |
| **Build / Version** | Commit hash, app version, API tag |
| **Severity** | Impact on the system (see `bugs/severity-rules.md`) |
| **Priority** | Urgency of fix (see `requirement-analysis/priority-rules.md`) |
| **Status** | New, Triaged, In Progress, Blocked, Ready for QA, Closed |
| **Environment** | OS, Browser/Device, Environment (Dev/Staging/Prod) |
| **Feature Flags / Config** | Enabled toggles or experiments |
| **Preconditions** | State before the bug occurred |
| **Steps to Reproduce** | Clear, numbered steps to trigger the bug |
| **Expected Result** | What *should* have happened |
| **Actual Result** | What *actually* happened, including error copy |
| **Reproducibility** | Always / Intermittent (%), include attempts/logs |
| **Evidence** | Logs, screenshots, videos per `global/evidence-template.md` |
| **Root Cause Hypothesis** | Optional but recommended after triage |
| **Attachments/Links** | Observability IDs, dashboards, related tickets |

## 2. Reporting Workflow
1. **Draft** using the above fields, ensuring evidence is attached.
2. **Auto-checklist**: confirm severity vs. priority alignment and tag affected areas.
3. **Submit** to tracker and notify triage channel for Critical/High issues.
4. **Update** status after each handoff (developer fix, QA verification, release note).

## 3. Evidence Rules
- Logs must include timestamps and correlation IDs.
- Screenshots or recordings are required for UI/UX issues; annotate critical regions.
- Redact PII, secrets, or customer identifiers before sharing externally.
- Store large artifacts under `/artifacts/YYYY-MM-DD/bug-<id>` and link to them.

## 4. Example

```markdown
**ID**: BUG-CHECKOUT-045
**Title**: [Checkout] Submit Order fails with 500 Error
**Build**: web@1.24.0 (commit 4f2a9d1)
**Severity/Priority**: Critical / P1
**Environment**: Staging, Chrome 120, Flag `payments_v2`=ON
**Steps to Reproduce**:
1. Add item to cart.
2. Proceed to checkout with valid card.
3. Click "Submit Order".
**Expected Result**: Order confirmation page is shown within 2s.
**Actual Result**: Toast "Internal Server Error" appears; request ID `req-7842`.
**Reproducibility**: 4/4 attempts, multiple accounts.
**Evidence**: Screenshot + API log bundle (see `/artifacts/2024-11-18/bug-checkout-045`).
**Root Cause Hypothesis**: PaymentGateway `process()` throws on expired JWT.
```
