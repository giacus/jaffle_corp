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
the history it observed.

## Expected Observations

- The first snapshot run creates one current version for each customer.
- A later `updated_at` for the edited customer creates another version instead
  of overwriting the first.
- Only the current version has an open-ended validity interval after the second
  snapshot run.
- Restoring the raw seed does not erase history already recorded by the snapshot.

## Common Failure Modes

Changing a descriptive value without advancing `updated_at` will not create a
new version under the timestamp strategy. Reseed after every CSV edit, and run
the snapshot only after the new source row is visible in DuckDB.

## Workspace State and Cleanup

Restore the tracked seed before leaving the lab. Snapshot history remains in the
local DuckDB database by design, so keep it while studying the result. When the
session is over, run `scripts/clean.sh` to remove the database and
all generated workshop state. A full validation also starts from a clean local
database and will discard this history.

## Completion Rubric

- [ ] The selected customer has at least two ordered history rows.
- [ ] You can identify the current and historical versions from validity fields.
- [ ] The raw customer seed is restored and clean in Git.
- [ ] You can explain why restoring a source row and deleting snapshot history
      are separate operations.

Continue to [Lab 8: Query the semantic layer](08-query-semantic-layer.md).
