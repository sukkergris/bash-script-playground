# Dag 7 — Arrays og associative arrays

## Hvad du lærer i dag
- Indekserede arrays (lister)
- Associative arrays (dictionaries/maps)
- Looping over arrays

---

## Indekserede arrays

```bash
# Opret array
farver=("rød" "grøn" "blå")

# Tilgå elementer
echo "${farver[0]}"         # → rød
echo "${farver[2]}"         # → blå
echo "${farver[-1]}"        # → blå (sidste element)

# Antal elementer
echo "${#farver[@]}"        # → 3

# Alle elementer
echo "${farver[@]}"         # → rød grøn blå

# Alle indekser
echo "${!farver[@]}"        # → 0 1 2
```

---

## Tilføj og fjern elementer

```bash
farver+=("gul")             # Tilføj element
unset 'farver[1]'           # Fjern element (sætter "hul" i array)

# Sluk for hullet — kopier til nyt array
farver=("${farver[@]}")
```

---

## Loop over array

```bash
for farve in "${farver[@]}"; do
    echo "Farve: $farve"
done

# Loop med indeks
for i in "${!farver[@]}"; do
    echo "$i: ${farver[$i]}"
done
```

**Brug altid `"${array[@]}"` med citationstegn** — ellers splitter Bash elementer med mellemrum.

---

## Associative arrays (Bash 4+)

```bash
declare -A config

config["host"]="localhost"
config["port"]="5432"
config["db"]="myapp"

echo "${config[host]}"          # → localhost
echo "${#config[@]}"            # → 3

# Alle nøgler
echo "${!config[@]}"            # → host port db

# Loop over nøgler og værdier
for key in "${!config[@]}"; do
    echo "$key = ${config[$key]}"
done
```

---

## Praktisk eksempel: samle fejl

```bash
declare -a errors=()

check_file() {
    local file="$1"
    [[ -f "$file" ]] || errors+=("Mangler fil: $file")
}

check_file "/etc/hosts"
check_file "/nonexistent"
check_file "/etc/passwd"

if [[ ${#errors[@]} -gt 0 ]]; then
    echo "Fejl fundet:"
    for err in "${errors[@]}"; do
        echo "  - $err"
    done
fi
```

---

## Øvelse

Byg en funktion `build_env_map()` der:
1. Læser en liste af `NØGLE=VÆRDI` strenge
2. Gemmer dem i et associative array
3. Printer alle nøgler og værdier pænt formateret
