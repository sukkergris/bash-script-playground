# Dag 20 — Fil-tests og fil-operationer

## Hvad du lærer i dag
- Alle vigtige fil-test operatorer
- Sikre mønstre for fil-operationer
- Atomiske operationer og race conditions

---

## Fil-test operatorer

```bash
[[ -e "$sti" ]]     # eksisterer (fil, mappe, symlink, etc.)
[[ -f "$sti" ]]     # regulær fil
[[ -d "$sti" ]]     # mappe
[[ -L "$sti" ]]     # symlink
[[ -r "$sti" ]]     # læsbar
[[ -w "$sti" ]]     # skrivbar
[[ -x "$sti" ]]     # eksekverbar
[[ -s "$sti" ]]     # eksisterer og er ikke tom
[[ -O "$sti" ]]     # ejet af den aktuelle bruger
[[ -G "$sti" ]]     # tilhører den aktuelle gruppe
```

---

## Sammenlign filer

```bash
[[ "$fil1" -nt "$fil2" ]]   # fil1 er nyere end fil2 (newer than)
[[ "$fil1" -ot "$fil2" ]]   # fil1 er ældre end fil2 (older than)
[[ "$fil1" -ef "$fil2" ]]   # fil1 og fil2 er den samme fil (inode)
```

---

## Sikre mønstre

### Opret mappe hvis den ikke eksisterer

```bash
ensure_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir"
}
```

### Kopier fil med backup

```bash
safe_copy() {
    local src="$1"
    local dst="$2"

    [[ -f "$src" ]] || { echo "Kilde eksisterer ikke: $src" >&2; return 1; }

    if [[ -f "$dst" ]]; then
        cp "$dst" "${dst}.bak"
    fi
    cp "$src" "$dst"
}
```

### Atomisk skriv (temp-fil + rename)

```bash
atomisk_skriv() {
    local fil="$1"
    local indhold="$2"
    local tmp

    tmp="$(mktemp "${fil}.tmp.XXXXXX")"
    echo "$indhold" > "$tmp"
    mv "$tmp" "$fil"    # mv er atomisk på samme filesystem
}
```

---

## `mktemp` — sikre midlertidige filer

```bash
# Midlertidig fil
tmp_fil="$(mktemp)"
trap "rm -f '$tmp_fil'" EXIT

# Midlertidig mappe
tmp_dir="$(mktemp -d)"
trap "rm -rf '$tmp_dir'" EXIT

# Med prefix og suffix
tmp="$(mktemp /tmp/myapp.XXXXXX.json)"
```

`XXXXXX` erstattes med tilfældig streng — sikrer unikke navne.

---

## Søg i filer

```bash
# Find filer nyere end N dage
find . -name "*.log" -mtime +7 -delete

# Find store filer
find . -size +10M -type f

# Find filer med specifikt indhold
grep -rl "TODO" . --include="*.sh"
```

---

## Fil-permissions

```bash
# Sæt permissions
chmod 755 script.sh
chmod u+x,go-w script.sh

# Tjek permissions numerisk
stat -c "%a" script.sh      # Linux
stat -f "%OLp" script.sh    # macOS

# Tjek om eksekverbar
[[ -x "script.sh" ]] || chmod +x "script.sh"
```

---

## Øvelse

Skriv en funktion `safe_backup()` der:
1. Tager en kilde-fil og en backup-mappe
2. Opretter backup-mappen hvis den ikke eksisterer
3. Kopierer filen med dato i filnavnet: `original.sh.2024-01-15`
4. Holder kun de 5 seneste backups (slet ældste)
5. Returnerer fejl hvis kilde-filen ikke eksisterer
