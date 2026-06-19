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
#
# Mutates the working tree in place (rather than packing to a temp dir) because
# `tessl eval run` must execute inside the linked project directory — running it
# from a copy elsewhere breaks project resolution. The restore trap keeps the
# tree clean. Do not run two copies concurrently: they share the same tile
# symlinks (e.g. tracker-primitives) and would corrupt each other's restore.

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
# Pre-flight: fail before mutating anything if any tile symlink is dangling, so
# an aborted run can never leave a half-materialized working tree.
while IFS= read -r link; do
  if [ ! -e "$(readlink -f "$link")" ]; then
    echo "error: dangling symlink $link -> $(readlink "$link")" >&2
    exit 1
  fi
done < <(find "$TILES_DIR" -type l)

# Arm the restore trap only now that the pre-flight passed and we are about to
# mutate the tree.
trap restore EXIT INT TERM

# Plain -type l (no -L): report the tile's top-level skill symlinks without
# descending through them. Record each link before rm so restore can recreate
# it even if a later copy fails.
while IFS= read -r link; do
  target="$(readlink "$link")"          # raw target, e.g. ../../../skills/engineering/tdd
  resolved="$(readlink -f "$link")"
  printf '%s\t%s\n' "$link" "$target" >> "$manifest"
  rm "$link"
  cp -r "$resolved" "$link"
done < <(find "$TILES_DIR" -type l)

count="$(wc -l < "$manifest" | tr -d ' ')"
echo "materialized $count tile symlink(s); running: tessl $*" >&2

# Default eval agent — injected when running eval run without an explicit --agent flag.
EVAL_AGENT="${TESSL_EVAL_AGENT:-claude:glm-5.1}"
args=("$@")
if [[ "${args[0]:-}" == "eval" && "${args[1]:-}" == "run" ]]; then
  has_agent=0
  for a in "${args[@]}"; do
    [[ "$a" == --agent* ]] && has_agent=1 && break
  done
  [[ "$has_agent" -eq 0 ]] && args=("${args[0]}" "${args[1]}" "--agent" "$EVAL_AGENT" "${args[@]:2}")
fi

# Run the requested tessl command from the repo root (where tessl.json lives).
cd "$REPO"
tessl "${args[@]}"
