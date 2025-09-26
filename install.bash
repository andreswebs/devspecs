#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Current directory is not a git repository." >&2
    echo "This will only install on an initialized git repository." >&2
    echo "Please run 'git init' and try again." >&2
    exit 1
fi

TMP_WORKDIR="$(mktemp -d)"

function finish {
    rm -rf "${TMP_WORKDIR}"
}

trap finish EXIT

INSTALL_DIR="$(pwd)"

DEVSPECS_SOURCE_RELATIVE_DIR="devspecs"
DEVSPECS_TARGET_RELATIVE_DIR=".devspecs"

DEVSPECS_MEMORY_RELATIVE_DIR="memory"
DEVSPECS_SCRIPTS_RELATIVE_DIR="scripts"
DEVSPECS_TEMPLATES_RELATIVE_DIR="templates"
DEVSPECS_PROMPTS_RELATIVE_DIR="prompts"

DEVSPECS_SOURCE_MEMORY_DIR="${TMP_WORKDIR}/${DEVSPECS_SOURCE_RELATIVE_DIR}/${DEVSPECS_MEMORY_RELATIVE_DIR}"
DEVSPECS_SOURCE_SCRIPTS_DIR="${TMP_WORKDIR}/${DEVSPECS_SOURCE_RELATIVE_DIR}/${DEVSPECS_SCRIPTS_RELATIVE_DIR}"
DEVSPECS_SOURCE_TEMPLATES_DIR="${TMP_WORKDIR}/${DEVSPECS_SOURCE_RELATIVE_DIR}/${DEVSPECS_TEMPLATES_RELATIVE_DIR}"
DEVSPECS_SOURCE_PROMPTS_DIR="${TMP_WORKDIR}/${DEVSPECS_SOURCE_RELATIVE_DIR}/${DEVSPECS_PROMPTS_RELATIVE_DIR}"

DEVSPECS_TARGET_MEMORY_DIR="${INSTALL_DIR}/${DEVSPECS_TARGET_RELATIVE_DIR}/${DEVSPECS_MEMORY_RELATIVE_DIR}"
DEVSPECS_TARGET_SCRIPTS_DIR="${INSTALL_DIR}/${DEVSPECS_TARGET_RELATIVE_DIR}/${DEVSPECS_SCRIPTS_RELATIVE_DIR}"
DEVSPECS_TARGET_TEMPLATES_DIR="${INSTALL_DIR}/${DEVSPECS_TARGET_RELATIVE_DIR}/${DEVSPECS_TEMPLATES_RELATIVE_DIR}"
DEVSPECS_TARGET_PROMPTS_DIR="${INSTALL_DIR}/${DEVSPECS_TARGET_RELATIVE_DIR}/${DEVSPECS_PROMPTS_RELATIVE_DIR}"

mkdir -p "${DEVSPECS_TARGET_MEMORY_DIR}"
mkdir -p "${DEVSPECS_TARGET_SCRIPTS_DIR}"
mkdir -p "${DEVSPECS_TARGET_TEMPLATES_DIR}"
mkdir -p "${DEVSPECS_TARGET_PROMPTS_DIR}"

REPO="andreswebs/devspecs"
REPO_HTTP_URL="https://github.com/${REPO}.git"
REPO_SSH_URL="git@github.com:${REPO}.git"
if [[ -n "${DEVSPECS_USE_SSH:-}" ]]; then
    REPO_URL="${REPO_SSH_URL}"
else
    REPO_URL="${REPO_HTTP_URL}"
fi

git clone "${REPO_URL}" "${TMP_WORKDIR}"

for memory_file in "${DEVSPECS_SOURCE_MEMORY_DIR}"/*; do
    if [ -f "${memory_file}" ] && [ -r "${memory_file}" ]; then
        cp "${memory_file}" "${DEVSPECS_TARGET_MEMORY_DIR}"
    fi
done

find "${DEVSPECS_SOURCE_SCRIPTS_DIR}" -maxdepth 1 -type f -name '*.bash' ! -name '*test*' -exec cp {} "${DEVSPECS_TARGET_SCRIPTS_DIR}" \;

for template_file in "${DEVSPECS_SOURCE_TEMPLATES_DIR}"/*; do
    if [ -f "${template_file}" ] && [ -r "${template_file}" ]; then
        cp "${template_file}" "${DEVSPECS_TARGET_TEMPLATES_DIR}"
    fi
done

for prompt_file in "${DEVSPECS_SOURCE_PROMPTS_DIR}"/*; do
    if [ -f "${prompt_file}" ] && [ -r "${prompt_file}" ]; then
        cp "${prompt_file}" "${DEVSPECS_TARGET_PROMPTS_DIR}"
    fi
done

for script in "${DEVSPECS_TARGET_SCRIPTS_DIR}"/link-github-*.bash; do
    if [[ -x "${script}" ]]; then
        "${script}"
    else
        bash "${script}"
    fi
done
