#!/bin/bash

##############################################################################
# Bug Report Generator
#
# Generates bug-report.md files from the template with pre-populated metadata.
#
# Usage:
#   source /path/to/bug-report-generator.sh
#   generate_bug_report "/path/to/bug/folder" "BUG-001" "Payment Gateway"
##############################################################################

##############################################################################
# Function: get_iso_timestamp
#
# Returns current timestamp in ISO 8601 format (YYYY-MM-DD HH:MM:SS)
#
# Returns:
#   0 (success) - Prints timestamp to stdout
##############################################################################
get_iso_timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

##############################################################################
# Function: generate_bug_report
#
# Creates a bug-report.md file from the template with pre-populated fields.
#
# Arguments:
#   $1 = Bug folder path (required)
#   $2 = Bug ID (required, format: BUG-001)
#   $3 = Feature name (required)
#   $4 = Ticket ID (optional)
#
# Returns:
#   0 (success) - File created successfully
#   1 (error) - File creation failed
#
# Environment:
#   Sets: BUG_REPORT_PATH = path to generated bug-report.md
##############################################################################
generate_bug_report() {
  local bug_folder="$1"
  local bug_id="$2"
  local feature_name="$3"
  local ticket_id="${4:-}"

  # Validate inputs
  if [[ -z "$bug_folder" ]] || [[ -z "$bug_id" ]] || [[ -z "$feature_name" ]]; then
    echo "ERROR: Bug folder, bug ID, and feature name required" >&2
    return 1
  fi

  # Validate bug folder exists
  if [[ ! -d "$bug_folder" ]]; then
    echo "ERROR: Bug folder does not exist: $bug_folder" >&2
    return 1
  fi

  BUG_REPORT_PATH="${bug_folder}/bug-report.md"

  # Check if report already exists
  if [[ -f "$BUG_REPORT_PATH" ]]; then
    echo "ERROR: Bug report already exists: $BUG_REPORT_PATH" >&2
    return 1
  fi

  # Get timestamps
  local timestamp=$(get_iso_timestamp)

  # Determine template path
  local templates_dir=""
  if [[ -f "profiles/default/templates/bug-report.md" ]]; then
    templates_dir="profiles/default/templates"
  elif [[ -f "${BASH_SOURCE%/*}/../profiles/default/templates/bug-report.md" ]]; then
    templates_dir="${BASH_SOURCE%/*}/../profiles/default/templates"
  elif [[ -f "/opt/qa-agent-os/profiles/default/templates/bug-report.md" ]]; then
    templates_dir="/opt/qa-agent-os/profiles/default/templates"
  elif [[ -f "$HOME/qa-agent-os/profiles/default/templates/bug-report.md" ]]; then
    templates_dir="$HOME/qa-agent-os/profiles/default/templates"
  else
    # Try to find it in common locations
    local found=0
    for location in \
      "qa-agent-os/templates/bug-report.md" \
      ".claude/templates/bug-report.md"; do
      if [[ -f "$location" ]]; then
        templates_dir=$(dirname "$location")
        found=1
        break
      fi
    done
    if (( !found )); then
      echo "ERROR: Bug report template not found" >&2
      return 1
    fi
  fi

  # Read template
  local template_file="${templates_dir}/bug-report.md"
  if [[ ! -f "$template_file" ]]; then
    echo "ERROR: Template file not found: $template_file" >&2
    return 1
  fi

  # Generate the report by substituting placeholders
  if ! sed \
    -e "s|{{BUG_ID}}|$bug_id|g" \
    -e "s|{{FEATURE_NAME}}|$feature_name|g" \
    -e "s|{{DATE_CREATED}}|$timestamp|g" \
    -e "s|{{DATE_UPDATED}}|$timestamp|g" \
    -e "s|{{VERSION}}|1.0|g" \
    -e "s|{{STATUS}}|Open|g" \
    "$template_file" > "$BUG_REPORT_PATH" 2>/dev/null; then
    echo "ERROR: Failed to generate bug report" >&2
    rm -f "$BUG_REPORT_PATH"
    return 1
  fi

  return 0
}

##############################################################################
# Export functions for use in other scripts
##############################################################################
export -f get_iso_timestamp
export -f generate_bug_report
export BUG_REPORT_PATH
