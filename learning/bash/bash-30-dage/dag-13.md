# Dag 13 — Exit codes og fejlhåndtering

## Hvad du lærer i dag
- Hvad exit codes er og hvordan de bruges
- `$?` — den seneste kommandos exit code
- Defensiv programmering med exit codes

---

## Hvad er exit codes?

Enhver kommando i Bash returnerer et heltal fra 0 til 255 når den slutter.

| Exit code | Betydning |
|-----------|-----------|
| `0` | Succes |
| `1` | Generel fejl |
| `2` | Forkert brug af kommando (typisk shell-fejl) |
| `126` | Kommandoen kan ikke eksekveres (mangler tilladelse) |
| `127` | Kommandoen findes ikke |
| `128+N` | Dræbt af signal N (f.eks. 130 = Ctrl+C / SIGINT) |

---

## `$?` — exit code fra forrige kommando

```bash
ls /nonexistent
echo "Exit code: $?"    # → 2

grep "noget" /dev/null
echo "Exit code: $?"    # → 1

true
echo "Exit code: $?"    # → 0
```

**Gem `$?` med det samme** — den næste kommando overskriver den:

```bash
kommando_der_måske_fejler
exit_code=$?            # gem straks

if (( exit_code != 0 )); then
    echo "Fejl: $exit_code"
fi
```

---

## `||` og `&&` med exit codes

```bash
# Kør kun hvis forrige succes
mkdir /tmp/mydir && echo "Mappe oprettet"

# Kør kun hvis forrige fejlede
cd /nonexistent || echo "Mappe findes ikke"

# Kæde
mkdir -p /tmp/work && cd /tmp/work && echo "Klar" || echo "Noget fejlede"
```

---

## Returner exit codes fra funktioner

```bash
tjek_forbindelse() {
    local host="$1"
    ping -c1 -W2 "$host" &>/dev/null
    return $?       # videregivér ping's exit code
}

if tjek_forbindelse "google.com"; then
    echo "Online"
else
    echo "Offline"
fi
```

---

## `exit` i scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

main() {
    local config="${1:-}"

    if [[ -z "$config" ]]; then
        echo "Brug: $0 <config-fil>" >&2
        exit 1      # afslut script med fejlkode
    fi

    # ... resten af scriptet
    exit 0          # eksplicit succes
}

main "$@"
```

---

## Praktisk mønster: akkumulér fejl

```bash
fejl=0

tjek_fil() {
    local fil="$1"
    if [[ ! -f "$fil" ]]; then
        echo "MANGLER: $fil" >&2
        return 1
    fi
    return 0
}

tjek_fil "/etc/hosts"     || (( fejl++ )) || true
tjek_fil "/nonexistent"   || (( fejl++ )) || true
tjek_fil "/etc/passwd"    || (( fejl++ )) || true

echo "Fejl fundet: $fejl"
exit "$fejl"
```

---

## Øvelse

Skriv en funktion `run_with_retry()` der:
1. Tager en kommando og et max antal forsøg
2. Kører kommandoen og returnerer hvis den lykkes
3. Venter 1 sekund og prøver igen ved fejl
4. Returnerer kommandoens exit code hvis alle forsøg mislykkedes
