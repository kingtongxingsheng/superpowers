#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOOK_UNDER_TEST="$REPO_ROOT/hooks/session-start"

output="$(CLAUDE_PLUGIN_ROOT="$REPO_ROOT" bash "$HOOK_UNDER_TEST")"

if [ -n "$output" ]; then
    echo "FAIL: SessionStart hook must not inject context" >&2
    exit 1
fi

node -e '
const hooks = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
if (Object.keys(hooks.hooks || {}).length !== 0) {
  throw new Error("hooks.json must not register SessionStart hooks");
}
' "$REPO_ROOT/hooks/hooks.json"

echo "PASS: SessionStart bootstrap is disabled"
