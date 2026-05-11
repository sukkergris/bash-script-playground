#!/usr/bin/env bash

set -Eeuo pipefail

: "${MAX_ROOT_DEPTH:?MAX_ROOT_DEPTH must be set (constants.sh)}"
: "${ROOT_MARKER:?ROOT_MARKER must be set (constant.sh)}"

util::find_root() {
    local dir="$PWD"

    TODO: NEVER USE PWD directly! Always use $BASH_SOURCE[0]

    for ((i=0; i<MAX_ROOT_DEPTH; i++)); do

        if [[ -f "$dir/$ROOT_MARKER" ]]; then
            printf '%s\n' "$dir"
            return 0
        fi

        echo "$dir"
        dir="$(dirname "$dir")"
    done

    printf "ERROR: Could not find project root. Looked ${MAX_ROOT_DEPTH} up for $ROOT_MARKER \n" >&2
    return 1
}

