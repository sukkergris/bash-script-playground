# Bash Parameter Expansion Cheat-Sheet

En kompakt guide til at bruge Bash parameter expansion til defaults, config-systemer og moduloaders.

---

## Grundkoncept: The `:` No-op Operator

Kommandoen `:` gør ingenting, men evaluerer sit argument. Det bruges til at køre parameter expansions uden at udføre noget:

```bash
: "${FOO:=bar}"    # Evaluer og sæt default, men udfør ingen handling
```

Dette er idiomatisk Bash og helt ækvivalent med:

```bash
if [ -z "$FOO" ]; then
    FOO="bar"
fi
```

**Hvorfor bruge `:`?**
- Kortere og mere læsbar
- Idiomatisk Bash
- Ingen risk for command execution
- Perfekt til module-loaders

---

## Oversigt: Alle Vigtige Parameter Expansions

| Syntaks | Betydning |
|---------|-----------|
| `${VAR:=x}` | Sæt hvis tom |
| `${VAR:-x}` | Brug hvis tom (sæt ikke) |
| `${VAR:+x}` | Brug hvis sat |
| `${VAR:?msg}` | Kræv værdi, fejl ellers |
| `${VAR:offset:length}` | Substring |
| `${VAR#pat}` | Fjern prefix (kort) |
| `${VAR##pat}` | Fjern prefix (lang) |
| `${VAR%pat}` | Fjern suffix (kort) |
| `${VAR%%pat}` | Fjern suffix (lang) |

---

## Detaljeret Gennemgang

### 1. `${VAR:=default}` — Sæt Hvis Tom

Hvis variablen er tom eller ikke defineret → **sæt den til default**.

```bash
: "${FOO:=bar}"

# FOO er nu "bar" hvis den var tom
# FOO ændres ikke hvis den allerede havde en værdi
```

**Brugscases:**
- Default konfigurationer
- Miljøvariabler i moduloaders
- Init-scripts

---

### 2. `${VAR:-default}` — Brug Default (Sæt Ikke)

Hvis variablen er tom → **brug default**, men **ændr ikke variablen**.

```bash
echo "${NAME:-ukendt bruger}"

# Hvis NAME er tom: output "ukendt bruger"
# Men NAME forbliver tom
```

**Brugscases:**
- Fallback-værdier i output
- Templates
- Brugerinput med defaults

---

### 3. `${VAR:+alt}` — Brug Hvis Sat

Hvis variablen har en værdi → **brug alt**, ellers tom streng.

```bash
echo "${DEBUG:+--verbose}"

# Hvis DEBUG er sat: output "--verbose"
# Hvis DEBUG er tom: output "" (tom)
```

**Brugscases:**
- Feature-toggles
- Betingede kommandolinjeargumenter
- Build-konfiguration

---

### 4. `${VAR:?fejlbesked}` — Kræv Værdi

Hvis variablen er tom → **stop scriptet med fejlbesked**.

```bash
: "${API_KEY:?API_KEY er ikke sat!}"
: "${DATABASE_URL:?Miljøvariabel DATABASE_URL mangler}"

# Scriptet stopper her hvis variablerne mangler
```

**Brugscases:**
- Validering af kritiske secrets
- Miljøvariabel-check i CI/CD
- Håndtering af obligatorisk config

---

### 5. `${VAR:offset:length}` — Substring

Tag et udsnit af en streng fra position `offset` med længde `length`.

```bash
FOO="abcdef"
echo "${FOO:2:3}"   # Output: cde
echo "${FOO:0:3}"   # Output: abc
echo "${FOO:2}"     # Output: cdef (fra position 2 til slut)
```

**Brugscases:**
- String-manipulation
- Path-parsing
- Version-parsing

---

### 6 & 7. Fjern Prefix

Fjern præfiks fra start af streng.

**`${VAR#pattern}`** — Fjern **korteste** match:
```bash
FILE="/home/theodor/project/lib/module.sh"
echo "${FILE#*/}"   # home/theodor/project/lib/module.sh
```

**`${VAR##pattern}`** — Fjern **længste** match:
```bash
echo "${FILE##*/}"  # module.sh (fjerner alt til sidste /)
```

---

### 8 & 9. Fjern Suffix

Fjern suffiks fra slutningen af streng.

**`${VAR%pattern}`** — Fjern **korteste** match:
```bash
FILE="/home/theodor/project/lib/module.sh"
echo "${FILE%.sh}"  # /home/theodor/project/lib/module
```

**`${VAR%%pattern}`** — Fjern **længste** match:
```bash
echo "${FILE%%/*}"  # (tom, fordi det fjerner alt fra første /)
```

---

## Praktiske Eksempler

### Example 1: Module-Loader med Defaults

```bash
: "${PROJECT_ROOT:=/default/path}"
: "${LOG_LEVEL:=info}"
: "${DEBUG:=false}"

source "$PROJECT_ROOT/lib/base.sh"
```

### Example 2: CI/CD Config Validation

```bash
: "${GITHUB_TOKEN:?Set GITHUB_TOKEN environment variable}"
: "${DOCKER_REGISTRY:?DOCKER_REGISTRY is required}"

docker login -u "$DOCKER_USER" --password-stdin "$DOCKER_REGISTRY"
```

### Example 3: Feature Toggles

```bash
./build.sh "${VERBOSE:+--verbose}" "${DEBUG:+--debug}"
# Sender --verbose kun hvis VERBOSE er sat
# Sender --debug kun hvis DEBUG er sat
```

### Example 4: Path Extraction

```bash
FILEPATH="/home/theodor/projects/myapp/src/main.sh"

DIR="${FILEPATH%/*}"           # /home/theodor/projects/myapp/src
BASENAME="${FILEPATH##*/}"     # main.sh
EXTENSION="${FILEPATH##*.}"    # sh
NOEXT="${FILEPATH%.*}"         # /home/theodor/projects/myapp/src/main
```

---

## Huskeregel

- **`:=`** → Sæt hvis tom
- **`:-`** → Brug hvis tom (sæt ikke)
- **`:+`** → Brug hvis sat
- **`:?`** → Kræv værdi
- **`:offset:length`** → Substring
- **`#`/`##`** → Fjern prefix (kort/lang)
- **`%`/`%%`** → Fjern suffix (kort/lang)
Den her linje:
: "${FOO:=bar}"

er funktionelt det samme som:
if [ -z "$FOO" ]; then
    FOO="bar"
fi

Begge gør præcis det samme:
Hvis FOO er tom eller ikke sat → sæt den til "bar"
Hvis FOO allerede har en værdi → lad den være
Forskellen er bare, at :‑versionen er:
kortere
mere idiomatisk Bash
uden kontrolstrukturer
uden risiko for at forsøge at eksekvere noget
perfekt til modul‑loaders og defaults
Huskeregel:
:= betyder “sæt hvis tom”,
: betyder “gør ingenting, men evaluer argumentet”.
---
Hvis du vil, laver jeg en lille cheat‑sheet over alle de vigtigste parameter expansions (:-, :=, :+, :?, osv.) så du får hele værktøjskassen på én side.

Selvfølgelig, Theodor — her får du et kompakt, skarpt og brugbart cheat‑sheet over de vigtigste Bash‑parameter expansions. Det her er guld når du bygger modul‑loaders, defaults, config‑systemer og robust Bash‑kode.
---
🧾 Bash Parameter Expansion Cheat‑Sheet
(den du faktisk kommer til at bruge)
1) `${VAR:=default}` — sæt hvis tom
“Hvis VAR er tom eller ikke sat → sæt den til default.”
Eksempel:
: "${FOO:=bar}"

= kompakt version af:
if [ -z "$FOO" ]; then
    FOO="bar"
fi

---
2) `${VAR:-default}` — brug default, men sæt ikke
“Hvis VAR er tom → brug default, men ændr ikke variablen.”
Eksempel:
echo "${NAME:-ukendt bruger}"

Hvis NAME er tom → output: ukendt bruger
Men NAME forbliver tom.
---
3) `${VAR:+alt}` — brug alt hvis VAR er sat
“Hvis VAR har en værdi → brug alt. Ellers → tom streng.”
Eksempel:
echo "${DEBUG:+--verbose}"

Hvis DEBUG er sat → output: --verbose
Hvis DEBUG ikke er sat → output: (tom)
God til feature‑toggles.
---
4) `${VAR:?fejlbesked}` — kræv at variablen er sat
“Hvis VAR er tom → stop scriptet og print fejlbesked.”
Eksempel:
: "${API_KEY:?API_KEY er ikke sat!}"

Hvis API_KEY mangler → scriptet stopper med en klar fejl.
Perfekt til:
secrets
config
miljøvariabler i CI/CD
---
5) `${VAR:offset:length}` — substring
“Tag et udsnit af en streng.”
Eksempel:
FOO="abcdef"
echo "${FOO:2:3}"

Output:
cde

---
6) `${VAR#pattern}` — fjern prefix (kortest match)
7) `${VAR##pattern}` — fjern prefix (længst match)
Eksempel:
FILE="/home/theodor/project/lib/module.sh"
echo "${FILE#*/}"   # home/theodor/project/lib/module.sh
echo "${FILE##*/}"  # module.sh

---
8) `${VAR%pattern}` — fjern suffix (kortest match)
9) `${VAR%%pattern}` — fjern suffix (længst match)
Eksempel:
echo "${FILE%.sh}"   # module
echo "${FILE%%/*}"   # (tom, fordi længste match fjerner alt)

---
🧨 Bonus: hvorfor `:` bruges sammen med expansions
: gør ingenting, men evaluerer argumentet.
Derfor:
: "${FOO:=bar}"

= “evaluer og sæt default, men udfør ingen handling”.
Det er den idiomatiske måde at lave defaults i Bash.
---
🔥 Ultra‑kort huskeregel
Syntaks	Betydning
${VAR:=x}	sæt hvis tom
${VAR:-x}	brug x hvis tom (men sæt ikke)
${VAR:+x}	brug x hvis VAR er sat
${VAR:?msg}	kræv VAR, ellers fejl
${VAR:offset:length}	substring
${VAR#pat} / ${VAR##pat}	fjern prefix
${VAR%pat} / ${VAR%%pat}	fjern suffix
:	no‑op, evaluer argumenter


Her kommer en ren, visuel ASCII‑oversigt, der giver dig et mentalt kort over alle de vigtigste Bash‑parameter expansions.
Den er lavet til at kunne sættes direkte ind i Obsidian.
---
🧾 Bash Parameter Expansion — ASCII Visual Guide
┌──────────────────────────────────────────────────────────────┐
│  DEFAULT VALUES                                               │
└──────────────────────────────────────────────────────────────┘

${VAR:=default}
        │
        ├─ If VAR is empty → SET VAR = "default"
        └─ If VAR has value → keep it

   Equivalent to:
       if [ -z "$VAR" ]; then VAR="default"; fi


${VAR:-default}
        │
        ├─ If VAR is empty → USE "default"
        └─ Does NOT set VAR


┌──────────────────────────────────────────────────────────────┐
│  CONDITIONAL SUBSTITUTE                                       │
└──────────────────────────────────────────────────────────────┘

${VAR:+alt}
        │
        ├─ If VAR is set → USE "alt"
        └─ If VAR is empty → USE "" (empty string)


┌──────────────────────────────────────────────────────────────┐
│  REQUIRED VARIABLES                                           │
└──────────────────────────────────────────────────────────────┘

${VAR:?error message}
        │
        ├─ If VAR is empty → print error + exit script
        └─ If VAR has value → expand normally


┌──────────────────────────────────────────────────────────────┐
│  SUBSTRINGS                                                   │
└──────────────────────────────────────────────────────────────┘

${VAR:offset:length}

Example:
    VAR="abcdef"
    ${VAR:2:3}  →  "cde"


┌──────────────────────────────────────────────────────────────┐
│  PREFIX REMOVAL (PATTERN MATCHING)                           │
└──────────────────────────────────────────────────────────────┘

${VAR#pattern}     → remove shortest prefix match
${VAR##pattern}    → remove longest prefix match

Example:
    FILE="/a/b/c.txt"
    ${FILE#*/}     → "a/b/c.txt"
    ${FILE##*/}    → "c.txt"


┌──────────────────────────────────────────────────────────────┐
│  SUFFIX REMOVAL (PATTERN MATCHING)                           │
└──────────────────────────────────────────────────────────────┘

${VAR%pattern}     → remove shortest suffix match
${VAR%%pattern}    → remove longest suffix match

Example:
    FILE="c.txt"
    ${FILE%.txt}   → "c"
    ${FILE%%.*}    → "c"


┌──────────────────────────────────────────────────────────────┐
│  WHY ":" IS USED WITH :=                                      │
└──────────────────────────────────────────────────────────────┘

: "${VAR:=default}"
   │
   ├─ ":" is a NO-OP (does nothing)
   ├─ Forces Bash to evaluate the expansion
   └─ Safely sets VAR if empty, without running anything

Equivalent to:
    if [ -z "$VAR" ]; then VAR="default"; fi


