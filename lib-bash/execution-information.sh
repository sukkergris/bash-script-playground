#!/usr/bin/env bash

# Linjen ovenover kaldes en "shebang".
# Den fortæller systemet, at scriptet skal køres med bash.
# /usr/bin/env bash finder bash via din PATH.

# $0 er navnet/stien, som scriptet blev startet med.
# Det kan fx være "./info.sh", "info.sh" eller "bash info.sh".
echo "Script kaldt som: $0"

# BASH_SOURCE[0] er selve filen, bash læser fra.
# Den er ofte mere præcis end $0, især hvis scriptet bliver sourced.
echo "Scriptfil: ${BASH_SOURCE[0]}"

# $BASH viser stien til den bash-fortolker, der kører scriptet.
echo "Bash-program: $BASH"

# $BASH_VERSION viser versionen af bash.
echo "Bash-version: $BASH_VERSION"

# uname viser hvilket system/kernel du kører på.
# På macOS får du typisk "Darwin".
echo "System: $(uname)"

# pwd viser den mappe, du står i, når scriptet køres.
# Det er ikke nødvendigvis samme mappe som scriptet ligger i.
echo "Aktuel mappe: $(pwd)"

# $# er antallet af argumenter givet til scriptet.
echo "Antal argumenter: $#"

# $@ er alle argumenter.
# Brug altid "$@" med citationstegn, så mellemrum bevares korrekt.
echo "Argumenter: " "$@"

# $1, $2 osv. er de enkelte argumenter.
# ${1:-ingen} betyder: brug $1 hvis den findes, ellers "ingen".
echo "Første argument: ${1:-ingen}"

# dirname giver mappen, scriptet ligger i.
# cd + pwd gør den til en absolut sti.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Scriptets mappe: $script_dir"

# $? er exit-koden fra sidste kommando.
# 0 betyder normalt succes.
false # Sætter return-koden til 1 (fejl)
exit_code=$?
echo "Exit-kode fra sidste kommando: $exit_code"

ecoh ${dir}
