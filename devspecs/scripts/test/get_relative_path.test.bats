#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

setup() {
    TEST_DIR_A="${BATS_FILE_TMPDIR}/project/src/components"
    TEST_DIR_B="${BATS_FILE_TMPDIR}/project/docs"
    TEST_DIR_C="${BATS_FILE_TMPDIR}/project"
    TEST_DIR_D="${BATS_FILE_TMPDIR}/other"
    TEST_DIR_E="${BATS_FILE_TMPDIR}/project/src/utils"

    mkdir -p "${TEST_DIR_A}"
    mkdir -p "${TEST_DIR_B}"
    mkdir -p "${TEST_DIR_C}"
    mkdir -p "${TEST_DIR_D}"
    mkdir -p "${TEST_DIR_E}"
}

@test "get_relative_path: returns error when source directory is missing" {
    run get_relative_path "" "/some/path"
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error: both source and target directories must be provided" ]]
}

@test "get_relative_path: returns error when target directory is missing" {
    run get_relative_path "/some/path" ""
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error: both source and target directories must be provided" ]]
}

@test "get_relative_path: returns error when both directories are missing" {
    run get_relative_path "" ""
    [ "${status}" -eq 1 ]
    [[ "${output}" =~ "error: both source and target directories must be provided" ]]
}

@test "get_relative_path: returns dot when directories are the same" {
    run get_relative_path "${TEST_DIR_C}" "${TEST_DIR_C}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "." ]
}

@test "get_relative_path: returns double dot-dot for grandparent directory" {
    run get_relative_path "${TEST_DIR_A}" "${TEST_DIR_C}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../.." ]
}

@test "get_relative_path: returns relative path to sibling directory" {
    run get_relative_path "${TEST_DIR_A}" "${TEST_DIR_B}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../../docs" ]
}

@test "get_relative_path: returns relative path between immediate sibling subdirectories" {
    run get_relative_path "${TEST_DIR_A}" "${TEST_DIR_E}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../utils" ]
}

@test "get_relative_path: returns path to child directory" {
    run get_relative_path "${TEST_DIR_C}" "${TEST_DIR_A}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "src/components" ]
}

@test "get_relative_path: returns relative path to completely different directory tree" {
    run get_relative_path "${TEST_DIR_A}" "${TEST_DIR_D}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../../../other" ]
}

@test "get_relative_path: handles paths with trailing slashes" {
    run get_relative_path "${TEST_DIR_A}/" "${TEST_DIR_B}/"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../../docs" ]
}

@test "get_relative_path: handles root to subdirectory" {
    run get_relative_path "/" "${BATS_FILE_TMPDIR}"
    [ "${status}" -eq 0 ]
    [[ "${output}" =~ ^private/var/folders/.* ]] || [[ "${output}" =~ ^tmp/.* ]] || [[ "${output}" =~ ^var/.* ]]
}

@test "get_relative_path: handles subdirectory to root" {
    run get_relative_path "${BATS_FILE_TMPDIR}" "/"
    [ "${status}" -eq 0 ]
    # Count the number of .. segments - should match directory depth
    dots_count=$(echo "${output}" | tr '/' '\n' | grep -c '^\.\.$' || true)
    [ "${dots_count}" -gt 0 ]
}

@test "get_relative_path: works with relative input paths" {
    # Change to test directory and use relative paths
    cd "${BATS_FILE_TMPDIR}" || exit 1
    run get_relative_path "project/src/components" "project/docs"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../../docs" ]
}

@test "get_relative_path: handles symbolic links correctly" {
    # Create a symbolic link
    ln -s "${TEST_DIR_C}" "${BATS_FILE_TMPDIR}/project_link"

    run get_relative_path "${TEST_DIR_A}" "${BATS_FILE_TMPDIR}/project_link"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../.." ]
}

@test "get_relative_path: handles current directory notation" {
    cd "${TEST_DIR_C}" || exit 1
    run get_relative_path "." "docs"
    [ "${status}" -eq 0 ]
    [ "${output}" = "docs" ]
}

@test "get_relative_path: handles parent directory notation" {
    cd "${TEST_DIR_C}" || exit 1
    run get_relative_path ".." "${TEST_DIR_B}"
    [ "${status}" -eq 0 ]
    [[ "${output}" =~ docs$ ]]
}

@test "get_relative_path: complex nested directory structure" {
    # Create deeper structure
    DEEP_DIR="${BATS_FILE_TMPDIR}/project/src/components/ui/buttons/primary"
    mkdir -p "${DEEP_DIR}"

    run get_relative_path "${DEEP_DIR}" "${TEST_DIR_B}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../../../../../docs" ]
}

@test "get_relative_path: handles directories with spaces in names" {
    SPACE_DIR_A="${BATS_FILE_TMPDIR}/project with spaces/src"
    SPACE_DIR_B="${BATS_FILE_TMPDIR}/project with spaces/docs"
    mkdir -p "${SPACE_DIR_A}"
    mkdir -p "${SPACE_DIR_B}"

    run get_relative_path "${SPACE_DIR_A}" "${SPACE_DIR_B}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../docs" ]
}

@test "get_relative_path: handles directories with special characters" {
    SPECIAL_DIR_A="${BATS_FILE_TMPDIR}/project-name_v2/src"
    SPECIAL_DIR_B="${BATS_FILE_TMPDIR}/project-name_v2/docs"
    mkdir -p "${SPECIAL_DIR_A}"
    mkdir -p "${SPECIAL_DIR_B}"

    run get_relative_path "${SPECIAL_DIR_A}" "${SPECIAL_DIR_B}"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../docs" ]
}