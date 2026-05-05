# Dag 1 — `$0` vs `${BASH_SOURCE[0]}`

## Hvad du lærer i dag

- Forskellen på `$0` og `${BASH_SOURCE[0]}`
- Hvornår du skal bruge hvilken variabel

---

## `$0` — entrypointet (hvordan scriptet blev kaldt)

`$0` indeholder navnet på det script der blev startet, set fra brugerens perspektiv.

Det kan være:

- `./run.sh`
- `scripts/run.sh`
- `/Users/theodor/run.sh`
- `run.sh` (hvis det ligger i PATH)
- en symlink til scriptet

**Vigtigt:** `$0` ændrer sig afhængigt af hvordan du starter scriptet.

### Eksempel $0

`$0` er ikke noget du sætter — Bash sætter den automatisk til præcis det du skrev for at starte scriptet.

Lav en testfil:

```bash
cat > /tmp/vis-nul.sh <<'EOF'
#!/usr/bin/env bash
echo "$0"
EOF
chmod +x /tmp/vis-nul.sh
```

Kør nu det samme script på tre forskellige måder:

```bash
/tmp/vis-nul.sh          # absolut sti
cd /tmp && ./vis-nul.sh  # relativ sti
cd /tmp && bash vis-nul.sh  # via bash
```

Output:

```text
/tmp/vis-nul.sh
./vis-nul.sh
vis-nul.sh
```

`$0` afspejler nøjagtigt det du tastede — ikke filens "rigtige" placering på disken.
Det er nyttigt til usage-beskeder (`echo "Brug: $0 <fil>"`), men upålideligt hvis du vil finde ud af, hvor scriptet faktisk ligger.

---

## `${BASH_SOURCE[0]}` — filen Bash læser lige nu

`${BASH_SOURCE[0]}` viser, hvilken fil den aktuelle Bash-kode kommer fra.

Det gør den nyttig når:

- en fil bliver sourced
- kode ligger i et modul
- du vil finde mappen, filen selv ligger i

**Vigtigt:** `${BASH_SOURCE[0]}` er ikke nødvendigvis en absolut sti, og Bash opløser ikke automatisk symlinks for dig.

Det er derfor vi ofte bruger `${BASH_SOURCE[0]}` som udgangspunkt og derefter normaliserer stien med `cd ... && pwd`.

### Eksempel ${BASH_SOURCE[0]}

```bash
echo "${BASH_SOURCE[0]}"
```

Hvis filen bliver sourced, peger den på den sourcede fil.
Hvis scriptet bliver kørt via en relativ sti eller symlink, ser du normalt netop den sti Bash blev givet.

Praktisk mini-test:

```bash
# 1) Lav testfil
cat > /tmp/bsrc-demo.sh <<'EOF'
#!/usr/bin/env bash
echo "\$0                = $0"
echo "\${BASH_SOURCE[0]} = ${BASH_SOURCE[0]}"
EOF
chmod +x /tmp/bsrc-demo.sh

# 2) Kør direkte
/tmp/bsrc-demo.sh

# 3) Kør via source
source /tmp/bsrc-demo.sh

# 4) Kør via symlink
ln -sf /tmp/bsrc-demo.sh /tmp/bsrc-link
/tmp/bsrc-link
```

Typisk observation:

- Direkte kørsel: `$0` og `${BASH_SOURCE[0]}` ligner ofte hinanden.
- `source`: `$0` er shellens navn, `${BASH_SOURCE[0]}` er den sourcede fil.
- Symlink: begge viser typisk symlink-stien, medmindre du selv normaliserer den.

To hurtige eksempler:

Eksempel A (direkte kørsel):

```bash
/tmp/bsrc-demo.sh
```

Typisk output:

```text
$0                = /tmp/bsrc-demo.sh
${BASH_SOURCE[0]} = /tmp/bsrc-demo.sh
```

Forklaring: Her er entrypoint og aktuel kildefil den samme, så de to værdier ligner hinanden.

Eksempel B (source):

```bash
source /tmp/bsrc-demo.sh
```

Typisk output:

```text
$0                = bash
${BASH_SOURCE[0]} = /tmp/bsrc-demo.sh
```

Forklaring: Ved `source` bliver filen kørt i den nuværende shell. Derfor peger `$0` på shellen, mens `${BASH_SOURCE[0]}` peger på filen.

---

## `bash-lib/stack.sh` — se stakken indefra

`bsrc-demo.sh` viste kun to variable. `bash-lib/stack.sh` bruger en funktion til at printe fem felter på én gang:

```bash
a() {
  local i=$((${#FUNCNAME} - 1))
  cat << EOF
  bash_source[0]: ${BASH_SOURCE[0]}
  \$0: $0
  file: ${BASH_SOURCE[i+1]}
  function: ${FUNCNAME[i]}
  executed at: ${BASH_LINENO[i]}
EOF
}

a
```

### Direkte kørsel

```bash
./bash-lib/stack.sh
```

Output:

```text
  bash_source[0]: ./bash-lib/stack.sh
  $0: ./bash-lib/stack.sh
  file: ./bash-lib/stack.sh
  function: a
  executed at: 15
```

### Via source

```bash
source ./bash-lib/stack.sh
```

Output:

```text
  bash_source[0]: ./bash-lib/stack.sh
  $0: bash
  file: ./bash-lib/stack.sh
  function: a
  executed at: 15
```

Den eneste forskel er `$0`. Resten er identisk — koden er den samme fil, kaldet på den samme linje.

---

### Hvad betyder hvert felt?

**`bash_source[0]`** — hvilken fil definerer den kørende funktion

`BASH_SOURCE[0]` er altid den fil Bash kigger i lige nu. Her peger den på `stack.sh`, fordi det er der `a()` er defineret. Det ændrer sig ikke ved `source`.

**`$0`** — hvordan shellen blev startet

Ved direkte kørsel starter Bash en ny proces med scriptet som entrypoint, så `$0` er filnavnet. Ved `source` kører koden i din nuværende shell — og den shell startede med `bash` — så `$0` er `bash`.

Tommelfingerregel: `$0` er det du ville se i `ps` for den proces der kører koden.

**`file`** — hvilken fil indeholder selve kaldet `a`

Feltet viser `BASH_SOURCE[1]`, dvs. den fil der kalder `a()`. Her er det `stack.sh` igen, fordi `a` kaldes på linje 15 i den samme fil.

Hvis `a()` blev kaldt fra et andet script, ville `file` vise det scripts sti i stedet.

**`function`** — hvilken funktion er aktiv

Her ser du `a`. Det er `FUNCNAME[0]` — den funktion der kører lige nu.

**`executed at`** — linjennummeret for kaldet

`BASH_LINENO[0]` er linjenummeret inde i kalderen, hvor `a` bliver kaldt. Linje 15 i `stack.sh` er netop `a`.

---

### Dybere stak efter source

Når du bruger `source`, bliver `a()` tilgængelig i din nuværende shell. Kald den inde fra en anden funktion for at se `file`-feltet ændre sig:

```bash
source ./bash-lib/stack.sh   # definerer a() og kører den én gang (linje 15)

outer() {
  a
}
outer
```

Det første output kommer fra `source`-kaldet (linje 15 i stack.sh):

```text
  bash_source[0]: ./bash-lib/stack.sh
  $0: bash
  file: ./bash-lib/stack.sh
  function: a
  executed at: 15
```

Det andet output kommer fra `outer → a`:

```text
  bash_source[0]: ./bash-lib/stack.sh
  $0: bash
  file: environment
  function: a
  executed at: 1
```

Bemærk `file: environment` — Bash bruger `environment` som filnavn for funktioner defineret direkte i shellen (ikke indlæst fra en fil). `bash_source[0]` peger stadig på `stack.sh`, fordi det er der `a()` er defineret, uanset hvem der kalder den.

---

## Kort opsummering

| Variabel | Hvad den viser | Bruges til |
| ---------- | --------------- | ------------ |
| `$0` | hvordan scriptet blev kaldt | CLI-navn, help-tekster |
| `${BASH_SOURCE[0]}` | hvilken fil den aktuelle kode kommer fra | modul-loading, paths |

---

## Øvelse

Opret `test-dag01.sh` og print begge variable. Kør scriptet direkte og via `source`. Hvad ændrer sig?

Tip: Når scriptet køres direkte, vil `$0` og `${BASH_SOURCE[0]}` ofte ligne hinanden. Den tydelige forskel kommer især frem ved `source`.

```bash
#!/usr/bin/env bash
echo "0: $0"
echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
```

## Ekstra øvelse — normalisering

Lav et script, der viser forskellen på den rå værdi i `${BASH_SOURCE[0]}` og en normaliseret, absolut sti.

Målet er at forstå dette mønster:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

Prøv at udvide det til også at finde selve filens absolutte sti:

```bash
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
```

Spørgsmål:

- Hvad er forskellen på den rå og den normaliserede værdi?
- Hvad sker der, hvis du kører scriptet fra en anden mappe?
- Hvad sker der, hvis du kalder scriptet via en symlink?

Se den praktiske version i `bash-30-dage-opgaver/dag-01/opgave-6.sh`.
