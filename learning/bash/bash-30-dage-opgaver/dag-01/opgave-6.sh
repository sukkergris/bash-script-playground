#!/usr/bin/env bash
# Opgave 6 — Normaliser stien til scriptet
#
# Mål: Se forskellen på den rå værdi i ${BASH_SOURCE[0]} og en normaliseret sti.
#
# Prøv at køre scriptet:
#
#   1. Fra samme mappe:
#        ./opgave-6.sh
#
#   2. Fra en anden mappe:
#        bash /xyz/learning/bash/bash-30-dage-opgaver/dag-01/opgave-6.sh
#
#   3. Via en relativ sti:
#        cd /xyz
#        bash learning/bash/bash-30-dage-opgaver/dag-01/opgave-6.sh
#
# Spørgsmål:
#   - Hvad viser ${BASH_SOURCE[0]} i hver kørsel?
#   - Hvad viser SCRIPT_DIR og SCRIPT_PATH?
#   - Hvilken værdi vil du bruge, hvis dit script skal finde filer ved siden af sig selv?

raw_source="${BASH_SOURCE[0]}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script_path="$script_dir/$(basename "${BASH_SOURCE[0]}")"

echo "Rå sti:                 $raw_source"
echo "Normaliseret mappe:     $script_dir"
echo "Normaliseret filsti:    $script_path"
