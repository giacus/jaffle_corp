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

- Add a new model to `projects/jaffle_reliability` that uses only public refs
  from upstream projects. Pick a clear grain before you write SQL.
- Add a singular test that catches overlapping merchandising price adjustment
  windows for the same product, store, and effective timestamp.
- Add a negative fixture row to a seed on a short-lived branch, prove an existing
  test fails, then remove the row and prove the project passes again.
- Extend the reliability score with one more public upstream signal and update
  its contract without changing the model grain.

## Contracts And Ownership

- Compare public and protected models in `jaffle_finance` or
  `jaffle_store_ops`. Write down which models feel safe for another project to
  depend on.
- Inspect the merchandising and planning public contracts. Write down one
  contract change that would be backward-compatible and one that would be
  breaking for `jaffle_reliability`.
- Add a second downstream extension project that depends on public marts from at
  least two domains.
- Convert at least one legacy-style surface into a clean public model with a
  contract.

## Macros And Configuration

- Add a project variable that changes a threshold in one mart, then prove the
  behavior with a focused model build and one query.
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
