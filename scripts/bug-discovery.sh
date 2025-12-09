#!/bin/bash

##############################################################################
# Bug Discovery and Selection Functions
#
# Provides functions for discovering and selecting bugs within a feature.
#
# Usage:
#   source /path/to/bug-discovery.sh
#   discover_bugs "/path/to/feature"
#   select_bug_interactive "/path/to/feature"
##############################################################################

##############################################################################
# Function: discover_bugs
#
# Scans a feature directory for existing bugs and returns their information.
#
# Arguments:
#   $1 = Feature directory path (required)
#
# Returns:
#   0 (success) - Prints bug information (BUG_ID|TITLE|PATH, one per line)
#   1 (error) - No bugs found or invalid directory
##############################################################################
discover_bugs() {
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

  if [[ ! -d "$bugs_dir" ]]; then
    echo "ERROR: No bugs directory found in feature" >&2
    return 1
  fi

  # Find all bug folders
  local bug_count=0
  while IFS= read -r -d '' bug_folder; do
    if [[ -d "$bug_folder" ]]; then
      local folder_name=$(basename "$bug_folder")

      # Extract bug ID
      if [[ $folder_name =~ ^(BUG-[0-9]+) ]]; then
        local bug_id="${BASH_REMATCH[1]}"

        # Extract title (everything after the hyphen following the bug ID)
        local bug_title="${folder_name#*-}"

        # Try to read title from bug-report.md if it exists
        local report_file="${bug_folder}/bug-report.md"
        if [[ -f "$report_file" ]]; then
          # Extract title from the markdown (look for "### Title" section or title line)
          local report_title=$(grep -A1 "^### Title$" "$report_file" 2>/dev/null | tail -1)
          if [[ -n "$report_title" ]] && [[ "$report_title" != "" ]]; then
            bug_title="$report_title"
          fi
        fi

        echo "${bug_id}|${bug_title}|${bug_folder}"
        ((bug_count++))
      fi
    fi
  done < <(find "$bugs_dir" -maxdepth 1 -type d -name "BUG-*" -print0 2>/dev/null)

  if (( bug_count == 0 )); then
    return 1
  fi

  return 0
}

##############################################################################
# Function: select_bug_interactive
#
# Displays an interactive menu for bug selection.
#
# Arguments:
#   $1 = Feature directory path (required)
#
# Returns:
#   0 (success) - Outputs "BUG_ID|PATH" to stdout
#   1 (error) - User cancelled or no bugs available
##############################################################################
select_bug_interactive() {
  local feature_dir="$1"

  if [[ -z "$feature_dir" ]] || [[ ! -d "$feature_dir" ]]; then
    echo "ERROR: Invalid feature directory: $feature_dir" >&2
    return 1
  fi

  # Discover bugs in feature
  local bugs_list
  if ! bugs_list=$(discover_bugs "$feature_dir"); then
    echo "ERROR: No bugs found in feature" >&2
    return 1
  fi

  # Convert to array
  local bugs=()
  while IFS= read -r line; do
    bugs+=("$line")
  done <<< "$bugs_list"

  # If only one bug, auto-select
  if (( ${#bugs[@]} == 1 )); then
    local bug_entry="${bugs[0]}"
    local bug_id="${bug_entry%%|*}"
    local bug_path="${bug_entry##*|}"
    echo "${bug_id}|${bug_path}"
    return 0
  fi

  # Display menu
  echo ""
  echo "Select a bug to revise:"
  echo ""
  for i in "${!bugs[@]}"; do
    local bug_entry="${bugs[$i]}"
    local bug_id="${bug_entry%%|*}"
    local bug_title="${bug_entry#*|}"
    bug_title="${bug_title%%|*}"

    # Try to get status from bug-report.md
    local bug_path="${bug_entry##*|}"
    local status="Unknown"
    if [[ -f "${bug_path}/bug-report.md" ]]; then
      status=$(grep "^| Status" "${bug_path}/bug-report.md" 2>/dev/null | tail -1 | awk -F'|' '{print $NF}' | xargs)
      [[ -z "$status" ]] && status="Open"
    fi

    printf "  [%d] %s - %s [Status: %s]\n" "$((i + 1))" "$bug_id" "$bug_title" "$status"
  done
  echo "  [0] Cancel"
  echo ""
  read -p "Enter selection [0-${#bugs[@]}]: " selection

  if [[ "$selection" == "0" ]]; then
    return 1
  fi

  # Validate selection
  if ! [[ "$selection" =~ ^[0-9]+$ ]] || (( selection < 1 || selection > ${#bugs[@]} )); then
    echo "ERROR: Invalid selection" >&2
    return 1
  fi

  local selected_bug="${bugs[$((selection - 1))]}"
  local bug_id="${selected_bug%%|*}"
  local bug_path="${selected_bug##*|}"
  echo "${bug_id}|${bug_path}"
  return 0
}

##############################################################################
# Export functions for use in other scripts
##############################################################################
export -f discover_bugs
export -f select_bug_interactive
