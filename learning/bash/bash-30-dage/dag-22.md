# Dag 22 — `sed` — stream editing

## Hvad du lærer i dag
- `sed` til find-og-erstat i tekst og filer
- Praktiske `sed`-kommandoer til scripts
- Cross-platform forskelle (GNU vs BSD)

---

## Hvad er `sed`?

`sed` er en stream editor — den læser tekst linje for linje og transformerer den.

```bash
sed 'kommando' input.txt > output.txt
sed -i 'kommando' fil.txt    # in-place (ændrer filen direkte)
```

---

## Find og erstat

```bash
# Erstat første forekomst per linje
sed 's/gammel/ny/' fil.txt

# Erstat alle forekomster per linje (global)
sed 's/gammel/ny/g' fil.txt

# Case-insensitiv erstat
sed 's/gammel/ny/gi' fil.txt

# Erstat på specifik linje (linje 3)
sed '3s/gammel/ny/' fil.txt
```

---

## Cross-platform: in-place med backup

```bash
# GNU sed (Linux)
sed -i 's/old/new/g' fil.txt

# BSD sed (macOS) — kræver backup-suffiks (kan være tom streng)
sed -i '' 's/old/new/g' fil.txt

# Cross-platform løsning
sed_inplace() {
    local expression="$1"
    local file="$2"

    if sed --version &>/dev/null 2>&1; then
        sed -i "$expression" "$file"        # GNU
    else
        sed -i '' "$expression" "$file"     # BSD/macOS
    fi
}
```

---

## Slet linjer

```bash
# Slet tomme linjer
sed '/^$/d' fil.txt

# Slet kommentarlinjer
sed '/^#/d' fil.txt

# Slet linjer med mønster
sed '/fejl/d' fil.txt

# Slet linje N
sed '5d' fil.txt

# Slet fra linje N til M
sed '3,7d' fil.txt
```

---

## Udtræk linjer

```bash
# Print kun linje 5
sed -n '5p' fil.txt

# Print linje 3 til 10
sed -n '3,10p' fil.txt

# Print linjer der matcher mønster
sed -n '/ERROR/p' fil.txt
```

---

## Praktiske eksempler i scripts

```bash
# Opdater versionsnummer i en fil
bump_version() {
    local file="$1"
    local new_version="$2"
    sed_inplace "s/^VERSION=.*/VERSION=\"$new_version\"/" "$file"
}

# Fjern trailing whitespace
trim_trailing() {
    sed_inplace 's/[[:space:]]*$//' "$1"
}

# Indsæt linje efter mønster
indsæt_efter() {
    local mønster="$1"
    local ny_linje="$2"
    local fil="$3"
    sed_inplace "/$mønster/a\\$ny_linje" "$fil"
}
```

---

## `sed` vs parameter expansion

Til simple strengoperationer på variabler: brug parameter expansion (ingen subshell):

```bash
# I stedet for: echo "$str" | sed 's/foo/bar/g'
echo "${str//foo/bar}"
```

Brug `sed` til filer og komplekse transformationer.

---

## Øvelse

Skriv en funktion `prepare_template()` der:
1. Tager en template-fil med `{{VARIABEL}}`-pladsholdere
2. Erstatter `{{APP_NAME}}`, `{{VERSION}}`, `{{DATE}}` med faktiske værdier
3. Skriver resultatet til en ny fil
4. Virker på både macOS og Linux
