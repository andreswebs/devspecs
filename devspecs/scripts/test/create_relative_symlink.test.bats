#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

setup() {
    TEST_PROJECT_DIR="${BATS_FILE_TMPDIR}/project"
    TEST_SRC_DIR="${TEST_PROJECT_DIR}/src"
    TEST_DOCS_DIR="${TEST_PROJECT_DIR}/docs"
    TEST_CONFIG_DIR="${TEST_PROJECT_DIR}/config"
    TEST_UTILS_DIR="${TEST_SRC_DIR}/utils"

    mkdir -p "${TEST_SRC_DIR}"
    mkdir -p "${TEST_DOCS_DIR}"
    mkdir -p "${TEST_CONFIG_DIR}"
    mkdir -p "${TEST_UTILS_DIR}"

    echo "test=1" > "${TEST_CONFIG_DIR}/app.conf"
    echo "// utility functions" > "${TEST_UTILS_DIR}/helpers.js"
    echo "readme content" > "${TEST_PROJECT_DIR}/README.md"
}

@test "create_relative_symlink: returns error when source path is missing" {
    run create_relative_symlink "" "/some/target"
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error:" ]]
}

@test "create_relative_symlink: returns error when target path is missing" {
    run create_relative_symlink "/some/source" ""
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error:" ]]
}

@test "create_relative_symlink: returns error when both paths are missing" {
    run create_relative_symlink "" ""
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error:" ]]
}

@test "create_relative_symlink: returns error when source file does not exist" {
    run create_relative_symlink "${TEST_CONFIG_DIR}/nonexistent.conf" "${TEST_SRC_DIR}/config.conf"
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error:" ]]
}

@test "create_relative_symlink: creates symlink to file in same directory" {
    local source_file="${TEST_CONFIG_DIR}/app.conf"
    local target_link="${TEST_CONFIG_DIR}/app_link.conf"

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "app.conf" ]
}

@test "create_relative_symlink: creates symlink to file in parent directory" {
    local source_file="${TEST_PROJECT_DIR}/README.md"
    local target_link="${TEST_SRC_DIR}/README_link.md"

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "../README.md" ]
}

@test "create_relative_symlink: creates symlink to file in sibling directory" {
    local source_file="${TEST_CONFIG_DIR}/app.conf"
    local target_link="${TEST_DOCS_DIR}/app_link.conf"

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "../config/app.conf" ]
}

@test "create_relative_symlink: creates symlink to file in nested directory" {
    local source_file="${TEST_UTILS_DIR}/helpers.js"
    local target_link="${TEST_PROJECT_DIR}/helpers_link.js"

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "src/utils/helpers.js" ]
}

@test "create_relative_symlink: creates symlink from nested to parent directory" {
    local source_file="${TEST_PROJECT_DIR}/README.md"
    local target_link="${TEST_UTILS_DIR}/README_link.md"

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "../../README.md" ]
}

@test "create_relative_symlink: overwrites existing symlink" {
    local source_file="${TEST_CONFIG_DIR}/app.conf"
    local target_link="${TEST_DOCS_DIR}/app_link.conf"

    TMP_SRC_FILE="${BATS_TEST_TMPDIR}/some_other_file"
    touch "${TMP_SRC_FILE}"
    ln -s -f "${TMP_SRC_FILE}" "${target_link}"
    [ -L "${target_link}" ]

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "../config/app.conf" ]
}

@test "create_relative_symlink: returns error when target exists as regular file" {
    local source_file="${TEST_CONFIG_DIR}/app.conf"
    local target_link="${TEST_DOCS_DIR}/existing_file.txt"

    # Create a regular file at target location
    echo "existing content" > "${target_link}"
    [ -f "${target_link}" ]

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error:" ]]
}

@test "create_relative_symlink: creates parent directories if they don't exist" {
    local source_file="${TEST_CONFIG_DIR}/app.conf"
    local target_link="${TEST_PROJECT_DIR}/deep/nested/path/app_link.conf"

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "../../../config/app.conf" ]
}

@test "create_relative_symlink: works with absolute paths" {
    local source_file
    local target_link
    source_file="$(realpath "${TEST_CONFIG_DIR}/app.conf")"
    target_link="$(realpath "${TEST_DOCS_DIR}")/app_link.conf"

    run create_relative_symlink "${source_file}" "${target_link}"
    [ "${status}" -eq 0 ]
    [ -L "${target_link}" ]
    [ "$(readlink "${target_link}")" = "../config/app.conf" ]
}

@test "create_relative_symlink: works with relative paths" {
    cd "${TEST_PROJECT_DIR}"

    run create_relative_symlink "config/app.conf" "docs/app_link.conf"
    [ "${status}" -eq 0 ]
    [ -L "docs/app_link.conf" ]
    [ "$(readlink "docs/app_link.conf")" = "../config/app.conf" ]
}
