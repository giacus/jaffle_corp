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
