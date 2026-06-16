#!/usr/bin/env bash
set -euo pipefail

# Runs a tessl command with the tile skill symlinks temporarily materialized
# into real files, then restores the symlinks afterwards.
#
# Why: skills live once under skills/<bucket>/<name>, and each tile references
# them via symlinks (tiles/<tile>/skills/<name> -> ../../../skills/...). Tessl
# excludes symlinks from plugins for security, so `tessl eval run`, `plugin
# publish`, and `plugin pack` all fail against the tiles as-is. This wrapper
# dereferences the symlinks just long enough for Tessl to read real files,
# then puts the symlinks back so the working tree stays clean.
#
# Usage:
#   scripts/tessl-with-tiles.sh eval run tiles/engineering-skills --agent=claude:claude-sonnet-4-6
#   scripts/tessl-with-tiles.sh plugin publish tiles/productivity-skills
#
# Anything after the script name is passed straight through to `tessl`.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TILES_DIR="$REPO/tiles"

if [ "$#" -eq 0 ]; then
  echo "usage: $(basename "$0") <tessl-args...>" >&2
  echo "example: $(basename "$0") eval run tiles/engineering-skills" >&2
  exit 2
fi

command -v tessl >/dev/null 2>&1 || {
  echo "error: tessl CLI not found on PATH. Install it: curl -fsSL https://get.tessl.io | sh" >&2
  exit 1
}

# Collect every symlink under tiles/ along with its raw (unresolved) target,
# so we can restore them byte-for-byte regardless of git state.
manifest="$(mktemp)"
cleanup_done=0

restore() {
  [ "$cleanup_done" -eq 1 ] && return
  cleanup_done=1
  # Restore in reverse: drop the materialized copy, recreate the symlink.
  while IFS=$'\t' read -r link target; do
    [ -z "$link" ] && continue
    rm -rf "$link"
    ln -s "$target" "$link"
  done < "$manifest"
  rm -f "$manifest"
}
trap restore EXIT INT TERM

# -L makes find follow into the tree but still report symlinks via -type l.
while IFS= read -r link; do
  target="$(readlink "$link")"          # raw target, e.g. ../../../skills/engineering/tdd
  printf '%s\t%s\n' "$link" "$target" >> "$manifest"
  resolved="$(readlink -f "$link")"
  if [ ! -e "$resolved" ]; then
    echo "error: dangling symlink $link -> $target" >&2
    exit 1
  fi
  rm "$link"
  cp -r "$resolved" "$link"
done < <(find "$TILES_DIR" -type l)

count="$(wc -l < "$manifest" | tr -d ' ')"
echo "materialized $count tile symlink(s); running: tessl $*" >&2

# Run the requested tessl command from the repo root (where tessl.json lives).
cd "$REPO"
tessl "$@"
