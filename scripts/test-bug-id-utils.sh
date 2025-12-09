#!/bin/bash

##############################################################################
# Test Script: Bug ID Utility Functions
#
# Tests all functions in bug-id-utils.sh with various edge cases
#
# Run from scripts directory:
#   bash test-bug-id-utils.sh
##############################################################################

# Source the utility functions
source "$(dirname "$0")/bug-id-utils.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Create temporary test directory
TEST_DIR=$(mktemp -d)
FEATURE_DIR="${TEST_DIR}/test-feature"
BUGS_DIR="${FEATURE_DIR}/bugs"

echo "=========================================="
echo "Bug ID Utility Functions Test Suite"
echo "=========================================="
echo "Test directory: $TEST_DIR"
echo ""

##############################################################################
# Helper function to run a test
##############################################################################
run_test() {
  local test_name="$1"
  local expected="$2"
  local actual="$3"

  TESTS_RUN=$((TESTS_RUN + 1))

  if [[ "$expected" == "$actual" ]]; then
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo "✓ PASS: $test_name"
    return 0
  else
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo "✗ FAIL: $test_name"
    echo "  Expected: $expected"
    echo "  Got:      $actual"
    return 1
  fi
}

##############################################################################
# Test 1: find_next_bug_id - Empty bugs folder (should return BUG-001)
##############################################################################
echo ""
echo "Test Group 1: find_next_bug_id() Function"
echo "----------------------------------------"

mkdir -p "$FEATURE_DIR"

result=$(find_next_bug_id "$FEATURE_DIR")
run_test "find_next_bug_id: Empty feature returns BUG-001" "BUG-001" "$result"

##############################################################################
# Test 2: find_next_bug_id - Single bug exists (should return BUG-002)
##############################################################################
mkdir -p "${BUGS_DIR}/BUG-001-first-bug"

result=$(find_next_bug_id "$FEATURE_DIR")
run_test "find_next_bug_id: Single bug returns BUG-002" "BUG-002" "$result"

##############################################################################
# Test 3: find_next_bug_id - Multiple bugs (should return BUG-003)
##############################################################################
mkdir -p "${BUGS_DIR}/BUG-002-second-bug"

result=$(find_next_bug_id "$FEATURE_DIR")
run_test "find_next_bug_id: Two bugs return BUG-003" "BUG-003" "$result"

##############################################################################
# Test 4: find_next_bug_id - Non-sequential IDs with gaps (BUG-001, BUG-003 -> BUG-004)
##############################################################################
rm -rf "${BUGS_DIR}/BUG-002-second-bug"
mkdir -p "${BUGS_DIR}/BUG-003-third-bug"

result=$(find_next_bug_id "$FEATURE_DIR")
run_test "find_next_bug_id: Gaps in IDs returns highest+1" "BUG-004" "$result"

##############################################################################
# Test 5: find_next_bug_id - Large ID numbers (BUG-100+ -> BUG-101)
##############################################################################
rm -rf "$BUGS_DIR"
mkdir -p "${BUGS_DIR}/BUG-099-ninety-ninth"
mkdir -p "${BUGS_DIR}/BUG-100-hundredth"

result=$(find_next_bug_id "$FEATURE_DIR")
run_test "find_next_bug_id: Large IDs returns BUG-101" "BUG-101" "$result"

##############################################################################
# Test 6: find_next_bug_id - Invalid feature directory
##############################################################################
result=$(find_next_bug_id "/nonexistent/path" 2>&1)
exit_code=$?
run_test "find_next_bug_id: Invalid path returns error" "1" "$exit_code"

##############################################################################
# Test 7: validate_bug_id_unique - New ID is unique
##############################################################################
echo ""
echo "Test Group 2: validate_bug_id_unique() Function"
echo "-----------------------------------------------"

rm -rf "$BUGS_DIR"
mkdir -p "$BUGS_DIR"

validate_bug_id_unique "$FEATURE_DIR" "BUG-001" >/dev/null 2>&1
result=$?
run_test "validate_bug_id_unique: New ID returns success" "0" "$result"

##############################################################################
# Test 8: validate_bug_id_unique - Existing ID is not unique
##############################################################################
mkdir -p "${BUGS_DIR}/BUG-001-test"

validate_bug_id_unique "$FEATURE_DIR" "BUG-001" >/dev/null 2>&1
result=$?
run_test "validate_bug_id_unique: Existing ID returns error" "1" "$result"

##############################################################################
# Test 9: validate_bug_id_unique - Invalid ID format
##############################################################################
validate_bug_id_unique "$FEATURE_DIR" "INVALID-001" >/dev/null 2>&1
result=$?
run_test "validate_bug_id_unique: Invalid format returns error" "1" "$result"

##############################################################################
# Test 10: sanitize_bug_title - Special characters converted to hyphens
##############################################################################
echo ""
echo "Test Group 3: sanitize_bug_title() Function"
echo "-------------------------------------------"

# Note: apostrophes become hyphens, so "User's" becomes "user-s"
result=$(sanitize_bug_title "User's Email @ Domain.com (Issue)")
expected="user-s-email-domain-com-issue"
run_test "sanitize_bug_title: Special characters removed" "$expected" "$result"

##############################################################################
# Test 11: sanitize_bug_title - Uppercase converted to lowercase
##############################################################################
result=$(sanitize_bug_title "Login Form - Validation ERROR")
expected="login-form-validation-error"
run_test "sanitize_bug_title: Uppercase to lowercase" "$expected" "$result"

##############################################################################
# Test 12: sanitize_bug_title - Spaces converted to hyphens
##############################################################################
result=$(sanitize_bug_title "User Login Form With Spaces")
expected="user-login-form-with-spaces"
run_test "sanitize_bug_title: Spaces to hyphens" "$expected" "$result"

##############################################################################
# Test 13: sanitize_bug_title - Leading/trailing hyphens removed
##############################################################################
result=$(sanitize_bug_title "---Bug Title---")
expected="bug-title"
run_test "sanitize_bug_title: Strip leading/trailing hyphens" "$expected" "$result"

##############################################################################
# Test 14: sanitize_bug_title - Consecutive hyphens collapsed
##############################################################################
result=$(sanitize_bug_title "Bug---Title+++Test")
expected="bug-title-test"
run_test "sanitize_bug_title: Collapse consecutive hyphens" "$expected" "$result"

##############################################################################
# Test 15: sanitize_bug_title - Truncate to 40 characters
##############################################################################
long_title="This is a very long bug title that exceeds forty characters and should be truncated"
result=$(sanitize_bug_title "$long_title")
result_len=${#result}
# Should be 40 or less
if (( result_len <= 40 )); then
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo "✓ PASS: sanitize_bug_title: Truncate to 40 chars (length: $result_len)"
  TESTS_RUN=$((TESTS_RUN + 1))
else
  TESTS_FAILED=$((TESTS_FAILED + 1))
  echo "✗ FAIL: sanitize_bug_title: Truncate to 40 chars"
  echo "  Expected length <= 40, got: $result_len"
  TESTS_RUN=$((TESTS_RUN + 1))
fi

##############################################################################
# Test 16: sanitize_bug_title - No trailing hyphen after truncation
##############################################################################
# Create a title that would end with hyphen after truncation
truncate_test="Login form validation error on checkout page with confirmation"
result=$(sanitize_bug_title "$truncate_test")
# Should not end with hyphen
if [[ ! "$result" =~ -$ ]]; then
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo "✓ PASS: sanitize_bug_title: No trailing hyphen"
  TESTS_RUN=$((TESTS_RUN + 1))
else
  TESTS_FAILED=$((TESTS_FAILED + 1))
  echo "✗ FAIL: sanitize_bug_title: Has trailing hyphen"
  echo "  Result: $result"
  TESTS_RUN=$((TESTS_RUN + 1))
fi

##############################################################################
# Test 17: sanitize_bug_title - Punctuation handling
##############################################################################
result=$(sanitize_bug_title "Bug! Issue? Problem...Resolved!")
expected="bug-issue-problem-resolved"
run_test "sanitize_bug_title: Punctuation removed" "$expected" "$result"

##############################################################################
# Integration Test: Complete workflow
##############################################################################
echo ""
echo "Test Group 4: Integration Tests"
echo "-------------------------------"

# Clean up for integration test
rm -rf "$BUGS_DIR"
mkdir -p "$FEATURE_DIR"

# Step 1: Get next ID for empty feature
next_id=$(find_next_bug_id "$FEATURE_DIR")
run_test "Integration: First bug ID is BUG-001" "BUG-001" "$next_id"

# Step 2: Validate ID is unique
validate_bug_id_unique "$FEATURE_DIR" "$next_id" >/dev/null 2>&1
run_test "Integration: New ID passes uniqueness check" "0" "$?"

# Step 3: Sanitize a title
safe_title=$(sanitize_bug_title "Login Form - Validation Error on Checkout!")
expected_title="login-form-validation-error-on-checkout"
run_test "Integration: Title sanitized correctly" "$expected_title" "$safe_title"

# Step 4: Create the folder
mkdir -p "${BUGS_DIR}/${next_id}-${safe_title}"
[[ -d "${BUGS_DIR}/${next_id}-${safe_title}" ]] && integration_result=0 || integration_result=1
run_test "Integration: Folder created successfully" "0" "$integration_result"

# Step 5: Get next ID again (should be BUG-002)
next_id_2=$(find_next_bug_id "$FEATURE_DIR")
run_test "Integration: Second bug ID is BUG-002" "BUG-002" "$next_id_2"

##############################################################################
# Cleanup
##############################################################################
rm -rf "$TEST_DIR"

##############################################################################
# Summary
##############################################################################
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total Tests: $TESTS_RUN"
echo "Passed:      $TESTS_PASSED"
echo "Failed:      $TESTS_FAILED"
echo ""

if (( TESTS_FAILED == 0 )); then
  echo "Result: ALL TESTS PASSED"
  exit 0
else
  echo "Result: SOME TESTS FAILED"
  exit 1
fi
