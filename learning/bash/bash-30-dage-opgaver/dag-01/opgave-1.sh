#!/usr/bin/env bash
# Opgave 1 — Print $0 og ${BASH_SOURCE[0]}
#
# Kør scriptet på tre måder og observer hvad der ændrer sig:
#
#   1. Direkte kørsel:   bash dag-01/opgave-1.sh
#   2. Med fuld sti:     bash /xyz/learning/bash/bash-30-dage-opgaver/dag-01/opgave-1.sh
#   3. Via source:       source dag-01/opgave-1.sh
#
# Spørgsmål: Hvilken variabel ændrer sig? Hvilken forbliver den samme?

echo "\$0              = $0"
echo "\${BASH_SOURCE[0]} = ${BASH_SOURCE[0]}"

normal_path=$(realpath "${BASH_SOURCE[0]}");
echo "realpath         = ${normal_path}"
