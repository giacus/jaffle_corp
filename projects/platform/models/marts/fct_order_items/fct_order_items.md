{% docs platform__fct_order_items %}
Public item-level interface for product-mix analysis and downstream cost
estimation.

- **Grain:** one row per `order_item_id`.
- **Business rules:** carries source sales amounts and quantity, enriches each
  item with product attributes, and attaches estimated supply characteristics.
- **Caveats:** estimated supply cost is planning evidence, not an actual ledger
  cost; compare currencies before aggregating monetary fields across orders.

A useful query compares sold quantity with estimated input cost within each
supply currency:

```sql
select supply_currency, product_family, sum(quantity) as item_quantity, sum(estimated_supply_cost_minor) as estimated_supply_cost_minor
from {% raw %}{{ ref('fct_order_items') }}{% endraw %}
group by 1, 2
order by 1, estimated_supply_cost_minor desc
```
{% enddocs %}

{% docs platform__fct_order_items__order_item_key %}
Deterministic surrogate key for the order item fact at one row per item. Derived from order item identifier and order identifier.
{% enddocs %}
