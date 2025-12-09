#!/bin/bash

##############################################################################
# Bug ID Utility Functions
#
# Provides reusable bash functions for:
# - Auto-incrementing bug IDs per feature
# - Validating bug ID uniqueness
# - Sanitizing bug titles for folder names
#
# Usage:
#   source /path/to/bug-id-utils.sh
#   next_id=$(find_next_bug_id "/path/to/feature")
#   validate_bug_id_unique "/path/to/feature" "$next_id"
#   safe_title=$(sanitize_bug_title "User Login Form - Validation Error")
##############################################################################

# Enable error handling
set -o pipefail

##############################################################################
# Function: find_next_bug_id
#
# Scans the bugs folder for existing BUG-* folders and determines the next
# sequential bug ID to use.
#
# Arguments:
#   $1 = Feature directory path (required)
#
# Returns:
#   0 (success) - Prints the next bug ID to stdout (e.g., "BUG-001" or "BUG-042")
#   1 (error) - Invalid feature path or read error
#
# Examples:
#   next_id=$(find_next_bug_id "/path/to/feature")
#   echo "Next bug ID is: $next_id"
##############################################################################
find_next_bug_id() {
  local feature_dir="$1"

  # Validate input
  if [[ -z "$feature_dir" ]]; then
    echo "ERROR: Feature directory path required" >&2
    return 1
  fi

  if [[ ! -d "$feature_dir" ]]; then
    echo "ERROR: Feature directory does not exist: $feature_dir" >&2
    return 1
  fi

  local bugs_dir="${feature_dir}/bugs"

  # If bugs directory doesn't exist yet, start with BUG-001
  if [[ ! -d "$bugs_dir" ]]; then
    echo "BUG-001"
    return 0
  fi

  # Find all existing BUG-* folders
  local bug_folders=()
  local max_id=0

  # Scan for BUG-* folders safely
  while IFS= read -r -d '' folder; do
    if [[ -d "$folder" ]]; then
      # Extract folder name
      local folder_name=$(basename "$folder")

      # Extract numeric ID using regex
      if [[ $folder_name =~ ^BUG-([0-9]+) ]]; then
        local id_num="${BASH_REMATCH[1]}"
        # Remove leading zeros for numeric comparison
        id_num=$((10#$id_num))

        if (( id_num > max_id )); then
          max_id=$id_num
        fi
      fi
    fi
  done < <(find "$bugs_dir" -maxdepth 1 -type d -name "BUG-*" -print0 2>/dev/null)

  # Calculate next ID
  local next_id=$((max_id + 1))

  # Format with zero-padding to 3 digits
  printf "BUG-%03d" "$next_id"
  return 0
}

##############################################################################
# Function: validate_bug_id_unique
#
# Verifies that a proposed bug ID doesn't already exist in the feature.
# Used to prevent ID collisions before creating the bug folder.
#
# Arguments:
#   $1 = Feature directory path (required)
#   $2 = Bug ID to validate (required, format: BUG-001)
#
# Returns:
#   0 (success) - ID is unique and available
#   1 (error) - ID already exists or validation error
#
# Examples:
#   if validate_bug_id_unique "/path/to/feature" "BUG-001"; then
#     echo "ID is available"
#   else
#     echo "ID already exists"
#   fi
##############################################################################
validate_bug_id_unique() {
  local feature_dir="$1"
  local bug_id="$2"

  # Validate inputs
  if [[ -z "$feature_dir" ]] || [[ -z "$bug_id" ]]; then
    echo "ERROR: Feature directory and bug ID required" >&2
    return 1
  fi

  if [[ ! -d "$feature_dir" ]]; then
    echo "ERROR: Feature directory does not exist: $feature_dir" >&2
    return 1
  fi

  # Validate bug ID format
  if [[ ! $bug_id =~ ^BUG-[0-9]{3}$ ]]; then
    echo "ERROR: Invalid bug ID format. Expected BUG-XXX: $bug_id" >&2
    return 1
  fi

  local bugs_dir="${feature_dir}/bugs"

  # Check if any folder starting with this ID exists
  if [[ -d "$bugs_dir" ]]; then
    local matching_folders
    matching_folders=$(find "$bugs_dir" -maxdepth 1 -type d -name "${bug_id}-*" 2>/dev/null | wc -l)

    if (( matching_folders > 0 )); then
      echo "ERROR: Bug ID already exists: $bug_id" >&2
      return 1
    fi
  fi

  return 0
}

##############################################################################
# Function: sanitize_bug_title
#
# Converts a bug title to a URL-friendly folder name component.
# Converts to lowercase, removes special characters, uses hyphens as separators,
# and truncates to reasonable length.
#
# Arguments:
#   $1 = Bug title to sanitize (required)
#
# Returns:
#   0 (success) - Prints sanitized title to stdout
#   1 (error) - Invalid input
#
# Examples:
#   safe_title=$(sanitize_bug_title "Login Form - Validation Error!")
#   echo "$safe_title"  # Output: login-form-validation-error
#
#   safe_title=$(sanitize_bug_title "User's Email @ Domain.com (Issue)")
#   echo "$safe_title"  # Output: users-email-domain-com-issue
##############################################################################
sanitize_bug_title() {
  local title="$1"

  # Validate input
  if [[ -z "$title" ]]; then
    echo "ERROR: Title required for sanitization" >&2
    return 1
  fi

  # Step 1: Convert to lowercase
  title=$(echo "$title" | tr '[:upper:]' '[:lower:]')

  # Step 2: Replace all non-alphanumeric and non-hyphen characters with hyphens
  # This includes spaces, underscores, dots, slashes, and other punctuation
  title=$(echo "$title" | tr -cs 'a-z0-9\-' '-')

  # Step 3: Remove consecutive hyphens (replace multiple hyphens with single)
  while [[ "$title" =~ -- ]]; do
    title="${title//--/-}"
  done

  # Step 4: Remove leading/trailing hyphens
  title="${title#-}"
  title="${title%-}"

  # Step 5: Truncate to 40 characters (reasonable folder name length)
  # If truncating causes a trailing hyphen, remove it
  if (( ${#title} > 40 )); then
    title="${title:0:40}"
    title="${title%-}"
  fi

  # Validate that result is not empty
  if [[ -z "$title" ]]; then
    echo "ERROR: Title sanitization resulted in empty string" >&2
    return 1
  fi

  echo "$title"
  return 0
}

##############################################################################
# Export functions for use in other scripts
##############################################################################
export -f find_next_bug_id
export -f validate_bug_id_unique
export -f sanitize_bug_title
