#!/usr/bin/env bash
# Rename files so `ls` never needs to quote them: spaces become a separator
# character (default `_`, override with --space-char), any other non-portable
# character is dropped, and repeated separator characters collapse to one.
#
# Usage: rename_sanitize.sh [-n] [--space-char CHAR] [directory]
set -euo pipefail

dry_run=false
space_char="_"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n)
      dry_run=true
      shift
      ;;
    --space-char)
      space_char="${2:-}"
      shift 2
      ;;
    --space-char=*)
      space_char="${1#*=}"
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ ${#space_char} -ne 1 ]]; then
  echo "--space-char must be a single character" >&2
  exit 1
fi

dir="${1:-.}"

for f in "$dir"/*; do
  [[ -f "$f" ]] || continue
  base=$(basename -- "$f")

  new="${base// /$space_char}"
  new="${new//[^${space_char}A-Za-z0-9._-]/}"
  while [[ "$new" == *"$space_char$space_char"* ]]; do
    new="${new//$space_char$space_char/$space_char}"
  done
  new="${new#"$space_char"}"
  new="${new%"$space_char"}"

  [[ -z "$new" || "$new" == "$base" ]] && continue

  target="$new"
  if [[ -e "$dir/$target" ]]; then
    stem="${new%.*}"
    ext="${new##*.}"
    [[ "$stem" == "$ext" ]] && ext=""
    n=1
    while [[ -e "$dir/$target" ]]; do
      if [[ -n "$ext" ]]; then
        target="${stem}${space_char}${n}.${ext}"
      else
        target="${stem}${space_char}${n}"
      fi
      ((n++))
    done
  fi

  if $dry_run; then
    echo "$base -> $target"
  else
    mv -n -- "$dir/$base" "$dir/$target"
  fi
done
