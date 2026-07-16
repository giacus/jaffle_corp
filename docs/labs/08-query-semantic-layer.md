# Lab 8: Query the Semantic Layer

[Labs](../labs.md) · Previous: [Observe snapshot history](07-observe-snapshot-history.md) · Next: [Refactor a legacy interface](09-refactor-legacy-interface.md)

## At a Glance

- **Level:** intermediate
- **Time:** 30–45 minutes
- **Requires:** Lab 1 complete
- **You will:** trace a metric from a mart into a MetricFlow result.

## Build the Required Domain

```bash
dbt deps --project-dir projects/supply
dbt seed --project-dir projects/supply
dbt deps --project-dir projects/finance
dbt build --project-dir projects/finance --exclude resource_type:seed
```

## Trace Before Querying

Inspect in this order:

1. `projects/finance/models/marts/fct_order_revenue`
2. `projects/finance/models/semantic_models.yml`
3. `projects/finance/models/metrics.yml`
4. [MetricFlow guide](../metricflow.md)

Find the measure and semantic model behind `net_revenue_usd`.

## Query

```bash
cd projects/finance
mf validate-configs --skip-dw
mf list metrics
mf query \
  --metrics net_revenue_usd,estimated_gross_margin_usd,refund_rate \
  --group-by metric_time,location,order__country_code \
  --limit 20
cd ../..
```

## Expected Observations

- MetricFlow resolves the requested metrics from measures declared on the
  order-revenue semantic model.
- Entity and dimension names form the query interface; they are not necessarily
  identical to physical column names.
- The grouped result changes grain from one row per order to the requested time,
  location, and order-country combination.
- Ratio metrics require more than summing a precomputed row-level percentage.

## Common Failure Modes

Run MetricFlow from `projects/finance`, where its dbt project context is
available. If validation succeeds but the query cannot find relations, rebuild
the required Supply and Finance domains in the same DuckDB profile. Treat an
unknown group-by as a semantic configuration problem, not a warehouse problem.

## Workspace State and Cleanup

This lab materializes domain relations and creates generated MetricFlow/dbt
artifacts only. Return to the repository root after querying. Keep the data for
the remaining labs, or remove it with `scripts/clean.sh` when the session ends.

## Completion Rubric

- [ ] Semantic configuration validation and the representative query both pass.
- [ ] You can trace each requested metric to its measure and physical model.
- [ ] You can explain why the output grain differs from the model grain.
- [ ] You can identify which names belong to dbt models, semantic entities,
      dimensions, measures, and metrics.

Continue to [Lab 9: Refactor a legacy interface](09-refactor-legacy-interface.md).
