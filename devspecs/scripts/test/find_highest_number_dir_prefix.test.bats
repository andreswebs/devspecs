#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

setup() {
    TEST_TEMP_DIR="${BATS_TEST_TMPDIR}/find_highest_test"
    mkdir -p "${TEST_TEMP_DIR}"
}

@test "find_highest_number_dir_prefix: returns error when no parent directory provided" {
    run find_highest_number_dir_prefix
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"error: parent directory must be provided"* ]]
}

@test "find_highest_number_dir_prefix: returns error when empty string provided" {
    run find_highest_number_dir_prefix ""
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"error: parent directory must be provided"* ]]
}

@test "find_highest_number_dir_prefix: returns 0 for non-existent directory" {
    run find_highest_number_dir_prefix "/non/existent/directory"
    [ "${status}" -eq 0 ]
    [ "${output}" = "0" ]
}

@test "find_highest_number_dir_prefix: returns 0 for empty directory" {
    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "0" ]
}

@test "find_highest_number_dir_prefix: returns 0 for directory with no numbered subdirectories" {
    mkdir -p "${TEST_TEMP_DIR}/feature"
    mkdir -p "${TEST_TEMP_DIR}/another-feature"
    mkdir -p "${TEST_TEMP_DIR}/no-numbers"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "0" ]
}

@test "find_highest_number_dir_prefix: returns highest number from single numbered directory" {
    mkdir -p "${TEST_TEMP_DIR}/005-feature"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "5" ]
}

@test "find_highest_number_dir_prefix: returns highest number from multiple numbered directories" {
    mkdir -p "${TEST_TEMP_DIR}/001-first"
    mkdir -p "${TEST_TEMP_DIR}/010-second"
    mkdir -p "${TEST_TEMP_DIR}/005-third"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "10" ]
}

@test "find_highest_number_dir_prefix: handles leading zeros correctly (octal prevention)" {
    mkdir -p "${TEST_TEMP_DIR}/008-feature"
    mkdir -p "${TEST_TEMP_DIR}/009-another"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "9" ]
}

@test "find_highest_number_dir_prefix: ignores files, only processes directories" {
    mkdir -p "${TEST_TEMP_DIR}/001-directory"
    touch "${TEST_TEMP_DIR}/999-file.txt"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "1" ]
}

@test "find_highest_number_dir_prefix: handles mixed numbered and non-numbered directories" {
    mkdir -p "${TEST_TEMP_DIR}/001-first"
    mkdir -p "${TEST_TEMP_DIR}/feature-no-number"
    mkdir -p "${TEST_TEMP_DIR}/020-second"
    mkdir -p "${TEST_TEMP_DIR}/another-feature"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "20" ]
}

@test "find_highest_number_dir_prefix: handles three-digit numbers correctly" {
    mkdir -p "${TEST_TEMP_DIR}/001-first"
    mkdir -p "${TEST_TEMP_DIR}/100-hundred"
    mkdir -p "${TEST_TEMP_DIR}/050-fifty"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "100" ]
}

@test "find_highest_number_dir_prefix: handles large numbers" {
    mkdir -p "${TEST_TEMP_DIR}/001-first"
    mkdir -p "${TEST_TEMP_DIR}/999-last"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "999" ]
}

@test "find_highest_number_dir_prefix: ignores directories with numbers not at start" {
    mkdir -p "${TEST_TEMP_DIR}/001-first"
    mkdir -p "${TEST_TEMP_DIR}/feature-999"
    mkdir -p "${TEST_TEMP_DIR}/some123thing"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "1" ]
}

@test "find_highest_number_dir_prefix: handles directories with only numbers as prefix" {
    mkdir -p "${TEST_TEMP_DIR}/123"
    mkdir -p "${TEST_TEMP_DIR}/456-feature"
    mkdir -p "${TEST_TEMP_DIR}/789anything"

    run find_highest_number_dir_prefix "${TEST_TEMP_DIR}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "789" ]
}