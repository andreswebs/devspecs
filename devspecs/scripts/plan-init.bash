#!/usr/bin/env bash
# Initialize implementation plan structure for current branch
# Returns metadata needed for implementation plan generation

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/functions.bash"

SPEC_INFO=$(get_spec_info || exit 1)

## [WIP]
# # Create specs directory if it doesn't exist
# mkdir -p "$FEATURE_DIR"

# # Copy plan template if it exists
# TEMPLATE="$REPO_ROOT/templates/plan-template.md"
# if [ -f "$TEMPLATE" ]; then
#     cp "$TEMPLATE" "$IMPL_PLAN"
# fi

echo "${SPEC_INFO}" | jq --monochrome-output
