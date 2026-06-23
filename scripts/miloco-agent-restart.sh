#!/usr/bin/env bash
# Fork 专属：后台重启 miloco-agent Sidecar（供管理台一键重启调用）
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export MILOCO_HOME="${MILOCO_HOME:-$HOME/.openclaw/miloco}"

pkill -f "miloco-agent" 2>/dev/null || true
sleep 1
exec env MILOCO_HOME="$MILOCO_HOME" bash "$ROOT/scripts/miloco-agent-run.sh"
