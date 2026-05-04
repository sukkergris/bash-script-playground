# Dev Container — Ubuntu

A VS Code dev container running Ubuntu 24.04, intended as a Bash scripting playground.

## Structure

```
.devcontainer/ubuntu/
├── Dockerfile.ubuntu       # Container image definition
├── devcontainer.json       # VS Code dev container config
├── docker-compose.ubuntu.yml
└── env/
    └── .env                # Environment variables (not committed)
```

## Installed packages

| Package           | Purpose                                      |
|-------------------|----------------------------------------------|
| `build-essential` | C compiler (`gcc`) and `make` — required by Neovim Treesitter to compile language parsers |
| `curl`            | HTTP transfers                               |
| `git`             | Version control                              |
| `neovim`          | Editor                                       |

## VS Code extensions

- **Anthropic Claude Code** — AI coding assistant
- **Vim** (`vscodevim.vim`) — Vim keybindings
- **Bash Debug** (`rogalmic.bash-debug`) — Bash debugger
- **Bash IDE** (`mads-hartmann.bash-ide-vscode`) — Language server for shell scripts
- **Bashbook** — Jupyter-style notebooks for Bash
- **ShellCheck** — Shell script linter
- **EditorConfig** — Consistent editor settings
- **Code Spell Checker** (English + Danish)

## SSH agent forwarding

The container mounts the host SSH agent socket so `git` operations using SSH keys work inside the container without copying keys.

## Rebuilding

After changing `Dockerfile.ubuntu`, rebuild via VS Code:

> **Dev Containers: Rebuild Container**

Or from the CLI:

```sh
docker compose -f .devcontainer/ubuntu/docker-compose.ubuntu.yml up --build
```
