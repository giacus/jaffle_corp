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
cd projects/jaffle_reliability
dbt deps
dbt build --select jaffle_reliability
cd ../..
```

The extension currently joins:

- `jaffle_finance.fct_store_day_revenue_quality`
- `jaffle_merchandising.fct_product_store_day_availability`
- `jaffle_planning.fct_store_day_capacity_plan`

Those are all public contracted upstream models.
