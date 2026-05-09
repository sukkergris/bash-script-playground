# Extension 1 — fzf (fuzzy finder)

**GitHub:** https://github.com/junegunn/fzf

**Hvad er det?** 
`fzf` er en interaktiv command-line fuzzy finder. Det lader dig søge, filtrere og vælge fra tekst meget hurtigt — enten fra stdin, filer, bash history, osv.

Det ændrer hvordan du arbejder med bash. Markant.

---

## Installation

### macOS
```bash
brew install fzf

# Optionalt: installer shell-integrations (keybindings)
$(brew --prefix)/opt/fzf/install
```

### Linux (Debian/Ubuntu)
```bash
sudo apt-get install fzf
```

### Linux (manuelt / anden distro)
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Verificer installation
```bash
fzf --version
```

Hvis det virker, er du klar.

---

## Grundkoncepter

### 1. **Basisk brug: piping til fzf**

```bash
# Se liste af filer, vælg én
ls | fzf

# Se alle directories, vælg én
find . -type d | fzf
```

**Hvordan det virker:**
1. fzf åbner en interaktiv prompt
2. Du skriver bogstaver for at filtrere
3. Arrow keys eller j/k for at navigere
4. Enter for at vælge
5. Output går til stdout

---

### 2. **Return-værdier**

```bash
# Gem valget i en variabel
selected=$(ls | fzf)
echo "Du valgte: $selected"

# Hvis brugeren trykker Esc (annullerer)
if [ -z "$selected" ]; then
  echo "Intet valgt"
fi
```

---

### 3. **Praktiske eksempler**

**Åbn fil i editor**
```bash
vim $(find . -type f | fzf)
```

**Kill process interaktivt**
```bash
kill $(ps aux | fzf | awk '{print $2}')
```

**Søg gennem bash history**
```bash
<C-r>  # Trigger reverse-i-search (hvis du har installeret shell-integrationer)
```

**Hop til directory**
```bash
cd $(find ~ -type d -maxdepth 3 | fzf)
```

---

## Vigtige flag

| Flag | Hvad det gør |
|------|-------------|
| `--multi` | Tillad multi-select (Tab for at vælge, Enter for at bekræfte) |
| `--no-sort` | Bevar input-rækkefølge (default sorterer fzf) |
| `--preview` | Vis preview af valgt fil (eksempel nedenfor) |
| `--height 50%` | Begrænse fzf's højde |
| `--reverse` | Flip layout (prompt at top) |
| `--header` | Tilføj header-tekst |

---

## Eksempler med flag

**Multi-select files**
```bash
vim $(find . -type f | fzf --multi)
```

**Med preview (kræver bat eller cat)**
```bash
find . -type f | fzf --preview 'head -20 {}'
```

**Reverse layout med header**
```bash
ls | fzf --reverse --header "Vælg en fil:"
```

---

## Integration med Bash

### Trigger med keybindings (efter ./install)

Hvis du kørte `~/.fzf/install`, har du disse keybindings:

| Keybinding | Hvad det gør |
|-----------|-------------|
| `<C-t>` | Fuzzy find filer i current dir, indsæt i kommandoline |
| `<C-r>` | Fuzzy search bash history |
| `<A-c>` | Hop til directory ved fuzzy search |

**Test dem:**
```bash
# Åbn en bash shell
bash

# Tryk Ctrl+R og start at søge i history
<C-r>

# Eller tryk Ctrl+T og søg efter fil
<C-t>
```

---

## Praktisk use-case: Custom fuzzy-finder wrapper

```bash
#!/usr/bin/env bash

# Fuzzy-find og åbn fil
fuzzy_edit() {
  local file
  file=$(find . -type f | fzf --preview 'head -20 {}')
  
  if [ -n "$file" ]; then
    "${EDITOR:-vim}" "$file"
  fi
}

# Fuzzy-find og cat fil
fuzzy_cat() {
  local file
  file=$(find . -type f | fzf --preview 'head -20 {}')
  
  if [ -n "$file" ]; then
    cat "$file"
  fi
}

fuzzy_edit
```

---

## Næste skridt

- Se [opgaverne](opgaver/) for praktisk øvelse
- Læs officiel dokumentation: https://github.com/junegunn/fzf/wiki
- Eksperimenter med kombinationer: `fzf --help` viser alle flag

**Pro tip:** Kombiner fzf med `jq` for å fuzzy-select JSON-data! (Kommer i extension 2)
