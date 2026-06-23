#!/usr/bin/env bash
# Fork 专属：启动 miloco-agent Sidecar
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="${MILOCO_AGENT_VENV:-$ROOT/miloco-agent/.venv}"

if [[ ! -d "$VENV_DIR" ]]; then
  echo "未找到 venv，请先运行: bash scripts/miloco-agent-install.sh" >&2
  exit 1
fi

# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"
export MILOCO_HOME="${MILOCO_HOME:-$HOME/.openclaw/miloco}"

exec miloco-agent
