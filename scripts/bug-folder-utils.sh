#!/bin/bash

##############################################################################
# Bug Folder Utilities
#
# Provides functions for creating bug folder structures and templates.
#
# Usage:
#   source /path/to/bug-folder-utils.sh
#   create_bug_folder "/path/to/feature" "BUG-001" "checkout-timeout"
##############################################################################

# Source dependencies
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/bug-id-utils.sh"

##############################################################################
# Function: validate_feature_directory
#
# Validates that a feature directory exists and has proper structure.
#
# Arguments:
#   $1 = Feature directory path (required)
#
# Returns:
#   0 (success) - Directory is valid
#   1 (error) - Directory is invalid
##############################################################################
validate_feature_directory() {
  local feature_dir="$1"

  if [[ -z "$feature_dir" ]]; then
    echo "ERROR: Feature directory path required" >&2
    return 1
  fi

  if [[ ! -d "$feature_dir" ]]; then
    echo "ERROR: Feature directory does not exist: $feature_dir" >&2
    return 1
  fi

  if [[ ! -r "$feature_dir" ]]; then
    echo "ERROR: Feature directory not readable: $feature_dir" >&2
    return 1
  fi

  if [[ ! -w "$feature_dir" ]]; then
    echo "ERROR: Feature directory not writable: $feature_dir" >&2
    return 1
  fi

  return 0
}

##############################################################################
# Function: create_bug_folder
#
# Creates a bug folder with all required subfolders for evidence organization.
#
# Arguments:
#   $1 = Feature directory path (required)
#   $2 = Bug ID (required, format: BUG-001)
#   $3 = Short title (required, must be sanitized)
#
# Returns:
#   0 (success) - Folder created successfully
#   1 (error) - Creation failed
#
# Environment:
#   Sets: BUG_FOLDER_PATH = path to created bug folder
##############################################################################
create_bug_folder() {
  local feature_dir="$1"
  local bug_id="$2"
  local short_title="$3"

  # Validate inputs
  if [[ -z "$feature_dir" ]] || [[ -z "$bug_id" ]] || [[ -z "$short_title" ]]; then
    echo "ERROR: Feature directory, bug ID, and short title required" >&2
    return 1
  fi

  # Validate feature directory
  if ! validate_feature_directory "$feature_dir"; then
    return 1
  fi

  # Validate bug ID
  if [[ ! $bug_id =~ ^BUG-[0-9]{3}$ ]]; then
    echo "ERROR: Invalid bug ID format: $bug_id" >&2
    return 1
  fi

  # Construct bug folder path
  local bugs_dir="${feature_dir}/bugs"
  local bug_folder_name="${bug_id}-${short_title}"
  BUG_FOLDER_PATH="${bugs_dir}/${bug_folder_name}"

  # Check if folder already exists
  if [[ -d "$BUG_FOLDER_PATH" ]]; then
    echo "ERROR: Bug folder already exists: $BUG_FOLDER_PATH" >&2
    return 1
  fi

  # Create bugs directory if it doesn't exist
  if [[ ! -d "$bugs_dir" ]]; then
    if ! mkdir -p "$bugs_dir" 2>/dev/null; then
      echo "ERROR: Failed to create bugs directory: $bugs_dir" >&2
      return 1
    fi
  fi

  # Create bug folder with all subfolders in one operation
  if ! mkdir -p "$BUG_FOLDER_PATH"/{screenshots,logs,videos,artifacts} 2>/dev/null; then
    echo "ERROR: Failed to create bug folder structure: $BUG_FOLDER_PATH" >&2
    return 1
  fi

  return 0
}

##############################################################################
# Export functions for use in other scripts
##############################################################################
export -f validate_feature_directory
export -f create_bug_folder
export BUG_FOLDER_PATH
