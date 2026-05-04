# Dag 24 — Regular expressions i Bash

## Hvad du lærer i dag
- Regex i `[[ =~ ]]`
- POSIX character classes
- Capture groups med `BASH_REMATCH`

---

## Regex i `[[ =~ ]]`

```bash
streng="Theodor123"

if [[ "$streng" =~ ^[A-Za-z]+[0-9]+$ ]]; then
    echo "Matcher: bogstaver efterfulgt af tal"
fi
```

**Vigtigt:** Regex-mønsteret må IKKE citeres med `"..."` — det behandles som en literal streng.

```bash
# FORKERT
[[ "$str" =~ "^[0-9]+" ]]   # søger efter literal "^[0-9]+"

# RIGTIGT
[[ "$str" =~ ^[0-9]+ ]]
```

---

## POSIX character classes

Disse virker på alle platforme (ingen `/dev/null` for macOS vs Linux):

| Class | Matcher |
|-------|---------|
| `[:alpha:]` | Bogstaver (a-z, A-Z) |
| `[:digit:]` | Tal (0-9) |
| `[:alnum:]` | Bogstaver + tal |
| `[:space:]` | Whitespace (space, tab, newline) |
| `[:upper:]` | Store bogstaver |
| `[:lower:]` | Små bogstaver |
| `[:punct:]` | Tegnsætning |

```bash
[[ "$str" =~ ^[[:alpha:]]+$ ]]     # kun bogstaver
[[ "$str" =~ [[:digit:]] ]]        # indeholder mindst ét tal
```

---

## `BASH_REMATCH` — capture groups

```bash
streng="version=2.5.1"

if [[ "$streng" =~ version=([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    echo "Fuld match: ${BASH_REMATCH[0]}"    # → version=2.5.1
    echo "Major: ${BASH_REMATCH[1]}"          # → 2
    echo "Minor: ${BASH_REMATCH[2]}"          # → 5
    echo "Patch: ${BASH_REMATCH[3]}"          # → 1
fi
```

`BASH_REMATCH[0]` = hele matchet, `[1]`... = capture groups.

---

## Praktiske valideringsmønstre

```bash
# Validér IP-adresse (grundlæggende)
is_ip() {
    [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
}

# Validér heltal
is_integer() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

# Validér positivt heltal
is_positive_int() {
    [[ "$1" =~ ^[0-9]+$ ]] && (( $1 > 0 ))
}

# Validér hostname
is_hostname() {
    [[ "$1" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*$ ]]
}

# Validér semver
is_semver() {
    [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}
```

---

## Regex vs glob

| Kontekst | Syntaks | Eksempel |
|----------|---------|---------|
| `[[ =~ ]]` | ERE regex | `[[ $s =~ ^[0-9]+$ ]]` |
| `[[ == ]]` | Glob | `[[ $s == *.sh ]]` |
| `case` | Glob | `case "$s" in *.sh)` |
| `find -name` | Glob | `find . -name "*.sh"` |

---

## Øvelse

Skriv en funktion `parse_connection_string()` der:
1. Tager en connection string: `protocol://user:pass@host:port/database`
2. Bruger `[[ =~ ]]` og `BASH_REMATCH` til at udtrække hver del
3. Printer alle dele separat
4. Returnerer fejl hvis strengen ikke matcher det forventede format
