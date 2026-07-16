# Lab 5: Protect a Price-Window Invariant

[Labs](../labs.md) · Previous: [Prove a test can fail](04-prove-test-failure.md) · Next: [Review a contract change](06-review-contract-change.md)

## At a Glance

- **Level:** intermediate
- **Time:** 45–60 minutes
- **Requires:** Lab 4 complete with the seed restored
- **You will:** write a singular test for cross-row business behavior.

## Design the Rule

Inspect:

- `projects/shared/models/staging/merchandising/stg_price_adjustments`
- `projects/merchandising/models/marts/fct_price_adjustment_windows`
- `projects/merchandising/tests`

Create:

```text
projects/merchandising/tests/assert_price_adjustment_windows_do_not_overlap.sql
```

The test must return rows when two adjustment windows overlap for the same
product and store. Decide whether touching endpoints count as overlap and explain
that choice in the SQL.

## Verify

```bash
dbt deps --project-dir projects/merchandising
dbt seed --project-dir projects/merchandising \
  --select raw_price_adjustments --full-refresh
dbt build --project-dir projects/merchandising \
  --select +fct_price_adjustment_windows
dbt test --project-dir projects/merchandising \
  --select assert_price_adjustment_windows_do_not_overlap
```

Add a temporary overlapping row, reseed, and prove the test fails. Remove it,
reseed, and prove the test passes.

## Expected Observations

- The baseline fixture passes because no two windows violate your chosen
  interval semantics.
- The temporary overlap returns the offending pair rather than an aggregate
  count, giving a reviewer evidence they can diagnose.
- The test can pass or fail independently of the model contract because it
  protects cross-row behavior, not column shape.

## Common Failure Modes

A self-join can compare a window with itself or emit the same pair twice. Design
an ordering predicate between identifiers and decide explicitly how null end
timestamps and touching endpoints behave. If the test does not fail, verify that
the temporary row matches the same product and store and was reseeded.

## Workspace State and Cleanup

The temporary seed row must be removed and the original seed reseeded. The new
singular test is an authored lab deliverable: keep it on a learning branch if you
want to review or commit it, or delete it after saving your evidence. The local
cleanup script removes generated data, not authored SQL. Keep generated state
for the next lab. Use `scripts/clean.sh --keep-venv` only for an intentional
restart followed by the prerequisites, or `scripts/clean.sh` when the session
ends.

## Completion Rubric

- [ ] The test passes on the baseline, fails on a deliberate overlap, and passes
      again after restoration.
- [ ] Returned failure rows identify both conflicting windows.
- [ ] The SQL explains endpoint and open-ended-window semantics.
- [ ] `git status --short` shows only the singular test you intentionally chose
      to retain, or a clean tree if you removed it.

Continue to [Lab 6: Review a contract change](06-review-contract-change.md).
