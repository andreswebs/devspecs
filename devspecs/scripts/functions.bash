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

function get_relative_path() {
    local source_dir="${1}"
    local target_dir="${2}"

    if [[ -z "${source_dir}" || -z "${target_dir}" ]]; then
        log "error: both source and target directories must be provided"
        return 1
    fi

    # Convert to absolute paths to handle edge cases
    source_dir=$(realpath "${source_dir}")
    target_dir=$(realpath "${target_dir}")

    # Split paths into arrays
    IFS='/' read -ra source_parts <<< "${source_dir}"
    IFS='/' read -ra target_parts <<< "${target_dir}"

    # Find common prefix length
    local common_length=0
    local min_length=$((${#source_parts[@]} < ${#target_parts[@]} ? ${#source_parts[@]} : ${#target_parts[@]}))

    for ((i=0; i<min_length; i++)); do
        if [[ "${source_parts[i]}" == "${target_parts[i]}" ]]; then
            ((common_length++))
        else
            break
        fi
    done

    # Calculate dots needed (parent directory traversals)
    local dots_needed=$((${#source_parts[@]} - common_length))

    # Build relative path
    local relative_path=""

    # Add dots for going up
    for ((i=0; i<dots_needed; i++)); do
        if [[ -n "${relative_path}" ]]; then
            relative_path="${relative_path}/.."
        else
            relative_path=".."
        fi
    done

    # Add remaining target path parts
    for ((i=common_length; i<${#target_parts[@]}; i++)); do
        if [[ -n "${relative_path}" ]]; then
            relative_path="${relative_path}/${target_parts[i]}"
        else
            relative_path="${target_parts[i]}"
        fi
    done

    # Handle case where directories are the same
    if [[ -z "${relative_path}" ]]; then
        relative_path="."
    fi

    echo "${relative_path}"
}

function create_relative_symlink() {
    local source_path="${1}"
    local target_path="${2}"

    if [[ -z "${source_path}" || -z "${target_path}" ]]; then
        log "error: both source and target paths must be provided"
        return 1
    fi

    if ! source_path=$(realpath "${source_path}" 2>/dev/null); then
        log "error: source path '${1}' does not exist or is not accessible"
        return 1
    fi

    if [[ ! -e "${source_path}" ]]; then
        log "error: source path '${source_path}' does not exist"
        return 1
    fi

    local target_dir
    local target_filename
    target_dir=$(dirname "${target_path}")
    target_filename=$(basename "${target_path}")

    if ! mkdir -p "${target_dir}"; then
        log "error: failed to create target directory '${target_dir}'"
        return 1
    fi

    target_dir=$(realpath "${target_dir}")
    target_path="${target_dir}/${target_filename}"

    if [[ -e "${target_path}" && ! -L "${target_path}" ]]; then
        if [[ -f "${target_path}" ]]; then
            log "error: target path '${target_path}' exists as a regular file"
            return 1
        else
            log "error: target path '${target_path}' already exists and is not a symlink"
            return 1
        fi
    fi

    local relative_path
    relative_path=$(get_relative_path "${target_dir}" "${source_path}")

    (
        if ! pushd "${target_dir}" > /dev/null; then
            log "error: failed to access target directory '${target_dir}'"
            return 1
        fi

        if ! ln -s -f "${relative_path}" "${target_filename}"; then
            log "error: failed to create symlink"
            return 1
        fi

        popd > /dev/null || return 1
    )
}

function validate_spec_name() {
    local name="${1}"
    if ! is_valid_spec_name "${name}"; then
        log "error: '${name}' is not a valid spec branch"
        log "Specs should be named like: 001-examplename."
        return 1
    fi
	return 0
}

function get_spec_dir_name() {
    local specs_dir="${DEVSPECS_SPECS_DIR:-.devspecs/specs}"
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

    echo "${base_dir}/${specs_dir}/${spec_name}"
}

function get_spec_info() {
    local repo_root
    local current_branch
    local spec_dir

    repo_root=$(get_repo_root || exit 1)
    current_branch=$(get_current_branch || exit 1)

    validate_spec_name "${current_branch}" || exit 1

    spec_dir=$(get_spec_dir_name "${repo_root}" "${current_branch}")

    local spec_file_base_name="spec.md"
    local plan_file_base_name="plan.md"
    local tasks_file_base_name="tasks.md"
    local research_file_base_name="research.md"
    local data_model_file_base_name="data-model.md"
    local contracts_relative_dir="contracts"

    local spec_file="${spec_dir}/${spec_file_base_name}"
    local plan_file="${spec_dir}/${plan_file_base_name}"
    local tasks_file="${spec_dir}/${tasks_file_base_name}"
    local research_file="${spec_dir}/${research_file_base_name}"
    local data_model_file="${spec_dir}/${data_model_file_base_name}"
    local contracts_dir="${spec_dir}/${contracts_relative_dir}"


    local SPEC_INFO='{
        "repo_root": "'${repo_root}'",
        "current_branch": "'${current_branch}'",
        "spec_dir": "'${spec_dir}'",
        "spec_file": "'${spec_file}'",
        "plan_file": "'${plan_file}'",
        "tasks_file": "'${tasks_file}'",
        "research_file": "'${research_file}'",
        "data_model_file": "'${data_model_file}'",
        "contracts_dir": "'${contracts_dir}'"
    }'

    echo "${SPEC_INFO}" | tr -d '\n' | tr -d ' '
}
