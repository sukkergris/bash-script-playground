#!/usr/bin/env bash
# Opgave 5 — Mount bash-lib i devcontaineren og brug scripts direkte i CLI
#
# Mål: Forstå hvordan man pakker scripts i et delt bibliotek, monterer det
#      i devcontaineren, og gør kommandoerne tilgængelige globalt i terminalen.
#
# ─── Trin 1: Se hvad bash-lib indeholder ─────────────────────────────────────
#
#   bash-lib/ ligger i roden af projektet og er allerede tilgængeligt på
#   /xyz/bash-lib inde i containeren.
#
#   Kig på indholdet:
#
#       ls /xyz/bash-lib
#       cat /xyz/bash-lib/greet
#
# ─── Trin 2: Kald scriptet uden PATH ─────────────────────────────────────────
#
#   Prøv at kalde det direkte (det virker ikke endnu):
#
#       greet                  # command not found
#
#   Med fuld sti (virker, men er upraktisk):
#
#       /xyz/bash-lib/greet
#
# ─── Trin 3: Tilføj mount i devcontainer.json ────────────────────────────────
#
#   I .devcontainer/ubuntu/devcontainer.json er der allerede tilføjet:
#
#       "mounts": [
#           "source=${localWorkspaceFolder}/bash-lib,target=/bash-lib,type=bind,consistency=cached"
#       ]
#
#   Dette monterer bash-lib som en selvstændig mappe på /bash-lib —
#   uafhængigt af /xyz. Det svarer til at have et delt bibliotek
#   der ikke er kædet til projektstien.
#
# ─── Trin 4: Tilføj /bash-lib til PATH automatisk ───────────────────────────
#
#   postCreateCommand i devcontainer.json kører én gang efter containeren
#   er bygget:
#
#       echo 'export PATH="/bash-lib:$PATH"' >> /root/.bashrc
#
#   Åbn en ny terminal og test:
#
#       greet                  # kalder /bash-lib/greet direkte
#       greet Theodor          # med argument
#
# ─── Trin 5: Rebuild og verificer ───────────────────────────────────────────
#
#   Rebuild containeren i VS Code:
#   > Dev Containers: Rebuild Container
#
#   Kør derefter:
#
#       which greet            # → /bash-lib/greet
#       echo "${BASH_SOURCE[0]}" # inde i greet — hvad viser den?
#
# ─── Spørgsmål ───────────────────────────────────────────────────────────────
#
#   1. Hvad viser $0 når du kalder `greet` direkte?
#   2. Hvad viser ${BASH_SOURCE[0]}?
#   3. Hvad sker der med ${BASH_SOURCE[0]} hvis du source'r greet i stedet?
#        source /bash-lib/greet
#   4. Hvorfor er /bash-lib bedre end /xyz/bash-lib som mount-destination?

echo "Kører opgave-5 fra: ${BASH_SOURCE[0]}"
echo ""
echo "Test om greet er tilgængeligt:"
if command -v greet &>/dev/null; then
    echo "  'greet' fundet på: $(command -v greet)"
    greet "Theodor"
else
    echo "  'greet' ikke fundet i PATH endnu."
    echo "  Følg trin 3-5 i opgaven og rebuild containeren."
fi
