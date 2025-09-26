#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/functions.bash"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/env.bash"

SPEC_INFO=$(get_spec_info || exit 1)
SPEC_DIR=$(echo "${SPEC_INFO}" | jq --raw-output '.spec_dir')

REQUIREMENTS_FILE_BASE_NAME="requirements.md"
REQUIREMENTS_FILE="${SPEC_DIR}/${REQUIREMENTS_FILE_BASE_NAME}"

if ! is_readable_file "${REQUIREMENTS_FILE}"; then
    log "error: failed to access ${REQUIREMENTS_FILE}"
    exit 1
fi

cat "${REQUIREMENTS_FILE}"
