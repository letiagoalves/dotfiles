# Firestore agent guardrail

Machine-wide hard rule for AI coding agents (Claude Code, Cursor, Antigravity IDE): **never write to
Firestore, always ask before reading it.** Applies to every project on this machine, not just this repo.

## What it does

- **Writes are hard-blocked, unconditionally.** No override, no kill switch, no exceptions for the
  emulator. If an agent needs a write done, it's expected to describe the intended write and let you do
  it by hand.
- **Reads trigger an interactive "ask" decision** in the host tool's own permission system, rather than a
  block — this fulfills "reading is allowed, but ask first."
- **Edits to a `firestore.rules` file are treated as a write** (hard-blocked) — loosening security rules
  is an indirect path to the same outcome as writing data directly.
- Every decision (write denied / read flagged for approval) is appended to `~/.firestore-guard.log` for
  audit purposes, including in unattended/background agent runs where nobody was present to see the prompt.

## How it works

One shared script, [`firestore-guard.js`](./firestore-guard.js), is wired into each tool's native
"before this tool call runs" hook. Each host passes `--tool=<claude|cursor|antigravity>` and
`--event=<shell|mcp|write>` and the event's JSON payload on stdin; the script extracts the relevant text
(shell command string, MCP tool name + args, or the file path for a write/edit call), classifies it with a
small pattern list (see "Detection" below), and returns a deny/ask/allow decision in whatever shape that
host expects.

| Tool | Global rules file (prose backstop) | Global hook config | Hard-block mechanism |
|---|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/settings.json` → `hooks.PreToolUse` (merged in, not a whole-file symlink — see below) | `permissionDecision: "deny"` / exit code 2 |
| Cursor | `~/.cursor/rules/firestore-guardrail.mdc` | `~/.cursor/hooks.json` → `beforeShellExecution` / `beforeMCPExecution` / `preToolUse` (Write), all `failClosed: true` | `permission: "deny"` / exit code 2 |
| Antigravity IDE | `~/.gemini/GEMINI.md` | `~/.gemini/config/hooks.json` → `PreToolUse` | `decision: "deny"` |

All of the above (except `~/.claude/settings.json`, which has pre-existing unrelated content) are plain
symlinks back into this directory, so editing a file here and re-running `install.sh` is enough to update
every tool.

## Setup / new machine

```
./install.sh
```

Idempotent — safe to re-run after editing any file in this directory (e.g. to tweak the pattern list).
Restart Claude Code / Cursor / Antigravity IDE afterwards so they pick up the new hook config.

`~/.claude/settings.json` already carries unrelated content (status line, plugins, etc.), so it can't be a
whole-file symlink; `install.sh` calls [`merge-claude-settings.js`](./merge-claude-settings.js) to merge in
just the `hooks.PreToolUse` entries, replacing only entries it previously added (identified by referencing
`firestore-guard.js`) so re-runs don't pile up duplicates.

## Detection ("how it decides write vs. read vs. allow")

Deliberately simple keyword/pattern matching on the literal command/call text — not adversarial-proof, just
catching the well-intentioned default case (an agent running a script or calling an SDK method directly):

- **Write**: `.set(`, `.update(`, `.add(`, `.delete(`, `.commit()`, `runTransaction(`, `batch()` (only
  when a Firestore/Firebase hint is present in the same text), plus explicit `gcloud firestore
  import|databases delete|indexes/backups/fields create|update|delete`, `firebase firestore:delete|import`,
  and any `firestore.googleapis.com` REST call using POST/PATCH/DELETE.
- **Read**: `.get(`, `.where(`, `onSnapshot(` (same Firestore-hint requirement), plus `gcloud firestore
  export`, `gcloud firestore ... list|describe|get`, and GET-method REST calls to
  `firestore.googleapis.com`.
- Anything else: passes through untouched (allow).

Update the pattern lists directly in `firestore-guard.js`, then re-run `./install.sh` — no other file needs
to change.

## Known gaps (accepted trade-offs, not bugs)

- **Indirect execution isn't inspected.** A hook sees the literal shell command / MCP call — `node
  backfill.js` gives it nothing to match on even if `backfill.js` writes to Firestore internally. Closing
  this fully isn't practical without either static analysis or blocking whole categories of script
  execution (`node *`, `python *`, ...), which was explicitly ruled out in favor of low-friction defaults.
- **Authoring write-shaped application code is not blocked**, only *executing* it is. Writing a Cloud
  Function containing `.set()` is fine; running it against real Firestore is not. `firestore.rules` is the
  one deliberate exception (see above) because it's a small, well-known, unusually sensitive file.
- **Fail-open on crash for Claude Code and Antigravity.** Cursor's hooks support `failClosed: true`
  (a hook crash/timeout/invalid-JSON is itself treated as deny); Claude Code and Antigravity's hook systems
  don't document an equivalent, so a bug in `firestore-guard.js` fails open for those two hosts. The script
  is written defensively (try/catch around everything) to make crashes unlikely, but this is a structural
  limitation of those tools, not something this script can fully close.
- **"Ask" reliability in fully autonomous/background runs is unconfirmed.** None of the three tools'
  documentation confirms what happens to an "ask" decision when there's no human present to answer it
  (e.g. `claude --dangerously-skip-permissions`, Cursor Background Agents, Antigravity autonomous runs).
  Writes are unaffected (they're a hard deny regardless). If you rely on unattended runs on Firestore-
  touching projects, treat the read-ask gate as best-effort in that mode specifically, and check
  `~/.firestore-guard.log` afterwards.
- **Antigravity tool-name matchers (`run_command`, `write_to_file`, `replace_file_content`, `mcp_.*`) are
  best-effort**, based on written docs rather than an observed real hook firing — this is the
  least-confirmed of the three integrations. If Antigravity's guard doesn't seem to trigger, check
  `~/.firestore-guard.log` for a `mismatch`-free run and inspect the actual tool names Antigravity sends
  (add a temporary `console.error(JSON.stringify(input))` to `firestore-guard.js` to inspect live payloads).
- **Mobile/native Firestore usage (iOS/Android/Flutter client SDKs) only gets the prose rules file**, not a
  working technical block — there's no shell-command/MCP-call surface for compiled app code to hook into.

## No override, by design

There is intentionally no environment variable, config flag, or documented escape hatch to disable this.
The only way to perform a Firestore write via an agent session is to edit or remove the relevant hook
config by hand — that friction is deliberate.
