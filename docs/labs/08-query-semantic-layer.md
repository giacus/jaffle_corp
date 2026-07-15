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

## Checkpoint

You are done when you can connect model grain, measure, metric, dimensions, and
query output without treating MetricFlow as a black box.

Continue to [Lab 9: Refactor a legacy interface](09-refactor-legacy-interface.md).
