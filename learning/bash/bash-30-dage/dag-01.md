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

```bash
echo "$0"
```

Hvis du kører:

```bash
/usr/local/bin/myscript
```

så viser `$0`:

```bash
/usr/local/bin/myscript
```

selvom den rigtige fil måske ligger et helt andet sted.

---

## `${BASH_SOURCE[0]}` — den fysiske fil (hvor koden ligger)

`${BASH_SOURCE[0]}` indeholder den faktiske sti til filen, uanset:

- hvordan den blev kaldt
- om den blev sourced
- om den blev symlinket
- om du kører den via PATH
- om du kører den fra en anden mappe

Det er derfor vi bruger `${BASH_SOURCE[0]}` i alle moduler.

### Eksempel ${BASH_SOURCE[0]}

```bash
echo "${BASH_SOURCE[0]}"
```

→ viser altid den rigtige fil.

---

## Kort opsummering

| Variabel | Hvad den viser | Bruges til |
| ---------- | --------------- | ------------ |
| `$0` | hvordan scriptet blev kaldt | CLI-navn, help-tekster |
| `${BASH_SOURCE[0]}` | hvor filen faktisk ligger | modul-loading, paths |

---

## Øvelse

Opret `test-dag01.sh` og print begge variable. Kør scriptet direkte og via `source`. Hvad ændrer sig?

```bash
#!/usr/bin/env bash
echo "0: $0"
echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
```
