{% docs finance__int_order_component_cost_bridge %}
Connects each sold order item to Supply's recipe components so Finance can
compare recipe-derived cost with the platform estimate.

- **Grain:** one row per `order_item_id`, assuming the upstream order-item
  interface is unique. Quantity scales the summed component costs, not the
  number of distinct component identifiers.
- **Business rules:** joins recipe costs by `product_id`, multiplies each
  component's expected USD cost by the sold quantity, and groups back to the
  order item. The platform estimate is converted from minor to major units.
- **Caveats:** the recipe join has no order-date condition; it uses the supplied
  recipe-cost interface, not a historical cost lookup. A missing recipe leaves
  recipe cost and component families null and component count zero. The
  platform estimate is in currency major units, not explicitly FX-converted USD.

Inspect missing recipe coverage before interpreting a downstream cost variance:

```sql
select order_item_id, product_id, quantity, platform_estimated_supply_cost_major
from {% raw %}{{ ref('int_order_component_cost_bridge') }}{% endraw %}
where component_count = 0
order by order_item_id
```
{% enddocs %}

{% docs finance__int_order_component_cost_bridge__platform_estimated_supply_cost_major %}
Platform estimated supply cost for the order-item fact for component-cost variance examples, expressed in currency major units. Derived from estimated supply cost minor.
{% enddocs %}

{% docs finance__int_order_component_cost_bridge__recipe_expected_component_cost_usd %}
Recipe expected component cost for the order-item fact for component-cost variance examples, expressed in US dollars. Aggregated from expected component cost USD and quantity.
{% enddocs %}

{% docs finance__int_order_component_cost_bridge__component_count %}
Number of components represented by the order-item fact for component-cost variance examples. Aggregated from component identifier.
{% enddocs %}

{% docs finance__int_order_component_cost_bridge__component_families %}
Component families represented by the order-item fact for component-cost variance examples. Aggregated from component family.
{% enddocs %}
