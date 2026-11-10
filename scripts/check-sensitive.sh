#!/usr/bin/env bash
# Scans tracked and untracked files for sensitive terms, then runs gitleaks if installed.
# Patterns file: one extended regex per line. Blank lines and lines starting with "#" are ignored.
# Default patterns file: <repo>/.sensitive-terms (git-ignored, keep it local).
# Usage: scripts/check-sensitive.sh [patterns-file]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
TERMS="${1:-$ROOT/.sensitive-terms}"

if [ ! -f "$TERMS" ]; then
  cat >&2 <<EOF
warning: no patterns file at $TERMS. Sensitive-term scan skipped.
Create it (it is git-ignored) with one extended regex per line. Lines starting with '#' are comments. Example:
  # client names
  client-codename-a
  # private hostnames
  internal-host-[0-9]+
EOF
  exit 0
fi

# Load and validate patterns. Patterns are never printed: they may themselves be sensitive.
PATTERNS=()
LINENOS=()
lineno=0
while IFS= read -r pat || [ -n "$pat" ]; do
  lineno=$((lineno + 1))
  case "$pat" in
    ''|'#'*) continue ;;
  esac
  rc=0
  grep -E -- "$pat" /dev/null >/dev/null 2>&1 || rc=$?
  if [ "$rc" -gt 1 ]; then
    echo "error: invalid regex at $TERMS line $lineno" >&2
    exit 2
  fi
  PATTERNS+=("$pat")
  LINENOS+=("$lineno")
done < "$TERMS"

status=0

if [ ${#PATTERNS[@]} -eq 0 ]; then
  echo "ok: no patterns in $TERMS"
else
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    FILES="$(git ls-files --cached --others --exclude-standard)"
  else
    FILES="$(find . -path ./.git -prune -o -type f -print | sed 's|^\./||')"
  fi

  found=0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    [ -f "$f" ] || continue
    if [ "$f" -ef "$TERMS" ]; then
      continue
    fi
    for ((i = 0; i < ${#PATTERNS[@]}; i++)); do
      nums="$(grep -nIE -- "${PATTERNS[$i]}" "$f" 2>/dev/null | cut -d: -f1 || true)"
      while IFS= read -r ln; do
        [ -n "$ln" ] || continue
        echo "  $f:$ln (matches pattern on $TERMS line ${LINENOS[$i]})"
        found=$((found + 1))
      done <<< "$nums"
    done
  done <<< "$FILES"

  if [ "$found" -gt 0 ]; then
    echo "sensitive-check: FAILED, $found match(es). Remove or generalize them."
    status=1
  else
    echo "ok: no sensitive terms found"
  fi
fi

if command -v gitleaks >/dev/null 2>&1; then
  echo "running gitleaks..."
  gitleaks detect --no-banner || status=1
else
  echo "note: gitleaks not installed, secret scan skipped (CI runs it)"
fi

exit "$status"
