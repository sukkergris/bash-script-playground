# Dag 25 — Debugging i Bash

## Hvad du lærer i dag
- `set -x` og `PS4` til trace-output
- `trap DEBUG` til avanceret debugging
- Strategier til at isolere fejl

---

## `set -x` — trace mode

```bash
#!/usr/bin/env bash
set -x  # aktiver trace

x=5
y=3
echo $(( x + y ))

set +x  # deaktiver trace
```

Output:
```
+ x=5
+ y=3
++ (( x + y ))
+ echo 8
8
```

Hvert `+` = ét niveau af expansion.

---

## `PS4` — format trace-linjer

Standard `PS4` er `+ `. Tilpas den til at vise fil og linje:

```bash
export PS4='[${BASH_SOURCE[0]##*/}:${LINENO}] '
set -x
```

Output:
```
[script.sh:5] x=5
[script.sh:6] echo 8
```

Endnu mere detaljeret:
```bash
export PS4='+ $(date +"%T") [${BASH_SOURCE[0]##*/}:${LINENO}] '
```

---

## Aktiver trace for én funktion

```bash
debug_funktion() {
    set -x
    # ... funktionskode ...
    set +x
}
```

---

## Kør script i debug-mode

```bash
bash -x script.sh             # trace alt
bash -xv script.sh            # trace + print hver linje før expansion
```

---

## Isolér fejl med subshells

```bash
echo "Tester modul X:"
(
    set -x
    source lib-bash/logging.sh
    log_info "test"
)
echo "Test afsluttet"
```

---

## Print variable hurtigt

```bash
# Quick debug-print til stderr
dbg() {
    echo "DBG [${FUNCNAME[1]}:${BASH_LINENO[0]}] $*" >&2
}

# Brug:
dbg "x=$x, y=$y"
dbg "array=${array[*]}"
```

---

## Tjek hvilken linje der fejler

```bash
trap 'echo "Fejl på linje $LINENO: $BASH_COMMAND" >&2' ERR
```

---

## Strategier

### 1. Isolér — kør fejlende del alene
### 2. Forenkl — fjern alt udover det fejlende
### 3. Trace — brug `set -x` rundt om fejlstedet
### 4. Print — brug `dbg()` til at inspicere tilstand
### 5. Sammenlign — hvad forventer du? Hvad sker der faktisk?

```bash
forventet="hello world"
faktisk="$(hent_besked)"

if [[ "$forventet" != "$faktisk" ]]; then
    echo "MISMATCH:" >&2
    echo "  Forventet: $(printf '%q' "$forventet")" >&2
    echo "  Faktisk:   $(printf '%q' "$faktisk")" >&2
fi
```

`printf '%q'` viser usynlige tegn (tabs, newlines, etc.) tydeligt.

---

## `shellcheck` — statisk analyse

```bash
shellcheck script.sh        # find potentielle fejl
shellcheck -x script.sh     # følg source-kommandoer
```

Installer: `brew install shellcheck` / `apt install shellcheck`

---

## Øvelse

Tag et af dine scripts fra de foregående dage og:
1. Tilpas `PS4` med fil og linje
2. Aktiver `set -x` for den mest komplekse funktion
3. Kør scriptet og forstå hvert trace-linje
4. Tilføj en `dbg()`-funktion og brug den 3 steder
