# Dag 17 — Pipes og process substitution

## Hvad du lærer i dag
- Pipes og pipeline-kæder
- Process substitution `<()` og `>()`
- Named pipes (FIFOs)

---

## Pipes: `|`

En pipe sender stdout fra én kommando til stdin for den næste.

```bash
cat /etc/passwd | grep "bash" | cut -d: -f1 | sort
```

Hvert led kører i sin egen subshell, parallelt.

---

## `pipefail` — fang fejl i pipe

Uden `set -o pipefail`:
```bash
cat /nonexistent | grep "noget"
echo $?     # → 1 (fra grep, ikke 2 fra cat)
```

Med `pipefail`, stopper scriptet ved `cat`'s fejl.

---

## Process substitution: `<(kommando)`

Giver output fra en kommando som en "fil" du kan læse fra.

```bash
# Sammenlign output fra to kommandoer
diff <(sort fil1.txt) <(sort fil2.txt)

# Brug som input til while read (undgår subshell-problem)
while IFS= read -r linje; do
    echo "Host: $linje"
done < <(grep -v "^#\|^$" /etc/hosts)
```

**Fordelen ved `< <(...)` frem for pipe:**
Pipe kører `while`-løkken i en subshell, så variabler sættes inde i løkken er ikke tilgængelige udenfor:

```bash
# PROBLEM: tæller er 0 udenfor løkken
grep "noget" fil.txt | while read -r linje; do
    (( tæller++ )) || true
done
echo "$tæller"   # → 0 !! (subshell)

# LØSNING: brug process substitution
tæller=0
while IFS= read -r linje; do
    (( tæller++ )) || true
done < <(grep "noget" fil.txt)
echo "$tæller"   # → korrekt antal
```

---

## Process substitution: `>(kommando)`

Sender output til en kommando som om det var en fil:

```bash
# Log til to steder samtidigt
kommando > >(tee stdout.log) 2> >(tee stderr.log >&2)
```

---

## Named pipes (FIFOs)

```bash
mkfifo /tmp/mypipe

# Terminal 1: skriv til pipe
echo "besked" > /tmp/mypipe

# Terminal 2: læs fra pipe
cat /tmp/mypipe

# Ryd op
rm /tmp/mypipe
```

Named pipes bruges sjældent i normale scripts, men er nyttige til IPC.

---

## Praktisk pipeline-mønster

```bash
find_modified_scripts() {
    local days="${1:-7}"

    find . -name "*.sh" -newer . -mtime "-$days" \
        | xargs grep -l "set -euo pipefail" \
        | sort \
        | uniq
}

# Sammenlign resultater
diff \
    <(find_modified_scripts 7) \
    <(find_modified_scripts 30) \
    || true
```

---

## Øvelse

Skriv et script der bruger process substitution til at:
1. Finde alle `.sh`-filer i projektet
2. Tælle antal linjer i hvert fil
3. Sortere efter størrelse (størst først)
4. Bevare tællevariablen efter løkken
