# Task 4: Prove a Test Can Fail

[Course path](../course_path.md) · Previous: [Navigate the manifest](03-navigate-manifest.md) · Next: [Add a behavior test](05-add-behavior-test.md)

## At a Glance

- **Level:** guided
- **Time:** 20–30 minutes
- **Requires:** the local environment from Task 1
- **You will:** create, observe, and recover from a controlled test failure.

## Prepare

Use:

- `projects/shared/seeds/merchandising/raw_price_adjustments.csv`
- `projects/shared/models/staging/merchandising/stg_price_adjustments/stg_price_adjustments.yml`

Save a temporary copy of the seed outside the repository. Then duplicate one
data row so two rows have the same `price_adjustment_id`.

## Prove the Failure

```bash
dbt deps --project-dir projects/merchandising
dbt seed --project-dir projects/merchandising \
  --select raw_price_adjustments --full-refresh
dbt build --project-dir projects/merchandising \
  --select stg_price_adjustments
```

Read the failing uniqueness test and its compiled query. Restore the original
seed, then rerun the seed and build until both pass.

Confirm only that seed is clean:

```bash
git diff --exit-code -- \
  projects/shared/seeds/merchandising/raw_price_adjustments.csv
```

## Checkpoint

You are done when you have seen the expected failure once, restored the fixture,
and can explain what row the test returned and why.

Continue to [Task 5: Protect a price-window invariant](05-add-behavior-test.md).
