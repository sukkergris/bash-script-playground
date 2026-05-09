#!/usr/bin/env bash
# Opgave 4: Custom function — fuzzy_edit

# Kør:
#   source opgave-4.sh
#   fuzzy_edit

# Opgave:
# Lav en bash-function der fuzzy-finder filer og åbner dem i editor.

fuzzy_edit() {
  local file
  file=$(find . -type f | fzf --preview 'head -10 {}')

  if [ -n "$file" ]; then
    # Brug $EDITOR hvis sat, ellers vim som fallback
    "${EDITOR:-vim}" "$file"
    echo "Lukket: $file"
  else
    echo "Intet valgt."
  fi
}

# Kald functionen
fuzzy_edit
