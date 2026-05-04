
# Bash for Ingeniører: Grundbog & 30-dages Læringsplan

Her får du alle fire dele, hver som sit eget kapitel, skrevet i et Obsidian‑venligt format med klare forklaringer og eksempler.
Det er skrevet til dig som begynder i Bash, men med den ingeniør‑dybde du foretrækker.

---

## Kapitel 1 — Forskellen på `$0` og `${BASH_SOURCE[0]}`

**`$0` — entrypointet (hvordan scriptet blev kaldt)**

$0 indeholder navnet på det script der blev startet, set fra brugerens perspektiv.

Det kan være:

- ./run.sh
- scripts/run.sh
- /Users/theodor/run.sh
- run.sh (hvis det ligger i PATH)
- en symlink til scriptet

**Vigtigt:** `$0` ændrer sig afhængigt af hvordan du starter scriptet.

**Eksempel:**

```bash
echo "$0"
```

Hvis du kører:

```bash
/usr/local/bin/myscript
```

så viser `$0`:

```bash
/usr/local/bin/myscript
```

Selvom den rigtige fil måske ligger et helt andet sted.

---

**`${BASH_SOURCE[0]}` — den fysiske fil (hvor koden ligger)**

`${BASH_SOURCE[0]}` indeholder den faktiske sti til filen, uanset:

- hvordan den blev kaldt
- om den blev sourced
- om den blev symlinket
- om du kører den via PATH
- om du kører den fra en anden mappe

Det er derfor vi bruger `${BASH_SOURCE[0]}` i alle moduler.

**Eksempel:**

```bash
echo "${BASH_SOURCE[0]}"
```

→ viser altid den rigtige fil.

---

## Kort opsummering

| Variabel | Hvad den viser | Bruges til |
| --- | --- | --- |
| $0 | hvordan scriptet blev kaldt | CLI‑navn, help‑tekster |
| ${BASH_SOURCE[0]} | hvor filen faktisk ligger | modul‑loading, paths |

---

## Kapitel 2 — Hvorfor symlinks kan ødelægge `$0`

Forestil dig:

```text
/usr/local/bin/myscript -> /Users/theodor/project/scripts/myscript.sh
```

Når du kører:

```bash
myscript
```

så bliver `$0`:

```bash
/usr/local/bin/myscript
```

Men scriptet ligger i:

```bash
/Users/theodor/project/scripts/myscript.sh
```

**Problemet:**

Hvis du bruger:

```bash
SCRIPT_DIR="$(dirname "$0")"
```

så tror scriptet, at det ligger i `/usr/local/bin/`.

Det betyder:

- du loader moduler fra det forkerte sted
- relative paths bliver forkerte
- tests fejler
- logging viser forkerte stier

**Løsningen:**

Brug aldrig `$0` til at finde scriptets placering. Brug `${BASH_SOURCE[0]}`.

---

## Kapitel 3 — Hvordan man laver en “realpath” i ren Bash

macOS har ikke realpath som standard.
Linux har.
Windows/WSL er uforudsigelig.
Derfor laver vi vores egen, cross‑platform:

```bash
realpath_bash() {
    local path="$1"
    local dir
    local file

    dir="$(cd -- "$(dirname -- "$path")" && pwd)"
    file="$(basename -- "$path")"

    echo "$dir/$file"
}
```

**Brug:**

```bash
ABS_PATH="$(realpath_bash "${BASH_SOURCE[0]}")"
```

**Hvad du får:**

- absolut sti
- uden relative elementer
- uden symlinks
- virker på macOS, Linux, WSL, Git Bash

---


## Ekstra: Robust fejlhåndtering i Bash

### Brug altid `set -Eeuo pipefail`

Tilføj `-E` til dine scripts, så din `trap ... ERR` også virker i funktioner, subshells og command substitutions. Uden `-E` fanger du kun fejl i toplevel, og mister fejlhåndtering i netop de steder, hvor scripts ofte fejler.

**Eksempel:**

```bash
set -Eeuo pipefail
trap '__on_error "$?" "$BASH_COMMAND" "${BASH_LINENO[0]}"' ERR
```

### Brug `${BASH_LINENO[0]}` for præcis linjeinfo

`$LINENO` viser linjen, hvor trappen blev udløst, ikke nødvendigvis hvor fejlen faktisk skete (især i funktioner og call stacks). `${BASH_LINENO[0]}` peger på linjen, hvor fejlen opstod, hvilket gør debugging hurtigere og mere præcis.

**Eksempel på fejlhåndteringsfunktion:**

```bash
__on_error() {
    local exit_code="$1"
    local cmd="$2"
    local line="$3"
    printf "\033[0;31m[ERROR]\033[0m Exit code %s at line %s: %s\n" \
        "$exit_code" "$line" "$cmd" >&2
    exit "$exit_code"
}
trap '__on_error "$?" "$BASH_COMMAND" "${BASH_LINENO[0]}"' ERR
```

**Fordele:**

- Fejl fanges altid, også i funktioner og subshells
- Linjenummeret er altid korrekt
- Debugging bliver hurtigere og mere pålidelig

Dette gør din fejlhåndtering robust og produktionsegnet – ikke kun “nice to have”.

---

## Kapitel 4 — Hvordan man bygger en cross‑platform script‑loader

Dette er den korrekte, robuste og industristærke måde at finde scriptets mappe på:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"

### Load moduler

source "$SCRIPT_DIR/../bash-lib/error-handling.sh"
source "$SCRIPT_DIR/../bash-lib/logging.sh"
source "$SCRIPT_DIR/../bash-lib/os-detection.sh"
```

**Hvorfor den virker:**

- `${BASH_SOURCE[0]}` → den rigtige fil, ikke symlink
- dirname → finder mappen
- cd + pwd → gør stien absolut
- -- → beskytter mod stier der starter med -
- virker i:
    - macOS
    - Linux
    - WSL
    - Git Bash
    - CI/CD
    - symlinkede scripts
    - sourced scripts

**Resultat:**

Du får en deterministisk loader, der altid ved hvor dine moduler ligger.

---


---

🔥 Hvis du vil, kan jeg lave:

- et Obsidian‑diagram over hele script‑loading flowet
- en script‑generator der automatisk laver loader + header
- et test‑script der demonstrerer forskellen på $0 og ${BASH_SOURCE[0]}
- en Bash‑styleguide til dit projekt

Sig hvad du vil have næste.

---

## 30-dages Bash-læringsplan

Filer ligger i `.evanescence/bash-30-dage/`.

| Dag | Fil | Emne |
| --- | --- | --- |
| 1 | [dag-01.md](../../.evanescence/bash-30-dage/dag-01.md) | `$0` vs `${BASH_SOURCE[0]}` |
| 2 | [dag-02.md](../../.evanescence/bash-30-dage/dag-02.md) | Symlinks og `$0` |
| 3 | [dag-03.md](../../.evanescence/bash-30-dage/dag-03.md) | `realpath` i ren Bash |
| 4 | [dag-04.md](../../.evanescence/bash-30-dage/dag-04.md) | Cross-platform script-loader |
| 5 | [dag-05.md](../../.evanescence/bash-30-dage/dag-05.md) | Variabler og scoping |
| 6 | [dag-06.md](../../.evanescence/bash-30-dage/dag-06.md) | Strings og parameter expansion |
| 7 | [dag-07.md](../../.evanescence/bash-30-dage/dag-07.md) | Arrays og associative arrays |
| 8 | [dag-08.md](../../.evanescence/bash-30-dage/dag-08.md) | Aritmetik med `(( ))` og `$(( ))` |
| 9 | [dag-09.md](../../.evanescence/bash-30-dage/dag-09.md) | Betingede udtryk og `[[ ]]` |
| 10 | [dag-10.md](../../.evanescence/bash-30-dage/dag-10.md) | `for`-loops |
| 11 | [dag-11.md](../../.evanescence/bash-30-dage/dag-11.md) | `while` og `until` loops |
| 12 | [dag-12.md](../../.evanescence/bash-30-dage/dag-12.md) | Funktioner, parametre og returværdier |
| 13 | [dag-13.md](../../.evanescence/bash-30-dage/dag-13.md) | Exit codes og fejlhåndtering |
| 14 | [dag-14.md](../../.evanescence/bash-30-dage/dag-14.md) | `set -euo pipefail` — hvad det gør |
| 15 | [dag-15.md](../../.evanescence/bash-30-dage/dag-15.md) | ERR-traps og cleanup med `trap` |
| 16 | [dag-16.md](../../.evanescence/bash-30-dage/dag-16.md) | Input/output omdirigering |
| 17 | [dag-17.md](../../.evanescence/bash-30-dage/dag-17.md) | Pipes og process substitution |
| 18 | [dag-18.md](../../.evanescence/bash-30-dage/dag-18.md) | Subshells og forked processer |
| 19 | [dag-19.md](../../.evanescence/bash-30-dage/dag-19.md) | Miljøvariabler og konfigurationsmønstre |
| 20 | [dag-20.md](../../.evanescence/bash-30-dage/dag-20.md) | Fil-tests og fil-operationer |
| 21 | [dag-21.md](../../.evanescence/bash-30-dage/dag-21.md) | Tekstprocessering med `grep` |
| 22 | [dag-22.md](../../.evanescence/bash-30-dage/dag-22.md) | `sed` — stream editing |
| 23 | [dag-23.md](../../.evanescence/bash-30-dage/dag-23.md) | `awk` — tekst-transformation |
| 24 | [dag-24.md](../../.evanescence/bash-30-dage/dag-24.md) | Regular expressions og `BASH_REMATCH` |
| 25 | [dag-25.md](../../.evanescence/bash-30-dage/dag-25.md) | Debugging med `set -x` og `PS4` |
| 26 | [dag-26.md](../../.evanescence/bash-30-dage/dag-26.md) | Signal handling og graceful shutdown |
| 27 | [dag-27.md](../../.evanescence/bash-30-dage/dag-27.md) | Job control og baggrunds-processer |
| 28 | [dag-28.md](../../.evanescence/bash-30-dage/dag-28.md) | OS-detection og cross-platform scripts |
| 29 | [dag-29.md](../../.evanescence/bash-30-dage/dag-29.md) | Testing i Bash uden frameworks |
| 30 | [dag-30.md](../../.evanescence/bash-30-dage/dag-30.md) | Byg en komplet CLI-tool |
