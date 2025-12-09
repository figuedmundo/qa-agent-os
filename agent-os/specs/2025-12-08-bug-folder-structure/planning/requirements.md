# Spec Requirements: Bug Folder Structure Reorganization

**Spec:** bug-folder-structure
**Date:** 2025-12-08
**Status:** Requirements Complete

---

## Initial Description

The user wants to reorganize the bug reporting structure in QA Agent OS. Currently, bugs are created per ticket, but the user believes bugs should be organized at the feature level instead. This specification defines the new folder structure, file organization, supporting materials handling, and command integration for feature-level bug management.

---

## Requirements Discussion

### First Round Questions

**Q1:** I'm assuming bug IDs should be auto-incremented sequentially at the feature level (BUG-001, BUG-002, etc.). Should we keep the folder name stable with an auto-incremented ID and store any external Jira ID as a metadata field in the bug-report.md, or should we embed the Jira ID directly in the folder name?

**Answer:** Option A selected - Keep BUG-001, store Jira ID as metadata field in bug-report.md. This keeps folders stable and allows the bug-report.md to reference the Jira ID when the bug is approved and sent to Jira.

---

**Q2:** I'm thinking the folder structure should include organized subfolders for supporting materials: screenshots/, logs/, videos/, and artifacts/. Does this cover all the material types you'd want to store, or should we add/remove any categories?

**Answer:** Recommended structure accepted:
- `screenshots/` - PNG, JPG, GIF images showing the bug
- `logs/` - TXT, LOG files with console output, error logs, server logs, database logs
- `videos/` - MP4, MOV, WebM screen recordings and reproductions
- `artifacts/` - HAR files (network traces), SQL queries, JSON configs, dev tools exports, database dumps

---

**Q3:** Should the bug-report.md include a field to track which ticket(s) this bug affects? For example, "Ticket: TICKET-123" or "Related Tickets: TICKET-123, TICKET-456"?

**Answer:** Yes - Add "Ticket: TICKET-123" field to bug-report.md to track which ticket this bug affects. This creates a relationship between the feature-level bug and the specific tickets that are impacted.

---

**Q4:** Should we include ALL types of supporting materials that help reproduce the bug (database snapshots, network traces, configuration files, etc.), or limit it to visual evidence (screenshots/videos)?

**Answer:** All types that help reproduce the bug. The subfolder structure should support comprehensive evidence collection including database dumps, network traces, config files, and any other artifacts that assist in understanding and reproducing the issue.

---

**Q5:** Should we create a master index file at the feature level (like bugs-index.md) that lists all bugs in that feature, or should users just browse the BUG-00X folders directly?

**Answer:** No master index file needed. Users can browse folders directly. Simpler implementation and maintains clarity without adding another document to maintain.

---

**Q6:** When the user runs a bug reporting command, should it auto-detect that it's being run from within a feature directory and automatically create the correct folder structure with the next sequential BUG-ID?

**Answer:** Yes - Auto-detect feature context and create new folder structure. The command should be intelligent enough to know which feature the user is working in and auto-increment the BUG-ID accordingly.

---

**Q7:** For existing bugs currently organized at the ticket level, should we create a migration script or deprecation path, or should this be forward-looking only with new bugs following the new structure?

**Answer:** Forward-looking only, no legacy migration needed. New bugs will use the feature-level structure, and there's no need to move existing ticket-level bugs.

---

### Existing Code to Reference

**Similar Features Identified:**

- **Bug Reporting Command:** `profiles/default/commands/report-bug/` - Existing command for creating bug reports that will need to be updated
- **Revise Bug Command:** `profiles/default/commands/revise-bug/` - Existing command for updating bugs that will need to support feature-level structure
- **Bug Reporting Standard:** `profiles/default/standards/bugs/bug-reporting.md` - The standard that defines bug document structure and fields
- **Global Bug Conventions:** `profiles/default/standards/global/bugs.md` - Conventions for how bugs are treated in QA workflows

---

## Visual Assets

### Files Provided
No visual assets were provided for this specification.

---

## Requirements Summary

### Functional Requirements

**Feature-Level Organization:**
- Bugs organized at `/qa-agent-os/features/[feature-name]/bugs/` instead of ticket level
- Enables multi-ticket bugs and feature-level issue tracking
- Clear separation of bug management from ticket-specific testing

**Folder Structure:**
- Each bug stored in its own folder: `BUG-00X-[short-title]/`
- Auto-increment ID per feature (BUG-001, BUG-002, BUG-003, etc.)
- Short title derived from bug summary, URL-friendly format
- Subfolders for organized evidence collection:
  - `screenshots/` - Visual evidence (PNG, JPG, GIF)
  - `logs/` - Text logs and diagnostic output (TXT, LOG)
  - `videos/` - Video reproductions (MP4, MOV, WebM)
  - `artifacts/` - Network traces, database dumps, configs (HAR, JSON, SQL)

**bug-report.md Fields:**
- ID: BUG-001 (auto-incremented per feature)
- Title: [short-title]
- Description: [detailed description of the issue]
- Steps to Reproduce: [numbered, repeatable steps]
- Expected Behavior: [what should happen]
- Actual Behavior: [what actually happens]
- Severity: [Critical/High/Medium/Low]
- Environment: [browser, OS, version, etc.]
- Ticket: [TICKET-123] (identifies which ticket this bug affects)
- Jira_ID: [BUG-12345] (optional, populated when bug is approved and sent to Jira)
- Status: [Open/In Progress/Approved/Resolved/Closed]
- Date Created: [timestamp]
- Date Updated: [timestamp]
- Attachments: [list of supporting materials organized in subfolders]

**Supporting Materials Organization:**
- Screenshots stored in `screenshots/` with descriptive names (e.g., `form-validation-error.png`)
- Logs stored in `logs/` with timestamps or descriptions (e.g., `console-error-2025-12-08.log`)
- Videos stored in `videos/` with clear names (e.g., `login-flow-reproduction.mp4`)
- Artifacts stored in `artifacts/` organized by type (e.g., `network-trace-login.har`, `database-dump.sql`, `config-export.json`)

**Command Integration:**

`/report-bug` command enhancements:
- Auto-detect if run from within a feature directory
- Auto-determine the correct BUG-ID based on existing bugs in feature
- Create new folder structure: `BUG-00X-[title]/`
- Create bug-report.md with template fields
- Create supporting material subfolders automatically
- Prompt user for material paths and organize them into correct subfolders

`/revise-bug` command enhancements:
- Auto-detect feature and bug context from working directory
- Update existing bug-report.md
- Support adding new materials to appropriate subfolders
- Maintain status tracking and version history

---

### Reusability Opportunities

- **Leverage existing bug-reporting standard:** The consolidated `standards/bugs/bug-reporting.md` defines the document structure that will be used for bug-report.md
- **Reference report-bug command logic:** Auto-increment and context detection patterns from existing `/report-bug` command
- **Apply feature-level organization patterns:** Parallel to how tickets are organized within features in the current structure
- **Shared supporting materials patterns:** Similar to how test artifacts and documentation are organized in feature knowledge

---

### Scope Boundaries

**In Scope:**
- Define feature-level bug folder structure
- Establish naming conventions for folders and files
- Define bug-report.md field structure and requirements
- Organize supporting materials into logical subfolders
- Add "Ticket" field to track bug-to-ticket relationships
- Add "Jira_ID" field for external issue tracking
- Update /report-bug command to create feature-level bugs
- Update /revise-bug command to work with feature-level bugs
- Auto-detect feature context from working directory
- Auto-increment BUG-IDs within each feature

**Out of Scope:**
- Creating migration script for existing ticket-level bugs (forward-looking only)
- Multi-feature bug view or cross-feature bug index (each feature manages its own bugs)
- Automated Jira synchronization (manual field update for now)
- Creating master bugs index file at feature level
- Organizing bugs by status, severity, or other hierarchies
- Real-time bug tracking dashboard or visualization

---

### Technical Considerations

**Auto-Increment Logic:**
- Read existing bug folders in feature to determine next ID
- Format: BUG-###, zero-padded to 3 digits
- Increment per feature (BUG-001 for Feature A, separate numbering for Feature B)

**Folder Naming:**
- Format: `BUG-00X-[short-title]/` where short-title is URL-friendly (hyphens, lowercase)
- Derived from bug title/summary automatically
- Keep short but descriptive (e.g., `BUG-001-login-form-validation-error`)

**Context Detection:**
- Detect feature context from working directory path
- Check if running from within `/qa-agent-os/features/[feature-name]/` directory
- Auto-suggest feature if ambiguous; error if feature context not found

**Template Generation:**
- Generate bug-report.md using existing bug-reporting standard as reference
- Pre-populate environment fields if context available
- Leave most fields empty for user to fill

**Supporting Materials:**
- Create empty subfolders during bug creation
- User responsibility to populate with actual files
- Command can assist in organizing files into correct subfolders based on file type

**Status Tracking:**
- Implement status field in bug-report.md (Open/In Progress/Approved/Resolved/Closed)
- Dates auto-set on creation and updated on revisions
- Support status transitions via /revise-bug command

---

## Existing Code References

### Standards to Reference
- **File:** `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/agent-os/standards/bugs/` - Contains bug-related standards and conventions
- **File:** `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/agent-os/standards/global/` - Contains global conventions including bug handling

### Commands to Update
- **Location:** `/Users/edmundo.figueroaherbas@medirect.com.mt/projects/personal/qa-agent-os/agent-os/specs/2025-12-08-bug-folder-structure/` - Reference when implementing report-bug and revise-bug command updates

### Related Architecture
- **Feature Structure Pattern:** How features are organized in `/qa-agent-os/features/` should mirror the pattern for bug organization
- **Ticket Structure Pattern:** How tickets are organized within features can inform how bugs are organized within features

---

## Design Decisions

**Decision 1: Option A - BUG-ID Stability with Jira_ID Metadata**
- **Why:** Keeps folder names stable and predictable
- **Impact:** Users can reference bugs by stable BUG-ID; Jira ID is tracked but doesn't affect folder structure
- **Alternative rejected:** Embedding Jira ID in folder name would require renaming folders when bugs are exported to Jira, causing path breakage

**Decision 2: Organized Subfolders for Supporting Materials**
- **Why:** Scalable and discoverable organization; different file types have different purposes
- **Impact:** Users immediately understand what type of evidence is available and where to find it
- **Alternative rejected:** Flat structure would make it harder to find specific types of evidence in large bug reports with many attachments

**Decision 3: Feature-Level Organization**
- **Why:** Bugs often span multiple tickets or relate to the feature as a whole
- **Impact:** Better alignment with feature testing strategy; single source of truth for all feature bugs
- **Alternative rejected:** Ticket-level bugs don't capture cross-ticket issues and create redundancy

**Decision 4: No Master Index File**
- **Why:** Simpler implementation; folder structure is self-documenting
- **Impact:** Users browse folders directly; no maintenance burden for index file
- **Alternative rejected:** Master index adds complexity without significant benefit when folders are well-organized

**Decision 5: Forward-Looking Migration Strategy**
- **Why:** Reduces implementation complexity; existing bugs remain searchable in ticket-level locations
- **Impact:** New bugs use feature-level structure; no disruption to existing processes
- **Alternative rejected:** Migrating all existing bugs would be time-consuming and require path updates across documentation

**Decision 6: Auto-Detect Feature Context**
- **Why:** Improves UX by reducing user input; fewer mistakes in bug placement
- **Impact:** Commands become more intelligent about context; users run commands from feature directory
- **Alternative rejected:** Manual feature selection would be more error-prone and verbose

---

## Implementation Considerations

**Auto-Increment Implementation:**
- Bash/shell function to scan existing BUG-* folders and extract numbers
- Find max ID, increment by 1, zero-pad to 3 digits
- Validate no duplicate IDs exist

**Folder Creation and Validation:**
- Create main bug folder with standardized naming
- Create all subfolder structure (screenshots/, logs/, videos/, artifacts/)
- Validate write permissions and disk space before creation
- Provide clear error messages if folder already exists

**Template Generation:**
- Use bug-reporting standard as reference for field structure
- Generate bug-report.md with empty fields and placeholders
- Include field definitions as comments for user guidance
- Pre-populate available context (environment, feature name, creation timestamp)

**Context Detection Logic:**
- Check current working directory and parent directories for feature structure
- Parse path to extract feature name
- Validate feature exists and is readable
- Support both absolute and relative path detection

**Supporting Materials Organization:**
- Accept file paths from user
- Validate file types belong in correct subfolders
- Copy/move files to correct location
- Update Attachments field in bug-report.md

**Error Handling:**
- Clear messaging if feature context not found
- Graceful handling if BUG-ID collision detected
- Validation of bug-report.md before saving
- Warning if required fields are empty

---

## Out of Scope Details

**Not included in this specification:**
- Detailed UI for material organization (assumed command-line driven)
- Search or filtering across bugs
- Integration with external bug tracking systems (Jira sync is manual)
- Bug lifecycle workflows beyond basic status tracking
- Severity-based prioritization or sorting
- Automated duplicate detection
- Bug assignment or ownership tracking
- Historical tracking of bug movements between statuses

---

**Requirements Status:** Complete
**User Decisions:** All confirmed
**Ready for:** Specification Creation

