#!/usr/bin/env bash
# Opgave 2: GitHub release download

# Hvad: Download og installer fzf fra GitHub releases (pre-compiled binary)
#
# Kør:
#   bash opgave-2-github.sh
#
# Noter:
#   - Henter seneste release automatisk
#   - Bruger curl til download
#   - Installerer til /usr/local/bin (kræver sudo)

echo "=== Opgave 2: GitHub Release Download ==="
echo ""

# Finder seneste release automatisk
echo "Finder seneste version fra GitHub..."
LATEST=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
VERSION="${LATEST#v}"  # Fjern "v" prefix

if [ -z "$VERSION" ]; then
  echo "✗ Kunne ikke finde seneste version"
  exit 1
fi

echo "Seneste version: $VERSION"
echo ""

# Check om fzf allerede er installeret
if command -v fzf &> /dev/null; then
  CURRENT=$(fzf --version | awk '{print $1}')
  echo "fzf er allerede installeret (version $CURRENT)"
  echo ""
  read -p "Vil du opdatere til $VERSION? (j/n) " choice
  if [ "$choice" != "j" ]; then
    echo "Afbrudt."
    exit 0
  fi
fi

# Bestem OS og arkitektur
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
esac

BINARY="fzf-${VERSION}-${OS}_${ARCH}.tar.gz"
URL="https://github.com/junegunn/fzf/releases/download/v${VERSION}/${BINARY}"

echo "Downloader fra: $URL"
echo ""

# Download til /tmp
if curl -fL "$URL" -o "/tmp/${BINARY}"; then
  echo "✓ Download færdig"
else
  echo "✗ Download fejlede"
  exit 1
fi

# Pak ud
echo ""
echo "Pakker ud..."
tar -xzf "/tmp/${BINARY}" -C /tmp

# Installer
echo "Installerer til /usr/local/bin..."
sudo mv /tmp/fzf /usr/local/bin/
sudo chmod +x /usr/local/bin/fzf

# Cleanup
rm "/tmp/${BINARY}"

# Verificer
echo ""
echo "Verificering:"
fzf --version

echo ""
echo "✓ Installation færdig!"
