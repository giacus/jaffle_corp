# jaffle-corp

Welcome to `jaffle-corp`, a dbt Core playground for people who want to practice
on something more realistic than a tidy first tutorial.

If the classic Jaffle Shop is a friendly first dbt project, `jaffle-corp` is the
next practice fixture: still fictional, still approachable, but large enough to
show the modeling, ownership, testing, and semantic-layer questions that appear
once a dbt project starts serving more than one team.

You will work with a fictional food-retail company that sells jaffles through
stores. The data is synthetic, the domain is safe for public use, and the repo
is designed to run locally with dbt Core and DuckDB. No warehouse credentials,
dbt Cloud account, or private metadata service is required.

This repo is inspired by dbt Labs' [jaffle-shop](https://github.com/dbt-labs/jaffle-shop),
but it is not a fork and is not affiliated with or endorsed by dbt Labs. See
[ATTRIBUTION.md](ATTRIBUTION.md) for the relationship, contribution, and license
boundaries.

Use this repo when you want a general, executable fixture for dbt Core training,
code review practice, and analytics-engineering design discussion. Do not use it
as your very first dbt lesson; the repo assumes you are ready to read models,
run dbt commands, and reason about project structure.

## Table of Contents

1. [What You Will Build](#what-you-will-build)
2. [How This Compares to Jaffle Shop](#how-this-compares-to-jaffle-shop)
3. [Prerequisites](#prerequisites)
4. [Set Up dbt Core](#set-up-dbt-core)
5. [First 10 Minutes](#first-10-minutes)
6. [Build the Project](#build-the-project)
7. [Explore the Project](#explore-the-project)
8. [Run MetricFlow](#run-metricflow)
9. [Going Further](#going-further)
10. [Contributing](#contributing)

## What You Will Build

The repo is organized as a small dbt monorepo with several domain projects:

- `jaffle_platform` cleans source data and exposes core customer, order, product,
  store, payment, and refund interfaces.
- `jaffle_supply`, `jaffle_finance`, `jaffle_experience`, `jaffle_growth`,
  `jaffle_store_ops`, `jaffle_merchandising`, and `jaffle_planning` build on
  those interfaces from different business perspectives.
- `jaffle_legacy` keeps intentionally awkward models around as a migration and
  refactoring playground.
- `jaffle_reliability` is a downstream extension fixture that consumes public
  finance, merchandising, and planning contracts without reaching into protected
  internals.
- `jaffle_shared` contains shared macros and schema behavior.

The point is not to memorize every model. The point is to practice navigating
domain boundaries, project dependencies, public contracts, protected models,
semantic models, selectors, tests, analyses, snapshots, and legacy debt in a
repo that still runs on a laptop.

For a fuller map, see [docs/architecture.md](docs/architecture.md).

## How This Compares to Jaffle Shop

dbt Labs' [jaffle-shop](https://github.com/dbt-labs/jaffle-shop) is an official
sandbox for learning dbt through a small fictional restaurant. Its current README
is especially useful for dbt Cloud and warehouse onboarding.

`jaffle-corp` keeps the familiar fictional food-retail setting, but changes the
learning goal:

| If you want to... | Start with... |
| --- | --- |
| Learn the first dbt concepts: models, refs, sources, tests, seeds, and docs. | `jaffle-shop` or another beginner dbt tutorial. |
| Practice dbt Core locally without a cloud warehouse. | `jaffle-corp`. |
| See how a project feels after multiple teams, marts, grains, and ownership boundaries appear. | `jaffle-corp`. |
| Work through public/protected models, contracts, selectors, legacy debt, and semantic models. | `jaffle-corp`. |
| Learn dbt Cloud environment and job setup. | `jaffle-shop` or the official dbt Cloud docs. |

This repo is not a replacement for a first dbt lesson. It is a realistic fixture
for the next step: reading lineage, making scoped changes, deciding what should
be public, and validating a multi-project dbt Core repo end to end.

Another way to think about the difference:

| Dimension | `jaffle-shop` | `jaffle-corp` |
| --- | --- | --- |
| Default workflow | Guided setup around dbt Cloud and a warehouse. | Local dbt Core commands with DuckDB. |
| Project shape | Compact single-project sandbox. | Multi-project monorepo with domain ownership. |
| Learning style | Follow a setup guide and learn core dbt workflows. | Inspect, change, test, and review realistic patterns. |
| Modeling surface | Beginner-friendly marts and source data. | Public/protected models, contracts, multiple grains, legacy marts, and semantic models. |
| Best fit | First dbt project or dbt Cloud onboarding. | Intermediate training, workshops, interviews, and fixture-based practice. |

## Prerequisites

You need:

- Python 3.11 or 3.12.
- Git and a terminal.
- Enough local disk space for a small DuckDB database.

Python 3.14 is not yet supported by the current dbt dependency stack used here.

## Set Up dbt Core

Create a virtual environment and install the pinned local toolchain:

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Check that dbt is available:

```bash
dbt --version
```

The committed [profiles.yml](profiles.yml) points dbt at an ignored local DuckDB
file named `jaffle_corp.duckdb`. You do not need to create a private profile or
configure credentials for the default local workflow.

## First 10 Minutes

Start with one project before building the whole repo:

```bash
dbt debug --project-dir projects/jaffle_platform --profiles-dir .
dbt deps --project-dir projects/jaffle_platform --profiles-dir .
dbt seed --project-dir projects/jaffle_platform --profiles-dir .
dbt build --project-dir projects/jaffle_platform --profiles-dir .
dbt ls --project-dir projects/jaffle_platform --profiles-dir . --select access:public --resource-type model
```

You should see dbt connect to the local DuckDB profile, load synthetic source
tables, build the platform models, run tests, and list the public platform
interfaces. That is enough to start exploring without understanding every domain
yet.

Model files use a model-local folder convention:

```text
models/<layer>/<model_name>/<model_name>.sql
models/<layer>/<model_name>/<model_name>.yml
models/<layer>/<model_name>/<model_name>.md
```

The SQL, contract/tests, and docs block for a model sit beside each other. Shared
files such as sources, groups, exposures, semantic models, and metrics stay at
the layer or project level.

## Build the Project

The fastest way to check the whole repo is:

```bash
scripts/validate_repo.sh
```

That command cleans ignored dbt artifacts, recreates the default local DuckDB
database, installs project dependencies, lints SQL, seeds source tables, builds
each dbt project in dependency order, and runs a few direct MetricFlow queries.
On a typical laptop it should take a couple of minutes, not hours.

If you want to move more slowly, start with the platform project:

```bash
dbt deps --project-dir projects/jaffle_platform --profiles-dir .
dbt seed --project-dir projects/jaffle_platform --profiles-dir .
dbt build --project-dir projects/jaffle_platform --profiles-dir .
```

Then build downstream projects in the order shown by
[scripts/validate_repo.sh](scripts/validate_repo.sh). The order matters because
the local DuckDB setup is standing in for a shared warehouse. Run the projects
sequentially; DuckDB allows one writer per database file.

The project order is:

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
```

The downstream extension fixture builds after the core projects:

```text
projects/jaffle_reliability
```

Generated files are ignored by Git. Expect local `target/`, `dbt_packages/`,
`logs/`, and `jaffle_corp.duckdb` artifacts after running dbt. To clean dbt
artifacts, run:

```bash
rm -rf projects/jaffle_platform/target projects/jaffle_platform/dbt_packages
```

Repeat that for other projects when needed, or use `task clean` if you already
have the optional [Task](https://taskfile.dev/) runner installed.

## Explore the Project

Try a few dbt Core commands from the repo root:

```bash
dbt ls --project-dir projects/jaffle_platform --profiles-dir . --select fct_orders
dbt ls --project-dir projects/jaffle_finance --profiles-dir . --select access:public --resource-type model
dbt build --project-dir projects/jaffle_finance --profiles-dir . --select +fct_order_revenue
dbt build --project-dir projects/jaffle_reliability --profiles-dir . --select jaffle_reliability
```

Generate dbt docs for a project:

```bash
dbt docs generate --project-dir projects/jaffle_platform --profiles-dir .
dbt docs serve --project-dir projects/jaffle_platform --profiles-dir .
```

Then inspect how the public interfaces, protected implementation models, tests,
and sources are presented.

The repo intentionally includes a few rough edges. See
[EXERCISES.md](EXERCISES.md) for starter exercises, but do not treat it as an
answer key. Finding additional modeling, testing, semantic, and ownership issues
is part of the exercise.

If you want a more structured training sequence, follow
[docs/course_path.md](docs/course_path.md).

## Run MetricFlow

MetricFlow is optional on your first pass. Use it after a successful dbt build
when you want to explore how metrics are defined and queried from the same local
project files.

Build the repo first, then point MetricFlow at the same DuckDB file:

```bash
export JAFFLE_CORP_DUCKDB_PATH="$PWD/jaffle_corp.duckdb"
```

Inspect available metrics directly:

```bash
cd projects/jaffle_finance
export DBT_PROFILES_DIR=../..
mf validate-configs --skip-dw
mf list metrics
```

Run a query:

```bash
mf query \
  --metrics net_revenue_usd,estimated_gross_margin_usd,refund_rate \
  --group-by metric_time,location,order__country_code \
  --limit 20
```

Semantic Layer files are plain dbt/MetricFlow YAML:

- `models/semantic_models.yml` defines entities, measures, dimensions, and time.
- `models/metrics.yml` defines curated metrics.
- `models/saved_queries.yml` is not pre-filled; add one when a repeated query is
  worth versioning.

There are no Python helper scripts for the Semantic Layer. Use `dbt` and `mf`
directly so the examples stay close to the tools students will use in real
projects.

For more MetricFlow examples, see [docs/metricflow.md](docs/metricflow.md).

## Going Further

Good next steps after your first successful build:

- Compare public and protected models in a downstream project.
- Trace how a metric moves from a mart model into `models/semantic_models.yml`
  and `models/metrics.yml`.
- Add a test to a public model contract.
- Build a new model in `projects/jaffle_reliability` using only public upstream
  refs.
- Add a new downstream extension project that depends on the same public
  contracts as `jaffle_reliability`.
- Refactor one legacy model without changing its external behavior.
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

### dbt Cloud

This project is deliberately focused on dbt Core. You can adapt it for dbt Cloud
or a hosted mesh environment, but that is not the default path. The local
`packages.yml` fallbacks exist so the repo can parse and build without account
level project metadata; hosted dbt Mesh setups can use the committed
`dependencies.yml` files as the intended interface boundary.

## Contributing

This repo is intended to be played with. Good contributions add realistic dbt
complexity while keeping the business fictional, small enough to run locally,
and understandable from the docs.

Before opening a pull request:

```bash
scripts/validate_repo.sh
```

Reference material used for structure and context:

- [dbt-labs/jaffle-shop](https://github.com/dbt-labs/jaffle-shop)
- [dbt project dependencies docs](https://docs.getdbt.com/docs/mesh/govern/project-dependencies)
- [dbt model access docs](https://docs.getdbt.com/reference/resource-configs/access)
- [dbt Semantic Layer docs](https://docs.getdbt.com/docs/build/semantic-models)
