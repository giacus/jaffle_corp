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
- `projects/finance/models/intermediate/int_order_payment_allocations/int_order_payment_allocations.sql`
- `projects/finance/models/intermediate/int_order_item_costs/int_order_item_costs.sql`
- `projects/finance/models/intermediate/int_order_cost_rollup/int_order_cost_rollup.sql`
- `projects/finance/models/marts/fct_order_revenue/fct_order_revenue.sql`
- `projects/finance/models/marts/fct_order_revenue/fct_order_revenue.yml`
- `projects/finance/packages.yml`

The intermediate models matter: the final mart is deliberately thin, while the
package-qualified cross-project references and finance policy live upstream.

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

## Expected Observations

- The two immediate parents of the revenue mart separate payment recognition
  from item-cost aggregation.
- Cross-project references target public platform interfaces rather than
  protected implementation models.
- The selected graph is larger than the final SQL file suggests because dbt
  resolves package dependencies as part of lineage.
- The YAML contract and attached tests answer different trust questions.

## Common Failure Modes

If package-qualified refs cannot be resolved, run `dbt deps` from the Finance
project before inspecting or building its graph. A missing raw relation means
the shared seeds have not yet been loaded into the same local DuckDB database;
return to Lab 1, or run `dbt seed --project-dir projects/finance` before the
focused Finance build.

## Workspace State and Cleanup

This lab changes generated package, target, log, and DuckDB state only. Keep that
state for later labs. Use `scripts/clean.sh --keep-venv` only for an intentional
restart followed by Lab 1, or `scripts/clean.sh` for a complete end-of-session
teardown.

## Completion Rubric

- [ ] The focused Finance build passes.
- [ ] You can draw the path from public platform orders and items through the
      relevant Finance intermediates to `fct_order_revenue`.
- [ ] You can state the final grain and identify the tests enforcing it.
- [ ] You can explain which calculations are recognition policy and which are
      carried through from upstream contracts.

Continue to [Lab 3: Navigate the full manifest](03-navigate-manifest.md).
