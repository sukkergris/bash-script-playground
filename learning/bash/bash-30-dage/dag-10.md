# Dag 10 — `for`-loops

## Hvad du lærer i dag
- De tre former for `for`-loops i Bash
- Looping over filer, output, og tal
- `break` og `continue`

---

## Form 1: loop over en liste

```bash
for farve in rød grøn blå; do
    echo "Farve: $farve"
done
```

---

## Form 2: loop over output fra kommando

```bash
for fil in *.sh; do
    echo "Script: $fil"
done

# Eller via command substitution
for linje in $(cat /etc/hosts); do
    echo "$linje"
done
```

**Advarsel:** `$(cat fil)` splitter på mellemrum, ikke kun newlines.
Brug `while read` til linjevis læsning (dag 11).

---

## Form 3: C-style loop

```bash
for (( i = 0; i < 5; i++ )); do
    echo "Iteration $i"
done

# Tæl baglæns
for (( i = 10; i >= 0; i-- )); do
    echo "$i"
done
```

---

## Loop over et array

```bash
filer=("config.sh" "logging.sh" "os-detection.sh")

for fil in "${filer[@]}"; do
    if [[ -f "lib-bash/$fil" ]]; then
        echo "OK: $fil"
    else
        echo "MANGLER: $fil"
    fi
done
```

---

## Loop over et talinterval

```bash
# seq (ekstern kommando)
for i in $(seq 1 10); do echo "$i"; done

# Bash 4+ brace expansion (ingen ekstern kommando)
for i in {1..10}; do echo "$i"; done

# Med step
for i in {0..100..10}; do echo "$i"; done
```

---

## `break` og `continue`

```bash
for fil in /etc/*; do
    [[ -d "$fil" ]] && continue     # skip mapper
    [[ "$fil" == *"shadow"* ]] && break  # stop ved shadow-filer

    echo "Fil: $fil"
done
```

---

## Praktisk: batch-processering

```bash
processér_filer() {
    local mappe="$1"
    local fejl=0

    for fil in "$mappe"/*.csv; do
        [[ -f "$fil" ]] || continue     # spring over hvis ingen filer matcher

        if validate_csv "$fil"; then
            log_ok "Valideret: $fil"
        else
            log_error "Ugyldig: $fil"
            (( fejl++ )) || true        # || true: undgår exit ved set -e
        fi
    done

    return "$fejl"
}
```

---

## Øvelse

Skriv et script der:
1. Looper over alle `.sh`-filer i `lib-bash/`
2. Tjekker at hver fil har korrekt shebang (`#!/usr/bin/env bash`)
3. Printer `[OK]` eller `[MANGLER SHEBANG]` for hver fil
