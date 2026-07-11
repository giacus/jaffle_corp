# Task 10: Build a Cross-Domain Capstone

[Course path](../course_path.md) · Previous: [Refactor a legacy interface](09-refactor-legacy-interface.md)

## At a Glance

- **Level:** advanced
- **Time:** 2–4 hours
- **Requires:** the earlier tasks, or a successful full validation
- **You will:** design, contract, and test a new downstream model.

## Start from a Clean Baseline

```bash
scripts/validate_repo.sh
```

## Business Question

> Do orders that miss the kitchen ready target generate more support demand,
> worse SLA outcomes, or lower satisfaction?

Use only these public contracted inputs:

- `jaffle_store_ops.fct_order_service_times`
- `jaffle_experience.fct_support_tickets`

## Design Before SQL

Decide:

1. Is the output grain one row per order or one row per ticket?
2. Which key enforces that grain?
3. Which columns belong in the public contract?
4. Which behavioral test proves the result is trustworthy?
5. Should this extend `jaffle_reliability` or become another extension project?

Then add the model, YAML contract, documentation, behavioral test, and one
analysis query.

If you create another project, register it in:

- `Taskfile.yml` and `scripts/validate_repo.sh` at the correct dependency point;
- `projects/jaffle_catalog/packages.yml` for manifest coverage;
- `docs/architecture.md` for discoverability.

## Final Verification

Run focused upstream and downstream builds, then:

```bash
scripts/validate_repo.sh
```

## Checkpoint

You are done when the model uses no protected refs, its grain is enforced, the
business question is answerable from the result, and the full validator passes.

Return to the [course path](../course_path.md) and choose a stretch idea from the
[exercise catalog](../../EXERCISES.md).
