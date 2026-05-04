# Dag 16 — Input/output omdirigering

## Hvad du lærer i dag
- File descriptors: stdin, stdout, stderr
- Omdirigering med `>`, `>>`, `<`, `2>`
- `>&2`, `/dev/null`, og `tee`

---

## File descriptors

| FD | Navn | Standard |
|----|------|----------|
| 0 | stdin | Tastaturet |
| 1 | stdout | Terminalen |
| 2 | stderr | Terminalen |

---

## Output omdirigering

```bash
# Skriv stdout til fil (overskriv)
kommando > output.txt

# Tilføj stdout til fil
kommando >> log.txt

# Skriv stderr til fil
kommando 2> fejl.log

# Skriv både stdout og stderr til fil
kommando > alt.log 2>&1
kommando &> alt.log     # kortere form (Bash 4+)

# Tilføj begge til fil
kommando >> alt.log 2>&1
```

---

## Rækkefølge betyder noget!

```bash
# FORKERT — stderr omdirigeres til original stdout (terminal), ikke til fil
kommando 2>&1 > fil.txt

# RIGTIGT — stdout → fil.txt, derefter stderr → where stdout now points (fil.txt)
kommando > fil.txt 2>&1
```

---

## `/dev/null` — sorter hullet

```bash
# Kassér al output
kommando &>/dev/null

# Kassér kun fejlbeskeder
kommando 2>/dev/null

# Kassér kun normal output (men vis fejl)
kommando >/dev/null
```

---

## Skriv til stderr fra dit script

```bash
log_error() {
    echo "ERROR: $*" >&2    # >&2 sender til stderr
}

log_info() {
    echo "INFO: $*"         # går til stdout
}
```

**Fejlbeskeder hører hjemme på stderr.** Det lader brugere filtrere:
```bash
./script.sh 2>/dev/null     # vis kun normal output
./script.sh 2>errors.log    # gem fejl, se normal output
```

---

## Input omdirigering

```bash
# Læs fra fil
while IFS= read -r linje; do
    echo "$linje"
done < input.txt

# Here-string (linje direkte som input)
grep "mønster" <<< "dette er en test"

# Here-document (multi-linje input)
cat << EOF
Linje 1
Linje 2
EOF
```

---

## `tee` — skriv til fil OG terminal

```bash
kommando | tee output.txt           # vis + gem stdout
kommando | tee -a log.txt           # vis + tilføj til fil
kommando 2>&1 | tee alt.log        # vis + gem alt
```

---

## Praktisk: log til fil og terminal

```bash
LOG_FILE="/var/log/myapp.log"

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $*" | tee -a "$LOG_FILE"
}
```

---

## Øvelse

Skriv et script der:
1. Kører en kommando der producerer både stdout og stderr
2. Gemmer stdout i `output.log`
3. Gemmer stderr i `errors.log`
4. Printer et resume til terminalen om hvad der skete
