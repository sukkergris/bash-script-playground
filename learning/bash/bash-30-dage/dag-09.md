# Dag 9 — Betingede udtryk: `if`, `[[ ]]`, og test-operatorer

## Hvad du lærer i dag
- `if`/`elif`/`else` struktur
- `[[ ]]` vs `[ ]` — hvad du skal bruge
- Alle vigtige test-operatorer

---

## Grundstruktur

```bash
if [[ betingelse ]]; then
    # gør noget
elif [[ anden_betingelse ]]; then
    # gør noget andet
else
    # fallback
fi
```

---

## `[[ ]]` vs `[ ]`

**Brug altid `[[ ]]`** i moderne Bash-scripts.

| Feature | `[[ ]]` | `[ ]` |
|---------|---------|-------|
| Glob-matching | Ja (`[[ $f == *.sh ]]`) | Nej |
| Regex-matching | Ja (`[[ $s =~ ^[0-9]+$ ]]`) | Nej |
| `&&` og `\|\|` | Ja | Nej (`-a`/`-o`) |
| Quoting af variabler | Ikke nødvendigt | Påkrævet |
| Del af Bash | Ja (builtin) | Posix-kompatibel |

---

## Strengsammenligninger

```bash
navn="Theodor"

[[ "$navn" == "Theodor" ]]      # lig med
[[ "$navn" != "Alice" ]]        # forskellig fra
[[ "$navn" < "Z" ]]             # alfabetisk før
[[ -z "$navn" ]]                # tom streng
[[ -n "$navn" ]]                # ikke-tom streng

# Glob-matching
[[ "$navn" == The* ]]           # starter med "The"

# Regex-matching
[[ "$navn" =~ ^[A-Z] ]]         # starter med stort bogstav
```

---

## Fil-tests

```bash
[[ -e "$sti" ]]     # eksisterer (fil eller mappe)
[[ -f "$sti" ]]     # er en regulær fil
[[ -d "$sti" ]]     # er en mappe
[[ -r "$sti" ]]     # er læsbar
[[ -w "$sti" ]]     # er skrivbar
[[ -x "$sti" ]]     # er eksekverbar
[[ -s "$sti" ]]     # er ikke tom (størrelse > 0)
[[ -L "$sti" ]]     # er et symlink
```

---

## Logiske operatorer

```bash
if [[ -f "$fil" && -r "$fil" ]]; then
    echo "Filen eksisterer og er læsbar"
fi

if [[ "$env" == "prod" || "$env" == "staging" ]]; then
    echo "Skarp miljø"
fi

if [[ ! -d "$mappe" ]]; then
    mkdir -p "$mappe"
fi
```

---

## Case-statement

```bash
os="macos"

case "$os" in
    macos)
        echo "Apple platform"
        ;;
    linux|ubuntu|debian)
        echo "Linux platform"
        ;;
    wsl)
        echo "Windows Subsystem for Linux"
        ;;
    *)
        echo "Ukendt platform: $os"
        ;;
esac
```

---

## Øvelse

Skriv en funktion `validate_config()` der:
1. Tjekker at en config-fil eksisterer og er læsbar
2. Tjekker at en URL-streng matcher mønsteret `http(s)://...`
3. Tjekker at en port er et tal mellem 1 og 65535
4. Udskriver fejl for hvert mislykket tjek
