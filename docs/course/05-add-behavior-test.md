# Task 5: Protect a Price-Window Invariant

[Course path](../course_path.md) · Previous: [Prove a test can fail](04-prove-test-failure.md) · Next: [Review a contract change](06-review-contract-change.md)

## At a Glance

- **Level:** intermediate
- **Time:** 45–60 minutes
- **Requires:** Task 4 complete with the seed restored
- **You will:** write a singular test for cross-row business behavior.

## Design the Rule

Inspect:

- `projects/jaffle_shared/models/staging/merchandising/stg_price_adjustments`
- `projects/jaffle_merchandising/models/marts/fct_price_adjustment_windows`
- `projects/jaffle_merchandising/tests`

Create:

```text
projects/jaffle_merchandising/tests/assert_price_adjustment_windows_do_not_overlap.sql
```

The test must return rows when two adjustment windows overlap for the same
product and store. Decide whether touching endpoints count as overlap and explain
that choice in the SQL.

## Verify

```bash
dbt deps --project-dir projects/jaffle_merchandising
dbt seed --project-dir projects/jaffle_merchandising \
  --select raw_price_adjustments --full-refresh
dbt build --project-dir projects/jaffle_merchandising \
  --select +fct_price_adjustment_windows
dbt test --project-dir projects/jaffle_merchandising \
  --select assert_price_adjustment_windows_do_not_overlap
```

Add a temporary overlapping row, reseed, and prove the test fails. Remove it,
reseed, and prove the test passes.

## Checkpoint

You are done when the fixture is restored and your test's interval semantics are
clear enough for another engineer to review.

Continue to [Task 6: Review a contract change](06-review-contract-change.md).
