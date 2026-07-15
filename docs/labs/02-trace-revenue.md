# Lab 2: Trace Recognized Revenue

[Labs](../labs.md) · Previous: [Get the project running](01-get-running.md) · Next: [Navigate the manifest](03-navigate-manifest.md)

## At a Glance

- **Level:** guided
- **Time:** 25–35 minutes
- **Requires:** Lab 1 complete
- **You will:** follow one business question across project boundaries.

## Question

How does an order become recognized revenue?

## Inspect

- `projects/platform/models/marts/fct_orders/fct_orders.sql`
- `projects/platform/models/marts/fct_order_items/fct_order_items.sql`
- `projects/finance/models/marts/fct_order_revenue/fct_order_revenue.sql`
- `projects/finance/models/marts/fct_order_revenue/fct_order_revenue.yml`
- `projects/finance/packages.yml`

## Follow the Graph

```bash
dbt deps --project-dir projects/finance

dbt ls --project-dir projects/finance \
  --select +fct_order_revenue \
  --resource-type model

dbt ls --project-dir projects/finance \
  --select fct_order_revenue \
  --resource-type test

dbt build --project-dir projects/finance \
  --select +fct_order_revenue
```

Answer:

1. What is the model grain?
2. Which projects provide its public inputs?
3. Which tests attach directly to the model?
4. What makes this interface safe or unsafe downstream?

## Checkpoint

You are done when you can narrate the lineage from platform orders and items to
recognized finance revenue without reading every finance model.

Continue to [Lab 3: Navigate the full manifest](03-navigate-manifest.md).
