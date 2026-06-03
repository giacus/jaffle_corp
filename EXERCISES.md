# Exercises

These exercises are intentionally incomplete. The repo is meant to feel like a
realistic analytics codebase, so you should discover additional issues through
parsing, building, reading lineage, and writing tests.

Start by running the platform project from the README. Then choose a path based
on what you want to practice. For a sequenced workshop-style journey, use
[docs/course_path.md](docs/course_path.md).

## First Tour

Goal: learn how the repo is shaped before changing code.

```bash
dbt ls --project-dir projects/jaffle_platform --profiles-dir . --select access:public --resource-type model
dbt deps --project-dir projects/jaffle_finance --profiles-dir .
dbt ls --project-dir projects/jaffle_finance --profiles-dir . --select +fct_order_revenue
dbt build --project-dir projects/jaffle_finance --profiles-dir . --select +fct_order_revenue
```

Then open the finance mart YAML and answer:

- Which upstream public models does finance depend on?
- Which finance models are public interfaces?
- Which tests protect `fct_order_revenue`?

Done means you can explain the lineage from orders and order items to finance
revenue without reading every model in the repo.

## Modeling And Tests

- Add a scenario-aware key to
  `jaffle_planning.fct_product_day_forecast_accuracy`. The current model hints
  at the problem but does not enforce uniqueness.
- Add a test that catches overlapping capacity scenario windows by store.
- Add accepted-value tests for scenario names, owner roles, and adjustment
  reasons.
- Tighten currency naming in
  `jaffle_merchandising.fct_menu_margin_baseline`; it mixes local prices with
  USD recipe costs.

## Contracts And Ownership

- Compare public and protected models in `jaffle_finance` or
  `jaffle_store_ops`. Write down which models feel safe for another project to
  depend on.
- Add model contracts to the most important merchandising and planning marts
  once you decide which surfaces should be public.
- Convert at least one legacy-style surface into a clean public model with a
  contract.

## Macros And Configuration

- Replace the hard-coded merchandising availability threshold in
  `jaffle_shared.availability_health` with a project variable.
- Find one repeated expression that is realistic enough to become a shared
  macro, then add tests or examples around the change.

## Semantic Layer

- Trace one finance metric from `models/metrics.yml` to its measure in
  `models/semantic_models.yml` and then to the mart model.
- Extend MetricFlow coverage for substitution readiness or planning exceptions.
- Add a `models/saved_queries.yml` file only if you can describe who would reuse
  the query and why.

## Notes For Instructors

Do not treat this file as a full answer key. It names low-friction exercises so
students can get started, while leaving enough ambiguity for code review, lineage
inspection, and semantic-model debugging practice.
