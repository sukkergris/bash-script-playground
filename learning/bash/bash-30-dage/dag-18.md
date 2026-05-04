# Dag 18 — Subshells og forked processer

## Hvad du lærer i dag
- Hvad en subshell er
- Hvornår Bash automatisk starter subshells
- Fordele og ulemper ved subshells

---

## Hvad er en subshell?

En subshell er en kopi af den aktuelle shell-process. Den arver:
- Alle variabler (men ikke `local`-variabler)
- Alle exporterede variabler
- Alle funktioner
- Aktuel mappe

Men ændringer i subshellen påvirker **ikke** forælderen.

---

## Hvornår starter Bash automatisk subshells?

```bash
# 1. Command substitution
resultat=$(kommando)         # subshell

# 2. Pipe
kommando1 | kommando2        # begge kører i subshells

# 3. Explicit subshell
(
    cd /tmp
    ls
)
# Aktuel mappe er stadig uændret her

# 4. Process substitution
<(kommando)   >(kommando)    # subshell
```

---

## Variabler og subshells

```bash
x=10

(
    x=20                # ændrer kun subshellens x
    echo "Inde: $x"    # → 20
)

echo "Ude: $x"         # → 10 (uændret)
```

---

## Praktisk brug: isoleret fejlhåndtering

```bash
# Kør farlig kode i subshell — fejl stopper ikke forældren
if ( set -e; farlig_kommando; anden_kommando ); then
    echo "Alt lykkedes"
else
    echo "Noget fejlede i subshell"
fi
```

---

## `cd` i subshell

```bash
processér_i_mappe() {
    local mappe="$1"
    (
        cd "$mappe"
        # Alt herinde kører med $mappe som CWD
        for fil in *.csv; do
            process_file "$fil"
        done
    )
    # Vi er stadig i den oprindelige mappe
}
```

---

## Parallel kørsel i subshells

```bash
#!/usr/bin/env bash
set -euo pipefail

# Start flere baggrundsprocesser
for server in web1 web2 web3; do
    (
        ssh "$server" "uptime"
    ) &
done

# Vent på alle
wait
echo "Alle servere tjekket"
```

`&` starter en subshell i baggrunden. `wait` venter på alle baggrunds-jobs.

---

## `$BASHPID` vs `$$`

```bash
echo "Forælder PID: $$"
echo "Forælder BASHPID: $BASHPID"

(
    echo "Subshell PID med \$\$: $$"         # → samme som forælder!
    echo "Subshell PID med \$BASHPID: $BASHPID"   # → ny PID
)
```

`$$` arves fra forælderen. `$BASHPID` opdateres til subshellens egen PID.

---

## Øvelse

Skriv et script der:
1. Starter 3 subshells i baggrunden, der hver sover et tilfældigt antal sekunder (1-5)
2. Printer en besked når hver subshell er færdig
3. Bruger `wait` til at vente på alle
4. Printer total elapsed time
