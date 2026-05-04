# Dag 23 — `awk` — tekst-transformation

## Hvad du lærer i dag
- `awk` som kolonne-processor
- Felter, separatorer og mønstre
- Praktiske awk-one-liners

---

## Hvad er `awk`?

`awk` er et lille programmeringssprog designet til at processere struktureret tekst (kolonner/felter).

```
MØNSTER { HANDLING }
```

---

## Felter

`awk` splitter hver linje i felter:

| Variabel | Indhold |
|----------|---------|
| `$0` | Hele linjen |
| `$1` | Første felt |
| `$2` | Andet felt |
| `$NF` | Sidste felt |
| `NR` | Linjenummer |
| `NF` | Antal felter på linjen |
| `FS` | Field separator (default: whitespace) |

```bash
echo "Theodor Heiselberg 30" | awk '{print $1, $3}'
# → Theodor 30
```

---

## Felt-separator

```bash
# Kolon-separeret (som /etc/passwd)
awk -F: '{print $1, $6}' /etc/passwd

# Komma-separeret (CSV)
awk -F, '{print $2}' data.csv

# Inde i script
awk 'BEGIN{FS=":"} {print $1}' /etc/passwd
```

---

## Mønstre

```bash
# Print kun linjer der matcher
awk '/ERROR/ {print}' logfil.txt

# Print linjer der IKKE matcher
awk '!/ERROR/ {print}' logfil.txt

# Print linjer mellem to mønstre
awk '/START/,/STOP/ {print}' fil.txt

# Betinget
awk '$3 > 100 {print $1, $3}' data.txt
```

---

## `BEGIN` og `END`

```bash
awk '
BEGIN {
    total = 0
    print "=== Rapport ==="
}
{
    total += $2
    print $1, $2
}
END {
    print "Total:", total
    print "Linjer:", NR
}
' data.txt
```

---

## Praktiske one-liners

```bash
# Sum af kolonne 2
awk '{sum += $2} END {print sum}' fil.txt

# Gennemsnit
awk '{sum += $1} END {print sum/NR}' tal.txt

# Unikke værdier i kolonne 1
awk '!seen[$1]++' fil.txt

# Print linjer 5-10
awk 'NR>=5 && NR<=10' fil.txt

# Fjern duplikerede linjer (bevarer rækkefølge)
awk '!seen[$0]++' fil.txt
```

---

## `awk` i Bash-scripts

```bash
# Udtræk disk-brug
disk_brugt() {
    df -h "$1" | awk 'NR==2 {print $5}' | tr -d '%'
}

# Parse process-liste
top_processer() {
    ps aux | awk 'NR>1 {print $1, $3, $11}' | sort -k2 -rn | head -10
}

# Hent linje N
hent_linje() {
    awk "NR==$1" "$2"
}
```

---

## Øvelse

Brug `awk` til at skrive et script der:
1. Læser en log-fil med format: `TIMESTAMP LEVEL MESSAGE`
2. Tæller antal linjer per log-niveau (INFO, WARN, ERROR)
3. Printer en oversigt: `LEVEL: antal`
4. Printer total antal linjer i slutningen
