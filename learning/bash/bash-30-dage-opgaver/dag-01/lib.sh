#!/usr/bin/env bash
# Hjælpemodul — sourced af opgave-3.sh
#
# Bemærk: dette modul bruger ${BASH_SOURCE[0]} til at finde sin egen placering,
# uanset hvorfra det bliver sourced.

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

lib_info() {
    echo "[lib.sh] Kaldt fra:      $0"
    echo "[lib.sh] Lib ligger i:   $LIB_DIR"
}
