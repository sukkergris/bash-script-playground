# Dag 8 — Aritmetik i Bash

## Hvad du lærer i dag
- Heltalstalsberegning med `(( ))` og `$(( ))`
- Sammenligninger med tal
- Hvornår du skal bruge `bc` til decimaltal

---

## `(( ))` — aritmetisk kontekst

```bash
x=5
y=3

(( sum = x + y ))
echo "$sum"         # → 8

(( x++ ))           # increment
echo "$x"           # → 6

(( y -= 1 ))
echo "$y"           # → 2
```

`(( ))` returnerer exit code 0 hvis resultatet er ikke-nul, 1 hvis nul.

---

## `$(( ))` — aritmetisk substitution

```bash
echo $(( 10 / 3 ))          # → 3 (heltalsdivision)
echo $(( 10 % 3 ))          # → 1 (modulo/rest)
echo $(( 2 ** 8 ))          # → 256 (eksponent)

radius=5
areal=$(( radius * radius * 3 ))    # groft π ≈ 3
echo "Areal ≈ $areal"
```

---

## Sammenligninger i aritmetisk kontekst

```bash
x=10

if (( x > 5 )); then
    echo "x er større end 5"
fi

if (( x >= 10 && x <= 20 )); then
    echo "x er mellem 10 og 20"
fi
```

**I `(( ))` bruges `>`, `<`, `>=`, `<=`, `==`, `!=`.**
I `[[ ]]` bruges `-gt`, `-lt`, `-ge`, `-le`, `-eq`, `-ne` for tal.

---

## Tabel: sammenligningsoperatorer

| `(( ))` | `[[ ]]` / `[ ]` | Betydning |
|---------|-----------------|-----------|
| `==` | `-eq` | lig med |
| `!=` | `-ne` | forskellig fra |
| `>` | `-gt` | større end |
| `>=` | `-ge` | større end eller lig |
| `<` | `-lt` | mindre end |
| `<=` | `-le` | mindre end eller lig |

---

## Decimaltal med `bc`

Bash understøtter kun heltal. Brug `bc` til decimaltal:

```bash
result=$(echo "scale=2; 10 / 3" | bc)
echo "$result"          # → 3.33

pi=$(echo "scale=5; 4*a(1)" | bc -l)
echo "$pi"              # → 3.14159
```

---

## Praktisk: tæl filer og vis status

```bash
total=$(find . -name "*.sh" | wc -l)
max=10

if (( total > max )); then
    echo "For mange scripts: $total (max $max)"
elif (( total == 0 )); then
    echo "Ingen scripts fundet"
else
    echo "$total scripts fundet"
fi
```

---

## Øvelse

Skriv en funktion `beregn_diskbrug()` der:
1. Tager en procent (0-100) som argument
2. Udskriver en besked baseret på om det er under 50%, 50-80%, eller over 80%
3. Bruger `(( ))` til alle sammenligninger
