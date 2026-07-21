# Jaffle Reliability Extension

This project is a downstream fixture that depends on public `jaffle-corp`
interfaces. It is intentionally small: the goal is to show extension authors how
to depend on stable marts without reaching into another domain's staging or
intermediate models.

Run the full repo check from the repository root when you want to prove the
upstream contracts and this extension still work together:

```bash
scripts/validate_repo.sh
```

Then iterate on only the extension after the upstream projects have been built:

```bash
dbt deps --project-dir projects/reliability
dbt build --project-dir projects/reliability --select reliability
```

The extension currently joins:

- `finance.fct_store_day_revenue_quality`
- `merchandising.fct_product_store_day_availability`
- `planning.fct_store_day_capacity_plan`

Those are all public contracted upstream models.

The project defines two dbt user-defined functions. `reliability_status`
classifies a bounded score in the mart, while `current_store_reliability`
provides a reusable store-and-date lookup over that public mart. DuckDB does not
yet provide dbt's scalar function DDL directly, so the project dispatches dbt's
UDF materialization to equivalent DuckDB scalar macros while keeping standard
dbt function resources and dependency behavior.

An on-run-start readiness operation names any missing public upstream relation
before the mart runs, while remaining safe during a first-time parse. Analyses
can call the canonical store-and-date function directly.
