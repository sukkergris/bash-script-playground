# Dag 27 — Job control og baggrunds-processer

## Hvad du lærer i dag
- Baggrunds-processer med `&`
- `wait`, `jobs`, og process management
- Parallel kørsel med fejlhåndtering

---

## Kør i baggrunden: `&`

```bash
lang_opgave &       # start i baggrunden
PID=$!              # gem PID for den seneste baggrunds-process
echo "Startet med PID $PID"
```

`$!` = PID for den seneste baggrunds-process.

---

## `wait` — vent på processer

```bash
# Vent på alle baggrunds-processer
process1 &
process2 &
process3 &
wait            # vent på alle

# Vent på specifik PID
process1 &
pid1=$!
wait "$pid1"    # vent kun på denne

# Hent exit code
wait "$pid1"
kode=$?
```

---

## Parallel kørsel — simpelt mønster

```bash
#!/usr/bin/env bash
set -euo pipefail

pids=()

for server in web1 web2 web3; do
    (
        ssh "$server" "hostname && uptime"
    ) &
    pids+=($!)
done

fejl=0
for pid in "${pids[@]}"; do
    wait "$pid" || (( fejl++ )) || true
done

echo "Fejlede: $fejl"
```

---

## Parallel kørsel med output-isolering

```bash
parallel_run() {
    local -a pids=()
    local -a outputs=()

    for opgave in "$@"; do
        local tmp
        tmp="$(mktemp)"
        outputs+=("$tmp")

        eval "$opgave" > "$tmp" 2>&1 &
        pids+=($!)
    done

    local fejl=0
    for i in "${!pids[@]}"; do
        if wait "${pids[$i]}"; then
            echo "OK: $i"
            cat "${outputs[$i]}"
        else
            echo "FEJL: $i"
            cat "${outputs[$i]}" >&2
            (( fejl++ )) || true
        fi
        rm -f "${outputs[$i]}"
    done

    return "$fejl"
}
```

---

## `jobs` — se aktive jobs

```bash
jobs            # vis alle baggrunds-jobs
jobs -l         # inkludér PIDs
jobs -p         # kun PIDs

fg              # bring seneste job til forgrunden
fg %1           # bring job #1 til forgrunden
bg %1           # fortsæt stoppet job i baggrunden
```

---

## Timeout med baggrunds-processer

```bash
run_with_timeout() {
    local timeout_secs="$1"
    local cmd="${@:2}"

    $cmd &
    local pid=$!

    (
        sleep "$timeout_secs"
        kill "$pid" 2>/dev/null
    ) &
    local timer_pid=$!

    if wait "$pid"; then
        kill "$timer_pid" 2>/dev/null
        return 0
    else
        return 1
    fi
}
```

Eller brug det enklere: `timeout 30 kommando`

---

## Øvelse

Skriv et script der:
1. Kører 5 "opgaver" parallelt (simulér med `sleep $((RANDOM % 5 + 1))`)
2. Tracker hvilke der lykkes/fejler
3. Printer status i realtid når hver færdiggøres
4. Afslutter med exit code lig antal fejlede opgaver
