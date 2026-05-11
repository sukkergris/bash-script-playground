#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/constants.sh"

source "$SCRIPT_DIR/util/find-root.sh"

PROJECT_ROOT="$(util::find_root)"

LIB_DIR="$PROJECT_ROOT/lib-bash"

declare -Ag __MODULES_LOADED=()

lib::load-module() {
    local name="$1"
    local file="$LIB_DIR/"
}

util::find_root
