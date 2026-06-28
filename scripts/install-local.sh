#!/usr/bin/env bash
set -euo pipefail

# Install the local working copy of one or more tiles straight into a target
# repo, bypassing the Tessl registry. Use this when you've changed a skill and
# don't want to wait for the publish pipeline (merge -> calver bump -> publish)
# to land the new version in the registry.
#
# Tessl excludes symlinks from plugins, and each tile's skills are symlinks into
# ../../../skills. So we copy the tile to .local-dist/<tile> with symlinks
# dereferenced (cp -RL), then `tessl install` that real-file copy. This never
# mutates the working tree (unlike tessl-with-tiles.sh, which materializes in
# place only because `tessl eval run` must run inside the linked project dir).
#
# The dereferenced copy is PERSISTENT (gitignored .local-dist/), not a temp dir,
# because `tessl install` records the install path as a `file:` source in the
# target's tessl.json. A temp dir would leave a dead path the moment this script
# exits, breaking `tessl install`/`update`/sync there. .local-dist/ lives on this
# machine, so that file: source keeps resolving.
#
# Consequence for the target repo: its tessl.json dependency is rewritten from a
# registry version pin to `source: file:<abs path to .local-dist/<tile>>`. That
# path is machine-local — do NOT commit it. To return the target to a published
# version: `tessl install bonai-dev/<tile>@<version>` (or revert tessl.json).
#
# Usage (run from inside the consumer repo, or pass --target):
#   /abs/path/to/skills/scripts/install-local.sh                  # both tiles -> cwd
#   scripts/install-local.sh engineering-skills                   # one tile -> cwd
#   scripts/install-local.sh --target ~/code/app                  # both tiles -> another repo
#   scripts/install-local.sh --global engineering-skills          # install globally (~/.tessl)
#
# Positional args are tile names (dir names under tiles/); omit them for all
# tiles. Re-run after each skill change to refresh both .local-dist/ and the
# target.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TILES_DIR="$REPO/tiles"

target="$PWD"
global_flag=()
tiles=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      [ "$#" -ge 2 ] || { echo "error: --target needs a directory" >&2; exit 2; }
      target="$2"; shift 2 ;;
    --global)
      global_flag=(--global); shift ;;
    -h|--help)
      sed -n '3,30p' "$0"; exit 0 ;;
    -*)
      echo "error: unknown flag $1" >&2; exit 2 ;;
    *)
      tiles+=("$1"); shift ;;
  esac
done

command -v tessl >/dev/null 2>&1 || {
  echo "error: tessl CLI not found on PATH. Install it: curl -fsSL https://get.tessl.io | sh" >&2
  exit 1
}

# Default to every tile under tiles/.
if [ "${#tiles[@]}" -eq 0 ]; then
  for d in "$TILES_DIR"/*/; do tiles+=("$(basename "$d")"); done
fi

target="$(cd "$target" && pwd)"
# Installing into the skills repo itself would write the consumer-side .tessl/
# plugin copies back into the source tree. Refuse.
case "$target" in
  "$REPO"|"$REPO"/*)
    echo "error: --target ($target) is inside the skills repo; install into a consumer repo instead" >&2
    exit 1 ;;
esac

# Persistent, gitignored materialization dir. tessl.json in the target will point
# its file: source here, so this must outlive the script (see header).
staging="$REPO/.local-dist"
mkdir -p "$staging"

for tile in "${tiles[@]}"; do
  src="$TILES_DIR/$tile"
  [ -f "$src/.tessl-plugin/plugin.json" ] || {
    echo "error: no tile '$tile' (expected $src/.tessl-plugin/plugin.json)" >&2
    exit 1
  }
  # -RL dereferences the skill symlinks into real files so Tessl ingests them.
  # Refresh from scratch each run so removed skills don't linger.
  rm -rf "$staging/$tile"
  cp -RL "$src" "$staging/$tile"
  echo "==> installing $tile -> $target"
  ( cd "$target" && tessl install "$staging/$tile" --yes ${global_flag[@]+"${global_flag[@]}"} )
done
