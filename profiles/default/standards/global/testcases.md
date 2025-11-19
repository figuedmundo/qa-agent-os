## Test Case Conventions

These conventions apply to any test artifact produced by agents (manual, automated, exploratory charters).

### Authoring Principles
- **Traceable**: map each case to requirement/user story ID and risk tag.
- **Atomic**: one primary assertion per case to simplify automation and defect linking.
- **Deterministic**: define expected outcomes precisely, including error messages, UI states, or API payloads.
- **Reusable Data**: describe data setup or fixtures so another tester can reproduce.
- **Accessibility & NFR coverage**: note when WCAG, localization, performance, or resiliency aspects are assessed.

### Documentation Requirements
- Use the canonical structure from `testcases/test-case-standard.md`.
- Include `Automation? (Yes/No/Planned)`, `Last Run`, and `Owner`.
- For automated suites, add repository path and CI job ID.

### Maintenance
- Review regression suites each sprint; deprecate duplicates and flag gaps.
- Version test cases alongside product releases; note behavior changes explicitly.
- When a defect is found, either link to an existing case or create a new one before closing the bug.