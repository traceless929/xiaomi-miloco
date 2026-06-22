#!/usr/bin/env bash
# 检查当前分支相对 upstream/main 的 diff 是否误含 fork 专属文件。
# 用法: bash scripts/check-upstream-pr.sh [base-ref]
# 默认 base-ref=upstream/main

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="${1:-upstream/main}"
MANIFEST="${ROOT}/.fork-only"

if ! git -C "$ROOT" rev-parse --verify "$BASE" >/dev/null 2>&1; then
  echo "[check-upstream-pr] 找不到 base ref: $BASE" >&2
  echo "请先: git fetch upstream" >&2
  exit 2
fi

if [[ ! -f "$MANIFEST" ]]; then
  echo "[check-upstream-pr] 缺少 $MANIFEST" >&2
  exit 2
fi

violations=()
while IFS= read -r pattern || [[ -n "$pattern" ]]; do
  [[ -z "$pattern" || "$pattern" =~ ^[[:space:]]*# ]] && continue
  pattern="${pattern%/}"
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    if [[ "$f" == "$pattern" || "$f" == "$pattern/"* ]]; then
      violations+=("$f")
    fi
  done < <(git -C "$ROOT" diff --name-only "$BASE"...HEAD)
done < "$MANIFEST"

if [[ ${#violations[@]} -gt 0 ]]; then
  echo "[check-upstream-pr] 以下 fork 专属文件出现在相对 $BASE 的变更中，请勿纳入官方 PR:" >&2
  # 去重
  printf '%s\n' "${violations[@]}" | sort -u | while IFS= read -r v; do
    echo "  - $v" >&2
  done
  exit 1
fi

echo "[check-upstream-pr] OK — 相对 $BASE 无 fork 专属文件"
