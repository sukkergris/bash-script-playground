#!/usr/bin/env bash
# Opgave 3: Kompilering fra kilde

# Hvad: Clone fzf fra GitHub og byg fra kildekode
#
# Kør:
#   bash opgave-3-compile.sh
#
# Noter:
#   - Kræver git, go compiler, make (eller ./install script)
#   - Tager tid (compilation)
#   - Installerer til ~/.fzf
#   - Bruges ofte for udvikling på programmet selv

echo "=== Opgave 3: Kompilering fra kilde ==="
echo ""

# Check om git er installeret
if ! command -v git &> /dev/null; then
  echo "✗ git er ikke installeret. Kan ikke fortsætte."
  exit 1
fi

# Bepaal installationsfolder
FZF_DIR="$HOME/fzf-source"

# Check om fzf allerede er cloned
if [ -d "$FZF_DIR" ]; then
  echo "fzf er allerede cloned i: $FZF_DIR"
  read -p "Vil du re-clone og re-build? (j/n) " choice
  if [ "$choice" = "j" ]; then
    echo "Sletter eksisterende mappe..."
    rm -rf "$FZF_DIR"
  else
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

cd "$FZF_DIR"

echo "✓ Clone færdig"
echo ""

# Check om der er et install script
if [ -f "./install" ]; then
  echo "Kører install script..."
  ./install --bin

  echo ""
  echo "Verificering:"
  $FZF_DIR/fzf --version

  echo ""
  echo "✓ Build og installation færdig!"
  echo ""
  echo "fzf er nu bygget i: $FZF_DIR"
  echo "Binary: $FZF_DIR/fzf"

else
  # Fallback: Prøv manuelt build hvis der ingen install script
  echo "Ingen install script fundet. Bygger manuelt..."

  if ! command -v go &> /dev/null; then
    echo "✗ Go compiler er ikke installeret. Kan ikke bygge."
    echo "Installer via: sudo apt-get install golang-go"
    exit 1
  fi

  make build

  echo ""
  echo "✓ Build færdig!"
  echo "Binary: $FZF_DIR/bin/fzf"
fi
