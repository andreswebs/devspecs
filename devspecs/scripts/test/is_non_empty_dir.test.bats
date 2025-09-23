#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

setup_file() {
    export EMPTY_DIR="${BATS_FILE_TMPDIR}/empty"
    export NON_EMPTY_DIR="${BATS_FILE_TMPDIR}/non_empty"
    export NON_EXISTENT_DIR="${BATS_FILE_TMPDIR}/non_existent"
    export TEST_FILE="${NON_EMPTY_DIR}/test.txt"

    mkdir -p "${EMPTY_DIR}"
    mkdir -p "${NON_EMPTY_DIR}"
    touch "${TEST_FILE}"
}

@test "is_non_empty_dir: returns true for non-empty directory" {
    run is_non_empty_dir "${NON_EMPTY_DIR}"
    [ "${status}" -eq 0 ]
}

@test "is_non_empty_dir: returns false for empty directory" {
    run is_non_empty_dir "${EMPTY_DIR}"
    [ "${status}" -eq 1 ]
}

@test "is_non_empty_dir: returns false for non-existent directory" {
    run is_non_empty_dir "${NON_EXISTENT_DIR}"
    [ "${status}" -eq 1 ]
}

@test "is_non_empty_dir: returns false for file instead of directory" {
    run is_non_empty_dir "${TEST_FILE}"
    [ "${status}" -eq 1 ]
}

@test "is_non_empty_dir: returns false for empty string parameter" {
    run is_non_empty_dir ""
    [ "${status}" -eq 1 ]
}

@test "is_non_empty_dir: returns false when no parameter provided" {
    run is_non_empty_dir
    [ "${status}" -eq 1 ]
}

@test "is_non_empty_dir: returns true for directory with hidden files" {
    local hidden_file_dir="${BATS_TEST_TMPDIR}/hidden_files"
    mkdir -p "${hidden_file_dir}"
    touch "${hidden_file_dir}/.hidden_file"

    run is_non_empty_dir "${hidden_file_dir}"
    [ "${status}" -eq 0 ]
}

@test "is_non_empty_dir: returns true for directory with subdirectories" {
    local subdir_dir="${BATS_TEST_TMPDIR}/with_subdir"
    mkdir -p "${subdir_dir}/subdir"

    run is_non_empty_dir "${subdir_dir}"
    [ "${status}" -eq 0 ]
}

@test "is_non_empty_dir: handles directory names with spaces" {
    local space_dir="${BATS_TEST_TMPDIR}/dir with spaces"
    mkdir -p "${space_dir}"
    touch "${space_dir}/test.txt"

    run is_non_empty_dir "${space_dir}"
    [ "${status}" -eq 0 ]
}

@test "is_non_empty_dir: handles permission denied gracefully" {
    # Skip this test if running as root (can't test permission denied)
    if [ "$(id -u)" -eq 0 ]; then
        skip "Cannot test permission denied as root user"
    fi

    local restricted_dir="${BATS_TEST_TMPDIR}/restricted"
    mkdir -p "${restricted_dir}"
    touch "${restricted_dir}/file.txt"
    chmod 000 "${restricted_dir}"

    run is_non_empty_dir "${restricted_dir}"
    [ "${status}" -eq 1 ]

    # Restore permissions for cleanup
    chmod 755 "${restricted_dir}"
}
