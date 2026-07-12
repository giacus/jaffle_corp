# jaffle-corp

`jaffle-corp` is a local dbt Core playground for analytics engineers who want a
fixture that feels larger than a first tutorial, but still runs on a laptop.

The company is fictional. The data is synthetic. The modeling problems are meant
to feel familiar: shared platform models, domain marts, public contracts,
protected implementation details, semantic models, downstream dependencies, and a
little legacy debt.

> [!NOTE]
> This is not the best place to learn your first `ref`, source, or generic test.
> Start here when you already know the dbt basics and want to practice project
> design, code review, refactoring, contracts, and extension work.

This project is inspired by dbt Labs'
[jaffle-shop](https://github.com/dbt-labs/jaffle-shop), but it is not a fork and
is not affiliated with or endorsed by dbt Labs. See
[ATTRIBUTION.md](ATTRIBUTION.md) for attribution, contribution, and license
boundaries.

Ready to go? The default path below uses dbt Core, DuckDB, and the committed
local profile. No warehouse credentials or dbt Cloud account are required.

## Shortest Beginner Route

This repo is intentionally too large to understand file by file. On your first
visit, stay at the repository root and use this path:

```bash
scripts/bootstrap.sh
source .venv/bin/activate
dbt seed --project-dir projects/jaffle_platform
dbt build --project-dir projects/jaffle_platform --exclude resource_type:seed
scripts/generate_manifest.sh
```

That gives you one working domain and a complete project index without asking
you to understand all the other domains first. The generated, git-ignored
`target/manifest.json` contains resources from every local dbt project.

Then explore in this order:

1. `jaffle_shared` for raw fixtures, source definitions, and staging models.
2. `jaffle_platform` for stable public models built from that shared foundation.
3. `jaffle_finance` for a realistic downstream domain.
4. `jaffle_reliability` for a small cross-project extension.
5. `jaffle_legacy` only when you want intentional migration debt.

Use [docs/course_path.md](docs/course_path.md) for a guided route or
[EXERCISES.md](EXERCISES.md) for individual labs. You do not need to read every
project before changing one.

## Table of Contents

1. [Shortest Beginner Route](#shortest-beginner-route)
2. [Prerequisites](#prerequisites)
3. [Set Up the Local Toolchain](#set-up-the-local-toolchain)
4. [Build Your First Project](#build-your-first-project)
5. [Build the Whole Fixture](#build-the-whole-fixture)
6. [Read the Whole Project from One Manifest](#read-the-whole-project-from-one-manifest)
7. [Explore the Repo](#explore-the-repo)
8. [Work on Downstream Extensions](#work-on-downstream-extensions)
9. [Run MetricFlow](#run-metricflow)
10. [Going Further](#going-further)
11. [Contributing](#contributing)

## Prerequisites

You need:

- Python 3.11 or 3.12.
- Git and a terminal.
- Enough local disk space for a small DuckDB database.

Python 3.14 is not yet supported by the current dbt dependency stack used here.
The repo pins known-compatible versions, so notices about newer dbt or package
versions are informational; do not upgrade them individually during setup.

Optional:

- [Task](https://taskfile.dev/) if you want short commands like `task validate`.
- `jq` if you want the short manifest queries shown below; Python works as a
  fallback.
- A dbt Cloud or dbt Mesh environment if you want to adapt the fixture outside
  the local DuckDB workflow.

## Set Up the Local Toolchain

From the repository root, run the bootstrap script:

```bash
scripts/bootstrap.sh
```

This creates or reuses `.venv`, installs the activation hook, installs pinned
dependencies, runs `dbt deps` where needed, and verifies that `dbt compile`
works for `jaffle_platform`, the project used by the beginner route.

To compile every runnable dbt project and generate the full-project manifest
during setup, run:

```bash
scripts/bootstrap.sh --full
```

If you use [Task](https://taskfile.dev/), the same setup is available as:

```bash
task setup
```

After bootstrap, activate the venv in each new shell:

```bash
source .venv/bin/activate
```

The hook makes `source .venv/bin/activate` load the repo-local dbt environment
as well as Python. After activation, you can run dbt from the repo root or from
inside any `projects/<project>` folder.

If you prefer the manual setup path, run:

```bash
python3.11 -m venv .venv
bash scripts/install_venv_hook.sh
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
dbt deps --project-dir projects/jaffle_platform --profiles-dir .
dbt compile --project-dir projects/jaffle_platform --profiles-dir .
```

If you use another Python environment manager and do not want to patch
`.venv/bin/activate`, source the dbt environment directly in each shell:

```bash
source scripts/env.sh
```

Check that dbt is installed:

```bash
dbt --version
```

The committed [profiles.yml](profiles.yml) points dbt at an ignored local DuckDB
file named `jaffle_corp.duckdb`. `scripts/env.sh` sets `DBT_PROFILES_DIR` and
`JAFFLE_CORP_DUCKDB_PATH` to absolute repo-root paths, so dbt keeps using the
same profile and database even after you `cd` into a project folder.

You do not need to create private credentials for the default local workflow.

### Command Styles

After activating the patched venv, both command styles work:

```bash
# From the repo root
dbt compile --project-dir projects/jaffle_platform

# From inside a dbt project
cd projects/jaffle_platform
dbt compile
cd ../..
```

If you skip the venv hook and do not source `scripts/env.sh`, `--profiles-dir`
must include a path:

```bash
# From the repo root
dbt compile --project-dir projects/jaffle_platform --profiles-dir .

# From inside a dbt project
cd projects/jaffle_platform
dbt compile --profiles-dir ../..
cd ../..
```

`jaffle_shared` is the centralized ingestion and staging package. It owns all
raw fixture seeds, source definitions, staging models, and shared macros. Run it
through an importing domain project, such as `jaffle_platform`, so cross-project
legacy compatibility models can resolve their public upstream refs.

### Troubleshooting

If dbt cannot find the profile:

```text
Runtime Error
  Could not find profile named 'jaffle_corp'
```

activate the patched venv again:

```bash
source .venv/bin/activate
```

Then confirm the profile path:

```bash
echo "$DBT_PROFILES_DIR"
```

It should print the repository root. If you are not using the venv hook, either
source `scripts/env.sh` or pass the correct `--profiles-dir` path explicitly.

If dbt says:

```text
Error: Option '--profiles-dir' requires an argument.
```

the flag is incomplete. Use `--profiles-dir .` from the repo root or
`--profiles-dir ../..` from inside a project folder.

If DuckDB reports a lock on `jaffle_corp.duckdb`, another dbt, MetricFlow, or
docs process is still using the local database. Stop that process and rerun the
command. In local development, run dbt commands sequentially.

### Automation Notes

For agents and scripts:

- Start every shell with `source .venv/bin/activate`.
- Prefer `scripts/validate_repo.sh` for a full fixture health check.
- Run project builds sequentially; the local DuckDB file allows one writer at a
  time.
- Do not set per-project profile paths unless intentionally overriding the
  default local setup.

### Checkpoint

At this point:

- Your virtual environment is active.
- `DBT_PROFILES_DIR` points at the repository root.
- `JAFFLE_CORP_DUCKDB_PATH` points at the root `jaffle_corp.duckdb` file.
- `dbt --version` prints dbt Core and the DuckDB adapter.
- You are still at the repository root.

## Build Your First Project

Start with the platform project. It imports `jaffle_shared`, loads the complete
raw fixture layer, and builds the core customer, order, product, store, payment,
and refund interfaces that other projects consume.

```bash
dbt debug --project-dir projects/jaffle_platform
dbt deps --project-dir projects/jaffle_platform
dbt seed --project-dir projects/jaffle_platform
dbt build --project-dir projects/jaffle_platform --exclude resource_type:seed
```

The explicit seed step matters in a new database: staging models read the raw
tables through `source()`, so dbt does not infer a seed-to-model dependency. The
build excludes seeds because they have already been loaded.

Now list the public platform models:

```bash
dbt ls \
  --project-dir projects/jaffle_platform \
  --select access:public \
  --resource-type model
```

### Checkpoint

You should now have:

- A local `jaffle_corp.duckdb` file.
- Seed tables loaded into the local raw schema.
- Platform models and tests passing.
- A short list of public models that downstream projects are allowed to depend
  on.

## Build the Whole Fixture

The full validation script is the easiest way to check that the fixture is
healthy:

```bash
scripts/validate_repo.sh
```

That script:

- Cleans ignored dbt artifacts for each project.
- Recreates the default local DuckDB database.
- Runs `dbt deps` for the core and extension projects.
- Lints SQL with SQLFluff.
- Seeds source data.
- Builds every core project in dependency order.
- Builds the downstream `jaffle_reliability` extension fixture.
- Runs MetricFlow semantic validation and representative metric queries.
- Regenerates one full-project manifest at `target/manifest.json`.

On a typical laptop, this should take a few minutes, not hours.

If you prefer to run the build manually, keep the projects in this order:

```text
projects/jaffle_platform
projects/jaffle_supply
projects/jaffle_finance
projects/jaffle_experience
projects/jaffle_growth
projects/jaffle_store_ops
projects/jaffle_merchandising
projects/jaffle_planning
projects/jaffle_legacy
projects/jaffle_reliability
```

The order matters because this local setup uses one DuckDB file as the shared
warehouse stand-in. Run project builds sequentially; DuckDB allows one writer per
database file.

With Task installed, the equivalent command is:

```bash
task validate
```

### Checkpoint

After a successful full validation:

- Core projects build and test successfully.
- The extension project builds against public upstream contracts.
- MetricFlow validates semantic configs with zero errors.
- `target/manifest.json` indexes resources from every local project.
- `target/`, `dbt_packages/`, `logs/`, and `jaffle_corp.duckdb` exist locally
  and remain ignored by Git.

## Read the Whole Project from One Manifest

Normal dbt commands create one manifest per project. For a monorepo-wide view,
`jaffle_catalog` imports every local project as a package and emits one genuine
dbt artifact from the repository root:

```bash
scripts/generate_manifest.sh
```

The result is:

```text
target/manifest.json
```

The manifest includes models, seeds, snapshots, tests, sources, exposures,
metrics, semantic models, macros, lineage, config, and file paths across the
fixture. It is generated output and is intentionally not committed.

If `jq` is installed, these are useful first queries:

```bash
# Resource counts
jq '{nodes: (.nodes | length), sources: (.sources | length), metrics: (.metrics | length), semantic_models: (.semantic_models | length)}' target/manifest.json

# Project packages represented by executable nodes
jq -r '[.nodes[].package_name] | unique[]' target/manifest.json

# Public models and their source files
jq -r '.nodes | to_entries[] | select(.value.resource_type == "model" and .value.config.access == "public") | [.key, .value.original_file_path] | @tsv' target/manifest.json
```

With Task installed, `task manifest` runs the same command. See
[`projects/jaffle_catalog/README.md`](projects/jaffle_catalog/README.md) for the
catalog project's boundary and extension notes.

## Explore the Repo

The repo is an intentionally broad dbt monorepo that remains small enough to run
locally. Follow one domain lane at a time:

| Project | Purpose |
| --- | --- |
| `jaffle_platform` | Conformed dimensions and core public interfaces. |
| `jaffle_supply` | Inventory, purchasing, component cost, and supply risk models. |
| `jaffle_finance` | Revenue, refunds, margins, store P&L, and finance quality models. |
| `jaffle_experience` | Support, contacts, experiments, and customer experience models. |
| `jaffle_growth` | Campaign attribution and growth performance models. |
| `jaffle_store_ops` | Store operations, kitchen, service, and shift-plan models. |
| `jaffle_merchandising` | Menu publication, availability, pairings, and merchandising goals. |
| `jaffle_planning` | Forecast, capacity, and component planning scenarios. |
| `jaffle_legacy` | Intentionally awkward models for migration and refactoring practice. |
| `jaffle_shared` | All raw fixtures, source definitions, staging models, shared macros, and schema behavior. |
| `jaffle_reliability` | Downstream extension fixture that consumes public contracts. |
| `jaffle_catalog` | Tooling-only umbrella that emits the full-project manifest. |

Use this edit map when you know the kind of change but not the folder:

| You want to change | Start in |
| --- | --- |
| Synthetic input data | `projects/jaffle_shared/seeds/<domain>/` |
| Source cleanup or naming | `projects/jaffle_shared/models/staging/<domain>/` |
| Reusable transformation logic | `models/intermediate/` |
| A consumer-facing dataset or contract | `models/marts/` and its model-local YAML |
| Cross-row business behavior | The project's `tests/` folder |
| A semantic measure or metric | `models/semantic_models.yml` or `models/metrics.yml` |
| A cross-domain use case | `jaffle_reliability` or another extension project |

For a fuller map, read [docs/architecture.md](docs/architecture.md).

Try these from the repo root:

```bash
dbt ls --project-dir projects/jaffle_finance --select access:public --resource-type model
dbt build --project-dir projects/jaffle_finance --select +fct_order_revenue
dbt docs generate --project-dir projects/jaffle_platform
dbt docs serve --project-dir projects/jaffle_platform
```

Model files use a model-local folder convention:

```text
models/<layer>/<model_name>/<model_name>.sql
models/<layer>/<model_name>/<model_name>.yml
models/<layer>/<model_name>/<model_name>.md
```

The SQL, model contract/tests, and docs block for a model live together. Shared
files such as sources, groups, exposures, semantic models, and metrics stay at
the layer or project level.

## Work on Downstream Extensions

`projects/jaffle_reliability` exists to prove that this repo can serve as a
fixture for downstream projects.

It depends on public models from finance, merchandising, and planning. It should
not reach into protected intermediate models. Use it as the pattern for your own
extension project:

```bash
dbt build \
  --project-dir projects/jaffle_reliability \
  --select jaffle_reliability
```

When adding another extension, start by answering four questions:

1. Which public upstream models does it consume?
2. What grain does the new model expose?
3. Which columns form the contract?
4. Which tests prove the extension is safe to build downstream?

See [docs/extension_authoring.md](docs/extension_authoring.md) for the full
authoring pattern.

## Run MetricFlow

MetricFlow is optional on your first pass. Use it after a successful dbt build
when you want to inspect semantic models and metrics.

If this is a new shell, activate the patched venv first:

```bash
source .venv/bin/activate
```

Then run MetricFlow from the dbt project that owns the metrics:

```bash
cd projects/jaffle_finance
mf validate-configs --skip-dw
mf list metrics
mf query \
  --metrics net_revenue_usd,estimated_gross_margin_usd,refund_rate \
  --group-by metric_time,location,order__country_code \
  --limit 20
cd ../..
```

`DBT_PROFILES_DIR` is required for direct `mf` commands because MetricFlow reads
the active dbt project, while this repo keeps the shared `profiles.yml` at the
repository root. `scripts/env.sh` sets it for you.

Semantic Layer files are plain dbt/MetricFlow YAML:

- `models/semantic_models.yml` defines entities, measures, dimensions, and time.
- `models/metrics.yml` defines curated metrics.
- `models/saved_queries.yml` is intentionally absent until a repeated query is
  worth versioning.

For more examples, see [docs/metricflow.md](docs/metricflow.md).

## Going Further

Once the fixture builds, use it as a practice environment:

- Work through [EXERCISES.md](EXERCISES.md).
- Follow the structured path in [docs/course_path.md](docs/course_path.md).
- Compare public and protected models in a downstream project.
- Trace one metric from a mart model into `semantic_models.yml` and
  `metrics.yml`.
- Add a test to a public model contract.
- Build a new extension project that consumes only public upstream models.
- Refactor a legacy model without changing its external behavior.
- Propose a new public interface only after you can name the downstream use case,
  model grain, contract, and validation query.

Useful docs:

- [docs/architecture.md](docs/architecture.md)
- [docs/course_path.md](docs/course_path.md)
- [docs/extension_authoring.md](docs/extension_authoring.md)
- [docs/metricflow.md](docs/metricflow.md)

Small glossary:

- `public model`: a model intended as a stable interface for other projects.
- `protected model`: a model that can be used inside its project, but should not
  be treated as a cross-project contract.
- `model contract`: a declared column-level interface that dbt validates.
- `project dependency`: the intended dbt Mesh relationship between projects.
  Local `packages.yml` fallbacks keep this repo runnable with dbt Core.
- `semantic model`: MetricFlow YAML that describes entities, dimensions,
  measures, and time.
- `metric`: a curated calculation built on semantic-model measures.

### dbt Cloud and Mesh

The default workflow is deliberately local. You can adapt the repo for dbt Cloud
or a hosted mesh environment, but that is not required to learn from it.

The committed `dependencies.yml` files show the intended project-dependency
boundaries. The local `packages.yml` fallbacks keep those same projects runnable
with dbt Core when account-level project metadata is not available.

## Contributing

This repo is meant to be played with. Good contributions add realistic dbt
complexity while keeping the business fictional, small enough to run locally,
and understandable from the docs.

Before opening a pull request:

```bash
scripts/validate_repo.sh
```

The GitHub Actions `validate` check runs the same fixture validation on pull
requests and default-branch pushes. Keep changes on feature branches and merge
through a pull request; the default branch should stay protected from direct
pushes.
