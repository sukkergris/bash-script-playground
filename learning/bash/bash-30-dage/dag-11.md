# Dag 11 — `while` og `until` loops

## Hvad du lærer i dag
- `while` og `until` loops
- Linjevis fillæsning med `while read`
- Infinite loops og clean exit

---

## `while` — kør så længe betingelse er sand

```bash
i=0
while (( i < 5 )); do
    echo "i = $i"
    (( i++ ))
done
```

---

## `until` — kør så længe betingelse er falsk

```bash
forsøg=0
while ! ping -c1 -W1 google.com &>/dev/null; do
    (( forsøg++ ))
    echo "Forsøg $forsøg — ingen forbindelse, venter..."
    sleep 2
done
echo "Forbundet!"
```

`until` er syntaktisk sukker for `while !` — brug den der giver mest naturlig dansk læsning.

---

## Linjevis fillæsning (det rigtige mønster)

```bash
# FORKERT — splitter på mellemrum
for linje in $(cat fil.txt); do ...

# RIGTIGT — bevarer mellemrum og whitespace
while IFS= read -r linje; do
    echo "Linje: $linje"
done < fil.txt
```

### Hvad `IFS= read -r` gør

| Del | Forklaring |
|-----|-----------|
| `IFS=` | Tom field separator — bevar mellemrum i linjen |
| `read` | Læs én linje fra stdin |
| `-r` | Raw mode — fortolk ikke `\` som escape |

---

## Læs fra process substitution

```bash
while IFS= read -r linje; do
    echo "Host: $linje"
done < <(grep -v "^#" /etc/hosts)
```

`< <(kommando)` lader dig pipe til `while read` og beholder subshell-variabler.

---

## Infinite loop med clean exit

```bash
#!/usr/bin/env bash
set -euo pipefail

cleanup() {
    echo "Rydder op..."
}
trap cleanup EXIT

while true; do
    echo "Tjekker... $(date)"
    sleep 5
done
```

`trap cleanup EXIT` sikrer at `cleanup()` altid kører, selv ved `Ctrl+C`.

---

## Læs input fra bruger

```bash
while IFS= read -r -p "Indtast navn (q=quit): " input; do
    [[ "$input" == "q" ]] && break
    echo "Hej, $input!"
done
```

---

## Øvelse

Skriv et script der:
1. Læser en fil linje for linje (brug `while IFS= read -r`)
2. Springer linjer over der starter med `#`
3. Printer linjenummer og indhold for resten
4. Tæller og printer totalt antal linjer læst
