#!/bin/bash

##############################################################################
# Context Detection Functions
#
# Provides feature and bug context detection from working directory paths.
#
# Usage:
#   source /path/to/context-detection.sh
#   detect_feature_context
#   detect_bug_context
##############################################################################

##############################################################################
# Function: detect_feature_context
#
# Detects if the current working directory is within a feature folder.
#
# Returns:
#   0 (success) - Feature found, outputs feature name to stdout
#   1 (error) - Feature context not found
##############################################################################
detect_feature_context() {
  local current_dir="$PWD"

  # Walk up directory tree looking for features/[feature-name] pattern
  while [[ "$current_dir" != "/" ]]; do
    local parent=$(dirname "$current_dir")
    local current_name=$(basename "$current_dir")
    local parent_name=$(basename "$parent")

    # Check if parent is "features" directory
    if [[ "$parent_name" == "features" ]] && [[ "$current_name" != "features" ]]; then
      # Found a feature directory
      echo "$current_name"
      return 0
    fi

    # Check if current is "bugs" and parent contains "features" path
    if [[ "$current_name" == "bugs" ]]; then
      local feature_parent=$(dirname "$parent")
      local feature_name=$(basename "$parent")
      if [[ "$(dirname "$feature_parent")" != "/" ]] && [[ -d "$parent" ]]; then
        # Validate it's actually in features directory
        local check_parent=$(dirname "$feature_parent")
        if [[ -d "$check_parent/features/$feature_name" ]]; then
          echo "$feature_name"
          return 0
        fi
      fi
    fi

    # Check if we're in a BUG-* folder within features
    if [[ "$current_name" =~ ^BUG-[0-9]+ ]]; then
      local bug_parent=$(dirname "$current_dir")
      local bug_grandparent=$(dirname "$bug_parent")
      local feature_name=$(basename "$bug_grandparent")
      if [[ "$(basename "$bug_parent")" == "bugs" ]]; then
        echo "$feature_name"
        return 0
      fi
    fi

    current_dir="$parent"
  done

  return 1
}

##############################################################################
# Function: detect_bug_context
#
# Detects if the current working directory is within a bug folder.
#
# Returns:
#   0 (success) - Bug found, outputs "FEATURE_NAME BUG_ID BUG_PATH"
#   1 (error) - Bug context not found
##############################################################################
detect_bug_context() {
  local current_dir="$PWD"

  # Walk up directory tree looking for BUG-* pattern
  while [[ "$current_dir" != "/" ]]; do
    local current_name=$(basename "$current_dir")

    # Check if we're in or above a BUG-* folder
    if [[ "$current_name" =~ ^BUG-[0-9]+ ]]; then
      # Extract bug ID
      if [[ $current_name =~ ^(BUG-[0-9]+) ]]; then
        local bug_id="${BASH_REMATCH[1]}"
        local bug_path="$current_dir"

        # Find feature name by walking up to features directory
        local search_dir=$(dirname "$bug_path")
        while [[ "$search_dir" != "/" ]]; do
          local search_name=$(basename "$search_dir")
          local search_parent=$(dirname "$search_dir")
          local search_parent_name=$(basename "$search_parent")

          if [[ "$search_parent_name" == "features" ]]; then
            echo "$search_name $bug_id $bug_path"
            return 0
          fi

          search_dir="$search_parent"
        done
      fi
    fi

    current_dir=$(dirname "$current_dir")
  done

  return 1
}

##############################################################################
# Function: prompt_feature_selection
#
# Displays interactive menu for feature selection.
#
# Returns:
#   0 (success) - Feature selected, outputs feature name to stdout
#   1 (error) - No features or user cancelled
##############################################################################
prompt_feature_selection() {
  # Try to find features directory
  local features_base="qa-agent-os/features"
  if [[ ! -d "$features_base" ]]; then
    # Try relative path up from current location
    features_base=$(find . -maxdepth 5 -type d -name "features" 2>/dev/null | head -1)
    if [[ ! -d "$features_base" ]]; then
      echo "ERROR: No features directory found" >&2
      return 1
    fi
  fi

  # Find all features
  local features=()
  while IFS= read -r -d '' feature_dir; do
    local feature_name=$(basename "$feature_dir")
    features+=("$feature_name")
  done < <(find "$features_base" -maxdepth 1 -type d -name "*" -not -name "features" -print0 2>/dev/null)

  if (( ${#features[@]} == 0 )); then
    echo "ERROR: No features found in $features_base" >&2
    return 1
  fi

  if (( ${#features[@]} == 1 )); then
    # Auto-select single feature
    echo "${features[0]}"
    return 0
  fi

  # Display menu
  echo ""
  echo "Select a feature:"
  for i in "${!features[@]}"; do
    echo "  [$((i + 1))] ${features[$i]}"
  done
  echo "  [0] Cancel"
  echo ""
  read -p "Enter selection [0-${#features[@]}]: " selection

  if [[ "$selection" == "0" ]]; then
    return 1
  fi

  # Validate selection
  if ! [[ "$selection" =~ ^[0-9]+$ ]] || (( selection < 1 || selection > ${#features[@]} )); then
    echo "ERROR: Invalid selection" >&2
    return 1
  fi

  echo "${features[$((selection - 1))]}"
  return 0
}

##############################################################################
# Function: prompt_bug_selection
#
# Displays interactive menu for bug selection within a feature.
#
# Arguments:
#   $1 = Feature directory path (required)
#
# Returns:
#   0 (success) - Bug selected, outputs "BUG_ID BUG_PATH"
#   1 (error) - No bugs or user cancelled
##############################################################################
prompt_bug_selection() {
  local feature_dir="$1"

  if [[ -z "$feature_dir" ]] || [[ ! -d "$feature_dir" ]]; then
    echo "ERROR: Invalid feature directory: $feature_dir" >&2
    return 1
  fi

  local bugs_dir="${feature_dir}/bugs"

  if [[ ! -d "$bugs_dir" ]]; then
    echo "ERROR: No bugs directory in feature: $feature_dir" >&2
    return 1
  fi

  # Find all bugs
  local bugs=()
  while IFS= read -r -d '' bug_dir; do
    local bug_name=$(basename "$bug_dir")
    if [[ $bug_name =~ ^(BUG-[0-9]+) ]]; then
      bugs+=("$bug_name")
    fi
  done < <(find "$bugs_dir" -maxdepth 1 -type d -name "BUG-*" -print0 2>/dev/null)

  if (( ${#bugs[@]} == 0 )); then
    echo "ERROR: No bugs found in feature" >&2
    return 1
  fi

  if (( ${#bugs[@]} == 1 )); then
    # Auto-select single bug
    local bug_id="${bugs[0]%-*}"
    echo "$bug_id ${bugs_dir}/${bugs[0]}"
    return 0
  fi

  # Display menu
  echo ""
  echo "Select a bug:"
  for i in "${!bugs[@]}"; do
    echo "  [$((i + 1))] ${bugs[$i]}"
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
  local bug_id="${selected_bug%-*}"
  echo "$bug_id ${bugs_dir}/${selected_bug}"
  return 0
}

##############################################################################
# Export functions for use in other scripts
##############################################################################
export -f detect_feature_context
export -f detect_bug_context
export -f prompt_feature_selection
export -f prompt_bug_selection
