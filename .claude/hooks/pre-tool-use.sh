#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash) — deterministic guardrail.
# Reads the tool-call JSON on stdin, blocks dangerous shell commands.
# Exit 0 = allow. Exit 2 = BLOCK (stderr is shown to Claude as the reason).
set -uo pipefail

INPUT="$(cat)"

if command -v python3 >/dev/null 2>&1; then
  CMD="$(printf '%s' "$INPUT" | python3 -c 'import sys,json;
try:
    d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))
except Exception:
    print("")' 2>/dev/null)"
else
  CMD="$(printf '%s' "$INPUT" | tr -d '\n')"
fi

block() { echo "🛑 BLOCKED by pre-tool-use guardrail: $1" >&2; exit 2; }

case "$CMD" in
  *"rm -rf /"*|*"rm -rf ~"*|*"rm -rf ."*|*":(){ :|:&};:"*) block "destructive delete" ;;
esac
printf '%s' "$CMD" | grep -Eq '(^|[^a-zA-Z])rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f' && block "recursive force delete (rm -rf)"
printf '%s' "$CMD" | grep -Eq 'git[[:space:]]+push[[:space:]]+.*(-f|--force)([[:space:]]|$)' && block "force push (use --force-with-lease on your own branch, consciously)"
printf '%s' "$CMD" | grep -Eq 'git[[:space:]]+reset[[:space:]]+--hard' && block "git reset --hard (loses work; checkpoint first)"
printf '%s' "$CMD" | grep -Eq '(^|[^a-zA-Z])sudo([[:space:]]|$)' && block "sudo is not allowed"
printf '%s' "$CMD" | grep -Eq 'curl[[:space:]].*\|[[:space:]]*(sh|bash|zsh)' && block "curl | shell (no remote-script execution)"
printf '%s' "$CMD" | grep -Eq '>[[:space:]]*/dev/sd|mkfs|dd[[:space:]]+if=' && block "raw disk operation"

printf '%s' "$CMD" | grep -Eq '\.xcodeproj|\.xcworkspace' && \
  echo "⚠️  Note: don't hand-edit .xcodeproj/.xcworkspace internals via shell — use Xcode or the SPM manifest." >&2

exit 0
