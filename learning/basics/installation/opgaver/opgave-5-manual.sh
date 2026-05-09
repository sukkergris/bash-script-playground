#!/usr/bin/env bash
# Opgave 5: Manuelt download og PATH-tilføjelse

# Hvad: Download binary og tilføj til PATH (uden sudo, kun til $HOME)
#
# Kør:
#   bash opgave-5-manual.sh
#
# Noter:
#   - Installerer til ~/.local/bin
#   - Tilføjer ~/.local/bin til PATH
#   - Kræver IKKE sudo
#   - Mest kontrol og fleksibilitet

echo "=== Opgave 5: Manuelt Download og PATH ==="
echo ""

# Finds seneste version
echo "Finder seneste version..."
LATEST=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
VERSION="${LATEST#v}"

if [ -z "$VERSION" ]; then
  echo "✗ Kunne ikke finde seneste version"
  exit 1
fi

echo "Seneste version: $VERSION"
echo ""

# Opret ~/.local/bin hvis det ikke findes
mkdir -p "$HOME/.local/bin"

# Check om fzf allerede er der
if [ -f "$HOME/.local/bin/fzf" ]; then
  CURRENT=$("$HOME/.local/bin/fzf" --version | awk '{print $1}')
  echo "fzf findes allerede ($VERSION)"
  read -p "Vil du opdatere? (j/n) " choice
  if [ "$choice" != "j" ]; then
    echo "Afbrudt."
    exit 0
  fi
fi

# Find OS og arkitektur
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
esac

BINARY="fzf-${VERSION}-${OS}_${ARCH}.tar.gz"
URL="https://github.com/junegunn/fzf/releases/download/v${VERSION}/${BINARY}"

echo "Downloader: $BINARY"
if curl -fL "$URL" -o "/tmp/${BINARY}"; then
  echo "✓ Download færdig"
else
  echo "✗ Download fejlede"
  exit 1
fi

echo ""
echo "Pakker ud..."
tar -xzf "/tmp/${BINARY}" -C "$HOME/.local/bin"
rm "/tmp/${BINARY}"

echo "✓ Pakket ud til: $HOME/.local/bin"
echo ""

# Tilføj til PATH hvis det ikke allerede er der
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo "Tilføjer $HOME/.local/bin til PATH..."

  # Find den rigtige shell-config fil
  if [ -f "$HOME/.bashrc" ]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo "Tilføjet til ~/.bashrc"
  elif [ -f "$HOME/.zshrc" ]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo "Tilføjet til ~/.zshrc"
  else
    echo "Kunne ikke finde .bashrc eller .zshrc"
    echo "Tilføj manuelt denne linje til din shell config:"
    echo 'export PATH="$HOME/.local/bin:$PATH"'
  fi

  echo ""
  echo "Reloader shell..."
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✓ $HOME/.local/bin er allerede i PATH"
fi

echo ""
echo "Verificering:"
"$HOME/.local/bin/fzf" --version

echo ""
echo "✓ Installation færdig!"
echo ""
echo "fzf er nu på: $HOME/.local/bin/fzf"
echo ""
echo "For at fjerne alt igen:"
echo "  rm $HOME/.local/bin/fzf"
