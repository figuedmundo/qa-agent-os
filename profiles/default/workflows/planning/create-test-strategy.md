# Create Feature Test Strategy Workflow

This workflow creates a strategic test approach document (feature-test-strategy.md) that defines HOW the feature will be tested at a high level.

## Core Responsibilities

1. **Prompt for Test Approach**: Guide users through defining test levels, types, tools, environments
2. **Analyze Feature Knowledge**: Review feature-knowledge.md to understand scope and risks
3. **Create Strategy Document**: Generate feature-test-strategy.md with 10 standardized sections
4. **Define Entry/Exit Criteria**: Establish when testing starts and when it's complete

**Note:** The placeholder `[feature-path]` refers to the full path like `qa-agent-os/features/feature-name`. The placeholder `[feature-knowledge-path]` refers to `[feature-path]/feature-knowledge.md`.

---

## Workflow

### Step 1: Read Feature Knowledge

Read `[feature-knowledge-path]` to understand:
- Feature scope and purpose
- Business rules and technical requirements
- Critical paths and risk areas
- Integration points
- Known edge cases

This context informs the test strategy decisions.

### Step 2: Prompt for Test Levels

Ask user:
```
Which test levels are needed for this feature?

Select all that apply (comma-separated numbers):
  [1] Unit Testing - Testing individual functions/methods in isolation
  [2] API Testing - Testing backend APIs and integrations
  [3] UI Testing - Testing user interface and interactions
  [4] Integration Testing - Testing component interactions
  [5] End-to-End Testing - Testing complete user workflows

Your selection (e.g., 2,3,5):
```

Record selected test levels.

### Step 3: Prompt for Test Types

Ask user:
```
What types of testing should be covered?

Select all that apply (comma-separated numbers):
  [1] Functional Testing - Core feature functionality
  [2] Performance Testing - Speed, load, response times
  [3] Security Testing - Authentication, authorization, data security
  [4] Accessibility Testing - WCAG compliance, keyboard navigation
  [5] Usability Testing - User experience and ease of use
  [6] Regression Testing - Ensuring existing functionality still works

Your selection (e.g., 1,2,6):
```

Record selected test types.

### Step 4: Prompt for Testing Tools

Ask user:
```
What tools and frameworks will you use for testing?

Examples:
- API: Postman, Newman, Insomnia, REST Assured
- UI: Playwright, Cypress, Selenium, TestCafe
- Performance: K6, JMeter, Apache Bench, Gatling
- CI/CD: GitHub Actions, Jenkins, GitLab CI, CircleCI

Provide your tools (one per line):
```

Record testing tools.

### Step 5: Prompt for Test Environments

Ask user:
```
What test environments are available?

Examples:
- Development (dev)
- Staging/Pre-production
- Production (if applicable)
- Local/Manual testing

Provide your environments (one per line):
```

Record test environments.

### Step 6: Prompt for Performance Requirements

Ask user:
```
Are there specific performance requirements or SLAs?

If yes, provide details such as:
- API response times (e.g., < 800ms for 95th percentile)
- Page load times (e.g., < 3s for 90th percentile)
- Throughput requirements (e.g., 1000 requests/second)
- Availability/uptime targets (e.g., 99.9%)

Your response (or type "none"):
```

Record performance requirements if provided.

### Step 7: Prompt for Security & Compliance

Ask user:
```
Are there security, compliance, or privacy requirements?

If yes, specify:
- Data privacy requirements (GDPR, CCPA, HIPAA, etc.)
- Security testing scope (penetration testing, vulnerability scanning)
- Compliance standards (PCI DSS, SOC 2, etc.)
- Special access restrictions

Your response (or type "none"):
```

Record security and compliance requirements if provided.

### Step 8: Analyze Risk Areas

Based on feature-knowledge.md, identify:
- **High-Risk Areas**: Complex calculations, critical business rules, financial operations, integrations
- **Medium-Risk Areas**: Standard CRUD operations with validation, reporting features
- **Low-Risk Areas**: Simple read-only operations, informational displays

### Step 9: Define Entry and Exit Criteria

Based on feature scope and test approach, define:

**Entry Criteria:**
- Feature code complete and deployed to test environment
- Test data prepared
- Test environment configured
- Required test tools available

**Exit Criteria:**
- All high-priority test cases executed
- All critical defects resolved
- Test coverage targets met (e.g., 80% of requirements covered)
- Performance benchmarks met
- Security scans passed

### Step 10: Create feature-test-strategy.md

Create `[feature-path]/feature-test-strategy.md` using the template structure:

```markdown
# Feature Test Strategy: [Feature Name]

**Status:** Active
**Version:** 1.0
**Last Updated:** [YYYY-MM-DD HH:MM]

---

## 1. Test Scope

### In Scope
- [Test scope item 1 from feature knowledge]
- [Test scope item 2 from feature knowledge]

### Out of Scope
- [Out of scope item 1]
- [Out of scope item 2]

### Reference
- **Feature Knowledge:** [feature-path]/feature-knowledge.md

---

## 2. Test Levels

[List selected test levels from Step 2]

### Unit Testing
[If selected, describe approach]

### API Testing
[If selected, describe approach]

### UI Testing
[If selected, describe approach]

### Integration Testing
[If selected, describe approach]

### End-to-End Testing
[If selected, describe approach]

---

## 3. Test Types

[List selected test types from Step 3]

### Functional Testing
[If selected, describe approach]

### Performance Testing
[If selected, describe approach and requirements from Step 6]

### Security Testing
[If selected, describe approach and requirements from Step 7]

### Accessibility Testing
[If selected, describe approach]

### Usability Testing
[If selected, describe approach]

### Regression Testing
[If selected, describe approach]

---

## 4. Testing Tools & Frameworks

### API Testing Tools
[Tools from Step 4]

### UI Testing Tools
[Tools from Step 4]

### Performance Testing Tools
[Tools from Step 4]

### CI/CD Integration
[Tools from Step 4]

### Other Tools
[Any additional tools from Step 4]

---

## 5. Test Environments

[List environments from Step 5]

### [Environment Name]
- **Purpose:** [When this environment is used]
- **Access:** [How to access]
- **Data:** [Test data availability]
- **Configuration:** [Special configurations]

---

## 6. Test Data Strategy

### Test Data Requirements
[From feature-knowledge.md Section 6]

### Test Data Preparation
- [How test data will be created]
- [Who is responsible for test data]
- [Test data refresh process]

### Special Data Scenarios
- [Edge case data requirements]
- [Boundary value data]
- [Negative test data]

---

## 7. Risk Assessment

### High-Risk Areas
[From Step 8 and feature-knowledge.md Section 6]
- **Risk:** [Description]
- **Mitigation:** [Test approach to mitigate risk]

### Medium-Risk Areas
[From Step 8]
- **Risk:** [Description]
- **Mitigation:** [Test approach]

### Low-Risk Areas
[From Step 8]

---

## 8. Entry & Exit Criteria

### Entry Criteria
[From Step 9]
- [Criterion 1]
- [Criterion 2]

### Exit Criteria
[From Step 9]
- [Criterion 1]
- [Criterion 2]

### Definition of Done
- All high-priority defects resolved
- Test execution completion rate: [e.g., 100%]
- Test pass rate: [e.g., 95%]
- Code coverage (if applicable): [e.g., 80%]

---

## 9. Roles & Responsibilities

### QA Team
- Test plan creation and review
- Test case design and execution
- Defect reporting and tracking
- Test result documentation

### Development Team
- Unit test creation
- Defect fixing
- Code review for testability
- Environment setup support

### Product Team
- Requirements clarification
- Acceptance criteria validation
- User acceptance testing
- Sign-off on release

---

## 10. Deliverables

### Test Planning Phase
- [ ] Feature test strategy (this document)
- [ ] Ticket-level test plans (per ticket)
- [ ] Test data preparation plan

### Test Execution Phase
- [ ] Test cases (per ticket)
- [ ] Test execution results
- [ ] Defect reports
- [ ] Test coverage reports

### Test Completion Phase
- [ ] Test summary report
- [ ] Defect summary
- [ ] Lessons learned
- [ ] Release sign-off

---

**Note:** This strategic document is referenced by all ticket-level test plans to avoid redundancy. Ticket test plans focus on specific requirements while inheriting the strategic approach from this document.
```

### Step 11: Completion

Display summary:
```
Feature test strategy created!

Created: [feature-path]/feature-test-strategy.md

Document contains:
- 10 sections defining strategic test approach
- Test levels, types, tools, and environments
- Risk assessment and mitigation strategies
- Entry/exit criteria and deliverables
- Roles and responsibilities

Next: When planning tickets, test plans will reference this strategy document.
```
