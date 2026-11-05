# cc-commands

Sammlung persönlicher **cc-\*-Befehle**: Ein-Command-Wrapper, um Claude Code,
Codex CLI und Gemini über verschiedene freie/abonnierte Provider-Routen zu
starten — mit Modellauswahl (`<befehl>`, `<befehl> list`), Key-Verwaltung und
Übersicht (`cc list`).

Alle Befehle bestehen aus einem Bash-Skript plus `.cmd`-Wrapper (Windows:
cmd/PowerShell → Git Bash). API-Keys liegen **außerhalb** dieses Repos:

| Befehl | Route | Key/Bedingung |
|---|---|---|
| `cc` | Claude Code (eigenes Claude-Konto) | `claude` installiert |
| `cc-agent` | AgentRouter (agentrouter.org) | `~/.cc-providers/agentrouter.key` |
| `cc-blues` | BluesMinds-Gateway | `~/.bluesminds/api_key` |
| `cc-kilo` | Kilo Gateway (kilo-auto/free + mehr) | `~/.cc-providers/kilo.key` |
| `cc-nim` | NVIDIA NIM über ccr-Bridge | `~/.cc-providers/nim.key` ccr-Bridge muß auf Port 3456 laufen |
| `cc-opencode` | Kilo Auto-Free-Router | wie `cc-kilo` (delegiert auf `cc-kilo`) |
| `cc-gemini` | Gemini über Antigravity CLI (`agy`) | `agy` installiert, Google-AI-Pro-Abo |
| `codex` | OpenAI Codex CLI | `codex` installiert |
| `codex [-omni <modell>]` | OmniRoute-Autorouter | `$OMNIROUTE_API_KEY` oder `~/.cc-providers/omniroute.key` |
| `codex-omni` | wie `codex -omni` | wie oben |
| `free-astra` | Adapter-Server für Codex | Node.js |
| `cc-free-astra` | Claude Code über den free-astra-Adapter | Node.js + `claude` |

## Installation

```bash
# 1. Dieses Repo klonen (oder die Dateien kopieren) nach ~/bin:
git clone https://github.com/<user>/cc-commands.git "$HOME/bin"   # oder Dateien nach ~/bin kopieren

# 2. ~/bin in den PATH aufnehmen (Windows: User-PATH-Variable; Git Bash: .bashrc)
```

Keys anlegen (Dateinamen s. Tabelle), z. B. `~/.cc-providers/kilo.key`.
Jeder Befehl hat `help` und die meisten `list`:

```bash
cc list              # Übersicht aller Befehle + Status (Keys, ccr, agy)
cc-kilo list         # Modellliste
cc-kilo kilo-auto/free  "was du bauen willst"   # direkt starten
cc-gemini            # interaktive Modellwahl + Start
```

## Hinweise

- `codex`/`codex-omni` und einige `.cmd`-Wrapper enthalten puffern persönliche
  Pfade (`/c/Users/<Name>/...`) — bei Übernahme anpassen.
- `sk-ccr-local` in `cc-config.js`/`cc-nim` ist ein bewusster Dummy-Token für
  den lokalen claude-code-router, kein echtes Secret.
- Keys werden bewusst **nicht** mitgeliefert (`*.key` ist im `.gitignore`).
