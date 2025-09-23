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

mkdir -p .devspecs/scripts
mkdir -p .devspecs/prompts
mkdir -p .devspecs/memory

REPO="andreswebs/devspecs"
REPO_HTTP_URL="https://github.com/${REPO}.git"
REPO_SSH_URL="git@github.com:${REPO}.git"
if [[ -n "${DEVSPECS_USE_SSH:-}" ]]; then
    REPO_URL="${REPO_SSH_URL}"
else
    REPO_URL="${REPO_HTTP_URL}"
fi

git clone "${REPO_URL}" "${TMP_WORKDIR}"

find "${TMP_WORKDIR}/devspecs/scripts" -maxdepth 1 -type f -name '*.bash' ! -name 'test*' -exec cp {} .devspecs/scripts/ \;

for src in "${TMP_WORKDIR}/devspecs/prompts"/*; do
    name="$(basename "${src}")"
    if [[ ! -e ".devspecs/prompts/${name}" ]]; then
        cp "${src}" ".devspecs/prompts/${name}"
    fi
done

for script in .devspecs/scripts/link-github-*.bash; do
    if [[ -x "${script}" ]]; then
        "${script}"
    else
        bash "${script}"
    fi
done

rm -rf "${TMP_WORKDIR}"
