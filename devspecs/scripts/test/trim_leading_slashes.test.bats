#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

@test "trim_leading_slashes removes single leading slash" {
    run trim_leading_slashes "/path"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path" ]
}

@test "trim_leading_slashes removes multiple leading slashes" {
    run trim_leading_slashes "///path"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path" ]
}

@test "trim_leading_slashes preserves path without leading slashes" {
    run trim_leading_slashes "path"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path" ]
}

@test "trim_leading_slashes handles empty string" {
    run trim_leading_slashes ""
    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "trim_leading_slashes handles root path" {
    run trim_leading_slashes "/"
    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "trim_leading_slashes handles multiple root slashes" {
    run trim_leading_slashes "///"
    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "trim_leading_slashes handles complex path with leading slashes" {
    run trim_leading_slashes "/usr/local/bin"
    [ "${status}" -eq 0 ]
    [ "${output}" = "usr/local/bin" ]
}

@test "trim_leading_slashes handles complex path without leading slashes" {
    run trim_leading_slashes "usr/local/bin"
    [ "${status}" -eq 0 ]
    [ "${output}" = "usr/local/bin" ]
}

@test "trim_leading_slashes handles relative path with leading slashes" {
    run trim_leading_slashes "/./some/path"
    [ "${status}" -eq 0 ]
    [ "${output}" = "./some/path" ]
}

@test "trim_leading_slashes handles path with only slashes in middle" {
    run trim_leading_slashes "path/to/file"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path/to/file" ]
}

@test "trim_leading_slashes handles single dot with leading slash" {
    run trim_leading_slashes "/."
    [ "${status}" -eq 0 ]
    [ "${output}" = "." ]
}

@test "trim_leading_slashes handles double dot with leading slash" {
    run trim_leading_slashes "/.."
    [ "${status}" -eq 0 ]
    [ "${output}" = ".." ]
}

@test "trim_leading_slashes handles path with both leading and trailing slashes" {
    run trim_leading_slashes "/path/to/file/"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path/to/file/" ]
}

@test "trim_leading_slashes handles multiple leading slashes with complex path" {
    run trim_leading_slashes "////home/user/documents"
    [ "${status}" -eq 0 ]
    [ "${output}" = "home/user/documents" ]
}

@test "trim_leading_slashes handles path starting with multiple slashes and dots" {
    run trim_leading_slashes "///../relative/path"
    [ "${status}" -eq 0 ]
    [ "${output}" = "../relative/path" ]
}