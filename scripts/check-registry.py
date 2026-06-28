#!/usr/bin/env python3
"""Check — and optionally regenerate — the skill-registry invariants.

The invariants (from CLAUDE.md) that drift after an upstream merge:

  - Every skill in engineering/, productivity/, misc/ is listed in
      * .claude-plugin/plugin.json
      * the top-level README.md  (linked to its SKILL.md)
      * its bucket README.md     (linked, under the right User-/Model-invoked group)
  - Skills in personal/, in-progress/, deprecated/ appear in NONE of the above.
  - Each tile manifest (tiles/<tile>/.tessl-plugin/plugin.json) and the tile's
    skills/ symlinks match its bucket.

Usage:
  scripts/check-registry.py            # report drift; exit 1 if any
  scripts/check-registry.py --write    # regenerate plugin.json manifests + tile
                                       # symlinks in place. READMEs are reported,
                                       # never rewritten (they carry curated prose).

Stdlib only. Run from anywhere; paths resolve relative to the repo root.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SHIPPED = ["engineering", "productivity", "misc"]
EXCLUDED = ["personal", "in-progress", "deprecated"]
TILES = {"engineering": "engineering-skills", "productivity": "productivity-skills"}

LINK = re.compile(r"\]\(([^)]+)\)")
GROUP_HEADING = re.compile(r"^\s*#{0,6}\s*\*{0,2}\s*(user|model)-invoked", re.I)
BUCKET_HEADING = re.compile(r"^###\s+([A-Za-z]+)\s*\((\d+)\)", re.M)


# ── discovery ────────────────────────────────────────────────────────────────

def skills_in(bucket: str) -> list[str]:
    base = REPO / "skills" / bucket
    if not base.is_dir():
        return []
    return sorted(p.name for p in base.iterdir() if (p / "SKILL.md").is_file())


def frontmatter(name: str, bucket: str) -> dict:
    text = (REPO / "skills" / bucket / name / "SKILL.md").read_text()
    fm = {"name": name, "description": "", "user_invoked": False}
    if text.startswith("---"):
        block = text.split("---", 2)[1]
        for line in block.splitlines():
            if ":" not in line:
                continue
            key, _, val = line.partition(":")
            key, val = key.strip(), val.strip()
            if key == "description":
                fm["description"] = val
            elif key == "disable-model-invocation":
                fm["user_invoked"] = val.lower() == "true"
    return fm


# ── README inspection (check-only) ───────────────────────────────────────────

def targets(text: str) -> list[str]:
    return LINK.findall(text)


def group_of(lines: list[str], ref_line: int) -> str | None:
    """Nearest preceding User-/Model-invoked heading above ref_line."""
    for i in range(ref_line, -1, -1):
        m = GROUP_HEADING.match(lines[i])
        if m:
            return m.group(1).lower()
    return None


def ref_line(lines: list[str], suffix: str) -> int | None:
    for i, line in enumerate(lines):
        if any(t.endswith(suffix) or t.rstrip("/").endswith(suffix.rstrip("/"))
               for t in targets(line)):
            return i
    return None


def has_groups(text: str) -> bool:
    return bool(re.search(r"(?i)user-invoked", text)) and bool(
        re.search(r"(?i)model-invoked", text))


def check_readme(path: Path, expected: dict[str, dict], suffix_for,
                 forbidden_suffixes: list[str], problems: list[str]) -> None:
    """expected: name -> frontmatter. suffix_for(name)->link suffix to find it."""
    if not path.is_file():
        problems.append(f"{path}: missing")
        return
    text = path.read_text()
    lines = text.splitlines()
    grouped = has_groups(text)
    rel = path.relative_to(REPO)

    for name, fm in expected.items():
        rl = ref_line(lines, suffix_for(name))
        if rl is None:
            grp = "User-invoked" if fm["user_invoked"] else "Model-invoked"
            problems.append(
                f"{rel}: missing '{name}' (add under {grp} — \"{fm['description'][:70]}\")")
            continue
        if grouped:
            want = "user" if fm["user_invoked"] else "model"
            got = group_of(lines, rl)
            if got and got != want:
                problems.append(
                    f"{rel}: '{name}' is under {got}-invoked but frontmatter says {want}-invoked")

    for t in targets(text):
        for bad in forbidden_suffixes:
            if bad in t:
                problems.append(f"{rel}: references excluded-bucket skill ({t})")


# ── manifest + symlink regeneration ──────────────────────────────────────────

def reconcile(existing: list[str], desired: set[str]) -> tuple[list[str], list[str], list[str]]:
    kept = [e for e in existing if e in desired]
    added = sorted(desired - set(existing))
    removed = [e for e in existing if e not in desired]
    return kept + added, added, removed


def sync_manifest(path: Path, desired: set[str], write: bool,
                  problems: list[str], changes: list[str]) -> None:
    data = json.loads(path.read_text())
    new_skills, added, removed = reconcile(data.get("skills", []), desired)
    if added or removed:
        rel = path.relative_to(REPO)
        if write:
            data["skills"] = new_skills
            path.write_text(json.dumps(data, indent=2) + "\n")
            changes.append(f"{rel}: +{added} -{removed}")
        else:
            problems.append(f"{rel}: add {added}, remove {removed}")


def sync_symlinks(bucket: str, tile: str, write: bool,
                  problems: list[str], changes: list[str]) -> None:
    want = set(skills_in(bucket))
    link_dir = REPO / "tiles" / tile / "skills"
    have = {p.name for p in link_dir.iterdir() if p.is_symlink()} if link_dir.is_dir() else set()
    rel = link_dir.relative_to(REPO)
    for name in sorted(want - have):
        if write:
            link_dir.mkdir(parents=True, exist_ok=True)
            os.symlink(f"../../../skills/{bucket}/{name}", link_dir / name)
            changes.append(f"{rel}/{name}: symlink created")
        else:
            problems.append(f"{rel}: missing symlink '{name}'")
    for name in sorted(have - want):
        if write:
            (link_dir / name).unlink()
            changes.append(f"{rel}/{name}: stale symlink removed")
        else:
            problems.append(f"{rel}: stale symlink '{name}'")


# ── README count check ───────────────────────────────────────────────────────

def check_counts(problems: list[str]) -> None:
    text = (REPO / "README.md").read_text()
    counts = {m.group(1).lower(): int(m.group(2)) for m in BUCKET_HEADING.finditer(text)}
    for bucket in SHIPPED:
        actual = len(skills_in(bucket))
        stated = counts.get(bucket)
        if stated is not None and stated != actual:
            problems.append(f"README.md: '### {bucket.title()} ({stated})' should be ({actual})")


# ── main ─────────────────────────────────────────────────────────────────────

def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--write", action="store_true",
                    help="regenerate plugin.json manifests + tile symlinks")
    args = ap.parse_args()

    problems: list[str] = []
    changes: list[str] = []

    shipped_fm = {b: {n: frontmatter(n, b) for n in skills_in(b)} for b in SHIPPED}

    # 1. top-level plugin.json
    top_desired = {f"./skills/{b}/{n}" for b in SHIPPED for n in skills_in(b)}
    sync_manifest(REPO / ".claude-plugin" / "plugin.json", top_desired, args.write,
                  problems, changes)

    # 2. tile manifests + symlinks
    for bucket, tile in TILES.items():
        sync_manifest(REPO / "tiles" / tile / ".tessl-plugin" / "plugin.json",
                      {f"skills/{n}" for n in skills_in(bucket)}, args.write,
                      problems, changes)
        sync_symlinks(bucket, tile, args.write, problems, changes)

    # 3. top-level README — every shipped skill linked; no excluded ones
    forbidden = [f"/skills/{b}/" for b in EXCLUDED]
    top_expected = {n: fm for b in SHIPPED for n, fm in shipped_fm[b].items()}
    top_suffix = {n: f"/skills/{b}/{n}/SKILL.md"
                  for b in SHIPPED for n in shipped_fm[b]}
    check_readme(REPO / "README.md", top_expected, lambda n: top_suffix[n],
                 forbidden, problems)

    # 4. bucket READMEs
    for bucket in SHIPPED:
        check_readme(REPO / "skills" / bucket / "README.md", shipped_fm[bucket],
                     lambda n: f"{n}/SKILL.md", [], problems)

    # 5. README counts
    check_counts(problems)

    if changes:
        print("regenerated:")
        for c in changes:
            print(f"  ✎ {c}")
    if problems:
        print("registry drift:" if not args.write else "remaining (README — fix by hand):")
        for p in problems:
            print(f"  ✗ {p}")
        return 1
    print("registry OK" if not changes else "registry OK (after --write)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
