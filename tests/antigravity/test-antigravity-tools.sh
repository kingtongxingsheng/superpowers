#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

fail() { echo "FAIL: $*" >&2; exit 1; }

[ ! -e "$REPO_ROOT/skills/using-superpowers" ] || fail "obsolete bootstrap skill remains"
[ ! -e "$REPO_ROOT/skills/using-superpowers/SKILL.md" ] || fail "obsolete bootstrap file remains"

echo "PASS: Antigravity has no bootstrap skill dependency"
