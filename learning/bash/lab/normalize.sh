#!/usr/bin/env bash
set -Eeuo pipefail

# ${var%pattern}
NAME="util/find-root.sh"
NAME_NORMALIZED="${NAME%.sh}"
echo "${NAME_NORMALIZED}"
