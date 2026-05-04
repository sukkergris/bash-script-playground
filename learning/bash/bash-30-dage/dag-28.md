# Dag 28 — OS-detection og cross-platform scripts

## Hvad du lærer i dag
- Hvordan man detekterer OS pålideligt
- Platform-specifikke kommandoer og deres alternativer
- Mønsteret fra `lib-bash/os-detection.sh`

---

## Problemet med `$OSTYPE`

`$OSTYPE` er Bash-specifik og varierer:

| Platform | `$OSTYPE` |
|----------|-----------|
| macOS | `darwin23.0` (versionsafhængig) |
| Linux | `linux-gnu` |
| WSL | `linux-gnu` (kan ikke skelnes fra Linux!) |
| Git Bash | `msys` |

Du kan ikke bruge `$OSTYPE` til at skelne WSL fra Linux.

---

## Robust OS-detection

```bash
detect_os() {
    local os_type
    os_type="$(uname -s)"

    case "$os_type" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if grep -qi "microsoft" /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}
```

---

## Arkitektur

```bash
detect_arch() {
    local arch
    arch="$(uname -m)"

    case "$arch" in
        x86_64|amd64)   echo "x86_64" ;;
        arm64|aarch64)  echo "arm64" ;;
        armv7l)         echo "armv7" ;;
        *)              echo "$arch" ;;
    esac
}
```

---

## Platform-specifikke kommandoer

### `stat` — filinfo

```bash
file_size() {
    local file="$1"
    case "$(detect_os)" in
        macos)  stat -f "%z" "$file" ;;
        *)      stat -c "%s" "$file" ;;
    esac
}
```

### `date` — tidsstempel

```bash
timestamp_iso() {
    case "$(detect_os)" in
        macos)  date -u "+%Y-%m-%dT%H:%M:%SZ" ;;
        *)      date -u --iso-8601=seconds ;;
    esac
}
```

### `sed` in-place

```bash
sed_inplace() {
    case "$(detect_os)" in
        macos)  sed -i '' "$1" "$2" ;;
        *)      sed -i "$1" "$2" ;;
    esac
}
```

---

## Tjek for tilgængelige kommandoer

```bash
require_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        echo "FEJL: '$cmd' er ikke installeret" >&2
        return 1
    fi
}

require_command "jq" || exit 1
require_command "openssl" || exit 1
```

---

## Brug altid `command -v`, ikke `which`

```bash
# UNDGÅ
which jq

# BRUG
command -v jq           # returnerer stien
command -v jq &>/dev/null  # kun exit code
```

`which` er ikke POSIX og opfører sig forskelligt på macOS vs Linux.

---

## Øvelse

Udbyg `detect_os()` til en funktion `os_info()` der returnerer:
1. OS-navn
2. OS-version (f.eks. `14.2` på macOS, kernel-version på Linux)
3. Arkitektur
4. Om den kører som root

Gem alle dele i et associative array og print dem formateret.
