# Task Breakdown: Bug Folder Structure Reorganization

## Overview
Total Tasks: 53
Expected Duration: 5-6 developer-days

## Strategic Summary

This specification reorganizes bug storage from ticket-level to feature-level with stable auto-incremented IDs, organized supporting materials, and updated commands. The implementation follows a logical progression: establish standards and patterns, implement command logic, integrate with existing workflows, and validate through comprehensive testing.

---

## Task List

### Task Group 1: Standards and Template Updates
**Dependencies:** None
**Duration:** 1 day

This task group updates the existing bug reporting standards and creates new templates to support feature-level bug organization with organized supporting materials.

- [x] 1.0 Complete standards updates and template creation
  - [x] 1.1 Update bug-reporting.md standard for feature-level organization
    - Reference file: `/profiles/default/standards/bugs/bug-reporting.md`
    - Add section: "Feature-Level Organization" explaining folder structure at `/qa-agent-os/features/[feature-name]/bugs/`
    - Add section: "Bug ID Format" explaining BUG-XXX format (zero-padded to 3 digits, feature-scoped)
    - Add section: "Supporting Materials Organization" with semantic subfolder structure (screenshots/, logs/, videos/, artifacts/)
    - Update "Metadata" section to include new fields: Ticket, Jira_ID, Date Updated, Version
    - Update "Reproduction" section to reference supporting material locations
    - Include examples of bug folder structure and file organization
    - Ensure alignment with existing bug conventions in standards/global/bugs.md

  - [x] 1.2 Create bug-report.md template for new bugs
    - Create new file: `/profiles/default/templates/bug-report.md`
    - Include all required sections: Metadata, Bug Details, Reproduction, Classification, Evidence, Analysis, Status Workflow
    - Pre-populate placeholders for: ID, Feature, Date Created, Date Updated, Version
    - Add field definitions and examples as markdown comments for user guidance
    - Include attachment tracking section with format: `- [subfolder]/[filename] - [description]`
    - Include revision log section with format: `| Date | Version | Change Type | Details |`
    - Use section markers for easy navigation (## Metadata, ## Bug Details, etc.)
    - Follow existing markdown formatting patterns from standards documents
    - Ensure template matches bug-reporting.md structure exactly

  - [x] 1.3 Create bug folder structure documentation
    - Document file: `/profiles/default/templates/bug-folder-structure-guide.md`
    - Explain full folder hierarchy: `BUG-00X-[short-title]/{screenshots,logs,videos,artifacts}/bug-report.md`
    - Define file type guidelines for each subfolder
    - Provide folder naming rules: URL-friendly format, lowercase, hyphens, 20-40 chars for short-title
    - Include examples of well-formed folder names: `BUG-001-login-form-validation-error`, `BUG-003-checkout-payment-timeout`
    - Provide file organization examples with realistic evidence types
    - Include directory creation commands for manual setup if needed

**Acceptance Criteria:**
- bug-reporting.md updated with feature-level organization section
- bug-report.md template created with all required fields and guidance comments
- bug-folder-structure-guide.md documents complete organization pattern
- Templates follow existing QA Agent OS markdown patterns
- All new fields (Ticket, Jira_ID, Date Updated, Version, revision log) documented

---

### Task Group 2: Auto-Increment Logic Implementation
**Dependencies:** Task Group 1
**Duration:** 1 day

This task group implements the core auto-increment logic for generating sequential bug IDs per feature.

- [x] 2.0 Complete auto-increment logic implementation
  - [x] 2.1 Create bash utility function for ID generation
    - Create file: `/scripts/bug-id-utils.sh` with reusable bash functions
    - Implement function `find_next_bug_id()` that:
      - Takes feature directory path as parameter
      - Scans `bugs/` subdirectory for existing `BUG-*` folders
      - Extracts numeric ID from each folder name using regex: `BUG-([0-9]+)`
      - Finds maximum ID number using `sort -n` and `tail -1`
      - Generates next ID with `printf "BUG-%03d" $((max_id + 1))`
      - Handles edge case where bugs folder doesn't exist (returns BUG-001)
      - Returns both ID and formatted folder name prefix

    - Implement function `validate_bug_id_unique()` that:
      - Verifies proposed bug ID doesn't already exist
      - Checks if folder with BUG-00X pattern already exists
      - Prevents race conditions by validating immediately before folder creation

    - Implement function `sanitize_bug_title()` that:
      - Converts title to URL-friendly format: lowercase, hyphens, alphanumeric
      - Removes special characters but preserves hyphens
      - Truncates to reasonable length (40 chars recommended)
      - Returns sanitized title for folder naming

    - Document each function with usage examples
    - Handle all error cases with meaningful return codes
    - Test functions in isolation before integration

  - [x] 2.2 Test auto-increment logic with edge cases
    - Create test script: `/scripts/test-bug-id-utils.sh`
    - Test scenarios:
      - Empty bugs folder (should return BUG-001)
      - Single bug exists (should return BUG-002)
      - Multiple bugs with gaps (BUG-001, BUG-003 should return BUG-004)
      - Non-sequential IDs (BUG-001, BUG-010 should return BUG-011)
      - Uniqueness validation with existing bug
      - Title sanitization with special characters
      - Title sanitization with unicode characters
      - Title truncation to 40 characters
    - Execute all test cases and verify output
    - Document results in test log

**Acceptance Criteria:**
- bug-id-utils.sh created with all required functions
- find_next_bug_id() correctly generates sequential IDs
- validate_bug_id_unique() prevents collisions
- sanitize_bug_title() produces URL-friendly folder names
- All edge cases handled with meaningful error messages
- Test script verifies all scenarios pass

---

### Task Group 3: Folder Structure Creation
**Dependencies:** Task Group 1, Task Group 2
**Duration:** 1 day

This task group implements the folder and file creation logic for new bugs at feature level.

- [x] 3.0 Complete folder creation implementation
  - [x] 3.1 Create bash function for folder structure initialization
    - Create file: `/scripts/bug-folder-utils.sh`
    - Implement function `create_bug_folder()` that:
      - Takes parameters: feature_directory, bug_id, short_title
      - Creates main bug folder: `$feature/bugs/BUG-00X-[short-title]/`
      - Creates all subfolders in one operation: `mkdir -p $bug_folder/{screenshots,logs,videos,artifacts}`
      - Validates write permissions to feature directory before creation
      - Validates feature directory exists and is readable
      - Returns success/failure with meaningful error messages
      - Handles race conditions: validate ID is still unique after folder creation begins

    - Implement function `validate_feature_directory()` that:
      - Checks if directory exists
      - Checks read/write permissions
      - Verifies `.../features/[feature-name]` pattern in path
      - Returns feature name if valid, error message if not

  - [x] 3.2 Implement bug-report.md template generation
    - Create file: `/scripts/bug-report-generator.sh`
    - Implement function `generate_bug_report()` that:
      - Takes parameters: bug_id, feature_name, ticket_id (optional), environment (optional)
      - Sources bug-report.md template from `/profiles/default/templates/bug-report.md`
      - Pre-populates: ID, Feature, Date Created (ISO format: YYYY-MM-DD HH:MM:SS), Date Updated, Version (1.0)
      - Pre-populates: Ticket field if provided
      - Leaves user-populated fields empty with helpful placeholder comments
      - Generates Attachments section with empty table structure
      - Generates Revision Log with initial entry
      - Writes completed template to `$bug_folder/bug-report.md`
      - Returns path to generated file

  - [x] 3.3 Test folder creation logic
    - Create test script: `/scripts/test-folder-creation.sh`
    - Create temporary test feature directory with proper structure
    - Test scenarios:
      - Create first bug in feature (BUG-001)
      - Create second bug in same feature (BUG-002)
      - All subfolders created correctly
      - bug-report.md generated with correct content
      - Metadata fields pre-populated accurately
      - Handle missing bugs directory (create automatically)
      - Handle permission errors gracefully
    - Clean up test artifacts
    - Document all test results

**Acceptance Criteria:**
- bug-folder-utils.sh and bug-report-generator.sh created
- create_bug_folder() creates complete folder hierarchy
- generate_bug_report() produces valid bug-report.md with all required sections
- All subfolders (screenshots/, logs/, videos/, artifacts/) created automatically
- Metadata fields (ID, Feature, Date Created, Version) pre-populated correctly
- Error handling provides clear guidance for permission issues
- Test suite validates all scenarios pass

---

### Task Group 4: Context Detection Implementation
**Dependencies:** Task Group 1, Task Group 2, Task Group 3
**Duration:** 1 day

This task group implements the feature and bug context detection logic for commands.

- [x] 4.0 Complete context detection implementation
  - [x] 4.1 Create feature context detection function
    - Create file: `/scripts/context-detection.sh`
    - Implement function `detect_feature_context()` that:
      - Reads current working directory with `pwd`
      - Parses path to find `/qa-agent-os/features/[feature-name]/` pattern
      - Extracts feature name from path components
      - Validates feature directory exists and is readable
      - Supports detection from multiple paths:
        - `/qa-agent-os/features/[feature]/` (feature root)
        - `/qa-agent-os/features/[feature]/bugs/` (bugs directory)
        - `/qa-agent-os/features/[feature]/bugs/BUG-00X/` (specific bug)
      - Returns extracted feature name if successful
      - Returns error code and helpful message if detection fails
      - Suggests correct directory: "Please run from: qa-agent-os/features/[feature-name]/"

    - Implement function `validate_feature_exists()` that:
      - Checks if feature directory exists in file system
      - Checks if required subdirectories exist (documentation, tickets, etc.)
      - Returns success/failure with feature details

  - [x] 4.2 Create bug context detection function
    - Implement function `detect_bug_context()` that:
      - Takes optional bug_id parameter or reads from path
      - Parses current directory for BUG-00X pattern
      - Extracts bug ID from folder name
      - Detects parent feature by scanning up directory tree
      - Validates bug folder exists with required bug-report.md
      - Returns tuple: (feature_name, bug_id, bug_path)
      - Returns error message if bug context not found
      - Supports multiple invocation patterns:
        - Run from bug folder (auto-detect)
        - Run from feature/bugs folder with `--bug BUG-002`
        - Run from anywhere with full path

  - [x] 4.3 Test context detection logic
    - Create test script: `/scripts/test-context-detection.sh`
    - Create test directory structure with multiple features and bugs
    - Test scenarios:
      - Detect feature from feature root directory
      - Detect feature from bugs subdirectory
      - Detect feature from within bug folder
      - Detect bug from bug folder
      - Detect bug with explicit parameter
      - Error when feature not found
      - Error when bug not found
      - Validation of feature existence
    - Clean up test artifacts
    - Document all results

**Acceptance Criteria:**
- context-detection.sh created with feature and bug detection functions
- detect_feature_context() works from multiple directory levels
- detect_bug_context() correctly extracts bug IDs from folder names
- Helpful error messages suggest correct directory paths
- All path parsing handles both absolute and relative paths
- Validation confirms feature and bug existence
- Test suite validates all scenarios pass

---

### Task Group 5: /report-bug Command Update
**Dependencies:** Task Groups 1-4
**Duration:** 1.5 days

This task group updates the /report-bug command to create feature-level bugs with auto-increment logic and organized supporting materials.

- [ ] 5.0 Complete /report-bug command implementation
  - [ ] 5.1 Update Phase 0: Feature context detection and validation
    - File to update: `/profiles/default/commands/report-bug/single-agent/0-detect-context.md`
    - Replace ticket-level detection with feature-level detection
    - Steps:
      1. Call `detect_feature_context()` from context-detection.sh
      2. If detection fails, provide error message and suggestion
      3. Allow manual feature selection with `--feature` parameter override
      4. Validate feature exists and contains required structure
      5. Store feature_name for use in later phases
    - Output: Feature name confirmed, ready to proceed with bug details

  - [ ] 5.2 Update Phase 1: Auto-increment bug ID and title collection
    - File to update: `/profiles/default/commands/report-bug/single-agent/1-collect-details.md`
    - Insert new substep before existing details collection:
      1. Call `find_next_bug_id()` to determine next sequential ID
      2. Display detected ID: "Creating bug: BUG-003"
      3. Ask user for bug title/short description
      4. Validate title is 20-40 characters recommended
      5. Call `sanitize_bug_title()` to produce folder-safe name
      6. Display proposed folder name: "Folder will be: BUG-003-checkout-timeout"
      7. Allow user to adjust title if needed
    - Store bug_id and sanitized_title for folder creation
    - Continue with existing details collection (description, steps, environment, ticket ID, etc.)
    - Update to accept new field: Ticket (referenced ticket ID this bug affects)

  - [ ] 5.3 Update Phase 2: Supporting materials organization
    - File to update: `/profiles/default/commands/report-bug/single-agent/2-collect-evidence.md`
    - Update evidence collection to organize materials by type
    - Steps:
      1. Ask user for evidence type: [1] Screenshot [2] Log [3] Video [4] Artifact [5] Done
      2. For each evidence item:
         - Ask for file path
         - Determine subfolder based on file type or user selection
         - Validate file exists and is readable
         - Copy file to appropriate subfolder (screenshots/, logs/, videos/, artifacts/)
         - Ask for description/caption
         - Record in Attachments list with format: `- [subfolder]/[filename] - [description]`
      3. Continue until user selects "Done"
    - Update Attachments tracking to include subfolder organization
    - Generate Attachments section in bug-report.md with organized file list

  - [ ] 5.4 Update Phase 3: AI severity classification (no changes to core logic)
    - File: `/profiles/default/commands/report-bug/single-agent/3-classify-severity.md`
    - Minimal updates needed - existing severity classification logic works at feature level
    - Ensure severity classification uses bug description, evidence, and impact
    - Reference severity rules from bug-reporting.md standard

  - [ ] 5.5 Update Phase 4: Bug folder creation and report generation
    - File to update: `/profiles/default/commands/report-bug/single-agent/4-generate-report.md`
    - Replace ticket-level folder creation with feature-level
    - Steps:
      1. Create bug folder using `create_bug_folder(feature_name, bug_id, sanitized_title)`
      2. Generate bug-report.md using `generate_bug_report()` with collected details
      3. Write all collected information to bug-report.md:
         - Metadata: ID, Feature, Ticket, Created, Updated, Version, Status (Open)
         - Bug Details: Title, Description, Environment
         - Reproduction: Steps to Reproduce, Expected Behavior, Actual Behavior
         - Classification: Severity, Justification
         - Evidence: Attachments organized by subfolder
         - Analysis: Root Cause Hypothesis (if captured), Related Tickets
         - Status Workflow: Initial status (Open), empty status history
         - Revision Log: Initial entry with creation details
      4. Display success message: "Bug created: BUG-003-checkout-payment-timeout/"
      5. Provide next steps: "Next: Add more evidence with /revise-bug, update status as investigation progresses"

  - [ ] 5.6 Update command orchestrator with new path
    - File to update: `/profiles/default/commands/report-bug/single-agent/report-bug.md`
    - Update "Output Structure" section from ticket-level to feature-level:
      - Old: `qa-agent-os/features/[feature-name]/[ticket-id]/bugs/BUG-XXX.md`
      - New: `qa-agent-os/features/[feature-name]/bugs/BUG-XXX-[short-title]/bug-report.md`
    - Update "Bug Report Contents" to reference new schema with Ticket and Jira_ID fields
    - Update workflow examples to reflect feature-level structure

**Acceptance Criteria:**
- /report-bug command detects feature context correctly
- Auto-increment logic generates correct sequential IDs
- Bug folders created with all subfolders (screenshots/, logs/, videos/, artifacts/)
- Supporting materials organized into correct subfolders
- bug-report.md generated with all required fields pre-populated
- Ticket field included for tracking ticket relationships
- Error messages guide users to correct directories
- Metadata includes ID, Feature, Ticket, Created, Updated, Version, Status
- Revision log initialized with creation entry
- Success messaging provides clear feedback and next steps

---

### Task Group 6: /revise-bug Command Update
**Dependencies:** Task Groups 1-5
**Duration:** 1.5 days

This task group updates the /revise-bug command to work with feature-level bugs and support organized supporting materials.

- [ ] 6.0 Complete /revise-bug command implementation
  - [ ] 6.1 Create bug discovery and selection logic
    - Create file: `/scripts/bug-discovery.sh`
    - Implement function `discover_bugs()` that:
      - Takes feature directory as parameter
      - Scans `$feature/bugs/BUG-*` folders
      - Extracts bug IDs and titles from folder names
      - Reads bug-report.md title field for display
      - Returns list of (bug_id, title, path) tuples

    - Implement function `select_bug_interactive()` that:
      - Displays list of available bugs with numbered menu
      - Shows: [1] BUG-001 - Checkout validation error [Status: Open]
      - Accepts user numeric selection
      - Returns selected bug_id and path

  - [ ] 6.2 Update Phase 0: Bug context detection with discovery
    - File to update: `/profiles/default/commands/revise-bug/single-agent/0-detect-bug.md`
    - Or create new phase if doesn't exist
    - Steps:
      1. If bug_id provided as parameter, use it directly
      2. Else, call `detect_bug_context()` from context-detection.sh
      3. If detection fails, call `detect_feature_context()`
      4. Call `discover_bugs()` to list available bugs
      5. If single bug exists, auto-select it
      6. If multiple bugs exist, show interactive menu with `select_bug_interactive()`
      7. Load bug-report.md and display summary:
         - Title, Status, Severity, Date Updated, Ticket(s), Jira_ID
    - Store bug_id, bug_path, feature_name for later phases
    - Output: Bug summary displayed, ready for revision selection

  - [ ] 6.3 Update Phase 1: Revision type selection
    - File: `/profiles/default/commands/revise-bug/single-agent/1-select-revision-type.md`
    - (Likely already exists - minimal updates needed)
    - Update revision type menu to include:
      - [1] Add Evidence (new materials to subfolders)
      - [2] Update Status (Open → In Progress → Approved → Resolved → Closed)
      - [3] Update Severity (re-classify severity)
      - [4] Add Investigation Notes (root cause, fix strategy)
      - [5] Update Description (reproduction steps, environment)
      - [6] Update Ticket References (add/update related tickets)
      - [7] Add Jira ID (when bug approved and exported to Jira)
    - Output: User selects revision type

  - [ ] 6.4 Implement revision handlers
    - Create file: `/scripts/bug-revisions.sh`
    - Implement function `handle_add_evidence()` that:
      - Asks for evidence type: [1] Screenshot [2] Log [3] Video [4] Artifact
      - Prompts for file path
      - Validates file exists and is readable
      - Copies file to correct subfolder (screenshots/, logs/, videos/, artifacts/)
      - Asks for description
      - Returns attachment entry for log

    - Implement function `handle_status_update()` that:
      - Shows current status and valid transitions
      - Prompts for new status
      - Validates status is in allowed set: Open, In Progress, Approved, Resolved, Closed
      - Returns status change for log

    - Implement function `handle_severity_update()` that:
      - Shows current severity (S1-S4)
      - Asks for new severity with justification
      - Validates severity level
      - Returns severity change for log

    - Implement function `handle_add_notes()` that:
      - Prompts for notes text
      - Indicates section: root cause analysis, fix strategy, investigation progress
      - Returns notes for log

  - [ ] 6.5 Update Phase 2: Apply revision to bug-report.md
    - Create file: `/profiles/default/commands/revise-bug/single-agent/2-apply-revision.md`
    - Steps based on revision type:
      - For Add Evidence: append attachment to Attachments section
      - For Status Update: update Status field, add to Status History table
      - For Severity Update: update Severity field
      - For Add Notes: append to appropriate Analysis section
      - For Update Ticket: update Ticket field (comma-separated if multiple)
      - For Add Jira ID: update Jira_ID field with provided ID
    - After any revision:
      1. Update Date Updated field to current timestamp
      2. Determine version increment:
         - Major increment (1.0 → 2.0) for: Approved, Resolved, Closed status changes
         - Minor increment (1.0 → 1.1) for: evidence additions, notes, description, severity updates
      3. Add revision log entry with format:
         ```
         | YYYY-MM-DD HH:MM:SS | X.Y | [revision type] | [specific change] |
         ```
      4. Write updated bug-report.md back to file
    - Output: Revision applied successfully

  - [ ] 6.6 Update command orchestrator
    - File to update: `/profiles/default/commands/revise-bug/single-agent/revise-bug.md`
    - Update description to reference feature-level bug structure
    - Update usage examples to show feature-level commands
    - Update output structure to reference feature-level paths

**Acceptance Criteria:**
- /revise-bug command discovers bugs at feature level
- Bug selection menu displays available bugs with current status
- All revision types supported: evidence, status, severity, notes, ticket, Jira ID
- Supporting materials organized into correct subfolders
- bug-report.md updated with all changes
- Version incremented correctly (major for status, minor for other updates)
- Revision log maintained with timestamp, version, change type, details
- Date Updated field updated with each revision
- Status workflow enforced: Open → In Progress → Approved → Resolved → Closed
- Error messages guide users through revision process
- Timestamps in ISO format (YYYY-MM-DD HH:MM:SS)

---

### Task Group 7: Integration with Existing Workflow
**Dependencies:** Task Groups 1-6
**Duration:** 1 day

This task group integrates the new feature-level bug structure with existing QA Agent OS commands and workflows.

- [ ] 7.0 Complete integration with QA Agent OS
  - [ ] 7.1 Update /plan-ticket command references
    - File: `/profiles/default/commands/start-ticket/` or equivalent
    - Update any ticket-specific documentation that mentions bug creation
    - Add note: "Bugs are now tracked at feature level. Run `/report-bug` from feature directory."
    - Ensure ticket test planning doesn't duplicate bug tracking

  - [ ] 7.2 Create integration guide document
    - File: `/agent-os/specs/2025-12-08-bug-folder-structure/integration-guide.md`
    - Explain how feature-level bugs integrate with existing workflow:
      - `/plan-ticket` command for ticket-specific test planning
      - `/report-bug` command for feature-level bug tracking
      - How bugs and tests interact
    - Show example workflow:
      1. Run /plan-ticket for specific ticket testing
      2. Discover bug during testing
      3. Run /report-bug from feature directory (auto-detects context)
      4. Bug created at feature level with Ticket field referencing the ticket
      5. Bug visible to all ticket testing for the feature
    - Document cross-references between bug-report.md and test-plan.md

  - [ ] 7.3 Verify standards alignment
    - Confirm feature-level bug structure aligns with:
      - `/profiles/default/standards/global/bugs.md` (bug lifecycle)
      - `/profiles/default/standards/bugs/bug-reporting.md` (schema and severity)
    - Update standards if needed to explicitly reference feature-level organization
    - Ensure status workflow (Open → In Progress → Approved → Resolved → Closed) matches global conventions

  - [ ] 7.4 Update configuration if needed
    - Check `/config.yml` for any bug-related settings
    - Ensure no hard-coded paths reference ticket-level bugs
    - Confirm command output paths configured correctly

**Acceptance Criteria:**
- /report-bug and /revise-bug commands integrated with existing workflow
- Cross-references between bugs and tickets documented
- Standards alignment verified
- Integration guide created for QA engineers
- No conflicts with existing commands
- Configuration files updated if needed

---

### Task Group 8: End-to-End Testing and Validation
**Dependencies:** Task Groups 1-7
**Duration:** 1.5 days

This task group performs comprehensive testing of the new bug folder structure and commands.

- [ ] 8.0 Complete end-to-end testing
  - [ ] 8.1 Create comprehensive test plan
    - Document file: `/agent-os/specs/2025-12-08-bug-folder-structure/test-plan.md`
    - Define test scenarios:
      - Scenario 1: Create first bug in feature (auto-increment to BUG-001)
      - Scenario 2: Create multiple bugs with proper ID sequencing
      - Scenario 3: Add multiple evidence types to single bug
      - Scenario 4: Update bug status through workflow
      - Scenario 5: Update severity with justification
      - Scenario 6: Add Jira ID when bug approved
      - Scenario 7: Context detection from various directories
      - Scenario 8: Folder structure validation (all subfolders created)
      - Scenario 9: Attachment organization by type
      - Scenario 10: Revision log tracking
      - Scenario 11: Version numbering (major vs minor increments)
      - Scenario 12: Error cases (feature not found, invalid inputs)
    - Define expected outcomes for each scenario
    - List success criteria

  - [ ] 8.2 Execute manual test scenarios
    - Create test feature directory: `/tmp/test-features/bug-test-feature/`
    - Setup directory structure to match real feature pattern
    - Test Scenario 1: Create first bug
      - Navigate to test feature directory
      - Run `/report-bug --title "Test Bug One"`
      - Verify: BUG-001 folder created
      - Verify: bug-report.md generated with correct metadata
      - Verify: All subfolders created (screenshots/, logs/, videos/, artifacts/)
    - Test Scenario 2: Create second bug
      - Run `/report-bug --title "Test Bug Two"`
      - Verify: BUG-002 folder created (not BUG-001 again)
      - Verify: ID auto-incremented correctly
    - Test Scenario 3: Add evidence types
      - Create test files: screenshot.png, error.log, replay.mp4, trace.har
      - Run `/revise-bug BUG-001` → "Add Evidence"
      - For each file type, verify copied to correct subfolder
      - Verify bug-report.md Attachments updated
    - Test Scenario 4: Status workflow
      - Run `/revise-bug BUG-001` → "Update Status" → "In Progress"
      - Verify Status field updated
      - Verify Status History table updated
      - Verify Date Updated field updated
      - Update to "Approved"
      - Verify version incremented to 2.0 (major change)
    - Test Scenario 5: Severity update
      - Run `/revise-bug BUG-001` → "Update Severity" → "S1"
      - Verify Severity field updated
      - Verify version incremented to 1.1 (minor change)
    - Test Scenario 6: Jira ID
      - Run `/revise-bug BUG-001` → "Add Jira ID" → "JIRA-12345"
      - Verify Jira_ID field populated
      - Verify folder name still BUG-001 (stable)
    - Test Scenario 7: Context detection
      - Navigate to test feature root
      - Run `/report-bug`, verify feature auto-detected
      - Navigate to bugs directory
      - Run `/revise-bug`, verify feature auto-detected
      - Navigate to specific bug folder
      - Run `/revise-bug`, verify bug auto-detected
    - Test Scenario 8: Folder structure validation
      - Verify all bug folders contain:
        - bug-report.md (file exists)
        - screenshots/ (directory exists)
        - logs/ (directory exists)
        - videos/ (directory exists)
        - artifacts/ (directory exists)
    - Test Scenario 9: Attachment organization
      - Verify files copied to correct subfolders
      - Verify relative paths in bug-report.md (screenshots/name.png, etc.)
    - Test Scenario 10: Revision log
      - Verify revision log populated with entries
      - Verify entries include: timestamp, version, change type, details
    - Test Scenario 11: Version numbering
      - Verify initial version: 1.0
      - After evidence addition: 1.1
      - After status change to Approved: 2.0
      - After note addition: 2.1
    - Test Scenario 12: Error handling
      - Run `/report-bug` from wrong directory
      - Verify error message: "Could not detect feature context. Please run from: qa-agent-os/features/[feature-name]/"
      - Run `/revise-bug` with non-existent bug ID
      - Verify error message guides to available bugs
    - Document results for each scenario

  - [ ] 8.3 Validate file organization
    - Create test bug with multiple evidence types
    - Verify folder structure:
      ```
      BUG-001-test-bug/
      ├── bug-report.md
      ├── screenshots/
      │   ├── error-state.png
      │   └── validation-message.png
      ├── logs/
      │   ├── browser-console.log
      │   └── server-error.txt
      ├── videos/
      │   └── repro-steps.mp4
      └── artifacts/
          ├── network-trace.har
          └── request-payload.json
      ```
    - Verify bug-report.md contains:
      - Metadata with ID, Feature, Date Created, Date Updated, Version, Status
      - Attachments section listing all files with subfolder paths
      - Revision log with all changes tracked

  - [ ] 8.4 Test cross-feature bug independence
    - Create two test features with bugs
    - Verify:
      - Feature 1 has BUG-001, BUG-002
      - Feature 2 has BUG-001, BUG-002 (independent numbering)
      - Bug IDs scoped per feature correctly
      - No cross-feature ID conflicts

  - [ ] 8.5 Validate ticket field functionality
    - Create bug with Ticket: TICKET-123
    - Update bug to reference multiple tickets: TICKET-123, TICKET-124
    - Verify Ticket field correctly displays references
    - Verify bidirectional traceability concept works

  - [ ] 8.6 Create test report document
    - File: `/agent-os/specs/2025-12-08-bug-folder-structure/test-results.md`
    - Document all test scenarios executed
    - Record pass/fail for each scenario
    - Note any issues discovered and resolutions
    - Include example folder structure screenshot
    - Include example bug-report.md content
    - List all edge cases validated

**Acceptance Criteria:**
- All 12 test scenarios executed and documented
- Auto-increment logic verified across multiple bugs
- Supporting materials correctly organized by subfolder
- Revision log properly maintained with versions
- Status workflow enforced
- Ticket field functional for cross-references
- Context detection works from multiple directories
- Error handling provides helpful guidance
- Folder structure matches specification
- bug-report.md schema correct and complete
- Test report documents all results

---

### Task Group 9: Documentation Updates
**Dependencies:** Task Groups 1-8
**Duration:** 0.5 days

This task group updates project documentation to reflect the new feature-level bug organization.

- [ ] 9.0 Complete documentation updates
  - [ ] 9.1 Update CHANGELOG.md
    - File: `/CHANGELOG.md` at repo root
    - Add entry under new version (e.g., v1.3.0) describing:
      - Feature-level bug organization
      - Auto-incremented bug IDs per feature
      - Organized supporting materials (screenshots/, logs/, videos/, artifacts/)
      - Updated /report-bug command with feature context auto-detection
      - Updated /revise-bug command with feature-level support
      - Stable BUG-XXX folder names with Jira_ID metadata field
      - Breaking change: Bug path now feature-level instead of ticket-level

  - [ ] 9.2 Update README.md
    - File: `/README.md` at repo root
    - Add or update "Bug Management" section:
      - Brief explanation of feature-level bug organization
      - Link to bug-folder-structure-guide.md
      - Quick command reference: `/report-bug`, `/revise-bug`
      - Example folder structure
      - Note about forward-looking approach (no migration of existing bugs)

  - [ ] 9.3 Update QA-QUICKSTART.md
    - File: `/QA-QUICKSTART.md` at repo root
    - Add section "Bug Reporting Workflow":
      - Step 1: Navigate to feature directory
      - Step 2: Run `/report-bug` to create new bug
      - Step 3: Add evidence and details
      - Step 4: Run `/revise-bug` to update bug status
      - Include example command usage
      - Include example output and folder structure
      - Link to more detailed documentation

  - [ ] 9.4 Update CLAUDE.md
    - File: `/CLAUDE.md` at repo root
    - Add to "QA Workflow Patterns" section:
      - Explanation of feature-level bugs alongside test-plan.md and test-cases.md
      - How bugs relate to testing workflow
      - Bug ID scoping (per-feature)
      - Cross-reference capability (Ticket field)
    - Update any code examples referencing bug paths
    - Add note about /report-bug and /revise-bug commands

  - [ ] 9.5 Create user guide for bug folder structure
    - File: `/agent-os/specifications/bug-folder-structure-user-guide.md`
    - Comprehensive guide for QA engineers:
      - Feature-level organization explanation
      - Folder structure and naming conventions
      - Bug ID format and auto-increment behavior
      - How to create a new bug with /report-bug
      - How to update existing bugs with /revise-bug
      - Supporting materials organization
      - Ticket field usage for cross-references
      - Status workflow and status transitions
      - Jira integration (manual field update)
      - Example workflow: create → investigate → approve → export
      - Troubleshooting common issues

**Acceptance Criteria:**
- CHANGELOG.md updated with new feature description
- README.md includes bug management section
- QA-QUICKSTART.md includes bug reporting workflow
- CLAUDE.md updated with bug patterns and examples
- User guide created for bug folder structure
- All documentation links updated to reference new structure
- Examples reflect feature-level organization
- Documentation is clear and accessible to QA engineers

---

### Task Group 10: Code Cleanup and Finalization
**Dependencies:** Task Groups 1-9
**Duration:** 0.5 days

This task group performs final cleanup, consolidation, and preparation for release.

- [ ] 10.0 Complete code cleanup and finalization
  - [ ] 10.1 Review and consolidate bash utilities
    - Review all created bash scripts:
      - `/scripts/bug-id-utils.sh`
      - `/scripts/bug-folder-utils.sh`
      - `/scripts/bug-report-generator.sh`
      - `/scripts/context-detection.sh`
      - `/scripts/bug-discovery.sh`
      - `/scripts/bug-revisions.sh`
    - Consider consolidation opportunities:
      - Combine related utilities into single files if appropriate
      - Ensure consistent naming conventions
      - Avoid duplication of common functions
    - Add comprehensive comments and function documentation
    - Verify all error handling is consistent
    - Ensure all return codes are meaningful

  - [ ] 10.2 Verify command phase files completeness
    - Review all updated phase files:
      - `/profiles/default/commands/report-bug/single-agent/0-detect-context.md`
      - `/profiles/default/commands/report-bug/single-agent/1-collect-details.md`
      - `/profiles/default/commands/report-bug/single-agent/2-collect-evidence.md`
      - `/profiles/default/commands/report-bug/single-agent/3-classify-severity.md`
      - `/profiles/default/commands/report-bug/single-agent/4-generate-report.md`
      - `/profiles/default/commands/revise-bug/single-agent/0-detect-bug.md` (or create)
      - `/profiles/default/commands/revise-bug/single-agent/1-select-revision-type.md`
      - `/profiles/default/commands/revise-bug/single-agent/2-apply-revision.md`
    - Verify all phase tags are correct
    - Ensure step-by-step instructions are clear
    - Check all file references are accurate
    - Verify all command outputs are helpful

  - [ ] 10.3 Test command compilation
    - Run `project-install.sh` to compile commands
    - Verify commands are correctly deployed to `.claude/commands/qa-agent-os/`
    - Check that phase tags are properly resolved
    - Ensure all referenced files are accessible

  - [ ] 10.4 Create implementation checklist
    - File: `/agent-os/specs/2025-12-08-bug-folder-structure/implementation-checklist.md`
    - List all deliverables:
      - Standards updates (bug-reporting.md)
      - Templates (bug-report.md, bug-folder-structure-guide.md)
      - Bash utilities and functions
      - Command phase files
      - Documentation updates
      - Test results
    - Verification steps for each deliverable
    - Sign-off criteria

  - [ ] 10.5 Review backward compatibility
    - Verify no breaking changes to existing standards
    - Confirm existing bug standards still work (ticket-level bugs remain)
    - Ensure new feature-level bugs don't interfere with existing workflows
    - Document forward-looking approach in migration notes

**Acceptance Criteria:**
- All bash utilities consolidated and documented
- Command phase files complete and verified
- Commands compile without errors
- All phase tags resolved correctly
- Implementation checklist created
- Backward compatibility maintained
- Code ready for production use

---

## Execution Order and Dependencies

The task groups should be executed in the following order to respect dependencies:

1. **Task Group 1** (Standards and Templates) - No dependencies - COMPLETE
2. **Task Group 2** (Auto-Increment Logic) - Depends on Task Group 1 - COMPLETE
3. **Task Group 3** (Folder Structure) - Depends on Task Groups 1-2 - COMPLETE
4. **Task Group 4** (Context Detection) - Depends on Task Groups 1-3 - COMPLETE
5. **Task Group 5** (/report-bug Command) - Depends on Task Groups 1-4 - IN PROGRESS
6. **Task Group 6** (/revise-bug Command) - Depends on Task Groups 1-5 - PENDING
7. **Task Group 7** (Integration) - Depends on Task Groups 1-6 - PENDING
8. **Task Group 8** (End-to-End Testing) - Depends on Task Groups 1-7 - PENDING
9. **Task Group 9** (Documentation) - Depends on Task Groups 1-8 - PENDING
10. **Task Group 10** (Code Cleanup) - Depends on Task Groups 1-9 - PENDING

---

## Success Metrics

Upon completion of all task groups, the implementation should achieve:

- Feature-level bug organization at `/qa-agent-os/features/[feature-name]/bugs/BUG-00X-[title]/`
- Auto-incremented bug IDs per feature (BUG-001, BUG-002, etc.)
- Organized supporting materials in semantic subfolders (screenshots/, logs/, videos/, artifacts/)
- bug-report.md schema with all required fields including Ticket and Jira_ID
- `/report-bug` command creates feature-level bugs with auto-detected context
- `/revise-bug` command updates feature-level bugs with full revision tracking
- Revision log maintained with version numbering and change tracking
- All comprehensive end-to-end testing scenarios pass
- Documentation updated across README, CHANGELOG, QA-QUICKSTART, CLAUDE.md
- Forward-looking implementation (no migration of existing ticket-level bugs)
- Commands integrated seamlessly with existing QA Agent OS workflow

---

## Risk Mitigation

**Risks Identified:**

1. **Auto-increment collisions**: Mitigated by validation function checking ID uniqueness before folder creation
2. **Path detection failures**: Mitigated by comprehensive error messages and manual override options
3. **File organization confusion**: Mitigated by semantic subfolder names and template guidance
4. **Integration conflicts**: Mitigated by integration testing and verification of backward compatibility
5. **Documentation gaps**: Mitigated by user guide and multiple documentation updates

---

*Specification tasks in progress. Work proceeding systematically through all 10 task groups.*
