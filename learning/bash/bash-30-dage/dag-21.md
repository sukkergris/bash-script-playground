# Dag 21 — Tekstprocessering med `grep`

## Hvad du lærer i dag
- `grep` og dens vigtigste flag
- Extended regular expressions med `-E`
- Praktiske søgemønstre til scripts

---

## Grundlæggende `grep`

```bash
grep "mønster" fil.txt          # find linjer med mønster
grep -i "mønster" fil.txt       # case-insensitiv
grep -v "mønster" fil.txt       # inverter — linjer UDEN mønster
grep -n "mønster" fil.txt       # vis linjenummer
grep -c "mønster" fil.txt       # tæl matchende linjer
grep -l "mønster" *.sh          # vis kun filnavne
grep -r "mønster" ./lib-bash/   # rekursiv søgning
```

---

## Extended Regular Expressions: `grep -E` eller `egrep`

```bash
# Alternativ (OR)
grep -E "fejl|error|warning" logfil.txt

# En eller flere
grep -E "colou?r" fil.txt       # color eller colour

# Gentag gruppe
grep -E "(ab){3}" fil.txt       # ababab

# Klasser
grep -E "^[0-9]{1,3}\.[0-9]{1,3}" fil.txt   # IP-adresse start
```

---

## Nyttige mønstre

```bash
# Tom linjer
grep -v "^$" fil.txt

# Kommentarer
grep -v "^#" fil.txt

# Begge (ingen tomme linjer og ingen kommentarer)
grep -v "^[[:space:]]*#\|^[[:space:]]*$" fil.txt

# Kun linjer med indhold
grep -v "^[[:space:]]*$" fil.txt
```

---

## Kontekst-flag

```bash
grep -A 3 "ERROR" log.txt       # 3 linjer EFTER match (After)
grep -B 2 "ERROR" log.txt       # 2 linjer FØR match (Before)
grep -C 2 "ERROR" log.txt       # 2 linjer på begge sider (Context)
```

---

## `grep` i scripts

```bash
# Test om noget matcher (brug exit code)
if grep -q "set -euo pipefail" "$fil"; then
    echo "Fil har korrekt header"
fi

# Hent matchet
version=$(grep -oP 'VERSION="\K[^"]+' config.sh)

# Tæl fejl
fejl=$(grep -c "^ERROR:" logfil.txt || true)
```

`-q` = quiet, kast kun exit code.
`-o` = print kun det matchende del.
`-P` = Perl-kompatible regex (ikke tilgængelig på macOS).

---

## Cross-platform regex

macOS bruger BSD grep, Linux bruger GNU grep. Forskelle:

```bash
# GNU grep (Linux)
grep -P '\d+' fil     # Perl regex (\d, \w, \s)
grep -oP 'KEY=\K\S+' fil   # lookahead \K

# BSD grep (macOS) — brug -E i stedet
grep -E '[0-9]+' fil
grep -oE 'KEY=([^ ]+)' fil | cut -d= -f2
```

I lib-bash: brug `-E` for at sikre kompatibilitet.

---

## Øvelse

Skriv en funktion `søg_i_scripts()` der:
1. Finder alle `.sh`-filer i et givet directory (rekursivt)
2. Søger efter `TODO`, `FIXME`, og `HACK` kommentarer
3. Printer fil:linje:indhold for hvert fund
4. Returnerer antallet af fund
