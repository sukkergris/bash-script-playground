#!/usr/bin/env bash
# Opgave 4: Shell script installer

# Hvad: Bruges fzf's eget installationsscript
#
# Kør:
#   bash opgave-4-script.sh
#
# Noter:
#   - fzf leverer sitt eget install script
#   - Det håndterer keybindings og shell-integration
#   - Interaktiv installation (du bliver spurgt spørgsmål)
#   - Installerer til ~/.fzf

echo "=== Opgave 4: Shell Script Installer ==="
echo ""

# Check om git er installeret
if ! command -v git &> /dev/null; then
  echo "✗ git er ikke installeret. Kan ikke fortsætte."
  exit 1
fi

FZF_DIR="$HOME/.fzf"

# Check om fzf allerede er installeret denne vej
if [ -d "$FZF_DIR" ]; then
  echo "fzf er allerede installeret i: $FZF_DIR"
  echo ""
  "$FZF_DIR/bin/fzf" --version
  echo ""
  read -p "Vil du køre install script igen? (j/n) " choice
  if [ "$choice" != "j" ]; then
    echo "Afbrudt."
    exit 0
  fi
fi

echo "Cloner fzf repository..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"

if [ ! -d "$FZF_DIR" ]; then
  echo "✗ Clone fejlede"
  exit 1
fi

echo "✓ Clone færdig"
echo ""
echo "Kører install script..."
echo "(Du bliver spurgt om keybindings og shell-integration)"
echo ""

cd "$FZF_DIR"
./install

echo ""
echo "✓ Installation færdig!"
echo ""
echo "fzf er nu installeret i: $FZF_DIR"
echo ""
echo "Verificering:"
"$FZF_DIR/bin/fzf" --version
