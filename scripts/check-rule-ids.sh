#!/usr/bin/env bash
# Checks requirement IDs (R-AREA-NN) across spec files.
# Fails on: duplicate IDs across specs, malformed R- definitions, spec files with no IDs.
# Skips README.md and files whose name starts with "_".
# Usage: scripts/check-rule-ids.sh [specs-dir]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPECS_DIR="${1:-$ROOT/specs}"

if [ ! -d "$SPECS_DIR" ]; then
  echo "error: specs directory not found: $SPECS_DIR" >&2
  exit 1
fi

# A definition line starts with the ID, optionally after "- ", "| " or "N. ".
PREFIX='(- |[|] |[0-9]+[.] )?'
STRICT='R-[A-Z]+-[0-9]{2}'

files=()
for f in "$SPECS_DIR"/*.md; do
  [ -e "$f" ] || continue
  case "$(basename "$f")" in
    README.md|_*) continue ;;
  esac
  files+=("$f")
done

if [ ${#files[@]} -eq 0 ]; then
  echo "ok: no spec files to check"
  exit 0
fi

status=0
index="$(mktemp)"
trap 'rm -f "$index"' EXIT

for f in "${files[@]}"; do
  rel="${f#"$ROOT"/}"

  # Malformed: a line that starts an "R-..." token before its colon, but is not R-AREA-NN.
  bad="$(grep -nE "^${PREFIX}R-[^: ]*:" "$f" | grep -vE "^[0-9]+:${PREFIX}${STRICT}:" || true)"
  if [ -n "$bad" ]; then
    echo "malformed ID in $rel (expected R-AREA-NN, uppercase area, two digits), at line(s):"
    echo "$bad" | cut -d: -f1 | sed 's/^/  line /'
    status=1
  fi

  defs="$(grep -nE "^${PREFIX}${STRICT}:" "$f" || true)"
  if [ -z "$defs" ]; then
    echo "no requirement IDs defined in $rel (expected lines like 'R-AREA-01: ...')"
    status=1
    continue
  fi

  echo "$defs" | grep -oE "${STRICT}:" | tr -d ':' | awk -v f="$rel" '{ print $0, f }' >> "$index"
done

dups="$(awk '{ print $1 }' "$index" | sort | uniq -d || true)"
if [ -n "$dups" ]; then
  while IFS= read -r id; do
    echo "duplicate ID $id defined in:"
    awk -v id="$id" '$1 == id { print "  " $2 }' "$index"
  done <<< "$dups"
  status=1
fi

if [ "$status" -ne 0 ]; then
  echo "rule-ids: FAILED"
  exit 1
fi

count="$(awk 'END { print NR }' "$index")"
echo "ok: $count requirement IDs in ${#files[@]} spec file(s)"
