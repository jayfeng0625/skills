# Commands

Repo-wide canonical commands. Skills read these verbatim — keep them runnable from a clean shell in the repo root.

Tiles under `tiles/` reference skills via symlinks (single source of truth in
`skills/`). Tessl excludes symlinks from plugins, so every tile command must go
through `scripts/tessl-with-tiles.sh`, which materializes the symlinks into real
files for the duration of the command and restores them afterwards. Requires the
tessl CLI (`curl -fsSL https://get.tessl.io | sh`) and auth (`tessl login`, or
`TESSL_TOKEN` in the environment).

## test_command

scripts/tessl-with-tiles.sh eval run tiles/engineering-skills

(runs the eval scenarios under the tile's `evals/`; produces the registry Impact
score. Swap the tile dir for `tiles/productivity-skills`.)

## lint_command

scripts/tessl-with-tiles.sh plugin lint tiles/engineering-skills

## typecheck_command

n/a

## build_command

scripts/tessl-with-tiles.sh plugin pack tiles/engineering-skills
