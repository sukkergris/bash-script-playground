# Dag 2 — Hvorfor symlinks kan ødelægge `$0`

## Hvad du lærer i dag
- Hvad der sker med `$0` ved symlinks
- Hvorfor `${BASH_SOURCE[0]}` er det rigtige valg

---

## Scenariet

Forestil dig denne symlink:
```
/usr/local/bin/myscript -> /Users/theodor/project/scripts/myscript.sh
```

Når du kører:
```
myscript
```

så bliver `$0`:
```
/usr/local/bin/myscript
```

Men scriptet ligger i:
```
/Users/theodor/project/scripts/myscript.sh
```

---

## Problemet

Hvis du bruger:
```bash
SCRIPT_DIR="$(dirname "$0")"
```

så tror scriptet, at det ligger i `/usr/local/bin/`.

Det betyder:
- du loader moduler fra det forkerte sted
- relative paths bliver forkerte
- tests fejler
- logging viser forkerte stier

---

## Løsningen

**Brug aldrig `$0` til at finde scriptets placering.**
**Brug `${BASH_SOURCE[0]}`.**

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
echo "Script ligger i: $SCRIPT_DIR"
```

---

## Øvelse

1. Opret `~/bin/test-symlink.sh` med indhold ovenfor
2. Lav en symlink: `ln -s ~/bin/test-symlink.sh /tmp/symlinked`
3. Kør `/tmp/symlinked` — hvad viser `SCRIPT_DIR`?
4. Skift til `$0` i stedet — hvad ændrer sig?
