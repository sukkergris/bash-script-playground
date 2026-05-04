# Dag 19 — Miljøvariabler og konfigurationsmønstre

## Hvad du lærer i dag
- Miljøvariabler og `export`
- Læsning af `.env`-filer
- Sikre defaults og validering

---

## Miljøvariabler

Miljøvariabler er variabler der nedarves fra forælderprocessen til child-processer via `export`.

```bash
# Sæt og eksporter
export DATABASE_URL="postgres://localhost/mydb"
export LOG_LEVEL="info"

# Tjek om en er sat
printenv DATABASE_URL
env | grep "DATABASE"
```

---

## Arv fra forælderprocessen

```bash
# I terminalen:
export APP_ENV="production"

# I script:
echo "${APP_ENV:-development}"   # → production
```

---

## Læs `.env`-fil sikkert

```bash
load_env() {
    local env_file="${1:-.env}"

    [[ -f "$env_file" ]] || return 0

    while IFS= read -r linje || [[ -n "$linje" ]]; do
        # Spring kommentarer og tomme linjer over
        [[ "$linje" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${linje// }" ]] && continue

        # Eksporter kun linjer der matcher NØGLE=VÆRDI
        if [[ "$linje" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
            export "$linje"
        fi
    done < "$env_file"
}
```

**Advarsel:** Brug aldrig `source .env` direkte — `.env` kan indeholde arbitrær kode.

---

## Validér påkrævede variabler

```bash
require_env() {
    local var_name="$1"
    local value="${!var_name}"   # indirekte reference

    if [[ -z "$value" ]]; then
        echo "FEJL: Miljøvariabel '$var_name' er påkrævet" >&2
        return 1
    fi
}

require_env "DATABASE_URL" || exit 1
require_env "API_KEY" || exit 1
```

`${!var_name}` er indirekte expansion — variabelnavnet evalueres til variablens navn.

---

## Defaults med prioritet

```bash
# Prioritet: eksplicit argument > miljøvariabel > default
konfigurér() {
    local arg_host="${1:-}"

    DB_HOST="${arg_host:-${DATABASE_HOST:-localhost}}"
    DB_PORT="${DATABASE_PORT:-5432}"
    DB_NAME="${DATABASE_NAME:?'DATABASE_NAME er påkrævet'}"

    readonly DB_HOST DB_PORT DB_NAME
}
```

---

## Sikkerhed: hemmeligheder i miljøvariabler

```bash
# OK: URL indeholder ikke password
export DATABASE_URL="postgres://localhost/mydb"
export DATABASE_PASSWORD="$(cat /run/secrets/db_password)"

# UNDGÅ: print ikke hemmeligheder
echo "$DATABASE_PASSWORD"   # farligt i logs

# Maskér i logs
log_info "Forbinder til ${DATABASE_URL%@*}..."
```

---

## Øvelse

Byg en `load_and_validate_config()` funktion der:
1. Indlæser `.env` sikkert (uden `source`)
2. Validerer at `APP_ENV`, `PORT`, og `DATABASE_URL` er sat
3. Sætter fornuftige defaults for `PORT` (8080) og `APP_ENV` (development)
4. Logger de effektive værdier (men maskerer passwords)
