# Dag 3 — Hvordan man laver en `realpath` i ren Bash

## Hvad du lærer i dag
- Problemet med `realpath` på tværs af platforme
- Implementering af cross-platform `realpath_bash()`

---

## Problemet

| Platform | `realpath` tilgængelig? |
|----------|------------------------|
| Linux | Ja, som standard |
| macOS | Nej (kræver `brew install coreutils`) |
| WSL | Varierer |
| Git Bash | Nej |

Du kan ikke bruge `realpath` direkte i lib-bash — det bryder på macOS.

---

## Løsningen: `realpath_bash()`

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

### Hvad den gør trin for trin

1. `dirname -- "$path"` — finder mappen
2. `cd -- "..."` — skifter midlertidigt til den mappe (i en subshell via `$()`)
3. `pwd` — printer den absolutte sti til mappen
4. `basename -- "$path"` — tager kun filnavnet
5. Sætter dem sammen med `/`

### `--` beskytter mod stier med `-`

Hvis en sti starter med `-`, kan `cd`, `dirname`, `basename` fejlfortolke den som et flag.
`--` fortæller kommandoen: "herefter er der ingen flags, kun argumenter."

---

## Brug

```bash
ABS_PATH="$(realpath_bash "${BASH_SOURCE[0]}")"
echo "$ABS_PATH"
```

---

## Hvad du får

- Absolut sti (ingen `../..` i stien)
- Virker på macOS, Linux, WSL, Git Bash
- Ingen externe dependencies

---

## Øvelse

Tilføj `realpath_bash()` til et testscript. Kald den med:
1. En relativ sti: `./scripts/myscript.sh`
2. En sti med `../`: `../otherdir/file.sh`
3. `${BASH_SOURCE[0]}`

Print resultatet og verificer at stien er absolut.
