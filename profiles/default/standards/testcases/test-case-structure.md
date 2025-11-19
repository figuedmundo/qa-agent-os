# QA Standard – Test Case Structure (Quick Reference)

Use this as a quick reminder of the canonical structure defined in `test-case-standard.md`.

## Required Fields (Summary)

| Field | Notes |
| :--- | :--- |
| **ID** | Unique ID, traceable to repo/management tool |
| **Title** | `[Module] - [Action] - [Expected Outcome]` |
| **Requirement / Risk IDs** | Link to BRD item, user story, or risk register |
| **Purpose** | Why this test exists |
| **Type & Priority** | Functional, Regression, API, Accessibility, etc. + Critical/High/Medium/Low |
| **Automation Status** | Manual / Automated / Planned + location |
| **Preconditions & Test Data** | Setup, accounts, feature flags |
| **Steps** | Numbered, atomic actions |
| **Expected Result** | Observable behavior with metrics/messages |
| **Postconditions** | System state after execution |
| **Observability Notes** | Logs/metrics to verify |
| **Actual Result & Defect Link** | Filled during execution |

## Writing Reminders
- Keep steps deterministic—include data values and UI locators if needed.
- Reference accessibility, localization, performance, and resiliency considerations explicitly.
- Update cases when requirements change; note version/date in metadata.
- When a case fails, attach evidence per `global/evidence-template.md` and link resulting defect.

## Example Snippet

```markdown
**ID**: TC-PAYMENT-014
**Title**: Payment - Retry Card - Show Failure Message
**Requirement**: REQ-PAY-09
**Steps**:
1. Submit payment with expired card.
2. Click "Try Again".
**Expected Result**: Error banner "Card expired" with support link; request ID logged.
```
