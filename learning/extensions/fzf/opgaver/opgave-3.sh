#!/usr/bin/env bash
# Opgave 3: fzf med preview

# Kør:
#   bash opgave-3.sh

# Opgave:
# Find en fil og vis en preview af første 10 linjer mens du søger.

# Hint:
#   - --preview flag med 'head -10 {}'
#   - {} bliver erstattet med valgt fil

selected=$(find . -type f | fzf --preview 'head -10 {}')

if [ -n "$selected" ]; then
  echo "Valgt fil: $selected"
  echo ""
  echo "--- Indhold (første 10 linjer) ---"
  head -10 "$selected"
else
  echo "Intet valgt."
fi
