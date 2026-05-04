# Dag 29 — Testing i Bash uden frameworks

## Hvad du lærer i dag
- Test-mønstre direkte i Bash
- Assert-funktioner
- Mønstre fra `dev/test-lib-bash/`

---

## Grundprincipperne

Fra projektets CLAUDE.md:
- Ren Bash — ingen testframeworks
- Hvert testtilfælde printer `[OK]` eller `[ERROR]` via `logging.sh`
- Error-handling testes i subshells
- Tests er deterministiske og kræver ingen netværk/sudo

---

## Grundlæggende assert-funktioner

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib-bash/logging.sh"

TESTS_RUN=0
TESTS_FAILED=0

assert_eq() {
    local beskrivelse="$1"
    local forventet="$2"
    local faktisk="$3"
    (( TESTS_RUN++ )) || true

    if [[ "$forventet" == "$faktisk" ]]; then
        log_ok "$beskrivelse"
    else
        log_error "$beskrivelse"
        echo "  Forventet: $(printf '%q' "$forventet")" >&2
        echo "  Faktisk:   $(printf '%q' "$faktisk")" >&2
        (( TESTS_FAILED++ )) || true
    fi
}

assert_true() {
    local beskrivelse="$1"
    (( TESTS_RUN++ )) || true

    if eval "${@:2}"; then
        log_ok "$beskrivelse"
    else
        log_error "$beskrivelse"
        (( TESTS_FAILED++ )) || true
    fi
}

assert_fails() {
    local beskrivelse="$1"
    (( TESTS_RUN++ )) || true

    if ! eval "${@:2}" &>/dev/null; then
        log_ok "$beskrivelse"
    else
        log_error "$beskrivelse — forventede fejl men fik succes"
        (( TESTS_FAILED++ )) || true
    fi
}
```

---

## Test error-handling i subshells

```bash
# Korrekt mønster — test at en funktion fejler
assert_exits_nonzero() {
    local beskrivelse="$1"
    local kommando="$2"
    (( TESTS_RUN++ )) || true

    if ( set -e; eval "$kommando" ) 2>/dev/null; then
        log_error "$beskrivelse — forventede exit != 0"
        (( TESTS_FAILED++ )) || true
    else
        log_ok "$beskrivelse"
    fi
}
```

---

## Komplet testfil-skabelon

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib-bash/logging.sh"
source "$SCRIPT_DIR/../../lib-bash/mit-modul.sh"

TESTS_RUN=0
TESTS_FAILED=0

# --- Tests ---

test_grundlæggende_funktion() {
    local resultat
    resultat="$(min_funktion "input")"
    assert_eq "min_funktion returnerer korrekt output" "forventet" "$resultat"
}

test_fejl_ved_tomt_input() {
    assert_exits_nonzero "min_funktion fejler ved tomt input" \
        "min_funktion ''"
}

# --- Kør tests ---

test_grundlæggende_funktion
test_fejl_ved_tomt_input

# --- Resultat ---

echo ""
echo "Tests kørt: $TESTS_RUN"
echo "Tests fejlet: $TESTS_FAILED"

(( TESTS_FAILED == 0 ))
```

---

## Kør alle tests

```bash
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

total_fejl=0

for testfil in test-*.sh; do
    echo "=== $testfil ==="
    bash "$testfil" || (( total_fejl++ )) || true
    echo ""
done

echo "==========================="
echo "Samlet fejlede filer: $total_fejl"
exit "$total_fejl"
```

---

## Øvelse

Skriv en komplet testfil for `lib-bash/os-detection.sh` der tester:
1. `detect_os()` returnerer en af: `macos`, `linux`, `wsl`, `windows`, `unknown`
2. Outputtet er ikke tomt
3. Kørsel på det aktuelle system returnerer det forventede OS
