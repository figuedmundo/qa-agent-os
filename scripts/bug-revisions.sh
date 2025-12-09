#!/bin/bash

##############################################################################
# Bug Revision Handler Functions
#
# Provides functions for handling different types of bug revisions:
# evidence addition, status updates, severity changes, notes, etc.
#
# Usage:
#   source /path/to/bug-revisions.sh
#   handle_add_evidence "/path/to/bug"
#   handle_status_update "/path/to/bug-report.md"
##############################################################################

##############################################################################
# Function: handle_add_evidence
#
# Guides user through adding new evidence to a bug folder.
#
# Arguments:
#   $1 = Bug folder path (required)
#
# Returns:
#   0 (success) - Outputs evidence entry format
#   1 (error) - Invalid folder or user cancelled
##############################################################################
handle_add_evidence() {
  local bug_folder="$1"

  if [[ -z "$bug_folder" ]] || [[ ! -d "$bug_folder" ]]; then
    echo "ERROR: Invalid bug folder: $bug_folder" >&2
    return 1
  fi

  # Display evidence type menu
  echo ""
  echo "Select evidence type:"
  echo "  [1] Screenshot (PNG, JPG, GIF)"
  echo "  [2] Log (TXT, LOG)"
  echo "  [3] Video (MP4, MOV, WebM)"
  echo "  [4] Artifact (HAR, JSON, SQL, CSV)"
  echo "  [5] Cancel"
  echo ""
  read -p "Enter selection [1-5]: " evidence_type

  case "$evidence_type" in
    1)
      local subfolder="screenshots"
      ;;
    2)
      local subfolder="logs"
      ;;
    3)
      local subfolder="videos"
      ;;
    4)
      local subfolder="artifacts"
      ;;
    5)
      return 1
      ;;
    *)
      echo "ERROR: Invalid selection" >&2
      return 1
      ;;
  esac

  # Prompt for file path
  read -p "Enter file path: " file_path

  # Validate file exists
  if [[ ! -f "$file_path" ]]; then
    echo "ERROR: File not found: $file_path" >&2
    return 1
  fi

  # Copy file to subfolder
  local filename=$(basename "$file_path")
  local dest_path="${bug_folder}/${subfolder}/${filename}"

  if ! cp "$file_path" "$dest_path" 2>/dev/null; then
    echo "ERROR: Failed to copy file to ${subfolder}/" >&2
    return 1
  fi

  # Prompt for description
  read -p "Enter description (optional): " description

  # Output evidence entry in format: SUBFOLDER|FILENAME|DESCRIPTION
  echo "${subfolder}|${filename}|${description}"
  return 0
}

##############################################################################
# Function: handle_status_update
#
# Guides user through updating bug status.
#
# Arguments:
#   $1 = Bug report path (bug-report.md) (required)
#   $2 = Current status (optional)
#
# Returns:
#   0 (success) - Outputs "OLD_STATUS|NEW_STATUS"
#   1 (error) - User cancelled or invalid input
##############################################################################
handle_status_update() {
  local bug_report="$1"
  local current_status="${2:-Open}"

  if [[ -z "$bug_report" ]] || [[ ! -f "$bug_report" ]]; then
    echo "ERROR: Invalid bug report: $bug_report" >&2
    return 1
  fi

  # Display status options
  echo ""
  echo "Current Status: $current_status"
  echo ""
  echo "Valid Status Transitions:"
  echo "  [1] Open"
  echo "  [2] In Progress"
  echo "  [3] Approved"
  echo "  [4] Resolved"
  echo "  [5] Closed"
  echo "  [0] Cancel"
  echo ""
  read -p "Select new status [0-5]: " status_choice

  local new_status=""
  case "$status_choice" in
    1) new_status="Open" ;;
    2) new_status="In Progress" ;;
    3) new_status="Approved" ;;
    4) new_status="Resolved" ;;
    5) new_status="Closed" ;;
    0) return 1 ;;
    *) echo "ERROR: Invalid selection" >&2; return 1 ;;
  esac

  # Output status change
  echo "${current_status}|${new_status}"
  return 0
}

##############################################################################
# Function: handle_severity_update
#
# Guides user through updating bug severity.
#
# Arguments:
#   $1 = Current severity (optional)
#
# Returns:
#   0 (success) - Outputs "OLD_SEVERITY|NEW_SEVERITY|JUSTIFICATION"
#   1 (error) - User cancelled or invalid input
##############################################################################
handle_severity_update() {
  local current_severity="${1:-S3}"

  # Display severity options
  echo ""
  echo "Current Severity: $current_severity"
  echo ""
  echo "Select new severity:"
  echo "  [1] S1 - Critical (Data loss, security, crash, payment broken, no workaround)"
  echo "  [2] S2 - Major (Feature broken, wrong data, difficult workaround)"
  echo "  [3] S3 - Minor (UI issues, incorrect labels, easy workaround)"
  echo "  [4] S4 - Trivial (Cosmetic, typos, minimal impact)"
  echo "  [0] Cancel"
  echo ""
  read -p "Select severity [0-4]: " severity_choice

  local new_severity=""
  case "$severity_choice" in
    1) new_severity="S1" ;;
    2) new_severity="S2" ;;
    3) new_severity="S3" ;;
    4) new_severity="S4" ;;
    0) return 1 ;;
    *) echo "ERROR: Invalid selection" >&2; return 1 ;;
  esac

  # Prompt for justification
  read -p "Enter justification for severity change: " justification

  # Output severity change
  echo "${current_severity}|${new_severity}|${justification}"
  return 0
}

##############################################################################
# Function: handle_add_notes
#
# Guides user through adding investigation notes to a bug.
#
# Arguments:
#   None
#
# Returns:
#   0 (success) - Outputs note entry
#   1 (error) - User cancelled
##############################################################################
handle_add_notes() {
  echo ""
  echo "Add Investigation Notes"
  echo "========================"
  echo ""
  echo "Note Types:"
  echo "  [1] Root Cause Analysis"
  echo "  [2] Fix Strategy"
  echo "  [3] Investigation Progress"
  echo "  [4] General Notes"
  echo "  [0] Cancel"
  echo ""
  read -p "Select note type [0-4]: " note_type

  local note_section=""
  case "$note_type" in
    1) note_section="Root Cause Hypothesis" ;;
    2) note_section="Fix Strategy" ;;
    3) note_section="Investigation Progress" ;;
    4) note_section="General Notes" ;;
    0) return 1 ;;
    *) echo "ERROR: Invalid selection" >&2; return 1 ;;
  esac

  # Prompt for note content
  echo ""
  echo "Enter your notes (press Ctrl+D when done):"
  local note_content
  note_content=$(cat)

  # Output note entry
  echo "${note_section}|${note_content}"
  return 0
}

##############################################################################
# Function: increment_version
#
# Increments version number based on change type.
#
# Arguments:
#   $1 = Current version (e.g., 1.0, 1.5)
#   $2 = Change type (major or minor)
#
# Returns:
#   0 (success) - Outputs new version to stdout
##############################################################################
increment_version() {
  local current_version="$1"
  local change_type="${2:-minor}"

  # Parse current version
  local major="${current_version%%.*}"
  local minor="${current_version#*.}"

  if [[ "$change_type" == "major" ]]; then
    # Major increment: increase major version, reset minor to 0
    major=$((major + 1))
    minor=0
  else
    # Minor increment: increase minor version
    minor=$((minor + 1))
  fi

  echo "${major}.${minor}"
  return 0
}

##############################################################################
# Export functions for use in other scripts
##############################################################################
export -f handle_add_evidence
export -f handle_status_update
export -f handle_severity_update
export -f handle_add_notes
export -f increment_version
