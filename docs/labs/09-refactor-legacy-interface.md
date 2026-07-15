# Lab 9: Refactor a Legacy Interface

[Labs](../labs.md) · Previous: [Query the semantic layer](08-query-semantic-layer.md) · Next: [Cross-domain capstone](10-cross-domain-capstone.md)

## At a Glance

- **Level:** advanced
- **Time:** 60–90 minutes
- **Requires:** labs 1–8, or a successful `scripts/validate_repo.sh`
- **You will:** improve an awkward model without losing relied-on behavior.

## Establish the Baseline

Start with:

- `projects/legacy/models/marts/legacy_daily_store_rollup`
- `projects/legacy/models/exposures.yml`

```bash
dbt deps --project-dir projects/legacy
dbt build --project-dir projects/legacy \
  --select +legacy_daily_store_rollup
dbt show --project-dir projects/legacy --inline \
  "select count(*) as row_count from {{ ref('legacy_daily_store_rollup') }}"
```

Capture the row count and representative business totals before editing SQL.

## Refactor Safely

1. Identify naming, grain, or currency problems.
2. Add a characterization test for behavior the exposure relies on.
3. Build a cleaner replacement or adapter.
4. Compare the new result with the baseline.
5. Document what improved and what stayed compatible.

Rerun the focused build and select your characterization test by name.

## Checkpoint

You are done when the before/after evidence is explicit, the compatibility test
passes, and you can explain which awkward behavior was intentionally preserved.

Continue to [Lab 10: Build a cross-domain capstone](10-cross-domain-capstone.md).
