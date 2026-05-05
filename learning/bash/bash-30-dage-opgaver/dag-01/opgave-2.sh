#!/usr/bin/env bash
# Opgave 2 — Symlink-test
#
# Opret en symlink til dette script og kør via symlinken:
#
#   ln -s "$(pwd)/dag-01/opgave-2.sh" /tmp/mit-script
#   bash /tmp/mit-script
#
# Forventet observation:
#   Når du kalder scriptet via en symlink, vil $0 normalt vise symlink-stien.
#   ${BASH_SOURCE[0]} er heller ikke automatisk symlink-opløst i Bash.
#   Pointen er derfor ikke at ${BASH_SOURCE[0]} "magisk" finder den rigtige fil,
#   men at den er mere robust end $0 når kode bliver sourced eller genbrugt som modul.
#
# Spørgsmål: Hvornår er det et problem at bruge $0 til at finde scriptet?

echo "\$0              = $0"
echo "\${BASH_SOURCE[0]} = ${BASH_SOURCE[0]}"

# Beregn scriptet eget bibliotek — prøv begge varianter:
dir_via_0="$(cd "$(dirname "$0")" && pwd)"
dir_via_source="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Bibliotek via \$0:              $dir_via_0"
echo "Bibliotek via \${BASH_SOURCE[0]}: $dir_via_source"
