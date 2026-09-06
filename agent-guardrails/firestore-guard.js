#!/usr/bin/env node
'use strict';

/**
 * firestore-guard.js
 *
 * Machine-wide guardrail shared by Claude Code, Cursor, and Antigravity IDE hooks.
 * See ../README.md for the full design/rationale.
 *
 * Policy (deliberately simple, not adversarial-proof — see README "Known gaps"):
 *   - Firestore WRITE-shaped shell commands / MCP calls  -> hard DENY, no override, no kill switch.
 *   - Firestore READ-shaped shell commands / MCP calls   -> ASK (host tool's interactive permission prompt).
 *   - Edits to a `firestore.rules` file                  -> hard DENY (treated as a write).
 *   - Everything else                                    -> ALLOW (pass through untouched).
 *
 * Every decision (including allow-with-a-match, if any) is appended to
 * ~/.firestore-guard.log for audit purposes.
 *
 * Invocation contract: each host's hook config passes `--tool=<claude|cursor|antigravity>`
 * and `--event=<shell|mcp|write>` as argv flags, and the event payload as JSON on stdin.
 */

const fs = require('fs');
const os = require('os');
const path = require('path');

// ---------------------------------------------------------------------------
// Argv / IO helpers
// ---------------------------------------------------------------------------

function arg(name, fallback) {
  const prefix = `--${name}=`;
  const found = process.argv.find((a) => a.startsWith(prefix));
  return found ? found.slice(prefix.length) : fallback;
}

const TOOL = arg('tool', 'unknown'); // claude | cursor | antigravity
const EVENT = arg('event', 'unknown'); // shell | mcp | write

const LOG_PATH = path.join(os.homedir(), '.firestore-guard.log');

function log(entry) {
  try {
    const line = JSON.stringify({
      ts: new Date().toISOString(),
      tool: TOOL,
      event: EVENT,
      ...entry,
    });
    fs.appendFileSync(LOG_PATH, line + '\n');
  } catch (_) {
    // Logging must never crash the guard.
  }
}

function readStdin() {
  try {
    return fs.readFileSync(0, 'utf8');
  } catch (_) {
    return '';
  }
}

// ---------------------------------------------------------------------------
// Pattern matching
// ---------------------------------------------------------------------------

// Self-sufficient: these already name Firestore explicitly, no extra hint needed.
const EXPLICIT_WRITE = [
  /gcloud\s+firestore\s+import\b/i,
  /gcloud\s+firestore\s+databases\s+delete\b/i,
  /gcloud\s+firestore\s+(indexes|backups|fields)\s+(create|update|delete)\b/i,
  /firebase\s+firestore:(delete|import)\b/i,
];

const EXPLICIT_READ = [
  /gcloud\s+firestore\s+export\b/i,
  /gcloud\s+firestore\s+(indexes|backups|fields|databases|operations)\s+(list|describe|get)\b/i,
];

// Generic method-shaped patterns — only counted when a Firestore/Firebase hint
// is present in the same text blob, to avoid flagging unrelated `.set(`/`.get(`
// calls (Map.set, axios.get, etc.) that have nothing to do with Firestore.
const GENERIC_WRITE = [
  /\.set\s*\(/,
  /\.update\s*\(/,
  /\.add\s*\(/,
  /\.delete\s*\(/,
  /\.commit\s*\(\s*\)/,
  /runTransaction\s*\(/,
  /batch\s*\(\s*\)/,
];

const GENERIC_READ = [/\.get\s*\(/, /\.where\s*\(/, /onSnapshot\s*\(/];

// MCP tool names/args rarely use method-call syntax (no `.set(`) — they name the
// operation as a bare word instead (tool name `mcp__firestore__write`, an `"op":
// "set"` field, etc). These match that word with underscore/punctuation treated
// as a boundary (MCP tool names are commonly snake_case / double-underscore
// separated, where `\b` alone does not treat `_` as a boundary).
const WRITE_VERB_IN_NAME = /(?:^|[^a-z])(write|set|update|add|delete|create|remove|put|upsert)(?:[^a-z]|$)/i;
const READ_VERB_IN_NAME = /(?:^|[^a-z])(read|get|query|list|fetch|watch|snapshot|export)(?:[^a-z]|$)/i;

const FIRESTORE_HINT = /firestore|firebase-admin|firebase\.firestore|admin\.firestore/i;
const REST_HOST = /firestore\.googleapis\.com/i;
const WRITE_METHOD = /-X\s*(POST|PATCH|DELETE)\b|--request[=\s]+(POST|PATCH|DELETE)\b/i;

function classify(text) {
  if (!text) return null;
  if (REST_HOST.test(text)) {
    return WRITE_METHOD.test(text) ? 'write' : 'read';
  }
  if (EXPLICIT_WRITE.some((re) => re.test(text))) return 'write';
  if (EXPLICIT_READ.some((re) => re.test(text))) return 'read';
  if (FIRESTORE_HINT.test(text)) {
    if (GENERIC_WRITE.some((re) => re.test(text))) return 'write';
    if (GENERIC_READ.some((re) => re.test(text))) return 'read';
    if (WRITE_VERB_IN_NAME.test(text)) return 'write';
    if (READ_VERB_IN_NAME.test(text)) return 'read';
  }
  return null;
}

function isFirestoreRulesPath(p) {
  if (!p) return false;
  const lower = String(p).toLowerCase();
  return lower.endsWith('firestore.rules') || (lower.endsWith('.rules') && lower.includes('firestore'));
}

// ---------------------------------------------------------------------------
// Per-host payload extraction
// ---------------------------------------------------------------------------

function extractText(tool, event, input) {
  try {
    if (event === 'shell') {
      if (tool === 'claude') return input?.tool_input?.command || '';
      if (tool === 'cursor') return input?.command || '';
      if (tool === 'antigravity') {
        const a = (input?.toolCall && input.toolCall.args) || {};
        return a.CommandLine || a.command_line || a.command || JSON.stringify(a);
      }
    }
    if (event === 'mcp') {
      if (tool === 'claude') {
        return `${input?.tool_name || ''} ${JSON.stringify(input?.tool_input || {})}`;
      }
      if (tool === 'cursor') {
        const rawInput =
          typeof input?.tool_input === 'string' ? input.tool_input : JSON.stringify(input?.tool_input || {});
        return `${input?.mcp_server_name || ''} ${input?.tool_name || ''} ${rawInput}`;
      }
      if (tool === 'antigravity') {
        const call = input?.toolCall || {};
        return `${call.name || ''} ${JSON.stringify(call.args || {})}`;
      }
    }
  } catch (_) {
    // fall through to empty string
  }
  return '';
}

function extractFilePath(tool, input) {
  try {
    if (tool === 'claude') return input?.tool_input?.file_path || '';
    if (tool === 'cursor') {
      return input?.tool_input?.file_path || input?.tool_input?.path || input?.file_path || input?.path || '';
    }
    if (tool === 'antigravity') {
      const a = (input?.toolCall && input.toolCall.args) || {};
      return a.TargetFile || a.AbsolutePath || a.file_path || a.path || '';
    }
  } catch (_) {
    // fall through
  }
  return '';
}

// ---------------------------------------------------------------------------
// Messages
// ---------------------------------------------------------------------------

const WRITE_REASON =
  'Firestore write blocked by machine-wide guardrail (dotfiles/agent-guardrails). ' +
  'Writes to Firestore — in any environment, including the emulator — are never permitted from an agent ' +
  'session, and there is no override. Tell the user exactly what write you intended (target collection/' +
  'document, operation, and data) so they can perform it manually if they want it done.';

const RULES_WRITE_REASON =
  'Editing firestore.rules is blocked by machine-wide guardrail (dotfiles/agent-guardrails) — changes to ' +
  'Firestore security rules are treated the same as a Firestore write, with no override. Tell the user what ' +
  'rule change you intended so they can review and apply it manually.';

const READ_REASON =
  'Firestore read requires the user\'s explicit go-ahead first (machine-wide guardrail, dotfiles/' +
  'agent-guardrails). Stop and ask the user in chat before proceeding with this read.';

// ---------------------------------------------------------------------------
// Output (host-specific decision formats)
// ---------------------------------------------------------------------------

function emitAndExit(kind, reason, matchedText) {
  log({ decision: kind || 'allow', reason: reason || null, matchedText: String(matchedText || '').slice(0, 500) });

  if (TOOL === 'claude') {
    if (kind === 'write') {
      // Exit code 2 is an unconditional block in Claude Code, overriding any JSON decision.
      process.stderr.write(reason + '\n');
      process.exit(2);
    }
    if (kind === 'read') {
      process.stdout.write(
        JSON.stringify({
          hookSpecificOutput: {
            hookEventName: 'PreToolUse',
            permissionDecision: 'ask',
            permissionDecisionReason: reason,
          },
        })
      );
      process.exit(0);
    }
    process.exit(0); // no output = allow
  }

  if (TOOL === 'cursor') {
    if (kind === 'write') {
      // Exit code 2 blocks the action the same as returning deny.
      process.stderr.write(reason + '\n');
      process.exit(2);
    }
    if (kind === 'read') {
      process.stdout.write(JSON.stringify({ permission: 'ask', user_message: reason, agent_message: reason }));
      process.exit(0);
    }
    process.stdout.write(JSON.stringify({ permission: 'allow' }));
    process.exit(0);
  }

  if (TOOL === 'antigravity') {
    if (kind === 'write') {
      process.stdout.write(JSON.stringify({ decision: 'deny', reason }));
      process.exit(0);
    }
    if (kind === 'read') {
      process.stdout.write(JSON.stringify({ decision: 'ask', reason }));
      process.exit(0);
    }
    process.stdout.write(JSON.stringify({ decision: 'allow' }));
    process.exit(0);
  }

  // Unknown host: fail open rather than jamming an unrecognized tool's agent loop.
  process.exit(0);
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

const raw = readStdin();
let input = {};
try {
  input = raw ? JSON.parse(raw) : {};
} catch (err) {
  log({ decision: 'allow', reason: 'unparseable-stdin', error: String(err) });
  emitAndExit(null, null, '');
}

try {
  if (EVENT === 'write') {
    const filePath = extractFilePath(TOOL, input);
    if (isFirestoreRulesPath(filePath)) {
      emitAndExit('write', RULES_WRITE_REASON, filePath);
    } else {
      emitAndExit(null, null, filePath);
    }
  } else {
    const text = extractText(TOOL, EVENT, input);
    const kind = classify(text);
    const reason = kind === 'write' ? WRITE_REASON : kind === 'read' ? READ_REASON : null;
    emitAndExit(kind, reason, text);
  }
} catch (err) {
  // Defensive fallback: never let a bug in this script hang or crash the host's tool
  // loop in a way that looks like something other than "allow". See README for the
  // known limitation this implies (fail-open-on-crash) for hosts without a
  // `failClosed`-style config (Claude Code, and possibly Antigravity).
  log({ decision: 'allow', reason: 'guard-internal-error', error: String(err) });
  emitAndExit(null, null, '');
}
