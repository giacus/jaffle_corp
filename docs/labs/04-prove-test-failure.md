# Lab 4: Prove a Test Can Fail

[Labs](../labs.md) · Previous: [Navigate the manifest](03-navigate-manifest.md) · Next: [Add a behavior test](05-add-behavior-test.md)

## At a Glance

- **Level:** guided
- **Time:** 20–30 minutes
- **Requires:** the local environment from Lab 1
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

## Expected Observations

- The controlled duplicate makes the staging model's uniqueness test fail while
  the SQL model itself can still build.
- The failing test query returns the duplicated identifier, which is more useful
  evidence than the command's nonzero exit code alone.
- Restoring and reseeding the raw input makes the same focused build pass.

## Common Failure Modes

Editing a row without creating an exact duplicate identifier will not exercise
the intended uniqueness test. If the failure persists after restoration, make
sure you reseeded with `--full-refresh` before rebuilding the staging model.

## Workspace State and Cleanup

The temporary seed mutation must not survive the lab. Delete its out-of-repo
backup after the final `git diff --exit-code` passes. The restored seed remains
loaded in DuckDB; keep it for Lab 5 or run `scripts/clean.sh` at the end of the
session.

## Completion Rubric

- [ ] You captured one expected uniqueness failure and inspected its returned
      row or compiled query.
- [ ] The restored seed produces a passing focused build.
- [ ] `git diff --exit-code` confirms the fixture is unchanged.
- [ ] You can explain why this test detects a data violation rather than a SQL
      compilation problem.

Continue to [Lab 5: Protect a price-window invariant](05-add-behavior-test.md).
