# Getting Started

This guide covers the complete local setup and the common failure modes. For
the shortest useful route, use the five-minute start in the repository README.

## Prerequisites

You need:

- Python 3.11 (`.python-version` pins the tested 3.11.9 patch release);
- Git, Bash or Zsh, and a terminal;
- internet access for the initial Python and dbt package installation;
- at least 1 GiB of free disk space for downloads and generated state.

The automated scripts are tested on macOS and Linux. On Windows, use WSL; native
PowerShell is not currently a supported execution path. Other Python versions
are not part of the `v0.1.0` workshop contract. Notices about newer dbt or
package releases are informational; do not upgrade dependencies individually
during setup.

`requirements.txt` records the intentional top-level tool choices.
`requirements.lock.txt` records the exact Python 3.11 environment used by
bootstrap and CI. Update both together after testing an intentional dependency
upgrade; do not hand-edit one transitive package in isolation.

If Python 3.11 is not installed, use your normal Python manager. For example,
with pyenv:

```bash
pyenv install 3.11.9
pyenv local 3.11.9
```

Optional tools:

- [Task](https://taskfile.dev/) for short script aliases;
- `jq` for exploring `target/manifest.json`;
- a hosted dbt environment only if you want to adapt the fixture beyond its
  default local workflow.

## Automated Setup

For a repeatable workshop, clone the tagged baseline:

```bash
git clone --branch v0.1.0 https://github.com/giacus/jaffle_corp.git
cd jaffle_corp
scripts/bootstrap.sh
source .venv/bin/activate
```

Bootstrap creates or reuses a Python 3.11 `.venv`, installs pinned dependencies,
installs the repo environment hook, resolves dbt packages, and smoke-compiles
`platform`. A valid existing `.venv` is reused even when `python3.11` is not on
the current shell's `PATH`.

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
dbt show --project-dir projects/platform --select fct_orders --limit 5
```

The explicit seed step matters in a new database. Staging models use `source()`,
so dbt does not infer a seed-to-model dependency. The final command should show
five rows from the public order fact, including its stable key, source order ID,
customer, store, and order timestamp.

Inspect the public output:

```bash
dbt ls \
  --project-dir projects/platform \
  --select access:public \
  --resource-type model
```

## Clean Rebuild, Validation, and Manifest

Run the complete repository check from the root:

```bash
scripts/validate_repo.sh
```

This command is intentionally destructive to generated local state: it removes
project targets, dbt packages, logs, and the default `jaffle_corp.duckdb` before
rebuilding. Tracked source files and `.venv` are preserved. It then resolves
packages, lints SQL, loads synthetic sources, builds every project in dependency
order, tests the downstream extension, validates the Semantic Layer, and
regenerates the complete manifest.

To generate only the monorepo-wide artifact:

```bash
scripts/generate_manifest.sh
```

The tooling-only `catalog` project writes `target/manifest.json`. Normal dbt
commands continue to produce project-local manifests.

## Browse the dbt Documentation Site

After building the fixture, generate and serve the full-project documentation:

```bash
scripts/docs.sh generate
scripts/docs.sh serve
```

Open <http://localhost:8080> to explore model descriptions, column docs,
contracts, ownership, and lineage. Press `Ctrl-C` to stop the server. The site
is generated under ignored `target/` state and is removed by the cleanup script.

## Reset or Finish a Session

Preview what the cleanup would remove:

```bash
scripts/clean.sh --dry-run
```

Keep generated state while following the sequential lab route because later
labs reuse earlier seeds and builds. To intentionally restart the data work
while keeping the Python environment, run:

```bash
scripts/clean.sh --keep-venv
```

Then rerun Lab 1 and any prerequisites named by the lab where you resume.

At the end of a workshop, reclaim all generated local disk space, including
`.venv`:

```bash
scripts/clean.sh
```

The cleanup script operates only on an explicit allowlist of ignored generated
paths inside this checkout. It never removes tracked SQL, YAML, Markdown, seeds,
or other source files.

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

### Python 3.11 not found

If bootstrap finds an older system Python, install Python 3.11 or pass the
absolute interpreter path explicitly:

```bash
PYTHON=/absolute/path/to/python3.11 scripts/bootstrap.sh
```

If an existing `.venv` was created with another Python version, run
`scripts/clean.sh`, then bootstrap again.

## Automation Notes

- Start a shell with `source .venv/bin/activate`.
- Use `scripts/validate_repo.sh` as the canonical full health check.
- Use `scripts/generate_manifest.sh` when only the combined artifact matters.
- Use `scripts/docs.sh generate` and `scripts/docs.sh serve` for local dbt docs.
- Use `scripts/clean.sh` when the workshop is over.
- Run project builds sequentially.
- Avoid per-project database or profile overrides unless the test explicitly
  requires isolation.
