# Dag 12 — Funktioner: definering, parametre og returværdier

## Hvad du lærer i dag
- Definer og kald funktioner
- Parametre og `$@` vs `$*`
- Returværdier med exit codes og `echo`

---

## Definer og kald en funktion

```bash
hilsen() {
    echo "Hej, $1!"
}

hilsen "Theodor"    # → Hej, Theodor!
```

---

## Parametre

Inden i en funktion:

| Variabel | Indhold |
|----------|---------|
| `$1`, `$2`, ... | Positionale argumenter |
| `$@` | Alle argumenter som separate ord |
| `$*` | Alle argumenter som én streng |
| `$#` | Antal argumenter |
| `$0` | Scriptets navn (ikke funktionens!) |

```bash
vis_args() {
    echo "Antal: $#"
    for arg in "$@"; do
        echo "  - $arg"
    done
}

vis_args "et" "to tre" "fire"
# Antal: 3
#   - et
#   - to tre
#   - fire
```

**Brug altid `"$@"` — det bevarer argumenter med mellemrum.**

---

## Returværdi via exit code

```bash
er_fil() {
    local path="$1"
    [[ -f "$path" ]]    # returnerer 0 (sand) eller 1 (falsk)
}

if er_fil "/etc/hosts"; then
    echo "Filen eksisterer"
fi
```

`return N` sætter exit code. `0` = succes, `1-255` = fejl.

---

## Returværdi via echo (output capture)

```bash
hent_version() {
    local fil="$1"
    grep "^VERSION=" "$fil" | cut -d= -f2
}

VERSION="$(hent_version config.sh)"
echo "Version: $VERSION"
```

---

## `local` er obligatorisk

```bash
beregn() {
    local x="$1"
    local y="$2"
    local sum=$(( x + y ))
    echo "$sum"
}

resultat="$(beregn 3 4)"
echo "$resultat"    # → 7
```

Uden `local` ville `x`, `y`, og `sum` forurene det globale scope.

---

## Validation pattern

```bash
require_arg() {
    local name="$1"
    local value="$2"

    if [[ -z "$value" ]]; then
        echo "FEJL: Argument '$name' er påkrævet" >&2
        return 1
    fi
}

deploy() {
    local env="$1"
    require_arg "env" "$env" || return 1
    echo "Deployer til $env..."
}
```

---

## Øvelse

Skriv en funktion `log_step()` der:
1. Tager et stepnummer og en besked
2. Printer `[Step N/M] besked` formateret
3. Holder styr på det totale antal steps (brug en global tæller)
4. Returnerer fejl-exit-code hvis stepnummeret overstiger det totale
