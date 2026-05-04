# Dag 4 — Cross-platform script-loader

## Hvad du lærer i dag
- Den korrekte måde at bygge en robust script-loader på
- Hvorfor hvert element i loaderen er nødvendigt

---

## Den færdige loader

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"

# Load moduler
source "$SCRIPT_DIR/../lib-bash/error-handling.sh"
source "$SCRIPT_DIR/../lib-bash/logging.sh"
source "$SCRIPT_DIR/../lib-bash/os-detection.sh"
```

---

## Analyse af hver linje

### `#!/usr/bin/env bash`
Finder `bash` i PATH — virker på alle platforme, selv hvis bash ligger et andet sted end `/bin/bash`.

### `set -euo pipefail`
- `-e` — stop ved fejl
- `-u` — stop ved udefinerede variabler
- `-o pipefail` — stop hvis noget i en pipe fejler (ikke kun det sidste led)

### `SCRIPT_PATH="${BASH_SOURCE[0]}"`
Gemmer stien til den faktiske fil (ikke symlinken, ikke `$0`).

### `cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd`
1. `dirname` — finder mappen for filen
2. `cd` — skifter til den mappe (i subshell)
3. `pwd` — returnerer absolut sti
4. `--` — beskytter mod stier der starter med `-`

---

## Hvorfor den virker overalt

| Scenario | Virker? |
|----------|---------|
| Direkte kørsel (`./script.sh`) | Ja |
| Via PATH (`script.sh`) | Ja |
| Via symlink | Ja |
| Sourced fra et andet script | Ja |
| Fra CI/CD | Ja |
| macOS, Linux, WSL, Git Bash | Ja |

---

## Resultat

Du får en deterministisk loader, der altid ved hvor dine moduler ligger.

---

## Øvelse

Byg et script der loader alle tre lib-bash-moduler via denne loader og kalder `log_info`, `log_warn`, `log_error`, `log_ok` og `detect_os`.
