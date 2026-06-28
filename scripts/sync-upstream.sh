#!/usr/bin/env bash
set -euo pipefail

# Sync this fork with mattpocock/skills (upstream).
#
# The fork tracks upstream by *merge* (see the `Merge branch 'main' of
# https://github.com/mattpocock/skills` commits in the history), so this helper
# does the mechanical, safe parts and then hands you a clean merge to resolve:
#
#   1. ensure the `upstream` remote exists
#   2. fetch upstream
#   3. cut a sync branch off the current HEAD
#   4. merge upstream/main (stopping on conflicts for you to resolve)
#   5. remind you of the post-merge invariants (and run the registry checker)
#
# It never pushes and never force-anything. Resolve conflicts with
# /resolving-merge-conflicts, then run scripts/check-registry.py --write.
#
# Usage: scripts/sync-upstream.sh [upstream-branch]   (default: main)

UPSTREAM_URL="https://github.com/mattpocock/skills"
UPSTREAM_BRANCH="${1:-main}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

if [ -n "$(git status --porcelain)" ]; then
  echo "error: working tree is dirty — commit or stash first." >&2
  exit 1
fi

# 1. upstream remote (idempotent)
if ! git remote get-url upstream >/dev/null 2>&1; then
  echo "→ adding upstream remote: $UPSTREAM_URL"
  git remote add upstream "$UPSTREAM_URL"
fi

# 2. fetch
echo "→ fetching upstream/$UPSTREAM_BRANCH"
git fetch upstream "$UPSTREAM_BRANCH"

# 3. sync branch
base="$(git branch --show-current)"
sync_branch="sync-upstream-$(date +%Y%m%d)"
echo "→ creating $sync_branch off $base"
git switch -c "$sync_branch"

# Show what's incoming in the shipped skill buckets before merging.
echo ""
echo "→ incoming changes under skills/ (engineering, productivity, misc):"
git diff --stat "HEAD...upstream/$UPSTREAM_BRANCH" -- \
  skills/engineering skills/productivity skills/misc || true
echo ""

# 4. merge (no auto-commit, so you can inspect; --no-ff to keep the merge point)
echo "→ merging upstream/$UPSTREAM_BRANCH (resolve any conflicts, then commit)"
if git merge --no-ff --no-edit "upstream/$UPSTREAM_BRANCH"; then
  echo "✓ merged with no conflicts"
else
  echo ""
  echo "✗ merge has conflicts. Resolve them, e.g. with /resolving-merge-conflicts."
  echo "  Conflict layers to expect (see README → Syncing upstream):"
  echo "    A. renamed/deleted skills  — modify/delete conflicts; re-apply by hand"
  echo "    B. body-edited skills      — to-prd/to-issues/triage/handoff + fork rewrites"
  echo "    C. registry/overlay files  — README/CLAUDE.md/CONTEXT.md/plugin.json/tiles"
  echo "  Then: git commit  &&  scripts/check-registry.py --write"
  exit 0
fi

# 5. post-merge invariants
echo ""
echo "→ regenerating registry manifests + checking READMEs"
python3 "$REPO/scripts/check-registry.py" --write || {
  echo ""
  echo "✗ README drift remains — fix the lines above by hand, then re-run the checker."
  exit 1
}

echo ""
echo "✓ sync branch $sync_branch is ready. Review, then merge it back into $base."
echo "  Don't forget: scripts/tessl-with-tiles.sh plugin lint tiles/<tile> before publishing."
