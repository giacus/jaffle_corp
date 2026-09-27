{% docs finance__int_order_margin_waterfall %}
Reconciles two estimates of order margin: the platform supply-cost estimate
and the component costs implied by Supply's recipes.

- **Grain:** one row per `order_id` from the order-revenue interface.
- **Business rules:** sums item-level recipe costs by order and subtracts them
  from net revenue. `recipe_cost_variance_usd` is recipe cost minus platform
  cost; `margin_method_variance_usd` is platform margin minus recipe margin.
  Both are positive when the recipe estimate makes an order less profitable.
- **Caveats:** missing recipe rollups become zero cost, so recipe margin may
  overstate profitability when coverage is incomplete. `component_count` sums
  item-level distinct counts; it is not a count of unique components across the
  whole order. Orders retain their upstream revenue-quality status rather than
  being filtered to recognized revenue.

Native unit tests in the adjacent YAML cover multiple items per order, both
variance signs, missing item rows, and null recipe costs. After building the
upstream Finance relations, run:

```bash
dbt test --project-dir projects/finance --select test_type:unit
```

Find orders where the recipe method reduces estimated margin:

```sql
select order_id, platform_margin_usd, recipe_margin_usd, margin_method_variance_usd
from {% raw %}{{ ref('int_order_margin_waterfall') }}{% endraw %}
where margin_method_variance_usd > 0
order by margin_method_variance_usd desc, order_id
```
{% enddocs %}

{% docs finance__int_order_margin_waterfall__platform_supply_cost_usd %}
Platform supply cost for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated supply cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__recipe_expected_component_cost_usd %}
Recipe expected component cost for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__recipe_cost_variance_usd %}
Recipe cost variance for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated supply cost USD and recipe expected component cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__recipe_margin_usd %}
Recipe margin for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from net revenue USD and recipe expected component cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__platform_margin_usd %}
Platform margin for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated gross margin USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__margin_method_variance_usd %}
Margin method variance for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated gross margin USD, net revenue USD, and recipe expected component cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__component_count %}
Number of components represented by the finance fact comparing platform-estimated and recipe-derived margin.
{% enddocs %}
