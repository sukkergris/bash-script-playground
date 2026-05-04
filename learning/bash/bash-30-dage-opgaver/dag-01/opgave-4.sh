#!/usr/bin/env bash
# Opgave 4 — Tilføj et script til PATH og kald det direkte
#
# Mål: Forstå hvad der sker med $0 og ${BASH_SOURCE[0]}
#      når et script kaldes via PATH i stedet for med en sti.
#
# Trin:
#
#   1. Opret en bin-mappe og kopier scriptet derind:
#
#        mkdir -p ~/bin
#        cp dag-01/opgave-4.sh ~/bin/daginfo
#        chmod +x ~/bin/daginfo
#
#   2. Tilføj ~/bin til din PATH midlertidigt i denne session:
#
#        export PATH="$HOME/bin:$PATH"
#
#   3. Kald scriptet direkte uden sti:
#
#        daginfo
#
#   4. Sammenlign med at kalde det med fuld sti:
#
#        ~/bin/daginfo
#
# Spørgsmål:
#   - Hvad viser $0 når du kalder via PATH?
#   - Hvad viser $0 når du kalder med fuld sti?
#   - Hvad viser ${BASH_SOURCE[0]} i begge tilfælde?
#   - Ville det gå galt at bruge $0 til at finde scriptet eget bibliotek her?

echo "=== Kald-info ==="
echo "\$0                = $0"
echo "\${BASH_SOURCE[0]}   = ${BASH_SOURCE[0]}"

echo ""
echo "=== Bibliotek-beregning ==="

# Sådan må man IKKE gøre det — $0 kan være kun "daginfo" uden sti
unsafe_dir="$(cd "$(dirname "$0")" && pwd)"
echo "Usikker (via \$0):            $unsafe_dir"

# Sådan gør man det rigtigt
safe_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Sikker (via \${BASH_SOURCE[0]}): $safe_dir"

echo ""
echo "=== PATH-check ==="
echo "Scriptet kan kaldes direkte fordi ~/bin er i PATH:"
echo "\$PATH = $PATH"
