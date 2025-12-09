# Requirements: Eliminate Templates - Standards as Single Source of Truth

**Spec:** eliminate-template-duplication
**Date:** 2025-12-01
**Status:** Requirements Complete

---

## User Decisions

Based on user clarifications:

1. **Template Approach:** ❌ Remove templates entirely, merge into standards (single source of truth)
2. **Standards Consolidation:** ✅ Merge similar standards files
3. **Workflow Integration:** ✅ Complete workflows and integrate them into command flow
4. **Architecture Vision:** Standards = templates = same concept, no need for separation

---

## Problem Statement

The current QA Agent OS architecture has **fundamental duplication** between templates and standards:

### Current Architecture Issues

```
Current (DUPLICATED):
├── templates/
│   ├── bug-report-template.md          ← Structure + Content + Examples
│   ├── test-plan-template.md           ← Structure + Content + Examples
│   ├── test-cases-template.md          ← Structure + Content + Examples
│   └── feature-knowledge-template.md   ← Structure + Content + Examples
│
└── standards/
    ├── bugs/
    │   ├── bug-template.md              ← DUPLICATE: Structure + Content
    │   ├── severity-rules.md            ← DUPLICATE: Content
    │   ├── bug-reporting-standard.md    ← DUPLICATE: Content
    │   ├── bug-reporting.md             ← DUPLICATE: Content
    │   └── bug-analysis.md              ← DUPLICATE: Content
    │
    └── testcases/
        ├── test-case-standard.md        ← DUPLICATE: Content
        ├── test-case-structure.md       ← DUPLICATE: Structure
        └── test-generation.md           ← DUPLICATE: Content
```

**Problems:**

1. **Templates and Standards are the same concept in 2 places**
   - Templates define: "Here's the document structure with field definitions and examples"
   - Standards define: "Here's the document structure with field definitions and rules"
   - **They're the same thing!**

2. **Double Maintenance Burden**
   - Adding "summary" field requires updating BOTH template AND standards
   - Changes must be synchronized across 2 locations
   - Risk of inconsistency between template and standards

3. **Token/Context Waste**
   - Bug documentation alone: 657 lines across templates + 5 standards files
   - Test documentation: 576 template lines + 149 standards lines
   - Duplication wastes precious LLM context window

4. **Architectural Confusion**
   - Commands reference templates directly
   - Phase files embed template structure inline (390 lines in `/report-bug`)
   - Workflows exist but are unused/incomplete
   - No clear single source of truth

5. **No Compiler to Detect Unused Files**
   - Markdown has no build step to find unused files
   - Files like `workflows/bug-tracking/bug-reporting.md` exist but aren't used
   - Impossible to know what's dead code vs actively used

---

## Proposed Solution: Standards as Single Source of Truth

### Unified Architecture (Single-Agent & Multi-Agent)

```
Commands (Orchestrators)
  ├─ Single-Agent Mode → Phase Files → Workflows → Standards
  └─ Multi-Agent Mode  → Subagents   → Workflows → Standards
```

**Flow Details:**

- **Phase Files (Single-Agent):** Step-by-step instructions Claude executes directly
- **Subagents (Multi-Agent):** Specialized agents (e.g., bug-writer, requirement-analyst) that execute workflows autonomously
- **Workflows:** Reusable business logic (shared by both modes)
- **Standards:** Single source of truth - document structure + rules + examples (shared by both modes)

**Example (`/report-bug`):**

Single-Agent:
```
/report-bug → Phase 4 → {{workflows/bug-reporting}} → @standards/bugs/bug-reporting.md
```

Multi-Agent:
```
/report-bug → bug-writer agent → workflows/bug-reporting → @standards/bugs/bug-reporting.md
```

### New Architecture

```
Proposed (UNIFIED):
└── standards/
    ├── bugs/
    │   └── bug-reporting.md             ← UNIFIED: Structure + Content + Rules + Examples
    │
    ├── testcases/
    │   ├── test-plan.md                 ← UNIFIED: Test plan structure + standards
    │   └── test-cases.md                ← UNIFIED: Test cases structure + standards
    │
    ├── features/
    │   ├── feature-knowledge.md         ← UNIFIED: Feature documentation structure + standards
    │   └── feature-test-strategy.md     ← UNIFIED: Test strategy structure + standards
    │
    └── conventions.md                   ← General QA conventions (unchanged)
```

**Benefits:**

✅ **Single Source of Truth:** Standards contain everything (structure + content + rules + examples)
✅ **Zero Duplication:** No templates folder, no duplicate information
✅ **Simpler Architecture:** Commands → Workflows → Standards (no template layer)
✅ **Single Maintenance Point:** Add "summary" field once in standards, done
✅ **Token Efficiency:** ~40-50% reduction in markdown content loaded to LLM
✅ **Clearer Conceptually:** "Standards define how to build documents" - one concept, one place

---

## Detailed Changes

### 1. Eliminate Templates Folder Entirely

**Delete Folder:**
```
profiles/default/templates/  ← DELETE ENTIRE FOLDER
├── bug-report-template.md
├── test-plan-template.md
├── test-cases-template.md
├── feature-knowledge-template.md
├── feature-test-strategy-template.md
├── test-plan-template.md
└── collection-log-template.md
```

**Why:** Templates and standards are the same concept. Keeping both creates confusion and duplication.

---

### 2. Consolidate and Enhance Standards

#### Bug Standards Consolidation

**Before (5 files, 443 lines):**
```
standards/bugs/
├── bug-template.md                  (130 lines)
├── severity-rules.md                (189 lines)
├── bug-reporting-standard.md        (55 lines)
├── bug-reporting.md                 (25 lines)
└── bug-analysis.md                  (44 lines)
```

**After (1 file, ~300 lines consolidated):**
```
standards/bugs/
└── bug-reporting.md                 (300 lines - comprehensive)
```

**Contents of Unified `bug-reporting.md`:**
```markdown
# Bug Reporting Standard

## Document Structure

### Required Sections

1. Bug Summary
2. Environment
3. Steps to Reproduce
4. Expected vs Actual Behavior
5. Evidence
6. Severity Classification
7. Impact Analysis
8. Related Information

### Field Definitions

#### Bug Summary
**Purpose:** One-sentence description of the issue
**Format:** [Component] - [Brief description of defect]
**Examples:**
- "Login Form - Submit button disabled with valid credentials"
- "API - Returns 500 error for GET /users endpoint"

**Validation:**
- Max 100 characters
- Must include component name
- Must be descriptive (not "Bug in app")

#### Environment
**Purpose:** Where the bug was found
**Required Fields:**
- Environment: [Dev/Staging/Production]
- Browser/Device: [Chrome 118, iPhone 14, etc.]
- OS: [Windows 11, iOS 17, etc.]
- Version/Build: [v2.3.1, build #1234]

[Continue with all fields from old bug-template.md + bug-reporting-standard.md]

## Severity Classification Rules

[Full content from severity-rules.md]

### Critical (P1)
- Production down or severely degraded
- Data loss or corruption
- Security vulnerability exposed
[etc...]

## Bug Analysis Methodology

[Full content from bug-analysis.md]

### Root Cause Analysis
1. Identify symptoms vs root cause
2. Check for similar existing bugs
3. Determine affected scope
[etc...]

## Reporting Workflow

[Full content from bug-reporting-standard.md]

### Evidence Collection Checklist
- [ ] Screenshots/screen recording
- [ ] Console logs (browser/app)
- [ ] Network traffic (HAR file or screenshots)
[etc...]

## Examples

### Example 1: Critical Bug Report
[Full example with all sections filled]

### Example 2: Medium Severity Bug
[Full example]
```

**Result:** One comprehensive standard containing structure + rules + examples + methodology.

---

#### Test Plan Standards Consolidation

**Before (1 template + scattered standards):**
```
templates/test-plan-template.md      (253 lines)
standards/testcases/                 (various)
```

**After (1 unified standard):**
```
standards/testcases/test-plan.md     (350 lines comprehensive)
```

**Contents:**
- Document structure (12 sections)
- Field definitions for each section
- Coverage matrix standards
- Test data requirements standards
- Entry/exit criteria rules
- Examples of complete test plans

---

#### Test Cases Standards Consolidation

**Before:**
```
templates/test-cases-template.md           (323 lines)
standards/testcases/test-case-standard.md  (64 lines)
standards/testcases/test-case-structure.md (38 lines)
```

**After:**
```
standards/testcases/test-cases.md          (400 lines comprehensive)
```

**Contents:**
- Test case document structure
- Test case field definitions
- Test case types (functional, edge, negative, dependency)
- Priority classification rules
- Automation recommendations standards
- Execution tracking format
- Examples of all test case types

---

#### Feature Documentation Standards

**Before:**
```
templates/feature-knowledge-template.md      (130 lines)
templates/feature-test-strategy-template.md  (192 lines)
```

**After:**
```
standards/features/feature-knowledge.md      (180 lines)
standards/features/feature-test-strategy.md  (250 lines)
```

**Contents:** Same structure but enhanced with validation rules, best practices, and examples.

---

### 3. Complete and Integrate Workflows

**Current Issue:** Workflows exist but are incomplete/unused.

**Example:**
```
workflows/bug-tracking/bug-reporting.md  ← Incomplete stub, not used by /report-bug
```

**Solution:** Complete workflows and integrate into command flow.

#### New Command Flow

**Before:**
```
Command Orchestrator
  → Phase Files (with inline duplication)
    → Direct template references
      → Standards (sometimes referenced, sometimes not)
```

**After:**
```
Command Orchestrator
  → Workflow (complete, reusable)
    → Standards (single source of truth)
      → Agents (if multi-agent mode)
```

#### Complete `bug-reporting.md` Workflow

**File:** `profiles/default/workflows/bug-tracking/bug-reporting.md`

**Contents:**
```markdown
# Bug Reporting Workflow

This workflow guides bug report creation using the bug reporting standard.

## Input
- Bug context (feature, ticket, environment)
- Evidence gathered by user

## Output
- Complete bug report at: `qa-agent-os/features/[feature]/[ticket]/bugs/BUG-XXX.md`

## Workflow Steps

### Step 1: Read Bug Reporting Standard

Read the comprehensive bug reporting standard:
- **File:** `@qa-agent-os/standards/bugs/bug-reporting.md`
- **Purpose:** Understand document structure, field definitions, severity rules, analysis methodology

### Step 2: Collect Bug Information

Follow the evidence collection checklist from the standard:
- Prompt user for required fields (summary, environment, steps to reproduce)
- Guide evidence collection (screenshots, logs, network traffic)
- Ask clarifying questions based on bug type

### Step 3: Classify Severity

Apply severity classification rules from the standard:
- Analyze impact (production down? data loss? workaround available?)
- Determine initial severity (Critical/High/Medium/Low)
- Allow user override with justification

### Step 4: Perform Bug Analysis

Apply bug analysis methodology from the standard:
- Root cause analysis
- Check for similar bugs
- Determine affected scope
- Identify reproduction reliability

### Step 5: Generate Bug Report

Create bug report document following the structure from the standard:
- Apply all field definitions and formats
- Include all collected evidence
- Add severity justification
- Reference related bugs/tickets
- Include impact analysis

Save to: `[ticket-path]/bugs/BUG-[auto-increment].md`

### Step 6: Completion

Output confirmation with bug ID and severity.
```

**Result:** Workflow references standard as single source of truth, no duplication.

---

### 4. Update Command Phase Files to Reference Workflows

**Before (Phase 4 of `/report-bug`):**
```markdown
# Phase 4: Generate Bug Report

Create bug report with this structure:

[390 lines of inline template duplication]

## Bug Summary
**Format:** [Component] - [Brief description]
[Full field definition duplicated from template]

## Environment
[Full section duplicated]

[Continues for 390 lines...]
```

**After:**
```markdown
# Phase 4: Generate Bug Report

Execute the bug reporting workflow:

{{workflows/bug-tracking/bug-reporting}}

The workflow will:
1. Read the bug reporting standard
2. Collect all required information
3. Classify severity using standard rules
4. Perform analysis using standard methodology
5. Generate bug report following standard structure

**Standard Reference:** `@qa-agent-os/standards/bugs/bug-reporting.md`
```

**Result:** Phase file reduced from 390 lines to ~20 lines. All content lives in standard.

---

### 5. Standards Become Self-Contained Documents

Each standard should be a **complete, standalone guide** containing:

1. **Document Structure** (what templates used to provide)
   - Required sections and ordering
   - Optional sections
   - Section purposes

2. **Field Definitions** (what templates used to provide)
   - Field name, purpose, format
   - Validation rules
   - Examples

3. **Content Standards** (what standards used to provide)
   - Best practices
   - Conventions
   - Patterns to follow/avoid

4. **Rules and Methodology** (what standards used to provide)
   - Classification criteria (severity, priority)
   - Analysis methodologies
   - Workflows and checklists

5. **Examples** (what templates used to provide)
   - Complete example documents
   - Good vs bad examples
   - Edge cases

**Result:** One file has everything. No need to check multiple files. No duplication.

---

## File Changes Summary

### Files to Delete (7 files)

```
profiles/default/templates/
├── bug-report-template.md                    ❌ DELETE (merge to standards/bugs/bug-reporting.md)
├── test-plan-template.md                     ❌ DELETE (merge to standards/testcases/test-plan.md)
├── test-cases-template.md                    ❌ DELETE (merge to standards/testcases/test-cases.md)
├── feature-knowledge-template.md             ❌ DELETE (merge to standards/features/feature-knowledge.md)
├── feature-test-strategy-template.md         ❌ DELETE (merge to standards/features/feature-test-strategy.md)
├── test-plan-template.md                     ❌ DELETE (duplicate)
└── collection-log-template.md                ❌ DELETE (no longer needed after streamlining)
```

**DELETE entire templates/ folder**

### Files to Consolidate and Enhance

#### Bug Standards (5 → 1 file)

**Delete:**
```
standards/bugs/
├── bug-template.md              ❌ DELETE (merge into bug-reporting.md)
├── severity-rules.md            ❌ DELETE (merge into bug-reporting.md)
├── bug-reporting-standard.md    ❌ DELETE (merge into bug-reporting.md)
└── bug-analysis.md              ❌ DELETE (merge into bug-reporting.md)
```

**Keep and Enhance:**
```
standards/bugs/
└── bug-reporting.md             ✅ ENHANCE (merge all 5 files into this)
```

#### Test Case Standards (3 → 2 files)

**Delete:**
```
standards/testcases/
├── test-case-standard.md        ❌ DELETE (merge into test-cases.md)
└── test-case-structure.md       ❌ DELETE (merge into test-cases.md)
```

**Create:**
```
standards/testcases/
├── test-plan.md                 ✅ CREATE (from test-plan-template.md + enhancements)
└── test-cases.md                ✅ CREATE (from test-cases-template.md + merge standards)
```

**Keep:**
```
standards/testcases/
└── test-generation.md           ✅ KEEP (unique content, no duplication)
```

#### Feature Standards (0 → 2 files)

**Create:**
```
standards/features/               ✅ CREATE FOLDER
├── feature-knowledge.md          ✅ CREATE (from feature-knowledge-template.md)
└── feature-test-strategy.md      ✅ CREATE (from feature-test-strategy-template.md)
```

### Workflows to Complete

**Complete:**
```
workflows/bug-tracking/
└── bug-reporting.md              ✅ COMPLETE (currently stub, make comprehensive)
```

**Verify/Complete:**
```
workflows/testing/
├── requirement-analysis.md       ✅ VERIFY (ensure references test-plan standard)
└── testcase-generation.md        ✅ VERIFY (ensure references test-cases standard)
```

### Command Phase Files to Update

**Update to reference workflows instead of inline duplication:**
```
commands/report-bug/single-agent/
└── 4-generate-report.md          ✅ UPDATE (reference workflow, remove inline content)

commands/plan-ticket/single-agent/
├── 3-analyze-requirements.md     ✅ UPDATE (reference workflow)
└── 4-optional-testcase-gen.md    ✅ UPDATE (reference workflow)

commands/generate-testcases/single-agent/
└── 3-generate-cases.md           ✅ UPDATE (reference workflow)
```

---

## Token Savings Estimate

### Current Token Usage (Approximate)

**Templates:**
- bug-report-template.md: 214 lines
- test-plan-template.md: 253 lines
- test-cases-template.md: 323 lines
- feature templates: 322 lines
- **Total:** ~1,112 lines

**Duplicate Standards Content:**
- Bug standards (5 files): 443 lines
- Test case standards: 149 lines
- **Total:** ~592 lines

**Command Phase Inline Duplication:**
- `/report-bug` Phase 4: 390 lines
- Other phases: ~200 lines
- **Total:** ~590 lines

**Grand Total Duplication:** ~2,294 lines of duplicated content

### After Consolidation

**Unified Standards:**
- bugs/bug-reporting.md: 300 lines (consolidates 657 lines)
- testcases/test-plan.md: 350 lines (consolidates 253 template + scattered standards)
- testcases/test-cases.md: 400 lines (consolidates 472 lines)
- features/: 430 lines (consolidates 322 template lines)
- **Total:** ~1,480 lines

**Workflows (Completed):**
- bug-reporting.md: 80 lines
- Other workflows: ~200 lines
- **Total:** ~280 lines

**Command Phase Files (Minimal):**
- All phases reference workflows: ~100 lines total
- **Total:** ~100 lines

**Grand Total After:** ~1,860 lines

**Token Savings:** ~434 lines eliminated (~19% reduction)

**More importantly:**
- ✅ Zero duplication (0 duplicate lines)
- ✅ Single source of truth (1 place to update)
- ✅ Clearer architecture (easier to understand and maintain)

---

## Implementation Plan

### Phase 1: Create Unified Standards

1. **Create `standards/bugs/bug-reporting.md`**
   - Merge all 5 bug standards files
   - Add document structure from bug-report-template.md
   - Add examples
   - Ensure comprehensive and self-contained

2. **Create `standards/testcases/test-plan.md`**
   - Copy test-plan-template.md structure
   - Merge test plan standards
   - Add validation rules
   - Add examples

3. **Create `standards/testcases/test-cases.md`**
   - Copy test-cases-template.md structure
   - Merge test-case-standard.md and test-case-structure.md
   - Add examples

4. **Create `standards/features/` folder**
   - Create feature-knowledge.md (from template + enhancements)
   - Create feature-test-strategy.md (from template + enhancements)

### Phase 2: Complete Workflows

1. **Complete `workflows/bug-tracking/bug-reporting.md`**
   - Add all 6 steps
   - Reference bug-reporting.md standard
   - Remove duplication

2. **Update `workflows/testing/requirement-analysis.md`**
   - Reference test-plan.md standard
   - Remove template references

3. **Update `workflows/testing/testcase-generation.md`**
   - Reference test-cases.md standard
   - Remove template references

### Phase 3: Update Command Phase Files

1. **Update `/report-bug` Phase 4**
   - Replace 390 lines with workflow reference
   - Test execution

2. **Update `/plan-ticket` Phase 3**
   - Replace template reference with workflow + standard reference
   - Test execution

3. **Update `/generate-testcases` Phase 3**
   - Replace template reference with workflow + standard reference
   - Test execution

### Phase 4: Delete Old Files

1. **Delete `templates/` folder entirely**
2. **Delete old bug standards files** (bug-template.md, severity-rules.md, etc.)
3. **Delete old test case standards files** (test-case-standard.md, test-case-structure.md)

### Phase 5: Update Documentation

1. **Update CHANGELOG.md** with v0.6.0
2. **Update README.md** with new architecture
3. **Update CLAUDE.md** with standards-as-source-of-truth pattern

---

## Success Criteria

✅ **Zero Templates:** templates/ folder deleted
✅ **Zero Duplication:** No duplicate content across standards
✅ **Single Source of Truth:** Each standard is comprehensive and self-contained
✅ **Workflows Integrated:** Commands → Workflows → Standards (clean flow)
✅ **Token Efficiency:** ~19% reduction in loaded content
✅ **Maintainability:** Adding "summary" field requires 1 update in 1 standard file
✅ **Clarity:** Architecture is simple and easy to understand

---

## Migration Notes

**For Existing Users:**
- Generated documents (existing bug reports, test plans) remain unchanged
- New documents will use unified standards
- No breaking changes for end users

**For Developers:**
- Update custom commands to reference standards instead of templates
- Update custom workflows to follow new pattern
- Delete any local templates/ folder overrides

---

## Out of Scope

❌ Multi-agent architecture changes (defer to later)
❌ Existing generated documents migration (not needed)
❌ Custom user templates in projects (users can keep if desired)

---

**Requirements Status:** ✅ Complete
**User Decisions:** Confirmed
**Ready for:** Implementation
