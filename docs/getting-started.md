# Getting Started

This guide covers the complete local setup and the common failure modes. For
the shortest useful route, use the five-minute start in the repository README.

## Prerequisites

You need:

- Python 3.11 or 3.12;
- Git and a terminal;
- enough disk space for a small virtual environment and DuckDB database.

Python 3.14 is not supported by the pinned dependency stack. Notices about
newer dbt or package releases are informational; do not upgrade dependencies
individually during setup.

`requirements.txt` records the intentional top-level tool choices.
`requirements.lock.txt` records the exact Python 3.11 environment used by
bootstrap and CI. Update both together after testing an intentional dependency
upgrade; do not hand-edit one transitive package in isolation.

Optional tools:

- [Task](https://taskfile.dev/) for short script aliases;
- `jq` for exploring `target/manifest.json`;
- a hosted dbt environment only if you want to adapt the fixture beyond its
  default local workflow.

## Automated Setup

From the repository root:

```bash
scripts/bootstrap.sh
source .venv/bin/activate
```

Bootstrap creates or reuses `.venv`, installs pinned dependencies, installs the
repo environment hook, resolves dbt packages, and smoke-compiles `platform`.

To compile every runnable project and generate the complete manifest during
setup:

```bash
scripts/bootstrap.sh --full
```

Task aliases, when Task is installed:

```bash
task setup
task setup-full
```

## Manual Setup

If you need to see every step:

```bash
python3.11 -m venv .venv
bash scripts/install_venv_hook.sh
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.lock.txt
dbt deps --project-dir projects/platform --profiles-dir .
dbt compile --project-dir projects/platform --profiles-dir .
```

If another environment manager owns activation and you do not want to patch
`.venv/bin/activate`, load the dbt variables directly in each shell:

```bash
source scripts/env.sh
```

## Environment Behavior

The committed [profile](../profiles.yml) points at the ignored root-level file
`jaffle_corp.duckdb`. Activating `.venv` sets:

- `DBT_PROFILES_DIR` to the repository root;
- `JAFFLE_CORP_DUCKDB_PATH` to the root DuckDB file;
- `JAFFLE_CORP_ROOT` to the repository root.

This means both command styles work after activation:

```bash
# From the repository root
dbt compile --project-dir projects/platform

# From inside a project
cd projects/platform
dbt compile
cd ../..
```

Without the hook or `scripts/env.sh`, pass `--profiles-dir .` from the root or
`--profiles-dir ../..` from a project directory.

## First Build

The `platform` project imports `shared`, loads the complete raw fixture layer,
and builds the stable core interfaces:

```bash
dbt debug --project-dir projects/platform
dbt deps --project-dir projects/platform
dbt seed --project-dir projects/platform
dbt build --project-dir projects/platform --exclude resource_type:seed
```

The explicit seed step matters in a new database. Staging models use `source()`,
so dbt does not infer a seed-to-model dependency.

Inspect the public output:

```bash
dbt ls \
  --project-dir projects/platform \
  --select access:public \
  --resource-type model
```

## Full Validation and Manifest

Run the complete repository check from the root:

```bash
scripts/validate_repo.sh
```

It cleans generated artifacts, resolves packages, lints SQL, loads synthetic
sources, builds every project in dependency order, tests the downstream
extension, validates representative Semantic Layer queries, and regenerates the
complete manifest.

To generate only the monorepo-wide artifact:

```bash
scripts/generate_manifest.sh
```

The tooling-only `catalog` project writes `target/manifest.json`. Normal dbt
commands continue to produce project-local manifests.

## Troubleshooting

### Profile not found

If dbt reports `Could not find profile named 'jaffle_corp'`, reactivate the
environment and confirm the profile path:

```bash
source .venv/bin/activate
echo "$DBT_PROFILES_DIR"
```

It should print the repository root. Otherwise source `scripts/env.sh` or pass
the appropriate `--profiles-dir` value explicitly.

### Incomplete profile flag

If dbt reports `Option '--profiles-dir' requires an argument`, use
`--profiles-dir .` from the root or `--profiles-dir ../..` from inside a
project.

### DuckDB lock

If DuckDB reports a lock on `jaffle_corp.duckdb`, stop the dbt, MetricFlow, or
docs process using it. Run builds sequentially because the default local file
allows one writer at a time.

## Automation Notes

- Start a shell with `source .venv/bin/activate`.
- Use `scripts/validate_repo.sh` as the canonical full health check.
- Use `scripts/generate_manifest.sh` when only the combined artifact matters.
- Run project builds sequentially.
- Avoid per-project database or profile overrides unless the test explicitly
  requires isolation.
