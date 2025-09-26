#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

@test "is_valid_json_string: returns true for valid empty object" {
    run is_valid_json_string '{}'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid empty array" {
    run is_valid_json_string '[]'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid simple object" {
    run is_valid_json_string '{"key": "value"}'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid simple array" {
    run is_valid_json_string '[1, 2, 3]'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid nested object" {
    run is_valid_json_string '{"outer": {"inner": "value"}}'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid string" {
    run is_valid_json_string '"hello world"'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid number" {
    run is_valid_json_string '42'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid boolean true" {
    run is_valid_json_string 'true'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid boolean false" {
    run is_valid_json_string 'false'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid null" {
    run is_valid_json_string 'null'
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns true for valid complex object" {
    local complex_json='{"name": "test", "age": 30, "active": true, "tags": ["dev", "test"], "meta": null}'
    run is_valid_json_string "${complex_json}"
    [ "${status}" -eq 0 ]
}

@test "is_valid_json_string: returns false for invalid json - missing quotes" {
    run is_valid_json_string '{key: value}'
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for invalid json - trailing comma" {
    run is_valid_json_string '{"key": "value",}'
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for invalid json - single quotes" {
    run is_valid_json_string "{'key': 'value'}"
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for invalid json - unbalanced braces" {
    run is_valid_json_string '{"key": "value"'
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for invalid json - unbalanced brackets" {
    run is_valid_json_string '[1, 2, 3'
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for empty string" {
    run is_valid_json_string ''
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for plain text" {
    run is_valid_json_string 'hello world'
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for malformed number" {
    run is_valid_json_string '42.3.1'
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for undefined value" {
    run is_valid_json_string 'undefined'
    [ "${status}" -eq 1 ]
}

@test "is_valid_json_string: returns false for javascript object notation" {
    run is_valid_json_string '{name: "test"}'
    [ "${status}" -eq 1 ]
}