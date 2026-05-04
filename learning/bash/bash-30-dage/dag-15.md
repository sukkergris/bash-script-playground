# Dag 15 — ERR-traps og cleanup med `trap`

## Hvad du lærer i dag
- `trap` kommandoen og dens signaler
- ERR-trap til fejlhåndtering
- EXIT-trap til cleanup der altid kører

---

## Hvad er `trap`?

`trap` registrerer en funktion der kører når et signal modtages eller en hændelse sker.

```bash
trap 'kør_dette' SIGNAL
```

---

## Vigtige signaler og hændelser

| Signal/hændelse | Hvornår |
|-----------------|---------|
| `EXIT` | Altid når scriptet slutter (succes eller fejl) |
| `ERR` | Når en kommando returnerer ikke-nul |
| `INT` | Ctrl+C (SIGINT) |
| `TERM` | `kill` kommando (SIGTERM) |
| `DEBUG` | Før hver kommando (til debugging) |

---

## EXIT-trap — cleanup der altid kører

```bash
#!/usr/bin/env bash
set -euo pipefail

TMPDIR_WORK="$(mktemp -d)"

cleanup() {
    rm -rf "$TMPDIR_WORK"
    echo "Midlertidig mappe slettet" >&2
}
trap cleanup EXIT

# Resten af scriptet bruger $TMPDIR_WORK
# cleanup() kører uanset om scriptet lykkes eller fejler
```

---

## ERR-trap — fang alle fejl

```bash
#!/usr/bin/env bash
set -euo pipefail

__on_error() {
    local exit_code=$?
    local line_number=${BASH_LINENO[0]}
    local command="${BASH_COMMAND}"

    echo "FEJL: exit code $exit_code på linje $line_number" >&2
    echo "Kommando: $command" >&2
}
trap __on_error ERR
```

Dette er præcis mønsteret fra `lib-bash/error-handling.sh`.

---

## Kombiner EXIT og ERR

```bash
FEJL=false

__on_error() {
    FEJL=true
    echo "Fejl på linje ${BASH_LINENO[0]}: ${BASH_COMMAND}" >&2
}

cleanup() {
    if [[ "$FEJL" == "true" ]]; then
        echo "Script fejlede — rydder op" >&2
    else
        echo "Script lykkedes" >&2
    fi
    rm -rf "${TMPDIR:-}"
}

trap __on_error ERR
trap cleanup EXIT
```

---

## Nul-ud en trap

```bash
trap - EXIT   # Fjern EXIT-trap
trap - ERR    # Fjern ERR-trap
```

---

## `BASH_LINENO` og `BASH_COMMAND`

Disse to variabler er kun meningsfulde inde i en trap-handler:

| Variabel | Indhold |
|----------|---------|
| `BASH_LINENO[0]` | Linjenummer der triggede trappen |
| `BASH_COMMAND` | Kommandoen der kørte da trappen aktiverede |
| `FUNCNAME[@]` | Call stack (funktionsnavne) |

---

## Øvelse

Byg et script der:
1. Opretter en midlertidig mappe
2. Kopierer filer derind
3. Processerer dem
4. Sørger via `trap cleanup EXIT` for at mappen altid slettes
5. Logger fejlinfo via `trap __on_error ERR`
