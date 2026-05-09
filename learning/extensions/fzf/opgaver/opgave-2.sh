#!/usr/bin/env bash
# Opgave 2: fzf med flag — multi-select

# Kør:
#   bash opgave-2.sh

# Opgave:
# Lad brugeren vælge FLERE filer (multi-select med Tab).
# Print antallet af filer der blev valgt.

# Hint:
#   - brug --multi flag
#   - mapfile eller readarray til at parse output

mapfile -t selected < <(find . -type f | fzf --multi)

if [ ${#selected[@]} -gt 0 ]; then
  echo "Du valgte ${#selected[@]} fil(er):"
  for file in "${selected[@]}"; do
    echo "  - $file"
  done
else
  echo "Intet valgt."
fi
