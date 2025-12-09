# Phase 1: Feature Context Analysis

## Analyze Feature Documentation and Create Knowledge Documents

This phase analyzes gathered feature documentation and creates comprehensive feature knowledge and testing strategy documents.

### Context Detection and Setup

First, detect if we're in feature context:

```
Check current working directory path:
- If path matches: qa-agent-os/features/[feature-name]/
  → Feature context detected

Otherwise:
- Present interactive selection menu
- Let user select feature to analyze
- Validate selected feature folder exists
```

### Documentation Folder Validation

Check if documentation folder exists and contains files:

```
Validate: qa-agent-os/features/[feature-name]/documentation/
- Does folder exist?
- Does it contain readable files?

If empty or insufficient:
  Display prompt:
  "No documentation found in [path]/documentation/

  Please gather documentation before running analysis. You can:

  [1] Show gathering guidance
      Display /gather-docs feature context guidance

  [2] Cancel, I'll add documentation manually
      Exit without proceeding"
```

If user selects [1], display gathering guidance and exit for them to add files.
If user selects [2], exit gracefully.

### Re-execution Detection

Check if analysis documents already exist:

```
Check for:
- qa-agent-os/features/[feature-name]/feature-knowledge.md
- qa-agent-os/features/[feature-name]/feature-test-strategy.md

If both exist:
  Present re-execution options:
  "Feature analysis already exists for [feature-name].

  Existing files:
    - feature-knowledge.md (Version X.X)
    - feature-test-strategy.md (Version X.X)

  Options:
    [1] Full re-analysis (overwrite both documents)
    [2] Update feature-knowledge.md only
    [3] Update feature-test-strategy.md only
    [4] Cancel

  Choose [1-4]:"

Handle each option:
- [1] Proceed with full analysis (regenerate both)
- [2] Proceed with analysis (regenerate knowledge only, skip strategy)
- [3] Proceed with analysis (skip knowledge, regenerate strategy only)
- [4] Exit without changes
```

### Feature Documentation Analysis

Read and analyze all documents in `qa-agent-os/features/[feature-name]/documentation/`:

```
For each document, extract:
- Business rules and requirements
- API endpoints and contracts
- Data models and schemas
- Edge cases and error scenarios
- Dependencies and integrations
- Open questions or clarifications needed
- References to source documents
```

You will:
1. Read all files in the documentation folder
2. Extract key information organized by type
3. Consolidate into structured sections
4. Note relationships and dependencies
5. Identify any ambiguities or open questions

Reference pattern: `profiles/default/commands/plan-feature/single-agent/3-consolidate-knowledge.md`

### Generate feature-knowledge.md

Create comprehensive feature knowledge document with 8 sections:

**Section 1: Overview**
- Feature purpose and goals
- Business objectives
- Key stakeholders
- Scope and boundaries

**Section 2: Business Rules**
- Validation rules
- Business logic and calculations
- Constraints and restrictions
- Compliance requirements

**Section 3: API Endpoints**
- Methods (GET, POST, PUT, DELETE, etc.)
- Paths and routes
- Request formats and parameters
- Response formats and examples
- Error handling and status codes
- Authentication/authorization requirements

**Section 4: Data Models**
- Entity definitions
- Relationships and cardinality
- Schema details
- Constraints and validations
- Enum values and constants

**Section 5: Edge Cases**
- Error scenarios
- Boundary conditions
- Special cases and exceptions
- Concurrent access handling
- Race conditions

**Section 6: Dependencies**
- External systems and services
- Internal modules and components
- Third-party libraries
- Database requirements

**Section 7: Open Questions**
- Unresolved issues
- Clarifications needed from stakeholders
- Areas requiring further investigation
- Future enhancements

**Section 8: References**
- Source documents
- Related specifications
- External links
- Additional resources

Reference template: `@qa-agent-os/templates/feature-knowledge-template.md`

Output location: `qa-agent-os/features/[feature-name]/feature-knowledge.md`

### Generate feature-test-strategy.md

Create comprehensive testing strategy document with 10 sections:

**Section 1: Testing Approach**
- Overall testing strategy
- Test types (unit, integration, e2e, etc.)
- Testing methodologies
- Quality gates and acceptance criteria

**Section 2: Tools**
- Testing frameworks
- Automation tools
- Test data tools
- CI/CD integration tools
- Monitoring and logging tools

**Section 3: Environment**
- Test environments (dev, staging, prod-like)
- Environment configurations
- Setup and teardown procedures
- Environment-specific considerations

**Section 4: Test Data Strategy**
- Test data sources
- Data generation approach
- Data cleanup procedures
- Test data management
- Privacy and security considerations

**Section 5: Risks**
- Testing risks and mitigations
- Coverage risks
- Performance risks
- Integration risks
- Security risks

**Section 6: Entry/Exit Criteria**
- Testing entry criteria (when to start)
- Testing exit criteria (when to stop)
- Sign-off requirements
- Regression testing triggers

**Section 7: Dependencies**
- Prerequisite testing phases
- Blocking issues or tickets
- External system availability
- Third-party dependencies

**Section 8: Schedule**
- Testing timeline
- Milestones
- Resource allocation timeline
- Release coordination

**Section 9: Resources**
- Team members and roles
- Test lead assignments
- Stakeholder involvement
- Support requirements

**Section 10: References**
- Feature documentation links
- Standards and best practices
- Templates and tools links
- Related testing documents

Reference template: `@qa-agent-os/templates/feature-test-strategy-template.md`

Output location: `qa-agent-os/features/[feature-name]/feature-test-strategy.md`

Reference pattern: `profiles/default/commands/plan-feature/single-agent/4-create-strategy.md`

### Success Output

Display comprehensive success message:

```
Feature analysis complete!

Created documents:
1. feature-knowledge.md (8 sections)
   Location: qa-agent-os/features/[feature-name]/feature-knowledge.md

2. feature-test-strategy.md (10 sections)
   Location: qa-agent-os/features/[feature-name]/feature-test-strategy.md

Analysis details:
- Business rules extracted: [count]
- API endpoints documented: [count]
- Data models defined: [count]
- Edge cases identified: [count]
- Open questions noted: [count]

Testing strategy includes:
- Testing approach defined
- Tools and environments configured
- Test data strategy defined
- Risks identified and mitigated
- Schedule and resources planned

Next steps:
1. Review the generated documents for accuracy
2. Share with stakeholders for feedback
3. Create tickets for this feature: /start-ticket [ticket-id]
4. Each ticket will reference this feature strategy

Feature path: qa-agent-os/features/[feature-name]/
```

### Next Phase

When complete, provide guidance to create tickets for this feature using `/start-ticket [ticket-id]`.

Each ticket will:
- Inherit the feature strategy
- Reference feature knowledge for context
- Add ticket-specific requirements
- Detect gaps between ticket and feature knowledge
- Create ticket-specific test plans
