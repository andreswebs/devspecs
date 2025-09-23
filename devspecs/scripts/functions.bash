#!/usr/bin/env bash

function log() {
    echo "${*}" >&2
}

function is_cmd_available() {
    local cmd="${1}"
    command -v "${cmd}" &> /dev/null
}

function is_non_empty_dir() {
    [ -d "${1}" ] && [ -r "${1}" ] && [ -n "$(ls -A "${1}" 2>/dev/null)" ]
}

function is_readable_file() {
    [ -f "${1}" ] && [ -r "${1}" ]
}

function get_repo_root() {
    git rev-parse --show-toplevel
}

function get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

function is_valid_spec_name() {
    local name="${1}"
    [[ "${name}" =~ ^[0-9]{3}-[a-zA-Z0-9]+([_-][a-zA-Z0-9]+)*$ ]]
}

function check_feature_branch() {
    local branch="${1}"
    if ! is_valid_spec_name "${branch}"; then
        log "error: Not on a feature branch. Current branch: $branch"
        log "Feature branches should be named like: 001-examplename"
        return 1
    fi
	return 0
}

function get_spec_dir_name() {
    local specs_dir="${SPECS_DIR:-specs}"
    # Remove all leading slashes
    while [[ "${specs_dir}" == /* ]]; do
        specs_dir="${specs_dir#/}"
    done
    # Remove all trailing slashes
    while [[ "${specs_dir}" == */ ]]; do
        specs_dir="${specs_dir%/}"
    done

    local base_dir="${1}"
    local spec_name="${2}"

    if ! is_valid_spec_name "${spec_name}"; then
        log "error: '${spec_name}' is not a valid spec name"
        return 1
    fi

    echo "${base_dir}/${specs_dir}/${spec_name}"
}

function get_feature_dir() {
    local base_dir="${1}"
    local branch_name="${2}"

    if ! check_feature_branch "${branch_name}"; then
        return 1
    fi

    get_spec_dir_name "${base_dir}" "${branch_name}"
}

function get_feature_paths() {
    local repo_root
    local current_branch
    local feature_dir

    repo_root=$(get_repo_root)
    current_branch=$(get_current_branch)
    feature_dir=$(get_feature_dir "${repo_root}" "${current_branch}")

    cat <<EOF
REPO_ROOT='${repo_root}'
CURRENT_BRANCH='${current_branch}'
FEATURE_DIR='${feature_dir}'
FEATURE_SPEC='${feature_dir}/spec.md'
IMPL_PLAN='${feature_dir}/plan.md'
TASKS='${feature_dir}/tasks.md'
RESEARCH='${feature_dir}/research.md'
DATA_MODEL='${feature_dir}/data-model.md'
QUICKSTART='${feature_dir}/quickstart.md'
CONTRACTS_DIR='${feature_dir}/contracts'
EOF
}
