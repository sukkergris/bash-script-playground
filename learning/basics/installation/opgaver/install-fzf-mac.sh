#!/usr/bin/env bash
# Installationsscript: fzf på Mac M3 (Apple Silicon)

# Hvad: Installerer fzf (command-line fuzzy finder) på macOS Apple Silicon
# Kilde: https://github.com/junegunn/fzf
#
# Kør:
#   bash install-fzf-mac.sh
#
# Noter:
#   - Kræver macOS på Apple Silicon (M1/M2/M3)
#   - Bruger Homebrew hvis tilgængeligt, ellers git clone (~/.fzf)
#   - Tilføjer shell-integration til ~/.zshrc (Ctrl+R, Ctrl+T, Alt+C)

echo "=== fzf Installation (Mac M3 / Apple Silicon) ==="
echo ""

# Tjek at vi kører på macOS
if [ "$(uname -s)" != "Darwin" ]; then
  echo "✗ Dette script kræver macOS."
  exit 1
fi

# Tjek at vi kører på Apple Silicon
if [ "$(uname -m)" != "arm64" ]; then
  echo "✗ Dette script er beregnet til Apple Silicon (arm64)."
  echo "  Nuværende arkitektur: $(uname -m)"
  exit 1
fi

echo "✓ Platform: macOS $(sw_vers -productVersion) på Apple Silicon"
echo ""

# Tjek om fzf allerede er installeret
if command -v fzf &> /dev/null; then
  CURRENT=$(fzf --version | awk '{print $1}')
  echo "fzf er allerede installeret (version $CURRENT)"
  read -p "Vil du geninstallere/opdatere? (j/n) " choice
  if [ "$choice" != "j" ]; then
    echo "Afbrudt."
    exit 0
  fi
  echo ""
fi

# Installer med Homebrew (foretrukket) eller git clone (fallback)
if command -v brew &> /dev/null; then
  echo "Bruger Homebrew til installation..."
  brew install fzf

  if ! command -v fzf &> /dev/null; then
    echo "✗ Installation fejlede"
    exit 1
  fi

  echo "✓ fzf installeret via Homebrew"
  echo ""

  # Tilføj shell-integration til ~/.zshrc (standard shell på macOS)
  if [ -f "$HOME/.zshrc" ]; then
    if grep -qF 'fzf --zsh' "$HOME/.zshrc"; then
      echo "✓ Shell-integration allerede til stede i ~/.zshrc"
    else
      {
        echo ""
        echo "# fzf shell-integration (key bindings + fuzzy completion)"
        echo 'eval "$(fzf --zsh)"'
      } >> "$HOME/.zshrc"
      echo "✓ Shell-integration tilføjet til ~/.zshrc"
    fi
  else
    echo "  Tip: Tilføj denne linje til din shell-konfiguration:"
    echo '  eval "$(fzf --zsh)"'
  fi

else
  # Fallback: git clone
  echo "Homebrew ikke fundet. Bruger git clone-metoden..."
  echo ""

  if ! command -v git &> /dev/null; then
    echo "✗ Hverken Homebrew eller git er tilgængeligt."
    echo "  Installer Homebrew fra: https://brew.sh"
    exit 1
  fi

  FZF_DIR="$HOME/.fzf"

  if [ -d "$FZF_DIR" ]; then
    echo "~/.fzf eksisterer allerede"
    read -p "Vil du slette og re-clone? (j/n) " choice
    if [ "$choice" = "j" ]; then
      rm -rf "$FZF_DIR"
    else
      echo "Afbrudt."
      exit 0
    fi
    echo ""
  fi

  echo "Cloner fzf repository..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"

  if [ ! -d "$FZF_DIR" ]; then
    echo "✗ Clone fejlede"
    exit 1
  fi

  echo "✓ Clone færdig"
  echo ""

  # --all aktiverer key bindings og fuzzy completion uden interaktive prompter
  echo "Kører install script (sætter shell-integration op)..."
  "$FZF_DIR/install" --all

  echo "✓ fzf installeret via git clone"
fi

echo ""

# Verificering
echo "Verificering:"
fzf --version

echo ""
echo "✓ fzf er installeret: $(command -v fzf)"
echo ""
echo "Genstart terminalen eller kør: source ~/.zshrc"
echo "Prøv derefter:"
echo "  Ctrl+R  — fuzzy-søgning i shell-historik"
echo "  Ctrl+T  — fuzzy-søgning af filer"
echo "  Alt+C   — fuzzy-søgning til at skifte mappe"
