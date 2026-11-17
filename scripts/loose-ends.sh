#!/usr/bin/env bash
# loose-ends.sh: detect pending work that is not in TASKS.md (no AI).
# Usage: bash scripts/loose-ends.sh [--fix]
# --fix removes worktrees and branches already merged into the base branch (clean trees only).
# Output lines starting with "!" are loose ends: turn each into a TASKS.md item.
set -u
FIX=0; [ "${1:-}" = "--fix" ] && FIX=1
ROOT="$(git rev-parse --show-toplevel)"
TASKS="$ROOT/TASKS.md"
BASE="$(git -C "$ROOT" rev-parse --verify -q main >/dev/null && echo main || echo master)"
alerts=0
alert() { echo "  ! $*"; alerts=$((alerts+1)); }
registered() { local x; for x in "$@"; do grep -q -- "$x" "$TASKS" && return 0; done; return 1; }

echo "== Worktrees =="
git -C "$ROOT" worktree list --porcelain | awk '/^worktree/{w=$2} /^branch/{sub("refs/heads/","",$2); print w" "$2}' |
while read -r wt br; do
  [ "$br" = "$BASE" ] && continue
  [ "$wt" = "$ROOT" ] && continue
  n="$(git -C "$ROOT" rev-list --count "$BASE..$br" 2>/dev/null || echo 0)"
  if [ "$n" = 0 ]; then
    if [ "$FIX" = 1 ] && [ -z "$(git -C "$wt" status --porcelain 2>/dev/null)" ]; then
      git -C "$ROOT" worktree remove "$wt" && git -C "$ROOT" branch -d "$br" >/dev/null && echo "  ok removed merged worktree $br"
    else alert "worktree $br already merged and still open: remove it"; fi
    continue
  fi
  echo "- $br: $n commits ahead of $BASE"
  registered "$br" || alert "worktree $br has no item in TASKS.md"
done

echo "== Merged branches without worktree =="
git -C "$ROOT" branch --merged "$BASE" --format='%(refname:short) %(worktreepath)' | awk -v b="$BASE" '$1!=b && $2==""{print $1}' |
while read -r br; do
  if [ "$FIX" = 1 ]; then git -C "$ROOT" branch -d "$br" >/dev/null && echo "  ok deleted merged branch $br"
  else alert "branch $br merged: delete it"; fi
done

echo "== Cards in 'doing' without a TASKS.md item =="
grep -rl '^status: doing' "$ROOT/backlog" 2>/dev/null | while read -r f; do
  id="$(basename "$f" .md | grep -oE '^[A-Z0-9]+-[0-9]+')"
  [ -n "$id" ] && ! grep -q "$id" "$TASKS" && alert "$id is doing but not in TASKS.md"
done

echo "== done (use --fix for safe cleanups; the rest becomes TASKS.md items) =="
