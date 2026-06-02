# jaffle-corp

`jaffle-corp` is a deliberately overgrown dbt demo for teams that have outgrown the classic Jaffle Shop example.

The business is still fictional and food-focused: customers buy jaffles from stores, orders contain items, products require supplies, payments settle in multiple currencies, refunds happen, campaigns create attribution arguments, and legacy tables refuse to disappear. The project is intentionally more realistic than a tidy tutorial while remaining safe for open-source use.

## What This Repo Demonstrates

- A multi-project dbt monorepo with domain boundaries.
- Mesh-style project dependencies through `dependencies.yml`.
- Local package fallbacks so contributors can parse and build examples without a dbt platform account.
- Public model contracts on project interfaces.
- Semantic Layer definitions with direct MetricFlow commands for simple, derived, ratio, cumulative, and conversion metrics.
- Legacy models, inconsistent source conventions, time-window macros, and selectors that mimic production sprawl.
- Supply, support, experimentation, quality, store operations, merchandising, planning, snapshots, analyses, exposures, and singular tests.
- Multiple grains beyond order and order item: store-hour, product-store-hour, product-store-day, product-pair-day, store-product-day, component-store-week, scenario-store-day, customer-day, and store-day.
- Synthetic seed data only. No real company data, names, warehouse identifiers, or proprietary business entities are included.

## Project Map

| Project | Purpose | Depends On |
| --- | --- | --- |
| `jaffle_shared` | Shared macros and schema behavior. | None |
| `jaffle_platform` | Raw ingestion, staging, conformed dimensions, order facts, and public interfaces. | `jaffle_shared` |
| `jaffle_supply` | Recipes, purchase orders, inventory counts, component costs, and supply risk. | `jaffle_platform`, `jaffle_shared` |
| `jaffle_finance` | Payments, refunds, FX normalization, revenue recognition, margin, and finance controls. | `jaffle_platform`, `jaffle_supply`, `jaffle_shared` |
| `jaffle_experience` | Support tickets, contact threads, menu price tests, and experiment outcomes. | `jaffle_platform`, `jaffle_finance`, `jaffle_shared` |
| `jaffle_growth` | Loyalty, promo attribution, customer lifecycle, experiment conversion, and value segments. | `jaffle_platform`, `jaffle_finance`, `jaffle_experience`, `jaffle_shared` |
| `jaffle_store_ops` | Kitchen timing, shifts, quality checks, incidents, and store-day operations. | `jaffle_platform`, `jaffle_supply`, `jaffle_finance`, `jaffle_shared` |
| `jaffle_merchandising` | Menu publications, product-store availability, price adjustments, menu goals, product pairings, and substitutions. | `jaffle_platform`, `jaffle_supply`, `jaffle_shared` |
| `jaffle_planning` | Forecast accuracy, capacity scenarios, operating calendars, and component-week plans. | `jaffle_platform`, `jaffle_supply`, `jaffle_finance`, `jaffle_store_ops`, `jaffle_shared` |
| `jaffle_legacy` | Intentional legacy patterns kept as a migration playground. | `jaffle_platform`, `jaffle_finance`, `jaffle_experience`, `jaffle_shared` |

## Quickstart

Install dbt with the DuckDB adapter. Use Python 3.11 or 3.12; Python 3.14 is not yet supported by the current dbt dependency stack.

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

To validate the full repo exactly the way CI does:

```bash
scripts/validate_repo.sh
```

Install dependencies and seed the local DuckDB source tables:

```bash
dbt deps --project-dir projects/jaffle_platform --profiles-dir .
dbt seed --project-dir projects/jaffle_platform --profiles-dir .

dbt deps --project-dir projects/jaffle_supply --profiles-dir .
dbt seed --project-dir projects/jaffle_supply --profiles-dir .

dbt deps --project-dir projects/jaffle_finance --profiles-dir .

dbt deps --project-dir projects/jaffle_experience --profiles-dir .
dbt seed --project-dir projects/jaffle_experience --profiles-dir .

dbt deps --project-dir projects/jaffle_growth --profiles-dir .

dbt deps --project-dir projects/jaffle_store_ops --profiles-dir .
dbt seed --project-dir projects/jaffle_store_ops --profiles-dir .

dbt deps --project-dir projects/jaffle_merchandising --profiles-dir .
dbt seed --project-dir projects/jaffle_merchandising --profiles-dir .

dbt deps --project-dir projects/jaffle_planning --profiles-dir .
dbt seed --project-dir projects/jaffle_planning --profiles-dir .

dbt deps --project-dir projects/jaffle_legacy --profiles-dir .
```

Build the projects sequentially:

```bash
dbt build --project-dir projects/jaffle_platform --profiles-dir .
dbt build --project-dir projects/jaffle_supply --profiles-dir .
dbt build --project-dir projects/jaffle_finance --profiles-dir .
dbt build --project-dir projects/jaffle_experience --profiles-dir .
dbt build --project-dir projects/jaffle_growth --profiles-dir .
dbt build --project-dir projects/jaffle_store_ops --profiles-dir .
dbt build --project-dir projects/jaffle_merchandising --profiles-dir .
dbt build --project-dir projects/jaffle_planning --profiles-dir .
dbt build --project-dir projects/jaffle_legacy --profiles-dir .
```

Run MetricFlow directly against the local build:

```bash
export JAFFLE_CORP_DUCKDB_PATH="$PWD/jaffle_corp.duckdb"

cd projects/jaffle_finance
DBT_PROFILES_DIR=../.. mf validate-configs --skip-dw
DBT_PROFILES_DIR=../.. mf query \
  --metrics net_revenue_usd,estimated_gross_margin_usd,refund_rate \
  --group-by metric_time,location,order__country_code \
  --limit 20
```

See [docs/metricflow.md](docs/metricflow.md) for the full set of domain MetricFlow commands.

Lint SQL across the multi-project repo:

```bash
scripts/lint_sql_projects.sh
```

The committed `profiles.yml` uses a local ignored DuckDB file named `jaffle_corp.duckdb`, so there are no credentials to configure.

Run project builds sequentially when using the local DuckDB profile. DuckDB allows one writer per database file, so parallel project builds can conflict on the demo database lock.

## Mesh Notes

Each consumer project contains:

- `dependencies.yml` for the intended dbt Mesh relationship.
- `packages.yml` local path dependencies for open-source local parsing and end-to-end demos.

In a hosted mesh environment, the project dependencies are the interface boundary. The local package fallback exists because public contributors will not have your account-level metadata service.

## Data Contract Philosophy

The public models are intentionally narrow:

- `jaffle_platform.fct_orders`
- `jaffle_platform.fct_order_items`
- `jaffle_platform.fct_promo_events`
- `jaffle_platform.fct_loyalty_events`
- `jaffle_platform.dim_exchange_rates`
- `jaffle_platform.dim_customers`
- `jaffle_platform.dim_locations`
- `jaffle_platform.dim_products`
- `jaffle_supply.dim_components`
- `jaffle_supply.fct_purchase_orders`
- `jaffle_supply.fct_product_component_costs`
- `jaffle_supply.fct_inventory_daily`
- `jaffle_supply.fct_supply_risk_daily`
- `jaffle_finance.fct_order_revenue`
- `jaffle_finance.fct_daily_store_pnl`
- `jaffle_finance.fct_order_margin_waterfall`
- `jaffle_finance.fct_store_day_revenue_quality`
- `jaffle_finance.fct_component_cost_variance`
- `jaffle_finance.dim_finance_controls`
- `jaffle_experience.fct_support_tickets`
- `jaffle_experience.fct_customer_contact_threads`
- `jaffle_experience.fct_experiment_outcomes`
- `jaffle_experience.fct_menu_price_test_results`
- `jaffle_experience.dim_experiment_variants`
- `jaffle_growth.fct_customer_lifecycle`
- `jaffle_growth.fct_campaign_performance`
- `jaffle_growth.fct_customer_value_segments`
- `jaffle_growth.fct_loyalty_balance_daily`
- `jaffle_growth.fct_experiment_conversion`
- `jaffle_growth.fct_campaign_incrementality`
- `jaffle_store_ops.fct_order_service_times`
- `jaffle_store_ops.fct_store_day_operations`
- `jaffle_store_ops.fct_quality_events`
- `jaffle_store_ops.fct_incident_reviews`
- `jaffle_store_ops.dim_store_operating_profiles`

Everything else is treated as protected implementation detail unless explicitly configured otherwise.

The merchandising and planning projects deliberately contain more protected/internal surfaces so students can practice deciding what should become public, contracted, or deleted.

## Student Exercises

See [TODO.md](TODO.md) for a deliberately incomplete list of starter fixes. The list is not an answer key; finding additional modeling, testing, semantic, and ownership issues is part of the exercise.

## Repository Hygiene

See [docs/open_source_sanitization.md](docs/open_source_sanitization.md) for the sanitization rules used while creating this repo.

## Contributing

This repo is intended to be played with. Good contributions add realistic dbt complexity while keeping the business fictional, small enough to run locally, and understandable from the docs.

Before opening a pull request:

```bash
scripts/validate_repo.sh
```

If you need to scan for additional private-domain terms before publishing, pass them explicitly:

```bash
PROHIBITED_PATTERN='<pipe-separated-private-terms>' scripts/check_sanitization.sh
```

The sanitization script ignores the command line that defines `PROHIBITED_PATTERN`, so copied examples do not self-match.

Reference material used for structure:

- [dbt-labs/jaffle-shop](https://github.com/dbt-labs/jaffle-shop)
- [dbt project dependencies docs](https://docs.getdbt.com/docs/mesh/govern/project-dependencies)
- [dbt model access docs](https://docs.getdbt.com/reference/resource-configs/access)
- [dbt Semantic Layer docs](https://docs.getdbt.com/docs/build/semantic-models)
