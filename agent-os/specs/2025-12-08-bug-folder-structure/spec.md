# Specification: Bug Folder Structure Reorganization

## Goal

Reorganize bug storage from ticket-level to feature-level with a structured folder hierarchy, supporting multi-ticket bugs, organized evidence collection, and Jira integration metadata while maintaining stable bug identifiers for reliable reference and linking.

## Problem Statement

Currently, bugs are created per ticket within ticket folders, which prevents proper tracking of bugs that span multiple tickets or affect the feature holistically. This creates duplication and loses the ability to see all bugs in a feature at once. Bug reporting lacks organized storage for supporting materials like logs, screenshots, and network traces, making it difficult to gather and retrieve evidence during investigation.

## Solution

Implement feature-level bug organization with:
- Stable, auto-incremented bug IDs (BUG-001, BUG-002, etc.) per feature
- Dedicated folder structure at `/qa-agent-os/features/[feature-name]/bugs/BUG-00X-[title]/`
- Organized subfolders for supporting materials: screenshots/, logs/, videos/, artifacts/
- Comprehensive bug-report.md schema with all required fields
- Updated `/report-bug` and `/revise-bug` commands with auto-detection and context awareness
- Jira ID tracked as metadata for future synchronization while keeping folder names stable

## Benefits

- **Multi-Ticket Bug Support**: Track bugs affecting multiple tickets without duplication
- **Organized Evidence**: Semantic subfolders make evidence discovery quick and intuitive
- **Stable References**: BUG-001 remains constant; Jira ID stored separately
- **Feature Clarity**: All bugs visible at feature level alongside testing and feature knowledge
- **Better Investigation**: Structured evidence organization reduces time to root cause
- **Future Integration**: Jira ID field enables automation without folder renames
- **Audit Trail**: Folder-based organization provides clear history of all feature bugs

---

## User Stories

- As a QA Engineer, I want to organize bugs at the feature level so that I can see all bugs affecting a feature regardless of which specific tickets they impact.

- As a QA Lead, I want all bug evidence organized into semantic subfolders so that I can quickly locate screenshots, logs, videos, and artifacts needed to investigate issues.

- As a Developer, I want stable bug identifiers (BUG-001, not Jira IDs) in folder names so that my references and scripts don't break when bugs are exported to Jira.

---

## Specific Requirements

**Feature-Level Bug Organization**
- Bugs stored at `/qa-agent-os/features/[feature-name]/bugs/` instead of ticket level
- Enables tracking of bugs affecting multiple tickets or the feature as a whole
- Supports feature-focused bug management and testing strategy alignment
- Clear separation between ticket-specific testing (test-plan.md, test-cases.md) and feature-wide issues
- Each feature independently manages its bugs with no cross-feature index required

**Auto-Incremented Bug IDs**
- Sequential numbering per feature: BUG-001, BUG-002, BUG-003, etc.
- Zero-padded to 3 digits (BUG-001, not BUG-1)
- IDs are permanent and never change after folder creation
- IDs auto-increment based on highest existing number in feature's bugs folder
- Jira ID stored separately as metadata field in bug-report.md when approved
- Enables stable folder references and prevents link breakage during Jira export

**Folder Structure and Naming**
- Format: `BUG-00X-[short-title]/` where short-title is URL-friendly (lowercase, hyphens)
- Short title derived from bug summary, 20-40 characters recommended
- Example: `BUG-001-login-form-validation-error`, `BUG-003-checkout-payment-timeout`
- All content for one bug contained within its folder to maintain organizational clarity
- Subfolders auto-created but can remain empty if no materials of that type

**bug-report.md Schema**
- Comprehensive markdown file containing all bug metadata and details
- Follows bug-reporting standard format with required and optional fields
- Auto-populated fields: ID, Date Created, Date Updated (timestamps)
- User-populated fields: Title, Description, Steps to Reproduce, Expected Behavior, Actual Behavior, Severity, Environment, Status
- Optional but recommended fields: Ticket (ticket ID this affects), Root Cause, Fix Strategy
- Integration field: Jira_ID (optional, filled when bug approved and sent to Jira)
- Field for tracking supporting materials with descriptions (auto-generated from subfolder contents)
- Includes revision log for tracking changes and updates

**Supporting Materials Organization**
- Four semantic subfolders organizing different evidence types:
  - `screenshots/` - PNG, JPG, GIF images showing visual evidence of the bug
  - `logs/` - TXT, LOG files with console output, error logs, server logs, database logs, stack traces
  - `videos/` - MP4, MOV, WebM screen recordings demonstrating repro steps and bug behavior
  - `artifacts/` - HAR files (network traces), SQL queries, JSON configs, dev tools exports, database dumps, environment snapshots
- Flexible structure allows adding new subfolder types for specialized material types
- Subfolders created automatically during bug initialization even if initially empty
- User responsible for populating with actual files via `/report-bug` or `/revise-bug` commands

**Ticket Tracking Field**
- bug-report.md includes "Ticket" field to reference related ticket ID(s)
- Format: Single ticket ID (e.g., `Ticket: TICKET-123`) or comma-separated list (e.g., `Ticket: TICKET-123, TICKET-124`)
- Enables bidirectional traceability between feature-level bugs and ticket-specific testing
- Helps QA teams understand which tickets are impacted by each bug
- Supports cross-ticket bug identification during ticket testing

**Jira Integration Support**
- "Jira_ID" field in bug-report.md stores external Jira ticket identifier (e.g., `Jira_ID: BUG-12345`)
- Field remains empty until bug is approved and sent to Jira
- Folder name stays stable (BUG-001) even after Jira export, preventing path breakage
- Manual update via `/revise-bug` command when bug approved
- Enables future automated synchronization without folder reorganization
- Supports linking bug folder to Jira ticket in bug-report.md description for reference

**Context Detection for Commands**
- `/report-bug` and `/revise-bug` auto-detect if run from feature directory
- Check working directory path for `/qa-agent-os/features/[feature-name]/` pattern
- Validate feature exists and is readable before proceeding
- Support detection from both `/features/[feature]` and `/features/[feature]/bugs/` directories
- Provide clear error message if feature context not found, suggesting correct directory
- Allow manual feature selection if detection fails or is ambiguous

**Auto-Increment Logic for Bug ID Generation**
- Scan existing `BUG-*` folders in feature's bugs directory
- Extract numeric ID from each folder (e.g., BUG-001 becomes 001, BUG-042 becomes 042)
- Find maximum ID number among existing bugs
- Generate next sequential ID (max + 1), zero-padded to 3 digits
- Validate uniqueness before creating new folder
- Handle edge case where bugs folder doesn't exist yet (start at BUG-001)

**Template Generation for New Bugs**
- Generate bug-report.md from existing bug-reporting standard
- Pre-populate with template for all required fields
- Include field descriptions and examples as comments for user guidance
- Pre-fill available context: creation timestamp (ISO format), feature name, optional environment details
- Leave most fields empty for user completion
- Provide clear section markers for bug details, reproduction, classification, evidence, analysis

**Status Tracking and Workflow**
- Status field in bug-report.md with predefined values: Open/In Progress/Approved/Resolved/Closed
- Date Created and Date Updated timestamps track lifecycle
- Version field tracks revisions (1.0, 1.1, 1.2, etc.)
- `/revise-bug` updates timestamps and increments version when changes made
- Maintains audit trail of all status transitions through revision log
- Supports workflow: Open → In Progress → Approved → Resolved → Closed

---

## Visual Design

No visual mockups were provided for this specification. The feature focuses on folder structure organization and file formats rather than UI design.

---

## Existing Code to Leverage

**Bug Reporting Standard (bug-reporting.md)**
- Defines comprehensive bug report structure with metadata, classification, and evidence sections
- Provides severity classification rules (S1-Critical to S4-Trivial) with assessment criteria
- Includes bug analysis methodology and evidence guidelines
- Should be referenced in `/report-bug` template generation to ensure consistency
- Use existing field definitions and format as foundation for bug-report.md schema

**Report-Bug Command (/report-bug)**
- Existing command has 5 phases: detect context, collect details, collect evidence, classify severity, generate report
- Already implements context detection and auto-increment logic for ticket-level bugs
- Demonstrates structured evidence collection and AI severity classification patterns
- Phases framework can be reused; need to redirect output from ticket level to feature level
- Review phase 0 (detect context) to adapt feature-level detection patterns

**Revise-Bug Command (/revise-bug)**
- Existing command supports bug updates with 6 revision types: evidence, severity, status, reproduction, notes, scope
- Implements version tracking and revision log patterns to reuse
- Shows smart bug discovery and user workflow for selecting bugs
- Current phases: detect bug, prompt update type, apply update
- Adapts directly to feature-level bugs with minimal logic changes

**Global Bug Conventions (bugs.md)**
- Defines bug lifecycle: Report, Triage, Fix & Verify, Close
- Specifies required metadata and triage rules
- Sets SLA guidelines and quality gates for bug management
- Informs status workflow and severity assessment in bug-report.md schema
- Should be referenced in spec for workflow alignment

**Feature Folder Structure Patterns**
- Existing features organized as `/qa-agent-os/features/[feature-name]/[ticket-id]/`
- Test artifacts organized into semantic folders (tests/, evidence/, documentation/)
- Shows how to structure related content hierarchically within feature folders
- Tickets organized per feature, suggesting bugs should follow similar pattern
- Patterns can be adapted: `/qa-agent-os/features/[feature-name]/bugs/BUG-00X-[title]/`

---

## Design Decisions

**Decision 1: Feature-Level Organization vs Ticket-Level**
- **Chosen**: Feature-level organization at `/qa-agent-os/features/[feature-name]/bugs/`
- **Rationale**: Bugs often span multiple tickets or represent feature-wide issues; feature-level keeps all bug context together; prevents duplication when bugs affect multiple tickets; aligns with feature-focused testing strategy
- **Alternative Rejected**: Ticket-level would require duplicating bugs if they affect multiple tickets; loses feature-wide bug view; creates maintenance burden for cross-ticket issues

**Decision 2: Auto-Incremented ID Format (BUG-001) vs Jira ID in Folder Name**
- **Chosen**: Keep BUG-001 in folder name (stable reference), store Jira ID as metadata field in bug-report.md
- **Rationale**: Stable folder references prevent path breakage; clean audit trail from BUG-001 through Jira export; supports future folder linking and script references; Jira ID field enables future automation without structural changes
- **Alternative Rejected**: Folder renaming when bugs exported to Jira would break references; Jira-only IDs lose sequential ordering at feature level; mixing internal and external IDs in folder names adds confusion

**Decision 3: Organized Subfolders vs Flat Structure**
- **Chosen**: Organized subfolders (screenshots/, logs/, videos/, artifacts/)
- **Rationale**: Scalable and discoverable organization; users immediately find needed evidence type; supports expansion to new material types without breaking existing structure; semantic folder names are self-documenting
- **Alternative Rejected**: Flat structure simpler initially but harder to navigate in bugs with dozens of attachments; no categorization forces users to rename files for identification

**Decision 4: No Master Bug Index File**
- **Chosen**: No master bugs-index.md at feature level; users browse folder structure directly
- **Rationale**: Simpler implementation and maintenance; folder structure is self-documenting with clear naming; tools can generate lists dynamically; each feature manages bugs independently
- **Alternative Rejected**: Master index adds maintenance overhead; requires synchronization with actual bug folders; minimal user benefit when folders well-organized

**Decision 5: Forward-Looking Migration Strategy (No Legacy Migration)**
- **Chosen**: Forward-looking only; new bugs follow feature-level structure, existing ticket-level bugs remain unchanged
- **Rationale**: Reduces implementation complexity; existing bugs remain searchable in ticket-level locations; new bugs benefit from better organization immediately; no disruption to in-progress bug investigations
- **Alternative Rejected**: Migrating all existing bugs would require path updates across documentation and references; high effort with limited immediate benefit; could introduce errors in migration process

**Decision 6: Auto-Detect Feature Context in Commands**
- **Chosen**: `/report-bug` and `/revise-bug` auto-detect feature context from working directory
- **Rationale**: Improves UX by reducing user input; fewer mistakes in bug placement; commands become more intelligent; users naturally work from feature directory during feature testing
- **Alternative Rejected**: Manual feature selection more error-prone and verbose; adds unnecessary steps to command workflow; reduces command intelligence value

---

## User Workflows

**Workflow 1: Create a New Bug Report**

1. User navigates to feature directory: `cd qa-agent-os/features/[feature-name]/`
2. User runs: `/report-bug` (interactive mode) or `/report-bug --title "Bug title"` (direct mode)
3. System detects feature context from working directory path
4. System reads existing bugs folder and determines next sequential BUG-ID (e.g., BUG-003 if BUG-001 and BUG-002 exist)
5. System prompts for bug title/short description
6. System creates folder structure: `bugs/BUG-003-[short-title]/` with subfolders (screenshots/, logs/, videos/, artifacts/)
7. System generates bug-report.md with template, pre-filled creation timestamp and feature name
8. System guides user through:
   - Bug details questionnaire (description, steps to reproduce, expected vs actual behavior)
   - Environment information (browser, OS, version, feature flags)
   - Supporting evidence collection (screenshots, logs, videos, artifacts)
   - Severity classification with AI suggestion and user confirmation
   - Related ticket ID(s) that this bug affects
9. System organizes uploaded/referenced files into appropriate subfolders based on file type
10. System generates final bug-report.md with all sections completed
11. User reviews and saves bug report
12. User optionally commits bug folder to version control
13. Bug is now visible at feature level with all evidence organized and accessible

**Workflow 2: Investigate and Update Bug Report**

1. User navigates to feature directory or bug directory
2. User runs: `/revise-bug` (interactive selection) or `/revise-bug BUG-003` (direct mode)
3. System detects bug context from working directory or from specified bug ID
4. System displays current bug summary (title, status, severity, key details)
5. System prompts for revision type:
   - Add Evidence: User provides new screenshots, logs, videos, or artifacts
   - Update Status: User changes bug status (Open → In Progress → Approved → Resolved → Closed)
   - Update Severity: User updates severity classification with justification
   - Add Investigation Notes: User adds root cause analysis or fix strategy
   - Update Description: User adds more detailed reproduction steps or environment info
6. System validates user input and processes update:
   - For evidence: Organizes files into correct subfolder (screenshot → screenshots/, etc.)
   - For status: Records transition with timestamp
   - For notes: Appends to appropriate section in bug-report.md
7. System updates timestamps (Date Updated)
8. System increments version number (1.0 → 1.1 → 1.2, major increment for status changes)
9. System adds revision log entry with details, timestamp, and reason for change
10. System saves updated bug-report.md
11. User optionally makes additional updates in same session
12. Bug investigation history fully tracked in revision log

**Workflow 3: Approve Bug and Send to Jira (Manual Export)**

1. User completes bug investigation with full evidence and root cause analysis
2. User updates bug-report.md Status field to "Approved"
3. User runs: `/revise-bug BUG-003` and selects "Update Status" → "Approved"
4. System updates bug-report.md and revision log
5. User exports bug details to Jira (manual process outside this spec)
6. Jira creates external bug ticket, e.g., `BUG-12345`
7. User runs: `/revise-bug BUG-003` and selects "Add Investigation Notes" or creates new revision type
8. User manually adds to bug-report.md: `Jira_ID: BUG-12345`
9. User optionally adds note: "Jira ticket created: https://jira.company.com/browse/BUG-12345"
10. System updates timestamps and version
11. Folder name remains `BUG-003-...` (stable for future reference)
12. Bug now linked to external Jira ticket while maintaining stable internal identifier
13. Future updates can reference either BUG-003 (internal) or BUG-12345 (external Jira)

**Workflow 4: Add Supporting Materials to Existing Bug**

1. User obtains new evidence (screenshot, log file, network trace, etc.)
2. User runs: `/revise-bug BUG-003` and selects "Add Evidence"
3. System prompts: "What type of evidence? [1] Screenshot [2] Log [3] Video [4] Artifact"
4. User selects appropriate type
5. System prompts for file path and optional description
6. System copies/moves file to correct subfolder (e.g., logs/error-2025-12-08-14-30.log)
7. System updates Attachments section in bug-report.md with file path and description
8. System updates Date Updated timestamp and revision log
9. Evidence now organized and accessible from bug-report.md
10. Other team members can immediately find new materials in organized subfolders

---

## Technical Implementation Considerations

**Auto-Increment Implementation**
- Use bash/shell function to scan existing bug folders: `ls -d bugs/BUG-* 2>/dev/null`
- Extract numeric portion from folder names using regex or parameter expansion: `${folder#BUG-}`
- Find maximum ID: `sort -n` and `tail -1`
- Generate next ID: `printf "BUG-%03d" $((max_id + 1))`
- Validate no duplicate IDs exist before creating folder
- Handle edge case: If no bugs folder exists, start with BUG-001
- Prevent race conditions if multiple users create bugs simultaneously (validate final ID before write)

**Folder Creation and Validation**
- Verify feature directory exists and is readable before proceeding
- Create bugs directory if it doesn't exist: `mkdir -p bugs`
- Create bug folder with auto-incremented ID and short title
- Create all subfolders in one operation: `mkdir -p bugs/BUG-00X-title/{screenshots,logs,videos,artifacts}`
- Validate write permissions to feature directory before creating structure
- Provide clear error message if folder creation fails (permissions, disk space, etc.)
- Validate folder name for special characters; sanitize short-title if needed

**Template Generation**
- Source template from existing bug-reporting standard or template file
- Generate bug-report.md with all required sections and field names
- Pre-populate metadata section: ID, Feature, Date Created (ISO timestamp)
- Leave user-populated fields empty with helpful comments/placeholders
- Include field definitions and examples as markdown comments
- Use section markers for easy navigation (## Bug Details, ## Reproduction, etc.)
- Ensure bug-report.md follows same format as other markdown documents in QA Agent OS

**Context Detection Logic**
- Read current working directory: `pwd`
- Parse path components to find `/qa-agent-os/features/[feature-name]/`
- Extract feature name from path: `basename $(dirname $PWD)` or equivalent
- Validate feature directory exists: `[ -d "qa-agent-os/features/$feature" ]`
- Support detection from both `/features/[feature]` and `/features/[feature]/bugs/` and `/features/[feature]/bugs/BUG-00X/`
- If detection fails, provide helpful message: "Could not detect feature context. Please run from feature directory: qa-agent-os/features/[feature-name]/"
- Allow override with parameter: `/report-bug --feature "feature-name"`
- For `/revise-bug`, also support detection from bug folder path to extract both feature and bug ID

**Supporting Materials Organization**
- Accept file paths from user (absolute or relative)
- Validate file types belong in correct subfolders:
  - screenshots/: png, jpg, jpeg, gif
  - logs/: log, txt, out
  - videos/: mp4, mov, webm, avi
  - artifacts/: har, json, sql, xml, csv, dump, config
- If file type unclear, prompt user: "What type of material? [1] Screenshot [2] Log [3] Video [4] Other Artifact"
- Copy/move files to correct subfolder (copy preferred to preserve originals)
- Update Attachments section in bug-report.md with path relative to bug folder and description
- Format: `- [filename] - [user description]` or `- screenshots/checkout-error.png - Button validation error screenshot`

**Status Tracking Implementation**
- Maintain Status field with predefined options: Open / In Progress / Approved / Resolved / Closed
- Track Date Created (immutable) and Date Updated (updates with each revision)
- Maintain Version field starting at 1.0, increment by 0.1 for minor updates, by 1.0 for major status changes
- Major version increments for: Approved, Resolved, Closed, Re-opened status changes
- Minor version increments for: evidence additions, notes, description updates
- Revision log entry for each update: timestamp, change type, previous/new values, reason

**Error Handling and User Guidance**
- Clear messaging if feature context not found: "Could not detect feature context. Please run from: qa-agent-os/features/[feature-name]/"
- Helpful error if BUG-ID collision detected: "Bug ID BUG-003 already exists. Using next available: BUG-004"
- Validation of bug-report.md before saving: check required fields are populated
- Warning if required fields empty: "Warning: Field 'Steps to Reproduce' is empty. Continue? [y/n]"
- Validation of file paths: check files exist and are readable before copying
- Clear message on successful completion: "Bug created: BUG-003-checkout-payment-timeout/"
- Suggest next steps: "Next: Add evidence with /revise-bug, update status as investigation progresses"

---

## Integration with Existing Standards

This feature extends and builds upon established QA Agent OS standards:

**Bug Reporting Standard Reference**
- File: `profiles/default/standards/bugs/bug-reporting.md`
- Defines comprehensive bug report structure, severity classification (S1-S4), and analysis methodology
- This spec uses the existing standard as foundation for bug-report.md schema
- Severity classification rules are applied in both command phases

**Global Bug Conventions Reference**
- File: `profiles/default/standards/global/bugs.md`
- Establishes bug lifecycle: Report → Triage → Fix & Verify → Close
- Defines required metadata, triage rules, SLA guidelines
- This spec's status workflow (Open → In Progress → Approved → Resolved → Closed) aligns with these conventions
- Quality gates referenced in SLA guidelines inform severity classification workflow

**Report-Bug Command Enhancement**
- File: `profiles/default/commands/report-bug/single-agent/report-bug.md`
- Existing command creates bugs at ticket level; needs redirection to feature level
- Phases 0-4 logic can be adapted: context detection, details collection, evidence gathering, severity classification, report generation
- Output path changes from `qa-agent-os/features/[feature]/[ticket]/bugs/` to `qa-agent-os/features/[feature]/bugs/BUG-00X/`
- Auto-increment logic adapted from ticket level to feature level

**Revise-Bug Command Enhancement**
- File: `profiles/default/commands/revise-bug/single-agent/revise-bug.md`
- Existing command updates bugs; phases 1-3 (detect bug, prompt type, apply update) adapt directly
- Bug detection changes from ticket-level to feature-level folder scanning
- Version tracking and revision log patterns reused as-is
- Support new revision types for adding materials to organized subfolders

---

## Out of Scope

The following features are explicitly NOT included in this specification and MUST NOT be built:

- **Migration of Existing Bugs**: No script to migrate ticket-level bugs to feature-level structure; forward-looking only
- **Multi-Feature Bug View**: No cross-feature bug index or global bugs search; each feature manages bugs independently
- **Automated Jira Synchronization**: Jira ID sync is manual (update bug-report.md field); no automated bi-directional sync
- **Master Bugs Index File**: No bugs-index.md or bugs-summary.md at feature level; users browse folders directly
- **Bug Severity/Status Hierarchies**: No automatic organization by severity, priority, or status levels
- **Real-Time Bug Dashboard**: No visualization, metrics, or reporting UI for bug trends
- **Duplicate Bug Detection**: No automatic detection of similar/duplicate bugs across feature
- **Bug Linking/Dependencies**: No ability to mark bugs as related or dependent on other bugs
- **Bug Assignment/Team Collaboration**: No ownership assignment or permission controls; assumes shared team access
- **Historical Status Tracking**: Revision log provides change history, but no timeline visualization or metrics
- **Search Across All Bugs**: No full-text search facility; users navigate folders for discovery
- **Bulk Bug Operations**: No batch update, delete, or status change operations on multiple bugs
- **Bug Templates by Type**: No specialized templates for API bugs, UI bugs, performance bugs, etc.
- **Automated Attachment Validation**: No verification that attachments contain expected data or format validation
- **Backup/Archive Strategy**: No archival process for resolved/closed bugs; all bugs remain in active folder structure

---

## Future Enhancements

These improvements could be added in later phases but are not part of current scope:

**Automated Jira Synchronization**
- Detect when Jira_ID field is populated and automatically sync metadata back to Jira ticket
- Bi-directional sync: updates in bug-report.md could update Jira ticket, and vice versa
- Provide webhook integration for Jira to notify QA Agent OS of external changes

**Global Bugs Search and Index**
- Create command to generate searchable index of all bugs across all features
- Implement text search across all bug-report.md files
- Generate dashboard with bug statistics by severity, status, feature

**Duplicate Bug Detection**
- Analyze bug descriptions and automatically suggest similar/duplicate bugs in feature
- Merge duplicate bugs with cross-references
- Track bug lineage and relationships

**Bug Linking and Dependencies**
- Allow marking bugs as related or dependent on other bugs
- Create visual map of bug relationships within and across features
- Track when one bug blocks resolution of another

**Severity Trend Analysis**
- Track bug severity distribution over time
- Generate reports on critical/high bug trends
- Alert when critical bug count exceeds threshold

**Bug Resolution Metrics**
- Calculate mean time to detect (MTTD) and mean time to resolve (MTTR) per severity
- Track defect escape rate (bugs found in prod vs pre-prod)
- Generate quality improvement recommendations based on trends

**Specialized Bug Templates**
- Create variant templates for API bugs, UI bugs, performance bugs, security bugs
- Pre-populate relevant fields based on bug type
- Include type-specific evidence and analysis templates

**Automated Attachment Organization**
- Validate file contents match declared subfolder type
- Compress artifacts before storage
- Implement retention policies for old attachments

---

## Appendix: Folder Structure Example

```
/qa-agent-os/features/payment-gateway/
├── bugs/
│   ├── BUG-001-checkout-validation-error/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   │   ├── form-validation-message.png
│   │   │   └── error-state-highlighted.png
│   │   ├── logs/
│   │   │   ├── browser-console-2025-12-08.log
│   │   │   └── backend-error-trace.txt
│   │   ├── videos/
│   │   │   └── checkout-flow-repro.mp4
│   │   └── artifacts/
│   │       ├── network-trace-failed-request.har
│   │       └── request-payload.json
│   │
│   ├── BUG-002-payment-processing-timeout/
│   │   ├── bug-report.md
│   │   ├── screenshots/
│   │   │   └── loading-spinner-60-seconds.png
│   │   ├── logs/
│   │   │   └── payment-service-timeout.log
│   │   ├── videos/
│   │   └── artifacts/
│   │       ├── payment-gateway-response.json
│   │       └── database-transaction-log.sql
│   │
│   └── BUG-003-currency-conversion-error/
│       ├── bug-report.md
│       ├── screenshots/
│       │   └── price-displayed-wrong-currency.png
│       ├── logs/
│       │   └── currency-service-response.log
│       ├── videos/
│       └── artifacts/
│           └── exchange-rate-config.json
│
├── documentation/
├── feature-knowledge.md
├── feature-test-strategy.md
│
├── [TICKET-001]/
│   ├── documentation/
│   ├── test-plan.md
│   └── test-cases.md
│
└── [TICKET-002]/
    ├── documentation/
    ├── test-plan.md
    └── test-cases.md
```

---

*Specification complete. Ready for implementation of `/report-bug` and `/revise-bug` commands with feature-level bug organization, auto-increment logic, and supporting materials management.*
