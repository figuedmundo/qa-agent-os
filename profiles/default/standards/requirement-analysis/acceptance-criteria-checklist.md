# QA Standard – Acceptance Criteria Checklist

## Acceptance Criteria Must Be
- **Clear & unambiguous**: written in business language with no double negatives.
- **Testable & measurable**: define observable outcomes, not internal implementation.
- **Atomic**: one behavior per criterion to avoid partial passes.
- **Consistent with business rules**: reference canonical rule IDs when available.
- **Free of hidden assumptions**: state preconditions, data states, and user roles.
- **Versioned**: note when criteria change between releases.

## Recommended Formats
- **Given/When/Then (Gherkin)** for behavior-driven scenarios.
- **Rule + Example tables** for complex validations.
- **Scenario outlines** for data-driven permutations.

## QA Validation Checklist
- Do criteria cover primary, alternate, and failure paths?
- Are edge/boundary values and localization/accessibility expectations included?
- Are non-functional expectations (latency, throughput, security) captured or linked?
- Is each criterion mapped to at least one test case ID?
- Are acceptance test data sets defined or referenced?
