# Dag 5 — Variabler og scoping i Bash

## Hvad du lærer i dag
- Hvordan variabler virker i Bash
- Forskellen på globale og lokale variabler
- `local`, `readonly`, og `export`

---

## Grundlæggende variabler

```bash
#!/usr/bin/env bash
set -euo pipefail

navn="Theodor"
alder=30

echo "Navn: $navn, alder: $alder"
```

**Ingen mellemrum** omkring `=` — det er et syntax-krav i Bash.

---

## Lokale variabler i funktioner

Uden `local` er alle variabler globale:

```bash
sæt_navn() {
    navn="Overwritten"   # global — ændrer den udefra!
}

navn="Original"
sæt_navn
echo "$navn"   # → "Overwritten"
```

Med `local` er variablen begrænset til funktionen:

```bash
sæt_navn() {
    local navn="Lokal"
    echo "Inde i funktionen: $navn"
}

navn="Global"
sæt_navn
echo "Udenfor: $navn"   # → "Global" — uændret
```

**Brug altid `local` inde i funktioner.**

---

## `readonly` — konstanter

```bash
readonly MAX_RETRIES=3
MAX_RETRIES=5   # fejler! bash: MAX_RETRIES: readonly variable
```

Brug `readonly` til konfigurationsværdier der ikke må ændres.

---

## `export` — videre til child-processer

```bash
export DATABASE_URL="postgres://localhost/mydb"
bash -c 'echo $DATABASE_URL'   # → postgres://localhost/mydb
```

Uden `export` ser child-processer ikke variablen:
```bash
SECRET="hemmelig"
bash -c 'echo $SECRET'   # → (tom)
```

---

## `unset` — slet en variabel

```bash
navn="Theodor"
unset navn
echo "${navn:-ikke sat}"   # → "ikke sat"
```

---

## Opsummering

| Nøgleord | Hvad det gør |
|----------|-------------|
| (ingen) | Global variabel |
| `local` | Kun synlig i funktionen |
| `readonly` | Kan ikke overskrives |
| `export` | Synlig i child-processer |
| `unset` | Sletter variablen |

---

## Øvelse

Skriv en funktion `build_path()` der:
1. Tager en mappe og et filnavn som argumenter
2. Bruger `local` til alle interne variabler
3. Returnerer den sammensatte sti via `echo`
