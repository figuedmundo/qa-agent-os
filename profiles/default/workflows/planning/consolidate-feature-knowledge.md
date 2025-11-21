# Consolidate Feature Knowledge Workflow

This workflow analyzes all collected feature documentation and creates a comprehensive feature-knowledge.md document that consolidates WHAT is being built.

## Core Responsibilities

1. **Read Documentation**: Extract information from all collected documents
2. **Analyze & Extract**: Identify core functionality, business rules, technical requirements, edge cases
3. **Organize Knowledge**: Structure information into 8 standardized sections
4. **Create Master Document**: Generate feature-knowledge.md as single source of truth

**Note:** The placeholder `[feature-path]` refers to the full path like `qa-agent-os/features/feature-name`.

---

## Workflow

### Step 1: Read All Collected Documentation

Read all files from `[feature-path]/documentation/`:
- brd.md (Business Requirements Document)
- api-specs.md or api-specs.yaml/json (API Specifications)
- business-rules.md (Business Rules & Calculations)
- mockups/ directory (UI Mockups)
- technical-docs.md (Other Technical Documentation)
- COLLECTION_LOG.md (Collection metadata)

Extract and note:
- Core feature purpose and goals
- Business rules and calculation logic
- API endpoints and data contracts
- User flows and UI patterns
- Edge cases and constraints
- Integration points
- Open questions or ambiguities

### Step 2: Analyze Core Functionality

From the documentation, identify:
- **Feature Purpose**: Why this feature exists, what problem it solves
- **Feature Scope**: What's included in this feature
- **Out of Scope**: What's explicitly excluded
- **Key User Personas**: Who will use this feature
- **Success Criteria**: How success is measured

### Step 3: Extract Business Requirements

From documentation, extract:
- **Core Functionality**: Main capabilities the feature provides
- **Business Rules**: Validation rules, business constraints, conditional logic
- **Calculations**: Formulas, algorithms, mathematical operations
- **Data Dependencies**: What data is required, where it comes from
- **Business Workflows**: Step-by-step business processes

### Step 4: Extract Technical Requirements

From documentation, identify:
- **API Endpoints**: All endpoints (method, path, purpose)
- **Request/Response Formats**: Data structures for each API
- **Data Model**: Entities, relationships, key fields
- **Dependencies**: External systems, third-party services, internal services
- **Technical Constraints**: Performance requirements, technology limitations

### Step 5: Identify User Experience Patterns

From mockups and documentation, note:
- **User Flows**: How users navigate through the feature
- **UI Components**: Key interface elements (forms, tables, modals, charts)
- **Interactions**: User actions and system responses
- **Validation Feedback**: How errors are displayed to users
- **Accessibility Considerations**: Screen reader support, keyboard navigation

### Step 6: Document Edge Cases & Constraints

From documentation and analysis, identify:
- **Known Edge Cases**: Boundary conditions, special scenarios
- **Business Constraints**: Rules that limit functionality
- **Technical Limitations**: System or architectural constraints
- **Data Constraints**: Required formats, value ranges, validation rules

### Step 7: Define Test Considerations

Based on all extracted information, note:
- **Critical Paths**: Most important user flows to test
- **Risk Areas**: High-risk functionality (calculations, integrations)
- **Test Data Needs**: Required test data scenarios
- **Integration Points**: Areas requiring integration testing
- **Performance Considerations**: Areas needing performance testing

### Step 8: Capture Open Questions

During analysis, record any:
- **Ambiguities**: Unclear requirements
- **Missing Information**: Gaps in documentation
- **Assumptions Made**: Things assumed but not explicitly stated
- **Clarifications Needed**: Questions for stakeholders

### Step 9: Create feature-knowledge.md

Create `[feature-path]/feature-knowledge.md` using the template structure:

```markdown
# Feature Knowledge: [Feature Name]

**Status:** Active
**Last Updated:** [YYYY-MM-DD HH:MM]

---

## 1. Feature Overview

### Purpose
[Why this feature exists, what problem it solves]

### Scope
**In Scope:**
- [Item 1]
- [Item 2]

**Out of Scope:**
- [Item 1]
- [Item 2]

### Key User Personas
- [Persona 1]: [Description]
- [Persona 2]: [Description]

### Success Criteria
- [Criterion 1]
- [Criterion 2]

---

## 2. Business Requirements

### Core Functionality
[Detailed description of main capabilities]

### Business Rules
1. **[Rule Name]**: [Description, conditions, exceptions]
2. **[Rule Name]**: [Description, conditions, exceptions]

### Calculations & Formulas
[Any mathematical operations, algorithms, calculation logic]

### Data Dependencies
- [Dependency 1]: [Source, purpose]
- [Dependency 2]: [Source, purpose]

### Business Workflows
[Step-by-step business processes]

---

## 3. Technical Requirements

### API Endpoints

#### [Method] /api/endpoint/path
- **Purpose:** [What this endpoint does]
- **Request Format:**
  ```json
  [Request structure]
  ```
- **Response Format:**
  ```json
  [Response structure]
  ```
- **Validation Rules:** [Any validation]

### Data Model
[Entity definitions, key fields, relationships]

### Dependencies
- **External Systems:** [Third-party integrations]
- **Internal Services:** [Other services this feature depends on]

### Technical Constraints
- [Constraint 1]
- [Constraint 2]

---

## 4. User Experience

### User Flows
1. **[Flow Name]**: [Step-by-step user journey]
2. **[Flow Name]**: [Step-by-step user journey]

### UI Components
- [Component 1]: [Purpose, behavior]
- [Component 2]: [Purpose, behavior]

### Interactions & Validations
[How users interact with the feature, validation feedback]

### Accessibility
[Screen reader support, keyboard navigation, WCAG compliance notes]

---

## 5. Edge Cases & Constraints

### Known Edge Cases
1. **[Edge Case]**: [Description, expected behavior]
2. **[Edge Case]**: [Description, expected behavior]

### Business Constraints
- [Constraint 1]
- [Constraint 2]

### Technical Limitations
- [Limitation 1]
- [Limitation 2]

### Data Constraints
- [Constraint 1]: [Value ranges, formats, validation rules]

---

## 6. Test Considerations

### Critical Paths
1. [Critical user flow 1]
2. [Critical user flow 2]

### Risk Areas
- **High Risk:** [Areas with complex logic, integrations, calculations]
- **Medium Risk:** [Important but less complex areas]

### Test Data Requirements
- [Test data scenario 1]
- [Test data scenario 2]

### Integration Points
- [Integration 1]: [What to test]
- [Integration 2]: [What to test]

### Performance Considerations
- [Performance requirement 1]
- [Performance requirement 2]

---

## 7. Open Questions

1. **[Question]**: [Context, impact, who to ask]
2. **[Question]**: [Context, impact, who to ask]

---

## 8. Document Sources

### Primary Sources
- **BRD**: [feature-path]/documentation/brd.md
- **API Specs**: [feature-path]/documentation/api-specs.md
- **Business Rules**: [feature-path]/documentation/business-rules.md

### Visual Assets
- **Mockups**: [feature-path]/documentation/mockups/

### Collection Log
- **Log**: [feature-path]/documentation/COLLECTION_LOG.md
- **Collection Date**: [YYYY-MM-DD]

---

**Note:** This document is updated when tickets introduce new information via gap detection.
```

### Step 10: Completion

Display summary:
```
Feature knowledge document created!

Created: [feature-path]/feature-knowledge.md

Document contains:
- 8 sections covering all aspects of the feature
- Consolidated information from all source documents
- Test considerations for QA planning
- Open questions for stakeholder clarification

Next: This document will be referenced by all tickets in this feature.
```
