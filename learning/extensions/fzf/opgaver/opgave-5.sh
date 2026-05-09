#!/usr/bin/env bash
# Opgave 5: fzf med process list — kill interaktivt

# Kør:
#   bash opgave-5.sh

# Opgave:
# Vis en liste af dine køende processer, lad brugeren vælge,
# og kill processen. (ADVARSEL: Pas på!)

# Hint:
#   - ps aux eller pgrep -af
#   - awk for at få PID
#   - kill $pid

selected=$(ps aux | fzf)

if [ -n "$selected" ]; then
  pid=$(echo "$selected" | awk '{print $2}')
  echo "Du valgte PID: $pid"
  echo "Kommando: $(echo "$selected" | awk '{print $NF}')"

  # Spørg før kill
  read -p "Kill denne proces? (j/n): " confirm
  if [ "$confirm" = "j" ]; then
    kill "$pid"
    echo "Process killed."
  else
    echo "Afbrudt."
  fi
else
  echo "Intet valgt."
fi
