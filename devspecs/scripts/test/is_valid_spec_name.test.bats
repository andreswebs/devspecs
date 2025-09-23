#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

@test "is_valid_spec_name: returns true for valid spec name with numbers only" {
    run is_valid_spec_name "001-123"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with letters only" {
    run is_valid_spec_name "001-feature"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with mixed alphanumeric" {
    run is_valid_spec_name "001-feature123"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with underscores" {
    run is_valid_spec_name "001-feature_name"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with hyphens" {
    run is_valid_spec_name "001-feature-name"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with mixed separators" {
    run is_valid_spec_name "001-feature_name-test"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with uppercase letters" {
    run is_valid_spec_name "001-FeatureName"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with all uppercase" {
    run is_valid_spec_name "001-FEATURE"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns true for valid spec name with mixed case" {
    run is_valid_spec_name "001-MyFeature_Name-Test123"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: returns false for spec name with less than 3 digits" {
    run is_valid_spec_name "01-feature"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with more than 3 digits" {
    run is_valid_spec_name "0001-feature"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name without hyphen" {
    run is_valid_spec_name "001feature"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with letters in number part" {
    run is_valid_spec_name "00a-feature"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name starting with letters" {
    run is_valid_spec_name "abc-feature"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with no name part" {
    run is_valid_spec_name "001-"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with spaces" {
    run is_valid_spec_name "001-feature name"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with special characters" {
    run is_valid_spec_name "001-feature@name"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with dots" {
    run is_valid_spec_name "001-feature.name"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with slashes" {
    run is_valid_spec_name "001-feature/name"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for empty string" {
    run is_valid_spec_name ""
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false when no parameter provided" {
    run is_valid_spec_name
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with leading whitespace" {
    run is_valid_spec_name " 001-feature"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with trailing whitespace" {
    run is_valid_spec_name "001-feature "
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name with multiple hyphens after number" {
    run is_valid_spec_name "001--feature"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name ending with hyphen only" {
    run is_valid_spec_name "001--"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: returns false for spec name ending with underscore only" {
    run is_valid_spec_name "001-_"
    [ "${status}" -eq 1 ]
}

@test "is_valid_spec_name: edge case with minimum valid name" {
    run is_valid_spec_name "000-a"
    [ "${status}" -eq 0 ]
}

@test "is_valid_spec_name: edge case with maximum digits" {
    run is_valid_spec_name "999-feature"
    [ "${status}" -eq 0 ]
}
