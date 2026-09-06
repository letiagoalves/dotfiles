#!/usr/bin/env bash
# Installs the Firestore guardrail (see README.md) into Claude Code, Cursor, and
# Antigravity IDE's global config on this machine. Idempotent: safe to re-run,
# including on a fresh machine after cloning this dotfiles repo.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARD_SCRIPT="$REPO_DIR/firestore-guard.js"

echo "==> Firestore guardrail install (repo: $REPO_DIR)"

chmod +x "$GUARD_SCRIPT"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  already linked: $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="${dest}.pre-firestore-guard.bak"
    echo "  backing up existing $dest -> $backup"
    mv "$dest" "$backup"
  fi
  ln -s "$src" "$dest"
  echo "  linked: $dest -> $src"
}

# --- Claude Code -------------------------------------------------------------
link "$REPO_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

CLAUDE_SETTINGS="$HOME/.claude/settings.json"
node "$REPO_DIR/merge-claude-settings.js" "$CLAUDE_SETTINGS" "$REPO_DIR/claude/hooks-fragment.json"
echo "  merged hooks into: $CLAUDE_SETTINGS"

# --- Cursor --------------------------------------------------------------------
link "$REPO_DIR/cursor/hooks.json" "$HOME/.cursor/hooks.json"
link "$REPO_DIR/cursor/rules" "$HOME/.cursor/rules"

# --- Antigravity IDE (Gemini) --------------------------------------------------
link "$REPO_DIR/gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md"
link "$REPO_DIR/gemini/hooks.json" "$HOME/.gemini/config/hooks.json"

echo "==> Done. Audit log will be written to: $HOME/.firestore-guard.log"
echo "==> Restart Claude Code / Cursor / Antigravity IDE sessions to pick up the new hooks."
