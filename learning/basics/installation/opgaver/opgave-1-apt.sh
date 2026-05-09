#!/usr/bin/env bash
# Opgave 1: apt-get installation

# Hvad: Installer fzf via apt-get (package manager)
#
# Kør:
#   bash opgave-1.sh
#
# Noter:
#   - Kræver sudo (du bliver spurgt om password)
#   - Spørger sudo først, så du kan sige nej
#   - Checker først om fzf allerede er installeret

echo "=== Opgave 1: apt-get Installation ==="
echo ""

# Check om fzf allerede er installeret
if command -v fzf &> /dev/null; then
  echo "✓ fzf er allerede installeret:"
  fzf --version
  echo ""
  echo "Springer over installation."
  exit 0
fi

echo "fzf er IKKE installeret."
echo ""
echo "Vil du installere det via apt-get? (j/n)"
read -p "> " choice

if [ "$choice" != "j" ]; then
  echo "Afbrudt."
  exit 0
fi

echo ""
echo "Kører: sudo apt-get update"
sudo apt-get update

echo ""
echo "Kører: sudo apt-get install -y fzf"
sudo apt-get install -y fzf

echo ""
echo "Verificering:"
fzf --version

echo ""
echo "✓ Installation færdig!"
