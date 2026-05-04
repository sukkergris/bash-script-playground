# Dag 26 — Signal handling og `trap`

## Hvad du lærer i dag
- Unix-signaler og hvad de bruges til
- `trap` til at fange signaler
- Graceful shutdown-mønstre

---

## Vigtige Unix-signaler

| Signal | Nr | Default | Hvornår |
|--------|-----|---------|---------|
| `SIGHUP` | 1 | Terminate | Terminal lukket / reload config |
| `SIGINT` | 2 | Terminate | Ctrl+C |
| `SIGQUIT` | 3 | Core dump | Ctrl+\ |
| `SIGKILL` | 9 | Terminate | Kan ikke fanges — dræber øjeblikkeligt |
| `SIGTERM` | 15 | Terminate | Systemd/kill — blød nedlukning |
| `SIGUSR1` | 10 | Terminate | Bruger-defineret |
| `SIGUSR2` | 12 | Terminate | Bruger-defineret |

---

## Fang signaler med `trap`

```bash
#!/usr/bin/env bash
set -euo pipefail

RUNNING=true

stop() {
    echo "Modtog stop-signal, rydder op..." >&2
    RUNNING=false
}

trap stop SIGTERM SIGINT

while $RUNNING; do
    echo "Kører... $(date)"
    sleep 1
done

echo "Stoppet pænt"
```

---

## Graceful shutdown for langvarige scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

PID_FILE="/var/run/myapp.pid"
WORK_DIR="$(mktemp -d)"

cleanup() {
    local sig="${1:-}"
    echo "Rydder op (signal: ${sig:-EXIT})..." >&2
    rm -rf "$WORK_DIR"
    rm -f "$PID_FILE"
}

trap 'cleanup SIGTERM; exit 0' SIGTERM
trap 'cleanup SIGINT; exit 130' SIGINT
trap 'cleanup' EXIT

echo $$ > "$PID_FILE"

# Hoved-loop
while true; do
    do_work
    sleep 5
done
```

---

## Reload config med SIGHUP

```bash
CONFIG_FILE="/etc/myapp/config"

load_config() {
    source "$CONFIG_FILE"
    log_info "Config genindlæst fra $CONFIG_FILE"
}

trap load_config SIGHUP

load_config  # Indlæs ved start

while true; do
    process_requests
done
```

Send `kill -HUP $PID` for at trigge reload.

---

## SIGUSR1/SIGUSR2 til custom hændelser

```bash
dump_status() {
    echo "=== Status ===" >&2
    echo "Processer: $(jobs | wc -l)" >&2
    echo "Uptime: $SECONDS sekunder" >&2
}

trap dump_status SIGUSR1
```

Send `kill -USR1 $PID` for at dumpe status.

---

## `trap -` — nul-ud en trap

```bash
trap - SIGTERM    # Genvind default adfærd for SIGTERM
trap '' SIGINT    # Ignorer SIGINT (Ctrl+C)
```

---

## Øvelse

Byg et "daemon-script" der:
1. Skriver sin PID til `/tmp/myapp.pid`
2. Kører en loop med `sleep`
3. Stopper pænt ved SIGTERM/SIGINT (slet PID-fil)
4. Reloader en config-variabel ved SIGHUP
5. Printer status ved SIGUSR1
