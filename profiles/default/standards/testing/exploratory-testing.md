# QA Standard – Exploratory Testing Guidelines

## Charter Structure
- **Mission**: Goal of the session.
- **Scope / Out-of-scope**.
- **Risks & Hypotheses**: What could go wrong.
- **Timebox**: Duration (e.g., 90 minutes).
- **Environment & Build**.
- **Owner / Pairing Partner**.
- **Areas to explore**.
- **Data variations & personas**.
- **Negative / failure scenarios**.
- **Non-functional considerations** (performance, accessibility, localization).

## Heuristics to apply
- CRUD
- Boundaries
- Error Guessing
- State Transitions
- Pairwise Testing
- Tours (e.g., Money, Interrupt, FedEx)
- Observability (logs/metrics) and chaos/resiliency experiments

## Session Execution
- **Instrument**: Start timer, collect screenshots, logs, and notes in real time.
- **Tag findings**: Issue, Question, Idea, Opportunity.
- **Note coverage**: Which heuristics and areas were touched.
- **Capture data**: Inputs used, test accounts, feature flags.

## Debrief Template
1. **Session Summary**: Mission, duration, participants.
2. **Findings**: Bugs (link to tracker), risks, questions, ideas.
3. **Evidence**: Link to recordings/logs per `global/evidence-template.md`.
4. **Next Actions**: Follow-up test charters, automation candidates, backlog items.
5. **Reflection**: What worked, what to adjust for next session.
