# Course Path

Use this path when you want `jaffle-corp` to behave like a structured dbt Core
training fixture instead of a repo to wander through.

The modules are ordered from orientation to advanced practice. The sequence is
the smoothest self-study path.

Suggested formats:

- 60-minute tour: modules 1, 2, and the concept map.
- Half-day workshop: modules 1 through 4.
- Multi-day practice: all modules plus the capstone.

## Preflight

Before starting a module in a fresh clone, run:

```bash
scripts/bootstrap.sh
source .venv/bin/activate
dbt seed --project-dir projects/jaffle_platform
dbt build --project-dir projects/jaffle_platform --exclude resource_type:seed
```

If you start at module 3 or later instead of following the sequence, first run
`scripts/validate_repo.sh` to create a complete baseline.

## 1. Orientation

Goal: build one project and understand the local workflow.

Start from the repo root and activate the local environment:

```bash
source .venv/bin/activate
```

Start here:

```bash
dbt debug --project-dir projects/jaffle_platform
dbt deps --project-dir projects/jaffle_platform
dbt seed --project-dir projects/jaffle_platform
dbt build --project-dir projects/jaffle_platform --exclude resource_type:seed
```

Inspect:

- `profiles.yml`
- `projects/jaffle_platform/dbt_project.yml`
- `projects/jaffle_platform/models/staging`
- `projects/jaffle_platform/models/marts`

You are done when you can explain where raw seed data lands, which models become
public interfaces, and how to rebuild the project from the command line.

## 2. Domain Modeling

Goal: follow one business question through staging, intermediate, and mart
models.

Suggested question: "How does an order become recognized revenue?"

Inspect:

- `projects/jaffle_platform/models/marts/fct_orders/fct_orders.sql`
- `projects/jaffle_platform/models/marts/fct_order_items/fct_order_items.sql`
- `projects/jaffle_finance/models/marts/fct_order_revenue/fct_order_revenue.sql`
- `projects/jaffle_finance/models/marts/fct_order_revenue/fct_order_revenue.yml`

Commands:

```bash
dbt deps --project-dir projects/jaffle_finance
dbt ls --project-dir projects/jaffle_finance \
  --select +fct_order_revenue \
  --resource-type model
dbt build --project-dir projects/jaffle_finance --select +fct_order_revenue
```

You are done when you can describe the grain of `fct_order_revenue`, its tests,
and the upstream public models it relies on.

The command-by-command version is [Lab 1 in the exercise catalog](../EXERCISES.md#lab-1-trace-recognized-revenue).

## 3. Interfaces And Contracts

Goal: decide what should be safe for other projects to depend on.

Inspect:

- `dependencies.yml` files in downstream projects
- `packages.yml` files used for local dbt Core execution
- `access` and `contract` configs in mart YAML files

Practice:

- Compare public and protected models in `jaffle_finance`.
- Inspect a contracted merchandising or planning mart and name the exact columns
  a downstream project can safely rely on.
- Build or modify a small model in `projects/jaffle_reliability` using only
  public upstream refs.
- Add or tighten a model contract only after deciding the interface is stable
  enough for another project to consume.

You are done when you can explain the difference between a local package fallback
and an intended project dependency.

## 4. Testing Realistic Data

Goal: add tests that protect behavior instead of only checking not-null columns.

Inspect:

- Generic tests in `models/**/<model>/<model>.yml`
- Singular tests in `projects/*/tests`
- The intentionally incomplete ideas in [../EXERCISES.md](../EXERCISES.md)

Practice:

- Add an accepted-values test for a planning scenario or owner role.
- Add a singular test for overlapping price adjustment windows.
- Run the project-specific build that proves your test is wired correctly.

You are done when a future contributor would understand what behavior your test
protects.

Use [Lab 2](../EXERCISES.md#lab-2-prove-a-test-can-fail) for a guided failure or
[Lab 4](../EXERCISES.md#lab-4-protect-a-price-window-invariant) for the interval
test.

## 5. Legacy Migration

Goal: improve a messy model without losing its external behavior.

Inspect:

- `projects/jaffle_legacy/models/marts`
- `projects/jaffle_legacy/models/staging`
- `projects/jaffle_legacy/analyses`

Practice:

- Start with `legacy_daily_store_rollup` and its declared exposure.
- Capture baseline row counts and representative totals before changing SQL.
- Add a characterization test for the behavior the consumer relies on.
- Build a cleaner replacement or adapter model.
- Compare the result with the baseline and document the compatibility boundary.

You are done when you can explain what stayed compatible and what became cleaner.

See [Lab 7](../EXERCISES.md#lab-7-refactor-a-legacy-interface-safely) for the full
feedback loop.

## 6. Semantic Layer And MetricFlow

Goal: trace a metric from SQL model to semantic model to MetricFlow query.

Inspect:

- `projects/jaffle_finance/models/semantic_models.yml`
- `projects/jaffle_finance/models/metrics.yml`
- [metricflow.md](metricflow.md)

Commands:

```bash
source .venv/bin/activate
cd projects/jaffle_finance
mf validate-configs --skip-dw
mf list metrics
mf query \
  --metrics net_revenue_usd,estimated_gross_margin_usd,refund_rate \
  --group-by metric_time,location,order__country_code \
  --limit 20
cd ../..
```

You are done when you can explain the model grain, measure, metric, dimensions,
and query output without a wrapper script.

## 7. Capstone

Goal: make a realistic cross-domain change.

Example prompt:

> Store operations and customer experience want to know whether orders that miss
> the kitchen ready target generate more support demand, worse SLA outcomes, or
> lower satisfaction. Add a tested downstream model using the public order
> service-time and support-ticket interfaces.

Expected work:

- Choose the right public interfaces.
- Avoid reaching into protected implementation models unless you deliberately
  change their access.
- Add tests for the new grain.
- Decide whether the output should be public or protected.
- Run the relevant downstream builds.
- Register any new extension project in validation, the full catalog, and the
  architecture docs.

You are done when the change is understandable from dbt lineage and does not
break `scripts/validate_repo.sh`.

Use [Lab 8](../EXERCISES.md#lab-8-cross-domain-support-capstone) for concrete
inputs and completion criteria.

## Concept Map

| Concept | Where to look |
| --- | --- |
| dbt Core local profile | `profiles.yml` |
| Multi-project layout | `projects/*/dbt_project.yml` |
| Local package fallback | `projects/*/packages.yml` |
| Project dependency intent | `projects/*/dependencies.yml` |
| Domain map | `docs/architecture.md` |
| Downstream extension fixture | `projects/jaffle_reliability` |
| Model-local layout | `projects/*/models/<layer>/<model>/<model>.sql` |
| Public model access | `projects/*/models/marts/<model>/<model>.yml` |
| Model contracts | `projects/*/models/marts/<model>/<model>.yml` |
| Staging conventions | `projects/*/models/staging` |
| Intermediate modeling | `projects/*/models/intermediate` |
| Singular tests | `projects/*/tests` |
| Snapshots | `projects/jaffle_platform/snapshots` |
| Exposures | `projects/*/models/exposures.yml` |
| Semantic models | `projects/*/models/semantic_models.yml` |
| Metrics | `projects/*/models/metrics.yml` |
| Legacy anti-patterns | `projects/jaffle_legacy` |
| End-to-end validation | `scripts/validate_repo.sh` |
| Full-project dbt artifact | `target/manifest.json` from `scripts/generate_manifest.sh` |
