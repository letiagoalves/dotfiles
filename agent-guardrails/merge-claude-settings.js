#!/usr/bin/env node
'use strict';

/**
 * Idempotently merges the Firestore guardrail's PreToolUse hooks into an existing
 * ~/.claude/settings.json without disturbing any other content in that file.
 *
 * Usage: node merge-claude-settings.js <path-to-settings.json> <path-to-hooks-fragment.json>
 */

const fs = require('fs');

const [, , settingsPath, fragmentPath] = process.argv;
if (!settingsPath || !fragmentPath) {
  console.error('Usage: merge-claude-settings.js <settings.json> <hooks-fragment.json>');
  process.exit(1);
}

function readJson(p, fallback) {
  if (!fs.existsSync(p)) return fallback;
  const raw = fs.readFileSync(p, 'utf8').trim();
  if (!raw) return fallback;
  return JSON.parse(raw);
}

const settings = readJson(settingsPath, {});
const fragment = readJson(fragmentPath, { hooks: {} });

settings.hooks = settings.hooks || {};

const GUARD_MARKER = 'firestore-guard.js';

for (const [event, fragmentEntries] of Object.entries(fragment.hooks || {})) {
  const existing = Array.isArray(settings.hooks[event]) ? settings.hooks[event] : [];

  // Drop any prior entries this installer added (identified by referencing our
  // guard script), so re-running install.sh after editing the fragment doesn't
  // pile up duplicates.
  const kept = existing.filter((entry) => {
    const inner = Array.isArray(entry.hooks) ? entry.hooks : [];
    return !inner.some((h) => typeof h.command === 'string' && h.command.includes(GUARD_MARKER));
  });

  settings.hooks[event] = [...kept, ...fragmentEntries];
}

fs.mkdirSync(require('path').dirname(settingsPath), { recursive: true });
fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + '\n');
