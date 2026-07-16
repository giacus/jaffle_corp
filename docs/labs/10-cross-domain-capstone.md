# Lab 10: Build a Cross-Domain Capstone

[Labs](../labs.md) · Previous: [Refactor a legacy interface](09-refactor-legacy-interface.md)

## At a Glance

- **Level:** advanced
- **Time:** 2–4 hours
- **Requires:** the earlier labs, or a successful full validation
- **You will:** design, contract, and test a new downstream model.

## Start from a Clean Baseline

The full validator is a clean rebuild: it removes the local DuckDB database and
generated dbt artifacts before recreating and validating the repository. Save
any Lab 7 snapshot evidence you still need before running it. Authored SQL and
documentation are not removed.

```bash
scripts/validate_repo.sh
```

## Business Question

> Do orders that miss the kitchen ready target generate more support demand,
> worse SLA outcomes, or lower satisfaction?

Use only these public contracted inputs:

- `store_ops.fct_order_service_times`
- `experience.fct_support_tickets`

## Design Before SQL

Decide:

1. Is the output grain one row per order or one row per ticket?
2. Which key enforces that grain?
3. Which columns belong in the public contract?
4. Which behavioral test proves the result is trustworthy?
5. Should this extend `reliability` or become another extension project?

Then add the model, YAML contract, documentation, behavioral test, and one
analysis query.

If you create another project, register it in:

- `scripts/validate_repo.sh` at the correct dependency point;
- `projects/catalog/packages.yml` for manifest coverage;
- `docs/architecture.md` for discoverability.

## Final Verification

Run focused upstream and downstream builds, then:

```bash
scripts/validate_repo.sh
```

## Expected Observations

- Both inputs are public, contracted interfaces, but their different grains
  force an explicit join and output-grain decision.
- Orders without support tickets and tickets without complete kitchen timing
  make join semantics part of the business definition.
- The most useful behavior test protects the chosen grain or business
  relationship rather than repeating contract checks.
- Full validation exercises project registration and protected-reference rules
  that a focused model build cannot prove alone.

## Common Failure Modes

Joining order-level timing directly to ticket-level support data can multiply
orders or obscure multiple tickets. Prove the cardinality before calculating
rates or averages. If a new project parses alone but fails full validation,
check package registration, dependency order, access boundaries, and catalog
coverage.

## Workspace State and Cleanup

Use a dedicated branch: the model, contract, docs, tests, and analysis are
authored deliverables. The full validator intentionally replaces local DuckDB
state on each run. After saving your results, run
`scripts/clean.sh` to remove the database, packages, logs, and build
artifacts without touching authored files.

## Completion Rubric

- [ ] The design states the output grain, join cardinality, null policy, and
      ownership before implementation.
- [ ] The public contract and tests enforce the chosen grain and one meaningful
      behavior.
- [ ] The analysis query answers the business question and discusses edge cases.
- [ ] No protected refs are used, focused checks pass, and the clean full
      validator succeeds.

Return to the [labs index](../labs.md) and choose a stretch idea.
