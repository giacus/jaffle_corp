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

## Expected Observations

- The legacy output mixes awkward names and business semantics that downstream
  exposure consumers may nevertheless rely on.
- A characterization test preserves observed behavior without claiming that the
  behavior is ideal.
- An adapter can offer a clearer interface while isolating compatibility logic
  from new domain logic.

## Common Failure Modes

Do not use a row count alone as proof of equivalence; capture representative
totals at the model grain and account for null and currency behavior. Avoid
silently renaming or recasting columns still referenced by the exposure.

## Workspace State and Cleanup

Do this exercise on a learning branch. The replacement model,
characterization test, and documentation are authored code and are never removed
by the local-state cleanup script. Keep or discard those changes deliberately;
use `scripts/clean.sh` only to remove generated data and artifacts.

## Completion Rubric

- [ ] Baseline evidence includes row count and business totals at the declared
      grain.
- [ ] The characterization test fails for a meaningful incompatible change.
- [ ] The replacement or adapter improves a named problem without breaking the
      behavior you chose to preserve.
- [ ] Focused builds and tests pass, and the compatibility decision is recorded.

Continue to [Lab 10: Build a cross-domain capstone](10-cross-domain-capstone.md).
