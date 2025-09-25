#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

@test "generate_next_spec_number generates next number from 0" {
    run generate_next_spec_number 0
    [ "${status}" -eq 0 ]
    [ "${output}" = "001" ]
}

@test "generate_next_spec_number generates next number from 1" {
    run generate_next_spec_number 1
    [ "${status}" -eq 0 ]
    [ "${output}" = "002" ]
}

@test "generate_next_spec_number generates next number from 9" {
    run generate_next_spec_number 9
    [ "${status}" -eq 0 ]
    [ "${output}" = "010" ]
}

@test "generate_next_spec_number generates next number from 99" {
    run generate_next_spec_number 99
    [ "${status}" -eq 0 ]
    [ "${output}" = "100" ]
}

@test "generate_next_spec_number generates next number from 999" {
    run generate_next_spec_number 999
    [ "${status}" -eq 0 ]
    [ "${output}" = "1000" ]
}

@test "generate_next_spec_number handles single digit input" {
    run generate_next_spec_number 5
    [ "${status}" -eq 0 ]
    [ "${output}" = "006" ]
}

@test "generate_next_spec_number handles double digit input" {
    run generate_next_spec_number 42
    [ "${status}" -eq 0 ]
    [ "${output}" = "043" ]
}

@test "generate_next_spec_number handles triple digit input" {
    run generate_next_spec_number 123
    [ "${status}" -eq 0 ]
    [ "${output}" = "124" ]
}

@test "generate_next_spec_number fails with no arguments" {
    run generate_next_spec_number
    [ "${status}" -ne 0 ]
}

@test "generate_next_spec_number fails with non-numeric input" {
    run generate_next_spec_number "abc"
    [ "${status}" -ne 0 ]
}

@test "generate_next_spec_number fails with negative input" {
    run generate_next_spec_number -1
    [ "${status}" -ne 0 ]
}

@test "generate_next_spec_number fails with empty string input" {
    run generate_next_spec_number ""
    [ "${status}" -ne 0 ]
}