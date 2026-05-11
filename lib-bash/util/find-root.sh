#!/usr/bin/env bash

util::find_root() {
    local dir="$PWD"
    local max_up=5

    for ((i=0; i<max_up; i++)); do
        if [[ -f "$dir/root-folder-marker" ]]; then
            printf '%s\n' "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done

    printf 'ERROR: Could not find project root\n' >&2
    return 1
}

