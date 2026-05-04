# Dag 30 — Byg en komplet CLI-tool

## Hvad du lærer i dag
- Sæt alle 29 dages læring sammen
- Byg en produktionsklar CLI med subkommandoer, help, og fejlhåndtering
- Mønstre fra `ktk-server/lib-bash/`

---

## Målet

En CLI-tool `ktk` med subkommandoer:

```
ktk cert init       — Generer dev-certs
ktk cert check      — Validér eksisterende certs
ktk host add        — Tilføj til /etc/hosts
ktk host remove     — Fjern fra /etc/hosts
ktk version         — Vis version
ktk help            — Vis hjælp
```

---

## Strukturen

```
bin/ktk                     Entrypoint
lib-bash/
  header.sh                 Loader (dag 4)
  error-handling.sh         ERR-trap (dag 15)
  logging.sh                log_* funktioner (dag 16)
  os-detection.sh           detect_os() (dag 28)
  cert.sh                   cert-kommandoer
  host.sh                   host-kommandoer
```

---

## Entrypoint: `bin/ktk`

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib-bash/header.sh"

VERSION="1.0.0"

usage() {
    cat <<EOF
Brug: ktk <kommando> [argumenter]

Kommandoer:
  cert init          Generer self-signed dev-certs
  cert check         Validér eksisterende certs
  host add <navn>    Tilføj til /etc/hosts
  host remove <navn> Fjern fra /etc/hosts
  version            Vis version
  help               Vis denne hjælp

EOF
}

main() {
    local cmd="${1:-}"

    case "$cmd" in
        cert)   source "$SCRIPT_DIR/../lib-bash/cert.sh"; cert_cmd "${@:2}" ;;
        host)   source "$SCRIPT_DIR/../lib-bash/host.sh"; host_cmd "${@:2}" ;;
        version) echo "ktk $VERSION" ;;
        help|"") usage ;;
        *)
            log_error "Ukendt kommando: $cmd"
            usage
            exit 1
            ;;
    esac
}

main "$@"
```

---

## Argument-parsing med getopts

```bash
parse_args() {
    local verbose=false
    local dry_run=false
    local output=""

    while getopts ":vo:n" opt; do
        case "$opt" in
            v)  verbose=true ;;
            o)  output="$OPTARG" ;;
            n)  dry_run=true ;;
            :)  log_error "Flag -$OPTARG kræver et argument"; return 1 ;;
            \?) log_error "Ukendt flag: -$OPTARG"; return 1 ;;
        esac
    done
    shift $(( OPTIND - 1 ))

    echo "verbose=$verbose dry_run=$dry_run output=$output args=$*"
}
```

---

## Tjekliste for en produktionsklar CLI

- [ ] `#!/usr/bin/env bash` + `set -euo pipefail`
- [ ] `${BASH_SOURCE[0]}`-baseret loader
- [ ] ERR-trap med linje og kommando
- [ ] EXIT-trap til cleanup
- [ ] `usage()`-funktion
- [ ] Validering af alle argumenter
- [ ] Fejlbeskeder til stderr (`>&2`)
- [ ] Meningsfulde exit codes
- [ ] Cross-platform (macOS + Linux)
- [ ] Tests for alle subkommandoer

---

## Tillykke!

Du har nu lært:

| Dag | Emne |
|-----|------|
| 1-4 | Script-loading og paths |
| 5-8 | Variabler, strings, arrays, aritmetik |
| 9-11 | Betingelser og loops |
| 12-15 | Funktioner, exit codes, traps |
| 16-18 | I/O, pipes, subshells |
| 19-20 | Config og filer |
| 21-24 | Tekstprocessering og regex |
| 25-26 | Debugging og signaler |
| 27-28 | Parallelitet og OS-detection |
| 29 | Testing |
| 30 | Komplet CLI-tool |

---

## Afsluttende øvelse

Byg `bin/ktk` komplet med:
1. Mindst 2 subkommandoer der bruger eksisterende `lib-bash`-moduler
2. Fuld argument-validering
3. Tests for alle subkommandoer
4. Kørsel på både macOS og Linux
