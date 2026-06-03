# jaffle-corp

Welcome to `jaffle-corp`, a dbt Core playground for people who know the classic
Jaffle Shop shape and want something closer to the messiness of a real analytics
engineering codebase.

You will work with a fictional food-retail company that sells jaffles through
stores. The data is synthetic, the domain is safe for public use, and the repo
is designed to run locally with dbt Core and DuckDB. No warehouse credentials,
dbt Cloud account, or private metadata service is required.

This repo is inspired by dbt Labs' [jaffle-shop](https://github.com/dbt-labs/jaffle-shop),
but it is not a fork and is not affiliated with or endorsed by dbt Labs. See
[ATTRIBUTION.md](ATTRIBUTION.md) for the relationship, contribution, and license
boundaries.

## Table of Contents

1. [What You Will Build](#what-you-will-build)
2. [Prerequisites](#prerequisites)
3. [Set Up dbt Core](#set-up-dbt-core)
4. [Build the Project](#build-the-project)
5. [Explore the Project](#explore-the-project)
6. [Run MetricFlow](#run-metricflow)
7. [Going Further](#going-further)
8. [Contributing](#contributing)

## What You Will Build

The repo is organized as a small dbt monorepo with several domain projects:

- `jaffle_platform` cleans source data and exposes core customer, order, product,
  store, payment, and refund interfaces.
- `jaffle_supply`, `jaffle_finance`, `jaffle_experience`, `jaffle_growth`,
  `jaffle_store_ops`, `jaffle_merchandising`, and `jaffle_planning` build on
  those interfaces from different business perspectives.
- `jaffle_legacy` keeps intentionally awkward models around as a migration and
  refactoring playground.
- `jaffle_shared` contains shared macros and schema behavior.

The point is not to memorize every model. The point is to practice navigating
domain boundaries, project dependencies, public contracts, protected models,
semantic models, selectors, tests, analyses, snapshots, and legacy debt in a
repo that still runs on a laptop.

For a fuller map, see [docs/domain_map.md](docs/domain_map.md) and
[docs/architecture.md](docs/architecture.md).

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

## Build the Project

The fastest way to check the whole repo is:

```bash
scripts/validate_repo.sh
```

That command installs project dependencies, lints SQL, seeds local DuckDB source
tables, builds each dbt project in dependency order, and runs a few direct
MetricFlow queries.

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

## Explore the Project

Try a few dbt Core commands from the repo root:

```bash
dbt ls --project-dir projects/jaffle_platform --profiles-dir . --select fct_orders
dbt ls --project-dir projects/jaffle_finance --profiles-dir . --select access:public --resource-type model
dbt build --project-dir projects/jaffle_finance --profiles-dir . --select fct_order_revenue+
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

## Run MetricFlow

Build the repo first, then point MetricFlow at the same DuckDB file:

```bash
export JAFFLE_CORP_DUCKDB_PATH="$PWD/jaffle_corp.duckdb"
```

Inspect available metrics directly:

```bash
cd projects/jaffle_finance
DBT_PROFILES_DIR=../.. mf validate-configs --skip-dw
DBT_PROFILES_DIR=../.. mf list metrics
```

Run a query:

```bash
DBT_PROFILES_DIR=../.. mf query \
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

Good next steps:

- Compare public and protected models in a downstream project.
- Trace how a metric moves from a mart model into `models/semantic_models.yml`
  and `models/metrics.yml`.
- Add a test to a public model contract.
- Refactor one legacy model without changing its external behavior.
- Decide whether a merchandising or planning model should become public,
  protected, or private.

Useful docs:

- [docs/architecture.md](docs/architecture.md)
- [docs/domain_map.md](docs/domain_map.md)
- [docs/metricflow.md](docs/metricflow.md)

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
