#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

setup_file() {
    export READABLE_FILE="${BATS_FILE_TMPDIR}/readable.txt"
    export NON_EXISTENT_FILE="${BATS_FILE_TMPDIR}/non_existent.txt"
    export UNREADABLE_FILE="${BATS_FILE_TMPDIR}/unreadable.txt"
    export TEST_DIR="${BATS_FILE_TMPDIR}/testme"

    touch "${READABLE_FILE}"

    if [ "$(id -u)" -ne 0 ]; then
        touch "${UNREADABLE_FILE}"
        chmod 000 "${UNREADABLE_FILE}"
    fi

    mkdir -p "${TEST_DIR}"
}

teardown_file() {
    # Restore permissions for cleanup
    if [ -f "${UNREADABLE_FILE}" ]; then
        chmod 644 "${UNREADABLE_FILE}" 2>/dev/null || true
    fi
}

@test "is_readable_file: returns true for readable file" {
    run is_readable_file "${READABLE_FILE}"
    [ "${status}" -eq 0 ]
}

@test "is_readable_file: returns false for non-existent file" {
    run is_readable_file "${NON_EXISTENT_FILE}"
    [ "${status}" -eq 1 ]
}

@test "is_readable_file: returns false for unreadable file" {
    # Skip this test if running as root (can't test permission denied)
    if [ "$(id -u)" -eq 0 ]; then
        skip "Cannot test unreadable file as root user"
    fi

    run is_readable_file "${UNREADABLE_FILE}"
    [ "${status}" -eq 1 ]
}

@test "is_readable_file: returns false for directory instead of file" {
    run is_readable_file "${TEST_DIR}"
    [ "${status}" -eq 1 ]
}

@test "is_readable_file: returns false for empty string parameter" {
    run is_readable_file ""
    [ "${status}" -eq 1 ]
}

@test "is_readable_file: returns false when no parameter provided" {
    run is_readable_file
    [ "${status}" -eq 1 ]
}

@test "is_readable_file: handles file names with spaces" {
    local space_file="${BATS_TEST_TMPDIR}/file with spaces.txt"
    touch "${space_file}"

    run is_readable_file "${space_file}"
    [ "${status}" -eq 0 ]
}

@test "is_readable_file: returns true for executable file" {
    local exec_file="${BATS_TEST_TMPDIR}/executable.sh"
    touch "${exec_file}"
    chmod +x "${exec_file}"

    run is_readable_file "${exec_file}"
    [ "${status}" -eq 0 ]
}

@test "is_readable_file: returns true for symlink to readable file" {
    local symlink_file="${BATS_TEST_TMPDIR}/symlink.txt"
    ln -s "${READABLE_FILE}" "${symlink_file}"

    run is_readable_file "${symlink_file}"
    [ "${status}" -eq 0 ]
}

@test "is_readable_file: returns false for broken symlink" {
    local broken_symlink="${BATS_TEST_TMPDIR}/broken_symlink.txt"
    ln -s "${NON_EXISTENT_FILE}" "${broken_symlink}"

    run is_readable_file "${broken_symlink}"
    [ "${status}" -eq 1 ]
}
