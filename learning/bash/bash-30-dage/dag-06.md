# Dag 6 — Strings og string-manipulation

## Hvad du lærer i dag
- Strengoperationer uden externe tools
- Parameter expansion: `${var#...}`, `${var%...}`, `${var//...}`

---

## Grundlæggende strengoperationer

```bash
str="Hello, World!"

echo "${#str}"          # → 13 (længde)
echo "${str^^}"         # → HELLO, WORLD! (store bogstaver)
echo "${str,,}"         # → hello, world! (små bogstaver)
echo "${str:7}"         # → World! (fra position 7)
echo "${str:7:5}"       # → World (5 tegn fra position 7)
```

---

## Fjern prefix og suffix

```bash
fil="backup-2024-01-15.tar.gz"

# Fjern korteste match fra venstre (#)
echo "${fil#backup-}"       # → 2024-01-15.tar.gz

# Fjern længste match fra venstre (##)
echo "${fil##*-}"           # → 15.tar.gz

# Fjern korteste match fra højre (%)
echo "${fil%.gz}"           # → backup-2024-01-15.tar

# Fjern længste match fra højre (%%)
echo "${fil%%.*}"           # → backup-2024-01-15
```

**Huskeregel:** `#` = fra venstre (som `#` kommer før `%` i ASCII), `%` = fra højre.

---

## Erstat tekst

```bash
sti="/usr/local/bin/script"

# Erstat første forekomst
echo "${sti/local/global}"      # → /usr/global/bin/script

# Erstat alle forekomster
echo "${sti//\//|}"             # → |usr|local|bin|script
```

---

## Standardværdier

```bash
# Brug standardværdi hvis variabel er tom eller udefineret
echo "${navn:-ukendt}"          # → ukendt (hvis $navn ikke er sat)

# Sæt variablen hvis den er tom
: "${config:=/etc/app.conf}"
echo "$config"                  # → /etc/app.conf

# Fejl hvis variabel er tom
echo "${REQUIRED_VAR:?'Variabel er påkrævet'}"
```

---

## Praktisk eksempel: filnavne

```bash
filepath="/Users/theodor/projekt/data.csv"

dirname_bash="${filepath%/*}"       # → /Users/theodor/projekt
basename_bash="${filepath##*/}"     # → data.csv
extension="${filepath##*.}"         # → csv
stem="${basename_bash%.*}"          # → data
```

---

## Øvelse

Skriv en funktion `parse_filepath()` der tager en fuld sti og printer:
- Mappe
- Filnavn med extension
- Extension alene
- Filnavn uden extension

Brug kun parameter expansion — ingen `dirname`/`basename` kommandoer.
