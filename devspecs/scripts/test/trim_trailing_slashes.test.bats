#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

@test "trim_trailing_slashes removes single trailing slash" {
    run trim_trailing_slashes "path/"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path" ]
}

@test "trim_trailing_slashes removes multiple trailing slashes" {
    run trim_trailing_slashes "path///"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path" ]
}

@test "trim_trailing_slashes preserves path without trailing slashes" {
    run trim_trailing_slashes "path"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path" ]
}

@test "trim_trailing_slashes handles empty string" {
    run trim_trailing_slashes ""
    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "trim_trailing_slashes handles root path" {
    run trim_trailing_slashes "/"
    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "trim_trailing_slashes handles multiple root slashes" {
    run trim_trailing_slashes "///"
    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "trim_trailing_slashes handles complex path with trailing slashes" {
    run trim_trailing_slashes "/usr/local/bin/"
    [ "${status}" -eq 0 ]
    [ "${output}" = "/usr/local/bin" ]
}

@test "trim_trailing_slashes handles complex path without trailing slashes" {
    run trim_trailing_slashes "/usr/local/bin"
    [ "${status}" -eq 0 ]
    [ "${output}" = "/usr/local/bin" ]
}

@test "trim_trailing_slashes handles relative path with trailing slashes" {
    run trim_trailing_slashes "./some/path/"
    [ "${status}" -eq 0 ]
    [ "${output}" = "./some/path" ]
}

@test "trim_trailing_slashes handles path with only slashes in middle" {
    run trim_trailing_slashes "path/to/file"
    [ "${status}" -eq 0 ]
    [ "${output}" = "path/to/file" ]
}

@test "trim_trailing_slashes handles single dot with trailing slash" {
    run trim_trailing_slashes "./"
    [ "${status}" -eq 0 ]
    [ "${output}" = "." ]
}

@test "trim_trailing_slashes handles double dot with trailing slash" {
    run trim_trailing_slashes "../"
    [ "${status}" -eq 0 ]
    [ "${output}" = ".." ]
}