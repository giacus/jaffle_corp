# Lab 7: Observe Snapshot History

[Labs](../labs.md) · Previous: [Review a contract change](06-review-contract-change.md) · Next: [Query the semantic layer](08-query-semantic-layer.md)

## At a Glance

- **Level:** intermediate
- **Time:** 30–45 minutes
- **Requires:** Lab 1 complete with platform built
- **You will:** observe how a timestamp snapshot records a changing customer.

## Inspect

- `projects/platform/snapshots/customer_profile_snapshot.sql`
- `projects/shared/seeds/platform/raw_customers.csv`

## Create Two Versions

1. Run the snapshot once.
2. Save the seed outside the repository.
3. Change one customer's descriptive field and advance its `updated_at` value.
4. Reseed and rerun the snapshot.
5. Inspect the history.

```bash
dbt snapshot --project-dir projects/platform \
  --select customer_profile_snapshot

dbt seed --project-dir projects/platform \
  --select raw_customers --full-refresh

dbt snapshot --project-dir projects/platform \
  --select customer_profile_snapshot

dbt show --project-dir projects/platform --inline \
  "select customer_id, dbt_valid_from, dbt_valid_to from {{ ref('customer_profile_snapshot') }} order by customer_id, dbt_valid_from"
```

Restore the seed and reseed `raw_customers`. The snapshot intentionally retains
the history it observed. Run `scripts/validate_repo.sh` later if you want to
recreate the entire local database from a clean baseline.

## Checkpoint

You are done when you can explain why a later timestamp creates a new version
and how dbt marks the current versus historical row.

Continue to [Lab 8: Query the semantic layer](08-query-semantic-layer.md).
