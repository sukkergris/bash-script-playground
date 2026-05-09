# Basics: Installation af programmer på Linux

Når du skal installere programmer på Linux, er der flere forskellige måder. Hver metode har fordele og ulemper.

---

## 5 måder at installere programmer på Linux

### 1. **Package manager (apt, dnf, pacman)**

**Hvad:** Dit system har en *package manager* som håndterer installationer centralt.

**For Linux (Debian/Ubuntu):**
```bash
apt-get update           # Hent liste over tilgængelige pakker
apt-get install fzf      # Installer programmet
apt-get remove fzf       # Fjern programmet
apt-cache search fzf     # Søg efter pakke
```

**Fordele:**
- ✅ Nemmest og hurtigst
- ✅ Automatisk afhængighedsstyring
- ✅ Centraliseret opdatering via `apt-get upgrade`
- ✅ Virker på alle systemer med samme distro

**Ulemper:**
- ❌ Pakken skal være tilgængelig i repository
- ❌ Ofte ikke den nyeste version
- ❌ Kræver `sudo`

**Hvornår:** Når programmet findes i officielt repository og versionen er "god nok".

---

### 2. **Download fra GitHub releases**

**Hvad:** Hent en pre-compiled binary direkte fra GitHub.

**Eksempel (fzf):**
```bash
# Find seneste version på https://github.com/junegunn/fzf/releases
VERSION="0.46.1"
URL="https://github.com/junegunn/fzf/releases/download/v${VERSION}/fzf-${VERSION}-linux_amd64.tar.gz"

# Download
curl -fL "$URL" -o /tmp/fzf.tar.gz

# Pak ud
tar -xzf /tmp/fzf.tar.gz -C /tmp

# Installer
sudo mv /tmp/fzf /usr/local/bin/
sudo chmod +x /usr/local/bin/fzf

# Verificer
fzf --version
```

**Fordele:**
- ✅ Altid den nyeste version
- ✅ Uafhængig af repository
- ✅ Kan installeres uden `sudo` (til `$HOME`)

**Ulemper:**
- ❌ Skal selv håndtere afhængigheder
- ❌ Skal selv opdatere
- ❌ Binæren kan være ukompatibel med dit system

**Hvornår:** Når du vil have den seneste version eller programmet ikke er i repository.

---

### 3. **Kompilering fra kilde**

**Hvad:** Download kildekoden, kompiler og installer selv.

**Eksempel (fzf fra git):**
```bash
# Clone repository
git clone https://github.com/junegunn/fzf.git ~/fzf

# Gå ind i folderen
cd ~/fzf

# Byg
./install --bin

# Verificer
./fzf --version
```

**Fordele:**
- ✅ Fuld kontrol over compilation
- ✅ Kan tilpasse til dit system
- ✅ Nyeste udviklingskode

**Ulemper:**
- ❌ Kræver compiler (gcc, make, osv.)
- ❌ Langt længere installation
- ❌ Kan mislykkes hvis afhængigheder mangler
- ❌ Højere resource-forbrug under build

**Hvornår:** Når du har specielle krav eller udvikler på programmet.

---

### 4. **Shell script installer**

**Hvad:** Programmet leverer et installationsscript.

**Eksempel (fzf's installationscript):**
```bash
# Git clone
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# Kør installationsscript
~/.fzf/install

# Script spørger om keybindings osv.
# Afterward: Verify
fzf --version
```

**Fordele:**
- ✅ Automatiseret og enkel
- ✅ Script håndterer details
- ✅ Ofte tilpasser sig dit system

**Ulemper:**
- ❌ Skal stole på scriptets kvalitet
- ❌ Kan være svært at få kontrol over installation
- ❌ Svært at fjerne "rent" igen

**Hvornår:** Når programmet leverer sit eget installationsscript.

---

### 5. **Manuelt: download, unzip, add to PATH**

**Hvad:** Helt manuel installation uden hjælp fra package manager.

**Eksempel (fzf):**
```bash
# Download binary
wget https://github.com/junegunn/fzf/releases/download/v0.46.1/fzf-0.46.1-linux_amd64.tar.gz

# Pak ud til $HOME
mkdir -p ~/.local/bin
tar -xzf fzf-0.46.1-linux_amd64.tar.gz -C ~/.local/bin

# Tilføj til PATH i ~/.bashrc eller ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Reload shell
source ~/.bashrc

# Verificer
fzf --version
```

**Fordele:**
- ✅ Ingen `sudo` nødvendigt
- ✅ Har kontrol over hvor det installeres
- ✅ Nemt at fjerne (delete folder)

**Ulemper:**
- ❌ Skal selv håndtere alt
- ❌ Skal selv opdatere
- ❌ Kan blive uorganiseret

**Hvornår:** Når du vil have fuldt kontrol og ikke skal dele system med andre.

---

## Sammenligning

| Metode | Nem | Opdater | Kontrol | Nyeste | Dependencies | Sudo |
|--------|-----|---------|---------|--------|--------------|------|
| apt | ⭐⭐⭐⭐⭐ | Auto | Lav | ❌ | Auto | ✅ |
| GitHub binary | ⭐⭐⭐⭐ | Manual | Medium | ✅ | Nej | ✅ |
| Compile | ⭐⭐ | Manual | ⭐⭐⭐⭐⭐ | ✅ | Manual | ✅ |
| Script | ⭐⭐⭐⭐ | Variabel | Medium | Ofte | Auto | ✅ |
| Manual | ⭐⭐⭐ | Manual | ⭐⭐⭐⭐⭐ | ✅ | Nej | ❌ |

---

## Best practice

**Prioritets-orden:**

1. **Prøv først apt/package manager** — Hvis programmet findes og version er ok
2. **GitHub binary hvis apt er for gammelt** — Når du skal have nyere version
3. **Compile kun hvis nødvendigt** — Når du har specielle krav
4. **Script installer hvis leverandør leverer det** — Lad værktøjet selv installere sig
5. **Manuel installation for $HOME-binaries** — Når du ikke vil have `sudo`

---

## Næste skridt

Se [opgaverne](opgaver/) for praktiske øvelser med alle 5 metoder.
