# Global hard rule: Firestore

**Never create or update Firestore data, in any project, in any environment (including the emulator).**
This is enforced by a `PreToolUse` hook (see `~/.gemini/config/hooks.json`, script at
`~/workspace/github.com/dotfiles/agent-guardrails/firestore-guard.js`) that hard-blocks matching terminal
commands, MCP tool calls, and edits to `firestore.rules` files. There is no override and no kill switch —
if you believe a write is genuinely needed, tell the user exactly what write you intended (collection/
document, operation, data) and let them perform it manually.

**Reading Firestore data is allowed, but always ask the user first**, in any project, in any environment.
Describe what you want to read and why, then wait for explicit approval before proceeding. The hook above
will also surface an interactive approval prompt for recognized Firestore reads, but do not rely on that
alone — treat "ask first" as your default behavior for anything Firestore-shaped even if the hook doesn't
catch it (e.g. reads buried inside a script you're about to run).
