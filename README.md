# cc-commands

Sammlung persönlicher **cc-\*-Befehle**: Ein-Command-Wrapper, um Claude Code,
Codex CLI und Gemini über verschiedene freie/abonnierte Provider-Routen zu
starten — mit Modellauswahl (`<befehl>`, `<befehl> list`), **Live-Verfügbarkeit
je Modell** und Übersicht (`cc list`).

Alle Befehle bestehen aus einem Bash-Skript plus `.cmd`-Wrapper (Windows:
cmd/PowerShell → Git Bash). API-Keys liegen **außerhalb** dieses Repos
(`~/.cc-providers`, `~/.bluesminds`).

| Befehl | Route | Key/Bedingung |
|---|---|---|
| `cc` | Claude Code (eigenes Claude-Konto) | `claude` installiert |
| `cc-agent` | AgentRouter (agentrouter.org) | `~/.cc-providers/agentrouter.key` |
| `cc-blues` | BluesMinds-Gateway | `~/.bluesminds/api_key` |
| `cc-kilo` | Kilo Gateway | `~/.cc-providers/kilo.key` |
| `cc-nim` | NVIDIA NIM über ccr-Bridge | `~/.cc-providers/nim.key` — ccr-Setup s. u. |
| `cc-opencode` | Kilo Auto-Free-Router | wie `cc-kilo` (delegiert auf `cc-kilo`) |
| `cc-gemini` | Gemini über Antigravity CLI (`agy`) | Google-AI-Pro-Abo |
| `codex` | OpenAI Codex CLI | `codex` installiert |
| `codex -omni` / `codex-omni` | OmniRoute-Autorouter | `$OMNIROUTE_API_KEY` oder `~/.cc-providers/omniroute.key` |
| `free-astra` | Adapter-Server für Codex | Node.js |
| `cc-free-astra` | Claude Code über free-astra | Node.js + `claude` |

## Live-Modellstatus

Die Listen zeigen, **welche Modelle gerade wirklich erreichbar sind**:

```
Nr.  OK Modell
1    ✓  [FREE] kilo-auto/free          ← jetzt nutzbar
2    ✗  some-model-v1                  ← momentan kein Backend
3    !  openai/gpt-oss-20b             ← Rate-Limit (gedrosselt, aber vorhanden)
```

- `✓` erreichbar · `!` Rate-Limit · `✗` nicht verfügbar · `?` unsicher (Timeout)
- **cc-kilo/cc-opencode**: Status aus den Metadaten (`inference_provider_ids`,
  `autoRouting`-Router sind immer erreichbar).
- **cc-blues, cc-nim**: echte Live-Probe (1 Mini-Request `max_tokens=1` je Modell,
  parallel). `cc-nim list` zeigt bei Embedding-Modellen korrekt `✗` (kein Chat-Format).
- **cc-agent**: keine Probe möglich — AgentRouter antwortet Nicht-Claude-Clients
  grundsätzlich mit 401 ("unauthorized client detected"). Liste daher unverifiziert.

## ccr-Setup (nur für `cc-nim`)

NVIDIA NIM spricht OpenAI-Format; Claude Code braucht Anthropic-Format.
Die Übersetzung übernimmt **claude-code-router (ccr)** als lokale Bridge:

```bash
# 1. Install (falls fehlend):
npm install -g @musistudio/claude-code-router

# 2. Bridge starten (oder einfach cc-nim aufrufen — es startet sie selbst):
ccr start          # lauscht danach auf http://127.0.0.1:3456

# 3. Test, ob die Bridge läuft:
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:3456
```

`cc-nim` prüft die Bridge automatisch vor dem Start und holt sie hoch, wenn sie
fehlt. Details zur Routing-Config verwaltet `cc-config.js` (`nvidia-nim`-Provider).

## Installation

```bash
git clone https://github.com/<user>/cc-commands.git "$HOME/bin"   # oder Dateien nach ~/bin kopieren
# ~/bin in den PATH aufnehmen (Windows: User-PATH-Variable; Git Bash: .bashrc)
```

Keys anlegen (Dateinamen s. Tabelle, z. B. `~/.cc-providers/kilo.key`).

```bash
cc list                       # Übersicht aller Befehle + Statuszeile (Keys, ccr, agy)
cc-kilo list                  # Modellliste mit Verfügbarkeit
cc-kilo                       # interaktive Auswahl + Start
cc-blues list && cc-nim list llama && cc-agent
codex-omni exec "What is 2+2?"          # OmniRoute über Default auto/best-free
codex -omni exec --skip-git-repo-check "..."
```

## Hinweise

- Einige Skripte enthalten persönliche Pfade (`/c/Users/<Name>/...`) — bei
  Übernahme anpassen (u. a. `codex`, `codex-omni`, die `.cmd`-Wrapper).
- `codex-omni`/`codex -omni`: Default ist `auto/best-free` (läuft direkt am
  lokalen OmniRoute-Router). `omniroute/auto` braucht zusätzlich eine aktive
  Cloud-Verbindung im Router (`omniroute providers add omniroute ...`).
  Der Router selbst läuft als `omniroute`-npm-Dienst (Port 20128).
- `sk-ccr-local` in `cc-config.js`/`cc-nim` ist ein bewusster Dummy-Token für
  den lokalen ccr, kein echtes Secret.
- Keys werden bewusst **nicht** mitgeliefert (`*.key` ist im `.gitignore`).
