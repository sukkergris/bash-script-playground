#!/usr/bin/env bash
# Opgave 1: Basisk fzf — find en fil

# Kør:
#   bash opgave-1.sh

# Opgave:
# Brug fzf til at liste alle filer i denne folder (.),
# lad brugeren vælge én, og print den valgte filsti.

# Hint:
#   - find . -type f
#   - pipe til fzf
#   - gem outputtet i en variabel

selected=$(find . -type f | fzf)

if [ -n "$selected" ]; then
  echo "Du valgte: $selected"
else
  echo "Intet valgt."
fi
