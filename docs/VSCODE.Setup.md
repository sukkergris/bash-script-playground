# VS Code Setup

## Dansk Spell Check

For at aktivere dansk stavekontrol i VS Code:

1. Installer extension: **"Danish - Code Spell Checker"** (af Street Side Software)
2. Åbn Settings (`Ctrl+,` eller `Cmd+,`)
3. Søg efter `cSpell.language`
4. Sæt værdi til: `da` (eller `en,da` hvis du også vil have engelsk)

Alternativt, tilføj direkte i `.vscode/settings.json`:
```json
"cSpell.language": "da"
```

Efter dette vil dansk i kommentarer og tekst blive stavekontrolleret.
