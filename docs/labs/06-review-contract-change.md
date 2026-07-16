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

## Expected Observations

- A public model's YAML contract describes relation shape, while the manifest
  shows consumers that may rely on more than that declared shape.
- A change can compile locally yet still require downstream migration.
- Focused validation commands should cover both the changed interface and known
  consumers rather than rebuilding unrelated domains.

## Common Failure Modes

Do not count tests, macros, or exposures as executable downstream models when
describing the migration blast radius; classify them separately. If the graph
looks incomplete, regenerate the manifest before writing the review.

## Workspace State and Cleanup

Write the design note outside the repository unless you intend it to become a
tracked proposal. This lab should not change model code or DuckDB data. The
manifest is generated state and can be removed later with
`scripts/clean.sh`.

## Completion Rubric

- [ ] The note names one compatible and one breaking change precisely.
- [ ] Downstream models, tests, and exposures are identified and classified.
- [ ] The breaking change has an ordered migration path and rollback boundary.
- [ ] Another engineer could execute the proposed focused checks without
      rediscovering the graph.

Continue to [Lab 7: Observe snapshot history](07-observe-snapshot-history.md).
