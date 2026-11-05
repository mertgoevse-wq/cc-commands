#!/usr/bin/env bash
# cc — Übersicht via `cc list`, sonst Claude Code (delegiert auf cc.cmd)
if [ "${1:-}" = "list" ]; then shift; exec bash "$HOME/bin/cc-list" "$@"; fi
exec claude "$@"
