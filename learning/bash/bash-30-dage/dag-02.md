# Dag 02 — Symlinks, `$0` og normalisering af script-stier

## Hvad du lærer i dag

- Hvorfor `$0` ikke er stabil til path-opslag
- Hvordan `${BASH_SOURCE[0]}` opfører sig ved execute vs source
- Et macOS-kompatibelt normaliseringsmønster uden `readlink -f`

---

## Koncept 1 — Entrypoint-adfærd i CLI

`$0` viser, hvordan scriptet blev kaldt fra CLI.

Eksempel med symlink:

```bash
/usr/local/bin/myscript -> /Users/theodor/project/scripts/myscript.sh
```

Når du kører:

```bash
myscript
```

kan `$0` være:

```bash
/usr/local/bin/myscript
```

Det er nyttigt til CLI-navn/help-tekst, men usikkert til at finde scriptets egen mappe.

---

## Koncept 2 — Edge cases: execute vs source og symlinks

`${BASH_SOURCE[0]}` peger på filen Bash eksekverer/læser i den aktuelle stack-frame.

- Når scriptet eksekveres direkte, ligner `$0` og `${BASH_SOURCE[0]}` ofte hinanden.
- Når scriptet sources, bliver `$0` typisk shellens navn (fx `bash` eller `zsh`), mens `${BASH_SOURCE[0]}` stadig peger på den sourcede fil.
- Ved symlinks er `${BASH_SOURCE[0]}` ikke automatisk canonical path. Derfor skal du normalisere eksplicit.

---

## Sammenligning

| Variabel | Execute (`./script.sh`) | Source (`source script.sh`) | Bruges til |
| --- | --- | --- | --- |
| `$0` | Script-navn/-sti som kaldt | Shellens navn | CLI-navn, usage/help |
| `${BASH_SOURCE[0]}` | Fil Bash læser | Sourced fil | Moduler, path-beregning |

---

## Normaliseringsmønster (macOS-kompatibelt)

`readlink -f` findes typisk ikke på macOS. Brug i stedet et mønster baseret på `cd`, `pwd -P` og `readlink`:

```bash
#!/usr/bin/env bash

# Finder scriptets canonical directory, også hvis entrypoint er en symlink.
script_source="${BASH_SOURCE[0]}"
while [[ -h "$script_source" ]]; do
	script_dir="$(cd -P -- "$(dirname -- "$script_source")" && pwd)"
	script_source="$(readlink -- "$script_source")"
	[[ "$script_source" != /* ]] && script_source="$script_dir/$script_source"
done
SCRIPT_DIR="$(cd -P -- "$(dirname -- "$script_source")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/$(basename -- "$script_source")"
```

Hvis du kun har brug for en absolut mappe uden symlink-opløsning, er dette nok:

```bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
```

---

## Øvelser

### 1) Direct vs. Sourced

Lav `test-source.sh`:

```bash
#!/usr/bin/env bash
echo "$0 = $0"
echo "BASH_SOURCE[0] = ${BASH_SOURCE[0]}"
```

Kør:

```bash
./test-source.sh
source ./test-source.sh
```

Spørgsmål:

- Hvad ændrer sig for `$0`?
- Hvad ændrer sig for `${BASH_SOURCE[0]}`?

### 2) Normalisering med symlink

1. Opret script i en mappe, fx:

```bash
mkdir -p ~/bin
cp test-source.sh ~/bin/test-source.sh
chmod +x ~/bin/test-source.sh
```

2. Opret symlink:

```bash
ln -sf ~/bin/test-source.sh /tmp/test-source-link
```

3. Udskriv i scriptet både rå `${BASH_SOURCE[0]}` og `SCRIPT_DIR`/`SCRIPT_PATH` fra normaliseringsmønsteret ovenfor.

4. Kør både:

```bash
/tmp/test-source-link
~/bin/test-source.sh
```

Spørgsmål:

- Hvilke værdier ændrer sig?
- Hvilken værdi er mest robust til at loade filer relativt til scriptet?
