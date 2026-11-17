#!/usr/bin/env bash
# close-step.sh: close one plan step in a single call.
# Marks the step checkbox in the plan, git add (listed files + plan), commit, push current branch.
#
# Usage:
#   close-step.sh -C <worktree> -p <plan.md> -s <ID> -m "<message>" [-t "<trailer>"] [--no-push] -- <file>...
#
# Relative paths (plan, files) are relative to <worktree>.
# Success: "ok <hash> <ID> <n files> push:<yes|no>" (exit 0).
# Failure: "error: <reason>" on stderr (exit 1), plan restored. Usage error: exit 2.
set -euo pipefail

WORKTREE="" PLAN="" ID="" MSG="" TRAILER="" NO_PUSH=0
BAK="" MARKED=0 ADDED=0 COMMITTED=0
FILES=()

usage() {
  echo "usage: $0 -C <worktree> -p <plan.md> -s <ID> -m \"<message>\" [-t \"<trailer>\"] [--no-push] -- <file>..." >&2
  exit 2
}
cleanup_tmp() { [ -n "$BAK" ] && rm -f "$BAK"; return 0; }
trap cleanup_tmp EXIT
fail() {
  echo "error: $*" >&2
  [ "$MARKED" = 1 ] && [ "$COMMITTED" = 0 ] && cp "$BAK" "$PLAN" || true
  if [ "$ADDED" = 1 ] && [ "$COMMITTED" = 0 ]; then
    git -C "$WORKTREE" reset -q -- "${FILES[@]}" "$PLAN_REL" >/dev/null 2>&1 || true
  fi
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    -C) [ $# -ge 2 ] || usage; WORKTREE="$2"; shift 2 ;;
    -p) [ $# -ge 2 ] || usage; PLAN="$2"; shift 2 ;;
    -s) [ $# -ge 2 ] || usage; ID="$2"; shift 2 ;;
    -m) [ $# -ge 2 ] || usage; MSG="$2"; shift 2 ;;
    -t) [ $# -ge 2 ] || usage; TRAILER="$2"; shift 2 ;;
    --no-push) NO_PUSH=1; shift ;;
    --) shift; FILES=("$@"); break ;;
    *) echo "error: unknown option: $1" >&2; exit 2 ;;
  esac
done
[ -n "$WORKTREE" ] && [ -n "$PLAN" ] && [ -n "$ID" ] && [ -n "$MSG" ] && [ ${#FILES[@]} -gt 0 ] || usage
[ -d "$WORKTREE" ] || { echo "error: worktree not found: $WORKTREE" >&2; exit 1; }
WORKTREE="$(cd "$WORKTREE" && pwd)"

PLAN_REL="${PLAN#"$WORKTREE"/}"
PLAN="$WORKTREE/$PLAN_REL"
[ -f "$PLAN" ] || fail "plan not found: $PLAN_REL"
for i in "${!FILES[@]}"; do FILES[$i]="${FILES[$i]#"$WORKTREE"/}"; done

if ! git -C "$WORKTREE" diff --cached --quiet; then
  echo "error: index already has staged changes; commit or unstage them first" >&2; exit 1
fi

BAK="$(mktemp)"
cp "$PLAN" "$BAK"

# Mark checkbox on "- [ ] **<ID>." / "- [ ] <ID>." lines (the ID is followed by "." or a space).
ESC="$(printf '%s' "$ID" | sed 's/[][\.*^$/+?(){}|]/\\&/g')"
sed -E "s/^(- )\[ \]( (\*\*)?${ESC}[. ])/\1[x]\2/" "$BAK" > "$PLAN"
MARKED=1
if cmp -s "$BAK" "$PLAN"; then
  echo "warning: checkbox for $ID not found or already marked" >&2
fi

git -C "$WORKTREE" add -- "${FILES[@]}" "$PLAN_REL" 2>/dev/null || fail "git add failed"
ADDED=1
if git -C "$WORKTREE" diff --cached --quiet; then fail "nothing staged"; fi

if [ -n "$TRAILER" ]; then
  git -C "$WORKTREE" commit -q -m "$MSG" -m "$TRAILER" >/dev/null 2>&1 || fail "commit failed"
else
  git -C "$WORKTREE" commit -q -m "$MSG" >/dev/null 2>&1 || fail "commit failed"
fi
COMMITTED=1
HASH="$(git -C "$WORKTREE" rev-parse --short HEAD)"

PUSHED=no
if [ "$NO_PUSH" = 0 ]; then
  BR="$(git -C "$WORKTREE" rev-parse --abbrev-ref HEAD)"
  git -C "$WORKTREE" push -q -u origin "$BR" >/dev/null 2>&1 || { echo "error: push failed (commit $HASH kept)" >&2; exit 1; }
  PUSHED=yes
fi
echo "ok $HASH $ID ${#FILES[@]} files push:$PUSHED"
