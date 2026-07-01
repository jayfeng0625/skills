#!/usr/bin/env bash
set -euo pipefail

# Symlink this repo's skills straight into the local agent skill directories so
# that edits to the working copy are live with no reinstall step. A direct
# symlink points at the working copy, so a skill's changes take effect
# immediately; linked skills are invocable under their bare frontmatter name
# (e.g. /tdd).
#
# Default destinations (no --target): the machine-wide agent dirs
#   ~/.claude/skills   Claude Code
#   ~/.agents/skills   pi and other Agent-Skills-standard harnesses
# With one or more --target REPO: link into REPO/.claude/skills instead, scoped
# to that project.
#
# Usage:
#   scripts/install-local.sh                              # all skills -> global agent dirs
#   scripts/install-local.sh engineering                  # every skill in the engineering bucket
#   scripts/install-local.sh engineering productivity     # multiple buckets
#   scripts/install-local.sh engineering tdd              # a bucket plus one more skill
#   scripts/install-local.sh --target ~/code/app misc     # misc bucket -> ~/code/app/.claude/skills
#   scripts/install-local.sh --uninstall in-progress      # remove this repo's in-progress links
#   scripts/install-local.sh --uninstall                  # remove all of this repo's links
#
# Positional args are selectors: a bucket name (a dir directly under skills/, e.g.
# engineering, productivity, misc, personal, in-progress) selects every skill in
# that bucket; any other name is treated as a single skill. deprecated/ is always
# excluded. Omit selectors for every non-deprecated skill. Re-run only when skills
# are added, removed, or renamed, not when their contents change (symlinks are live).
#
# --uninstall inverts the run: instead of linking the selection it removes this
# repo's links for it (with no selectors, all of them). A normal (install) run is
# additive, linking the selection and clearing only links that have gone dangling.
# Links owned by other sources (e.g. other plugins) are never touched.
#
# Sourceable: the functions below run only when the file is executed directly, so
# `source install-local.sh` exposes them for unit testing without side effects.

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO/skills"

die() { echo "error: $1" >&2; exit "${2:-1}"; }

# True if $1 equals any of the remaining args.
_contains() {
  local needle="$1"; shift
  local x
  for x in "$@"; do [ "$x" = "$needle" ] && return 0; done
  return 1
}

usage() {
  awk 'NR<=2{next} /^#/{sub(/^# ?/,"");print;started=1;next} started{exit} /^$/{next} {exit}' "${BASH_SOURCE[0]}"
}

# Echo the abs path of each selected skill dir (one holding a SKILL.md), never
# from deprecated/. With no selectors: every non-deprecated skill. Each selector is
# either a bucket name (a dir directly under skills/ -> all its skills) or a skill
# name (-> that one); a selector matching neither is fatal. Output is de-duplicated.
list_skills() {
  local -a want=("$@") found=() out=()
  local skill_md src w hit matched
  while IFS= read -r -d '' skill_md; do
    found+=("$(dirname "$skill_md")")
  done < <(find "$SKILLS_DIR" -name SKILL.md -not -path '*/deprecated/*' -not -path '*/node_modules/*' -print0)
  [ "${#found[@]}" -gt 0 ] || return 0

  if [ "${#want[@]}" -eq 0 ]; then
    printf '%s\n' "${found[@]}"
    return
  fi
  for w in "${want[@]}"; do
    if [ -d "$SKILLS_DIR/$w" ]; then
      [ "$w" = deprecated ] && die "bucket 'deprecated' is excluded from local install"
      matched=0
      for src in "${found[@]}"; do
        case "$src" in
          "$SKILLS_DIR/$w"/*) matched=1; _contains "$src" ${out[@]+"${out[@]}"} || out+=("$src") ;;
        esac
      done
      [ "$matched" -eq 1 ] || die "bucket '$w' has no linkable skills"
    else
      hit=""
      for src in "${found[@]}"; do
        [ "$(basename "$src")" = "$w" ] && { hit="$src"; break; }
      done
      [ -n "$hit" ] || die "no bucket or skill '$w' under $SKILLS_DIR (excluding deprecated/)"
      _contains "$hit" ${out[@]+"${out[@]}"} || out+=("$hit")
    fi
  done
  printf '%s\n' "${out[@]}"
}

# Map a --target repo to its skills dir, refusing the skills repo itself (linking
# it into its own .claude/skills would be circular).
resolve_target() {
  local repo
  repo="$(cd "$1" 2>/dev/null && pwd)" || die "target '$1' is not a directory"
  case "$repo" in
    "$REPO"|"$REPO"/*) die "target ($repo) is the skills repo itself; pass a consumer repo" ;;
  esac
  printf '%s\n' "$repo/.claude/skills"
}

# Refuse a destination that is itself a symlink resolving into this repo: linking
# there would write the per-skill symlinks back into the source tree.
guard_dest() {
  local dest="$1" resolved
  [ -L "$dest" ] || return 0
  resolved="$(readlink -f "$dest")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      die "$dest is a symlink into this repo ($resolved); rm it and re-run so a real dir is created" ;;
  esac
}

# Drop symlinks in DEST that point into this repo but are now dangling, so a
# renamed or removed skill doesn't leave a dead link behind.
prune_dangling() {
  local dest="$1" link target
  [ -d "$dest" ] || return 0
  for link in "$dest"/*; do
    [ -L "$link" ] && [ ! -e "$link" ] || continue
    target="$(readlink "$link")"
    case "$target" in
      "$REPO"/*) rm -f "$link"; echo "pruned dangling $(basename "$link")" ;;
    esac
  done
}

# Remove this-repo symlinks in DEST. With TARGETS (skill dirs) given, remove only
# those; with none, remove every this-repo link. Links owned by other sources are
# never touched. Prints a per-destination count.
remove_links() {
  local dest="$1"; shift
  local -a targets=("$@")
  local all=0; [ "${#targets[@]}" -eq 0 ] && all=1
  local link target n=0
  if [ -d "$dest" ]; then
    for link in "$dest"/*; do
      [ -L "$link" ] || continue
      target="$(readlink "$link")"
      case "$target" in "$REPO"/*) ;; *) continue ;; esac
      if [ "$all" -eq 1 ] || _contains "$target" ${targets[@]+"${targets[@]}"}; then
        rm -f "$link"; echo "removed $(basename "$link")"; n=$((n + 1))
      fi
    done
  fi
  echo "==> removed $n link(s) from $dest"
}

# Create or refresh one symlink: DEST/<name> -> SRC, replacing any real file there.
link_skill() {
  local src="$1" dest="$2" name target
  name="$(basename "$src")"
  target="$dest/$name"
  [ -e "$target" ] && [ ! -L "$target" ] && rm -rf "$target"
  ln -sfn "$src" "$target"
  echo "linked $name -> $dest"
}

main() {
  local -a targets=() names=()
  local uninstall=0
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --target) [ "$#" -ge 2 ] || die "--target needs a directory" 2; targets+=("$2"); shift 2 ;;
      --uninstall) uninstall=1; shift ;;
      -h|--help) usage; exit 0 ;;
      -*) die "unknown flag $1" 2 ;;
      *) names+=("$1"); shift ;;
    esac
  done

  local -a dests=()
  if [ "${#targets[@]}" -gt 0 ]; then
    local t resolved
    for t in "${targets[@]}"; do
      resolved="$(resolve_target "$t")"
      dests+=("$resolved")
    done
  else
    dests=("$HOME/.claude/skills" "$HOME/.agents/skills")
  fi

  # Resolve selectors to skill dirs. Skipped only for uninstall-everything, where
  # no selection is needed.
  local -a srcs=()
  if [ "$uninstall" -eq 0 ] || [ "${#names[@]}" -gt 0 ]; then
    local out s
    out="$(list_skills ${names[@]+"${names[@]}"})"
    while IFS= read -r s; do [ -n "$s" ] && srcs+=("$s"); done <<< "$out"
    [ "${#srcs[@]}" -gt 0 ] || die "no skills selected"
  fi

  local dest src
  if [ "$uninstall" -eq 1 ]; then
    for dest in "${dests[@]}"; do
      guard_dest "$dest"
      remove_links "$dest" ${srcs[@]+"${srcs[@]}"}
    done
    return
  fi

  for dest in "${dests[@]}"; do
    guard_dest "$dest"
    mkdir -p "$dest"
    prune_dangling "$dest"
    for src in "${srcs[@]}"; do link_skill "$src" "$dest"; done
    echo "==> linked ${#srcs[@]} skill(s) into $dest"
  done
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  main "$@"
fi
