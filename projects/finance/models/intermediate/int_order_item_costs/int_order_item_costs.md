{% docs finance__int_order_item_costs %}
Item-level bridge between the public platform sales interfaces and Finance cost
estimation.

- **Grain:** one row per `order_item_id`.
- **Business rules:** joins each item to its order context and applies the
  order-implied USD conversion ratio to estimated supply cost.
- **Caveats:** missing order context leaves conversion fields null, and applying
  an order-currency ratio to supply estimates is intentionally simplified for
  the fixture rather than presented as audited costing.

A useful query surfaces items whose order context did not resolve:

```sql
select count(*) as items, count(*) filter (where ordered_date_utc is null) as items_without_order_context
from {% raw %}{{ ref('int_order_item_costs') }}{% endraw %}
```
{% enddocs %}

{% docs finance__int_order_item_costs__order_currency %}
The order currency value produced for each `int_order_item_costs` row. Derived from currency.
{% enddocs %}

{% docs finance__int_order_item_costs__estimated_supply_cost_major %}
The estimated supply cost major value produced for each `int_order_item_costs` row. Derived from estimated supply cost minor.
{% enddocs %}

{% docs finance__int_order_item_costs__estimated_supply_cost_usd %}
The estimated supply cost usd value produced for each `int_order_item_costs` row. Derived from usd per order currency unit and estimated supply cost minor.
{% enddocs %}
