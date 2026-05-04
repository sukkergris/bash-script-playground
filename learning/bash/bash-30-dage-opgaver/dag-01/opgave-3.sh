#!/usr/bin/env bash
# Opgave 3 — Source et modul og se forskellen
#
# Kør fra roden af projektet:
#   bash learning/bash/bash-30-dage-opgaver/dag-01/opgave-3.sh
#
# Spørgsmål:
#   - Hvad viser $0 inde i lib.sh?
#   - Hvad viser ${BASH_SOURCE[0]} inde i lib.sh?
#   - Hvorfor er det vigtigt at lib.sh bruger ${BASH_SOURCE[0]} til LIB_DIR?

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

echo "=== Fra opgave-3.sh ==="
echo "\$0              = $0"
echo "\${BASH_SOURCE[0]} = ${BASH_SOURCE[0]}"
echo ""
echo "=== Fra lib.sh ==="
lib_info
