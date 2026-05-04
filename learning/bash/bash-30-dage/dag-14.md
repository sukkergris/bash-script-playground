# Dag 14 — `set -euo pipefail` — hvad det faktisk gør

## Hvad du lærer i dag
- Hvad hver del af `set -euo pipefail` gør
- Pitfalls og undtagelser du skal kende
- Hvornår du skal deaktivere det midlertidigt

---

## `set -e` — stop ved fejl

Bashscriptet stopper øjeblikkeligt hvis en kommando returnerer ikke-nul exit code.

```bash
set -e

mkdir /tmp/work
cd /nonexistent   # → script stopper her
echo "Aldrig nået"
```

### Undtagelser for `-e`

`-e` aktiveres IKKE ved:
- Kommandoer i `if`-betingelser: `if grep ...; then`
- Kommandoer med `||` eller `&&`
- Kommandoer i `while`/`until`-betingelser
- Negerede kommandoer: `! kommando`

```bash
# Disse stopper IKKE scriptet selv med -e:
grep "noget" fil || true
if ls /nonexistent; then echo "fundet"; fi
```

---

## `set -u` — stop ved udefinerede variabler

```bash
set -u

echo "$UDEFINERET"    # → bash: UDEFINERET: unbound variable → script stopper
```

### Undgå `-u` fejl med standardværdier

```bash
# Brug :- for at give en standardværdi
navn="${NAVN:-ukendt}"

# Brug :? for at fejle med en besked
db="${DATABASE_URL:?'DATABASE_URL er påkrævet'}"
```

---

## `set -o pipefail` — stop ved fejl i pipe

Uden `pipefail` er exit code fra en pipe altid exit code fra den SIDSTE kommando.

```bash
# Uden pipefail:
cat /nonexistent | grep "noget"
echo $?     # → 1 (fra grep, ikke fra cat)

# Med pipefail:
set -o pipefail
cat /nonexistent | grep "noget"
# → script stopper ved cat's fejl
```

---

## Midlertidig deaktivering

Til kommandoer der forventes at fejle:

```bash
# Deaktivér -e midlertidigt
set +e
kommando_der_måske_fejler
kode=$?
set -e

# Eller brug || true
kommando_der_måske_fejler || true

# Eller brug subshell
(set +e; kommando_der_måske_fejler; echo $?)
```

---

## Komplet anbefalet header

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
```

Denne kombination fanger de fleste fejl automatisk og gør scripts meget mere robuste.

---

## Sammenligning: med og uden

| Scenario | Uden `set -euo pipefail` | Med |
|----------|--------------------------|-----|
| Udefineret variabel | Stille fejl, tom string | Script stopper med fejl |
| Kommando fejler | Script fortsætter | Script stopper |
| Pipe-fejl midt i pipe | Ignoreres | Script stopper |

---

## Øvelse

Tag et eksisterende script og tilføj `set -euo pipefail`. Identificer og ret alle steder hvor scriptet nu fejler — forstå hvorfor hvert sted fejlede.
