#!/usr/bin/env bash

util::find_root() {
    local dir="$PWD"

    for ((i=0; i<MAX_ROOT_DEPTH; i++)); do
        if [[ -f "$dir/root-folder-marker" ]]; then
            printf '%s\n' "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done

    printf 'ERROR: Could not find project root\n' >&2
    return 1
}

