# Lab 6: Review a Contract Change

[Labs](../labs.md) · Previous: [Add a behavior test](05-add-behavior-test.md) · Next: [Observe snapshot history](07-observe-snapshot-history.md)

## At a Glance

- **Level:** intermediate
- **Time:** 30–45 minutes
- **Requires:** the local environment from Lab 1
- **You will:** assess compatibility and blast radius before changing code.

## Prepare

Refresh the complete graph:

```bash
scripts/generate_manifest.sh
```

Choose one public model consumed by `jaffle_reliability`. Inspect its model YAML,
its contract, and its entries in `target/manifest.json`.

## Write the Review

Create a short local design note containing:

- one backward-compatible change;
- one breaking change;
- the exact downstream nodes affected;
- a migration plan for the breaking change;
- the focused dbt commands that would validate it.

Do not implement the breaking change. This lab is about making the decision
before making the diff.

## Checkpoint

You are done when another engineer could turn your note into a safe pull request
without rediscovering the model's consumers or contract.

Continue to [Lab 7: Observe snapshot history](07-observe-snapshot-history.md).
